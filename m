From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-add-remove-duplicates.patch added to -mm tree
Date: Thu, 13 Aug 2009 14:49:19 -0700
Message-ID: <200908132149.n7DLnKgm013131@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753412AbZHMV7s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Aug 2009 17:59:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, adobriyan@gmail.com, alan@linux.intel.com, alan@lxorguk.ukuu.org.uk, alan@redhat.com, gregkh@suse.de, vapier@gentoo.org


The patch titled
     scripts/get_maintainer.pl: add --remove-duplicates
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-add-remove-duplicates.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/get_maintainer.pl: add --remove-duplicates
From: Joe Perches <joe@perches.com>

Allow control over the elimination of duplicate email names and addresses

--remove-duplicates will use the first email name or address presented
--noremove-duplicates will emit all names and addresses

--remove-duplicates is enabled by default

For instance:

$ ./scripts/get_maintainer.pl -f drivers/char/tty_ioctl.c
Greg Kroah-Hartman <gregkh@suse.de>
Alan Cox <alan@linux.intel.com>
Mike Frysinger <vapier@gentoo.org>
Alexey Dobriyan <adobriyan@gmail.com>
linux-kernel@vger.kernel.org

$ ./scripts/get_maintainer.pl -f --noremove-duplicates drivers/char/tty_ioctl.c
Greg Kroah-Hartman <gregkh@suse.de>
Alan Cox <alan@redhat.com>
Alan Cox <alan@linux.intel.com>
Alan Cox <alan@lxorguk.ukuu.org.uk>
Mike Frysinger <vapier@gentoo.org>
Alexey Dobriyan <adobriyan@gmail.com>
linux-kernel@vger.kernel.org

Using --remove-duplicates could eliminate multiple maintainers that
share the same name but not the same email address.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |  108 ++++++++++++++++++------------------
 1 file changed, 55 insertions(+), 53 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-add-remove-duplicates scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-add-remove-duplicates
+++ a/scripts/get_maintainer.pl
@@ -30,6 +30,7 @@ my $email_git_max_maintainers = 5;
 my $email_git_min_percent = 5;
 my $email_git_since = "1-year-ago";
 my $email_git_blame = 0;
+my $email_remove_duplicates = 1;
 my $output_multiline = 1;
 my $output_separator = ", ";
 my $scm = 0;
@@ -71,6 +72,7 @@ if (!GetOptions(
 		'git-min-percent=i' => \$email_git_min_percent,
 		'git-since=s' => \$email_git_since,
 		'git-blame!' => \$email_git_blame,
+		'remove-duplicates!' => \$email_remove_duplicates,
 		'm!' => \$email_maintainer,
 		'n!' => \$email_usename,
 		'l!' => \$email_list,
@@ -158,32 +160,28 @@ close(MAINT);
 
 my %mailmap;
 
-open(MAILMAP, "<${lk_path}.mailmap") || warn "$P: Can't open .mailmap\n";
-while (<MAILMAP>) {
-    my $line = $_;
+if ($email_remove_duplicates) {
+    open(MAILMAP, "<${lk_path}.mailmap") || warn "$P: Can't open .mailmap\n";
+    while (<MAILMAP>) {
+	my $line = $_;
 
-    next if ($line =~ m/^\s*#/);
-    next if ($line =~ m/^\s*$/);
+	next if ($line =~ m/^\s*#/);
+	next if ($line =~ m/^\s*$/);
 
-    my ($name, $address) = parse_email($line);
-    $line = format_email($name, $address);
+	my ($name, $address) = parse_email($line);
+	$line = format_email($name, $address);
 
-    next if ($line =~ m/^\s*$/);
+	next if ($line =~ m/^\s*$/);
 
-    if (exists($mailmap{$name})) {
-	my $obj = $mailmap{$name};
-	push(@$obj, $address);
-    } else {
-	my @arr = ($address);
-	$mailmap{$name} = \@arr;
-    }
-}
-close(MAILMAP);
-
-foreach my $name (sort {$mailmap{$a} <=> $mailmap{$b}} keys %mailmap) {
-    my $obj = $mailmap{$name};
-    foreach my $address (@$obj) {
+	if (exists($mailmap{$name})) {
+	    my $obj = $mailmap{$name};
+	    push(@$obj, $address);
+	} else {
+	    my @arr = ($address);
+	    $mailmap{$name} = \@arr;
+	}
     }
+    close(MAILMAP);
 }
 
 ## use the filenames on the command line or find the filenames in the patchfiles
@@ -373,6 +371,7 @@ MAINTAINER field selection options:
     --n => include name 'Full Name <addr\@domain.tld>'
     --l => include list(s) if any
     --s => include subscriber only list(s) if any
+    --remove-duplicates => minimize duplicate email names/addresses
   --scm => print SCM tree(s) if any
   --status => print status if any
   --subsystem => print subsystem name if any
@@ -389,7 +388,7 @@ Other options:
   --help => show this help information
 
 Default options:
-  [--email --git --m --n --l --multiline --pattern-depth=0]
+  [--email --git --m --n --l --multiline --pattern-depth=0 --remove-duplicates]
 
 Notes:
   Using "-f directory" may give unexpected results:
@@ -438,12 +437,12 @@ sub parse_email {
     my $name = "";
     my $address = "";
 
-    if ($formatted_email =~ /^([^<]+)<(.*\@.*)>.*$/) {
+    if ($formatted_email =~ /^([^<]+)<(.+\@.*)>.*$/) {
 	$name = $1;
 	$address = $2;
-    } elsif ($formatted_email =~ /^\s*<(.*\@.*)>.*$/) {
+    } elsif ($formatted_email =~ /^\s*<(.+\@\S*)>.*$/) {
 	$address = $1;
-    } elsif ($formatted_email =~ /^\s*(.*\@.*)$/) {
+    } elsif ($formatted_email =~ /^(.+\@\S*)$/) {
 	$address = $1;
     }
 
@@ -542,14 +541,16 @@ sub add_categories {
     }
 }
 
-sub email_address_inuse {
-    my ($test_address) = @_;
+my %email_hash_name;
+my %email_hash_address;
 
-    foreach my $line (@email_to) {
-	my ($name, $address) = parse_email($line);
+sub email_inuse {
+    my ($name, $address) = @_;
+
+    return 1 if (($name eq "") && ($address eq ""));
+    return 1 if (($name ne "") && exists($email_hash_name{$name}));
+    return 1 if (($address ne "") && exists($email_hash_address{$address}));
 
-	return 1 if ($address eq $test_address);
-    }
     return 0;
 }
 
@@ -558,8 +559,12 @@ sub push_email_address {
 
     my ($name, $address) = parse_email($line);
 
-    if (!email_address_inuse($address)) {
+    if (!$email_remove_duplicates) {
+	push(@email_to, format_email($name, $address));
+    } elsif (!email_inuse($name, $address)) {
 	push(@email_to, format_email($name, $address));
+	$email_hash_name{$name}++;
+	$email_hash_address{$address}++;
     }
 }
 
@@ -600,6 +605,9 @@ sub mailmap {
 	my ($name, $address) = parse_email($line);
 	if (!exists($hash{$name})) {
 	    $hash{$name} = $address;
+	} elsif ($address ne $hash{$name}) {
+	    $address = $hash{$name};
+	    $line = format_email($name, $address);
 	}
 	if (exists($mailmap{$name})) {
 	    my $obj = $mailmap{$name};
@@ -652,31 +660,23 @@ sub recent_git_signoffs {
 
     $total_sign_offs = @lines;
 
-    @lines = mailmap(@lines);
+    if ($email_remove_duplicates) {
+	@lines = mailmap(@lines);
+    }
 
     @lines = sort(@lines);
+
     # uniq -c
-    foreach my $line (@lines) {
-	$hash{$line}++;
-    }
+    $hash{$_}++ for @lines;
+
     # sort -rn
-    @lines = ();
     foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
-	push(@lines,"$hash{$line}	$line");
-    }
-
-    foreach my $line (@lines) {
-	if ($line =~ m/([0-9]+)\s+(.*)/) {
-	    my $sign_offs = $1;
-	    $line = $2;
-	    $count++;
-	    if ($sign_offs < $email_git_min_signatures ||
-	        $count > $email_git_max_maintainers ||
-		$sign_offs * 100 / $total_sign_offs < $email_git_min_percent) {
-		last;
-	    }
-	    push_email_address($line);
-	}
+	my $sign_offs = $hash{$line};
+	$count++;
+	last if ($sign_offs < $email_git_min_signatures ||
+		 $count > $email_git_max_maintainers ||
+		 $sign_offs * 100 / $total_sign_offs < $email_git_min_percent);
+	push_email_address($line);
     }
 }
 
@@ -743,7 +743,9 @@ sub git_assign_blame {
 
 	$total_sign_offs += @lines;
 
-	@lines = mailmap(@lines);
+	if ($email_remove_duplicates) {
+	    @lines = mailmap(@lines);
+	}
 
 	$hash{$_}++ for @lines;
     }
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-osd-library-and-filesystem-pattern-fix.patch
linux-next.patch
maintainers-add-ipvs-include-files.patch
scripts-get_maintainerpl-add-git-blame.patch
scripts-get_maintainerpl-add-sections-in-pattern-match-depth-order.patch
scripts-get_maintainerpl-add-pattern-depth.patch
scripts-get_maintainerpl-better-email-routines-use-perl-not-shell-where-possible.patch
scripts-get_maintainerpl-add-mailmap-use-shell-and-email-cleanups.patch
scripts-get_maintainerpl-using-separator-implies-nomultiline.patch
scripts-get_maintainerpl-add-remove-duplicates.patch
mmc-msm_sdccc-driver-for-htc-dream.patch
msm_sdccc-convert-printkkern_level-to-pr_level.patch
msm_sdccc-stylistic-cleaning.patch
msm_sdccc-move-overly-indented-code-to-separate-function.patch
maintainers-add-matt-mackall-and-herbert-xu-to-hardware-random-number-generator.patch

