From: akpm@linux-foundation.org
Subject: - uml-header-untangling.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:36:29 -0800
Message-ID: <200802052236.m15MaARO012687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52841 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756876AbYBEWmK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: header untangling
has been removed from the -mm tree.  Its filename was
     uml-header-untangling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: header untangling
From: Jeff Dike <jdike@addtoit.com>

Untangle UML headers somewhat and add some includes where they were
needed explicitly, but gotten accidentally via some other header.

arch/um/include/um_uaccess.h loses asm/fixmap.h because it uses no
fixmap stuff and gains elf.h, because it needs FIXADDR_USER_*, and
archsetjmp.h, because it needs jmp_buf.

pmd_alloc_one is uninlined because it needs mm_struct, and that's
inconvenient to provide in asm-um/pgtable-3level.h.

elf_core_copy_fpregs is also uninlined from elf-i386.h and
elf-x86_64.h, which duplicated the code anyway, to
arch/um/kernel/process.c, so that the reference to current_thread
doesn't pull sched.h or anything related into asm/elf.h.

arch/um/sys-i386/ldt.c, arch/um/kernel/tlb.c and
arch/um/kernel/skas/uaccess.c got sched.h because they dereference
task_structs.  Its includes of linux and asm headers got turned from
"" to <>.

arch/um/sys-i386/bug.c gets asm/errno.h because it needs errno
constants.

asm/elf-i386 gets asm/user.h because it needs user_regs_struct.

asm/fixmap.h gets page.h because it needs PAGE_SIZE and PAGE_MASK and
system.h for BUG_ON.

asm/pgtable doesn't need sched.h.

asm/processor-generic.h defined mm_segment_t, but didn't use it.  So,
that definition is moved to uaccess.h, which defines a bunch of
mm_segment_t-related stuff.  thread_info.h uses mm_segment_t, and
includes uaccess.h, which causes a recursion.  So, the definition is
placed above the include of thread_info. in uaccess.h.  thread_info.h
also gets page.h because it needs PAGE_SIZE.

ObCheckpatchViolationJustification - I'm not adding a typedef; I'm
moving mm_segment_t from one place to another.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/random.c           |    1 +
 arch/um/include/um_uaccess.h       |    4 +++-
 arch/um/kernel/mem.c               |   21 ++++++++++++++++-----
 arch/um/kernel/process.c           |    8 ++++++++
 arch/um/kernel/skas/uaccess.c      |   13 +++++++------
 arch/um/kernel/tlb.c               |    7 ++++---
 arch/um/sys-i386/bug.c             |    1 +
 arch/um/sys-i386/ldt.c             |    5 +++--
 include/asm-um/elf-i386.h          |    9 ++-------
 include/asm-um/elf-x86_64.h        |    8 +-------
 include/asm-um/fixmap.h            |    3 ++-
 include/asm-um/pgtable-3level.h    |   11 ++---------
 include/asm-um/pgtable.h           |    1 -
 include/asm-um/processor-generic.h |    5 +----
 include/asm-um/thread_info.h       |    3 ++-
 include/asm-um/uaccess.h           |   10 +++++++++-
 16 files changed, 62 insertions(+), 48 deletions(-)

diff -puN arch/um/drivers/random.c~uml-header-untangling arch/um/drivers/random.c
--- a/arch/um/drivers/random.c~uml-header-untangling
+++ a/arch/um/drivers/random.c
@@ -5,6 +5,7 @@
  * This software may be used and distributed according to the terms
  * of the GNU General Public License, incorporated herein by reference.
  */
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
diff -puN arch/um/include/um_uaccess.h~uml-header-untangling arch/um/include/um_uaccess.h
--- a/arch/um/include/um_uaccess.h~uml-header-untangling
+++ a/arch/um/include/um_uaccess.h
@@ -6,7 +6,9 @@
 #ifndef __ARCH_UM_UACCESS_H
 #define __ARCH_UM_UACCESS_H
 
-#include "asm/fixmap.h"
+#include <asm/elf.h>
+#include <asm/fixmap.h>
+#include "sysdep/archsetjmp.h"
 
 #define __under_task_size(addr, size) \
 	(((unsigned long) (addr) < TASK_SIZE) && \
diff -puN arch/um/kernel/mem.c~uml-header-untangling arch/um/kernel/mem.c
--- a/arch/um/kernel/mem.c~uml-header-untangling
+++ a/arch/um/kernel/mem.c
@@ -152,7 +152,7 @@ pgprot_t kmap_prot;
 
 #define kmap_get_fixmap_pte(vaddr)					\
 	pte_offset_kernel(pmd_offset(pud_offset(pgd_offset_k(vaddr), (vaddr)),\
- 			  (vaddr)), (vaddr))
+				     (vaddr)), (vaddr))
 
 static void __init kmap_init(void)
 {
@@ -278,7 +278,8 @@ struct page *arch_validate(struct page *
 	goto again;
 }
 
-/* This can't do anything because nothing in the kernel image can be freed
+/*
+ * This can't do anything because nothing in the kernel image can be freed
  * since it's not in kernel physical memory.
  */
 
@@ -331,9 +332,7 @@ void show_mem(void)
 	printk("%d pages swap cached\n", cached);
 }
 
-/*
- * Allocate and free page tables.
- */
+/* Allocate and free page tables. */
 
 pgd_t *pgd_alloc(struct mm_struct *mm)
 {
@@ -368,3 +367,15 @@ struct page *pte_alloc_one(struct mm_str
 	pte = alloc_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
 	return pte;
 }
+
+#ifdef CONFIG_3_LEVEL_PGTABLES
+pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
+{
+	pmd_t *pmd = (pmd_t *) __get_free_page(GFP_KERNEL);
+
+	if (pmd)
+		memset(pmd, 0, PAGE_SIZE);
+
+	return pmd;
+}
+#endif
diff -puN arch/um/kernel/process.c~uml-header-untangling arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-header-untangling
+++ a/arch/um/kernel/process.c
@@ -446,3 +446,11 @@ unsigned long get_wchan(struct task_stru
 
 	return 0;
 }
+
+int elf_core_copy_fpregs(struct task_struct *t, elf_fpregset_t *fpu)
+{
+	int cpu = current_thread_info()->cpu;
+
+	return save_fp_registers(userspace_pid[cpu], (unsigned long *) fpu);
+}
+
diff -puN arch/um/kernel/skas/uaccess.c~uml-header-untangling arch/um/kernel/skas/uaccess.c
--- a/arch/um/kernel/skas/uaccess.c~uml-header-untangling
+++ a/arch/um/kernel/skas/uaccess.c
@@ -3,12 +3,13 @@
  * Licensed under the GPL
  */
 
-#include "linux/err.h"
-#include "linux/highmem.h"
-#include "linux/mm.h"
-#include "asm/current.h"
-#include "asm/page.h"
-#include "asm/pgtable.h"
+#include <linux/err.h>
+#include <linux/highmem.h>
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <asm/current.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
 #include "kern_util.h"
 #include "os.h"
 
diff -puN arch/um/kernel/tlb.c~uml-header-untangling arch/um/kernel/tlb.c
--- a/arch/um/kernel/tlb.c~uml-header-untangling
+++ a/arch/um/kernel/tlb.c
@@ -3,9 +3,10 @@
  * Licensed under the GPL
  */
 
-#include "linux/mm.h"
-#include "asm/pgtable.h"
-#include "asm/tlbflush.h"
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <asm/pgtable.h>
+#include <asm/tlbflush.h>
 #include "as-layout.h"
 #include "mem_user.h"
 #include "os.h"
diff -puN arch/um/sys-i386/bug.c~uml-header-untangling arch/um/sys-i386/bug.c
--- a/arch/um/sys-i386/bug.c~uml-header-untangling
+++ a/arch/um/sys-i386/bug.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/uaccess.h>
+#include <asm/errno.h>
 
 /* Mostly copied from i386/x86_86 - eliminated the eip < PAGE_OFFSET because
  * that's not relevant in skas mode.
diff -puN arch/um/sys-i386/ldt.c~uml-header-untangling arch/um/sys-i386/ldt.c
--- a/arch/um/sys-i386/ldt.c~uml-header-untangling
+++ a/arch/um/sys-i386/ldt.c
@@ -3,8 +3,9 @@
  * Licensed under the GPL
  */
 
-#include "linux/mm.h"
-#include "asm/unistd.h"
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <asm/unistd.h>
 #include "os.h"
 #include "proc_mm.h"
 #include "skas.h"
diff -puN include/asm-um/elf-i386.h~uml-header-untangling include/asm-um/elf-i386.h
--- a/include/asm-um/elf-i386.h~uml-header-untangling
+++ a/include/asm-um/elf-i386.h
@@ -5,7 +5,7 @@
 #ifndef __UM_ELF_I386_H
 #define __UM_ELF_I386_H
 
-#include <linux/sched.h>
+#include <asm/user.h>
 #include "skas.h"
 
 #define R_386_NONE	0
@@ -76,12 +76,7 @@ typedef struct user_i387_struct elf_fpre
 	pr_reg[16] = PT_REGS_SS(regs);		\
 } while(0);
 
-static inline int elf_core_copy_fpregs(struct task_struct *t,
-				       elf_fpregset_t *fpu)
-{
-	int cpu = ((struct thread_info *) t->stack)->cpu;
-	return save_fp_registers(userspace_pid[cpu], (unsigned long *) fpu);
-}
+extern int elf_core_copy_fpregs(struct task_struct *t, elf_fpregset_t *fpu);
 
 #define ELF_CORE_COPY_FPREGS(t, fpu) elf_core_copy_fpregs(t, fpu)
 
diff -puN include/asm-um/elf-x86_64.h~uml-header-untangling include/asm-um/elf-x86_64.h
--- a/include/asm-um/elf-x86_64.h~uml-header-untangling
+++ a/include/asm-um/elf-x86_64.h
@@ -7,7 +7,6 @@
 #ifndef __UM_ELF_X86_64_H
 #define __UM_ELF_X86_64_H
 
-#include <linux/sched.h>
 #include <asm/user.h>
 #include "skas.h"
 
@@ -96,12 +95,7 @@ typedef struct user_i387_struct elf_fpre
 	(pr_reg)[25] = 0;					\
 	(pr_reg)[26] = 0;
 
-static inline int elf_core_copy_fpregs(struct task_struct *t,
-				       elf_fpregset_t *fpu)
-{
-	int cpu = current_thread->cpu;
-	return save_fp_registers(userspace_pid[cpu], (unsigned long *) fpu);
-}
+extern int elf_core_copy_fpregs(struct task_struct *t, elf_fpregset_t *fpu);
 
 #define ELF_CORE_COPY_FPREGS(t, fpu) elf_core_copy_fpregs(t, fpu)
 
diff -puN include/asm-um/fixmap.h~uml-header-untangling include/asm-um/fixmap.h
--- a/include/asm-um/fixmap.h~uml-header-untangling
+++ a/include/asm-um/fixmap.h
@@ -1,9 +1,10 @@
 #ifndef __UM_FIXMAP_H
 #define __UM_FIXMAP_H
 
+#include <asm/system.h>
 #include <asm/kmap_types.h>
 #include <asm/archparam.h>
-#include <asm/elf.h>
+#include <asm/page.h>
 
 /*
  * Here we define all the compile-time 'special' virtual
diff -puN include/asm-um/pgtable-3level.h~uml-header-untangling include/asm-um/pgtable-3level.h
--- a/include/asm-um/pgtable-3level.h~uml-header-untangling
+++ a/include/asm-um/pgtable-3level.h
@@ -59,15 +59,8 @@ static inline void pgd_mkuptodate(pgd_t 
 
 #define set_pmd(pmdptr, pmdval) set_64bit((phys_t *) (pmdptr), pmd_val(pmdval))
 
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
-{
-        pmd_t *pmd = (pmd_t *) __get_free_page(GFP_KERNEL);
-
-        if(pmd)
-                memset(pmd, 0, PAGE_SIZE);
-
-        return pmd;
-}
+struct mm_struct;
+extern pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address);
 
 static inline void pud_clear (pud_t *pud)
 {
diff -puN include/asm-um/pgtable.h~uml-header-untangling include/asm-um/pgtable.h
--- a/include/asm-um/pgtable.h~uml-header-untangling
+++ a/include/asm-um/pgtable.h
@@ -8,7 +8,6 @@
 #ifndef __UM_PGTABLE_H
 #define __UM_PGTABLE_H
 
-#include "linux/sched.h"
 #include <asm/fixmap.h>
 
 #define _PAGE_PRESENT	0x001
diff -puN include/asm-um/processor-generic.h~uml-header-untangling include/asm-um/processor-generic.h
--- a/include/asm-um/processor-generic.h~uml-header-untangling
+++ a/include/asm-um/processor-generic.h
@@ -11,6 +11,7 @@ struct pt_regs;
 struct task_struct;
 
 #include "asm/ptrace.h"
+#include "asm/pgtable.h"
 #include "registers.h"
 #include "sysdep/archsetjmp.h"
 
@@ -68,10 +69,6 @@ struct thread_struct {
 	.request		= { 0 } \
 }
 
-typedef struct {
-	unsigned long seg;
-} mm_segment_t;
-
 extern struct task_struct *alloc_task_struct(void);
 
 static inline void release_thread(struct task_struct *task)
diff -puN include/asm-um/thread_info.h~uml-header-untangling include/asm-um/thread_info.h
--- a/include/asm-um/thread_info.h~uml-header-untangling
+++ a/include/asm-um/thread_info.h
@@ -8,8 +8,9 @@
 
 #ifndef __ASSEMBLY__
 
-#include <asm/processor.h>
 #include <asm/types.h>
+#include <asm/page.h>
+#include <asm/uaccess.h>
 
 struct thread_info {
 	struct task_struct	*task;		/* main task structure */
diff -puN include/asm-um/uaccess.h~uml-header-untangling include/asm-um/uaccess.h
--- a/include/asm-um/uaccess.h~uml-header-untangling
+++ a/include/asm-um/uaccess.h
@@ -6,7 +6,15 @@
 #ifndef __UM_UACCESS_H
 #define __UM_UACCESS_H
 
-#include "linux/sched.h"
+#include <asm/errno.h>
+#include <asm/processor.h>
+
+/* thread_info has a mm_segment_t in it, so put the definition up here */
+typedef struct {
+	unsigned long seg;
+} mm_segment_t;
+
+#include "linux/thread_info.h"
 
 #define VERIFY_READ 0
 #define VERIFY_WRITE 1
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
