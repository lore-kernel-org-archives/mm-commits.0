Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56F8FC43464
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F89B21D7F
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600475072;
	bh=ApJ5X5t7xf631ehhOSyqL78L7xaqxSpBI9Hm5zzKZjc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ixvZxvbIHJcpj2LJAkXu+VTPoQjy/R2q90IQehUBAUREWUJCVv3de3RO/iHikGiwO
	 BZu7T9SggyF9rd5LTPZDJNazOTqCG1Jal30MxyxfL5Q6uwPUjUm6GxlNSum0XWypFC
	 1VIoXGWVJZkg5Ln1O7As0SnLckXzKY8uUMgS4jb4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgISAYb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 20:24:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISAYb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 20:24:31 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CB7321D7B;
        Sat, 19 Sep 2020 00:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600475070;
        bh=ApJ5X5t7xf631ehhOSyqL78L7xaqxSpBI9Hm5zzKZjc=;
        h=Date:From:To:Subject:From;
        b=Y0Ouulq90GkveKN0I3I2PCu7FFpJDO8Y4jRD/aShz2mBFCOOMFjG4nMq+EhMtVLp2
         cu9eCao1aF/GRAi926HAnCBrCP1uLbmIs51VagOvdAyJLw4k3gklG2Kpfwt7EkfSYR
         K1lje7Qm+1/D9a3Am0ckbz/tqyZrtkb939tlBt0w=
Date:   Fri, 18 Sep 2020 17:24:28 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zeil@yandex-team.ru,
        tony.luck@intel.com, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, mhocko@kernel.org, david@redhat.com,
        dave.hansen@intel.com, cai@lca.pw, aneesh.kumar@linux.vnet.ibm.com,
        aneesh.kumar@linux.ibm.com, osalvador@suse.de
Subject:  [to-be-updated]
 mmhwpoison-rework-soft-offline-for-in-use-pages.patch removed from -mm tree
Message-ID: <20200919002428.2yfCV%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: rework soft offline for in-use pages
has been removed from the -mm tree.  Its filename was
     mmhwpoison-rework-soft-offline-for-in-use-pages.patch

This patch was dropped because an updated version will be merged

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

Link: http://lkml.kernel.org/r/20200806184923.7007-9-nao.horiguchi@gmail.com
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    5 ---
 mm/memory-failure.c        |   45 ++++++++++++-----------------------
 mm/migrate.c               |   11 ++------
 mm/page_alloc.c            |   28 ---------------------
 4 files changed, 19 insertions(+), 70 deletions(-)

--- a/include/linux/page-flags.h~mmhwpoison-rework-soft-offline-for-in-use-pages
+++ a/include/linux/page-flags.h
@@ -428,14 +428,9 @@ PAGEFLAG_FALSE(Uncached)
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
@@ -65,8 +65,12 @@ int sysctl_memory_failure_recovery __rea
 
 atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
-static void page_handle_poison(struct page *page)
+static void page_handle_poison(struct page *page, bool release)
 {
+	if (release) {
+		put_page(page);
+		drain_all_pages(page_zone(page));
+	}
 	SetPageHWPoison(page);
 	page_ref_inc(page);
 	num_poisoned_pages_inc();
@@ -1765,19 +1769,13 @@ static int soft_offline_huge_page(struct
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
@@ -1812,10 +1810,8 @@ static int __soft_offline_page(struct pa
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
 
@@ -1846,7 +1842,9 @@ static int __soft_offline_page(struct pa
 		list_add(&page->lru, &pagelist);
 		ret = migrate_pages(&pagelist, new_page, NULL, MPOL_MF_MOVE_ALL,
 					MIGRATE_SYNC, MR_MEMORY_FAILURE);
-		if (ret) {
+		if (!ret) {
+			page_handle_poison(page, true);
+		} else {
 			if (!list_empty(&pagelist))
 				putback_movable_pages(&pagelist);
 
@@ -1865,27 +1863,16 @@ static int __soft_offline_page(struct pa
 static int soft_offline_in_use_page(struct page *page, int flags)
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
 		ret = soft_offline_huge_page(page, flags);
 	else
 		ret = __soft_offline_page(page, flags);
-	set_pageblock_migratetype(page, mt);
 	return ret;
 }
 
@@ -1894,7 +1881,7 @@ static int soft_offline_free_page(struct
 	int rc = -EBUSY;
 
 	if (!dissolve_free_huge_page(page) && take_page_off_buddy(page)) {
-		page_handle_poison(page);
+		page_handle_poison(page, false);
 		rc = 0;
 	}
 
--- a/mm/migrate.c~mmhwpoison-rework-soft-offline-for-in-use-pages
+++ a/mm/migrate.c
@@ -1223,16 +1223,11 @@ out:
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
@@ -8825,32 +8825,4 @@ bool take_page_off_buddy(struct page *pa
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

mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page.patch
mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists.patch
mmhwpoison-refactor-madvise_inject_error.patch
mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page.patch
mmhwpoison-drop-unneeded-pcplist-draining.patch
mmhwpoison-remove-stale-code.patch

