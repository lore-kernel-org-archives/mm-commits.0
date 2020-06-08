From: akpm@linux-foundation.org
Subject: [folded-merged]
 docs-mm-gup-pin_user_pagesrst-add-a-case-5-v2.patch removed from -mm tree
Date: Sun, 07 Jun 2020 21:19:23 -0700
Message-ID: <20200608041923.Q8Tym9t23%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725945AbgFHETZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:19:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, david@fromorbit.com, jack@suse.cz, jasowang@redhat.com, jglisse@redhat.com, jhubbard@nvidia.com, jrdr.linux@gmail.com, mm-commits@vger.kernel.org, mst@redhat.com, vbabka@suse.cz


The patch titled
     Subject: docs: mm/gup: pin_user_pages.rst: add a "case 5"
has been removed from the -mm tree.  Its filename was
     docs-mm-gup-pin_user_pagesrst-add-a-case-5-v2.patch

This patch was dropped because it was folded into docs-mm-gup-pin_user_page=
srst-add-a-case-5.patch

------------------------------------------------------
=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: docs: mm/gup: pin_user_pages.rst: add a "case 5"

There are four cases listed in pin_user_pages.rst. These are
intended to help developers figure out whether to use
get_user_pages*(), or pin_user_pages*(). However, the four cases
do not cover all the situations. For example, drivers/vhost/vhost.c
has a "pin, write to page, set page dirty, unpin" case.

Add a fifth case, to help explain that there is a general pattern
that requires pin_user_pages*() API calls.

Link: http://lkml.kernel.org/r/20200601052633.853874-2-jhubbard@nvidia.com
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

 Documentation/core-api/pin_user_pages.rst |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/Documentation/core-api/pin_user_pages.rst~docs-mm-gup-pin_user_pagesr=
st-add-a-case-5-v2
+++ a/Documentation/core-api/pin_user_pages.rst
@@ -174,21 +174,19 @@ needs to be set.
 CASE 5: Pinning in order to write to the data within the page
 -------------------------------------------------------------
 Even though neither DMA nor Direct IO is involved, just a simple case of "=
pin,
-access page's data, unpin" can cause a problem. Case 5 may be considered a
+write to a page's data, unpin" can cause a problem. Case 5 may be consider=
ed a
 superset of Case 1, plus Case 2, plus anything that invokes that pattern. =
In
 other words, if the code is neither Case 1 nor Case 2, it may still require
 FOLL_PIN, for patterns like this:
=20
 Correct (uses FOLL_PIN calls):
     pin_user_pages()
-    access the data within the pages
-    set_page_dirty_lock()
+    write to the data within the pages
     unpin_user_pages()
=20
 INCORRECT (uses FOLL_GET calls):
     get_user_pages()
-    access the data within the pages
-    set_page_dirty_lock()
+    write to the data within the pages
     put_page()
=20
 page_maybe_dma_pinned(): the whole point of pinning
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-update-pin_user_pagesrst-for-case-3-mmu-notifiers.patch
mm-gup-introduce-pin_user_pages_locked.patch
mm-gup-frame_vector-convert-get_user_pages-pin_user_pages.patch
mm-gup-documentation-fix-for-pin_user_pages-apis.patch
docs-mm-gup-pin_user_pagesrst-add-a-case-5.patch
vhost-convert-get_user_pages-pin_user_pages.patch
