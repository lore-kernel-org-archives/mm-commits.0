Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6FFBC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5B06611C0
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:40:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbhKESnY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 14:43:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231904AbhKESnY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 14:43:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A1CC61186;
        Fri,  5 Nov 2021 18:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636137644;
        bh=9jQX3JWH9H3S8Jt2UA24BDHa2opKT2XM9TwflcmeLmE=;
        h=Date:From:To:Subject:From;
        b=UaBEOV0yuDLBKISquABsJtf68yfELFg/T8YRvFWZ0Zhb5Uj7pi230hG5f62Y/gB6o
         VT9hTdLgdB0RUHn3k8H/3l43yZbBuWWb+mXmb1uFnkXlTW3MsMoyARc0wvyVOg+SwX
         esD16rfohiO3PO3uE5dDAImt3QJ3ZFsuMZSXntRU=
Date:   Fri, 05 Nov 2021 11:40:43 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, david@redhat.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@linux.dev, nghialm78@gmail.com, osalvador@suse.de,
        rientjes@google.com, songmuchun@bytedance.com, ziy@nvidia.com
Subject:  [folded-merged]
 hugetlb-add-hugetlb-demote-page-support-v4.patch removed from -mm tree
Message-ID: <20211105184043.z5n3gAWZ5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb-add-hugetlb-demote-page-support-v4
has been removed from the -mm tree.  Its filename was
     hugetlb-add-hugetlb-demote-page-support-v4.patch

This patch was dropped because it was folded into hugetlb-add-hugetlb-demote-page-support.patch

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb-add-hugetlb-demote-page-support-v4

On 10/7/21 11:19 AM, Mike Kravetz wrote:
> +static int demote_free_huge_page(struct hstate *h, struct page *page)
> +{
> +	int i, nid = page_to_nid(page);
> +	struct hstate *target_hstate;
> +	int rc = 0;
> +
> +	target_hstate = size_to_hstate(PAGE_SIZE << h->demote_order);
> +
> +	remove_hugetlb_page_for_demote(h, page, false);
> +	spin_unlock_irq(&hugetlb_lock);
> +
> +	rc = alloc_huge_page_vmemmap(h, page);
> +	if (rc) {
> +		/* Allocation of vmemmmap failed, we can not demote page */
> +		spin_lock_irq(&hugetlb_lock);
> +		set_page_refcounted(page);
> +		add_hugetlb_page(h, page, false);
> +		return rc;
> +	}
> +
> +	/*
> +	 * Use destroy_compound_hugetlb_page_for_demote for all huge page
> +	 * sizes as it will not ref count pages.
> +	 */
> +	destroy_compound_hugetlb_page_for_demote(page, huge_page_order(h));
> +
> +	for (i = 0; i < pages_per_huge_page(h);
> +				i += pages_per_huge_page(target_hstate)) {
> +		if (hstate_is_gigantic(target_hstate))
> +			prep_compound_gigantic_page_for_demote(page + i,
> +							target_hstate->order);
> +		else
> +			prep_compound_page(page + i, target_hstate->order);
> +		set_page_private(page + i, 0);
> +		set_page_refcounted(page + i);
> +		prep_new_huge_page(target_hstate, page + i, nid);
> +		put_page(page + i);
> +	}

I was doing some stress testing with multiple concurrent writers to
sysfs/.../nr_hugepages and sysfs/.../demote.  On occasion, I would see
unexpected surplus pages of the smaller huge page size (2M on x86).

Here is what was happening.  One task was decrementing the number of
2M huge pages with "echo 0 > nr_hugepages.  It proceeded to the routine
set_max_huge_pages and was executing the following:

	/*
	 * Decrease the pool size
	 * First return free pages to the buddy allocator (being careful
	 * to keep enough around to satisfy reservations).  Then place
	 * pages into surplus state as needed so the pool will shrink
	 * to the desired size as pages become free.
	 *
	 * By placing pages into the surplus state independent of the
	 * overcommit value, we are allowing the surplus pool size to
	 * exceed overcommit. There are few sane options here. Since
	 * alloc_surplus_huge_page() is checking the global counter,
	 * though, we'll note that we're not allowed to exceed surplus
	 * and won't grow the pool anywhere else. Not until one of the
	 * sysctls are changed, or the surplus pages go out of use.
	 */
	min_count = h->resv_huge_pages + h->nr_huge_pages - h->free_huge_pages;
	min_count = max(count, min_count);
	try_to_free_low(h, min_count, nodes_allowed);

	/*
	 * Collect pages to be removed on list without dropping lock
	 */
	while (min_count < persistent_huge_pages(h)) {
		page = remove_pool_huge_page(h, nodes_allowed, 0);
		if (!page)
			break;

		list_add(&page->lru, &page_list);
	}
	/* free the pages after dropping lock */
	spin_unlock_irq(&hugetlb_lock);
	update_and_free_pages_bulk(h, &page_list);
	flush_free_hpage_work(h);

Now, while the lock was dropped the routine demote_free_huge_page above
added 512 huge pages to the 2M pool.

	spin_lock_irq(&hugetlb_lock);

Then after acquiring the lock we make these 512 pages surplus.

	while (count < persistent_huge_pages(h)) {
		if (!adjust_pool_surplus(h, nodes_allowed, 1))
			break;
	}

To prevent this race from happening in general, the hstate specific mutex
resize_lock is held for the duration of set_max_huge_pages.  Since, the
demote code is also adjusting pool sizes it should also take the mutex.
The routine demote_store already takes the mutex of the hstate of the
page size being demoted (1M in this case).  That is because the 1M pool
size will be decreased.  We also need to take the resize mutex of the 2M
pool as this pool will be increased.  To prevent deadlocks, we use the
convention of always taking the resize mutex of the larger hstate first.

An updated version of this patch below adds taking the 'target hstate'
mutex in demote_free_huge_page.  Although unnecessary, it also updates
max_huge_pages of both hstates for consistency.




Demote page functionality will split a huge page into a number of huge
pages of a smaller size.  For example, on x86 a 1GB huge page can be
demoted into 512 2M huge pages.  Demotion is done 'in place' by simply
splitting the huge page.

Added '*_for_demote' wrappers for remove_hugetlb_page,
destroy_compound_hugetlb_page and prep_compound_gigantic_page for use
by demote code.

Link: https://lkml.kernel.org/r/6ca29b8e-527c-d6ec-900e-e6a43e4f8b73@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Nghia Le <nghialm78@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/mm/hugetlb.c~hugetlb-add-hugetlb-demote-page-support-v4
+++ a/mm/hugetlb.c
@@ -3349,6 +3349,15 @@ static int demote_free_huge_page(struct
 	 */
 	destroy_compound_hugetlb_page_for_demote(page, huge_page_order(h));
 
+	/*
+	 * Taking target hstate mutex synchronizes with set_max_huge_pages.
+	 * Without the mutex, pages added to target hstate could be marked
+	 * as surplus.
+	 *
+	 * Note that we already hold h->resize_lock.  To prevent deadlock,
+	 * use the convention of always taking larger size hstate mutex first.
+	 */
+	mutex_lock(&target_hstate->resize_lock);
 	for (i = 0; i < pages_per_huge_page(h);
 				i += pages_per_huge_page(target_hstate)) {
 		if (hstate_is_gigantic(target_hstate))
@@ -3361,8 +3370,17 @@ static int demote_free_huge_page(struct
 		prep_new_huge_page(target_hstate, page + i, nid);
 		put_page(page + i);
 	}
+	mutex_unlock(&target_hstate->resize_lock);
 
 	spin_lock_irq(&hugetlb_lock);
+
+	/*
+	 * Not absolutely necessary, but for consistency update max_huge_pages
+	 * based on pool changes for the demoted page.
+	 */
+	h->max_huge_pages--;
+	target_hstate->max_huge_pages += pages_per_huge_page(h);
+
 	return rc;
 }
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-add-demote-hugetlb-page-sysfs-interfaces.patch
mm-cma-add-cma_pages_valid-to-determine-if-pages-are-in-cma.patch
hugetlb-be-sure-to-free-demoted-cma-pages-to-cma.patch
hugetlb-add-demote-bool-to-gigantic-page-routines.patch
hugetlb-add-hugetlb-demote-page-support.patch
hugetlb-remove-unnecessary-set_page_count-in-prep_compound_gigantic_page.patch

