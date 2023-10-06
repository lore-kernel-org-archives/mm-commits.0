Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E825EE94130
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:48:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbjJFVsM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233806AbjJFVsL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:48:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084A1C2
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:48:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31773C433C8;
        Fri,  6 Oct 2023 21:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628889;
        bh=ObuHh4mhryAJGOjISBcgTJ99eDQfanEYSlgtsAuUsgI=;
        h=Date:To:From:Subject:From;
        b=1KKsNFeEIQVmkrTW35V6dYDq4jsWpRbxtzE+SKuQ8LTp6E6u9tz1swrC9NuWY9GDV
         mc8e/4m4kNuooTLA3lmW3E0Z3DiBLvHnQvSKih8wj5cdfQDDKiMwJihn7wLTDtrmoz
         cGhRCJVgLXnVkhMdbRLUIKcjznqG+NmLRmq0iVVY=
Date:   Fri, 06 Oct 2023 14:48:07 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, mike.kravetz@oracle.com, hughd@google.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-make-numa_migrate_prep-to-take-a-folio.patch removed from -mm tree
Message-Id: <20231006214809.31773C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory: make numa_migrate_prep() to take a folio
has been removed from the -mm tree.  Its filename was
     mm-memory-make-numa_migrate_prep-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory: make numa_migrate_prep() to take a folio
Date: Thu, 21 Sep 2023 15:44:15 +0800

In preparation for large folio numa balancing, make numa_migrate_prep() to
take a folio, no functional change intended.

Link: https://lkml.kernel.org/r/20230921074417.24004-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 mm/internal.h    |    2 +-
 mm/memory.c      |    9 ++++-----
 3 files changed, 6 insertions(+), 7 deletions(-)

--- a/mm/huge_memory.c~mm-memory-make-numa_migrate_prep-to-take-a-folio
+++ a/mm/huge_memory.c
@@ -1556,7 +1556,7 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	 */
 	if (node_is_toptier(nid))
 		last_cpupid = page_cpupid_last(&folio->page);
-	target_nid = numa_migrate_prep(&folio->page, vma, haddr, nid, &flags);
+	target_nid = numa_migrate_prep(folio, vma, haddr, nid, &flags);
 	if (target_nid == NUMA_NO_NODE) {
 		folio_put(folio);
 		goto out_map;
--- a/mm/internal.h~mm-memory-make-numa_migrate_prep-to-take-a-folio
+++ a/mm/internal.h
@@ -983,7 +983,7 @@ void vunmap_range_noflush(unsigned long
 
 void __vunmap_range_noflush(unsigned long start, unsigned long end);
 
-int numa_migrate_prep(struct page *page, struct vm_area_struct *vma,
+int numa_migrate_prep(struct folio *folio, struct vm_area_struct *vma,
 		      unsigned long addr, int page_nid, int *flags);
 
 void free_zone_device_page(struct page *page);
--- a/mm/memory.c~mm-memory-make-numa_migrate_prep-to-take-a-folio
+++ a/mm/memory.c
@@ -4724,10 +4724,10 @@ static vm_fault_t do_fault(struct vm_fau
 	return ret;
 }
 
-int numa_migrate_prep(struct page *page, struct vm_area_struct *vma,
+int numa_migrate_prep(struct folio *folio, struct vm_area_struct *vma,
 		      unsigned long addr, int page_nid, int *flags)
 {
-	get_page(page);
+	folio_get(folio);
 
 	/* Record the current PID acceesing VMA */
 	vma_set_access_pid_bit(vma);
@@ -4738,7 +4738,7 @@ int numa_migrate_prep(struct page *page,
 		*flags |= TNF_FAULT_LOCAL;
 	}
 
-	return mpol_misplaced(page, vma, addr);
+	return mpol_misplaced(&folio->page, vma, addr);
 }
 
 static vm_fault_t do_numa_page(struct vm_fault *vmf)
@@ -4812,8 +4812,7 @@ static vm_fault_t do_numa_page(struct vm
 		last_cpupid = (-1 & LAST_CPUPID_MASK);
 	else
 		last_cpupid = page_cpupid_last(&folio->page);
-	target_nid = numa_migrate_prep(&folio->page, vma, vmf->address, nid,
-				       &flags);
+	target_nid = numa_migrate_prep(folio, vma, vmf->address, nid, &flags);
 	if (target_nid == NUMA_NO_NODE) {
 		folio_put(folio);
 		goto out_map;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


