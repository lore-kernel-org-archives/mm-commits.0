From: akpm@linux-foundation.org
Subject: [to-be-updated]
 zsmalloc-factor-page-chain-functionality-out.patch removed from -mm tree
Date: Tue, 05 Apr 2016 14:14:09 -0700
Message-ID: <57042aa1.JDo2yGC5Qx2T1j6O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759977AbcDEVOL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 17:14:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, aquini@redhat.com, chan.jeong@lge.com, gi-oh.kim@profitbricks.com, hughd@google.com, iamjoonsoo.kim@lge.com, koct9i@gmail.com, mgorman@suse.de, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rknize@motorola.com, sangseok.lee@lge.com, sergey.senozhatsky@gmail.com, vbabka@suse.cz, viro@ZenIV.linux.org.uk, xuyiping@hisilicon.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: factor page chain functionality out
has been removed from the -mm tree.  Its filename was
     zsmalloc-factor-page-chain-functionality-out.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: factor page chain functionality out

For migration, we need to create sub-page chain of zspage dynamically so
this patch factors it out from alloc_zspage.

As a minor refactoring, it makes OBJ_ALLOCATED_TAG assign more clear in
obj_malloc(it could be another patch but it's trivial so I want to put
together in this patch).

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

 mm/zsmalloc.c |   80 +++++++++++++++++++++++++++---------------------
 1 file changed, 46 insertions(+), 34 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-factor-page-chain-functionality-out mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-factor-page-chain-functionality-out
+++ a/mm/zsmalloc.c
@@ -981,7 +981,9 @@ static void init_zspage(struct size_clas
 	unsigned long off = 0;
 	struct page *page = first_page;
 
-	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
+	first_page->freelist = NULL;
+	INIT_LIST_HEAD(&first_page->lru);
+	set_zspage_inuse(first_page, 0);
 
 	while (page) {
 		struct page *next_page;
@@ -1026,13 +1028,44 @@ static void init_zspage(struct size_clas
 	set_freeobj(first_page, 0);
 }
 
+static void create_page_chain(struct page *pages[], int nr_pages)
+{
+	int i;
+	struct page *page;
+	struct page *prev_page = NULL;
+	struct page *first_page = NULL;
+
+	for (i = 0; i < nr_pages; i++) {
+		page = pages[i];
+
+		INIT_LIST_HEAD(&page->lru);
+		if (i == 0) {
+			SetPagePrivate(page);
+			set_page_private(page, 0);
+			first_page = page;
+		}
+
+		if (i == 1)
+			set_page_private(first_page, (unsigned long)page);
+		if (i >= 1)
+			set_page_private(page, (unsigned long)first_page);
+		if (i >= 2)
+			list_add(&page->lru, &prev_page->lru);
+		if (i == nr_pages - 1)
+			SetPagePrivate2(page);
+
+		prev_page = page;
+	}
+}
+
 /*
  * Allocate a zspage for the given size class
  */
 static struct page *alloc_zspage(struct size_class *class, gfp_t flags)
 {
-	int i, error;
-	struct page *first_page = NULL, *uninitialized_var(prev_page);
+	int i;
+	struct page *first_page = NULL;
+	struct page *pages[ZS_MAX_PAGES_PER_ZSPAGE];
 
 	/*
 	 * Allocate individual pages and link them together as:
@@ -1045,43 +1078,23 @@ static struct page *alloc_zspage(struct
 	 * (i.e. no other sub-page has this flag set) and PG_private_2 to
 	 * identify the last page.
 	 */
-	error = -ENOMEM;
 	for (i = 0; i < class->pages_per_zspage; i++) {
 		struct page *page;
 
 		page = alloc_page(flags);
-		if (!page)
-			goto cleanup;
-
-		INIT_LIST_HEAD(&page->lru);
-		if (i == 0) {	/* first page */
-			page->freelist = NULL;
-			SetPagePrivate(page);
-			set_page_private(page, 0);
-			first_page = page;
-			set_zspage_inuse(page, 0);
+		if (!page) {
+			while (--i >= 0)
+				__free_page(pages[i]);
+			return NULL;
 		}
-		if (i == 1)
-			set_page_private(first_page, (unsigned long)page);
-		if (i >= 1)
-			set_page_private(page, (unsigned long)first_page);
-		if (i >= 2)
-			list_add(&page->lru, &prev_page->lru);
-		if (i == class->pages_per_zspage - 1)	/* last page */
-			SetPagePrivate2(page);
-		prev_page = page;
+
+		pages[i] = page;
 	}
 
+	create_page_chain(pages, class->pages_per_zspage);
+	first_page = pages[0];
 	init_zspage(class, first_page);
 
-	error = 0; /* Success */
-
-cleanup:
-	if (unlikely(error) && first_page) {
-		free_zspage(first_page);
-		first_page = NULL;
-	}
-
 	return first_page;
 }
 
@@ -1421,7 +1434,6 @@ static unsigned long obj_malloc(struct s
 	unsigned long m_offset;
 	void *vaddr;
 
-	handle |= OBJ_ALLOCATED_TAG;
 	obj = get_freeobj(first_page);
 	objidx_to_page_and_offset(class, first_page, obj,
 				&m_page, &m_offset);
@@ -1431,10 +1443,10 @@ static unsigned long obj_malloc(struct s
 	set_freeobj(first_page, link->next >> OBJ_ALLOCATED_TAG);
 	if (!class->huge)
 		/* record handle in the header of allocated chunk */
-		link->handle = handle;
+		link->handle = handle | OBJ_ALLOCATED_TAG;
 	else
 		/* record handle in first_page->private */
-		set_page_private(first_page, handle);
+		set_page_private(first_page, handle | OBJ_ALLOCATED_TAG);
 	kunmap_atomic(vaddr);
 	mod_zspage_inuse(first_page, 1);
 	zs_stat_inc(class, OBJ_USED, 1);
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-vmscan-reclaim-highmem-zone-if-buffer_heads-is-over-limit.patch
mm-call-swap_slot_free_notify-with-holding-page-lock.patch
mm-hwpoison-fix-wrong-num_poisoned_pages-account.patch
zsmalloc-use-first_page-rather-than-page.patch
zsmalloc-clean-up-many-bug_on.patch
zsmalloc-reordering-function-parameter.patch
zsmalloc-remove-unused-pool-param-in-obj_free.patch
zsmalloc-separate-free_zspage-from-putback_zspage.patch
zsmalloc-zs_compact-refactoring.patch
zsmalloc-migrate-head-page-of-zspage.patch
zsmalloc-use-single-linked-list-for-page-chain.patch
zsmalloc-migrate-tail-pages-in-zspage.patch
zram-use-__gfp_movable-for-memory-allocation.patch

