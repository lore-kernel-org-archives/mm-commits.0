From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-fix-mailmap-handling.patch added to -mm tree
Date: Tue, 05 Oct 2010 14:09:51 -0700
Message-ID: <201010052109.o95L9pZI020204@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756399Ab0JEVJz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 17:09:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: florian@mickler.org, joe@perches.com


The patch titled
     scripts/get_maintainer.pl: fix mailmap handling
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-fix-mailmap-handling.patch

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
Subject: scripts/get_maintainer.pl: fix mailmap handling
From: Florian Mickler <florian@mickler.org>

Implement it, like it is described in git-shortlog.

Signed-off-by: Florian Mickler <florian@mickler.org>
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |  147 ++++++++++++++++++++++++++----------
 1 file changed, 109 insertions(+), 38 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-fix-mailmap-handling scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-fix-mailmap-handling
+++ a/scripts/get_maintainer.pl
@@ -295,31 +295,76 @@ while (<$maint>) {
 }
 close($maint);
 
-my %mailmap;
 
-if ($email_remove_duplicates) {
-    open(my $mailmap, '<', "${lk_path}.mailmap")
+#
+# Read mail address map
+#
+
+my $mailmap = read_mailmap();
+
+sub read_mailmap {
+    my $mailmap = {
+	names => {},
+	addresses => {}
+   };
+
+    if (!$email_remove_duplicates) {
+	return $mailmap;
+    }
+
+    open(my $mailmap_file, '<', "${lk_path}.mailmap")
 	or warn "$P: Can't open .mailmap: $!\n";
-    while (<$mailmap>) {
-	my $line = $_;
 
-	next if ($line =~ m/^\s*#/);
-	next if ($line =~ m/^\s*$/);
+    while (<$mailmap_file>) {
+	s/#.*$//; #strip comments
+	s/^\s+|\s+$//g; #trim
 
-	my ($name, $address) = parse_email($line);
-	$line = format_email($name, $address, $email_usename);
+	next if (/^\s*$/); #skip empty lines
+	#entries have one of the following formats:
+	# name1 <mail1>
+	# <mail1> <mail2>
+	# name1 <mail1> <mail2>
+	# name1 <mail1> name2 <mail2>
+	# (see man git-shortlog)
+	if (/^(.+)<(.+)>$/) {
+		my $real_name = $1;
+		my $address = $2;
 
-	next if ($line =~ m/^\s*$/);
+		$real_name =~ s/\s+$//;
+		$mailmap->{names}->{$address} = $real_name;
 
-	if (exists($mailmap{$name})) {
-	    my $obj = $mailmap{$name};
-	    push(@$obj, $address);
-	} else {
-	    my @arr = ($address);
-	    $mailmap{$name} = \@arr;
+	} elsif (/^<([^\s]+)>\s*<([^\s]+)>$/) {
+		my $real_address = $1;
+		my $wrong_address = $2;
+
+		$mailmap->{addresses}->{$wrong_address} = $real_address;
+
+	} elsif (/^(.+)<([^\s]+)>\s*<([^\s]+)>$/) {
+		my $real_name= $1;
+		my $real_address = $2;
+		my $wrong_address = $3;
+
+		$real_name =~ s/\s+$//;
+
+		$mailmap->{names}->{$wrong_address} = $real_name;
+		$mailmap->{addresses}->{$wrong_address} = $real_address;
+
+	} elsif (/^(.+)<([^\s]+)>\s*([^\s].*)<([^\s]+)>$/) {
+		my $real_name = $1;
+		my $real_address = $2;
+		my $wrong_name = $3;
+		my $wrong_address = $4;
+
+		$real_name =~ s/\s+$//;
+		$wrong_name =~ s/\s+$//;
+
+		$mailmap->{names}->{format_email($wrong_name,$wrong_address,1)} = $real_name;
+		$mailmap->{addresses}->{format_email($wrong_name,$wrong_address,1)} = $real_address;
 	}
     }
-    close($mailmap);
+    close($mailmap_file);
+
+    return $mailmap;
 }
 
 ## use the filenames on the command line or find the filenames in the patchfiles
@@ -1061,30 +1106,58 @@ sub which_conf {
     return "";
 }
 
-sub mailmap {
-    my (@lines) = @_;
-    my %hash;
+sub mailmap_email {
+	my $line = shift;
 
-    foreach my $line (@lines) {
 	my ($name, $address) = parse_email($line);
-	if (!exists($hash{$name})) {
-	    $hash{$name} = $address;
-	} elsif ($address ne $hash{$name}) {
-	    $address = $hash{$name};
-	    $line = format_email($name, $address, $email_usename);
-	}
-	if (exists($mailmap{$name})) {
-	    my $obj = $mailmap{$name};
-	    foreach my $map_address (@$obj) {
-		if (($map_address eq $address) &&
-		    ($map_address ne $hash{$name})) {
-		    $line = format_email($name, $hash{$name}, $email_usename);
+	my $email = format_email($name, $address, 1);
+	my $real_name = $name;
+	my $real_address = $address;
+
+	if (exists $mailmap->{names}->{$email} || exists $mailmap->{addresses}->{$email}) {
+		if (exists $mailmap->{names}->{$email}) {
+			$real_name = $mailmap->{names}->{$email};
+		}
+		if (exists $mailmap->{addresses}->{$email}) {
+			$real_address = $mailmap->{addresses}->{$email};
+		}
+	} else {
+		if (exists $mailmap->{names}->{$address}) {
+			$real_name = $mailmap->{names}->{$address};
+		}
+		if (exists $mailmap->{addresses}->{$address}) {
+			$real_address = $mailmap->{addresses}->{$address};
 		}
-	    }
 	}
+	return format_email($real_name, $real_address, 1);
+}
+
+sub mailmap {
+    my (@addresses) = @_;
+
+    my @ret = ();
+    foreach my $line (@addresses) {
+	push(@ret, mailmap_email($line), 1);
     }
 
-    return @lines;
+    merge_by_realname(@ret) if $email_remove_duplicates;
+
+    return @ret;
+}
+
+sub merge_by_realname {
+	my %address_map;
+	my (@emails) = @_;
+	foreach my $email (@emails) {
+		my ($name, $address) = parse_email($email);
+		if (!exists $address_map{$name}) {
+			$address_map{$name} = $address;
+		} else {
+			$address = $address_map{$name};
+			$email = format_email($name,$address,1);
+		}
+	}
+
 }
 
 sub git_execute_cmd {
@@ -1636,9 +1709,7 @@ sub vcs_assign {
 	$divisor = 1;
     }
 
-    if ($email_remove_duplicates) {
-	@lines = mailmap(@lines);
-    }
+    @lines = mailmap(@lines);
 
     return if (@lines <= 0);
 
_

Patches currently in -mm which might be from florian@mickler.org are

origin.patch
scripts-get_maintainerpl-add-interactive-mode.patch
scripts-get_maintainerpl-improve-interactive-ui.patch
scripts-get_maintainerpl-update-interactive-ui-improve-hg-runtime.patch
scripts-get_maintainerpl-use-case-insensitive-name-de-duplication.patch
scripts-get_maintainerpl-fix-mailmap-handling.patch
scripts-get_maintainerpl-correct-indentation-in-a-few-places.patch
scripts-get_maintainerpl-use-mailmap-in-name-deduplication-and-other-updates.patch
scripts-get_maintainerpl-dont-deduplicate-unnamed-addresses-ie-mailing-lists.patch

