From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 029/118] mm: fix get_user_pages_remote()'s
 handling of FOLL_LONGTERM
Date: Thu, 30 Jan 2020 22:12:36 -0800
Message-ID: <20200131061236.4ftJPpJHN%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726488AbgAaGMi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:12:38 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.williamson@redhat.com, aneesh.kumar@linux.ibm.com, axboe@kernel.dk, bjorn.topel@intel.com, corbet@lwn.net, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, hch@lst.de, hverkuil-cisco@xs4all.nl, ira.weiny@intel.com, jack@suse.cz, jgg@mellanox.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, kirill@shutemov.name, leonro@mellanox.com, linux-mm@kvack.org, mchehab@kernel.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com, torvalds@linux-foundation.org

=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: mm: fix get_user_pages_remote()'s handling of FOLL_LONGTERM

As it says in the updated comment in gup.c: current FOLL_LONGTERM behavior
is incompatible with FAULT_FLAG_ALLOW_RETRY because of the FS DAX check
requirement on vmas.

However, the corresponding restriction in get_user_pages_remote() was
slightly stricter than is actually required: it forbade all FOLL_LONGTERM
callers, but we can actually allow FOLL_LONGTERM callers that do not set
the "locked" arg.

Update the code and comments to loosen the restriction, allowing
FOLL_LONGTERM in some cases.

Also, copy the DAX check ("if a VMA is DAX, don't allow long term
pinning") from the VFIO call site, all the way into the internals of
get_user_pages_remote() and __gup_longterm_locked().  That is:
get_user_pages_remote() calls __gup_longterm_locked(), which in turn calls
check_dax_vmas().  This check will then be removed from the VFIO call site
in a subsequent patch.

Thanks to Jason Gunthorpe for pointing out a clean way to fix this, and to
Dan Williams for helping clarify the DAX refactoring.

Link: http://lkml.kernel.org/r/20200107224558.2362728-7-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Tested-by: Alex Williamson <alex.williamson@redhat.com>
Acked-by: Alex Williamson <alex.williamson@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
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
Cc: Leon Romanovsky <leonro@mellanox.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |  174 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 92 insertions(+), 82 deletions(-)

--- a/mm/gup.c~mm-fix-get_user_pages_remotes-handling-of-foll_longterm
+++ a/mm/gup.c
@@ -1111,88 +1111,6 @@ static __always_inline long __get_user_p
 	return pages_done;
 }
=20
-/*
- * get_user_pages_remote() - pin user pages in memory
- * @tsk:	the task_struct to use for page fault accounting, or
- *		NULL if faults are not to be recorded.
- * @mm:		mm_struct of target mm
- * @start:	starting user address
- * @nr_pages:	number of pages from start to pin
- * @gup_flags:	flags modifying lookup behaviour
- * @pages:	array that receives pointers to the pages pinned.
- *		Should be at least nr_pages long. Or NULL, if caller
- *		only intends to ensure the pages are faulted in.
- * @vmas:	array of pointers to vmas corresponding to each page.
- *		Or NULL if the caller does not require them.
- * @locked:	pointer to lock flag indicating whether lock is held and
- *		subsequently whether VM_FAULT_RETRY functionality can be
- *		utilised. Lock must initially be held.
- *
- * Returns either number of pages pinned (which may be less than the
- * number requested), or an error. Details about the return value:
- *
- * -- If nr_pages is 0, returns 0.
- * -- If nr_pages is >0, but no pages were pinned, returns -errno.
- * -- If nr_pages is >0, and some pages were pinned, returns the number of
- *    pages pinned. Again, this may be less than nr_pages.
- *
- * The caller is responsible for releasing returned @pages, via put_page().
- *
- * @vmas are valid only as long as mmap_sem is held.
- *
- * Must be called with mmap_sem held for read or write.
- *
- * get_user_pages walks a process's page tables and takes a reference to
- * each struct page that each user address corresponds to at a given
- * instant. That is, it takes the page that would be accessed if a user
- * thread accesses the given user virtual address at that instant.
- *
- * This does not guarantee that the page exists in the user mappings when
- * get_user_pages returns, and there may even be a completely different
- * page there in some cases (eg. if mmapped pagecache has been invalidated
- * and subsequently re faulted). However it does guarantee that the page
- * won't be freed completely. And mostly callers simply care that the page
- * contains data that was valid *at some point in time*. Typically, an IO
- * or similar operation cannot guarantee anything stronger anyway because
- * locks can't be held over the syscall boundary.
- *
- * If gup_flags & FOLL_WRITE =3D=3D 0, the page must not be written to. If=
 the page
- * is written to, set_page_dirty (or set_page_dirty_lock, as appropriate) =
must
- * be called after the page is finished with, and before put_page is calle=
d.
- *
- * get_user_pages is typically used for fewer-copy IO operations, to get a
- * handle on the memory by some means other than accesses via the user vir=
tual
- * addresses. The pages may be submitted for DMA to devices or accessed via
- * their kernel linear mapping (via the kmap APIs). Care should be taken to
- * use the correct cache flushing APIs.
- *
- * See also get_user_pages_fast, for performance critical applications.
- *
- * get_user_pages should be phased out in favor of
- * get_user_pages_locked|unlocked or get_user_pages_fast. Nothing
- * should use get_user_pages because it cannot pass
- * FAULT_FLAG_ALLOW_RETRY to handle_mm_fault.
- */
-long get_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
-		unsigned long start, unsigned long nr_pages,
-		unsigned int gup_flags, struct page **pages,
-		struct vm_area_struct **vmas, int *locked)
-{
-	/*
-	 * FIXME: Current FOLL_LONGTERM behavior is incompatible with
-	 * FAULT_FLAG_ALLOW_RETRY because of the FS DAX check requirement on
-	 * vmas.  As there are no users of this flag in this call we simply
-	 * disallow this option for now.
-	 */
-	if (WARN_ON_ONCE(gup_flags & FOLL_LONGTERM))
-		return -EINVAL;
-
-	return __get_user_pages_locked(tsk, mm, start, nr_pages, pages, vmas,
-				       locked,
-				       gup_flags | FOLL_TOUCH | FOLL_REMOTE);
-}
-EXPORT_SYMBOL(get_user_pages_remote);
-
 /**
  * populate_vma_page_range() -  populate a range of pages in the vma.
  * @vma:   target vma
@@ -1627,6 +1545,98 @@ static __always_inline long __gup_longte
 #endif /* CONFIG_FS_DAX || CONFIG_CMA */
=20
 /*
+ * get_user_pages_remote() - pin user pages in memory
+ * @tsk:	the task_struct to use for page fault accounting, or
+ *		NULL if faults are not to be recorded.
+ * @mm:		mm_struct of target mm
+ * @start:	starting user address
+ * @nr_pages:	number of pages from start to pin
+ * @gup_flags:	flags modifying lookup behaviour
+ * @pages:	array that receives pointers to the pages pinned.
+ *		Should be at least nr_pages long. Or NULL, if caller
+ *		only intends to ensure the pages are faulted in.
+ * @vmas:	array of pointers to vmas corresponding to each page.
+ *		Or NULL if the caller does not require them.
+ * @locked:	pointer to lock flag indicating whether lock is held and
+ *		subsequently whether VM_FAULT_RETRY functionality can be
+ *		utilised. Lock must initially be held.
+ *
+ * Returns either number of pages pinned (which may be less than the
+ * number requested), or an error. Details about the return value:
+ *
+ * -- If nr_pages is 0, returns 0.
+ * -- If nr_pages is >0, but no pages were pinned, returns -errno.
+ * -- If nr_pages is >0, and some pages were pinned, returns the number of
+ *    pages pinned. Again, this may be less than nr_pages.
+ *
+ * The caller is responsible for releasing returned @pages, via put_page().
+ *
+ * @vmas are valid only as long as mmap_sem is held.
+ *
+ * Must be called with mmap_sem held for read or write.
+ *
+ * get_user_pages walks a process's page tables and takes a reference to
+ * each struct page that each user address corresponds to at a given
+ * instant. That is, it takes the page that would be accessed if a user
+ * thread accesses the given user virtual address at that instant.
+ *
+ * This does not guarantee that the page exists in the user mappings when
+ * get_user_pages returns, and there may even be a completely different
+ * page there in some cases (eg. if mmapped pagecache has been invalidated
+ * and subsequently re faulted). However it does guarantee that the page
+ * won't be freed completely. And mostly callers simply care that the page
+ * contains data that was valid *at some point in time*. Typically, an IO
+ * or similar operation cannot guarantee anything stronger anyway because
+ * locks can't be held over the syscall boundary.
+ *
+ * If gup_flags & FOLL_WRITE =3D=3D 0, the page must not be written to. If=
 the page
+ * is written to, set_page_dirty (or set_page_dirty_lock, as appropriate) =
must
+ * be called after the page is finished with, and before put_page is calle=
d.
+ *
+ * get_user_pages is typically used for fewer-copy IO operations, to get a
+ * handle on the memory by some means other than accesses via the user vir=
tual
+ * addresses. The pages may be submitted for DMA to devices or accessed via
+ * their kernel linear mapping (via the kmap APIs). Care should be taken to
+ * use the correct cache flushing APIs.
+ *
+ * See also get_user_pages_fast, for performance critical applications.
+ *
+ * get_user_pages should be phased out in favor of
+ * get_user_pages_locked|unlocked or get_user_pages_fast. Nothing
+ * should use get_user_pages because it cannot pass
+ * FAULT_FLAG_ALLOW_RETRY to handle_mm_fault.
+ */
+long get_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
+		unsigned long start, unsigned long nr_pages,
+		unsigned int gup_flags, struct page **pages,
+		struct vm_area_struct **vmas, int *locked)
+{
+	/*
+	 * Parts of FOLL_LONGTERM behavior are incompatible with
+	 * FAULT_FLAG_ALLOW_RETRY because of the FS DAX check requirement on
+	 * vmas. However, this only comes up if locked is set, and there are
+	 * callers that do request FOLL_LONGTERM, but do not set locked. So,
+	 * allow what we can.
+	 */
+	if (gup_flags & FOLL_LONGTERM) {
+		if (WARN_ON_ONCE(locked))
+			return -EINVAL;
+		/*
+		 * This will check the vmas (even if our vmas arg is NULL)
+		 * and return -ENOTSUPP if DAX isn't allowed in this case:
+		 */
+		return __gup_longterm_locked(tsk, mm, start, nr_pages, pages,
+					     vmas, gup_flags | FOLL_TOUCH |
+					     FOLL_REMOTE);
+	}
+
+	return __get_user_pages_locked(tsk, mm, start, nr_pages, pages, vmas,
+				       locked,
+				       gup_flags | FOLL_TOUCH | FOLL_REMOTE);
+}
+EXPORT_SYMBOL(get_user_pages_remote);
+
+/*
  * This is the same as get_user_pages_remote(), just with a
  * less-flexible calling convention where we assume that the task
  * and mm being operated on are the current task's and don't allow
_
