From: akpm@linux-foundation.org
Subject: +
 checkpatch-add-showfile-to-allow-input-via-pipe-to-show-filenames.patch
 added to -mm tree
Date: Thu, 04 Jun 2015 14:57:03 -0700
Message-ID: <5570c9af.6ei0sX9G1NQsRrCz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43455 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbbFDV5E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Jun 2015 17:57:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, pmladek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add --showfile to allow input via pipe to show filenames
has been added to the -mm tree.  Its filename is
     checkpatch-add-showfile-to-allow-input-via-pipe-to-show-filenames.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-showfile-to-allow-input-via-pipe-to-show-filenames.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-showfile-to-allow-input-via-pipe-to-show-filenames.patch

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
Subject: checkpatch: add --showfile to allow input via pipe to show filenames

Using "git diff | ./scripts/checkpatch -" does not have an
easy mechanism to see the files and lines actually modified.

Add --showfile to see the file and line specified in the diff.

When --showfile is used without --terse, the second line of each
message output is redundant, so it is removed.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-showfile-to-allow-input-via-pipe-to-show-filenames scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-showfile-to-allow-input-via-pipe-to-show-filenames
+++ a/scripts/checkpatch.pl
@@ -25,6 +25,7 @@ my $chk_patch = 1;
 my $tst_only;
 my $emacs = 0;
 my $terse = 0;
+my $showfile = 0;
 my $file = 0;
 my $check = 0;
 my $check_orig = 0;
@@ -66,6 +67,7 @@ Options:
   --patch                    treat FILE as patchfile (default)
   --emacs                    emacs compile window format
   --terse                    one line per report
+  --showfile                 emit diffed file position, not input file position
   -f, --file                 treat FILE as regular source file
   --subjective, --strict     enable more subjective tests
   --types TYPE(,TYPE2...)    show only these comma separated message types
@@ -137,6 +139,7 @@ GetOptions(
 	'patch!'	=> \$chk_patch,
 	'emacs!'	=> \$emacs,
 	'terse!'	=> \$terse,
+	'showfile!'	=> \$showfile,
 	'f|file!'	=> \$file,
 	'subjective!'	=> \$check,
 	'strict!'	=> \$check,
@@ -1693,6 +1696,12 @@ sub report {
 	}
 	$output .= RESET if (-t STDOUT && $color);
 	$output .= ' ' . $msg . "\n";
+
+	if ($showfile) {
+		my @lines = split("\n", $output, -1);
+		splice(@lines, 1, 1);
+		$output = join("\n", @lines);
+	}
 	$output = (split('\n', $output))[0] . "\n" if ($terse);
 
 	push(our @report, $output);
@@ -2119,10 +2128,6 @@ sub process {
 
 		my $hunk_line = ($realcnt != 0);
 
-#make up the handle for any error we report on this line
-		$prefix = "$filename:$realline: " if ($emacs && $file);
-		$prefix = "$filename:$linenr: " if ($emacs && !$file);
-
 		$here = "#$linenr: " if (!$file);
 		$here = "#$realline: " if ($file);
 
@@ -2152,6 +2157,13 @@ sub process {
 			$found_file = 1;
 		}
 
+#make up the handle for any error we report on this line
+		if ($showfile) {
+			$prefix = "$realfile:$realline: "
+		} elsif ($emacs) {
+			$prefix = "$filename:$linenr: ";
+		}
+
 		if ($found_file) {
 			if ($realfile =~ m@^(drivers/net/|net/)@) {
 				$check = 1;
@@ -5606,7 +5618,7 @@ sub process {
 		ERROR("NOT_UNIFIED_DIFF",
 		      "Does not appear to be a unified-diff format patch\n");
 	}
-	if ($is_patch && $chk_signoff && $signoff == 0) {
+	if ($is_patch && $filename ne '-' && $chk_signoff && $signoff == 0) {
 		ERROR("MISSING_SIGN_OFF",
 		      "Missing Signed-off-by: line(s)\n");
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

