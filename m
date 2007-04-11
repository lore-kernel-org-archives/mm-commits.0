From: akpm@linux-foundation.org
Subject: + kthread-dont-depend-on-work-queues.patch added to -mm tree
Date: Wed, 11 Apr 2007 00:02:43 -0700
Message-ID: <200704110702.l3B72hdQ030938@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34439 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbXDKHD2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 03:03:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, davidel@xmailserver.org, holt@sgi.com, jengelh@linux01.gwdg.de, mingo@elte.hu, oleg@tv-sign.ru, roland@redhat.com, serge@hallyn.com, torvalds@linux-foundation.org


The patch titled
     kthread: Don't depend on work queues
has been added to the -mm tree.  Its filename is
     kthread-dont-depend-on-work-queues.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kthread: Don't depend on work queues
From: Eric W. Biederman <ebiederm@xmission.com>

Currently there is a circular reference between work queue initialization
and kthread initialization.  This prevents the kthread infrastructure from
initializing until after work queues have been initialized.

For kthreads we want something that is as close as possible to the
init_task and is not contaminated by user processes.  The later we start
our kthreadd that forks the rest of the kernel threads the harder this is
to do and the more of a mess we have to clean up because the defaults have
changed on us.

So this patch modifies the kthread support to not use work queues but to
instead use a simple list of structures, and to have kthreadd start from
init_task immediately after our kernel thread that execs /sbin/init.

By being a true child of init_task we only have to change those process
settings that we want to have different from init_task, such as our process
name, blocking all signals and setting SIGCHLD to SIG_IGN so that all of
our children are reaped automatically.

By being a true child of init_task we also naturally get our ppid set to 0
and do not wind up as a child of PID == 1.  Ensuring that kernel threads
will not slow down the functioning of the wait family of functions.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kthread.h |    2 
 init/main.c             |    2 
 kernel/kthread.c        |  119 ++++++++++++++++++++------------------
 3 files changed, 68 insertions(+), 55 deletions(-)

diff -puN include/linux/kthread.h~kthread-dont-depend-on-work-queues include/linux/kthread.h
--- a/include/linux/kthread.h~kthread-dont-depend-on-work-queues
+++ a/include/linux/kthread.h
@@ -30,4 +30,6 @@ void kthread_bind(struct task_struct *k,
 int kthread_stop(struct task_struct *k);
 int kthread_should_stop(void);
 
+int kthreadd(void *unused);
+
 #endif /* _LINUX_KTHREAD_H */
diff -puN init/main.c~kthread-dont-depend-on-work-queues init/main.c
--- a/init/main.c~kthread-dont-depend-on-work-queues
+++ a/init/main.c
@@ -54,6 +54,7 @@
 #include <linux/lockdep.h>
 #include <linux/pid_namespace.h>
 #include <linux/device.h>
+#include <linux/kthread.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -428,6 +429,7 @@ static void noinline rest_init(void)
 {
 	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
 	numa_default_policy();
+	kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
 	unlock_kernel();
 
 	/*
diff -puN kernel/kthread.c~kthread-dont-depend-on-work-queues kernel/kthread.c
--- a/kernel/kthread.c~kthread-dont-depend-on-work-queues
+++ a/kernel/kthread.c
@@ -1,7 +1,7 @@
 /* Kernel thread helper functions.
  *   Copyright (C) 2004 IBM Corporation, Rusty Russell.
  *
- * Creation is done via keventd, so that we get a clean environment
+ * Creation is done via kthreadd, so that we get a clean environment
  * even if we're invoked from userspace (think modprobe, hotplug cpu,
  * etc.).
  */
@@ -15,24 +15,22 @@
 #include <linux/mutex.h>
 #include <asm/semaphore.h>
 
-/*
- * We dont want to execute off keventd since it might
- * hold a semaphore our callers hold too:
- */
-static struct workqueue_struct *helper_wq;
+static DEFINE_SPINLOCK(kthread_create_lock);
+static LIST_HEAD(kthread_create_list);
+static DECLARE_WAIT_QUEUE_HEAD(kthread_create_work);
 
 struct kthread_create_info
 {
-	/* Information passed to kthread() from keventd. */
+	/* Information passed to kthread() from kthreadd. */
 	int (*threadfn)(void *data);
 	void *data;
 	struct completion started;
 
-	/* Result passed back to kthread_create() from keventd. */
+	/* Result passed back to kthread_create() from kthreadd. */
 	struct task_struct *result;
 	struct completion done;
 
-	struct work_struct work;
+	struct list_head list;
 };
 
 struct kthread_stop_info
@@ -60,42 +58,17 @@ int kthread_should_stop(void)
 }
 EXPORT_SYMBOL(kthread_should_stop);
 
-static void kthread_exit_files(void)
-{
-	struct fs_struct *fs;
-	struct task_struct *tsk = current;
-
-	exit_fs(tsk);		/* current->fs->count--; */
-	fs = init_task.fs;
-	tsk->fs = fs;
-	atomic_inc(&fs->count);
- 	exit_files(tsk);
-	current->files = init_task.files;
-	atomic_inc(&tsk->files->count);
-}
-
 static int kthread(void *_create)
 {
 	struct kthread_create_info *create = _create;
 	int (*threadfn)(void *data);
 	void *data;
-	sigset_t blocked;
 	int ret = -EINTR;
 
-	kthread_exit_files();
-
-	/* Copy data: it's on keventd's stack */
+	/* Copy data: it's on kthread's stack */
 	threadfn = create->threadfn;
 	data = create->data;
 
-	/* Block and flush all signals (in case we're not from keventd). */
-	sigfillset(&blocked);
-	sigprocmask(SIG_BLOCK, &blocked, NULL);
-	flush_signals(current);
-
-	/* By default we can run anywhere, unlike keventd. */
-	set_cpus_allowed(current, CPU_MASK_ALL);
-
 	/* OK, tell user we're spawned, wait for stop or wakeup */
 	__set_current_state(TASK_INTERRUPTIBLE);
 	complete(&create->started);
@@ -112,11 +85,8 @@ static int kthread(void *_create)
 	return 0;
 }
 
-/* We are keventd: create a thread. */
-static void keventd_create_kthread(struct work_struct *work)
+static void create_kthread(struct kthread_create_info *create)
 {
-	struct kthread_create_info *create =
-		container_of(work, struct kthread_create_info, work);
 	int pid;
 
 	/* We want our own signal handler (we take no signals by default). */
@@ -162,17 +132,14 @@ struct task_struct *kthread_create(int (
 	create.data = data;
 	init_completion(&create.started);
 	init_completion(&create.done);
-	INIT_WORK(&create.work, keventd_create_kthread);
 
-	/*
-	 * The workqueue needs to start up first:
-	 */
-	if (!helper_wq)
-		create.work.func(&create.work);
-	else {
-		queue_work(helper_wq, &create.work);
-		wait_for_completion(&create.done);
-	}
+	spin_lock(&kthread_create_lock);
+	list_add_tail(&create.list, &kthread_create_list);
+	wake_up(&kthread_create_work);
+	spin_unlock(&kthread_create_lock);
+
+	wait_for_completion(&create.done);
+
 	if (!IS_ERR(create.result)) {
 		va_list args;
 		va_start(args, namefmt);
@@ -180,7 +147,6 @@ struct task_struct *kthread_create(int (
 			  namefmt, args);
 		va_end(args);
 	}
-
 	return create.result;
 }
 EXPORT_SYMBOL(kthread_create);
@@ -245,12 +211,55 @@ int kthread_stop(struct task_struct *k)
 }
 EXPORT_SYMBOL(kthread_stop);
 
-static __init int helper_init(void)
+
+static __init void kthreadd_setup(void)
+{
+	struct task_struct *tsk = current;
+	struct k_sigaction sa;
+	sigset_t blocked;
+
+	strcpy(tsk->comm, "kthreadd");
+
+	/* Block and flush all signals */
+	sigfillset(&blocked);
+	sigprocmask(SIG_BLOCK, &blocked, NULL);
+	flush_signals(tsk);
+
+	/* SIG_IGN makes children autoreap: see do_notify_parent(). */
+	sa.sa.sa_handler = SIG_IGN;
+	sa.sa.sa_flags = 0;
+	siginitset(&sa.sa.sa_mask, sigmask(SIGCHLD));
+	do_sigaction(SIGCHLD, &sa, (struct k_sigaction *)0);
+
+	set_user_nice(current, -5);
+}
+
+int kthreadd(void *unused)
 {
-	helper_wq = create_singlethread_workqueue("kthread");
-	BUG_ON(!helper_wq);
+	/* Setup a clean context for our children to inherit. */
+	kthreadd_setup();
+
+	current->flags |= PF_NOFREEZE;
+
+	for (;;) {
+		wait_event(kthread_create_work,
+			   !list_empty(&kthread_create_list));
+
+		spin_lock(&kthread_create_lock);
+		while (!list_empty(&kthread_create_list)) {
+			struct kthread_create_info *create;
+
+			create = list_entry(kthread_create_list.next,
+					    struct kthread_create_info, list);
+			list_del_init(&create->list);
+			spin_unlock(&kthread_create_lock);
+
+			create_kthread(create);
+
+			spin_lock(&kthread_create_lock);
+		}
+		spin_unlock(&kthread_create_lock);
+	}
 
 	return 0;
 }
-
-core_initcall(helper_init);
_

Patches currently in -mm which might be from ebiederm@xmission.com are

powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
fix-x86_64-mm-relocatable-kernel-support.patch
account-for-module-percpu-space-separately-from-kernel.patch
i386-irq-kill-irq-compression.patch
i386-relocate-vdso-elf-headers-to-match-mapped-location-with-compat_vdso.patch
i386-make-compat_vdso-runtime-selectable.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
allow-access-to-proc-pid-fd-after-setuid.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
fix-race-between-proc_get_inode-and-remove_proc_entry.patch
fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-constify-them.patch
tty-remove-unnecessary-export-of-proc_clear_tty.patch
tty-simplify-calling-of-put_pid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch
clean-up-elf-note-generation.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
use-the-apic-to-determine-the-hardware-processor-id-i386.patch
use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
always-ask-the-hardware-to-obtain-hardware-processor-id-ia64.patch
proc-cleanup-use-seq_release_private-where-appropriate.patch
kthread-dont-depend-on-work-queues.patch
kthread-dont-depend-on-work-queues-fix.patch
edac-k8-driver-coding-tidy.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-and-sid-of-init-process.patch
use-struct-pid-parameter-in-copy_process.patch
use-task_pgrp-task_session-in-copy_process.patch
kill-unused-sesssion-and-group-values-in-rocket-driver.patch
fix-some-coding-style-errors-in-autofs.patch
replace-pid_t-in-autofs-with-struct-pid-reference.patch
dont-init-pgrp-and-__session-in-init_signals.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
