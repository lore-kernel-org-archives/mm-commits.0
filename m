From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 042/118] vfio, mm: pin_user_pages (FOLL_PIN) and
 put_user_page() conversion
Date: Thu, 30 Jan 2020 22:13:24 -0800
Message-ID: <20200131061324.AO72PHl35%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:32850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGN0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:13:26 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.williamson@redhat.com, aneesh.kumar@linux.ibm.com, axboe@kernel.dk, bjorn.topel@intel.com, corbet@lwn.net, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, hch@lst.de, hverkuil-cisco@xs4all.nl, ira.weiny@intel.com, jack@suse.cz, jgg@mellanox.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, kirill@shutemov.name, leonro@mellanox.com, linux-mm@kvack.org, mchehab@kernel.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com, torvalds@linux-foundation.org

=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: vfio, mm: pin_user_pages (FOLL_PIN) and put_user_page() conversion

1. Change vfio from get_user_pages_remote(), to
   pin_user_pages_remote().

2. Because all FOLL_PIN-acquired pages must be released via
   put_user_page(), also convert the put_page() call over to
   put_user_pages_dirty_lock().

Note that this effectively changes the code's behavior in
vfio_iommu_type1.c: put_pfn(): it now ultimately calls
set_page_dirty_lock(), instead of set_page_dirty().  This is probably more
accurate.

As Christoph Hellwig put it, "set_page_dirty() is only safe if we are
dealing with a file backed page where we have reference on the inode it
hangs off." [1]

[1] https://lore.kernel.org/r/20190723153640.GB720@lst.de

Link: http://lkml.kernel.org/r/20200107224558.2362728-20-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Tested-by: Alex Williamson <alex.williamson@redhat.com>
Acked-by: Alex Williamson <alex.williamson@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>
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

 drivers/vfio/vfio_iommu_type1.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/vfio/vfio_iommu_type1.c~vfio-mm-pin_user_pages-foll_pin-and-p=
ut_user_page-conversion
+++ a/drivers/vfio/vfio_iommu_type1.c
@@ -309,9 +309,8 @@ static int put_pfn(unsigned long pfn, in
 {
 	if (!is_invalid_reserved_pfn(pfn)) {
 		struct page *page =3D pfn_to_page(pfn);
-		if (prot & IOMMU_WRITE)
-			SetPageDirty(page);
-		put_page(page);
+
+		put_user_pages_dirty_lock(&page, 1, prot & IOMMU_WRITE);
 		return 1;
 	}
 	return 0;
@@ -329,7 +328,7 @@ static int vaddr_get_pfn(struct mm_struc
 		flags |=3D FOLL_WRITE;
=20
 	down_read(&mm->mmap_sem);
-	ret =3D get_user_pages_remote(NULL, mm, vaddr, 1, flags | FOLL_LONGTERM,
+	ret =3D pin_user_pages_remote(NULL, mm, vaddr, 1, flags | FOLL_LONGTERM,
 				    page, NULL, NULL);
 	if (ret =3D=3D 1) {
 		*pfn =3D page_to_pfn(page[0]);
_
