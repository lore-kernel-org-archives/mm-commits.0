From: akpm@linux-foundation.org
Subject: [to-be-updated]
 vb2-provide-helpers-for-mapping-virtual-addresses.patch removed from -mm
 tree
Date: Mon, 06 Jul 2015 15:19:12 -0700
Message-ID: <559afee0.xXvchwQeir55Qm9W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33706 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbbGFWTN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 18:19:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, airlied@linux.ie, fabf@skynet.be, hans.verkuil@cisco.com, inki.dae@samsung.com, jy0922.shim@samsung.com, kgene@kernel.org, kyungmin.park@samsung.com, laurent.pinchart+renesas@ideasonboard.com, m.szyprowski@samsung.com, mchehab@osg.samsung.com, mgorman@suse.de, pawel@osciak.com, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: vb2: provide helpers for mapping virtual addresses
has been removed from the -mm tree.  Its filename was
     vb2-provide-helpers-for-mapping-virtual-addresses.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: vb2: provide helpers for mapping virtual addresses

Provide simple helper functions to map virtual address range into an array
of pfns / pages.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Kukjin Kim <kgene@kernel.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pawel Osciak <pawel@osciak.com>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/v4l2-core/videobuf2-memops.c |   58 +++++++++++++++++++
 include/media/videobuf2-memops.h           |    5 +
 2 files changed, 63 insertions(+)

diff -puN drivers/media/v4l2-core/videobuf2-memops.c~vb2-provide-helpers-for-mapping-virtual-addresses drivers/media/v4l2-core/videobuf2-memops.c
--- a/drivers/media/v4l2-core/videobuf2-memops.c~vb2-provide-helpers-for-mapping-virtual-addresses
+++ a/drivers/media/v4l2-core/videobuf2-memops.c
@@ -137,6 +137,64 @@ int vb2_get_contig_userptr(unsigned long
 EXPORT_SYMBOL_GPL(vb2_get_contig_userptr);
 
 /**
+ * vb2_create_framevec() - map virtual addresses to pfns
+ * @start:	Virtual user address where we start mapping
+ * @length:	Length of a range to map
+ * @write:	Should we map for writing into the area
+ *
+ * This function allocates and fills in a vector with pfns corresponding to
+ * virtual address range passed in arguments. If pfns have corresponding pages,
+ * page references are also grabbed to pin pages in memory. The function
+ * returns pointer to the vector on success and error pointer in case of
+ * failure. Returned vector needs to be freed via vb2_destroy_pfnvec().
+ */
+struct frame_vector *vb2_create_framevec(unsigned long start,
+					 unsigned long length,
+					 bool write)
+{
+	int ret;
+	unsigned long first, last;
+	unsigned long nr;
+	struct frame_vector *vec;
+
+	first = start >> PAGE_SHIFT;
+	last = (start + length - 1) >> PAGE_SHIFT;
+	nr = last - first + 1;
+	vec = frame_vector_create(nr);
+	if (!vec)
+		return ERR_PTR(-ENOMEM);
+	ret = get_vaddr_frames(start, nr, write, 1, vec);
+	if (ret < 0)
+		goto out_destroy;
+	/* We accept only complete set of PFNs */
+	if (ret != nr) {
+		ret = -EFAULT;
+		goto out_release;
+	}
+	return vec;
+out_release:
+	put_vaddr_frames(vec);
+out_destroy:
+	frame_vector_destroy(vec);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL(vb2_create_framevec);
+
+/**
+ * vb2_destroy_framevec() - release vector of mapped pfns
+ * @vec:	vector of pfns / pages to release
+ *
+ * This releases references to all pages in the vector @vec (if corresponding
+ * pfns are backed by pages) and frees the passed vector.
+ */
+void vb2_destroy_framevec(struct frame_vector *vec)
+{
+	put_vaddr_frames(vec);
+	frame_vector_destroy(vec);
+}
+EXPORT_SYMBOL(vb2_destroy_framevec);
+
+/**
  * vb2_common_vm_open() - increase refcount of the vma
  * @vma:	virtual memory region for the mapping
  *
diff -puN include/media/videobuf2-memops.h~vb2-provide-helpers-for-mapping-virtual-addresses include/media/videobuf2-memops.h
--- a/include/media/videobuf2-memops.h~vb2-provide-helpers-for-mapping-virtual-addresses
+++ a/include/media/videobuf2-memops.h
@@ -15,6 +15,7 @@
 #define _MEDIA_VIDEOBUF2_MEMOPS_H
 
 #include <media/videobuf2-core.h>
+#include <linux/mm.h>
 
 /**
  * vb2_vmarea_handler - common vma refcount tracking handler
@@ -36,5 +37,9 @@ int vb2_get_contig_userptr(unsigned long
 struct vm_area_struct *vb2_get_vma(struct vm_area_struct *vma);
 void vb2_put_vma(struct vm_area_struct *vma);
 
+struct frame_vector *vb2_create_framevec(unsigned long start,
+					 unsigned long length,
+					 bool write);
+void vb2_destroy_framevec(struct frame_vector *vec);
 
 #endif
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
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

