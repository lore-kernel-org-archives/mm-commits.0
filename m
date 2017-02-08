From: akpm@linux-foundation.org
Subject: + lib-update-lz4-compressor-module-fix-fix-fix.patch added to -mm tree
Date: Wed, 08 Feb 2017 14:09:50 -0800
Message-ID: <589b972e./MKdtWgi77KTJKb3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53834 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751346AbdBHWK1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2017 17:10:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, 4sschmid@informatik.uni-hamburg.de, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-update-lz4-compressor-module-fix-fix-fix
has been added to the -mm tree.  Its filename is
     lib-update-lz4-compressor-module-fix-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-update-lz4-compressor-module-fix-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-update-lz4-compressor-module-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-update-lz4-compressor-module-fix-fix-fix

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lz4/lz4_decompress.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN lib/lz4/lz4_decompress.c~lib-update-lz4-compressor-module-fix-fix-fix lib/lz4/lz4_decompress.c
--- a/lib/lz4/lz4_decompress.c~lib-update-lz4-compressor-module-fix-fix-fix
+++ a/lib/lz4/lz4_decompress.c
@@ -475,17 +475,6 @@ int LZ4_decompress_fast_usingDict(const
 		originalSize, 0, dictStart, dictSize);
 }
 
-#ifndef STATIC
-EXPORT_SYMBOL(LZ4_decompress_safe);
-EXPORT_SYMBOL(LZ4_decompress_safe_partial);
-EXPORT_SYMBOL(LZ4_decompress_fast);
-EXPORT_SYMBOL(LZ4_setStreamDecode);
-EXPORT_SYMBOL(LZ4_decompress_safe_continue);
-EXPORT_SYMBOL(LZ4_decompress_fast_continue);
-EXPORT_SYMBOL(LZ4_decompress_safe_usingDict);
-EXPORT_SYMBOL(LZ4_decompress_fast_usingDict);
-#endif
-
 /*-******************************
  *	For backwards compatibility
  ********************************/
@@ -507,7 +496,6 @@ int lz4_decompress_unknownoutputsize(con
 	else
 		return -1;
 }
-EXPORT_SYMBOL(lz4_decompress_unknownoutputsize);
 
 int lz4_decompress(const unsigned char *src, size_t *src_len,
 	unsigned char *dest, size_t actual_dest_len) {
@@ -526,7 +514,19 @@ int lz4_decompress(const unsigned char *
 	else
 		return -1;
 }
+
+#ifndef STATIC
+EXPORT_SYMBOL(LZ4_decompress_safe);
+EXPORT_SYMBOL(LZ4_decompress_safe_partial);
+EXPORT_SYMBOL(LZ4_decompress_fast);
+EXPORT_SYMBOL(LZ4_setStreamDecode);
+EXPORT_SYMBOL(LZ4_decompress_safe_continue);
+EXPORT_SYMBOL(LZ4_decompress_fast_continue);
+EXPORT_SYMBOL(LZ4_decompress_safe_usingDict);
+EXPORT_SYMBOL(LZ4_decompress_fast_usingDict);
+EXPORT_SYMBOL(lz4_decompress_unknownoutputsize);
 EXPORT_SYMBOL(lz4_decompress);
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("LZ4 decompressor");
+#endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
scripts-spellingtxt-fix-incorrect-typo-words-fix.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-slab-rename-kmalloc-node-cache-to-kmalloc-size-fix.patch
slub-make-sysfs-directories-for-memcg-sub-caches-optional-fix.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix-fix.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes.patch
mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix.patch
mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix.patch
mm-track-active-portions-of-a-section-at-boot-fix.patch
mm-memory_hotplugc-unexport-__remove_pages.patch
z3fold-add-kref-refcounting-checkpatch-fixes.patch
mm-convert-remove_migration_pte-to-use-page_vma_mapped_walk-checkpatch-fixes.patch
mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes-fix.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
lib-update-lz4-compressor-module-fix-fix.patch
lib-update-lz4-compressor-module-fix-fix-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

