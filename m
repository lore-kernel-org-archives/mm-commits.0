From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-output-first-field-only-in-mailing-lists-and-after-maintainers.patch added to -mm tree
Date: Tue, 26 May 2009 14:41:45 -0700
Message-ID: <200905262141.n4QLfjkQ029542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757543AbZEZVmQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 17:42:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     scripts/get_maintainer.pl: output first field only in mailing lists and after maintainers.
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-output-first-field-only-in-mailing-lists-and-after-maintainers.patch

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
Subject: scripts/get_maintainer.pl: output first field only in mailing lists and after maintainers.
From: Joe Perches <joe@perches.com>

Fix mailing lists that are described, but not "(subscriber-only)"

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   46 +++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 19 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-output-first-field-only-in-mailing-lists-and-after-maintainers scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-output-first-field-only-in-mailing-lists-and-after-maintainers
+++ a/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.15';
+my $V = '0.16';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -169,6 +169,7 @@ foreach my $file (@ARGV) {
 }
 
 my @email_to = ();
+my @list_to = ();
 my @scm = ();
 my @web = ();
 my @subsystem = ();
@@ -182,7 +183,7 @@ foreach my $file (@files) {
 
     my $exclude = 0;
     foreach my $line (@typevalue) {
-	if ($line =~ m/^(\C):(.*)/) {
+	if ($line =~ m/^(\C):\s*(.*)/) {
 	    my $type = $1;
 	    my $value = $2;
 	    if ($type eq 'X') {
@@ -196,7 +197,7 @@ foreach my $file (@files) {
     if (!$exclude) {
 	my $tvi = 0;
 	foreach my $line (@typevalue) {
-	    if ($line =~ m/^(\C):(.*)/) {
+	    if ($line =~ m/^(\C):\s*(.*)/) {
 		my $type = $1;
 		my $value = $2;
 		if ($type eq 'F') {
@@ -229,15 +230,18 @@ if ($email_git_penguin_chiefs) {
     }
 }
 
-if ($email) {
-    my $address_cnt = @email_to;
-    if ($address_cnt == 0 && $email_list) {
-	push(@email_to, "linux-kernel\@vger.kernel.org");
+if ($email || $email_list) {
+    my @to = ();
+    if ($email) {
+	@to = (@to, @email_to);
+    }
+    if ($email_list) {
+	if (@list_to == 0) {
+	    push(@list_to, "linux-kernel\@vger.kernel.org");
+	@to = (@to, @list_to);
+	}
     }
-
-#Don't sort email address list, but do remove duplicates
-    @email_to = uniq(@email_to);
-    output(@email_to);
+    output(uniq(@to));
 }
 
 if ($scm) {
@@ -307,7 +311,7 @@ Output type options:
   --multiline => print 1 entry per line
 
 Default options:
-  [--email --git --m --l --multiline]
+  [--email --git --m --n --l --multiline]
 
 Other options:
   --version -> show version
@@ -366,26 +370,30 @@ sub add_categories {
     $index = $index - 1;
     while ($index >= 0) {
 	my $tv = $typevalue[$index];
-	if ($tv =~ m/^(\C):(.*)/) {
+	if ($tv =~ m/^(\C):\s*(.*)/) {
 	    my $ptype = $1;
 	    my $pvalue = $2;
 	    if ($ptype eq "L") {
-		my $subscr = $pvalue;
-		if ($subscr =~ m/\s*\(subscribers-only\)/) {
+		my $list_address = $pvalue;
+		my $list_additional = "";
+		if ($list_address =~ m/([^\s]+)\s+(.*)$/) {
+		    $list_address = $1;
+		    $list_additional = $2;
+		}
+		if ($list_additional =~ m/\(subscribers-only\)/) {
 		    if ($email_subscriber_list) {
-			$subscr =~ s/\s*\(subscribers-only\)//g;
-			push(@email_to, $subscr);
+			push(@list_to, $list_address);
 		    }
 		} else {
 		    if ($email_list) {
-			push(@email_to, $pvalue);
+			push(@list_to, $list_address);
 		    }
 		}
 	    } elsif ($ptype eq "M") {
 		if ($email_maintainer) {
 		    if ($index >= 0) {
 			my $tv = $typevalue[$index - 1];
-			if ($tv =~ m/^(\C):(.*)/) {
+			if ($tv =~ m/^(\C):\s*(.*)/) {
 			    if ($1 eq "P" && $email_usename) {
 				push(@email_to, format_email($2, $pvalue));
 			    } else {
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-pair-edac-e752x-p-and-m-entries.patch
linux-next.patch
scripts-get_maintainerpl-output-first-field-only-in-mailing-lists-and-after-maintainers.patch
scripts-get_maintainerpl-better-fix-for-subscriber-only-mailing-lists.patch
scripts-get_maintainerpl-improve-git-chief-penquins-linus-torvalds-filtering.patch
scripts-get_maintainerpl-warn-on-missing-git-or-git-repository.patch
scripts-get_maintainerpl-support-m-lines-with-names-and-multiple-entries-per-m-line.patch
scripts-get_maintainerpl-better-email-name-quoting.patch
scripts-get_maintainerpl-support-both-p-m-and-integrated-m-lines.patch
scripts-get_maintainerpl-dont-print-maintainers-when-not-requested.patch
scripts-get_maintainerpl-allow-8-bit-characters-in-email-addresses.patch
scripts-get_maintainerpl-change-die-to-warn-when-command-line-file-is-not-a-patch.patch
maintainers-swap-mismarked-ecrypt-fs-m-and-p-entries.patch
maintainers-add-file-patterns-to-the-rest.patch
maintainers-update-m32r-file-patterns-after-rename.patch
maintainers-mark-alsa-lists-as-moderated.patch
maintainers-remove-l-linux-kernel-vgerkernelorg-from-all-but-the-rest.patch
maintainers-mention-scripts-get_maintainerpl-in-the-preface.patch
maintainers-add-file-pattern-to-cisco-fcoe-hba-driver.patch

