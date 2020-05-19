From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-gup-move-__get_user_pages_fast-down-a-few-lines-in-gupc.patch added to
 -mm tree
Date: Mon, 18 May 2020 20:22:35 -0700
Message-ID: <20200519032235.DW4TJKoQL%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbgESDWh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 23:22:37 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, chris@chris-wilson.co.uk, daniel@ffwll.ch, jani.nikula@linux.intel.com, jhubbard@nvidia.com, joonas.lahtinen@linux.intel.com, jrdr.linux@gmail.com, matthew.auld@intel.com, mm-commits@vger.kernel.org, rodrigo.vivi@intel.com, tvrtko.ursulin@intel.com, willy@infradead.org


The patch titled
     Subject: mm/gup: move __get_user_pages_fast() down a few lines in gup.c
has been added to the -mm tree.  Its filename is
     mm-gup-move-__get_user_pages_fast-down-a-few-lines-in-gupc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gup-move-__get_user_pages_fast-down-a-few-lines-in-gupc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-move-__get_user_pages_fast-down-a-few-lines-in-gupc.patch

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
Subject: mm/gup: move __get_user_pages_fast() down a few lines in gup.c

Patch series "mm/gup, drm/i915: refactor gup_fast, convert to
pin_user_pages()".

In order to convert the drm/i915 driver from get_user_pages() to
pin_user_pages(), a FOLL_PIN equivalent of __get_user_pages_fast() was
required.  That led to refactoring __get_user_pages_fast(), with the
following goals:

1) As above: provide a pin_user_pages*() routine for drm/i915 to call,
   in place of __get_user_pages_fast(),

2) Get rid of the gup.c duplicate code for walking page tables with
   interrupts disabled. This duplicate code is a minor maintenance
   problem anyway.

3) Make it easy for an upcoming patch from Souptick, which aims to
   convert __get_user_pages_fast() to use a gup_flags argument, instead
   of a bool writeable arg.  Also, if this series looks good, we can
   ask Souptick to change the name as well, to whatever the consensus
   is. My initial recommendation is: get_user_pages_fast_only(), to
   match the new pin_user_pages_only().


This patch (of 4):

This is in order to avoid a forward declaration of
internal_get_user_pages_fast(), in the next patch.

This is code movement only--all generated code should be identical.

Link: http://lkml.kernel.org/r/20200519002124.2025955-1-jhubbard@nvidia.com
Link: http://lkml.kernel.org/r/20200519002124.2025955-2-jhubbard@nvidia.com
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

 mm/gup.c |  112 ++++++++++++++++++++++++++---------------------------
 1 file changed, 56 insertions(+), 56 deletions(-)

--- a/mm/gup.c~mm-gup-move-__get_user_pages_fast-down-a-few-lines-in-gupc
+++ a/mm/gup.c
@@ -2687,62 +2687,6 @@ static bool gup_fast_permitted(unsigned
 }
 #endif
 
-/*
- * Like get_user_pages_fast() except it's IRQ-safe in that it won't fall back to
- * the regular GUP.
- * Note a difference with get_user_pages_fast: this always returns the
- * number of pages pinned, 0 if no pages were pinned.
- *
- * If the architecture does not support this function, simply return with no
- * pages pinned.
- */
-int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
-			  struct page **pages)
-{
-	unsigned long len, end;
-	unsigned long flags;
-	int nr_pinned = 0;
-	/*
-	 * Internally (within mm/gup.c), gup fast variants must set FOLL_GET,
-	 * because gup fast is always a "pin with a +1 page refcount" request.
-	 */
-	unsigned int gup_flags = FOLL_GET;
-
-	if (write)
-		gup_flags |= FOLL_WRITE;
-
-	start = untagged_addr(start) & PAGE_MASK;
-	len = (unsigned long) nr_pages << PAGE_SHIFT;
-	end = start + len;
-
-	if (end <= start)
-		return 0;
-	if (unlikely(!access_ok((void __user *)start, len)))
-		return 0;
-
-	/*
-	 * Disable interrupts.  We use the nested form as we can already have
-	 * interrupts disabled by get_futex_key.
-	 *
-	 * With interrupts disabled, we block page table pages from being
-	 * freed from under us. See struct mmu_table_batch comments in
-	 * include/asm-generic/tlb.h for more details.
-	 *
-	 * We do not adopt an rcu_read_lock(.) here as we also want to
-	 * block IPIs that come from THPs splitting.
-	 */
-
-	if (IS_ENABLED(CONFIG_HAVE_FAST_GUP) &&
-	    gup_fast_permitted(start, end)) {
-		local_irq_save(flags);
-		gup_pgd_range(start, end, gup_flags, pages, &nr_pinned);
-		local_irq_restore(flags);
-	}
-
-	return nr_pinned;
-}
-EXPORT_SYMBOL_GPL(__get_user_pages_fast);
-
 static int __gup_longterm_unlocked(unsigned long start, int nr_pages,
 				   unsigned int gup_flags, struct page **pages)
 {
@@ -2815,6 +2759,62 @@ static int internal_get_user_pages_fast(
 	return ret;
 }
 
+/*
+ * Like get_user_pages_fast() except it's IRQ-safe in that it won't fall back to
+ * the regular GUP.
+ * Note a difference with get_user_pages_fast: this always returns the
+ * number of pages pinned, 0 if no pages were pinned.
+ *
+ * If the architecture does not support this function, simply return with no
+ * pages pinned.
+ */
+int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
+			  struct page **pages)
+{
+	unsigned long len, end;
+	unsigned long flags;
+	int nr_pinned = 0;
+	/*
+	 * Internally (within mm/gup.c), gup fast variants must set FOLL_GET,
+	 * because gup fast is always a "pin with a +1 page refcount" request.
+	 */
+	unsigned int gup_flags = FOLL_GET;
+
+	if (write)
+		gup_flags |= FOLL_WRITE;
+
+	start = untagged_addr(start) & PAGE_MASK;
+	len = (unsigned long) nr_pages << PAGE_SHIFT;
+	end = start + len;
+
+	if (end <= start)
+		return 0;
+	if (unlikely(!access_ok((void __user *)start, len)))
+		return 0;
+
+	/*
+	 * Disable interrupts.  We use the nested form as we can already have
+	 * interrupts disabled by get_futex_key.
+	 *
+	 * With interrupts disabled, we block page table pages from being
+	 * freed from under us. See struct mmu_table_batch comments in
+	 * include/asm-generic/tlb.h for more details.
+	 *
+	 * We do not adopt an rcu_read_lock(.) here as we also want to
+	 * block IPIs that come from THPs splitting.
+	 */
+
+	if (IS_ENABLED(CONFIG_HAVE_FAST_GUP) &&
+	    gup_fast_permitted(start, end)) {
+		local_irq_save(flags);
+		gup_pgd_range(start, end, gup_flags, pages, &nr_pinned);
+		local_irq_restore(flags);
+	}
+
+	return nr_pinned;
+}
+EXPORT_SYMBOL_GPL(__get_user_pages_fast);
+
 /**
  * get_user_pages_fast() - pin user pages in memory
  * @start:      starting user address
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

rapidio-fix-an-error-in-get_user_pages_fast-error-handling.patch
selftests-vm-gitignore-add-mremap_dontunmap.patch
selftests-vm-write_to_hugetlbfsc-fix-unused-variable-warning.patch
mm-gup-introduce-pin_user_pages_unlocked.patch
ivtv-convert-get_user_pages-pin_user_pages.patch
mm-gup-move-__get_user_pages_fast-down-a-few-lines-in-gupc.patch
mm-gup-refactor-and-de-duplicate-gup_fast-code.patch
mm-gup-introduce-pin_user_pages_fast_only.patch
drm-i915-convert-get_user_pages-pin_user_pages.patch
khugepaged-add-self-test-fix-3.patch
rapidio-convert-get_user_pages-pin_user_pages.patch
