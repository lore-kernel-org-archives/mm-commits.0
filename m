From: akpm@linux-foundation.org
Subject: [to-be-updated] iommu-helper-simplify-find_next_zero_area.patch removed from -mm tree
Date: Tue, 27 Oct 2009 01:19:25 -0700
Message-ID: <200910270819.n9R8JPTQ013687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932165AbZJ0IT7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Oct 2009 04:19:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, fujita.tomonori@lab.ntt.co.jp, joerg.roedel@amd.com, mm-commits@vger.kernel.org


The patch titled
     iommu-helper: simplify find_next_zero_area
has been removed from the -mm tree.  Its filename was
     iommu-helper-simplify-find_next_zero_area.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iommu-helper: simplify find_next_zero_area
From: Andrew Morton <akpm@linux-foundation.org>
DESC
iommu-helper: simplify find_next_zero_area
EDESC

Use find_next_bit instead of doing test_bit for each bit

Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN lib/iommu-helper.c~revert-lib-iommu-helperc-fix-off-by-one-error-in-find_next_zero_area lib/iommu-helper.c
--- a/lib/iommu-helper.c~revert-lib-iommu-helperc-fix-off-by-one-error-in-find_next_zero_area
+++ a/lib/iommu-helper.c
@@ -19,13 +19,12 @@ again:
 	index = (index + align_mask) & ~align_mask;
 
 	end = index + nr;
-	if (end > size)
+	if (end >= size)
 		return -1;
-	for (i = index; i < end; i++) {
-		if (test_bit(i, map)) {
-			start = i+1;
-			goto again;
-		}
+	i = find_next_bit(map, end, index);
+	if (i < end) {
+		start = i + 1;
+		goto again;
 	}
 	return index;
 }
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
iommu-helper-simplify-find_next_zero_area.patch
bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area.patch
isp1362-hcd-use-bitmap_find_next_zero_area.patch
mlx4-use-bitmap_find_next_zero_area.patch
sparc-use-bitmap_find_next_zero_area.patch
ia64-use-bitmap_find_next_zero_area.patch
genalloc-use-bitmap_find_next_zero_area.patch

