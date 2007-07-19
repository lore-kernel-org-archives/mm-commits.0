From: akpm@linux-foundation.org
Subject: - arch-personality-independent-stack-top.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:01:46 -0700
Message-ID: <200707192001.l6JK1kWB019567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54172 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754624AbXGSUZK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:25:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, aaw@google.com, mm-commits@vger.kernel.org


The patch titled
     arch: personality independent stack top
has been removed from the -mm tree.  Its filename was
     arch-personality-independent-stack-top.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: arch: personality independent stack top
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

New arch macro STACK_TOP_MAX it gives the larges valid stack address for the
architecture in question.

It differs from STACK_TOP in that it will not distinguish between
personalities but will always return the largest possible address.

This is used to create the initial stack on execve, which we will move down to
the proper location once the binfmt code has figured out where that is.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ollie Wild <aaw@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/a.out.h    |    2 ++
 include/asm-arm/a.out.h      |    1 +
 include/asm-arm26/a.out.h    |    1 +
 include/asm-avr32/a.out.h    |    1 +
 include/asm-cris/a.out.h     |    1 +
 include/asm-frv/mem-layout.h |    1 +
 include/asm-h8300/a.out.h    |    1 +
 include/asm-i386/a.out.h     |    1 +
 include/asm-ia64/ustack.h    |    1 +
 include/asm-m32r/a.out.h     |    1 +
 include/asm-m68k/a.out.h     |    1 +
 include/asm-mips/a.out.h     |    1 +
 include/asm-parisc/a.out.h   |    1 +
 include/asm-powerpc/a.out.h  |    3 +++
 include/asm-s390/a.out.h     |    1 +
 include/asm-sh/a.out.h       |    1 +
 include/asm-sh64/a.out.h     |    1 +
 include/asm-sparc/a.out.h    |    1 +
 include/asm-sparc64/a.out.h  |    2 ++
 include/asm-um/a.out.h       |    2 ++
 include/asm-x86_64/a.out.h   |    3 ++-
 include/asm-xtensa/a.out.h   |    1 +
 22 files changed, 28 insertions(+), 1 deletion(-)

diff -puN include/asm-alpha/a.out.h~arch-personality-independent-stack-top include/asm-alpha/a.out.h
--- a/include/asm-alpha/a.out.h~arch-personality-independent-stack-top
+++ a/include/asm-alpha/a.out.h
@@ -101,6 +101,8 @@ struct exec
 #define STACK_TOP \
   (current->personality & ADDR_LIMIT_32BIT ? 0x80000000 : 0x00120000000UL)
 
+#define STACK_TOP_MAX	0x00120000000UL
+
 #endif
 
 #endif /* __A_OUT_GNU_H__ */
diff -puN include/asm-arm/a.out.h~arch-personality-independent-stack-top include/asm-arm/a.out.h
--- a/include/asm-arm/a.out.h~arch-personality-independent-stack-top
+++ a/include/asm-arm/a.out.h
@@ -30,6 +30,7 @@ struct exec
 #ifdef __KERNEL__
 #define STACK_TOP	((current->personality == PER_LINUX_32BIT) ? \
 			 TASK_SIZE : TASK_SIZE_26)
+#define STACK_TOP_MAX	TASK_SIZE
 #endif
 
 #ifndef LIBRARY_START_TEXT
diff -puN include/asm-arm26/a.out.h~arch-personality-independent-stack-top include/asm-arm26/a.out.h
--- a/include/asm-arm26/a.out.h~arch-personality-independent-stack-top
+++ a/include/asm-arm26/a.out.h
@@ -29,6 +29,7 @@ struct exec
 
 #ifdef __KERNEL__
 #define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
 #endif
 
 #ifndef LIBRARY_START_TEXT
diff -puN include/asm-avr32/a.out.h~arch-personality-independent-stack-top include/asm-avr32/a.out.h
--- a/include/asm-avr32/a.out.h~arch-personality-independent-stack-top
+++ a/include/asm-avr32/a.out.h
@@ -20,6 +20,7 @@ struct exec
 #ifdef __KERNEL__
 
 #define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
 
 #endif
 
diff -puN include/asm-cris/a.out.h~arch-personality-independent-stack-top include/asm-cris/a.out.h
--- a/include/asm-cris/a.out.h~arch-personality-independent-stack-top
+++ a/include/asm-cris/a.out.h
@@ -8,6 +8,7 @@
 
 /* grabbed from the intel stuff  */   
 #define STACK_TOP TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
 
 
 struct exec
diff -puN include/asm-frv/mem-layout.h~arch-personality-independent-stack-top include/asm-frv/mem-layout.h
--- a/include/asm-frv/mem-layout.h~arch-personality-independent-stack-top
+++ a/include/asm-frv/mem-layout.h
@@ -60,6 +60,7 @@
  */
 #define BRK_BASE			__UL(2 * 1024 * 1024 + PAGE_SIZE)
 #define STACK_TOP			__UL(2 * 1024 * 1024)
+#define STACK_TOP_MAX	STACK_TOP
 
 /* userspace process size */
 #ifdef CONFIG_MMU
diff -puN include/asm-h8300/a.out.h~arch-personality-independent-stack-top include/asm-h8300/a.out.h
--- a/include/asm-h8300/a.out.h~arch-personality-independent-stack-top
+++ a/include/asm-h8300/a.out.h
@@ -20,6 +20,7 @@ struct exec
 #ifdef __KERNEL__
 
 #define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
 
 #endif
 
diff -puN include/asm-i386/a.out.h~arch-personality-independent-stack-top include/asm-i386/a.out.h
--- a/include/asm-i386/a.out.h~arch-personality-independent-stack-top
+++ a/include/asm-i386/a.out.h
@@ -20,6 +20,7 @@ struct exec
 #ifdef __KERNEL__
 
 #define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
 
 #endif
 
diff -puN include/asm-ia64/ustack.h~arch-personality-independent-stack-top include/asm-ia64/ustack.h
--- a/include/asm-ia64/ustack.h~arch-personality-independent-stack-top
+++ a/include/asm-ia64/ustack.h
@@ -11,6 +11,7 @@
 /* The absolute hard limit for stack size is 1/2 of the mappable space in the region */
 #define MAX_USER_STACK_SIZE	(RGN_MAP_LIMIT/2)
 #define STACK_TOP		(0x6000000000000000UL + RGN_MAP_LIMIT)
+#define STACK_TOP_MAX		STACK_TOP
 #endif
 
 /* Make a default stack size of 2GiB */
diff -puN include/asm-m32r/a.out.h~arch-personality-independent-stack-top include/asm-m32r/a.out.h
--- a/include/asm-m32r/a.out.h~arch-personality-independent-stack-top
+++ a/include/asm-m32r/a.out.h
@@ -20,6 +20,7 @@ struct exec
 #ifdef __KERNEL__
 
 #define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
 
 #endif
 
diff -puN include/asm-m68k/a.out.h~arch-personality-independent-stack-top include/asm-m68k/a.out.h
--- a/include/asm-m68k/a.out.h~arch-personality-independent-stack-top
+++ a/include/asm-m68k/a.out.h
@@ -20,6 +20,7 @@ struct exec
 #ifdef __KERNEL__
 
 #define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
 
 #endif
 
diff -puN include/asm-mips/a.out.h~arch-personality-independent-stack-top include/asm-mips/a.out.h
--- a/include/asm-mips/a.out.h~arch-personality-independent-stack-top
+++ a/include/asm-mips/a.out.h
@@ -40,6 +40,7 @@ struct exec
 #ifdef CONFIG_64BIT
 #define STACK_TOP	(current->thread.mflags & MF_32BIT_ADDR ? TASK_SIZE32 : TASK_SIZE)
 #endif
+#define STACK_TOP_MAX	TASK_SIZE
 
 #endif
 
diff -puN include/asm-parisc/a.out.h~arch-personality-independent-stack-top include/asm-parisc/a.out.h
--- a/include/asm-parisc/a.out.h~arch-personality-independent-stack-top
+++ a/include/asm-parisc/a.out.h
@@ -23,6 +23,7 @@ struct exec
  * prumpf */
 
 #define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	DEFAULT_TASK_SIZE
 
 #endif
 
diff -puN include/asm-powerpc/a.out.h~arch-personality-independent-stack-top include/asm-powerpc/a.out.h
--- a/include/asm-powerpc/a.out.h~arch-personality-independent-stack-top
+++ a/include/asm-powerpc/a.out.h
@@ -26,9 +26,12 @@ struct exec
 #define STACK_TOP (test_thread_flag(TIF_32BIT) ? \
 		   STACK_TOP_USER32 : STACK_TOP_USER64)
 
+#define STACK_TOP_MAX STACK_TOP_USER64
+
 #else /* __powerpc64__ */
 
 #define STACK_TOP TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
 
 #endif /* __powerpc64__ */
 #endif /* __KERNEL__ */
diff -puN include/asm-s390/a.out.h~arch-personality-independent-stack-top include/asm-s390/a.out.h
--- a/include/asm-s390/a.out.h~arch-personality-independent-stack-top
+++ a/include/asm-s390/a.out.h
@@ -32,6 +32,7 @@ struct exec
 #ifdef __KERNEL__
 
 #define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	DEFAULT_TASK_SIZE
 
 #endif
 
diff -puN include/asm-sh/a.out.h~arch-personality-independent-stack-top include/asm-sh/a.out.h
--- a/include/asm-sh/a.out.h~arch-personality-independent-stack-top
+++ a/include/asm-sh/a.out.h
@@ -20,6 +20,7 @@ struct exec
 #ifdef __KERNEL__
 
 #define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
 
 #endif
 
diff -puN include/asm-sh64/a.out.h~arch-personality-independent-stack-top include/asm-sh64/a.out.h
--- a/include/asm-sh64/a.out.h~arch-personality-independent-stack-top
+++ a/include/asm-sh64/a.out.h
@@ -31,6 +31,7 @@ struct exec
 #ifdef __KERNEL__
 
 #define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
 
 #endif
 
diff -puN include/asm-sparc/a.out.h~arch-personality-independent-stack-top include/asm-sparc/a.out.h
--- a/include/asm-sparc/a.out.h~arch-personality-independent-stack-top
+++ a/include/asm-sparc/a.out.h
@@ -92,6 +92,7 @@ struct relocation_info /* used when head
 #include <asm/page.h>
 
 #define STACK_TOP	(PAGE_OFFSET - PAGE_SIZE)
+#define STACK_TOP_MAX	STACK_TOP
 
 #endif /* __KERNEL__ */
 
diff -puN include/asm-sparc64/a.out.h~arch-personality-independent-stack-top include/asm-sparc64/a.out.h
--- a/include/asm-sparc64/a.out.h~arch-personality-independent-stack-top
+++ a/include/asm-sparc64/a.out.h
@@ -101,6 +101,8 @@ struct relocation_info /* used when head
 #define STACK_TOP (test_thread_flag(TIF_32BIT) ? \
 		   STACK_TOP32 : STACK_TOP64)
 
+#define STACK_TOP_MAX STACK_TOP64
+
 #endif
 
 #endif /* !(__ASSEMBLY__) */
diff -puN include/asm-um/a.out.h~arch-personality-independent-stack-top include/asm-um/a.out.h
--- a/include/asm-um/a.out.h~arch-personality-independent-stack-top
+++ a/include/asm-um/a.out.h
@@ -17,4 +17,6 @@ extern int honeypot;
 #define STACK_TOP \
 	CHOOSE_MODE((honeypot ? host_task_size : task_size), task_size)
 
+#define STACK_TOP_MAX	STACK_TOP
+
 #endif
diff -puN include/asm-x86_64/a.out.h~arch-personality-independent-stack-top include/asm-x86_64/a.out.h
--- a/include/asm-x86_64/a.out.h~arch-personality-independent-stack-top
+++ a/include/asm-x86_64/a.out.h
@@ -21,7 +21,8 @@ struct exec
 
 #ifdef __KERNEL__
 #include <linux/thread_info.h>
-#define STACK_TOP TASK_SIZE
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	TASK_SIZE64
 #endif
 
 #endif /* __A_OUT_GNU_H__ */
diff -puN include/asm-xtensa/a.out.h~arch-personality-independent-stack-top include/asm-xtensa/a.out.h
--- a/include/asm-xtensa/a.out.h~arch-personality-independent-stack-top
+++ a/include/asm-xtensa/a.out.h
@@ -17,6 +17,7 @@
 /* Note: the kernel needs the a.out definitions, even if only ELF is used. */
 
 #define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
 
 struct exec
 {
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
