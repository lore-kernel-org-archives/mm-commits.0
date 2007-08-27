From: akpm@linux-foundation.org
Subject: + vfb-make-virtual-framebuffer-mmapable.patch added to -mm tree
Date: Mon, 27 Aug 2007 15:23:56 -0700
Message-ID: <200708272223.l7RMNuto031695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36648 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758171AbXH0WX7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 18:23:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ilya.yanok@gmail.com, adaplas@gmail.com


The patch titled
     vfb: make virtual framebuffer mmapable
has been added to the -mm tree.  Its filename is
     vfb-make-virtual-framebuffer-mmapable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vfb: make virtual framebuffer mmapable
From: Ilya Yanok <ilya.yanok@gmail.com>

Changed things:

1. vmalloc()/vfree() replaced with rvmalloc()/rvfree() (taken from
   drivers/media/video/se401.c)

2. mmap method implemented (mostly taken from drivers/media/video/se401.c)

3. smem_start and smem_len fields of struct fb_fix_screeninfo initialized.
    (smem_start initialized with virtual address, don't know if it is really
   bad...)

[adaplas: sparse warning fix]
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/vfb.c |   78 +++++++++++++++++++++++++++++++++++++++---
 1 files changed, 74 insertions(+), 4 deletions(-)

diff -puN drivers/video/vfb.c~vfb-make-virtual-framebuffer-mmapable drivers/video/vfb.c
--- a/drivers/video/vfb.c~vfb-make-virtual-framebuffer-mmapable
+++ a/drivers/video/vfb.c
@@ -37,6 +37,48 @@ static void *videomemory;
 static u_long videomemorysize = VIDEOMEMSIZE;
 module_param(videomemorysize, ulong, 0);
 
+/**********************************************************************
+ *
+ * Memory management
+ *
+ **********************************************************************/
+static void *rvmalloc(unsigned long size)
+{
+	void *mem;
+	unsigned long adr;
+
+	size = PAGE_ALIGN(size);
+	mem = vmalloc_32(size);
+	if (!mem)
+		return NULL;
+
+	memset(mem, 0, size); /* Clear the ram out, no junk to the user */
+	adr = (unsigned long) mem;
+	while (size > 0) {
+		SetPageReserved(vmalloc_to_page((void *)adr));
+		adr += PAGE_SIZE;
+		size -= PAGE_SIZE;
+	}
+
+	return mem;
+}
+
+static void rvfree(void *mem, unsigned long size)
+{
+	unsigned long adr;
+
+	if (!mem)
+		return;
+
+	adr = (unsigned long) mem;
+	while ((long) size > 0) {
+		ClearPageReserved(vmalloc_to_page((void *)adr));
+		adr += PAGE_SIZE;
+		size -= PAGE_SIZE;
+	}
+	vfree(mem);
+}
+
 static struct fb_var_screeninfo vfb_default __initdata = {
 	.xres =		640,
 	.yres =		480,
@@ -371,7 +413,33 @@ static int vfb_pan_display(struct fb_var
 static int vfb_mmap(struct fb_info *info,
 		    struct vm_area_struct *vma)
 {
-	return -EINVAL;
+	unsigned long start = vma->vm_start;
+	unsigned long size = vma->vm_end - vma->vm_start;
+	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
+	unsigned long page, pos;
+
+	if (offset + size > info->fix.smem_len) {
+		return -EINVAL;
+	}
+
+	pos = (unsigned long)info->fix.smem_start + offset;
+
+	while (size > 0) {
+		page = vmalloc_to_pfn((void *)pos);
+		if (remap_pfn_range(vma, start, page, PAGE_SIZE, PAGE_SHARED)) {
+			return -EAGAIN;
+		}
+		start += PAGE_SIZE;
+		pos += PAGE_SIZE;
+		if (size > PAGE_SIZE)
+			size -= PAGE_SIZE;
+		else
+			size = 0;
+	}
+
+	vma->vm_flags |= VM_RESERVED;	/* avoid to swap out this VMA */
+	return 0;
+
 }
 
 #ifndef MODULE
@@ -406,7 +474,7 @@ static int __init vfb_probe(struct platf
 	/*
 	 * For real video cards we use ioremap.
 	 */
-	if (!(videomemory = vmalloc(videomemorysize)))
+	if (!(videomemory = rvmalloc(videomemorysize)))
 		return retval;
 
 	/*
@@ -429,6 +497,8 @@ static int __init vfb_probe(struct platf
 
 	if (!retval || (retval == 4))
 		info->var = vfb_default;
+	vfb_fix.smem_start = (unsigned long) videomemory;
+	vfb_fix.smem_len = videomemorysize;
 	info->fix = vfb_fix;
 	info->pseudo_palette = info->par;
 	info->par = NULL;
@@ -452,7 +522,7 @@ err2:
 err1:
 	framebuffer_release(info);
 err:
-	vfree(videomemory);
+	rvfree(videomemory, videomemorysize);
 	return retval;
 }
 
@@ -462,7 +532,7 @@ static int vfb_remove(struct platform_de
 
 	if (info) {
 		unregister_framebuffer(info);
-		vfree(videomemory);
+		rvfree(videomemory, videomemorysize);
 		framebuffer_release(info);
 	}
 	return 0;
_

Patches currently in -mm which might be from ilya.yanok@gmail.com are

vfb-make-virtual-framebuffer-mmapable.patch
