From: akpm@linux-foundation.org
Subject: - slob-reduce-external-fragmentation-by-using-three-free-lists.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:32:44 -0800
Message-ID: <200802052232.m15MWP6x012325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49013 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762309AbYBEWlO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     slob: reduce external fragmentation by using three free lists
has been removed from the -mm tree.  Its filename was
     slob-reduce-external-fragmentation-by-using-three-free-lists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slob: reduce external fragmentation by using three free lists
From: Matt Mackall <mpm@selenic.com>

By putting smaller objects on their own list, we greatly reduce overall
external fragmentation and increase repeatability.  This reduces total SLOB
overhead from > 50% to ~6% on a simple boot test.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slob.c |   47 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff -puN mm/slob.c~slob-reduce-external-fragmentation-by-using-three-free-lists mm/slob.c
--- a/mm/slob.c~slob-reduce-external-fragmentation-by-using-three-free-lists
+++ a/mm/slob.c
@@ -12,10 +12,17 @@
  * allocator is as little as 2 bytes, however typically most architectures
  * will require 4 bytes on 32-bit and 8 bytes on 64-bit.
  *
- * The slob heap is a linked list of pages from alloc_pages(), and
- * within each page, there is a singly-linked list of free blocks (slob_t).
- * The heap is grown on demand and allocation from the heap is currently
- * first-fit.
+ * The slob heap is a set of linked list of pages from alloc_pages(),
+ * and within each page, there is a singly-linked list of free blocks
+ * (slob_t). The heap is grown on demand. To reduce fragmentation,
+ * heap pages are segregated into three lists, with objects less than
+ * 256 bytes, objects less than 1024 bytes, and all other objects.
+ *
+ * Allocation from heap involves first searching for a page with
+ * sufficient free blocks (using a next-fit-like approach) followed by
+ * a first-fit scan of the page. Deallocation inserts objects back
+ * into the free list in address order, so this is effectively an
+ * address-ordered first fit.
  *
  * Above this is an implementation of kmalloc/kfree. Blocks returned
  * from kmalloc are prepended with a 4-byte header with the kmalloc size.
@@ -110,9 +117,13 @@ static inline void free_slob_page(struct
 }
 
 /*
- * All (partially) free slob pages go on this list.
+ * All partially free slob pages go on these lists.
  */
-static LIST_HEAD(free_slob_pages);
+#define SLOB_BREAK1 256
+#define SLOB_BREAK2 1024
+static LIST_HEAD(free_slob_small);
+static LIST_HEAD(free_slob_medium);
+static LIST_HEAD(free_slob_large);
 
 /*
  * slob_page: True for all slob pages (false for bigblock pages)
@@ -140,9 +151,9 @@ static inline int slob_page_free(struct 
 	return test_bit(PG_private, &sp->flags);
 }
 
-static inline void set_slob_page_free(struct slob_page *sp)
+static void set_slob_page_free(struct slob_page *sp, struct list_head *list)
 {
-	list_add(&sp->list, &free_slob_pages);
+	list_add(&sp->list, list);
 	__set_bit(PG_private, &sp->flags);
 }
 
@@ -294,12 +305,20 @@ static void *slob_alloc(size_t size, gfp
 {
 	struct slob_page *sp;
 	struct list_head *prev;
+	struct list_head *slob_list;
 	slob_t *b = NULL;
 	unsigned long flags;
 
+	if (size < SLOB_BREAK1)
+		slob_list = &free_slob_small;
+	else if (size < SLOB_BREAK2)
+		slob_list = &free_slob_medium;
+	else
+		slob_list = &free_slob_large;
+
 	spin_lock_irqsave(&slob_lock, flags);
 	/* Iterate through each partially free page, try to find room */
-	list_for_each_entry(sp, &free_slob_pages, list) {
+	list_for_each_entry(sp, slob_list, list) {
 #ifdef CONFIG_NUMA
 		/*
 		 * If there's a node specification, search for a partial
@@ -321,9 +340,9 @@ static void *slob_alloc(size_t size, gfp
 		/* Improve fragment distribution and reduce our average
 		 * search time by starting our next search here. (see
 		 * Knuth vol 1, sec 2.5, pg 449) */
-		if (prev != free_slob_pages.prev &&
-				free_slob_pages.next != prev->next)
-			list_move_tail(&free_slob_pages, prev->next);
+		if (prev != slob_list->prev &&
+				slob_list->next != prev->next)
+			list_move_tail(slob_list, prev->next);
 		break;
 	}
 	spin_unlock_irqrestore(&slob_lock, flags);
@@ -341,7 +360,7 @@ static void *slob_alloc(size_t size, gfp
 		sp->free = b;
 		INIT_LIST_HEAD(&sp->list);
 		set_slob(b, SLOB_UNITS(PAGE_SIZE), b + SLOB_UNITS(PAGE_SIZE));
-		set_slob_page_free(sp);
+		set_slob_page_free(sp, slob_list);
 		b = slob_page_alloc(sp, size, align);
 		BUG_ON(!b);
 		spin_unlock_irqrestore(&slob_lock, flags);
@@ -387,7 +406,7 @@ static void slob_free(void *block, int s
 		set_slob(b, units,
 			(void *)((unsigned long)(b +
 					SLOB_UNITS(PAGE_SIZE)) & PAGE_MASK));
-		set_slob_page_free(sp);
+		set_slob_page_free(sp, &free_slob_small);
 		goto out;
 	}
 
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch
drivers-char-randomcwrite_pool-cond_resched-needed.patch
random-clean-up-checkpatch-complaints.patch
random-clean-up-checkpatch-complaints-fix.patch
random-consolidate-wakeup-logic.patch
random-use-unlocked_ioctl.patch
random-reuse-rand_initialize.patch
random-improve-variable-naming-clear-extract-buffer.patch
random-make-backtracking-attacks-harder.patch
random-remove-cacheline-alignment-for-locks.patch
random-eliminate-redundant-new_rotate-variable.patch
random-remove-some-prefetch-logic.patch
random-simplify-add_ptr-logic.patch
random-make-mixing-interface-byte-oriented.patch
random-simplify-and-rename-credit_entropy_store.patch
random-add-async-notification-support-to-dev-random.patch
