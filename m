Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8083113B7AE
	for <mm-commits@vger.kernel.org>; Fri, 26 Jun 2026 00:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782434849; cv=none; b=a8+X8roQn7NBfsC6yxmmlBcBbHRq3RGgwwi656l/KGGwGuFPE4s4urGd6/a9J4nUFGph+mKuIGSHfXJGY8HZ0kEaDsHScl7SWPA8K2dbkkPCoTO8/E/vcj3GCvuoLGDrq8JPR/ycmDRiCNdm6IsfrmG9Ae2Lfh/lIfwvEOqs8y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782434849; c=relaxed/simple;
	bh=bPkvu+A3z1brWZK9FjYi2LKmBF2ACmzUAjo9oNINh+8=;
	h=Date:To:From:Subject:Message-Id; b=qoRU8Wy4woJkvwAss20TlGN55Q1cPuARIdczlF0RTb8AjcVQzP4eZasz15iV+Bb66ITeCRscyI9B8F5ntQ6xuyYXWl9+rMnyezjjdG+7Mm5hD0lot89wNZZSQBp3R0++DVQzzLHO6qOPSHJSE4JaZfkTL3MLgTqLo0LOXjNKhkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JMgCZNLa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JMgCZNLa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556711F000E9;
	Fri, 26 Jun 2026 00:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782434848;
	bh=VFnjcJq2jPcqp7aAmW+hT3bKn+wtbA0Gj0b2lvKHbqY=;
	h=Date:To:From:Subject;
	b=JMgCZNLayDMEnT6ILaOwrTEzQ8UzQpSWdHLB3+mF9Y0+QYqbST/+FeRIoqcOsccFR
	 ++nWawHZJblz2RuwkoITYw+YH5jgBoC9sq81TXWKlxFGY2MiENUdemyfam3XY+eUOT
	 AqmYY1UYg8PD2aLe9AlHd2inxh75nCYRvaII9k2Q=
Date: Thu, 25 Jun 2026 17:47:27 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_init-remove-set_pageblock_order-call-from-sparse_init.patch added to mm-new branch
Message-Id: <20260626004728.556711F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init: remove set_pageblock_order() call from sparse_init()
has been added to the -mm mm-new branch.  Its filename is
     mm-mm_init-remove-set_pageblock_order-call-from-sparse_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-remove-set_pageblock_order-call-from-sparse_init.patch

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
Subject: mm/mm_init: remove set_pageblock_order() call from sparse_init()
Date: Fri, 12 Jun 2026 11:58:54 +0800

free_area_init() already sets pageblock_order before sparse_init() runs
for CONFIG_HUGETLB_PAGE_SIZE_VARIABLE, so sparse_init() does not need to
call set_pageblock_order() again.

With that call removed, set_pageblock_order() is only used in
mm/mm_init.c.  Make it static.

Link: https://lore.kernel.org/20260612035903.2468601-11-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@suse.de>
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

 mm/internal.h |    1 -
 mm/mm_init.c  |    4 ++--
 mm/sparse.c   |    3 ---
 3 files changed, 2 insertions(+), 6 deletions(-)

--- a/mm/internal.h~mm-mm_init-remove-set_pageblock_order-call-from-sparse_init
+++ a/mm/internal.h
@@ -1435,7 +1435,6 @@ extern unsigned long  __must_check vm_mm
         unsigned long, unsigned long,
         unsigned long, unsigned long);
 
-extern void set_pageblock_order(void);
 unsigned long reclaim_pages(struct list_head *folio_list);
 unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 					    struct list_head *folio_list);
--- a/mm/mm_init.c~mm-mm_init-remove-set_pageblock_order-call-from-sparse_init
+++ a/mm/mm_init.c
@@ -1496,7 +1496,7 @@ static inline void setup_usemap(struct z
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 
 /* Initialise the number of pages represented by NR_PAGEBLOCK_BITS */
-void __init set_pageblock_order(void)
+static void __init set_pageblock_order(void)
 {
 	unsigned int order = PAGE_BLOCK_MAX_ORDER;
 
@@ -1522,7 +1522,7 @@ void __init set_pageblock_order(void)
  * include/linux/pageblock-flags.h for the values of pageblock_order based on
  * the kernel config
  */
-void __init set_pageblock_order(void)
+static inline void __init set_pageblock_order(void)
 {
 }
 
--- a/mm/sparse.c~mm-mm_init-remove-set_pageblock_order-call-from-sparse_init
+++ a/mm/sparse.c
@@ -343,9 +343,6 @@ void __init sparse_init(void)
 	pnum_begin = first_present_section_nr();
 	nid_begin = sparse_early_nid(__nr_to_section(pnum_begin));
 
-	/* Setup pageblock_order for HUGETLB_PAGE_SIZE_VARIABLE */
-	set_pageblock_order();
-
 	for_each_present_section_nr(pnum_begin + 1, pnum_end) {
 		int nid = sparse_early_nid(__nr_to_section(pnum_end));
 
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

