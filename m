Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C5729A322
	for <mm-commits@vger.kernel.org>; Thu, 23 Oct 2025 20:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761250469; cv=none; b=LWRO7M/8MIg72uMBheVm/X8FPjkC3ckRfSvu6zxMY2j3eqeGooHIZCuvp90XnyyixUOr9CxQUweotOfvYGBqTkkukqrTnmK6ec0RF+1Lh6HHiRwlORWSLEyICNdKUTnGfAwAVzxiheXFWQw1SiFJzztw+XLqChlvXuiIW3lSJQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761250469; c=relaxed/simple;
	bh=lp5SFmUW54yLkCVXhsOiCpZKHqW3Cmdyi6qYIKL2C/A=;
	h=Date:To:From:Subject:Message-Id; b=b8ajXrycHEOIX0HSPpliQ0VIWohC87Aqakk8GPtqZO7cXzhU3cRRMN3Rpu9IXkNw6xAfIn1j6I75iDZ0prVjijCGRQhCkPlojSop03H77RsXhbvND4obKDcQ+oL5nXurkgjyEAKxOIhChzCDx+j5/blLdPjrSLpZQaObWYq8PRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OO9C/zIb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OO9C/zIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C37C4CEE7;
	Thu, 23 Oct 2025 20:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761250469;
	bh=lp5SFmUW54yLkCVXhsOiCpZKHqW3Cmdyi6qYIKL2C/A=;
	h=Date:To:From:Subject:From;
	b=OO9C/zIbtD+3EEwMXYrsEY8n/dBUzAjq3tuRxo1LrDmaZpO7vY6aNXNxv+MQtx08C
	 z0rh0EzAvVRTILqvPA+v1f+poVslqK2V46XSTQIZRVCfeTBSC+yLrtIjh9rMnl8oDR
	 azW0TrQb3rUbGIvOQFW6oLv9ETW3n6f12OMxtgzE=
Date: Thu, 23 Oct 2025 13:14:28 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,sidhartha.kumar@oracle.com,ryan.roberts@arm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-always-skip-dma-pinned-folio-in-prot_numa_skip.patch added to mm-unstable branch
Message-Id: <20251023201428.F0C37C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mprotect: always skip dma pinned folio in prot_numa_skip()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mprotect-always-skip-dma-pinned-folio-in-prot_numa_skip.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mprotect-always-skip-dma-pinned-folio-in-prot_numa_skip.patch

This patch will later appear in the mm-unstable branch at
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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: mprotect: always skip dma pinned folio in prot_numa_skip()
Date: Thu, 23 Oct 2025 19:37:34 +0800

Patch series "mm: some optimizations for prot numa", v5.


This patch (of 4):

If the folio (even not CoW folio) is dma pinned, it can't be migrated due
to the elevated reference count.  So always skip a pinned folio to avoid
wasting cycles when folios are migrated.

Link: https://lkml.kernel.org/r/20251023113737.3572790-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20251023113737.3572790-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/mprotect.c~mm-mprotect-always-skip-dma-pinned-folio-in-prot_numa_skip
+++ a/mm/mprotect.c
@@ -136,9 +136,12 @@ static bool prot_numa_skip(struct vm_are
 	if (folio_is_zone_device(folio) || folio_test_ksm(folio))
 		goto skip;
 
-	/* Also skip shared copy-on-write pages */
-	if (is_cow_mapping(vma->vm_flags) &&
-	    (folio_maybe_dma_pinned(folio) || folio_maybe_mapped_shared(folio)))
+	/* Also skip shared copy-on-write folios */
+	if (is_cow_mapping(vma->vm_flags) && folio_maybe_mapped_shared(folio))
+		goto skip;
+
+	/* Folios are pinned and can't be migrated */
+	if (folio_maybe_dma_pinned(folio))
 		goto skip;
 
 	/*
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-mprotect-always-skip-dma-pinned-folio-in-prot_numa_skip.patch
mm-mprotect-avoid-unnecessary-struct-page-accessing-if-pte_protnone.patch
mm-mprotect-convert-to-folio_can_map_prot_numa.patch
mm-huge_memory-use-folio_can_map_prot_numa-for-pmd-folio.patch
mm-debug_vm_pgtable-add-debug_vm_pgtable_free_huge_page.patch
mm-page_alloc-add-__split_page.patch
mm-cma-add-__cma_release.patch
mm-page_alloc-add-alloc_contig_frozen_rangepages.patch
mm-cma-add-cma_alloc_frozen_compound.patch
mm-hugetlb-allocate-frozen-pages-in-alloc_gigantic_folio.patch

