From: akpm@linux-foundation.org
Subject: - cleanup-floppyh.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:57:18 -0700
Message-ID: <200710180657.l9I6vIb9030804@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39163 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763290AbXJRHPx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, mm-commits@vger.kernel.org


The patch titled
     cleanup floppy.h
has been removed from the -mm tree.  Its filename was
     cleanup-floppyh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cleanup floppy.h
From: "Jan Beulich" <jbeulich@novell.com>

AUTO_DMA and FLOPPY_MOTOR_MASK in include/asm-*/floppy.h are dead symbols -
remove them.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/floppy.h   |    2 --
 include/asm-arm/floppy.h     |    2 --
 include/asm-m68k/floppy.h    |    3 ---
 include/asm-mips/floppy.h    |    2 --
 include/asm-parisc/floppy.h  |    4 ----
 include/asm-powerpc/floppy.h |    2 --
 include/asm-ppc/floppy.h     |    2 --
 include/asm-sh/floppy.h      |    4 ----
 include/asm-sparc/floppy.h   |    2 --
 include/asm-sparc64/floppy.h |    4 ----
 include/asm-x86/floppy_32.h  |    4 ----
 include/asm-x86/floppy_64.h  |    4 ----
 12 files changed, 35 deletions(-)

diff -puN include/asm-alpha/floppy.h~cleanup-floppyh include/asm-alpha/floppy.h
--- a/include/asm-alpha/floppy.h~cleanup-floppyh
+++ a/include/asm-alpha/floppy.h
@@ -91,8 +91,6 @@ static int FDC2 = -1;
 #define N_FDC 2
 #define N_DRIVE 8
 
-#define FLOPPY_MOTOR_MASK 0xf0
-
 /*
  * Most Alphas have no problems with floppy DMA crossing 64k borders,
  * except for certain ones, like XL and RUFFIAN.
diff -puN include/asm-arm/floppy.h~cleanup-floppyh include/asm-arm/floppy.h
--- a/include/asm-arm/floppy.h~cleanup-floppyh
+++ a/include/asm-arm/floppy.h
@@ -128,8 +128,6 @@ static inline void fd_scandrives (void)
 #define N_FDC 1
 #define N_DRIVE 4
 
-#define FLOPPY_MOTOR_MASK 0xf0
-
 #define CROSS_64KB(a,s) (0)
 
 /*
diff -puN include/asm-m68k/floppy.h~cleanup-floppyh include/asm-m68k/floppy.h
--- a/include/asm-m68k/floppy.h~cleanup-floppyh
+++ a/include/asm-m68k/floppy.h
@@ -31,9 +31,6 @@ asmlinkage irqreturn_t floppy_hardint(in
 #define FLOPPY0_TYPE (MACH_IS_Q40 ? 6 : 4)
 #define FLOPPY1_TYPE 0
 
-#define FLOPPY_MOTOR_MASK 0xf0
-
-
 /* basically PC init + set use_virtual_dma */
 #define  FDC1 m68k_floppy_init()
 
diff -puN include/asm-mips/floppy.h~cleanup-floppyh include/asm-mips/floppy.h
--- a/include/asm-mips/floppy.h~cleanup-floppyh
+++ a/include/asm-mips/floppy.h
@@ -34,8 +34,6 @@ static inline void fd_cacheflush(char * 
 #define N_FDC 1			/* do you *really* want a second controller? */
 #define N_DRIVE 8
 
-#define FLOPPY_MOTOR_MASK 0xf0
-
 /*
  * The DMA channel used by the floppy controller cannot access data at
  * addresses >= 16MB
diff -puN include/asm-parisc/floppy.h~cleanup-floppyh include/asm-parisc/floppy.h
--- a/include/asm-parisc/floppy.h~cleanup-floppyh
+++ a/include/asm-parisc/floppy.h
@@ -266,10 +266,6 @@ static int FDC2 = -1;
 #define N_FDC 1
 #define N_DRIVE 8
 
-#define FLOPPY_MOTOR_MASK 0xf0
-
-#define AUTO_DMA
-
 #define EXTRA_FLOPPY_PARAMS
 
 #endif /* __ASM_PARISC_FLOPPY_H */
diff -puN include/asm-powerpc/floppy.h~cleanup-floppyh include/asm-powerpc/floppy.h
--- a/include/asm-powerpc/floppy.h~cleanup-floppyh
+++ a/include/asm-powerpc/floppy.h
@@ -202,8 +202,6 @@ static int FDC2 = -1;
 #define N_FDC 2			/* Don't change this! */
 #define N_DRIVE 8
 
-#define FLOPPY_MOTOR_MASK 0xf0
-
 /*
  * The PowerPC has no problems with floppy DMA crossing 64k borders.
  */
diff -puN include/asm-ppc/floppy.h~cleanup-floppyh include/asm-ppc/floppy.h
--- a/include/asm-ppc/floppy.h~cleanup-floppyh
+++ a/include/asm-ppc/floppy.h
@@ -166,8 +166,6 @@ static int FDC2 = -1;
 #define N_FDC 2			/* Don't change this! */
 #define N_DRIVE 8
 
-#define FLOPPY_MOTOR_MASK 0xf0
-
 /*
  * The PowerPC has no problems with floppy DMA crossing 64k borders.
  */
diff -puN include/asm-sh/floppy.h~cleanup-floppyh include/asm-sh/floppy.h
--- a/include/asm-sh/floppy.h~cleanup-floppyh
+++ a/include/asm-sh/floppy.h
@@ -263,10 +263,6 @@ static int FDC2 = -1;
 #define N_FDC 2
 #define N_DRIVE 8
 
-#define FLOPPY_MOTOR_MASK 0xf0
-
-#define AUTO_DMA
-
 #define EXTRA_FLOPPY_PARAMS
 
 #endif /* __ASM_SH_FLOPPY_H */
diff -puN include/asm-sparc/floppy.h~cleanup-floppyh include/asm-sparc/floppy.h
--- a/include/asm-sparc/floppy.h~cleanup-floppyh
+++ a/include/asm-sparc/floppy.h
@@ -77,8 +77,6 @@ static struct sun_floppy_ops sun_fdops;
 #define fd_dma_mem_free(addr,size) (vfree((void *)(addr)))
 #endif
 
-#define FLOPPY_MOTOR_MASK         0x10
-
 /* XXX This isn't really correct. XXX */
 #define get_dma_residue(x)        (0)
 
diff -puN include/asm-sparc64/floppy.h~cleanup-floppyh include/asm-sparc64/floppy.h
--- a/include/asm-sparc64/floppy.h~cleanup-floppyh
+++ a/include/asm-sparc64/floppy.h
@@ -84,8 +84,6 @@ static struct sun_floppy_ops sun_fdops;
 #define fd_free_irq()             sun_fdops.fd_free_irq()
 #define fd_eject(drive)           sun_fdops.fd_eject(drive)
 
-static int FLOPPY_MOTOR_MASK = 0x10;
-
 /* Super paranoid... */
 #undef HAVE_DISABLE_HLT
 
@@ -622,7 +620,6 @@ isa_done:
 	sun_fdops.fd_eject = sun_pci_fd_eject;
 
         fdc_status = (unsigned long) &sun_fdc->status_82077;
-	FLOPPY_MOTOR_MASK = 0xf0;
 
 	allowed_drive_mask = 0;
 	sun_floppy_types[0] = 0;
@@ -729,7 +726,6 @@ static unsigned long __init sun_floppy_i
 		sun_fdops.fd_eject = sun_pci_fd_eject;
 
         	fdc_status = (unsigned long) &sun_fdc->status_82077;
-		FLOPPY_MOTOR_MASK = 0xf0;
 
 		/*
 		 * XXX: Find out on which machines this is really needed.
diff -puN include/asm-x86/floppy_32.h~cleanup-floppyh include/asm-x86/floppy_32.h
--- a/include/asm-x86/floppy_32.h~cleanup-floppyh
+++ a/include/asm-x86/floppy_32.h
@@ -275,10 +275,6 @@ static int FDC2 = -1;
 #define N_FDC 2
 #define N_DRIVE 8
 
-#define FLOPPY_MOTOR_MASK 0xf0
-
-#define AUTO_DMA
-
 #define EXTRA_FLOPPY_PARAMS
 
 #endif /* __ASM_I386_FLOPPY_H */
diff -puN include/asm-x86/floppy_64.h~cleanup-floppyh include/asm-x86/floppy_64.h
--- a/include/asm-x86/floppy_64.h~cleanup-floppyh
+++ a/include/asm-x86/floppy_64.h
@@ -274,10 +274,6 @@ static int FDC2 = -1;
 #define N_FDC 2
 #define N_DRIVE 8
 
-#define FLOPPY_MOTOR_MASK 0xf0
-
-#define AUTO_DMA
-
 #define EXTRA_FLOPPY_PARAMS
 
 #endif /* __ASM_X86_64_FLOPPY_H */
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
git-x86.patch
revert-x86_64-mm-cpa-einval.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
