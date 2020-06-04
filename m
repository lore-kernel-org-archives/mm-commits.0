From: akpm@linux-foundation.org
Subject: [merged] mm-gup-introduce-pin_user_pages_fast_only.patch
 removed from -mm tree
Date: Thu, 04 Jun 2020 10:16:04 -0700
Message-ID: <20200604171604.XBwPFvQWN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729866AbgFDRQG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:16:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, chris@chris-wilson.co.uk, daniel@ffwll.ch, jani.nikula@linux.intel.com, jhubbard@nvidia.com, joonas.lahtinen@linux.intel.com, jrdr.linux@gmail.com, matthew.auld@intel.com, mm-commits@vger.kernel.org, rodrigo.vivi@intel.com, tvrtko.ursulin@intel.com, willy@infradead.org


The patch titled
     Subject: mm/gup: introduce pin_user_pages_fast_only()
has been removed from the -mm tree.  Its filename was
     mm-gup-introduce-pin_user_pages_fast_only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: introduce pin_user_pages_fast_only()

This is the FOLL_PIN equivalent of __get_user_pages_fast(), except with a
more descriptive name, and gup_flags instead of a boolean "write" in the
argument list.

Link: http://lkml.kernel.org/r/20200519002124.2025955-4-jhubbard@nvidia.com
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

 include/linux/mm.h |    2 ++
 mm/gup.c           |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

--- a/include/linux/mm.h~mm-gup-introduce-pin_user_pages_fast_only
+++ a/include/linux/mm.h
@@ -1827,6 +1827,8 @@ extern int mprotect_fixup(struct vm_area
  */
 int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			  struct page **pages);
+int pin_user_pages_fast_only(unsigned long start, int nr_pages,
+			     unsigned int gup_flags, struct page **pages);
 /*
  * per-process(per-mm_struct) statistics.
  */
--- a/mm/gup.c~mm-gup-introduce-pin_user_pages_fast_only
+++ a/mm/gup.c
@@ -2913,6 +2913,42 @@ int pin_user_pages_fast(unsigned long st
 }
 EXPORT_SYMBOL_GPL(pin_user_pages_fast);
 
+/*
+ * This is the FOLL_PIN equivalent of __get_user_pages_fast(). Behavior is the
+ * same, except that this one sets FOLL_PIN instead of FOLL_GET.
+ *
+ * The API rules are the same, too: no negative values may be returned.
+ */
+int pin_user_pages_fast_only(unsigned long start, int nr_pages,
+			     unsigned int gup_flags, struct page **pages)
+{
+	int nr_pinned;
+
+	/*
+	 * FOLL_GET and FOLL_PIN are mutually exclusive. Note that the API
+	 * rules require returning 0, rather than -errno:
+	 */
+	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
+		return 0;
+	/*
+	 * FOLL_FAST_ONLY is required in order to match the API description of
+	 * this routine: no fall back to regular ("slow") GUP.
+	 */
+	gup_flags |= (FOLL_PIN | FOLL_FAST_ONLY);
+	nr_pinned = internal_get_user_pages_fast(start, nr_pages, gup_flags,
+						 pages);
+	/*
+	 * This routine is not allowed to return negative values. However,
+	 * internal_get_user_pages_fast() *can* return -errno. Therefore,
+	 * correct for that here:
+	 */
+	if (nr_pinned < 0)
+		nr_pinned = 0;
+
+	return nr_pinned;
+}
+EXPORT_SYMBOL_GPL(pin_user_pages_fast_only);
+
 /**
  * pin_user_pages_remote() - pin pages of a remote process (task != current)
  *
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
