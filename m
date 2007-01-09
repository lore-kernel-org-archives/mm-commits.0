From: akpm@osdl.org
Subject: + i386-adjustments-to-page-table-dump-during-oops.patch added to -mm tree
Date: Mon, 08 Jan 2007 20:18:50 -0800
Message-ID: <200701090418.l094Io4o028161@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39478 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbXAIETe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 23:19:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, ak@muc.de


The patch titled
     i386: adjustments to page table dump during oops
has been added to the -mm tree.  Its filename is
     i386-adjustments-to-page-table-dump-during-oops.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: adjustments to page table dump during oops
From: "Jan Beulich" <jbeulich@novell.com>

- make the page table contents printing PAE capable
- make sure the address stored in current->thread.cr2 is unmodified from
  what was read from CR2
- don't call oops_may_print() multiple times, when one time suffices

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@muc.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/mm/fault.c |   54 ++++++++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 19 deletions(-)

diff -puN arch/i386/mm/fault.c~i386-adjustments-to-page-table-dump-during-oops arch/i386/mm/fault.c
--- a/arch/i386/mm/fault.c~i386-adjustments-to-page-table-dump-during-oops
+++ a/arch/i386/mm/fault.c
@@ -327,7 +327,6 @@ fastcall void __kprobes do_page_fault(st
 	struct mm_struct *mm;
 	struct vm_area_struct * vma;
 	unsigned long address;
-	unsigned long page;
 	int write, si_code;
 
 	/* get the address */
@@ -538,7 +537,12 @@ no_context:
 	bust_spinlocks(1);
 
 	if (oops_may_print()) {
-	#ifdef CONFIG_X86_PAE
+		unsigned long page;
+#ifndef CONFIG_X86_PAE
+		typedef unsigned long pgt_t;
+#else
+		typedef unsigned long long pgt_t;
+
 		if (error_code & 16) {
 			pte_t *pte = lookup_address(address);
 
@@ -547,7 +551,7 @@ no_context:
 					"NX-protected page - exploit attempt? "
 					"(uid: %d)\n", current->uid);
 		}
-	#endif
+#endif
 		if (address < PAGE_SIZE)
 			printk(KERN_ALERT "BUG: unable to handle kernel NULL "
 					"pointer dereference");
@@ -557,25 +561,37 @@ no_context:
 		printk(" at virtual address %08lx\n",address);
 		printk(KERN_ALERT " printing eip:\n");
 		printk("%08lx\n", regs->eip);
-	}
-	page = read_cr3();
-	page = ((unsigned long *) __va(page))[address >> 22];
-	if (oops_may_print())
+
+		page = read_cr3();
+		page = ((pgt_t *) __va(page))[address >> PGDIR_SHIFT];
+#ifdef CONFIG_X86_PAE
+		printk(KERN_ALERT "*pdpt = %08lx\n", page);
+		if (page & 1) {
+			page &= PAGE_MASK;
+			page = ((pgt_t *) __va(page))[(address >> PMD_SHIFT)
+			                              & (PTRS_PER_PMD - 1)];
+			printk(KERN_ALERT "*pde = %08lx\n", page);
+		}
+#else
 		printk(KERN_ALERT "*pde = %08lx\n", page);
-	/*
-	 * We must not directly access the pte in the highpte
-	 * case, the page table might be allocated in highmem.
-	 * And lets rather not kmap-atomic the pte, just in case
-	 * it's allocated already.
-	 */
+#endif
+
+		/*
+		 * We must not directly access the pte in the highpte
+		 * case, the page table might be allocated in highmem.
+		 * And lets rather not kmap-atomic the pte, just in case
+		 * it's allocated already.
+		 */
 #ifndef CONFIG_HIGHPTE
-	if ((page & 1) && oops_may_print()) {
-		page &= PAGE_MASK;
-		address &= 0x003ff000;
-		page = ((unsigned long *) __va(page))[address >> PAGE_SHIFT];
-		printk(KERN_ALERT "*pte = %08lx\n", page);
-	}
+		if (page & 1) {
+			page &= PAGE_MASK;
+			page = ((pgt_t *) __va(page))[(address >> PAGE_SHIFT)
+			                              & (PTRS_PER_PTE - 1)];
+			printk(KERN_ALERT "*pte = %08lx\n", page);
+		}
 #endif
+	}
+
 	tsk->thread.cr2 = address;
 	tsk->thread.trap_no = 14;
 	tsk->thread.error_code = error_code;
_

Patches currently in -mm which might be from jbeulich@novell.com are

intel-rng-workarounds.patch
fix-hwrng-built-in-initcalls-priority.patch
ia64-swiotlb-bug-fixes.patch
ia64-make-swiotlb-use-bus_to_virt-virt_to_bus.patch
ia64-swiotlb-cleanup.patch
ia64-swiotlb-abstraction-eg-for-xen.patch
ia64-missing-exports-hwsw_sync_.patch
ia64-enable-swiotlb-only-when-needed.patch
x86_64-do-not-always-end-the-stack-trace-with-ulong_max.patch
i386-adjustments-to-page-table-dump-during-oops.patch
