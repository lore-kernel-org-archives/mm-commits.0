From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 33/54] arm64: use asm-generic/cacheflush.h
Date: Sun, 07 Jun 2020 21:41:51 -0700
Message-ID: <20200608044151.TzsKIXB78%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgFHEly (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:41:54 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, catalin.marinas@arm.com, hch@lst.de, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, will@kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: arm64: use asm-generic/cacheflush.h

ARM64 needs almost no cache flushing routines of its own.  Rely on
asm-generic/cacheflush.h for the defaults.

Link: http://lkml.kernel.org/r/20200515143646.3857579-10-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/cacheflush.h |   46 ++------------------------
 1 file changed, 5 insertions(+), 41 deletions(-)

--- a/arch/arm64/include/asm/cacheflush.h~arm64-use-asm-generic-cacheflushh
+++ a/arch/arm64/include/asm/cacheflush.h
@@ -94,20 +94,7 @@ static inline void flush_icache_range(un
 
 	kick_all_cpus_sync();
 }
-
-static inline void flush_cache_mm(struct mm_struct *mm)
-{
-}
-
-static inline void flush_cache_page(struct vm_area_struct *vma,
-				    unsigned long user_addr, unsigned long pfn)
-{
-}
-
-static inline void flush_cache_range(struct vm_area_struct *vma,
-				     unsigned long start, unsigned long end)
-{
-}
+#define flush_icache_range flush_icache_range
 
 /*
  * Cache maintenance functions used by the DMA API. No to be used directly.
@@ -123,12 +110,7 @@ extern void __dma_flush_area(const void
  */
 extern void copy_to_user_page(struct vm_area_struct *, struct page *,
 	unsigned long, void *, const void *, unsigned long);
-#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
-	do {							\
-		memcpy(dst, src, len);				\
-	} while (0)
-
-#define flush_cache_dup_mm(mm) flush_cache_mm(mm)
+#define copy_to_user_page copy_to_user_page
 
 /*
  * flush_dcache_page is used when the kernel has written to the page
@@ -154,29 +136,11 @@ static __always_inline void __flush_icac
 	dsb(ish);
 }
 
-#define flush_dcache_mmap_lock(mapping)		do { } while (0)
-#define flush_dcache_mmap_unlock(mapping)	do { } while (0)
-
-/*
- * We don't appear to need to do anything here.  In fact, if we did, we'd
- * duplicate cache flushing elsewhere performed by flush_dcache_page().
- */
-#define flush_icache_page(vma,page)	do { } while (0)
-
-/*
- * Not required on AArch64 (PIPT or VIPT non-aliasing D-cache).
- */
-static inline void flush_cache_vmap(unsigned long start, unsigned long end)
-{
-}
-
-static inline void flush_cache_vunmap(unsigned long start, unsigned long end)
-{
-}
