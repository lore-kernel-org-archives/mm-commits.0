From: akpm@linux-foundation.org
Subject: [merged] mm-gup-introduce-pin_user_pages_unlocked.patch
 removed from -mm tree
Date: Tue, 02 Jun 2020 14:39:56 -0700
Message-ID: <20200602213956.uUm0QNC1G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgFBVj5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:39:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, awalls@md.metrocast.net, jhubbard@nvidia.com, mchehab@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: introduce pin_user_pages_unlocked
has been removed from the -mm tree.  Its filename was
     mm-gup-introduce-pin_user_pages_unlocked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: introduce pin_user_pages_unlocked

Introduce pin_user_pages_unlocked(), which is nearly identical to the
get_user_pages_unlocked() that it wraps, except that it sets FOLL_PIN and
rejects FOLL_GET.

Link: http://lkml.kernel.org/r/20200518012157.1178336-2-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 mm/gup.c           |   17 +++++++++++++++++
 2 files changed, 19 insertions(+)

--- a/include/linux/mm.h~mm-gup-introduce-pin_user_pages_unlocked
+++ a/include/linux/mm.h
@@ -1709,6 +1709,8 @@ long get_user_pages_locked(unsigned long
 		    unsigned int gup_flags, struct page **pages, int *locked);
 long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
 		    struct page **pages, unsigned int gup_flags);
+long pin_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
+		    struct page **pages, unsigned int gup_flags);
 
 int get_user_pages_fast(unsigned long start, int nr_pages,
 			unsigned int gup_flags, struct page **pages);
--- a/mm/gup.c~mm-gup-introduce-pin_user_pages_unlocked
+++ a/mm/gup.c
@@ -2960,3 +2960,20 @@ long pin_user_pages(unsigned long start,
 				     pages, vmas, gup_flags);
 }
 EXPORT_SYMBOL(pin_user_pages);
+
+/*
+ * pin_user_pages_unlocked() is the FOLL_PIN variant of
+ * get_user_pages_unlocked(). Behavior is the same, except that this one sets
+ * FOLL_PIN and rejects FOLL_GET.
+ */
+long pin_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
+			     struct page **pages, unsigned int gup_flags)
+{
+	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
+	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
+		return -EINVAL;
+
+	gup_flags |= FOLL_PIN;
+	return get_user_pages_unlocked(start, nr_pages, pages, gup_flags);
+}
+EXPORT_SYMBOL(pin_user_pages_unlocked);
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-move-__get_user_pages_fast-down-a-few-lines-in-gupc.patch
mm-gup-refactor-and-de-duplicate-gup_fast-code.patch
mm-gup-refactor-and-de-duplicate-gup_fast-code-fix.patch
mm-gup-introduce-pin_user_pages_fast_only.patch
drm-i915-convert-get_user_pages-pin_user_pages.patch
mm-gup-might_lock_readmmap_sem-in-get_user_pages_fast.patch
khugepaged-add-self-test-fix-3.patch
rapidio-convert-get_user_pages-pin_user_pages.patch
mm-gup-update-pin_user_pagesrst-for-case-3-mmu-notifiers.patch
mm-gup-introduce-pin_user_pages_locked.patch
mm-gup-introduce-pin_user_pages_locked-v2.patch
mm-gup-frame_vector-convert-get_user_pages-pin_user_pages.patch
mm-gup-documentation-fix-for-pin_user_pages-apis.patch
docs-mm-gup-pin_user_pagesrst-add-a-case-5.patch
vhost-convert-get_user_pages-pin_user_pages.patch
