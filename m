From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-add-sections-print-entire-matched-subsystem.patch added to -mm tree
Date: Thu, 14 Jan 2010 15:12:59 -0800
Message-ID: <201001142312.o0ENCx1R005115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755346Ab0ANXNU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jan 2010 18:13:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     scripts/get_maintainer.pl: add --sections, print entire matched subsystem
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-add-sections-print-entire-matched-subsystem.patch

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
Subject: scripts/get_maintainer.pl: add --sections, print entire matched subsystem
From: Joe Perches <joe@perches.com>

Print the complete contents of the matched subsystem in pattern match
depth order.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-add-sections-print-entire-matched-subsystem scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-add-sections-print-entire-matched-subsystem
+++ a/scripts/get_maintainer.pl
@@ -41,6 +41,7 @@ my $web = 0;
 my $subsystem = 0;
 my $status = 0;
 my $keywords = 1;
+my $sections = 0;
 my $file_emails = 0;
 my $from_filename = 0;
 my $pattern_depth = 0;
@@ -121,6 +122,7 @@ if (!GetOptions(
 		'web!' => \$web,
 		'pattern-depth=i' => \$pattern_depth,
 		'k|keywords!' => \$keywords,
+		'sections!' => \$sections,
 		'fe|file-emails!' => \$file_emails,
 		'f|file' => \$from_filename,
 		'v|version' => \$version,
@@ -152,10 +154,20 @@ if ($output_rolestats) {
     $output_roles = 1;
 }
 
-my $selections = $email + $scm + $status + $subsystem + $web;
-if ($selections == 0) {
-    usage();
-    die "$P:  Missing required option: email, scm, status, subsystem or web\n";
+if ($sections) {
+    $email = 0;
+    $email_list = 0;
+    $scm = 0;
+    $status = 0;
+    $subsystem = 0;
+    $web = 0;
+    $keywords = 0;
+} else {
+    my $selections = $email + $scm + $status + $subsystem + $web;
+    if ($selections == 0) {
+	usage();
+	die "$P:  Missing required option: email, scm, status, subsystem or web\n";
+    }
 }
 
 if ($email &&
@@ -357,6 +369,21 @@ foreach my $file (@files) {
 
     foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
 	add_categories($line);
+	    if ($sections) {
+		my $i;
+		my $start = find_starting_index($line);
+		my $end = find_ending_index($line);
+		for ($i = $start; $i < $end; $i++) {
+		    my $line = $typevalue[$i];
+		    if ($line =~ /^[FX]:/) {		##Restore file patterns
+			$line =~ s/([^\\])\.([^\*])/$1\?$2/g;
+			$line =~ s/([^\\])\.$/$1\?/g;	##Convert . back to ?
+			$line =~ s/\\\./\./g;       	##Convert \. to .
+			$line =~ s/\.\*/\*/g;       	##Convert .* to *
+		    }
+		    print("$line\n");
+		}
+	    }
     }
 
     if ($email && $email_git) {
@@ -486,6 +513,7 @@ Output type options:
 Other options:
   --pattern-depth => Number of pattern directory traversals (default: 0 (all))
   --keywords => scan patch for keywords (default: 1 (on))
+  --sections => print the entire subsystem sections with pattern matches
   --version => show version
   --help => show this help information
 
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
net-rds-remove-uses-of-nipquad-use-%pi4.patch
net-sunrpc-remove-uses-of-nipquad-use-%pi4.patch
fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-remove-uses-of-nipquad-use-%pi4.patch
drivers-firmware-iscsi_ibftc-remove-nipquad_fmt-use-%pi4.patch
drivers-staging-pohmelfs-inodec-remove-uses-of-nipquad-use-%pi4.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses-v2.patch
scripts-get_maintainerpl-add-sections-print-entire-matched-subsystem.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch

