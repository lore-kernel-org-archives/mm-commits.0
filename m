Return-Path: <SRS0=f579=BK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7EF3C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:23:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 955642087C
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596226990;
	bh=zzWCTj76WG+xd4tbC4W02plzSxxAcqfiaWIydU2s5jg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=hCOOKXFBEN6ckfe9/FVgTq6B6R7Jm8qZXJ20SFP0NPcyVtmGqFqVLSOyFM0Yz9g2A
	 AZPfcjbw8eJLia6/QDG+djeZGT75GbohCy6HYV1kFZlOkjWBy+vxJbEFVRP3MrUTLh
	 6e+TRkj6WyG/lR84mmVClRWb8Rdoe0u4rO8AjFr4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgGaUXK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Jul 2020 16:23:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726950AbgGaUXK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jul 2020 16:23:10 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAA0C208E4;
        Fri, 31 Jul 2020 20:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596226989;
        bh=zzWCTj76WG+xd4tbC4W02plzSxxAcqfiaWIydU2s5jg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=tF9HK9tCN7EIqSp+j8jfiZ2Owm6mYsMOvjrONroVuMuoEp7+jm9JYFLGIANo5ZoeP
         IufD4cOCvul0MEoikEsbZRXkXoX4InHxZ55nYnzvvZXqPN4/t1wU+eU8b+hMAEEu0+
         sTBPvJjY9T63FgHCSr/Wq0sDQTZxqrlchca9YBHc=
Date:   Fri, 31 Jul 2020 13:23:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aneesh.kumar@linux.ibm.com, guro@fb.com, hch@infradead.org,
        iamjoonsoo.kim@lge.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        vbabka@suse.cz
Subject:  +
 mm-hugetlb-make-hugetlb-migration-callback-cma-aware.patch added to -mm
 tree
Message-ID: <20200731202308.qnoHMtsAo%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: make hugetlb migration callback CMA aware
has been added to the -mm tree.  Its filename is
     mm-hugetlb-make-hugetlb-migration-callback-cma-aware.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-make-hugetlb-migration-callback-cma-aware.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-make-hugetlb-migration-callback-cma-aware.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -509,8 +509,6 @@ struct page *alloc_huge_page_nodemask(st
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

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-page_alloc-fix-memalloc_nocma_save-restore-apis.patch
mm-vmscan-make-active-inactive-ratio-as-1-1-for-anon-lru.patch
mm-vmscan-protect-the-workingset-on-anonymous-lru.patch
mm-workingset-prepare-the-workingset-detection-infrastructure-for-anon-lru.patch
mm-swapcache-support-to-handle-the-shadow-entries.patch
mm-swap-implement-workingset-detection-for-anonymous-lru.patch
mm-vmscan-restore-active-inactive-ratio-for-anonymous-lru.patch
mm-page_isolation-prefer-the-node-of-the-source-page.patch
mm-migrate-move-migration-helper-from-h-to-c.patch
mm-hugetlb-unify-migration-callbacks.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations.patch
mm-migrate-make-a-standard-migration-target-allocation-function.patch
mm-mempolicy-use-a-standard-migration-target-allocation-callback.patch
mm-page_alloc-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory-failure-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory_hotplug-remove-a-wrapper-for-alloc_migration_target.patch
mm-gup-restrict-cma-region-by-using-allocation-scope-api.patch
mm-hugetlb-make-hugetlb-migration-callback-cma-aware.patch
mm-gup-use-a-standard-migration-target-allocation-callback.patch

