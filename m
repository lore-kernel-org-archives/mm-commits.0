Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9410F2EAB64
	for <mm-commits@vger.kernel.org>; Tue,  2 Sep 2025 23:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756857174; cv=none; b=nvY5IA3HBIesq8LvoLW1D1AXMQEWsDxZtPXaZsUk1C3IuGgfSsSQ0cQdQpMUaHXPf6KY2FYcV2PLVFKx15iqqoCRDVP59gnhQiyMpjpZvHN+t3cdBq38oRcqpOu1O7MvGgikXDo5ghEsNXWD2i5c4ONYHFjv47dP1gISi7se5WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756857174; c=relaxed/simple;
	bh=ZeZIeUq6LF4+SANAStaaR9MErCFdz4U9jXMHYLQuLF0=;
	h=Date:To:From:Subject:Message-Id; b=h3lnYDTIKnZIVapgRsVfJNubhd7IxrgrwiDIpobHQPPvBMjsIl6t6MMKiOId6330uG7DydMzzn7LioRX+Es161V9vXNHYGZNIs11wJYMq2HpZWIw2aA4pXJO5tnbLWKTFLYB8gEeDnCYBXdqBCXf3H7vhjG+UkfTjQpfdiBUwJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wc8IemuJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wc8IemuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFA3C4CEED;
	Tue,  2 Sep 2025 23:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756857174;
	bh=ZeZIeUq6LF4+SANAStaaR9MErCFdz4U9jXMHYLQuLF0=;
	h=Date:To:From:Subject:From;
	b=Wc8IemuJBtDQizKXh1mqz9JobXp26V+Sk1SrscuVDHt8EXz7/3EVGOU35Bqo/FFnL
	 kn011T8HQVr6a1ZTCR2VNOlrxU+AnQDCgxbn271z0LLQLgMaG4/yW+RZSr+4z5gs+O
	 NSjG5q/H9Fn0JuUgHRkFpgqCd7CVRt6ZcKC3rIEA=
Date: Tue, 02 Sep 2025 16:52:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-remove-struct-hstate-from-init_new_hugetlb_folio.patch added to mm-new branch
Message-Id: <20250902235254.0CFA3C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugetlb: remove struct hstate from init_new_hugetlb_folio()
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-remove-struct-hstate-from-init_new_hugetlb_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-remove-struct-hstate-from-init_new_hugetlb_folio.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: hugetlb: remove struct hstate from init_new_hugetlb_folio()
Date: Tue, 2 Sep 2025 20:48:15 +0800

The struct hstate is never used, remove it.

Link: https://lkml.kernel.org/r/20250902124820.3081488-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
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

mm-hugetlb-convert-to-use-more-alloc_fresh_hugetlb_folio.patch
mm-hugetlb-convert-to-account_new_hugetlb_folio.patch
mm-hugetlb-directly-pass-order-when-allocate-a-hugetlb-folio.patch
mm-hugetlb-remove-struct-hstate-from-init_new_hugetlb_folio.patch
mm-hugeltb-check-numa_no_node-in-only_alloc_fresh_hugetlb_folio.patch
mm-page_alloc-add-alloc_contig_frozen_pages.patch
mm-cma-add-alloc-flags-for-__cma_alloc.patch
mm-cma-add-__cma_release.patch
mm-hugetlb-allocate-frozen-pages-in-alloc_gigantic_folio.patch

