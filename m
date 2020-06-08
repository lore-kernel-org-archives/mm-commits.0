From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-gup-pin_user_pagesrst-add-a-case-5-v2.patch
 added to -mm tree
Date: Sun, 07 Jun 2020 17:50:45 -0700
Message-ID: <20200608005045.MNgvu9O5D%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728001AbgFHAur (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 7 Jun 2020 20:50:47 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, david@fromorbit.com, jack@suse.cz, jasowang@redhat.com, jglisse@redhat.com, jhubbard@nvidia.com, jrdr.linux@gmail.com, mm-commits@vger.kernel.org, mst@redhat.com, vbabka@suse.cz


The patch titled
     Subject: docs: mm/gup: pin_user_pages.rst: add a "case 5"
has been added to the -mm tree.  Its filename is
     docs-mm-gup-pin_user_pagesrst-add-a-case-5-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/docs-mm-gup-pin_user_pagesrst-=
add-a-case-5-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/docs-mm-gup-pin_user_pagesrst-=
add-a-case-5-v2.patch

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
mm-gup-introduce-pin_user_pages_locked-v2.patch
mm-gup-frame_vector-convert-get_user_pages-pin_user_pages.patch
mm-gup-documentation-fix-for-pin_user_pages-apis.patch
docs-mm-gup-pin_user_pagesrst-add-a-case-5.patch
docs-mm-gup-pin_user_pagesrst-add-a-case-5-v2.patch
vhost-convert-get_user_pages-pin_user_pages.patch
