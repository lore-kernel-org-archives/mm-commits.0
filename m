From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 035/118] goldish_pipe: convert to pin_user_pages()
 and put_user_page()
Date: Thu, 30 Jan 2020 22:12:58 -0800
Message-ID: <20200131061258.jzFOFzIrl%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGNA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:13:00 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.williamson@redhat.com, aneesh.kumar@linux.ibm.com, axboe@kernel.dk, bjorn.topel@intel.com, corbet@lwn.net, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, hch@lst.de, hverkuil-cisco@xs4all.nl, ira.weiny@intel.com, jack@suse.cz, jgg@mellanox.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, kirill@shutemov.name, leonro@mellanox.com, linux-mm@kvack.org, mchehab@kernel.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com, torvalds@linux-foundation.org

=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: goldish_pipe: convert to pin_user_pages() and put_user_page()

1. Call the new global pin_user_pages_fast(), from
   pin_goldfish_pages().

2. As required by pin_user_pages(), release these pages via
   put_user_page().  In this case, do so via put_user_pages_dirty_lock().

That has the side effect of calling set_page_dirty_lock(), instead of
set_page_dirty().  This is probably more accurate.

As Christoph Hellwig put it, "set_page_dirty() is only safe if we are
dealing with a file backed page where we have reference on the inode it
hangs off." [1]

Another side effect is that the release code is simplified because the
page[] loop is now in gup.c instead of here, so just delete the local
release_user_pages() entirely, and call put_user_pages_dirty_lock()
directly, instead.

[1] https://lore.kernel.org/r/20190723153640.GB720@lst.de

Link: http://lkml.kernel.org/r/20200107224558.2362728-13-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Leon Romanovsky <leonro@mellanox.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/goldfish/goldfish_pipe.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

--- a/drivers/platform/goldfish/goldfish_pipe.c~goldish_pipe-convert-to-pin=
_user_pages-and-put_user_page
+++ a/drivers/platform/goldfish/goldfish_pipe.c
@@ -274,7 +274,7 @@ static int goldfish_pin_pages(unsigned l
 		*iter_last_page_size =3D last_page_size;
 	}
=20
-	ret =3D get_user_pages_fast(first_page, requested_pages,
+	ret =3D pin_user_pages_fast(first_page, requested_pages,
 				  !is_write ? FOLL_WRITE : 0,
 				  pages);
 	if (ret <=3D 0)
@@ -285,18 +285,6 @@ static int goldfish_pin_pages(unsigned l
 	return ret;
 }
=20
-static void release_user_pages(struct page **pages, int pages_count,
-			       int is_write, s32 consumed_size)
-{
-	int i;
-
-	for (i =3D 0; i < pages_count; i++) {
-		if (!is_write && consumed_size > 0)
-			set_page_dirty(pages[i]);
-		put_page(pages[i]);
-	}
-}
