From: akpm@linux-foundation.org
Subject: + swiotlb-add-support-to-disable-swiotlb-overflow-buffer-with-deprecation-warning.patch added to -mm tree
Date: Fri, 24 Aug 2012 14:56:26 -0700
Message-ID: <20120824215626.B1EA0100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:43453 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab2HXV41 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Aug 2012 17:56:27 -0400
Received: by ghbz15 with SMTP id z15so335832ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 14:56:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shuah.khan@hp.com, bhelgaas@google.com, fujita.tomonori@lab.ntt.co.jp, konrad.wilk@oracle.com, paul.gortmaker@gmail.com


The patch titled
     Subject: swiotlb: add support to disable swiotlb overflow buffer with deprecation warning
has been added to the -mm tree.  Its filename is
     swiotlb-add-support-to-disable-swiotlb-overflow-buffer-with-deprecation-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shuah Khan <shuah.khan@hp.com>
Subject: swiotlb: add support to disable swiotlb overflow buffer with deprecation warning

Add support for disabling swiotlb overflow buffer using zero size swiotlb
overflow buffer to help test disable overflow scenarios to find drivers
that don't check dma mapping errors.

Add kernel error message to track overflow buffer triggers to understand
how often overflow buffer gets used.

Add deprecation notice warning message and deprecation schedule
documentation, as a first step towards removing overflow support, to be
consistent with other iommu implementations and return DMA_ERROR_CODE. 
Once drivers are fixed overflow support can be removed.

Tested on x86-64 and compile tested on IA64.

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Paul Gortmaker <paul.gortmaker@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |   15 +++
 lib/swiotlb.c                              |   73 ++++++++++++++-----
 2 files changed, 69 insertions(+), 19 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~swiotlb-add-support-to-disable-swiotlb-overflow-buffer-with-deprecation-warning Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~swiotlb-add-support-to-disable-swiotlb-overflow-buffer-with-deprecation-warning
+++ a/Documentation/feature-removal-schedule.txt
@@ -621,3 +621,18 @@ Who:	Russell King <linux@arm.linux.org.u
 	Santosh Shilimkar <santosh.shilimkar@ti.com>
 
 ----------------------------
+
+What:  SWIOTLB overflow buffer support.
+When:  3.8
+Why:   Remove SWIOTLB overflow buffer support and return DMA_ERROR_CODE
+       (a value of zero) to make it consistent with iommu implementation
+       on Intel, AMD, and swiotlb-xen. In 3.7, add logging to track swiotlb
+       buffer overflow triggers to understand how often overflow buffer
+       gets used. The next step is to fix drivers that don't call
+       dma_mapping_error to check for errors returned by the mapping
+       interfaces. Once drivers are fixed overflow support can be removed.
+       If you see any problems related to disabling SWIOTLB overflow buffer,
+       please report to us!
+       E-mail us at: linux-kernel@vger.kernel.org
+Who:   Shuah Khan <shuah.khan@hp.com> <shuahkhan@gmail.com>
+
diff -puN lib/swiotlb.c~swiotlb-add-support-to-disable-swiotlb-overflow-buffer-with-deprecation-warning lib/swiotlb.c
--- a/lib/swiotlb.c~swiotlb-add-support-to-disable-swiotlb-overflow-buffer-with-deprecation-warning
+++ a/lib/swiotlb.c
@@ -92,6 +92,24 @@ static DEFINE_SPINLOCK(io_tlb_lock);
 
 static int late_alloc;
 
+static void swiotlb_print_overflow_deprecation_notice(void)
+{
+	if (io_tlb_overflow) {
+		pr_warn("SWIOTLB overflow buffer will be deprecated.\n"
+			"  If you have a driver that depends on this feature\n"
+			"  please Email us at: linux-kernel@vger.kernel.org,\n"
+			"  Shuah Khan (shuahkhan@gmail.com), and\n"
+			"  Konrad Wilk (konrad.wilk@oracle.com)\n");
+	} else {
+		pr_warn("SWIOTLB overflow buffer is disabled and will be\n"
+			"  deprecated. Please report problems related to\n"
+			"  disabling overflow buffer to\n"
+			"  linux-kernel@vger.kernel.org,\n"
+			"  Shuah Khan (shuahkhan@gmail.com), and\n"
+			"  Konrad Wilk (konrad.wilk@oracle.com)\n");
+	}
+}
+
 static int __init
 setup_io_tlb_npages(char *str)
 {
@@ -108,7 +126,6 @@ setup_io_tlb_npages(char *str)
 	return 1;
 }
 __setup("swiotlb=", setup_io_tlb_npages);
-/* make io_tlb_overflow tunable too? */
 
 unsigned long swiotlb_nr_tbl(void)
 {
@@ -156,12 +173,18 @@ void __init swiotlb_init_with_tbl(char *
 	io_tlb_index = 0;
 	io_tlb_orig_addr = alloc_bootmem_pages(PAGE_ALIGN(io_tlb_nslabs * sizeof(phys_addr_t)));
 
-	/*
-	 * Get the overflow emergency buffer
-	 */
-	io_tlb_overflow_buffer = alloc_bootmem_low_pages(PAGE_ALIGN(io_tlb_overflow));
-	if (!io_tlb_overflow_buffer)
-		panic("Cannot allocate SWIOTLB overflow buffer!\n");
+	if (io_tlb_overflow) {
+		/*
+		 * Get the overflow emergency buffer
+		 */
+		io_tlb_overflow_buffer = alloc_bootmem_low_pages(
+						PAGE_ALIGN(io_tlb_overflow));
+		if (!io_tlb_overflow_buffer)
+			panic("Cannot allocate SWIOTLB overflow buffer!\n");
+	}
+
+	swiotlb_print_overflow_deprecation_notice();
+
 	if (verbose)
 		swiotlb_print_info();
 }
@@ -264,14 +287,17 @@ swiotlb_late_init_with_default_size(size
 
 	memset(io_tlb_orig_addr, 0, io_tlb_nslabs * sizeof(phys_addr_t));
 
-	/*
-	 * Get the overflow emergency buffer
-	 */
-	io_tlb_overflow_buffer = (void *)__get_free_pages(GFP_DMA,
-	                                          get_order(io_tlb_overflow));
-	if (!io_tlb_overflow_buffer)
-		goto cleanup4;
+	if (io_tlb_overflow) {
+		/*
+		 * Get the overflow emergency buffer
+		 */
+		io_tlb_overflow_buffer = (void *)
+			__get_free_pages(GFP_DMA, get_order(io_tlb_overflow));
+		if (!io_tlb_overflow_buffer)
+			goto cleanup4;
+	}
 
+	swiotlb_print_overflow_deprecation_notice();
 	swiotlb_print_info();
 
 	late_alloc = 1;
@@ -297,12 +323,13 @@ cleanup1:
 
 void __init swiotlb_free(void)
 {
-	if (!io_tlb_overflow_buffer)
+	if (!io_tlb_orig_addr)
 		return;
 
 	if (late_alloc) {
-		free_pages((unsigned long)io_tlb_overflow_buffer,
-			   get_order(io_tlb_overflow));
+		if (io_tlb_overflow_buffer)
+			free_pages((unsigned long)io_tlb_overflow_buffer,
+				   get_order(io_tlb_overflow));
 		free_pages((unsigned long)io_tlb_orig_addr,
 			   get_order(io_tlb_nslabs * sizeof(phys_addr_t)));
 		free_pages((unsigned long)io_tlb_list, get_order(io_tlb_nslabs *
@@ -310,8 +337,9 @@ void __init swiotlb_free(void)
 		free_pages((unsigned long)io_tlb_start,
 			   get_order(io_tlb_nslabs << IO_TLB_SHIFT));
 	} else {
-		free_bootmem_late(__pa(io_tlb_overflow_buffer),
-				  PAGE_ALIGN(io_tlb_overflow));
+		if (io_tlb_overflow_buffer)
+			free_bootmem_late(__pa(io_tlb_overflow_buffer),
+					  PAGE_ALIGN(io_tlb_overflow));
 		free_bootmem_late(__pa(io_tlb_orig_addr),
 				  PAGE_ALIGN(io_tlb_nslabs * sizeof(phys_addr_t)));
 		free_bootmem_late(__pa(io_tlb_list),
@@ -681,7 +709,10 @@ dma_addr_t swiotlb_map_page(struct devic
 	map = map_single(dev, phys, size, dir);
 	if (!map) {
 		swiotlb_full(dev, size, dir, 1);
+		if (!io_tlb_overflow)
+			return DMA_ERROR_CODE;
 		map = io_tlb_overflow_buffer;
+		dev_err(dev, "SWIOTLB is full. Mapping overflow buffer.\n");
 	}
 
 	dev_addr = swiotlb_virt_to_bus(dev, map);
@@ -691,6 +722,8 @@ dma_addr_t swiotlb_map_page(struct devic
 	 */
 	if (!dma_capable(dev, dev_addr, size)) {
 		swiotlb_tbl_unmap_single(dev, map, size, dir);
+		if (!io_tlb_overflow)
+			return DMA_ERROR_CODE;
 		dev_addr = swiotlb_virt_to_bus(dev, io_tlb_overflow_buffer);
 	}
 
@@ -910,6 +943,8 @@ EXPORT_SYMBOL(swiotlb_sync_sg_for_device
 int
 swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
 {
+	if (!io_tlb_overflow)
+		return DMA_ERROR_CODE;
 	return (dma_addr == swiotlb_virt_to_bus(hwdev, io_tlb_overflow_buffer));
 }
 EXPORT_SYMBOL(swiotlb_dma_mapping_error);
_

Patches currently in -mm which might be from shuah.khan@hp.com are

linux-next.patch
swiotlb-add-support-to-disable-swiotlb-overflow-buffer-with-deprecation-warning.patch

