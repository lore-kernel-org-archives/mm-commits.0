Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D308C433E6
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 22:24:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 402382312E
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 22:24:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731185AbhALWYI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Jan 2021 17:24:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730906AbhALWYI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 12 Jan 2021 17:24:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BED782312E;
        Tue, 12 Jan 2021 22:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610490208;
        bh=OIwLSRiduSBTHZkxNB3ukark8PFEZP/0hrMpb7llYWI=;
        h=Date:From:To:Subject:From;
        b=UQ1UH0An8CYe3hbHa29SNP0ycoRYRS4Y1IvnMtxZPKXtHLf5rkJTMSvXJ0Ijm5Kd3
         QWOmsLH3bCJEDRYbdzjGqlfeEDlUGhIFrsvQMSoCM1rqvUC0CnHQ19AzlWzRQdLiN5
         jOcaCMfe0Bhz/7RdNxZA9blZszOY62Ydux6M4goI=
Date:   Tue, 12 Jan 2021 14:23:27 -0800
From:   akpm@linux-foundation.org
To:     ak@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        shy828301@gmail.com, songmuchun@bytedance.com
Subject:  [to-be-updated]
 mm-hugetlb-add-return-eagain-for-dissolve_free_huge_page.patch removed from
 -mm tree
Message-ID: <20210112222327.JK6BQ-b1s%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: add return -EAGAIN for dissolve_free_huge_page
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-return-eagain-for-dissolve_free_huge_page.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb: add return -EAGAIN for dissolve_free_huge_page

There is a race between dissolve_free_huge_page() and put_page(),
and the race window is quite small. Theoretically, we should return
-EBUSY when we encounter this race. In fact, we have a chance to
successfully dissolve the page if we do a retry. Because the race
window is quite small. If we seize this opportunity, it is an
optimization for increasing the success rate of dissolving page.

If we free a HugeTLB page from a non-task context, it is deferred
through a workqueue. In this case, we need to flush the work.

The dissolve_free_huge_page() can be called from memory hotplug,
the caller aims to free the HugeTLB page to the buddy allocator
so that the caller can unplug the page successfully.

Link: https://lkml.kernel.org/r/20210110124017.86750-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-add-return-eagain-for-dissolve_free_huge_page
+++ a/mm/hugetlb.c
@@ -1763,10 +1763,11 @@ static int free_pool_huge_page(struct hs
  * nothing for in-use hugepages and non-hugepages.
  * This function returns values like below:
  *
- *  -EBUSY: failed to dissolved free hugepages or the hugepage is in-use
- *          (allocated or reserved.)
- *       0: successfully dissolved free hugepages or the page is not a
- *          hugepage (considered as already dissolved)
+ *  -EAGAIN: race with __free_huge_page() and can do a retry
+ *  -EBUSY:  failed to dissolved free hugepages or the hugepage is in-use
+ *           (allocated or reserved.)
+ *       0:  successfully dissolved free hugepages or the page is not a
+ *           hugepage (considered as already dissolved)
  */
 int dissolve_free_huge_page(struct page *page)
 {
@@ -1793,8 +1794,10 @@ int dissolve_free_huge_page(struct page
 		 * We should make sure that the page is already on the free list
 		 * when it is dissolved.
 		 */
-		if (unlikely(!PageHugeFreed(head)))
+		if (unlikely(!PageHugeFreed(head))) {
+			rc = -EAGAIN;
 			goto out;
+		}
 
 		/*
 		 * Move PageHWPoison flag from head page to the raw error page,
@@ -1813,6 +1816,14 @@ int dissolve_free_huge_page(struct page
 	}
 out:
 	spin_unlock(&hugetlb_lock);
+
+	/*
+	 * If the freeing of the HugeTLB page is put on a work queue, we should
+	 * flush the work before retrying.
+	 */
+	if (unlikely(rc == -EAGAIN))
+		flush_work(&free_hpage_work);
+
 	return rc;
 }
 
@@ -1835,7 +1846,12 @@ int dissolve_free_huge_pages(unsigned lo
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn += 1 << minimum_order) {
 		page = pfn_to_page(pfn);
+retry:
 		rc = dissolve_free_huge_page(page);
+		if (rc == -EAGAIN) {
+			cpu_relax();
+			goto retry;
+		}
 		if (rc)
 			break;
 	}
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlbfs-fix-cannot-migrate-the-fallocated-hugetlb-page.patch
mm-hugetlb-fix-a-race-between-freeing-and-dissolving-the-page.patch
mm-hugetlb-fix-a-race-between-isolating-and-freeing-page.patch
mm-hugetlb-remove-vm_bug_on_page-from-page_huge_active.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage.patch
mm-memcontrol-fix-nr_anon_thps-accounting-in-charge-moving.patch
mm-memcontrol-convert-nr_anon_thps-account-to-pages.patch
mm-memcontrol-convert-nr_file_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_pmdmapped-account-to-pages.patch
mm-memcontrol-convert-nr_file_pmdmapped-account-to-pages.patch
mm-memcontrol-make-the-slab-calculation-consistent.patch

