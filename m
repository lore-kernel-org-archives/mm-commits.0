Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BF2363C42
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 17:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768238500; cv=none; b=cr5dAGQiPyxHTsELn+y2lknPNlf6Kjhkb8mZAKPKBwa0tGJRxzcGdECYB/0ja3pG5n/HGz+xm2SUdtle9+Az7tVdaU3cWGVtg6MSWlc5KcXaPJiRzRx4bQSHPFhP+rCf6TF5Ng8aX/+8IBt3hBj4kpmZqHwUT3WFRk4hdci58+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768238500; c=relaxed/simple;
	bh=qu4yTmC2lRjzzcsgyNZZP8k2YEm8tlBxEBTT/jH7gvE=;
	h=Date:To:From:Subject:Message-Id; b=IU2f2Yg6oeKlzIeAwxtNqCHmpSJDQRXmeER9agGV2B8orIRUB/wh04fYf2n6qq8lkkO8LpBRU8/GmovFpBWHPHhUdiS+2sRaPqJPcuKMUCAkxxxO8/KdvHhGwTV24TG/mlUlTqlrWEdR1PJkxzgRJ7IMidakT8pl7UMT/1LH5x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O/A6x5XF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O/A6x5XF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CD6C116D0;
	Mon, 12 Jan 2026 17:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768238500;
	bh=qu4yTmC2lRjzzcsgyNZZP8k2YEm8tlBxEBTT/jH7gvE=;
	h=Date:To:From:Subject:From;
	b=O/A6x5XF9o0vbjz0hPksetIgqc4H8abuo6+uf0LMOyMxGNSej7yRH4eHMMCxn1vU9
	 RmhhaPhgFHH6ZBK2OeKsZlBUSkaAep/EkcJh32v3+y3av2SyWheZNKeHPSCohj7+Gf
	 5j9sIpIgMNIZ86AYVR4k2AZTt4lW9P6ij7Pf7pzg=
Date: Mon, 12 Jan 2026 09:21:39 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_cma-optimize-hugetlb_cma_alloc_frozen_folio.patch added to mm-new branch
Message-Id: <20260112172140.52CD6C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugetlb_cma: optimize hugetlb_cma_alloc_frozen_folio()
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb_cma-optimize-hugetlb_cma_alloc_frozen_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_cma-optimize-hugetlb_cma_alloc_frozen_folio.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: hugetlb_cma: optimize hugetlb_cma_alloc_frozen_folio()
Date: Mon, 12 Jan 2026 23:09:53 +0800

Check hugetlb_cma_size which helps to avoid unnecessary gfp check or
nodemask traversal.

Link: https://lkml.kernel.org/r/20260112150954.1802953-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cma.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/hugetlb_cma.c~mm-hugetlb_cma-optimize-hugetlb_cma_alloc_frozen_folio
+++ a/mm/hugetlb_cma.c
@@ -16,7 +16,7 @@
 static struct cma *hugetlb_cma[MAX_NUMNODES];
 static unsigned long hugetlb_cma_size_in_node[MAX_NUMNODES] __initdata;
 static bool hugetlb_cma_only;
-static unsigned long hugetlb_cma_size __initdata;
+static unsigned long hugetlb_cma_size __ro_after_init;
 
 void hugetlb_cma_free_frozen_folio(struct folio *folio)
 {
@@ -31,6 +31,9 @@ struct folio *hugetlb_cma_alloc_frozen_f
 	struct folio *folio;
 	struct page *page = NULL;
 
+	if (!hugetlb_cma_size)
+		return NULL;
+
 	if (hugetlb_cma[nid])
 		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-debug_vm_pgtable-add-debug_vm_pgtable_free_huge_page.patch
mm-page_alloc-add-__split_page.patch
mm-cma-kill-cma_pages_valid.patch
mm-page_alloc-add-alloc_contig_frozen_rangepages.patch
mm-cma-add-cma_alloc_frozen_compound.patch
mm-hugetlb-allocate-frozen-pages-for-gigantic-allocation.patch
mm-page_isolation-introduce-page_is_unmovable.patch
mm-page_alloc-optimize-pfn_range_valid_contig.patch
mm-hugetlb-optimize-replace_free_hugepage_folios.patch
mm-hugetlb_cma-optimize-hugetlb_cma_alloc_frozen_folio.patch
mm-hugetlb_cma-mark-hugetlb_cma_only-as-__ro_after_init.patch

