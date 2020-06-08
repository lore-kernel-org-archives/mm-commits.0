From: akpm@linux-foundation.org
Subject: [merged]
 mm-gup-frame_vector-convert-get_user_pages-pin_user_pages.patch removed
 from -mm tree
Date: Mon, 08 Jun 2020 15:32:15 -0700
Message-ID: <20200608223215.89LrcjS8M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbgFHWcR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 18:32:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel@ffwll.ch, david@fromorbit.com, david@redhat.com, jack@suse.cz, jglisse@redhat.com, jhubbard@nvidia.com, jrdr.linux@gmail.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, vbabka@suse.cz


The patch titled
     Subject: mm/gup: frame_vector: convert get_user_pages() --> pin_user_p=
ages()
has been removed from the -mm tree.  Its filename was
     mm-gup-frame_vector-convert-get_user_pages-pin_user_pages.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

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
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
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
