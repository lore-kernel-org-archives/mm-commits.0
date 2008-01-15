From: akpm@linux-foundation.org
Subject: + cris-v10-vmlinuxldss-fix-kernel-oops-on-boot-and-use-common-defines.patch added to -mm tree
Date: Tue, 15 Jan 2008 12:34:26 -0800
Message-ID: <200801152034.m0FKY6Pg001854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58844 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752158AbYAOUfm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 15:35:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.nilsson@axis.com, mikael.starvik@axis.com, sam@ravnborg.org


The patch titled
     CRIS v10: vmlinux.lds.S: ix kernel oops on boot and use common defines
has been added to the -mm tree.  Its filename is
     cris-v10-vmlinuxldss-fix-kernel-oops-on-boot-and-use-common-defines.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

cris-v10-correct-do_signal-to-fix-oops-and-clean-up-signal-handling-in-general.patch
cris-define-__arch_want_sys_rt_sigsuspend-in-unistdh-for-cris.patch
cris-v10-kernel-timec-needs-to-include-linux-vmstath-to-compile.patch
cris-v10-driver-for-ds1302-needs-to-include-cris-specific-i2ch.patch
cris-v10-vmlinuxldss-fix-kernel-oops-on-boot-and-use-common-defines.patch
git-kbuild.patch
git-mtd.patch
cris-avoid-using-arch-links-in-kconfig.patch
cris-remove-unused-__dummy-const_addr-and-addr-from-bitopsh.patch
avoid-overflows-in-kernel-timec.patch
