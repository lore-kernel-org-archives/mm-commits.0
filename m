From: akpm@linux-foundation.org
Subject: - cris-v10-vmlinuxldss-fix-kernel-oops-on-boot-and-use-common-defines.patch removed from -mm tree
Date: Sat, 19 Jan 2008 23:04:44 -0800
Message-ID: <200801200704.m0K74OgU007802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54330 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753704AbYATHEe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 Jan 2008 02:04:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.nilsson@axis.com, mikael.starvik@axis.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     CRIS v10: vmlinux.lds.S: ix kernel oops on boot and use common defines
has been removed from the -mm tree.  Its filename was
     cris-v10-vmlinuxldss-fix-kernel-oops-on-boot-and-use-common-defines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: CRIS v10: vmlinux.lds.S: ix kernel oops on boot and use common defines
From: Jesper Nilsson <jesper.nilsson@axis.com>

- Move alignment to page size of init data outside ifdef for BLK_DEV_INITRD.
  The reservation up to page size of memory after init data was previously
  not done if BLK_DEV_INITRD was undefined.
  This caused a kernel oops when init memory pages were freed after startup,
  data placed in the same page as the last init memory would also be freed
  and reused, with disastrous results.

- Use macros for initcalls and .text sections.

- Replace hardcoded page size constant with PAGE_SIZE define.

- Change include/asm-cris/page.h to use the _AC macro to instead
  of testing __ASSEMBLY__.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Mikael Starvik <mikael.starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/vmlinux.lds.S |   33 +++++++++++++----------------
 include/asm-cris/page.h          |    7 +-----
 2 files changed, 17 insertions(+), 23 deletions(-)

diff -puN arch/cris/arch-v10/vmlinux.lds.S~cris-v10-vmlinuxldss-fix-kernel-oops-on-boot-and-use-common-defines arch/cris/arch-v10/vmlinux.lds.S
--- a/arch/cris/arch-v10/vmlinux.lds.S~cris-v10-vmlinuxldss-fix-kernel-oops-on-boot-and-use-common-defines
+++ a/arch/cris/arch-v10/vmlinux.lds.S
@@ -9,7 +9,8 @@
  */	
 
 #include <asm-generic/vmlinux.lds.h>
-		
+#include <asm/page.h>
+
 jiffies = jiffies_64;
 SECTIONS
 {
@@ -23,7 +24,7 @@ SECTIONS
 	_stext = .;
 	__stext = .;
 	.text : {
-		*(.text)
+		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
 		*(.fixup)
@@ -49,10 +50,10 @@ SECTIONS
 	__edata = . ;                 /* End of data section */
 	_edata = . ;
 
-	. = ALIGN(8192);              /* init_task and stack, must be aligned */
+	. = ALIGN(PAGE_SIZE);	/* init_task and stack, must be aligned */
   	.data.init_task : { *(.data.init_task) }
 
-  	. = ALIGN(8192);              /* Init code and data */
+	. = ALIGN(PAGE_SIZE);	/* Init code and data */
   	__init_begin = .;
 	.init.text : { 
 		   _sinittext = .;
@@ -66,13 +67,7 @@ SECTIONS
   	__setup_end = .;
   	.initcall.init : {
 		__initcall_start = .;
-		*(.initcall1.init);
-		*(.initcall2.init);
-		*(.initcall3.init);
-		*(.initcall4.init);
-		*(.initcall5.init);
-		*(.initcall6.init);
-		*(.initcall7.init);
+		INITCALLS
 		__initcall_end = .;	
 	}
 
@@ -88,16 +83,18 @@ SECTIONS
 		__initramfs_start = .;
 		*(.init.ramfs)
 		__initramfs_end = .;
-		/* We fill to the next page, so we can discard all init
-		   pages without needing to consider what payload might be
-		   appended to the kernel image.  */
-		FILL (0); 
-		. = ALIGN (8192);
 	}
 #endif
-	
 	__vmlinux_end = .;            /* last address of the physical file */
-  	__init_end = .;
+
+	/*
+	 * We fill to the next page, so we can discard all init
+	 * pages without needing to consider what payload might be
+	 * appended to the kernel image.
+	 */
+	. = ALIGN(PAGE_SIZE);
+
+	__init_end = .;
 
 	__data_end = . ;              /* Move to _edata ? */
 	__bss_start = .;              /* BSS */
diff -puN include/asm-cris/page.h~cris-v10-vmlinuxldss-fix-kernel-oops-on-boot-and-use-common-defines include/asm-cris/page.h
--- a/include/asm-cris/page.h~cris-v10-vmlinuxldss-fix-kernel-oops-on-boot-and-use-common-defines
+++ a/include/asm-cris/page.h
@@ -4,14 +4,11 @@
 #ifdef __KERNEL__
 
 #include <asm/arch/page.h>
+#include <linux/const.h>
 
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT	13
-#ifndef __ASSEMBLY__
-#define PAGE_SIZE	(1UL << PAGE_SHIFT)
-#else
-#define PAGE_SIZE	(1 << PAGE_SHIFT)
-#endif
+#define PAGE_SIZE	(_AC(1, UL) << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
 #define clear_page(page)        memset((void *)(page), 0, PAGE_SIZE)
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

origin.patch
cris-add-missed-local_irq_restore-call.patch
git-kbuild.patch
git-mtd.patch
cris-avoid-using-arch-links-in-kconfig.patch
cris-remove-unused-__dummy-const_addr-and-addr-from-bitopsh.patch
