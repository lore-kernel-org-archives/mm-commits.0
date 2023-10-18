Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1821CDB482
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 15:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbjJRPhX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 11:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344724AbjJRPhS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 11:37:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C372313D
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 08:37:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571D1C433C8;
        Wed, 18 Oct 2023 15:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697643435;
        bh=Euoks1vD6WAxG1I/WZQOqFKTQzf3/hxWUcXP4o0tdEc=;
        h=Date:To:From:Subject:From;
        b=c/o+AkugBaQlGkG1dWlGjmI8Jcn1o8nd6/fD/JoFha4CM2+RPcOXFlXVMmNB1tGFL
         9HpuRHJMm3hZlB6iDyHr3fvoY196V7L1L8lus4eb59z869/kyYWDbiu+483/pM9Tc/
         wwDUJ/gDKQY2uTHRvgNy6+uyTvvjU82QGfw+iGhw=
Date:   Wed, 18 Oct 2023 08:37:14 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vincent.guittot@linaro.org,
        peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-use-a-folio-in-change_pte_range.patch added to mm-unstable branch
Message-Id: <20231018153715.571D1C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mprotect: use a folio in change_pte_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mprotect-use-a-folio-in-change_pte_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mprotect-use-a-folio-in-change_pte_range.patch

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
Subject: mm: mprotect: use a folio in change_pte_range()
Date: Wed, 18 Oct 2023 22:07:56 +0800

Use a folio in change_pte_range() to save three compound_head() calls.
Since now only normal and PMD-mapped page is handled by numa balancing,
it is enough to only update the entire folio's access time.

Link: https://lkml.kernel.org/r/20231018140806.2783514-10-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/mm/mprotect.c~mm-mprotect-use-a-folio-in-change_pte_range
+++ a/mm/mprotect.c
@@ -114,7 +114,7 @@ static long change_pte_range(struct mmu_
 			 * pages. See similar comment in change_huge_pmd.
 			 */
 			if (prot_numa) {
-				struct page *page;
+				struct folio *folio;
 				int nid;
 				bool toptier;
 
@@ -122,13 +122,14 @@ static long change_pte_range(struct mmu_
 				if (pte_protnone(oldpte))
 					continue;
 
-				page = vm_normal_page(vma, addr, oldpte);
-				if (!page || is_zone_device_page(page) || PageKsm(page))
+				folio = vm_normal_folio(vma, addr, oldpte);
+				if (!folio || folio_is_zone_device(folio) ||
+				    folio_test_ksm(folio))
 					continue;
 
 				/* Also skip shared copy-on-write pages */
 				if (is_cow_mapping(vma->vm_flags) &&
-				    page_count(page) != 1)
+				    folio_ref_count(folio) != 1)
 					continue;
 
 				/*
@@ -136,14 +137,15 @@ static long change_pte_range(struct mmu_
 				 * it cannot move them all from MIGRATE_ASYNC
 				 * context.
 				 */
-				if (page_is_file_lru(page) && PageDirty(page))
+				if (folio_is_file_lru(folio) &&
+				    folio_test_dirty(folio))
 					continue;
 
 				/*
 				 * Don't mess with PTEs if page is already on the node
 				 * a single-threaded process is running on.
 				 */
-				nid = page_to_nid(page);
+				nid = folio_nid(folio);
 				if (target_node == nid)
 					continue;
 				toptier = node_is_toptier(nid);
@@ -157,7 +159,7 @@ static long change_pte_range(struct mmu_
 					continue;
 				if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING &&
 				    !toptier)
-					xchg_page_access_time(page,
+					folio_xchg_access_time(folio,
 						jiffies_to_msecs(jiffies));
 			}
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm_types-add-virtual-and-_last_cpupid-into-struct-folio.patch
mm-add-folio_last_cpupid.patch
mm-memory-use-folio_last_cpupid-in-do_numa_page.patch
mm-huge_memory-use-folio_last_cpupid-in-do_huge_pmd_numa_page.patch
mm-huge_memory-use-folio_last_cpupid-in-__split_huge_page_tail.patch
mm-remove-page_cpupid_last.patch
mm-add-folio_xchg_access_time.patch
sched-fair-use-folio_xchg_access_time-in-numa_hint_fault_latency.patch
mm-mprotect-use-a-folio-in-change_pte_range.patch
mm-huge_memory-use-a-folio-in-change_huge_pmd.patch
mm-remove-xchg_page_access_time.patch
mm-add-folio_xchg_last_cpupid.patch
sched-fair-use-folio_xchg_last_cpupid-in-should_numa_migrate_memory.patch
mm-migrate-use-folio_xchg_last_cpupid-in-folio_migrate_flags.patch
mm-huge_memory-use-folio_xchg_last_cpupid-in-__split_huge_page_tail.patch
mm-make-finish_mkwrite_fault-static.patch
mm-convert-wp_page_reuse-and-finish_mkwrite_fault-to-take-a-folio.patch
mm-use-folio_xchg_last_cpupid-in-wp_page_reuse.patch
mm-remove-page_cpupid_xchg_last.patch

