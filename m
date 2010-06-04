From: akpm@linux-foundation.org
Subject: + x86-olpc-add-support-for-calling-into-openfirmware.patch added to -mm tree
Date: Fri, 04 Jun 2010 15:48:28 -0700
Message-ID: <201006042248.o54MmSgH022854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757370Ab0FDWsp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jun 2010 18:48:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, hpa@zytor.com, jordan.crouse@amd.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: OLPC: add support for calling into OpenFirmware
has been added to the -mm tree.  Its filename is
     x86-olpc-add-support-for-calling-into-openfirmware.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: OLPC: add support for calling into OpenFirmware
From: Andres Salomon <dilinger@queued.net>

Add support for saving OFW's cif, and later calling into it to run OFW
commands.  OFW remains resident in memory, living within virtual range
0xff800000 - 0xffc00000.  A single page directory entry points to the
pgdir that OFW actually uses, so rather than saving the entire page table,
we save that one entry (and restore it for the call into OFW).

This is currently only used by the OLPC XO; however, there's nothing
restricting OFW's usage on other (x86) platforms.

Signed-off-by: Andres Salomon <dilinger@queued.net>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                        |    9 ++
 arch/x86/include/asm/olpc_ofw.h         |   33 ++++++++
 arch/x86/include/asm/pgtable_32_types.h |   14 ++-
 arch/x86/include/asm/setup.h            |    1 
 arch/x86/kernel/Makefile                |    1 
 arch/x86/kernel/head_32.S               |   31 +++++++
 arch/x86/kernel/olpc.c                  |    8 +-
 arch/x86/kernel/olpc_ofw.c              |   88 ++++++++++++++++++++++
 arch/x86/kernel/setup.c                 |    3 
 arch/x86/mm/dump_pagetables.c           |    7 +
 arch/x86/mm/init_32.c                   |   17 ++++
 11 files changed, 205 insertions(+), 7 deletions(-)

diff -puN arch/x86/Kconfig~x86-olpc-add-support-for-calling-into-openfirmware arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-olpc-add-support-for-calling-into-openfirmware
+++ a/arch/x86/Kconfig
@@ -2060,6 +2060,15 @@ config OLPC
 	  Add support for detecting the unique features of the OLPC
 	  XO hardware.
 
+config OLPC_OPENFIRMWARE
+	bool "Support for OLPC's Open Firmware"
+	depends on !X86_64 && !X86_PAE
+	default y if OLPC
+	help
+	  This option adds support for the implementation of Open Firmware
+	  that is used on the OLPC XO-1 Children's Machine.
+	  If unsure, say N here.
+
 endif # X86_32
 
 config K8_NB
diff -puN /dev/null arch/x86/include/asm/olpc_ofw.h
--- /dev/null
+++ a/arch/x86/include/asm/olpc_ofw.h
@@ -0,0 +1,33 @@
+#ifndef _ASM_X86_OLPC_OFW_H
+#define _ASM_X86_OLPC_OFW_H
+
+/* hardcode addresses to make life easier dealing w/ VMALLOC_END and others */
+#define OLPC_OFW_START 0xff800000UL
+#define OLPC_OFW_SIZE (PGDIR_SIZE)
+#define OLPC_OFW_END (OLPC_OFW_START + OLPC_OFW_SIZE)
+
+#ifdef CONFIG_OLPC_OPENFIRMWARE
+
+#ifndef __ASSEMBLER__
+
+/* address of OFW callback interface; will be NULL if OFW isn't found */
+extern int (*olpc_ofw_cif)(int *);
+
+/* page dir entry containing OFW's current memory */
+extern pgdval_t olpc_ofw_pgd;
+
+/* run an OFW command by calling into the firmware */
+extern int olpc_ofw(const char *name, int nr_args, int nr_res, ...);
+
+/* determine/ensure OFW lives in the proper place in (virtual) memory */
+void olpc_ofw_detect_range(void);
+
+#endif
+
+#else
+
+static inline void olpc_ofw_detect_range(void) { }
+
+#endif
+
+#endif
diff -puN arch/x86/include/asm/pgtable_32_types.h~x86-olpc-add-support-for-calling-into-openfirmware arch/x86/include/asm/pgtable_32_types.h
--- a/arch/x86/include/asm/pgtable_32_types.h~x86-olpc-add-support-for-calling-into-openfirmware
+++ a/arch/x86/include/asm/pgtable_32_types.h
@@ -37,13 +37,21 @@ extern bool __vmalloc_start_set; /* set 
 #define LAST_PKMAP 1024
 #endif
 
-#define PKMAP_BASE ((FIXADDR_BOOT_START - PAGE_SIZE * (LAST_PKMAP + 1))	\
-		    & PMD_MASK)
+#include <asm/olpc_ofw.h>
+
+/* make sure we have enough space for PKMAP region *and* OFW after VMALLOC*/
+#define PKMAP_BASE ((FIXADDR_BOOT_START - PAGE_SIZE * (LAST_PKMAP + 1) \
+		- OLPC_OFW_SIZE) & PMD_MASK)
 
 #ifdef CONFIG_HIGHMEM
 # define VMALLOC_END	(PKMAP_BASE - 2 * PAGE_SIZE)
 #else
-# define VMALLOC_END	(FIXADDR_START - 2 * PAGE_SIZE)
+# ifdef CONFIG_OLPC_OPENFIRMWARE
+   /* dumppages looks a lot saner if we leave a PGDIR_SIZEd gap */
+#  define VMALLOC_END	(OLPC_OFW_START - PGDIR_SIZE)
+# else
+#  define VMALLOC_END	(FIXADDR_START - 2 * PAGE_SIZE)
+# endif
 #endif
 
 #define MODULES_VADDR	VMALLOC_START
diff -puN arch/x86/include/asm/setup.h~x86-olpc-add-support-for-calling-into-openfirmware arch/x86/include/asm/setup.h
--- a/arch/x86/include/asm/setup.h~x86-olpc-add-support-for-calling-into-openfirmware
+++ a/arch/x86/include/asm/setup.h
@@ -21,6 +21,7 @@
 #define OLD_CL_MAGIC		0xA33F
 #define OLD_CL_ADDRESS		0x020	/* Relative to real mode data */
 #define NEW_CL_POINTER		0x228	/* Relative to real mode data */
+#define OLPC_OFW_INFO_OFFSET	0xb0	/* Relative to real mode data */
 
 #ifndef __ASSEMBLY__
 #include <asm/bootparam.h>
diff -puN arch/x86/kernel/Makefile~x86-olpc-add-support-for-calling-into-openfirmware arch/x86/kernel/Makefile
--- a/arch/x86/kernel/Makefile~x86-olpc-add-support-for-calling-into-openfirmware
+++ a/arch/x86/kernel/Makefile
@@ -104,6 +104,7 @@ obj-$(CONFIG_SCx200)		+= scx200.o
 scx200-y			+= scx200_32.o
 
 obj-$(CONFIG_OLPC)		+= olpc.o
+obj-$(CONFIG_OLPC_OPENFIRMWARE)	+= olpc_ofw.o
 obj-$(CONFIG_X86_MRST)		+= mrst.o
 
 microcode-y				:= microcode_core.o
diff -puN arch/x86/kernel/head_32.S~x86-olpc-add-support-for-calling-into-openfirmware arch/x86/kernel/head_32.S
--- a/arch/x86/kernel/head_32.S~x86-olpc-add-support-for-calling-into-openfirmware
+++ a/arch/x86/kernel/head_32.S
@@ -131,6 +131,29 @@ ENTRY(startup_32)
 	movsl
 1:
 
+#ifdef CONFIG_OLPC_OPENFIRMWARE
+	movl $0x0, pa(olpc_ofw_cif)
+
+	/* Did OpenFirmware boot us? */
+	movl $pa(boot_params) + OLPC_OFW_INFO_OFFSET, %ebp
+	cmpl $0x2057464F, (%ebp)	/* Magic number "OFW " */
+	jne 3f
+
+	/* Save the callback address for calling into OFW from linux */
+	mov 0x8(%ebp), %eax
+	mov %eax, pa(olpc_ofw_cif)
+
+	/* %cr3 holds OFW's pgdir table.  For calling info OFW, we need to
+	 * the save next-to-last pgdir table entry, which points to a page
+	 * table that lives within OFW's memory.  The pgdir table contains
+	 * 1024 entries (each a 4 byte pde), so we want
+	 * ((int *) %cr3)[1022]. */
+	movl %cr3, %eax
+	movl 1022*4(%eax), %ebx
+	movl %ebx, pa(olpc_ofw_pgd)
+3:
+#endif
+
 #ifdef CONFIG_PARAVIRT
 	/* This is can only trip for a broken bootloader... */
 	cmpw $0x207, pa(boot_params + BP_version)
@@ -658,6 +681,14 @@ ENTRY(stack_start)
 	.long init_thread_union+THREAD_SIZE
 	.long __BOOT_DS
 
+.globl olpc_ofw_cif
+.globl olpc_ofw_pgd
+
+olpc_ofw_cif:
+	.long olpc_ofw_cif
+olpc_ofw_pgd:
+	.long olpc_ofw_pgd
+
 ready:	.byte 0
 
 early_recursion_flag:
diff -puN arch/x86/kernel/olpc.c~x86-olpc-add-support-for-calling-into-openfirmware arch/x86/kernel/olpc.c
--- a/arch/x86/kernel/olpc.c~x86-olpc-add-support-for-calling-into-openfirmware
+++ a/arch/x86/kernel/olpc.c
@@ -22,8 +22,8 @@
 #include <asm/setup.h>
 #include <asm/olpc.h>
 
-#ifdef CONFIG_OPEN_FIRMWARE
-#include <asm/ofw.h>
+#ifdef CONFIG_OLPC_OPENFIRMWARE
+#include <asm/olpc_ofw.h>
 #endif
 
 struct olpc_platform_t olpc_platform_info;
@@ -188,13 +188,13 @@ err:
 }
 EXPORT_SYMBOL_GPL(olpc_ec_cmd);
 
-#ifdef CONFIG_OPEN_FIRMWARE
+#ifdef CONFIG_OLPC_OPENFIRMWARE
 static void __init platform_detect(void)
 {
 	size_t propsize;
 	__be32 rev;
 
-	if (ofw("getprop", 4, 1, NULL, "board-revision-int", &rev, 4,
+	if (olpc_ofw("getprop", 4, 1, NULL, "board-revision-int", &rev, 4,
 			&propsize) || propsize != 4) {
 		printk(KERN_ERR "ofw: getprop call failed!\n");
 		rev = cpu_to_be32(0);
diff -puN /dev/null arch/x86/kernel/olpc_ofw.c
--- /dev/null
+++ a/arch/x86/kernel/olpc_ofw.c
@@ -0,0 +1,88 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <asm/olpc_ofw.h>
+
+static DEFINE_SPINLOCK(ofw_lock);
+
+#define MAXARGS 10
+
+/* handle actual call into OFW */
+static int __olpc_ofw(int *ofw_args)
+{
+	pgd_t *base, *pde;
+	pgdval_t oldval;
+	int ret;
+
+	/* temporarily clobber %cr3[1022] w/ olpc_ofw_pgd */
+	base = __va(read_cr3());
+	pde = &base[1022];
+	oldval = pgd_val(*pde);
+	set_pgd(pde, __pgd(olpc_ofw_pgd));
+
+	/* call into ofw */
+	ret = olpc_ofw_cif(ofw_args);
+
+	/* restore %cr3[1022] */
+	set_pgd(pde, __pgd(oldval));
+
+	return ret;
+}
+
+
+int olpc_ofw(const char *name, int nr_args, int nr_res, ...)
+{
+	int args[MAXARGS + 3];
+	unsigned long flags;
+	va_list ap;
+	int ret, i, *ofw_ret;
+
+	if (!olpc_ofw_cif)
+		return -1;
+	BUG_ON(nr_args + nr_res > MAXARGS);
+
+	args[0] = (int) name;
+	args[1] = nr_args;
+	args[2] = nr_res;
+
+	va_start(ap, nr_res);
+	i = 3;
+	while (nr_args) {
+		args[i++] = va_arg(ap, int);
+		nr_args--;
+	}
+
+	spin_lock_irqsave(&ofw_lock, flags);
+	ret = __olpc_ofw(args);
+	spin_unlock_irqrestore(&ofw_lock, flags);
+
+	if (ret == 0) {
+		while (nr_res) {
+			ofw_ret = va_arg(ap, int *);
+			*ofw_ret = args[i++];
+			nr_res--;
+		}
+	}
+
+	va_end(ap);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(olpc_ofw);
+
+void __init olpc_ofw_detect_range(void)
+{
+	if (!olpc_ofw_cif)
+		return;
+
+	/* verify that the cif lies within a memory range that we expect */
+	if ((unsigned long) olpc_ofw_cif < OLPC_OFW_START ||
+				(unsigned long) olpc_ofw_cif > OLPC_OFW_END) {
+		printk(KERN_WARNING "OFW detected, but cif has invalid address 0x%lx - disabling!\n",
+				(unsigned long) olpc_ofw_cif);
+		olpc_ofw_cif = NULL;
+	} else
+		printk(KERN_WARNING "OFW detected in memory, cif @ 0x%lx\n",
+				(unsigned long) olpc_ofw_cif);
+}
diff -puN arch/x86/kernel/setup.c~x86-olpc-add-support-for-calling-into-openfirmware arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~x86-olpc-add-support-for-calling-into-openfirmware
+++ a/arch/x86/kernel/setup.c
@@ -102,6 +102,7 @@
 
 #include <asm/paravirt.h>
 #include <asm/hypervisor.h>
+#include <asm/olpc_ofw.h>
 
 #include <asm/percpu.h>
 #include <asm/topology.h>
@@ -859,6 +860,8 @@ void __init setup_arch(char **cmdline_p)
 
 	dmi_check_system(bad_bios_dmi_table);
 
+	olpc_ofw_detect_range();
+
 	/*
 	 * VMware detection requires dmi to be available, so this
 	 * needs to be done after dmi_scan_machine, for the BP.
diff -puN arch/x86/mm/dump_pagetables.c~x86-olpc-add-support-for-calling-into-openfirmware arch/x86/mm/dump_pagetables.c
--- a/arch/x86/mm/dump_pagetables.c~x86-olpc-add-support-for-calling-into-openfirmware
+++ a/arch/x86/mm/dump_pagetables.c
@@ -18,6 +18,7 @@
 #include <linux/seq_file.h>
 
 #include <asm/pgtable.h>
+#include <asm/olpc_ofw.h>
 
 /*
  * The dumper groups pagetable entries of the same type into one, and for
@@ -55,6 +56,9 @@ enum address_markers_idx {
 # ifdef CONFIG_HIGHMEM
 	PKMAP_BASE_NR,
 # endif
+# ifdef CONFIG_OLPC_OPENFIRMWARE
+	OLPC_OFW_START_NR,
+# endif
 	FIXADDR_START_NR,
 #endif
 };
@@ -77,6 +81,9 @@ static struct addr_marker address_marker
 # ifdef CONFIG_HIGHMEM
 	{ 0/*PKMAP_BASE*/,      "Persisent kmap() Area" },
 # endif
+# ifdef CONFIG_OLPC_OPENFIRMWARE
+	{ OLPC_OFW_START,	"OpenFirmware Mapping" },
+# endif
 	{ 0/*FIXADDR_START*/,   "Fixmap Area" },
 #endif
 	{ -1, NULL }		/* End of list */
diff -puN arch/x86/mm/init_32.c~x86-olpc-add-support-for-calling-into-openfirmware arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~x86-olpc-add-support-for-calling-into-openfirmware
+++ a/arch/x86/mm/init_32.c
@@ -49,6 +49,7 @@
 #include <asm/paravirt.h>
 #include <asm/setup.h>
 #include <asm/cacheflush.h>
+#include <asm/olpc_ofw.h>
 #include <asm/page_types.h>
 #include <asm/init.h>
 
@@ -903,6 +904,9 @@ void __init mem_init(void)
 
 	printk(KERN_INFO "virtual kernel memory layout:\n"
 		"    fixmap  : 0x%08lx - 0x%08lx   (%4ld kB)\n"
+#ifdef CONFIG_OLPC_OPENFIRMWARE
+		"    ofw     : 0x%08lx - 0x%08lx   (%4ld MB)\n"
+#endif
 #ifdef CONFIG_HIGHMEM
 		"    pkmap   : 0x%08lx - 0x%08lx   (%4ld kB)\n"
 #endif
@@ -914,6 +918,12 @@ void __init mem_init(void)
 		FIXADDR_START, FIXADDR_TOP,
 		(FIXADDR_TOP - FIXADDR_START) >> 10,
 
+#ifdef CONFIG_OLPC_OPENFIRMWARE
+		olpc_ofw_cif ? OLPC_OFW_START : 0,
+		olpc_ofw_cif ? OLPC_OFW_END : 0,
+		olpc_ofw_cif ? (OLPC_OFW_END - OLPC_OFW_START) >> 20 : 0,
+#endif
+
 #ifdef CONFIG_HIGHMEM
 		PKMAP_BASE, PKMAP_BASE+LAST_PKMAP*PAGE_SIZE,
 		(LAST_PKMAP*PAGE_SIZE) >> 10,
@@ -941,7 +951,14 @@ void __init mem_init(void)
 	 */
 #define __FIXADDR_TOP (-PAGE_SIZE)
 #ifdef CONFIG_HIGHMEM
+#ifdef CONFIG_OLPC_OPENFIRMWARE
+	BUILD_BUG_ON(PKMAP_BASE + LAST_PKMAP*PAGE_SIZE	> OLPC_OFW_START);
+#else
 	BUILD_BUG_ON(PKMAP_BASE + LAST_PKMAP*PAGE_SIZE	> FIXADDR_START);
+#endif
+#ifdef CONFIG_OLPC_OPENFIRMWARE
+	BUILD_BUG_ON(OLPC_OFW_END			>= FIXADDR_START);
+#endif
 	BUILD_BUG_ON(VMALLOC_END			> PKMAP_BASE);
 #endif
 #define high_memory (-128UL << 20)
_

Patches currently in -mm which might be from dilinger@queued.net are

x86-mm-create-symbolic-index-into-address_markers-array.patch
x86-olpc-add-support-for-calling-into-openfirmware.patch
gxfb-fix-incorrect-__init-annotation.patch
lxfb-fix-incorrect-__init-annotation.patch

