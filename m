From: akpm@linux-foundation.org
Subject: + checkpatch-emit-an-error-on-formats-with-0x%decimal.patch added to -mm tree
Date: Mon, 03 Aug 2015 14:16:53 -0700
Message-ID: <55bfda45.oeWUfUBrtMYOyDui%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42585 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444AbbHCVQx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Aug 2015 17:16:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: emit an error on formats with 0x%<decimal>
has been added to the -mm tree.  Its filename is
     checkpatch-emit-an-error-on-formats-with-0x%decimal.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-emit-an-error-on-formats-with-0x%25decimal.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-emit-an-error-on-formats-with-0x%25decimal.patch

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
Subject: checkpatch: emit an error on formats with 0x%<decimal>

Using 0x%d is wrong.  Emit a message when it happens.

Miscellanea:

Improve the %Lu warning to match formats like %16Lu.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-emit-an-error-on-formats-with-0x%decimal scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-emit-an-error-on-formats-with-0x%decimal
+++ a/scripts/checkpatch.pl
@@ -4816,16 +4816,20 @@ sub process {
 			     "Consecutive strings are generally better as a single string\n" . $herecurr);
 		}
 
-# check for %L{u,d,i} in strings
+# check for %L{u,d,i} and 0x%[udi] in strings
 		my $string;
 		while ($line =~ /(?:^|")([X\t]*)(?:"|$)/g) {
 			$string = substr($rawline, $-[1], $+[1] - $-[1]);
 			$string =~ s/%%/__/g;
-			if ($string =~ /(?<!%)%L[udi]/) {
+			if ($string =~ /(?<!%)%[\*\d\.\$]*L[udi]/) {
 				WARN("PRINTF_L",
 				     "\%Ld/%Lu are not-standard C, use %lld/%llu\n" . $herecurr);
 				last;
 			}
+			if ($string =~ /0x%[\*\d\.\$\Llzth]*[udi]/) {
+				ERROR("PRINTF_0xDECIMAL",
+				      "Prefixing 0x with decimal output is defective\n" . $herecurr);
+			}
 		}
 
 # check for line continuations in quoted strings with odd counts of "
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

