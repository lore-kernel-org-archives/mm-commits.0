From: akpm@linux-foundation.org
Subject: [to-be-updated]
 media-omap_vout-convert-omap_vout_uservirt_to_phys-to-use-get_vaddr_pfns.patch removed from -mm tree
Date: Mon, 06 Jul 2015 15:19:09 -0700
Message-ID: <559afedd.Xdrs34GwTu+6Gx1W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33694 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbbGFWTK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 18:19:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, airlied@linux.ie, fabf@skynet.be, hans.verkuil@cisco.com, inki.dae@samsung.com, jy0922.shim@samsung.com, kgene@kernel.org, kyungmin.park@samsung.com, laurent.pinchart+renesas@ideasonboard.com, m.szyprowski@samsung.com, mchehab@osg.samsung.com, mgorman@suse.de, pawel@osciak.com, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: media: omap_vout: convert omap_vout_uservirt_to_phys() to use get_vaddr_pfns()
has been removed from the -mm tree.  Its filename was
     media-omap_vout-convert-omap_vout_uservirt_to_phys-to-use-get_vaddr_pfns.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: media: omap_vout: convert omap_vout_uservirt_to_phys() to use get_vaddr_pfns()

Convert omap_vout_uservirt_to_phys() to use get_vaddr_pfns() instead of
hand made mapping of virtual address to physical address.  Also the
function leaked page reference from get_user_pages() so fix that by
properly release the reference when omap_vout_buffer_release() is called.

[hans.verkuil@cisco.com: remove unused struct omap_vout_device *vout variable]
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
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

 drivers/media/platform/omap/omap_vout.c |   71 +++++++++-------------
 1 file changed, 32 insertions(+), 39 deletions(-)

diff -puN drivers/media/platform/omap/omap_vout.c~media-omap_vout-convert-omap_vout_uservirt_to_phys-to-use-get_vaddr_pfns drivers/media/platform/omap/omap_vout.c
--- a/drivers/media/platform/omap/omap_vout.c~media-omap_vout-convert-omap_vout_uservirt_to_phys-to-use-get_vaddr_pfns
+++ a/drivers/media/platform/omap/omap_vout.c
@@ -195,46 +195,34 @@ static int omap_vout_try_format(struct v
 }
 
 /*
- * omap_vout_uservirt_to_phys: This inline function is used to convert user
- * space virtual address to physical address.
+ * omap_vout_get_userptr: Convert user space virtual address to physical
+ * address.
  */
-static unsigned long omap_vout_uservirt_to_phys(unsigned long virtp)
+static int omap_vout_get_userptr(struct videobuf_buffer *vb, u32 virtp,
+				 u32 *physp)
 {
-	unsigned long physp = 0;
-	struct vm_area_struct *vma;
-	struct mm_struct *mm = current->mm;
+	struct frame_vector *vec;
+	int ret;
 
 	/* For kernel direct-mapped memory, take the easy way */
-	if (virtp >= PAGE_OFFSET)
-		return virt_to_phys((void *) virtp);
+	if (virtp >= PAGE_OFFSET) {
+		*physp = virt_to_phys((void *)virtp);
+		return 0;
+	}
 
-	down_read(&current->mm->mmap_sem);
-	vma = find_vma(mm, virtp);
-	if (vma && (vma->vm_flags & VM_IO) && vma->vm_pgoff) {
-		/* this will catch, kernel-allocated, mmaped-to-usermode
-		   addresses */
-		physp = (vma->vm_pgoff << PAGE_SHIFT) + (virtp - vma->vm_start);
-		up_read(&current->mm->mmap_sem);
-	} else {
-		/* otherwise, use get_user_pages() for general userland pages */
-		int res, nr_pages = 1;
-		struct page *pages;
-
-		res = get_user_pages(current, current->mm, virtp, nr_pages, 1,
-				0, &pages, NULL);
-		up_read(&current->mm->mmap_sem);
-
-		if (res == nr_pages) {
-			physp =  __pa(page_address(&pages[0]) +
-					(virtp & ~PAGE_MASK));
-		} else {
-			printk(KERN_WARNING VOUT_NAME
-					"get_user_pages failed\n");
-			return 0;
-		}
+	vec = frame_vector_create(1);
+	if (!vec)
+		return -ENOMEM;
+
+	ret = get_vaddr_frames(virtp, 1, true, false, vec);
+	if (ret != 1) {
+		frame_vector_destroy(vec);
+		return -EINVAL;
 	}
+	*physp = __pfn_to_phys(frame_vector_pfns(vec)[0]);
+	vb->priv = vec;
 
-	return physp;
+	return 0;
 }
 
 /*
@@ -784,11 +772,15 @@ static int omap_vout_buffer_prepare(stru
 	 * address of the buffer
 	 */
 	if (V4L2_MEMORY_USERPTR == vb->memory) {
+		int ret;
+
 		if (0 == vb->baddr)
 			return -EINVAL;
 		/* Physical address */
-		vout->queued_buf_addr[vb->i] = (u8 *)
-			omap_vout_uservirt_to_phys(vb->baddr);
+		ret = omap_vout_get_userptr(vb, vb->baddr,
+				(u32 *)&vout->queued_buf_addr[vb->i]);
+		if (ret < 0)
+			return ret;
 	} else {
 		unsigned long addr, dma_addr;
 		unsigned long size;
@@ -834,12 +826,13 @@ static void omap_vout_buffer_queue(struc
 static void omap_vout_buffer_release(struct videobuf_queue *q,
 			    struct videobuf_buffer *vb)
 {
-	struct omap_vout_device *vout = q->priv_data;
-
 	vb->state = VIDEOBUF_NEEDS_INIT;
+	if (vb->memory == V4L2_MEMORY_USERPTR && vb->priv) {
+		struct frame_vector *vec = vb->priv;
 
-	if (V4L2_MEMORY_MMAP != vout->memory)
-		return;
+		put_vaddr_frames(vec);
+		frame_vector_destroy(vec);
+	}
 }
 
 /*
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
vb2-provide-helpers-for-mapping-virtual-addresses.patch
media-vb2-convert-vb2_dma_sg_get_userptr-to-use-frame-vector.patch
media-vb2-convert-vb2_vmalloc_get_userptr-to-use-frame-vector.patch
media-vb2-convert-vb2_dc_get_userptr-to-use-frame-vector.patch
media-vb2-remove-unused-functions.patch
drm-exynos-convert-g2d_userptr_get_dma_addr-to-use-get_vaddr_frames.patch
mm-move-get_vaddr_frames-behind-a-config-option.patch
mm-move-get_vaddr_frames-behind-a-config-option-fix.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch

