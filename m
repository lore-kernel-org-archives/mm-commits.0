Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22772F24
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 19:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712173571; cv=none; b=gBt6aShc9DwyXtUrOs00Fwde7gbNyWnx6g9XMPotMOiCgCnIIeu+G+mdVTje9qX1uayuAlVudq05nK3sj+28F7sjP8J0eradjzVURbDUT5XFyGVevilKIUs4NnOFDtTJE/x8gogpV4B5BnVveWeE2DHjQ2mwIUrb84ByHDg5mOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712173571; c=relaxed/simple;
	bh=EvmCHBouzkWhr06HET62yu4laHBAI+NUNTPeNHZmdIo=;
	h=Date:To:From:Subject:Message-Id; b=fciLs8uFWA7dNlwvDCjnVgzL5v/3YYThj7HibuBQI3c9SfHvVn7dyMw4yGbnvhsWUmPebfzpU0Dt4Nfal5FN1erMo2aDruuI+eapMiCAjCcpyxPwfVGE+Gp6U63/LrMWVKWfNORX0wa1Qr+BQ9OXI6+0bfsPH3P3z6IoA9qKQww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q52dshz5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q52dshz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0DAC433C7;
	Wed,  3 Apr 2024 19:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712173569;
	bh=EvmCHBouzkWhr06HET62yu4laHBAI+NUNTPeNHZmdIo=;
	h=Date:To:From:Subject:From;
	b=Q52dshz5hy0RN6xJS1IXwbe8TMAfYV/f9f42VGA3oRoKorV0zt83mfgFMw8i3OjPD
	 WD2CAue6mYcF0kd6rHY4O9LR/MWRrIrSIgIz4YeBOSgcTpARvhUYLYGxgbZIJ3EQ+4
	 ZMgFVfOU2HVSu9zXgZ5tqln1UMxRj+yOIukQfwOc=
Date: Wed, 03 Apr 2024 12:46:08 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mgorman@techsingularity.net,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-use-the-correct-thp-order-for-thp-pcp.patch added to mm-unstable branch
Message-Id: <20240403194609.5B0DAC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: use the correct THP order for THP PCP
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-use-the-correct-thp-order-for-thp-pcp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-use-the-correct-thp-order-for-thp-pcp.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: page_alloc: use the correct THP order for THP PCP
Date: Wed, 3 Apr 2024 21:47:21 +0800

Commit 44042b449872 ("mm/page_alloc: allow high-order pages to be stored
on the per-cpu lists") extends the PCP allocator to store THP pages, and
it determines whether to cache THP pages in PCP by comparing with
pageblock_order.  But the pageblock_order is not always equal to THP
order.  It might also be MAX_PAGE_ORDER, which could prevent PCP from
caching THP pages.

Therefore, using HPAGE_PMD_ORDER instead to determine the need for caching
THP for PCP will fix this issue

Link: https://lkml.kernel.org/r/a25c9e14cd03907d5978b60546a69e6aa3fc2a7d.1712151833.git.baolin.wang@linux.alibaba.com
Fixes: 44042b449872 ("mm/page_alloc: allow high-order pages to be stored on the per-cpu lists")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-use-the-correct-thp-order-for-thp-pcp
+++ a/mm/page_alloc.c
@@ -506,7 +506,7 @@ static inline unsigned int order_to_pind
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	if (order > PAGE_ALLOC_COSTLY_ORDER) {
-		VM_BUG_ON(order != pageblock_order);
+		VM_BUG_ON(order != HPAGE_PMD_ORDER);
 		return NR_LOWORDER_PCP_LISTS;
 	}
 #else
@@ -522,7 +522,7 @@ static inline int pindex_to_order(unsign
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	if (pindex == NR_LOWORDER_PCP_LISTS)
-		order = pageblock_order;
+		order = HPAGE_PMD_ORDER;
 #else
 	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
 #endif
@@ -535,7 +535,7 @@ static inline bool pcp_allowed_order(uns
 	if (order <= PAGE_ALLOC_COSTLY_ORDER)
 		return true;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (order == pageblock_order)
+	if (order == HPAGE_PMD_ORDER)
 		return true;
 #endif
 	return false;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-record-the-migration-reason-for-struct-migration_target_control.patch
mm-hugetlb-make-the-hugetlb-migration-strategy-consistent.patch
docs-hugetlbpagerst-add-hugetlb-migration-description.patch
mm-factor-out-the-numa-mapping-rebuilding-into-a-new-helper.patch
mm-support-multi-size-thp-numa-balancing.patch
mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics.patch
mm-page_alloc-use-the-correct-thp-order-for-thp-pcp.patch

