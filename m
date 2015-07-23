From: akpm@linux-foundation.org
Subject: + checkpatch-always-check-block-comment-styles.patch added to -mm tree
Date: Thu, 23 Jul 2015 12:39:27 -0700
Message-ID: <55b142ef.vb7dQpCihOWquyym%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbbGWTj2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jul 2015 15:39:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: always check block comment styles
has been added to the -mm tree.  Its filename is
     checkpatch-always-check-block-comment-styles.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-always-check-block-comment-styles.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-always-check-block-comment-styles.patch

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
Subject: checkpatch: always check block comment styles

Some of the block comment tests that are used only for networking are
appropriate for all patches.

For example, these styles are not encouraged:

	/*
	 block comment without introductory *
	*/
and
	/*
	 * block comment with line terminating */

Remove the networking specific test and add comments.

There are some infrequent false positives where code is lazily commented
out using /* and */ rather than using #if 0/#endif blocks like: /* case
foo: case bar: */ case baz:

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-always-check-block-comment-styles scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-always-check-block-comment-styles
+++ a/scripts/checkpatch.pl
@@ -2751,6 +2751,8 @@ sub process {
 			}
 		}
 
+# Block comment styles
+# Networking with an initial /*
 		if ($realfile =~ m@^(drivers/net/|net/)@ &&
 		    $prevrawline =~ /^\+[ \t]*\/\*[ \t]*$/ &&
 		    $rawline =~ /^\+[ \t]*\*/ &&
@@ -2759,22 +2761,23 @@ sub process {
 			     "networking block comments don't use an empty /* line, use /* Comment...\n" . $hereprev);
 		}
 
-		if ($realfile =~ m@^(drivers/net/|net/)@ &&
-		    $prevrawline =~ /^\+[ \t]*\/\*/ &&		#starting /*
+# Block comments use * on subsequent lines
+		if ($prevline =~ /$;[ \t]*$/ &&			#ends in comment
+		    $prevrawline =~ /^\+.*?\/\*/ &&		#starting /*
 		    $prevrawline !~ /\*\/[ \t]*$/ &&		#no trailing */
 		    $rawline =~ /^\+/ &&			#line is new
 		    $rawline !~ /^\+[ \t]*\*/) {		#no leading *
-			WARN("NETWORKING_BLOCK_COMMENT_STYLE",
-			     "networking block comments start with * on subsequent lines\n" . $hereprev);
+			WARN("BLOCK_COMMENT_STYLE",
+			     "Block comments use * on subsequent lines\n" . $hereprev);
 		}
 
-		if ($realfile =~ m@^(drivers/net/|net/)@ &&
-		    $rawline !~ m@^\+[ \t]*\*/[ \t]*$@ &&	#trailing */
+# Block comments use */ on trailing lines
+		if ($rawline !~ m@^\+[ \t]*\*/[ \t]*$@ &&	#trailing */
 		    $rawline !~ m@^\+.*/\*.*\*/[ \t]*$@ &&	#inline /*...*/
 		    $rawline !~ m@^\+.*\*{2,}/[ \t]*$@ &&	#trailing **/
 		    $rawline =~ m@^\+[ \t]*.+\*\/[ \t]*$@) {	#non blank */
-			WARN("NETWORKING_BLOCK_COMMENT_STYLE",
-			     "networking block comments put the trailing */ on a separate line\n" . $herecurr);
+			WARN("BLOCK_COMMENT_STYLE",
+			     "Block comments use a trailing */ on a separate line\n" . $herecurr);
 		}
 
 # check for missing blank lines after struct/union declarations
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
parse_integer-add-checkpatchpl-notice.patch
mm-utilc-add-kstrimdup.patch
checkpatch-warn-on-bare-sha-1-commit-ids-in-commit-logs.patch
checkpatch-add-warning-on-bug-bug_on-use.patch
checkpatch-improve-suspect_code_indent-test.patch
checkpatch-allow-longer-declaration-macros.patch
checkpatch-add-some-foo_destroy-functions-to-needless_if-tests.patch
checkpatch-report-the-right-line-when-using-emacs-and-file.patch
checkpatch-always-check-block-comment-styles.patch
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

