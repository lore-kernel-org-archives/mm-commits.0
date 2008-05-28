From: akpm@linux-foundation.org
Subject: + slub-record-page-flag-overlays-explicitly.patch added to -mm tree
Date: Tue, 27 May 2008 22:01:16 -0700
Message-ID: <200805280501.m4S51GFc029964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751971AbYE1FDT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 01:03:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, clameter@sgi.com, jeremy@goop.org, kosaki.motohiro@jp.fujitsu.com, mpm@selenic.com, nickpiggin@yahoo.com.au, penberg@cs.helsinki.fi, riel@redhat.com


The patch titled
     slub: record page flag overlays explicitly
has been added to the -mm tree.  Its filename is
     slub-record-page-flag-overlays-explicitly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slub: record page flag overlays explicitly
From: Andy Whitcroft <apw@shadowen.org>

SLUB reuses two page bits for internal purposes, it overlays PG_active and
PG_error.  This is hidden away in slub.c.  Document these overlays
explicitly in the main page-flags enum along with all the others.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@sgi.com>
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
@@ -103,6 +103,10 @@ enum pageflags {
 
 	/* XEN */
 	PG_pinned = PG_owner_priv_1,
+
+	/* SLUB */
+	PG_slub_frozen = PG_active,
+	PG_slub_debug = PG_error,
 };
 
 #ifndef __GENERATING_BOUNDS_H
@@ -167,6 +171,9 @@ PAGEFLAG(Reserved, reserved) __CLEARPAGE
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
@@ -972,7 +940,7 @@ static int free_debug_processing(struct 
 	}
 
 	/* Special debug activities for freeing objects */
-	if (!SlabFrozen(page) && !page->freelist)
+	if (!PageSlubFrozen(page) && !page->freelist)
 		remove_full(s, page);
 	if (s->flags & SLAB_STORE_USER)
 		set_track(s, object, TRACK_FREE, addr);
@@ -1158,7 +1126,7 @@ static struct page *new_slab(struct kmem
 	page->flags |= 1 << PG_slab;
 	if (s->flags & (SLAB_DEBUG_FREE | SLAB_RED_ZONE | SLAB_POISON |
 			SLAB_STORE_USER | SLAB_TRACE))
-		SetSlabDebug(page);
+		__SetPageSlubDebug(page);
 
 	start = page_address(page);
 
@@ -1185,14 +1153,14 @@ static void __free_slab(struct kmem_cach
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
@@ -1289,7 +1257,7 @@ static inline int lock_and_freeze_slab(s
 	if (slab_trylock(page)) {
 		list_del(&page->lru);
 		n->nr_partial--;
-		SetSlabFrozen(page);
+		__SetPageSlubFrozen(page);
 		return 1;
 	}
 	return 0;
@@ -1399,7 +1367,7 @@ static void unfreeze_slab(struct kmem_ca
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
 	struct kmem_cache_cpu *c = get_cpu_slab(s, smp_processor_id());
 
-	ClearSlabFrozen(page);
+	__ClearPageSlubFrozen(page);
 	if (page->inuse) {
 
 		if (page->freelist) {
@@ -1407,7 +1375,8 @@ static void unfreeze_slab(struct kmem_ca
 			stat(c, tail ? DEACTIVATE_TO_TAIL : DEACTIVATE_TO_HEAD);
 		} else {
 			stat(c, DEACTIVATE_FULL);
-			if (SlabDebug(page) && (s->flags & SLAB_STORE_USER))
+			if (SLABDEBUG && PageSlubDebug(page) &&
+						(s->flags & SLAB_STORE_USER))
 				add_full(n, page);
 		}
 		slab_unlock(page);
@@ -1560,7 +1529,7 @@ load_freelist:
 	object = c->page->freelist;
 	if (unlikely(!object))
 		goto another_slab;
-	if (unlikely(SlabDebug(c->page)))
+	if (unlikely(SLABDEBUG && PageSlubDebug(c->page)))
 		goto debug;
 
 	c->freelist = object[c->offset];
@@ -1597,7 +1566,7 @@ new_slab:
 		if (c->page)
 			flush_slab(s, c);
 		slab_lock(new);
-		SetSlabFrozen(new);
+		__SetPageSlubFrozen(new);
 		c->page = new;
 		goto load_freelist;
 	}
@@ -1681,7 +1650,7 @@ static void __slab_free(struct kmem_cach
 	stat(c, FREE_SLOWPATH);
 	slab_lock(page);
 
-	if (unlikely(SlabDebug(page)))
+	if (unlikely(SLABDEBUG && PageSlubDebug(page)))
 		goto debug;
 
 checks_ok:
@@ -1689,7 +1658,7 @@ checks_ok:
 	page->freelist = object;
 	page->inuse--;
 
-	if (unlikely(SlabFrozen(page))) {
+	if (unlikely(PageSlubFrozen(page))) {
 		stat(c, FREE_FROZEN);
 		goto out_unlock;
 	}
@@ -3315,12 +3284,12 @@ static void validate_slab_slab(struct km
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

linux-next.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
buddy-clarify-comments-describing-buddy-merge.patch
page-flags-record-page-flag-overlays-explicitly.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
update-checkpatchpl-to-version-019.patch
update-checkpatchpl-to-version-019-fix.patch
page-owner-tracking-leak-detector.patch

