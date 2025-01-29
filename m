Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311801E3DEC
	for <mm-commits@vger.kernel.org>; Wed, 29 Jan 2025 23:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738193190; cv=none; b=qcj/aYUDShvxIY3jny1COAYMWQMFA36554Dc9But1+P6hNlXmK+qhTjU5MMPQuqqlIu5uQA9XYWtPXApFZ7SJslnpvPXh5C6famEStxHsb55LXDOrw+37skHQ0ByouckES42YDTT7z+uRdfpM6xCand0nHoeZvA+MIDCqQcFpoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738193190; c=relaxed/simple;
	bh=5rNb0oZE+JekkGUfdJTI2uRY5poJsHtZuykDcWx4Ryw=;
	h=Date:To:From:Subject:Message-Id; b=pU5HA1IHbCNuowvWxgcng0u8JBp/jJBH5aXXCC0FR7i+HzU006kxnRVqQl8Pe3fZWbIREb5ugUneVtlEYHq5MnLC+W/2/7USxPpDRIE0oQQSHqg1dmlDTIu4BWZMar8nrDZ2aEK3phT1JgaBNISUlFGwoERqi8bbYA5kTEEGzos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RyvUV/qE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RyvUV/qE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C676C4CED1;
	Wed, 29 Jan 2025 23:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738193189;
	bh=5rNb0oZE+JekkGUfdJTI2uRY5poJsHtZuykDcWx4Ryw=;
	h=Date:To:From:Subject:From;
	b=RyvUV/qErS1s89iiR7U/kUoADLNHwTBOBUor84Bd8+lJYrHBi0PCYItnxERCXjMtR
	 wRX8oa+vrW9vNI9/g58g4BNGqgprGjQ140qkGdlGh9cdVoWHv+MO3/Jx+zXJfOR/TY
	 PVbUBueAt9HZzqiDpgDcpWkZNSAEjmjnr8Dz9IuA=
Date: Wed, 29 Jan 2025 15:26:29 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yaozhenguo1@gmail.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,gor@linux.ibm.com,dave.hansen@linux.intel.com,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-simplify-zone-intersection-check.patch added to mm-unstable branch
Message-Id: <20250129232629.8C676C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: simplify zone intersection check
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-simplify-zone-intersection-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-simplify-zone-intersection-check.patch

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
From: Frank van der Linden <fvdl@google.com>
Subject: mm/cma: simplify zone intersection check
Date: Wed, 29 Jan 2025 22:41:52 +0000

cma_activate_area walks all pages in the area, checking their zone
individually to see if the area resides in more than one zone.

Make this a little more efficient by using the recently introduced
pfn_range_intersects_zones() function.  Store the NUMA node id (if any) in
the cma structure to facilitate this.

Link: https://lkml.kernel.org/r/20250129224157.2046079-24-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   13 ++++++-------
 mm/cma.h |    2 ++
 2 files changed, 8 insertions(+), 7 deletions(-)

--- a/mm/cma.c~mm-cma-simplify-zone-intersection-check
+++ a/mm/cma.c
@@ -103,7 +103,6 @@ static void __init cma_activate_area(str
 {
 	unsigned long pfn, base_pfn;
 	int allocrange, r;
-	struct zone *zone;
 	struct cma_memrange *cmr;
 
 	for (allocrange = 0; allocrange < cma->nranges; allocrange++) {
@@ -124,12 +123,8 @@ static void __init cma_activate_area(str
 		 * CMA resv range to be in the same zone.
 		 */
 		WARN_ON_ONCE(!pfn_valid(base_pfn));
-		zone = page_zone(pfn_to_page(base_pfn));
-		for (pfn = base_pfn + 1; pfn < base_pfn + cmr->count; pfn++) {
-			WARN_ON_ONCE(!pfn_valid(pfn));
-			if (page_zone(pfn_to_page(pfn)) != zone)
-				goto cleanup;
-		}
+		if (pfn_range_intersects_zones(cma->nid, base_pfn, cmr->count))
+			goto cleanup;
 
 		for (pfn = base_pfn; pfn < base_pfn + cmr->count;
 		     pfn += pageblock_nr_pages)
@@ -261,6 +256,7 @@ int __init cma_init_reserved_mem(phys_ad
 	cma->ranges[0].base_pfn = PFN_DOWN(base);
 	cma->ranges[0].count = cma->count;
 	cma->nranges = 1;
+	cma->nid = NUMA_NO_NODE;
 
 	*res_cma = cma;
 
@@ -497,6 +493,7 @@ int __init cma_declare_contiguous_multi(
 	}
 
 	cma->nranges = nr;
+	cma->nid = nid;
 	*res_cma = cma;
 
 out:
@@ -684,6 +681,8 @@ static int __init __cma_declare_contiguo
 	if (ret)
 		memblock_phys_free(base, size);
 
+	(*res_cma)->nid = nid;
+
 	return ret;
 }
 
--- a/mm/cma.h~mm-cma-simplify-zone-intersection-check
+++ a/mm/cma.h
@@ -50,6 +50,8 @@ struct cma {
 	struct cma_kobject *cma_kobj;
 #endif
 	bool reserve_pages_on_error;
+	/* NUMA node (NUMA_NO_NODE if unspecified) */
+	int nid;
 };
 
 extern struct cma cma_areas[MAX_CMA_AREAS];
_

Patches currently in -mm which might be from fvdl@google.com are

mm-cma-export-total-and-free-number-of-pages-for-cma-areas.patch
mm-cma-support-multiple-contiguous-ranges-if-requested.patch
mm-cma-introduce-cma_intersects-function.patch
mm-hugetlb-use-cma_declare_contiguous_multi.patch
mm-hugetlb-fix-round-robin-bootmem-allocation.patch
mm-hugetlb-remove-redundant-__clearpagereserved.patch
mm-hugetlb-use-online-nodes-for-bootmem-allocation.patch
mm-hugetlb-convert-cmdline-parameters-from-setup-to-early.patch
x86-mm-make-register_page_bootmem_memmap-handle-pte-mappings.patch
mm-bootmem_info-export-register_page_bootmem_memmap.patch
mm-sparse-allow-for-alternate-vmemmap-section-init-at-boot.patch
mm-hugetlb-set-migratetype-for-bootmem-folios.patch
mm-define-__init_reserved_page_zone-function.patch
mm-hugetlb-check-bootmem-pages-for-zone-intersections.patch
mm-sparse-add-vmemmap__hvo-functions.patch
mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc.patch
mm-hugetlb-move-huge_boot_pages-list-init-to-hugetlb_bootmem_alloc.patch
mm-hugetlb-add-pre-hvo-framework.patch
mm-hugetlb_vmemmap-fix-hugetlb_vmemmap_restore_folios-definition.patch
mm-hugetlb-do-pre-hvo-for-bootmem-allocated-pages.patch
x86-setup-call-hugetlb_bootmem_alloc-early.patch
x86-mm-set-arch_want_sparsemem_vmemmap_preinit.patch
mm-cma-simplify-zone-intersection-check.patch
mm-cma-introduce-a-cma-validate-function.patch
mm-cma-introduce-interface-for-early-reservations.patch
mm-hugetlb-add-hugetlb_cma_only-cmdline-option.patch
mm-hugetlb-enable-bootmem-allocation-from-cma-areas.patch
mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file.patch

