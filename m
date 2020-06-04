From: akpm@linux-foundation.org
Subject: [merged]
 mm-gup-refactor-and-de-duplicate-gup_fast-code.patch removed from -mm tree
Date: Thu, 04 Jun 2020 10:16:01 -0700
Message-ID: <20200604171601._8BxqZ6B0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729866AbgFDRQD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:16:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, chris@chris-wilson.co.uk, daniel@ffwll.ch, jani.nikula@linux.intel.com, jhubbard@nvidia.com, joonas.lahtinen@linux.intel.com, jrdr.linux@gmail.com, matthew.auld@intel.com, mm-commits@vger.kernel.org, rodrigo.vivi@intel.com, tvrtko.ursulin@intel.com, willy@infradead.org


The patch titled
     Subject: mm/gup: refactor and de-duplicate gup_fast() code
has been removed from the -mm tree.  Its filename was
     mm-gup-refactor-and-de-duplicate-gup_fast-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: refactor and de-duplicate gup_fast() code

There were two nearly identical sets of code for gup_fast() style of
walking the page tables with interrupts disabled.  This has lead to the
usual maintenance problems that arise from having duplicated code.

There is already a core internal routine in gup.c for gup_fast(), so just
enhance it very slightly: allow skipping the fall-back to "slow" (regular)
get_user_pages(), via the new FOLL_FAST_ONLY flag.  Then, just call
internal_get_user_pages_fast() from __get_user_pages_fast(), and adjust
the API to match pre-existing API behavior.

There is a change in behavior from this refactoring: the nested form of
interrupt disabling is used in all gup_fast() variants now.  That's
because there is only one place that interrupt disabling for page walking
is done, and so the safer form is required.  This should, if anything,
eliminate possible (rare) bugs, because the non-nested form of enabling
interrupts was fragile at best.

[jhubbard@nvidia.com: fixup]
  Link: http://lkml.kernel.org/r/20200521233841.1279742-1-jhubbard@nvidia.com
Link: http://lkml.kernel.org/r/20200519002124.2025955-3-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: "Joonas Lahtinen" <joonas.lahtinen@linux.intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 
 mm/gup.c           |   61 ++++++++++++++++++++-----------------------
 2 files changed, 30 insertions(+), 32 deletions(-)

--- a/include/linux/mm.h~mm-gup-refactor-and-de-duplicate-gup_fast-code
+++ a/include/linux/mm.h
@@ -2816,6 +2816,7 @@ struct page *follow_page(struct vm_area_
 #define FOLL_LONGTERM	0x10000	/* mapping lifetime is indefinite: see below */
 #define FOLL_SPLIT_PMD	0x20000	/* split huge pmd before returning */
 #define FOLL_PIN	0x40000	/* pages must be released via unpin_user_page */
+#define FOLL_FAST_ONLY	0x80000	/* gup_fast: prevent fall-back to slow gup */
 
 /*
  * FOLL_PIN and FOLL_LONGTERM may be used in various combinations with each
--- a/mm/gup.c~mm-gup-refactor-and-de-duplicate-gup_fast-code
+++ a/mm/gup.c
@@ -2731,10 +2731,12 @@ static int internal_get_user_pages_fast(
 					struct page **pages)
 {
 	unsigned long addr, len, end;
+	unsigned long flags;
 	int nr_pinned = 0, ret = 0;
 
 	if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM |
-				       FOLL_FORCE | FOLL_PIN | FOLL_GET)))
+				       FOLL_FORCE | FOLL_PIN | FOLL_GET |
+				       FOLL_FAST_ONLY)))
 		return -EINVAL;
 
 	start = untagged_addr(start) & PAGE_MASK;
@@ -2753,16 +2755,26 @@ static int internal_get_user_pages_fast(
 	 * order to avoid confusing the normal COW routines. So only
 	 * targets that are already writable are safe to do by just
 	 * looking at the page tables.
+	 *
+	 * Disable interrupts. The nested form is used, in order to allow full,
+	 * general purpose use of this routine.
+	 *
+	 * With interrupts disabled, we block page table pages from being
+	 * freed from under us. See struct mmu_table_batch comments in
+	 * include/asm-generic/tlb.h for more details.
+	 *
+	 * We do not adopt an rcu_read_lock(.) here as we also want to
+	 * block IPIs that come from THPs splitting.
 	 */
 	if (IS_ENABLED(CONFIG_HAVE_FAST_GUP) &&
 	    gup_fast_permitted(start, end)) {
-		local_irq_disable();
+		local_irq_save(flags);
 		gup_pgd_range(addr, end, gup_flags | FOLL_WRITE, pages, &nr_pinned);
-		local_irq_enable();
+		local_irq_restore(flags);
 		ret = nr_pinned;
 	}
 
-	if (nr_pinned < nr_pages) {
+	if (nr_pinned < nr_pages && !(gup_flags & FOLL_FAST_ONLY)) {
 		/* Try to get the remaining pages with get_user_pages */
 		start += nr_pinned << PAGE_SHIFT;
 		pages += nr_pinned;
@@ -2798,37 +2810,27 @@ static int internal_get_user_pages_fast(
 int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			  struct page **pages)
 {
-	unsigned long len, end;
-	unsigned long flags;
-	int nr_pinned = 0;
+	int nr_pinned;
 	/*
 	 * Internally (within mm/gup.c), gup fast variants must set FOLL_GET,
 	 * because gup fast is always a "pin with a +1 page refcount" request.
+	 *
+	 * FOLL_FAST_ONLY is required in order to match the API description of
+	 * this routine: no fall back to regular ("slow") GUP.
 	 */
-	unsigned int gup_flags = FOLL_GET;
+	unsigned int gup_flags = FOLL_GET | FOLL_FAST_ONLY;
 
 	if (write)
 		gup_flags |= FOLL_WRITE;
 
-	start = untagged_addr(start) & PAGE_MASK;
-	len = (unsigned long) nr_pages << PAGE_SHIFT;
-	end = start + len;
-
-	if (end <= start)
-		return 0;
-	if (unlikely(!access_ok((void __user *)start, len)))
-		return 0;
+	nr_pinned = internal_get_user_pages_fast(start, nr_pages, gup_flags,
+						 pages);
 
 	/*
-	 * Disable interrupts.  We use the nested form as we can already have
-	 * interrupts disabled by get_futex_key.
-	 *
-	 * With interrupts disabled, we block page table pages from being
-	 * freed from under us. See struct mmu_table_batch comments in
-	 * include/asm-generic/tlb.h for more details.
-	 *
-	 * We do not adopt an rcu_read_lock(.) here as we also want to
-	 * block IPIs that come from THPs splitting.
+	 * As specified in the API description above, this routine is not
+	 * allowed to return negative values. However, the common core
+	 * routine internal_get_user_pages_fast() *can* return -errno.
+	 * Therefore, correct for that here:
 	 *
 	 * NOTE! We allow read-only gup_fast() here, but you'd better be
 	 * careful about possible COW pages. You'll get _a_ COW page, but
@@ -2836,13 +2838,8 @@ int __get_user_pages_fast(unsigned long
 	 * COW event happens after this. COW may break the page copy in a
 	 * random direction.
 	 */
