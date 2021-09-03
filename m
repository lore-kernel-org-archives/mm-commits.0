Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D066FC433FE
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:00:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA85B61131
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350491AbhICVBN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:01:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350205AbhICVBI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:01:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79B22610FD;
        Fri,  3 Sep 2021 21:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702807;
        bh=jKweiw6mA10XIfPVktj+60sQgLXw1s2xxEWyo4eLMyI=;
        h=Date:From:To:Subject:From;
        b=CjNbWsSdYT2b022/cY4KOYpu0HMvLGrT3Rk1GjFY8PP90/N7YVpX6neAMGYQO8NhI
         0vw4W5HN6JXRz6gIAWYNvJ6snSKfNN5jC0JpT3f8cwHJbaABu/sAjv+Lh2T+aByUwP
         F3BJpAbMm8M82HWUDYtSdtrtrCfw98KOTKxq/NPs=
Date:   Fri, 03 Sep 2021 14:00:07 -0700
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, david@redhat.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@linux.dev, osalvador@suse.de,
        songmuchun@bytedance.com, willy@infradead.org
Subject:  [merged]
 hugetlb-drop-ref-count-earlier-after-page-allocation.patch removed from -mm
 tree
Message-ID: <20210903210007.FDX5R_eSZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: drop ref count earlier after page allocation
has been removed from the -mm tree.  Its filename was
     hugetlb-drop-ref-count-earlier-after-page-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: drop ref count earlier after page allocation

When discussing the possibility of inflated page ref counts, Muuchun Song
pointed out this potential issue [1].  It is true that any code could
potentially take a reference on a compound page after allocation and
before it is converted to and put into use as a hugetlb page. 
Specifically, this could be done by any users of get_page_unless_zero.

There are three areas of concern within hugetlb code.

1) When adding pages to the pool.  In this case, new pages are
   allocated added to the pool by calling put_page to invoke the hugetlb
   destructor (free_huge_page).  If there is an inflated ref count on the
   page, it will not be immediately added to the free list.  It will only
   be added to the free list when the temporary ref count is dropped. 
   This is deemed acceptable and will not be addressed.

2) A page is allocated for immediate use normally as a surplus page or
   migration target.  In this case, the user of the page will also hold a
   reference.  There is no issue as this is just like normal page ref
   counting.

3) A page is allocated and MUST be added to the free list to satisfy a
   reservation.  One such example is gather_surplus_pages as pointed out
   by Muchun in [1].  More specifically, this case covers callers of
   enqueue_huge_page where the page reference count must be zero.  This
   patch covers this third case.

Three routines call enqueue_huge_page when the page reference count could
potentially be inflated.  They are: gather_surplus_pages,
alloc_and_dissolve_huge_page and add_hugetlb_page.

add_hugetlb_page is called on error paths when a huge page can not be
freed due to the inability to allocate vmemmap pages.  In this case, the
temporairly inflated ref count is not an issue.  When the ref is dropped
the appropriate action will be taken.  Instead of VM_BUG_ON if the ref
count does not drop to zero, simply return.

In gather_surplus_pages and alloc_and_dissolve_huge_page the caller
expects a page (or pages) to be put on the free lists.  In this case we
must ensure there are no temporary ref counts.  We do this by calling
put_page_testzero() earlier and not using pages without a zero ref count. 
The temporary page flag (HPageTemporary) is used in such cases so that as
soon as the inflated ref count is dropped the page will be freed.

[1] https://lore.kernel.org/linux-mm/CAMZfGtVMn3daKrJwZMaVOGOaJU+B4dS--x_oPmGQMD=c=QNGEg@mail.gmail.com/
Link: https://lkml.kernel.org/r/20210809184832.18342-3-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |  100 ++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 78 insertions(+), 22 deletions(-)

--- a/mm/hugetlb.c~hugetlb-drop-ref-count-earlier-after-page-allocation
+++ a/mm/hugetlb.c
@@ -1072,6 +1072,8 @@ static void enqueue_huge_page(struct hst
 	int nid = page_to_nid(page);
 
 	lockdep_assert_held(&hugetlb_lock);
+	VM_BUG_ON_PAGE(page_count(page), page);
+
 	list_move(&page->lru, &h->hugepage_freelists[nid]);
 	h->free_huge_pages++;
 	h->free_huge_pages_node[nid]++;
@@ -1399,11 +1401,20 @@ static void add_hugetlb_page(struct hsta
 	SetHPageVmemmapOptimized(page);
 
 	/*
-	 * This page is now managed by the hugetlb allocator and has
-	 * no users -- drop the last reference.
+	 * This page is about to be managed by the hugetlb allocator and
+	 * should have no users.  Drop our reference, and check for others
+	 * just in case.
 	 */
 	zeroed = put_page_testzero(page);
-	VM_BUG_ON_PAGE(!zeroed, page);
+	if (!zeroed)
+		/*
+		 * It is VERY unlikely soneone else has taken a ref on
+		 * the page.  In this case, we simply return as the
+		 * hugetlb destructor (free_huge_page) will be called
+		 * when this other ref is dropped.
+		 */
+		return;
+
 	arch_clear_hugepage_flags(page);
 	enqueue_huge_page(h, page);
 }
@@ -2017,9 +2028,10 @@ int dissolve_free_huge_pages(unsigned lo
  * Allocates a fresh surplus page from the page allocator.
  */
 static struct page *alloc_surplus_huge_page(struct hstate *h, gfp_t gfp_mask,
-		int nid, nodemask_t *nmask)
+		int nid, nodemask_t *nmask, bool zero_ref)
 {
 	struct page *page = NULL;
+	bool retry = false;
 
 	if (hstate_is_gigantic(h))
 		return NULL;
@@ -2029,6 +2041,7 @@ static struct page *alloc_surplus_huge_p
 		goto out_unlock;
 	spin_unlock_irq(&hugetlb_lock);
 
+retry:
 	page = alloc_fresh_huge_page(h, gfp_mask, nid, nmask, NULL);
 	if (!page)
 		return NULL;
@@ -2046,11 +2059,35 @@ static struct page *alloc_surplus_huge_p
 		spin_unlock_irq(&hugetlb_lock);
 		put_page(page);
 		return NULL;
-	} else {
-		h->surplus_huge_pages++;
-		h->surplus_huge_pages_node[page_to_nid(page)]++;
 	}
 
+	if (zero_ref) {
+		/*
+		 * Caller requires a page with zero ref count.
+		 * We will drop ref count here.  If someone else is holding
+		 * a ref, the page will be freed when they drop it.  Abuse
+		 * temporary page flag to accomplish this.
+		 */
+		SetHPageTemporary(page);
+		if (!put_page_testzero(page)) {
+			/*
+			 * Unexpected inflated ref count on freshly allocated
+			 * huge.  Retry once.
+			 */
+			pr_info("HugeTLB unexpected inflated ref count on freshly allocated page\n");
+			spin_unlock_irq(&hugetlb_lock);
+			if (retry)
+				return NULL;
+
+			retry = true;
+			goto retry;
+		}
+		ClearHPageTemporary(page);
+	}
+
+	h->surplus_huge_pages++;
+	h->surplus_huge_pages_node[page_to_nid(page)]++;
+
 out_unlock:
 	spin_unlock_irq(&hugetlb_lock);
 
@@ -2092,7 +2129,7 @@ struct page *alloc_buddy_huge_page_with_
 	nodemask_t *nodemask;
 
 	nid = huge_node(vma, addr, gfp_mask, &mpol, &nodemask);
-	page = alloc_surplus_huge_page(h, gfp_mask, nid, nodemask);
+	page = alloc_surplus_huge_page(h, gfp_mask, nid, nodemask, false);
 	mpol_cond_put(mpol);
 
 	return page;
@@ -2164,7 +2201,7 @@ retry:
 	spin_unlock_irq(&hugetlb_lock);
 	for (i = 0; i < needed; i++) {
 		page = alloc_surplus_huge_page(h, htlb_alloc_mask(h),
-				NUMA_NO_NODE, NULL);
+				NUMA_NO_NODE, NULL, true);
 		if (!page) {
 			alloc_ok = false;
 			break;
@@ -2205,24 +2242,20 @@ retry:
 
 	/* Free the needed pages to the hugetlb pool */
 	list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
-		int zeroed;
-
 		if ((--needed) < 0)
 			break;
-		/*
-		 * This page is now managed by the hugetlb allocator and has
-		 * no users -- drop the buddy allocator's reference.
-		 */
-		zeroed = put_page_testzero(page);
-		VM_BUG_ON_PAGE(!zeroed, page);
+		/* Add the page to the hugetlb allocator */
 		enqueue_huge_page(h, page);
 	}
 free:
 	spin_unlock_irq(&hugetlb_lock);
 
-	/* Free unnecessary surplus pages to the buddy allocator */
+	/*
+	 * Free unnecessary surplus pages to the buddy allocator.
+	 * Pages have no ref count, call free_huge_page directly.
+	 */
 	list_for_each_entry_safe(page, tmp, &surplus_list, lru)
-		put_page(page);
+		free_huge_page(page);
 	spin_lock_irq(&hugetlb_lock);
 
 	return ret;
@@ -2531,6 +2564,7 @@ static int alloc_and_dissolve_huge_page(
 {
 	gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
 	int nid = page_to_nid(old_page);
+	bool alloc_retry = false;
 	struct page *new_page;
 	int ret = 0;
 
@@ -2541,9 +2575,30 @@ static int alloc_and_dissolve_huge_page(
 	 * the pool.  This simplifies and let us do most of the processing
 	 * under the lock.
 	 */
+alloc_retry:
 	new_page = alloc_buddy_huge_page(h, gfp_mask, nid, NULL, NULL);
 	if (!new_page)
 		return -ENOMEM;
+	/*
+	 * If all goes well, this page will be directly added to the free
+	 * list in the pool.  For this the ref count needs to be zero.
+	 * Attempt to drop now, and retry once if needed.  It is VERY
+	 * unlikely there is another ref on the page.
+	 *
+	 * If someone else has a reference to the page, it will be freed
+	 * when they drop their ref.  Abuse temporary page flag to accomplish
+	 * this.  Retry once if there is an inflated ref count.
+	 */
+	SetHPageTemporary(new_page);
+	if (!put_page_testzero(new_page)) {
+		if (alloc_retry)
+			return -EBUSY;
+
+		alloc_retry = true;
+		goto alloc_retry;
+	}
+	ClearHPageTemporary(new_page);
+
 	__prep_new_huge_page(h, new_page);
 
 retry:
@@ -2583,11 +2638,10 @@ retry:
 		remove_hugetlb_page(h, old_page, false);
 
 		/*
-		 * Reference count trick is needed because allocator gives us
-		 * referenced page but the pool requires pages with 0 refcount.
+		 * Ref count on new page is already zero as it was dropped
+		 * earlier.  It can be directly added to the pool free list.
 		 */
 		__prep_account_new_huge_page(h, nid);
-		page_ref_dec(new_page);
 		enqueue_huge_page(h, new_page);
 
 		/*
@@ -2601,6 +2655,8 @@ retry:
 
 free_new:
 	spin_unlock_irq(&hugetlb_lock);
+	/* Page has a zero ref count, but needs a ref to be freed */
+	set_page_refcounted(new_page);
 	update_and_free_page(h, new_page, false);
 
 	return ret;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


