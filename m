From: akpm@linux-foundation.org
Subject: + lib-update-lz4-compressor-module-fix-fix.patch added to -mm
 tree
Date: Wed, 08 Feb 2017 13:37:52 -0800
Message-ID: <589b8fb0.WwDFdPwpa6wkXKpK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50156 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751851AbdBHVhx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2017 16:37:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, 4sschmid@informatik.uni-hamburg.de, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-update-lz4-compressor-module-fix-fix
has been added to the -mm tree.  Its filename is
     lib-update-lz4-compressor-module-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-update-lz4-compressor-module-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-update-lz4-compressor-module-fix-fix.patch

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
Subject: lib-update-lz4-compressor-module-fix-fix

simplify

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lz4/lz4_decompress.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff -puN lib/lz4/lz4_decompress.c~lib-update-lz4-compressor-module-fix-fix lib/lz4/lz4_decompress.c
--- a/lib/lz4/lz4_decompress.c~lib-update-lz4-compressor-module-fix-fix
+++ a/lib/lz4/lz4_decompress.c
@@ -40,11 +40,6 @@
 #include <linux/kernel.h>
 #include <asm/unaligned.h>
 
-#ifdef STATIC
-#undef EXPORT_SYMBOL
-#define EXPORT_SYMBOL(x)
-#endif
-
 /*-*****************************
  *	Decompression functions
  *******************************/
@@ -328,7 +323,6 @@ int LZ4_decompress_safe(const char *sour
 		maxDecompressedSize, endOnInputSize, full, 0,
 		noDict, (BYTE *)dest, NULL, 0);
 }
-EXPORT_SYMBOL(LZ4_decompress_safe);
 
 int LZ4_decompress_safe_partial(const char *source, char *dest,
 	int compressedSize, int targetOutputSize, int maxDecompressedSize)
@@ -337,7 +331,6 @@ int LZ4_decompress_safe_partial(const ch
 		maxDecompressedSize, endOnInputSize, partial,
 		targetOutputSize, noDict, (BYTE *)dest, NULL, 0);
 }
-EXPORT_SYMBOL(LZ4_decompress_safe_partial);
 
 int LZ4_decompress_fast(const char *source, char *dest, int originalSize)
 {
@@ -345,7 +338,6 @@ int LZ4_decompress_fast(const char *sour
 		endOnOutputSize, full, 0, withPrefix64k,
 		(BYTE *)(dest - 64 * KB), NULL, 64 * KB);
 }
-EXPORT_SYMBOL(LZ4_decompress_fast);
 
 int LZ4_setStreamDecode(LZ4_streamDecode_t *LZ4_streamDecode,
 	const char *dictionary, int dictSize)
@@ -358,7 +350,6 @@ int LZ4_setStreamDecode(LZ4_streamDecode
 	lz4sd->extDictSize	= 0;
 	return 1;
 }
-EXPORT_SYMBOL(LZ4_setStreamDecode);
 
 /*
  * *_continue() :
@@ -406,7 +397,6 @@ int LZ4_decompress_safe_continue(LZ4_str
 
 	return result;
 }
-EXPORT_SYMBOL(LZ4_decompress_safe_continue);
 
 int LZ4_decompress_fast_continue(LZ4_streamDecode_t *LZ4_streamDecode,
 	const char *source, char *dest, int originalSize)
@@ -441,7 +431,6 @@ int LZ4_decompress_fast_continue(LZ4_str
 
 	return result;
 }
-EXPORT_SYMBOL(LZ4_decompress_fast_continue);
 
 /*
  * Advanced decoding functions :
@@ -478,7 +467,6 @@ int LZ4_decompress_safe_usingDict(const
 	return LZ4_decompress_usingDict_generic(source, dest,
 		compressedSize, maxOutputSize, 1, dictStart, dictSize);
 }
-EXPORT_SYMBOL(LZ4_decompress_safe_usingDict);
 
 int LZ4_decompress_fast_usingDict(const char *source, char *dest,
 	int originalSize, const char *dictStart, int dictSize)
@@ -486,7 +474,17 @@ int LZ4_decompress_fast_usingDict(const
 	return LZ4_decompress_usingDict_generic(source, dest, 0,
 		originalSize, 0, dictStart, dictSize);
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
 EXPORT_SYMBOL(LZ4_decompress_fast_usingDict);
+#endif
 
 /*-******************************
  *	For backwards compatibility
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
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

