From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-improve-output-with-multiple-command-line-files.patch removed
 from -mm tree
Date: Mon, 29 Jun 2015 13:48:39 -0700
Message-ID: <5591af27.m2+s9XcLSemWShJY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50748 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbbF2Usj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:48:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, pmladek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve output with multiple command-line files
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-output-with-multiple-command-line-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve output with multiple command-line files

If there are multiple patches/files on the command line,
use a prefix before the patch/file message output like:
        --------------
        patch/filename
        --------------
to make the identifying which messages go with which
file/patch a bit easier to parse.

Move the perl version and false positive messages after
all the files have been scanned so that they are emitted
only once.

Standardize the NOTE: <...> form to always emit a blank
line before the NOTE and always use print << "EOM" style.

Signed-off-by: Joe Perches <joe@perches.com>
Suggested-by: Petr Mladek <pmladek@suse.cz>
Tested-by: Petr Mladek <pmladek@suse.cz>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   62 +++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 23 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-output-with-multiple-command-line-files scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-output-with-multiple-command-line-files
+++ a/scripts/checkpatch.pl
@@ -197,11 +197,11 @@ sub hash_show_words {
 	my ($hashRef, $prefix) = @_;
 
 	if ($quiet == 0 && keys %$hashRef) {
-		print "NOTE: $prefix message types:";
+		print "\nNOTE: $prefix message types:";
 		foreach my $word (sort keys %$hashRef) {
 			print " $word";
 		}
-		print "\n\n";
+		print "\n";
 	}
 }
 
@@ -741,6 +741,13 @@ for my $filename (@ARGV) {
 		push(@rawlines, $_);
 	}
 	close($FILE);
+
+	if ($#ARGV > 0 && $quiet == 0) {
+		print '-' x length($vname) . "\n";
+		print "$vname\n";
+		print '-' x length($vname) . "\n";
+	}
+
 	if (!process($filename)) {
 		$exit = 1;
 	}
@@ -755,6 +762,23 @@ for my $filename (@ARGV) {
 	build_types();
 }
 
+if (!$quiet) {
+	if ($^V lt 5.10.0) {
+		print << "EOM"
+
+NOTE: perl $^V is not modern enough to detect all possible issues.
+      An upgrade to at least perl v5.10.0 is suggested.
+EOM
+	}
+	if ($exit) {
+		print << "EOM"
+
+NOTE: If any of the errors are false positives, please report
+      them to the maintainer, see CHECKPATCH in MAINTAINERS.
+EOM
+	}
+}
+
 exit($exit);
 
 sub top_of_kernel_tree {
@@ -5578,22 +5602,18 @@ sub process {
 		print "total: $cnt_error errors, $cnt_warn warnings, " .
 			(($check)? "$cnt_chk checks, " : "") .
 			"$cnt_lines lines checked\n";
-		print "\n" if ($quiet == 0);
 	}
 
 	if ($quiet == 0) {
-
-		if ($^V lt 5.10.0) {
-			print("NOTE: perl $^V is not modern enough to detect all possible issues.\n");
-			print("An upgrade to at least perl v5.10.0 is suggested.\n\n");
-		}
-
 		# If there were whitespace errors which cleanpatch can fix
 		# then suggest that.
 		if ($rpt_cleaners) {
-			print "NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or\n";
-			print "      scripts/cleanfile\n\n";
 			$rpt_cleaners = 0;
+			print << "EOM"
+
+NOTE: Whitespace errors detected.
+      You may wish to use scripts/cleanpatch or scripts/cleanfile
+EOM
 		}
 	}
 
@@ -5627,6 +5647,7 @@ sub process {
 
 		if (!$quiet) {
 			print << "EOM";
+
 Wrote EXPERIMENTAL --fix correction(s) to '$newfile'
 
 Do _NOT_ trust the results written to this file.
@@ -5634,22 +5655,17 @@ Do _NOT_ submit these changes without in
 
 This EXPERIMENTAL file is simply a convenience to help rewrite patches.
 No warranties, expressed or implied...
-
 EOM
 		}
 	}
 
-	if ($clean == 1 && $quiet == 0) {
-		print "$vname has no obvious style problems and is ready for submission.\n"
-	}
-	if ($clean == 0 && $quiet == 0) {
-		print << "EOM";
-$vname has style problems, please review.
-
-If any of these errors are false positives, please report
-them to the maintainer, see CHECKPATCH in MAINTAINERS.
-EOM
+	if ($quiet == 0) {
+		print "\n";
+		if ($clean == 1) {
+			print "$vname has no obvious style problems and is ready for submission.\n";
+		} else {
+			print "$vname has style problems, please review.\n";
+		}
 	}
