From: akpm@osdl.org
Subject: - swsusp-support-i386-systems-with-pae-or-without-pse.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:59:33 -0800
Message-ID: <200612072259.kB7MxXws029531@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51089 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163699AbWLGW76 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:59:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, ak@suse.de, davej@redhat.com, ncunningham@linuxmail.org, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: Support i386 systems with PAE or without PSE
has been removed from the -mm tree.  Its filename was
     swsusp-support-i386-systems-with-pae-or-without-pse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: Support i386 systems with PAE or without PSE
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Make swsusp support i386 systems with PAE or without PSE.

This is done by creating temporary page tables located in resume-safe page
frames before the suspend image is restored in the same way as x86_64 does
it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Andi Kleen <ak@suse.de>
Cc: Dave Jones <davej@redhat.com>
Cc: Nigel Cunningham <ncunningham@linuxmail.org>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/power/Makefile   |    2 
 arch/i386/power/suspend.c  |  158 +++++++++++++++++++++++++++++++++++
 arch/i386/power/swsusp.S   |    9 +
 include/asm-i386/suspend.h |   13 --
 kernel/power/Kconfig       |    2 
 5 files changed, 168 insertions(+), 16 deletions(-)

diff -puN arch/i386/power/Makefile~swsusp-support-i386-systems-with-pae-or-without-pse arch/i386/power/Makefile
--- a/arch/i386/power/Makefile~swsusp-support-i386-systems-with-pae-or-without-pse
+++ a/arch/i386/power/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_PM)		+= cpu.o
-obj-$(CONFIG_SOFTWARE_SUSPEND)	+= swsusp.o
+obj-$(CONFIG_SOFTWARE_SUSPEND)	+= swsusp.o suspend.o
diff -puN /dev/null arch/i386/power/suspend.c
--- /dev/null
+++ a/arch/i386/power/suspend.c
@@ -0,0 +1,158 @@
+/*
+ * Suspend support specific for i386 - temporary page tables
+ *
+ * Distribute under GPLv2
+ *
+ * Copyright (c) 2006 Rafael J. Wysocki <rjw@sisk.pl>
+ */
+
+#include <linux/suspend.h>
+#include <linux/bootmem.h>
+
+#include <asm/system.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+
+/* Defined in arch/i386/power/swsusp.S */
+extern int restore_image(void);
+
+/* Pointer to the temporary resume page tables */
+pgd_t *resume_pg_dir;
+
+/* The following three functions are based on the analogous code in
+ * arch/i386/mm/init.c
+ */
+
+/*
+ * Create a middle page table on a resume-safe page and put a pointer to it in
+ * the given global directory entry.  This only returns the gd entry
+ * in non-PAE compilation mode, since the middle layer is folded.
+ */
+static pmd_t *resume_one_md_table_init(pgd_t *pgd)
+{
+	pud_t *pud;
+	pmd_t *pmd_table;
+
+#ifdef CONFIG_X86_PAE
+	pmd_table = (pmd_t *)get_safe_page(GFP_ATOMIC);
+	if (!pmd_table)
+		return NULL;
+
+	set_pgd(pgd, __pgd(__pa(pmd_table) | _PAGE_PRESENT));
+	pud = pud_offset(pgd, 0);
+
+	BUG_ON(pmd_table != pmd_offset(pud, 0));
+#else
+	pud = pud_offset(pgd, 0);
+	pmd_table = pmd_offset(pud, 0);
+#endif
+
+	return pmd_table;
+}
+
+/*
+ * Create a page table on a resume-safe page and place a pointer to it in
+ * a middle page directory entry.
+ */
+static pte_t *resume_one_page_table_init(pmd_t *pmd)
+{
+	if (pmd_none(*pmd)) {
+		pte_t *page_table = (pte_t *)get_safe_page(GFP_ATOMIC);
+		if (!page_table)
+			return NULL;
+
+		set_pmd(pmd, __pmd(__pa(page_table) | _PAGE_TABLE));
+
+		BUG_ON(page_table != pte_offset_kernel(pmd, 0));
+
+		return page_table;
+	}
+
+	return pte_offset_kernel(pmd, 0);
+}
+
+/*
+ * This maps the physical memory to kernel virtual address space, a total
+ * of max_low_pfn pages, by creating page tables starting from address
+ * PAGE_OFFSET.  The page tables are allocated out of resume-safe pages.
+ */
+static int resume_physical_mapping_init(pgd_t *pgd_base)
+{
+	unsigned long pfn;
+	pgd_t *pgd;
+	pmd_t *pmd;
+	pte_t *pte;
+	int pgd_idx, pmd_idx;
+
+	pgd_idx = pgd_index(PAGE_OFFSET);
+	pgd = pgd_base + pgd_idx;
+	pfn = 0;
+
+	for (; pgd_idx < PTRS_PER_PGD; pgd++, pgd_idx++) {
+		pmd = resume_one_md_table_init(pgd);
+		if (!pmd)
+			return -ENOMEM;
+
+		if (pfn >= max_low_pfn)
+			continue;
+
+		for (pmd_idx = 0; pmd_idx < PTRS_PER_PMD; pmd++, pmd_idx++) {
+			if (pfn >= max_low_pfn)
+				break;
+
+			/* Map with big pages if possible, otherwise create
+			 * normal page tables.
+			 * NOTE: We can mark everything as executable here
+			 */
+			if (cpu_has_pse) {
+				set_pmd(pmd, pfn_pmd(pfn, PAGE_KERNEL_LARGE_EXEC));
+				pfn += PTRS_PER_PTE;
+			} else {
+				pte_t *max_pte;
+
+				pte = resume_one_page_table_init(pmd);
+				if (!pte)
+					return -ENOMEM;
+
+				max_pte = pte + PTRS_PER_PTE;
+				for (; pte < max_pte; pte++, pfn++) {
+					if (pfn >= max_low_pfn)
+						break;
+
+					set_pte(pte, pfn_pte(pfn, PAGE_KERNEL_EXEC));
+				}
+			}
+		}
+	}
+	return 0;
+}
+
+static inline void resume_init_first_level_page_table(pgd_t *pg_dir)
+{
+#ifdef CONFIG_X86_PAE
+	int i;
+
+	/* Init entries of the first-level page table to the zero page */
+	for (i = 0; i < PTRS_PER_PGD; i++)
+		set_pgd(pg_dir + i,
+			__pgd(__pa(empty_zero_page) | _PAGE_PRESENT));
+#endif
+}
+
+int swsusp_arch_resume(void)
+{
+	int error;
+
+	resume_pg_dir = (pgd_t *)get_safe_page(GFP_ATOMIC);
+	if (!resume_pg_dir)
+		return -ENOMEM;
+
+	resume_init_first_level_page_table(resume_pg_dir);
+	error = resume_physical_mapping_init(resume_pg_dir);
+	if (error)
+		return error;
+
+	/* We have got enough memory and from now on we cannot recover */
+	restore_image();
+	return 0;
+}
diff -puN arch/i386/power/swsusp.S~swsusp-support-i386-systems-with-pae-or-without-pse arch/i386/power/swsusp.S
--- a/arch/i386/power/swsusp.S~swsusp-support-i386-systems-with-pae-or-without-pse
+++ a/arch/i386/power/swsusp.S
@@ -28,8 +28,9 @@ ENTRY(swsusp_arch_suspend)
 	call swsusp_save
 	ret
 
-ENTRY(swsusp_arch_resume)
-	movl	$swsusp_pg_dir-__PAGE_OFFSET, %ecx
+ENTRY(restore_image)
+	movl	resume_pg_dir, %ecx
+	subl	$__PAGE_OFFSET, %ecx
 	movl	%ecx, %cr3
 
 	movl	restore_pblist, %edx
@@ -51,6 +52,10 @@ copy_loop:
 	.p2align 4,,7
 
 done:
+	/* go back to the original page tables */
+	movl	$swapper_pg_dir, %ecx
+	subl	$__PAGE_OFFSET, %ecx
+	movl	%ecx, %cr3
 	/* Flush TLB, including "global" things (vmalloc) */
 	movl	mmu_cr4_features, %eax
 	movl	%eax, %edx
diff -puN include/asm-i386/suspend.h~swsusp-support-i386-systems-with-pae-or-without-pse include/asm-i386/suspend.h
--- a/include/asm-i386/suspend.h~swsusp-support-i386-systems-with-pae-or-without-pse
+++ a/include/asm-i386/suspend.h
@@ -6,18 +6,7 @@
 #include <asm/desc.h>
 #include <asm/i387.h>
 
-static inline int
-arch_prepare_suspend(void)
-{
-	/* If you want to make non-PSE machine work, turn off paging
-           in swsusp_arch_suspend. swsusp_pg_dir should have identity mapping, so
-           it could work...  */
-	if (!cpu_has_pse) {
-		printk(KERN_ERR "PSE is required for swsusp.\n");
-		return -EPERM;
-	}
-	return 0;
-}
+static inline int arch_prepare_suspend(void) { return 0; }
 
 /* image of the saved processor state */
 struct saved_context {
diff -puN kernel/power/Kconfig~swsusp-support-i386-systems-with-pae-or-without-pse kernel/power/Kconfig
--- a/kernel/power/Kconfig~swsusp-support-i386-systems-with-pae-or-without-pse
+++ a/kernel/power/Kconfig
@@ -78,7 +78,7 @@ config PM_SYSFS_DEPRECATED
 
 config SOFTWARE_SUSPEND
 	bool "Software Suspend"
-	depends on PM && SWAP && ((X86 && (!SMP || SUSPEND_SMP) && !X86_PAE) || ((FRV || PPC32) && !SMP))
+	depends on PM && SWAP && ((X86 && (!SMP || SUSPEND_SMP)) || ((FRV || PPC32) && !SMP))
 	---help---
 	  Enable the possibility of suspending the machine.
 	  It doesn't need ACPI or APM.
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
md-change-lifetime-rules-for-md-devices.patch

