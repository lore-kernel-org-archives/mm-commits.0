From: akpm@linux-foundation.org
Subject: - iommu-sg-add-iommu-helper-functions-for-the-free-area-management.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:28:31 -0800
Message-ID: <200802052228.m15MSCvm011866@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60191 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762742AbYBEWoO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:44:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomof@acm.org, James.Bottomley@steeleye.com, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     iommu sg: add IOMMU helper functions for the free area management
has been removed from the -mm tree.  Its filename was
     iommu-sg-add-iommu-helper-functions-for-the-free-area-management.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

 include/linux/iommu-helper.h |    7 ++
 lib/Makefile                 |    1 
 lib/iommu-helper.c           |   80 +++++++++++++++++++++++++++++++++
 3 files changed, 88 insertions(+)

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
@@ -0,0 +1,80 @@
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
+					 unsigned int nr,
+					 unsigned long align_mask)
+{
+	unsigned long index, end, i;
+again:
+	index = find_next_zero_bit(map, size, start);
+
+	/* Align allocation */
+	index = (index + align_mask) & ~align_mask;
+
+	end = index + nr;
+	if (end >= size)
+		return -1;
+	for (i = index; i < end; i++) {
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
+	index = find_next_zero_area(map, size, start, nr, align_mask);
+	if (index != -1) {
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

origin.patch
