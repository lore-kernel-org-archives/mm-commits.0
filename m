From: akpm@linux-foundation.org
Subject: - uninline-forkc-exitc.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:54:35 -0700
Message-ID: <200710192254.l9JMsZkW024545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60874 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966804AbXJSXGi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, arjan@infradead.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Uninline fork.c/exit.c
has been removed from the -mm tree.  Its filename was
     uninline-forkc-exitc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Uninline fork.c/exit.c
From: Alexey Dobriyan <adobriyan@sw.ru>

Save ~650 bytes here.

add/remove: 4/0 grow/shrink: 0/7 up/down: 430/-1088 (-658)
function                                     old     new   delta
__copy_fs_struct                               -     202    +202
__put_fs_struct                                -     112    +112
__exit_fs                                      -      58     +58
__exit_files                                   -      58     +58
exit_files                                    58       2     -56
put_fs_struct                                112       5    -107
exit_fs                                      161       2    -159
sys_unshare                                  774     590    -184
copy_process                                4031    3840    -191
do_exit                                     1791    1597    -194
copy_fs_struct                               202       5    -197

No difference in lmbench lat_proc tests on 2-way Opteron 246.
Smaaaal degradation on UP P4 (within errors).

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    6 +++---
 kernel/fork.c |   20 ++++++++++----------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff -puN kernel/exit.c~uninline-forkc-exitc kernel/exit.c
--- a/kernel/exit.c~uninline-forkc-exitc
+++ a/kernel/exit.c
@@ -493,7 +493,7 @@ void reset_files_struct(struct task_stru
 }
 EXPORT_SYMBOL(reset_files_struct);
 
-static inline void __exit_files(struct task_struct *tsk)
+static void __exit_files(struct task_struct *tsk)
 {
 	struct files_struct * files = tsk->files;
 
@@ -510,7 +510,7 @@ void exit_files(struct task_struct *tsk)
 	__exit_files(tsk);
 }
 
-static inline void __put_fs_struct(struct fs_struct *fs)
+static void __put_fs_struct(struct fs_struct *fs)
 {
 	/* No need to hold fs->lock if we are killing it */
 	if (atomic_dec_and_test(&fs->count)) {
@@ -531,7 +531,7 @@ void put_fs_struct(struct fs_struct *fs)
 	__put_fs_struct(fs);
 }
 
-static inline void __exit_fs(struct task_struct *tsk)
+static void __exit_fs(struct task_struct *tsk)
 {
 	struct fs_struct * fs = tsk->fs;
 
diff -puN kernel/fork.c~uninline-forkc-exitc kernel/fork.c
--- a/kernel/fork.c~uninline-forkc-exitc
+++ a/kernel/fork.c
@@ -206,7 +206,7 @@ static struct task_struct *dup_task_stru
 }
 
 #ifdef CONFIG_MMU
-static inline int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
+static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 {
 	struct vm_area_struct *mpnt, *tmp, **pprev;
 	struct rb_node **rb_link, *rb_parent;
@@ -584,7 +584,7 @@ fail_nomem:
 	return retval;
 }
 
-static inline struct fs_struct *__copy_fs_struct(struct fs_struct *old)
+static struct fs_struct *__copy_fs_struct(struct fs_struct *old)
 {
 	struct fs_struct *fs = kmem_cache_alloc(fs_cachep, GFP_KERNEL);
 	/* We don't need to lock fs - think why ;-) */
@@ -616,7 +616,7 @@ struct fs_struct *copy_fs_struct(struct 
 
 EXPORT_SYMBOL_GPL(copy_fs_struct);
 
-static inline int copy_fs(unsigned long clone_flags, struct task_struct * tsk)
+static int copy_fs(unsigned long clone_flags, struct task_struct *tsk)
 {
 	if (clone_flags & CLONE_FS) {
 		atomic_inc(&current->fs->count);
@@ -819,7 +819,7 @@ int unshare_files(void)
 
 EXPORT_SYMBOL(unshare_files);
 
-static inline int copy_sighand(unsigned long clone_flags, struct task_struct * tsk)
+static int copy_sighand(unsigned long clone_flags, struct task_struct *tsk)
 {
 	struct sighand_struct *sig;
 
@@ -842,7 +842,7 @@ void __cleanup_sighand(struct sighand_st
 		kmem_cache_free(sighand_cachep, sighand);
 }
 
-static inline int copy_signal(unsigned long clone_flags, struct task_struct * tsk)
+static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 {
 	struct signal_struct *sig;
 	int ret;
@@ -924,7 +924,7 @@ void __cleanup_signal(struct signal_stru
 	kmem_cache_free(signal_cachep, sig);
 }
 
-static inline void cleanup_signal(struct task_struct *tsk)
+static void cleanup_signal(struct task_struct *tsk)
 {
 	struct signal_struct *sig = tsk->signal;
 
@@ -934,7 +934,7 @@ static inline void cleanup_signal(struct
 		__cleanup_signal(sig);
 }
 
-static inline void copy_flags(unsigned long clone_flags, struct task_struct *p)
+static void copy_flags(unsigned long clone_flags, struct task_struct *p)
 {
 	unsigned long new_flags = p->flags;
 
@@ -953,7 +953,7 @@ asmlinkage long sys_set_tid_address(int 
 	return task_pid_vnr(current);
 }
 
-static inline void rt_mutex_init_task(struct task_struct *p)
+static void rt_mutex_init_task(struct task_struct *p)
 {
 	spin_lock_init(&p->pi_lock);
 #ifdef CONFIG_RT_MUTEXES
@@ -1385,7 +1385,7 @@ struct task_struct * __cpuinit fork_idle
 	return task;
 }
 
-static inline int fork_traceflag (unsigned clone_flags)
+static int fork_traceflag(unsigned clone_flags)
 {
 	if (clone_flags & CLONE_UNTRACED)
 		return 0;
@@ -1521,7 +1521,7 @@ void __init proc_caches_init(void)
  * Check constraints on flags passed to the unshare system call and
  * force unsharing of additional process context as appropriate.
  */
-static inline void check_unshare_flags(unsigned long *flags_ptr)
+static void check_unshare_flags(unsigned long *flags_ptr)
 {
 	/*
 	 * If unsharing a thread from a thread group, must also
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
single_open-seq_release-leak-diagnostics.patch
