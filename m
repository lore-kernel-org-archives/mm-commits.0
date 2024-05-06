Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F3F3A1B9
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957166; cv=none; b=sGwWXrQ7sX0WUaiIqxXQrrInTSezb0/78CnZhkB4gWMYnm3EsA/CL51hcWEy2PC0/I/ul2lve3FF6kxlr173tyxj25R4PsODadgR5emP/rxt1fcB9gkr6FWdS/SYA0dYkJDsHCSF8+5JWhaebrdBbC4WbqZSKH7BNSXcneobGHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957166; c=relaxed/simple;
	bh=mbfE0/0KFL3LjeaafAw0jghEUiv1WgFyRks0ag/QyUg=;
	h=Date:To:From:Subject:Message-Id; b=bHNogu3+ms9WWS1Q2zxs+X/9sEmYTPsqKvYfm/d3lr8YlRQKIlJWzzuqhV9g6pCj2aTQg11xe+10GajDx+Mf/teMv7deKcE6QdGc0k4HctYTWwUZkGgqKHZlhGuSBR8xSZ8P6Vlmr5lHApG+0ba6U8oDFTZMha/Ht5eps7KLngM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N3WZ4cMI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N3WZ4cMI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC3EC116B1;
	Mon,  6 May 2024 00:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957166;
	bh=mbfE0/0KFL3LjeaafAw0jghEUiv1WgFyRks0ag/QyUg=;
	h=Date:To:From:Subject:From;
	b=N3WZ4cMIJgLbDZVSRQ9Zx7Rd36LZUmcBttATD9BeCsmoVEzUSyIO+cHuqlBgiats8
	 eiwV/YMmrk/vHwD0An2I5kosEVZlxbfpBEN5MlDuPjC4aZz09qkVF8n4rHuwMLaiqE
	 6cfc9VcFP7na1zs0r5lsNNX+CfUueQB19RmsC5U0=
Date: Sun, 05 May 2024 17:59:25 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,david@redhat.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-align-cma-on-allocation-order-not-demotion-order.patch removed from -mm tree
Message-Id: <20240506005925.DCC3EC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: align cma on allocation order, not demotion order
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-align-cma-on-allocation-order-not-demotion-order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm/hugetlb: align cma on allocation order, not demotion order
Date: Tue, 30 Apr 2024 16:14:37 +0000

Align the CMA area for hugetlb gigantic pages to their size, not the size
that they can be demoted to.  Otherwise there might be misaligned sections
at the start and end of the CMA area that will never be used for hugetlb
page allocations.

Link: https://lkml.kernel.org/r/20240430161437.2100295-1-fvdl@google.com
Fixes: a01f43901cfb ("hugetlb: be sure to free demoted CMA pages to CMA")
Signed-off-by: Frank van der Linden <fvdl@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-align-cma-on-allocation-order-not-demotion-order
+++ a/mm/hugetlb.c
@@ -7800,7 +7800,7 @@ void __init hugetlb_cma_reserve(int orde
 		 * huge page demotion.
 		 */
 		res = cma_declare_contiguous_nid(0, size, 0,
-					PAGE_SIZE << HUGETLB_PAGE_ORDER,
+					PAGE_SIZE << order,
 					HUGETLB_PAGE_ORDER, false, name,
 					&hugetlb_cma[nid], nid);
 		if (res) {
_

Patches currently in -mm which might be from fvdl@google.com are


