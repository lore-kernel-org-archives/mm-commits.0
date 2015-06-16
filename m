From: akpm@linux-foundation.org
Subject: +
 checkpatch-emit-an-error-when-theres-a-diff-in-a-changelog.patch added to
 -mm tree
Date: Tue, 16 Jun 2015 13:43:27 -0700
Message-ID: <55808a6f.YtQ4egl73f4Q4R7M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36428 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383AbbFPUn1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jun 2015 16:43:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: emit an error when there's a diff in a changelog
has been added to the -mm tree.  Its filename is
     checkpatch-emit-an-error-when-theres-a-diff-in-a-changelog.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-emit-an-error-when-theres-a-diff-in-a-changelog.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-emit-an-error-when-theres-a-diff-in-a-changelog.patch

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
Subject: checkpatch: emit an error when there's a diff in a changelog

People often put diff snippets in changelogs.  This causes problems when
one tries to apply a file containing both the changelog and the changelog.

Warn once when what seems to be a diff snippet in the changelog exists.

Signed-off-by: Joe Perches <joe@perches.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-emit-an-error-when-theres-a-diff-in-a-changelog scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-emit-an-error-when-theres-a-diff-in-a-changelog
+++ a/scripts/checkpatch.pl
@@ -1954,6 +1954,7 @@ sub process {
 	my $in_header_lines = $file ? 0 : 1;
 	my $in_commit_log = 0;		#Scanning lines before patch
 	my $commit_log_long_line = 0;
+	my $commit_log_has_diff = 0;
 	my $reported_maintainer_file = 0;
 	my $non_utf8_charset = 0;
 
@@ -2087,7 +2088,8 @@ sub process {
 		my $rawline = $rawlines[$linenr - 1];
 
 #extract the line range in the file after the patch is applied
-		if ($line=~/^\@\@ -\d+(?:,\d+)? \+(\d+)(,(\d+))? \@\@/) {
+		if (!$in_commit_log &&
+		    $line =~ /^\@\@ -\d+(?:,\d+)? \+(\d+)(,(\d+))? \@\@/) {
 			$is_patch = 1;
 			$first_line = $linenr + 1;
 			$realline=$1-1;
@@ -2181,6 +2183,17 @@ sub process {
 
 		$cnt_lines++ if ($realcnt != 0);
 
+# Check if the commit log has what seems like a diff which can confuse patch
+		if ($in_commit_log && !$commit_log_has_diff &&
+		    (($line =~ m@^\s+diff\b.*a/[\w/]+@ &&
+		      $line =~ m@^\s+diff\b.*a/([\w/]+)\s+b/$1\b@) ||
+		     $line =~ m@^\s*(?:\-\-\-\s+a/|\+\+\+\s+b/)@ ||
+		     $line =~ m/^\s*\@\@ \-\d+,\d+ \+\d+,\d+ \@\@/)) {
+			ERROR("DIFF_IN_COMMIT_MSG",
+			      "Avoid using diff content in the commit message - patch(1) might not work\n" . $herecurr);
+			$commit_log_has_diff = 1;
+		}
+
 # Check for incorrect file permissions
 		if ($line =~ /^new (file )?mode.*[7531]\d{0,2}$/) {
 			my $permhere = $here . "FILE: $realfile\n";
_

Patches currently in -mm which might be from joe@perches.com are

ocfs2-reduce-object-size-of-mlog-uses.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
compiler-gcch-neatening.patch
compiler-gcc-integrate-the-various-compiler-gcch-files.patch
get_maintainerpl-add-get_maintainerignore-file-capability.patch
maintainers-alsa-devel-alsa-projectorg-is-moderated-for-non-subscribers.patch
lib-string-introduce-strreplace.patch
mm-utilc-add-kstrimdup.patch
checkpatch-check-for-uncommented-waitqueue_active.patch
checkpatch-add-strict-warning-for-c99-fixed-size-typedefs-intsize_t.patch
checkpatch-make-types-found-in-a-source-file-patch-local.patch
checkpatch-use-string-consistently.patch
checkpatch-categorize-some-long-line-length-checks.patch
checkpatch-improve-output-with-multiple-command-line-files.patch
checkpatch-colorize-output-to-terminal.patch
checkpatch-add-showfile-to-allow-input-via-pipe-to-show-filenames.patch
checkpatch-remove-local-from-codespell-path.patch
checkpatch-avoid-not_unified_diff-errors-on-cover-letterpatch-files.patch
checkpatch-suggest-using-ether_addr_equal.patch
checkpatch-fix-processing-of-memset-issues.patch
checkpatch-suggest-using-eth_zero_addr-and-eth_broadcast_addr.patch
checkpatch-add-multi-line-handling-for-prefer_ether_addr_copy.patch
checkpatch-validate-module_license-content.patch
checkpatch-emit-an-error-when-theres-a-diff-in-a-changelog.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch
maintainers-update-sound-soc-intel-patterns.patch
maintainers-update-brcm-dts-pattern.patch
maintainers-update-brcm-gpio-filename-pattern.patch
maintainers-remove-unused-nbdh-pattern.patch
maintainers-move-jens-osterkamp-to-credits.patch
maintainers-bcache-kent-overstreet-has-changed-email-address.patch

