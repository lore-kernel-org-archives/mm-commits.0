From: akpm@linux-foundation.org
Subject: + drm-via-set-foll_pin-via-pin_user_pages_fast.patch
 added to -mm tree
Date: Tue, 14 Jan 2020 15:30:23 -0800
Message-ID: <20200114233023.eSnBDt38F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728774AbgANXaZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Jan 2020 18:30:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.williamson@redhat.com, aneesh.kumar@linux.ibm.com, axboe@kernel.dk, bjorn.topel@intel.com, corbet@lwn.net, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, hch@lst.de, hverkuil-cisco@xs4all.nl, ira.weiny@intel.com, jack@suse.cz, jgg@mellanox.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, kirill@shutemov.name, leonro@mellanox.com, mchehab@kernel.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com


The patch titled
     Subject: drm/via: set FOLL_PIN via pin_user_pages_fast()
has been added to the -mm tree.  Its filename is
     drm-via-set-foll_pin-via-pin_user_pages_fast.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drm-via-set-foll_pin-via-pin_u=
ser_pages_fast.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drm-via-set-foll_pin-via-pin_u=
ser_pages_fast.patch

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
Subject: drm/via: set FOLL_PIN via pin_user_pages_fast()

Convert drm/via to use the new pin_user_pages_fast() call, which sets
FOLL_PIN.  Setting FOLL_PIN is now required for code that requires
tracking of pinned pages, and therefore for any code that calls
put_user_page().

In partial anticipation of this work, the drm/via driver was already
calling put_user_page() instead of put_page().  Therefore, in order to
convert from the get_user_pages()/put_page() model, to the
pin_user_pages()/put_user_page() model, the only change required is to
change get_user_pages() to pin_user_pages().

Link: http://lkml.kernel.org/r/20200107224558.2362728-16-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Leon Romanovsky <leonro@mellanox.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/via/via_dmablit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/via/via_dmablit.c~drm-via-set-foll_pin-via-pin_user_p=
ages_fast
+++ a/drivers/gpu/drm/via/via_dmablit.c
@@ -239,7 +239,7 @@ via_lock_all_dma_pages(drm_via_sg_info_t
 	vsg->pages =3D vzalloc(array_size(sizeof(struct page *), vsg->num_pages));
 	if (NULL =3D=3D vsg->pages)
 		return -ENOMEM;
-	ret =3D get_user_pages_fast((unsigned long)xfer->mem_addr,
+	ret =3D pin_user_pages_fast((unsigned long)xfer->mem_addr,
 			vsg->num_pages,
 			vsg->direction =3D=3D DMA_FROM_DEVICE ? FOLL_WRITE : 0,
 			vsg->pages);
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-factor-out-duplicate-code-from-four-routines.patch
mm-gup-move-try_get_compound_head-to-top-fix-minor-issues.patch
mm-devmap-refactor-1-based-refcounting-for-zone_device-pages.patch
goldish_pipe-rename-local-pin_user_pages-routine.patch
mm-fix-get_user_pages_remotes-handling-of-foll_longterm.patch
vfio-fix-foll_longterm-use-simplify-get_user_pages_remote-call.patch
mm-gup-allow-foll_force-for-get_user_pages_fast.patch
ib-umem-use-get_user_pages_fast-to-pin-dma-pages.patch
media-v4l2-core-set-pages-dirty-upon-releasing-dma-buffers.patch
mm-gup-introduce-pin_user_pages-and-foll_pin.patch
goldish_pipe-convert-to-pin_user_pages-and-put_user_page.patch
ib-corehwumem-set-foll_pin-via-pin_user_pages-fix-up-odp.patch
mm-process_vm_access-set-foll_pin-via-pin_user_pages_remote.patch
drm-via-set-foll_pin-via-pin_user_pages_fast.patch
fs-io_uring-set-foll_pin-via-pin_user_pages.patch
net-xdp-set-foll_pin-via-pin_user_pages.patch
media-v4l2-core-pin_user_pages-foll_pin-and-put_user_page-conversion.patch
vfio-mm-pin_user_pages-foll_pin-and-put_user_page-conversion.patch
powerpc-book3s64-convert-to-pin_user_pages-and-put_user_page.patch
mm-gup_benchmark-use-proper-foll_write-flags-instead-of-hard-coding-1.patch
mm-tree-wide-rename-put_user_page-to-unpin_user_page.patch
