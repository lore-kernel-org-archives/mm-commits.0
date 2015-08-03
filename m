From: akpm@linux-foundation.org
Subject: + checkpatch-avoid-some-commit-message-long-line-warnings.patch
 added to -mm tree
Date: Mon, 03 Aug 2015 16:44:15 -0700
Message-ID: <55bffccf.dUWDDE6V3HIAbMWA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47165 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929AbbHCXoQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Aug 2015 19:44:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, pebolle@tiscali.nl, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: avoid some commit message long line warnings
has been added to the -mm tree.  Its filename is
     checkpatch-avoid-some-commit-message-long-line-warnings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-avoid-some-commit-message-long-line-warnings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-avoid-some-commit-message-long-line-warnings.patch

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
Subject: checkpatch: avoid some commit message long line warnings

Fixes: and Link: lines may exceed 75 chars in the commit log.

So too can stack dump and dmesg lines and lines that seem
like filenames.

And Fixes: lines don't need to have a "commit" prefix before the
commit id.

Add exceptions for these types of lines.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-avoid-some-commit-message-long-line-warnings scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-avoid-some-commit-message-long-line-warnings
+++ a/scripts/checkpatch.pl
@@ -1953,9 +1953,9 @@ sub process {
 	our $clean = 1;
 	my $signoff = 0;
 	my $is_patch = 0;
-
 	my $in_header_lines = $file ? 0 : 1;
 	my $in_commit_log = 0;		#Scanning lines before patch
+       my $commit_log_possible_stack_dump = 0;
 	my $commit_log_long_line = 0;
 	my $commit_log_has_diff = 0;
 	my $reported_maintainer_file = 0;
@@ -2314,16 +2314,40 @@ sub process {
 
 # Check for line lengths > 75 in commit log, warn once
 		if ($in_commit_log && !$commit_log_long_line &&
-		    length($line) > 75) {
+                   length($line) > 75 &&
+                   !($line =~ /^\s*[a-zA-Z0-9_\/\.]+\s+\|\s+\d+/ ||
+                                       # file delta changes
+                     $line =~ /^\s*(?:[\w\.\-]+\/)++[\w\.\-]+:/ ||
+                                       # filename then :
+                     $line =~ /^\s*(?:Fixes:|Link:)/i ||
+                                       # A Fixes: or Link: line
+                     $commit_log_possible_stack_dump)) {
 			WARN("COMMIT_LOG_LONG_LINE",
 			     "Possible unwrapped commit description (prefer a maximum 75 chars per line)\n" . $herecurr);
 			$commit_log_long_line = 1;
 		}
 
+# Check if the commit log is in a possible stack dump
+               if ($in_commit_log && !$commit_log_possible_stack_dump &&
+                   ($line =~ /^\s*(?:WARNING:|BUG:)/ ||
+                    $line =~ /^\s*\[\s*\d+\.\d{6,6}\s*\]/ ||
+                               # timestamp
+                    $line =~ /^\s*\[\<[0-9a-fA-F]{8,}\>\]/)) {
+                               # stack dump address
+                       $commit_log_possible_stack_dump = 1;
+               }
+
+# Reset possible stack dump if a blank line is found
+               if ($in_commit_log && $commit_log_possible_stack_dump &&
+                   $line =~ /^\s*$/) {
+                       $commit_log_possible_stack_dump = 0;
+               }
+
 # Check for git id commit length and improperly formed commit descriptions
 		if ($in_commit_log &&
 		    ($line =~ /\bcommit\s+[0-9a-f]{5,}\b/i ||
-		     $line =~ /\b[0-9a-f]{12,40}\b/i)) {
+                    ($line =~ /\b[0-9a-f]{12,40}\b/i &&
+                     $line !~ /\bfixes:\s*[0-9a-f]{12,40}/i))) {
 			my $init_char = "c";
 			my $orig_commit = "";
 			my $short = 1;
_

Patches currently in -mm which might be from joe@perches.com are

lindent-handle-missing-indent-gracefully.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-slab_common-allow-null-cache-pointer-in-kmem_cache_destroy.patch
mm-mempool-allow-null-pool-pointer-in-mempool_destroy.patch
mm-dmapool-allow-null-pool-pointer-in-dma_pool_destroy.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
maintainers-credits-mark-maxraid-as-orphan-move-anil-ravindranath-to-credits.patch
parse_integer-add-checkpatchpl-notice.patch
mm-utilc-add-kstrimdup.patch
checkpatch-warn-on-bare-sha-1-commit-ids-in-commit-logs.patch
checkpatch-add-warning-on-bug-bug_on-use.patch
checkpatch-improve-suspect_code_indent-test.patch
checkpatch-allow-longer-declaration-macros.patch
checkpatch-add-some-foo_destroy-functions-to-needless_if-tests.patch
checkpatch-report-the-right-line-when-using-emacs-and-file.patch
checkpatch-always-check-block-comment-styles.patch
checkpatch-make-strict-the-default-for-drivers-staging-files-and-patches.patch
checkpatch-emit-an-error-on-formats-with-0x%decimal.patch
checkpatch-avoid-some-commit-message-long-line-warnings.patch
hfs-fix-b-tree-corruption-after-insertion-at-position-0.patch
seq_file-provide-an-analogue-of-print_hex_dump.patch
crypto-qat-use-seq_hex_dump-to-dump-buffers.patch
parisc-use-seq_hex_dump-to-dump-buffers.patch
zcrypt-use-seq_hex_dump-to-dump-buffers.patch
kmemleak-use-seq_hex_dump-to-dump-buffers.patch
wil6210-use-seq_hex_dump-to-dump-buffers.patch
linux-next.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch

