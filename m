From: akpm@linux-foundation.org
Subject: + mm-convert-mm-nr_ptes-to-atomic_long_t.patch added to -mm tree
Date: Mon, 07 Oct 2013 16:10:06 -0700
Message-ID: <52533f4e./rhsExR+LqG2n8gt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34898 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab3JGXKH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Oct 2013 19:10:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tglx@linutronix.de, srikar@linux.vnet.ibm.com, sedat.dilek@gmail.com, robinmholt@gmail.com, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, n-horiguchi@ah.jp.nec.com, mtk.manpages@gmail.com, mingo@redhat.com, mgorman@suse.de, keescook@chromium.org, hughd@google.com, hannes@cmpxchg.org, fweisbec@gmail.com, ebiederm@xmission.com, dhowells@redhat.com, davej@redhat.com, dave.hansen@intel.com, athorlton@sgi.com, ak@linux.intel.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com

Subject: + mm-convert-mm-nr_ptes-to-atomic_long_t.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,aarcange@redhat.com,ak@linux.intel.com,athorlton@sgi.com,dave.hansen@intel.com,davej@redhat.com,dhowells@redhat.com,ebiederm@xmission.com,fweisbec@gmail.com,hannes@cmpxchg.org,hughd@google.com,keescook@chromium.org,mgorman@suse.de,mingo@redhat.com,mtk.manpages@gmail.com,n-horiguchi@ah.jp.nec.com,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,robinmholt@gmail.com,sedat.dilek@gmail.com,srikar@linux.vnet.ibm.com,tglx@linutronix.de,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Mon, 07 Oct 2013 16:10:05 -0700


The patch titled
     Subject: mm: convert mm->nr_ptes to atomic_long_t
has been added to the -mm tree.  Its filename is
     mm-convert-mm-nr_ptes-to-atomic_long_t.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-convert-mm-nr_ptes-to-atomic_long_t.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-convert-mm-nr_ptes-to-atomic_long_t.patch

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
Subject: mm: convert mm->nr_ptes to atomic_long_t

With split page table lock for PMD level we can't hold mm->page_table_lock
while updating nr_ptes.

Let's convert it to atomic_long_t to avoid races.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Alex Thorlton <athorlton@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Jones <davej@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Robin Holt <robinmholt@gmail.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c       |    3 ++-
 include/linux/mm_types.h |    2 +-
 kernel/fork.c            |    2 +-
 mm/huge_memory.c         |   10 +++++-----
 mm/memory.c              |    4 ++--
 mm/mmap.c                |    3 ++-
 mm/oom_kill.c            |    6 +++---
 7 files changed, 16 insertions(+), 14 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-convert-mm-nr_ptes-to-atomic_long_t fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-convert-mm-nr_ptes-to-atomic_long_t
+++ a/fs/proc/task_mmu.c
@@ -62,7 +62,8 @@ void task_mem(struct seq_file *m, struct
 		total_rss << (PAGE_SHIFT-10),
 		data << (PAGE_SHIFT-10),
 		mm->stack_vm << (PAGE_SHIFT-10), text, lib,
-		(PTRS_PER_PTE*sizeof(pte_t)*mm->nr_ptes) >> 10,
+		(PTRS_PER_PTE * sizeof(pte_t) *
+		 atomic_long_read(&mm->nr_ptes)) >> 10,
 		swap << (PAGE_SHIFT-10));
 }
 
diff -puN include/linux/mm_types.h~mm-convert-mm-nr_ptes-to-atomic_long_t include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-convert-mm-nr_ptes-to-atomic_long_t
+++ a/include/linux/mm_types.h
@@ -339,6 +339,7 @@ struct mm_struct {
 	pgd_t * pgd;
 	atomic_t mm_users;			/* How many users with user space? */
 	atomic_t mm_count;			/* How many references to "struct mm_struct" (users count as 1) */
+	atomic_long_t nr_ptes;			/* Page table pages */
 	int map_count;				/* number of VMAs */
 
 	spinlock_t page_table_lock;		/* Protects page tables and some counters */
@@ -360,7 +361,6 @@ struct mm_struct {
 	unsigned long exec_vm;		/* VM_EXEC & ~VM_WRITE */
 	unsigned long stack_vm;		/* VM_GROWSUP/DOWN */
 	unsigned long def_flags;
-	unsigned long nr_ptes;		/* Page table pages */
 	unsigned long start_code, end_code, start_data, end_data;
 	unsigned long start_brk, brk, start_stack;
 	unsigned long arg_start, arg_end, env_start, env_end;
diff -puN kernel/fork.c~mm-convert-mm-nr_ptes-to-atomic_long_t kernel/fork.c
--- a/kernel/fork.c~mm-convert-mm-nr_ptes-to-atomic_long_t
+++ a/kernel/fork.c
@@ -532,7 +532,7 @@ static struct mm_struct *mm_init(struct
 	mm->flags = (current->mm) ?
 		(current->mm->flags & MMF_INIT_MASK) : default_dump_filter;
 	mm->core_state = NULL;
-	mm->nr_ptes = 0;
+	atomic_long_set(&mm->nr_ptes, 0);
 	memset(&mm->rss_stat, 0, sizeof(mm->rss_stat));
 	spin_lock_init(&mm->page_table_lock);
 	mm_init_aio(mm);
diff -puN mm/huge_memory.c~mm-convert-mm-nr_ptes-to-atomic_long_t mm/huge_memory.c
--- a/mm/huge_memory.c~mm-convert-mm-nr_ptes-to-atomic_long_t
+++ a/mm/huge_memory.c
@@ -738,7 +738,7 @@ static int __do_huge_pmd_anonymous_page(
 		pgtable_trans_huge_deposit(mm, pmd, pgtable);
 		set_pmd_at(mm, haddr, pmd, entry);
 		add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR);
-		mm->nr_ptes++;
+		atomic_long_inc(&mm->nr_ptes);
 		spin_unlock(&mm->page_table_lock);
 	}
 
@@ -771,7 +771,7 @@ static bool set_huge_zero_page(pgtable_t
 	entry = pmd_mkhuge(entry);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, haddr, pmd, entry);
-	mm->nr_ptes++;
+	atomic_long_inc(&mm->nr_ptes);
 	return true;
 }
 
@@ -896,7 +896,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 	pmd = pmd_mkold(pmd_wrprotect(pmd));
 	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
-	dst_mm->nr_ptes++;
+	atomic_long_inc(&dst_mm->nr_ptes);
 
 	ret = 0;
 out_unlock:
@@ -1351,7 +1351,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 		pgtable = pgtable_trans_huge_withdraw(tlb->mm, pmd);
 		if (is_huge_zero_pmd(orig_pmd)) {
-			tlb->mm->nr_ptes--;
+			atomic_long_dec(&tlb->mm->nr_ptes);
 			spin_unlock(&tlb->mm->page_table_lock);
 			put_huge_zero_page();
 		} else {
@@ -1360,7 +1360,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 			VM_BUG_ON(page_mapcount(page) < 0);
 			add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
 			VM_BUG_ON(!PageHead(page));
-			tlb->mm->nr_ptes--;
+			atomic_long_dec(&tlb->mm->nr_ptes);
 			spin_unlock(&tlb->mm->page_table_lock);
 			tlb_remove_page(tlb, page);
 		}
diff -puN mm/memory.c~mm-convert-mm-nr_ptes-to-atomic_long_t mm/memory.c
--- a/mm/memory.c~mm-convert-mm-nr_ptes-to-atomic_long_t
+++ a/mm/memory.c
@@ -382,7 +382,7 @@ static void free_pte_range(struct mmu_ga
 	pgtable_t token = pmd_pgtable(*pmd);
 	pmd_clear(pmd);
 	pte_free_tlb(tlb, token, addr);
-	tlb->mm->nr_ptes--;
+	atomic_long_dec(&tlb->mm->nr_ptes);
 }
 
 static inline void free_pmd_range(struct mmu_gather *tlb, pud_t *pud,
@@ -573,7 +573,7 @@ int __pte_alloc(struct mm_struct *mm, st
 	spin_lock(&mm->page_table_lock);
 	wait_split_huge_page = 0;
 	if (likely(pmd_none(*pmd))) {	/* Has another populated it ? */
-		mm->nr_ptes++;
+		atomic_long_inc(&mm->nr_ptes);
 		pmd_populate(mm, pmd, new);
 		new = NULL;
 	} else if (unlikely(pmd_trans_splitting(*pmd)))
diff -puN mm/mmap.c~mm-convert-mm-nr_ptes-to-atomic_long_t mm/mmap.c
--- a/mm/mmap.c~mm-convert-mm-nr_ptes-to-atomic_long_t
+++ a/mm/mmap.c
@@ -2726,7 +2726,8 @@ void exit_mmap(struct mm_struct *mm)
 	}
 	vm_unacct_memory(nr_accounted);
 
-	WARN_ON(mm->nr_ptes > (FIRST_USER_ADDRESS+PMD_SIZE-1)>>PMD_SHIFT);
+	WARN_ON(atomic_long_read(&mm->nr_ptes) >
+			(FIRST_USER_ADDRESS+PMD_SIZE-1)>>PMD_SHIFT);
 }
 
 /* Insert vm structure into process list sorted by address
diff -puN mm/oom_kill.c~mm-convert-mm-nr_ptes-to-atomic_long_t mm/oom_kill.c
--- a/mm/oom_kill.c~mm-convert-mm-nr_ptes-to-atomic_long_t
+++ a/mm/oom_kill.c
@@ -161,7 +161,7 @@ unsigned long oom_badness(struct task_st
 	 * The baseline for the badness score is the proportion of RAM that each
 	 * task's rss, pagetable and swap space use.
 	 */
-	points = get_mm_rss(p->mm) + p->mm->nr_ptes +
+	points = get_mm_rss(p->mm) + atomic_long_read(&p->mm->nr_ptes) +
 		 get_mm_counter(p->mm, MM_SWAPENTS);
 	task_unlock(p);
 
@@ -364,10 +364,10 @@ static void dump_tasks(const struct mem_
 			continue;
 		}
 
-		pr_info("[%5d] %5d %5d %8lu %8lu %7lu %8lu         %5hd %s\n",
+		pr_info("[%5d] %5d %5d %8lu %8lu %7ld %8lu         %5hd %s\n",
 			task->pid, from_kuid(&init_user_ns, task_uid(task)),
 			task->tgid, task->mm->total_vm, get_mm_rss(task->mm),
-			task->mm->nr_ptes,
+			atomic_long_read(&task->mm->nr_ptes),
 			get_mm_counter(task->mm, MM_SWAPENTS),
 			task->signal->oom_score_adj, task->comm);
 		task_unlock(task);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-huge_memoryc-fix-stale-comments-of-transparent_hugepage_flags.patch
mm-thp-cleanup-mv-alloc_hugepage-to-better-place.patch
mm-thp-khugepaged-add-policy-for-finding-target-node.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
mm-avoid-increase-sizeofstruct-page-due-to-split-page-table-lock.patch
mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
mm-convert-mm-nr_ptes-to-atomic_long_t.patch
mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch
mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch
mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch
thp-mm-locking-tail-page-is-a-bug.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

