From: akpm@linux-foundation.org
Subject: - define-new-percpu-interface-for-shared-data.patch removed from -mm tree
Date: Wed, 06 Jun 2007 10:13:48 -0700
Message-ID: <200706061713.l56HDmvP002060@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41733 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751330AbXFFROd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 13:14:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fenghua.yu@intel.com, clameter@sgi.com, kiran@scalex86.org, linux-arch@vger.kernel.org, rusty@rustcorp.com.au, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     Define new percpu interface for shared data
has been removed from the -mm tree.  Its filename was
     define-new-percpu-interface-for-shared-data.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: Define new percpu interface for shared data
From: Fenghua Yu <fenghua.yu@intel.com>

per cpu data section contains two types of data.  One set which is exclusively
accessed by the local cpu and the other set which is per cpu, but also shared
by remote cpus.  In the current kernel, these two sets are not clearely
separated out.  This can potentially cause the same data cacheline shared
between the two sets of data, which will result in unnecessary bouncing of the
cacheline between cpus.

One way to fix the problem is to cacheline align the remotely accessed per cpu
data, both at the beginning and at the end.  Because of the padding at both
ends, this will likely cause some memory wastage and also the interface to
achieve this is not clean.

Depending on how linker places percpu data, the patches could
increase or decrease percpu section size. Data from 2.6.21-rc7-mm2:

On x86 SMP, the section size is increased from 0x7768 to 0x790c.
1.3% increase.

On X86-64 SMP, the size is decreased from 0x72d0 to 0x6540.
11.8% decrease.

On X86-64 VSMP, the size is increased from 0x72d0 to 0x8340.
14.3% increase.

On IA64 SMP, the size is decreased from 0x8370 to 0x7fc0.
2.8% decrease.


This patch:

Moves the remotely accessed per cpu data (which is currently marked
as ____cacheline_aligned_in_smp) into a different section, where all the data
elements are cacheline aligned. And as such, this differentiates the local
only data and remotely accessed data cleanly.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: <linux-arch@vger.kernel.org>
Acked-by: Ravikiran Thirumalai <kiran@scalex86.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/vmlinux.lds.S   |    5 +----
 arch/arm/kernel/vmlinux.lds.S     |    1 +
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
 26 files changed, 80 insertions(+), 68 deletions(-)

diff -puN arch/alpha/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data arch/alpha/kernel/vmlinux.lds.S
--- a/arch/alpha/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data
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
diff -puN arch/arm/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data arch/arm/kernel/vmlinux.lds.S
--- a/arch/arm/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data
+++ a/arch/arm/kernel/vmlinux.lds.S
@@ -66,6 +66,7 @@ SECTIONS
 		. = ALIGN(4096);
 		__per_cpu_start = .;
 			*(.data.percpu)
+			*(.data.percpu.shared_aligned)
 		__per_cpu_end = .;
 #ifndef CONFIG_XIP_KERNEL
 		__init_begin = _stext;
diff -puN arch/cris/arch-v32/vmlinux.lds.S~define-new-percpu-interface-for-shared-data arch/cris/arch-v32/vmlinux.lds.S
--- a/arch/cris/arch-v32/vmlinux.lds.S~define-new-percpu-interface-for-shared-data
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
diff -puN arch/frv/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data arch/frv/kernel/vmlinux.lds.S
--- a/arch/frv/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data
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
diff -puN arch/i386/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data arch/i386/kernel/vmlinux.lds.S
--- a/arch/i386/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data
+++ a/arch/i386/kernel/vmlinux.lds.S
@@ -179,12 +179,7 @@ SECTIONS
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
 	
diff -puN arch/ia64/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data arch/ia64/kernel/vmlinux.lds.S
--- a/arch/ia64/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data
+++ a/arch/ia64/kernel/vmlinux.lds.S
@@ -206,6 +206,7 @@ SECTIONS
 	{
 		__per_cpu_start = .;
 		*(.data.percpu)
+		*(.data.percpu.shared_aligned)
 		__per_cpu_end = .;
 	}
   . = __phys_per_cpu_start + PERCPU_PAGE_SIZE;	/* ensure percpu data fits
diff -puN arch/m32r/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data arch/m32r/kernel/vmlinux.lds.S
--- a/arch/m32r/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data
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
diff -puN arch/mips/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data arch/mips/kernel/vmlinux.lds.S
--- a/arch/mips/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data
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
diff -puN arch/parisc/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data arch/parisc/kernel/vmlinux.lds.S
--- a/arch/parisc/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data
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
diff -puN arch/powerpc/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data arch/powerpc/kernel/vmlinux.lds.S
--- a/arch/powerpc/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data
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
diff -puN arch/ppc/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data arch/ppc/kernel/vmlinux.lds.S
--- a/arch/ppc/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data
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
diff -puN arch/s390/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data arch/s390/kernel/vmlinux.lds.S
--- a/arch/s390/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data
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
diff -puN arch/sh/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data arch/sh/kernel/vmlinux.lds.S
--- a/arch/sh/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data
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
diff -puN arch/sh64/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data arch/sh64/kernel/vmlinux.lds.S
--- a/arch/sh64/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data
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
diff -puN arch/sparc/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data arch/sparc/kernel/vmlinux.lds.S
--- a/arch/sparc/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data
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
diff -puN arch/sparc64/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data arch/sparc64/kernel/vmlinux.lds.S
--- a/arch/sparc64/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data
+++ a/arch/sparc64/kernel/vmlinux.lds.S
@@ -90,10 +90,7 @@ SECTIONS
   __initramfs_end = .;
 #endif
 
-  . = ALIGN(PAGE_SIZE);
-  __per_cpu_start = .;
-  .data.percpu  : { *(.data.percpu) }
-  __per_cpu_end = .;
+  PERCPU(PAGE_SIZE)
   . = ALIGN(PAGE_SIZE);
   __init_end = .;
   __bss_start = .;
diff -puN arch/x86_64/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data arch/x86_64/kernel/vmlinux.lds.S
--- a/arch/x86_64/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data
+++ a/arch/x86_64/kernel/vmlinux.lds.S
@@ -210,10 +210,8 @@ SECTIONS
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
 
diff -puN arch/xtensa/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data arch/xtensa/kernel/vmlinux.lds.S
--- a/arch/xtensa/kernel/vmlinux.lds.S~define-new-percpu-interface-for-shared-data
+++ a/arch/xtensa/kernel/vmlinux.lds.S
@@ -190,10 +190,7 @@ SECTIONS
   __initramfs_end = .;
 #endif
 
-  . = ALIGN(4096);
-  __per_cpu_start = .;
-  .data.percpu  : { *(.data.percpu) }
-  __per_cpu_end = .;
+  PERCPU(4096)
 
 
   /* We need this dummy segment here */
diff -puN include/asm-generic/percpu.h~define-new-percpu-interface-for-shared-data include/asm-generic/percpu.h
--- a/include/asm-generic/percpu.h~define-new-percpu-interface-for-shared-data
+++ a/include/asm-generic/percpu.h
@@ -14,6 +14,11 @@ extern unsigned long __per_cpu_offset[NR
 #define DEFINE_PER_CPU(type, name) \
     __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
 
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
+    __attribute__((__section__(".data.percpu.shared_aligned"))) \
+    __typeof__(type) per_cpu__##name				\
+    ____cacheline_aligned_in_smp
+
 /* var is in discarded region: offset to particular copy we want */
 #define per_cpu(var, cpu) (*({				\
 	extern int simple_identifier_##var(void);	\
@@ -34,6 +39,9 @@ do {								\
 #define DEFINE_PER_CPU(type, name) \
     __typeof__(type) per_cpu__##name
 
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
+    DEFINE_PER_CPU(type, name)
+
 #define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
 #define __get_cpu_var(var)			per_cpu__##var
 #define __raw_get_cpu_var(var)			per_cpu__##var
diff -puN include/asm-generic/vmlinux.lds.h~define-new-percpu-interface-for-shared-data include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~define-new-percpu-interface-for-shared-data
+++ a/include/asm-generic/vmlinux.lds.h
@@ -267,3 +267,11 @@
   	*(.initcall7.init)						\
   	*(.initcall7s.init)
 
+#define PERCPU(align)							\
+	. = ALIGN(align);						\
+	__per_cpu_start = .;						\
+	.data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {		\
+		*(.data.percpu)						\
+		*(.data.percpu.shared_aligned)				\
+	}								\
+	__per_cpu_end = .;
diff -puN include/asm-i386/percpu.h~define-new-percpu-interface-for-shared-data include/asm-i386/percpu.h
--- a/include/asm-i386/percpu.h~define-new-percpu-interface-for-shared-data
+++ a/include/asm-i386/percpu.h
@@ -54,6 +54,11 @@ extern unsigned long __per_cpu_offset[];
 #define DEFINE_PER_CPU(type, name) \
     __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
 
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
+    __attribute__((__section__(".data.percpu.shared_aligned"))) \
+    __typeof__(type) per_cpu__##name				\
+    ____cacheline_aligned_in_smp
+
 /* We can use this directly for local CPU (faster). */
 DECLARE_PER_CPU(unsigned long, this_cpu_off);
 
diff -puN include/asm-ia64/percpu.h~define-new-percpu-interface-for-shared-data include/asm-ia64/percpu.h
--- a/include/asm-ia64/percpu.h~define-new-percpu-interface-for-shared-data
+++ a/include/asm-ia64/percpu.h
@@ -29,6 +29,16 @@
 	__attribute__((__section__(".data.percpu")))		\
 	__SMALL_ADDR_AREA __typeof__(type) per_cpu__##name
 
+#ifdef CONFIG_SMP
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
+	__attribute__((__section__(".data.percpu.shared_aligned")))	\
+	__SMALL_ADDR_AREA __typeof__(type) per_cpu__##name		\
+	____cacheline_aligned_in_smp
+#else
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
+	DEFINE_PER_CPU(type, name)
+#endif
+
 /*
  * Pretty much a literal copy of asm-generic/percpu.h, except that percpu_modcopy() is an
  * external routine, to avoid include-hell.
diff -puN include/asm-powerpc/percpu.h~define-new-percpu-interface-for-shared-data include/asm-powerpc/percpu.h
--- a/include/asm-powerpc/percpu.h~define-new-percpu-interface-for-shared-data
+++ a/include/asm-powerpc/percpu.h
@@ -20,6 +20,11 @@
 #define DEFINE_PER_CPU(type, name) \
     __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
 
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
+    __attribute__((__section__(".data.percpu.shared_aligned"))) \
+    __typeof__(type) per_cpu__##name				\
+    ____cacheline_aligned_in_smp
+
 /* var is in discarded region: offset to particular copy we want */
 #define per_cpu(var, cpu) (*RELOC_HIDE(&per_cpu__##var, __per_cpu_offset(cpu)))
 #define __get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __my_cpu_offset()))
@@ -40,6 +45,8 @@ extern void setup_per_cpu_areas(void);
 
 #define DEFINE_PER_CPU(type, name) \
     __typeof__(type) per_cpu__##name
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
+    DEFINE_PER_CPU(type, name)
 
 #define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
 #define __get_cpu_var(var)			per_cpu__##var
diff -puN include/asm-s390/percpu.h~define-new-percpu-interface-for-shared-data include/asm-s390/percpu.h
--- a/include/asm-s390/percpu.h~define-new-percpu-interface-for-shared-data
+++ a/include/asm-s390/percpu.h
@@ -41,6 +41,11 @@ extern unsigned long __per_cpu_offset[NR
     __attribute__((__section__(".data.percpu"))) \
     __typeof__(type) per_cpu__##name
 
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
+    __attribute__((__section__(".data.percpu.shared_aligned"))) \
+    __typeof__(type) per_cpu__##name				\
+    ____cacheline_aligned_in_smp
+
 #define __get_cpu_var(var) __reloc_hide(var,S390_lowcore.percpu_offset)
 #define __raw_get_cpu_var(var) __reloc_hide(var,S390_lowcore.percpu_offset)
 #define per_cpu(var,cpu) __reloc_hide(var,__per_cpu_offset[cpu])
@@ -59,6 +64,8 @@ do {								\
 
 #define DEFINE_PER_CPU(type, name) \
     __typeof__(type) per_cpu__##name
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
+    DEFINE_PER_CPU(type, name)
 
 #define __get_cpu_var(var) __reloc_hide(var,0)
 #define __raw_get_cpu_var(var) __reloc_hide(var,0)
diff -puN include/asm-sparc64/percpu.h~define-new-percpu-interface-for-shared-data include/asm-sparc64/percpu.h
--- a/include/asm-sparc64/percpu.h~define-new-percpu-interface-for-shared-data
+++ a/include/asm-sparc64/percpu.h
@@ -18,6 +18,11 @@ extern unsigned long __per_cpu_shift;
 #define DEFINE_PER_CPU(type, name) \
     __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
 
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
+    __attribute__((__section__(".data.percpu.shared_aligned"))) \
+    __typeof__(type) per_cpu__##name				\
+    ____cacheline_aligned_in_smp
+
 register unsigned long __local_per_cpu_offset asm("g5");
 
 /* var is in discarded region: offset to particular copy we want */
@@ -38,6 +43,8 @@ do {								\
 #define real_setup_per_cpu_areas()		do { } while (0)
 #define DEFINE_PER_CPU(type, name) \
     __typeof__(type) per_cpu__##name
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
+    DEFINE_PER_CPU(type, name)
 
 #define per_cpu(var, cpu)			(*((void)cpu, &per_cpu__##var))
 #define __get_cpu_var(var)			per_cpu__##var
diff -puN include/asm-x86_64/percpu.h~define-new-percpu-interface-for-shared-data include/asm-x86_64/percpu.h
--- a/include/asm-x86_64/percpu.h~define-new-percpu-interface-for-shared-data
+++ a/include/asm-x86_64/percpu.h
@@ -20,6 +20,11 @@
 #define DEFINE_PER_CPU(type, name) \
     __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
 
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
+    __attribute__((__section__(".data.percpu.shared_aligned"))) \
+    __typeof__(type) per_cpu__##name				\
+    ____cacheline_internodealigned_in_smp
+
 /* var is in discarded region: offset to particular copy we want */
 #define per_cpu(var, cpu) (*({				\
 	extern int simple_identifier_##var(void);	\
@@ -46,6 +51,8 @@ extern void setup_per_cpu_areas(void);
 
 #define DEFINE_PER_CPU(type, name) \
     __typeof__(type) per_cpu__##name
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
+    DEFINE_PER_CPU(type, name)
 
 #define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
 #define __get_cpu_var(var)			per_cpu__##var
_

Patches currently in -mm which might be from fenghua.yu@intel.com are

define-new-percpu-interface-for-shared-data.patch
use-the-new-percpu-interface-for-shared-data.patch
