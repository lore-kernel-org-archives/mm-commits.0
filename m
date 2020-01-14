From: akpm@linux-foundation.org
Subject: +
 mm-tree-wide-rename-put_user_page-to-unpin_user_page.patch added to -mm
 tree
Date: Tue, 14 Jan 2020 15:30:45 -0800
Message-ID: <20200114233045.Qxoq86AuK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728757AbgANXas (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Jan 2020 18:30:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.williamson@redhat.com, aneesh.kumar@linux.ibm.com, axboe@kernel.dk, bjorn.topel@intel.com, corbet@lwn.net, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, hch@lst.de, hverkuil-cisco@xs4all.nl, ira.weiny@intel.com, jack@suse.cz, jgg@mellanox.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, kirill@shutemov.name, leonro@mellanox.com, mchehab@kernel.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com


The patch titled
     Subject: mm, tree-wide: rename put_user_page*() to unpin_user_page*()
has been added to the -mm tree.  Its filename is
     mm-tree-wide-rename-put_user_page-to-unpin_user_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-tree-wide-rename-put_user_p=
age-to-unpin_user_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-tree-wide-rename-put_user_p=
age-to-unpin_user_page.patch

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
Subject: mm, tree-wide: rename put_user_page*() to unpin_user_page*()

In order to provide a clearer, more symmetric API for pinning and
unpinning DMA pages.  This way, pin_user_pages*() calls match up with
unpin_user_pages*() calls, and the API is a lot closer to being
self-explanatory.

Link: http://lkml.kernel.org/r/20200107224558.2362728-23-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: Ira Weiny <ira.weiny@intel.com>
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

 Documentation/core-api/pin_user_pages.rst   |    2 -
 arch/powerpc/mm/book3s64/iommu_api.c        |    4 +-
 drivers/gpu/drm/via/via_dmablit.c           |    4 +-
 drivers/infiniband/core/umem.c              |    2 -
 drivers/infiniband/hw/hfi1/user_pages.c     |    2 -
 drivers/infiniband/hw/mthca/mthca_memfree.c |    6 +--
 drivers/infiniband/hw/qib/qib_user_pages.c  |    2 -
 drivers/infiniband/hw/qib/qib_user_sdma.c   |    6 +--
 drivers/infiniband/hw/usnic/usnic_uiom.c    |    2 -
 drivers/infiniband/sw/siw/siw_mem.c         |    2 -
 drivers/media/v4l2-core/videobuf-dma-sg.c   |    4 +-
 drivers/platform/goldfish/goldfish_pipe.c   |    4 +-
 drivers/vfio/vfio_iommu_type1.c             |    2 -
 fs/io_uring.c                               |    4 +-
 include/linux/mm.h                          |   26 +++++++-------
 mm/gup.c                                    |   32 +++++++++---------
 mm/process_vm_access.c                      |    4 +-
 net/xdp/xdp_umem.c                          |    2 -
 18 files changed, 55 insertions(+), 55 deletions(-)

--- a/arch/powerpc/mm/book3s64/iommu_api.c~mm-tree-wide-rename-put_user_pag=
e-to-unpin_user_page
+++ a/arch/powerpc/mm/book3s64/iommu_api.c
@@ -168,7 +168,7 @@ good_exit:
=20
 free_exit:
 	/* free the references taken */
-	put_user_pages(mem->hpages, pinned);
+	unpin_user_pages(mem->hpages, pinned);
=20
 	vfree(mem->hpas);
 	kfree(mem);
@@ -214,7 +214,7 @@ static void mm_iommu_unpin(struct mm_iom
 		if (mem->hpas[i] & MM_IOMMU_TABLE_GROUP_PAGE_DIRTY)
 			SetPageDirty(page);
=20
-		put_user_page(page);
+		unpin_user_page(page);
=20
 		mem->hpas[i] =3D 0;
 	}
--- a/Documentation/core-api/pin_user_pages.rst~mm-tree-wide-rename-put_use=
r_page-to-unpin_user_page
+++ a/Documentation/core-api/pin_user_pages.rst
@@ -219,7 +219,7 @@ since the system was booted, via two new
     /proc/vmstat/nr_foll_pin_requested
=20
 Those are both going to show zero, unless CONFIG_DEBUG_VM is set. This is
-because there is a noticeable performance drop in put_user_page(), when th=
ey
+because there is a noticeable performance drop in unpin_user_page(), when =
they
 are activated.
=20
 References
--- a/drivers/gpu/drm/via/via_dmablit.c~mm-tree-wide-rename-put_user_page-t=
o-unpin_user_page
+++ a/drivers/gpu/drm/via/via_dmablit.c
@@ -188,8 +188,8 @@ via_free_sg_info(struct pci_dev *pdev, d
 		kfree(vsg->desc_pages);
 		/* fall through */
 	case dr_via_pages_locked:
-		put_user_pages_dirty_lock(vsg->pages, vsg->num_pages,
-					  (vsg->direction =3D=3D DMA_FROM_DEVICE));
+		unpin_user_pages_dirty_lock(vsg->pages, vsg->num_pages,
+					   (vsg->direction =3D=3D DMA_FROM_DEVICE));
 		/* fall through */
 	case dr_via_pages_alloc:
 		vfree(vsg->pages);
--- a/drivers/infiniband/core/umem.c~mm-tree-wide-rename-put_user_page-to-u=
npin_user_page
+++ a/drivers/infiniband/core/umem.c
@@ -54,7 +54,7 @@ static void __ib_umem_release(struct ib_
=20
 	for_each_sg_page(umem->sg_head.sgl, &sg_iter, umem->sg_nents, 0) {
 		page =3D sg_page_iter_page(&sg_iter);
-		put_user_pages_dirty_lock(&page, 1, umem->writable && dirty);
+		unpin_user_pages_dirty_lock(&page, 1, umem->writable && dirty);
 	}
=20
 	sg_free_table(&umem->sg_head);
--- a/drivers/infiniband/hw/hfi1/user_pages.c~mm-tree-wide-rename-put_user_=
page-to-unpin_user_page
+++ a/drivers/infiniband/hw/hfi1/user_pages.c
@@ -118,7 +118,7 @@ int hfi1_acquire_user_pages(struct mm_st
 void hfi1_release_user_pages(struct mm_struct *mm, struct page **p,
 			     size_t npages, bool dirty)
 {
-	put_user_pages_dirty_lock(p, npages, dirty);
+	unpin_user_pages_dirty_lock(p, npages, dirty);
=20
 	if (mm) { /* during close after signal, mm can be NULL */
 		atomic64_sub(npages, &mm->pinned_vm);
--- a/drivers/infiniband/hw/mthca/mthca_memfree.c~mm-tree-wide-rename-put_u=
ser_page-to-unpin_user_page
+++ a/drivers/infiniband/hw/mthca/mthca_memfree.c
@@ -482,7 +482,7 @@ int mthca_map_user_db(struct mthca_dev *
=20
 	ret =3D pci_map_sg(dev->pdev, &db_tab->page[i].mem, 1, PCI_DMA_TODEVICE);
 	if (ret < 0) {
-		put_user_page(pages[0]);
+		unpin_user_page(pages[0]);
 		goto out;
 	}
=20
@@ -490,7 +490,7 @@ int mthca_map_user_db(struct mthca_dev *
 				 mthca_uarc_virt(dev, uar, i));
 	if (ret) {
 		pci_unmap_sg(dev->pdev, &db_tab->page[i].mem, 1, PCI_DMA_TODEVICE);
-		put_user_page(sg_page(&db_tab->page[i].mem));
+		unpin_user_page(sg_page(&db_tab->page[i].mem));
 		goto out;
 	}
=20
@@ -556,7 +556,7 @@ void mthca_cleanup_user_db_tab(struct mt
 		if (db_tab->page[i].uvirt) {
 			mthca_UNMAP_ICM(dev, mthca_uarc_virt(dev, uar, i), 1);
 			pci_unmap_sg(dev->pdev, &db_tab->page[i].mem, 1, PCI_DMA_TODEVICE);
-			put_user_page(sg_page(&db_tab->page[i].mem));
+			unpin_user_page(sg_page(&db_tab->page[i].mem));
 		}
 	}
=20
--- a/drivers/infiniband/hw/qib/qib_user_pages.c~mm-tree-wide-rename-put_us=
er_page-to-unpin_user_page
+++ a/drivers/infiniband/hw/qib/qib_user_pages.c
@@ -40,7 +40,7 @@
 static void __qib_release_user_pages(struct page **p, size_t num_pages,
 				     int dirty)
 {
-	put_user_pages_dirty_lock(p, num_pages, dirty);
+	unpin_user_pages_dirty_lock(p, num_pages, dirty);
 }
=20
 /**
--- a/drivers/infiniband/hw/qib/qib_user_sdma.c~mm-tree-wide-rename-put_use=
r_page-to-unpin_user_page
+++ a/drivers/infiniband/hw/qib/qib_user_sdma.c
@@ -317,7 +317,7 @@ static int qib_user_sdma_page_to_frags(c
 		 * the caller can ignore this page.
 		 */
 		if (put) {
-			put_user_page(page);
+			unpin_user_page(page);
 		} else {
 			/* coalesce case */
 			kunmap(page);
@@ -631,7 +631,7 @@ static void qib_user_sdma_free_pkt_frag(
 			kunmap(pkt->addr[i].page);
=20
 		if (pkt->addr[i].put_page)
-			put_user_page(pkt->addr[i].page);
+			unpin_user_page(pkt->addr[i].page);
 		else
 			__free_page(pkt->addr[i].page);
 	} else if (pkt->addr[i].kvaddr) {
@@ -706,7 +706,7 @@ static int qib_user_sdma_pin_pages(const
 	/* if error, return all pages not managed by pkt */
 free_pages:
 	while (i < j)
-		put_user_page(pages[i++]);
+		unpin_user_page(pages[i++]);
=20
 done:
 	return ret;
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c~mm-tree-wide-rename-put_user=
_page-to-unpin_user_page
+++ a/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -75,7 +75,7 @@ static void usnic_uiom_put_pages(struct
 		for_each_sg(chunk->page_list, sg, chunk->nents, i) {
 			page =3D sg_page(sg);
 			pa =3D sg_phys(sg);
-			put_user_pages_dirty_lock(&page, 1, dirty);
+			unpin_user_pages_dirty_lock(&page, 1, dirty);
 			usnic_dbg("pa: %pa\n", &pa);
 		}
 		kfree(chunk);
--- a/drivers/infiniband/sw/siw/siw_mem.c~mm-tree-wide-rename-put_user_page=
-to-unpin_user_page
+++ a/drivers/infiniband/sw/siw/siw_mem.c
@@ -63,7 +63,7 @@ struct siw_mem *siw_mem_id2obj(struct si
 static void siw_free_plist(struct siw_page_chunk *chunk, int num_pages,
 			   bool dirty)
 {
-	put_user_pages_dirty_lock(chunk->plist, num_pages, dirty);
+	unpin_user_pages_dirty_lock(chunk->plist, num_pages, dirty);
 }
=20
 void siw_umem_release(struct siw_umem *umem, bool dirty)
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c~mm-tree-wide-rename-put_use=
r_page-to-unpin_user_page
+++ a/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -349,8 +349,8 @@ int videobuf_dma_free(struct videobuf_dm
 	BUG_ON(dma->sglen);
=20
 	if (dma->pages) {
-		put_user_pages_dirty_lock(dma->pages, dma->nr_pages,
-					  dma->direction =3D=3D DMA_FROM_DEVICE);
+		unpin_user_pages_dirty_lock(dma->pages, dma->nr_pages,
+					    dma->direction =3D=3D DMA_FROM_DEVICE);
 		kfree(dma->pages);
 		dma->pages =3D NULL;
 	}
--- a/drivers/platform/goldfish/goldfish_pipe.c~mm-tree-wide-rename-put_use=
r_page-to-unpin_user_page
+++ a/drivers/platform/goldfish/goldfish_pipe.c
@@ -360,8 +360,8 @@ static int transfer_max_buffers(struct g
=20
 	*consumed_size =3D pipe->command_buffer->rw_params.consumed_size;
=20
-	put_user_pages_dirty_lock(pipe->pages, pages_count,
-				  !is_write && *consumed_size > 0);
+	unpin_user_pages_dirty_lock(pipe->pages, pages_count,
+				    !is_write && *consumed_size > 0);
=20
 	mutex_unlock(&pipe->lock);
 	return 0;
--- a/drivers/vfio/vfio_iommu_type1.c~mm-tree-wide-rename-put_user_page-to-=
unpin_user_page
+++ a/drivers/vfio/vfio_iommu_type1.c
@@ -310,7 +310,7 @@ static int put_pfn(unsigned long pfn, in
 	if (!is_invalid_reserved_pfn(pfn)) {
 		struct page *page =3D pfn_to_page(pfn);
=20
-		put_user_pages_dirty_lock(&page, 1, prot & IOMMU_WRITE);
+		unpin_user_pages_dirty_lock(&page, 1, prot & IOMMU_WRITE);
 		return 1;
 	}
 	return 0;
--- a/fs/io_uring.c~mm-tree-wide-rename-put_user_page-to-unpin_user_page
+++ a/fs/io_uring.c
@@ -4682,7 +4682,7 @@ static int io_sqe_buffer_unregister(stru
 		struct io_mapped_ubuf *imu =3D &ctx->user_bufs[i];
=20
 		for (j =3D 0; j < imu->nr_bvecs; j++)
-			put_user_page(imu->bvec[j].bv_page);
+			unpin_user_page(imu->bvec[j].bv_page);
=20
 		if (ctx->account_mem)
 			io_unaccount_mem(ctx->user, imu->nr_bvecs);
@@ -4827,7 +4827,7 @@ static int io_sqe_buffer_register(struct
 			 * release any pages we did get
 			 */
 			if (pret > 0)
-				put_user_pages(pages, pret);
+				unpin_user_pages(pages, pret);
 			if (ctx->account_mem)
 				io_unaccount_mem(ctx->user, nr_pages);
 			kvfree(imu->bvec);
--- a/include/linux/mm.h~mm-tree-wide-rename-put_user_page-to-unpin_user_pa=
ge
+++ a/include/linux/mm.h
@@ -1044,27 +1044,27 @@ static inline void put_page(struct page
 }
=20
 /**
- * put_user_page() - release a gup-pinned page
+ * unpin_user_page() - release a gup-pinned page
  * @page:            pointer to page to be released
  *
  * Pages that were pinned via pin_user_pages*() must be released via either
- * put_user_page(), or one of the put_user_pages*() routines. This is so t=
hat
- * eventually such pages can be separately tracked and uniquely handled. In
+ * unpin_user_page(), or one of the unpin_user_pages*() routines. This is =
so
+ * that eventually such pages can be separately tracked and uniquely handl=
ed. In
  * particular, interactions with RDMA and filesystems need special handlin=
g.
  *
- * put_user_page() and put_page() are not interchangeable, despite this ea=
rly
- * implementation that makes them look the same. put_user_page() calls must
+ * unpin_user_page() and put_page() are not interchangeable, despite this =
early
+ * implementation that makes them look the same. unpin_user_page() calls m=
ust
  * be perfectly matched up with pin*() calls.
  */
-static inline void put_user_page(struct page *page)
+static inline void unpin_user_page(struct page *page)
 {
 	put_page(page);
 }
=20
-void put_user_pages_dirty_lock(struct page **pages, unsigned long npages,
-			       bool make_dirty);
+void unpin_user_pages_dirty_lock(struct page **pages, unsigned long npages,
+				 bool make_dirty);
=20
-void put_user_pages(struct page **pages, unsigned long npages);
+void unpin_user_pages(struct page **pages, unsigned long npages);
=20
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
 #define SECTION_IN_PAGE_FLAGS
@@ -2588,7 +2588,7 @@ struct page *follow_page(struct vm_area_
 #define FOLL_ANON	0x8000	/* don't do file mappings */
 #define FOLL_LONGTERM	0x10000	/* mapping lifetime is indefinite: see below=
 */
 #define FOLL_SPLIT_PMD	0x20000	/* split huge pmd before returning */
-#define FOLL_PIN	0x40000	/* pages must be released via put_user_page() */
+#define FOLL_PIN	0x40000	/* pages must be released via unpin_user_page */
=20
 /*
  * FOLL_PIN and FOLL_LONGTERM may be used in various combinations with each
@@ -2623,7 +2623,7 @@ struct page *follow_page(struct vm_area_
  * Direct IO). This lets the filesystem know that some non-file-system ent=
ity is
  * potentially changing the pages' data. In contrast to FOLL_GET (whose pa=
ges
  * are released via put_page()), FOLL_PIN pages must be released, ultimate=
ly, by
- * a call to put_user_page().
+ * a call to unpin_user_page().
  *
  * FOLL_PIN is similar to FOLL_GET: both of these pin pages. They use diff=
erent
  * and separate refcounting mechanisms, however, and that means that each =
has
@@ -2631,7 +2631,7 @@ struct page *follow_page(struct vm_area_
  *
  *     FOLL_GET: get_user_pages*() to acquire, and put_page() to release.
  *
- *     FOLL_PIN: pin_user_pages*() to acquire, and put_user_pages to relea=
se.
+ *     FOLL_PIN: pin_user_pages*() to acquire, and unpin_user_pages to rel=
ease.
  *
  * FOLL_PIN and FOLL_GET are mutually exclusive for a given function call.
  * (The underlying pages may experience both FOLL_GET-based and FOLL_PIN-b=
ased
@@ -2641,7 +2641,7 @@ struct page *follow_page(struct vm_area_
  * FOLL_PIN should be set internally by the pin_user_pages*() APIs, never
  * directly by the caller. That's in order to help avoid mismatches when
  * releasing pages: get_user_pages*() pages must be released via put_page(=
),
- * while pin_user_pages*() pages must be released via put_user_page().
+ * while pin_user_pages*() pages must be released via unpin_user_page().
  *
  * Please see Documentation/vm/pin_user_pages.rst for more information.
  */
--- a/mm/gup.c~mm-tree-wide-rename-put_user_page-to-unpin_user_page
+++ a/mm/gup.c
@@ -45,7 +45,7 @@ static inline struct page *try_get_compo
 }
=20
 /**
- * put_user_pages_dirty_lock() - release and optionally dirty gup-pinned p=
ages
+ * unpin_user_pages_dirty_lock() - release and optionally dirty gup-pinned=
 pages
  * @pages:  array of pages to be maybe marked dirty, and definitely releas=
ed.
  * @npages: number of pages in the @pages array.
  * @make_dirty: whether to mark the pages dirty
@@ -55,19 +55,19 @@ static inline struct page *try_get_compo
  *
  * For each page in the @pages array, make that page (or its head page, if=
 a
  * compound page) dirty, if @make_dirty is true, and if the page was previ=
ously
- * listed as clean. In any case, releases all pages using put_user_page(),
- * possibly via put_user_pages(), for the non-dirty case.
+ * listed as clean. In any case, releases all pages using unpin_user_page(=
),
+ * possibly via unpin_user_pages(), for the non-dirty case.
  *
- * Please see the put_user_page() documentation for details.
+ * Please see the unpin_user_page() documentation for details.
  *
  * set_page_dirty_lock() is used internally. If instead, set_page_dirty() =
is
  * required, then the caller should a) verify that this is really correct,
  * because _lock() is usually required, and b) hand code it:
- * set_page_dirty_lock(), put_user_page().
+ * set_page_dirty_lock(), unpin_user_page().
  *
  */
-void put_user_pages_dirty_lock(struct page **pages, unsigned long npages,
-			       bool make_dirty)
+void unpin_user_pages_dirty_lock(struct page **pages, unsigned long npages,
+				 bool make_dirty)
 {
 	unsigned long index;
=20
@@ -78,7 +78,7 @@ void put_user_pages_dirty_lock(struct pa
 	 */
=20
 	if (!make_dirty) {
-		put_user_pages(pages, npages);
+		unpin_user_pages(pages, npages);
 		return;
 	}
=20
@@ -106,21 +106,21 @@ void put_user_pages_dirty_lock(struct pa
 		 */
 		if (!PageDirty(page))
 			set_page_dirty_lock(page);
-		put_user_page(page);
+		unpin_user_page(page);
 	}
 }
-EXPORT_SYMBOL(put_user_pages_dirty_lock);
+EXPORT_SYMBOL(unpin_user_pages_dirty_lock);
=20
 /**
- * put_user_pages() - release an array of gup-pinned pages.
+ * unpin_user_pages() - release an array of gup-pinned pages.
  * @pages:  array of pages to be marked dirty and released.
  * @npages: number of pages in the @pages array.
  *
- * For each page in the @pages array, release the page using put_user_page=
().
+ * For each page in the @pages array, release the page using unpin_user_pa=
ge().
  *
- * Please see the put_user_page() documentation for details.
+ * Please see the unpin_user_page() documentation for details.
  */
-void put_user_pages(struct page **pages, unsigned long npages)
+void unpin_user_pages(struct page **pages, unsigned long npages)
 {
 	unsigned long index;
=20
@@ -130,9 +130,9 @@ void put_user_pages(struct page **pages,
 	 * single operation to the head page should suffice.
 	 */
 	for (index =3D 0; index < npages; index++)
-		put_user_page(pages[index]);
+		unpin_user_page(pages[index]);
 }
-EXPORT_SYMBOL(put_user_pages);
+EXPORT_SYMBOL(unpin_user_pages);
=20
 #ifdef CONFIG_MMU
 static struct page *no_page_table(struct vm_area_struct *vma,
--- a/mm/process_vm_access.c~mm-tree-wide-rename-put_user_page-to-unpin_use=
r_page
+++ a/mm/process_vm_access.c
@@ -126,8 +126,8 @@ static int process_vm_rw_single_vec(unsi
 		pa +=3D pinned_pages * PAGE_SIZE;
=20
 		/* If vm_write is set, the pages need to be made dirty: */
-		put_user_pages_dirty_lock(process_pages, pinned_pages,
-					  vm_write);
+		unpin_user_pages_dirty_lock(process_pages, pinned_pages,
+					    vm_write);
 	}
=20
 	return rc;
--- a/net/xdp/xdp_umem.c~mm-tree-wide-rename-put_user_page-to-unpin_user_pa=
ge
+++ a/net/xdp/xdp_umem.c
@@ -212,7 +212,7 @@ static int xdp_umem_map_pages(struct xdp
=20
 static void xdp_umem_unpin_pages(struct xdp_umem *umem)
 {
-	put_user_pages_dirty_lock(umem->pgs, umem->npgs, true);
+	unpin_user_pages_dirty_lock(umem->pgs, umem->npgs, true);
=20
 	kfree(umem->pgs);
 	umem->pgs =3D NULL;
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
