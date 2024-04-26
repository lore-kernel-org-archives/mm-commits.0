Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0698473
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101485; cv=none; b=m7l1ls3fNpRnzJcqQFNwNpHVbVnG76QJdVGjq3EKtlf/v9UMHefd2PXdCqFJl0w1Ds98hfzu38NyJbwozustqJI0mS7a3XGJ5PAdr4XgyDm0cCw64T3TZdNqo/QMRnFRNlBtM1Cog90eeYmkNUHkIhZb13LEG+L1ecsS4nbv9K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101485; c=relaxed/simple;
	bh=HGjiGMsr+7tPp1z/7if7fFYJ3daZIrdoshLHWRsbNZo=;
	h=Date:To:From:Subject:Message-Id; b=n/XBu2Bg+czC20uCrE2NnDI3OjTjDXZRgDG8etKX3Z7dgM6neZsOZlJleEm9EQChFgW+cGMlVcBVyGG1109dtC53BB6czbXBvFtzt+I7PddYHUB0RPfgxWyUgXCUF2V51cv0XuTZ37jsZDeAPptvCJuno8u4gykZG1F1Q8syz8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mjlJoc5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mjlJoc5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992FDC113CD;
	Fri, 26 Apr 2024 03:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101485;
	bh=HGjiGMsr+7tPp1z/7if7fFYJ3daZIrdoshLHWRsbNZo=;
	h=Date:To:From:Subject:From;
	b=mjlJoc5E7tapXQOfq/ybCu8uSHay6I6wKdIKsCu4Z99FJAwQ3Lts6jCSiQh5eGwuE
	 pxzLiBrRqgVeM4CBzI0VsLV38YmYXdYD67F+Hbvi3DjnML3nGH7NN9G9I8RmcIaiPW
	 P4ZNaEB+3XXazLeV4u7RmeE0vaiZXtjwPVpqKFm4=
Date: Thu, 25 Apr 2024 20:18:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,vbabka@suse.cz,mgorman@techsingularity.net,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-fix-freelist-movement-during-block-conversion-fix.patch removed from -mm tree
Message-Id: <20240426031805.992FDC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-page_alloc-fix-freelist-movement-during-block-conversion-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-freelist-movement-during-block-conversion-fix.patch

This patch was dropped because it was folded into mm-page_alloc-fix-freelist-movement-during-block-conversion.patch

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm-page_alloc-fix-freelist-movement-during-block-conversion-fix
Date: Fri, 5 Apr 2024 20:11:47 +0800

fix allocation failures with CONFIG_CMA

The original code logic was that if the 'migratetype' type allocation is
failed, it would first try CMA page allocation and then attempt to
fallback to other migratetype allocations.  Now it has been changed so
that if CMA allocation fails, it will directly return.  This change has
caused a regression when I running the thpcompact benchmark, resulting in
a significant reduction in the percentage of THPs like below:

thpcompact Percentage Faults Huge
                          K6.9-rc2                K6.9-rc2 + this patch
Percentage huge-1        78.18 (   0.00%)       42.49 ( -45.65%)
Percentage huge-3        86.70 (   0.00%)       35.13 ( -59.49%)
Percentage huge-5        90.26 (   0.00%)       52.35 ( -42.00%)
Percentage huge-7        92.34 (   0.00%)       31.84 ( -65.52%)
Percentage huge-12       91.18 (   0.00%)       45.85 ( -49.72%)
Percentage huge-18       89.00 (   0.00%)       29.18 ( -67.22%)
Percentage huge-24       90.52 (   0.00%)       46.68 ( -48.43%)
Percentage huge-30       94.44 (   0.00%)       38.35 ( -59.39%)
Percentage huge-32       93.09 (   0.00%)       39.37 ( -57.70%)

After making the following modifications, the regression is gone.

Link: https://lkml.kernel.org/r/a97697e0-45b0-4f71-b087-fdc7a1d43c0e@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-freelist-movement-during-block-conversion-fix
+++ a/mm/page_alloc.c
@@ -2139,7 +2139,8 @@ __rmqueue(struct zone *zone, unsigned in
 	if (unlikely(!page)) {
 		if (alloc_flags & ALLOC_CMA)
 			page = __rmqueue_cma_fallback(zone, order);
-		else
+
+		if (!page)
 			page = __rmqueue_fallback(zone, order, migratetype,
 						  alloc_flags);
 	}
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-page_alloc-fix-freelist-movement-during-block-conversion.patch
mm-page_alloc-consolidate-free-page-accounting-fix-3.patch
mm-record-the-migration-reason-for-struct-migration_target_control.patch
mm-hugetlb-make-the-hugetlb-migration-strategy-consistent.patch
docs-hugetlbpagerst-add-hugetlb-migration-description.patch
mm-factor-out-the-numa-mapping-rebuilding-into-a-new-helper.patch
mm-support-multi-size-thp-numa-balancing.patch
mm-support-multi-size-thp-numa-balancing-v3.patch
mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics.patch
mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics-v2.patch
mm-page_alloc-use-the-correct-thp-order-for-thp-pcp.patch
mm-set-pageblock_order-to-hpage_pmd_order-in-case-with-config_hugetlb_page-but-thp-enabled.patch
mm-page_alloc-allowing-mthp-compaction-to-capture-the-freed-page-directly.patch

