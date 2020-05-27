From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-gup-frame_vector-convert-get_user_pages-pin_user_pages.patch added to
 -mm tree
Date: Wed, 27 May 2020 16:17:57 -0700
Message-ID: <20200527231757.FmYwJ0fBB%akpm@linux-foundation.org>
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbgE0XR7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 May 2020 19:17:59 -0400
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel@ffwll.ch, david@fromorbit.com, jack@suse.cz, jglisse@redhat.com, jhubbard@nvidia.com, mm-commits@vger.kernel.org, vbabka@suse.cz


The patch titled
     Subject: mm/gup: frame_vector: convert get_user_pages() --> pin_user_p=
ages()
has been added to the -mm tree.  Its filename is
     mm-gup-frame_vector-convert-get_user_pages-pin_user_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gup-frame_vector-convert-ge=
t_user_pages-pin_user_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-frame_vector-convert-ge=
t_user_pages-pin_user_pages.patch

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
Subject: mm/gup: frame_vector: convert get_user_pages() --> pin_user_pages()

This code was using get_user_pages*(), and all of the callers so far were
in a "Case 2" scenario (DMA/RDMA), using the categorization from [1].=20
That means that it's time to convert the get_user_pages*() + put_page()
calls to pin_user_pages*() + unpin_user_pages() calls.

There is some helpful background in [2]: basically, this is a small part
of fixing a long-standing disconnect between pinning pages, and file
systems' use of those pages.

[1] Documentation/core-api/pin_user_pages.rst

[2] "Explicit pinning of user-space pages":
    https://lwn.net/Articles/807108/

Link: http://lkml.kernel.org/r/20200527223243.884385-3-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/frame_vector.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/frame_vector.c~mm-gup-frame_vector-convert-get_user_pages-pin_user=
_pages
+++ a/mm/frame_vector.c
@@ -72,7 +72,7 @@ int get_vaddr_frames(unsigned long start
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP))) {
 		vec->got_ref =3D true;
 		vec->is_pfns =3D false;
-		ret =3D get_user_pages_locked(start, nr_frames,
+		ret =3D pin_user_pages_locked(start, nr_frames,
 			gup_flags, (struct page **)(vec->ptrs), &locked);
 		goto out;
 	}
@@ -122,7 +122,6 @@ EXPORT_SYMBOL(get_vaddr_frames);
  */
 void put_vaddr_frames(struct frame_vector *vec)
 {
-	int i;
 	struct page **pages;
=20
 	if (!vec->got_ref)
@@ -135,8 +134,8 @@ void put_vaddr_frames(struct frame_vecto
 	 */
 	if (WARN_ON(IS_ERR(pages)))
 		goto out;
-	for (i =3D 0; i < vec->nr_frames; i++)
-		put_page(pages[i]);
+
+	unpin_user_pages(pages, vec->nr_frames);
 	vec->got_ref =3D false;
 out:
 	vec->nr_frames =3D 0;
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
