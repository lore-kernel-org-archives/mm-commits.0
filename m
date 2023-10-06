Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA7DE94125
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233801AbjJFVsK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233769AbjJFVsI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:48:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050FFBE
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:48:07 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A42AC433C9;
        Fri,  6 Oct 2023 21:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628886;
        bh=6+YucOX+lmetUPYukOtI6IzH5SLyCl6y1LBZioGI5a8=;
        h=Date:To:From:Subject:From;
        b=JhQeRHxa/u98DuWsyXf8IGd6Kd4uB2DgHCExlOIixsSOp3wszsPtC3crbAC29nRgh
         uHvhBsW0VI7i7UE5H+fMUF9X+R2aT/9+mCVJ5z4qkj1U/2sGa45RyeMr+XVCERF2qg
         sLaII/qh5YNs+qjz6B4v1JXsNIBr0DIL5xASN5hE=
Date:   Fri, 06 Oct 2023 14:48:04 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, mike.kravetz@oracle.com, hughd@google.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-use-a-folio-in-do_numa_page.patch removed from -mm tree
Message-Id: <20231006214806.3A42AC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory: use a folio in do_numa_page()
has been removed from the -mm tree.  Its filename was
     mm-memory-use-a-folio-in-do_numa_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory: use a folio in do_numa_page()
Date: Thu, 21 Sep 2023 15:44:14 +0800

Numa balancing only try to migrate non-compound page in do_numa_page(),
use a folio in it to save several compound_head calls, note we use
folio_estimated_sharers(), it is enough to check the folio sharers since
only normal page is handled, if large folio numa balancing is supported, a
precise folio sharers check would be used, no functional change intended.

Link: https://lkml.kernel.org/r/20230921074417.24004-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

--- a/mm/memory.c~mm-memory-use-a-folio-in-do_numa_page
+++ a/mm/memory.c
@@ -4744,8 +4744,8 @@ int numa_migrate_prep(struct page *page,
 static vm_fault_t do_numa_page(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	struct page *page = NULL;
-	int page_nid = NUMA_NO_NODE;
+	struct folio *folio = NULL;
+	int nid = NUMA_NO_NODE;
 	bool writable = false;
 	int last_cpupid;
 	int target_nid;
@@ -4776,12 +4776,12 @@ static vm_fault_t do_numa_page(struct vm
 	    can_change_pte_writable(vma, vmf->address, pte))
 		writable = true;
 
-	page = vm_normal_page(vma, vmf->address, pte);
-	if (!page || is_zone_device_page(page))
+	folio = vm_normal_folio(vma, vmf->address, pte);
+	if (!folio || folio_is_zone_device(folio))
 		goto out_map;
 
 	/* TODO: handle PTE-mapped THP */
-	if (PageCompound(page))
+	if (folio_test_large(folio))
 		goto out_map;
 
 	/*
@@ -4796,34 +4796,34 @@ static vm_fault_t do_numa_page(struct vm
 		flags |= TNF_NO_GROUP;
 
 	/*
-	 * Flag if the page is shared between multiple address spaces. This
+	 * Flag if the folio is shared between multiple address spaces. This
 	 * is later used when determining whether to group tasks together
 	 */
-	if (page_mapcount(page) > 1 && (vma->vm_flags & VM_SHARED))
+	if (folio_estimated_sharers(folio) > 1 && (vma->vm_flags & VM_SHARED))
 		flags |= TNF_SHARED;
 
-	page_nid = page_to_nid(page);
+	nid = folio_nid(folio);
 	/*
 	 * For memory tiering mode, cpupid of slow memory page is used
 	 * to record page access time.  So use default value.
 	 */
 	if ((sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
-	    !node_is_toptier(page_nid))
+	    !node_is_toptier(nid))
 		last_cpupid = (-1 & LAST_CPUPID_MASK);
 	else
-		last_cpupid = page_cpupid_last(page);
-	target_nid = numa_migrate_prep(page, vma, vmf->address, page_nid,
-			&flags);
+		last_cpupid = page_cpupid_last(&folio->page);
+	target_nid = numa_migrate_prep(&folio->page, vma, vmf->address, nid,
+				       &flags);
 	if (target_nid == NUMA_NO_NODE) {
-		put_page(page);
+		folio_put(folio);
 		goto out_map;
 	}
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	writable = false;
 
 	/* Migrate to the requested node */
-	if (migrate_misplaced_folio(page_folio(page), vma, target_nid)) {
-		page_nid = target_nid;
+	if (migrate_misplaced_folio(folio, vma, target_nid)) {
+		nid = target_nid;
 		flags |= TNF_MIGRATED;
 	} else {
 		flags |= TNF_MIGRATE_FAIL;
@@ -4839,8 +4839,8 @@ static vm_fault_t do_numa_page(struct vm
 	}
 
 out:
-	if (page_nid != NUMA_NO_NODE)
-		task_numa_fault(last_cpupid, page_nid, 1, flags);
+	if (nid != NUMA_NO_NODE)
+		task_numa_fault(last_cpupid, nid, 1, flags);
 	return 0;
 out_map:
 	/*
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


