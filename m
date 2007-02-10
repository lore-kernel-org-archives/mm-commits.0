From: akpm@linux-foundation.org
Subject: - drivers-add-lcd-support-update-8.patch removed from -mm tree
Date: Sat, 10 Feb 2007 00:10:36 -0800
Message-ID: <200702100810.l1A8AaSX006947@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39272 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbXBJIKn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 03:10:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maxextreme@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers: add LCD support (update 8)
has been removed from the -mm tree.  Its filename was
     drivers-add-lcd-support-update-8.patch

This patch was dropped because it was folded into drivers-add-lcd-support-3.patch

------------------------------------------------------
Subject: drivers: add LCD support (update 8)
From: Miguel Ojeda Sandonis <maxextreme@gmail.com>

 - add "depends on x86" until some solution to d-cache
   aliasing is provided

 - use the new and simpler vm_insert_page()
     instead of nopage() related code

Signed-off-by: Miguel Ojeda Sandonis <maxextreme@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/auxdisplay/Kconfig        |    1 +
 drivers/auxdisplay/cfag12864bfb.c |   21 ++-------------------
 2 files changed, 3 insertions(+), 19 deletions(-)

diff -puN drivers/auxdisplay/Kconfig~drivers-add-lcd-support-update-8 drivers/auxdisplay/Kconfig
--- a/drivers/auxdisplay/Kconfig~drivers-add-lcd-support-update-8
+++ a/drivers/auxdisplay/Kconfig
@@ -64,6 +64,7 @@ config KS0108_DELAY
 
 config CFAG12864B
 	tristate "CFAG12864B LCD"
+	depends on X86
 	depends on KS0108
 	default n
 	---help---
diff -puN drivers/auxdisplay/cfag12864bfb.c~drivers-add-lcd-support-update-8 drivers/auxdisplay/cfag12864bfb.c
--- a/drivers/auxdisplay/cfag12864bfb.c~drivers-add-lcd-support-update-8
+++ a/drivers/auxdisplay/cfag12864bfb.c
@@ -65,27 +65,10 @@ static struct fb_var_screeninfo cfag1286
 	.vmode = FB_VMODE_NONINTERLACED,
 };
 
-static struct page *cfag12864bfb_vma_nopage(struct vm_area_struct *vma,
-	unsigned long address, int *type)
-{
-	struct page *page = virt_to_page(cfag12864b_buffer);
-	get_page(page);
-
-	if (type)
-		*type = VM_FAULT_MINOR;
-
-	return page;
-}
-
-static struct vm_operations_struct cfag12864bfb_vm_ops = {
-	.nopage = cfag12864bfb_vma_nopage,
-};
-
 static int cfag12864bfb_mmap(struct fb_info *info, struct vm_area_struct *vma)
 {
-	vma->vm_ops = &cfag12864bfb_vm_ops;
-	vma->vm_flags |= VM_RESERVED;
-	return 0;
+	return vm_insert_page(vma, vma->vm_start,
+		virt_to_page(cfag12864b_buffer));
 }
 
 static struct fb_ops cfag12864bfb_ops = {
_

Patches currently in -mm which might be from maxextreme@gmail.com are

drivers-add-lcd-support-3.patch
drivers-add-lcd-support-update-8.patch
drivers-add-lcd-support-update-9.patch
drivers-add-lcd-support-workqueue-fixups.patch
