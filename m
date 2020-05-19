From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-refactor-and-de-duplicate-gup_fast-code.patch
 added to -mm tree
Date: Mon, 18 May 2020 20:22:38 -0700
Message-ID: <20200519032238.hseZhjHMZ%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbgESDWk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 23:22:40 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, chris@chris-wilson.co.uk, daniel@ffwll.ch, jani.nikula@linux.intel.com, jhubbard@nvidia.com, joonas.lahtinen@linux.intel.com, jrdr.linux@gmail.com, matthew.auld@intel.com, mm-commits@vger.kernel.org, rodrigo.vivi@intel.com, tvrtko.ursulin@intel.com, willy@infradead.org


The patch titled
     Subject: mm/gup: refactor and de-duplicate gup_fast() code
has been added to the -mm tree.  Its filename is
     mm-gup-refactor-and-de-duplicate-gup_fast-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gup-refactor-and-de-duplicate-gup_fast-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-refactor-and-de-duplicate-gup_fast-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: http://lkml.kernel.org/r/20200519002124.2025955-3-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
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
 mm/gup.c           |   60 ++++++++++++++++++++-----------------------
 2 files changed, 29 insertions(+), 32 deletions(-)

--- a/include/linux/mm.h~mm-gup-refactor-and-de-duplicate-gup_fast-code
+++ a/include/linux/mm.h
@@ -2763,6 +2763,7 @@ struct page *follow_page(struct vm_area_
 #define FOLL_LONGTERM	0x10000	/* mapping lifetime is indefinite: see below */
 #define FOLL_SPLIT_PMD	0x20000	/* split huge pmd before returning */
 #define FOLL_PIN	0x40000	/* pages must be released via unpin_user_page */
+#define FOLL_FAST_ONLY	0x80000	/* gup_fast: prevent fall-back to slow gup */
 
 /*
  * FOLL_PIN and FOLL_LONGTERM may be used in various combinations with each
--- a/mm/gup.c~mm-gup-refactor-and-de-duplicate-gup_fast-code
+++ a/mm/gup.c
@@ -2715,6 +2715,7 @@ static int internal_get_user_pages_fast(
 					struct page **pages)
 {
 	unsigned long addr, len, end;
+	unsigned long flags;
 	int nr_pinned = 0, ret = 0;
 
 	if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM |
@@ -2731,15 +2732,26 @@ static int internal_get_user_pages_fast(
 	if (unlikely(!access_ok((void __user *)start, len)))
 		return -EFAULT;
 
+	/*
+	 * Disable interrupts. The nested form is used, in order to allow full,
+	 * general purpose use of this routine.
+	 *
+	 * With interrupts disabled, we block page table pages from being
+	 * freed from under us. See struct mmu_table_batch comments in
+	 * include/asm-generic/tlb.h for more details.
+	 *
+	 * We do not adopt an rcu_read_lock(.) here as we also want to
+	 * block IPIs that come from THPs splitting.
+	 */
 	if (IS_ENABLED(CONFIG_HAVE_FAST_GUP) &&
 	    gup_fast_permitted(start, end)) {
-		local_irq_disable();
+		local_irq_save(flags);
 		gup_pgd_range(addr, end, gup_flags, pages, &nr_pinned);
-		local_irq_enable();
+		local_irq_restore(flags);
 		ret = nr_pinned;
 	}
 
-	if (nr_pinned < nr_pages) {
+	if (nr_pinned < nr_pages && !(gup_flags & FOLL_FAST_ONLY)) {
 		/* Try to get the remaining pages with get_user_pages */
 		start += nr_pinned << PAGE_SHIFT;
 		pages += nr_pinned;
@@ -2771,45 +2783,29 @@ static int internal_get_user_pages_fast(
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
-
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
 	 */
