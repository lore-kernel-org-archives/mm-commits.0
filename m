Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E971EE7D0BD
	for <mm-commits@archiver.kernel.org>; Fri, 22 Sep 2023 01:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbjIVBim (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Sep 2023 21:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjIVBik (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Sep 2023 21:38:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E46F1
        for <mm-commits@vger.kernel.org>; Thu, 21 Sep 2023 18:38:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62946C433CA;
        Fri, 22 Sep 2023 01:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695346714;
        bh=TH4L7yetQZAx0PqMdnDzpg23vB/FRf/tFWOrnmbWBZ8=;
        h=Date:To:From:Subject:From;
        b=RFRrqb2wC2BoEq+GBTSJ/ANilpSqZihC6V2NVtELpLGbIFZ7PaVPquzuOZCqdyvRh
         TfhzqL99r9s4iUTp7z1zYNGt/nWItFKKlZNhnlbGmblSyZ8a1z7eC18yoI/mU5yCEc
         DMHKcPBpfvaS52jsM7nxPO1fqoxBDQ6AmBxXm1Go=
Date:   Thu, 21 Sep 2023 18:38:33 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, mike.kravetz@oracle.com, hughd@google.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-use-a-folio-in-do_numa_page.patch added to mm-unstable branch
Message-Id: <20230922013834.62946C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory: use a folio in do_numa_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-use-a-folio-in-do_numa_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-use-a-folio-in-do_numa_page.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -4747,8 +4747,8 @@ int numa_migrate_prep(struct page *page,
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
@@ -4779,12 +4779,12 @@ static vm_fault_t do_numa_page(struct vm
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
@@ -4799,34 +4799,34 @@ static vm_fault_t do_numa_page(struct vm
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
@@ -4842,8 +4842,8 @@ static vm_fault_t do_numa_page(struct vm
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

mm-migrate-remove-pagetranshuge-check-in-numamigrate_isolate_page.patch
mm-migrate-remove-thp-mapcount-check-in-numamigrate_isolate_page.patch
mm-migrate-convert-numamigrate_isolate_page-to-numamigrate_isolate_folio.patch
mm-migrate-convert-migrate_misplaced_page-to-migrate_misplaced_folio.patch
mm-migrate-use-__folio_test_movable.patch
mm-migrate-use-a-folio-in-add_page_for_migration.patch
mm-migrate-remove-pagehead-check-for-hugetlb-in-add_page_for_migration.patch
mm-migrate-remove-isolated-variable-in-add_page_for_migration.patch
mm-memory-add-vm_normal_folio_pmd.patch
mm-huge_memory-use-a-folio-in-do_huge_pmd_numa_page.patch
mm-memory-use-a-folio-in-do_numa_page.patch
mm-memory-make-numa_migrate_prep-to-take-a-folio.patch
mm-mempolicy-make-mpol_misplaced-to-take-a-folio.patch
sched-numa-mm-make-numa-migrate-functions-to-take-a-folio.patch

