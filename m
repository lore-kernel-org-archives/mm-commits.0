From: akpm@linux-foundation.org
Subject: + mm-move-get_vaddr_frames-behind-a-config-option.patch added to
 -mm tree
Date: Wed, 10 Jun 2015 14:16:29 -0700
Message-ID: <5578a92d.ad9YnullkluXmUhE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073AbbFJVQb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Jun 2015 17:16:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, airlied@linux.ie, akpm@linux-foundation.org, fabf@skynet.be, hans.verkuil@cisco.com, inki.dae@samsung.com, jy0922.shim@samsung.com, kgene@kernel.org, kyungmin.park@samsung.com, laurent.pinchart+renesas@ideasonboard.com, m.szyprowski@samsung.com, mchehab@osg.samsung.com, mgorman@suse.de, pawel@osciak.com, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move get_vaddr_frames() behind a config option
has been added to the -mm tree.  Its filename is
     mm-move-get_vaddr_frames-behind-a-config-option.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-get_vaddr_frames-behind-a-config-option.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-get_vaddr_frames-behind-a-config-option.patch

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
Subject: mm: move get_vaddr_frames() behind a config option

get_vaddr_frames() is used by relatively rare drivers so hide it and the
related functions behind a config option that is selected only by drivers
that need the infrastructure.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "Prabhakar Lad" <prabhakar.csengg@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Kukjin Kim <kgene@kernel.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pawel Osciak <pawel@osciak.com>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/exynos/Kconfig      |    1 
 drivers/media/platform/omap/Kconfig |    1 
 drivers/media/v4l2-core/Kconfig     |    1 
 mm/Kconfig                          |    3 
 mm/Makefile                         |    1 
 mm/frame_vector.c                   |  232 ++++++++++++++++++++++++++
 mm/gup.c                            |  225 -------------------------
 7 files changed, 239 insertions(+), 225 deletions(-)

diff -puN drivers/gpu/drm/exynos/Kconfig~mm-move-get_vaddr_frames-behind-a-config-option drivers/gpu/drm/exynos/Kconfig
--- a/drivers/gpu/drm/exynos/Kconfig~mm-move-get_vaddr_frames-behind-a-config-option
+++ a/drivers/gpu/drm/exynos/Kconfig
@@ -71,6 +71,7 @@ config DRM_EXYNOS_VIDI
 config DRM_EXYNOS_G2D
 	bool "Exynos DRM G2D"
 	depends on DRM_EXYNOS && !VIDEO_SAMSUNG_S5P_G2D
+	select FRAME_VECTOR
 	help
 	  Choose this option if you want to use Exynos G2D for DRM.
 
diff -puN drivers/media/platform/omap/Kconfig~mm-move-get_vaddr_frames-behind-a-config-option drivers/media/platform/omap/Kconfig
--- a/drivers/media/platform/omap/Kconfig~mm-move-get_vaddr_frames-behind-a-config-option
+++ a/drivers/media/platform/omap/Kconfig
@@ -10,6 +10,7 @@ config VIDEO_OMAP2_VOUT
 	select OMAP2_DSS if HAS_IOMEM && ARCH_OMAP2PLUS
 	select OMAP2_VRFB if ARCH_OMAP2 || ARCH_OMAP3
 	select VIDEO_OMAP2_VOUT_VRFB if VIDEO_OMAP2_VOUT && OMAP2_VRFB
+	select FRAME_VECTOR
 	default n
 	---help---
 	  V4L2 Display driver support for OMAP2/3 based boards.
diff -puN drivers/media/v4l2-core/Kconfig~mm-move-get_vaddr_frames-behind-a-config-option drivers/media/v4l2-core/Kconfig
--- a/drivers/media/v4l2-core/Kconfig~mm-move-get_vaddr_frames-behind-a-config-option
+++ a/drivers/media/v4l2-core/Kconfig
@@ -73,6 +73,7 @@ config VIDEOBUF2_CORE
 
 config VIDEOBUF2_MEMOPS
 	tristate
+	select FRAME_VECTOR
 
 config VIDEOBUF2_DMA_CONTIG
 	tristate
diff -puN mm/Kconfig~mm-move-get_vaddr_frames-behind-a-config-option mm/Kconfig
--- a/mm/Kconfig~mm-move-get_vaddr_frames-behind-a-config-option
+++ a/mm/Kconfig
@@ -637,6 +637,9 @@ config MAX_STACK_SIZE_MB
 
 	  A sane initial value is 80 MB.
 
+config FRAME_VECTOR
+	bool
+
 # For architectures that support deferred memory initialisation
 config ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT
 	bool
diff -puN mm/Makefile~mm-move-get_vaddr_frames-behind-a-config-option mm/Makefile
--- a/mm/Makefile~mm-move-get_vaddr_frames-behind-a-config-option
+++ a/mm/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_NUMA) 	+= mempolicy.o
 obj-$(CONFIG_SPARSEMEM)	+= sparse.o
 obj-$(CONFIG_SPARSEMEM_VMEMMAP) += sparse-vmemmap.o
 obj-$(CONFIG_SLOB) += slob.o
+obj-$(CONFIG_FRAME_VECTOR) += frame_vector.o
 obj-$(CONFIG_MMU_NOTIFIER) += mmu_notifier.o
 obj-$(CONFIG_KSM) += ksm.o
 obj-$(CONFIG_PAGE_POISONING) += debug-pagealloc.o
diff -puN /dev/null mm/frame_vector.c
--- /dev/null
+++ a/mm/frame_vector.c
@@ -0,0 +1,232 @@
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/pagemap.h>
+#include <linux/sched.h>
+
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
diff -puN mm/gup.c~mm-move-get_vaddr_frames-behind-a-config-option mm/gup.c
--- a/mm/gup.c~mm-move-get_vaddr_frames-behind-a-config-option
+++ a/mm/gup.c
@@ -937,231 +937,6 @@ int __mm_populate(unsigned long start, u
 	return ret;	/* 0 or negative error code */
 }
 
-/*
- * get_vaddr_frames() - map virtual addresses to pfns
- * @start:	starting user address
- * @nr_frames:	number of pages / pfns from start to map
- * @write:	whether pages will be written to by the caller
- * @force:	whether to force write access even if user mapping is
- *		readonly. See description of the same argument of
-		get_user_pages().
- * @vec:	structure which receives pages / pfns of the addresses mapped.
- *		It should have space for at least nr_frames entries.
- *
- * This function maps virtual addresses from @start and fills @vec structure
- * with page frame numbers or page pointers to corresponding pages (choice
- * depends on the type of the vma underlying the virtual address). If @start
- * belongs to a normal vma, the function grabs reference to each of the pages
- * to pin them in memory. If @start belongs to VM_IO | VM_PFNMAP vma, we don't
- * touch page structures and the caller must make sure pfns aren't reused for
- * anything else while he is using them.
- *
- * The function returns number of pages mapped which may be less than
- * @nr_frames. In particular we stop mapping if there are more vmas of
- * different type underlying the specified range of virtual addresses.
- * When the function isn't able to map a single page, it returns error.
- *
- * This function takes care of grabbing mmap_sem as necessary.
- */
-int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
-		     bool write, bool force, struct frame_vector *vec)
-{
-	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
-	int ret = 0;
-	int err;
-	int locked;
-
-	if (nr_frames == 0)
-		return 0;
-
-	if (WARN_ON_ONCE(nr_frames > vec->nr_allocated))
-		nr_frames = vec->nr_allocated;
-
-	down_read(&mm->mmap_sem);
-	locked = 1;
-	vma = find_vma_intersection(mm, start, start + 1);
-	if (!vma) {
-		ret = -EFAULT;
-		goto out;
-	}
-	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP))) {
-		vec->got_ref = true;
-		vec->is_pfns = false;
-		ret = get_user_pages_locked(current, mm, start, nr_frames,
-			write, force, (struct page **)(vec->ptrs), &locked);
-		goto out;
-	}
-
-	vec->got_ref = false;
-	vec->is_pfns = true;
-	do {
-		unsigned long *nums = frame_vector_pfns(vec);
-
-		while (ret < nr_frames && start + PAGE_SIZE <= vma->vm_end) {
-			err = follow_pfn(vma, start, &nums[ret]);
-			if (err) {
-				if (ret == 0)
-					ret = err;
-				goto out;
-			}
-			start += PAGE_SIZE;
-			ret++;
-		}
-		/*
-		 * We stop if we have enough pages or if VMA doesn't completely
-		 * cover the tail page.
-		 */
-		if (ret >= nr_frames || start < vma->vm_end)
-			break;
-		vma = find_vma_intersection(mm, start, start + 1);
-	} while (vma && vma->vm_flags & (VM_IO | VM_PFNMAP));
-out:
-	if (locked)
-		up_read(&mm->mmap_sem);
-	if (!ret)
-		ret = -EFAULT;
-	if (ret > 0)
-		vec->nr_frames = ret;
-	return ret;
-}
-EXPORT_SYMBOL(get_vaddr_frames);
-
-/**
- * put_vaddr_frames() - drop references to pages if get_vaddr_frames() acquired
- *			them
- * @vec:	frame vector to put
- *
- * Drop references to pages if get_vaddr_frames() acquired them. We also
- * invalidate the frame vector so that it is prepared for the next call into
- * get_vaddr_frames().
- */
-void put_vaddr_frames(struct frame_vector *vec)
-{
-	int i;
-	struct page **pages;
-
-	if (!vec->got_ref)
-		goto out;
-	pages = frame_vector_pages(vec);
-	/*
-	 * frame_vector_pages() might needed to do a conversion when
-	 * get_vaddr_frames() got pages but vec was later converted to pfns.
-	 * But it shouldn't really fail to convert pfns back...
-	 */
-	if (WARN_ON(IS_ERR(pages)))
-		goto out;
-	for (i = 0; i < vec->nr_frames; i++)
-		put_page(pages[i]);
-	vec->got_ref = false;
-out:
-	vec->nr_frames = 0;
-}
-EXPORT_SYMBOL(put_vaddr_frames);
-
-/**
- * frame_vector_to_pages - convert frame vector to contain page pointers
- * @vec:	frame vector to convert
- *
- * Convert @vec to contain array of page pointers.  If the conversion is
- * successful, return 0. Otherwise return an error. Note that we do not grab
- * page references for the page structures.
- */
-int frame_vector_to_pages(struct frame_vector *vec)
-{
-	int i;
-	unsigned long *nums;
-	struct page **pages;
-
-	if (!vec->is_pfns)
-		return 0;
-	nums = frame_vector_pfns(vec);
-	for (i = 0; i < vec->nr_frames; i++)
-		if (!pfn_valid(nums[i]))
-			return -EINVAL;
-	pages = (struct page **)nums;
-	for (i = 0; i < vec->nr_frames; i++)
-		pages[i] = pfn_to_page(nums[i]);
-	vec->is_pfns = false;
-	return 0;
-}
-EXPORT_SYMBOL(frame_vector_to_pages);
-
-/**
- * frame_vector_to_pfns - convert frame vector to contain pfns
- * @vec:	frame vector to convert
- *
- * Convert @vec to contain array of pfns.
- */
-void frame_vector_to_pfns(struct frame_vector *vec)
-{
-	int i;
-	unsigned long *nums;
-	struct page **pages;
-
-	if (vec->is_pfns)
-		return;
-	pages = (struct page **)(vec->ptrs);
-	nums = (unsigned long *)pages;
-	for (i = 0; i < vec->nr_frames; i++)
-		nums[i] = page_to_pfn(pages[i]);
-	vec->is_pfns = true;
-}
-EXPORT_SYMBOL(frame_vector_to_pfns);
-
-/**
- * frame_vector_create() - allocate & initialize structure for pinned pfns
- * @nr_frames:	number of pfns slots we should reserve
- *
- * Allocate and initialize struct pinned_pfns to be able to hold @nr_pfns
- * pfns.
- */
-struct frame_vector *frame_vector_create(unsigned int nr_frames)
-{
-	struct frame_vector *vec;
-	int size = sizeof(struct frame_vector) + sizeof(void *) * nr_frames;
-
-	if (WARN_ON_ONCE(nr_frames == 0))
-		return NULL;
-	/*
-	 * This is absurdly high. It's here just to avoid strange effects when
-	 * arithmetics overflows.
-	 */
-	if (WARN_ON_ONCE(nr_frames > INT_MAX / sizeof(void *) / 2))
-		return NULL;
-	/*
-	 * Avoid higher order allocations, use vmalloc instead. It should
-	 * be rare anyway.
-	 */
-	if (size <= PAGE_SIZE)
-		vec = kmalloc(size, GFP_KERNEL);
-	else
-		vec = vmalloc(size);
-	if (!vec)
-		return NULL;
-	vec->nr_allocated = nr_frames;
-	vec->nr_frames = 0;
-	return vec;
-}
-EXPORT_SYMBOL(frame_vector_create);
-
-/**
- * frame_vector_destroy() - free memory allocated to carry frame vector
- * @vec:	Frame vector to free
- *
- * Free structure allocated by frame_vector_create() to carry frames.
- */
-void frame_vector_destroy(struct frame_vector *vec)
-{
-	/* Make sure put_vaddr_frames() got called properly... */
-	VM_BUG_ON(vec->nr_frames > 0);
-	if (!is_vmalloc_addr(vec))
-		kfree(vec);
-	else
-		vfree(vec);
-}
-EXPORT_SYMBOL(frame_vector_destroy);
