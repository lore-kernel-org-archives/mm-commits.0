From: akpm@linux-foundation.org
Subject: - define-percpu-smp-cacheline-align-interface.patch removed from -mm tree
Date: Tue, 15 May 2007 16:40:11 -0700
Message-ID: <200705152343.l4FNhHZ9021125@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57825 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756428AbXEOXqk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 19:46:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fenghua.yu@intel.com, clameter@sgi.com, kiran@scalex86.org, linux-arch@vger.kernel.org, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     Define percpu smp cacheline align interface
has been removed from the -mm tree.  Its filename was
     define-percpu-smp-cacheline-align-interface.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Define percpu smp cacheline align interface
From: Fenghua Yu <fenghua.yu@intel.com>

The patches place all of smp cacheline aligned percpu data into
.data.percpu.cacheline_aligned_in_smp.  Other percpu data is still in
data.percpu section.  The patches can reduce cache line access in SMP and
reduce alignment gap waste.  The patches also define PERCPU macro for
vmlinux.lds.S for code clean up.

This patch:

Define percpu smp cacheline align interface

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: <linux-arch@vger.kernel.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Ravikiran G Thirumalai <kiran@scalex86.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/vmlinux.lds.S   |    5 +----
 arch/arm/kernel/vmlinux.lds.S     |    5 +----
 arch/cris/arch-v32/vmlinux.lds.S  |    5 +----
 arch/frv/kernel/vmlinux.lds.S     |    5 +----
 arch/i386/kernel/vmlinux.lds.S    |    7 +------
 arch/ia64/kernel/vmlinux.lds.S    |    1 +
 arch/m32r/kernel/vmlinux.lds.S    |    5 +----
 arch/mips/kernel/vmlinux.lds.S    |    5 +----
 arch/parisc/kernel/vmlinux.lds.S  |    7 +++----
 arch/powerpc/kernel/vmlinux.lds.S |    7 +------
 arch/ppc/kernel/vmlinux.lds.S     |    5 +----
 arch/s390/kernel/vmlinux.lds.S    |    5 +----
 arch/sh/kernel/vmlinux.lds.S      |    5 +----
 arch/sh64/kernel/vmlinux.lds.S    |    5 +----
 arch/sparc/kernel/vmlinux.lds.S   |    5 +----
 arch/sparc64/kernel/vmlinux.lds.S |    5 +----
 arch/x86_64/kernel/vmlinux.lds.S  |    6 ++----
 arch/xtensa/kernel/vmlinux.lds.S  |    5 +----
 include/asm-generic/percpu.h      |    8 ++++++++
 include/asm-generic/vmlinux.lds.h |    8 ++++++++
 include/asm-i386/percpu.h         |    5 +++++
 include/asm-ia64/percpu.h         |   10 ++++++++++
 include/asm-powerpc/percpu.h      |    7 +++++++
 include/asm-s390/percpu.h         |    7 +++++++
 include/asm-sparc64/percpu.h      |    7 +++++++
 include/asm-x86_64/percpu.h       |    7 +++++++
 26 files changed, 80 insertions(+), 72 deletions(-)

diff -puN arch/alpha/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface arch/alpha/kernel/vmlinux.lds.S
--- a/arch/alpha/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface
+++ a/arch/alpha/kernel/vmlinux.lds.S
@@ -69,10 +69,7 @@ SECTIONS
   . = ALIGN(8);
   SECURITY_INIT
 
-  . = ALIGN(8192);
-  __per_cpu_start = .;
-  .data.percpu : { *(.data.percpu) }
-  __per_cpu_end = .;
+  PERCPU(8192)
 
   . = ALIGN(2*8192);
   __init_end = .;
diff -puN arch/arm/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface arch/arm/kernel/vmlinux.lds.S
--- a/arch/arm/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface
+++ a/arch/arm/kernel/vmlinux.lds.S
@@ -63,10 +63,7 @@ SECTIONS
 			usr/built-in.o(.init.ramfs)
 		__initramfs_end = .;
 #endif
-		. = ALIGN(4096);
-		__per_cpu_start = .;
-			*(.data.percpu)
-		__per_cpu_end = .;
+		PERCPU(4096)
 #ifndef CONFIG_XIP_KERNEL
 		__init_begin = _stext;
 		*(.init.data)
diff -puN arch/cris/arch-v32/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface arch/cris/arch-v32/vmlinux.lds.S
--- a/arch/cris/arch-v32/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface
+++ a/arch/cris/arch-v32/vmlinux.lds.S
@@ -91,10 +91,7 @@ SECTIONS
 	}
 	SECURITY_INIT
 
-	. =  ALIGN (8192);
-	__per_cpu_start = .;
-	.data.percpu  : { *(.data.percpu) }
-	__per_cpu_end = .;
+	PERCPU(8192)
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	.init.ramfs : {
diff -puN arch/frv/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface arch/frv/kernel/vmlinux.lds.S
--- a/arch/frv/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface
+++ a/arch/frv/kernel/vmlinux.lds.S
@@ -57,10 +57,7 @@ SECTIONS
   __alt_instructions_end = .;
  .altinstr_replacement : { *(.altinstr_replacement) }
 
-  . = ALIGN(4096);
-  __per_cpu_start = .;
-  .data.percpu  : { *(.data.percpu) }
-  __per_cpu_end = .;
+  PERCPU(4096)
 
 #ifdef CONFIG_BLK_DEV_INITRD
   . = ALIGN(4096);
diff -puN arch/i386/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface arch/i386/kernel/vmlinux.lds.S
--- a/arch/i386/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface
+++ a/arch/i386/kernel/vmlinux.lds.S
@@ -178,12 +178,7 @@ SECTIONS
 	__initramfs_end = .;
   }
 #endif
-  . = ALIGN(4096);
-  .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {
-	__per_cpu_start = .;
-	*(.data.percpu)
-	__per_cpu_end = .;
-  }
+  PERCPU(4096)
   . = ALIGN(4096);
   /* freed after init ends here */
 	
diff -puN arch/ia64/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface arch/ia64/kernel/vmlinux.lds.S
--- a/arch/ia64/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface
+++ a/arch/ia64/kernel/vmlinux.lds.S
@@ -206,6 +206,7 @@ SECTIONS
 	{
 		__per_cpu_start = .;
 		*(.data.percpu)
+		*(.data.percpu.shared_cacheline_aligned)
 		__per_cpu_end = .;
 	}
   . = __phys_per_cpu_start + PERCPU_PAGE_SIZE;	/* ensure percpu data fits
diff -puN arch/m32r/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface arch/m32r/kernel/vmlinux.lds.S
--- a/arch/m32r/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface
+++ a/arch/m32r/kernel/vmlinux.lds.S
@@ -110,10 +110,7 @@ SECTIONS
   __initramfs_end = .;
 #endif
 
-  . = ALIGN(4096);
-  __per_cpu_start = .;
-  .data.percpu  : { *(.data.percpu) }
-  __per_cpu_end = .;
+  PERCPU(4096)
   . = ALIGN(4096);
   __init_end = .;
   /* freed after init ends here */
diff -puN arch/mips/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface arch/mips/kernel/vmlinux.lds.S
--- a/arch/mips/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface
+++ a/arch/mips/kernel/vmlinux.lds.S
@@ -119,10 +119,7 @@ SECTIONS
   .init.ramfs : { *(.init.ramfs) }
   __initramfs_end = .;
 #endif
-  . = ALIGN(_PAGE_SIZE);
-  __per_cpu_start = .;
-  .data.percpu  : { *(.data.percpu) }
-  __per_cpu_end = .;
+  PERCPU(_PAGE_SIZE)
   . = ALIGN(_PAGE_SIZE);
   __init_end = .;
   /* freed after init ends here */
diff -puN arch/parisc/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface arch/parisc/kernel/vmlinux.lds.S
--- a/arch/parisc/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface
+++ a/arch/parisc/kernel/vmlinux.lds.S
@@ -181,10 +181,9 @@ SECTIONS
   .init.ramfs : { *(.init.ramfs) }
   __initramfs_end = .;
 #endif
-  . = ALIGN(ASM_PAGE_SIZE);
-  __per_cpu_start = .;
-  .data.percpu  : { *(.data.percpu) }
-  __per_cpu_end = .;
+
+  PERCPU(ASM_PAGE_SIZE)
+
   . = ALIGN(ASM_PAGE_SIZE);
   __init_end = .;
   /* freed after init ends here */
diff -puN arch/powerpc/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface arch/powerpc/kernel/vmlinux.lds.S
--- a/arch/powerpc/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface
+++ a/arch/powerpc/kernel/vmlinux.lds.S
@@ -139,12 +139,7 @@ SECTIONS
 		__initramfs_end = .;
 	}
 #endif
-	. = ALIGN(PAGE_SIZE);
-	.data.percpu : {
-		__per_cpu_start = .;
-		*(.data.percpu)
-		__per_cpu_end = .;
-	}
+	PERCPU(PAGE_SIZE)
 
 	. = ALIGN(8);
 	.machine.desc : {
diff -puN arch/ppc/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface arch/ppc/kernel/vmlinux.lds.S
--- a/arch/ppc/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface
+++ a/arch/ppc/kernel/vmlinux.lds.S
@@ -130,10 +130,7 @@ SECTIONS
   __ftr_fixup : { *(__ftr_fixup) }
   __stop___ftr_fixup = .;
 
-  . = ALIGN(4096);
-  __per_cpu_start = .;
-  .data.percpu  : { *(.data.percpu) }
-  __per_cpu_end = .;
+  PERCPU(4096)
 
 #ifdef CONFIG_BLK_DEV_INITRD
   . = ALIGN(4096);
diff -puN arch/s390/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface arch/s390/kernel/vmlinux.lds.S
--- a/arch/s390/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface
+++ a/arch/s390/kernel/vmlinux.lds.S
@@ -107,10 +107,7 @@ SECTIONS
   . = ALIGN(2);
   __initramfs_end = .;
 #endif
-  . = ALIGN(4096);
-  __per_cpu_start = .;
-  .data.percpu  : { *(.data.percpu) }
-  __per_cpu_end = .;
+  PERCPU(4096)
   . = ALIGN(4096);
   __init_end = .;
   /* freed after init ends here */
diff -puN arch/sh/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface arch/sh/kernel/vmlinux.lds.S
--- a/arch/sh/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface
+++ a/arch/sh/kernel/vmlinux.lds.S
@@ -60,10 +60,7 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   __nosave_end = .;
 
-  . = ALIGN(PAGE_SIZE);
-  __per_cpu_start = .;
-  .data.percpu : { *(.data.percpu) }
-  __per_cpu_end = .;
+  PERCPU(PAGE_SIZE)
   .data.cacheline_aligned : { *(.data.cacheline_aligned) }
 
   _edata = .;			/* End of data section */
diff -puN arch/sh64/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface arch/sh64/kernel/vmlinux.lds.S
--- a/arch/sh64/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface
+++ a/arch/sh64/kernel/vmlinux.lds.S
@@ -85,10 +85,7 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   .data.page_aligned : C_PHYS(.data.page_aligned) { *(.data.page_aligned) }
 
-  . = ALIGN(PAGE_SIZE);
-  __per_cpu_start = .;
-  .data.percpu : C_PHYS(.data.percpu) { *(.data.percpu) }
-  __per_cpu_end = . ;
+  PERCPU(PAGE_SIZE)
   .data.cacheline_aligned : C_PHYS(.data.cacheline_aligned) { *(.data.cacheline_aligned) }
 
   _edata = .;			/* End of data section */
diff -puN arch/sparc/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface arch/sparc/kernel/vmlinux.lds.S
--- a/arch/sparc/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface
+++ a/arch/sparc/kernel/vmlinux.lds.S
@@ -65,10 +65,7 @@ SECTIONS
   __initramfs_end = .;
 #endif
 
-  . = ALIGN(4096);
-  __per_cpu_start = .;
-  .data.percpu  : { *(.data.percpu) }
-  __per_cpu_end = .;
+  PERCPU(4096)
   . = ALIGN(4096);
   __init_end = .;
   . = ALIGN(32);
diff -puN arch/sparc64/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface arch/sparc64/kernel/vmlinux.lds.S
--- a/arch/sparc64/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface
+++ a/arch/sparc64/kernel/vmlinux.lds.S
@@ -89,10 +89,7 @@ SECTIONS
   __initramfs_end = .;
 #endif
 
-  . = ALIGN(8192);
-  __per_cpu_start = .;
-  .data.percpu  : { *(.data.percpu) }
-  __per_cpu_end = .;
+  PERCPU(8192)
   . = ALIGN(8192);
   __init_end = .;
   __bss_start = .;
diff -puN arch/x86_64/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface arch/x86_64/kernel/vmlinux.lds.S
--- a/arch/x86_64/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface
+++ a/arch/x86_64/kernel/vmlinux.lds.S
@@ -203,10 +203,8 @@ SECTIONS
   __initramfs_end = .;
 #endif
 
-  . = ALIGN(4096);
-  __per_cpu_start = .;
-  .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) { *(.data.percpu) }
-  __per_cpu_end = .;
+  PERCPU(4096)
+
   . = ALIGN(4096);
   __init_end = .;
 
diff -puN arch/xtensa/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface arch/xtensa/kernel/vmlinux.lds.S
--- a/arch/xtensa/kernel/vmlinux.lds.S~define-percpu-smp-cacheline-align-interface
+++ a/arch/xtensa/kernel/vmlinux.lds.S
@@ -198,10 +198,7 @@ SECTIONS
   __ftr_fixup : { *(__ftr_fixup) }
   __stop___ftr_fixup = .;
 
-  . = ALIGN(4096);
-  __per_cpu_start = .;
-  .data.percpu  : { *(.data.percpu) }
-  __per_cpu_end = .;
+  PERCPU(4096)
 
 #ifdef CONFIG_BLK_DEV_INITRD
   . = ALIGN(4096);
diff -puN include/asm-generic/percpu.h~define-percpu-smp-cacheline-align-interface include/asm-generic/percpu.h
--- a/include/asm-generic/percpu.h~define-percpu-smp-cacheline-align-interface
+++ a/include/asm-generic/percpu.h
@@ -14,6 +14,11 @@ extern unsigned long __per_cpu_offset[NR
 #define DEFINE_PER_CPU(type, name) \
     __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
 
+#define DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED(type, name)		  \
+    __attribute__((__section__(".data.percpu.shared_cacheline_aligned"))) \
+    __typeof__(type) per_cpu__##name					  \
+    ____cacheline_aligned_in_smp
+
 /* var is in discarded region: offset to particular copy we want */
 #define per_cpu(var, cpu) (*({				\
 	extern int simple_identifier_##var(void);	\
@@ -34,6 +39,9 @@ do {								\
 #define DEFINE_PER_CPU(type, name) \
     __typeof__(type) per_cpu__##name
 
+#define DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED(type, name)	\
+    DEFINE_PER_CPU(type, name)
+
 #define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
 #define __get_cpu_var(var)			per_cpu__##var
 #define __raw_get_cpu_var(var)			per_cpu__##var
diff -puN include/asm-generic/vmlinux.lds.h~define-percpu-smp-cacheline-align-interface include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~define-percpu-smp-cacheline-align-interface
+++ a/include/asm-generic/vmlinux.lds.h
@@ -251,3 +251,11 @@
   	*(.initcall7.init)						\
   	*(.initcall7s.init)
 
+#define PERCPU(align)							\
+	. = ALIGN(align);						\
+	__per_cpu_start = .;						\
+	.data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {		\
+		*(.data.percpu)						\
+		*(.data.percpu.shared_cacheline_aligned)		\
+	}								\
+	__per_cpu_end = .;
diff -puN include/asm-i386/percpu.h~define-percpu-smp-cacheline-align-interface include/asm-i386/percpu.h
--- a/include/asm-i386/percpu.h~define-percpu-smp-cacheline-align-interface
+++ a/include/asm-i386/percpu.h
@@ -54,6 +54,11 @@ extern unsigned long __per_cpu_offset[];
 #define DEFINE_PER_CPU(type, name) \
     __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
 
+#define DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED(type, name)		  \
+    __attribute__((__section__(".data.percpu.shared_cacheline_aligned"))) \
+    __typeof__(type) per_cpu__##name					  \
+    ____cacheline_aligned_in_smp
+
 /* We can use this directly for local CPU (faster). */
 DECLARE_PER_CPU(unsigned long, this_cpu_off);
 
diff -puN include/asm-ia64/percpu.h~define-percpu-smp-cacheline-align-interface include/asm-ia64/percpu.h
--- a/include/asm-ia64/percpu.h~define-percpu-smp-cacheline-align-interface
+++ a/include/asm-ia64/percpu.h
@@ -29,6 +29,16 @@
 	__attribute__((__section__(".data.percpu")))		\
 	__SMALL_ADDR_AREA __typeof__(type) per_cpu__##name
 
+#ifdef CONFIG_SMP
+#define DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED(type, name)		      \
+	__attribute__((__section__(".data.percpu.shared_cacheline_aligned"))) \
+	__SMALL_ADDR_AREA __typeof__(type) per_cpu__##name		      \
+	____cacheline_aligned_in_smp
+#else
+#define DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED(type, name)	\
+	DEFINE_PER_CPU(type, name)
+#endif
+
 /*
  * Pretty much a literal copy of asm-generic/percpu.h, except that percpu_modcopy() is an
  * external routine, to avoid include-hell.
diff -puN include/asm-powerpc/percpu.h~define-percpu-smp-cacheline-align-interface include/asm-powerpc/percpu.h
--- a/include/asm-powerpc/percpu.h~define-percpu-smp-cacheline-align-interface
+++ a/include/asm-powerpc/percpu.h
@@ -20,6 +20,11 @@
 #define DEFINE_PER_CPU(type, name) \
     __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
 
+#define DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED(type, name)		  \
+    __attribute__((__section__(".data.percpu.shared_cacheline_aligned"))) \
+    __typeof__(type) per_cpu__##name					  \
+    ____cacheline_aligned_in_smp
+
 /* var is in discarded region: offset to particular copy we want */
 #define per_cpu(var, cpu) (*RELOC_HIDE(&per_cpu__##var, __per_cpu_offset(cpu)))
 #define __get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __my_cpu_offset()))
@@ -40,6 +45,8 @@ extern void setup_per_cpu_areas(void);
 
 #define DEFINE_PER_CPU(type, name) \
     __typeof__(type) per_cpu__##name
+#define DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED(type, name)	\
+    DEFINE_PER_CPU(type, name)
 
 #define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
 #define __get_cpu_var(var)			per_cpu__##var
diff -puN include/asm-s390/percpu.h~define-percpu-smp-cacheline-align-interface include/asm-s390/percpu.h
--- a/include/asm-s390/percpu.h~define-percpu-smp-cacheline-align-interface
+++ a/include/asm-s390/percpu.h
@@ -41,6 +41,11 @@ extern unsigned long __per_cpu_offset[NR
     __attribute__((__section__(".data.percpu"))) \
     __typeof__(type) per_cpu__##name
 
+#define DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED(type, name)		  \
+    __attribute__((__section__(".data.percpu.shared_cacheline_aligned"))) \
+    __typeof__(type) per_cpu__##name					  \
+    ____cacheline_aligned_in_smp
+
 #define __get_cpu_var(var) __reloc_hide(var,S390_lowcore.percpu_offset)
 #define __raw_get_cpu_var(var) __reloc_hide(var,S390_lowcore.percpu_offset)
 #define per_cpu(var,cpu) __reloc_hide(var,__per_cpu_offset[cpu])
@@ -59,6 +64,8 @@ do {								\
 
 #define DEFINE_PER_CPU(type, name) \
     __typeof__(type) per_cpu__##name
+#define DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED(type, name)	\
+    DEFINE_PER_CPU(type, name)
 
 #define __get_cpu_var(var) __reloc_hide(var,0)
 #define __raw_get_cpu_var(var) __reloc_hide(var,0)
diff -puN include/asm-sparc64/percpu.h~define-percpu-smp-cacheline-align-interface include/asm-sparc64/percpu.h
--- a/include/asm-sparc64/percpu.h~define-percpu-smp-cacheline-align-interface
+++ a/include/asm-sparc64/percpu.h
@@ -17,6 +17,11 @@ extern unsigned long __per_cpu_shift;
 #define DEFINE_PER_CPU(type, name) \
     __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
 
+#define DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED(type, name)		  \
+    __attribute__((__section__(".data.percpu.shared_cacheline_aligned"))) \
+    __typeof__(type) per_cpu__##name					  \
+    ____cacheline_aligned_in_smp
+
 register unsigned long __local_per_cpu_offset asm("g5");
 
 /* var is in discarded region: offset to particular copy we want */
@@ -36,6 +41,8 @@ do {								\
 
 #define DEFINE_PER_CPU(type, name) \
     __typeof__(type) per_cpu__##name
+#define DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED(type, name)	\
+    DEFINE_PER_CPU(type, name)
 
 #define per_cpu(var, cpu)			(*((void)cpu, &per_cpu__##var))
 #define __get_cpu_var(var)			per_cpu__##var
diff -puN include/asm-x86_64/percpu.h~define-percpu-smp-cacheline-align-interface include/asm-x86_64/percpu.h
--- a/include/asm-x86_64/percpu.h~define-percpu-smp-cacheline-align-interface
+++ a/include/asm-x86_64/percpu.h
@@ -20,6 +20,11 @@
 #define DEFINE_PER_CPU(type, name) \
     __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
 
+#define DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED(type, name)		  \
+    __attribute__((__section__(".data.percpu.shared_cacheline_aligned"))) \
+    __typeof__(type) per_cpu__##name					  \
+    ____cacheline_internodealigned_in_smp
+
 /* var is in discarded region: offset to particular copy we want */
 #define per_cpu(var, cpu) (*({				\
 	extern int simple_identifier_##var(void);	\
@@ -46,6 +51,8 @@ extern void setup_per_cpu_areas(void);
 
 #define DEFINE_PER_CPU(type, name) \
     __typeof__(type) per_cpu__##name
+#define DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED(type, name)	\
+    DEFINE_PER_CPU(type, name)
 
 #define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
 #define __get_cpu_var(var)			per_cpu__##var
_

Patches currently in -mm which might be from fenghua.yu@intel.com are

define-percpu-smp-cacheline-align-interface.patch
call-percpu-smp-cacheline-algin-interface.patch
