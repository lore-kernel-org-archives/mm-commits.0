Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0058003D
	for <mm-commits@vger.kernel.org>; Fri, 26 Jun 2026 00:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782434842; cv=none; b=bHDk0RuITh+7xDLIsAZxEbF8GxYEoduL6H48ntKbofsEqlTzH5rlyxJvBmToJzXkPxzdAM/3WOMEg54bSaYSGpMHvHsJ9vJnzU6KvYDcLzB+XW6vYp5y+qH/kyijvCnNW0aIaeDxN/veB8cN5aTPLQdMiQSwFZ54a1PNrc+jJ+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782434842; c=relaxed/simple;
	bh=dXQGhXMMjgupoaQ8SSAqtcKSiG9g/rXY/1PS/JABwCQ=;
	h=Date:To:From:Subject:Message-Id; b=k8Xk/TYUlJvFwY56k9yjwHdo3X8Xc61x3kcJ1lluYQgVFox1azcNV6NTS4jtB3Vxzg7tIHUkfZUmGAFXOsupndJH7Y/gQj7hbwkmyygbvrQDi+znuXDoKsWNqOJ1XeJWsUg0YCCVeFDvDMxV2u6jYXTm+Ggz6zRld60m6+fGbU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kkwDuh5p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kkwDuh5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959F01F000E9;
	Fri, 26 Jun 2026 00:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782434840;
	bh=7870vNtQR2Q6Lf1y/695/UqkDtTWfXYe7l9PVzTwTEM=;
	h=Date:To:From:Subject;
	b=kkwDuh5pU2XxwimXRFQzD9SRltrDbINZj80XnbpE2N2TdHoz1PHftW7wG4otLAH6G
	 PmgCiUhrp/LWwq7UIPZrYfY1YGC+/pV8bXblPnzb3SypKcZ2+iKlh/LseLullygsJ5
	 6qjSg7JEX80BPytyJvswYIZQ+uz13QSFT8HsVGZ8=
Date: Thu, 25 Jun 2026 17:47:20 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-move-subsection_map_init-into-sparse_init.patch added to mm-new branch
Message-Id: <20260626004720.959F01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse: move subsection_map_init() into sparse_init()
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-move-subsection_map_init-into-sparse_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-move-subsection_map_init-into-sparse_init.patch

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
Subject: mm/sparse: move subsection_map_init() into sparse_init()
Date: Fri, 12 Jun 2026 11:58:51 +0800

subsection_map_init() is part of sparse memory initialization, but it is
currently called from free_area_init().

Move it into sparse_init() so the sparse-specific setup stays together
instead of being split across the generic free_area_init() path.

Link: https://lore.kernel.org/20260612035903.2468601-8-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h       |    5 ++---
 mm/mm_init.c        |   10 ++--------
 mm/sparse-vmemmap.c |   11 ++++++++++-
 mm/sparse.c         |    1 +
 4 files changed, 15 insertions(+), 12 deletions(-)

--- a/mm/internal.h~mm-sparse-move-subsection_map_init-into-sparse_init
+++ a/mm/internal.h
@@ -994,10 +994,9 @@ static inline void sparse_init(void) {}
  * mm/sparse-vmemmap.c
  */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-void sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages);
+void sparse_init_subsection_map(void);
 #else
-static inline void sparse_init_subsection_map(unsigned long pfn,
-		unsigned long nr_pages)
+static inline void sparse_init_subsection_map(void)
 {
 }
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
--- a/mm/mm_init.c~mm-sparse-move-subsection_map_init-into-sparse_init
+++ a/mm/mm_init.c
@@ -1864,18 +1864,12 @@ static void __init free_area_init(void)
 			       (u64)zone_movable_pfn[i] << PAGE_SHIFT);
 	}
 
-	/*
-	 * Print out the early node map, and initialize the
-	 * subsection-map relative to active online memory ranges to
-	 * enable future "sub-section" extensions of the memory map.
-	 */
+	/* Print out the early node map. */
 	pr_info("Early memory node ranges\n");
-	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
 		pr_info("  node %3d: [mem %#018Lx-%#018Lx]\n", nid,
 			(u64)start_pfn << PAGE_SHIFT,
 			((u64)end_pfn << PAGE_SHIFT) - 1);
-		sparse_init_subsection_map(start_pfn, end_pfn - start_pfn);
-	}
 
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
--- a/mm/sparse.c~mm-sparse-move-subsection_map_init-into-sparse_init
+++ a/mm/sparse.c
@@ -361,5 +361,6 @@ void __init sparse_init(void)
 	}
 	/* cover the last node */
 	sparse_init_nid(nid_begin, pnum_begin, pnum_end, map_count);
+	sparse_init_subsection_map();
 	vmemmap_populate_print_last();
 }
--- a/mm/sparse-vmemmap.c~mm-sparse-move-subsection_map_init-into-sparse_init
+++ a/mm/sparse-vmemmap.c
@@ -601,7 +601,7 @@ static void subsection_mask_set(unsigned
 	bitmap_set(map, idx, end - idx + 1);
 }
 
-void __init sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages)
+static void __init sparse_init_subsection_map_range(unsigned long pfn, unsigned long nr_pages)
 {
 	int end_sec_nr = pfn_to_section_nr(pfn + nr_pages - 1);
 	unsigned long nr, start_sec_nr = pfn_to_section_nr(pfn);
@@ -624,6 +624,15 @@ void __init sparse_init_subsection_map(u
 	}
 }
 
+void __init sparse_init_subsection_map(void)
+{
+	int i, nid;
+	unsigned long start, end;
+
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid)
+		sparse_init_subsection_map_range(start, end - start);
+}
+
 #ifdef CONFIG_MEMORY_HOTPLUG
 
 /* Mark all memory sections within the pfn range as online */
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

