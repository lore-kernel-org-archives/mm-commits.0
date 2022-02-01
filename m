Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 269E3C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  1 Feb 2022 22:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238450AbiBAWUU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Feb 2022 17:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238410AbiBAWUU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2022 17:20:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C86EFC061714
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 14:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86081B82F49
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 22:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1B9C340EB;
        Tue,  1 Feb 2022 22:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643754017;
        bh=aIQ78c2P+cRcTZfflHvGJUF6uoVsOLlLx91T7tXomPE=;
        h=Date:To:From:Subject:From;
        b=ZgEY1dulbV3aBmKkNSA9mAiZCd03t/c7XmREbUwkPpWEXv4OQYdfnZaweOywc++NS
         4izzr5eMrP/R/+WeNy0Hup8B1Hdl/VzecTvKKjHC5fNa6Q7tNftsrEHO7UdB5uKkw1
         bQ8GB0hPGv/3fAOYN5dw9BFNH6uDb736xVIng264=
Received: by hp1 (sSMTP sendmail emulation); Tue, 01 Feb 2022 14:20:15 -0800
Date:   Tue, 01 Feb 2022 14:20:15 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        zhongjiang-ali@linux.alibaba.com, weixugc@google.com,
        shy828301@gmail.com, shakeelb@google.com, riel@surriel.com,
        peterz@infradead.org, osalvador@suse.de, mhocko@suse.com,
        mgorman@techsingularity.net, hasanalmaruf@fb.com,
        feng.tang@intel.com, dave.hansen@linux.intel.com,
        baolin.wang@linux.alibaba.com, ying.huang@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-tiering-skip-to-scan-fast-memory.patch added to -mm tree
Message-Id: <20220201222015.CD1B9C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memory tiering: skip to scan fast memory
has been added to the -mm tree.  Its filename is
     memory-tiering-skip-to-scan-fast-memory.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memory-tiering-skip-to-scan-fast-memory.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memory-tiering-skip-to-scan-fast-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: memory tiering: skip to scan fast memory

If the NUMA balancing isn't used to optimize the page placement among
sockets but only among memory types, the hot pages in the fast memory node
couldn't be migrated (promoted) to anywhere.  So it's unnecessary to scan
the pages in the fast memory node via changing their PTE/PMD mapping to be
PROT_NONE.  So that the page faults could be avoided too.

In the test, if only the memory tiering NUMA balancing mode is enabled,
the number of the NUMA balancing hint faults for the DRAM node is reduced
to almost 0 with the patch.  While the benchmark score doesn't change
visibly.

Link: https://lkml.kernel.org/r/20220128082751.593478-4-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: zhongjiang-ali <zhongjiang-ali@linux.alibaba.com>
Cc: Hasan Al Maruf <hasanalmaruf@fb.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Wei Xu <weixugc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   30 +++++++++++++++++++++---------
 mm/mprotect.c    |   13 ++++++++++++-
 2 files changed, 33 insertions(+), 10 deletions(-)

--- a/mm/huge_memory.c~memory-tiering-skip-to-scan-fast-memory
+++ a/mm/huge_memory.c
@@ -34,6 +34,7 @@
 #include <linux/oom.h>
 #include <linux/numa.h>
 #include <linux/page_owner.h>
+#include <linux/sched/sysctl.h>
 
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
@@ -1774,17 +1775,28 @@ int change_huge_pmd(struct vm_area_struc
 	}
 #endif
 
-	/*
-	 * Avoid trapping faults against the zero page. The read-only
-	 * data is likely to be read-cached on the local CPU and
-	 * local/remote hits to the zero page are not interesting.
-	 */
-	if (prot_numa && is_huge_zero_pmd(*pmd))
-		goto unlock;
+	if (prot_numa) {
+		struct page *page;
+		/*
+		 * Avoid trapping faults against the zero page. The read-only
+		 * data is likely to be read-cached on the local CPU and
+		 * local/remote hits to the zero page are not interesting.
+		 */
+		if (is_huge_zero_pmd(*pmd))
+			goto unlock;
 
-	if (prot_numa && pmd_protnone(*pmd))
-		goto unlock;
+		if (pmd_protnone(*pmd))
+			goto unlock;
 
+		page = pmd_page(*pmd);
+		/*
+		 * Skip scanning top tier node if normal numa
+		 * balancing is disabled
+		 */
+		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
+		    node_is_toptier(page_to_nid(page)))
+			goto unlock;
+	}
 	/*
 	 * In case prot_numa, we are under mmap_read_lock(mm). It's critical
 	 * to not clear pmd intermittently to avoid race with MADV_DONTNEED
--- a/mm/mprotect.c~memory-tiering-skip-to-scan-fast-memory
+++ a/mm/mprotect.c
@@ -29,6 +29,7 @@
 #include <linux/uaccess.h>
 #include <linux/mm_inline.h>
 #include <linux/pgtable.h>
+#include <linux/sched/sysctl.h>
 #include <asm/cacheflush.h>
 #include <asm/mmu_context.h>
 #include <asm/tlbflush.h>
@@ -83,6 +84,7 @@ static unsigned long change_pte_range(st
 			 */
 			if (prot_numa) {
 				struct page *page;
+				int nid;
 
 				/* Avoid TLB flush if possible */
 				if (pte_protnone(oldpte))
@@ -109,7 +111,16 @@ static unsigned long change_pte_range(st
 				 * Don't mess with PTEs if page is already on the node
 				 * a single-threaded process is running on.
 				 */
-				if (target_node == page_to_nid(page))
+				nid = page_to_nid(page);
+				if (target_node == nid)
+					continue;
+
+				/*
+				 * Skip scanning top tier node if normal numa
+				 * balancing is disabled
+				 */
+				if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
+				    node_is_toptier(nid))
 					continue;
 			}
 
_

Patches currently in -mm which might be from ying.huang@intel.com are

numa-balancing-add-page-promotion-counter.patch
numa-balancing-optimize-page-placement-for-memory-tiering-system.patch
memory-tiering-skip-to-scan-fast-memory.patch

