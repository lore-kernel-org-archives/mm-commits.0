From: akpm@linux-foundation.org
Subject: - x86_64-use-read-and-write-crx-in-c-files.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:11:07 -0700
Message-ID: <200707192011.l6JKB7cn020740@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33916 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760588AbXGSUPT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gcosta@redhat.com, mm-commits@vger.kernel.org


The patch titled
     x86_64: use read and write crX in .c files
has been removed from the -mm tree.  Its filename was
     x86_64-use-read-and-write-crx-in-c-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: use read and write crX in .c files
From: Glauber de Oliveira Costa <gcosta@redhat.com>

Ise the read and write functions provided at system.h for control registers
instead of writing raw assembly over and over again in .c files. 
Functions to manipulate cr2 and cr8 were provided, as they were lacking.

Also, removed some extra space after closing brackets

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/process.c |    8 +++----
 arch/x86_64/kernel/suspend.c |   20 +++++++++----------
 arch/x86_64/mm/fault.c       |    4 +--
 arch/x86_64/mm/init.c        |    2 -
 include/asm-x86_64/system.h  |   34 ++++++++++++++++++++++++++++-----
 5 files changed, 46 insertions(+), 22 deletions(-)

diff -puN arch/x86_64/kernel/process.c~x86_64-use-read-and-write-crx-in-c-files arch/x86_64/kernel/process.c
--- a/arch/x86_64/kernel/process.c~x86_64-use-read-and-write-crx-in-c-files
+++ a/arch/x86_64/kernel/process.c
@@ -346,10 +346,10 @@ void __show_regs(struct pt_regs * regs)
 	rdmsrl(MSR_GS_BASE, gs); 
 	rdmsrl(MSR_KERNEL_GS_BASE, shadowgs); 
 
-	asm("movq %%cr0, %0": "=r" (cr0));
-	asm("movq %%cr2, %0": "=r" (cr2));
-	asm("movq %%cr3, %0": "=r" (cr3));
-	asm("movq %%cr4, %0": "=r" (cr4));
+	cr0 = read_cr0();
+	cr2 = read_cr2();
+	cr3 = read_cr3();
+	cr4 = read_cr4();
 
 	printk("FS:  %016lx(%04x) GS:%016lx(%04x) knlGS:%016lx\n", 
 	       fs,fsindex,gs,gsindex,shadowgs); 
diff -puN arch/x86_64/kernel/suspend.c~x86_64-use-read-and-write-crx-in-c-files arch/x86_64/kernel/suspend.c
--- a/arch/x86_64/kernel/suspend.c~x86_64-use-read-and-write-crx-in-c-files
+++ a/arch/x86_64/kernel/suspend.c
@@ -55,11 +55,11 @@ void __save_processor_state(struct saved
 	 * control registers 
 	 */
 	rdmsrl(MSR_EFER, ctxt->efer);
-	asm volatile ("movq %%cr0, %0" : "=r" (ctxt->cr0));
-	asm volatile ("movq %%cr2, %0" : "=r" (ctxt->cr2));
-	asm volatile ("movq %%cr3, %0" : "=r" (ctxt->cr3));
-	asm volatile ("movq %%cr4, %0" : "=r" (ctxt->cr4));
-	asm volatile ("movq %%cr8, %0" : "=r" (ctxt->cr8));
+	ctxt->cr0 = read_cr0();
+	ctxt->cr2 = read_cr2();
+	ctxt->cr3 = read_cr3();
+	ctxt->cr4 = read_cr4();
+	ctxt->cr8 = read_cr8();
 }
 
 void save_processor_state(void)
@@ -81,11 +81,11 @@ void __restore_processor_state(struct sa
 	 * control registers
 	 */
 	wrmsrl(MSR_EFER, ctxt->efer);
-	asm volatile ("movq %0, %%cr8" :: "r" (ctxt->cr8));
-	asm volatile ("movq %0, %%cr4" :: "r" (ctxt->cr4));
-	asm volatile ("movq %0, %%cr3" :: "r" (ctxt->cr3));
-	asm volatile ("movq %0, %%cr2" :: "r" (ctxt->cr2));
-	asm volatile ("movq %0, %%cr0" :: "r" (ctxt->cr0));
+	write_cr8(ctxt->cr8);
+	write_cr4(ctxt->cr4);
+	write_cr3(ctxt->cr3);
+	write_cr2(ctxt->cr2);
+	write_cr0(ctxt->cr0);
 
 	/*
 	 * now restore the descriptor tables to their proper values
diff -puN arch/x86_64/mm/fault.c~x86_64-use-read-and-write-crx-in-c-files arch/x86_64/mm/fault.c
--- a/arch/x86_64/mm/fault.c~x86_64-use-read-and-write-crx-in-c-files
+++ a/arch/x86_64/mm/fault.c
@@ -159,7 +159,7 @@ void dump_pagetable(unsigned long addres
 	pmd_t *pmd;
 	pte_t *pte;
 
-	asm("movq %%cr3,%0" : "=r" (pgd));
+	pgd = (pgd_t *)read_cr3();
 
 	pgd = __va((unsigned long)pgd & PHYSICAL_PAGE_MASK); 
 	pgd += pgd_index(address);
@@ -316,7 +316,7 @@ asmlinkage void __kprobes do_page_fault(
 	prefetchw(&mm->mmap_sem);
 
 	/* get the address */
-	__asm__("movq %%cr2,%0":"=r" (address));
+	address = read_cr2();
 
 	info.si_code = SEGV_MAPERR;
 
diff -puN arch/x86_64/mm/init.c~x86_64-use-read-and-write-crx-in-c-files arch/x86_64/mm/init.c
--- a/arch/x86_64/mm/init.c~x86_64-use-read-and-write-crx-in-c-files
+++ a/arch/x86_64/mm/init.c
@@ -384,7 +384,7 @@ void __meminit init_memory_mapping(unsig
 	} 
 
 	if (!after_bootmem)
-		asm volatile("movq %%cr4,%0" : "=r" (mmu_cr4_features));
+		mmu_cr4_features = read_cr4();
 	__flush_tlb_all();
 }
 
diff -puN include/asm-x86_64/system.h~x86_64-use-read-and-write-crx-in-c-files include/asm-x86_64/system.h
--- a/include/asm-x86_64/system.h~x86_64-use-read-and-write-crx-in-c-files
+++ a/include/asm-x86_64/system.h
@@ -75,19 +75,31 @@ static inline unsigned long read_cr0(voi
 	unsigned long cr0;
 	asm volatile("movq %%cr0,%0" : "=r" (cr0));
 	return cr0;
-} 
+}
 
 static inline void write_cr0(unsigned long val) 
 { 
 	asm volatile("movq %0,%%cr0" :: "r" (val));
-} 
+}
+
+static inline unsigned long read_cr2(void)
+{
+	unsigned long cr2;
+	asm("movq %%cr2,%0" : "=r" (cr2));
+	return cr2;
+}
+
+static inline void write_cr2(unsigned long val)
+{
+	asm volatile("movq %0,%%cr2" :: "r" (val));
+}
 
 static inline unsigned long read_cr3(void)
 { 
 	unsigned long cr3;
 	asm("movq %%cr3,%0" : "=r" (cr3));
 	return cr3;
-} 
+}
 
 static inline void write_cr3(unsigned long val)
 {
@@ -99,12 +111,24 @@ static inline unsigned long read_cr4(voi
 	unsigned long cr4;
 	asm("movq %%cr4,%0" : "=r" (cr4));
 	return cr4;
-} 
+}
 
 static inline void write_cr4(unsigned long val)
 { 
 	asm volatile("movq %0,%%cr4" :: "r" (val) : "memory");
-} 
+}
+
+static inline unsigned long read_cr8(void)
+{
+	unsigned long cr8;
+	asm("movq %%cr8,%0" : "=r" (cr8));
+	return cr8;
+}
+
+static inline void write_cr8(unsigned long val)
+{
+	asm volatile("movq %0,%%cr8" :: "r" (val) : "memory");
+}
 
 #define stts() write_cr0(8 | read_cr0())
 
_

Patches currently in -mm which might be from gcosta@redhat.com are
