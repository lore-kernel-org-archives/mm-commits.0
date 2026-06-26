Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BA926B973
	for <mm-commits@vger.kernel.org>; Fri, 26 Jun 2026 00:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782434853; cv=none; b=gDyPOBIwlme44RAvC9A+y+w4VDJmSABIh97dKgRKo/KCEC0pa4qi3dMAvxLwLhbwBVVuZkF0yc7NQnwTHcO0SYTrA51OlLOoEyLU1YwoEAxriEJG7ZTt430AlXybMCTZLYbltcU5A7gaGZ9xDhvVHWv4TepalXDu0pNf5ioKLuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782434853; c=relaxed/simple;
	bh=Ecg7ojLl1+IkkwF6XRTFJT3snibwiWWnnc7Iww2euIE=;
	h=Date:To:From:Subject:Message-Id; b=e5aYvUWpt/VEKOaib6GCaf8xozaPJGHVm5gQEcCAj2uXQxSjp1JfcwpIzZcTZmwraq8631YQj7huJPZC9sJNyCRyzXxeQ1h+O47hEzw0fHfQlCMgr8tNmV2V2nWr7OnbRiqRa6rRTG+IPRbldxL0wa5AajwsojVr+q4UIrw7XyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NTCjOxQk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NTCjOxQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48CB41F000E9;
	Fri, 26 Jun 2026 00:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782434851;
	bh=fwXYB/hR7TrkG8UgBdS/fuhFaBEA3FQDxrK51Y7U7Ps=;
	h=Date:To:From:Subject;
	b=NTCjOxQk6VKGypvApEdtxDHretkSqOrQ9f2PE5lERyyLt/ONpz21LdQvzD0hTogl+
	 sU7kGEbSC8zDwfdCiHNula2nFfdsN0Oo2L9VpXQWGdm0i9W26aZFLMAP89FRi3PPvw
	 tqnttyN/0MSVHxJsXLjnBWAcZzcrlTrijhWBT+9k=
Date: Thu, 25 Jun 2026 17:47:30 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-move-sparse_vmemmap_init_nid_late-into-sparse_init_nid.patch added to mm-new branch
Message-Id: <20260626004731.48CB41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse: move sparse_vmemmap_init_nid_late() into sparse_init_nid()
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-move-sparse_vmemmap_init_nid_late-into-sparse_init_nid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-move-sparse_vmemmap_init_nid_late-into-sparse_init_nid.patch

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
Subject: mm/sparse: move sparse_vmemmap_init_nid_late() into sparse_init_nid()
Date: Fri, 12 Jun 2026 11:58:55 +0800

sparse_vmemmap_init_nid_late() is still called separately from
mm_core_init_early(), away from the rest of the sparse initialization
path.

Now that sparse_init() runs after zone initialization, call
sparse_vmemmap_init_nid_late() from sparse_init_nid() instead.  This keeps
both sparse_vmemmap_init_nid_early() and sparse_vmemmap_init_nid_late() in
the sparse setup path.

Link: https://lore.kernel.org/20260612035903.2468601-12-songmuchun@bytedance.com
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

 mm/mm_init.c |    4 ----
 mm/sparse.c  |    1 +
 2 files changed, 1 insertion(+), 4 deletions(-)

--- a/mm/mm_init.c~mm-sparse-move-sparse_vmemmap_init_nid_late-into-sparse_init_nid
+++ a/mm/mm_init.c
@@ -2674,16 +2674,12 @@ void __init __weak mem_init(void)
 
 void __init mm_core_init_early(void)
 {
-	int nid;
-
 	free_area_init();
 
 	hugetlb_cma_reserve();
 	hugetlb_bootmem_alloc();
 
 	sparse_init();
-	for_each_node_state(nid, N_MEMORY)
-		sparse_vmemmap_init_nid_late(nid);
 	memmap_init();
 }
 
--- a/mm/sparse.c~mm-sparse-move-sparse_vmemmap_init_nid_late-into-sparse_init_nid
+++ a/mm/sparse.c
@@ -320,6 +320,7 @@ static void __init sparse_init_nid(int n
 		}
 	}
 	sparse_usage_fini();
+	sparse_vmemmap_init_nid_late(nid);
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

