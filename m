From: akpm@linux-foundation.org
Subject: + mm-zsmalloc-avoid-calculate-max-objects-of-zspage-twice.patch
 added to -mm tree
Date: Fri, 08 Jul 2016 14:16:41 -0700
Message-ID: <57801839.3Mu69J7uv2fYJnRb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43484 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604AbcGHVQm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2016 17:16:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: avoid calculate max objects of zspage twice
has been added to the -mm tree.  Its filename is
     mm-zsmalloc-avoid-calculate-max-objects-of-zspage-twice.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zsmalloc-avoid-calculate-max-objects-of-zspage-twice.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmalloc-avoid-calculate-max-objects-of-zspage-twice.patch

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
@@ -470,11 +470,6 @@ static struct zpool_driver zs_zpool_driv
 MODULE_ALIAS("zpool-zsmalloc");
 #endif /* CONFIG_ZPOOL */
 
-static unsigned int get_maxobj_per_zspage(int size, int pages_per_zspage)
-{
-	return pages_per_zspage * PAGE_SIZE / size;
-}
-
 /* per-cpu VM mapping areas for zspage accesses that cross page boundaries */
 static DEFINE_PER_CPU(struct mapping_area, zs_map_area);
 
@@ -1362,16 +1357,14 @@ static void init_zs_size_classes(void)
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
@@ -2448,6 +2441,7 @@ struct zs_pool *zs_create_pool(const cha
 	for (i = zs_size_classes - 1; i >= 0; i--) {
 		int size;
 		int pages_per_zspage;
+		int objs_per_zspage;
 		struct size_class *class;
 		int fullness = 0;
 
@@ -2455,6 +2449,7 @@ struct zs_pool *zs_create_pool(const cha
 		if (size > ZS_MAX_ALLOC_SIZE)
 			size = ZS_MAX_ALLOC_SIZE;
 		pages_per_zspage = get_pages_per_zspage(size);
+		objs_per_zspage = pages_per_zspage * PAGE_SIZE / size;
 
 		/*
 		 * size_class is used for normal zsmalloc operation such
@@ -2466,7 +2461,7 @@ struct zs_pool *zs_create_pool(const cha
 		 * previous size_class if possible.
 		 */
 		if (prev_class) {
-			if (can_merge(prev_class, size, pages_per_zspage)) {
+			if (can_merge(prev_class, pages_per_zspage, objs_per_zspage)) {
 				pool->size_class[i] = prev_class;
 				continue;
 			}
@@ -2479,8 +2474,7 @@ struct zs_pool *zs_create_pool(const cha
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

