From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-gup-introduce-pin_user_pages_locked-v2.patch removed from -mm tree
Date: Sun, 07 Jun 2020 21:18:46 -0700
Message-ID: <20200608041846.3M882YqDi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725945AbgFHESr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:18:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel@ffwll.ch, david@fromorbit.com, david@redhat.com, jack@suse.cz, jglisse@redhat.com, jhubbard@nvidia.com, jrdr.linux@gmail.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, vbabka@suse.cz


The patch titled
     Subject: mm/gup: introduce pin_user_pages_locked()
has been removed from the -mm tree.  Its filename was
     mm-gup-introduce-pin_user_pages_locked-v2.patch

This patch was dropped because it was folded into mm-gup-introduce-pin_user=
_pages_locked.patch

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
@@ -2035,6 +2035,12 @@ long get_user_pages_locked(unsigned long
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

mm-gup-update-pin_user_pagesrst-for-case-3-mmu-notifiers.patch
mm-gup-introduce-pin_user_pages_locked.patch
mm-gup-frame_vector-convert-get_user_pages-pin_user_pages.patch
mm-gup-documentation-fix-for-pin_user_pages-apis.patch
docs-mm-gup-pin_user_pagesrst-add-a-case-5.patch
docs-mm-gup-pin_user_pagesrst-add-a-case-5-v2.patch
vhost-convert-get_user_pages-pin_user_pages.patch
