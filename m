From: akpm@linux-foundation.org
Subject: + mm-rename-alloc_pages_exact.patch added to -mm tree
Date: Mon, 18 Apr 2011 11:49:27 -0700
Message-ID: <201104181849.p3IInRlH018640@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756346Ab1DRSu6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 14:50:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dave@linux.vnet.ibm.com, ak@linux.intel.com, mel@csn.ul.ie, rientjes@google.com, timur@freescale.com


The patch titled
     mm: rename alloc_pages_exact()
has been added to the -mm tree.  Its filename is
     mm-rename-alloc_pages_exact.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: rename alloc_pages_exact()
From: Dave Hansen <dave@linux.vnet.ibm.com>

alloc_pages_exact() returns a virtual address.  But, alloc_pages() returns
a 'struct page *'.  That makes for very confused kernel hackers.

__get_free_pages(), on the other hand, returns virtual addresses.  That
makes alloc_pages_exact() a much closer match to __get_free_pages(), so
rename it to get_free_pages_exact().  Also change the arguments to have
flags first, just like __get_free_pages().

Note that alloc_pages_exact()'s partner, free_pages_exact() already
matches free_pages(), so we do not have to touch the free side of things.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Timur Tabi <timur@freescale.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fsl-diu-fb.c  |    2 +-
 drivers/video/mxsfb.c       |    2 +-
 drivers/video/pxafb.c       |    6 +++---
 drivers/virtio/virtio_pci.c |    2 +-
 include/linux/gfp.h         |    2 +-
 kernel/profile.c            |    4 ++--
 mm/page_alloc.c             |   18 +++++++++---------
 mm/page_cgroup.c            |    2 +-
 8 files changed, 19 insertions(+), 19 deletions(-)

diff -puN drivers/video/fsl-diu-fb.c~mm-rename-alloc_pages_exact drivers/video/fsl-diu-fb.c
--- a/drivers/video/fsl-diu-fb.c~mm-rename-alloc_pages_exact
+++ a/drivers/video/fsl-diu-fb.c
@@ -294,7 +294,7 @@ static void *fsl_diu_alloc(size_t size, 
 
 	pr_debug("size=%zu\n", size);
 
-	virt = alloc_pages_exact(size, GFP_DMA | __GFP_ZERO);
+	virt = get_free_pages_exact(GFP_DMA | __GFP_ZERO, size);
 	if (virt) {
 		*phys = virt_to_phys(virt);
 		pr_debug("virt=%p phys=%llx\n", virt,
diff -puN drivers/video/mxsfb.c~mm-rename-alloc_pages_exact drivers/video/mxsfb.c
--- a/drivers/video/mxsfb.c~mm-rename-alloc_pages_exact
+++ a/drivers/video/mxsfb.c
@@ -718,7 +718,7 @@ static int __devinit mxsfb_init_fbinfo(s
 	} else {
 		if (!fb_size)
 			fb_size = SZ_2M; /* default */
-		fb_virt = alloc_pages_exact(fb_size, GFP_DMA);
+		fb_virt = get_free_pages_exact(GFP_DMA, fb_size);
 		if (!fb_virt)
 			return -ENOMEM;
 
diff -puN drivers/video/pxafb.c~mm-rename-alloc_pages_exact drivers/video/pxafb.c
--- a/drivers/video/pxafb.c~mm-rename-alloc_pages_exact
+++ a/drivers/video/pxafb.c
@@ -905,8 +905,8 @@ static int __devinit pxafb_overlay_map_v
 	/* We assume that user will use at most video_mem_size for overlay fb,
 	 * anyway, it's useless to use 16bpp main plane and 24bpp overlay
 	 */
-	ofb->video_mem = alloc_pages_exact(PAGE_ALIGN(pxafb->video_mem_size),
-		GFP_KERNEL | __GFP_ZERO);
+	ofb->video_mem = get_free_pages_exact(GFP_KERNEL | __GFP_ZERO,
+		PAGE_ALIGN(pxafb->video_mem_size));
 	if (ofb->video_mem == NULL)
 		return -ENOMEM;
 
@@ -1716,7 +1716,7 @@ static int __devinit pxafb_init_video_me
 {
 	int size = PAGE_ALIGN(fbi->video_mem_size);
 
-	fbi->video_mem = alloc_pages_exact(size, GFP_KERNEL | __GFP_ZERO);
+	fbi->video_mem = get_free_pages_exact(GFP_KERNEL | __GFP_ZERO, size);
 	if (fbi->video_mem == NULL)
 		return -ENOMEM;
 
diff -puN drivers/virtio/virtio_pci.c~mm-rename-alloc_pages_exact drivers/virtio/virtio_pci.c
--- a/drivers/virtio/virtio_pci.c~mm-rename-alloc_pages_exact
+++ a/drivers/virtio/virtio_pci.c
@@ -385,7 +385,7 @@ static struct virtqueue *setup_vq(struct
 	info->msix_vector = msix_vec;
 
 	size = PAGE_ALIGN(vring_size(num, VIRTIO_PCI_VRING_ALIGN));
-	info->queue = alloc_pages_exact(size, GFP_KERNEL|__GFP_ZERO);
+	info->queue = get_free_pages_exact(GFP_KERNEL|__GFP_ZERO, size);
 	if (info->queue == NULL) {
 		err = -ENOMEM;
 		goto out_info;
diff -puN include/linux/gfp.h~mm-rename-alloc_pages_exact include/linux/gfp.h
--- a/include/linux/gfp.h~mm-rename-alloc_pages_exact
+++ a/include/linux/gfp.h
@@ -346,7 +346,7 @@ extern struct page *alloc_pages_vma(gfp_
 extern unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order);
 extern unsigned long get_zeroed_page(gfp_t gfp_mask);
 
-void *alloc_pages_exact(size_t size, gfp_t gfp_mask);
+void *get_free_pages_exact(gfp_t gfp_mask, size_t size);
 void free_pages_exact(void *virt, size_t size);
 
 #define __get_free_page(gfp_mask) \
diff -puN kernel/profile.c~mm-rename-alloc_pages_exact kernel/profile.c
--- a/kernel/profile.c~mm-rename-alloc_pages_exact
+++ a/kernel/profile.c
@@ -121,8 +121,8 @@ int __ref profile_init(void)
 	if (prof_buffer)
 		return 0;
 
-	prof_buffer = alloc_pages_exact(buffer_bytes,
-					GFP_KERNEL|__GFP_ZERO|__GFP_NOWARN);
+	prof_buffer = get_free_pages_exact(GFP_KERNEL|__GFP_ZERO|__GFP_NOWARN,
+					buffer_bytes);
 	if (prof_buffer)
 		return 0;
 
diff -puN mm/page_alloc.c~mm-rename-alloc_pages_exact mm/page_alloc.c
--- a/mm/page_alloc.c~mm-rename-alloc_pages_exact
+++ a/mm/page_alloc.c
@@ -2319,7 +2319,7 @@ void free_pages(unsigned long addr, unsi
 EXPORT_SYMBOL(free_pages);
 
 /**
- * alloc_pages_exact - allocate an exact number physically-contiguous pages.
+ * get_free_pages_exact - allocate an exact number physically-contiguous pages.
  * @size: the number of bytes to allocate
  * @gfp_mask: GFP flags for the allocation
  *
@@ -2331,7 +2331,7 @@ EXPORT_SYMBOL(free_pages);
  *
  * Memory allocated by this function must be released by free_pages_exact().
  */
-void *alloc_pages_exact(size_t size, gfp_t gfp_mask)
+void *get_free_pages_exact(gfp_t gfp_mask, size_t size)
 {
 	unsigned int order = get_order(size);
 	unsigned long addr;
@@ -2350,14 +2350,14 @@ void *alloc_pages_exact(size_t size, gfp
 
 	return (void *)addr;
 }
-EXPORT_SYMBOL(alloc_pages_exact);
+EXPORT_SYMBOL(get_free_pages_exact);
 
 /**
- * free_pages_exact - release memory allocated via alloc_pages_exact()
- * @virt: the value returned by alloc_pages_exact.
- * @size: size of allocation, same value as passed to alloc_pages_exact().
+ * free_pages_exact - release memory allocated via get_free_pages_exact()
+ * @virt: the value returned by get_free_pages_exact.
+ * @size: size of allocation, same value as passed to get_free_pages_exact().
  *
- * Release the memory allocated by a previous call to alloc_pages_exact.
+ * Release the memory allocated by a previous call to get_free_pages_exact().
  */
 void free_pages_exact(void *virt, size_t size)
 {
@@ -5304,10 +5304,10 @@ void *__init alloc_large_system_hash(con
 			/*
 			 * If bucketsize is not a power-of-two, we may free
 			 * some pages at the end of hash table which
-			 * alloc_pages_exact() automatically does
+			 * get_free_pages_exact() automatically does
 			 */
 			if (get_order(size) < MAX_ORDER) {
-				table = alloc_pages_exact(size, GFP_ATOMIC);
+				table = get_free_pages_exact(GFP_ATOMIC, size);
 				kmemleak_alloc(table, size, 1, GFP_ATOMIC);
 			}
 		}
diff -puN mm/page_cgroup.c~mm-rename-alloc_pages_exact mm/page_cgroup.c
--- a/mm/page_cgroup.c~mm-rename-alloc_pages_exact
+++ a/mm/page_cgroup.c
@@ -134,7 +134,7 @@ static void *__init_refok alloc_page_cgr
 {
 	void *addr = NULL;
 
-	addr = alloc_pages_exact(size, GFP_KERNEL | __GFP_NOWARN);
+	addr = get_free_pages_exact(GFP_KERNEL | __GFP_NOWARN, size);
 	if (addr)
 		return addr;
 
_

Patches currently in -mm which might be from dave@linux.vnet.ibm.com are

origin.patch
mm-increase-reclaim_distance-to-30.patch
mm-convert-vma-vm_flags-to-64-bit.patch
mm-add-__nocast-attribute-to-vm_flags.patch
fremap-convert-vm_flags-to-unsigned-long-long.patch
procfs-convert-vm_flags-to-unsigned-long-long.patch
include-linux-gfph-work-around-apparent-sparse-confusion.patch
mm-rename-alloc_pages_exact.patch
mm-make-new-alloc_pages_exact.patch
mm-reuse-__free_pages_exact-in-__alloc_pages_exact.patch

