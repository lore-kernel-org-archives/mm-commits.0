From: akpm@linux-foundation.org
Subject: + uninline-forkc-exitc.patch added to -mm tree
Date: Wed, 03 Oct 2007 14:30:46 -0700
Message-ID: <200710032130.l93LUkoc009628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54312 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757237AbXJCVbh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2007 17:31:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, arjan@infradead.org, mingo@elte.hu


The patch titled
     Uninline fork.c/exit.c
has been added to the -mm tree.  Its filename is
     uninline-forkc-exitc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN kernel/exit.c~uninline-forkc-exitc kernel/exit.c
--- a/kernel/exit.c~uninline-forkc-exitc
+++ a/kernel/exit.c
@@ -492,7 +492,7 @@ void reset_files_struct(struct task_stru
 }
 EXPORT_SYMBOL(reset_files_struct);
 
-static inline void __exit_files(struct task_struct *tsk)
+static void __exit_files(struct task_struct *tsk)
 {
 	struct files_struct * files = tsk->files;
 
@@ -509,7 +509,7 @@ void exit_files(struct task_struct *tsk)
 	__exit_files(tsk);
 }
 
-static inline void __put_fs_struct(struct fs_struct *fs)
+static void __put_fs_struct(struct fs_struct *fs)
 {
 	/* No need to hold fs->lock if we are killing it */
 	if (atomic_dec_and_test(&fs->count)) {
@@ -530,7 +530,7 @@ void put_fs_struct(struct fs_struct *fs)
 	__put_fs_struct(fs);
 }
 
-static inline void __exit_fs(struct task_struct *tsk)
+static void __exit_fs(struct task_struct *tsk)
 {
 	struct fs_struct * fs = tsk->fs;
 
diff -puN kernel/fork.c~uninline-forkc-exitc kernel/fork.c
--- a/kernel/fork.c~uninline-forkc-exitc
+++ a/kernel/fork.c
@@ -207,7 +207,7 @@ static struct task_struct *dup_task_stru
 }
 
 #ifdef CONFIG_MMU
-static inline int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
+static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 {
 	struct vm_area_struct *mpnt, *tmp, **pprev;
 	struct rb_node **rb_link, *rb_parent;
@@ -589,7 +589,7 @@ fail_nomem:
 	return retval;
 }
 
-static inline struct fs_struct *__copy_fs_struct(struct fs_struct *old)
+static struct fs_struct *__copy_fs_struct(struct fs_struct *old)
 {
 	struct fs_struct *fs = kmem_cache_alloc(fs_cachep, GFP_KERNEL);
 	/* We don't need to lock fs - think why ;-) */
@@ -621,7 +621,7 @@ struct fs_struct *copy_fs_struct(struct 
 
 EXPORT_SYMBOL_GPL(copy_fs_struct);
 
-static inline int copy_fs(unsigned long clone_flags, struct task_struct * tsk)
+static int copy_fs(unsigned long clone_flags, struct task_struct * tsk)
 {
 	if (clone_flags & CLONE_FS) {
 		atomic_inc(&current->fs->count);
@@ -824,7 +824,7 @@ int unshare_files(void)
 
 EXPORT_SYMBOL(unshare_files);
 
-static inline int copy_sighand(unsigned long clone_flags, struct task_struct * tsk)
+static int copy_sighand(unsigned long clone_flags, struct task_struct * tsk)
 {
 	struct sighand_struct *sig;
 
@@ -847,7 +847,7 @@ void __cleanup_sighand(struct sighand_st
 		kmem_cache_free(sighand_cachep, sighand);
 }
 
-static inline int copy_signal(unsigned long clone_flags, struct task_struct * tsk)
+static int copy_signal(unsigned long clone_flags, struct task_struct * tsk)
 {
 	struct signal_struct *sig;
 	int ret;
@@ -927,7 +927,7 @@ void __cleanup_signal(struct signal_stru
 	kmem_cache_free(signal_cachep, sig);
 }
 
-static inline void cleanup_signal(struct task_struct *tsk)
+static void cleanup_signal(struct task_struct *tsk)
 {
 	struct signal_struct *sig = tsk->signal;
 
@@ -937,7 +937,7 @@ static inline void cleanup_signal(struct
 		__cleanup_signal(sig);
 }
 
-static inline void copy_flags(unsigned long clone_flags, struct task_struct *p)
+static void copy_flags(unsigned long clone_flags, struct task_struct *p)
 {
 	unsigned long new_flags = p->flags;
 
@@ -956,7 +956,7 @@ asmlinkage long sys_set_tid_address(int 
 	return task_pid_vnr(current);
 }
 
-static inline void rt_mutex_init_task(struct task_struct *p)
+static void rt_mutex_init_task(struct task_struct *p)
 {
 	spin_lock_init(&p->pi_lock);
 #ifdef CONFIG_RT_MUTEXES
@@ -1393,7 +1393,7 @@ struct task_struct * __cpuinit fork_idle
 	return task;
 }
 
-static inline int fork_traceflag (unsigned clone_flags)
+static int fork_traceflag (unsigned clone_flags)
 {
 	if (clone_flags & CLONE_UNTRACED)
 		return 0;
@@ -1526,7 +1526,7 @@ void __init proc_caches_init(void)
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

consolidate-ptrace_detach.patch
git-kbuild.patch
git-sched.patch
slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab-fix.patch
use-list_head-in-binfmt-handling-update.patch
make-unregister_binfmt-return-void.patch
slab_panic-more-proc-posix-timers-shmem.patch
add-kernel-notifierc.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2.patch
tweak-proc-ipmi-removal.patch
shrink-task_struct-if-config_futex=n.patch
userc-deinline.patch
userc-ifdef-mq_bytes.patch
userc-ifdef-mq_bytes-fix.patch
move-kasprintfo-to-obj-y.patch
task_struct-move-fpu_counter-and-oomkilladj.patch
sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
sysctl-factor-out-sysctl_data.patch
sysct-mqueue-remove-the-binary-sysctl-numbers.patch
sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch
sysctl-fix-neighbour-table-sysctls.patch
sysctl-ipv6-route-flushing-kill-binary-path.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
sysctl-x86_64-remove-unnecessary-binary-paths.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
sysctl-error-on-bad-sysctl-tables.patch
sysctl-update-sysctl_check_table.patch
uninline-forkc-exitc.patch
single_open-seq_release-leak-diagnostics.patch
