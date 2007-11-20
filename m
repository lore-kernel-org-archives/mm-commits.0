From: akpm@linux-foundation.org
Subject: - aout-move-stack_top-to-asm-processorh.patch removed from -mm tree
Date: Tue, 20 Nov 2007 12:51:11 -0800
Message-ID: <200711202051.lAKKpBMB022803@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47929 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763917AbXKTUvm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 15:51:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, linux-arch@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     AOUT: Move STACK_TOP[_MAX] to asm/processor.h
has been removed from the -mm tree.  Its filename was
     aout-move-stack_top-to-asm-processorh.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: AOUT: Move STACK_TOP[_MAX] to asm/processor.h
From: David Howells <dhowells@redhat.com>

Move STACK_TOP[_MAX] out of asm/a.out.h and into asm/processor.h as they're
required whether or not A.OUT format is available.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/a.out.h          |    8 +-------
 include/asm-alpha/processor.h      |    5 +++++
 include/asm-arm/a.out.h            |    6 ------
 include/asm-arm/processor.h        |    6 ++++++
 include/asm-avr32/a.out.h          |    7 -------
 include/asm-avr32/processor.h      |    5 +++++
 include/asm-blackfin/a.out.h       |    6 ------
 include/asm-blackfin/processor.h   |    4 ++++
 include/asm-cris/a.out.h           |    6 ------
 include/asm-cris/processor.h       |    3 +++
 include/asm-h8300/a.out.h          |    7 -------
 include/asm-h8300/processor.h      |    5 +++++
 include/asm-ia64/a.out.h           |    3 ---
 include/asm-m32r/a.out.h           |    7 -------
 include/asm-m32r/processor.h       |    5 +++++
 include/asm-m68k/a.out.h           |    7 -------
 include/asm-m68k/processor.h       |    5 +++++
 include/asm-mips/a.out.h           |   13 -------------
 include/asm-mips/processor.h       |    7 +++++++
 include/asm-parisc/a.out.h         |   10 ----------
 include/asm-parisc/processor.h     |   10 ++++++++++
 include/asm-powerpc/a.out.h        |   19 -------------------
 include/asm-powerpc/processor.h    |   19 +++++++++++++++++++
 include/asm-s390/a.out.h           |    7 -------
 include/asm-s390/processor.h       |    7 +++++++
 include/asm-sh/a.out.h             |    7 -------
 include/asm-sh/processor.h         |    7 +++++++
 include/asm-sh64/a.out.h           |    7 -------
 include/asm-sparc/a.out.h          |    9 ---------
 include/asm-sparc/processor.h      |    4 ++++
 include/asm-sparc64/a.out.h        |   12 ------------
 include/asm-sparc64/processor.h    |   12 ++++++++++++
 include/asm-sparc64/user.h         |    2 +-
 include/asm-um/a.out.h             |   13 -------------
 include/asm-um/processor-generic.h |    8 ++++++++
 include/asm-x86/a.out.h            |   10 ----------
 include/asm-x86/processor_32.h     |    2 ++
 include/asm-x86/processor_64.h     |    2 ++
 include/asm-xtensa/a.out.h         |    5 -----
 include/asm-xtensa/processor.h     |    2 ++
 40 files changed, 120 insertions(+), 169 deletions(-)

diff -puN include/asm-alpha/a.out.h~aout-move-stack_top-to-asm-processorh include/asm-alpha/a.out.h
--- a/include/asm-alpha/a.out.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-alpha/a.out.h
@@ -98,11 +98,5 @@ struct exec
 	set_personality (((BFPM->sh_bang || EX.ah.entry < 0x100000000L \
 			   ? ADDR_LIMIT_32BIT : 0) | PER_OSF4))
 
-#define STACK_TOP \
-  (current->personality & ADDR_LIMIT_32BIT ? 0x80000000 : 0x00120000000UL)
-
-#define STACK_TOP_MAX	0x00120000000UL
-
-#endif
-
+#endif /* __KERNEL__ */
 #endif /* __A_OUT_GNU_H__ */
diff -puN include/asm-alpha/processor.h~aout-move-stack_top-to-asm-processorh include/asm-alpha/processor.h
--- a/include/asm-alpha/processor.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-alpha/processor.h
@@ -20,6 +20,11 @@
  */
 #define TASK_SIZE (0x40000000000UL)
 
+#define STACK_TOP \
+  (current->personality & ADDR_LIMIT_32BIT ? 0x80000000 : 0x00120000000UL)
+
+#define STACK_TOP_MAX	0x00120000000UL
+
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
diff -puN include/asm-arm/a.out.h~aout-move-stack_top-to-asm-processorh include/asm-arm/a.out.h
--- a/include/asm-arm/a.out.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-arm/a.out.h
@@ -27,12 +27,6 @@ struct exec
 
 #define M_ARM 103
 
-#ifdef __KERNEL__
-#define STACK_TOP	((current->personality == PER_LINUX_32BIT) ? \
-			 TASK_SIZE : TASK_SIZE_26)
-#define STACK_TOP_MAX	TASK_SIZE
-#endif
-
 #ifndef LIBRARY_START_TEXT
 #define LIBRARY_START_TEXT	(0x00c00000)
 #endif
diff -puN include/asm-arm/processor.h~aout-move-stack_top-to-asm-processorh include/asm-arm/processor.h
--- a/include/asm-arm/processor.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-arm/processor.h
@@ -22,6 +22,12 @@
 #include <asm/ptrace.h>
 #include <asm/types.h>
 
+#ifdef __KERNEL__
+#define STACK_TOP	((current->personality == PER_LINUX_32BIT) ? \
+			 TASK_SIZE : TASK_SIZE_26)
+#define STACK_TOP_MAX	TASK_SIZE
+#endif
+
 union debug_insn {
 	u32	arm;
 	u16	thumb;
diff -puN include/asm-avr32/a.out.h~aout-move-stack_top-to-asm-processorh include/asm-avr32/a.out.h
--- a/include/asm-avr32/a.out.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-avr32/a.out.h
@@ -17,11 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif
-
 #endif /* __ASM_AVR32_A_OUT_H */
diff -puN include/asm-avr32/processor.h~aout-move-stack_top-to-asm-processorh include/asm-avr32/processor.h
--- a/include/asm-avr32/processor.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-avr32/processor.h
@@ -13,6 +13,11 @@
 
 #define TASK_SIZE	0x80000000
 
+#ifdef __KERNEL__
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+#endif
+
 #ifndef __ASSEMBLY__
 
 static inline void *current_text_addr(void)
diff -puN include/asm-blackfin/a.out.h~aout-move-stack_top-to-asm-processorh include/asm-blackfin/a.out.h
--- a/include/asm-blackfin/a.out.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-blackfin/a.out.h
@@ -16,10 +16,4 @@ struct exec {
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-
-#endif
-
 #endif				/* __BFIN_A_OUT_H__ */
diff -puN include/asm-blackfin/processor.h~aout-move-stack_top-to-asm-processorh include/asm-blackfin/processor.h
--- a/include/asm-blackfin/processor.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-blackfin/processor.h
@@ -30,6 +30,10 @@ static inline void wrusp(unsigned long u
 extern unsigned long memory_end;
 #define TASK_SIZE	(memory_end)
 
+#ifdef __KERNEL__
+#define STACK_TOP	TASK_SIZE
+#endif
+
 #define TASK_UNMAPPED_BASE	0
 
 struct thread_struct {
diff -puN include/asm-cris/a.out.h~aout-move-stack_top-to-asm-processorh include/asm-cris/a.out.h
--- a/include/asm-cris/a.out.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-cris/a.out.h
@@ -6,11 +6,6 @@
  * wants to know about a.out even if there is no interpreter available...
  */
 
-/* grabbed from the intel stuff  */   
-#define STACK_TOP TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-
 struct exec
 {
   unsigned long a_info;		/* Use macros N_MAGIC, etc for access */
@@ -28,5 +23,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-
 #endif
diff -puN include/asm-cris/processor.h~aout-move-stack_top-to-asm-processorh include/asm-cris/processor.h
--- a/include/asm-cris/processor.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-cris/processor.h
@@ -17,6 +17,9 @@
 
 struct task_struct;
 
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
diff -puN include/asm-h8300/a.out.h~aout-move-stack_top-to-asm-processorh include/asm-h8300/a.out.h
--- a/include/asm-h8300/a.out.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-h8300/a.out.h
@@ -17,11 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif
-
 #endif /* __H8300_A_OUT_H__ */
diff -puN include/asm-h8300/processor.h~aout-move-stack_top-to-asm-processorh include/asm-h8300/processor.h
--- a/include/asm-h8300/processor.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-h8300/processor.h
@@ -39,6 +39,11 @@ static inline void wrusp(unsigned long u
  */
 #define TASK_SIZE	(0xFFFFFFFFUL)
 
+#ifdef __KERNEL__
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+#endif
+
 /*
  * This decides where the kernel will search for a free chunk of vm
  * space during mmap's. We won't be using it
diff -puN include/asm-ia64/a.out.h~aout-move-stack_top-to-asm-processorh include/asm-ia64/a.out.h
--- a/include/asm-ia64/a.out.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-ia64/a.out.h
@@ -29,7 +29,4 @@ struct exec {
 #define N_SYMSIZE(x)	0
 #define N_TXTOFF(x)	0
 
-#ifdef __KERNEL__
-#include <asm/ustack.h>
-#endif
 #endif /* _ASM_IA64_A_OUT_H */
diff -puN include/asm-m32r/a.out.h~aout-move-stack_top-to-asm-processorh include/asm-m32r/a.out.h
--- a/include/asm-m32r/a.out.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-m32r/a.out.h
@@ -17,11 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif
-
 #endif /* _ASM_M32R_A_OUT_H */
diff -puN include/asm-m32r/processor.h~aout-move-stack_top-to-asm-processorh include/asm-m32r/processor.h
--- a/include/asm-m32r/processor.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-m32r/processor.h
@@ -60,6 +60,11 @@ extern struct cpuinfo_m32r cpu_data[];
 #define TASK_SIZE  (0x00400000UL)
 #endif
 
+#ifdef __KERNEL__
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+#endif
+
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
diff -puN include/asm-m68k/a.out.h~aout-move-stack_top-to-asm-processorh include/asm-m68k/a.out.h
--- a/include/asm-m68k/a.out.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-m68k/a.out.h
@@ -17,11 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif
-
 #endif /* __M68K_A_OUT_H__ */
diff -puN include/asm-m68k/processor.h~aout-move-stack_top-to-asm-processorh include/asm-m68k/processor.h
--- a/include/asm-m68k/processor.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-m68k/processor.h
@@ -41,6 +41,11 @@ static inline void wrusp(unsigned long u
 #define TASK_SIZE	(0x0E000000UL)
 #endif
 
+#ifdef __KERNEL__
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+#endif
+
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
diff -puN include/asm-mips/a.out.h~aout-move-stack_top-to-asm-processorh include/asm-mips/a.out.h
--- a/include/asm-mips/a.out.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-mips/a.out.h
@@ -32,17 +32,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#ifdef CONFIG_32BIT
-#define STACK_TOP	TASK_SIZE
-#endif
-#ifdef CONFIG_64BIT
-#define STACK_TOP	\
-      (test_thread_flag(TIF_32BIT_ADDR) ? TASK_SIZE32 : TASK_SIZE)
-#endif
-#define STACK_TOP_MAX	TASK_SIZE
-
-#endif
-
 #endif /* _ASM_A_OUT_H */
diff -puN include/asm-mips/processor.h~aout-move-stack_top-to-asm-processorh include/asm-mips/processor.h
--- a/include/asm-mips/processor.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-mips/processor.h
@@ -39,6 +39,7 @@ extern unsigned int vced_count, vcei_cou
  * so don't change it unless you know what you are doing.
  */
 #define TASK_SIZE	0x7fff8000UL
+#define STACK_TOP	TASK_SIZE
 
 /*
  * This decides where the kernel will search for a free chunk of vm
@@ -57,6 +58,8 @@ extern unsigned int vced_count, vcei_cou
  */
 #define TASK_SIZE32	0x7fff8000UL
 #define TASK_SIZE	0x10000000000UL
+#define STACK_TOP	\
+      (test_thread_flag(TIF_32BIT_ADDR) ? TASK_SIZE32 : TASK_SIZE)
 
 /*
  * This decides where the kernel will search for a free chunk of vm
@@ -69,6 +72,10 @@ extern unsigned int vced_count, vcei_cou
 	(test_tsk_thread_flag(tsk, TIF_32BIT_ADDR) ? TASK_SIZE32 : TASK_SIZE)
 #endif
 
+#ifdef __KERNEL__
+#define STACK_TOP_MAX	TASK_SIZE
+#endif
+
 #define NUM_FPU_REGS	32
 
 typedef __u64 fpureg_t;
diff -puN include/asm-parisc/a.out.h~aout-move-stack_top-to-asm-processorh include/asm-parisc/a.out.h
--- a/include/asm-parisc/a.out.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-parisc/a.out.h
@@ -17,14 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-/* XXX: STACK_TOP actually should be STACK_BOTTOM for parisc.
- * prumpf */
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	DEFAULT_TASK_SIZE
-
-#endif
-
 #endif /* __A_OUT_GNU_H__ */
diff -puN include/asm-parisc/processor.h~aout-move-stack_top-to-asm-processorh include/asm-parisc/processor.h
--- a/include/asm-parisc/processor.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-parisc/processor.h
@@ -47,6 +47,16 @@
 #define DEFAULT_MAP_BASE	DEFAULT_MAP_BASE32
 #endif
 
+#ifdef __KERNEL__
+
+/* XXX: STACK_TOP actually should be STACK_BOTTOM for parisc.
+ * prumpf */
+
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	DEFAULT_TASK_SIZE
+
+#endif
+
 #ifndef __ASSEMBLY__
 
 /*
diff -puN include/asm-powerpc/a.out.h~aout-move-stack_top-to-asm-processorh include/asm-powerpc/a.out.h
--- a/include/asm-powerpc/a.out.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-powerpc/a.out.h
@@ -17,23 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-#ifdef __powerpc64__
-
-#define STACK_TOP_USER64 TASK_SIZE_USER64
-#define STACK_TOP_USER32 TASK_SIZE_USER32
-
-#define STACK_TOP (test_thread_flag(TIF_32BIT) ? \
-		   STACK_TOP_USER32 : STACK_TOP_USER64)
-
-#define STACK_TOP_MAX STACK_TOP_USER64
-
-#else /* __powerpc64__ */
-
-#define STACK_TOP TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif /* __powerpc64__ */
-#endif /* __KERNEL__ */
-
 #endif /* _ASM_POWERPC_A_OUT_H */
diff -puN include/asm-powerpc/processor.h~aout-move-stack_top-to-asm-processorh include/asm-powerpc/processor.h
--- a/include/asm-powerpc/processor.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-powerpc/processor.h
@@ -113,6 +113,25 @@ extern struct task_struct *last_task_use
 		TASK_UNMAPPED_BASE_USER32 : TASK_UNMAPPED_BASE_USER64 )
 #endif
 
+#ifdef __KERNEL__
+#ifdef __powerpc64__
+
+#define STACK_TOP_USER64 TASK_SIZE_USER64
+#define STACK_TOP_USER32 TASK_SIZE_USER32
+
+#define STACK_TOP (test_thread_flag(TIF_32BIT) ? \
+		   STACK_TOP_USER32 : STACK_TOP_USER64)
+
+#define STACK_TOP_MAX STACK_TOP_USER64
+
+#else /* __powerpc64__ */
+
+#define STACK_TOP TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+
+#endif /* __powerpc64__ */
+#endif /* __KERNEL__ */
+
 typedef struct {
 	unsigned long seg;
 } mm_segment_t;
diff -puN include/asm-s390/a.out.h~aout-move-stack_top-to-asm-processorh include/asm-s390/a.out.h
--- a/include/asm-s390/a.out.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-s390/a.out.h
@@ -29,11 +29,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	DEFAULT_TASK_SIZE
-
-#endif
-
 #endif /* __A_OUT_GNU_H__ */
diff -puN include/asm-s390/processor.h~aout-move-stack_top-to-asm-processorh include/asm-s390/processor.h
--- a/include/asm-s390/processor.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-s390/processor.h
@@ -81,6 +81,13 @@ extern struct task_struct *last_task_use
 
 #endif /* __s390x__ */
 
+#ifdef __KERNEL__
+
+#define STACK_TOP		TASK_SIZE
+#define STACK_TOP_MAX		DEFAULT_TASK_SIZE
+
+#endif
+
 #define HAVE_ARCH_PICK_MMAP_LAYOUT
 
 typedef struct {
diff -puN include/asm-sh/a.out.h~aout-move-stack_top-to-asm-processorh include/asm-sh/a.out.h
--- a/include/asm-sh/a.out.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-sh/a.out.h
@@ -17,11 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif
-
 #endif /* __ASM_SH_A_OUT_H */
diff -puN include/asm-sh/processor.h~aout-move-stack_top-to-asm-processorh include/asm-sh/processor.h
--- a/include/asm-sh/processor.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-sh/processor.h
@@ -85,6 +85,13 @@ extern struct sh_cpuinfo cpu_data[];
  */
 #define TASK_SIZE	0x7c000000UL
 
+#ifdef __KERNEL__
+
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+
+#endif
+
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
diff -puN include/asm-sh64/a.out.h~aout-move-stack_top-to-asm-processorh include/asm-sh64/a.out.h
--- a/include/asm-sh64/a.out.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-sh64/a.out.h
@@ -28,11 +28,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif
-
 #endif /* __ASM_SH64_A_OUT_H */
diff -puN include/asm-sparc/a.out.h~aout-move-stack_top-to-asm-processorh include/asm-sparc/a.out.h
--- a/include/asm-sparc/a.out.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-sparc/a.out.h
@@ -87,13 +87,4 @@ struct relocation_info /* used when head
 
 #define N_RELOCATION_INFO_DECLARED 1
 
-#ifdef __KERNEL__
-
-#include <asm/page.h>
-
-#define STACK_TOP	(PAGE_OFFSET - PAGE_SIZE)
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif /* __KERNEL__ */
-
 #endif /* __SPARC_A_OUT_H__ */
diff -puN include/asm-sparc/processor.h~aout-move-stack_top-to-asm-processorh include/asm-sparc/processor.h
--- a/include/asm-sparc/processor.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-sparc/processor.h
@@ -33,6 +33,10 @@
  * we can make our access_ok test faster
  */
 #define TASK_SIZE	PAGE_OFFSET
+#ifdef __KERNEL__
+#define STACK_TOP	(PAGE_OFFSET - PAGE_SIZE)
+#define STACK_TOP_MAX	STACK_TOP
+#endif /* __KERNEL__ */
 
 struct task_struct;
 
diff -puN include/asm-sparc64/a.out.h~aout-move-stack_top-to-asm-processorh include/asm-sparc64/a.out.h
--- a/include/asm-sparc64/a.out.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-sparc64/a.out.h
@@ -93,18 +93,6 @@ struct relocation_info /* used when head
 
 #define N_RELOCATION_INFO_DECLARED 1
 
-#ifdef __KERNEL__
-
-#define STACK_TOP32	((1UL << 32UL) - PAGE_SIZE)
-#define STACK_TOP64	(0x0000080000000000UL - (1UL << 32UL))
-
-#define STACK_TOP (test_thread_flag(TIF_32BIT) ? \
-		   STACK_TOP32 : STACK_TOP64)
-
-#define STACK_TOP_MAX STACK_TOP64
-
-#endif
-
 #endif /* !(__ASSEMBLY__) */
 
 #endif /* !(__SPARC64_A_OUT_H__) */
diff -puN include/asm-sparc64/processor.h~aout-move-stack_top-to-asm-processorh include/asm-sparc64/processor.h
--- a/include/asm-sparc64/processor.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-sparc64/processor.h
@@ -36,7 +36,19 @@
 #else
 #define VPTE_SIZE	(1 << (VA_BITS - PAGE_SHIFT + 3))
 #endif
+
 #define TASK_SIZE	((unsigned long)-VPTE_SIZE)
+#ifdef __KERNEL__
+
+#define STACK_TOP32	((1UL << 32UL) - PAGE_SIZE)
+#define STACK_TOP64	(0x0000080000000000UL - (1UL << 32UL))
+
+#define STACK_TOP	(test_thread_flag(TIF_32BIT) ? \
+			 STACK_TOP32 : STACK_TOP64)
+
+#define STACK_TOP_MAX	STACK_TOP64
+
+#endif
 
 #ifndef __ASSEMBLY__
 
diff -puN include/asm-sparc64/user.h~aout-move-stack_top-to-asm-processorh include/asm-sparc64/user.h
--- a/include/asm-sparc64/user.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-sparc64/user.h
@@ -8,7 +8,7 @@
 #ifndef _SPARC64_USER_H
 #define _SPARC64_USER_H
 
-#include <asm/a.out.h>
+#include <linux/a.out.h>
 struct sunos_regs {
 	unsigned int psr, pc, npc, y;
 	unsigned int regs[15];
diff -puN include/asm-um/a.out.h~aout-move-stack_top-to-asm-processorh include/asm-um/a.out.h
--- a/include/asm-um/a.out.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-um/a.out.h
@@ -8,17 +8,4 @@
 
 #include "asm/arch/a.out.h"
 
-#undef STACK_TOP
-#undef STACK_TOP_MAX
-
-extern unsigned long stacksizelim;
-
-extern unsigned long host_task_size;
-
-#define STACK_ROOM (stacksizelim)
-
-#define STACK_TOP task_size
-
-#define STACK_TOP_MAX STACK_TOP
-
 #endif
diff -puN include/asm-um/processor-generic.h~aout-move-stack_top-to-asm-processorh include/asm-um/processor-generic.h
--- a/include/asm-um/processor-generic.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-um/processor-generic.h
@@ -98,9 +98,17 @@ static inline void mm_copy_segments(stru
  * User space process size: 3GB (default).
  */
 extern unsigned long task_size;
+extern unsigned long stacksizelim;
+extern unsigned long host_task_size;
 
 #define TASK_SIZE	(task_size)
 
+#undef STACK_TOP
+#undef STACK_TOP_MAX
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+#define STACK_ROOM	(stacksizelim)
+
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
diff -puN include/asm-x86/a.out.h~aout-move-stack_top-to-asm-processorh include/asm-x86/a.out.h
--- a/include/asm-x86/a.out.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-x86/a.out.h
@@ -17,14 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-# include <linux/thread_info.h>
-# define STACK_TOP	TASK_SIZE
-# ifdef CONFIG_X86_32
-#  define STACK_TOP_MAX	STACK_TOP
-# else
-#  define STACK_TOP_MAX	TASK_SIZE64
-# endif
-#endif
-
 #endif /* _ASM_X86_A_OUT_H */
diff -puN include/asm-x86/processor_32.h~aout-move-stack_top-to-asm-processorh include/asm-x86/processor_32.h
--- a/include/asm-x86/processor_32.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-x86/processor_32.h
@@ -212,6 +212,8 @@ extern int bootloader_type;
  * User space process size: 3GB (default).
  */
 #define TASK_SIZE	(PAGE_OFFSET)
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
 
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
diff -puN include/asm-x86/processor_64.h~aout-move-stack_top-to-asm-processorh include/asm-x86/processor_64.h
--- a/include/asm-x86/processor_64.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-x86/processor_64.h
@@ -147,6 +147,8 @@ static inline void clear_in_cr4 (unsigne
 #define TASK_SIZE_OF(child) 	((test_tsk_thread_flag(child, TIF_IA32)) ? IA32_PAGE_OFFSET : TASK_SIZE64)
 
 #define TASK_UNMAPPED_BASE	PAGE_ALIGN(TASK_SIZE/3)
+#define STACK_TOP		TASK_SIZE
+#define STACK_TOP_MAX		TASK_SIZE64
 
 /*
  * Size of io_bitmap.
diff -puN include/asm-xtensa/a.out.h~aout-move-stack_top-to-asm-processorh include/asm-xtensa/a.out.h
--- a/include/asm-xtensa/a.out.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-xtensa/a.out.h
@@ -14,11 +14,6 @@
 #ifndef _XTENSA_A_OUT_H
 #define _XTENSA_A_OUT_H
 
-/* Note: the kernel needs the a.out definitions, even if only ELF is used. */
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
 struct exec
 {
   unsigned long a_info;
diff -puN include/asm-xtensa/processor.h~aout-move-stack_top-to-asm-processorh include/asm-xtensa/processor.h
--- a/include/asm-xtensa/processor.h~aout-move-stack_top-to-asm-processorh
+++ a/include/asm-xtensa/processor.h
@@ -34,6 +34,8 @@
  */
 
 #define TASK_SIZE	__XTENSA_UL_CONST(0x40000000)
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
 
 /*
  * General exception cause assigned to debug exceptions. Debug exceptions go
_

Patches currently in -mm which might be from dhowells@redhat.com are

git-mtd.patch
frv-fix-the-extern-declaration-of-kallsyms_num_syms.patch
frv-arrange-things-such-that-bra-can-reach-from-the-trap.patch
frv-permit-the-memory-to-be-located-elsewhere-in-nommu-mode.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
frv-remove-dead-config-symbol-from-frv-code.patch
aout-move-stack_top-to-asm-processorh.patch
aout-mark-arches-that-support-aout-format.patch
aout-mark-arches-that-support-aout-format-fix.patch
aout-mark-arches-that-support-aout-format-fix-2.patch
aout-mark-arches-that-support-aout-format-fix-3.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch
usb-net2280-cant-have-a-function-called-show_registers.patch
mn10300-allocate-serial-port-uart-ids-for-on-chip-serial-ports.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
64-bit-i_version-afs-fixes.patch
add-an-err_cast-function-to-complement-err_ptr-and-co.patch
convert-err_ptrptr_errp-instances-to-err_castp.patch
iget-introduce-a-function-to-register-iget-failure.patch
iget-use-iget_failed-in-afs.patch
iget-use-iget_failed-in-gfs2.patch
iget-stop-affs-from-using-iget-and-read_inode-try.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-autofs-from-using-iget-and-read_inode.patch
iget-stop-befs-from-using-iget-and-read_inode-try.patch
iget-stop-bfs-from-using-iget-and-read_inode-try.patch
iget-stop-cifs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
iget-stop-fat-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-fix.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-fuse-from-using-iget-and-read_inode-try.patch
iget-stop-hfsplus-from-using-iget-and-read_inode.patch
iget-stop-isofs-from-using-read_inode.patch
iget-stop-jffs2-from-using-iget-and-read_inode.patch
iget-stop-jfs-from-using-iget-and-read_inode-try.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-openpromfs-from-using-iget-and.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
unexport-asm-pageh.patch
add-cmpxchg_local-to-frv.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
tty-let-architectures-override-the-user-kernel-macros.patch
mutex-subsystem-synchro-test-module.patch
