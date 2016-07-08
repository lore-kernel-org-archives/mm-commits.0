From: akpm@linux-foundation.org
Subject: +
 mm-zsmalloc-use-class-objs_per_zspage-to-get-num-of-max-objects.patch added to -mm tree
Date: Fri, 08 Jul 2016 14:16:39 -0700
Message-ID: <57801837.m7Gm5ZxQ8eJTpVMp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43483 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604AbcGHVQk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2016 17:16:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: use class->objs_per_zspage to get num of max objects
has been added to the -mm tree.  Its filename is
     mm-zsmalloc-use-class-objs_per_zspage-to-get-num-of-max-objects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zsmalloc-use-class-objs_per_zspage-to-get-num-of-max-objects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmalloc-use-class-objs_per_zspage-to-get-num-of-max-objects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -638,8 +638,7 @@ static int zs_stats_size_show(struct seq
 		freeable = zs_can_compact(class);
 		spin_unlock(&class->lock);
 
-		objs_per_zspage = get_maxobj_per_zspage(class->size,
-				class->pages_per_zspage);
+		objs_per_zspage = class->objs_per_zspage;
 		pages_used = obj_allocated / objs_per_zspage *
 				class->pages_per_zspage;
 
@@ -1017,8 +1016,7 @@ static void __free_zspage(struct zs_pool
 
 	cache_free_zspage(pool, zspage);
 
-	zs_stat_dec(class, OBJ_ALLOCATED, get_maxobj_per_zspage(
-			class->size, class->pages_per_zspage));
+	zs_stat_dec(class, OBJ_ALLOCATED, class->objs_per_zspage);
 	atomic_long_sub(class->pages_per_zspage,
 					&pool->pages_allocated);
 }
@@ -1369,7 +1367,7 @@ static bool can_merge(struct size_class
 	if (prev->pages_per_zspage != pages_per_zspage)
 		return false;
 
-	if (get_maxobj_per_zspage(prev->size, prev->pages_per_zspage)
+	if (prev->objs_per_zspage
 		!= get_maxobj_per_zspage(size, pages_per_zspage))
 		return false;
 
@@ -1595,8 +1593,7 @@ unsigned long zs_malloc(struct zs_pool *
 	record_obj(handle, obj);
 	atomic_long_add(class->pages_per_zspage,
 				&pool->pages_allocated);
-	zs_stat_inc(class, OBJ_ALLOCATED, get_maxobj_per_zspage(
-			class->size, class->pages_per_zspage));
+	zs_stat_inc(class, OBJ_ALLOCATED, class->objs_per_zspage);
 
 	/* We completely set up zspage so mark them as movable */
 	SetZsPageMovable(pool, zspage);
@@ -2268,8 +2265,7 @@ static unsigned long zs_can_compact(stru
 		return 0;
 
 	obj_wasted = obj_allocated - obj_used;
-	obj_wasted /= get_maxobj_per_zspage(class->size,
-			class->pages_per_zspage);
+	obj_wasted /= class->objs_per_zspage;
 
 	return obj_wasted * class->pages_per_zspage;
 }
@@ -2483,8 +2479,8 @@ struct zs_pool *zs_create_pool(const cha
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

mm-migrate-support-non-lru-movable-page-migration-fix.patch
mm-zsmalloc-add-trace-events-for-zs_compact.patch
mm-compaction-remove-unnecessary-order-check-in-try_to_compact_pages.patch
mm-zsmalloc-use-obj_index-to-keep-consistent-with-others.patch
mm-zsmalloc-take-obj-index-back-from-find_alloced_obj.patch
mm-zsmalloc-use-class-objs_per_zspage-to-get-num-of-max-objects.patch
mm-zsmalloc-avoid-calculate-max-objects-of-zspage-twice.patch
mm-zsmalloc-keep-comments-consistent-with-code.patch
mm-zsmalloc-add-__init__exit-attribute.patch
mm-zsmalloc-use-helper-to-clear-page-flags-bit.patch
mm-zsmalloc-add-per-class-compact-trace-event.patch

