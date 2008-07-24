From: akpm@linux-foundation.org
Subject: - slub-record-page-flag-overlays-explicitly.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:22:07 -0700
Message-ID: <200807242322.m6ONM7aT010540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754144AbYGXXX3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:23:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, cl@linux-foundation.org, jeremy@goop.org, kosaki.motohiro@jp.fujitsu.com, mpm@selenic.com, nickpiggin@yahoo.com.au, penberg@cs.helsinki.fi, riel@redhat.com, mm-commi


The patch titled
     slub: record page flag overlays explicitly
has been removed from the -mm tree.  Its filename was
     slub-record-page-flag-overlays-explicitly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slub: record page flag overlays explicitly
From: Andy Whitcroft <apw@shadowen.org>

SLUB reuses two page bits for internal purposes, it overlays PG_active and
PG_error.  This is hidden away in slub.c.  Document these overlays
explicitly in the main page-flags enum along with all the others.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    7 +++
 mm/slub.c                  |   65 +++++++++--------------------------
 2 files changed, 24 insertions(+), 48 deletions(-)

diff -puN include/linux/page-flags.h~slub-record-page-flag-overlays-explicitly include/linux/page-flags.h
--- a/include/linux/page-flags.h~slub-record-page-flag-overlays-explicitly
+++ a/include/linux/page-flags.h
@@ -104,6 +104,10 @@ enum pageflags {
 	/* XEN */
 	PG_pinned = PG_owner_priv_1,
 	PG_savepinned = PG_dirty,
+
+	/* SLUB */
+	PG_slub_frozen = PG_active,
+	PG_slub_debug = PG_error,
 };
 
 #ifndef __GENERATING_BOUNDS_H
@@ -169,6 +173,9 @@ PAGEFLAG(Reserved, reserved) __CLEARPAGE
 PAGEFLAG(Private, private) __CLEARPAGEFLAG(Private, private)
 	__SETPAGEFLAG(Private, private)
 
+__PAGEFLAG(SlubFrozen, slub_frozen)
+__PAGEFLAG(SlubDebug, slub_debug)
+
 /*
  * Only test-and-set exist for PG_writeback.  The unconditional operators are
  * risky: they bypass page accounting.
diff -puN mm/slub.c~slub-record-page-flag-overlays-explicitly mm/slub.c
--- a/mm/slub.c~slub-record-page-flag-overlays-explicitly
+++ a/mm/slub.c
@@ -102,44 +102,12 @@
  * 			the fast path and disables lockless freelists.
  */
 
-#define FROZEN (1 << PG_active)
-
 #ifdef CONFIG_SLUB_DEBUG
-#define SLABDEBUG (1 << PG_error)
+#define SLABDEBUG 1
 #else
 #define SLABDEBUG 0
 #endif
 
-static inline int SlabFrozen(struct page *page)
-{
-	return page->flags & FROZEN;
-}
-
-static inline void SetSlabFrozen(struct page *page)
-{
-	page->flags |= FROZEN;
-}
-
-static inline void ClearSlabFrozen(struct page *page)
-{
-	page->flags &= ~FROZEN;
-}
-
-static inline int SlabDebug(struct page *page)
-{
-	return page->flags & SLABDEBUG;
-}
-
-static inline void SetSlabDebug(struct page *page)
-{
-	page->flags |= SLABDEBUG;
-}
-
-static inline void ClearSlabDebug(struct page *page)
-{
-	page->flags &= ~SLABDEBUG;
-}
-
 /*
  * Issues still to be resolved:
  *
@@ -971,7 +939,7 @@ static int free_debug_processing(struct 
 	}
 
 	/* Special debug activities for freeing objects */
-	if (!SlabFrozen(page) && !page->freelist)
+	if (!PageSlubFrozen(page) && !page->freelist)
 		remove_full(s, page);
 	if (s->flags & SLAB_STORE_USER)
 		set_track(s, object, TRACK_FREE, addr);
@@ -1157,7 +1125,7 @@ static struct page *new_slab(struct kmem
 	page->flags |= 1 << PG_slab;
 	if (s->flags & (SLAB_DEBUG_FREE | SLAB_RED_ZONE | SLAB_POISON |
 			SLAB_STORE_USER | SLAB_TRACE))
-		SetSlabDebug(page);
+		__SetPageSlubDebug(page);
 
 	start = page_address(page);
 
@@ -1184,14 +1152,14 @@ static void __free_slab(struct kmem_cach
 	int order = compound_order(page);
 	int pages = 1 << order;
 
-	if (unlikely(SlabDebug(page))) {
+	if (unlikely(SLABDEBUG && PageSlubDebug(page))) {
 		void *p;
 
 		slab_pad_check(s, page);
 		for_each_object(p, s, page_address(page),
 						page->objects)
 			check_object(s, page, p, 0);
-		ClearSlabDebug(page);
+		__ClearPageSlubDebug(page);
 	}
 
 	mod_zone_page_state(page_zone(page),
@@ -1288,7 +1256,7 @@ static inline int lock_and_freeze_slab(s
 	if (slab_trylock(page)) {
 		list_del(&page->lru);
 		n->nr_partial--;
-		SetSlabFrozen(page);
+		__SetPageSlubFrozen(page);
 		return 1;
 	}
 	return 0;
@@ -1398,7 +1366,7 @@ static void unfreeze_slab(struct kmem_ca
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
 	struct kmem_cache_cpu *c = get_cpu_slab(s, smp_processor_id());
 
-	ClearSlabFrozen(page);
+	__ClearPageSlubFrozen(page);
 	if (page->inuse) {
 
 		if (page->freelist) {
@@ -1406,7 +1374,8 @@ static void unfreeze_slab(struct kmem_ca
 			stat(c, tail ? DEACTIVATE_TO_TAIL : DEACTIVATE_TO_HEAD);
 		} else {
 			stat(c, DEACTIVATE_FULL);
-			if (SlabDebug(page) && (s->flags & SLAB_STORE_USER))
+			if (SLABDEBUG && PageSlubDebug(page) &&
+						(s->flags & SLAB_STORE_USER))
 				add_full(n, page);
 		}
 		slab_unlock(page);
@@ -1551,7 +1520,7 @@ load_freelist:
 	object = c->page->freelist;
 	if (unlikely(!object))
 		goto another_slab;
-	if (unlikely(SlabDebug(c->page)))
+	if (unlikely(SLABDEBUG && PageSlubDebug(c->page)))
 		goto debug;
 
 	c->freelist = object[c->offset];
@@ -1588,7 +1557,7 @@ new_slab:
 		if (c->page)
 			flush_slab(s, c);
 		slab_lock(new);
-		SetSlabFrozen(new);
+		__SetPageSlubFrozen(new);
 		c->page = new;
 		goto load_freelist;
 	}
@@ -1674,7 +1643,7 @@ static void __slab_free(struct kmem_cach
 	stat(c, FREE_SLOWPATH);
 	slab_lock(page);
 
-	if (unlikely(SlabDebug(page)))
+	if (unlikely(SLABDEBUG && PageSlubDebug(page)))
 		goto debug;
 
 checks_ok:
@@ -1682,7 +1651,7 @@ checks_ok:
 	page->freelist = object;
 	page->inuse--;
 
-	if (unlikely(SlabFrozen(page))) {
+	if (unlikely(PageSlubFrozen(page))) {
 		stat(c, FREE_FROZEN);
 		goto out_unlock;
 	}
@@ -3317,12 +3286,12 @@ static void validate_slab_slab(struct km
 			s->name, page);
 
 	if (s->flags & DEBUG_DEFAULT_FLAGS) {
-		if (!SlabDebug(page))
-			printk(KERN_ERR "SLUB %s: SlabDebug not set "
+		if (!PageSlubDebug(page))
+			printk(KERN_ERR "SLUB %s: SlubDebug not set "
 				"on slab 0x%p\n", s->name, page);
 	} else {
-		if (SlabDebug(page))
-			printk(KERN_ERR "SLUB %s: SlabDebug set on "
+		if (PageSlubDebug(page))
+			printk(KERN_ERR "SLUB %s: SlubDebug set on "
 				"slab 0x%p\n", s->name, page);
 	}
 }
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
x86-implement-pte_special.patch
x86-implement-pte_special-fix.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
page-owner-tracking-leak-detector.patch

