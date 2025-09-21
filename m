Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D4D29ACEE
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489864; cv=none; b=qazIILa4OuWVCsMKiR1RIYIcvWP+vbrogK/6Z080WT/GfDuaRvRWLq+3zD0kiUAJjEAA+F7p4eGeCyjrOF/fLvSnTatEpYLONmvxry5O6txAWYr3dPge3wLZe9tbJWhsaYe/WOBl+FDz6a1y9LSRIb2fheFoXCjn4hN/ug6cyYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489864; c=relaxed/simple;
	bh=yDvD2LnNCR3eic7RomjVo1RBXKGxFuNFzUfU6yC4aiY=;
	h=Date:To:From:Subject:Message-Id; b=W2mchbQogNd5O65dq/yJ8lKMoeJJ+0bK2YM6YJaSmBgzuDfhe9gZMNyTUb1jolMLfUe/NC/I5JNBVboczvUvPmvq8eRo1+GkqQ+gj5fH+ZjlCPFx3pbcto9ubJhGINv1EdP42upetx10neaUz3FmuJTFWkiFetq83+k/NjADe14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BaajOn6j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BaajOn6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6AFC4CEE7;
	Sun, 21 Sep 2025 21:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489864;
	bh=yDvD2LnNCR3eic7RomjVo1RBXKGxFuNFzUfU6yC4aiY=;
	h=Date:To:From:Subject:From;
	b=BaajOn6je6ir89umxrQzssk/GVMcMGBx1mZE4gu5DuFah1MiI2sbIpCJDMwzHJDWC
	 tlz8IFjVzGhNMpfW0NclYrRQznW/ICzHwwj3rUm4qY9GAjhB94HoRse4Dq3jXiMR+d
	 kejpHP37508VS1AxaBtTbQEoq1BvXYALHvON9XME=
Date: Sun, 21 Sep 2025 14:24:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugeltb-check-numa_no_node-in-only_alloc_fresh_hugetlb_folio.patch removed from -mm tree
Message-Id: <20250921212423.EE6AFC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugeltb: check NUMA_NO_NODE in only_alloc_fresh_hugetlb_folio()
has been removed from the -mm tree.  Its filename was
     mm-hugeltb-check-numa_no_node-in-only_alloc_fresh_hugetlb_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: hugeltb: check NUMA_NO_NODE in only_alloc_fresh_hugetlb_folio()
Date: Wed, 10 Sep 2025 21:39:58 +0800

Move the NUMA_NO_NODE check out of buddy and gigantic folio allocation to
cleanup code a bit, also this will avoid NUMA_NO_NODE passed as 'nid' to
node_isset() in alloc_buddy_hugetlb_folio().

Link: https://lkml.kernel.org/r/20250910133958.301467-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugeltb-check-numa_no_node-in-only_alloc_fresh_hugetlb_folio
+++ a/mm/hugetlb.c
@@ -1479,8 +1479,6 @@ static struct folio *alloc_gigantic_foli
 	struct folio *folio;
 	bool retried = false;
 
-	if (nid == NUMA_NO_NODE)
-		nid = numa_mem_id();
 retry:
 	folio = hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
 	if (!folio) {
@@ -1942,8 +1940,6 @@ static struct folio *alloc_buddy_hugetlb
 		alloc_try_hard = false;
 	if (alloc_try_hard)
 		gfp_mask |= __GFP_RETRY_MAYFAIL;
-	if (nid == NUMA_NO_NODE)
-		nid = numa_mem_id();
 
 	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask);
 
@@ -1979,6 +1975,9 @@ static struct folio *only_alloc_fresh_hu
 	struct folio *folio;
 	int order = huge_page_order(h);
 
+	if (nid == NUMA_NO_NODE)
+		nid = numa_mem_id();
+
 	if (order_is_gigantic(order))
 		folio = alloc_gigantic_folio(order, gfp_mask, nid, nmask);
 	else
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


