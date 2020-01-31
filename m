From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 036/118] IB/{core,hw,umem}: set FOLL_PIN via
 pin_user_pages*(), fix up ODP
Date: Thu, 30 Jan 2020 22:13:02 -0800
Message-ID: <20200131061302.BxpCPixtw%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727941AbgAaGNE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:13:04 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.williamson@redhat.com, aneesh.kumar@linux.ibm.com, axboe@kernel.dk, bjorn.topel@intel.com, corbet@lwn.net, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, hch@lst.de, hverkuil-cisco@xs4all.nl, ira.weiny@intel.com, jack@suse.cz, jgg@mellanox.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, kirill@shutemov.name, leonro@mellanox.com, linux-mm@kvack.org, mchehab@kernel.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com, torvalds@linux-foundation.org

=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: IB/{core,hw,umem}: set FOLL_PIN via pin_user_pages*(), fix up ODP

Convert infiniband to use the new pin_user_pages*() calls.

Also, revert earlier changes to Infiniband ODP that had it using
put_user_page().  ODP is "Case 3" in
Documentation/core-api/pin_user_pages.rst, which is to say, normal
get_user_pages() and put_page() is the API to use there.

The new pin_user_pages*() calls replace corresponding get_user_pages*()
calls, and set the FOLL_PIN flag.  The FOLL_PIN flag requires that the
caller must return the pages via put_user_page*() calls, but infiniband
was already doing that as part of an earlier commit.

Link: http://lkml.kernel.org/r/20200107224558.2362728-14-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>
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

 drivers/infiniband/core/umem.c              |    2 +-
 drivers/infiniband/core/umem_odp.c          |   13 ++++++-------
 drivers/infiniband/hw/hfi1/user_pages.c     |    2 +-
 drivers/infiniband/hw/mthca/mthca_memfree.c |    2 +-
 drivers/infiniband/hw/qib/qib_user_pages.c  |    2 +-
 drivers/infiniband/hw/qib/qib_user_sdma.c   |    2 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c    |    2 +-
 drivers/infiniband/sw/siw/siw_mem.c         |    2 +-
 8 files changed, 13 insertions(+), 14 deletions(-)

--- a/drivers/infiniband/core/umem.c~ib-corehwumem-set-foll_pin-via-pin_use=
r_pages-fix-up-odp
+++ a/drivers/infiniband/core/umem.c
@@ -257,7 +257,7 @@ struct ib_umem *ib_umem_get(struct ib_de
 	sg =3D umem->sg_head.sgl;
=20
 	while (npages) {
-		ret =3D get_user_pages_fast(cur_base,
+		ret =3D pin_user_pages_fast(cur_base,
 					  min_t(unsigned long, npages,
 						PAGE_SIZE /
 						sizeof(struct page *)),
--- a/drivers/infiniband/core/umem_odp.c~ib-corehwumem-set-foll_pin-via-pin=
_user_pages-fix-up-odp
+++ a/drivers/infiniband/core/umem_odp.c
@@ -293,9 +293,8 @@ EXPORT_SYMBOL(ib_umem_odp_release);
  * The function returns -EFAULT if the DMA mapping operation fails. It ret=
urns
  * -EAGAIN if a concurrent invalidation prevents us from updating the page.
  *
- * The page is released via put_user_page even if the operation failed. For
- * on-demand pinning, the page is released whenever it isn't stored in the
- * umem.
+ * The page is released via put_page even if the operation failed. For on-=
demand
+ * pinning, the page is released whenever it isn't stored in the umem.
  */
 static int ib_umem_odp_map_dma_single_page(
 		struct ib_umem_odp *umem_odp,
@@ -348,7 +347,7 @@ static int ib_umem_odp_map_dma_single_pa
 	}
=20
 out:
-	put_user_page(page);
+	put_page(page);
 	return ret;
 }
=20
@@ -458,7 +457,7 @@ int ib_umem_odp_map_dma_pages(struct ib_
 					ret =3D -EFAULT;
 					break;
 				}
-				put_user_page(local_page_list[j]);
+				put_page(local_page_list[j]);
 				continue;
 			}
=20
@@ -485,8 +484,8 @@ int ib_umem_odp_map_dma_pages(struct ib_
 			 * ib_umem_odp_map_dma_single_page().
 			 */
 			if (npages - (j + 1) > 0)
-				put_user_pages(&local_page_list[j+1],
-					       npages - (j + 1));
+				release_pages(&local_page_list[j+1],
+					      npages - (j + 1));
 			break;
 		}
 	}
--- a/drivers/infiniband/hw/hfi1/user_pages.c~ib-corehwumem-set-foll_pin-vi=
a-pin_user_pages-fix-up-odp
+++ a/drivers/infiniband/hw/hfi1/user_pages.c
@@ -106,7 +106,7 @@ int hfi1_acquire_user_pages(struct mm_st
 	int ret;
 	unsigned int gup_flags =3D FOLL_LONGTERM | (writable ? FOLL_WRITE : 0);
=20
-	ret =3D get_user_pages_fast(vaddr, npages, gup_flags, pages);
+	ret =3D pin_user_pages_fast(vaddr, npages, gup_flags, pages);
 	if (ret < 0)
 		return ret;
=20
--- a/drivers/infiniband/hw/mthca/mthca_memfree.c~ib-corehwumem-set-foll_pi=
n-via-pin_user_pages-fix-up-odp
+++ a/drivers/infiniband/hw/mthca/mthca_memfree.c
@@ -472,7 +472,7 @@ int mthca_map_user_db(struct mthca_dev *
 		goto out;
 	}
=20
-	ret =3D get_user_pages_fast(uaddr & PAGE_MASK, 1,
+	ret =3D pin_user_pages_fast(uaddr & PAGE_MASK, 1,
 				  FOLL_WRITE | FOLL_LONGTERM, pages);
 	if (ret < 0)
 		goto out;
--- a/drivers/infiniband/hw/qib/qib_user_pages.c~ib-corehwumem-set-foll_pin=
-via-pin_user_pages-fix-up-odp
+++ a/drivers/infiniband/hw/qib/qib_user_pages.c
@@ -108,7 +108,7 @@ int qib_get_user_pages(unsigned long sta
=20
 	down_read(&current->mm->mmap_sem);
 	for (got =3D 0; got < num_pages; got +=3D ret) {
-		ret =3D get_user_pages(start_page + got * PAGE_SIZE,
+		ret =3D pin_user_pages(start_page + got * PAGE_SIZE,
 				     num_pages - got,
 				     FOLL_LONGTERM | FOLL_WRITE | FOLL_FORCE,
 				     p + got, NULL);
--- a/drivers/infiniband/hw/qib/qib_user_sdma.c~ib-corehwumem-set-foll_pin-=
via-pin_user_pages-fix-up-odp
+++ a/drivers/infiniband/hw/qib/qib_user_sdma.c
@@ -670,7 +670,7 @@ static int qib_user_sdma_pin_pages(const
 		else
 			j =3D npages;
=20
-		ret =3D get_user_pages_fast(addr, j, FOLL_LONGTERM, pages);
+		ret =3D pin_user_pages_fast(addr, j, FOLL_LONGTERM, pages);
 		if (ret !=3D j) {
 			i =3D 0;
 			j =3D ret;
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c~ib-corehwumem-set-foll_pin-v=
ia-pin_user_pages-fix-up-odp
+++ a/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -141,7 +141,7 @@ static int usnic_uiom_get_pages(unsigned
 	ret =3D 0;
=20
 	while (npages) {
-		ret =3D get_user_pages(cur_base,
+		ret =3D pin_user_pages(cur_base,
 				     min_t(unsigned long, npages,
 				     PAGE_SIZE / sizeof(struct page *)),
 				     gup_flags | FOLL_LONGTERM,
--- a/drivers/infiniband/sw/siw/siw_mem.c~ib-corehwumem-set-foll_pin-via-pi=
n_user_pages-fix-up-odp
+++ a/drivers/infiniband/sw/siw/siw_mem.c
@@ -426,7 +426,7 @@ struct siw_umem *siw_umem_get(u64 start,
 		while (nents) {
 			struct page **plist =3D &umem->page_chunk[i].plist[got];
=20
-			rv =3D get_user_pages(first_page_va, nents,
+			rv =3D pin_user_pages(first_page_va, nents,
 					    foll_flags | FOLL_LONGTERM,
 					    plist, NULL);
 			if (rv < 0)
_
