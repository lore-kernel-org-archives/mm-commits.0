From: akpm@linux-foundation.org
Subject: - final-removal-of-fastcall-fastcall.patch removed from -mm tree
Date: Thu, 14 Feb 2008 14:15:40 -0500
Message-ID: <200802150218.m1F2IxEx014968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45463 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758500AbYBOCTb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 21:19:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Final removal of FASTCALL()/fastcall
has been removed from the -mm tree.  Its filename was
     final-removal-of-fastcall-fastcall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Final removal of FASTCALL()/fastcall
From: Harvey Harrison <harvey.harrison@gmail.com>

All users are gone, remove definitions and comments referring
to them.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/i830_dma.c   |    2 +-
 include/asm-mn10300/highmem.h |    4 ++--
 include/asm-mn10300/linkage.h |    2 --
 include/linux/irq.h           |    1 -
 include/linux/linkage.h       |    5 -----
 5 files changed, 3 insertions(+), 11 deletions(-)

diff -puN drivers/char/drm/i830_dma.c~final-removal-of-fastcall-fastcall drivers/char/drm/i830_dma.c
--- a/drivers/char/drm/i830_dma.c~final-removal-of-fastcall-fastcall
+++ a/drivers/char/drm/i830_dma.c
@@ -36,7 +36,7 @@
 #include "i830_drm.h"
 #include "i830_drv.h"
 #include <linux/interrupt.h>	/* For task queue support */
-#include <linux/pagemap.h>	/* For FASTCALL on unlock_page() */
+#include <linux/pagemap.h>
 #include <linux/delay.h>
 #include <asm/uaccess.h>
 
diff -puN include/asm-mn10300/highmem.h~final-removal-of-fastcall-fastcall include/asm-mn10300/highmem.h
--- a/include/asm-mn10300/highmem.h~final-removal-of-fastcall-fastcall
+++ a/include/asm-mn10300/highmem.h
@@ -42,8 +42,8 @@ extern void __init kmap_init(void);
 #define PKMAP_NR(virt)  ((virt - PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
 
-extern unsigned long __fastcall kmap_high(struct page *page);
-extern void __fastcall kunmap_high(struct page *page);
+extern unsigned long kmap_high(struct page *page);
+extern void kunmap_high(struct page *page);
 
 static inline unsigned long kmap(struct page *page)
 {
diff -puN include/asm-mn10300/linkage.h~final-removal-of-fastcall-fastcall include/asm-mn10300/linkage.h
--- a/include/asm-mn10300/linkage.h~final-removal-of-fastcall-fastcall
+++ a/include/asm-mn10300/linkage.h
@@ -13,8 +13,6 @@
 
 /* don't override anything */
 #define asmlinkage
-#define FASTCALL(x) x
-#define fastcall
 
 #define __ALIGN		.align 4,0xcb
 #define __ALIGN_STR	".align 4,0xcb"
diff -puN include/linux/irq.h~final-removal-of-fastcall-fastcall include/linux/irq.h
--- a/include/linux/irq.h~final-removal-of-fastcall-fastcall
+++ a/include/linux/irq.h
@@ -285,7 +285,6 @@ extern void handle_bad_irq(unsigned int 
 
 /*
  * Monolithic do_IRQ implementation.
- * (is an explicit fastcall, because i386 4KSTACKS calls it from assembly)
  */
 #ifndef CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ
 extern unsigned int __do_IRQ(unsigned int irq);
diff -puN include/linux/linkage.h~final-removal-of-fastcall-fastcall include/linux/linkage.h
--- a/include/linux/linkage.h~final-removal-of-fastcall-fastcall
+++ a/include/linux/linkage.h
@@ -73,9 +73,4 @@
 #define ATTRIB_NORET  __attribute__((noreturn))
 #define NORET_AND     noreturn,
 
-#ifndef FASTCALL
-#define FASTCALL(x)	x
-#define fastcall
-#endif
-
 #endif
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
inotify-make-variables-static-in-inotify_userc.patch
kernel-doc-remove-fastcall.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
ubi-fix-sparse-errors-in-ubih.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
jbd-sparse-warnings-in-revokec-journalc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
