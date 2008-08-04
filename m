From: akpm@linux-foundation.org
Subject: + x86-amd-iommu-convert-driver-to-generic-iommu_num_pages-function.patch added to -mm tree
Date: Mon, 04 Aug 2008 14:22:10 -0700
Message-ID: <200808042122.m74LMAFq031531@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758175AbYHDVYF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 17:24:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, muli@il.ibm.com, tglx@linutronix.de


The patch titled
     x86, AMD IOMMU: convert driver to generic iommu_num_pages function
has been added to the -mm tree.  Its filename is
     x86-amd-iommu-convert-driver-to-generic-iommu_num_pages-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -182,7 +182,7 @@ static int iommu_flush_pages(struct amd_
 		u64 address, size_t size)
 {
 	int s = 0;
-	unsigned pages = iommu_nr_pages(address, size);
+	unsigned pages = iommu_num_pages(address, size, PAGE_SIZE);
 
 	address &= PAGE_MASK;
 
@@ -554,8 +554,9 @@ static struct dma_ops_domain *dma_ops_do
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
 
@@ -764,7 +765,7 @@ static dma_addr_t __map_single(struct de
 	unsigned int pages;
 	int i;
 
-	pages = iommu_nr_pages(paddr, size);
+	pages = iommu_num_pages(paddr, size, PAGE_SIZE);
 	paddr &= PAGE_MASK;
 
 	address = dma_ops_alloc_addresses(dev, dma_dom, pages);
@@ -799,7 +800,7 @@ static void __unmap_single(struct amd_io
 	if ((dma_addr == 0) || (dma_addr + size > dma_dom->aperture_size))
 		return;
 
-	pages = iommu_nr_pages(dma_addr, size);
+	pages = iommu_num_pages(dma_addr, size, PAGE_SIZE);
 	dma_addr &= PAGE_MASK;
 	start = dma_addr;
 
_

Patches currently in -mm which might be from joerg.roedel@amd.com are

origin.patch
linux-next.patch
x86-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
sparc64-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
powerpc-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
introduce-generic-iommu_num_pages-function.patch
x86-convert-gart-driver-to-generic-iommu_num_pages-function.patch
x86-amd-iommu-convert-driver-to-generic-iommu_num_pages-function.patch
x86-convert-calgary-iommu-driver-to-generic-iommu_num_pages-function.patch
powerpc-use-iommu_num_pages-function-in-iommu-code.patch
alpha-use-iommu_num_pages-function-in-iommu-code.patch
sparc64-use-iommu_num_pages-function-in-iommu-code.patch

