Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68FA9C46CA1
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 15:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbjJRPhe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 11:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235332AbjJRPhb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 11:37:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA2812E
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 08:37:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E568C433C8;
        Wed, 18 Oct 2023 15:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697643444;
        bh=IXGPX4HAadjnn7YCOGRQSIy7LnjyBiSttLTkbxGrij0=;
        h=Date:To:From:Subject:From;
        b=Rimqy1IQ6sgGe6Lbkh9vWlbabI4l35aPx0p7kIEhpSi6+LOVtytXIY8nkrykuCD0y
         MtJjNgWYmeue4kUilO2pUsIpzEdlUZ9RdeDU2CuGdL0CwMFlgmIZ90sIvbz3lLsxoh
         Mo4e6uveUGuETHxH8BkjfiKY9ZvjV8f0+K6m7CfY=
Date:   Wed, 18 Oct 2023 08:37:24 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vincent.guittot@linaro.org,
        peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-use-folio_xchg_last_cpupid-in-folio_migrate_flags.patch added to mm-unstable branch
Message-Id: <20231018153724.9E568C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: use folio_xchg_last_cpupid() in folio_migrate_flags()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-use-folio_xchg_last_cpupid-in-folio_migrate_flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-use-folio_xchg_last_cpupid-in-folio_migrate_flags.patch

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
Subject: mm: migrate: use folio_xchg_last_cpupid() in folio_migrate_flags()
Date: Wed, 18 Oct 2023 22:08:01 +0800

Convert to use folio_xchg_last_cpupid() in folio_migrate_flags(), also
directly use folio_nid() instead of page_to_nid(&folio->page).

Link: https://lkml.kernel.org/r/20231018140806.2783514-15-wangkefeng.wang@huawei.com
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

 mm/migrate.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/migrate.c~mm-migrate-use-folio_xchg_last_cpupid-in-folio_migrate_flags
+++ a/mm/migrate.c
@@ -588,20 +588,20 @@ void folio_migrate_flags(struct folio *n
 	 * Copy NUMA information to the new page, to prevent over-eager
 	 * future migrations of this same page.
 	 */
-	cpupid = page_cpupid_xchg_last(&folio->page, -1);
+	cpupid = folio_xchg_last_cpupid(folio, -1);
 	/*
 	 * For memory tiering mode, when migrate between slow and fast
 	 * memory node, reset cpupid, because that is used to record
 	 * page access time in slow memory node.
 	 */
 	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) {
-		bool f_toptier = node_is_toptier(page_to_nid(&folio->page));
-		bool t_toptier = node_is_toptier(page_to_nid(&newfolio->page));
+		bool f_toptier = node_is_toptier(folio_nid(folio));
+		bool t_toptier = node_is_toptier(folio_nid(newfolio));
 
 		if (f_toptier != t_toptier)
 			cpupid = -1;
 	}
-	page_cpupid_xchg_last(&newfolio->page, cpupid);
+	folio_xchg_last_cpupid(newfolio, cpupid);
 
 	folio_migrate_ksm(newfolio, folio);
 	/*
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

