Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27EF7C25B6B
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234728AbjJYXtd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234772AbjJYXsr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A83187
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:42 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA794C433C7;
        Wed, 25 Oct 2023 23:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277721;
        bh=gAB7AXmiwL6j0wb8nC/oeIV7vNkojISAKTU/Vn4xIKw=;
        h=Date:To:From:Subject:From;
        b=yHNVhYfrc3TjzKmLpqcYGbQEeHNRciuJtOYWJWMlfs1Gxjniad9CwXVuSJS5SMioI
         UVFeeX6zcPBKqiEfvMZ90S124anknL9fKoeERJoSE/PV9+bYZ0IXqlpqsypw49NvEH
         4cQv7VoguRNhlC1h7nJrp1ddd3sHqB2dRu2Vi4ig=
Date:   Wed, 25 Oct 2023 16:48:41 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vincent.guittot@linaro.org,
        peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-use-a-folio-in-change_huge_pmd.patch removed from -mm tree
Message-Id: <20231025234841.CA794C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: huge_memory: use a folio in change_huge_pmd()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-use-a-folio-in-change_huge_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: huge_memory: use a folio in change_huge_pmd()
Date: Wed, 18 Oct 2023 22:07:57 +0800

Use a folio in change_huge_pmd(), which helps to remove last
xchg_page_access_time() caller.

Link: https://lkml.kernel.org/r/20231018140806.2783514-11-wangkefeng.wang@huawei.com
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

 mm/huge_memory.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-a-folio-in-change_huge_pmd
+++ a/mm/huge_memory.c
@@ -1856,7 +1856,7 @@ int change_huge_pmd(struct mmu_gather *t
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 	if (is_swap_pmd(*pmd)) {
 		swp_entry_t entry = pmd_to_swp_entry(*pmd);
-		struct page *page = pfn_swap_entry_to_page(entry);
+		struct folio *folio = page_folio(pfn_swap_entry_to_page(entry));
 		pmd_t newpmd;
 
 		VM_BUG_ON(!is_pmd_migration_entry(*pmd));
@@ -1865,7 +1865,7 @@ int change_huge_pmd(struct mmu_gather *t
 			 * A protection check is difficult so
 			 * just be safe and disable write
 			 */
-			if (PageAnon(page))
+			if (folio_test_anon(folio))
 				entry = make_readable_exclusive_migration_entry(swp_offset(entry));
 			else
 				entry = make_readable_migration_entry(swp_offset(entry));
@@ -1887,7 +1887,7 @@ int change_huge_pmd(struct mmu_gather *t
 #endif
 
 	if (prot_numa) {
-		struct page *page;
+		struct folio *folio;
 		bool toptier;
 		/*
 		 * Avoid trapping faults against the zero page. The read-only
@@ -1900,8 +1900,8 @@ int change_huge_pmd(struct mmu_gather *t
 		if (pmd_protnone(*pmd))
 			goto unlock;
 
-		page = pmd_page(*pmd);
-		toptier = node_is_toptier(page_to_nid(page));
+		folio = page_folio(pmd_page(*pmd));
+		toptier = node_is_toptier(folio_nid(folio));
 		/*
 		 * Skip scanning top tier node if normal numa
 		 * balancing is disabled
@@ -1912,7 +1912,8 @@ int change_huge_pmd(struct mmu_gather *t
 
 		if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING &&
 		    !toptier)
-			xchg_page_access_time(page, jiffies_to_msecs(jiffies));
+			folio_xchg_access_time(folio,
+					       jiffies_to_msecs(jiffies));
 	}
 	/*
 	 * In case prot_numa, we are under mmap_read_lock(mm). It's critical
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


