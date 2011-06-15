From: akpm@linux-foundation.org
Subject: + kernel-forkc-fix-a-few-coding-style-issues.patch added to -mm tree
Date: Tue, 14 Jun 2011 18:27:30 -0700
Message-ID: <201106150124.p5F1Ol18032011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753508Ab1FOBfg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jun 2011 21:35:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: psykon@gmail.com


The patch titled
     kernel/fork.c: fix a few coding style issues
has been added to the -mm tree.  Its filename is
     kernel-forkc-fix-a-few-coding-style-issues.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/fork.c: fix a few coding style issues
From: Daniel Rebelo de Oliveira <psykon@gmail.com>

Signed-off-by: Daniel Rebelo de Oliveira <psykon@gmail.com>
Signed-off-by: Andrew Morton <>
---

 kernel/fork.c |   78 +++++++++++++++++++++++++++---------------------
 1 file changed, 44 insertions(+), 34 deletions(-)

diff -puN kernel/fork.c~kernel-forkc-fix-a-few-coding-style-issues kernel/fork.c
--- a/kernel/fork.c~kernel-forkc-fix-a-few-coding-style-issues
+++ a/kernel/fork.c
@@ -81,7 +81,7 @@
  * Protected counters by write_lock_irq(&tasklist_lock)
  */
 unsigned long total_forks;	/* Handle normal Linux uptimes. */
-int nr_threads; 		/* The idle threads do not count.. */
+int nr_threads;			/* The idle threads do not count.. */
 
 int max_threads;		/* tunable limit on nr_threads */
 
@@ -233,7 +233,7 @@ void __init fork_init(unsigned long memp
 	/*
 	 * we need to allow at least 20 threads to boot a system
 	 */
-	if(max_threads < 20)
+	if (max_threads < 20)
 		max_threads = 20;
 
 	init_task.signal->rlim[RLIMIT_NPROC].rlim_cur = max_threads/2;
@@ -269,7 +269,7 @@ static struct task_struct *dup_task_stru
 		return NULL;
 	}
 
- 	err = arch_dup_task_struct(tsk, orig);
+	err = arch_dup_task_struct(tsk, orig);
 	if (err)
 		goto out;
 
@@ -290,7 +290,7 @@ static struct task_struct *dup_task_stru
 #endif
 
 	/* One for us, one for whoever does the "release_task()" (usually parent) */
-	atomic_set(&tsk->usage,2);
+	atomic_set(&tsk->usage, 2);
 	atomic_set(&tsk->fs_excl, 0);
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	tsk->btrace_seq = 0;
@@ -439,7 +439,7 @@ fail_nomem:
 	goto out;
 }
 
-static inline int mm_alloc_pgd(struct mm_struct * mm)
+static inline int mm_alloc_pgd(struct mm_struct *mm)
 {
 	mm->pgd = pgd_alloc(mm);
 	if (unlikely(!mm->pgd))
@@ -447,7 +447,7 @@ static inline int mm_alloc_pgd(struct mm
 	return 0;
 }
 
-static inline void mm_free_pgd(struct mm_struct * mm)
+static inline void mm_free_pgd(struct mm_struct *mm)
 {
 	pgd_free(mm, mm->pgd);
 }
@@ -484,7 +484,7 @@ static void mm_init_aio(struct mm_struct
 #endif
 }
 
-static struct mm_struct * mm_init(struct mm_struct * mm, struct task_struct *p)
+static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
 {
 	atomic_set(&mm->mm_users, 1);
 	atomic_set(&mm->mm_count, 1);
@@ -515,9 +515,9 @@ static struct mm_struct * mm_init(struct
 /*
  * Allocate and initialize an mm_struct.
  */
-struct mm_struct * mm_alloc(void)
+struct mm_struct *mm_alloc(void)
 {
-	struct mm_struct * mm;
+	struct mm_struct *mm;
 
 	mm = allocate_mm();
 	if (!mm)
@@ -585,7 +585,7 @@ void added_exe_file_vma(struct mm_struct
 void removed_exe_file_vma(struct mm_struct *mm)
 {
 	mm->num_exe_file_vmas--;
-	if ((mm->num_exe_file_vmas == 0) && mm->exe_file){
+	if ((mm->num_exe_file_vmas == 0) && mm->exe_file) {
 		fput(mm->exe_file);
 		mm->exe_file = NULL;
 	}
@@ -777,9 +777,9 @@ fail_nocontext:
 	return NULL;
 }
 
-static int copy_mm(unsigned long clone_flags, struct task_struct * tsk)
+static int copy_mm(unsigned long clone_flags, struct task_struct *tsk)
 {
-	struct mm_struct * mm, *oldmm;
+	struct mm_struct *mm, *oldmm;
 	int retval;
 
 	tsk->min_flt = tsk->maj_flt = 0;
@@ -846,7 +846,7 @@ static int copy_fs(unsigned long clone_f
 	return 0;
 }
 
-static int copy_files(unsigned long clone_flags, struct task_struct * tsk)
+static int copy_files(unsigned long clone_flags, struct task_struct *tsk)
 {
 	struct files_struct *oldf, *newf;
 	int error = 0;
@@ -1168,11 +1168,11 @@ static struct task_struct *copy_process(
 	cgroup_fork(p);
 #ifdef CONFIG_NUMA
 	p->mempolicy = mpol_dup(p->mempolicy);
- 	if (IS_ERR(p->mempolicy)) {
- 		retval = PTR_ERR(p->mempolicy);
- 		p->mempolicy = NULL;
- 		goto bad_fork_cleanup_cgroup;
- 	}
+	if (IS_ERR(p->mempolicy)) {
+		retval = PTR_ERR(p->mempolicy);
+		p->mempolicy = NULL;
+		goto bad_fork_cleanup_cgroup;
+	}
 	mpol_fix_fork_child_flag(p);
 #endif
 #ifdef CONFIG_CPUSETS
@@ -1218,25 +1218,33 @@ static struct task_struct *copy_process(
 	retval = perf_event_init_task(p);
 	if (retval)
 		goto bad_fork_cleanup_policy;
-
-	if ((retval = audit_alloc(p)))
+	retval = audit_alloc(p);
+	if (retval)
 		goto bad_fork_cleanup_policy;
 	/* copy all the process information */
-	if ((retval = copy_semundo(clone_flags, p)))
+	retval = copy_semundo(clone_flags, p);
+	if (retval)
 		goto bad_fork_cleanup_audit;
-	if ((retval = copy_files(clone_flags, p)))
+	retval = copy_files(clone_flags, p);
+	if (retval)
 		goto bad_fork_cleanup_semundo;
-	if ((retval = copy_fs(clone_flags, p)))
+	retval = copy_fs(clone_flags, p);
+	if (retval)
 		goto bad_fork_cleanup_files;
-	if ((retval = copy_sighand(clone_flags, p)))
+	retval = copy_sighand(clone_flags, p);
+	if (retval)
 		goto bad_fork_cleanup_fs;
-	if ((retval = copy_signal(clone_flags, p)))
+	retval = copy_signal(clone_flags, p);
+	if (retval)
 		goto bad_fork_cleanup_sighand;
-	if ((retval = copy_mm(clone_flags, p)))
+	retval = copy_mm(clone_flags, p);
+	if (retval)
 		goto bad_fork_cleanup_signal;
-	if ((retval = copy_namespaces(clone_flags, p)))
+	retval = copy_namespaces(clone_flags, p);
+	if (retval)
 		goto bad_fork_cleanup_mm;
-	if ((retval = copy_io(clone_flags, p)))
+	retval = copy_io(clone_flags, p);
+	if (retval)
 		goto bad_fork_cleanup_namespaces;
 	retval = copy_thread(clone_flags, stack_start, stack_size, p, regs);
 	if (retval)
@@ -1258,7 +1266,7 @@ static struct task_struct *copy_process(
 	/*
 	 * Clear TID on mm_release()?
 	 */
-	p->clear_child_tid = (clone_flags & CLONE_CHILD_CLEARTID) ? child_tidptr: NULL;
+	p->clear_child_tid = (clone_flags & CLONE_CHILD_CLEARTID) ? child_tidptr : NULL;
 #ifdef CONFIG_BLOCK
 	p->plug = NULL;
 #endif
@@ -1326,7 +1334,7 @@ static struct task_struct *copy_process(
 	 * it's process group.
 	 * A fatal signal pending means that current will exit, so the new
 	 * thread can't slip out of an OOM kill (or normal SIGKILL).
- 	 */
+	*/
 	recalc_sigpending();
 	if (signal_pending(current)) {
 		spin_unlock(&current->sighand->siglock);
@@ -1674,12 +1682,14 @@ SYSCALL_DEFINE1(unshare, unsigned long, 
 	 */
 	if (unshare_flags & (CLONE_NEWIPC|CLONE_SYSVSEM))
 		do_sysvsem = 1;
-	if ((err = unshare_fs(unshare_flags, &new_fs)))
+	err = unshare_fs(unshare_flags, &new_fs);
+	if (err)
 		goto bad_unshare_out;
-	if ((err = unshare_fd(unshare_flags, &new_fd)))
+	err = unshare_fd(unshare_flags, &new_fd);
+	if (err)
 		goto bad_unshare_cleanup_fs;
-	if ((err = unshare_nsproxy_namespaces(unshare_flags, &new_nsproxy,
-			new_fs)))
+	err = unshare_nsproxy_namespaces(unshare_flags, &new_nsproxy, new_fs);
+	if (err)
 		goto bad_unshare_cleanup_fd;
 
 	if (new_fs || new_fd || do_sysvsem || new_nsproxy) {
_

Patches currently in -mm which might be from psykon@gmail.com are

kernel-forkc-fix-a-few-coding-style-issues.patch

