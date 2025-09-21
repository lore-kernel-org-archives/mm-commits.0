Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD89429ACD1
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489863; cv=none; b=kqqSVaPby1C8ibuyi94jXxP5wt7bav0hoHSVM/rKd6C5ZZQKh5sPlK65OSjMu8uLzcva+FYDrH8yy2r5Gp6ZD05jE6SfIZMpXBPZdn1/4BU7UCxAxg9vgdN3SK5aAVQb7pYqf4FIGaKpm+1hTifkmxEGZM3wGV03ngC/DVcHmNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489863; c=relaxed/simple;
	bh=15MIP6Sv++Cjf3zINOi1Qb7uQ6AkKzrFzsbbslMn6Cw=;
	h=Date:To:From:Subject:Message-Id; b=hW/AHGTl95fv/Hk7d2SvnOeT7sfQU2No7MIB8PLr4JXatfK+03DjoiYY6RNrNJYKOzFa1uocIhEHTkGV40lSjYZDPPkao+jgvA+92GSkZ5U5xTsSF58tzv+47NwqReIH2D2wXkvyLTnAOJrUIcf6BVWuiikkwCYa6E9R1ilP6O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zOen6rTP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zOen6rTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3619C113D0;
	Sun, 21 Sep 2025 21:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489862;
	bh=15MIP6Sv++Cjf3zINOi1Qb7uQ6AkKzrFzsbbslMn6Cw=;
	h=Date:To:From:Subject:From;
	b=zOen6rTPnQc7ZeCN57k6lrrYqwB0LX6/d4V4y4yzKecQz5+lGkx8DpQ6bpQn9l0Wx
	 StCUBk7rFmCABuFmlwFqcs8xe7bd/k0elzjEF/1SbYr6LLOVLm6HoCAYRVgedcfdMD
	 ozemKdNnURExR18e1P0obn0Miw2HPszMxH9+7gi4=
Date: Sun, 21 Sep 2025 14:24:22 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-remove-struct-hstate-from-init_new_hugetlb_folio.patch removed from -mm tree
Message-Id: <20250921212422.B3619C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb: remove struct hstate from init_new_hugetlb_folio()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-remove-struct-hstate-from-init_new_hugetlb_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: hugetlb: remove struct hstate from init_new_hugetlb_folio()
Date: Wed, 10 Sep 2025 21:39:57 +0800

The struct hstate is never used since commit d67e32f26713 ("hugetlb:
restructure pool allocations”), remove it.

Link: https://lkml.kernel.org/r/20250910133958.301467-5-wangkefeng.wang@huawei.com
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

 mm/hugetlb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-remove-struct-hstate-from-init_new_hugetlb_folio
+++ a/mm/hugetlb.c
@@ -1896,7 +1896,7 @@ static void account_new_hugetlb_folio(st
 	h->nr_huge_pages_node[folio_nid(folio)]++;
 }
 
-static void init_new_hugetlb_folio(struct hstate *h, struct folio *folio)
+static void init_new_hugetlb_folio(struct folio *folio)
 {
 	__folio_set_hugetlb(folio);
 	INIT_LIST_HEAD(&folio->lru);
@@ -1985,7 +1985,7 @@ static struct folio *only_alloc_fresh_hu
 		folio = alloc_buddy_hugetlb_folio(order, gfp_mask, nid, nmask,
 						  node_alloc_noretry);
 	if (folio)
-		init_new_hugetlb_folio(h, folio);
+		init_new_hugetlb_folio(folio);
 	return folio;
 }
 
@@ -3408,7 +3408,7 @@ static void __init gather_bootmem_preall
 
 		hugetlb_folio_init_vmemmap(folio, h,
 					   HUGETLB_VMEMMAP_RESERVE_PAGES);
-		init_new_hugetlb_folio(h, folio);
+		init_new_hugetlb_folio(folio);
 
 		if (hugetlb_bootmem_page_prehvo(m))
 			/*
@@ -4041,7 +4041,7 @@ static long demote_free_hugetlb_folios(s
 			prep_compound_page(page, dst->order);
 
 			new_folio->mapping = NULL;
-			init_new_hugetlb_folio(dst, new_folio);
+			init_new_hugetlb_folio(new_folio);
 			/* Copy the CMA flag so that it is freed correctly */
 			if (cma)
 				folio_set_hugetlb_cma(new_folio);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


