From: akpm@linux-foundation.org
Subject: - uml-style-cleanup.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:36:32 -0800
Message-ID: <200802052236.m15MaDjU012692@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44307 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762300AbYBEWmH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: style cleanup
has been removed from the -mm tree.  Its filename was
     uml-style-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: style cleanup
From: Jeff Dike <jdike@addtoit.com>

Style fixes in elf-i386.h and arch/um/kernel/mem.c.
      update the copyright
      get rid of an emacs formatting comment
      some formatting fixes
      inclusion trimming
      whitespace fixes

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/mem.c      |   86 +++++++++++++++++-------------------
 include/asm-um/elf-i386.h |   19 +------
 2 files changed, 45 insertions(+), 60 deletions(-)

diff -puN arch/um/kernel/mem.c~uml-style-cleanup arch/um/kernel/mem.c
--- a/arch/um/kernel/mem.c~uml-style-cleanup
+++ a/arch/um/kernel/mem.c
@@ -1,28 +1,22 @@
 /*
- * Copyright (C) 2000 - 2003 Jeff Dike (jdike@addtoit.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include "linux/stddef.h"
-#include "linux/kernel.h"
-#include "linux/mm.h"
-#include "linux/bootmem.h"
-#include "linux/swap.h"
-#include "linux/highmem.h"
-#include "linux/gfp.h"
-#include "asm/page.h"
-#include "asm/fixmap.h"
-#include "asm/pgalloc.h"
-#include "kern_util.h"
+#include <linux/stddef.h>
+#include <linux/bootmem.h>
+#include <linux/gfp.h>
+#include <linux/highmem.h>
+#include <linux/mm.h>
+#include <linux/swap.h>
+#include <asm/fixmap.h>
+#include <asm/page.h>
 #include "as-layout.h"
+#include "init.h"
 #include "kern.h"
+#include "kern_util.h"
 #include "mem_user.h"
-#include "um_uaccess.h"
 #include "os.h"
-#include "linux/types.h"
-#include "linux/string.h"
-#include "init.h"
-#include "kern_constants.h"
 
 /* allocated in paging_init, zeroed in mem_init, and unchanged thereafter */
 unsigned long *empty_zero_page = NULL;
@@ -53,7 +47,7 @@ static void setup_highmem(unsigned long 
 	int i;
 
 	highmem_pfn = __pa(highmem_start) >> PAGE_SHIFT;
-	for(i = 0; i < highmem_len >> PAGE_SHIFT; i++){
+	for (i = 0; i < highmem_len >> PAGE_SHIFT; i++) {
 		page = &mem_map[highmem_pfn + i];
 		ClearPageReserved(page);
 		init_page_count(page);
@@ -85,7 +79,7 @@ void __init mem_init(void)
 #endif
 	num_physpages = totalram_pages;
 	max_pfn = totalram_pages;
-	printk(KERN_INFO "Memory: %luk available\n", 
+	printk(KERN_INFO "Memory: %luk available\n",
 	       (unsigned long) nr_free_pages() << (PAGE_SHIFT-10));
 	kmalloc_ok = 1;
 
@@ -119,7 +113,7 @@ static void __init one_md_table_init(pud
 #endif
 }
 
-static void __init fixrange_init(unsigned long start, unsigned long end, 
+static void __init fixrange_init(unsigned long start, unsigned long end,
 				 pgd_t *pgd_base)
 {
 	pgd_t *pgd;
@@ -206,7 +200,8 @@ static void __init fixaddr_user_init( vo
 	paddr = (unsigned long)alloc_bootmem_low_pages( size);
 	memcpy( (void *)paddr, (void *)FIXADDR_USER_START, size);
 	paddr = __pa(paddr);
-	for ( ; size > 0; size-=PAGE_SIZE, vaddr+=PAGE_SIZE, paddr+=PAGE_SIZE){
+	for ( ; size > 0; size -= PAGE_SIZE, vaddr += PAGE_SIZE,
+		      paddr += PAGE_SIZE) {
 		pgd = swapper_pg_dir + pgd_index(vaddr);
 		pud = pud_offset(pgd, vaddr);
 		pmd = pmd_offset(pud, vaddr);
@@ -223,7 +218,7 @@ void __init paging_init(void)
 
 	empty_zero_page = (unsigned long *) alloc_bootmem_low_pages(PAGE_SIZE);
 	empty_bad_page = (unsigned long *) alloc_bootmem_low_pages(PAGE_SIZE);
-	for(i = 0; i < ARRAY_SIZE(zones_size); i++)
+	for (i = 0; i < ARRAY_SIZE(zones_size); i++)
 		zones_size[i] = 0;
 
 	zones_size[ZONE_NORMAL] = (end_iomem >> PAGE_SHIFT) -
@@ -253,26 +248,26 @@ struct page *arch_validate(struct page *
 	int i;
 
  again:
-	if(page == NULL)
+	if (page == NULL)
 		return page;
-	if(PageHighMem(page))
+	if (PageHighMem(page))
 		return page;
 
 	addr = (unsigned long) page_address(page);
-	for(i = 0; i < (1 << order); i++){
+	for (i = 0; i < (1 << order); i++) {
 		current->thread.fault_addr = (void *) addr;
-		if(__do_copy_to_user((void __user *) addr, &zero,
+		if (__do_copy_to_user((void __user *) addr, &zero,
 				     sizeof(zero),
 				     &current->thread.fault_addr,
-				     &current->thread.fault_catcher)){
-			if(!(mask & __GFP_WAIT))
+				     &current->thread.fault_catcher)) {
+			if (!(mask & __GFP_WAIT))
 				return NULL;
 			else break;
 		}
 		addr += PAGE_SIZE;
 	}
 
-	if(i == (1 << order))
+	if (i == (1 << order))
 		return page;
 	page = alloc_pages(mask, order);
 	goto again;
@@ -291,8 +286,8 @@ void free_initmem(void)
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
 	if (start < end)
-		printk ("Freeing initrd memory: %ldk freed\n", 
-			(end - start) >> 10);
+		printk(KERN_INFO "Freeing initrd memory: %ldk freed\n",
+		       (end - start) >> 10);
 	for (; start < end; start += PAGE_SIZE) {
 		ClearPageReserved(virt_to_page(start));
 		init_page_count(virt_to_page(start));
@@ -309,27 +304,28 @@ void show_mem(void)
 	int highmem = 0;
 	struct page *page;
 
-	printk("Mem-info:\n");
+	printk(KERN_INFO "Mem-info:\n");
 	show_free_areas();
-	printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
+	printk(KERN_INFO "Free swap:       %6ldkB\n",
+	       nr_swap_pages<<(PAGE_SHIFT-10));
 	pfn = max_mapnr;
-	while(pfn-- > 0) {
+	while (pfn-- > 0) {
 		page = pfn_to_page(pfn);
 		total++;
-		if(PageHighMem(page))
+		if (PageHighMem(page))
 			highmem++;
-		if(PageReserved(page))
+		if (PageReserved(page))
 			reserved++;
-		else if(PageSwapCache(page))
+		else if (PageSwapCache(page))
 			cached++;
-		else if(page_count(page))
+		else if (page_count(page))
 			shared += page_count(page) - 1;
 	}
-	printk("%d pages of RAM\n", total);
-	printk("%d pages of HIGHMEM\n", highmem);
-	printk("%d reserved pages\n", reserved);
-	printk("%d pages shared\n", shared);
-	printk("%d pages swap cached\n", cached);
+	printk(KERN_INFO "%d pages of RAM\n", total);
+	printk(KERN_INFO "%d pages of HIGHMEM\n", highmem);
+	printk(KERN_INFO "%d reserved pages\n", reserved);
+	printk(KERN_INFO "%d pages shared\n", shared);
+	printk(KERN_INFO "%d pages swap cached\n", cached);
 }
 
 /* Allocate and free page tables. */
@@ -340,8 +336,8 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 
 	if (pgd) {
 		memset(pgd, 0, USER_PTRS_PER_PGD * sizeof(pgd_t));
-		memcpy(pgd + USER_PTRS_PER_PGD, 
-		       swapper_pg_dir + USER_PTRS_PER_PGD, 
+		memcpy(pgd + USER_PTRS_PER_PGD,
+		       swapper_pg_dir + USER_PTRS_PER_PGD,
 		       (PTRS_PER_PGD - USER_PTRS_PER_PGD) * sizeof(pgd_t));
 	}
 	return pgd;
diff -puN include/asm-um/elf-i386.h~uml-style-cleanup include/asm-um/elf-i386.h
--- a/include/asm-um/elf-i386.h~uml-style-cleanup
+++ a/include/asm-um/elf-i386.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2000 - 2003 Jeff Dike (jdike@addtoit.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 #ifndef __UM_ELF_I386_H
@@ -46,7 +46,7 @@ typedef struct user_i387_struct elf_fpre
 	PT_REGS_EDI(regs) = 0; \
 	PT_REGS_EBP(regs) = 0; \
 	PT_REGS_EAX(regs) = 0; \
-} while(0)
+} while (0)
 
 #define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE 4096
@@ -74,7 +74,7 @@ typedef struct user_i387_struct elf_fpre
 	pr_reg[14] = PT_REGS_EFLAGS(regs);	\
 	pr_reg[15] = PT_REGS_SP(regs);		\
 	pr_reg[16] = PT_REGS_SS(regs);		\
-} while(0);
+} while (0);
 
 extern int elf_core_copy_fpregs(struct task_struct *t, elf_fpregset_t *fpu);
 
@@ -86,7 +86,7 @@ extern long elf_aux_hwcap;
 extern char * elf_aux_platform;
 #define ELF_PLATFORM (elf_aux_platform)
 
-#define SET_PERSONALITY(ex, ibcs2) do ; while(0)
+#define SET_PERSONALITY(ex, ibcs2) do { } while (0)
 
 extern unsigned long vsyscall_ehdr;
 extern unsigned long vsyscall_end;
@@ -161,14 +161,3 @@ if ( vsyscall_ehdr ) {							      \
 }
 
 #endif
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
