From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-introduce-pin_user_pages_locked.patch added to
 -mm tree
Date: Wed, 27 May 2020 16:17:54 -0700
Message-ID: <20200527231754.YnbMpevsR%akpm@linux-foundation.org>
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbgE0XR4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 May 2020 19:17:56 -0400
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel@ffwll.ch, david@fromorbit.com, jack@suse.cz, jglisse@redhat.com, jhubbard@nvidia.com, mm-commits@vger.kernel.org, vbabka@suse.cz


The patch titled
     Subject: mm/gup: introduce pin_user_pages_locked()
has been added to the -mm tree.  Its filename is
     mm-gup-introduce-pin_user_pages_locked.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gup-introduce-pin_user_page=
s_locked.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-introduce-pin_user_page=
s_locked.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: introduce pin_user_pages_locked()

Patch series "mm/gup: introduce pin_user_pages_locked(), use it in
frame_vector.c"

This adds yet one more pin_user_pages*() variant, and uses that to convert
mm/frame_vector.c.

With this, along with maybe 20 or 30 other recent patches in various
trees, we are close to having the relevant gup call sites converted--with
the notable exception of the bio/block layer.


This patch (of 2):

Introduce pin_user_pages_locked(), which is nearly identical to
get_user_pages_locked() except that it sets FOLL_PIN and rejects FOLL_GET.

Link: http://lkml.kernel.org/r/20200527223243.884385-1-jhubbard@nvidia.com
Link: http://lkml.kernel.org/r/20200527223243.884385-2-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 mm/gup.c           |   30 ++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

--- a/include/linux/mm.h~mm-gup-introduce-pin_user_pages_locked
+++ a/include/linux/mm.h
@@ -1707,6 +1707,8 @@ long pin_user_pages(unsigned long start,
 		    struct vm_area_struct **vmas);
 long get_user_pages_locked(unsigned long start, unsigned long nr_pages,
 		    unsigned int gup_flags, struct page **pages, int *locked);
+long pin_user_pages_locked(unsigned long start, unsigned long nr_pages,
+		    unsigned int gup_flags, struct page **pages, int *locked);
 long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
 		    struct page **pages, unsigned int gup_flags);
 long pin_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
--- a/mm/gup.c~mm-gup-introduce-pin_user_pages_locked
+++ a/mm/gup.c
@@ -3022,3 +3022,33 @@ long pin_user_pages_unlocked(unsigned lo
 	return get_user_pages_unlocked(start, nr_pages, pages, gup_flags);
 }
 EXPORT_SYMBOL(pin_user_pages_unlocked);
+
+/*
+ * pin_user_pages_locked() is the FOLL_PIN variant of get_user_pages_locke=
d().
+ * Behavior is the same, except that this one sets FOLL_PIN and rejects
+ * FOLL_GET.
+ */
+long pin_user_pages_locked(unsigned long start, unsigned long nr_pages,
+			   unsigned int gup_flags, struct page **pages,
+			   int *locked)
+{
+	/*
+	 * FIXME: Current FOLL_LONGTERM behavior is incompatible with
+	 * FAULT_FLAG_ALLOW_RETRY because of the FS DAX check requirement on
+	 * vmas.  As there are no users of this flag in this call we simply
+	 * disallow this option for now.
+	 */
+	if (WARN_ON_ONCE(gup_flags & FOLL_LONGTERM))
+		return -EINVAL;
+
+	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
+	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
+		return -EINVAL;
+
+	gup_flags |=3D FOLL_PIN;
+	return __get_user_pages_locked(current, current->mm, start, nr_pages,
+				       pages, NULL, locked,
+				       gup_flags | FOLL_TOUCH);
+}
+EXPORT_SYMBOL(pin_user_pages_locked);
+
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-introduce-pin_user_pages_unlocked.patch
ivtv-convert-get_user_pages-pin_user_pages.patch
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
mm-gup-frame_vector-convert-get_user_pages-pin_user_pages.patch
