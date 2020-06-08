From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 48/54] m68k: implement flush_icache_user_range
Date: Sun, 07 Jun 2020 21:42:37 -0700
Message-ID: <20200608044237.riKYQbjpp%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727122AbgFHEmi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:42:38 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, geert@linux-m68k.org, hch@lst.de, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Christoph Hellwig <hch@lst.de>
Subject: m68k: implement flush_icache_user_range

Rename the current flush_icache_range to flush_icache_user_range as per
commit ae92ef8a4424 ("PATCH] flush icache in correct context") there seems
to be an assumption that it operates on user addresses.  Add a
flush_icache_range around it that for now is a no-op.

Link: http://lkml.kernel.org/r/20200515143646.3857579-25-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/cacheflush_mm.h |    2 ++
 arch/m68k/mm/cache.c                  |    7 ++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/arch/m68k/include/asm/cacheflush_mm.h~m68k-implement-flush_icache_user_range
+++ a/arch/m68k/include/asm/cacheflush_mm.h
@@ -257,6 +257,8 @@ static inline void __flush_page_to_ram(v
 extern void flush_icache_user_page(struct vm_area_struct *vma, struct page *page,
 				    unsigned long addr, int len);
 extern void flush_icache_range(unsigned long address, unsigned long endaddr);
+extern void flush_icache_user_range(unsigned long address,
+		unsigned long endaddr);
 
 static inline void copy_to_user_page(struct vm_area_struct *vma,
 				     struct page *page, unsigned long vaddr,
--- a/arch/m68k/mm/cache.c~m68k-implement-flush_icache_user_range
+++ a/arch/m68k/mm/cache.c
@@ -73,7 +73,7 @@ static unsigned long virt_to_phys_slow(u
 
 /* Push n pages at kernel virtual address and clear the icache */
 /* RZ: use cpush %bc instead of cpush %dc, cinv %ic */
-void flush_icache_range(unsigned long address, unsigned long endaddr)
+void flush_icache_user_range(unsigned long address, unsigned long endaddr)
 {
 	if (CPU_IS_COLDFIRE) {
 		unsigned long start, end;
@@ -104,6 +104,11 @@ void flush_icache_range(unsigned long ad
 			      : "di" (FLUSH_I));
 	}
 }
+
+void flush_icache_range(unsigned long address, unsigned long endaddr)
+{
+	flush_icache_user_range(address, endaddr);
+}
 EXPORT_SYMBOL(flush_icache_range);
 
 void flush_icache_user_page(struct vm_area_struct *vma, struct page *page,
_
