Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 023CCE94132
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbjJFVsG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233725AbjJFVsF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:48:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0C1C5
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:48:04 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F54C433CB;
        Fri,  6 Oct 2023 21:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628883;
        bh=aDLuPTOORvfIiJyZFcl6KXDGCdPVZNOE2nFgg85qjt8=;
        h=Date:To:From:Subject:From;
        b=ELtec+oLtszEBA+zln8ndYz1z/8j+ZL36soZGf7NU8OGB0AicHFjxr1HpCsT/vRp4
         nBGrM8w12yIwRJ8GZ+1c7Wo/YO7Z9jOVzaDz8dpgdOKvtfBH/jm8/URTwWB38GEfgH
         Y2D2Q6FYns/+eYsqCYMy3x/quZmEAen6h6Q0Vr7U=
Date:   Fri, 06 Oct 2023 14:48:01 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, mike.kravetz@oracle.com, hughd@google.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-use-a-folio-in-do_huge_pmd_numa_page.patch removed from -mm tree
Message-Id: <20231006214803.73F54C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: huge_memory: use a folio in do_huge_pmd_numa_page()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-use-a-folio-in-do_huge_pmd_numa_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: huge_memory: use a folio in do_huge_pmd_numa_page()
Date: Thu, 21 Sep 2023 15:44:13 +0800

Use a folio in do_huge_pmd_numa_page(), reduce three page_folio() calls to
one, no functional change intended.

Link: https://lkml.kernel.org/r/20230921074417.24004-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-a-folio-in-do_huge_pmd_numa_page
+++ a/mm/huge_memory.c
@@ -1517,9 +1517,9 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	struct vm_area_struct *vma = vmf->vma;
 	pmd_t oldpmd = vmf->orig_pmd;
 	pmd_t pmd;
-	struct page *page;
+	struct folio *folio;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
-	int page_nid = NUMA_NO_NODE;
+	int nid = NUMA_NO_NODE;
 	int target_nid, last_cpupid = (-1 & LAST_CPUPID_MASK);
 	bool migrated = false, writable = false;
 	int flags = 0;
@@ -1541,36 +1541,34 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	    can_change_pmd_writable(vma, vmf->address, pmd))
 		writable = true;
 
-	page = vm_normal_page_pmd(vma, haddr, pmd);
-	if (!page)
+	folio = vm_normal_folio_pmd(vma, haddr, pmd);
+	if (!folio)
 		goto out_map;
 
 	/* See similar comment in do_numa_page for explanation */
 	if (!writable)
 		flags |= TNF_NO_GROUP;
 
-	page_nid = page_to_nid(page);
+	nid = folio_nid(folio);
 	/*
 	 * For memory tiering mode, cpupid of slow memory page is used
 	 * to record page access time.  So use default value.
 	 */
-	if (node_is_toptier(page_nid))
-		last_cpupid = page_cpupid_last(page);
-	target_nid = numa_migrate_prep(page, vma, haddr, page_nid,
-				       &flags);
-
+	if (node_is_toptier(nid))
+		last_cpupid = page_cpupid_last(&folio->page);
+	target_nid = numa_migrate_prep(&folio->page, vma, haddr, nid, &flags);
 	if (target_nid == NUMA_NO_NODE) {
-		put_page(page);
+		folio_put(folio);
 		goto out_map;
 	}
 
 	spin_unlock(vmf->ptl);
 	writable = false;
 
-	migrated = migrate_misplaced_folio(page_folio(page), vma, target_nid);
+	migrated = migrate_misplaced_folio(folio, vma, target_nid);
 	if (migrated) {
 		flags |= TNF_MIGRATED;
-		page_nid = target_nid;
+		nid = target_nid;
 	} else {
 		flags |= TNF_MIGRATE_FAIL;
 		vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
@@ -1582,9 +1580,8 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	}
 
 out:
-	if (page_nid != NUMA_NO_NODE)
-		task_numa_fault(last_cpupid, page_nid, HPAGE_PMD_NR,
-				flags);
+	if (nid != NUMA_NO_NODE)
+		task_numa_fault(last_cpupid, nid, HPAGE_PMD_NR, flags);
 
 	return 0;
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


