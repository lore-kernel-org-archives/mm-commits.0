From: akpm@linux-foundation.org
Subject: [to-be-updated] zsmalloc-keep-max_object-in-size_class.patch
 removed from -mm tree
Date: Tue, 05 Apr 2016 14:13:54 -0700
Message-ID: <57042a92.najb0j3V9rKx4KFA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52293 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759769AbcDEVN4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 17:13:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, aquini@redhat.com, chan.jeong@lge.com, gi-oh.kim@profitbricks.com, hughd@google.com, iamjoonsoo.kim@lge.com, koct9i@gmail.com, mgorman@suse.de, riel@redhat.com, rknize@motorola.com, sangseok.lee@lge.com, sergey.senozhatsky@gmail.com, vbabka@suse.cz, viro@ZenIV.linux.org.uk, xuyiping@hisilicon.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: keep max_object in size_class
has been removed from the -mm tree.  Its filename was
     zsmalloc-keep-max_object-in-size_class.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: keep max_object in size_class

Every zspage in a size_class has same number of max objects so
we could move it to a size_class.

Signed-off-by: Minchan Kim <minchan@kernel.org>Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Russ Knize <rknize@motorola.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Gioh Kim <gi-oh.kim@profitbricks.com>
Cc: Sangseok Lee <sangseok.lee@lge.com>
Cc: Chan Gyun Jeong <chan.jeong@lge.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: YiPing Xu <xuyiping@hisilicon.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-keep-max_object-in-size_class mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-keep-max_object-in-size_class
+++ a/mm/zsmalloc.c
@@ -32,8 +32,6 @@
  *	page->freelist: points to the first free object in zspage.
  *		Free objects are linked together using in-place
  *		metadata.
- *	page->objects: maximum number of objects we can store in this
- *		zspage (class->zspage_order * PAGE_SIZE / class->size)
  *	page->lru: links together first pages of various zspages.
  *		Basically forming list of zspages in a fullness group.
  *	page->mapping: class index and fullness group of the zspage
@@ -211,6 +209,7 @@ struct size_class {
 	 * of ZS_ALIGN.
 	 */
 	int size;
+	int objs_per_zspage;
 	unsigned int index;
 
 	struct zs_size_stat stats;
@@ -627,21 +626,22 @@ static inline void zs_pool_stat_destroy(
  * the pool (not yet implemented). This function returns fullness
  * status of the given page.
  */
-static enum fullness_group get_fullness_group(struct page *first_page)
+static enum fullness_group get_fullness_group(struct size_class *class,
+						struct page *first_page)
 {
-	int inuse, max_objects;
+	int inuse, objs_per_zspage;
 	enum fullness_group fg;
 
 	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
 
 	inuse = first_page->inuse;
-	max_objects = first_page->objects;
+	objs_per_zspage = class->objs_per_zspage;
 
 	if (inuse == 0)
 		fg = ZS_EMPTY;
-	else if (inuse == max_objects)
+	else if (inuse == objs_per_zspage)
 		fg = ZS_FULL;
-	else if (inuse <= 3 * max_objects / fullness_threshold_frac)
+	else if (inuse <= 3 * objs_per_zspage / fullness_threshold_frac)
 		fg = ZS_ALMOST_EMPTY;
 	else
 		fg = ZS_ALMOST_FULL;
@@ -728,7 +728,7 @@ static enum fullness_group fix_fullness_
 	enum fullness_group currfg, newfg;
 
 	get_zspage_mapping(first_page, &class_idx, &currfg);
-	newfg = get_fullness_group(first_page);
+	newfg = get_fullness_group(class, first_page);
 	if (newfg == currfg)
 		goto out;
 
@@ -1008,9 +1008,6 @@ static struct page *alloc_zspage(struct
 	init_zspage(class, first_page);
 
 	first_page->freelist = location_to_obj(first_page, 0);
-	/* Maximum number of objects we can store in this zspage */
-	first_page->objects = class->pages_per_zspage * PAGE_SIZE / class->size;
-
 	error = 0; /* Success */
 
 cleanup:
@@ -1238,11 +1235,11 @@ static bool can_merge(struct size_class
 	return true;
 }
 
-static bool zspage_full(struct page *first_page)
+static bool zspage_full(struct size_class *class, struct page *first_page)
 {
 	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
 
-	return first_page->inuse == first_page->objects;
+	return first_page->inuse == class->objs_per_zspage;
 }
 
 unsigned long zs_get_total_pages(struct zs_pool *pool)
@@ -1628,7 +1625,7 @@ static int migrate_zspage(struct zs_pool
 		}
 
 		/* Stop if there is no more space */
-		if (zspage_full(d_page)) {
+		if (zspage_full(class, d_page)) {
 			unpin_tag(handle);
 			ret = -ENOMEM;
 			break;
@@ -1687,7 +1684,7 @@ static enum fullness_group putback_zspag
 {
 	enum fullness_group fullness;
 
-	fullness = get_fullness_group(first_page);
+	fullness = get_fullness_group(class, first_page);
 	insert_zspage(class, fullness, first_page);
 	set_zspage_mapping(first_page, class->index, fullness);
 
@@ -1936,8 +1933,9 @@ struct zs_pool *zs_create_pool(const cha
 		class->size = size;
 		class->index = i;
 		class->pages_per_zspage = pages_per_zspage;
-		if (pages_per_zspage == 1 &&
-			get_maxobj_per_zspage(size, pages_per_zspage) == 1)
+		class->objs_per_zspage = class->pages_per_zspage *
+						PAGE_SIZE / class->size;
+		if (pages_per_zspage == 1 && class->objs_per_zspage == 1)
 			class->huge = true;
 		spin_lock_init(&class->lock);
 		pool->size_class[i] = class;
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-vmscan-reclaim-highmem-zone-if-buffer_heads-is-over-limit.patch
mm-call-swap_slot_free_notify-with-holding-page-lock.patch
mm-hwpoison-fix-wrong-num_poisoned_pages-account.patch
zsmalloc-use-first_page-rather-than-page.patch
zsmalloc-clean-up-many-bug_on.patch
zsmalloc-reordering-function-parameter.patch
zsmalloc-remove-unused-pool-param-in-obj_free.patch
zsmalloc-squeeze-inuse-into-page-mapping.patch
zsmalloc-remove-page_mapcount_reset.patch
zsmalloc-squeeze-freelist-into-page-mapping.patch
zsmalloc-move-struct-zs_meta-from-mapping-to-freelist.patch
zsmalloc-factor-page-chain-functionality-out.patch
zsmalloc-separate-free_zspage-from-putback_zspage.patch
zsmalloc-zs_compact-refactoring.patch
zsmalloc-migrate-head-page-of-zspage.patch
zsmalloc-use-single-linked-list-for-page-chain.patch
zsmalloc-migrate-tail-pages-in-zspage.patch
zram-use-__gfp_movable-for-memory-allocation.patch

