From: akpm@linux-foundation.org
Subject: [patch 110/126] kmod: split out umh code into its own file
Date: Fri, 08 Sep 2017 16:17:00 -0700
Message-ID: <20170908231700.9LCIQUMFO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53568 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932381AbdIHXRC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:17:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, colin.king@canonical.com, dan.carpenter@oracle.com, danielmentz@google.com, dcb314@hotmail.com, dmitry.torokhov@gmail.com, ebiederm@xmission.com, gregkh@linuxfoundation.org, jeyu@redhat.com, jpoimboe@redhat.com, keescook@chromium.org, linux@roeck-us.net, matt.redfearn@imgtec.com, mbenes@suse.cz, mcgrof@kernel.org, mm-commits@vger.kernel.org, mmarek@suse.com, pmladek@suse.com, rusty@rustcorp.com.au, torvalds@linux-foundation.org

From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: kmod: split out umh code into its own file

Patch series "kmod: few code cleanups to split out umh code"

The usermode helper has a provenance from the old usb code which first
required a usermode helper.  Eventually this was shoved into kmod.c and
the kernel's modprobe calls was converted over eventually to share the
same code.  Over time the list of usermode helpers in the kernel has grown
-- so kmod is just but one user of the API.

This series is a simple logical cleanup which acknowledges the code
evolution of the usermode helper and shoves the UMH API into its own
dedicated file.  This way users of the API can later just include umh.h
instead of kmod.h.

Note despite the diff state the first patch really is just a code shove,
no functional changes are done there.  I did use git format-patch -M to
generate the patch, but in the end the split was not enough for git to
consider it a rename hence the large diffstat.

I've put this through 0-day and it gives me their machine compilation
blessings with all tests as OK.


This patch (of 4):

There's a slew of usermode helper users and kmod is just one of them. 
Split out the usermode helper code into its own file to keep the logic and
focus split up.

This change provides no functional changes.

Link: http://lkml.kernel.org/r/20170810180618.22457-2-mcgrof@kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michal Marek <mmarek@suse.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Matt Redfearn <matt.redfearn@imgtec.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Daniel Mentz <danielmentz@google.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS     |    6 
 kernel/Makefile |    2 
 kernel/kmod.c   |  560 ---------------------------------------------
 kernel/umh.c    |  568 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 577 insertions(+), 559 deletions(-)

diff -puN MAINTAINERS~kmod-split-out-umh-code-into-its-own-file MAINTAINERS
--- a/MAINTAINERS~kmod-split-out-umh-code-into-its-own-file
+++ a/MAINTAINERS
@@ -7457,6 +7457,12 @@ S:	Maintained
 F:	tools/testing/selftests/
 F:	Documentation/dev-tools/kselftest*
 
+KERNEL USERMODE HELPER
+M:	"Luis R. Rodriguez" <mcgrof@kernel.org>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	kernel/umh.c
+
 KERNEL VIRTUAL MACHINE (KVM)
 M:	Paolo Bonzini <pbonzini@redhat.com>
 M:	Radim KrÄmÃ¡Å <rkrcmar@redhat.com>
diff -puN kernel/Makefile~kmod-split-out-umh-code-into-its-own-file kernel/Makefile
--- a/kernel/Makefile~kmod-split-out-umh-code-into-its-own-file
+++ a/kernel/Makefile
@@ -5,7 +5,7 @@
 obj-y     = fork.o exec_domain.o panic.o \
 	    cpu.o exit.o softirq.o resource.o \
 	    sysctl.o sysctl_binary.o capability.o ptrace.o user.o \
-	    signal.o sys.o kmod.o workqueue.o pid.o task_work.o \
+	    signal.o sys.o umh.o kmod.o workqueue.o pid.o task_work.o \
 	    extable.o params.o \
 	    kthread.o sys_ni.o nsproxy.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
diff -puN kernel/kmod.c~kmod-split-out-umh-code-into-its-own-file kernel/kmod.c
--- a/kernel/kmod.c~kmod-split-out-umh-code-into-its-own-file
+++ a/kernel/kmod.c
@@ -1,23 +1,6 @@
 /*
-	kmod, the new module loader (replaces kerneld)
-	Kirk Petersen
-
-	Reorganized not to be a daemon by Adam Richter, with guidance
-	from Greg Zornetzer.
-
-	Modified to avoid chroot and file sharing problems.
-	Mikael Pettersson
-
-	Limit the concurrent number of kmod modprobes to catch loops from
-	"modprobe needs a service that is in a module".
-	Keith Owens <kaos@ocs.com.au> December 1999
-
-	Unblock all signals when we exec a usermode process.
-	Shuu Yamaguchi <shuu@wondernetworkresources.com> December 2000
-
-	call_usermodehelper wait flag, and remove exec_usermodehelper.
-	Rusty Russell <rusty@rustcorp.com.au>  Jan 2003
-*/
+ * kmod - the kernel module loader
+ */
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/sched/task.h>
@@ -45,14 +28,6 @@
 
 #include <trace/events/module.h>
 
-#define CAP_BSET	(void *)1
-#define CAP_PI		(void *)2
-
-static kernel_cap_t usermodehelper_bset = CAP_FULL_SET;
-static kernel_cap_t usermodehelper_inheritable = CAP_FULL_SET;
-static DEFINE_SPINLOCK(umh_sysctl_lock);
-static DECLARE_RWSEM(umhelper_sem);
-
 #ifdef CONFIG_MODULES
 /*
  * Assuming:
@@ -204,534 +179,3 @@ int __request_module(bool wait, const ch
 EXPORT_SYMBOL(__request_module);
 
 #endif /* CONFIG_MODULES */
-
-static void call_usermodehelper_freeinfo(struct subprocess_info *info)
-{
-	if (info->cleanup)
-		(*info->cleanup)(info);
-	kfree(info);
-}
-
-static void umh_complete(struct subprocess_info *sub_info)
-{
-	struct completion *comp = xchg(&sub_info->complete, NULL);
-	/*
-	 * See call_usermodehelper_exec(). If xchg() returns NULL
-	 * we own sub_info, the UMH_KILLABLE caller has gone away
-	 * or the caller used UMH_NO_WAIT.
-	 */
-	if (comp)
-		complete(comp);
-	else
-		call_usermodehelper_freeinfo(sub_info);
-}
-
-/*
- * This is the task which runs the usermode application
- */
-static int call_usermodehelper_exec_async(void *data)
-{
-	struct subprocess_info *sub_info = data;
-	struct cred *new;
-	int retval;
-
-	spin_lock_irq(&current->sighand->siglock);
-	flush_signal_handlers(current, 1);
-	spin_unlock_irq(&current->sighand->siglock);
-
-	/*
-	 * Our parent (unbound workqueue) runs with elevated scheduling
-	 * priority. Avoid propagating that into the userspace child.
-	 */
-	set_user_nice(current, 0);
-
-	retval = -ENOMEM;
-	new = prepare_kernel_cred(current);
-	if (!new)
-		goto out;
-
-	spin_lock(&umh_sysctl_lock);
-	new->cap_bset = cap_intersect(usermodehelper_bset, new->cap_bset);
-	new->cap_inheritable = cap_intersect(usermodehelper_inheritable,
-					     new->cap_inheritable);
-	spin_unlock(&umh_sysctl_lock);
-
-	if (sub_info->init) {
-		retval = sub_info->init(sub_info, new);
-		if (retval) {
-			abort_creds(new);
-			goto out;
-		}
-	}
-
-	commit_creds(new);
-
-	retval = do_execve(getname_kernel(sub_info->path),
-			   (const char __user *const __user *)sub_info->argv,
-			   (const char __user *const __user *)sub_info->envp);
-out:
-	sub_info->retval = retval;
-	/*
-	 * call_usermodehelper_exec_sync() will call umh_complete
-	 * if UHM_WAIT_PROC.
-	 */
-	if (!(sub_info->wait & UMH_WAIT_PROC))
-		umh_complete(sub_info);
-	if (!retval)
-		return 0;
-	do_exit(0);
-}
-
-/* Handles UMH_WAIT_PROC.  */
-static void call_usermodehelper_exec_sync(struct subprocess_info *sub_info)
-{
-	pid_t pid;
-
-	/* If SIGCLD is ignored sys_wait4 won't populate the status. */
-	kernel_sigaction(SIGCHLD, SIG_DFL);
-	pid = kernel_thread(call_usermodehelper_exec_async, sub_info, SIGCHLD);
-	if (pid < 0) {
-		sub_info->retval = pid;
-	} else {
-		int ret = -ECHILD;
-		/*
-		 * Normally it is bogus to call wait4() from in-kernel because
-		 * wait4() wants to write the exit code to a userspace address.
-		 * But call_usermodehelper_exec_sync() always runs as kernel
-		 * thread (workqueue) and put_user() to a kernel address works
-		 * OK for kernel threads, due to their having an mm_segment_t
-		 * which spans the entire address space.
-		 *
-		 * Thus the __user pointer cast is valid here.
-		 */
-		sys_wait4(pid, (int __user *)&ret, 0, NULL);
-
-		/*
-		 * If ret is 0, either call_usermodehelper_exec_async failed and
-		 * the real error code is already in sub_info->retval or
-		 * sub_info->retval is 0 anyway, so don't mess with it then.
-		 */
-		if (ret)
-			sub_info->retval = ret;
-	}
-
-	/* Restore default kernel sig handler */
-	kernel_sigaction(SIGCHLD, SIG_IGN);
-
-	umh_complete(sub_info);
-}
-
-/*
- * We need to create the usermodehelper kernel thread from a task that is affine
- * to an optimized set of CPUs (or nohz housekeeping ones) such that they
- * inherit a widest affinity irrespective of call_usermodehelper() callers with
- * possibly reduced affinity (eg: per-cpu workqueues). We don't want
- * usermodehelper targets to contend a busy CPU.
- *
- * Unbound workqueues provide such wide affinity and allow to block on
- * UMH_WAIT_PROC requests without blocking pending request (up to some limit).
- *
- * Besides, workqueues provide the privilege level that caller might not have
- * to perform the usermodehelper request.
- *
- */
-static void call_usermodehelper_exec_work(struct work_struct *work)
-{
-	struct subprocess_info *sub_info =
-		container_of(work, struct subprocess_info, work);
-
-	if (sub_info->wait & UMH_WAIT_PROC) {
-		call_usermodehelper_exec_sync(sub_info);
-	} else {
-		pid_t pid;
-		/*
-		 * Use CLONE_PARENT to reparent it to kthreadd; we do not
-		 * want to pollute current->children, and we need a parent
-		 * that always ignores SIGCHLD to ensure auto-reaping.
-		 */
-		pid = kernel_thread(call_usermodehelper_exec_async, sub_info,
-				    CLONE_PARENT | SIGCHLD);
-		if (pid < 0) {
-			sub_info->retval = pid;
-			umh_complete(sub_info);
-		}
-	}
-}
-
-/*
- * If set, call_usermodehelper_exec() will exit immediately returning -EBUSY
- * (used for preventing user land processes from being created after the user
- * land has been frozen during a system-wide hibernation or suspend operation).
- * Should always be manipulated under umhelper_sem acquired for write.
- */
-static enum umh_disable_depth usermodehelper_disabled = UMH_DISABLED;
-
-/* Number of helpers running */
-static atomic_t running_helpers = ATOMIC_INIT(0);
-
-/*
- * Wait queue head used by usermodehelper_disable() to wait for all running
- * helpers to finish.
- */
-static DECLARE_WAIT_QUEUE_HEAD(running_helpers_waitq);
-
-/*
- * Used by usermodehelper_read_lock_wait() to wait for usermodehelper_disabled
- * to become 'false'.
- */
-static DECLARE_WAIT_QUEUE_HEAD(usermodehelper_disabled_waitq);
-
-/*
- * Time to wait for running_helpers to become zero before the setting of
- * usermodehelper_disabled in usermodehelper_disable() fails
- */
-#define RUNNING_HELPERS_TIMEOUT	(5 * HZ)
-
-int usermodehelper_read_trylock(void)
-{
-	DEFINE_WAIT(wait);
-	int ret = 0;
-
-	down_read(&umhelper_sem);
-	for (;;) {
-		prepare_to_wait(&usermodehelper_disabled_waitq, &wait,
-				TASK_INTERRUPTIBLE);
-		if (!usermodehelper_disabled)
-			break;
-
-		if (usermodehelper_disabled == UMH_DISABLED)
-			ret = -EAGAIN;
-
-		up_read(&umhelper_sem);
-
-		if (ret)
-			break;
-
-		schedule();
-		try_to_freeze();
-
-		down_read(&umhelper_sem);
-	}
-	finish_wait(&usermodehelper_disabled_waitq, &wait);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(usermodehelper_read_trylock);
-
-long usermodehelper_read_lock_wait(long timeout)
-{
-	DEFINE_WAIT(wait);
-
-	if (timeout < 0)
-		return -EINVAL;
-
-	down_read(&umhelper_sem);
-	for (;;) {
-		prepare_to_wait(&usermodehelper_disabled_waitq, &wait,
-				TASK_UNINTERRUPTIBLE);
-		if (!usermodehelper_disabled)
-			break;
-
-		up_read(&umhelper_sem);
-
-		timeout = schedule_timeout(timeout);
-		if (!timeout)
-			break;
-
-		down_read(&umhelper_sem);
-	}
-	finish_wait(&usermodehelper_disabled_waitq, &wait);
-	return timeout;
-}
-EXPORT_SYMBOL_GPL(usermodehelper_read_lock_wait);
-
-void usermodehelper_read_unlock(void)
-{
-	up_read(&umhelper_sem);
-}
-EXPORT_SYMBOL_GPL(usermodehelper_read_unlock);
-
-/**
- * __usermodehelper_set_disable_depth - Modify usermodehelper_disabled.
- * @depth: New value to assign to usermodehelper_disabled.
- *
- * Change the value of usermodehelper_disabled (under umhelper_sem locked for
- * writing) and wakeup tasks waiting for it to change.
- */
-void __usermodehelper_set_disable_depth(enum umh_disable_depth depth)
-{
-	down_write(&umhelper_sem);
-	usermodehelper_disabled = depth;
-	wake_up(&usermodehelper_disabled_waitq);
-	up_write(&umhelper_sem);
-}
-
-/**
- * __usermodehelper_disable - Prevent new helpers from being started.
- * @depth: New value to assign to usermodehelper_disabled.
- *
- * Set usermodehelper_disabled to @depth and wait for running helpers to exit.
- */
-int __usermodehelper_disable(enum umh_disable_depth depth)
-{
-	long retval;
-
-	if (!depth)
-		return -EINVAL;
-
-	down_write(&umhelper_sem);
-	usermodehelper_disabled = depth;
-	up_write(&umhelper_sem);
-
-	/*
-	 * From now on call_usermodehelper_exec() won't start any new
-	 * helpers, so it is sufficient if running_helpers turns out to
-	 * be zero at one point (it may be increased later, but that
-	 * doesn't matter).
-	 */
-	retval = wait_event_timeout(running_helpers_waitq,
-					atomic_read(&running_helpers) == 0,
-					RUNNING_HELPERS_TIMEOUT);
-	if (retval)
-		return 0;
-
-	__usermodehelper_set_disable_depth(UMH_ENABLED);
-	return -EAGAIN;
-}
-
-static void helper_lock(void)
-{
-	atomic_inc(&running_helpers);
-	smp_mb__after_atomic();
-}
-
-static void helper_unlock(void)
-{
-	if (atomic_dec_and_test(&running_helpers))
-		wake_up(&running_helpers_waitq);
-}
-
-/**
- * call_usermodehelper_setup - prepare to call a usermode helper
- * @path: path to usermode executable
- * @argv: arg vector for process
- * @envp: environment for process
- * @gfp_mask: gfp mask for memory allocation
- * @cleanup: a cleanup function
- * @init: an init function
- * @data: arbitrary context sensitive data
- *
- * Returns either %NULL on allocation failure, or a subprocess_info
- * structure.  This should be passed to call_usermodehelper_exec to
- * exec the process and free the structure.
- *
- * The init function is used to customize the helper process prior to
- * exec.  A non-zero return code causes the process to error out, exit,
- * and return the failure to the calling process
- *
- * The cleanup function is just before ethe subprocess_info is about to
- * be freed.  This can be used for freeing the argv and envp.  The
- * Function must be runnable in either a process context or the
- * context in which call_usermodehelper_exec is called.
- */
-struct subprocess_info *call_usermodehelper_setup(const char *path, char **argv,
-		char **envp, gfp_t gfp_mask,
-		int (*init)(struct subprocess_info *info, struct cred *new),
-		void (*cleanup)(struct subprocess_info *info),
-		void *data)
-{
-	struct subprocess_info *sub_info;
-	sub_info = kzalloc(sizeof(struct subprocess_info), gfp_mask);
-	if (!sub_info)
-		goto out;
-
-	INIT_WORK(&sub_info->work, call_usermodehelper_exec_work);
-
-#ifdef CONFIG_STATIC_USERMODEHELPER
-	sub_info->path = CONFIG_STATIC_USERMODEHELPER_PATH;
-#else
-	sub_info->path = path;
-#endif
-	sub_info->argv = argv;
-	sub_info->envp = envp;
-
-	sub_info->cleanup = cleanup;
-	sub_info->init = init;
-	sub_info->data = data;
-  out:
-	return sub_info;
-}
-EXPORT_SYMBOL(call_usermodehelper_setup);
-
-/**
- * call_usermodehelper_exec - start a usermode application
- * @sub_info: information about the subprocessa
- * @wait: wait for the application to finish and return status.
- *        when UMH_NO_WAIT don't wait at all, but you get no useful error back
- *        when the program couldn't be exec'ed. This makes it safe to call
- *        from interrupt context.
- *
- * Runs a user-space application.  The application is started
- * asynchronously if wait is not set, and runs as a child of system workqueues.
- * (ie. it runs with full root capabilities and optimized affinity).
- */
-int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
-{
-	DECLARE_COMPLETION_ONSTACK(done);
-	int retval = 0;
-
-	if (!sub_info->path) {
-		call_usermodehelper_freeinfo(sub_info);
-		return -EINVAL;
-	}
-	helper_lock();
-	if (usermodehelper_disabled) {
-		retval = -EBUSY;
-		goto out;
-	}
-
-	/*
-	 * If there is no binary for us to call, then just return and get out of
-	 * here.  This allows us to set STATIC_USERMODEHELPER_PATH to "" and
-	 * disable all call_usermodehelper() calls.
-	 */
-	if (strlen(sub_info->path) == 0)
-		goto out;
-
-	/*
-	 * Set the completion pointer only if there is a waiter.
-	 * This makes it possible to use umh_complete to free
-	 * the data structure in case of UMH_NO_WAIT.
-	 */
-	sub_info->complete = (wait == UMH_NO_WAIT) ? NULL : &done;
-	sub_info->wait = wait;
-
-	queue_work(system_unbound_wq, &sub_info->work);
-	if (wait == UMH_NO_WAIT)	/* task has freed sub_info */
-		goto unlock;
-
-	if (wait & UMH_KILLABLE) {
-		retval = wait_for_completion_killable(&done);
-		if (!retval)
-			goto wait_done;
-
-		/* umh_complete() will see NULL and free sub_info */
-		if (xchg(&sub_info->complete, NULL))
-			goto unlock;
-		/* fallthrough, umh_complete() was already called */
-	}
-
-	wait_for_completion(&done);
-wait_done:
-	retval = sub_info->retval;
-out:
-	call_usermodehelper_freeinfo(sub_info);
-unlock:
-	helper_unlock();
-	return retval;
-}
-EXPORT_SYMBOL(call_usermodehelper_exec);
-
-/**
- * call_usermodehelper() - prepare and start a usermode application
- * @path: path to usermode executable
- * @argv: arg vector for process
- * @envp: environment for process
- * @wait: wait for the application to finish and return status.
- *        when UMH_NO_WAIT don't wait at all, but you get no useful error back
- *        when the program couldn't be exec'ed. This makes it safe to call
- *        from interrupt context.
- *
- * This function is the equivalent to use call_usermodehelper_setup() and
- * call_usermodehelper_exec().
- */
-int call_usermodehelper(const char *path, char **argv, char **envp, int wait)
-{
-	struct subprocess_info *info;
-	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
-
-	info = call_usermodehelper_setup(path, argv, envp, gfp_mask,
-					 NULL, NULL, NULL);
-	if (info == NULL)
-		return -ENOMEM;
-
-	return call_usermodehelper_exec(info, wait);
-}
-EXPORT_SYMBOL(call_usermodehelper);
-
-static int proc_cap_handler(struct ctl_table *table, int write,
-			 void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	struct ctl_table t;
-	unsigned long cap_array[_KERNEL_CAPABILITY_U32S];
-	kernel_cap_t new_cap;
-	int err, i;
-
-	if (write && (!capable(CAP_SETPCAP) ||
-		      !capable(CAP_SYS_MODULE)))
-		return -EPERM;
-
-	/*
-	 * convert from the global kernel_cap_t to the ulong array to print to
-	 * userspace if this is a read.
-	 */
-	spin_lock(&umh_sysctl_lock);
-	for (i = 0; i < _KERNEL_CAPABILITY_U32S; i++)  {
-		if (table->data == CAP_BSET)
-			cap_array[i] = usermodehelper_bset.cap[i];
-		else if (table->data == CAP_PI)
-			cap_array[i] = usermodehelper_inheritable.cap[i];
-		else
-			BUG();
-	}
-	spin_unlock(&umh_sysctl_lock);
-
-	t = *table;
-	t.data = &cap_array;
-
-	/*
-	 * actually read or write and array of ulongs from userspace.  Remember
-	 * these are least significant 32 bits first
-	 */
-	err = proc_doulongvec_minmax(&t, write, buffer, lenp, ppos);
-	if (err < 0)
-		return err;
-
-	/*
-	 * convert from the sysctl array of ulongs to the kernel_cap_t
-	 * internal representation
-	 */
-	for (i = 0; i < _KERNEL_CAPABILITY_U32S; i++)
-		new_cap.cap[i] = cap_array[i];
-
-	/*
-	 * Drop everything not in the new_cap (but don't add things)
-	 */
-	spin_lock(&umh_sysctl_lock);
-	if (write) {
-		if (table->data == CAP_BSET)
-			usermodehelper_bset = cap_intersect(usermodehelper_bset, new_cap);
-		if (table->data == CAP_PI)
-			usermodehelper_inheritable = cap_intersect(usermodehelper_inheritable, new_cap);
-	}
-	spin_unlock(&umh_sysctl_lock);
-
-	return 0;
-}
-
-struct ctl_table usermodehelper_table[] = {
-	{
-		.procname	= "bset",
-		.data		= CAP_BSET,
-		.maxlen		= _KERNEL_CAPABILITY_U32S * sizeof(unsigned long),
-		.mode		= 0600,
-		.proc_handler	= proc_cap_handler,
-	},
-	{
-		.procname	= "inheritable",
-		.data		= CAP_PI,
-		.maxlen		= _KERNEL_CAPABILITY_U32S * sizeof(unsigned long),
-		.mode		= 0600,
-		.proc_handler	= proc_cap_handler,
-	},
-	{ }
-};
diff -puN /dev/null kernel/umh.c
--- /dev/null
+++ a/kernel/umh.c
@@ -0,0 +1,568 @@
+/*
+ * umh - the kernel usermode helper
+ */
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/sched/task.h>
+#include <linux/binfmts.h>
+#include <linux/syscalls.h>
+#include <linux/unistd.h>
+#include <linux/kmod.h>
+#include <linux/slab.h>
+#include <linux/completion.h>
+#include <linux/cred.h>
+#include <linux/file.h>
+#include <linux/fdtable.h>
+#include <linux/workqueue.h>
+#include <linux/security.h>
+#include <linux/mount.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/resource.h>
+#include <linux/notifier.h>
+#include <linux/suspend.h>
+#include <linux/rwsem.h>
+#include <linux/ptrace.h>
+#include <linux/async.h>
+#include <linux/uaccess.h>
+
+#include <trace/events/module.h>
+
+#define CAP_BSET	(void *)1
+#define CAP_PI		(void *)2
+
+static kernel_cap_t usermodehelper_bset = CAP_FULL_SET;
+static kernel_cap_t usermodehelper_inheritable = CAP_FULL_SET;
+static DEFINE_SPINLOCK(umh_sysctl_lock);
+static DECLARE_RWSEM(umhelper_sem);
+
+static void call_usermodehelper_freeinfo(struct subprocess_info *info)
+{
+	if (info->cleanup)
+		(*info->cleanup)(info);
+	kfree(info);
+}
+
+static void umh_complete(struct subprocess_info *sub_info)
+{
+	struct completion *comp = xchg(&sub_info->complete, NULL);
+	/*
+	 * See call_usermodehelper_exec(). If xchg() returns NULL
+	 * we own sub_info, the UMH_KILLABLE caller has gone away
+	 * or the caller used UMH_NO_WAIT.
+	 */
+	if (comp)
+		complete(comp);
+	else
+		call_usermodehelper_freeinfo(sub_info);
+}
+
+/*
+ * This is the task which runs the usermode application
+ */
+static int call_usermodehelper_exec_async(void *data)
+{
+	struct subprocess_info *sub_info = data;
+	struct cred *new;
+	int retval;
+
+	spin_lock_irq(&current->sighand->siglock);
+	flush_signal_handlers(current, 1);
+	spin_unlock_irq(&current->sighand->siglock);
+
+	/*
+	 * Our parent (unbound workqueue) runs with elevated scheduling
+	 * priority. Avoid propagating that into the userspace child.
+	 */
+	set_user_nice(current, 0);
+
+	retval = -ENOMEM;
+	new = prepare_kernel_cred(current);
+	if (!new)
+		goto out;
+
+	spin_lock(&umh_sysctl_lock);
+	new->cap_bset = cap_intersect(usermodehelper_bset, new->cap_bset);
+	new->cap_inheritable = cap_intersect(usermodehelper_inheritable,
+					     new->cap_inheritable);
+	spin_unlock(&umh_sysctl_lock);
+
+	if (sub_info->init) {
+		retval = sub_info->init(sub_info, new);
+		if (retval) {
+			abort_creds(new);
+			goto out;
+		}
+	}
+
+	commit_creds(new);
+
+	retval = do_execve(getname_kernel(sub_info->path),
+			   (const char __user *const __user *)sub_info->argv,
+			   (const char __user *const __user *)sub_info->envp);
+out:
+	sub_info->retval = retval;
+	/*
+	 * call_usermodehelper_exec_sync() will call umh_complete
+	 * if UHM_WAIT_PROC.
+	 */
+	if (!(sub_info->wait & UMH_WAIT_PROC))
+		umh_complete(sub_info);
+	if (!retval)
+		return 0;
+	do_exit(0);
+}
+
+/* Handles UMH_WAIT_PROC.  */
+static void call_usermodehelper_exec_sync(struct subprocess_info *sub_info)
+{
+	pid_t pid;
+
+	/* If SIGCLD is ignored sys_wait4 won't populate the status. */
+	kernel_sigaction(SIGCHLD, SIG_DFL);
+	pid = kernel_thread(call_usermodehelper_exec_async, sub_info, SIGCHLD);
+	if (pid < 0) {
+		sub_info->retval = pid;
+	} else {
+		int ret = -ECHILD;
+		/*
+		 * Normally it is bogus to call wait4() from in-kernel because
+		 * wait4() wants to write the exit code to a userspace address.
+		 * But call_usermodehelper_exec_sync() always runs as kernel
+		 * thread (workqueue) and put_user() to a kernel address works
+		 * OK for kernel threads, due to their having an mm_segment_t
+		 * which spans the entire address space.
+		 *
+		 * Thus the __user pointer cast is valid here.
+		 */
+		sys_wait4(pid, (int __user *)&ret, 0, NULL);
+
+		/*
+		 * If ret is 0, either call_usermodehelper_exec_async failed and
+		 * the real error code is already in sub_info->retval or
+		 * sub_info->retval is 0 anyway, so don't mess with it then.
+		 */
+		if (ret)
+			sub_info->retval = ret;
+	}
+
+	/* Restore default kernel sig handler */
+	kernel_sigaction(SIGCHLD, SIG_IGN);
+
+	umh_complete(sub_info);
+}
+
+/*
+ * We need to create the usermodehelper kernel thread from a task that is affine
+ * to an optimized set of CPUs (or nohz housekeeping ones) such that they
+ * inherit a widest affinity irrespective of call_usermodehelper() callers with
+ * possibly reduced affinity (eg: per-cpu workqueues). We don't want
+ * usermodehelper targets to contend a busy CPU.
+ *
+ * Unbound workqueues provide such wide affinity and allow to block on
+ * UMH_WAIT_PROC requests without blocking pending request (up to some limit).
+ *
+ * Besides, workqueues provide the privilege level that caller might not have
+ * to perform the usermodehelper request.
+ *
+ */
+static void call_usermodehelper_exec_work(struct work_struct *work)
+{
+	struct subprocess_info *sub_info =
+		container_of(work, struct subprocess_info, work);
+
+	if (sub_info->wait & UMH_WAIT_PROC) {
+		call_usermodehelper_exec_sync(sub_info);
+	} else {
+		pid_t pid;
+		/*
+		 * Use CLONE_PARENT to reparent it to kthreadd; we do not
+		 * want to pollute current->children, and we need a parent
+		 * that always ignores SIGCHLD to ensure auto-reaping.
+		 */
+		pid = kernel_thread(call_usermodehelper_exec_async, sub_info,
+				    CLONE_PARENT | SIGCHLD);
+		if (pid < 0) {
+			sub_info->retval = pid;
+			umh_complete(sub_info);
+		}
+	}
+}
+
+/*
+ * If set, call_usermodehelper_exec() will exit immediately returning -EBUSY
+ * (used for preventing user land processes from being created after the user
+ * land has been frozen during a system-wide hibernation or suspend operation).
+ * Should always be manipulated under umhelper_sem acquired for write.
+ */
+static enum umh_disable_depth usermodehelper_disabled = UMH_DISABLED;
+
+/* Number of helpers running */
+static atomic_t running_helpers = ATOMIC_INIT(0);
+
+/*
+ * Wait queue head used by usermodehelper_disable() to wait for all running
+ * helpers to finish.
+ */
+static DECLARE_WAIT_QUEUE_HEAD(running_helpers_waitq);
+
+/*
+ * Used by usermodehelper_read_lock_wait() to wait for usermodehelper_disabled
+ * to become 'false'.
+ */
+static DECLARE_WAIT_QUEUE_HEAD(usermodehelper_disabled_waitq);
+
+/*
+ * Time to wait for running_helpers to become zero before the setting of
+ * usermodehelper_disabled in usermodehelper_disable() fails
+ */
+#define RUNNING_HELPERS_TIMEOUT	(5 * HZ)
+
+int usermodehelper_read_trylock(void)
+{
+	DEFINE_WAIT(wait);
+	int ret = 0;
+
+	down_read(&umhelper_sem);
+	for (;;) {
+		prepare_to_wait(&usermodehelper_disabled_waitq, &wait,
+				TASK_INTERRUPTIBLE);
+		if (!usermodehelper_disabled)
+			break;
+
+		if (usermodehelper_disabled == UMH_DISABLED)
+			ret = -EAGAIN;
+
+		up_read(&umhelper_sem);
+
+		if (ret)
+			break;
+
+		schedule();
+		try_to_freeze();
+
+		down_read(&umhelper_sem);
+	}
+	finish_wait(&usermodehelper_disabled_waitq, &wait);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(usermodehelper_read_trylock);
+
+long usermodehelper_read_lock_wait(long timeout)
+{
+	DEFINE_WAIT(wait);
+
+	if (timeout < 0)
+		return -EINVAL;
+
+	down_read(&umhelper_sem);
+	for (;;) {
+		prepare_to_wait(&usermodehelper_disabled_waitq, &wait,
+				TASK_UNINTERRUPTIBLE);
+		if (!usermodehelper_disabled)
+			break;
+
+		up_read(&umhelper_sem);
+
+		timeout = schedule_timeout(timeout);
+		if (!timeout)
+			break;
+
+		down_read(&umhelper_sem);
+	}
+	finish_wait(&usermodehelper_disabled_waitq, &wait);
+	return timeout;
+}
+EXPORT_SYMBOL_GPL(usermodehelper_read_lock_wait);
+
+void usermodehelper_read_unlock(void)
+{
+	up_read(&umhelper_sem);
+}
+EXPORT_SYMBOL_GPL(usermodehelper_read_unlock);
+
+/**
+ * __usermodehelper_set_disable_depth - Modify usermodehelper_disabled.
+ * @depth: New value to assign to usermodehelper_disabled.
+ *
+ * Change the value of usermodehelper_disabled (under umhelper_sem locked for
+ * writing) and wakeup tasks waiting for it to change.
+ */
+void __usermodehelper_set_disable_depth(enum umh_disable_depth depth)
+{
+	down_write(&umhelper_sem);
+	usermodehelper_disabled = depth;
+	wake_up(&usermodehelper_disabled_waitq);
+	up_write(&umhelper_sem);
+}
+
+/**
+ * __usermodehelper_disable - Prevent new helpers from being started.
+ * @depth: New value to assign to usermodehelper_disabled.
+ *
+ * Set usermodehelper_disabled to @depth and wait for running helpers to exit.
+ */
+int __usermodehelper_disable(enum umh_disable_depth depth)
+{
+	long retval;
+
+	if (!depth)
+		return -EINVAL;
+
+	down_write(&umhelper_sem);
+	usermodehelper_disabled = depth;
+	up_write(&umhelper_sem);
+
+	/*
+	 * From now on call_usermodehelper_exec() won't start any new
+	 * helpers, so it is sufficient if running_helpers turns out to
+	 * be zero at one point (it may be increased later, but that
+	 * doesn't matter).
+	 */
+	retval = wait_event_timeout(running_helpers_waitq,
+					atomic_read(&running_helpers) == 0,
+					RUNNING_HELPERS_TIMEOUT);
+	if (retval)
+		return 0;
+
+	__usermodehelper_set_disable_depth(UMH_ENABLED);
+	return -EAGAIN;
+}
+
+static void helper_lock(void)
+{
+	atomic_inc(&running_helpers);
+	smp_mb__after_atomic();
+}
+
+static void helper_unlock(void)
+{
+	if (atomic_dec_and_test(&running_helpers))
+		wake_up(&running_helpers_waitq);
+}
+
+/**
+ * call_usermodehelper_setup - prepare to call a usermode helper
+ * @path: path to usermode executable
+ * @argv: arg vector for process
+ * @envp: environment for process
+ * @gfp_mask: gfp mask for memory allocation
+ * @cleanup: a cleanup function
+ * @init: an init function
+ * @data: arbitrary context sensitive data
+ *
+ * Returns either %NULL on allocation failure, or a subprocess_info
+ * structure.  This should be passed to call_usermodehelper_exec to
+ * exec the process and free the structure.
+ *
+ * The init function is used to customize the helper process prior to
+ * exec.  A non-zero return code causes the process to error out, exit,
+ * and return the failure to the calling process
+ *
+ * The cleanup function is just before ethe subprocess_info is about to
+ * be freed.  This can be used for freeing the argv and envp.  The
+ * Function must be runnable in either a process context or the
+ * context in which call_usermodehelper_exec is called.
+ */
+struct subprocess_info *call_usermodehelper_setup(const char *path, char **argv,
+		char **envp, gfp_t gfp_mask,
+		int (*init)(struct subprocess_info *info, struct cred *new),
+		void (*cleanup)(struct subprocess_info *info),
+		void *data)
+{
+	struct subprocess_info *sub_info;
+	sub_info = kzalloc(sizeof(struct subprocess_info), gfp_mask);
+	if (!sub_info)
+		goto out;
+
+	INIT_WORK(&sub_info->work, call_usermodehelper_exec_work);
+
+#ifdef CONFIG_STATIC_USERMODEHELPER
+	sub_info->path = CONFIG_STATIC_USERMODEHELPER_PATH;
+#else
+	sub_info->path = path;
+#endif
+	sub_info->argv = argv;
+	sub_info->envp = envp;
+
+	sub_info->cleanup = cleanup;
+	sub_info->init = init;
+	sub_info->data = data;
+  out:
+	return sub_info;
+}
+EXPORT_SYMBOL(call_usermodehelper_setup);
+
+/**
+ * call_usermodehelper_exec - start a usermode application
+ * @sub_info: information about the subprocessa
+ * @wait: wait for the application to finish and return status.
+ *        when UMH_NO_WAIT don't wait at all, but you get no useful error back
+ *        when the program couldn't be exec'ed. This makes it safe to call
+ *        from interrupt context.
+ *
+ * Runs a user-space application.  The application is started
+ * asynchronously if wait is not set, and runs as a child of system workqueues.
+ * (ie. it runs with full root capabilities and optimized affinity).
+ */
+int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
+{
+	DECLARE_COMPLETION_ONSTACK(done);
+	int retval = 0;
+
+	if (!sub_info->path) {
+		call_usermodehelper_freeinfo(sub_info);
+		return -EINVAL;
+	}
+	helper_lock();
+	if (usermodehelper_disabled) {
+		retval = -EBUSY;
+		goto out;
+	}
+
+	/*
+	 * If there is no binary for us to call, then just return and get out of
+	 * here.  This allows us to set STATIC_USERMODEHELPER_PATH to "" and
+	 * disable all call_usermodehelper() calls.
+	 */
+	if (strlen(sub_info->path) == 0)
+		goto out;
+
+	/*
+	 * Set the completion pointer only if there is a waiter.
+	 * This makes it possible to use umh_complete to free
+	 * the data structure in case of UMH_NO_WAIT.
+	 */
+	sub_info->complete = (wait == UMH_NO_WAIT) ? NULL : &done;
+	sub_info->wait = wait;
+
+	queue_work(system_unbound_wq, &sub_info->work);
+	if (wait == UMH_NO_WAIT)	/* task has freed sub_info */
+		goto unlock;
+
+	if (wait & UMH_KILLABLE) {
+		retval = wait_for_completion_killable(&done);
+		if (!retval)
+			goto wait_done;
+
+		/* umh_complete() will see NULL and free sub_info */
+		if (xchg(&sub_info->complete, NULL))
+			goto unlock;
+		/* fallthrough, umh_complete() was already called */
+	}
+
+	wait_for_completion(&done);
+wait_done:
+	retval = sub_info->retval;
+out:
+	call_usermodehelper_freeinfo(sub_info);
+unlock:
+	helper_unlock();
+	return retval;
+}
+EXPORT_SYMBOL(call_usermodehelper_exec);
+
+/**
+ * call_usermodehelper() - prepare and start a usermode application
+ * @path: path to usermode executable
+ * @argv: arg vector for process
+ * @envp: environment for process
+ * @wait: wait for the application to finish and return status.
+ *        when UMH_NO_WAIT don't wait at all, but you get no useful error back
+ *        when the program couldn't be exec'ed. This makes it safe to call
+ *        from interrupt context.
+ *
+ * This function is the equivalent to use call_usermodehelper_setup() and
+ * call_usermodehelper_exec().
+ */
+int call_usermodehelper(const char *path, char **argv, char **envp, int wait)
+{
+	struct subprocess_info *info;
+	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
+
+	info = call_usermodehelper_setup(path, argv, envp, gfp_mask,
+					 NULL, NULL, NULL);
+	if (info == NULL)
+		return -ENOMEM;
+
+	return call_usermodehelper_exec(info, wait);
+}
+EXPORT_SYMBOL(call_usermodehelper);
+
+static int proc_cap_handler(struct ctl_table *table, int write,
+			 void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table t;
+	unsigned long cap_array[_KERNEL_CAPABILITY_U32S];
+	kernel_cap_t new_cap;
+	int err, i;
+
+	if (write && (!capable(CAP_SETPCAP) ||
+		      !capable(CAP_SYS_MODULE)))
+		return -EPERM;
+
+	/*
+	 * convert from the global kernel_cap_t to the ulong array to print to
+	 * userspace if this is a read.
+	 */
+	spin_lock(&umh_sysctl_lock);
+	for (i = 0; i < _KERNEL_CAPABILITY_U32S; i++)  {
+		if (table->data == CAP_BSET)
+			cap_array[i] = usermodehelper_bset.cap[i];
+		else if (table->data == CAP_PI)
+			cap_array[i] = usermodehelper_inheritable.cap[i];
+		else
+			BUG();
+	}
+	spin_unlock(&umh_sysctl_lock);
+
+	t = *table;
+	t.data = &cap_array;
+
+	/*
+	 * actually read or write and array of ulongs from userspace.  Remember
+	 * these are least significant 32 bits first
+	 */
+	err = proc_doulongvec_minmax(&t, write, buffer, lenp, ppos);
+	if (err < 0)
+		return err;
+
+	/*
+	 * convert from the sysctl array of ulongs to the kernel_cap_t
+	 * internal representation
+	 */
+	for (i = 0; i < _KERNEL_CAPABILITY_U32S; i++)
+		new_cap.cap[i] = cap_array[i];
+
+	/*
+	 * Drop everything not in the new_cap (but don't add things)
+	 */
+	spin_lock(&umh_sysctl_lock);
+	if (write) {
+		if (table->data == CAP_BSET)
+			usermodehelper_bset = cap_intersect(usermodehelper_bset, new_cap);
+		if (table->data == CAP_PI)
+			usermodehelper_inheritable = cap_intersect(usermodehelper_inheritable, new_cap);
+	}
+	spin_unlock(&umh_sysctl_lock);
+
+	return 0;
+}
+
+struct ctl_table usermodehelper_table[] = {
+	{
+		.procname	= "bset",
+		.data		= CAP_BSET,
+		.maxlen		= _KERNEL_CAPABILITY_U32S * sizeof(unsigned long),
+		.mode		= 0600,
+		.proc_handler	= proc_cap_handler,
+	},
+	{
+		.procname	= "inheritable",
+		.data		= CAP_PI,
+		.maxlen		= _KERNEL_CAPABILITY_U32S * sizeof(unsigned long),
+		.mode		= 0600,
+		.proc_handler	= proc_cap_handler,
+	},
+	{ }
+};
_
