From: akpm@linux-foundation.org
Subject: [nacked] lib-iommu-helperc-fix-off-by-one-error-in-find_next_zero_area.patch removed from -mm tree
Date: Tue, 27 Oct 2009 00:37:15 -0700
Message-ID: <200910270737.n9R7bF8p011889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755376AbZJ0HhT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Oct 2009 03:37:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, joerg.roedel@amd.com, mm-commits@vger.kernel.org


The patch titled
     lib/iommu-helper.c: fix off-by-one error in find_next_zero_area()
has been removed from the -mm tree.  Its filename was
     lib-iommu-helperc-fix-off-by-one-error-in-find_next_zero_area.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/iommu-helper.c: fix off-by-one error in find_next_zero_area()
From: Akinobu Mita <akinobu.mita@gmail.com>

My user space testing exposed off-by-one error find_next_zero_area in
iommu-helper.  Some zero area cannot be found by this bug.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN lib/iommu-helper.c~lib-iommu-helperc-fix-off-by-one-error-in-find_next_zero_area lib/iommu-helper.c
--- a/lib/iommu-helper.c~lib-iommu-helperc-fix-off-by-one-error-in-find_next_zero_area
+++ a/lib/iommu-helper.c
@@ -19,7 +19,7 @@ again:
 	index = (index + align_mask) & ~align_mask;
 
 	end = index + nr;
-	if (end >= size)
+	if (end > size)
 		return -1;
 	for (i = index; i < end; i++) {
 		if (test_bit(i, map)) {
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

lib-iommu-helperc-fix-off-by-one-error-in-find_next_zero_area.patch
linux-next.patch
iommu-helper-simplify-find_next_zero_area.patch
bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area.patch
bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area-fix.patch
iommu-helper-use-bitmap-library.patch
isp1362-hcd-use-bitmap_find_next_zero_area.patch
mlx4-use-bitmap_find_next_zero_area.patch
sparc-use-bitmap_find_next_zero_area.patch
ia64-use-bitmap_find_next_zero_area.patch
genalloc-use-bitmap_find_next_zero_area.patch

