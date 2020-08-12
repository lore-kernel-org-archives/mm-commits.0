Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25077C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:37:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 007022054F
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196260;
	bh=RIVx32H+h8RS9USUstVx03pU5Q+ZCVupotOkpbcJweY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=RBGbaJCGdaLivqCdRZ+1Xh5OOEY/T6eXHHF5j7584D6RxN4WyK+rGxUG3R+IJko8a
	 6UUMu6QIA2Q+NnGRcL5aoklMVoj1jXqsb9qmq7mNVPOvj5cCIGf9zmnn9RzJIo+b27
	 6GiiP+ERJPl+a3uYnvXpSxE7nSz+9Iq2wezYZv1o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgHLBhj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:37:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBhj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:37:39 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C66320658;
        Wed, 12 Aug 2020 01:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196258;
        bh=RIVx32H+h8RS9USUstVx03pU5Q+ZCVupotOkpbcJweY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Z+nJ7BF1/zKvOAsd4HHoOixax8UMXnznC5QrxN6PsCEzlIVuO/Cs5UD5rLynbBhDZ
         InhGJvZraZChIIJTYDkzEsyqYooju7MUAXxafQBeMZfqH5JTWniiXR+UyA5SzTmmTi
         Hj9v41bF/wfnCZfVM4gafOsZTKCC2wmT2Q8Bi8JY=
Date:   Tue, 11 Aug 2020 18:37:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com, guro@fb.com,
        hch@infradead.org, iamjoonsoo.kim@lge.com, linux-mm@kvack.org,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 139/165] mm/hugetlb: make hugetlb migration
 callback CMA aware
Message-ID: <20200812013738.kE_WJcPRN%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/hugetlb: make hugetlb migration callback CMA aware

new_non_cma_page() in gup.c requires to allocate the new page that is not
on the CMA area.  new_non_cma_page() implements it by using allocation
scope APIs.

However, there is a work-around for hugetlb.  Normal hugetlb page
allocation API for migration is alloc_huge_page_nodemask().  It consists
of two steps.  First is dequeing from the pool.  Second is, if there is no
available page on the queue, allocating by using the page allocator.

new_non_cma_page() can't use this API since first step (deque) isn't aware
of scope API to exclude CMA area.  So, new_non_cma_page() exports hugetlb
internal function for the second step, alloc_migrate_huge_page(), to
global scope and uses it directly.  This is suboptimal since hugetlb pages
on the queue cannot be utilized.

This patch tries to fix this situation by making the deque function on
hugetlb CMA aware.  In the deque function, CMA memory is skipped if
PF_MEMALLOC_NOCMA flag is found.

Link: http://lkml.kernel.org/r/1596180906-8442-2-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 --
 mm/gup.c                |    6 +-----
 mm/hugetlb.c            |   11 +++++++++--
 3 files changed, 10 insertions(+), 9 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-make-hugetlb-migration-callback-cma-aware
+++ a/include/linux/hugetlb.h
@@ -511,8 +511,6 @@ struct page *alloc_huge_page_nodemask(st
 				nodemask_t *nmask, gfp_t gfp_mask);
 struct page *alloc_huge_page_vma(struct hstate *h, struct vm_area_struct *vma,
 				unsigned long address);
-struct page *alloc_migrate_huge_page(struct hstate *h, gfp_t gfp_mask,
-				     int nid, nodemask_t *nmask);
 int huge_add_to_page_cache(struct page *page, struct address_space *mapping,
 			pgoff_t idx);
 
--- a/mm/gup.c~mm-hugetlb-make-hugetlb-migration-callback-cma-aware
+++ a/mm/gup.c
@@ -1635,11 +1635,7 @@ static struct page *new_non_cma_page(str
 		struct hstate *h = page_hstate(page);
 
 		gfp_mask = htlb_modify_alloc_mask(h, gfp_mask);
-		/*
-		 * We don't want to dequeue from the pool because pool pages will
-		 * mostly be from the CMA region.
-		 */
-		return alloc_migrate_huge_page(h, gfp_mask, nid, NULL);
+		return alloc_huge_page_nodemask(h, nid, NULL, gfp_mask);
 	}
 #endif
 	if (PageTransHuge(page)) {
--- a/mm/hugetlb.c~mm-hugetlb-make-hugetlb-migration-callback-cma-aware
+++ a/mm/hugetlb.c
@@ -19,6 +19,7 @@
 #include <linux/memblock.h>
 #include <linux/sysfs.h>
 #include <linux/slab.h>
+#include <linux/sched/mm.h>
 #include <linux/mmdebug.h>
 #include <linux/sched/signal.h>
 #include <linux/rmap.h>
@@ -1040,10 +1041,16 @@ static void enqueue_huge_page(struct hst
 static struct page *dequeue_huge_page_node_exact(struct hstate *h, int nid)
 {
 	struct page *page;
+	bool nocma = !!(current->flags & PF_MEMALLOC_NOCMA);
+
+	list_for_each_entry(page, &h->hugepage_freelists[nid], lru) {
+		if (nocma && is_migrate_cma_page(page))
+			continue;
 
-	list_for_each_entry(page, &h->hugepage_freelists[nid], lru)
 		if (!PageHWPoison(page))
 			break;
+	}
+
 	/*
 	 * if 'non-isolated free hugepage' not found on the list,
 	 * the allocation fails.
@@ -1935,7 +1942,7 @@ out_unlock:
 	return page;
 }
 
-struct page *alloc_migrate_huge_page(struct hstate *h, gfp_t gfp_mask,
+static struct page *alloc_migrate_huge_page(struct hstate *h, gfp_t gfp_mask,
 				     int nid, nodemask_t *nmask)
 {
 	struct page *page;
_
