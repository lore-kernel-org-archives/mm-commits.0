From: akpm@linux-foundation.org
Subject: - swsusp-use-inline-functions-for-changing-page-flags.patch removed from -mm tree
Date: Mon, 19 Mar 2007 17:29:56 -0700
Message-ID: <200703200031.l2K0Vrm2021926@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36526 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030797AbXCTAcF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Mar 2007 20:32:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: use inline functions for changing page flags
has been removed from the -mm tree.  Its filename was
     swsusp-use-inline-functions-for-changing-page-flags.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: swsusp: use inline functions for changing page flags
From: Rafael J. Wysocki <rjw@sisk.pl>

Replace direct invocations of SetPageNosave(), SetPageNosaveFree() etc.  with
calls to inline functions that can be changed in subsequent patches without
modifying the code calling them.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/suspend.h |   33 ++++++++++++++++++++++++++
 kernel/power/snapshot.c |   48 +++++++++++++++++++-------------------
 mm/page_alloc.c         |    6 ++--
 3 files changed, 61 insertions(+), 26 deletions(-)

diff -puN include/linux/suspend.h~swsusp-use-inline-functions-for-changing-page-flags include/linux/suspend.h
--- a/include/linux/suspend.h~swsusp-use-inline-functions-for-changing-page-flags
+++ a/include/linux/suspend.h
@@ -8,6 +8,7 @@
 #include <linux/notifier.h>
 #include <linux/init.h>
 #include <linux/pm.h>
+#include <linux/mm.h>
 
 /* struct pbe is used for creating lists of pages that should be restored
  * atomically during the resume from disk, because the page frames they have
@@ -49,6 +50,38 @@ void __save_processor_state(struct saved
 void __restore_processor_state(struct saved_context *ctxt);
 unsigned long get_safe_page(gfp_t gfp_mask);
 
+/* Page management functions for the software suspend (swsusp) */
+
+static inline void swsusp_set_page_forbidden(struct page *page)
+{
+	SetPageNosave(page);
+}
+
+static inline int swsusp_page_is_forbidden(struct page *page)
+{
+	return PageNosave(page);
+}
+
+static inline void swsusp_unset_page_forbidden(struct page *page)
+{
+	ClearPageNosave(page);
+}
+
+static inline void swsusp_set_page_free(struct page *page)
+{
+	SetPageNosaveFree(page);
+}
+
+static inline int swsusp_page_is_free(struct page *page)
+{
+	return PageNosaveFree(page);
+}
+
+static inline void swsusp_unset_page_free(struct page *page)
+{
+	ClearPageNosaveFree(page);
+}
+
 /*
  * XXX: We try to keep some more pages free so that I/O operations succeed
  * without paging. Might this be more?
diff -puN kernel/power/snapshot.c~swsusp-use-inline-functions-for-changing-page-flags kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~swsusp-use-inline-functions-for-changing-page-flags
+++ a/kernel/power/snapshot.c
@@ -67,15 +67,15 @@ static void *get_image_page(gfp_t gfp_ma
 
 	res = (void *)get_zeroed_page(gfp_mask);
 	if (safe_needed)
-		while (res && PageNosaveFree(virt_to_page(res))) {
+		while (res && swsusp_page_is_free(virt_to_page(res))) {
 			/* The page is unsafe, mark it for swsusp_free() */
-			SetPageNosave(virt_to_page(res));
+			swsusp_set_page_forbidden(virt_to_page(res));
 			allocated_unsafe_pages++;
 			res = (void *)get_zeroed_page(gfp_mask);
 		}
 	if (res) {
-		SetPageNosave(virt_to_page(res));
-		SetPageNosaveFree(virt_to_page(res));
+		swsusp_set_page_forbidden(virt_to_page(res));
+		swsusp_set_page_free(virt_to_page(res));
 	}
 	return res;
 }
@@ -91,8 +91,8 @@ static struct page *alloc_image_page(gfp
 
 	page = alloc_page(gfp_mask);
 	if (page) {
-		SetPageNosave(page);
-		SetPageNosaveFree(page);
+		swsusp_set_page_forbidden(page);
+		swsusp_set_page_free(page);
 	}
 	return page;
 }
@@ -110,9 +110,9 @@ static inline void free_image_page(void 
 
 	page = virt_to_page(addr);
 
-	ClearPageNosave(page);
+	swsusp_unset_page_forbidden(page);
 	if (clear_nosave_free)
-		ClearPageNosaveFree(page);
+		swsusp_unset_page_free(page);
 
 	__free_page(page);
 }
@@ -615,7 +615,8 @@ static struct page *saveable_highmem_pag
 
 	BUG_ON(!PageHighMem(page));
 
-	if (PageNosave(page) || PageReserved(page) || PageNosaveFree(page))
+	if (swsusp_page_is_forbidden(page) ||  swsusp_page_is_free(page) ||
+	    PageReserved(page))
 		return NULL;
 
 	return page;
@@ -681,7 +682,7 @@ static struct page *saveable_page(unsign
 
 	BUG_ON(PageHighMem(page));
 
-	if (PageNosave(page) || PageNosaveFree(page))
+	if (swsusp_page_is_forbidden(page) || swsusp_page_is_free(page))
 		return NULL;
 
 	if (PageReserved(page) && pfn_is_nosave(pfn))
@@ -821,9 +822,10 @@ void swsusp_free(void)
 			if (pfn_valid(pfn)) {
 				struct page *page = pfn_to_page(pfn);
 
-				if (PageNosave(page) && PageNosaveFree(page)) {
-					ClearPageNosave(page);
-					ClearPageNosaveFree(page);
+				if (swsusp_page_is_forbidden(page) &&
+				    swsusp_page_is_free(page)) {
+					swsusp_unset_page_forbidden(page);
+					swsusp_unset_page_free(page);
 					__free_page(page);
 				}
 			}
@@ -1146,7 +1148,7 @@ static int mark_unsafe_pages(struct memo
 		max_zone_pfn = zone->zone_start_pfn + zone->spanned_pages;
 		for (pfn = zone->zone_start_pfn; pfn < max_zone_pfn; pfn++)
 			if (pfn_valid(pfn))
-				ClearPageNosaveFree(pfn_to_page(pfn));
+				swsusp_unset_page_free(pfn_to_page(pfn));
 	}
 
 	/* Mark pages that correspond to the "original" pfns as "unsafe" */
@@ -1155,7 +1157,7 @@ static int mark_unsafe_pages(struct memo
 		pfn = memory_bm_next_pfn(bm);
 		if (likely(pfn != BM_END_OF_MAP)) {
 			if (likely(pfn_valid(pfn)))
-				SetPageNosaveFree(pfn_to_page(pfn));
+				swsusp_set_page_free(pfn_to_page(pfn));
 			else
 				return -EFAULT;
 		}
@@ -1321,14 +1323,14 @@ prepare_highmem_image(struct memory_bitm
 		struct page *page;
 
 		page = alloc_page(__GFP_HIGHMEM);
-		if (!PageNosaveFree(page)) {
+		if (!swsusp_page_is_free(page)) {
 			/* The page is "safe", set its bit the bitmap */
 			memory_bm_set_bit(bm, page_to_pfn(page));
 			safe_highmem_pages++;
 		}
 		/* Mark the page as allocated */
-		SetPageNosave(page);
-		SetPageNosaveFree(page);
+		swsusp_set_page_forbidden(page);
+		swsusp_set_page_free(page);
 	}
 	memory_bm_position_reset(bm);
 	safe_highmem_bm = bm;
@@ -1360,7 +1362,7 @@ get_highmem_page_buffer(struct page *pag
 	struct highmem_pbe *pbe;
 	void *kaddr;
 
-	if (PageNosave(page) && PageNosaveFree(page)) {
+	if (swsusp_page_is_forbidden(page) && swsusp_page_is_free(page)) {
 		/* We have allocated the "original" page frame and we can
 		 * use it directly to store the loaded page.
 		 */
@@ -1522,14 +1524,14 @@ prepare_image(struct memory_bitmap *new_
 			error = -ENOMEM;
 			goto Free;
 		}
-		if (!PageNosaveFree(virt_to_page(lp))) {
+		if (!swsusp_page_is_free(virt_to_page(lp))) {
 			/* The page is "safe", add it to the list */
 			lp->next = safe_pages_list;
 			safe_pages_list = lp;
 		}
 		/* Mark the page as allocated */
-		SetPageNosave(virt_to_page(lp));
-		SetPageNosaveFree(virt_to_page(lp));
+		swsusp_set_page_forbidden(virt_to_page(lp));
+		swsusp_set_page_free(virt_to_page(lp));
 		nr_pages--;
 	}
 	/* Free the reserved safe pages so that chain_alloc() can use them */
@@ -1558,7 +1560,7 @@ static void *get_buffer(struct memory_bi
 	if (PageHighMem(page))
 		return get_highmem_page_buffer(page, ca);
 
-	if (PageNosave(page) && PageNosaveFree(page))
+	if (swsusp_page_is_forbidden(page) && swsusp_page_is_free(page))
 		/* We have allocated the "original" page frame and we can
 		 * use it directly to store the loaded page.
 		 */
diff -puN mm/page_alloc.c~swsusp-use-inline-functions-for-changing-page-flags mm/page_alloc.c
--- a/mm/page_alloc.c~swsusp-use-inline-functions-for-changing-page-flags
+++ a/mm/page_alloc.c
@@ -1016,8 +1016,8 @@ void mark_free_pages(struct zone *zone)
 		if (pfn_valid(pfn)) {
 			struct page *page = pfn_to_page(pfn);
 
-			if (!PageNosave(page))
-				ClearPageNosaveFree(page);
+			if (!swsusp_page_is_forbidden(page))
+				swsusp_unset_page_free(page);
 		}
 
 	for_each_migratetype_order(order, t) {
@@ -1026,7 +1026,7 @@ void mark_free_pages(struct zone *zone)
 
 			pfn = page_to_pfn(list_entry(curr, struct page, lru));
 			for (i = 0; i < (1UL << order); i++)
-				SetPageNosaveFree(pfn_to_page(pfn + i));
+				swsusp_set_page_free(pfn_to_page(pfn + i));
 		}
 	}
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
make-xfs-workqueues-nonfreezable.patch
swsusp-use-inline-functions-for-changing-page-flags.patch
swsusp-do-not-use-page-flags.patch
mm-remove-unused-page-flags.patch
fix-refrigerator-vs-thaw_process-race.patch
swsusp-fix-error-paths-in-snapshot_open.patch
swsusp-use-gfp_kernel-for-creating-basic-data-structures.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
shrink_slab-handle-bad-shrinkers.patch
