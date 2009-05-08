From: akpm@linux-foundation.org
Subject: + videobuf-dma-contig-zero-copy-userptr-support-v3.patch added to -mm tree
Date: Fri, 08 May 2009 13:07:06 -0700
Message-ID: <200905082007.n48K76pN021565@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753670AbZEHULS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 May 2009 16:11:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damm@igel.co.jp, hannes@cmpxchg.org, hverkuil@xs4all.nl, lethal@linux-sh.org, mchehab@infradead.org


The patch titled
     videobuf-dma-contig: zero copy USERPTR support
has been added to the -mm tree.  Its filename is
     videobuf-dma-contig-zero-copy-userptr-support-v3.patch

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
Subject: videobuf-dma-contig: zero copy USERPTR support
From: Magnus Damm <damm@igel.co.jp>

Since videobuf-dma-contig is designed to handle physically contiguous
memory, this patch modifies the videobuf-dma-contig code to only accept a
user space pointer to physically contiguous memory.  For now only
VM_PFNMAP vmas are supported, so forget hotplug.

On SuperH Mobile we use this with our sh_mobile_ceu_camera driver together
with various multimedia accelerator blocks that are exported to user space
using UIO.  The UIO kernel code exports physically contiguous memory to
user space and lets the user space application mmap() this memory and pass
a pointer using the USERPTR interface for V4L2 zero copy operation.

With this approach we support zero copy capture, hardware scaling and
various forms of hardware encoding and decoding.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/videobuf-dma-contig.c |   78 ++++++++++++++++++--
 1 file changed, 73 insertions(+), 5 deletions(-)

diff -puN drivers/media/video/videobuf-dma-contig.c~videobuf-dma-contig-zero-copy-userptr-support-v3 drivers/media/video/videobuf-dma-contig.c
--- a/drivers/media/video/videobuf-dma-contig.c~videobuf-dma-contig-zero-copy-userptr-support-v3
+++ a/drivers/media/video/videobuf-dma-contig.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/pagemap.h>
 #include <linux/dma-mapping.h>
 #include <media/videobuf-dma-contig.h>
 
@@ -25,6 +26,7 @@ struct videobuf_dma_contig_memory {
 	void *vaddr;
 	dma_addr_t dma_handle;
 	unsigned long size;
+	int is_userptr;
 };
 
 #define MAGIC_DC_MEM 0x0733ac61
@@ -108,6 +110,66 @@ static struct vm_operations_struct video
 	.close    = videobuf_vm_close,
 };
 
+static void videobuf_dma_contig_user_put(struct videobuf_dma_contig_memory *mem)
+{
+	mem->is_userptr = 0;
+	mem->dma_handle = 0;
+	mem->size = 0;
+}
+
+static int videobuf_dma_contig_user_get(struct videobuf_dma_contig_memory *mem,
+					struct videobuf_buffer *vb)
+{
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma;
+	unsigned long prev_pfn, this_pfn;
+	unsigned long pages_done, user_address;
+	int ret;
+
+	mem->size = PAGE_ALIGN(vb->size);
+	mem->is_userptr = 0;
+	ret = -EINVAL;
+
+	down_read(&mm->mmap_sem);
+
+	vma = find_vma(mm, vb->baddr);
+	if (!vma)
+		goto out_up;
+
+	if ((vb->baddr + mem->size) > vma->vm_end)
+		goto out_up;
+
+	pages_done = 0;
+	prev_pfn = 0; /* kill warning */
+	user_address = vb->baddr;
+
+	while (pages_done < (mem->size >> PAGE_SHIFT)) {
+		ret = follow_pfn(vma, user_address, &this_pfn);
+		if (ret)
+			break;
+
+		if (pages_done == 0)
+			mem->dma_handle = this_pfn << PAGE_SHIFT;
+		else if (this_pfn != (prev_pfn + 1))
+			ret = -EFAULT;
+
+		if (ret)
+			break;
+
+		prev_pfn = this_pfn;
+		user_address += PAGE_SIZE;
+		pages_done++;
+	}
+
+	if (!ret)
+		mem->is_userptr = 1;
+
+ out_up:
+	up_read(&current->mm->mmap_sem);
+
+	return ret;
+}
+
 static void *__videobuf_alloc(size_t size)
 {
 	struct videobuf_dma_contig_memory *mem;
@@ -154,12 +216,11 @@ static int __videobuf_iolock(struct vide
 	case V4L2_MEMORY_USERPTR:
 		dev_dbg(q->dev, "%s memory method USERPTR\n", __func__);
 
-		/* The only USERPTR currently supported is the one needed for
-		   read() method.
-		 */
+		/* handle pointer from user space */
 		if (vb->baddr)
-			return -EINVAL;
+			return videobuf_dma_contig_user_get(mem, vb);
 
+		/* allocate memory for the read() method */
 		mem->size = PAGE_ALIGN(vb->size);
 		mem->vaddr = dma_alloc_coherent(q->dev, mem->size,
 						&mem->dma_handle, GFP_KERNEL);
@@ -400,7 +461,7 @@ void videobuf_dma_contig_free(struct vid
 	   So, it should free memory only if the memory were allocated for
 	   read() operation.
 	 */
-	if ((buf->memory != V4L2_MEMORY_USERPTR) || buf->baddr)
+	if (buf->memory != V4L2_MEMORY_USERPTR)
 		return;
 
 	if (!mem)
@@ -408,6 +469,13 @@ void videobuf_dma_contig_free(struct vid
 
 	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
 
+	/* handle user space pointer case */
+	if (buf->baddr) {
+		videobuf_dma_contig_user_put(mem);
+		return;
+	}
+
+	/* read() method */
 	dma_free_coherent(q->dev, mem->size, mem->vaddr, mem->dma_handle);
 	mem->vaddr = NULL;
 }
_

Patches currently in -mm which might be from damm@igel.co.jp are

linux-next.patch
videobuf-dma-contig-zero-copy-userptr-support-v3.patch

