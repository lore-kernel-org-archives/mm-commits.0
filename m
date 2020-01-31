From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 032/118] IB/umem: use get_user_pages_fast() to pin
 DMA pages
Date: Thu, 30 Jan 2020 22:12:47 -0800
Message-ID: <20200131061247.yIaHhoydl%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726488AbgAaGMt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:12:49 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.williamson@redhat.com, aneesh.kumar@linux.ibm.com, axboe@kernel.dk, bjorn.topel@intel.com, corbet@lwn.net, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, hch@lst.de, hverkuil-cisco@xs4all.nl, ira.weiny@intel.com, jack@suse.cz, jgg@mellanox.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, kirill@shutemov.name, leonro@mellanox.com, linux-mm@kvack.org, mchehab@kernel.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com, torvalds@linux-foundation.org

=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: IB/umem: use get_user_pages_fast() to pin DMA pages

And get rid of the mmap_sem calls, as part of that.  Note that
get_user_pages_fast() will, if necessary, fall back to
__gup_longterm_unlocked(), which takes the mmap_sem as needed.

Link: http://lkml.kernel.org/r/20200107224558.2362728-10-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/core/umem.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/drivers/infiniband/core/umem.c~ib-umem-use-get_user_pages_fast-to-pin=
-dma-pages
+++ a/drivers/infiniband/core/umem.c
@@ -257,16 +257,13 @@ struct ib_umem *ib_umem_get(struct ib_de
 	sg =3D umem->sg_head.sgl;
=20
 	while (npages) {
-		down_read(&mm->mmap_sem);
-		ret =3D get_user_pages(cur_base,
-				     min_t(unsigned long, npages,
-					   PAGE_SIZE / sizeof (struct page *)),
-				     gup_flags | FOLL_LONGTERM,
-				     page_list, NULL);
-		if (ret < 0) {
-			up_read(&mm->mmap_sem);
+		ret =3D get_user_pages_fast(cur_base,
+					  min_t(unsigned long, npages,
+						PAGE_SIZE /
+						sizeof(struct page *)),
+					  gup_flags | FOLL_LONGTERM, page_list);
+		if (ret < 0)
 			goto umem_release;
-		}
=20
 		cur_base +=3D ret * PAGE_SIZE;
 		npages   -=3D ret;
@@ -274,8 +271,6 @@ struct ib_umem *ib_umem_get(struct ib_de
 		sg =3D ib_umem_add_sg_table(sg, page_list, ret,
 			dma_get_max_seg_size(device->dma_device),
 			&umem->sg_nents);
