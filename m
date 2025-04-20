Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3D1191F7F;
	Sun, 20 Apr 2025 21:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745184547; cv=none; b=UlDMXANBknx29JkQ82YkADdJCGW/EXpIS1IASMBJYeHsHf4CQnBk4K9TnJRc2FdA9GphpuosFVoIKh3GEWbb9inaDuu3krrDjBsfOLaK8X8gNgu1z8faK3DcJPux45g3x0yxfUOWrxvWY3yNassrX8Lg1+/WOFSeu2bum/0c2T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745184547; c=relaxed/simple;
	bh=W7hS8ySUToJelvB0dLWOnbM9DLHFfinziAC4BT4yDSQ=;
	h=Date:To:From:Subject:Message-Id; b=N/Rg3dkongakN1ehNvCGertFILpKfJpTzOetsQO5rhPAIwYcTg2eFDwvzmu6Y56YEzqg2RKKzcYYuAcLkRRHqjUS2QQeXKugBShJFpntrUz4TXtCsknhOn6sWOPi9cCy9YIu30b+9ylmfodYNzCumu1kk54fylqdIpn/WHPjmCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0IqJsdjF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0IqJsdjF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32123C4CEE2;
	Sun, 20 Apr 2025 21:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745184547;
	bh=W7hS8ySUToJelvB0dLWOnbM9DLHFfinziAC4BT4yDSQ=;
	h=Date:To:From:Subject:From;
	b=0IqJsdjFgoHEKpRpwwa6HGncw4Glsfv3deZcihyZsrs+liYpXY7CfIz7CguL+zKcQ
	 ysEHj+ec71I1Ykd2fVAH8QPWYt7IRHTuSvv2520R3iW5mfOD0TIvEYU6yP0IH50pDX
	 nJEGTWiJvxRnuBUzHFWeHWspQMwtj0aEJyl60sIs=
Date: Sun, 20 Apr 2025 14:29:06 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,stable@vger.kernel.org,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-contig_alloc-fix-alloc_contig_range-when-__gfp_comp-and-order-max_order.patch removed from -mm tree
Message-Id: <20250420212907.32123C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/contig_alloc: fix alloc_contig_range when __GFP_COMP and order < MAX_ORDER
has been removed from the -mm tree.  Its filename was
     mm-contig_alloc-fix-alloc_contig_range-when-__gfp_comp-and-order-max_order.patch

This patch was dropped because an updated version will be issued

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
@@ -6786,7 +6786,8 @@ int alloc_contig_range_noprof(unsigned l
 		goto done;
 	}
 
-	if (!(gfp_mask & __GFP_COMP)) {
+	if (!(gfp_mask & __GFP_COMP) ||
+		(is_power_of_2(end - start) && ilog2(end - start) < MAX_PAGE_ORDER)) {
 		split_free_pages(cc.freepages, gfp_mask);
 
 		/* Free head and tail (if any) */
@@ -6794,7 +6795,15 @@ int alloc_contig_range_noprof(unsigned l
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


