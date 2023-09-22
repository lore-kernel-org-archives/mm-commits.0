Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5CE4E7D0BB
	for <mm-commits@archiver.kernel.org>; Fri, 22 Sep 2023 01:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjIVBit (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Sep 2023 21:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjIVBim (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Sep 2023 21:38:42 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B01BCF
        for <mm-commits@vger.kernel.org>; Thu, 21 Sep 2023 18:38:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A0EC433C8;
        Fri, 22 Sep 2023 01:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695346716;
        bh=o3b4zT3qUzpVWmHEkiPCfUyOokeo2kgxAzlXfr1c3c4=;
        h=Date:To:From:Subject:From;
        b=LPXK8mbtxw7ARwDmNcw6vYYqu1epgLhWpTbTK7chAOvpq7UD0VZ+VLcNugcZ9IR/+
         8OEAnWuTkggHqnSOqgkv5QiLMoUUivAsAcEG3sUFR1IZ4LcBezkcwKc0/etrqYSKWd
         0ahuo4tG6GdMUjUYVduFrnVPpwUIL/4P7Bh/hxYc=
Date:   Thu, 21 Sep 2023 18:38:35 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, mike.kravetz@oracle.com, hughd@google.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-make-numa_migrate_prep-to-take-a-folio.patch added to mm-unstable branch
Message-Id: <20230922013836.38A0EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory: make numa_migrate_prep() to take a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-make-numa_migrate_prep-to-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-make-numa_migrate_prep-to-take-a-folio.patch

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
@@ -984,7 +984,7 @@ void vunmap_range_noflush(unsigned long
 
 void __vunmap_range_noflush(unsigned long start, unsigned long end);
 
-int numa_migrate_prep(struct page *page, struct vm_area_struct *vma,
+int numa_migrate_prep(struct folio *folio, struct vm_area_struct *vma,
 		      unsigned long addr, int page_nid, int *flags);
 
 void free_zone_device_page(struct page *page);
--- a/mm/memory.c~mm-memory-make-numa_migrate_prep-to-take-a-folio
+++ a/mm/memory.c
@@ -4727,10 +4727,10 @@ static vm_fault_t do_fault(struct vm_fau
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
@@ -4741,7 +4741,7 @@ int numa_migrate_prep(struct page *page,
 		*flags |= TNF_FAULT_LOCAL;
 	}
 
-	return mpol_misplaced(page, vma, addr);
+	return mpol_misplaced(&folio->page, vma, addr);
 }
 
 static vm_fault_t do_numa_page(struct vm_fault *vmf)
@@ -4815,8 +4815,7 @@ static vm_fault_t do_numa_page(struct vm
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

