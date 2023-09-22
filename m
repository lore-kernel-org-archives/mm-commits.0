Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8256FE7D0BC
	for <mm-commits@archiver.kernel.org>; Fri, 22 Sep 2023 01:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjIVBil (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Sep 2023 21:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjIVBii (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Sep 2023 21:38:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F281BCF
        for <mm-commits@vger.kernel.org>; Thu, 21 Sep 2023 18:38:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE35C433C8;
        Fri, 22 Sep 2023 01:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695346712;
        bh=DephnxudWrzd72NnYiAmu9LbFThAok0zLcpUjyqtMFA=;
        h=Date:To:From:Subject:From;
        b=hEFSspNcRDKELmx9xrlXX//BI4h8h+EsLA6a9SrRrVn31FeL4pILmfdZ2StprNsKW
         eQ1ma1G7m6CVetBe7uI1N7cN4+ZQkxNnY8ti0fs4E/RaR1NtGejZC14c9D3pV+CXlp
         6VPlgTMWUuCBJAFUdKsr7RohN52NbLYfCz2HGfZE=
Date:   Thu, 21 Sep 2023 18:38:31 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, mike.kravetz@oracle.com, hughd@google.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-use-a-folio-in-do_huge_pmd_numa_page.patch added to mm-unstable branch
Message-Id: <20230922013832.8CE35C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: huge_memory: use a folio in do_huge_pmd_numa_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-use-a-folio-in-do_huge_pmd_numa_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-use-a-folio-in-do_huge_pmd_numa_page.patch

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

