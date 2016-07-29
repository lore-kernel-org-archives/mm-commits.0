From: akpm@linux-foundation.org
Subject: [merged]
 mm-zsmalloc-avoid-calculate-max-objects-of-zspage-twice.patch removed from
 -mm tree
Date: Fri, 29 Jul 2016 11:56:18 -0700
Message-ID: <579ba6d2.PB5uwPvzDvGhVwsv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37559 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbcG2S4T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:56:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: avoid calculate max objects of zspage twice
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-avoid-calculate-max-objects-of-zspage-twice.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: mm/zsmalloc: avoid calculate max objects of zspage twice

Currently, if a class can not be merged, the max objects of zspage
in that class may be calculated twice.

This patch calculate max objects of zspage at the begin, and pass
the value to can_merge() to decide whether the class can be merged.

Also this patch remove function get_maxobj_per_zspage(), as there
is no other place to call this function.

Link: http://lkml.kernel.org/r/1467882338-4300-4-git-send-email-opensource.ganesh@gmail.com
Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-avoid-calculate-max-objects-of-zspage-twice mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-avoid-calculate-max-objects-of-zspage-twice
+++ a/mm/zsmalloc.c
@@ -467,11 +467,6 @@ static struct zpool_driver zs_zpool_driv
 MODULE_ALIAS("zpool-zsmalloc");
 #endif /* CONFIG_ZPOOL */
 
-static unsigned int get_maxobj_per_zspage(int size, int pages_per_zspage)
-{
-	return pages_per_zspage * PAGE_SIZE / size;
-}
-
 /* per-cpu VM mapping areas for zspage accesses that cross page boundaries */
 static DEFINE_PER_CPU(struct mapping_area, zs_map_area);
 
@@ -1359,16 +1354,14 @@ static void init_zs_size_classes(void)
 	zs_size_classes = nr;
 }
 
-static bool can_merge(struct size_class *prev, int size, int pages_per_zspage)
+static bool can_merge(struct size_class *prev, int pages_per_zspage,
+					int objs_per_zspage)
 {
-	if (prev->pages_per_zspage != pages_per_zspage)
-		return false;
+	if (prev->pages_per_zspage == pages_per_zspage &&
+		prev->objs_per_zspage == objs_per_zspage)
+		return true;
 
-	if (prev->objs_per_zspage
-		!= get_maxobj_per_zspage(size, pages_per_zspage))
-		return false;
-
-	return true;
+	return false;
 }
 
 static bool zspage_full(struct size_class *class, struct zspage *zspage)
@@ -2438,6 +2431,7 @@ struct zs_pool *zs_create_pool(const cha
 	for (i = zs_size_classes - 1; i >= 0; i--) {
 		int size;
 		int pages_per_zspage;
+		int objs_per_zspage;
 		struct size_class *class;
 		int fullness = 0;
 
@@ -2445,6 +2439,7 @@ struct zs_pool *zs_create_pool(const cha
 		if (size > ZS_MAX_ALLOC_SIZE)
 			size = ZS_MAX_ALLOC_SIZE;
 		pages_per_zspage = get_pages_per_zspage(size);
+		objs_per_zspage = pages_per_zspage * PAGE_SIZE / size;
 
 		/*
 		 * size_class is used for normal zsmalloc operation such
@@ -2456,7 +2451,7 @@ struct zs_pool *zs_create_pool(const cha
 		 * previous size_class if possible.
 		 */
 		if (prev_class) {
-			if (can_merge(prev_class, size, pages_per_zspage)) {
+			if (can_merge(prev_class, pages_per_zspage, objs_per_zspage)) {
 				pool->size_class[i] = prev_class;
 				continue;
 			}
@@ -2469,8 +2464,7 @@ struct zs_pool *zs_create_pool(const cha
 		class->size = size;
 		class->index = i;
 		class->pages_per_zspage = pages_per_zspage;
-		class->objs_per_zspage = get_maxobj_per_zspage(class->size,
-							class->pages_per_zspage);
+		class->objs_per_zspage = objs_per_zspage;
 		spin_lock_init(&class->lock);
 		pool->size_class[i] = class;
 		for (fullness = ZS_EMPTY; fullness < NR_ZS_FULLNESS;
_

Patches currently in -mm which might be from opensource.ganesh@gmail.com are

mm-zsmalloc-add-trace-events-for-zs_compact.patch
mm-zsmalloc-add-per-class-compact-trace-event.patch

