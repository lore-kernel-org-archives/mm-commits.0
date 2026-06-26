Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FA426B973
	for <mm-commits@vger.kernel.org>; Fri, 26 Jun 2026 00:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782434845; cv=none; b=JuJW0WgTU6fmtRHpKAP56y7k9j0Wcl1X4JyPm4cpeL/FJBqtSeDvKhvzxeKX8dEEOoyKITLnQHUYbL3u/xdSUmSNkA4bbPaYRlHvsSdku3Vq+VDn22ojbflczPhtj+jKhecTDVDxuwATuOOyySpfrf77wMPlN16aRG0nFEEIkxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782434845; c=relaxed/simple;
	bh=9B38w+E7p/Omf0gVt2vOTpeyl8JtT+CoJvgFMOG0Kc0=;
	h=Date:To:From:Subject:Message-Id; b=T2FzDjgaxgwBiUmjhNrtakIK88Icj/9jIukC8h7bsudLPEv/oWXDGxiwl2Xr19PmOB8RARZ+8RGkBMvmF27r8FysNIBJOH4DerYYqVO03u6SPN/DWYywDeDH1uZz7NrHDS1s9uMupAT+JSro9XuoeJVYN4NT8/uBFjaRdE6tKdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lf1glSMK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lf1glSMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7F21F000E9;
	Fri, 26 Jun 2026 00:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782434844;
	bh=6GKXzW/E+yJDdxJV8uyFGu87aQjaZMpBAFKinsKw27Q=;
	h=Date:To:From:Subject;
	b=lf1glSMKDIIM2wKU6rjmYjJaxBoHNoIQ5V2y9aFnzd1/qVd5xckTVU6NjiP1aORdR
	 r7vLGRvNnrpBXtLi3If0S0wGvWygPoLVdNGfQakFAbrt9jFj7rRbkUAafCbNZf5Pn0
	 F/AzrUewAD2wO2DLSBiNFNvVSDVpxcmBdcVNd2/0=
Date: Thu, 25 Jun 2026 17:47:23 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_init-defer-sparse_init-until-after-zone-initialization.patch added to mm-new branch
Message-Id: <20260626004724.1B7F21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init: defer sparse_init() until after zone initialization
has been added to the -mm mm-new branch.  Its filename is
     mm-mm_init-defer-sparse_init-until-after-zone-initialization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-defer-sparse_init-until-after-zone-initialization.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/mm_init: defer sparse_init() until after zone initialization
Date: Fri, 12 Jun 2026 11:58:52 +0800

free_area_init() is responsible for initializing pgdat and zone state. 
Calling sparse_init() from there mixes in later vmemmap and struct page
setup, which makes the initialization flow less clear.

Defer sparse_init(), sparse_vmemmap_init_nid_late(), and memmap_init()
until after free_area_init() completes, when zone initialization is fully
done.  This keeps free_area_init() focused on zone setup and ensures that
sparse_init() runs with the relevant zone state already available.

This is also a prerequisite for later hugetlb vmemmap changes that need
zone information during early sparse vmemmap setup.

Link: https://lore.kernel.org/20260612035903.2468601-9-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/mm_init.c~mm-mm_init-defer-sparse_init-until-after-zone-initialization
+++ a/mm/mm_init.c
@@ -1814,7 +1814,6 @@ static void __init free_area_init(void)
 	bool descending;
 
 	arch_zone_limits_init(max_zone_pfn);
-	sparse_init();
 
 	start_pfn = PHYS_PFN(memblock_start_of_DRAM());
 	descending = arch_has_descending_max_zone_pfns();
@@ -1903,11 +1902,7 @@ static void __init free_area_init(void)
 		}
 	}
 
-	for_each_node_state(nid, N_MEMORY)
-		sparse_vmemmap_init_nid_late(nid);
-
 	calc_nr_kernel_pages();
-	memmap_init();
 
 	/* disable hash distribution for systems with a single node */
 	fixup_hashdist();
@@ -2679,10 +2674,17 @@ void __init __weak mem_init(void)
 
 void __init mm_core_init_early(void)
 {
+	int nid;
+
 	hugetlb_cma_reserve();
 	hugetlb_bootmem_alloc();
 
 	free_area_init();
+
+	sparse_init();
+	for_each_node_state(nid, N_MEMORY)
+		sparse_vmemmap_init_nid_late(nid);
+	memmap_init();
 }
 
 /*
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb-fix-boot-panic-with-config_debug_vm-and-hvo-bootmem-pages.patch
mm-hugetlb_vmemmap-fix-__hugetlb_vmemmap_optimize_folios.patch
powerpc-mm-fix-wrong-addr_pfn-tracking-in-compound-vmemmap-population.patch
mm-hugetlb-initialize-gigantic-bootmem-hugepage-struct-pages-earlier.patch
mm-mm_init-simplify-deferred_free_pages-migratetype-init.patch
mm-sparse-panic-on-memmap-and-usemap-allocation-failure.patch
mm-sparse-move-subsection_map_init-into-sparse_init.patch
mm-mm_init-defer-sparse_init-until-after-zone-initialization.patch
mm-mm_init-defer-hugetlb-reservation-until-after-zone-initialization.patch
mm-mm_init-remove-set_pageblock_order-call-from-sparse_init.patch
mm-sparse-move-sparse_vmemmap_init_nid_late-into-sparse_init_nid.patch
mm-hugetlb_cma-validate-hugetlb-cma-range-by-zone-at-reserve-time.patch
mm-hugetlb-refactor-early-boot-gigantic-hugepage-allocation.patch
mm-hugetlb-free-cross-zone-bootmem-gigantic-pages-after-allocation.patch
mm-hugetlb_vmemmap-move-bootmem-hvo-setup-to-early-init.patch
mm-hugetlb-remove-obsolete-bootmem-cross-zone-checks.patch
mm-sparse-vmemmap-remove-sparse_vmemmap_init_nid_late.patch
mm-hugetlb-remove-unused-bootmem-cma-field.patch
mm-mm_init-fold-__init_page_from_nid-into-__init_deferred_page.patch

