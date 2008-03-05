From: akpm@linux-foundation.org
Subject: - iommu-export-iommu_is_span_boundary-helper-function.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:46:13 -0800
Message-ID: <200803050746.m257kDdg021746@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759125AbYCEHtA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:49:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, grundler@parisc-linux.org, kyle@parisc-linux.org, matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     iommu: export iommu_is_span_boundary helper function
has been removed from the -mm tree.  Its filename was
     iommu-export-iommu_is_span_boundary-helper-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iommu: export iommu_is_span_boundary helper function
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

iommu_is_span_boundary is used internally in the IOMMU helper
(lib/iommu-helper.c), a primitive function that judges whether a memory area
spans LLD's segment boundary or not.

It's difficult to convert some IOMMUs to use the IOMMU helper but
iommu_is_span_boundary is still useful for them.  So this patch exports it.

This is needed for the parisc iommu fixes.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Kyle McMartin <kyle@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/iommu-helper.h |    3 +++
 lib/iommu-helper.c           |   10 ++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff -puN include/linux/iommu-helper.h~iommu-export-iommu_is_span_boundary-helper-function include/linux/iommu-helper.h
--- a/include/linux/iommu-helper.h~iommu-export-iommu_is_span_boundary-helper-function
+++ a/include/linux/iommu-helper.h
@@ -1,3 +1,6 @@
+extern int iommu_is_span_boundary(unsigned int index, unsigned int nr,
+				  unsigned long shift,
+				  unsigned long boundary_size);
 extern unsigned long iommu_area_alloc(unsigned long *map, unsigned long size,
 				      unsigned long start, unsigned int nr,
 				      unsigned long shift,
diff -puN lib/iommu-helper.c~iommu-export-iommu_is_span_boundary-helper-function lib/iommu-helper.c
--- a/lib/iommu-helper.c~iommu-export-iommu_is_span_boundary-helper-function
+++ a/lib/iommu-helper.c
@@ -40,10 +40,12 @@ static inline void set_bit_area(unsigned
 	}
 }
 
-static inline int is_span_boundary(unsigned int index, unsigned int nr,
-				   unsigned long shift,
-				   unsigned long boundary_size)
+int iommu_is_span_boundary(unsigned int index, unsigned int nr,
+			   unsigned long shift,
+			   unsigned long boundary_size)
 {
+	BUG_ON(!is_power_of_2(boundary_size));
+
 	shift = (shift + index) & (boundary_size - 1);
 	return shift + nr > boundary_size;
 }
@@ -57,7 +59,7 @@ unsigned long iommu_area_alloc(unsigned 
 again:
 	index = find_next_zero_area(map, size, start, nr, align_mask);
 	if (index != -1) {
-		if (is_span_boundary(index, nr, shift, boundary_size)) {
+		if (iommu_is_span_boundary(index, nr, shift, boundary_size)) {
 			/* we could do more effectively */
 			start = index + 1;
 			goto again;
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

parisc-fix-a-overflow-bug-on-32bit-architectures.patch
git-scsi-misc.patch
mpt-fusion-dont-oops-if-numphys==0.patch

