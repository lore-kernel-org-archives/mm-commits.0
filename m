Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793768266;
	b=FcIFFNoZKnipObdkb9UKIG2ymfSh+wdyB/uTgjHJHTKUydb9PIKpekBZrbjBMqkVGcfO
	 IqGDV2v5c+faUZBTqf2V38NsT9TjlQbmS6jL4sTArpPSZt1EDmF4YRPlLicRc5kbKngxO
	 JAQr0vSjB9Dx+OHgOVveqHIkPY0r3NxYOw1pLPGl96rN82Pnuf5s5sqNoZZP4orJLMEYQ
	 MasWDi25xUZ/F/pTCL+/GYlQqvm3Rx1DAUAfr8zoL2wXL+nGRY41guEIxpt6+1dAajdaE
	 1FRW7BhH3mM9lRyy2uH7+sU8wP4bbkqcwtoweY0jO2HpF99oLICflP/QrbCWy+EuUqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793768266;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=QQQHAXksE/VbAeCdNrVuf3M37s+l9GhtMgAgfMs4Wk8=;
	b=ynsWjQ+uHYedBIxJAQ/PQHOuJ+tAxoytF10fDkgqK/ccCIapM7VSufFTz8J78UU7sh25
	 fFs0yeIfELAJbmXA3+xtgirSmk0sQx6tmEGt31cTluA9SwOrn1VsZAt2alYPiT9Gn6pVy
	 r72ivXt4rznmGhsCjFLR56SGiRkYN/UlGbBMa0b+pUWtuLU90Gx0WUOKIFcwAC61kd9li
	 OoQBU/7UuiB2e88FwUQt8aJU4m0Qt+FyZtiuRdyQZ8KFMYwmtDsf8FWmhQrBcqoE6j0aq
	 KW+EprrHfb88liKQr/ucp0JRvdydMxxHZujLDJZDOTBhKqGAS1rlE+2XluPJYxpeXww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LFYdT+i0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D73606A31B
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 04:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LFYdT+i0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5B71F000C1;
	Wed,  4 Nov 2026 04:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793768265;
	bh=QQQHAXksE/VbAeCdNrVuf3M37s+l9GhtMgAgfMs4Wk8=;
	h=Date:To:From:Subject;
	b=LFYdT+i0fr9cqeqhUs9SsUpYjC2wRu4HPSdH0b2OdTE8hUjDknYtgJYxBUQDjxqh2
	 kW0vlYm/0170Gv+VOShSS5B2n/11E/35T8UsbFvhkMM/sAbExSaVagI7yW9Nfo8r+T
	 yWlJ5eLQxrYu26jWFSVyJn+GS36kZZk2N7u7w+vA=
Date: Tue, 03 Nov 2026 20:57:44 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,qi.zheng@linux.dev,
	osalvador@suse.de,lance.yang@linux.dev,jthoughton@google.com,
	david@kernel.org,chenhuacai@kernel.org,muchun.song@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-remove-hugetlb-specific-vmemmap-optimization-macros.patch added to mm-new branch
Message-Id: <20261104045745.5A5B71F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: hugetlb_vmemmap: remove HugeTLB-specific vmemmap optimization macros
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb_vmemmap-remove-hugetlb-specific-vmemmap-optimization-macros.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-remove-hugetlb-specific-vmemmap-optimization-macros.patch

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
From: Muchun Song <muchun.song@linux.dev>
Subject: mm: hugetlb_vmemmap: remove HugeTLB-specific vmemmap optimization macros
Date: Wed, 04 Nov 2026 10:34:59 +0800

Patch series "mm: Decouple folio-based vmemmap optimization from HugeTLB",
v3.

Hi,

Section-based vmemmap optimization is implemented in sparse-vmemmap.c,
while folio-based optimization currently lives in hugetlb_vmemmap.c.  The
latter is tightly coupled to HugeTLB-specific state even though the
underlying page-table remapping operates on one folio at a time.

To make these interfaces easier to maintain, the folio-based remapping
mechanics first need a boundary that is independent of HugeTLB-specific
state and raw address ranges.  This will allow the mechanics to be moved
into a common vmemmap optimization layer alongside the section-based
interface.

This series establishes that boundary through three folio-oriented
operations, each with a distinct role:

  - vmemmap_optimize_folio() optimizes the vmemmap backing of a folio;
  - vmemmap_restore_folio() restores the vmemmap backing of a folio; and
  - vmemmap_pteify_folio() converts the vmemmap backing of a folio to
    PTE mappings.

Together, these operations encapsulate the address-range calculation and
remapping mechanics for a folio.  HugeTLB wrappers retain policy decisions
such as eligibility, optimized state, batching and TLB flush handling.

Patches 1-8 generalize the underlying vmemmap remapping infrastructure by
removing HugeTLB-specific assumptions and simplifying remap control and
resource handling.  Patches 9-12 then establish folio-oriented operations
for optimization, restoration and PTE conversion.

The implementation remains in hugetlb_vmemmap.c for now.  A follow-up can
move the folio-based operations into the common vmemmap optimization layer
once the interface boundary is in place.


This patch (of 12):

Vmemmap optimization is no longer HugeTLB-specific, so the remaining
HugeTLB-local reserve macros are redundant.

Replace them with the generic definitions to remove duplication and keep
the HugeTLB vmemmap code aligned with the common optimization macros.

Link: https://lore.kernel.org/20261104023510.260766-1-songmuchun@bytedance.com
Link: https://lore.kernel.org/20261104023510.260766-2-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: James Houghton <jthoughton@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
---

 include/linux/vmemmap-optimization.h |    4 ++--
 mm/hugetlb.c                         |    4 ++--
 mm/hugetlb_vmemmap.c                 |    6 +++---
 mm/hugetlb_vmemmap.h                 |   10 ++--------
 4 files changed, 9 insertions(+), 15 deletions(-)

--- a/include/linux/vmemmap-optimization.h~mm-hugetlb_vmemmap-remove-hugetlb-specific-vmemmap-optimization-macros
+++ a/include/linux/vmemmap-optimization.h
@@ -27,8 +27,8 @@
 
 /* The number of retained vmemmap pages with HVO enabled. */
 #define VMEMMAP_OPTIMIZATION_PAGES		1
-#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	\
-	(VMEMMAP_OPTIMIZATION_PAGES * PAGE_SIZE / sizeof(struct page))
+#define VMEMMAP_OPTIMIZATION_SIZE		(VMEMMAP_OPTIMIZATION_PAGES * PAGE_SIZE)
+#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	(VMEMMAP_OPTIMIZATION_SIZE / sizeof(struct page))
 #define VMEMMAP_OPTIMIZATION_MIN_ORDER		(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
 
 #ifdef CONFIG_VMEMMAP_OPTIMIZATION
--- a/mm/hugetlb.c~mm-hugetlb_vmemmap-remove-hugetlb-specific-vmemmap-optimization-macros
+++ a/mm/hugetlb.c
@@ -3317,7 +3317,7 @@ static void __init prep_and_add_bootmem_
 			 * be no contention.
 			 */
 			hugetlb_folio_init_tail_vmemmap(folio, h,
-					HUGETLB_VMEMMAP_RESERVE_PAGES,
+					VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES,
 					pages_per_huge_page(h));
 		}
 		hugetlb_bootmem_init_migratetype(folio, h);
@@ -3357,7 +3357,7 @@ static void __init gather_bootmem_preall
 		WARN_ON(folio_ref_count(folio) != 1);
 
 		hugetlb_folio_init_vmemmap(folio, h,
-					   HUGETLB_VMEMMAP_RESERVE_PAGES);
+					   VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES);
 		init_new_hugetlb_folio(folio);
 
 		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-remove-hugetlb-specific-vmemmap-optimization-macros
+++ a/mm/hugetlb_vmemmap.c
@@ -408,7 +408,7 @@ static int __hugetlb_vmemmap_restore_fol
 	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 
-	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
+	vmemmap_start	+= VMEMMAP_OPTIMIZATION_SIZE;
 
 	/*
 	 * The pages which the vmemmap virtual address range [@vmemmap_start,
@@ -676,8 +676,8 @@ static int __init hugetlb_vmemmap_init(v
 {
 	const struct hstate *h;
 
-	/* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct pages */
-	BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
+	/* VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES should cover all used struct pages */
+	BUILD_BUG_ON(__NR_USED_SUBPAGE > VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES);
 
 	for_each_hstate(h) {
 		if (hugetlb_vmemmap_optimizable(h)) {
--- a/mm/hugetlb_vmemmap.h~mm-hugetlb_vmemmap-remove-hugetlb-specific-vmemmap-optimization-macros
+++ a/mm/hugetlb_vmemmap.h
@@ -9,13 +9,7 @@
 #ifndef _LINUX_HUGETLB_VMEMMAP_H
 #define _LINUX_HUGETLB_VMEMMAP_H
 #include <linux/hugetlb.h>
-
-/*
- * Reserve one vmemmap page, all vmemmap addresses are mapped to it. See
- * Documentation/mm/vmemmap_dedup.rst.
- */
-#define HUGETLB_VMEMMAP_RESERVE_SIZE	PAGE_SIZE
-#define HUGETLB_VMEMMAP_RESERVE_PAGES	(HUGETLB_VMEMMAP_RESERVE_SIZE / sizeof(struct page))
+#include <linux/vmemmap-optimization.h>
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio);
@@ -37,7 +31,7 @@ static inline unsigned int hugetlb_vmemm
  */
 static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
 {
-	int size = hugetlb_vmemmap_size(h) - HUGETLB_VMEMMAP_RESERVE_SIZE;
+	int size = hugetlb_vmemmap_size(h) - VMEMMAP_OPTIMIZATION_SIZE;
 
 	if (!is_power_of_2(sizeof(struct page)))
 		return 0;
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-fix-missing-page-table-destructor-in-pagetable_free.patch
riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch
mm-sparse-vmemmap-map-shared-vmemmap-tail-pages-as-read-only.patch
powerpc-mm-map-shared-vmemmap-tail-pages-as-read-only.patch
mm-hugetlb_vmemmap-remove-vmemmap_wrprotect_hvo.patch
mm-hugetlb_vmemmap-remove-hugetlb_vmemmap_optimize_bootmem_folios.patch
mm-generalize-kernel-pte-table-allocation.patch
mm-generalize-pmd-page-table-allocation.patch
mm-generalize-pud-page-table-allocation.patch
mm-remove-pagetable_dtor_free.patch
mm-remove-redundant-pagetable_dtor-calls.patch
mm-hugetlb_vmemmap-remove-hugetlb-specific-vmemmap-optimization-macros.patch
mm-hugetlb_vmemmap-unify-vmemmap_splitremap_no_tlb_flush.patch
mm-hugetlb_vmemmap-simplify-vmemmap-head-page-handling.patch
mm-hugetlb_vmemmap-generalize-vmemmap-page-allocation.patch
mm-hugetlb_vmemmap-unify-writable-vmemmap-page-preparation.patch
mm-hugetlb_vmemmap-rename-vmemmap_remap_pte-to-vmemmap_optimize_pte.patch
mm-hugetlb_vmemmap-simplify-shared-tail-page-handling.patch
mm-hugetlb_vmemmap-move-alloc_vmemmap_page_list-next-to-its-free-helper.patch
mm-hugetlb_vmemmap-make-vmemmap-optimization-folio-oriented.patch
mm-hugetlb_vmemmap-make-vmemmap-restoration-folio-oriented.patch
mm-hugetlb_vmemmap-unify-vmemmap-range-restoration.patch
mm-hugetlb_vmemmap-make-vmemmap-pte-conversion-folio-oriented.patch

