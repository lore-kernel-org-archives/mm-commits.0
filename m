From: akpm@linux-foundation.org
Subject: [patch 045/126] zsmalloc: keep max_object in size_class
Date: Tue, 26 Jul 2016 15:23:11 -0700
Message-ID: <5797e2cf.XxEgXPs2LR2IS76v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161AbcGZWXN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:23:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, vbabka@suse.cz

From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: keep max_object in size_class

Every zspage in a size_class has same number of max objects so
we could move it to a size_class.

Link: http://lkml.kernel.org/r/1464736881-24886-5-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
@@ -213,6 +211,7 @@ struct size_class {
 	 * of ZS_ALIGN.
 	 */
 	int size;
+	int objs_per_zspage;
 	unsigned int index;
 
 	struct zs_size_stat stats;
@@ -631,21 +630,22 @@ static inline void zs_pool_stat_destroy(
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
@@ -732,7 +732,7 @@ static enum fullness_group fix_fullness_
 	enum fullness_group currfg, newfg;
 
 	get_zspage_mapping(first_page, &class_idx, &currfg);
-	newfg = get_fullness_group(first_page);
+	newfg = get_fullness_group(class, first_page);
 	if (newfg == currfg)
 		goto out;
 
@@ -1012,9 +1012,6 @@ static struct page *alloc_zspage(struct
 	init_zspage(class, first_page);
 
 	first_page->freelist = location_to_obj(first_page, 0);
-	/* Maximum number of objects we can store in this zspage */
-	first_page->objects = class->pages_per_zspage * PAGE_SIZE / class->size;
-
 	error = 0; /* Success */
 
 cleanup:
@@ -1242,11 +1239,11 @@ static bool can_merge(struct size_class
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
@@ -1632,7 +1629,7 @@ static int migrate_zspage(struct zs_pool
 		}
 
 		/* Stop if there is no more space */
-		if (zspage_full(d_page)) {
+		if (zspage_full(class, d_page)) {
 			unpin_tag(handle);
 			ret = -ENOMEM;
 			break;
@@ -1691,7 +1688,7 @@ static enum fullness_group putback_zspag
 {
 	enum fullness_group fullness;
 
-	fullness = get_fullness_group(first_page);
+	fullness = get_fullness_group(class, first_page);
 	insert_zspage(class, fullness, first_page);
 	set_zspage_mapping(first_page, class->index, fullness);
 
@@ -1943,8 +1940,9 @@ struct zs_pool *zs_create_pool(const cha
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
