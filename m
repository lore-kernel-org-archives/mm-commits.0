Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E39381E97
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 23:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789081531; cv=none; b=ExC1VcRqsC4g0eyEzycPELJ0TiMVovyZ9cA1AYWxby0r/mtK6aACvNkvYHcWmeCt6wcnFBc60m4k72x1kS00okAKyhBYifP1fdlJ/mFS4V+/sn2ZNwxtk1Iu2mp/q/VrJRGIxzRk0WHuk5zXCEvITQrb8VDPk7CBuXQl7Duv8G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789081531; c=relaxed/simple;
	bh=hEhfTNbthslBbaLJ9YT80J2GPL5Jqqn6a14EXHsSVQo=;
	h=Date:To:From:Subject:Message-Id; b=Wj130E8k+Hwt5yp2hfH0GuckSPON385hfI+eqwwFcsdGhmCO2R/M1ZrYGHKzbeoU8VCHFjn329fDoBIiaDLsILwphzbECpYyiw/GQRkr++EXiN0VcRKa1emm/t0E3voN/x3SgISCGJZcfC6ZgLFognSup4ENjeNdLb8UoQLM+y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aXNh/wTH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aXNh/wTH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3F41F000FF;
	Thu, 10 Sep 2026 23:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789081528;
	bh=mRCGIDWIz6RZHHzb3xumo1N3DyOUDcyP7KEkjeWu1YE=;
	h=Date:To:From:Subject;
	b=aXNh/wTH2lUzTIhIqa1D733UYxyr+y5IN3JjZ/gUodvjhflxuC8FTEf661wdNfg0L
	 KgEb0sy3xtVACBqmz6hnyqNDuTGEd+IffHanVrza6pMGo37/gj4/E1JBf6ErkEYq3a
	 7j53LkPzMOgsaIg0Z+8TO7HgTqArjTqucxmQRqNM=
Date: Thu, 10 Sep 2026 16:05:28 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-initialize-memory-sections-earlier.patch added to mm-unstable branch
Message-Id: <20260910230528.BC3F41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse: initialize memory sections earlier
has been added to the -mm mm-unstable branch.  Its filename is
     mm-sparse-initialize-memory-sections-earlier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-initialize-memory-sections-earlier.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/sparse: initialize memory sections earlier
Date: Thu, 10 Sep 2026 14:32:48 +0800

Upcoming HugeTLB bootmem changes need sparsemem section metadata before
the HugeTLB bootmem allocation path runs.  The memory sections are
initialized from sparse_init(), which is called too late for that setup.

Move the code that initializes sparsemem section metadata for memblock
ranges into mm_core_init_early(), before free_area_init() and the HugeTLB
bootmem setup.  Rename the helper to sparse_sections_init() so the new
caller describes the sparsemem-specific initialization step.

This is a preparatory change.

Link: https://lore.kernel.org/20260910063256.64386-10-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    1 +
 mm/sparse.c  |    9 +--------
 mm/sparse.h  |    2 ++
 3 files changed, 4 insertions(+), 8 deletions(-)

--- a/mm/mm_init.c~mm-sparse-initialize-memory-sections-earlier
+++ a/mm/mm_init.c
@@ -2642,6 +2642,7 @@ void __init mm_core_init_early(void)
 {
 	kho_memory_init_early();
 
+	sparse_sections_init();
 	free_area_init();
 
 	hugetlb_cma_reserve();
--- a/mm/sparse.c~mm-sparse-initialize-memory-sections-earlier
+++ a/mm/sparse.c
@@ -191,12 +191,7 @@ static void __init memory_present(int ni
 	}
 }
 
-/*
- * Mark all memblocks as present using memory_present().
- * This is a convenience function that is useful to mark all of the systems
- * memory as present during initialization.
- */
-static void __init memblocks_present(void)
+void __init sparse_sections_init(void)
 {
 	unsigned long start, end;
 	int i, nid;
@@ -322,8 +317,6 @@ void __init sparse_init(void)
 	unsigned long pnum_end, pnum_begin, map_count = 1;
 	int nid_begin;
 
-	memblocks_present();
-
 	if (compound_info_has_mask()) {
 		VM_WARN_ON_ONCE(!IS_ALIGNED((unsigned long) pfn_to_page(0),
 				    MAX_FOLIO_VMEMMAP_ALIGN));
--- a/mm/sparse.h~mm-sparse-initialize-memory-sections-earlier
+++ a/mm/sparse.h
@@ -59,6 +59,7 @@ static inline bool vmemmap_optimizable_o
  */
 #ifdef CONFIG_SPARSEMEM
 void sparse_init(void);
+void sparse_sections_init(void);
 int sparse_index_init(unsigned long section_nr, int nid);
 
 static inline void sparse_init_one_section(struct mem_section *ms,
@@ -104,6 +105,7 @@ static inline bool section_vmemmap_optim
 }
 #else
 static inline void sparse_init(void) {}
+static inline void sparse_sections_init(void) {}
 #endif /* CONFIG_SPARSEMEM */
 
 /*
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-sparse-relax-struct-mem_section-size-constraints.patch
mm-sparse-vmemmap-rename-hvo-order-macros.patch
mm-mm_init-skip-initializing-shared-vmemmap-tail-pages.patch
mm-sparse-vmemmap-initialize-shared-tail-vmemmap-pages-on-allocation.patch
mm-sparse-vmemmap-support-section-based-vmemmap-accounting.patch
mm-mm_init-factor-out-pfn_to_zone.patch
mm-sparse-vmemmap-move-helpers-ahead-of-future-callers.patch
mm-sparse-vmemmap-support-section-based-vmemmap-optimization.patch
mm-sparse-initialize-memory-sections-earlier.patch
mm-hugetlb-switch-hugetlb-to-section-based-vmemmap-optimization.patch
mm-sparse-vmemmap-remove-sparsemem_vmemmap_preinit-support.patch
mm-sparse-inline-usemap-allocation-into-sparse_init_nid.patch
mm-sparse-remove-section_map_size.patch
mm-hugetlb-remove-huge_bootmem_hvo.patch
mm-hugetlb-remove-huge_bootmem_cma.patch
mm-hugetlb-localize-struct-huge_bootmem_page.patch
mm-hugetlb-localize-huge_bootmem_zones_valid.patch
mm-sparse-vmemmap-introduce-config_sparsemem_vmemmap_optimization.patch
mm-sparse-vmemmap-factor-out-shared-vmemmap-tail-page-allocation.patch
mm-sparse-vmemmap-open-code-init_compound_tail.patch
mm-sparse-vmemmap-prepare-dax-vmemmap-population-for-section-orders.patch
mm-sparse-vmemmap-set-section-order-for-device-dax.patch
mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-move-hvo-helpers-to-a-public-header.patch
powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-drop-the-extra-tail-page-from-device-dax-reservation.patch
mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments.patch
documentation-mm-update-dax-vmemmap-deduplication-docs.patch

