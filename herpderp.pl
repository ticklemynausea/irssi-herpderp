#
#    License: GPL
#    herp.pl uses parts of watch.pl (http://scripts.irssi.org)
#
#    Randomly replaces text sent by people/to channels in a list with nonsense words like "herp" and "derp"
#    Why use IGNORE when you can use HERP.PL and make them look even more retarded?
#
#    /herp in irssi for usage
#
#    /herp list - lists all derped channels and nicknames
#    /herp add <nick> - adds a nickname or channel
#    /herp del <nick> - removes a nickname from the
#    /herp all - toggles herping of all names
#    Herp a derp derp feedback emailoftheyear[herp]gmail[derp]com
#

use strict;
use vars qw($VERSION %IRSSI);

use Irssi;

$VERSION = "0.5";

%IRSSI = (
    authors     => 'Mário Carneiro, Hugo Peixoto',
    contact     => 'emailoftheyear[derp]gmail[herp]com',
    name        => 'herpderp',
    description => 'Herp derp herp all messages herp of derp, client side derp.',
    license     => 'GNU General Public License',
    url         => 'https://github.com/ticklemynausea/irssi-herpderp',
    changed     => '11 July 2012 22:00:00',
);

# Herpa Derpa

my @herp_derp;
my @unherpables;
my @hd_words = ('herp', 'derp');

sub keep_caps {
    my $new = shift;
    my $old = shift;
    my @list_new = split('', $new);
    my @list_old = split('', $old);
    my $return = "";
    my $char;

    for (my $i = 0; $i < scalar(@list_new); $i++) {

        if ($i < scalar(@list_old)) {
            $char = $list_old[$i];
        } else {
            $char = $list_new[$i];
        }

        if ($char =~ /\p{isUpper}/) {
            $return .= uc($list_new[$i]);
        } else {
            $return .= $list_new[$i];
        }
    }

    return $return;
}

sub herpify_aux {
    my $word = shift;
    my $len = length($word);
    my $die = int(rand()*100);

    if ((grep lc($_) eq lc($word), @unherpables) or ($len < 4)) {
        return $word;
    }

    return $hd_words[(int rand($#hd_words + 1))];

}

sub herpify {
    my $text = shift;
    $text =~ s/(\b[\w-]+)/herpify_aux($1)/egi;
    return $text;
}

# IRSSI Crap

## List herp derp file

sub is_herpderp {
  my ($match) = "@_\n";
  my($file) = Irssi::get_irssi_dir."/herp";

  open my $fh, "<", $file;
  return grep {uc($_) eq uc($match)} <$fh>;
}

sub update_herpderp {
    my $silent = shift || "no";
    my $file  = Irssi::get_irssi_dir."/herp";
    open FILE, "< $file";
    @herp_derp = <FILE>;
    chomp(@herp_derp);

    if ($silent eq "no") {
        print "Herp Derp:";
        print " - " . join("\n - ", @herp_derp);
    }
}

sub update_unherpables {
    my $server = shift;
    my $target = shift;
    my $client_nick = $server->{nick};

    @unherpables = ();
    #push @unherpables, $client_nick;
    #if ($target =~ m/^#\w+$/i) {
    #    push @unherpables, $client_nick;
    #    # push all channel nicks into array someday maybe
    #} else {
    #    push @unherpables, $client_nick;
    #}
}

sub herp_add {
    my ($nick) = @_;
    my($file) = Irssi::get_irssi_dir."/herp";
    local(*FILE);

    if ($nick eq "") {
        Irssi::print "Herp nick herp derp list.";
        return;
    } elsif (is_herpderp($nick)) {
        Irssi::print "Herp derp twice derp nick.";
        return;
    }

    open FILE, ">> $file";
    print FILE join("\t","$nick\n");
    close FILE;

    Irssi::print "Herp a derp $nick is now in herp derp derp";
    update_herpderp("derp");
}

sub herp_del {
    my ($ni) = @_;
    my($file) = Irssi::get_irssi_dir."/herp";
    my($file2) = Irssi::get_irssi_dir."/.herp-temp";
    my(@nick);
    local(*FILE);
    local(*FILE2);
    if ($ni eq "") {
        Irssi::print "Derp herp one nick derp.";
        return;
    } elsif (!is_herpderp($ni)) {
        Irssi::print "Herp derp nick not on derp.";
        return;
    }

    open FILE2, "> $file2";
    print FILE2 "";
    close FILE2;

    open FILE, "< $file";
    open FILE2, ">> $file2";
    while (<FILE>) {
        @nick = split;
        if (uc(@nick[0]) eq uc($ni)) {
        } else {
            print FILE2 join("\t","@nick[0]\n");
        }
    }
    close FILE;
    close FILE2;

    open FILE, "> $file";
    print FILE "";
    close FILE;

    open FILE, ">> $file";
    open FILE2, "< $file2";
    while (<FILE2>) {
        @nick = split;
        print FILE join("\t","@nick[0]\n");
    }
    close FILE;
    close FILE2;

    Irssi::print "Herp \002$ni\002 is derp derp deleted.";
    update_herpderp("herp");
}

sub herp {
    my ($arg) = @_;
    my ($cmd, $nick) = split(/ /, $arg);
    if ($cmd eq "list") {
        update_herpderp("no");
    } elsif ($cmd eq "add") {
        herp_add($nick);
    } elsif ($cmd eq "del") {
        herp_del($nick);
    } elsif ($cmd eq "all") {
        my $herping = Irssi::settings_get_bool("herpderp_all");
        if ($herping eq 1) {
            Irssi::settings_set_bool("herpderp_all", 0);
            Irssi::print("All herp is now underped");
        } else {
            Irssi::settings_set_bool("herpderp_all", 1);
            Irssi::print("All derp now herped");
        }
    } else {
        Irssi::print("Usage: /herp {list|add|deil|all} [nick|#channel]");
        Irssi::print(" - /herp list -  lists all derp herp derps");
        Irssi::print(" - /herp add <nick> -  add new herp");
        Irssi::print(" - /herp del <nick> -  durr");
        Irssi::print(" - /herp all -  toggles derp on all herps received");
    }
}

## Signals

sub handle_privmsg {

    my ($server, $data, $nick, $address) = @_;
    my ($target, $msg) = split(/ :/, $data,2);

    my $herpderp_all = Irssi::settings_get_bool("herpderp_all");
    my $herpmsg;

    if ((uc($herpderp_all) eq "ON") or ((grep lc($_) eq lc($nick), @herp_derp) or (grep lc($_) eq lc($target), @herp_derp))) {
        update_unherpables($server, $target);
        $herpmsg = herpify($msg);
    } else {
        $herpmsg = $msg;
    }

    # stop this
    Irssi::signal_stop();

    # send new signal
    Irssi::signal_remove("event privmsg", "handle_privmsg");
    Irssi::signal_emit('event privmsg', ($server, "$target :$herpmsg", $nick, $address));
    Irssi::signal_add("event privmsg", "handle_privmsg");
}

sub handle_notice {

    my ($server, $data, $nick, $address) = @_;
    my ($target, $msg) = split(/ :/, $data,2);

    my $herpderp_all = Irssi::settings_get_bool("herpderp_all");
    my $herpmsg;

    if ((uc($herpderp_all) eq "ON") or ((grep lc($_) eq lc($nick), @herp_derp) or (grep lc($_) eq lc($target), @herp_derp))) {
        update_unherpables($server, $target);
        $herpmsg = herpify($msg);
    } else {
        $herpmsg = $msg;
    }

    # stop this
    Irssi::signal_stop();

    # send new signal
    Irssi::signal_remove("event notice", "handle_notice");
    Irssi::signal_emit('event notice', ($server, "$target :$herpmsg", $nick, $address));
    Irssi::signal_add("event notice", "handle_notice");
}

sub handle_action {

    my ($server, $data, $nick, $address, $target) = @_;
    my $msg = $data;

    my $herpderp_all = Irssi::settings_get_bool("herpderp_all");
    my $herpmsg;

    if ((uc($herpderp_all) eq "ON") or ((grep lc($_) eq lc($nick), @herp_derp) or (grep lc($_) eq lc($target), @herp_derp))) {
        update_unherpables($server, $target);
        $herpmsg = herpify($msg);
    } else {
        $herpmsg = $msg;
    }

    # stop this
    Irssi::signal_stop();

    # send new signal
    Irssi::signal_remove("ctcp action", "handle_action");
    Irssi::signal_emit('ctcp action', ($server, $herpmsg, $nick, $address, $target));
    Irssi::signal_add("ctcp action", "handle_action");
}

sub debugthis {
#    print join ", ", @herp_derp;
}#

sub init {
    Irssi::signal_add("event notice", "handle_notice");
    Irssi::signal_add("event privmsg", "handle_privmsg");
    Irssi::signal_add("ctcp action", "handle_action");
    Irssi::command_bind('herp', 'herp');
    #Irssi::command_bind('herbug', 'debugthis');
    Irssi::settings_add_bool("misc", "herpderp_all", "OFF");
}

init();
update_herpderp("yes please");
