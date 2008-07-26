From: akpm@linux-foundation.org
Subject: - kexec-jump.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:14:09 -0700
Message-ID: <200807262114.m6QLE9Dg019675@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757580AbYGZVPO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:15:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, ebiederm@xmission.com, mingo@elte.hu, nigel@nigel.suspend2.net, pavel@ucw.cz, rjw@sisk.pl, tglx@linutronix.de, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kexec jump
has been removed from the -mm tree.  Its filename was
     kexec-jump.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec jump
From: Huang Ying <ying.huang@intel.com>

This patch provides an enhancement to kexec/kdump.  It implements the
following features:

- Backup/restore memory used by the original kernel before/after
  kexec.

- Save/restore CPU state before/after kexec.

The features of this patch can be used as a general method to call program in
physical mode (paging turning off).  This can be used to call BIOS code under
Linux.

kexec-tools needs to be patched to support kexec jump. The patches and
the precompiled kexec can be download from the following URL:

       source: http://khibernation.sourceforge.net/download/release_v10/kexec-tools/kexec-tools-src_git_kh10.tar.bz2
       patches: http://khibernation.sourceforge.net/download/release_v10/kexec-tools/kexec-tools-patches_git_kh10.tar.bz2
       binary: http://khibernation.sourceforge.net/download/release_v10/kexec-tools/kexec_git_kh10

Usage example of calling some physical mode code and return:

1. Compile and install patched kernel with following options selected:

CONFIG_X86_32=y
CONFIG_KEXEC=y
CONFIG_PM=y
CONFIG_KEXEC_JUMP=y

2. Build patched kexec-tool or download the pre-built one.

3. Build some physical mode executable named such as "phy_mode"

4. Boot kernel compiled in step 1.

5. Load physical mode executable with /sbin/kexec. The shell command
   line can be as follow:

   /sbin/kexec --load-preserve-context --args-none phy_mode

6. Call physical mode executable with following shell command line:

   /sbin/kexec -e

Implementation point:

To support jumping without reserving memory.  One shadow backup page (source
page) is allocated for each page used by kexeced code image (destination
page).  When do kexec_load, the image of kexeced code is loaded into source
pages, and before executing, the destination pages and the source pages are
swapped, so the contents of destination pages are backupped.  Before jumping
to the kexeced code image and after jumping back to the original kernel, the
destination pages and the source pages are swapped too.

C ABI (calling convention) is used as communication protocol between
kernel and called code.

A flag named KEXEC_PRESERVE_CONTEXT for sys_kexec_load is added to
indicate that the loaded kernel image is used for jumping back.

Now, only the i386 architecture is supported.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/machine_kexec.c  |    2 
 arch/sh/kernel/machine_kexec.c       |    2 
 arch/x86/Kconfig                     |    7 +
 arch/x86/kernel/machine_kexec_32.c   |   27 +++
 arch/x86/kernel/machine_kexec_64.c   |    2 
 arch/x86/kernel/relocate_kernel_32.S |  174 +++++++++++++++++++++----
 include/asm-x86/kexec.h              |   18 +-
 include/linux/kexec.h                |   17 +-
 kernel/kexec.c                       |   57 ++++++++
 kernel/sys.c                         |   31 +---
 10 files changed, 269 insertions(+), 68 deletions(-)

diff -puN arch/powerpc/kernel/machine_kexec.c~kexec-jump arch/powerpc/kernel/machine_kexec.c
--- a/arch/powerpc/kernel/machine_kexec.c~kexec-jump
+++ a/arch/powerpc/kernel/machine_kexec.c
@@ -48,7 +48,7 @@ void machine_kexec_cleanup(struct kimage
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
  */
-NORET_TYPE void machine_kexec(struct kimage *image)
+void machine_kexec(struct kimage *image)
 {
 	if (ppc_md.machine_kexec)
 		ppc_md.machine_kexec(image);
diff -puN arch/sh/kernel/machine_kexec.c~kexec-jump arch/sh/kernel/machine_kexec.c
--- a/arch/sh/kernel/machine_kexec.c~kexec-jump
+++ a/arch/sh/kernel/machine_kexec.c
@@ -70,7 +70,7 @@ static void kexec_info(struct kimage *im
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
  */
-NORET_TYPE void machine_kexec(struct kimage *image)
+void machine_kexec(struct kimage *image)
 {
 
 	unsigned long page_list;
diff -puN arch/x86/Kconfig~kexec-jump arch/x86/Kconfig
--- a/arch/x86/Kconfig~kexec-jump
+++ a/arch/x86/Kconfig
@@ -1279,6 +1279,13 @@ config CRASH_DUMP
 	  (CONFIG_RELOCATABLE=y).
 	  For more details see Documentation/kdump/kdump.txt
 
+config KEXEC_JUMP
+	bool "kexec jump (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	depends on KEXEC && PM_SLEEP && X86_32
+	help
+	  Invoke code in physical address mode via KEXEC
+
 config PHYSICAL_START
 	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP)
 	default "0x1000000" if X86_NUMAQ
diff -puN arch/x86/kernel/machine_kexec_32.c~kexec-jump arch/x86/kernel/machine_kexec_32.c
--- a/arch/x86/kernel/machine_kexec_32.c~kexec-jump
+++ a/arch/x86/kernel/machine_kexec_32.c
@@ -22,6 +22,7 @@
 #include <asm/cpufeature.h>
 #include <asm/desc.h>
 #include <asm/system.h>
+#include <asm/cacheflush.h>
 
 #define PAGE_ALIGNED __attribute__ ((__aligned__(PAGE_SIZE)))
 static u32 kexec_pgd[1024] PAGE_ALIGNED;
@@ -85,10 +86,12 @@ static void load_segments(void)
  * reboot code buffer to allow us to avoid allocations
  * later.
  *
- * Currently nothing.
+ * Make control page executable.
  */
 int machine_kexec_prepare(struct kimage *image)
 {
+	if (nx_enabled)
+		set_pages_x(image->control_code_page, 1);
 	return 0;
 }
 
@@ -98,16 +101,24 @@ int machine_kexec_prepare(struct kimage 
  */
 void machine_kexec_cleanup(struct kimage *image)
 {
+	if (nx_enabled)
+		set_pages_nx(image->control_code_page, 1);
 }
 
 /*
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
  */
-NORET_TYPE void machine_kexec(struct kimage *image)
+void machine_kexec(struct kimage *image)
 {
 	unsigned long page_list[PAGES_NR];
 	void *control_page;
+	asmlinkage unsigned long
+		(*relocate_kernel_ptr)(unsigned long indirection_page,
+				       unsigned long control_page,
+				       unsigned long start_address,
+				       unsigned int has_pae,
+				       unsigned int preserve_context);
 
 	tracer_disable();
 
@@ -115,10 +126,11 @@ NORET_TYPE void machine_kexec(struct kim
 	local_irq_disable();
 
 	control_page = page_address(image->control_code_page);
-	memcpy(control_page, relocate_kernel, PAGE_SIZE);
+	memcpy(control_page, relocate_kernel, PAGE_SIZE/2);
 
+	relocate_kernel_ptr = control_page;
 	page_list[PA_CONTROL_PAGE] = __pa(control_page);
-	page_list[VA_CONTROL_PAGE] = (unsigned long)relocate_kernel;
+	page_list[VA_CONTROL_PAGE] = (unsigned long)control_page;
 	page_list[PA_PGD] = __pa(kexec_pgd);
 	page_list[VA_PGD] = (unsigned long)kexec_pgd;
 #ifdef CONFIG_X86_PAE
@@ -131,6 +143,7 @@ NORET_TYPE void machine_kexec(struct kim
 	page_list[VA_PTE_0] = (unsigned long)kexec_pte0;
 	page_list[PA_PTE_1] = __pa(kexec_pte1);
 	page_list[VA_PTE_1] = (unsigned long)kexec_pte1;
+	page_list[PA_SWAP_PAGE] = (page_to_pfn(image->swap_page) << PAGE_SHIFT);
 
 	/* The segment registers are funny things, they have both a
 	 * visible and an invisible part.  Whenever the visible part is
@@ -149,8 +162,10 @@ NORET_TYPE void machine_kexec(struct kim
 	set_idt(phys_to_virt(0),0);
 
 	/* now call it */
-	relocate_kernel((unsigned long)image->head, (unsigned long)page_list,
-			image->start, cpu_has_pae);
+	image->start = relocate_kernel_ptr((unsigned long)image->head,
+					   (unsigned long)page_list,
+					   image->start, cpu_has_pae,
+					   image->preserve_context);
 }
 
 void arch_crash_save_vmcoreinfo(void)
diff -puN arch/x86/kernel/machine_kexec_64.c~kexec-jump arch/x86/kernel/machine_kexec_64.c
--- a/arch/x86/kernel/machine_kexec_64.c~kexec-jump
+++ a/arch/x86/kernel/machine_kexec_64.c
@@ -181,7 +181,7 @@ void machine_kexec_cleanup(struct kimage
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
  */
-NORET_TYPE void machine_kexec(struct kimage *image)
+void machine_kexec(struct kimage *image)
 {
 	unsigned long page_list[PAGES_NR];
 	void *control_page;
diff -puN arch/x86/kernel/relocate_kernel_32.S~kexec-jump arch/x86/kernel/relocate_kernel_32.S
--- a/arch/x86/kernel/relocate_kernel_32.S~kexec-jump
+++ a/arch/x86/kernel/relocate_kernel_32.S
@@ -20,11 +20,44 @@
 #define PAGE_ATTR (_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED | _PAGE_DIRTY)
 #define PAE_PGD_ATTR (_PAGE_PRESENT)
 
+/* control_page + PAGE_SIZE/2 ~ control_page + PAGE_SIZE * 3/4 are
+ * used to save some data for jumping back
+ */
+#define DATA(offset)		(PAGE_SIZE/2+(offset))
+
+/* Minimal CPU state */
+#define ESP			DATA(0x0)
+#define CR0			DATA(0x4)
+#define CR3			DATA(0x8)
+#define CR4			DATA(0xc)
+
+/* other data */
+#define CP_VA_CONTROL_PAGE	DATA(0x10)
+#define CP_PA_PGD		DATA(0x14)
+#define CP_PA_SWAP_PAGE		DATA(0x18)
+#define CP_PA_BACKUP_PAGES_MAP	DATA(0x1c)
+
 	.text
 	.align PAGE_SIZE
 	.globl relocate_kernel
 relocate_kernel:
-	movl	8(%esp), %ebp /* list of pages */
+	/* Save the CPU context, used for jumping back */
+
+	pushl	%ebx
+	pushl	%esi
+	pushl	%edi
+	pushl	%ebp
+	pushf
+
+	movl	20+8(%esp), %ebp /* list of pages */
+	movl	PTR(VA_CONTROL_PAGE)(%ebp), %edi
+	movl	%esp, ESP(%edi)
+	movl	%cr0, %eax
+	movl	%eax, CR0(%edi)
+	movl	%cr3, %eax
+	movl	%eax, CR3(%edi)
+	movl	%cr4, %eax
+	movl	%eax, CR4(%edi)
 
 #ifdef CONFIG_X86_PAE
 	/* map the control page at its virtual address */
@@ -138,15 +171,25 @@ relocate_kernel:
 
 relocate_new_kernel:
 	/* read the arguments and say goodbye to the stack */
-	movl  4(%esp), %ebx /* page_list */
-	movl  8(%esp), %ebp /* list of pages */
-	movl  12(%esp), %edx /* start address */
-	movl  16(%esp), %ecx /* cpu_has_pae */
+	movl  20+4(%esp), %ebx /* page_list */
+	movl  20+8(%esp), %ebp /* list of pages */
+	movl  20+12(%esp), %edx /* start address */
+	movl  20+16(%esp), %ecx /* cpu_has_pae */
+	movl  20+20(%esp), %esi /* preserve_context */
 
 	/* zero out flags, and disable interrupts */
 	pushl $0
 	popfl
 
+	/* save some information for jumping back */
+	movl	PTR(VA_CONTROL_PAGE)(%ebp), %edi
+	movl	%edi, CP_VA_CONTROL_PAGE(%edi)
+	movl	PTR(PA_PGD)(%ebp), %eax
+	movl	%eax, CP_PA_PGD(%edi)
+	movl	PTR(PA_SWAP_PAGE)(%ebp), %eax
+	movl	%eax, CP_PA_SWAP_PAGE(%edi)
+	movl	%ebx, CP_PA_BACKUP_PAGES_MAP(%edi)
+
 	/* get physical address of control page now */
 	/* this is impossible after page table switch */
 	movl	PTR(PA_CONTROL_PAGE)(%ebp), %edi
@@ -197,8 +240,90 @@ identity_mapped:
 	xorl	%eax, %eax
 	movl	%eax, %cr3
 
+	movl	CP_PA_SWAP_PAGE(%edi), %eax
+	pushl	%eax
+	pushl	%ebx
+	call	swap_pages
+	addl	$8, %esp
+
+	/* To be certain of avoiding problems with self-modifying code
+	 * I need to execute a serializing instruction here.
+	 * So I flush the TLB, it's handy, and not processor dependent.
+	 */
+	xorl	%eax, %eax
+	movl	%eax, %cr3
+
+	/* set all of the registers to known values */
+	/* leave %esp alone */
+
+	testl	%esi, %esi
+	jnz 1f
+	xorl	%edi, %edi
+	xorl	%eax, %eax
+	xorl	%ebx, %ebx
+	xorl    %ecx, %ecx
+	xorl    %edx, %edx
+	xorl    %esi, %esi
+	xorl    %ebp, %ebp
+	ret
+1:
+	popl	%edx
+	movl	CP_PA_SWAP_PAGE(%edi), %esp
+	addl	$PAGE_SIZE, %esp
+2:
+	call	*%edx
+
+	/* get the re-entry point of the peer system */
+	movl	0(%esp), %ebp
+	call	1f
+1:
+	popl	%ebx
+	subl	$(1b - relocate_kernel), %ebx
+	movl	CP_VA_CONTROL_PAGE(%ebx), %edi
+	lea	PAGE_SIZE(%ebx), %esp
+	movl	CP_PA_SWAP_PAGE(%ebx), %eax
+	movl	CP_PA_BACKUP_PAGES_MAP(%ebx), %edx
+	pushl	%eax
+	pushl	%edx
+	call	swap_pages
+	addl	$8, %esp
+	movl	CP_PA_PGD(%ebx), %eax
+	movl	%eax, %cr3
+	movl	%cr0, %eax
+	orl	$(1<<31), %eax
+	movl	%eax, %cr0
+	lea	PAGE_SIZE(%edi), %esp
+	movl	%edi, %eax
+	addl	$(virtual_mapped - relocate_kernel), %eax
+	pushl	%eax
+	ret
+
+virtual_mapped:
+	movl	CR4(%edi), %eax
+	movl	%eax, %cr4
+	movl	CR3(%edi), %eax
+	movl	%eax, %cr3
+	movl	CR0(%edi), %eax
+	movl	%eax, %cr0
+	movl	ESP(%edi), %esp
+	movl	%ebp, %eax
+
+	popf
+	popl	%ebp
+	popl	%edi
+	popl	%esi
+	popl	%ebx
+	ret
+
 	/* Do the copies */
-	movl	%ebx, %ecx
+swap_pages:
+	movl	8(%esp), %edx
+	movl	4(%esp), %ecx
+	pushl	%ebp
+	pushl	%ebx
+	pushl	%edi
+	pushl	%esi
+	movl	%ecx, %ebx
 	jmp	1f
 
 0:	/* top, read another word from the indirection page */
@@ -226,27 +351,28 @@ identity_mapped:
 	movl    %ecx,   %esi /* For every source page do a copy */
 	andl    $0xfffff000, %esi
 
+	movl	%edi, %eax
+	movl	%esi, %ebp
+
+	movl	%edx, %edi
 	movl    $1024, %ecx
 	rep ; movsl
-	jmp     0b
-
-3:
 
-	/* To be certain of avoiding problems with self-modifying code
-	 * I need to execute a serializing instruction here.
-	 * So I flush the TLB, it's handy, and not processor dependent.
-	 */
-	xorl	%eax, %eax
-	movl	%eax, %cr3
+	movl	%ebp, %edi
+	movl	%eax, %esi
+	movl	$1024, %ecx
+	rep ; movsl
 
-	/* set all of the registers to known values */
-	/* leave %esp alone */
+	movl	%eax, %edi
+	movl	%edx, %esi
+	movl	$1024, %ecx
+	rep ; movsl
 
-	xorl	%eax, %eax
-	xorl	%ebx, %ebx
-	xorl    %ecx, %ecx
-	xorl    %edx, %edx
-	xorl    %esi, %esi
-	xorl    %edi, %edi
-	xorl    %ebp, %ebp
+	lea	PAGE_SIZE(%ebp), %esi
+	jmp     0b
+3:
+	popl	%esi
+	popl	%edi
+	popl	%ebx
+	popl	%ebp
 	ret
diff -puN include/asm-x86/kexec.h~kexec-jump include/asm-x86/kexec.h
--- a/include/asm-x86/kexec.h~kexec-jump
+++ a/include/asm-x86/kexec.h
@@ -10,14 +10,15 @@
 # define VA_PTE_0		5
 # define PA_PTE_1		6
 # define VA_PTE_1		7
+# define PA_SWAP_PAGE		8
 # ifdef CONFIG_X86_PAE
-#  define PA_PMD_0		8
-#  define VA_PMD_0		9
-#  define PA_PMD_1		10
-#  define VA_PMD_1		11
-#  define PAGES_NR		12
+#  define PA_PMD_0		9
+#  define VA_PMD_0		10
+#  define PA_PMD_1		11
+#  define VA_PMD_1		12
+#  define PAGES_NR		13
 # else
-#  define PAGES_NR		8
+#  define PAGES_NR		9
 # endif
 #else
 # define PA_CONTROL_PAGE	0
@@ -152,11 +153,12 @@ static inline void crash_setup_regs(stru
 }
 
 #ifdef CONFIG_X86_32
-asmlinkage NORET_TYPE void
+asmlinkage unsigned long
 relocate_kernel(unsigned long indirection_page,
 		unsigned long control_page,
 		unsigned long start_address,
-		unsigned int has_pae) ATTRIB_NORET;
+		unsigned int has_pae,
+		unsigned int preserve_context);
 #else
 NORET_TYPE void
 relocate_kernel(unsigned long indirection_page,
diff -puN include/linux/kexec.h~kexec-jump include/linux/kexec.h
--- a/include/linux/kexec.h~kexec-jump
+++ a/include/linux/kexec.h
@@ -83,6 +83,7 @@ struct kimage {
 
 	unsigned long start;
 	struct page *control_code_page;
+	struct page *swap_page;
 
 	unsigned long nr_segments;
 	struct kexec_segment segment[KEXEC_SEGMENT_MAX];
@@ -98,18 +99,20 @@ struct kimage {
 	unsigned int type : 1;
 #define KEXEC_TYPE_DEFAULT 0
 #define KEXEC_TYPE_CRASH   1
+	unsigned int preserve_context : 1;
 };
 
 
 
 /* kexec interface functions */
-extern NORET_TYPE void machine_kexec(struct kimage *image) ATTRIB_NORET;
+extern void machine_kexec(struct kimage *image);
 extern int machine_kexec_prepare(struct kimage *image);
 extern void machine_kexec_cleanup(struct kimage *image);
 extern asmlinkage long sys_kexec_load(unsigned long entry,
 					unsigned long nr_segments,
 					struct kexec_segment __user *segments,
 					unsigned long flags);
+extern int kernel_kexec(void);
 #ifdef CONFIG_COMPAT
 extern asmlinkage long compat_sys_kexec_load(unsigned long entry,
 				unsigned long nr_segments,
@@ -156,8 +159,9 @@ extern struct kimage *kexec_crash_image;
 #define kexec_flush_icache_page(page)
 #endif
 
-#define KEXEC_ON_CRASH  0x00000001
-#define KEXEC_ARCH_MASK 0xffff0000
+#define KEXEC_ON_CRASH		0x00000001
+#define KEXEC_PRESERVE_CONTEXT	0x00000002
+#define KEXEC_ARCH_MASK		0xffff0000
 
 /* These values match the ELF architecture values.
  * Unless there is a good reason that should continue to be the case.
@@ -174,7 +178,12 @@ extern struct kimage *kexec_crash_image;
 #define KEXEC_ARCH_MIPS_LE (10 << 16)
 #define KEXEC_ARCH_MIPS    ( 8 << 16)
 
-#define KEXEC_FLAGS    (KEXEC_ON_CRASH)  /* List of defined/legal kexec flags */
+/* List of defined/legal kexec flags */
+#ifndef CONFIG_KEXEC_JUMP
+#define KEXEC_FLAGS    KEXEC_ON_CRASH
+#else
+#define KEXEC_FLAGS    (KEXEC_ON_CRASH | KEXEC_PRESERVE_CONTEXT)
+#endif
 
 #define VMCOREINFO_BYTES           (4096)
 #define VMCOREINFO_NOTE_NAME       "VMCOREINFO"
diff -puN kernel/kexec.c~kexec-jump kernel/kexec.c
--- a/kernel/kexec.c~kexec-jump
+++ a/kernel/kexec.c
@@ -24,6 +24,8 @@
 #include <linux/utsrelease.h>
 #include <linux/utsname.h>
 #include <linux/numa.h>
+#include <linux/suspend.h>
+#include <linux/device.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -242,6 +244,12 @@ static int kimage_normal_alloc(struct ki
 		goto out;
 	}
 
+	image->swap_page = kimage_alloc_control_pages(image, 0);
+	if (!image->swap_page) {
+		printk(KERN_ERR "Could not allocate swap buffer\n");
+		goto out;
+	}
+
 	result = 0;
  out:
 	if (result == 0)
@@ -986,6 +994,8 @@ asmlinkage long sys_kexec_load(unsigned 
 		if (result)
 			goto out;
 
+		if (flags & KEXEC_PRESERVE_CONTEXT)
+			image->preserve_context = 1;
 		result = machine_kexec_prepare(image);
 		if (result)
 			goto out;
@@ -1411,3 +1421,50 @@ static int __init crash_save_vmcoreinfo_
 }
 
 module_init(crash_save_vmcoreinfo_init)
+
+/**
+ *	kernel_kexec - reboot the system
+ *
+ *	Move into place and start executing a preloaded standalone
+ *	executable.  If nothing was preloaded return an error.
+ */
+int kernel_kexec(void)
+{
+	int error = 0;
+
+	if (xchg(&kexec_lock, 1))
+		return -EBUSY;
+	if (!kexec_image) {
+		error = -EINVAL;
+		goto Unlock;
+	}
+
+	if (kexec_image->preserve_context) {
+#ifdef CONFIG_KEXEC_JUMP
+		local_irq_disable();
+		save_processor_state();
+#endif
+	} else {
+		blocking_notifier_call_chain(&reboot_notifier_list,
+					     SYS_RESTART, NULL);
+		system_state = SYSTEM_RESTART;
+		device_shutdown();
+		sysdev_shutdown();
+		printk(KERN_EMERG "Starting new kernel\n");
+		machine_shutdown();
+	}
+
+	machine_kexec(kexec_image);
+
+	if (kexec_image->preserve_context) {
+#ifdef CONFIG_KEXEC_JUMP
+		restore_processor_state();
+		local_irq_enable();
+#endif
+	}
+
+ Unlock:
+	xchg(&kexec_lock, 0);
+
+	return error;
+}
diff -puN kernel/sys.c~kexec-jump kernel/sys.c
--- a/kernel/sys.c~kexec-jump
+++ a/kernel/sys.c
@@ -301,26 +301,6 @@ void kernel_restart(char *cmd)
 }
 EXPORT_SYMBOL_GPL(kernel_restart);
 
-/**
- *	kernel_kexec - reboot the system
- *
- *	Move into place and start executing a preloaded standalone
- *	executable.  If nothing was preloaded return an error.
- */
-static void kernel_kexec(void)
-{
-#ifdef CONFIG_KEXEC
-	struct kimage *image;
-	image = xchg(&kexec_image, NULL);
-	if (!image)
-		return;
-	kernel_restart_prepare(NULL);
-	printk(KERN_EMERG "Starting new kernel\n");
-	machine_shutdown();
-	machine_kexec(image);
-#endif
-}
-
 static void kernel_shutdown_prepare(enum system_states state)
 {
 	blocking_notifier_call_chain(&reboot_notifier_list,
@@ -425,10 +405,15 @@ asmlinkage long sys_reboot(int magic1, i
 		kernel_restart(buffer);
 		break;
 
+#ifdef CONFIG_KEXEC
 	case LINUX_REBOOT_CMD_KEXEC:
-		kernel_kexec();
-		unlock_kernel();
-		return -EINVAL;
+		{
+			int ret;
+			ret = kernel_kexec();
+			unlock_kernel();
+			return ret;
+		}
+#endif
 
 #ifdef CONFIG_HIBERNATION
 	case LINUX_REBOOT_CMD_SW_SUSPEND:
_

Patches currently in -mm which might be from ying.huang@intel.com are

origin.patch
aes-x86_64-asm-implementation-optimization.patch

