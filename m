From: akpm@linux-foundation.org
Subject: - i386-adjustments-to-page-table-dump-during-oops-v3.patch removed from -mm tree
Date: Sat, 17 Feb 2007 18:15:48 -0800
Message-ID: <200702180215.l1I2FmCp008429@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55730 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993128AbXBRCQB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 21:16:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386: adjustments to page table dump during oops (v3)
has been removed from the -mm tree.  Its filename was
     i386-adjustments-to-page-table-dump-during-oops-v3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: adjustments to page table dump during oops (v3)
From: "Jan Beulich" <jbeulich@novell.com>

- make the page table contents printing PAE capable
- make sure the address stored in current->thread.cr2 is unmodified from
  what was read from CR2
- don't call oops_may_print() multiple times, when one time suffices
- print pte even in highpte case, as long as the pte page isn't in
  actually in high memory (which is specifically the case for all page
  tables covering kernel space)

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mm/fault.c |   54 +++++++++++++++++++++++++----------------
 1 files changed, 34 insertions(+), 20 deletions(-)

diff -puN arch/i386/mm/fault.c~i386-adjustments-to-page-table-dump-during-oops-v3 arch/i386/mm/fault.c
--- a/arch/i386/mm/fault.c~i386-adjustments-to-page-table-dump-during-oops-v3
+++ a/arch/i386/mm/fault.c
@@ -20,6 +20,7 @@
 #include <linux/tty.h>
 #include <linux/vt_kern.h>		/* For unblank_screen() */
 #include <linux/highmem.h>
+#include <linux/bootmem.h>		/* for max_low_pfn */
 #include <linux/module.h>
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
@@ -301,7 +302,6 @@ fastcall void __kprobes do_page_fault(st
 	struct mm_struct *mm;
 	struct vm_area_struct * vma;
 	unsigned long address;
-	unsigned long page;
 	int write, si_code;
 
 	/* get the address */
@@ -510,7 +510,9 @@ no_context:
 	bust_spinlocks(1);
 
 	if (oops_may_print()) {
-	#ifdef CONFIG_X86_PAE
+		__typeof__(pte_val(__pte(0))) page;
+
+#ifdef CONFIG_X86_PAE
 		if (error_code & 16) {
 			pte_t *pte = lookup_address(address);
 
@@ -519,7 +521,7 @@ no_context:
 					"NX-protected page - exploit attempt? "
 					"(uid: %d)\n", current->uid);
 		}
-	#endif
+#endif
 		if (address < PAGE_SIZE)
 			printk(KERN_ALERT "BUG: unable to handle kernel NULL "
 					"pointer dereference");
@@ -529,25 +531,37 @@ no_context:
 		printk(" at virtual address %08lx\n",address);
 		printk(KERN_ALERT " printing eip:\n");
 		printk("%08lx\n", regs->eip);
-	}
-	page = read_cr3();
-	page = ((unsigned long *) __va(page))[address >> 22];
-	if (oops_may_print())
+
+		page = read_cr3();
+		page = ((__typeof__(page) *) __va(page))[address >> PGDIR_SHIFT];
+#ifdef CONFIG_X86_PAE
+		printk(KERN_ALERT "*pdpt = %0*Lx\n", sizeof(page)*4, (u64)page);
+		if (page & _PAGE_PRESENT) {
+			page &= PAGE_MASK;
+			page = ((__typeof__(page) *) __va(page))[(address >> PMD_SHIFT)
+			                                         & (PTRS_PER_PMD - 1)];
+			printk(KERN_ALERT "*pde = %016Lx\n", page);
+			page &= ~_PAGE_NX;
+		}
+#else
 		printk(KERN_ALERT "*pde = %08lx\n", page);
-	/*
-	 * We must not directly access the pte in the highpte
-	 * case, the page table might be allocated in highmem.
-	 * And lets rather not kmap-atomic the pte, just in case
-	 * it's allocated already.
-	 */
-#ifndef CONFIG_HIGHPTE
-	if ((page & 1) && oops_may_print()) {
-		page &= PAGE_MASK;
-		address &= 0x003ff000;
-		page = ((unsigned long *) __va(page))[address >> PAGE_SHIFT];
-		printk(KERN_ALERT "*pte = %08lx\n", page);
-	}
 #endif
+
+		/*
+		 * We must not directly access the pte in the highpte
+		 * case if the page table is located in highmem.
+		 * And let's rather not kmap-atomic the pte, just in case
+		 * it's allocated already.
+		 */
+		if ((page >> PAGE_SHIFT) < max_low_pfn
+		    && (page & _PAGE_PRESENT)) {
+			page &= PAGE_MASK;
+			page = ((__typeof__(page) *) __va(page))[(address >> PAGE_SHIFT)
+			                                         & (PTRS_PER_PTE - 1)];
+			printk(KERN_ALERT "*pte = %0*Lx\n", sizeof(page)*4, (u64)page);
+		}
+	}
+
 	tsk->thread.cr2 = address;
 	tsk->thread.trap_no = 14;
 	tsk->thread.error_code = error_code;
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
adjust-legacy-ide-resource-setting-v2.patch
