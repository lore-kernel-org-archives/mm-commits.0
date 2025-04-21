Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2D08BEA
	for <mm-commits@vger.kernel.org>; Mon, 21 Apr 2025 19:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745264932; cv=none; b=UUcBuObK3OSIXqkqPiKCeQ7925+ZWOzR7S9Be6URaAx5ocfxKAWV4bHwzW8Y+jfWe0RxiwkbF0xgl2Jp6aJ0//oxzp4s1hT0Vo1SoQu88ayA7iEzbDce9V7jufEh0xMlOGHHfLv4rZ/KR0/vfgkL5Kfl9jL4jIvZHXkyhhETgJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745264932; c=relaxed/simple;
	bh=kUa/+H5bKaP0seRtBPhNQRW1KABFlni9LYjArtwHTmQ=;
	h=Date:To:From:Subject:Message-Id; b=l9tKZ85yIsiY+352z2uBAUCPxqnVs9HOEX5A+J4/L+MZiaoWIsFP9fJSAJ8Zi42Ed8Ku/9JXbPj/nkjMUWELTplheRli80qQG2x5GhbhFb0CDCmKsfs9nBuC9CNCA9NFKeqnN919VHhRVhVgfAYqC6qsDTioEqDkPOyCrENxmK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IdqHy1Nd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IdqHy1Nd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37AC5C4CEE4;
	Mon, 21 Apr 2025 19:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745264932;
	bh=kUa/+H5bKaP0seRtBPhNQRW1KABFlni9LYjArtwHTmQ=;
	h=Date:To:From:Subject:From;
	b=IdqHy1NdEbk7mUJcfbEuBEWRhOoKLHPB4UoETURyOdDhe7dvMV/5O1uof6Jdhs6f1
	 gvTvx/8NLTIMS1vSOyNmTxxqULii8IPn9XH/8F+0O2nT5bxL2XSNbFOdrHDWlGQQtt
	 XG0FESBGJySRlR3IDkqeuv11ENMah5v/zd4oGg7g=
Date: Mon, 21 Apr 2025 12:48:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,wangkefeng.wang@huawei.com,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-contig_alloc-fix-alloc_contig_range-when-__gfp_comp-and-order-max_order.patch added to mm-hotfixes-unstable branch
Message-Id: <20250421194852.37AC5C4CEE4@smtp.kernel.org>
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
Date: Mon, 21 Apr 2025 09:36:20 +0800

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

Link: https://lkml.kernel.org/r/20250421013620.459740-1-tujinjiang@huawei.com
Fixes: e98337d11bbd ("mm/contig_alloc: support __GFP_COMP")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-contig_alloc-fix-alloc_contig_range-when-__gfp_comp-and-order-max_order
+++ a/mm/page_alloc.c
@@ -6706,6 +6706,7 @@ int alloc_contig_range_noprof(unsigned l
 		.alloc_contig = true,
 	};
 	INIT_LIST_HEAD(&cc.migratepages);
+	bool is_range_aligned;
 
 	gfp_mask = current_gfp_context(gfp_mask);
 	if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
@@ -6794,7 +6795,14 @@ int alloc_contig_range_noprof(unsigned l
 		goto done;
 	}
 
-	if (!(gfp_mask & __GFP_COMP)) {
+	/*
+	 * With __GFP_COMP and the requested order < MAX_PAGE_ORDER,
+	 * isolated free pages can have higher order than the requested
+	 * one. Use split_free_pages() to free out of range pages.
+	 */
+	is_range_aligned = is_power_of_2(end - start);
+	if (!(gfp_mask & __GFP_COMP) ||
+		(is_range_aligned && ilog2(end - start) < MAX_PAGE_ORDER)) {
 		split_free_pages(cc.freepages, gfp_mask);
 
 		/* Free head and tail (if any) */
@@ -6802,7 +6810,15 @@ int alloc_contig_range_noprof(unsigned l
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
+	if (start == outer_start && end == outer_end && is_range_aligned) {
 		struct page *head = pfn_to_page(start);
 		int order = ilog2(end - start);
 
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-contig_alloc-fix-alloc_contig_range-when-__gfp_comp-and-order-max_order.patch

