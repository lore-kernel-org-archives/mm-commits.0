From: akpm@linux-foundation.org
Subject: [nacked]
 mm-zsmallocc-count-in-handles-size-when-calculating-pages_per_zspage.patch
 removed from -mm tree
Date: Fri, 20 Mar 2015 12:38:21 -0700
Message-ID: <550c772d.JvMC7ZCuWHUnlBY9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbbCTTiX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Mar 2015 15:38:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghao.xie@samsung.com, minchan@kernel.org, ngupta@vflare.org, yinghao.xie@sumsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc.c: count in handle's size when calculating pages_per_zspage
has been removed from the -mm tree.  Its filename was
     mm-zsmallocc-count-in-handles-size-when-calculating-pages_per_zspage.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Yinghao Xie <yinghao.xie@samsung.com>
Subject: mm/zsmalloc.c: count in handle's size when calculating pages_per_zspage

1. Fix wastage calculation.

2. Indirect handle introduced extra ZS_HANDLE_SIZE size for each
   object,it's transparent for upper function, but a size_class's total
   objects will change.

   take the 43rd class which class_size = 32 + 43 * 16 = 720 as example:
	4096 * 1 % 720 = 496
	4096 * 2 % 720 = 272
	4096 * 3 % 720 = 48 
	4096 * 4 %720 = 544

   after handle introduced,class_size + ZS_HANDLE_SIZE (4 on 32bit) = 724
	4096 * 1 % 724 = 476
	4096 * 2 % 724 = 228
	4096 * 3 % 724 = 704
	4096 * 4 % 724 = 456


   Clearly, ZS_HANDLE_SIZE should be considered when calculating
   pages_per_zspage;

3. In get_size_class_index(), min(zs_size_classes - 1, idx) insures a
   huge class's index <= zs_size_classes - 1, so it's no need to check
   again.

Signed-off-by: Yinghao Xie <yinghao.xie@sumsung.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN mm/zsmalloc.c~mm-zsmallocc-count-in-handles-size-when-calculating-pages_per_zspage mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmallocc-count-in-handles-size-when-calculating-pages_per_zspage
+++ a/mm/zsmalloc.c
@@ -731,7 +731,8 @@ out:
  * to form a zspage for each size class. This is important
  * to reduce wastage due to unusable space left at end of
  * each zspage which is given as:
- *	wastage = Zp - Zp % size_class
+ *	wastage = Zp % (class_size + ZS_HANDLE_SIZE)
+ *	usage = Zp - wastage
  * where Zp = zspage size = k * PAGE_SIZE where k = 1, 2, ...
  *
  * For example, for size class of 3/8 * PAGE_SIZE, we should
@@ -744,6 +745,9 @@ static int get_pages_per_zspage(int clas
 	/* zspage order which gives maximum used size per KB */
 	int max_usedpc_order = 1;
 
+	if (class_size > ZS_MAX_ALLOC_SIZE)
+		class_size = ZS_MAX_ALLOC_SIZE;
+
 	for (i = 1; i <= ZS_MAX_PAGES_PER_ZSPAGE; i++) {
 		int zspage_size;
 		int waste, usedpc;
@@ -1397,11 +1401,6 @@ unsigned long zs_malloc(struct zs_pool *
 	/* extra space in chunk to keep the handle */
 	size += ZS_HANDLE_SIZE;
 	class = pool->size_class[get_size_class_index(size)];
-	/* In huge class size, we store the handle into first_page->private */
-	if (class->huge) {
-		size -= ZS_HANDLE_SIZE;
-		class = pool->size_class[get_size_class_index(size)];
-	}
 
 	spin_lock(&class->lock);
 	first_page = find_get_zspage(class);
@@ -1827,9 +1826,7 @@ struct zs_pool *zs_create_pool(char *nam
 		struct size_class *class;
 
 		size = ZS_MIN_ALLOC_SIZE + i * ZS_SIZE_CLASS_DELTA;
-		if (size > ZS_MAX_ALLOC_SIZE)
-			size = ZS_MAX_ALLOC_SIZE;
-		pages_per_zspage = get_pages_per_zspage(size);
+		pages_per_zspage = get_pages_per_zspage(size + ZS_HANDLE_SIZE);
 
 		/*
 		 * size_class is used for normal zsmalloc operation such
_

Patches currently in -mm which might be from yinghao.xie@samsung.com are


