Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91E96C25B6F
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235003AbjJYXtd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234796AbjJYXsr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FB7D58
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA53AC433C8;
        Wed, 25 Oct 2023 23:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277721;
        bh=EVV3aR7EmjYp+W1oSzRyn7DtqJV1nByyQUlQi+1KZ2w=;
        h=Date:To:From:Subject:From;
        b=PGew/ad8LsFEHZUd2Iu/52SZ3EM/Vz/NAxIBr6prOImIPs+5J8ciSh2a/974+FYL1
         1uOebYHG7EyLs8xY3dYx/Bc9zTD0ZDeej6kE7SlVprj+uQHVcVUxx9YEkPUnuYVjbI
         jSyOy814AZfZQAOpaf8+5vgYapFwyEi8J/zJFxUA=
Date:   Wed, 25 Oct 2023 16:48:40 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vincent.guittot@linaro.org,
        peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mprotect-use-a-folio-in-change_pte_range.patch removed from -mm tree
Message-Id: <20231025234840.EA53AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: mprotect: use a folio in change_pte_range()
has been removed from the -mm tree.  Its filename was
     mm-mprotect-use-a-folio-in-change_pte_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


