From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-emit-an-error-when-theres-a-diff-in-a-changelog.patch removed
 from -mm tree
Date: Mon, 29 Jun 2015 13:48:59 -0700
Message-ID: <5591af3b.po/2D26dCfn3BJKI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbbF2Us7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:48:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: emit an error when there's a diff in a changelog
has been removed from the -mm tree.  Its filename was
     checkpatch-emit-an-error-when-theres-a-diff-in-a-changelog.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: emit an error when there's a diff in a changelog

People often put diff snippets in changelogs.  This causes problems
when one tries to apply a file containing both the changelog and the
diff because patch(1) tries to apply the diff which it found in the
changelog.

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

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
maintainers-update-sound-soc-intel-patterns.patch
maintainers-update-brcm-dts-pattern.patch
maintainers-update-brcm-gpio-filename-pattern.patch
maintainers-remove-unused-nbdh-pattern.patch
maintainers-move-jens-osterkamp-to-credits.patch
maintainers-bcache-kent-overstreet-has-changed-email-address.patch

