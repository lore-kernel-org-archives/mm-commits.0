From: akpm@linux-foundation.org
Subject: + mm-gup-introduce-pin_user_pages_locked-v2.patch added
 to -mm tree
Date: Mon, 01 Jun 2020 17:24:37 -0700
Message-ID: <20200602002437.IoUbZk-lO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgFBAYj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Jun 2020 20:24:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel@ffwll.ch, david@fromorbit.com, david@redhat.com, jack@suse.cz, jglisse@redhat.com, jhubbard@nvidia.com, jrdr.linux@gmail.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, vbabka@suse.cz


The patch titled
     Subject: mm/gup: introduce pin_user_pages_locked()
has been added to the -mm tree.  Its filename is
     mm-gup-introduce-pin_user_pages_locked-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gup-introduce-pin_user_page=
s_locked-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-introduce-pin_user_page=
s_locked-v2.patch

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

add an assert-and-return to the corresponding get_user_pages_locked()
call, to keep out any externally set FOLL_PIN flag,

Link: http://lkml.kernel.org/r/20200531234131.770697-2-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/gup.c~mm-gup-introduce-pin_user_pages_locked-v2
+++ a/mm/gup.c
@@ -2020,6 +2020,12 @@ long get_user_pages_locked(unsigned long
 	 */
 	if (WARN_ON_ONCE(gup_flags & FOLL_LONGTERM))
 		return -EINVAL;
+	/*
+	 * FOLL_PIN must only be set internally by the pin_user_pages*() APIs,
+	 * never directly by the caller, so enforce that:
+	 */
+	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
+		return -EINVAL;
=20
 	return __get_user_pages_locked(current, current->mm, start, nr_pages,
 				       pages, NULL, locked,
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
mm-gup-introduce-pin_user_pages_locked-v2.patch
mm-gup-frame_vector-convert-get_user_pages-pin_user_pages.patch
mm-gup-documentation-fix-for-pin_user_pages-apis.patch
