From: akpm@linux-foundation.org
Subject: [merged]
 mm-zsmalloc-use-class-objs_per_zspage-to-get-num-of-max-objects.patch
 removed from -mm tree
Date: Fri, 29 Jul 2016 11:56:16 -0700
Message-ID: <579ba6d0.iaunPKstoUbkRYEc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbcG2S4R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:56:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: use class->objs_per_zspage to get num of max objects
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-use-class-objs_per_zspage-to-get-num-of-max-objects.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: mm/zsmalloc: use class->objs_per_zspage to get num of max objects

num of max objects in zspage is stored in each size_class now.
So there is no need to re-calculate it.

Link: http://lkml.kernel.org/r/1467882338-4300-3-git-send-email-opensource.ganesh@gmail.com
Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-use-class-objs_per_zspage-to-get-num-of-max-objects mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-use-class-objs_per_zspage-to-get-num-of-max-objects
+++ a/mm/zsmalloc.c
@@ -635,8 +635,7 @@ static int zs_stats_size_show(struct seq
 		freeable = zs_can_compact(class);
 		spin_unlock(&class->lock);
 
-		objs_per_zspage = get_maxobj_per_zspage(class->size,
-				class->pages_per_zspage);
+		objs_per_zspage = class->objs_per_zspage;
 		pages_used = obj_allocated / objs_per_zspage *
 				class->pages_per_zspage;
 
@@ -1014,8 +1013,7 @@ static void __free_zspage(struct zs_pool
 
 	cache_free_zspage(pool, zspage);
 
-	zs_stat_dec(class, OBJ_ALLOCATED, get_maxobj_per_zspage(
-			class->size, class->pages_per_zspage));
+	zs_stat_dec(class, OBJ_ALLOCATED, class->objs_per_zspage);
 	atomic_long_sub(class->pages_per_zspage,
 					&pool->pages_allocated);
 }
@@ -1366,7 +1364,7 @@ static bool can_merge(struct size_class
 	if (prev->pages_per_zspage != pages_per_zspage)
 		return false;
 
-	if (get_maxobj_per_zspage(prev->size, prev->pages_per_zspage)
+	if (prev->objs_per_zspage
 		!= get_maxobj_per_zspage(size, pages_per_zspage))
 		return false;
 
@@ -1592,8 +1590,7 @@ unsigned long zs_malloc(struct zs_pool *
 	record_obj(handle, obj);
 	atomic_long_add(class->pages_per_zspage,
 				&pool->pages_allocated);
-	zs_stat_inc(class, OBJ_ALLOCATED, get_maxobj_per_zspage(
-			class->size, class->pages_per_zspage));
+	zs_stat_inc(class, OBJ_ALLOCATED, class->objs_per_zspage);
 
 	/* We completely set up zspage so mark them as movable */
 	SetZsPageMovable(pool, zspage);
@@ -2265,8 +2262,7 @@ static unsigned long zs_can_compact(stru
 		return 0;
 
 	obj_wasted = obj_allocated - obj_used;
-	obj_wasted /= get_maxobj_per_zspage(class->size,
-			class->pages_per_zspage);
+	obj_wasted /= class->objs_per_zspage;
 
 	return obj_wasted * class->pages_per_zspage;
 }
@@ -2473,8 +2469,8 @@ struct zs_pool *zs_create_pool(const cha
 		class->size = size;
 		class->index = i;
 		class->pages_per_zspage = pages_per_zspage;
-		class->objs_per_zspage = class->pages_per_zspage *
-						PAGE_SIZE / class->size;
+		class->objs_per_zspage = get_maxobj_per_zspage(class->size,
+							class->pages_per_zspage);
 		spin_lock_init(&class->lock);
 		pool->size_class[i] = class;
 		for (fullness = ZS_EMPTY; fullness < NR_ZS_FULLNESS;
_

Patches currently in -mm which might be from opensource.ganesh@gmail.com are

mm-zsmalloc-add-trace-events-for-zs_compact.patch
mm-zsmalloc-add-per-class-compact-trace-event.patch

