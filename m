From: akpm@linux-foundation.org
Subject: +
 mm-devmap-refactor-1-based-refcounting-for-zone_device-pages.patch added to
 -mm tree
Date: Tue, 14 Jan 2020 15:29:46 -0800
Message-ID: <20200114232946.qPAj8elee%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728827AbgANX3t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Jan 2020 18:29:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.williamson@redhat.com, aneesh.kumar@linux.ibm.com, axboe@kernel.dk, bjorn.topel@intel.com, corbet@lwn.net, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, hch@lst.de, hverkuil-cisco@xs4all.nl, ira.weiny@intel.com, jack@suse.cz, jgg@mellanox.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, kirill@shutemov.name, leonro@mellanox.com, mchehab@kernel.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com


The patch titled
     Subject: mm: devmap: refactor 1-based refcounting for ZONE_DEVICE pages
has been added to the -mm tree.  Its filename is
     mm-devmap-refactor-1-based-refcounting-for-zone_device-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-devmap-refactor-1-based-ref=
counting-for-zone_device-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-devmap-refactor-1-based-ref=
counting-for-zone_device-pages.patch

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
Subject: mm: devmap: refactor 1-based refcounting for ZONE_DEVICE pages

An upcoming patch changes and complicates the refcounting and especially
the "put page" aspects of it.  In order to keep everything clean, refactor
the devmap page release routines:

* Rename put_devmap_managed_page() to page_is_devmap_managed(), and
  limit the functionality to "read only": return a bool, with no side
  effects.

* Add a new routine, put_devmap_managed_page(), to handle decrementing
  the refcount for ZONE_DEVICE pages.

* Change callers (just release_pages() and put_page()) to check
  page_is_devmap_managed() before calling the new
  put_devmap_managed_page() routine.  This is a performance point:
  put_page() is a hot path, so we need to avoid non- inline function calls
  where possible.

* Rename __put_devmap_managed_page() to free_devmap_managed_page(), and
  limit the functionality to unconditionally freeing a devmap page.

This is originally based on a separate patch by Ira Weiny, which applied
to an early version of the put_user_page() experiments.  Since then,
J=C3=A9r=C3=B4me Glisse suggested the refactoring described above.

Link: http://lkml.kernel.org/r/20200107224558.2362728-5-jhubbard@nvidia.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Suggested-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Leon Romanovsky <leonro@mellanox.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   18 +++++++++++++-----
 mm/memremap.c      |   15 +--------------
 mm/swap.c          |   27 ++++++++++++++++++++++++++-
 3 files changed, 40 insertions(+), 20 deletions(-)

--- a/include/linux/mm.h~mm-devmap-refactor-1-based-refcounting-for-zone_de=
vice-pages
+++ a/include/linux/mm.h
@@ -952,9 +952,10 @@ static inline bool is_zone_device_page(c
 #endif
=20
 #ifdef CONFIG_DEV_PAGEMAP_OPS
-void __put_devmap_managed_page(struct page *page);
+void free_devmap_managed_page(struct page *page);
 DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
-static inline bool put_devmap_managed_page(struct page *page)
+
+static inline bool page_is_devmap_managed(struct page *page)
 {
 	if (!static_branch_unlikely(&devmap_managed_key))
 		return false;
@@ -963,7 +964,6 @@ static inline bool put_devmap_managed_pa
 	switch (page->pgmap->type) {
 	case MEMORY_DEVICE_PRIVATE:
 	case MEMORY_DEVICE_FS_DAX:
-		__put_devmap_managed_page(page);
 		return true;
 	default:
 		break;
@@ -971,11 +971,17 @@ static inline bool put_devmap_managed_pa
 	return false;
 }
=20
+void put_devmap_managed_page(struct page *page);
+
 #else /* CONFIG_DEV_PAGEMAP_OPS */
-static inline bool put_devmap_managed_page(struct page *page)
+static inline bool page_is_devmap_managed(struct page *page)
 {
 	return false;
 }
+
+static inline void put_devmap_managed_page(struct page *page)
+{
+}
 #endif /* CONFIG_DEV_PAGEMAP_OPS */
=20
 static inline bool is_device_private_page(const struct page *page)
@@ -1028,8 +1034,10 @@ static inline void put_page(struct page
 	 * need to inform the device driver through callback. See
 	 * include/linux/memremap.h and HMM for details.
 	 */
-	if (put_devmap_managed_page(page))
+	if (page_is_devmap_managed(page)) {
+		put_devmap_managed_page(page);
 		return;
+	}
=20
 	if (put_page_testzero(page))
 		__put_page(page);
--- a/mm/memremap.c~mm-devmap-refactor-1-based-refcounting-for-zone_device-=
pages
+++ a/mm/memremap.c
@@ -431,20 +431,8 @@ struct dev_pagemap *get_dev_pagemap(unsi
 EXPORT_SYMBOL_GPL(get_dev_pagemap);
=20
 #ifdef CONFIG_DEV_PAGEMAP_OPS
-void __put_devmap_managed_page(struct page *page)
+void free_devmap_managed_page(struct page *page)
 {
-	int count =3D page_ref_dec_return(page);
-
-	/* still busy */
-	if (count > 1)
-		return;
-
-	/* only triggered by the dev_pagemap shutdown path */
-	if (count =3D=3D 0) {
-		__put_page(page);
-		return;
-	}
-
 	/* notify page idle for dax */
 	if (!is_device_private_page(page)) {
 		wake_up_var(&page->_refcount);
@@ -481,5 +469,4 @@ void __put_devmap_managed_page(struct pa
 	page->mapping =3D NULL;
 	page->pgmap->ops->page_free(page);
 }
-EXPORT_SYMBOL(__put_devmap_managed_page);
 #endif /* CONFIG_DEV_PAGEMAP_OPS */
--- a/mm/swap.c~mm-devmap-refactor-1-based-refcounting-for-zone_device-pages
+++ a/mm/swap.c
@@ -813,8 +813,10 @@ void release_pages(struct page **pages,
 			 * processing, and instead, expect a call to
 			 * put_page_testzero().
 			 */
-			if (put_devmap_managed_page(page))
+			if (page_is_devmap_managed(page)) {
+				put_devmap_managed_page(page);
 				continue;
+			}
 		}
=20
 		page =3D compound_head(page);
@@ -1102,3 +1104,26 @@ void __init swap_setup(void)
 	 * _really_ don't want to cluster much more
 	 */
 }
+
+#ifdef CONFIG_DEV_PAGEMAP_OPS
+void put_devmap_managed_page(struct page *page)
+{
+	int count;
+
+	if (WARN_ON_ONCE(!page_is_devmap_managed(page)))
+		return;
+
+	count =3D page_ref_dec_return(page);
+
+	/*
+	 * devmap page refcounts are 1-based, rather than 0-based: if
+	 * refcount is 1, then the page is free and the refcount is
+	 * stable because nobody holds a reference on the page.
+	 */
+	if (count =3D=3D 1)
+		free_devmap_managed_page(page);
+	else if (!count)
+		__put_page(page);
+}
+EXPORT_SYMBOL(put_devmap_managed_page);
+#endif
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
