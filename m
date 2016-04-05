From: akpm@linux-foundation.org
Subject: [to-be-updated]
 zsmalloc-move-struct-zs_meta-from-mapping-to-freelist.patch removed from
 -mm tree
Date: Tue, 05 Apr 2016 14:14:06 -0700
Message-ID: <57042a9e.T0y7SLatTSjWxq+N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52343 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760095AbcDEVO2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 17:14:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, aquini@redhat.com, chan.jeong@lge.com, gi-oh.kim@profitbricks.com, hughd@google.com, iamjoonsoo.kim@lge.com, koct9i@gmail.com, mgorman@suse.de, riel@redhat.com, rknize@motorola.com, sangseok.lee@lge.com, sergey.senozhatsky@gmail.com, vbabka@suse.cz, viro@ZenIV.linux.org.uk, xuyiping@hisilicon.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: move struct zs_meta from mapping to freelist
has been removed from the -mm tree.  Its filename was
     zsmalloc-move-struct-zs_meta-from-mapping-to-freelist.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: move struct zs_meta from mapping to freelist

For supporting migration from VM, we need to have address_space on every
page so zsmalloc shouldn't use page->mapping.  So, this patch moves
zs_meta from mapping to freelist.

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

 mm/zsmalloc.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-move-struct-zs_meta-from-mapping-to-freelist mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-move-struct-zs_meta-from-mapping-to-freelist
+++ a/mm/zsmalloc.c
@@ -29,7 +29,7 @@
  *		Look at size_class->huge.
  *	page->lru: links together first pages of various zspages.
  *		Basically forming list of zspages in a fullness group.
- *	page->mapping: override by struct zs_meta
+ *	page->freelist: override by struct zs_meta
  *
  * Usage of struct page flags:
  *	PG_private: identifies the first component page
@@ -418,7 +418,7 @@ static int get_zspage_inuse(struct page
 
 	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
 
-	m = (struct zs_meta *)&first_page->mapping;
+	m = (struct zs_meta *)&first_page->freelist;
 
 	return m->inuse;
 }
@@ -429,7 +429,7 @@ static void set_zspage_inuse(struct page
 
 	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
 
-	m = (struct zs_meta *)&first_page->mapping;
+	m = (struct zs_meta *)&first_page->freelist;
 	m->inuse = val;
 }
 
@@ -439,7 +439,7 @@ static void mod_zspage_inuse(struct page
 
 	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
 
-	m = (struct zs_meta *)&first_page->mapping;
+	m = (struct zs_meta *)&first_page->freelist;
 	m->inuse += val;
 }
 
@@ -449,7 +449,7 @@ static void set_freeobj(struct page *fir
 
 	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
 
-	m = (struct zs_meta *)&first_page->mapping;
+	m = (struct zs_meta *)&first_page->freelist;
 	m->freeobj = idx;
 }
 
@@ -459,7 +459,7 @@ static unsigned long get_freeobj(struct
 
 	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
 
-	m = (struct zs_meta *)&first_page->mapping;
+	m = (struct zs_meta *)&first_page->freelist;
 	return m->freeobj;
 }
 
@@ -471,7 +471,7 @@ static void get_zspage_mapping(struct pa
 
 	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
 
-	m = (struct zs_meta *)&first_page->mapping;
+	m = (struct zs_meta *)&first_page->freelist;
 	*fullness = m->fullness;
 	*class_idx = m->class;
 }
@@ -484,7 +484,7 @@ static void set_zspage_mapping(struct pa
 
 	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
 
-	m = (struct zs_meta *)&first_page->mapping;
+	m = (struct zs_meta *)&first_page->freelist;
 	m->fullness = fullness;
 	m->class = class_idx;
 }
@@ -946,7 +946,6 @@ static void reset_page(struct page *page
 	clear_bit(PG_private, &page->flags);
 	clear_bit(PG_private_2, &page->flags);
 	set_page_private(page, 0);
-	page->mapping = NULL;
 	page->freelist = NULL;
 }
 
@@ -1056,6 +1055,7 @@ static struct page *alloc_zspage(struct
 
 		INIT_LIST_HEAD(&page->lru);
 		if (i == 0) {	/* first page */
+			page->freelist = NULL;
 			SetPagePrivate(page);
 			set_page_private(page, 0);
 			first_page = page;
@@ -2068,9 +2068,9 @@ static int __init zs_init(void)
 
 	/*
 	 * A zspage's a free object index, class index, fullness group,
-	 * inuse object count are encoded in its (first)page->mapping
+	 * inuse object count are encoded in its (first)page->freelist
 	 * so sizeof(struct zs_meta) should be less than
-	 * sizeof(page->mapping(i.e., unsigned long)).
+	 * sizeof(page->freelist(i.e., void *)).
 	 */
 	BUILD_BUG_ON(sizeof(struct zs_meta) > sizeof(unsigned long));
 
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-vmscan-reclaim-highmem-zone-if-buffer_heads-is-over-limit.patch
mm-call-swap_slot_free_notify-with-holding-page-lock.patch
mm-hwpoison-fix-wrong-num_poisoned_pages-account.patch
zsmalloc-use-first_page-rather-than-page.patch
zsmalloc-clean-up-many-bug_on.patch
zsmalloc-reordering-function-parameter.patch
zsmalloc-remove-unused-pool-param-in-obj_free.patch
zsmalloc-factor-page-chain-functionality-out.patch
zsmalloc-separate-free_zspage-from-putback_zspage.patch
zsmalloc-zs_compact-refactoring.patch
zsmalloc-migrate-head-page-of-zspage.patch
zsmalloc-use-single-linked-list-for-page-chain.patch
zsmalloc-migrate-tail-pages-in-zspage.patch
zram-use-__gfp_movable-for-memory-allocation.patch

