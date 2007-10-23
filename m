From: akpm@linux-foundation.org
Subject: - intel-iommu-clflush_cache_range-now-takes-size-param.patch removed from -mm tree
Date: Mon, 22 Oct 2007 23:46:44 -0700
Message-ID: <200710230646.l9N6kiEl004231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59832 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751925AbXJWGr1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 02:47:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anil.s.keshavamurthy@intel.com, a.p.zijlstra@chello.nl, ak@suse.de, arjan@infradead.org, ashok.raj@intel.com, clameter@sgi.com, davem@davemloft.net, greg@kroah.com, mingo@elte.hu, mul


The patch titled
     Intel IOMMU: clflush_cache_range now takes size param
has been removed from the -mm tree.  Its filename was
     intel-iommu-clflush_cache_range-now-takes-size-param.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Intel IOMMU: clflush_cache_range now takes size param
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>

Introduce the size param for clflush_cache_range().

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Greg KH <greg@kroah.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pageattr_64.c    |    6 +++---
 include/asm-x86/cacheflush.h |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/x86/mm/pageattr_64.c~intel-iommu-clflush_cache_range-now-takes-size-param arch/x86/mm/pageattr_64.c
--- a/arch/x86/mm/pageattr_64.c~intel-iommu-clflush_cache_range-now-takes-size-param
+++ a/arch/x86/mm/pageattr_64.c
@@ -61,10 +61,10 @@ static struct page *split_large_page(uns
 	return base;
 } 
 
-static void cache_flush_page(void *adr)
+void clflush_cache_range(void *adr, int size)
 {
 	int i;
-	for (i = 0; i < PAGE_SIZE; i += boot_cpu_data.x86_clflush_size)
+	for (i = 0; i < size; i += boot_cpu_data.x86_clflush_size)
 		clflush(adr+i);
 }
 
@@ -80,7 +80,7 @@ static void flush_kernel_map(void *arg)
 		asm volatile("wbinvd" ::: "memory");
 	else list_for_each_entry(pg, l, lru) {
 		void *adr = page_address(pg);
-		cache_flush_page(adr);
+		clflush_cache_range(adr, PAGE_SIZE);
 	}
 	__flush_tlb_all();
 }
diff -puN include/asm-x86/cacheflush.h~intel-iommu-clflush_cache_range-now-takes-size-param include/asm-x86/cacheflush.h
--- a/include/asm-x86/cacheflush.h~intel-iommu-clflush_cache_range-now-takes-size-param
+++ a/include/asm-x86/cacheflush.h
@@ -27,6 +27,7 @@
 void global_flush_tlb(void);
 int change_page_attr(struct page *page, int numpages, pgprot_t prot);
 int change_page_attr_addr(unsigned long addr, int numpages, pgprot_t prot);
+void clflush_cache_range(void *addr, int size);
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 /* internal debugging function */
_

Patches currently in -mm which might be from anil.s.keshavamurthy@intel.com are

origin.patch
