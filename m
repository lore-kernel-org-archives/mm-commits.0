From: akpm@linux-foundation.org
Subject: [to-be-updated] zsmalloc-squeeze-inuse-into-page-mapping.patch
 removed from -mm tree
Date: Tue, 05 Apr 2016 14:13:57 -0700
Message-ID: <57042a95.FR/G7ZzYkNouKM0A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52307 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760140AbcDEVN7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 17:13:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, aquini@redhat.com, chan.jeong@lge.com, gi-oh.kim@profitbricks.com, hughd@google.com, iamjoonsoo.kim@lge.com, koct9i@gmail.com, mgorman@suse.de, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rknize@motorola.com, sangseok.lee@lge.com, sergey.senozhatsky@gmail.com, vbabka@suse.cz, viro@ZenIV.linux.org.uk, xuyiping@hisilicon.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: squeeze inuse into page->mapping
has been removed from the -mm tree.  Its filename was
     zsmalloc-squeeze-inuse-into-page-mapping.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: squeeze inuse into page->mapping

Currently, we store class:fullness into page->mapping.  The number of
class we can support is 255 and fullness is 4 so (8 + 2 = 10bit) is enough
to represent them.  Meanwhile, the bits we need to store in-use objects in
zspage is that 11bit is enough.

For example, If we assume that 64K PAGE_SIZE, class_size 32 which is worst
case, class->pages_per_zspage become 1 so the number of objects in zspage
is 2048 so 11bit is enough.  The next class is 32 + 256(i.e.,
ZS_SIZE_CLASS_DELTA).  With worst case that ZS_MAX_PAGES_PER_ZSPAGE, 64K *
4 / (32 + 256) = 910 so 11bit is still enough.

So, we could squeeze inuse object count to page->mapping.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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

 mm/zsmalloc.c |  103 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 71 insertions(+), 32 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-squeeze-inuse-into-page-mapping mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-squeeze-inuse-into-page-mapping
+++ a/mm/zsmalloc.c
@@ -34,8 +34,7 @@
  *		metadata.
  *	page->lru: links together first pages of various zspages.
  *		Basically forming list of zspages in a fullness group.
- *	page->mapping: class index and fullness group of the zspage
- *	page->inuse: the number of objects that are used in this zspage
+ *	page->mapping: override by struct zs_meta
  *
  * Usage of struct page flags:
  *	PG_private: identifies the first component page
@@ -132,6 +131,13 @@
 /* each chunk includes extra space to keep handle */
 #define ZS_MAX_ALLOC_SIZE	PAGE_SIZE
 
+#define CLASS_BITS	8
+#define CLASS_MASK	((1 << CLASS_BITS) - 1)
+#define FULLNESS_BITS	2
+#define FULLNESS_MASK	((1 << FULLNESS_BITS) - 1)
+#define INUSE_BITS	11
+#define INUSE_MASK	((1 << INUSE_BITS) - 1)
+
 /*
  * On systems with 4K page size, this gives 255 size classes! There is a
  * trader-off here:
@@ -145,7 +151,7 @@
  *  ZS_MIN_ALLOC_SIZE and ZS_SIZE_CLASS_DELTA must be multiple of ZS_ALIGN
  *  (reason above)
  */
-#define ZS_SIZE_CLASS_DELTA	(PAGE_SIZE >> 8)
+#define ZS_SIZE_CLASS_DELTA	(PAGE_SIZE >> CLASS_BITS)
 
 /*
  * We do not maintain any list for completely empty or full pages
@@ -155,7 +161,7 @@ enum fullness_group {
 	ZS_ALMOST_EMPTY,
 	_ZS_NR_FULLNESS_GROUPS,
 
-	ZS_EMPTY,
+	ZS_EMPTY = _ZS_NR_FULLNESS_GROUPS,
 	ZS_FULL
 };
 
@@ -263,14 +269,11 @@ struct zs_pool {
 #endif
 };
 
-/*
- * A zspage's class index and fullness group
- * are encoded in its (first)page->mapping
- */
-#define CLASS_IDX_BITS	28
-#define FULLNESS_BITS	4
-#define CLASS_IDX_MASK	((1 << CLASS_IDX_BITS) - 1)
-#define FULLNESS_MASK	((1 << FULLNESS_BITS) - 1)
+struct zs_meta {
+	unsigned long class:CLASS_BITS;
+	unsigned long fullness:FULLNESS_BITS;
+	unsigned long inuse:INUSE_BITS;
+};
 
 struct mapping_area {
 #ifdef CONFIG_PGTABLE_MAPPING
@@ -412,28 +415,61 @@ static int is_last_page(struct page *pag
 	return PagePrivate2(page);
 }
 
+static int get_zspage_inuse(struct page *first_page)
+{
+	struct zs_meta *m;
+
+	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
+
+	m = (struct zs_meta *)&first_page->mapping;
+
+	return m->inuse;
+}
+
+static void set_zspage_inuse(struct page *first_page, int val)
+{
+	struct zs_meta *m;
+
+	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
+
+	m = (struct zs_meta *)&first_page->mapping;
+	m->inuse = val;
+}
+
+static void mod_zspage_inuse(struct page *first_page, int val)
+{
+	struct zs_meta *m;
+
+	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
+
+	m = (struct zs_meta *)&first_page->mapping;
+	m->inuse += val;
+}
+
 static void get_zspage_mapping(struct page *first_page,
 				unsigned int *class_idx,
 				enum fullness_group *fullness)
 {
-	unsigned long m;
+	struct zs_meta *m;
+
 	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
 
-	m = (unsigned long)first_page->mapping;
-	*fullness = m & FULLNESS_MASK;
-	*class_idx = (m >> FULLNESS_BITS) & CLASS_IDX_MASK;
+	m = (struct zs_meta *)&first_page->mapping;
+	*fullness = m->fullness;
+	*class_idx = m->class;
 }
 
 static void set_zspage_mapping(struct page *first_page,
 				unsigned int class_idx,
 				enum fullness_group fullness)
 {
-	unsigned long m;
+	struct zs_meta *m;
+
 	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
 
-	m = ((class_idx & CLASS_IDX_MASK) << FULLNESS_BITS) |
-			(fullness & FULLNESS_MASK);
-	first_page->mapping = (struct address_space *)m;
+	m = (struct zs_meta *)&first_page->mapping;
+	m->fullness = fullness;
+	m->class = class_idx;
 }
 
 /*
@@ -632,9 +668,7 @@ static enum fullness_group get_fullness_
 	int inuse, objs_per_zspage;
 	enum fullness_group fg;
 
-	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
-
-	inuse = first_page->inuse;
+	inuse = get_zspage_inuse(first_page);
 	objs_per_zspage = class->objs_per_zspage;
 
 	if (inuse == 0)
@@ -677,10 +711,10 @@ static void insert_zspage(struct size_cl
 
 	/*
 	 * We want to see more ZS_FULL pages and less almost
-	 * empty/full. Put pages with higher ->inuse first.
+	 * empty/full. Put pages with higher inuse first.
 	 */
 	list_add_tail(&first_page->lru, &(*head)->lru);
-	if (first_page->inuse >= (*head)->inuse)
+	if (get_zspage_inuse(first_page) >= get_zspage_inuse(*head))
 		*head = first_page;
 }
 
@@ -896,7 +930,7 @@ static void free_zspage(struct page *fir
 	struct page *nextp, *tmp, *head_extra;
 
 	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
-	VM_BUG_ON_PAGE(first_page->inuse, first_page);
+	VM_BUG_ON_PAGE(get_zspage_inuse(first_page), first_page);
 
 	head_extra = (struct page *)page_private(first_page);
 
@@ -992,7 +1026,7 @@ static struct page *alloc_zspage(struct
 			SetPagePrivate(page);
 			set_page_private(page, 0);
 			first_page = page;
-			first_page->inuse = 0;
+			set_zspage_inuse(page, 0);
 		}
 		if (i == 1)
 			set_page_private(first_page, (unsigned long)page);
@@ -1237,9 +1271,7 @@ static bool can_merge(struct size_class
 
 static bool zspage_full(struct size_class *class, struct page *first_page)
 {
-	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
-
-	return first_page->inuse == class->objs_per_zspage;
+	return get_zspage_inuse(first_page) == class->objs_per_zspage;
 }
 
 unsigned long zs_get_total_pages(struct zs_pool *pool)
@@ -1372,7 +1404,7 @@ static unsigned long obj_malloc(struct s
 		/* record handle in first_page->private */
 		set_page_private(first_page, handle);
 	kunmap_atomic(vaddr);
-	first_page->inuse++;
+	mod_zspage_inuse(first_page, 1);
 	zs_stat_inc(class, OBJ_USED, 1);
 
 	return obj;
@@ -1457,7 +1489,7 @@ static void obj_free(struct size_class *
 		set_page_private(first_page, 0);
 	kunmap_atomic(vaddr);
 	first_page->freelist = (void *)obj;
-	first_page->inuse--;
+	mod_zspage_inuse(first_page, -1);
 	zs_stat_dec(class, OBJ_USED, 1);
 }
 
@@ -2002,6 +2034,13 @@ static int __init zs_init(void)
 	if (ret)
 		goto notifier_fail;
 
+	/*
+	 * A zspage's class index, fullness group, inuse object count are
+	 * encoded in its (first)page->mapping so sizeof(struct zs_meta)
+	 * should be less than sizeof(page->mapping(i.e., unsigned long)).
+	 */
+	BUILD_BUG_ON(sizeof(struct zs_meta) > sizeof(unsigned long));
+
 	init_zs_size_classes();
 
 #ifdef CONFIG_ZPOOL
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-vmscan-reclaim-highmem-zone-if-buffer_heads-is-over-limit.patch
mm-call-swap_slot_free_notify-with-holding-page-lock.patch
mm-hwpoison-fix-wrong-num_poisoned_pages-account.patch
zsmalloc-use-first_page-rather-than-page.patch
zsmalloc-clean-up-many-bug_on.patch
zsmalloc-reordering-function-parameter.patch
zsmalloc-remove-unused-pool-param-in-obj_free.patch
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

