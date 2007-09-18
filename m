From: akpm@linux-foundation.org
Subject: - intel-iommu-clflush_cache_range-now-takes-size-param.patch removed from -mm tree
Date: Tue, 18 Sep 2007 01:12:36 -0600
Message-ID: <200709180712.l8I7CcqG025361@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49335 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753912AbXIRHNK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Sep 2007 03:13:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anil.s.keshavamurthy@intel.com, a.p.zijlstra@chello.nl, ak@suse.de, arjan@infradead.org, ashok.raj@intel.com, clameter@sgi.com, davem@davemloft.net, greg@kroah.com, muli@il.ibm.coms


The patch titled
     Intel IOMMU: clflush_cache_range now takes size param
has been removed from the -mm tree.  Its filename was
     intel-iommu-clflush_cache_range-now-takes-size-param.patch

This patch was dropped because I dropped the clflush patches which it depends on

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/pageattr.c       |    6 +++---
 include/asm-x86_64/cacheflush.h |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/x86_64/mm/pageattr.c~intel-iommu-clflush_cache_range-now-takes-size-param arch/x86_64/mm/pageattr.c
--- a/arch/x86_64/mm/pageattr.c~intel-iommu-clflush_cache_range-now-takes-size-param
+++ a/arch/x86_64/mm/pageattr.c
@@ -75,10 +75,10 @@ struct flush_arg {
 	struct list_head l;
 };
 
-static void cache_flush_page(void *adr)
+void clflush_cache_range(void *adr, int size)
 {
 	int i;
-	for (i = 0; i < PAGE_SIZE; i += boot_cpu_data.x86_clflush_size)
+	for (i = 0; i < size; i += boot_cpu_data.x86_clflush_size)
 		clflush(adr+i);
 }
 
@@ -93,7 +93,7 @@ static void flush_kernel_map(void *arg)
 		asm volatile("wbinvd" ::: "memory");
 	else list_for_each_entry(pg, &a->l, lru) {
 		if (PageFlush(pg))
-			cache_flush_page(page_address(pg));
+			clflush_cache_range(page_address(pg), PAGE_SIZE);
 	}
 	__flush_tlb_all();
 }
diff -puN include/asm-x86_64/cacheflush.h~intel-iommu-clflush_cache_range-now-takes-size-param include/asm-x86_64/cacheflush.h
--- a/include/asm-x86_64/cacheflush.h~intel-iommu-clflush_cache_range-now-takes-size-param
+++ a/include/asm-x86_64/cacheflush.h
@@ -27,6 +27,7 @@
 void global_flush_tlb(void); 
 int change_page_attr(struct page *page, int numpages, pgprot_t prot);
 int change_page_attr_addr(unsigned long addr, int numpages, pgprot_t prot);
+void clflush_cache_range(void *addr, int size);
 
 #ifdef CONFIG_DEBUG_RODATA
 void mark_rodata_ro(void);
_

Patches currently in -mm which might be from anil.s.keshavamurthy@intel.com are

optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft.patch
kprobes-support-kretprobe-blacklist.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-gfx-workaround-kconfig-fix.patch
intel-iommu-iommu-floppy-workaround.patch
intel-iommu-iommu-floppy-workaround-kconfig-fix.patch
intel-iommu-optimize-sg-map-unmap-calls.patch
