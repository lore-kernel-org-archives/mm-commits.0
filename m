From: akpm@linux-foundation.org
Subject: + iommu-sg-add-iommu-helper-functions-for-the-free-area-management.patch added to -mm tree
Date: Fri, 07 Dec 2007 14:12:20 -0800
Message-ID: <200712072212.lB7MCKmS006195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46796 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754263AbXLGWOD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 17:14:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomof@acm.org, James.Bottomley@steeleye.com, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, jens.axboe@oracle.com


The patch titled
     iommu sg: add IOMMU helper functions for the free area management
has been added to the -mm tree.  Its filename is
     iommu-sg-add-iommu-helper-functions-for-the-free-area-management.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iommu sg: add IOMMU helper functions for the free area management
From: FUJITA Tomonori <tomof@acm.org>

This adds IOMMU helper functions for the free area management.  These
functions take care of LLD's segment boundary limit for IOMMUs.  They would be
useful for IOMMUs that use bitmap for the free area management.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/iommu-helper.h |    7 +++
 lib/Makefile                 |    1 
 lib/iommu-helper.c           |   76 +++++++++++++++++++++++++++++++++
 3 files changed, 84 insertions(+)

diff -puN /dev/null include/linux/iommu-helper.h
--- /dev/null
+++ a/include/linux/iommu-helper.h
@@ -0,0 +1,7 @@
+extern unsigned long iommu_area_alloc(unsigned long *map, unsigned long size,
+				      unsigned long start, unsigned int nr,
+				      unsigned long shift,
+				      unsigned long boundary_size,
+				      unsigned long align_mask);
+extern void iommu_area_free(unsigned long *map, unsigned long start,
+			    unsigned int nr);
diff -puN lib/Makefile~iommu-sg-add-iommu-helper-functions-for-the-free-area-management lib/Makefile
--- a/lib/Makefile~iommu-sg-add-iommu-helper-functions-for-the-free-area-management
+++ a/lib/Makefile
@@ -65,6 +65,7 @@ obj-$(CONFIG_SMP) += pcounter.o
 obj-$(CONFIG_AUDIT_GENERIC) += audit.o
 
 obj-$(CONFIG_SWIOTLB) += swiotlb.o
+obj-$(CONFIG_IOMMU_HELPER) += iommu-helper.o
 obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
diff -puN /dev/null lib/iommu-helper.c
--- /dev/null
+++ a/lib/iommu-helper.c
@@ -0,0 +1,76 @@
+/*
+ * IOMMU helper functions for the free area management
+ */
+
+#include <linux/module.h>
+#include <linux/bitops.h>
+
+static unsigned long find_next_zero_area(unsigned long *map,
+					 unsigned long size,
+					 unsigned long start,
+					 unsigned int nr)
+{
+	unsigned long index, end, i;
+again:
+	index = find_next_zero_bit(map, size, start);
+	end = index + nr;
+	if (end > size)
+		return -1;
+	for (i = index + 1; i < end; i++) {
+		if (test_bit(i, map)) {
+			start = i+1;
+			goto again;
+		}
+	}
+	return index;
+}
+
+static inline void set_bit_area(unsigned long *map, unsigned long i,
+				int len)
+{
+	unsigned long end = i + len;
+	while (i < end) {
+		__set_bit(i, map);
+		i++;
+	}
+}
+
+static inline int is_span_boundary(unsigned int index, unsigned int nr,
+				   unsigned long shift,
+				   unsigned long boundary_size)
+{
+	shift = (shift + index) & (boundary_size - 1);
+	return shift + nr > boundary_size;
+}
+
+unsigned long iommu_area_alloc(unsigned long *map, unsigned long size,
+			       unsigned long start, unsigned int nr,
+			       unsigned long shift, unsigned long boundary_size,
+			       unsigned long align_mask)
+{
+	unsigned long index;
+again:
+	index = find_next_zero_area(map, size, start, nr);
+	if (index != -1) {
+		index = (index + align_mask) & ~align_mask;
+		if (is_span_boundary(index, nr, shift, boundary_size)) {
+			/* we could do more effectively */
+			start = index + 1;
+			goto again;
+		}
+		set_bit_area(map, index, nr);
+	}
+	return index;
+}
+EXPORT_SYMBOL(iommu_area_alloc);
+
+void iommu_area_free(unsigned long *map, unsigned long start, unsigned int nr)
+{
+	unsigned long end = start + nr;
+
+	while (start < end) {
+		__clear_bit(start, map);
+		start++;
+	}
+}
+EXPORT_SYMBOL(iommu_area_free);
_

Patches currently in -mm which might be from tomof@acm.org are

git-scsi-misc.patch
iommu-sg-merging-add-device_dma_parameters-structure.patch
iommu-sg-merging-pci-add-device_dma_parameters-support.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-ppc-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-ia64-make-sba_iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-alpha-make-pci_iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-sparc64-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-parisc-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-call-blk_queue_segment_boundary-in-__scsi_alloc_queue.patch
iommu-sg-merging-sata_inic162x-use-pci_set_dma_max_seg_size.patch
iommu-sg-merging-aacraid-use-pci_set_dma_max_seg_size.patch
iommu-sg-add-iommu-helper-functions-for-the-free-area-management.patch
iommu-sg-powerpc-convert-iommu-to-use-the-iommu-helper.patch
iommu-sg-powerpc-remove-dma-4gb-boundary-protection.patch
iommu-sg-x86-convert-calgary-iommu-to-use-the-iommu-helper.patch
iommu-sg-x86-convert-gart-iommu-to-use-the-iommu-helper.patch
iommu-sg-kill-__clear_bit_string-and-find_next_zero_string.patch
add-accessors-for-segment_boundary_mask-in.patch
pci-add-dma-segment-boundary-support.patch
swiotlb-respect-the-segment-boundary-limits.patch
call-dma_set_seg_boundary-in-__scsi_alloc_queue.patch
alpha-kill-deprecated-virt_to_bus.patch
