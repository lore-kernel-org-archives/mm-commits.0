From: akpm@osdl.org
Subject: + i386-adjustments-to-page-table-dump-during-oops-v2.patch added to -mm tree
Date: Tue, 23 Jan 2007 21:13:30 -0800
Message-ID: <200701240513.l0O5DUQV009099@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52196 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030211AbXAXFNf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 00:13:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, ak@suse.de


The patch titled
     i386: adjustments to page table dump during oops
has been added to the -mm tree.  Its filename is
     i386-adjustments-to-page-table-dump-during-oops-v2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: adjustments to page table dump during oops
From: "Jan Beulich" <jbeulich@novell.com>

I'd like this to replace the previously sent patch under the same title,
applied as i386-adjustments-to-page-table-dump-during-oops.patch in -mm.
If an incremental patch on top of the previous one is absolutely
required, I can certainly also generate that.

- make the page table contents printing PAE capable
- make sure the address stored in current->thread.cr2 is unmodified from
  what was read from CR2
- don't call oops_may_print() multiple times, when one time suffices
- print pte even in highpte case, as long as the pte page isn't in
  actually in high memory (which is specifically the case for all page
  tables covering kernel space)

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/mm/fault.c |   66 +++++++++++++++++++++++++++--------------
 1 file changed, 45 insertions(+), 21 deletions(-)

diff -puN arch/i386/mm/fault.c~i386-adjustments-to-page-table-dump-during-oops-v2 arch/i386/mm/fault.c
--- a/arch/i386/mm/fault.c~i386-adjustments-to-page-table-dump-during-oops-v2
+++ a/arch/i386/mm/fault.c
@@ -327,7 +327,6 @@ fastcall void __kprobes do_page_fault(st
 	struct mm_struct *mm;
 	struct vm_area_struct * vma;
 	unsigned long address;
-	unsigned long page;
 	int write, si_code;
 
 	/* get the address */
@@ -536,7 +535,16 @@ no_context:
 	bust_spinlocks(1);
 
 	if (oops_may_print()) {
-	#ifdef CONFIG_X86_PAE
+#ifndef CONFIG_X86_PAE
+		typedef unsigned long pgt_t;
+#define PRIpgt "08lx"
+#else
+		typedef unsigned long long pgt_t;
+#define PRIpgt "016Lx"
+#endif
+		pgt_t page;
+
+#ifdef CONFIG_X86_PAE
 		if (error_code & 16) {
 			pte_t *pte = lookup_address(address);
 
@@ -545,7 +553,7 @@ no_context:
 					"NX-protected page - exploit attempt? "
 					"(uid: %d)\n", current->uid);
 		}
-	#endif
+#endif
 		if (address < PAGE_SIZE)
 			printk(KERN_ALERT "BUG: unable to handle kernel NULL "
 					"pointer dereference");
@@ -555,25 +563,41 @@ no_context:
 		printk(" at virtual address %08lx\n",address);
 		printk(KERN_ALERT " printing eip:\n");
 		printk("%08lx\n", regs->eip);
-	}
-	page = read_cr3();
-	page = ((unsigned long *) __va(page))[address >> 22];
-	if (oops_may_print())
-		printk(KERN_ALERT "*pde = %08lx\n", page);
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
+
+		page = read_cr3();
+		page = ((pgt_t *) __va(page))[address >> PGDIR_SHIFT];
+#ifdef CONFIG_X86_PAE
+		printk(KERN_ALERT "*pdpt = %"PRIpgt"\n", page);
+		if (page & 1) {
+			page &= PAGE_MASK;
+			page = ((pgt_t *) __va(page))[(address >> PMD_SHIFT)
+			                              & (PTRS_PER_PMD - 1)];
+			printk(KERN_ALERT "*pde = %"PRIpgt"\n", page);
+			page &= ~_PAGE_NX;
+		}
+#else
+		printk(KERN_ALERT "*pde = %"PRIpgt"\n", page);
+#endif
+
+#ifdef CONFIG_HIGHPTE
+		/*
+		 * We must not directly access the pte in the highpte
+		 * case if the page table is located in highmem.
+		 * And lets rather not kmap-atomic the pte, just in case
+		 * it's allocated already.
+		 */
+		if ((page >> PAGE_SHIFT) >= highstart_pfn)
+			page = 0;
 #endif
+		if (page & 1) {
+			page &= PAGE_MASK;
+			page = ((pgt_t *) __va(page))[(address >> PAGE_SHIFT)
+			                              & (PTRS_PER_PTE - 1)];
+			printk(KERN_ALERT "*pte = %"PRIpgt"\n", page);
+		}
+#undef PRIpgt
+	}
+
 	tsk->thread.cr2 = address;
 	tsk->thread.trap_no = 14;
 	tsk->thread.error_code = error_code;
_

Patches currently in -mm which might be from jbeulich@novell.com are

ia64-swiotlb-bug-fixes.patch
ia64-make-swiotlb-use-bus_to_virt-virt_to_bus.patch
ia64-swiotlb-cleanup.patch
ia64-swiotlb-abstraction-eg-for-xen.patch
ia64-missing-exports-hwsw_sync_.patch
ia64-enable-swiotlb-only-when-needed.patch
i386-adjustments-to-page-table-dump-during-oops-v2.patch
i386-adjustments-to-page-table-dump-during-oops.patch
i386-entrys-end-endproc-annotations.patch
