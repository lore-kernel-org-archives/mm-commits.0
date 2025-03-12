Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A470D1DE3A4;
	Wed, 12 Mar 2025 22:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741819200; cv=none; b=BSCIdTy4HKbDqYz0hPgaeY0fAN/LxTYOV1VhsEToiQHlPD0wVPHVk/tYx1LEgiaZ/gOnDRRUntWGZcVA/M83SCkIMY2llOfT1av+dbw7UwmeSmI0NqAIvq7tV0zv52UJ3+xIH0RZbCPKzq+yEA+bMMI5HJP1w6Lig1hBcOO1TT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741819200; c=relaxed/simple;
	bh=VDMM2O2D43FkaPH94FVgj78/Auq6skvSQ+8RnfmcV50=;
	h=Date:To:From:Subject:Message-Id; b=k3CTsHbeyqemDDkaOBWZByrjK0DeZ0LKQoFzKZOf353CndH3hZi9axgD4W0uMOX44qOcYq1PM4ZYbK3ZH/lyQDE34DscfzQjawqX4jLZ2w9deEMbA+kJ+GSrdPbajGK35TDlt604BeJi99/mQI/2XSpTmD1+6wcCffvHdLNs1VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OBIeyMsk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OBIeyMsk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197E0C4CEDD;
	Wed, 12 Mar 2025 22:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741819200;
	bh=VDMM2O2D43FkaPH94FVgj78/Auq6skvSQ+8RnfmcV50=;
	h=Date:To:From:Subject:From;
	b=OBIeyMsk73wldRty+EOydAi3h1Mo+1g03kZY12M2uZbwrO3cfFPFvE1b497B0TX1a
	 nYrgBNeJuo8nfkm7cAw9xwqTYH/r4tczwTTlcV0IMO4dDDf5TjBvRvOJ8OOquZISgN
	 uDVEtBpVGcjs7yHIIjzVd7CxUdxSe8Z7jYbUGgOM=
Date: Wed, 12 Mar 2025 15:39:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,stable@vger.kernel.org,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-contig_alloc-fix-alloc_contig_range-when-__gfp_comp-and-order-max_order.patch added to mm-hotfixes-unstable branch
Message-Id: <20250312224000.197E0C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/contig_alloc: fix alloc_contig_range when __GFP_COMP and order < MAX_ORDER
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-contig_alloc-fix-alloc_contig_range-when-__gfp_comp-and-order-max_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-contig_alloc-fix-alloc_contig_range-when-__gfp_comp-and-order-max_order.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/contig_alloc: fix alloc_contig_range when __GFP_COMP and order < MAX_ORDER
Date: Wed, 12 Mar 2025 16:47:05 +0800

When calling alloc_contig_range() with __GFP_COMP and the order of
requested pfn range is pageblock_order, less than MAX_ORDER, I triggered
WARNING as follows:

 PFN range: requested [2150105088, 2150105600), allocated [2150105088, 2150106112)
 WARNING: CPU: 3 PID: 580 at mm/page_alloc.c:6877 alloc_contig_range+0x280/0x340

alloc_contig_range() marks pageblocks of the requested pfn range to be
isolated, migrate these pages if they are in use and will be freed to
MIGRATE_ISOLATED freelist.

Suppose two alloc_contig_range() calls at the same time and the requested
pfn range are [0x80280000, 0x80280200) and [0x80280200, 0x80280400)
respectively.  Suppose the two memory range are in use, then
alloc_contig_range() will migrate and free these pages to MIGRATE_ISOLATED
freelist.  __free_one_page() will merge MIGRATE_ISOLATE buddy to larger
buddy, resulting in a MAX_ORDER buddy.  Finally, find_large_buddy() in
alloc_contig_range() returns a MAX_ORDER buddy and results in WARNING.

To fix it, call free_contig_range() to free the excess pfn range.

Link: https://lkml.kernel.org/r/20250312084705.2938220-1-tujinjiang@huawei.com
Fixes: e98337d11bbd ("mm/contig_alloc: support __GFP_COMP")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-contig_alloc-fix-alloc_contig_range-when-__gfp_comp-and-order-max_order
+++ a/mm/page_alloc.c
@@ -6528,7 +6528,8 @@ int alloc_contig_range_noprof(unsigned l
 		goto done;
 	}
 
-	if (!(gfp_mask & __GFP_COMP)) {
+	if (!(gfp_mask & __GFP_COMP) ||
+		(is_power_of_2(end - start) && ilog2(end - start) < MAX_PAGE_ORDER)) {
 		split_free_pages(cc.freepages, gfp_mask);
 
 		/* Free head and tail (if any) */
@@ -6536,7 +6537,15 @@ int alloc_contig_range_noprof(unsigned l
 			free_contig_range(outer_start, start - outer_start);
 		if (end != outer_end)
 			free_contig_range(end, outer_end - end);
-	} else if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
+
+		outer_start = start;
+		outer_end = end;
+
+		if (!(gfp_mask & __GFP_COMP))
+			goto done;
+	}
+
+	if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
 		struct page *head = pfn_to_page(start);
 		int order = ilog2(end - start);
 
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-hugetlb-fix-surplus-pages-in-dissolve_free_huge_page.patch
mm-contig_alloc-fix-alloc_contig_range-when-__gfp_comp-and-order-max_order.patch
mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages.patch

