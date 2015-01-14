From: akpm@linux-foundation.org
Subject: + mm-account-pmd-page-tables-to-the-process.patch added to -mm
 tree
Date: Wed, 14 Jan 2015 15:42:08 -0800
Message-ID: <54b6fed0.iWMe04FNlYDCnDJg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbbANXmJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Jan 2015 18:42:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, dave.hansen@linux.intel.com, gorcunov@openvz.org, hughd@google.com, rientjes@google.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: account pmd page tables to the process
has been added to the -mm tree.  Its filename is
     mm-account-pmd-page-tables-to-the-process.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-account-pmd-page-tables-to-the-process.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-account-pmd-page-tables-to-the-process.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: account pmd page tables to the process

Dave noticed that unprivileged process can allocate significant amount of
memory -- >500 MiB on x86_64 -- and stay unnoticed by oom-killer and
memory cgroup.  The trick is to allocate a lot of PMD page tables.  Linux
kernel doesn't account PMD tables to the process, only PTE.

The use-cases below use few tricks to allocate a lot of PMD page tables
while keeping VmRSS and VmPTE low.  oom_score for the process will be 0.

	#include <errno.h>
	#include <stdio.h>
	#include <stdlib.h>
	#include <unistd.h>
	#include <sys/mman.h>
	#include <sys/prctl.h>

	#define PUD_SIZE (1UL << 30)
	#define PMD_SIZE (1UL << 21)

	#define NR_PUD 130000

	int main(void)
	{
		char *addr = NULL;
		unsigned long i;

		prctl(PR_SET_THP_DISABLE);
		for (i = 0; i < NR_PUD ; i++) {
			addr = mmap(addr + PUD_SIZE, PUD_SIZE, PROT_WRITE|PROT_READ,
					MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
			if (addr == MAP_FAILED) {
				perror("mmap");
				break;
			}
			*addr = 'x';
			munmap(addr, PMD_SIZE);
			mmap(addr, PMD_SIZE, PROT_WRITE|PROT_READ,
					MAP_ANONYMOUS|MAP_PRIVATE|MAP_FIXED, -1, 0);
			if (addr == MAP_FAILED)
				perror("re-mmap"), exit(1);
		}
		printf("PID %d consumed %lu KiB in PMD page tables\n",
				getpid(), i * 4096 >> 10);
		return pause();
	}

The patch addresses the issue by account PMD tables to the process the
same way we account PTE.

The main place where PMD tables is accounted is __pmd_alloc() and
free_pmd_range(). But there're few corner cases:

 - HugeTLB can share PMD page tables. The patch handles by accounting
   the table to all processes who share it.

 - x86 PAE pre-allocates few PMD tables on fork.

 - Architectures with FIRST_USER_ADDRESS > 0. We need to adjust sanity
   check on exit(2).

Accounting only happens on configuration where PMD page table's level is
present (PMD is not folded).  As with nr_ptes we use per-mm counter.  The
counter value is used to calculate baseline for badness score by
oom-killer.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   12 ++++++------
 arch/x86/mm/pgtable.c       |   13 ++++++++-----
 fs/proc/task_mmu.c          |    9 ++++++---
 include/linux/mm.h          |   24 ++++++++++++++++++++++++
 include/linux/mm_types.h    |    5 ++++-
 kernel/fork.c               |    3 +++
 mm/debug.c                  |    3 ++-
 mm/hugetlb.c                |    8 ++++++--
 mm/memory.c                 |    2 ++
 mm/mmap.c                   |    4 +++-
 mm/oom_kill.c               |    9 +++++----
 11 files changed, 69 insertions(+), 23 deletions(-)

diff -puN Documentation/sysctl/vm.txt~mm-account-pmd-page-tables-to-the-process Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-account-pmd-page-tables-to-the-process
+++ a/Documentation/sysctl/vm.txt
@@ -555,12 +555,12 @@ this is causing problems for your system
 
 oom_dump_tasks
 
-Enables a system-wide task dump (excluding kernel threads) to be
-produced when the kernel performs an OOM-killing and includes such
-information as pid, uid, tgid, vm size, rss, nr_ptes, swapents,
-oom_score_adj score, and name.  This is helpful to determine why the
-OOM killer was invoked, to identify the rogue task that caused it,
-and to determine why the OOM killer chose the task it did to kill.
+Enables a system-wide task dump (excluding kernel threads) to be produced
+when the kernel performs an OOM-killing and includes such information as
+pid, uid, tgid, vm size, rss, nr_ptes, nr_pmds, swapents, oom_score_adj
+score, and name.  This is helpful to determine why the OOM killer was
+invoked, to identify the rogue task that caused it, and to determine why
+the OOM killer chose the task it did to kill.
 
 If this is set to zero, this information is suppressed.  On very
 large systems with thousands of tasks it may not be feasible to dump
diff -puN arch/x86/mm/pgtable.c~mm-account-pmd-page-tables-to-the-process arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c~mm-account-pmd-page-tables-to-the-process
+++ a/arch/x86/mm/pgtable.c
@@ -190,7 +190,7 @@ void pud_populate(struct mm_struct *mm,
 
 #endif	/* CONFIG_X86_PAE */
 
-static void free_pmds(pmd_t *pmds[])
+static void free_pmds(struct mm_struct *mm, pmd_t *pmds[])
 {
 	int i;
 
@@ -198,10 +198,11 @@ static void free_pmds(pmd_t *pmds[])
 		if (pmds[i]) {
 			pgtable_pmd_page_dtor(virt_to_page(pmds[i]));
 			free_page((unsigned long)pmds[i]);
+			mm_dec_nr_pmds(mm);
 		}
 }
 
-static int preallocate_pmds(pmd_t *pmds[])
+static int preallocate_pmds(struct mm_struct *mm, pmd_t *pmds[])
 {
 	int i;
 	bool failed = false;
@@ -215,11 +216,13 @@ static int preallocate_pmds(pmd_t *pmds[
 			pmd = NULL;
 			failed = true;
 		}
+		if (pmd)
+			mm_inc_nr_pmds(mm);
 		pmds[i] = pmd;
 	}
 
 	if (failed) {
-		free_pmds(pmds);
+		free_pmds(mm, pmds);
 		return -ENOMEM;
 	}
 
@@ -283,7 +286,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 
 	mm->pgd = pgd;
 
-	if (preallocate_pmds(pmds) != 0)
+	if (preallocate_pmds(mm, pmds) != 0)
 		goto out_free_pgd;
 
 	if (paravirt_pgd_alloc(mm) != 0)
@@ -304,7 +307,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	return pgd;
 
 out_free_pmds:
-	free_pmds(pmds);
+	free_pmds(mm, pmds);
 out_free_pgd:
 	free_page((unsigned long)pgd);
 out:
diff -puN fs/proc/task_mmu.c~mm-account-pmd-page-tables-to-the-process fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-account-pmd-page-tables-to-the-process
+++ a/fs/proc/task_mmu.c
@@ -21,7 +21,7 @@
 
 void task_mem(struct seq_file *m, struct mm_struct *mm)
 {
-	unsigned long data, text, lib, swap;
+	unsigned long data, text, lib, swap, ptes, pmds;
 	unsigned long hiwater_vm, total_vm, hiwater_rss, total_rss;
 
 	/*
@@ -42,6 +42,8 @@ void task_mem(struct seq_file *m, struct
 	text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK)) >> 10;
 	lib = (mm->exec_vm << (PAGE_SHIFT-10)) - text;
 	swap = get_mm_counter(mm, MM_SWAPENTS);
+	ptes = PTRS_PER_PTE * sizeof(pte_t) * atomic_long_read(&mm->nr_ptes);
+	pmds = PTRS_PER_PMD * sizeof(pmd_t) * mm_nr_pmds(mm);
 	seq_printf(m,
 		"VmPeak:\t%8lu kB\n"
 		"VmSize:\t%8lu kB\n"
@@ -54,6 +56,7 @@ void task_mem(struct seq_file *m, struct
 		"VmExe:\t%8lu kB\n"
 		"VmLib:\t%8lu kB\n"
 		"VmPTE:\t%8lu kB\n"
+		"VmPMD:\t%8lu kB\n"
 		"VmSwap:\t%8lu kB\n",
 		hiwater_vm << (PAGE_SHIFT-10),
 		total_vm << (PAGE_SHIFT-10),
@@ -63,8 +66,8 @@ void task_mem(struct seq_file *m, struct
 		total_rss << (PAGE_SHIFT-10),
 		data << (PAGE_SHIFT-10),
 		mm->stack_vm << (PAGE_SHIFT-10), text, lib,
-		(PTRS_PER_PTE * sizeof(pte_t) *
-		 atomic_long_read(&mm->nr_ptes)) >> 10,
+		ptes >> 10,
+		pmds >> 10,
 		swap << (PAGE_SHIFT-10));
 }
 
diff -puN include/linux/mm.h~mm-account-pmd-page-tables-to-the-process include/linux/mm.h
--- a/include/linux/mm.h~mm-account-pmd-page-tables-to-the-process
+++ a/include/linux/mm.h
@@ -1405,8 +1405,32 @@ static inline int __pmd_alloc(struct mm_
 {
 	return 0;
 }
+
+static inline unsigned long mm_nr_pmds(struct mm_struct *mm)
+{
+	return 0;
+}
+
+static inline void mm_inc_nr_pmds(struct mm_struct *mm) {}
+static inline void mm_dec_nr_pmds(struct mm_struct *mm) {}
+
 #else
 int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address);
+
+static inline unsigned long mm_nr_pmds(struct mm_struct *mm)
+{
+	return atomic_long_read(&mm->nr_pmds);
+}
+
+static inline void mm_inc_nr_pmds(struct mm_struct *mm)
+{
+	atomic_long_inc(&mm->nr_pmds);
+}
+
+static inline void mm_dec_nr_pmds(struct mm_struct *mm)
+{
+	atomic_long_dec(&mm->nr_pmds);
+}
 #endif
 
 int __pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
diff -puN include/linux/mm_types.h~mm-account-pmd-page-tables-to-the-process include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-account-pmd-page-tables-to-the-process
+++ a/include/linux/mm_types.h
@@ -363,7 +363,10 @@ struct mm_struct {
 	pgd_t * pgd;
 	atomic_t mm_users;			/* How many users with user space? */
 	atomic_t mm_count;			/* How many references to "struct mm_struct" (users count as 1) */
-	atomic_long_t nr_ptes;			/* Page table pages */
+	atomic_long_t nr_ptes;			/* PTE page table pages */
+#ifndef __PAGETABLE_PMD_FOLDED
+	atomic_long_t nr_pmds;			/* PMD page table pages */
+#endif
 	int map_count;				/* number of VMAs */
 
 	spinlock_t page_table_lock;		/* Protects page tables and some counters */
diff -puN kernel/fork.c~mm-account-pmd-page-tables-to-the-process kernel/fork.c
--- a/kernel/fork.c~mm-account-pmd-page-tables-to-the-process
+++ a/kernel/fork.c
@@ -555,6 +555,9 @@ static struct mm_struct *mm_init(struct
 	INIT_LIST_HEAD(&mm->mmlist);
 	mm->core_state = NULL;
 	atomic_long_set(&mm->nr_ptes, 0);
+#ifndef __PAGETABLE_PMD_FOLDED
+	atomic_long_set(&mm->nr_pmds, 0);
+#endif
 	mm->map_count = 0;
 	mm->locked_vm = 0;
 	mm->pinned_vm = 0;
diff -puN mm/debug.c~mm-account-pmd-page-tables-to-the-process mm/debug.c
--- a/mm/debug.c~mm-account-pmd-page-tables-to-the-process
+++ a/mm/debug.c
@@ -173,7 +173,7 @@ void dump_mm(const struct mm_struct *mm)
 		"get_unmapped_area %p\n"
 #endif
 		"mmap_base %lu mmap_legacy_base %lu highest_vm_end %lu\n"
-		"pgd %p mm_users %d mm_count %d nr_ptes %lu map_count %d\n"
+		"pgd %p mm_users %d mm_count %d nr_ptes %lu nr_pmds %lu map_count %d\n"
 		"hiwater_rss %lx hiwater_vm %lx total_vm %lx locked_vm %lx\n"
 		"pinned_vm %lx shared_vm %lx exec_vm %lx stack_vm %lx\n"
 		"start_code %lx end_code %lx start_data %lx end_data %lx\n"
@@ -206,6 +206,7 @@ void dump_mm(const struct mm_struct *mm)
 		mm->pgd, atomic_read(&mm->mm_users),
 		atomic_read(&mm->mm_count),
 		atomic_long_read((atomic_long_t *)&mm->nr_ptes),
+		mm_nr_pmds((struct mm_struct *)mm),
 		mm->map_count,
 		mm->hiwater_rss, mm->hiwater_vm, mm->total_vm, mm->locked_vm,
 		mm->pinned_vm, mm->shared_vm, mm->exec_vm, mm->stack_vm,
diff -puN mm/hugetlb.c~mm-account-pmd-page-tables-to-the-process mm/hugetlb.c
--- a/mm/hugetlb.c~mm-account-pmd-page-tables-to-the-process
+++ a/mm/hugetlb.c
@@ -3582,6 +3582,7 @@ pte_t *huge_pmd_share(struct mm_struct *
 		if (saddr) {
 			spte = huge_pte_offset(svma->vm_mm, saddr);
 			if (spte) {
+				mm_inc_nr_pmds(mm);
 				get_page(virt_to_page(spte));
 				break;
 			}
@@ -3593,11 +3594,13 @@ pte_t *huge_pmd_share(struct mm_struct *
 
 	ptl = huge_pte_lockptr(hstate_vma(vma), mm, spte);
 	spin_lock(ptl);
-	if (pud_none(*pud))
+	if (pud_none(*pud)) {
 		pud_populate(mm, pud,
 				(pmd_t *)((unsigned long)spte & PAGE_MASK));
-	else
+	} else {
 		put_page(virt_to_page(spte));
+		mm_inc_nr_pmds(mm);
+	}
 	spin_unlock(ptl);
 out:
 	pte = (pte_t *)pmd_alloc(mm, pud, addr);
@@ -3628,6 +3631,7 @@ int huge_pmd_unshare(struct mm_struct *m
 
 	pud_clear(pud);
 	put_page(virt_to_page(ptep));
+	mm_dec_nr_pmds(mm);
 	*addr = ALIGN(*addr, HPAGE_SIZE * PTRS_PER_PTE) - HPAGE_SIZE;
 	return 1;
 }
diff -puN mm/memory.c~mm-account-pmd-page-tables-to-the-process mm/memory.c
--- a/mm/memory.c~mm-account-pmd-page-tables-to-the-process
+++ a/mm/memory.c
@@ -428,6 +428,7 @@ static inline void free_pmd_range(struct
 	pmd = pmd_offset(pud, start);
 	pud_clear(pud);
 	pmd_free_tlb(tlb, pmd, start);
+	mm_dec_nr_pmds(tlb->mm);
 }
 
 static inline void free_pud_range(struct mmu_gather *tlb, pgd_t *pgd,
@@ -3347,6 +3348,7 @@ int __pmd_alloc(struct mm_struct *mm, pu
 	smp_wmb(); /* See comment in __pte_alloc */
 
 	spin_lock(&mm->page_table_lock);
+	mm_inc_nr_pmds(mm);
 #ifndef __ARCH_HAS_4LEVEL_HACK
 	if (pud_present(*pud))		/* Another has populated it */
 		pmd_free(mm, new);
diff -puN mm/mmap.c~mm-account-pmd-page-tables-to-the-process mm/mmap.c
--- a/mm/mmap.c~mm-account-pmd-page-tables-to-the-process
+++ a/mm/mmap.c
@@ -2853,7 +2853,9 @@ void exit_mmap(struct mm_struct *mm)
 	vm_unacct_memory(nr_accounted);
 
 	WARN_ON(atomic_long_read(&mm->nr_ptes) >
-			(FIRST_USER_ADDRESS+PMD_SIZE-1)>>PMD_SHIFT);
+			round_up(FIRST_USER_ADDRESS, PMD_SIZE) >> PMD_SHIFT);
+	WARN_ON(mm_nr_pmds(mm) >
+			round_up(FIRST_USER_ADDRESS, PUD_SIZE) >> PUD_SHIFT);
 }
 
 /* Insert vm structure into process list sorted by address
diff -puN mm/oom_kill.c~mm-account-pmd-page-tables-to-the-process mm/oom_kill.c
--- a/mm/oom_kill.c~mm-account-pmd-page-tables-to-the-process
+++ a/mm/oom_kill.c
@@ -169,8 +169,8 @@ unsigned long oom_badness(struct task_st
 	 * The baseline for the badness score is the proportion of RAM that each
 	 * task's rss, pagetable and swap space use.
 	 */
-	points = get_mm_rss(p->mm) + atomic_long_read(&p->mm->nr_ptes) +
-		 get_mm_counter(p->mm, MM_SWAPENTS);
+	points = get_mm_rss(p->mm) + get_mm_counter(p->mm, MM_SWAPENTS) +
+		atomic_long_read(&p->mm->nr_ptes) + mm_nr_pmds(p->mm);
 	task_unlock(p);
 
 	/*
@@ -351,7 +351,7 @@ static void dump_tasks(struct mem_cgroup
 	struct task_struct *p;
 	struct task_struct *task;
 
-	pr_info("[ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name\n");
+	pr_info("[ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name\n");
 	rcu_read_lock();
 	for_each_process(p) {
 		if (oom_unkillable_task(p, memcg, nodemask))
@@ -367,10 +367,11 @@ static void dump_tasks(struct mem_cgroup
 			continue;
 		}
 
-		pr_info("[%5d] %5d %5d %8lu %8lu %7ld %8lu         %5hd %s\n",
+		pr_info("[%5d] %5d %5d %8lu %8lu %7ld %7ld %8lu         %5hd %s\n",
 			task->pid, from_kuid(&init_user_ns, task_uid(task)),
 			task->tgid, task->mm->total_vm, get_mm_rss(task->mm),
 			atomic_long_read(&task->mm->nr_ptes),
+			mm_nr_pmds(task->mm),
 			get_mm_counter(task->mm, MM_SWAPENTS),
 			task->signal->oom_score_adj, task->comm);
 		task_unlock(task);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

axonram-fix-bug-in-direct_access.patch
block-change-direct_access-calling-convention.patch
mm-fix-xip-fault-vs-truncate-race.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
vfsext2-introduce-is_daxinode.patch
daxext2-replace-xip-read-and-write-with-dax-i-o.patch
daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-xip_truncate_page-with-dax_truncate_page.patch
dax-replace-xip-documentation-with-dax-documentation.patch
vfs-remove-get_xip_mem.patch
ext2-remove-ext2_xip_verify_sb.patch
ext2-remove-ext2_use_xip.patch
ext2-remove-xipc-and-xiph.patch
vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax.patch
ext2-remove-ext2_aops_xip.patch
ext2-get-rid-of-most-mentions-of-xip-in-ext2.patch
dax-add-dax_zero_page_range.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality.patch
brd-rename-xip-to-dax.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath.patch
mm-drop-support-of-non-linear-mapping-from-fault-codepath.patch
mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub.patch
proc-drop-handling-non-linear-mappings.patch
rmap-drop-support-of-non-linear-mappings.patch
mm-replace-vma-shareadlinear-with-vma-shared.patch
mm-remove-rest-usage-of-vm_nonlinear-and-pte_file.patch
asm-generic-drop-unused-pte_file-helpers.patch
alpha-drop-_page_file-and-pte_file-related-helpers.patch
arc-drop-_page_file-and-pte_file-related-helpers.patch
arc-drop-_page_file-and-pte_file-related-helpers-fix.patch
arm64-drop-pte_file-and-pte_file-related-helpers.patch
arm-drop-l_pte_file-and-pte_file-related-helpers.patch
avr32-drop-_page_file-and-pte_file-related-helpers.patch
blackfin-drop-pte_file.patch
c6x-drop-pte_file.patch
cris-drop-_page_file-and-pte_file-related-helpers.patch
frv-drop-_page_file-and-pte_file-related-helpers.patch
hexagon-drop-_page_file-and-pte_file-related-helpers.patch
ia64-drop-_page_file-and-pte_file-related-helpers.patch
m32r-drop-_page_file-and-pte_file-related-helpers.patch
m68k-drop-_page_file-and-pte_file-related-helpers.patch
metag-drop-_page_file-and-pte_file-related-helpers.patch
microblaze-drop-_page_file-and-pte_file-related-helpers.patch
mips-drop-_page_file-and-pte_file-related-helpers.patch
mn10300-drop-_page_file-and-pte_file-related-helpers.patch
nios2-drop-_page_file-and-pte_file-related-helpers.patch
openrisc-drop-_page_file-and-pte_file-related-helpers.patch
parisc-drop-_page_file-and-pte_file-related-helpers.patch
powerpc-drop-_page_file-and-pte_file-related-helpers.patch
s390-drop-pte_file-related-helpers.patch
score-drop-_page_file-and-pte_file-related-helpers.patch
sh-drop-_page_file-and-pte_file-related-helpers.patch
sparc-drop-pte_file-related-helpers.patch
tile-drop-pte_file-related-helpers.patch
um-drop-_page_file-and-pte_file-related-helpers.patch
unicore32-drop-pte_file-related-helpers.patch
x86-drop-_page_file-and-pte_file-related-helpers.patch
xtensa-drop-_page_file-and-pte_file-related-helpers.patch
mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch
mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
mm-add-vm_bug_on_page-for-page_mapcount.patch
mm-numa-do-not-dereference-pmd-outside-of-the-lock-during-numa-hinting-fault.patch
mm-add-p-protnone-helpers-for-use-by-numa-balancing.patch
mm-convert-p_numa-users-to-p_protnone_numa.patch
ppc64-add-paranoid-warnings-for-unexpected-dsisr_protfault.patch
mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch
mm-remove-remaining-references-to-numa-hinting-bits-and-helpers.patch
mm-numa-do-not-trap-faults-on-the-huge-zero-page.patch
x86-mm-restore-original-pte_special-check.patch
mm-numa-add-paranoid-check-around-pte_protnone_numa.patch
mm-numa-avoid-unnecessary-tlb-flushes-when-setting-numa-hinting-entries.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
mm-page_allocc-drop-dead-destroy_compound_page.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages-fix-2.patch
mm-account-pmd-page-tables-to-the-process.patch

