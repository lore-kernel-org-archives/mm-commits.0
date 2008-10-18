From: akpm@linux-foundation.org
Subject: - x86-amd-iommu-convert-driver-to-generic-iommu_num_pages-function.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:12:56 -0700
Message-ID: <200810182312.m9INCufG028090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751281AbYJRXNT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:13:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, muli@il.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86, AMD IOMMU: convert driver to generic iommu_num_pages function
has been removed from the -mm tree.  Its filename was
     x86-amd-iommu-convert-driver-to-generic-iommu_num_pages-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86, AMD IOMMU: convert driver to generic iommu_num_pages function
From: Joerg Roedel <joerg.roedel@amd.com>

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/amd_iommu.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN arch/x86/kernel/amd_iommu.c~x86-amd-iommu-convert-driver-to-generic-iommu_num_pages-function arch/x86/kernel/amd_iommu.c
--- a/arch/x86/kernel/amd_iommu.c~x86-amd-iommu-convert-driver-to-generic-iommu_num_pages-function
+++ a/arch/x86/kernel/amd_iommu.c
@@ -295,7 +295,7 @@ static int iommu_flush_pages(struct amd_
 		u64 address, size_t size)
 {
 	int s = 0;
-	unsigned pages = iommu_nr_pages(address, size);
+	unsigned pages = iommu_num_pages(address, size, PAGE_SIZE);
 
 	address &= PAGE_MASK;
 
@@ -679,8 +679,9 @@ static struct dma_ops_domain *dma_ops_do
 	if (iommu->exclusion_start &&
 	    iommu->exclusion_start < dma_dom->aperture_size) {
 		unsigned long startpage = iommu->exclusion_start >> PAGE_SHIFT;
-		int pages = iommu_nr_pages(iommu->exclusion_start,
-					    iommu->exclusion_length);
+		int pages = iommu_num_pages(iommu->exclusion_start,
+					    iommu->exclusion_length,
+					    PAGE_SIZE);
 		dma_ops_reserve_addresses(dma_dom, startpage, pages);
 	}
 
@@ -935,7 +936,7 @@ static dma_addr_t __map_single(struct de
 	unsigned long align_mask = 0;
 	int i;
 
-	pages = iommu_nr_pages(paddr, size);
+	pages = iommu_num_pages(paddr, size, PAGE_SIZE);
 	paddr &= PAGE_MASK;
 
 	if (align)
@@ -980,7 +981,7 @@ static void __unmap_single(struct amd_io
 	if ((dma_addr == 0) || (dma_addr + size > dma_dom->aperture_size))
 		return;
 
-	pages = iommu_nr_pages(dma_addr, size);
+	pages = iommu_num_pages(dma_addr, size, PAGE_SIZE);
 	dma_addr &= PAGE_MASK;
 	start = dma_addr;
 
_

Patches currently in -mm which might be from joerg.roedel@amd.com are

origin.patch

