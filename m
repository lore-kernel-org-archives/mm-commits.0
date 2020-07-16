Return-Path: <SRS0=YRC/=A3=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF72BC433E1
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 21:46:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BF72207DD
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 21:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594935983;
	bh=N+QqXcozjy8Yo16XwEjK0RFYM91Q3FyCXbUVz2VHYVo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=kb63Ta+eV9eHDr0aAViyMmGUEWzKc95RuK0wtFmrChQXOLV4mJaxgj4XDWR+huo3P
	 OrGxpzND/WKfPcUqcpk1h2scIhtmFkzi1Gl0zWeysEu8e7w7Rmf5CQwoF7af6GJja1
	 Es4hoFO7XfHf15dVD8ZWdhdaTZT2MODQwvciFYXU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgGPVqX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jul 2020 17:46:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbgGPVqX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Jul 2020 17:46:23 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8991C2076D;
        Thu, 16 Jul 2020 21:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594935982;
        bh=N+QqXcozjy8Yo16XwEjK0RFYM91Q3FyCXbUVz2VHYVo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PpyHDG6fnd/HNqyTr7G2IoBS8JdX5axzCdPnHoxKS9fuOSUcOhtHL/PS2rSLPYmQj
         o6LBkTbGSbAxkHG6FGJxnCNcGIn3Zte0a5r01iXLKxBhe2tSn9BUDLth3lD+QrS1ln
         ygTfPeHBG0b8lNUkJYgHWXEVCgY6qBGb8WQdY+q4=
Date:   Thu, 16 Jul 2020 14:46:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aneesh.kumar@linux.vnet.ibm.com, dave.hansen@intel.com,
        david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        naoya.horiguchi@nec.com, osalvador@suse.com, osalvador@suse.de,
        tony.luck@intel.com, zeil@yandex-team.ru
Subject:  + mmhwpoison-rework-soft-offline-for-in-use-pages.patch
 added to -mm tree
Message-ID: <20200716214620.jESLU42Lg%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


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
the checks that take place prior to deliver the page to its end user would
act as a safe net and would skip that page.

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

  Among other things, page_set_poison() sets the HWPoison flag and does the last
  put_page.
  This call to put_page is mainly to be able to call __page_cache_release,
  since this function is not exported.

  Down the chain, we placed a check for HWPoison page in
  free_pages_prepare, that just skips any poisoned page, so those pages
  do not end up either in a pcplist or in buddy-freelist.

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

  There is no magic in here, we just isolate and migrate them.
  A new set of internal functions have been made to flag a hugetlb page as
  poisoned (SetPageHugePoisoned(), PageHugePoisoned(), ClearPageHugePoisoned())
  This allows us to flag the page when we migrate it, back in
  move_hugetlb_state().
  Later on we check whether the page is poisoned in __free_huge_page,
  and we bail out in that case before sending the page to e.g: active
  free list.
  This gives us full control of the page, and we can handle it
  page_handle_poison().

  In other words, we do not allow migrated hugepages to get back to the
  freelists.

  Since now the page has no user and has been migrated, we can call
  dissolve_free_huge_page, which will end up calling update_and_free_page.
  In update_and_free_page(), we check for the page to be poisoned.
  If it so, we handle it as we handle gigantic pages, i.e: we break down
  the page in order-0 pages and free them one by one.
  Doing so, allows us for free_pages_prepare to skip poisoned pages.

Because of the way we handle now in-use pages, we no longer need the
put-as-isolation-migratetype dance, that was guarding for poisoned pages
to end up in pcplists.

Link: http://lkml.kernel.org/r/20200716123810.25292-13-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.com>
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    5 --
 mm/hugetlb.c               |   60 ++++++++++++++++++++++++++++++-----
 mm/memory-failure.c        |   53 ++++++++++++------------------
 mm/migrate.c               |   11 +-----
 mm/page_alloc.c            |   38 +++++-----------------
 5 files changed, 86 insertions(+), 81 deletions(-)

--- a/include/linux/page-flags.h~mmhwpoison-rework-soft-offline-for-in-use-pages
+++ a/include/linux/page-flags.h
@@ -423,13 +423,8 @@ PAGEFLAG(HWPoison, hwpoison, PF_ANY)
 TESTSCFLAG(HWPoison, hwpoison, PF_ANY)
 #define __PG_HWPOISON (1UL << PG_hwpoison)
 extern bool take_page_off_buddy(struct page *page);
-extern bool set_hwpoison_free_buddy_page(struct page *page);
 #else
 PAGEFLAG_FALSE(HWPoison)
-static inline bool set_hwpoison_free_buddy_page(struct page *page)
-{
-	return 0;
-}
 #define __PG_HWPOISON 0
 #endif
 
--- a/mm/hugetlb.c~mmhwpoison-rework-soft-offline-for-in-use-pages
+++ a/mm/hugetlb.c
@@ -29,6 +29,7 @@
 #include <linux/numa.h>
 #include <linux/llist.h>
 #include <linux/cma.h>
+#include <linux/migrate.h>
 
 #include <asm/page.h>
 #include <asm/pgalloc.h>
@@ -1210,9 +1211,26 @@ static int hstate_next_node_to_free(stru
 		((node = hstate_next_node_to_free(hs, mask)) || 1);	\
 		nr_nodes--)
 
-#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
-static void destroy_compound_gigantic_page(struct page *page,
-					unsigned int order)
+static inline bool PageHugePoisoned(struct page *page)
+{
+	if (!PageHuge(page))
+		return false;
+
+	return (unsigned long)page[3].mapping == -1U;
+}
+
+static inline void SetPageHugePoisoned(struct page *page)
+{
+	page[3].mapping = (void *)-1U;
+}
+
+static inline void ClearPageHugePoisoned(struct page *page)
+{
+	page[3].mapping = NULL;
+}
+
+static void destroy_compound_gigantic_page(struct hstate *h, struct page *page,
+					   unsigned int order)
 {
 	int i;
 	int nr_pages = 1 << order;
@@ -1223,14 +1241,19 @@ static void destroy_compound_gigantic_pa
 		atomic_set(compound_pincount_ptr(page), 0);
 
 	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
+		if (!hstate_is_gigantic(h))
+			 p->mapping = NULL;
 		clear_compound_head(p);
 		set_page_refcounted(p);
 	}
 
+	if (PageHugePoisoned(page))
+		ClearPageHugePoisoned(page);
 	set_compound_order(page, 0);
 	__ClearPageHead(page);
 }
 
+#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
 static void free_gigantic_page(struct page *page, unsigned int order)
 {
 	/*
@@ -1285,13 +1308,16 @@ static struct page *alloc_gigantic_page(
 	return NULL;
 }
 static inline void free_gigantic_page(struct page *page, unsigned int order) { }
-static inline void destroy_compound_gigantic_page(struct page *page,
-						unsigned int order) { }
+static inline void destroy_compound_gigantic_page(struct hstate *h,
+						  struct page *page,
+						  unsigned int order) { }
 #endif
 
 static void update_and_free_page(struct hstate *h, struct page *page)
 {
 	int i;
+	bool poisoned = PageHugePoisoned(page);
+	unsigned int order = huge_page_order(h);
 
 	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
 		return;
@@ -1314,11 +1340,21 @@ static void update_and_free_page(struct
 		 * we might block in free_gigantic_page().
 		 */
 		spin_unlock(&hugetlb_lock);
-		destroy_compound_gigantic_page(page, huge_page_order(h));
-		free_gigantic_page(page, huge_page_order(h));
+		destroy_compound_gigantic_page(h, page, order);
+		free_gigantic_page(page, order);
 		spin_lock(&hugetlb_lock);
 	} else {
-		__free_pages(page, huge_page_order(h));
+		if (unlikely(poisoned)) {
+			/*
+			 * If the hugepage is poisoned, do as we do for
+			 * gigantic pages and free the pages as order-0.
+			 * free_pages_prepare will skip over the poisoned ones.
+			 */
+			destroy_compound_gigantic_page(h, page, order);
+			free_contig_range(page_to_pfn(page), 1 << order);
+		} else {
+			__free_pages(page, huge_page_order(h));
+		}
 	}
 }
 
@@ -1428,6 +1464,11 @@ static void __free_huge_page(struct page
 	if (restore_reserve)
 		h->resv_huge_pages++;
 
+	if (PageHugePoisoned(page)) {
+		spin_unlock(&hugetlb_lock);
+		return;
+	}
+
 	if (PageHugeTemporary(page)) {
 		list_del(&page->lru);
 		ClearPageHugeTemporary(page);
@@ -5629,6 +5670,9 @@ void move_hugetlb_state(struct page *old
 	hugetlb_cgroup_migrate(oldpage, newpage);
 	set_page_owner_migrate_reason(newpage, reason);
 
+	if (reason == MR_MEMORY_FAILURE)
+		SetPageHugePoisoned(oldpage);
+
 	/*
 	 * transfer temporary state of the new huge page. This is
 	 * reverse to other transitions because the newpage is going to
--- a/mm/memory-failure.c~mmhwpoison-rework-soft-offline-for-in-use-pages
+++ a/mm/memory-failure.c
@@ -65,9 +65,17 @@ int sysctl_memory_failure_recovery __rea
 
 atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
-static void page_handle_poison(struct page *page)
+static void page_handle_poison(struct page *page, bool release, bool set_flag,
+			       bool huge_flag)
 {
-	SetPageHWPoison(page);
+	if (set_flag)
+		SetPageHWPoison(page);
+
+        if (huge_flag)
+		dissolve_free_huge_page(page);
+        else if (release)
+		put_page(page);
+
 	page_ref_inc(page);
 	num_poisoned_pages_inc();
 }
@@ -1717,7 +1725,7 @@ static int get_any_page(struct page *pag
 
 static int soft_offline_huge_page(struct page *page)
 {
-	int ret;
+	int ret = -EBUSY;
 	unsigned long pfn = page_to_pfn(page);
 	struct page *hpage = compound_head(page);
 	LIST_HEAD(pagelist);
@@ -1757,19 +1765,12 @@ static int soft_offline_huge_page(struct
 			ret = -EIO;
 	} else {
 		/*
-		 * We set PG_hwpoison only when the migration source hugepage
-		 * was successfully dissolved, because otherwise hwpoisoned
-		 * hugepage remains on free hugepage list, then userspace will
-		 * find it as SIGBUS by allocation failure. That's not expected
-		 * in soft-offlining.
+		 * At this point the page cannot be in-use since we do not
+		 * let the page to go back to hugetlb freelists.
+		 * In that case we just need to dissolve it.
+		 * page_handle_poison will take care of it.
 		 */
-		ret = dissolve_free_huge_page(page);
-		if (!ret) {
-			if (set_hwpoison_free_buddy_page(page))
-				num_poisoned_pages_inc();
-			else
-				ret = -EBUSY;
-		}
+		page_handle_poison(page, true, true, true);
 	}
 	return ret;
 }
@@ -1804,10 +1805,8 @@ static int __soft_offline_page(struct pa
 	 * would need to fix isolation locking first.
 	 */
 	if (ret == 1) {
-		put_page(page);
 		pr_info("soft_offline: %#lx: invalidated\n", pfn);
-		SetPageHWPoison(page);
-		num_poisoned_pages_inc();
+		page_handle_poison(page, true, true, false);
 		return 0;
 	}
 
@@ -1838,7 +1837,9 @@ static int __soft_offline_page(struct pa
 		list_add(&page->lru, &pagelist);
 		ret = migrate_pages(&pagelist, new_page, NULL, MPOL_MF_MOVE_ALL,
 					MIGRATE_SYNC, MR_MEMORY_FAILURE);
-		if (ret) {
+		if (!ret) {
+			page_handle_poison(page, true, true, false);
+		} else {
 			if (!list_empty(&pagelist))
 				putback_movable_pages(&pagelist);
 
@@ -1857,37 +1858,25 @@ static int __soft_offline_page(struct pa
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
 
 static int soft_offline_free_page(struct page *page)
 {
 	int rc = -EBUSY;
-	int rc = dissolve_free_huge_page(page);
 
 	if (!dissolve_free_huge_page(page) && take_page_off_buddy(page)) {
-		page_handle_poison(page);
+		page_handle_poison(page, false, true, false);
 		rc = 0;
 	}
 
--- a/mm/migrate.c~mmhwpoison-rework-soft-offline-for-in-use-pages
+++ a/mm/migrate.c
@@ -1222,16 +1222,11 @@ out:
 	 * we want to retry.
 	 */
 	if (rc == MIGRATEPAGE_SUCCESS) {
-		put_page(page);
-		if (reason == MR_MEMORY_FAILURE) {
+		if (reason != MR_MEMORY_FAILURE)
 			/*
-			 * Set PG_HWPoison on just freed page
-			 * intentionally. Although it's rather weird,
-			 * it's how HWPoison flag works at the moment.
+			 * We handle poisoned pages in page_handle_poison.
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
@@ -1175,6 +1175,16 @@ static __always_inline bool free_pages_p
 
 	trace_mm_page_free(page, order);
 
+	if (unlikely(PageHWPoison(page)) && !order) {
+		/*
+		 * Untie memcg state and reset page's owner
+		 */
+		if (memcg_kmem_enabled() && PageKmemcg(page))
+			__memcg_kmem_uncharge_page(page, order);
+		reset_page_owner(page, order);
+		return false;
+	}
+
 	/*
 	 * Check tail pages before head page information is cleared to
 	 * avoid checking PageCompound for order-0 pages.
@@ -8828,32 +8838,4 @@ bool take_page_off_buddy(struct page *pa
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
-
-	return hwpoisoned;
-}
 #endif
_

Patches currently in -mm which might be from osalvador@suse.de are

mmmadvise-refactor-madvise_inject_error.patch
mmhwpoison-un-export-get_hwpoison_page-and-make-it-static.patch
mmhwpoison-kill-put_hwpoison_page.patch
mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch
mmhwpoison-rework-soft-offline-for-free-pages.patch
mmhwpoison-rework-soft-offline-for-in-use-pages.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page.patch
mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch
mmhwpoison-introduce-mf_msg_unsplit_thp.patch

