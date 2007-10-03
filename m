From: akpm@linux-foundation.org
Subject: + intel-iommu-sg-chaining-support.patch added to -mm tree
Date: Wed, 03 Oct 2007 14:12:13 -0700
Message-ID: <200710032112.l93LCDKS008893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56032 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752747AbXJCVMs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2007 17:12:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomof@acm.org, anil.s.keshavamurthy@intel.com, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com


The patch titled
     intel-iommu sg chaining support
has been added to the -mm tree.  Its filename is
     intel-iommu-sg-chaining-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: intel-iommu sg chaining support
From: FUJITA Tomonori <tomof@acm.org>

x86_64 defines ARCH_HAS_SG_CHAIN. So if IOMMU implementations don't
support sg chaining, we will get data corruption.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/pci/intel-iommu.c~intel-iommu-sg-chaining-support drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~intel-iommu-sg-chaining-support
+++ a/drivers/pci/intel-iommu.c
@@ -1963,7 +1963,7 @@ static void intel_free_coherent(struct d
 }
 
 #define SG_ENT_VIRT_ADDRESS(sg)	(page_address((sg)->page) + (sg)->offset)
-static void intel_unmap_sg(struct device *hwdev, struct scatterlist *sg,
+static void intel_unmap_sg(struct device *hwdev, struct scatterlist *sglist,
 	int nelems, int dir)
 {
 	int i;
@@ -1973,16 +1973,17 @@ static void intel_unmap_sg(struct device
 	struct iova *iova;
 	size_t size = 0;
 	void *addr;
+	struct scatterlist *sg;
 
 	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
 		return;
 
 	domain = find_domain(pdev);
 
-	iova = find_iova(&domain->iovad, IOVA_PFN(sg[0].dma_address));
+	iova = find_iova(&domain->iovad, IOVA_PFN(sglist[0].dma_address));
 	if (!iova)
 		return;
-	for (i = 0; i < nelems; i++, sg++) {
+	for_each_sg(sglist, sg, nelems, i) {
 		addr = SG_ENT_VIRT_ADDRESS(sg);
 		size += aligned_size((u64)addr, sg->length);
 	}
@@ -2003,20 +2004,20 @@ static void intel_unmap_sg(struct device
 }
 
 static int intel_nontranslate_map_sg(struct device *hddev,
-	struct scatterlist *sg, int nelems, int dir)
+	struct scatterlist *sglist, int nelems, int dir)
 {
 	int i;
+	struct scatterlist *sg;
 
-	for (i = 0; i < nelems; i++) {
-		struct scatterlist *s = &sg[i];
-		BUG_ON(!s->page);
-		s->dma_address = virt_to_bus(SG_ENT_VIRT_ADDRESS(s));
-		s->dma_length = s->length;
+	for_each_sg(sglist, sg, nelems, i) {
+		BUG_ON(!sg->page);
+		sg->dma_address = virt_to_bus(SG_ENT_VIRT_ADDRESS(sg));
+		sg->dma_length = sg->length;
 	}
 	return nelems;
 }
 
-static int intel_map_sg(struct device *hwdev, struct scatterlist *sg,
+static int intel_map_sg(struct device *hwdev, struct scatterlist *sglist,
 	int nelems, int dir)
 {
 	void *addr;
@@ -2028,18 +2029,18 @@ static int intel_map_sg(struct device *h
 	size_t offset = 0;
 	struct iova *iova = NULL;
 	int ret;
-	struct scatterlist *orig_sg = sg;
+	struct scatterlist *sg;
 	unsigned long start_addr;
 
 	BUG_ON(dir == DMA_NONE);
 	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
-		return intel_nontranslate_map_sg(hwdev, sg, nelems, dir);
+		return intel_nontranslate_map_sg(hwdev, sglist, nelems, dir);
 
 	domain = get_valid_domain_for_dev(pdev);
 	if (!domain)
 		return 0;
 
-	for (i = 0; i < nelems; i++, sg++) {
+	for_each_sg(sglist, sg, nelems, i) {
 		addr = SG_ENT_VIRT_ADDRESS(sg);
 		addr = (void *)virt_to_phys(addr);
 		size += aligned_size((u64)addr, sg->length);
@@ -2047,7 +2048,7 @@ static int intel_map_sg(struct device *h
 
 	iova = __intel_alloc_iova(hwdev, domain, size);
 	if (!iova) {
-		orig_sg->dma_length = 0;
+		sglist->dma_length = 0;
 		return 0;
 	}
 
@@ -2063,8 +2064,7 @@ static int intel_map_sg(struct device *h
 
 	start_addr = iova->pfn_lo << PAGE_SHIFT_4K;
 	offset = 0;
-	sg = orig_sg;
-	for (i = 0; i < nelems; i++, sg++) {
+	for_each_sg(sglist, sg, nelems, i) {
 		addr = SG_ENT_VIRT_ADDRESS(sg);
 		addr = (void *)virt_to_phys(addr);
 		size = aligned_size((u64)addr, sg->length);
_

Patches currently in -mm which might be from tomof@acm.org are

git-scsi-misc.patch
git-block.patch
x86-64-pci-gart-iommu-sg-chaining-zeroes-wrong-sg.patch
intel-iommu-sg-chaining-support.patch
