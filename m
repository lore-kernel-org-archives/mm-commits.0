Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B65D2F28F9
	for <mm-commits@vger.kernel.org>; Thu, 23 Oct 2025 20:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761250478; cv=none; b=nLA64jcLiVb6YAQ78whXWsgQM9MZBYd60BgioZ8+qG/gR9Sw56hnO+BhEbUIKu3OkrX9DJflkNCo9RBpHIUkfDO3O3JVFTqM9y2Xz90FRkX8B9s7Bc8WF/xOPnwpvMdEShlQ/xUMa4VxRtb8OFdwh97zEtMq1Khows3UKuxYPkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761250478; c=relaxed/simple;
	bh=uos/g3j300N9h0BRzckEyPDCklHMQZ/sVftxEdV9PkY=;
	h=Date:To:From:Subject:Message-Id; b=PtX9qibfN4vtj8XwrWTGoR3BSAkHJnDmnPs1au7CcADXnGxDVp2NrdFDDBtb15JliMUpP9Ol9U5Ufh+XkLRWZfKDphHrnIscKB+9IAcPQ2ppbCbrGqYjxUzWXEhaI/cMX12YCbq0YeeqwDFqHyGEUEuIIH4dn6UKRq9Rt7p0YIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wm2YwVAD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wm2YwVAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313F7C4CEE7;
	Thu, 23 Oct 2025 20:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761250477;
	bh=uos/g3j300N9h0BRzckEyPDCklHMQZ/sVftxEdV9PkY=;
	h=Date:To:From:Subject:From;
	b=Wm2YwVADqSPIADmj+uWPnHnYazaE7A1Oct/CZb+byYa8mXRVSMh+yDTf9oBguBPbS
	 Tqo/KeAQZzoF2Ylp7gNdGATSam1n9tdPHwisqZKamsHHXd1K4Sk9jjtlGaNPc3gd12
	 b9GYCbLSGKOXld/g3LCT2uKuDvlf2dCqa4w2edcY=
Date: Thu, 23 Oct 2025 13:14:35 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,sidhartha.kumar@oracle.com,ryan.roberts@arm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-use-folio_can_map_prot_numa-for-pmd-folio.patch added to mm-unstable branch
Message-Id: <20251023201437.313F7C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: huge_memory: use folio_can_map_prot_numa() for pmd folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-use-folio_can_map_prot_numa-for-pmd-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-use-folio_can_map_prot_numa-for-pmd-folio.patch

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
Subject: mm: huge_memory: use folio_can_map_prot_numa() for pmd folio
Date: Thu, 23 Oct 2025 19:37:37 +0800

The folio_can_map_prot_numa() checks whether the folio can map prot numa,
which skips unsuitable folio, i.e.  zone device, shared folios (KSM, CoW),
non-movable dma pinned, dirty file folio and folios that already have the
expected node affinity.  Although the ksm only applies to small folios, an
extra test was added for large folios, but the other policies should be
applied to pmd folio, which helps to avoid unnecessary pmd change and
folio migration attempts.

Link: https://lkml.kernel.org/r/20251023113737.3572790-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-folio_can_map_prot_numa-for-pmd-folio
+++ a/mm/huge_memory.c
@@ -2477,8 +2477,7 @@ int change_huge_pmd(struct mmu_gather *t
 #endif
 
 	if (prot_numa) {
-		struct folio *folio;
-		bool toptier;
+
 		/*
 		 * Avoid trapping faults against the zero page. The read-only
 		 * data is likely to be read-cached on the local CPU and
@@ -2490,19 +2489,9 @@ int change_huge_pmd(struct mmu_gather *t
 		if (pmd_protnone(*pmd))
 			goto unlock;
 
-		folio = pmd_folio(*pmd);
-		toptier = node_is_toptier(folio_nid(folio));
-		/*
-		 * Skip scanning top tier node if normal numa
-		 * balancing is disabled
-		 */
-		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
-		    toptier)
+		if (!folio_can_map_prot_numa(pmd_folio(*pmd), vma,
+					     vma_is_single_threaded_private(vma)))
 			goto unlock;
-
-		if (folio_use_access_time(folio))
-			folio_xchg_access_time(folio,
-					       jiffies_to_msecs(jiffies));
 	}
 	/*
 	 * In case prot_numa, we are under mmap_read_lock(mm). It's critical
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

