Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C918A221F30;
	Wed, 28 May 2025 23:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748473654; cv=none; b=gbPRC31Wr96tGmg3VuVe3n0XWBJACtBkznm5VNJ1LHGzNsNf1kCh847XOAsrK+Vw7beEUX99S85iVqAumMzJ0kwDFjbjHVXMGOvuVTc6kVfdwaK6XqRcfkr4kfAjPdKubF/AHwQsM1A/XXEzSfJ7IgWJhsIofTPMxTvpRRcYXKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748473654; c=relaxed/simple;
	bh=ODONM4PY+4c5Dzs3yI8XdPUV3QwSyopJVRyDaSeokg8=;
	h=Date:To:From:Subject:Message-Id; b=D3+57yIBpc5C5iv2pTEOZT22K4wIK1A4ql+T+5p+KcjkBY4F3JwZKYj61ELOKhawz7Zo85lS78VgTz7g2dYiMPpm46hbet8beyFuZ+VmVmJsMRcUUnnhr510C1IAtcsBc42e9sqPqLO6I9jzJOhAhjkqcJf+SEr7GiF3+lf3yJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gZB1u7Fj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gZB1u7Fj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F56C4CEE3;
	Wed, 28 May 2025 23:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748473654;
	bh=ODONM4PY+4c5Dzs3yI8XdPUV3QwSyopJVRyDaSeokg8=;
	h=Date:To:From:Subject:From;
	b=gZB1u7Fjosh7TJIKR4YG/8CPDx+iexIPVDfa+qEemV4yQdgIEDMZuPfFeT14dGQvw
	 WJWRGhl17VzGY1zGInBVCA63QamaYUNBqsSdB1l24okMuK0S0ycZT+vntdgOAsDt4x
	 CHTacW6VdTw4kS6F2e++HV71lMf/pUi+nhL1O5QU=
Date: Wed, 28 May 2025 16:07:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,wangkefeng.wang@huawei.com,stable@vger.kernel.org,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-contig_alloc-fix-alloc_contig_range-when-__gfp_comp-and-order-max_order.patch removed from -mm tree
Message-Id: <20250528230734.75F56C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/contig_alloc: fix alloc_contig_range when __GFP_COMP and order < MAX_ORDER
has been removed from the -mm tree.  Its filename was
     mm-contig_alloc-fix-alloc_contig_range-when-__gfp_comp-and-order-max_order.patch

This patch was dropped because an alternative patch was or shall be merged

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-contig_alloc-fix-alloc_contig_range-when-__gfp_comp-and-order-max_order
+++ a/mm/page_alloc.c
@@ -6693,6 +6693,7 @@ int alloc_contig_range_noprof(unsigned l
 		.alloc_contig = true,
 	};
 	INIT_LIST_HEAD(&cc.migratepages);
+	bool is_range_aligned;
 
 	gfp_mask = current_gfp_context(gfp_mask);
 	if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
@@ -6781,7 +6782,14 @@ int alloc_contig_range_noprof(unsigned l
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
@@ -6789,7 +6797,15 @@ int alloc_contig_range_noprof(unsigned l
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


