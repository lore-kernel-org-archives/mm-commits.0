Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16405E7D0BC
	for <mm-commits@archiver.kernel.org>; Fri, 22 Sep 2023 01:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjIVBit (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Sep 2023 21:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjIVBip (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Sep 2023 21:38:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C9DF5
        for <mm-commits@vger.kernel.org>; Thu, 21 Sep 2023 18:38:38 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D21CC433C7;
        Fri, 22 Sep 2023 01:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695346718;
        bh=OooVedGdxWScV3OeiEVaW8U294maNga6Py7y41Q9SaA=;
        h=Date:To:From:Subject:From;
        b=CNRvre/1NNkR2P5Jn/a9nQHPiWHwKRnbHnex9nIOy3WH9DW2JK7X3UoifL1amGDFy
         mzRT4le3f1OBjlj2tJoV/M0lQ1iT9ZuBC7VROGpWrR8TMwkkpLzfajXQnTZRNBDFs6
         VnH2Y3JchpBYELbDoOSNjUhyghJhICCmsEuGtBPk=
Date:   Thu, 21 Sep 2023 18:38:38 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, mike.kravetz@oracle.com, hughd@google.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-make-mpol_misplaced-to-take-a-folio.patch added to mm-unstable branch
Message-Id: <20230922013838.8D21CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mempolicy: make mpol_misplaced() to take a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-make-mpol_misplaced-to-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-make-mpol_misplaced-to-take-a-folio.patch

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
Subject: mm: mempolicy: make mpol_misplaced() to take a folio
Date: Thu, 21 Sep 2023 15:44:16 +0800

In preparation for large folio numa balancing, make mpol_misplaced() to
take a folio, no functional change intended.

Link: https://lkml.kernel.org/r/20230921074417.24004-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    5 +++--
 mm/memory.c               |    2 +-
 mm/mempolicy.c            |   22 ++++++++++++----------
 3 files changed, 16 insertions(+), 13 deletions(-)

--- a/include/linux/mempolicy.h~mm-mempolicy-make-mpol_misplaced-to-take-a-folio
+++ a/include/linux/mempolicy.h
@@ -174,7 +174,7 @@ extern void mpol_to_str(char *buffer, in
 /* Check if a vma is migratable */
 extern bool vma_migratable(struct vm_area_struct *vma);
 
-extern int mpol_misplaced(struct page *, struct vm_area_struct *, unsigned long);
+int mpol_misplaced(struct folio *, struct vm_area_struct *, unsigned long);
 extern void mpol_put_task_policy(struct task_struct *);
 
 static inline bool mpol_is_preferred_many(struct mempolicy *pol)
@@ -278,7 +278,8 @@ static inline int mpol_parse_str(char *s
 }
 #endif
 
-static inline int mpol_misplaced(struct page *page, struct vm_area_struct *vma,
+static inline int mpol_misplaced(struct folio *folio,
+				 struct vm_area_struct *vma,
 				 unsigned long address)
 {
 	return -1; /* no node preference */
--- a/mm/memory.c~mm-mempolicy-make-mpol_misplaced-to-take-a-folio
+++ a/mm/memory.c
@@ -4741,7 +4741,7 @@ int numa_migrate_prep(struct folio *foli
 		*flags |= TNF_FAULT_LOCAL;
 	}
 
-	return mpol_misplaced(&folio->page, vma, addr);
+	return mpol_misplaced(folio, vma, addr);
 }
 
 static vm_fault_t do_numa_page(struct vm_fault *vmf)
--- a/mm/mempolicy.c~mm-mempolicy-make-mpol_misplaced-to-take-a-folio
+++ a/mm/mempolicy.c
@@ -2568,24 +2568,25 @@ static void sp_free(struct sp_node *n)
 }
 
 /**
- * mpol_misplaced - check whether current page node is valid in policy
+ * mpol_misplaced - check whether current folio node is valid in policy
  *
- * @page: page to be checked
- * @vma: vm area where page mapped
- * @addr: virtual address where page mapped
+ * @folio: folio to be checked
+ * @vma: vm area where folio mapped
+ * @addr: virtual address in @vma for shared policy lookup and interleave policy
  *
- * Lookup current policy node id for vma,addr and "compare to" page's
+ * Lookup current policy node id for vma,addr and "compare to" folio's
  * node id.  Policy determination "mimics" alloc_page_vma().
  * Called from fault path where we know the vma and faulting address.
  *
  * Return: NUMA_NO_NODE if the page is in a node that is valid for this
- * policy, or a suitable node ID to allocate a replacement page from.
+ * policy, or a suitable node ID to allocate a replacement folio from.
  */
-int mpol_misplaced(struct page *page, struct vm_area_struct *vma, unsigned long addr)
+int mpol_misplaced(struct folio *folio, struct vm_area_struct *vma,
+		   unsigned long addr)
 {
 	struct mempolicy *pol;
 	struct zoneref *z;
-	int curnid = page_to_nid(page);
+	int curnid = folio_nid(folio);
 	unsigned long pgoff;
 	int thiscpu = raw_smp_processor_id();
 	int thisnid = cpu_to_node(thiscpu);
@@ -2641,11 +2642,12 @@ int mpol_misplaced(struct page *page, st
 		BUG();
 	}
 
-	/* Migrate the page towards the node whose CPU is referencing it */
+	/* Migrate the folio towards the node whose CPU is referencing it */
 	if (pol->flags & MPOL_F_MORON) {
 		polnid = thisnid;
 
-		if (!should_numa_migrate_memory(current, page, curnid, thiscpu))
+		if (!should_numa_migrate_memory(current, &folio->page, curnid,
+						thiscpu))
 			goto out;
 	}
 
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

