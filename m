From: akpm@linux-foundation.org
Subject: + mmhwpoison-rework-soft-offline-for-in-use-pages.patch
 added to -mm tree
Date: Wed, 24 Jun 2020 12:19:47 -0700
Message-ID: <20200624191947.WO4Iu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405057AbgFXTTt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 15:19:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zeil@yandex-team.ru, tony.luck@intel.com, naoya.horiguchi@nec.com, mike.kravetz@oracle.com, mhocko@kernel.org, david@redhat.com, dave.hansen@intel.com, aneesh.kumar@linux.vnet.ibm.com, aneesh.kumar@linux.ibm.com, osalvador@suse.de


The patch titled
     Subject: mm,hwpoison: rework soft offline for in-use pages
has been added to the -mm tree.  Its filename is
     mmhwpoison-rework-soft-offline-for-in-use-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-rework-soft-offline-for-in-use-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-rework-soft-offline-for-in-use-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: rework soft offline for in-use pages

This patch changes the way we set and handle in-use poisoned pages.  Until
now, poisoned pages were released to the buddy allocator, trusting that
the checks that take place prior to hand the page would act as a safe net
and would skip that page.

This has proved to be wrong, as we got some pfn walkers out there, like
compaction, that all they care is the page to be PageBuddy and be in a
freelist.

Although this might not be the only user, having poisoned pages in the
buddy allocator seems a bad idea as we should only have free pages that
are ready and meant to be used as such.

Before explaining the taken approach, let us break down the kind of pages
we can soft offline.

- Anonymous THP (after the split, they end up being 4K pages)
- Hugetlb
- Order-0 pages (that can be either migrated or invalited)

* Normal pages (order-0 and anon-THP)

  - If they are clean and unmapped page cache pages, we invalidate
    then by means of invalidate_inode_page().
  - If they are mapped/dirty, we do the isolate-and-migrate dance.

  Either way, do not call put_page directly from those paths.
  Instead, we keep the page and send it to page_set_poison to perform the
  right handling.

  page_set_poison sets the HWPoison flag and does the last put_page.
  This call to put_page is mainly to be able to call __page_cache_release,
  since this function is not exported.

  Down the chain, we placed a check for HWPoison page in
  free_pages_prepare, that just skips any poisoned page, so those pages
  do not end up in any pcplist/freelist.

  After that, we set the refcount on the page to 1 and we increment
  the poisoned pages counter.

  We could do as we do for free pages:
  1) wait until the page hits buddy's freelists
  2) take it off
  3) flag it

  The problem is that we could race with an allocation, so by the time we
  want to take the page off the buddy, the page is already allocated, so we
  cannot soft-offline it.
  This is not fatal of course, but if it is better if we can close the race
  as does not require a lot of code.

* Hugetlb pages

  - We isolate-and-migrate them

  After the migration has been successful, we call dissolve_free_huge_page,
  and we set HWPoison on the page if we succeed.
  Hugetlb has a slightly different handling though.

  While for non-hugetlb pages we cared about closing the race with an
  allocation, doing so for hugetlb pages requires quite some additional
  code (we would need to hook in free_huge_page and some other places).
  So I decided to not make the code overly complicated and just fail
  normally if the page we allocated in the meantime.

Because of the way we handle now in-use pages, we no longer need the
put-as-isolation-migratetype dance, that was guarding for poisoned pages
to end up in pcplists.

Link: http://lkml.kernel.org/r/20200624150137.7052-13-nao.horiguchi@gmail.com
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    5 ---
 mm/memory-failure.c        |   44 +++++++++++------------------------
 mm/migrate.c               |   11 ++------
 mm/page_alloc.c            |   31 ++----------------------
 4 files changed, 21 insertions(+), 70 deletions(-)

--- a/include/linux/page-flags.h~mmhwpoison-rework-soft-offline-for-in-use-pages
+++ a/include/linux/page-flags.h
@@ -422,14 +422,9 @@ PAGEFLAG_FALSE(Uncached)
 PAGEFLAG(HWPoison, hwpoison, PF_ANY)
 TESTSCFLAG(HWPoison, hwpoison, PF_ANY)
 #define __PG_HWPOISON (1UL << PG_hwpoison)
-extern bool set_hwpoison_free_buddy_page(struct page *page);
 extern bool take_page_off_buddy(struct page *page);
 #else
 PAGEFLAG_FALSE(HWPoison)
-static inline bool set_hwpoison_free_buddy_page(struct page *page)
-{
-	return 0;
-}
 #define __PG_HWPOISON 0
 #endif
 
--- a/mm/memory-failure.c~mmhwpoison-rework-soft-offline-for-in-use-pages
+++ a/mm/memory-failure.c
@@ -78,9 +78,12 @@ EXPORT_SYMBOL_GPL(hwpoison_filter_dev_mi
 EXPORT_SYMBOL_GPL(hwpoison_filter_flags_mask);
 EXPORT_SYMBOL_GPL(hwpoison_filter_flags_value);
 
-static void page_handle_poison(struct page *page)
+static void page_handle_poison(struct page *page, bool release)
 {
+
 	SetPageHWPoison(page);
+	if (release)
+		put_page(page);
 	page_ref_inc(page);
 	num_poisoned_pages_inc();
 }
@@ -1757,19 +1760,13 @@ static int soft_offline_huge_page(struct
 			ret = -EIO;
 	} else {
 		/*
-		 * We set PG_hwpoison only when the migration source hugepage
-		 * was successfully dissolved, because otherwise hwpoisoned
-		 * hugepage remains on free hugepage list, then userspace will
-		 * find it as SIGBUS by allocation failure. That's not expected
-		 * in soft-offlining.
+		 * We set PG_hwpoison only when we were able to take the page
+		 * off the buddy.
 		 */
-		ret = dissolve_free_huge_page(page);
-		if (!ret) {
-			if (set_hwpoison_free_buddy_page(page))
-				num_poisoned_pages_inc();
-			else
-				ret = -EBUSY;
-		}
+		if (!dissolve_free_huge_page(page) && take_page_off_buddy(page))
+			page_handle_poison(page, false);
+		else
+			ret = -EBUSY;
 	}
 	return ret;
 }
@@ -1804,10 +1801,8 @@ static int __soft_offline_page(struct pa
 	 * would need to fix isolation locking first.
 	 */
 	if (ret == 1) {
-		put_page(page);
 		pr_info("soft_offline: %#lx: invalidated\n", pfn);
-		SetPageHWPoison(page);
-		num_poisoned_pages_inc();
+		page_handle_poison(page, true);
 		return 0;
 	}
 
@@ -1838,7 +1833,9 @@ static int __soft_offline_page(struct pa
 		list_add(&page->lru, &pagelist);
 		ret = migrate_pages(&pagelist, new_page, NULL, MPOL_MF_MOVE_ALL,
 					MIGRATE_SYNC, MR_MEMORY_FAILURE);
-		if (ret) {
+		if (!ret) {
+			page_handle_poison(page, true);
+		} else {
 			if (!list_empty(&pagelist))
 				putback_movable_pages(&pagelist);
 
@@ -1857,27 +1854,16 @@ static int __soft_offline_page(struct pa
 static int soft_offline_in_use_page(struct page *page)
 {
 	int ret;
-	int mt;
 	struct page *hpage = compound_head(page);
 
 	if (!PageHuge(page) && PageTransHuge(hpage))
 		if (try_to_split_thp_page(page, "soft offline") < 0)
 			return -EBUSY;
 
-	/*
-	 * Setting MIGRATE_ISOLATE here ensures that the page will be linked
-	 * to free list immediately (not via pcplist) when released after
-	 * successful page migration. Otherwise we can't guarantee that the
-	 * page is really free after put_page() returns, so
-	 * set_hwpoison_free_buddy_page() highly likely fails.
-	 */
-	mt = get_pageblock_migratetype(page);
-	set_pageblock_migratetype(page, MIGRATE_ISOLATE);
 	if (PageHuge(page))
 		ret = soft_offline_huge_page(page);
 	else
 		ret = __soft_offline_page(page);
-	set_pageblock_migratetype(page, mt);
 	return ret;
 }
 
@@ -1886,7 +1872,7 @@ static int soft_offline_free_page(struct
 	int rc = -EBUSY;
 
 	if (!dissolve_free_huge_page(page) && take_page_off_buddy(page)) {
-		page_handle_poison(page);
+		page_handle_poison(page, false);
 		rc = 0;
 	}
 
--- a/mm/migrate.c~mmhwpoison-rework-soft-offline-for-in-use-pages
+++ a/mm/migrate.c
@@ -1255,16 +1255,11 @@ out:
 		 */
 		if (newpage && PageTransHuge(newpage))
 			thp_pmd_migration_success(true);
-		put_page(page);
-		if (reason == MR_MEMORY_FAILURE) {
+		if (reason != MR_MEMORY_FAILURE)
 			/*
-			 * Set PG_HWPoison on just freed page
-			 * intentionally. Although it's rather weird,
-			 * it's how HWPoison flag works at the moment.
+			 * We release the page in page_handle_poison.
 			 */
-			if (set_hwpoison_free_buddy_page(page))
-				num_poisoned_pages_inc();
-		}
+			put_page(page);
 	} else {
 		if (rc != -EAGAIN) {
 			if (likely(!__PageMovable(page))) {
--- a/mm/page_alloc.c~mmhwpoison-rework-soft-offline-for-in-use-pages
+++ a/mm/page_alloc.c
@@ -1175,6 +1175,9 @@ static __always_inline bool free_pages_p
 
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
+	if (unlikely(PageHWPoison(page)) && !order)
+		return false;
+
 	trace_mm_page_free(page, order);
 
 	/*
@@ -8848,32 +8851,4 @@ bool take_page_off_buddy(struct page *pa
 	spin_unlock_irqrestore(&zone->lock, flags);
 	return ret;
 }
-
-/*
- * Set PG_hwpoison flag if a given page is confirmed to be a free page.  This
- * test is performed under the zone lock to prevent a race against page
- * allocation.
- */
-bool set_hwpoison_free_buddy_page(struct page *page)
-{
-	struct zone *zone = page_zone(page);
-	unsigned long pfn = page_to_pfn(page);
-	unsigned long flags;
-	unsigned int order;
-	bool hwpoisoned = false;
-
-	spin_lock_irqsave(&zone->lock, flags);
-	for (order = 0; order < MAX_ORDER; order++) {
-		struct page *page_head = page - (pfn & ((1 << order) - 1));
-
-		if (PageBuddy(page_head) && page_order(page_head) >= order) {
-			if (!TestSetPageHWPoison(page))
-				hwpoisoned = true;
-			break;
-		}
-	}
-	spin_unlock_irqrestore(&zone->lock, flags);
