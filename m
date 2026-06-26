Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1FE20E023
	for <mm-commits@vger.kernel.org>; Fri, 26 Jun 2026 00:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782434874; cv=none; b=GakfEosYiwp1a1ZmVTfXIFuZJfNbSduZbP2yD7pngQ/7E+z6iaE28Rf1qVG69MbFJAs+03MZALETUKQHgGcxU2gzNks6ioWcM/FI1/A3ULaO8fprJSkZGoRl9HQ3FpA3bQ36VoPQQzKrGxqojyofyQ3iQH51Dnv9KKuuWpGDScw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782434874; c=relaxed/simple;
	bh=25CK0YDDNvbdtrtvkLuMv5S7ivfmxlV93/MWPNsBTrE=;
	h=Date:To:From:Subject:Message-Id; b=rdzRQikgwYfuaJ6GPBbx4a+q+kY4q++ZlUbWuW02EI+/AyidPUgZ84dw/LXWqfdFKMEBNYHNszZPG5lrzbrBXqqTy2Y1RnATGDiCBiZgR/2ErIThrW1tXRazkvyYT6AE5zM0oCtP98HLMMVRtCni32ntozcEO/reI3wmXrxZ8fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k+hYnSOh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k+hYnSOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0074F1F000E9;
	Fri, 26 Jun 2026 00:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782434873;
	bh=Fu3RZNOzWStzlVlgZQCjxto8HhIGa+wSy4DaHjoxD2M=;
	h=Date:To:From:Subject;
	b=k+hYnSOhFhmAhsBs2gZs4wApNS7sKeY29ibVrrp+6NA0yifRibLZpJ8dUeRxekFKd
	 TbuP16bpbMbTUbVgLcSWXyWrP8OqWK+G01Bys0VZnM4yREeXFdpQ3J3mqvv3Yn1BRt
	 tNwOg+aOMUfVvY0AQvoNsoUX8K8J0n5vfJk3XTv8=
Date: Thu, 25 Jun 2026 17:47:52 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-vmemmap-remove-sparse_vmemmap_init_nid_late.patch added to mm-new branch
Message-Id: <20260626004753.0074F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse-vmemmap: remove sparse_vmemmap_init_nid_late()
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-vmemmap-remove-sparse_vmemmap_init_nid_late.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-vmemmap-remove-sparse_vmemmap_init_nid_late.patch

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
Subject: mm/sparse-vmemmap: remove sparse_vmemmap_init_nid_late()
Date: Fri, 12 Jun 2026 11:59:01 +0800

hugetlb_vmemmap_init_late() no longer has any users, so the remaining
late-init path in sparse_vmemmap_init_nid_late() is dead code.

Remove sparse_vmemmap_init_nid_late() and its declarations.

Link: https://lore.kernel.org/20260612035903.2468601-18-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    7 -------
 mm/hugetlb_vmemmap.c   |    4 ----
 mm/hugetlb_vmemmap.h   |    5 -----
 mm/sparse-vmemmap.c    |   11 -----------
 mm/sparse.c            |    1 -
 5 files changed, 28 deletions(-)

--- a/include/linux/mmzone.h~mm-sparse-vmemmap-remove-sparse_vmemmap_init_nid_late
+++ a/include/linux/mmzone.h
@@ -2156,8 +2156,6 @@ static inline int preinited_vmemmap_sect
 }
 
 void sparse_vmemmap_init_nid_early(int nid);
-void sparse_vmemmap_init_nid_late(int nid);
-
 #else
 static inline int preinited_vmemmap_section(const struct mem_section *section)
 {
@@ -2166,10 +2164,6 @@ static inline int preinited_vmemmap_sect
 static inline void sparse_vmemmap_init_nid_early(int nid)
 {
 }
-
-static inline void sparse_vmemmap_init_nid_late(int nid)
-{
-}
 #endif
 
 static inline int online_section_nr(unsigned long nr)
@@ -2374,7 +2368,6 @@ static inline unsigned long next_present
 
 #else
 #define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
-#define sparse_vmemmap_init_nid_late(_nid) do {} while (0)
 #define pfn_in_present_section pfn_valid
 #endif /* CONFIG_SPARSEMEM */
 
--- a/mm/hugetlb_vmemmap.c~mm-sparse-vmemmap-remove-sparse_vmemmap_init_nid_late
+++ a/mm/hugetlb_vmemmap.c
@@ -808,10 +808,6 @@ void __init hugetlb_vmemmap_init_early(i
 		m->flags |= HUGE_BOOTMEM_HVO;
 	}
 }
-
-void __init hugetlb_vmemmap_init_late(int nid)
-{
-}
 #endif
 
 static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
--- a/mm/hugetlb_vmemmap.h~mm-sparse-vmemmap-remove-sparse_vmemmap_init_nid_late
+++ a/mm/hugetlb_vmemmap.h
@@ -29,7 +29,6 @@ void hugetlb_vmemmap_optimize_folios(str
 void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head *folio_list);
 #ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
 void hugetlb_vmemmap_init_early(int nid);
-void hugetlb_vmemmap_init_late(int nid);
 #endif
 
 
@@ -81,10 +80,6 @@ static inline void hugetlb_vmemmap_init_
 {
 }
 
-static inline void hugetlb_vmemmap_init_late(int nid)
-{
-}
-
 static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
 {
 	return 0;
--- a/mm/sparse.c~mm-sparse-vmemmap-remove-sparse_vmemmap_init_nid_late
+++ a/mm/sparse.c
@@ -320,7 +320,6 @@ static void __init sparse_init_nid(int n
 		}
 	}
 	sparse_usage_fini();
-	sparse_vmemmap_init_nid_late(nid);
 }
 
 /*
--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-remove-sparse_vmemmap_init_nid_late
+++ a/mm/sparse-vmemmap.c
@@ -579,17 +579,6 @@ void __init sparse_vmemmap_init_nid_earl
 {
 	hugetlb_vmemmap_init_early(nid);
 }
-
-/*
- * This is called just before the initialization of page structures
- * through memmap_init. Zones are now initialized, so any work that
- * needs to be done that needs zone information can be done from
- * here.
- */
-void __init sparse_vmemmap_init_nid_late(int nid)
-{
-	hugetlb_vmemmap_init_late(nid);
-}
 #endif
 
 static void subsection_mask_set(unsigned long *map, unsigned long pfn,
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

