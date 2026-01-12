Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12063793D6
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 17:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768238502; cv=none; b=UncV7moTyl16xTU0AoQbLZfvv6YlGBD6DkVMagbb5ngyTUyBfSoso1URowiiMKajKwJ0J4WOQmSucpXbyEGDZrazmtFbEC67PgjM+RmbotqUKLZPllnyLkFZIltYi6f4Qm2p7eaScMdmnBcRMi3Odky2ORi8XsaOD35nAusr+JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768238502; c=relaxed/simple;
	bh=cgVLR30FGvZGCiMg5Tz0CQNcmUvLu2YFTCb3aSw/XE0=;
	h=Date:To:From:Subject:Message-Id; b=r4NAKdE+uTi3QuV4fInhX3NXcsFJ5mwOIb4nQ4TUlceyGBd1rZnS+3gNN04FLi86OO24vl+nIjd5tXFyce6b9S7gDGOrEWvlSm274kyWJtly11N11aNl6pWlyUP/q3K4uTA2lc3df0KuOIVPQMbHi92JKngL85wOJYJRVtdAPVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YJXYKQS8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YJXYKQS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686B2C116D0;
	Mon, 12 Jan 2026 17:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768238502;
	bh=cgVLR30FGvZGCiMg5Tz0CQNcmUvLu2YFTCb3aSw/XE0=;
	h=Date:To:From:Subject:From;
	b=YJXYKQS8w2MUkiM8NzAPObsyS/wVJApoocqE1imokU06ayl9XZs9FwSYcFmrEeOuw
	 XtMPrAVjP7xc5r9I1u9vbJd0SPXNw6n1fy8J5EE0eVoej9r6Ojl7XgEG5XmBZOh/b2
	 k8t5Mog5zFygtpR/P1l+E55GkkQ/MAVDipyBA/mc=
Date: Mon, 12 Jan 2026 09:21:41 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_cma-mark-hugetlb_cma_only-as-__ro_after_init.patch added to mm-new branch
Message-Id: <20260112172142.686B2C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugetlb_cma: mark hugetlb_cma{_only} as __ro_after_init
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb_cma-mark-hugetlb_cma_only-as-__ro_after_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_cma-mark-hugetlb_cma_only-as-__ro_after_init.patch

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
Subject: mm: hugetlb_cma: mark hugetlb_cma{_only} as __ro_after_init
Date: Mon, 12 Jan 2026 23:09:54 +0800

hugetlb_cma and hugetlb_cma_only are initialized once during init and
never changed.

Link: https://lkml.kernel.org/r/20260112150954.1802953-6-wangkefeng.wang@huawei.com
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

 mm/hugetlb_cma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb_cma.c~mm-hugetlb_cma-mark-hugetlb_cma_only-as-__ro_after_init
+++ a/mm/hugetlb_cma.c
@@ -13,9 +13,9 @@
 #include "hugetlb_cma.h"
 
 
-static struct cma *hugetlb_cma[MAX_NUMNODES];
+static struct cma *hugetlb_cma[MAX_NUMNODES] __ro_after_init;
 static unsigned long hugetlb_cma_size_in_node[MAX_NUMNODES] __initdata;
-static bool hugetlb_cma_only;
+static bool hugetlb_cma_only __ro_after_init;
 static unsigned long hugetlb_cma_size __ro_after_init;
 
 void hugetlb_cma_free_frozen_folio(struct folio *folio)
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

