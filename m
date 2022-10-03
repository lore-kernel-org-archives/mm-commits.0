Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF51BC43219
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiJCVRu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiJCVPr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:15:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A0C558EB
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DACCCB815F2
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806F3C433B5;
        Mon,  3 Oct 2022 21:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831415;
        bh=jrp6CADZCx6OnAwSG/W2pJJuSQWfCuzWS2b1EgBhc5c=;
        h=Date:To:From:Subject:From;
        b=CNCB3++CXblh61HQV2rdpYHabn94Eq73I7SG+6V80Nz2seDjB4p0QaPIlNFNcvFGL
         4b1IiLYWn0Iv71Lh3tLId8n3qdNItOhjNg2mECEtx5DGYxnNUlF89dMtxhOwVWvdvF
         MgwrC9lK74Ej3GV9c35pCN4fVG402mvIKFRZGg4A=
Date:   Mon, 03 Oct 2022 14:10:14 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        osalvador@suse.de, mike.kravetz@oracle.com, david@redhat.com,
        xhao@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-add-available_huge_pages-func.patch removed from -mm tree
Message-Id: <20221003211015.806F3C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: add available_huge_pages() func
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-available_huge_pages-func.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/hugetlb: add available_huge_pages() func
Date: Thu, 22 Sep 2022 10:19:29 +0800

In hugetlb.c there are several places which compare the values of
'h->free_huge_pages' and 'h->resv_huge_pages', it looks a bit messy, so
add a new available_huge_pages() function to do these.

Link: https://lkml.kernel.org/r/20220922021929.98961-1-xhao@linux.alibaba.com
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-add-available_huge_pages-func
+++ a/mm/hugetlb.c
@@ -1191,6 +1191,11 @@ retry_cpuset:
 	return NULL;
 }
 
+static unsigned long available_huge_pages(struct hstate *h)
+{
+	return h->free_huge_pages - h->resv_huge_pages;
+}
+
 static struct page *dequeue_huge_page_vma(struct hstate *h,
 				struct vm_area_struct *vma,
 				unsigned long address, int avoid_reserve,
@@ -1207,12 +1212,11 @@ static struct page *dequeue_huge_page_vm
 	 * have no page reserves. This check ensures that reservations are
 	 * not "stolen". The child may still get SIGKILLed
 	 */
-	if (!vma_has_reserves(vma, chg) &&
-			h->free_huge_pages - h->resv_huge_pages == 0)
+	if (!vma_has_reserves(vma, chg) && !available_huge_pages(h))
 		goto err;
 
 	/* If reserves cannot be used, ensure enough pages are in the pool */
-	if (avoid_reserve && h->free_huge_pages - h->resv_huge_pages == 0)
+	if (avoid_reserve && !available_huge_pages(h))
 		goto err;
 
 	gfp_mask = htlb_alloc_mask(h);
@@ -2124,7 +2128,7 @@ retry:
 	if (!page_count(page)) {
 		struct page *head = compound_head(page);
 		struct hstate *h = page_hstate(head);
-		if (h->free_huge_pages - h->resv_huge_pages == 0)
+		if (!available_huge_pages(h))
 			goto out;
 
 		/*
@@ -2311,7 +2315,7 @@ struct page *alloc_huge_page_nodemask(st
 		nodemask_t *nmask, gfp_t gfp_mask)
 {
 	spin_lock_irq(&hugetlb_lock);
-	if (h->free_huge_pages - h->resv_huge_pages > 0) {
+	if (available_huge_pages(h)) {
 		struct page *page;
 
 		page = dequeue_huge_page_nodemask(h, gfp_mask, preferred_nid, nmask);
_

Patches currently in -mm which might be from xhao@linux.alibaba.com are

mm-damon-move-sz_damon_region-to-damon_sz_region.patch
mm-damon-use-damon_sz_region-in-appropriate-place.patch

