From: akpm@linux-foundation.org
Subject: + mlx4-use-bitmap_find_next_zero_area.patch added to -mm tree
Date: Wed, 28 Oct 2009 13:14:30 -0700
Message-ID: <200910282014.n9SKEUcM012960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754626AbZJ1UPB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Oct 2009 16:15:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, rolandd@cisco.com, yevgenyp@mellanox.co.il


The patch titled
     mlx4: use bitmap_find_next_zero_area
has been added to the -mm tree.  Its filename is
     mlx4-use-bitmap_find_next_zero_area.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mlx4: use bitmap_find_next_zero_area
From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: Roland Dreier <rolandd@cisco.com>
Cc: Yevgeny Petrilin <yevgenyp@mellanox.co.il>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/net/mlx4/alloc.c~mlx4-use-bitmap_find_next_zero_area drivers/net/mlx4/alloc.c
--- a/drivers/net/mlx4/alloc.c~mlx4-use-bitmap_find_next_zero_area
+++ a/drivers/net/mlx4/alloc.c
@@ -72,35 +72,6 @@ void mlx4_bitmap_free(struct mlx4_bitmap
 	mlx4_bitmap_free_range(bitmap, obj, 1);
 }
 
-static unsigned long find_aligned_range(unsigned long *bitmap,
-					u32 start, u32 nbits,
-					int len, int align)
-{
-	unsigned long end, i;
-
-again:
-	start = ALIGN(start, align);
-
-	while ((start < nbits) && test_bit(start, bitmap))
-		start += align;
-
-	if (start >= nbits)
-		return -1;
-
-	end = start+len;
-	if (end > nbits)
-		return -1;
-
-	for (i = start + 1; i < end; i++) {
-		if (test_bit(i, bitmap)) {
-			start = i + 1;
-			goto again;
-		}
-	}
-
-	return start;
-}
-
 u32 mlx4_bitmap_alloc_range(struct mlx4_bitmap *bitmap, int cnt, int align)
 {
 	u32 obj, i;
@@ -110,13 +81,13 @@ u32 mlx4_bitmap_alloc_range(struct mlx4_
 
 	spin_lock(&bitmap->lock);
 
-	obj = find_aligned_range(bitmap->table, bitmap->last,
-				 bitmap->max, cnt, align);
+	obj = bitmap_find_next_zero_area(bitmap->table, bitmap->max,
+				bitmap->last, cnt, align - 1);
 	if (obj >= bitmap->max) {
 		bitmap->top = (bitmap->top + bitmap->max + bitmap->reserved_top)
 				& bitmap->mask;
-		obj = find_aligned_range(bitmap->table, 0, bitmap->max,
-					 cnt, align);
+		obj = bitmap_find_next_zero_area(bitmap->table, bitmap->max,
+						0, cnt, align - 1);
 	}
 
 	if (obj < bitmap->max) {
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area.patch
iommu-helper-use-bitmap-library.patch
isp1362-hcd-use-bitmap_find_next_zero_area.patch
mlx4-use-bitmap_find_next_zero_area.patch
sparc-use-bitmap_find_next_zero_area.patch
ia64-use-bitmap_find_next_zero_area.patch
genalloc-use-bitmap_find_next_zero_area.patch

