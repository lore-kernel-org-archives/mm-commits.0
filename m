Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFE2173338
	for <mm-commits@vger.kernel.org>; Fri,  5 Apr 2024 20:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712347608; cv=none; b=HjlP0TKURi2ndfYp7Mr/d1XjMqLXh+nZhTPAz+/eMjF4t1komC/7Suqs75g6qxHZLdRIc6zZI0wJonGhzcQxycdOWGcyvhFYv0UOsa7Rq6jnERHP/ZLOoCwqkveYDHfXLhmIGPTqgAVnUJpnG8trEgXU2MTinLa+sjbLrHO057o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712347608; c=relaxed/simple;
	bh=+7k/l1Pr+bm1yPFuoiwASQDqIPx+TaiZJzJkjmF+jwA=;
	h=Date:To:From:Subject:Message-Id; b=UrUkbxgC5rFiv5ba4eULxtPeuy1WQk92TMSIbInMhEI75BAA5oeGKyWSL2FZpKeNZzXA4ZYzNnRNs88+fil1y8RI1BauQkBySGz5a1/zcevd9NgfeIHw0NXpJ0r4OpsZBM47Hp63swjFHuXILfwjmrC9QxjLvjv9cZ44Av7LCPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IrLHFbiT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IrLHFbiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B5AC433C7;
	Fri,  5 Apr 2024 20:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712347607;
	bh=+7k/l1Pr+bm1yPFuoiwASQDqIPx+TaiZJzJkjmF+jwA=;
	h=Date:To:From:Subject:From;
	b=IrLHFbiTXhi1kK0Nmk4wCgWjmB/D2ToTIlsWqbKpy0Jzx13dfbgJawMrqDhJ2ntzU
	 l4WcANw+o8QHnIpQRKdJ1M2IId019gwXYTuvtj30iQFDyofg10N8FocWl8Uljgd3/Z
	 5p0bPxo4t3IdF5eCc7JGTwr7cwLLo6cr7QelLRYQ=
Date: Fri, 05 Apr 2024 13:06:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,vbabka@suse.cz,mgorman@techsingularity.net,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-freelist-movement-during-block-conversion-fix.patch added to mm-unstable branch
Message-Id: <20240405200647.77B5AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_alloc-fix-freelist-movement-during-block-conversion-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-fix-freelist-movement-during-block-conversion-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-freelist-movement-during-block-conversion-fix.patch

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

mm-page_alloc-fix-freelist-movement-during-block-conversion-fix.patch
mm-record-the-migration-reason-for-struct-migration_target_control.patch
mm-hugetlb-make-the-hugetlb-migration-strategy-consistent.patch
docs-hugetlbpagerst-add-hugetlb-migration-description.patch
mm-factor-out-the-numa-mapping-rebuilding-into-a-new-helper.patch
mm-support-multi-size-thp-numa-balancing.patch
mm-support-multi-size-thp-numa-balancing-v3.patch
mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics.patch
mm-page_alloc-use-the-correct-thp-order-for-thp-pcp.patch
mm-set-pageblock_order-to-hpage_pmd_order-in-case-with-config_hugetlb_page-but-thp-enabled.patch

