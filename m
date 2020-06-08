From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 42/54] arm,sparc,unicore32: remove
 flush_icache_user_range
Date: Sun, 07 Jun 2020 21:42:19 -0700
Message-ID: <20200608044219.SvSo_kmtb%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727796AbgFHEmU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:42:20 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, gxt@pku.edu.cn, hch@lst.de, linux-mm@kvack.org, linux@armlinux.org.uk, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Christoph Hellwig <hch@lst.de>
Subject: arm,sparc,unicore32: remove flush_icache_user_range

flush_icache_user_range is only used by <asm-generic/cacheflush.h>, so
remove it from the architectures that implement it, but don't use
<asm-generic/cacheflush.h>.

Link: http://lkml.kernel.org/r/20200515143646.3857579-19-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Russell King <linux@armlinux.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/cacheflush.h       |    3 ---
 arch/sparc/include/asm/cacheflush_32.h  |    2 --
 arch/sparc/include/asm/cacheflush_64.h  |    1 -
 arch/unicore32/include/asm/cacheflush.h |    3 ---
 4 files changed, 9 deletions(-)

--- a/arch/arm/include/asm/cacheflush.h~armsparcunicore32-remove-flush_icache_user_range
+++ a/arch/arm/include/asm/cacheflush.h
@@ -318,9 +318,6 @@ extern void flush_kernel_dcache_page(str
 #define flush_dcache_mmap_lock(mapping)		xa_lock_irq(&mapping->i_pages)
 #define flush_dcache_mmap_unlock(mapping)	xa_unlock_irq(&mapping->i_pages)
 
-#define flush_icache_user_range(vma,page,addr,len) \
-	flush_dcache_page(page)
-
 /*
  * We don't appear to need to do anything here.  In fact, if we did, we'd
  * duplicate cache flushing elsewhere performed by flush_dcache_page().
--- a/arch/sparc/include/asm/cacheflush_32.h~armsparcunicore32-remove-flush_icache_user_range
+++ a/arch/sparc/include/asm/cacheflush_32.h
@@ -17,8 +17,6 @@
 #define flush_icache_range(start, end)		do { } while (0)
 #define flush_icache_page(vma, pg)		do { } while (0)
 
-#define flush_icache_user_range(vma,pg,adr,len)	do { } while (0)
-
 #define copy_to_user_page(vma, page, vaddr, dst, src, len) \
 	do {							\
 		flush_cache_page(vma, vaddr, page_to_pfn(page));\
--- a/arch/sparc/include/asm/cacheflush_64.h~armsparcunicore32-remove-flush_icache_user_range
+++ a/arch/sparc/include/asm/cacheflush_64.h
@@ -49,7 +49,6 @@ void __flush_dcache_range(unsigned long
 void flush_dcache_page(struct page *page);
 
 #define flush_icache_page(vma, pg)	do { } while(0)
-#define flush_icache_user_range(vma,pg,adr,len)	do { } while (0)
 
 void flush_ptrace_access(struct vm_area_struct *, struct page *,
 			 unsigned long uaddr, void *kaddr,
--- a/arch/unicore32/include/asm/cacheflush.h~armsparcunicore32-remove-flush_icache_user_range
+++ a/arch/unicore32/include/asm/cacheflush.h
@@ -162,9 +162,6 @@ extern void flush_dcache_page(struct pag
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
 
-#define flush_icache_user_range(vma, page, addr, len)	\
-	flush_dcache_page(page)
