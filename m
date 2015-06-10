From: akpm@linux-foundation.org
Subject: + mm-provide-new-get_vaddr_frames-helper.patch added to -mm tree
Date: Wed, 10 Jun 2015 14:16:07 -0700
Message-ID: <5578a917.cvjJ1els/jdJb/Zk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58121 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbbFJVQJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Jun 2015 17:16:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, airlied@linux.ie, fabf@skynet.be, hans.verkuil@cisco.com, inki.dae@samsung.com, jy0922.shim@samsung.com, kgene@kernel.org, kyungmin.park@samsung.com, laurent.pinchart+renesas@ideasonboard.com, m.szyprowski@samsung.com, mchehab@osg.samsung.com, mgorman@suse.de, pawel@osciak.com, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: provide new get_vaddr_frames() helper
has been added to the -mm tree.  Its filename is
     mm-provide-new-get_vaddr_frames-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-provide-new-get_vaddr_frames-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-provide-new-get_vaddr_frames-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: provide new get_vaddr_frames() helper

Provide new function get_vaddr_frames().  This function maps virtual
addresses from given start and fills given array with page frame numbers
of the corresponding pages.  If given start belongs to a normal vma, the
function grabs reference to each of the pages to pin them in memory.  If
start belongs to VM_IO | VM_PFNMAP vma, we don't touch page structures. 
Caller must make sure pfns aren't reused for anything else while he is
using them.

This function is created for various drivers to simplify handling of their
buffers.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Prabhakar Lad" <prabhakar.csengg@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Kukjin Kim <kgene@kernel.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Pawel Osciak <pawel@osciak.com>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   44 ++++++++
 mm/gup.c           |  226 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 270 insertions(+)

diff -puN include/linux/mm.h~mm-provide-new-get_vaddr_frames-helper include/linux/mm.h
--- a/include/linux/mm.h~mm-provide-new-get_vaddr_frames-helper
+++ a/include/linux/mm.h
@@ -20,6 +20,7 @@
 #include <linux/shrinker.h>
 #include <linux/resource.h>
 #include <linux/page_ext.h>
+#include <linux/err.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -1160,6 +1161,49 @@ long get_user_pages_unlocked(struct task
 		    int write, int force, struct page **pages);
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
+
+/* Container for pinned pfns / pages */
+struct frame_vector {
+	unsigned int nr_allocated;	/* Number of frames we have space for */
+	unsigned int nr_frames;	/* Number of frames stored in ptrs array */
+	bool got_ref;		/* Did we pin pages by getting page ref? */
+	bool is_pfns;		/* Does array contain pages or pfns? */
+	void *ptrs[0];		/* Array of pinned pfns / pages. Use
+				 * pfns_vector_pages() or pfns_vector_pfns()
+				 * for access */
+};
+
+struct frame_vector *frame_vector_create(unsigned int nr_frames);
+void frame_vector_destroy(struct frame_vector *vec);
+int get_vaddr_frames(unsigned long start, unsigned int nr_pfns,
+		     bool write, bool force, struct frame_vector *vec);
+void put_vaddr_frames(struct frame_vector *vec);
+int frame_vector_to_pages(struct frame_vector *vec);
+void frame_vector_to_pfns(struct frame_vector *vec);
+
+static inline unsigned int frame_vector_count(struct frame_vector *vec)
+{
+	return vec->nr_frames;
+}
+
+static inline struct page **frame_vector_pages(struct frame_vector *vec)
+{
+	if (vec->is_pfns) {
+		int err = frame_vector_to_pages(vec);
+
+		if (err)
+			return ERR_PTR(err);
+	}
+	return (struct page **)(vec->ptrs);
+}
+
+static inline unsigned long *frame_vector_pfns(struct frame_vector *vec)
+{
+	if (!vec->is_pfns)
+		frame_vector_to_pfns(vec);
+	return (unsigned long *)(vec->ptrs);
+}
+
 struct kvec;
 int get_kernel_pages(const struct kvec *iov, int nr_pages, int write,
 			struct page **pages);
diff -puN mm/gup.c~mm-provide-new-get_vaddr_frames-helper mm/gup.c
--- a/mm/gup.c~mm-provide-new-get_vaddr_frames-helper
+++ a/mm/gup.c
@@ -8,6 +8,7 @@
 #include <linux/rmap.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
+#include <linux/vmalloc.h>
 
 #include <linux/sched.h>
 #include <linux/rwsem.h>
@@ -936,6 +937,231 @@ int __mm_populate(unsigned long start, u
 	return ret;	/* 0 or negative error code */
 }
 
+/*
+ * get_vaddr_frames() - map virtual addresses to pfns
+ * @start:	starting user address
+ * @nr_frames:	number of pages / pfns from start to map
+ * @write:	whether pages will be written to by the caller
+ * @force:	whether to force write access even if user mapping is
+ *		readonly. See description of the same argument of
+		get_user_pages().
+ * @vec:	structure which receives pages / pfns of the addresses mapped.
+ *		It should have space for at least nr_frames entries.
+ *
+ * This function maps virtual addresses from @start and fills @vec structure
+ * with page frame numbers or page pointers to corresponding pages (choice
+ * depends on the type of the vma underlying the virtual address). If @start
+ * belongs to a normal vma, the function grabs reference to each of the pages
+ * to pin them in memory. If @start belongs to VM_IO | VM_PFNMAP vma, we don't
+ * touch page structures and the caller must make sure pfns aren't reused for
+ * anything else while he is using them.
+ *
+ * The function returns number of pages mapped which may be less than
+ * @nr_frames. In particular we stop mapping if there are more vmas of
+ * different type underlying the specified range of virtual addresses.
+ * When the function isn't able to map a single page, it returns error.
+ *
+ * This function takes care of grabbing mmap_sem as necessary.
+ */
+int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
+		     bool write, bool force, struct frame_vector *vec)
+{
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma;
+	int ret = 0;
+	int err;
+	int locked;
+
+	if (nr_frames == 0)
+		return 0;
+
+	if (WARN_ON_ONCE(nr_frames > vec->nr_allocated))
+		nr_frames = vec->nr_allocated;
+
+	down_read(&mm->mmap_sem);
+	locked = 1;
+	vma = find_vma_intersection(mm, start, start + 1);
+	if (!vma) {
+		ret = -EFAULT;
+		goto out;
+	}
+	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP))) {
+		vec->got_ref = true;
+		vec->is_pfns = false;
+		ret = get_user_pages_locked(current, mm, start, nr_frames,
+			write, force, (struct page **)(vec->ptrs), &locked);
+		goto out;
+	}
+
+	vec->got_ref = false;
+	vec->is_pfns = true;
+	do {
+		unsigned long *nums = frame_vector_pfns(vec);
+
+		while (ret < nr_frames && start + PAGE_SIZE <= vma->vm_end) {
+			err = follow_pfn(vma, start, &nums[ret]);
+			if (err) {
+				if (ret == 0)
+					ret = err;
+				goto out;
+			}
+			start += PAGE_SIZE;
+			ret++;
+		}
+		/*
+		 * We stop if we have enough pages or if VMA doesn't completely
+		 * cover the tail page.
+		 */
+		if (ret >= nr_frames || start < vma->vm_end)
+			break;
+		vma = find_vma_intersection(mm, start, start + 1);
+	} while (vma && vma->vm_flags & (VM_IO | VM_PFNMAP));
+out:
+	if (locked)
+		up_read(&mm->mmap_sem);
+	if (!ret)
+		ret = -EFAULT;
+	if (ret > 0)
+		vec->nr_frames = ret;
+	return ret;
+}
+EXPORT_SYMBOL(get_vaddr_frames);
+
+/**
+ * put_vaddr_frames() - drop references to pages if get_vaddr_frames() acquired
+ *			them
+ * @vec:	frame vector to put
+ *
+ * Drop references to pages if get_vaddr_frames() acquired them. We also
+ * invalidate the frame vector so that it is prepared for the next call into
+ * get_vaddr_frames().
+ */
+void put_vaddr_frames(struct frame_vector *vec)
+{
+	int i;
+	struct page **pages;
+
+	if (!vec->got_ref)
+		goto out;
+	pages = frame_vector_pages(vec);
+	/*
+	 * frame_vector_pages() might needed to do a conversion when
+	 * get_vaddr_frames() got pages but vec was later converted to pfns.
+	 * But it shouldn't really fail to convert pfns back...
+	 */
+	if (WARN_ON(IS_ERR(pages)))
+		goto out;
+	for (i = 0; i < vec->nr_frames; i++)
+		put_page(pages[i]);
+	vec->got_ref = false;
+out:
+	vec->nr_frames = 0;
+}
+EXPORT_SYMBOL(put_vaddr_frames);
+
+/**
+ * frame_vector_to_pages - convert frame vector to contain page pointers
+ * @vec:	frame vector to convert
+ *
+ * Convert @vec to contain array of page pointers.  If the conversion is
+ * successful, return 0. Otherwise return an error. Note that we do not grab
+ * page references for the page structures.
+ */
+int frame_vector_to_pages(struct frame_vector *vec)
+{
+	int i;
+	unsigned long *nums;
+	struct page **pages;
+
+	if (!vec->is_pfns)
+		return 0;
+	nums = frame_vector_pfns(vec);
+	for (i = 0; i < vec->nr_frames; i++)
+		if (!pfn_valid(nums[i]))
+			return -EINVAL;
+	pages = (struct page **)nums;
+	for (i = 0; i < vec->nr_frames; i++)
+		pages[i] = pfn_to_page(nums[i]);
+	vec->is_pfns = false;
+	return 0;
+}
+EXPORT_SYMBOL(frame_vector_to_pages);
+
+/**
+ * frame_vector_to_pfns - convert frame vector to contain pfns
+ * @vec:	frame vector to convert
+ *
+ * Convert @vec to contain array of pfns.
+ */
+void frame_vector_to_pfns(struct frame_vector *vec)
+{
+	int i;
+	unsigned long *nums;
+	struct page **pages;
+
+	if (vec->is_pfns)
+		return;
+	pages = (struct page **)(vec->ptrs);
+	nums = (unsigned long *)pages;
+	for (i = 0; i < vec->nr_frames; i++)
+		nums[i] = page_to_pfn(pages[i]);
+	vec->is_pfns = true;
+}
+EXPORT_SYMBOL(frame_vector_to_pfns);
+
+/**
+ * frame_vector_create() - allocate & initialize structure for pinned pfns
+ * @nr_frames:	number of pfns slots we should reserve
+ *
+ * Allocate and initialize struct pinned_pfns to be able to hold @nr_pfns
+ * pfns.
+ */
+struct frame_vector *frame_vector_create(unsigned int nr_frames)
+{
+	struct frame_vector *vec;
+	int size = sizeof(struct frame_vector) + sizeof(void *) * nr_frames;
+
+	if (WARN_ON_ONCE(nr_frames == 0))
+		return NULL;
+	/*
+	 * This is absurdly high. It's here just to avoid strange effects when
+	 * arithmetics overflows.
+	 */
+	if (WARN_ON_ONCE(nr_frames > INT_MAX / sizeof(void *) / 2))
+		return NULL;
+	/*
+	 * Avoid higher order allocations, use vmalloc instead. It should
+	 * be rare anyway.
+	 */
+	if (size <= PAGE_SIZE)
+		vec = kmalloc(size, GFP_KERNEL);
+	else
+		vec = vmalloc(size);
+	if (!vec)
+		return NULL;
+	vec->nr_allocated = nr_frames;
+	vec->nr_frames = 0;
+	return vec;
+}
+EXPORT_SYMBOL(frame_vector_create);
+
+/**
+ * frame_vector_destroy() - free memory allocated to carry frame vector
+ * @vec:	Frame vector to free
+ *
+ * Free structure allocated by frame_vector_create() to carry frames.
+ */
+void frame_vector_destroy(struct frame_vector *vec)
+{
+	/* Make sure put_vaddr_frames() got called properly... */
+	VM_BUG_ON(vec->nr_frames > 0);
+	if (!is_vmalloc_addr(vec))
+		kfree(vec);
+	else
+		vfree(vec);
+}
+EXPORT_SYMBOL(frame_vector_destroy);
+
 /**
  * get_dump_page() - pin user page in memory while writing it to core dump
  * @addr: user address
_

Patches currently in -mm which might be from jack@suse.cz are

revert-ufs-fix-deadlocks-introduced-by-sb-mutex-merge.patch
ufs-restore-s_lock-mutex.patch
fsnotify-remove-obsolete-documentation.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
linux-next.patch
mm-provide-new-get_vaddr_frames-helper.patch
media-omap_vout-convert-omap_vout_uservirt_to_phys-to-use-get_vaddr_pfns.patch
vb2-provide-helpers-for-mapping-virtual-addresses.patch
media-vb2-convert-vb2_dma_sg_get_userptr-to-use-frame-vector.patch
media-vb2-convert-vb2_vmalloc_get_userptr-to-use-frame-vector.patch
media-vb2-convert-vb2_dc_get_userptr-to-use-frame-vector.patch
media-vb2-remove-unused-functions.patch
drm-exynos-convert-g2d_userptr_get_dma_addr-to-use-get_vaddr_frames.patch
mm-move-get_vaddr_frames-behind-a-config-option.patch
mm-add-strictlimit-knob-v2.patch

