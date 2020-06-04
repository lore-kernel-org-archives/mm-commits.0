From: akpm@linux-foundation.org
Subject: [merged]
 mm-gup-move-__get_user_pages_fast-down-a-few-lines-in-gupc.patch removed
 from -mm tree
Date: Thu, 04 Jun 2020 10:15:58 -0700
Message-ID: <20200604171558.oiq1K_B05%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729866AbgFDRQB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:16:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, chris@chris-wilson.co.uk, daniel@ffwll.ch, jani.nikula@linux.intel.com, jhubbard@nvidia.com, joonas.lahtinen@linux.intel.com, jrdr.linux@gmail.com, matthew.auld@intel.com, mm-commits@vger.kernel.org, rodrigo.vivi@intel.com, tvrtko.ursulin@intel.com, willy@infradead.org


The patch titled
     Subject: mm/gup: move __get_user_pages_fast() down a few lines in gup.c
has been removed from the -mm tree.  Its filename was
     mm-gup-move-__get_user_pages_fast-down-a-few-lines-in-gupc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: move __get_user_pages_fast() down a few lines in gup.c

Patch series "mm/gup, drm/i915: refactor gup_fast, convert to pin_user_pages()", v2.

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

Link: http://lkml.kernel.org/r/20200522051931.54191-1-jhubbard@nvidia.com
Link: http://lkml.kernel.org/r/20200519002124.2025955-1-jhubbard@nvidia.com
Link: http://lkml.kernel.org/r/20200519002124.2025955-2-jhubbard@nvidia.com
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

 mm/gup.c |  132 ++++++++++++++++++++++++++---------------------------
 1 file changed, 66 insertions(+), 66 deletions(-)

--- a/mm/gup.c~mm-gup-move-__get_user_pages_fast-down-a-few-lines-in-gupc
+++ a/mm/gup.c
@@ -2703,72 +2703,6 @@ static bool gup_fast_permitted(unsigned
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
- *
- * Careful, careful! COW breaking can go either way, so a non-write
- * access can get ambiguous page results. If you call this function without
- * 'write' set, you'd better be sure that you're ok with that ambiguity.
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
-	 *
-	 * NOTE! We allow read-only gup_fast() here, but you'd better be
-	 * careful about possible COW pages. You'll get _a_ COW page, but
-	 * not necessarily the one you intended to get depending on what
-	 * COW event happens after this. COW may break the page copy in a
-	 * random direction.
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
@@ -2848,6 +2782,72 @@ static int internal_get_user_pages_fast(
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
+ *
+ * Careful, careful! COW breaking can go either way, so a non-write
+ * access can get ambiguous page results. If you call this function without
+ * 'write' set, you'd better be sure that you're ok with that ambiguity.
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
+	 *
+	 * NOTE! We allow read-only gup_fast() here, but you'd better be
+	 * careful about possible COW pages. You'll get _a_ COW page, but
+	 * not necessarily the one you intended to get depending on what
+	 * COW event happens after this. COW may break the page copy in a
+	 * random direction.
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

rapidio-convert-get_user_pages-pin_user_pages.patch
mm-gup-update-pin_user_pagesrst-for-case-3-mmu-notifiers.patch
mm-gup-introduce-pin_user_pages_locked.patch
mm-gup-introduce-pin_user_pages_locked-v2.patch
mm-gup-frame_vector-convert-get_user_pages-pin_user_pages.patch
mm-gup-documentation-fix-for-pin_user_pages-apis.patch
docs-mm-gup-pin_user_pagesrst-add-a-case-5.patch
vhost-convert-get_user_pages-pin_user_pages.patch
