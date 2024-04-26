Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FC7811E7
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104135; cv=none; b=cJRfue/1ttCAPxvPuWv2BnOMgEVh5EpDtl3qbXTiEN1YVcNuZSbI6AxrVjAF1rqfqx2s6INYSJAKJwRhDFDtmg6fbexORidQ6DmYcz6G/8oyYDZoEUFtCZq3T/c2RXU7WdPWswGAmit7z8xOI+rE9IxQesPIg0FsxwwY361OSEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104135; c=relaxed/simple;
	bh=Z3rFXqz674dGrAnQ6BfExnuE0ng4dz18o97BLcAPSSo=;
	h=Date:To:From:Subject:Message-Id; b=e+aOv6IQoV9boIGUwz75gHw4O+qSNrCLL/+ZAR+RA9LKtxwacvvwRBdTMtrpcszWe5iwbCXHmj+dy38KVI9Jdq545DwqAl7gfC1hA5Ov3TP1/lWdgErPre1LkIC1eHKJnd+HXS9vMyq2yaR2PXbwae9grRXMA4tah/mSCtCqZ38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m8kF9v6A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m8kF9v6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38B1C116B1;
	Fri, 26 Apr 2024 04:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104134;
	bh=Z3rFXqz674dGrAnQ6BfExnuE0ng4dz18o97BLcAPSSo=;
	h=Date:To:From:Subject:From;
	b=m8kF9v6AKI+BWxQYohBWu3SIG0FH918YcuJBnKpSwM7bJ1S06t+mmGI/jid4WUzi3
	 rBDYQdlOlBdXuAL28aOFLe+jUHrKNE7Ul8iXPicx3LvZ/bTeRXSKw1Ws+OTeRKmAyb
	 p1fWhIxk3DXggFOHRdLRI1ex0XqmMFno0HiAt88s=
Date: Thu, 25 Apr 2024 21:02:14 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mgorman@techsingularity.net,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-use-the-correct-thp-order-for-thp-pcp.patch removed from -mm tree
Message-Id: <20240426040214.C38B1C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: use the correct THP order for THP PCP
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-use-the-correct-thp-order-for-thp-pcp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Barry Song <baohua@kernel.org>
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

mm-page_alloc-allowing-mthp-compaction-to-capture-the-freed-page-directly.patch

