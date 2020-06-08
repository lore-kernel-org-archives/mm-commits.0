From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 34/54] c6x: use asm-generic/cacheflush.h
Date: Sun, 07 Jun 2020 21:41:55 -0700
Message-ID: <20200608044155.anFWQL1Y2%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgFHEl4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:41:56 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hch@lst.de, jacquiot.aurelien@gmail.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, msalter@redhat.com, torvalds@linux-foundation.org

From: Christoph Hellwig <hch@lst.de>
Subject: c6x: use asm-generic/cacheflush.h

C6x needs almost no cache flushing routines of its own.  Rely on
asm-generic/cacheflush.h for the defaults.

Link: http://lkml.kernel.org/r/20200515143646.3857579-11-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <jacquiot.aurelien@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/c6x/include/asm/cacheflush.h |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

--- a/arch/c6x/include/asm/cacheflush.h~c6x-use-asm-generic-cacheflushh
+++ a/arch/c6x/include/asm/cacheflush.h
@@ -17,21 +17,6 @@
 #include <asm/string.h>
 
 /*
- * virtually-indexed cache management (our cache is physically indexed)
- */
-#define flush_cache_all()			do {} while (0)
-#define flush_cache_mm(mm)			do {} while (0)
-#define flush_cache_dup_mm(mm)			do {} while (0)
-#define flush_cache_range(mm, start, end)	do {} while (0)
-#define flush_cache_page(vma, vmaddr, pfn)	do {} while (0)
-#define flush_cache_vmap(start, end)		do {} while (0)
-#define flush_cache_vunmap(start, end)		do {} while (0)
-#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
-#define flush_dcache_page(page)			do {} while (0)
-#define flush_dcache_mmap_lock(mapping)		do {} while (0)
-#define flush_dcache_mmap_unlock(mapping)	do {} while (0)
-
-/*
  * physically-indexed cache management
  */
 #define flush_icache_range(s, e)				  \
@@ -49,14 +34,12 @@ do {								  \
 			(unsigned long) page_address(page) + PAGE_SIZE)); \
 } while (0)
 
