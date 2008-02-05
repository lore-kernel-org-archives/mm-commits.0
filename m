From: akpm@linux-foundation.org
Subject: - nommu-add-new-vmalloc_user-and-remap_vmalloc_range-interfaces.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:33:40 -0800
Message-ID: <200802052233.m15MXLK3012418@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51934 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761955AbYBEWng (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, david_mccullough@securecomputing.com, dhowells@redhat.com, gerg@snapgear.com, mm-commits@vger.kernel.org


The patch titled
     nommu: add new vmalloc_user() and remap_vmalloc_range() interfaces.
has been removed from the -mm tree.  Its filename was
     nommu-add-new-vmalloc_user-and-remap_vmalloc_range-interfaces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: add new vmalloc_user() and remap_vmalloc_range() interfaces.
From: Paul Mundt <lethal@linux-sh.org>

This builds on top of the earlier vmalloc_32_user() work introduced by
b50731732f926d6c49fd0724616a7344c31cd5cf, as we now have places in the nommu
allmodconfig that hit up against these missing APIs.

As vmalloc_32_user() is already implemented, this is moved over to
vmalloc_user() and simply made a wrapper.  As all current nommu platforms are
32-bit addressable, there's no special casing we have to do for ZONE_DMA and
things of that nature as per GFP_VMALLOC32.

remap_vmalloc_range() needs to check VM_USERMAP in order to figure out whether
we permit the remap or not, which means that we also have to rework the
vmalloc_user() code to grovel for the VMA and set the flag.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: David McCullough <david_mccullough@securecomputing.com>
Acked-by: David Howells <dhowells@redhat.com>
Acked-by: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff -puN mm/nommu.c~nommu-add-new-vmalloc_user-and-remap_vmalloc_range-interfaces mm/nommu.c
--- a/mm/nommu.c~nommu-add-new-vmalloc_user-and-remap_vmalloc_range-interfaces
+++ a/mm/nommu.c
@@ -10,6 +10,7 @@
  *  Copyright (c) 2000-2003 David McCullough <davidm@snapgear.com>
  *  Copyright (c) 2000-2001 D Jeff Dionne <jeff@uClinux.org>
  *  Copyright (c) 2002      Greg Ungerer <gerg@snapgear.com>
+ *  Copyright (c) 2007      Paul Mundt <lethal@linux-sh.org>
  */
 
 #include <linux/module.h>
@@ -183,6 +184,26 @@ void *__vmalloc(unsigned long size, gfp_
 }
 EXPORT_SYMBOL(__vmalloc);
 
+void *vmalloc_user(unsigned long size)
+{
+	void *ret;
+
+	ret = __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
+			PAGE_KERNEL);
+	if (ret) {
+		struct vm_area_struct *vma;
+
+		down_write(&current->mm->mmap_sem);
+		vma = find_vma(current->mm, (unsigned long)ret);
+		if (vma)
+			vma->vm_flags |= VM_USERMAP;
+		up_write(&current->mm->mmap_sem);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(vmalloc_user);
+
 struct page *vmalloc_to_page(const void *addr)
 {
 	return virt_to_page(addr);
@@ -253,10 +274,17 @@ EXPORT_SYMBOL(vmalloc_32);
  *
  * The resulting memory area is 32bit addressable and zeroed so it can be
  * mapped to userspace without leaking data.
+ *
+ * VM_USERMAP is set on the corresponding VMA so that subsequent calls to
+ * remap_vmalloc_range() are permissible.
  */
 void *vmalloc_32_user(unsigned long size)
 {
-	return __vmalloc(size, GFP_KERNEL | __GFP_ZERO, PAGE_KERNEL);
+	/*
+	 * We'll have to sort out the ZONE_DMA bits for 64-bit,
+	 * but for now this can simply use vmalloc_user() directly.
+	 */
+	return vmalloc_user(size);
 }
 EXPORT_SYMBOL(vmalloc_32_user);
 
@@ -1216,6 +1244,21 @@ int remap_pfn_range(struct vm_area_struc
 }
 EXPORT_SYMBOL(remap_pfn_range);
 
+int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
+			unsigned long pgoff)
+{
+	unsigned int size = vma->vm_end - vma->vm_start;
+
+	if (!(vma->vm_flags & VM_USERMAP))
+		return -EINVAL;
+
+	vma->vm_start = (unsigned long)(addr + (pgoff << PAGE_SHIFT));
+	vma->vm_end = vma->vm_start + size;
+
+	return 0;
+}
+EXPORT_SYMBOL(remap_vmalloc_range);
+
 void swap_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
 {
 }
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
timerfd-fix-remaining-architectures.patch
git-sh.patch
kernel-printkc-concerns-about-the-console-handover.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
spi-superh-spi-using-sci.patch
rtc-ds1302-rtc-support.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
fb-defio-nopage.patch
fb-nvidiafb-try-harder-at-initial-mode-setting.patch
sm501fb-control-panel-pin-usage-with-platform-data-flags.patch
sm501fb-clear-framebuffer-memory-and-palette.patch
use-bootmem_exclusive-for-kdump.patch
sanitize-the-type-of-struct-useru_ar0.patch
avoid-overflows-in-kernel-timec.patch
