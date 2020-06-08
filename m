From: akpm@linux-foundation.org
Subject: [merged] docs-mm-gup-pin_user_pagesrst-add-a-case-5.patch
 removed from -mm tree
Date: Mon, 08 Jun 2020 15:32:20 -0700
Message-ID: <20200608223220.nQaSG9986%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbgFHWcW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 18:32:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, david@fromorbit.com, jack@suse.cz, jasowang@redhat.com, jglisse@redhat.com, jhubbard@nvidia.com, jrdr.linux@gmail.com, mm-commits@vger.kernel.org, mst@redhat.com, vbabka@suse.cz


The patch titled
     Subject: docs: mm/gup: pin_user_pages.rst: add a "case 5"
has been removed from the -mm tree.  Its filename was
     docs-mm-gup-pin_user_pagesrst-add-a-case-5.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: docs: mm/gup: pin_user_pages.rst: add a "case 5"

Patch series "vhost, docs: convert to pin_user_pages(), new "case 5""

It recently became clear to me that there are some get_user_pages*()
callers that don't fit neatly into any of the four cases that are so far
listed in pin_user_pages.rst.  vhost.c is one of those.

Add a Case 5 to the documentation, and refer to that when converting
vhost.c.

Thanks to Jan Kara for helping me (again) in understanding the interaction
between get_user_pages() and page writeback [1].

This is based on today's mmotm, which has a nearby patch to
pin_user_pages.rst that rewords cases 3 and 4.

Note that I have only compile-tested the vhost.c patch, although that does
also include cross-compiling for a few other arches.  Any run-time testing
would be greatly appreciated.

[1] https://lore.kernel.org/r/20200529070343.GL14550@quack2.suse.cz


This patch (of 2):

There are four cases listed in pin_user_pages.rst.  These are intended to
help developers figure out whether to use get_user_pages*(), or
pin_user_pages*().  However, the four cases do not cover all the
situations.  For example, drivers/vhost/vhost.c has a "pin, write to page,
set page dirty, unpin" case.

Add a fifth case, to help explain that there is a general pattern that
requires pin_user_pages*() API calls.

[jhubbard@nvidia.com: v2]
  Link: http://lkml.kernel.org/r/20200601052633.853874-2-jhubbard@nvidia.com
Link: http://lkml.kernel.org/r/20200529234309.484480-1-jhubbard@nvidia.com
Link: http://lkml.kernel.org/r/20200529234309.484480-2-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/pin_user_pages.rst |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/Documentation/core-api/pin_user_pages.rst~docs-mm-gup-pin_user_pagesr=
st-add-a-case-5
+++ a/Documentation/core-api/pin_user_pages.rst
@@ -171,6 +171,24 @@ If only struct page data (as opposed to
 is tracking) is affected, then normal GUP calls are sufficient, and neithe=
r flag
 needs to be set.
=20
+CASE 5: Pinning in order to write to the data within the page
+-------------------------------------------------------------
+Even though neither DMA nor Direct IO is involved, just a simple case of "=
pin,
+write to a page's data, unpin" can cause a problem. Case 5 may be consider=
ed a
+superset of Case 1, plus Case 2, plus anything that invokes that pattern. =
In
+other words, if the code is neither Case 1 nor Case 2, it may still require
+FOLL_PIN, for patterns like this:
+
+Correct (uses FOLL_PIN calls):
+    pin_user_pages()
+    write to the data within the pages
+    unpin_user_pages()
+
+INCORRECT (uses FOLL_GET calls):
+    get_user_pages()
+    write to the data within the pages
+    put_page()
+
 page_maybe_dma_pinned(): the whole point of pinning
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
=20
_

Patches currently in -mm which might be from jhubbard@nvidia.com are
