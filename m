From: akpm@linux-foundation.org
Subject: + vhost-convert-get_user_pages-pin_user_pages.patch added
 to -mm tree
Date: Mon, 01 Jun 2020 18:13:03 -0700
Message-ID: <20200602011303.zFNmgYED6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgFBBNG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Jun 2020 21:13:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, david@fromorbit.com, jack@suse.cz, jasowang@redhat.com, jglisse@redhat.com, jhubbard@nvidia.com, jrdr.linux@gmail.com, mm-commits@vger.kernel.org, mst@redhat.com, vbabka@suse.cz


The patch titled
     Subject: vhost: convert get_user_pages() --> pin_user_pages()
has been added to the -mm tree.  Its filename is
     vhost-convert-get_user_pages-pin_user_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vhost-convert-get_user_pages-p=
in_user_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vhost-convert-get_user_pages-p=
in_user_pages.patch

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
Subject: vhost: convert get_user_pages() --> pin_user_pages()

This code was using get_user_pages*(), in approximately a "Case 5"
scenario (accessing the data within a page), using the categorization from
[1].  That means that it's time to convert the get_user_pages*() +
put_page() calls to pin_user_pages*() + unpin_user_pages() calls.

There is some helpful background in [2]: basically, this is a small part
of fixing a long-standing disconnect between pinning pages, and file
systems' use of those pages.

[1] Documentation/core-api/pin_user_pages.rst

[2] "Explicit pinning of user-space pages":
    https://lwn.net/Articles/807108/

Link: http://lkml.kernel.org/r/20200529234309.484480-3-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/vhost/vhost.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/vhost/vhost.c~vhost-convert-get_user_pages-pin_user_pages
+++ a/drivers/vhost/vhost.c
@@ -1776,15 +1776,14 @@ static int set_bit_to_user(int nr, void
 	int bit =3D nr + (log % PAGE_SIZE) * 8;
 	int r;
=20
-	r =3D get_user_pages_fast(log, 1, FOLL_WRITE, &page);
+	r =3D pin_user_pages_fast(log, 1, FOLL_WRITE, &page);
 	if (r < 0)
 		return r;
 	BUG_ON(r !=3D 1);
 	base =3D kmap_atomic(page);
 	set_bit(bit, base);
 	kunmap_atomic(base);
-	set_page_dirty_lock(page);
-	put_page(page);
+	unpin_user_pages_dirty_lock(&page, 1, true);
 	return 0;
 }
=20
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
docs-mm-gup-pin_user_pagesrst-add-a-case-5.patch
vhost-convert-get_user_pages-pin_user_pages.patch
