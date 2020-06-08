From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 39/54] openrisc: use asm-generic/cacheflush.h
Date: Sun, 07 Jun 2020 21:42:09 -0700
Message-ID: <20200608044209.gpke1wosn%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgFHEmL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:42:11 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hch@lst.de, jonas@southpole.se, linux-mm@kvack.org, mm-commits@vger.kernel.org, shorne@gmail.com, stefan.kristiansson@saunalahti.fi, torvalds@linux-foundation.org

From: Christoph Hellwig <hch@lst.de>
Subject: openrisc: use asm-generic/cacheflush.h

OpenRISC needs almost no cache flushing routines of its own.  Rely on
asm-generic/cacheflush.h for the defaults.

Link: http://lkml.kernel.org/r/20200515143646.3857579-16-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Stafford Horne <shorne@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/openrisc/include/asm/cacheflush.h |   31 ++++-------------------
 1 file changed, 6 insertions(+), 25 deletions(-)

--- a/arch/openrisc/include/asm/cacheflush.h~openrisc-use-asm-generic-cacheflushh
+++ a/arch/openrisc/include/asm/cacheflush.h
@@ -62,31 +62,12 @@ static inline void flush_dcache_page(str
 	clear_bit(PG_dc_clean, &page->flags);
 }
 
-/*
- * Other interfaces are not required since we do not have virtually
- * indexed or tagged caches. So we can use the default here.
- */
-#define flush_cache_all()				do { } while (0)
-#define flush_cache_mm(mm)				do { } while (0)
-#define flush_cache_dup_mm(mm)				do { } while (0)
-#define flush_cache_range(vma, start, end)		do { } while (0)
-#define flush_cache_page(vma, vmaddr, pfn)		do { } while (0)
-#define flush_dcache_mmap_lock(mapping)			do { } while (0)
-#define flush_dcache_mmap_unlock(mapping)		do { } while (0)
-#define flush_icache_range(start, end)			do { } while (0)
-#define flush_icache_page(vma, pg)			do { } while (0)
-#define flush_icache_user_range(vma, pg, adr, len)	do { } while (0)
-#define flush_cache_vmap(start, end)			do { } while (0)
-#define flush_cache_vunmap(start, end)			do { } while (0)
+#define flush_icache_user_range(vma, page, addr, len)	\
+do {							\
+	if (vma->vm_flags & VM_EXEC)			\
+		sync_icache_dcache(page);		\
+} while (0)
 
-#define copy_to_user_page(vma, page, vaddr, dst, src, len)           \
-	do {                                                         \
-		memcpy(dst, src, len);                               \
-		if (vma->vm_flags & VM_EXEC)                         \
-			sync_icache_dcache(page);                    \
-	} while (0)
