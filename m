From: akpm@linux-foundation.org
Subject: [merged]
 mm-process_vm_access-set-foll_pin-via-pin_user_pages_remote.patch removed
 from -mm tree
Date: Fri, 31 Jan 2020 15:17:55 -0800
Message-ID: <20200131231755.Gi0MsfeQX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbgAaXR5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:17:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.williamson@redhat.com, aneesh.kumar@linux.ibm.com, axboe@kernel.dk, bjorn.topel@intel.com, corbet@lwn.net, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, hch@lst.de, hverkuil-cisco@xs4all.nl, ira.weiny@intel.com, jack@suse.cz, jgg@mellanox.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, kirill@shutemov.name, leonro@mellanox.com, mchehab@kernel.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com


The patch titled
     Subject: mm/process_vm_access: set FOLL_PIN via pin_user_pages_remote()
has been removed from the -mm tree.  Its filename was
     mm-process_vm_access-set-foll_pin-via-pin_user_pages_remote.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: mm/process_vm_access: set FOLL_PIN via pin_user_pages_remote()

Convert process_vm_access to use the new pin_user_pages_remote() call,
which sets FOLL_PIN.  Setting FOLL_PIN is now required for code that
requires tracking of pinned pages.

Also, release the pages via put_user_page*().

Also, rename "pages" to "pinned_pages", as this makes for easier reading
of process_vm_rw_single_vec().

Link: http://lkml.kernel.org/r/20200107224558.2362728-15-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
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
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Leon Romanovsky <leonro@mellanox.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/process_vm_access.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

--- a/mm/process_vm_access.c~mm-process_vm_access-set-foll_pin-via-pin_user=
_pages_remote
+++ a/mm/process_vm_access.c
@@ -42,12 +42,11 @@ static int process_vm_rw_pages(struct pa
 		if (copy > len)
 			copy =3D len;
=20
-		if (vm_write) {
+		if (vm_write)
 			copied =3D copy_page_from_iter(page, offset, copy, iter);
-			set_page_dirty_lock(page);
-		} else {
+		else
 			copied =3D copy_page_to_iter(page, offset, copy, iter);
-		}
+
 		len -=3D copied;
 		if (copied < copy && iov_iter_count(iter))
 			return -EFAULT;
@@ -96,7 +95,7 @@ static int process_vm_rw_single_vec(unsi
 		flags |=3D FOLL_WRITE;
=20
 	while (!rc && nr_pages && iov_iter_count(iter)) {
-		int pages =3D min(nr_pages, max_pages_per_loop);
+		int pinned_pages =3D min(nr_pages, max_pages_per_loop);
 		int locked =3D 1;
 		size_t bytes;
=20
@@ -106,14 +105,15 @@ static int process_vm_rw_single_vec(unsi
 		 * current/current->mm
 		 */
 		down_read(&mm->mmap_sem);
-		pages =3D get_user_pages_remote(task, mm, pa, pages, flags,
-					      process_pages, NULL, &locked);
+		pinned_pages =3D pin_user_pages_remote(task, mm, pa, pinned_pages,
+						     flags, process_pages,
+						     NULL, &locked);
 		if (locked)
 			up_read(&mm->mmap_sem);
-		if (pages <=3D 0)
+		if (pinned_pages <=3D 0)
 			return -EFAULT;
=20
-		bytes =3D pages * PAGE_SIZE - start_offset;
+		bytes =3D pinned_pages * PAGE_SIZE - start_offset;
 		if (bytes > len)
 			bytes =3D len;
=20
@@ -122,10 +122,12 @@ static int process_vm_rw_single_vec(unsi
 					 vm_write);
 		len -=3D bytes;
 		start_offset =3D 0;
-		nr_pages -=3D pages;
-		pa +=3D pages * PAGE_SIZE;
-		while (pages)
-			put_page(process_pages[--pages]);
+		nr_pages -=3D pinned_pages;
+		pa +=3D pinned_pages * PAGE_SIZE;
+
+		/* If vm_write is set, the pages need to be made dirty: */
+		put_user_pages_dirty_lock(process_pages, pinned_pages,
+					  vm_write);
 	}
=20
 	return rc;
_

Patches currently in -mm which might be from jhubbard@nvidia.com are
