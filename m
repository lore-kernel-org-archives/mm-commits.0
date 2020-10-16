Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E79F0C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96AEA2087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816239;
	bh=x35+Jt55sCkE7cWCeDKAzdwrR2GPt94mgLRx0drHenY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=kdlzfA6EcGrEbcqAnkZYp5h78/8IDWf90lzAMMEJkeBxvJ/+zfDq5/JT9mV6xc4/B
	 1sLE6uLBPnn5ebGaFKmqyN052qKV15Yr1T/JgiGa+9WRVM4r+W1NR449STEyh+pP+k
	 SQ0R3OYEmyrHNcbn6Zr40LUs1/zjRlMRsKAPpnzg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404308AbgJPCn7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:43:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404305AbgJPCn7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:43:59 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0950720B1F;
        Fri, 16 Oct 2020 02:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816237;
        bh=x35+Jt55sCkE7cWCeDKAzdwrR2GPt94mgLRx0drHenY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bfTiRhVbNDut1vz4zhQA6i9OzAMr7ZuO8ducB1homzFt5whtl/onoeBM8LfydsIcn
         s6+RN66KJxh10guS+JDJN3T/0NKvt1I2Q97CVutk1oFHMAB3IRohIORwXH41t8Gzhn
         O+Ul8FMbobPzu7cpMX1jaZy3xrPJVFTvfgh6ed6c=
Date:   Thu, 15 Oct 2020 19:43:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, aris@ruivo.org, cai@lca.pw,
        dave.hansen@intel.com, david@redhat.com, linux-mm@kvack.org,
        mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.com, osalvador@suse.de, tony.luck@intel.com,
        torvalds@linux-foundation.org, zeil@yandex-team.ru
Subject:  [patch 049/156] mm,hwpoison: rework soft offline for
 in-use pages
Message-ID: <20201016024356.uXnJx84h2%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: rework soft offline for in-use pages

This patch changes the way we set and handle in-use poisoned pages.  Until
now, poisoned pages were released to the buddy allocator, trusting that
the checks that take place at allocation time would act as a safe net and
would skip that page.

This has proved to be wrong, as we got some pfn walkers out there, like
compaction, that all they care is the page to be in a buddy freelist.

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

Either way, do not call put_page directly from those paths.  Instead, we
keep the page and send it to page_handle_poison to perform the right
handling.

page_handle_poison sets the HWPoison flag and does the last put_page.

Down the chain, we placed a check for HWPoison page in
free_pages_prepare, that just skips any poisoned page, so those pages
do not end up in any pcplist/freelist.

After that, we set the refcount on the page to 1 and we increment
the poisoned pages counter.

If we see that the check in free_pages_prepare creates trouble, we can
always do what we do for free pages:

  - wait until the page hits buddy's freelists
  - take it off, and flag it

The downside of the above approach is that we could race with an
allocation, so by the time we  want to take the page off the buddy, the
page has been already allocated so we cannot soft offline it.
But the user could always retry it.

* Hugetlb pages

  - We isolate-and-migrate them

After the migration has been successful, we call dissolve_free_huge_page,
and we set HWPoison on the page if we succeed.
Hugetlb has a slightly different handling though.

While for non-hugetlb pages we cared about closing the race with an
allocation, doing so for hugetlb pages requires quite some additional
and intrusive code (we would need to hook in free_huge_page and some other
places).
So I decided to not make the code overly complicated and just fail
normally if the page we allocated in the meantime.

We can always build on top of this.

As a bonus, because of the way we handle now in-use pages, we no longer
need the put-as-isolation-migratetype dance, that was guarding for poisoned
pages to end up in pcplists.

Link: https://lkml.kernel.org/r/20200922135650.1634-10-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Aristeu Rozanski <aris@ruivo.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    5 ----
 mm/memory-failure.c        |   43 +++++++++++------------------------
 mm/migrate.c               |   11 ++------
 mm/page_alloc.c            |   39 ++++++++-----------------------
 4 files changed, 28 insertions(+), 70 deletions(-)

--- a/include/linux/page-flags.h~mmhwpoison-rework-soft-offline-for-in-use-pages
+++ a/include/linux/page-flags.h
@@ -431,14 +431,9 @@ PAGEFLAG_FALSE(Uncached)
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
@@ -65,9 +65,11 @@ int sysctl_memory_failure_recovery __rea
 
 atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
-static void page_handle_poison(struct page *page)
+static void page_handle_poison(struct page *page, bool release)
 {
 	SetPageHWPoison(page);
+	if (release)
+		put_page(page);
 	page_ref_inc(page);
 	num_poisoned_pages_inc();
 }
@@ -1765,19 +1767,13 @@ static int soft_offline_huge_page(struct
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
@@ -1812,10 +1808,8 @@ static int __soft_offline_page(struct pa
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
 
@@ -1846,7 +1840,9 @@ static int __soft_offline_page(struct pa
 		list_add(&page->lru, &pagelist);
 		ret = migrate_pages(&pagelist, new_page, NULL, MPOL_MF_MOVE_ALL,
 					MIGRATE_SYNC, MR_MEMORY_FAILURE);
-		if (ret) {
+		if (!ret) {
+			page_handle_poison(page, true);
+		} else {
 			if (!list_empty(&pagelist))
 				putback_movable_pages(&pagelist);
 
@@ -1865,27 +1861,16 @@ static int __soft_offline_page(struct pa
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
 
@@ -1894,7 +1879,7 @@ static int soft_offline_free_page(struct
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
@@ -1174,6 +1174,17 @@ static __always_inline bool free_pages_p
 
 	trace_mm_page_free(page, order);
 
+	if (unlikely(PageHWPoison(page)) && !order) {
+		/*
+		 * Do not let hwpoison pages hit pcplists/buddy
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
@@ -8844,32 +8855,4 @@ bool take_page_off_buddy(struct page *pa
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
