From: akpm@linux-foundation.org
Subject: [to-be-updated]
 zsmalloc-use-single-linked-list-for-page-chain.patch removed from -mm tree
Date: Tue, 05 Apr 2016 14:14:21 -0700
Message-ID: <57042aad.ge6wP75Bitf1ML1f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760143AbcDEVOX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 17:14:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, aquini@redhat.com, chan.jeong@lge.com, gi-oh.kim@profitbricks.com, hughd@google.com, iamjoonsoo.kim@lge.com, koct9i@gmail.com, mgorman@suse.de, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rknize@motorola.com, sangseok.lee@lge.com, sergey.senozhatsky@gmail.com, vbabka@suse.cz, viro@ZenIV.linux.org.uk, xuyiping@hisilicon.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: use single linked list for page chain
has been removed from the -mm tree.  Its filename was
     zsmalloc-use-single-linked-list-for-page-chain.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: use single linked list for page chain

For tail page migration, we shouldn't use page->lru which was used for
page chaining because VM will use it for own purpose so that we need
another field for chaining.  For chaining, singly linked list is enough
and page->index of tail page to point first object offset in the page
could be replaced in run-time calculation.

So this patch change page->lru list for chaining with singly linked list
via page->freelist squeeze and introduces get_first_obj_ofs to get first
object offset in a page.

With that, it could maintain page chaining without using page->lru.

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

 mm/zsmalloc.c |  119 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 78 insertions(+), 41 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-use-single-linked-list-for-page-chain mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-use-single-linked-list-for-page-chain
+++ a/mm/zsmalloc.c
@@ -17,10 +17,7 @@
  *
  * Usage of struct page fields:
  *	page->private: points to the first component (0-order) page
- *	page->index (union with page->freelist): offset of the first object
- *		starting in this page.
- *	page->lru: links together all component pages (except the first page)
- *		of a zspage
+ *	page->index (union with page->freelist): override by struct zs_meta
  *
  *	For _first_ page only:
  *
@@ -271,10 +268,19 @@ struct zs_pool {
 };
 
 struct zs_meta {
-	unsigned long freeobj:FREEOBJ_BITS;
-	unsigned long class:CLASS_BITS;
-	unsigned long fullness:FULLNESS_BITS;
-	unsigned long inuse:INUSE_BITS;
+	union {
+		/* first page */
+		struct {
+			unsigned long freeobj:FREEOBJ_BITS;
+			unsigned long class:CLASS_BITS;
+			unsigned long fullness:FULLNESS_BITS;
+			unsigned long inuse:INUSE_BITS;
+		};
+		/* tail pages */
+		struct {
+			struct page *next;
+		};
+	};
 };
 
 struct mapping_area {
@@ -491,6 +497,34 @@ static unsigned long get_freeobj(struct
 	return m->freeobj;
 }
 
+static void set_next_page(struct page *page, struct page *next)
+{
+	struct zs_meta *m;
+
+	VM_BUG_ON_PAGE(is_first_page(page), page);
+
+	m = (struct zs_meta *)&page->index;
+	m->next = next;
+}
+
+static struct page *get_next_page(struct page *page)
+{
+	struct page *next;
+
+	if (is_last_page(page))
+		next = NULL;
+	else if (is_first_page(page))
+		next = (struct page *)page_private(page);
+	else {
+		struct zs_meta *m = (struct zs_meta *)&page->index;
+
+		VM_BUG_ON(!m->next);
+		next = m->next;
+	}
+
+	return next;
+}
+
 static void get_zspage_mapping(struct page *first_page,
 				unsigned int *class_idx,
 				enum fullness_group *fullness)
@@ -871,18 +905,30 @@ static struct page *get_first_page(struc
 		return (struct page *)page_private(page);
 }
 
-static struct page *get_next_page(struct page *page)
+int get_first_obj_ofs(struct size_class *class, struct page *first_page,
+			struct page *page)
 {
-	struct page *next;
+	int pos, bound;
+	int page_idx = 0;
+	int ofs = 0;
+	struct page *cursor = first_page;
 
-	if (is_last_page(page))
-		next = NULL;
-	else if (is_first_page(page))
-		next = (struct page *)page_private(page);
-	else
-		next = list_entry(page->lru.next, struct page, lru);
+	if (first_page == page)
+		goto out;
 
-	return next;
+	while (page != cursor) {
+		page_idx++;
+		cursor = get_next_page(cursor);
+	}
+
+	bound = PAGE_SIZE * page_idx;
+	pos = (((class->objs_per_zspage * class->size) *
+		page_idx / class->pages_per_zspage) / class->size
+		) * class->size;
+
+	ofs = (pos + class->size) % PAGE_SIZE;
+out:
+	return ofs;
 }
 
 static void objidx_to_page_and_offset(struct size_class *class,
@@ -1008,27 +1054,25 @@ void lock_zspage(struct page *first_page
 
 static void free_zspage(struct zs_pool *pool, struct page *first_page)
 {
-	struct page *nextp, *tmp, *head_extra;
+	struct page *nextp, *tmp;
 
 	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
 	VM_BUG_ON_PAGE(get_zspage_inuse(first_page), first_page);
 
 	lock_zspage(first_page);
-	head_extra = (struct page *)page_private(first_page);
+	nextp = (struct page *)page_private(first_page);
 
 	/* zspage with only 1 system page */
-	if (!head_extra)
+	if (!nextp)
 		goto out;
 
-	list_for_each_entry_safe(nextp, tmp, &head_extra->lru, lru) {
-		list_del(&nextp->lru);
-		reset_page(nextp);
-		unlock_page(nextp);
-		put_page(nextp);
-	}
-	reset_page(head_extra);
-	unlock_page(head_extra);
-	put_page(head_extra);
+	do {
+		tmp = nextp;
+		nextp = get_next_page(nextp);
+		reset_page(tmp);
+		unlock_page(tmp);
+		put_page(tmp);
+	} while (nextp);
 out:
 	reset_page(first_page);
 	unlock_page(first_page);
@@ -1055,13 +1099,6 @@ static void init_zspage(struct size_clas
 		struct link_free *link;
 		void *vaddr;
 
-		/*
-		 * page->index stores offset of first object starting
-		 * in the page.
-		 */
-		if (page != first_page)
-			page->index = off;
-
 		vaddr = kmap_atomic(page);
 		link = (struct link_free *)vaddr + off / sizeof(*link);
 
@@ -1103,7 +1140,6 @@ static void create_page_chain(struct pag
 	for (i = 0; i < nr_pages; i++) {
 		page = pages[i];
 
-		INIT_LIST_HEAD(&page->lru);
 		if (i == 0) {
 			SetPagePrivate(page);
 			set_page_private(page, 0);
@@ -1112,10 +1148,12 @@ static void create_page_chain(struct pag
 
 		if (i == 1)
 			set_page_private(first_page, (unsigned long)page);
-		if (i >= 1)
+		if (i >= 1) {
+			set_next_page(page, NULL);
 			set_page_private(page, (unsigned long)first_page);
+		}
 		if (i >= 2)
-			list_add(&page->lru, &prev_page->lru);
+			set_next_page(prev_page, page);
 		if (i == nr_pages - 1)
 			SetPagePrivate2(page);
 
@@ -2239,8 +2277,7 @@ int zs_page_migrate(struct address_space
 	kunmap_atomic(d_addr);
 	kunmap_atomic(s_addr);
 
-	if (!is_first_page(page))
-		offset = page->index;
+	offset = get_first_obj_ofs(class, first_page, page);
 
 	addr = kmap_atomic(page);
 	do {
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-vmscan-reclaim-highmem-zone-if-buffer_heads-is-over-limit.patch
mm-call-swap_slot_free_notify-with-holding-page-lock.patch
mm-hwpoison-fix-wrong-num_poisoned_pages-account.patch
zsmalloc-use-first_page-rather-than-page.patch
zsmalloc-clean-up-many-bug_on.patch
zsmalloc-reordering-function-parameter.patch
zsmalloc-remove-unused-pool-param-in-obj_free.patch
zsmalloc-migrate-tail-pages-in-zspage.patch
zram-use-__gfp_movable-for-memory-allocation.patch

