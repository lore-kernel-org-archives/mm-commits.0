From: akpm@linux-foundation.org
Subject: [merged] mm-introduce-fault_flag_default.patch removed
 from -mm tree
Date: Fri, 03 Apr 2020 13:38:48 -0700
Message-ID: <20200403203848.KOz2KgNqq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727867AbgDCUiu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:38:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, bgeffon@google.com, bobbypowers@gmail.com, cracauer@cons.org, david@redhat.com, dgilbert@redhat.com, dplotnikov@virtuozzo.com, gokhale2@llnl.gov, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, kirill@shutemov.name, mcfadden8@llnl.gov, mgorman@suse.de, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, peterx@redhat.com, rppt@linux.vnet.ibm.com, torvalds@linux-foundation.org, willy@infradead.org, xemul@openvz.org


The patch titled
     Subject: mm: introduce FAULT_FLAG_DEFAULT
has been removed from the -mm tree.  Its filename was
     mm-introduce-fault_flag_default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: introduce FAULT_FLAG_DEFAULT

Although there're tons of arch-specific page fault handlers, most of them
are still sharing the same initial value of the page fault flags.  Say,
merely all of the page fault handlers would allow the fault to be retried,
and they also allow the fault to respond to SIGKILL.

Let's define a default value for the fault flags to replace those initial
page fault flags that were copied over.  With this, it'll be far easier to
introduce new fault flag that can be used by all the architectures instead
of touching all the archs.

Link: http://lkml.kernel.org/r/20200220160238.9694-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Tested-by: Brian Geffon <bgeffon@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Bobby Powers <bobbypowers@gmail.com>
Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Cracauer <cracauer@cons.org>
Cc: Marty McFadden <mcfadden8@llnl.gov>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Maya Gokhale <gokhale2@llnl.gov>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/mm/fault.c      |    2 +-
 arch/arc/mm/fault.c        |    2 +-
 arch/arm/mm/fault.c        |    2 +-
 arch/arm64/mm/fault.c      |    2 +-
 arch/hexagon/mm/vm_fault.c |    2 +-
 arch/ia64/mm/fault.c       |    2 +-
 arch/m68k/mm/fault.c       |    2 +-
 arch/microblaze/mm/fault.c |    2 +-
 arch/mips/mm/fault.c       |    2 +-
 arch/nds32/mm/fault.c      |    2 +-
 arch/nios2/mm/fault.c      |    2 +-
 arch/openrisc/mm/fault.c   |    2 +-
 arch/parisc/mm/fault.c     |    2 +-
 arch/powerpc/mm/fault.c    |    2 +-
 arch/riscv/mm/fault.c      |    2 +-
 arch/s390/mm/fault.c       |    2 +-
 arch/sh/mm/fault.c         |    2 +-
 arch/sparc/mm/fault_32.c   |    2 +-
 arch/sparc/mm/fault_64.c   |    2 +-
 arch/um/kernel/trap.c      |    2 +-
 arch/unicore32/mm/fault.c  |    2 +-
 arch/x86/mm/fault.c        |    2 +-
 arch/xtensa/mm/fault.c     |    2 +-
 include/linux/mm.h         |    7 +++++++
 24 files changed, 30 insertions(+), 23 deletions(-)

--- a/arch/alpha/mm/fault.c~mm-introduce-fault_flag_default
+++ a/arch/alpha/mm/fault.c
@@ -89,7 +89,7 @@ do_page_fault(unsigned long address, uns
 	const struct exception_table_entry *fixup;
 	int si_code = SEGV_MAPERR;
 	vm_fault_t fault;
-	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+	unsigned int flags = FAULT_FLAG_DEFAULT;
 
 	/* As of EV6, a load into $31/$f31 is a prefetch, and never faults
 	   (or is suppressed by the PALcode).  Support that for older CPUs
--- a/arch/arc/mm/fault.c~mm-introduce-fault_flag_default
+++ a/arch/arc/mm/fault.c
@@ -100,7 +100,7 @@ void do_page_fault(unsigned long address
 	         (regs->ecr_cause == ECR_C_PROTV_INST_FETCH))
 		exec = 1;
 
-	flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+	flags = FAULT_FLAG_DEFAULT;
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
 	if (write)
--- a/arch/arm64/mm/fault.c~mm-introduce-fault_flag_default
+++ a/arch/arm64/mm/fault.c
@@ -446,7 +446,7 @@ static int __kprobes do_page_fault(unsig
 	struct mm_struct *mm = current->mm;
 	vm_fault_t fault, major = 0;
 	unsigned long vm_flags = VM_READ | VM_WRITE | VM_EXEC;
-	unsigned int mm_flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+	unsigned int mm_flags = FAULT_FLAG_DEFAULT;
 
 	if (kprobe_page_fault(regs, esr))
 		return 0;
--- a/arch/arm/mm/fault.c~mm-introduce-fault_flag_default
+++ a/arch/arm/mm/fault.c
@@ -241,7 +241,7 @@ do_page_fault(unsigned long addr, unsign
 	struct mm_struct *mm;
 	int sig, code;
 	vm_fault_t fault;
-	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+	unsigned int flags = FAULT_FLAG_DEFAULT;
 
 	if (kprobe_page_fault(regs, fsr))
 		return 0;
--- a/arch/hexagon/mm/vm_fault.c~mm-introduce-fault_flag_default
+++ a/arch/hexagon/mm/vm_fault.c
@@ -41,7 +41,7 @@ void do_page_fault(unsigned long address
 	int si_code = SEGV_MAPERR;
 	vm_fault_t fault;
 	const struct exception_table_entry *fixup;
-	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+	unsigned int flags = FAULT_FLAG_DEFAULT;
 
 	/*
 	 * If we're in an interrupt or have no user context,
--- a/arch/ia64/mm/fault.c~mm-introduce-fault_flag_default
+++ a/arch/ia64/mm/fault.c
@@ -65,7 +65,7 @@ ia64_do_page_fault (unsigned long addres
 	struct mm_struct *mm = current->mm;
 	unsigned long mask;
 	vm_fault_t fault;
-	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+	unsigned int flags = FAULT_FLAG_DEFAULT;
 
 	mask = ((((isr >> IA64_ISR_X_BIT) & 1UL) << VM_EXEC_BIT)
 		| (((isr >> IA64_ISR_W_BIT) & 1UL) << VM_WRITE_BIT));
--- a/arch/m68k/mm/fault.c~mm-introduce-fault_flag_default
+++ a/arch/m68k/mm/fault.c
@@ -71,7 +71,7 @@ int do_page_fault(struct pt_regs *regs,
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct * vma;
 	vm_fault_t fault;
-	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+	unsigned int flags = FAULT_FLAG_DEFAULT;
 
 	pr_debug("do page fault:\nregs->sr=%#x, regs->pc=%#lx, address=%#lx, %ld, %p\n",
 		regs->sr, regs->pc, address, error_code, mm ? mm->pgd : NULL);
--- a/arch/microblaze/mm/fault.c~mm-introduce-fault_flag_default
+++ a/arch/microblaze/mm/fault.c
@@ -91,7 +91,7 @@ void do_page_fault(struct pt_regs *regs,
 	int code = SEGV_MAPERR;
 	int is_write = error_code & ESR_S;
 	vm_fault_t fault;
-	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+	unsigned int flags = FAULT_FLAG_DEFAULT;
 
 	regs->ear = address;
 	regs->esr = error_code;
--- a/arch/mips/mm/fault.c~mm-introduce-fault_flag_default
+++ a/arch/mips/mm/fault.c
@@ -44,7 +44,7 @@ static void __kprobes __do_page_fault(st
 	const int field = sizeof(unsigned long) * 2;
 	int si_code;
 	vm_fault_t fault;
-	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+	unsigned int flags = FAULT_FLAG_DEFAULT;
 
 	static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 10);
 
--- a/arch/nds32/mm/fault.c~mm-introduce-fault_flag_default
+++ a/arch/nds32/mm/fault.c
@@ -80,7 +80,7 @@ void do_page_fault(unsigned long entry,
 	int si_code;
 	vm_fault_t fault;
 	unsigned int mask = VM_READ | VM_WRITE | VM_EXEC;
-	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+	unsigned int flags = FAULT_FLAG_DEFAULT;
 
 	error_code = error_code & (ITYPE_mskINST | ITYPE_mskETYPE);
 	tsk = current;
--- a/arch/nios2/mm/fault.c~mm-introduce-fault_flag_default
+++ a/arch/nios2/mm/fault.c
@@ -47,7 +47,7 @@ asmlinkage void do_page_fault(struct pt_
 	struct mm_struct *mm = tsk->mm;
 	int code = SEGV_MAPERR;
 	vm_fault_t fault;
-	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+	unsigned int flags = FAULT_FLAG_DEFAULT;
 
 	cause >>= 2;
 
--- a/arch/openrisc/mm/fault.c~mm-introduce-fault_flag_default
+++ a/arch/openrisc/mm/fault.c
@@ -50,7 +50,7 @@ asmlinkage void do_page_fault(struct pt_
 	struct vm_area_struct *vma;
 	int si_code;
 	vm_fault_t fault;
-	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+	unsigned int flags = FAULT_FLAG_DEFAULT;
 
 	tsk = current;
 
--- a/arch/parisc/mm/fault.c~mm-introduce-fault_flag_default
+++ a/arch/parisc/mm/fault.c
@@ -274,7 +274,7 @@ void do_page_fault(struct pt_regs *regs,
 	if (!mm)
 		goto no_context;
 
-	flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+	flags = FAULT_FLAG_DEFAULT;
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
 
--- a/arch/powerpc/mm/fault.c~mm-introduce-fault_flag_default
+++ a/arch/powerpc/mm/fault.c
@@ -434,7 +434,7 @@ static int __do_page_fault(struct pt_reg
 {
 	struct vm_area_struct * vma;
 	struct mm_struct *mm = current->mm;
-	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+	unsigned int flags = FAULT_FLAG_DEFAULT;
  	int is_exec = TRAP(regs) == 0x400;
 	int is_user = user_mode(regs);
 	int is_write = page_fault_is_write(error_code);
--- a/arch/riscv/mm/fault.c~mm-introduce-fault_flag_default
+++ a/arch/riscv/mm/fault.c
@@ -30,7 +30,7 @@ asmlinkage void do_page_fault(struct pt_
 	struct vm_area_struct *vma;
 	struct mm_struct *mm;
 	unsigned long addr, cause;
-	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+	unsigned int flags = FAULT_FLAG_DEFAULT;
 	int code = SEGV_MAPERR;
 	vm_fault_t fault;
 
--- a/arch/s390/mm/fault.c~mm-introduce-fault_flag_default
+++ a/arch/s390/mm/fault.c
@@ -429,7 +429,7 @@ static inline vm_fault_t do_exception(st
 
 	address = trans_exc_code & __FAIL_ADDR_MASK;
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
-	flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+	flags = FAULT_FLAG_DEFAULT;
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
 	if (access == VM_WRITE || (trans_exc_code & store_indication) == 0x400)
--- a/arch/sh/mm/fault.c~mm-introduce-fault_flag_default
+++ a/arch/sh/mm/fault.c
@@ -380,7 +380,7 @@ asmlinkage void __kprobes do_page_fault(
 	struct mm_struct *mm;
 	struct vm_area_struct * vma;
 	vm_fault_t fault;
-	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+	unsigned int flags = FAULT_FLAG_DEFAULT;
 
 	tsk = current;
 	mm = tsk->mm;
--- a/arch/sparc/mm/fault_32.c~mm-introduce-fault_flag_default
+++ a/arch/sparc/mm/fault_32.c
@@ -168,7 +168,7 @@ asmlinkage void do_sparc_fault(struct pt
 	int from_user = !(regs->psr & PSR_PS);
 	int code;
 	vm_fault_t fault;
-	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+	unsigned int flags = FAULT_FLAG_DEFAULT;
 
 	if (text_fault)
 		address = regs->pc;
--- a/arch/sparc/mm/fault_64.c~mm-introduce-fault_flag_default
+++ a/arch/sparc/mm/fault_64.c
@@ -271,7 +271,7 @@ asmlinkage void __kprobes do_sparc64_fau
 	int si_code, fault_code;
 	vm_fault_t fault;
 	unsigned long address, mm_rss;
-	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+	unsigned int flags = FAULT_FLAG_DEFAULT;
 
 	fault_code = get_thread_fault_code();
 
--- a/arch/um/kernel/trap.c~mm-introduce-fault_flag_default
+++ a/arch/um/kernel/trap.c
@@ -33,7 +33,7 @@ int handle_page_fault(unsigned long addr
 	pmd_t *pmd;
 	pte_t *pte;
 	int err = -EFAULT;
-	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+	unsigned int flags = FAULT_FLAG_DEFAULT;
 
 	*code_out = SEGV_MAPERR;
 
--- a/arch/unicore32/mm/fault.c~mm-introduce-fault_flag_default
+++ a/arch/unicore32/mm/fault.c
@@ -202,7 +202,7 @@ static int do_pf(unsigned long addr, uns
 	struct mm_struct *mm;
 	int sig, code;
 	vm_fault_t fault;
-	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+	unsigned int flags = FAULT_FLAG_DEFAULT;
 
 	tsk = current;
 	mm = tsk->mm;
--- a/arch/x86/mm/fault.c~mm-introduce-fault_flag_default
+++ a/arch/x86/mm/fault.c
@@ -1310,7 +1310,7 @@ void do_user_addr_fault(struct pt_regs *
 	struct task_struct *tsk;
 	struct mm_struct *mm;
 	vm_fault_t fault, major = 0;
-	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+	unsigned int flags = FAULT_FLAG_DEFAULT;
 
 	tsk = current;
 	mm = tsk->mm;
--- a/arch/xtensa/mm/fault.c~mm-introduce-fault_flag_default
+++ a/arch/xtensa/mm/fault.c
@@ -43,7 +43,7 @@ void do_page_fault(struct pt_regs *regs)
 
 	int is_write, is_exec;
 	vm_fault_t fault;
-	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+	unsigned int flags = FAULT_FLAG_DEFAULT;
 
 	code = SEGV_MAPERR;
 
--- a/include/linux/mm.h~mm-introduce-fault_flag_default
+++ a/include/linux/mm.h
@@ -391,6 +391,13 @@ extern pgprot_t protection_map[16];
 #define FAULT_FLAG_REMOTE	0x80	/* faulting for non current tsk/mm */
 #define FAULT_FLAG_INSTRUCTION  0x100	/* The fault was during an instruction fetch */
 
+/*
+ * The default fault flags that should be used by most of the
+ * arch-specific page fault handlers.
+ */
+#define FAULT_FLAG_DEFAULT  (FAULT_FLAG_ALLOW_RETRY | \
+			     FAULT_FLAG_KILLABLE)
+
 #define FAULT_FLAG_TRACE \
 	{ FAULT_FLAG_WRITE,		"WRITE" }, \
 	{ FAULT_FLAG_MKWRITE,		"MKWRITE" }, \
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-merge-parameters-for-change_protection.patch
userfaultfd-wp-apply-_page_uffd_wp-bit.patch
userfaultfd-wp-drop-_page_uffd_wp-properly-when-fork.patch
userfaultfd-wp-add-pmd_swp_uffd_wp-helpers.patch
userfaultfd-wp-support-swap-and-page-migration.patch
khugepaged-skip-collapse-if-uffd-wp-detected.patch
userfaultfd-wp-dont-wake-up-when-doing-write-protect.patch
userfaultfd-wp-declare-_uffdio_writeprotect-conditionally.patch
userfaultfd-selftests-refactor-statistics.patch
userfaultfd-selftests-add-write-protect-test.patch
