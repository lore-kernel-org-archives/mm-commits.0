From: akpm@linux-foundation.org
Subject: +
 vfio-fix-foll_longterm-use-simplify-get_user_pages_remote-call.patch added
 to -mm tree
Date: Tue, 14 Jan 2020 15:29:56 -0800
Message-ID: <20200114232956.mGQ6HfmJF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728844AbgANX37 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Jan 2020 18:29:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.williamson@redhat.com, aneesh.kumar@linux.ibm.com, axboe@kernel.dk, bjorn.topel@intel.com, corbet@lwn.net, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, hch@lst.de, hverkuil-cisco@xs4all.nl, ira.weiny@intel.com, jack@suse.cz, jgg@mellanox.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, kirill@shutemov.name, leonro@mellanox.com, mchehab@kernel.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com


The patch titled
     Subject: vfio: fix FOLL_LONGTERM use, simplify get_user_pages_remote()=
 call
has been added to the -mm tree.  Its filename is
     vfio-fix-foll_longterm-use-simplify-get_user_pages_remote-call.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vfio-fix-foll_longterm-use-sim=
plify-get_user_pages_remote-call.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vfio-fix-foll_longterm-use-sim=
plify-get_user_pages_remote-call.patch

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
Subject: vfio: fix FOLL_LONGTERM use, simplify get_user_pages_remote() call

Update VFIO to take advantage of the recently loosened restriction on
FOLL_LONGTERM with get_user_pages_remote().  Also, now it is possible to
fix a bug: the VFIO caller is logically a FOLL_LONGTERM user, but it
wasn't setting FOLL_LONGTERM.

Also, remove an unnessary pair of calls that were releasing and
reacquiring the mmap_sem.  There is no need to avoid holding mmap_sem just
in order to call page_to_pfn().

Also, now that the the DAX check ("if a VMA is DAX, don't allow long term
pinning") is in the internals of get_user_pages_remote() and
__gup_longterm_locked(), there's no need for it at the VFIO call site.  So
remove it.

Link: http://lkml.kernel.org/r/20200107224558.2362728-8-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Tested-by: Alex Williamson <alex.williamson@redhat.com>
Acked-by: Alex Williamson <alex.williamson@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Leon Romanovsky <leonro@mellanox.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/vfio/vfio_iommu_type1.c |   30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

--- a/drivers/vfio/vfio_iommu_type1.c~vfio-fix-foll_longterm-use-simplify-g=
et_user_pages_remote-call
+++ a/drivers/vfio/vfio_iommu_type1.c
@@ -322,7 +322,6 @@ static int vaddr_get_pfn(struct mm_struc
 {
 	struct page *page[1];
 	struct vm_area_struct *vma;
-	struct vm_area_struct *vmas[1];
 	unsigned int flags =3D 0;
 	int ret;
=20
@@ -330,33 +329,14 @@ static int vaddr_get_pfn(struct mm_struc
 		flags |=3D FOLL_WRITE;
=20
 	down_read(&mm->mmap_sem);
-	if (mm =3D=3D current->mm) {
-		ret =3D get_user_pages(vaddr, 1, flags | FOLL_LONGTERM, page,
-				     vmas);
-	} else {
-		ret =3D get_user_pages_remote(NULL, mm, vaddr, 1, flags, page,
-					    vmas, NULL);
-		/*
-		 * The lifetime of a vaddr_get_pfn() page pin is
-		 * userspace-controlled. In the fs-dax case this could
-		 * lead to indefinite stalls in filesystem operations.
-		 * Disallow attempts to pin fs-dax pages via this
-		 * interface.
-		 */
-		if (ret > 0 && vma_is_fsdax(vmas[0])) {
-			ret =3D -EOPNOTSUPP;
-			put_page(page[0]);
-		}
-	}
-	up_read(&mm->mmap_sem);
-
+	ret =3D get_user_pages_remote(NULL, mm, vaddr, 1, flags | FOLL_LONGTERM,
+				    page, NULL, NULL);
 	if (ret =3D=3D 1) {
 		*pfn =3D page_to_pfn(page[0]);
-		return 0;
+		ret =3D 0;
+		goto done;
 	}
=20
-	down_read(&mm->mmap_sem);
-
 	vaddr =3D untagged_addr(vaddr);
=20
 	vma =3D find_vma_intersection(mm, vaddr, vaddr + 1);
@@ -366,7 +346,7 @@ static int vaddr_get_pfn(struct mm_struc
 		if (is_invalid_reserved_pfn(*pfn))
 			ret =3D 0;
 	}
-
+done:
 	up_read(&mm->mmap_sem);
 	return ret;
 }
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
