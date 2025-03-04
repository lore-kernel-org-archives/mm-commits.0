Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97BF18FDDA
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 02:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741056573; cv=none; b=FhncawW6KWWnKidWhgEUaZOp71gcl6Pn3E3ENKP15ihye0Ok1Y6PnH2quUjRZuvfndYSbRx8wvCP13FqpwM+LQknhwF5CCHCdB3gnRr/VHEi3UyKEjO9VfDOmJpSiexuUhf8cu8ujrD+ODLUJnfpa6PgIaATvPmFzCJC6Vj4tUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741056573; c=relaxed/simple;
	bh=kg2Zxvv2yY5CsvBWwhHa4Sy7PR8/5Z9X9B2Is8xz9n4=;
	h=Date:To:From:Subject:Message-Id; b=HX8xmbKbeaP+eDsMfpnkbirulatq4YROpABq7RZpXHeV+aUIHSIp7Jj46DQ9NM0BC+WvPxVMqBRps+bIKs8vIv8cVg1/UoL1xhspsaib/YMnpKJQoafpq0BLIMC2JCb4UZJzSxYUYrQDrGCX8SKVxJfUmjDX9QxXSFFKwh0FXhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IXkXsiom; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IXkXsiom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7A2C4CEE4;
	Tue,  4 Mar 2025 02:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741056573;
	bh=kg2Zxvv2yY5CsvBWwhHa4Sy7PR8/5Z9X9B2Is8xz9n4=;
	h=Date:To:From:Subject:From;
	b=IXkXsiomvnh8RBbmMvOzzXm6n4C8uZQ7DEusQhT9Al551e1wfAJEshfUmutLD6o9s
	 6DDX/QWEaHtvhG4K3EhS+RbvqKUjSFx7a0RkZeDXgvro87mHRQIHqKJcYt9SgA9PkR
	 5ReMdcQZCXp3WbusZ1nyptFD4ElxQjOhC/ArbM/Y=
Date: Mon, 03 Mar 2025 18:49:32 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,arnd@arndb.de,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-simplify-zone-intersection-check.patch added to mm-unstable branch
Message-Id: <20250304024933.7D7A2C4CEE4@smtp.kernel.org>
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
Date: Fri, 28 Feb 2025 18:29:23 +0000

cma_activate_area walks all pages in the area, checking their zone
individually to see if the area resides in more than one zone.

Make this a little more efficient by using the recently introduced
pfn_range_intersects_zones() function.  Store the NUMA node id (if any) in
the cma structure to facilitate this.

Link: https://lkml.kernel.org/r/20250228182928.2645936-23-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
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
x86-mm-set-arch_want_hugetlb_vmemmap_preinit.patch
mm-cma-simplify-zone-intersection-check.patch
mm-cma-introduce-a-cma-validate-function.patch
mm-cma-introduce-interface-for-early-reservations.patch
mm-hugetlb-add-hugetlb_cma_only-cmdline-option.patch
mm-hugetlb-enable-bootmem-allocation-from-cma-areas.patch
mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file.patch

