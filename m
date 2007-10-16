From: akpm@linux-foundation.org
Subject: - uml-fold-mmu_context_skas-into-mm_context.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:37:46 -0700
Message-ID: <200710162037.l9GKbkTl015314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36552 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965436AbXJPVSE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:18:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: fold mmu_context_skas into mm_context
has been removed from the -mm tree.  Its filename was
     uml-fold-mmu_context_skas-into-mm_context.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fold mmu_context_skas into mm_context
From: Jeff Dike <jdike@addtoit.com>

This patch folds mmu_context_skas into struct mm_context, changing all users
of these structures as needed.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/skas/mmu-skas.h |   23 ----------------
 arch/um/include/tlb.h           |    2 -
 arch/um/include/um_mmu.h        |   18 ++++++++++--
 arch/um/kernel/exec.c           |    4 +-
 arch/um/kernel/reboot.c         |    2 -
 arch/um/kernel/skas/mmu.c       |   12 ++++----
 arch/um/kernel/skas/process.c   |    2 -
 arch/um/kernel/tlb.c            |   43 ++++++++++++++----------------
 arch/um/sys-i386/ldt.c          |   17 +++++------
 arch/um/sys-x86_64/syscalls.c   |    2 -
 include/asm-um/ldt.h            |    4 --
 include/asm-um/mmu_context.h    |    4 +-
 12 files changed, 58 insertions(+), 75 deletions(-)

diff -puN arch/um/include/skas/mmu-skas.h~uml-fold-mmu_context_skas-into-mm_context /dev/null
--- a/arch/um/include/skas/mmu-skas.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#ifndef __SKAS_MMU_H
-#define __SKAS_MMU_H
-
-#include "mm_id.h"
-#include "asm/ldt.h"
-
-struct mmu_context_skas {
-	struct mm_id id;
-	unsigned long last_page_table;
-#ifdef CONFIG_3_LEVEL_PGTABLES
-	unsigned long last_pmd;
-#endif
-	uml_ldt_t ldt;
-};
-
-extern void __switch_mm(struct mm_id * mm_idp);
-
-#endif
diff -puN arch/um/include/tlb.h~uml-fold-mmu_context_skas-into-mm_context arch/um/include/tlb.h
--- a/arch/um/include/tlb.h~uml-fold-mmu_context_skas-into-mm_context
+++ a/arch/um/include/tlb.h
@@ -33,7 +33,7 @@ struct host_vm_op {
 extern void force_flush_all(void);
 extern void fix_range_common(struct mm_struct *mm, unsigned long start_addr,
                              unsigned long end_addr, int force,
-			     int (*do_ops)(union mm_context *,
+			     int (*do_ops)(struct mm_context *,
 					   struct host_vm_op *, int, int,
 					   void **));
 extern int flush_tlb_kernel_range_common(unsigned long start,
diff -puN arch/um/include/um_mmu.h~uml-fold-mmu_context_skas-into-mm_context arch/um/include/um_mmu.h
--- a/arch/um/include/um_mmu.h~uml-fold-mmu_context_skas-into-mm_context
+++ a/arch/um/include/um_mmu.h
@@ -7,10 +7,22 @@
 #define __ARCH_UM_MMU_H
 
 #include "uml-config.h"
-#include "mmu-skas.h"
+#include "mm_id.h"
+#include "asm/ldt.h"
 
-typedef union mm_context {
-	struct mmu_context_skas skas;
+typedef struct mm_context {
+	struct mm_id id;
+	unsigned long last_page_table;
+#ifdef CONFIG_3_LEVEL_PGTABLES
+	unsigned long last_pmd;
+#endif
+	struct uml_ldt ldt;
 } mm_context_t;
 
+extern void __switch_mm(struct mm_id * mm_idp);
+
+/* Avoid tangled inclusion with asm/ldt.h */
+extern long init_new_ldt(struct mm_context *to_mm, struct mm_context *from_mm);
+extern void free_ldt(struct mm_context *mm);
+
 #endif
diff -puN arch/um/kernel/exec.c~uml-fold-mmu_context_skas-into-mm_context arch/um/kernel/exec.c
--- a/arch/um/kernel/exec.c~uml-fold-mmu_context_skas-into-mm_context
+++ a/arch/um/kernel/exec.c
@@ -23,14 +23,14 @@ void flush_thread(void)
 
 	arch_flush_thread(&current->thread.arch);
 
-	ret = unmap(&current->mm->context.skas.id, 0, end, 1, &data);
+	ret = unmap(&current->mm->context.id, 0, end, 1, &data);
 	if (ret) {
 		printk(KERN_ERR "flush_thread - clearing address space failed, "
 		       "err = %d\n", ret);
 		force_sig(SIGKILL, current);
 	}
 
-	__switch_mm(&current->mm->context.skas.id);
+	__switch_mm(&current->mm->context.id);
 }
 
 void start_thread(struct pt_regs *regs, unsigned long eip, unsigned long esp)
diff -puN arch/um/kernel/reboot.c~uml-fold-mmu_context_skas-into-mm_context arch/um/kernel/reboot.c
--- a/arch/um/kernel/reboot.c~uml-fold-mmu_context_skas-into-mm_context
+++ a/arch/um/kernel/reboot.c
@@ -25,7 +25,7 @@ static void kill_off_processes(void)
 			if(p->mm == NULL)
 				continue;
 
-			pid = p->mm->context.skas.id.u.pid;
+			pid = p->mm->context.id.u.pid;
 			os_kill_ptraced_process(pid, 1);
 		}
 	}
diff -puN arch/um/kernel/skas/mmu.c~uml-fold-mmu_context_skas-into-mm_context arch/um/kernel/skas/mmu.c
--- a/arch/um/kernel/skas/mmu.c~uml-fold-mmu_context_skas-into-mm_context
+++ a/arch/um/kernel/skas/mmu.c
@@ -47,9 +47,9 @@ static int init_stub_pte(struct mm_struc
 	 * destroy_context_skas.
 	 */
 
-	mm->context.skas.last_page_table = pmd_page_vaddr(*pmd);
+	mm->context.last_page_table = pmd_page_vaddr(*pmd);
 #ifdef CONFIG_3_LEVEL_PGTABLES
-	mm->context.skas.last_pmd = (unsigned long) __va(pud_val(*pud));
+	mm->context.last_pmd = (unsigned long) __va(pud_val(*pud));
 #endif
 
 	*pte = mk_pte(virt_to_page(kernel), __pgprot(_PAGE_PRESENT));
@@ -66,8 +66,8 @@ static int init_stub_pte(struct mm_struc
 
 int init_new_context(struct task_struct *task, struct mm_struct *mm)
 {
-	struct mmu_context_skas *from_mm = NULL;
-	struct mmu_context_skas *to_mm = &mm->context.skas;
+ 	struct mm_context *from_mm = NULL;
+	struct mm_context *to_mm = &mm->context;
 	unsigned long stack = 0;
 	int ret = -ENOMEM;
 
@@ -97,7 +97,7 @@ int init_new_context(struct task_struct 
 
 	to_mm->id.stack = stack;
 	if (current->mm != NULL && current->mm != &init_mm)
-		from_mm = &current->mm->context.skas;
+		from_mm = &current->mm->context;
 
 	if (proc_mm) {
 		ret = new_mm(stack);
@@ -133,7 +133,7 @@ int init_new_context(struct task_struct 
 
 void destroy_context(struct mm_struct *mm)
 {
-	struct mmu_context_skas *mmu = &mm->context.skas;
+	struct mm_context *mmu = &mm->context;
 
 	if (proc_mm)
 		os_close_file(mmu->id.u.mm_fd);
diff -puN arch/um/kernel/skas/process.c~uml-fold-mmu_context_skas-into-mm_context arch/um/kernel/skas/process.c
--- a/arch/um/kernel/skas/process.c~uml-fold-mmu_context_skas-into-mm_context
+++ a/arch/um/kernel/skas/process.c
@@ -65,5 +65,5 @@ unsigned long current_stub_stack(void)
 	if (current->mm == NULL)
 		return 0;
 
-	return current->mm->context.skas.id.stack;
+	return current->mm->context.id.stack;
 }
diff -puN arch/um/kernel/tlb.c~uml-fold-mmu_context_skas-into-mm_context arch/um/kernel/tlb.c
--- a/arch/um/kernel/tlb.c~uml-fold-mmu_context_skas-into-mm_context
+++ a/arch/um/kernel/tlb.c
@@ -14,8 +14,8 @@
 
 static int add_mmap(unsigned long virt, unsigned long phys, unsigned long len,
 		    unsigned int prot, struct host_vm_op *ops, int *index,
-		    int last_filled, union mm_context *mmu, void **flush,
-		    int (*do_ops)(union mm_context *, struct host_vm_op *,
+		    int last_filled, struct mm_context *mmu, void **flush,
+		    int (*do_ops)(struct mm_context *, struct host_vm_op *,
 				  int, int, void **))
 {
 	__u64 offset;
@@ -52,8 +52,8 @@ static int add_mmap(unsigned long virt, 
 
 static int add_munmap(unsigned long addr, unsigned long len,
 		      struct host_vm_op *ops, int *index, int last_filled,
-		      union mm_context *mmu, void **flush,
-		      int (*do_ops)(union mm_context *, struct host_vm_op *,
+		      struct mm_context *mmu, void **flush,
+		      int (*do_ops)(struct mm_context *, struct host_vm_op *,
 				    int, int, void **))
 {
 	struct host_vm_op *last;
@@ -82,8 +82,8 @@ static int add_munmap(unsigned long addr
 
 static int add_mprotect(unsigned long addr, unsigned long len,
 			unsigned int prot, struct host_vm_op *ops, int *index,
-			int last_filled, union mm_context *mmu, void **flush,
-			int (*do_ops)(union mm_context *, struct host_vm_op *,
+			int last_filled, struct mm_context *mmu, void **flush,
+			int (*do_ops)(struct mm_context *, struct host_vm_op *,
 				      int, int, void **))
 {
 	struct host_vm_op *last;
@@ -117,8 +117,8 @@ static int add_mprotect(unsigned long ad
 static inline int update_pte_range(pmd_t *pmd, unsigned long addr,
 				   unsigned long end, struct host_vm_op *ops,
 				   int last_op, int *op_index, int force,
-				   union mm_context *mmu, void **flush,
-				   int (*do_ops)(union mm_context *,
+				   struct mm_context *mmu, void **flush,
+				   int (*do_ops)(struct mm_context *,
 						 struct host_vm_op *, int, int,
 						 void **))
 {
@@ -157,8 +157,8 @@ static inline int update_pte_range(pmd_t
 static inline int update_pmd_range(pud_t *pud, unsigned long addr,
 				   unsigned long end, struct host_vm_op *ops,
 				   int last_op, int *op_index, int force,
-				   union mm_context *mmu, void **flush,
-				   int (*do_ops)(union mm_context *,
+				   struct mm_context *mmu, void **flush,
+				   int (*do_ops)(struct mm_context *,
 						 struct host_vm_op *, int, int,
 						 void **))
 {
@@ -187,8 +187,8 @@ static inline int update_pmd_range(pud_t
 static inline int update_pud_range(pgd_t *pgd, unsigned long addr,
 				   unsigned long end, struct host_vm_op *ops,
 				   int last_op, int *op_index, int force,
-				   union mm_context *mmu, void **flush,
-				   int (*do_ops)(union mm_context *,
+				   struct mm_context *mmu, void **flush,
+				   int (*do_ops)(struct mm_context *,
 						 struct host_vm_op *, int, int,
 						 void **))
 {
@@ -216,11 +216,11 @@ static inline int update_pud_range(pgd_t
 
 void fix_range_common(struct mm_struct *mm, unsigned long start_addr,
 		      unsigned long end_addr, int force,
-		      int (*do_ops)(union mm_context *, struct host_vm_op *,
+		      int (*do_ops)(struct mm_context *, struct host_vm_op *,
 				    int, int, void **))
 {
 	pgd_t *pgd;
-	union mm_context *mmu = &mm->context;
+	struct mm_context *mmu = &mm->context;
 	struct host_vm_op ops[1];
 	unsigned long addr = start_addr, next;
 	int ret = 0, last_op = ARRAY_SIZE(ops) - 1, op_index = -1;
@@ -375,7 +375,7 @@ void flush_tlb_page(struct vm_area_struc
 		w = 0;
 	}
 
-	mm_id = &mm->context.skas.id;
+	mm_id = &mm->context.id;
 	prot = ((r ? UM_PROT_READ : 0) | (w ? UM_PROT_WRITE : 0) |
 		(x ? UM_PROT_EXEC : 0));
 	if (pte_newpage(*pte)) {
@@ -453,7 +453,7 @@ void __flush_tlb_one(unsigned long addr)
 	flush_tlb_kernel_range_common(addr, addr + PAGE_SIZE);
 }
 
-static int do_ops(union mm_context *mmu, struct host_vm_op *ops, int last,
+static int do_ops(struct mm_context *mmu, struct host_vm_op *ops, int last,
 		  int finished, void **flush)
 {
 	struct host_vm_op *op;
@@ -463,17 +463,16 @@ static int do_ops(union mm_context *mmu,
 	op = &ops[i];
 		switch(op->type) {
 		case MMAP:
-			ret = map(&mmu->skas.id, op->u.mmap.addr,
-				  op->u.mmap.len, op->u.mmap.prot,
-				  op->u.mmap.fd, op->u.mmap.offset, finished,
-				  flush);
+			ret = map(&mmu->id, op->u.mmap.addr, op->u.mmap.len,
+				  op->u.mmap.prot, op->u.mmap.fd,
+				  op->u.mmap.offset, finished, flush);
 			break;
 		case MUNMAP:
-			ret = unmap(&mmu->skas.id, op->u.munmap.addr,
+			ret = unmap(&mmu->id, op->u.munmap.addr,
 				    op->u.munmap.len, finished, flush);
 			break;
 		case MPROTECT:
-			ret = protect(&mmu->skas.id, op->u.mprotect.addr,
+			ret = protect(&mmu->id, op->u.mprotect.addr,
 				      op->u.mprotect.len, op->u.mprotect.prot,
 				      finished, flush);
 			break;
diff -puN arch/um/sys-i386/ldt.c~uml-fold-mmu_context_skas-into-mm_context arch/um/sys-i386/ldt.c
--- a/arch/um/sys-i386/ldt.c~uml-fold-mmu_context_skas-into-mm_context
+++ a/arch/um/sys-i386/ldt.c
@@ -33,7 +33,7 @@ long write_ldt_entry(struct mm_id * mm_i
 		 * Note: I'm unsure: should interrupts be disabled here?
 		 */
 		if (!current->active_mm || current->active_mm == &init_mm ||
-		    mm_idp != &current->active_mm->context.skas.id)
+		    mm_idp != &current->active_mm->context.id)
 			__switch_mm(mm_idp);
 	}
 
@@ -79,8 +79,8 @@ long write_ldt_entry(struct mm_id * mm_i
 		 * PTRACE_LDT possible to implement.
 		 */
 		if (current->active_mm && current->active_mm != &init_mm &&
-		    mm_idp != &current->active_mm->context.skas.id)
-			__switch_mm(&current->active_mm->context.skas.id);
+		    mm_idp != &current->active_mm->context.id)
+			__switch_mm(&current->active_mm->context.id);
 	}
 
 	return res;
@@ -135,7 +135,7 @@ static int read_ldt(void __user * ptr, u
 {
 	int i, err = 0;
 	unsigned long size;
-	uml_ldt_t * ldt = &current->mm->context.skas.ldt;
+	uml_ldt_t * ldt = &current->mm->context.ldt;
 
 	if (!ldt->entry_count)
 		goto out;
@@ -203,8 +203,8 @@ static int read_default_ldt(void __user 
 
 static int write_ldt(void __user * ptr, unsigned long bytecount, int func)
 {
-	uml_ldt_t * ldt = &current->mm->context.skas.ldt;
-	struct mm_id * mm_idp = &current->mm->context.skas.id;
+	uml_ldt_t * ldt = &current->mm->context.ldt;
+	struct mm_id * mm_idp = &current->mm->context.id;
 	int i, err;
 	struct user_desc ldt_info;
 	struct ldt_entry entry0, *ldt_p;
@@ -384,8 +384,7 @@ out_free:
 	free_pages((unsigned long)ldt, order);
 }
 
-long init_new_ldt(struct mmu_context_skas * new_mm,
-		  struct mmu_context_skas * from_mm)
+long init_new_ldt(struct mm_context *new_mm, struct mm_context *from_mm)
 {
 	struct user_desc desc;
 	short * num_p;
@@ -483,7 +482,7 @@ long init_new_ldt(struct mmu_context_ska
 }
 
 
-void free_ldt(struct mmu_context_skas * mm)
+void free_ldt(struct mm_context *mm)
 {
 	int i;
 
diff -puN arch/um/sys-x86_64/syscalls.c~uml-fold-mmu_context_skas-into-mm_context arch/um/sys-x86_64/syscalls.c
--- a/arch/um/sys-x86_64/syscalls.c~uml-fold-mmu_context_skas-into-mm_context
+++ a/arch/um/sys-x86_64/syscalls.c
@@ -30,7 +30,7 @@ long arch_prctl(struct task_struct *task
 {
 	unsigned long *ptr = addr, tmp;
 	long ret;
-	int pid = task->mm->context.skas.id.u.pid;
+	int pid = task->mm->context.id.u.pid;
 
 	/*
 	 * With ARCH_SET_FS (and ARCH_SET_GS is treated similarly to
diff -puN include/asm-um/ldt.h~uml-fold-mmu_context_skas-into-mm_context include/asm-um/ldt.h
--- a/include/asm-um/ldt.h~uml-fold-mmu_context_skas-into-mm_context
+++ a/include/asm-um/ldt.h
@@ -11,11 +11,7 @@
 #include "asm/semaphore.h"
 #include "asm/host_ldt.h"
 
-struct mmu_context_skas;
 extern void ldt_host_info(void);
-extern long init_new_ldt(struct mmu_context_skas * to_mm,
-			 struct mmu_context_skas * from_mm);
-extern void free_ldt(struct mmu_context_skas * mm);
 
 #define LDT_PAGES_MAX \
 	((LDT_ENTRIES * LDT_ENTRY_SIZE)/PAGE_SIZE)
diff -puN include/asm-um/mmu_context.h~uml-fold-mmu_context_skas-into-mm_context include/asm-um/mmu_context.h
--- a/include/asm-um/mmu_context.h~uml-fold-mmu_context_skas-into-mm_context
+++ a/include/asm-um/mmu_context.h
@@ -29,7 +29,7 @@ static inline void activate_mm(struct mm
 	 * possible.
 	 */
 	if (old != new && (current->flags & PF_BORROWED_MM))
-		__switch_mm(&new->context.skas.id);
+		__switch_mm(&new->context.id);
 }
 
 static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next, 
@@ -41,7 +41,7 @@ static inline void switch_mm(struct mm_s
 		cpu_clear(cpu, prev->cpu_vm_mask);
 		cpu_set(cpu, next->cpu_vm_mask);
 		if(next != &init_mm)
-			__switch_mm(&next->context.skas.id);
+			__switch_mm(&next->context.id);
 	}
 }
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch
