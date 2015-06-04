From: akpm@linux-foundation.org
Subject: +
 checkpatch-improve-output-with-multiple-command-line-files.patch added to
 -mm tree
Date: Thu, 04 Jun 2015 14:56:59 -0700
Message-ID: <5570c9ab.lN1RUqnNlWQHqblo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbbFDV5A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Jun 2015 17:57:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, pmladek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve output with multiple command-line files
has been added to the -mm tree.  Its filename is
     checkpatch-improve-output-with-multiple-command-line-files.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-output-with-multiple-command-line-files.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-output-with-multiple-command-line-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
-
 	return $clean;
 }
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-fix-global_initialisers-test.patch
ocfs2-reduce-object-size-of-mlog-uses.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
compiler-gcch-neatening.patch
compiler-gcc-integrate-the-various-compiler-gcch-files.patch
get_maintainerpl-add-get_maintainerignore-file-capability.patch
mm-utilc-add-kstrimdup.patch
checkpatch-check-for-uncommented-waitqueue_active.patch
checkpatch-add-strict-warning-for-c99-fixed-size-typedefs-intsize_t.patch
checkpatch-make-types-found-in-a-source-file-patch-local.patch
checkpatch-use-string-consistently.patch
checkpatch-categorize-some-long-line-length-checks.patch
checkpatch-improve-output-with-multiple-command-line-files.patch
checkpatch-colorize-output-to-terminal.patch
checkpatch-add-showfile-to-allow-input-via-pipe-to-show-filenames.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch
maintainers-update-sound-soc-intel-patterns.patch
maintainers-update-brcm-dts-pattern.patch
maintainers-update-brcm-gpio-filename-pattern.patch
maintainers-remove-unused-nbdh-pattern.patch
maintainers-move-jens-osterkamp-to-credits.patch
maintainers-bcache-kent-overstreet-has-changed-email-address.patch

