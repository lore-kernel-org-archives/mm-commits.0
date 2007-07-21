From: akpm@linux-foundation.org
Subject: + whitespace-fixes-fork.patch added to -mm tree
Date: Fri, 20 Jul 2007 17:18:48 -0700
Message-ID: <200707210018.l6L0ImNL023867@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52484 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759517AbXGUAUQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 20:20:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com


The patch titled
     whitespace fixes: fork
has been added to the -mm tree.  Its filename is
     whitespace-fixes-fork.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: whitespace fixes: fork
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff -puN kernel/fork.c~whitespace-fixes-fork kernel/fork.c
--- a/kernel/fork.c~whitespace-fixes-fork
+++ a/kernel/fork.c
@@ -258,7 +258,7 @@ static inline int dup_mmap(struct mm_str
 			get_file(file);
 			if (tmp->vm_flags & VM_DENYWRITE)
 				atomic_dec(&inode->i_writecount);
-      
+
 			/* insert tmp into the share list, just after mpnt */
 			spin_lock(&file->f_mapping->i_mmap_lock);
 			tmp->vm_truncate_count = mpnt->vm_truncate_count;
@@ -321,7 +321,7 @@ static inline void mm_free_pgd(struct mm
 #define mm_free_pgd(mm)
 #endif /* CONFIG_MMU */
 
- __cacheline_aligned_in_smp DEFINE_SPINLOCK(mmlist_lock);
+__cacheline_aligned_in_smp DEFINE_SPINLOCK(mmlist_lock);
 
 #define allocate_mm()	(kmem_cache_alloc(mm_cachep, GFP_KERNEL))
 #define free_mm(mm)	(kmem_cache_free(mm_cachep, (mm)))
@@ -728,8 +728,8 @@ static struct files_struct *dup_fd(struc
 	/* compute the remainder to be cleared */
 	size = (new_fdt->max_fds - open_files) * sizeof(struct file *);
 
-	/* This is long word aligned thus could use a optimized version */ 
-	memset(new_fds, 0, size); 
+	/* This is long word aligned thus could use a optimized version */
+	memset(new_fds, 0, size);
 
 	if (new_fdt->max_fds > open_files) {
 		int left = (new_fdt->max_fds-open_files)/8;
@@ -1057,12 +1057,12 @@ static struct task_struct *copy_process(
 	task_io_accounting_init(p);
 	acct_clear_integrals(p);
 
- 	p->it_virt_expires = cputime_zero;
+	p->it_virt_expires = cputime_zero;
 	p->it_prof_expires = cputime_zero;
- 	p->it_sched_expires = 0;
- 	INIT_LIST_HEAD(&p->cpu_timers[0]);
- 	INIT_LIST_HEAD(&p->cpu_timers[1]);
- 	INIT_LIST_HEAD(&p->cpu_timers[2]);
+	p->it_sched_expires = 0;
+	INIT_LIST_HEAD(&p->cpu_timers[0]);
+	INIT_LIST_HEAD(&p->cpu_timers[1]);
+	INIT_LIST_HEAD(&p->cpu_timers[2]);
 
 	p->lock_depth = -1;		/* -1 = no lock */
 	do_posix_clock_monotonic_gettime(&p->start_time);
@@ -1231,7 +1231,7 @@ static struct task_struct *copy_process(
 	 * A fatal signal pending means that current will exit, so the new
 	 * thread can't slip out of an OOM kill (or normal SIGKILL).
  	 */
- 	recalc_sigpending();
+	recalc_sigpending();
 	if (signal_pending(current)) {
 		spin_unlock(&current->sighand->siglock);
 		write_unlock_irq(&tasklist_lock);
_

Patches currently in -mm which might be from dwalker@mvista.com are

whitespace-fixes-time-syscalls.patch
whitespace-fixes-process-accounting.patch
whitespace-fixes-cpuset.patch
whitespace-fixes-relayfs.patch
whitespace-fixes-audit-filtering.patch
whitespace-fixes-dma-channel-allocator.patch
whitespace-fixes-fork.patch
whitespace-fixes-module-loading.patch
whitespace-fixes-panic-handling.patch
whitespace-fixes-capability-syscalls.patch
whitespace-fixes-syscall-auditing.patch
whitespace-fixes-compat-syscalls.patch
whitespace-fixes-system-auditing.patch
whitespace-fixes-execution-domains.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch
