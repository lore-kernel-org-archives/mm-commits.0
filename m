Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242E8376BF2
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 23:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789081251; cv=none; b=M4PMBBi7mrj4255+b9SwPjRmE0JPGJoRw7BkcU/onPDGdlTZl0Mx8qK2GY4J0vwSHM01cv4ilZkN6I07kFyvPe6KDiik3+P8iUOgBHnoHq3S+IL98VczE4dVfQq5qNP5cMzFZoSUE+yC13iafkwXaIPXSGV4fnz8CzlhJRWOPJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789081251; c=relaxed/simple;
	bh=BX3Q+28BpNxvYT4O4qTbayfyrKFaH95b8NkV8SLoWZM=;
	h=Date:To:From:Subject:Message-Id; b=H1tORHwMdKPHOlZWGp1sNK5zEFI5QEpsIbV2c1jwAdwBQgK6nLkY+BEX05Q987MZs/1e1EXhMtNoN+zS2TSMQGkGNAJNIj2rHgPKdKfEqvTXiUhfNtMkBsp/9MdOUxTPzJhy+pIsaQYgwLw+FYhKCVGWFS4rq+HUHZyhaC7zDqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lFjxsb+m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lFjxsb+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA9D1F00893;
	Thu, 10 Sep 2026 23:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789081250;
	bh=Wgv1Awe1vA8aBSoOFc5fGTIdLJN+rFYv/MAMju+t/RE=;
	h=Date:To:From:Subject;
	b=lFjxsb+mqxUImdxYfldHBMEsZSRc/CA5zfL5M9UVbODcI5jXmyz7cXzzvEcbeVOcE
	 i8xspRtJbzrwQuO0GLfs5LLC4hcCM2JCfxmwZpOiIa3+O8AyoXpRuSC+4pGJSyX8X1
	 HjjIy9EqcZlOfDmEMWv2GoZjma+6T9iEJbl3FoUc=
Date: Thu, 10 Sep 2026 16:00:49 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-sparse-initialize-memory-sections-earlier.patch removed from -mm tree
Message-Id: <20260910230049.EEA9D1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: initialize memory sections earlier
has been removed from the -mm tree.  Its filename was
     mm-sparse-initialize-memory-sections-earlier.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse: initialize memory sections earlier
Date: Tue, 25 Aug 2026 16:46:00 +0800

Upcoming HugeTLB bootmem changes need sparsemem section metadata before
the HugeTLB bootmem allocation path runs.  The memory sections are
initialized from sparse_init(), which is called too late for that setup.

Move the code that initializes sparsemem section metadata for memblock
ranges into mm_core_init_early(), before free_area_init() and the HugeTLB
bootmem setup.  Rename the helper to sparse_sections_init() so the new
caller describes the sparsemem-specific initialization step.

This is a preparatory change.

Link: https://lore.kernel.org/20260825084608.47437-10-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
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
 mm/sparse.c  |   10 ++--------
 mm/sparse.h  |    2 ++
 3 files changed, 5 insertions(+), 8 deletions(-)

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
@@ -191,12 +191,8 @@ static void __init memory_present(int ni
 	}
 }
 
-/*
- * Mark all memblocks as present using memory_present().
- * This is a convenience function that is useful to mark all of the systems
- * memory as present during initialization.
- */
-static void __init memblocks_present(void)
+/* Initialize memory section metadata for all system memory. */
+void __init sparse_sections_init(void)
 {
 	unsigned long start, end;
 	int i, nid;
@@ -322,8 +318,6 @@ void __init sparse_init(void)
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

