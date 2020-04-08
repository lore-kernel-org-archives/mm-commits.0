From: akpm@linux-foundation.org
Subject: [merged]
 mm-vma-make-vma_is_accessible-available-for-general-use.patch removed from
 -mm tree
Date: Tue, 07 Apr 2020 18:56:29 -0700
Message-ID: <20200408015629.ucdEX_-Dl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgDHB4c (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:56:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acme@kernel.org, aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com, arnd@arndb.de, benh@kernel.crashing.org, dalias@libc.org, dave.hansen@linux.intel.com, geert@linux-m68k.org, guoren@kernel.org, luto@kernel.org, mgorman@suse.de, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com, paulburton@kernel.org, paulus@ozlabs.org, paulus@samba.org, peterz@infradead.org, ralf@linux-mips.org, rostedt@goodmis.org, tglx@linutronix.de, vbabka@suse.cz, viro@zeniv.linux.org.uk, will@kernel.org, ysato@users.sourceforge.jp


The patch titled
     Subject: mm/vma: make vma_is_accessible() available for general use
has been removed from the -mm tree.  Its filename was
     mm-vma-make-vma_is_accessible-available-for-general-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/vma: make vma_is_accessible() available for general use

Lets move vma_is_accessible() helper to include/linux/mm.h which makes it
available for general use.  While here, this replaces all remaining open
encodings for VMA access check with vma_is_accessible().

Link: http://lkml.kernel.org/r/1582520593-30704-3-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Guo Ren <guoren@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Guo Ren <guoren@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Burton <paulburton@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/csky/mm/fault.c    |    2 +-
 arch/m68k/mm/fault.c    |    2 +-
 arch/mips/mm/fault.c    |    2 +-
 arch/powerpc/mm/fault.c |    2 +-
 arch/sh/mm/fault.c      |    2 +-
 arch/x86/mm/fault.c     |    2 +-
 include/linux/mm.h      |    6 ++++++
 kernel/sched/fair.c     |    2 +-
 mm/gup.c                |    2 +-
 mm/memory.c             |    5 -----
 mm/mempolicy.c          |    3 +--
 mm/mmap.c               |    5 ++---
 12 files changed, 17 insertions(+), 18 deletions(-)

--- a/arch/csky/mm/fault.c~mm-vma-make-vma_is_accessible-available-for-general-use
+++ a/arch/csky/mm/fault.c
@@ -141,7 +141,7 @@ good_area:
 		if (!(vma->vm_flags & VM_WRITE))
 			goto bad_area;
 	} else {
-		if (!(vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC)))
+		if (!vma_is_accessible(vma))
 			goto bad_area;
 	}
 
--- a/arch/m68k/mm/fault.c~mm-vma-make-vma_is_accessible-available-for-general-use
+++ a/arch/m68k/mm/fault.c
@@ -125,7 +125,7 @@ good_area:
 		case 1:		/* read, present */
 			goto acc_err;
 		case 0:		/* read, not present */
-			if (!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)))
+			if (!vma_is_accessible(vma))
 				goto acc_err;
 	}
 
--- a/arch/mips/mm/fault.c~mm-vma-make-vma_is_accessible-available-for-general-use
+++ a/arch/mips/mm/fault.c
@@ -142,7 +142,7 @@ good_area:
 				goto bad_area;
 			}
 		} else {
-			if (!(vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC)))
+			if (!vma_is_accessible(vma))
 				goto bad_area;
 		}
 	}
--- a/arch/powerpc/mm/fault.c~mm-vma-make-vma_is_accessible-available-for-general-use
+++ a/arch/powerpc/mm/fault.c
@@ -314,7 +314,7 @@ static bool access_error(bool is_write,
 		return false;
 	}
 
-	if (unlikely(!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE))))
+	if (unlikely(!vma_is_accessible(vma)))
 		return true;
 	/*
 	 * We should ideally do the vma pkey access check here. But in the
--- a/arch/sh/mm/fault.c~mm-vma-make-vma_is_accessible-available-for-general-use
+++ a/arch/sh/mm/fault.c
@@ -355,7 +355,7 @@ static inline int access_error(int error
 		return 1;
 
 	/* read, not present: */
-	if (unlikely(!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE))))
+	if (unlikely(!vma_is_accessible(vma)))
 		return 1;
 
 	return 0;
--- a/arch/x86/mm/fault.c~mm-vma-make-vma_is_accessible-available-for-general-use
+++ a/arch/x86/mm/fault.c
@@ -1222,7 +1222,7 @@ access_error(unsigned long error_code, s
 		return 1;
 
 	/* read, not present: */
-	if (unlikely(!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE))))
+	if (unlikely(!vma_is_accessible(vma)))
 		return 1;
 
 	return 0;
--- a/include/linux/mm.h~mm-vma-make-vma_is_accessible-available-for-general-use
+++ a/include/linux/mm.h
@@ -629,6 +629,12 @@ static inline bool vma_is_foreign(struct
 
 	return false;
 }
+
+static inline bool vma_is_accessible(struct vm_area_struct *vma)
+{
+	return vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC);
+}
+
 #ifdef CONFIG_SHMEM
 /*
  * The vma_is_shmem is not inline because it is used only by slow
--- a/kernel/sched/fair.c~mm-vma-make-vma_is_accessible-available-for-general-use
+++ a/kernel/sched/fair.c
@@ -2799,7 +2799,7 @@ static void task_numa_work(struct callba
 		 * Skip inaccessible VMAs to avoid any confusion between
 		 * PROT_NONE and NUMA hinting ptes
 		 */
-		if (!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)))
+		if (!vma_is_accessible(vma))
 			continue;
 
 		do {
--- a/mm/gup.c~mm-vma-make-vma_is_accessible-available-for-general-use
+++ a/mm/gup.c
@@ -1416,7 +1416,7 @@ long populate_vma_page_range(struct vm_a
 	 * We want mlock to succeed for regions that have any permissions
 	 * other than PROT_NONE.
 	 */
-	if (vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC))
+	if (vma_is_accessible(vma))
 		gup_flags |= FOLL_FORCE;
 
 	/*
--- a/mm/memory.c~mm-vma-make-vma_is_accessible-available-for-general-use
+++ a/mm/memory.c
@@ -3964,11 +3964,6 @@ static inline vm_fault_t wp_huge_pmd(str
 	return VM_FAULT_FALLBACK;
 }
 
-static inline bool vma_is_accessible(struct vm_area_struct *vma)
-{
-	return vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE);
-}
-
 static vm_fault_t create_huge_pud(struct vm_fault *vmf)
 {
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) &&			\
--- a/mm/mempolicy.c~mm-vma-make-vma_is_accessible-available-for-general-use
+++ a/mm/mempolicy.c
@@ -678,8 +678,7 @@ static int queue_pages_test_walk(unsigne
 
 	if (flags & MPOL_MF_LAZY) {
 		/* Similar to task_numa_work, skip inaccessible VMAs */
-		if (!is_vm_hugetlb_page(vma) &&
-			(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)) &&
+		if (!is_vm_hugetlb_page(vma) && vma_is_accessible(vma) &&
 			!(vma->vm_flags & VM_MIXEDMAP))
 			change_prot_numa(vma, start, endvma);
 		return 1;
--- a/mm/mmap.c~mm-vma-make-vma_is_accessible-available-for-general-use
+++ a/mm/mmap.c
@@ -2358,8 +2358,7 @@ int expand_upwards(struct vm_area_struct
 		gap_addr = TASK_SIZE;
 
 	next = vma->vm_next;
-	if (next && next->vm_start < gap_addr &&
-			(next->vm_flags & (VM_WRITE|VM_READ|VM_EXEC))) {
+	if (next && next->vm_start < gap_addr && vma_is_accessible(next)) {
 		if (!(next->vm_flags & VM_GROWSUP))
 			return -ENOMEM;
 		/* Check that both stack segments have the same anon_vma? */
@@ -2440,7 +2439,7 @@ int expand_downwards(struct vm_area_stru
 	prev = vma->vm_prev;
 	/* Check that both stack segments have the same anon_vma? */
 	if (prev && !(prev->vm_flags & VM_GROWSDOWN) &&
-			(prev->vm_flags & (VM_WRITE|VM_READ|VM_EXEC))) {
+			vma_is_accessible(prev)) {
 		if (address - prev->vm_end < stack_guard_gap)
 			return -ENOMEM;
 	}
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-vma-define-a-default-value-for-vm_data_default_flags.patch
mm-vma-introduce-vm_access_flags.patch
mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial.patch
mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial-v3.patch
mm-debug-add-tests-validating-architecture-page-table-helpers.patch
