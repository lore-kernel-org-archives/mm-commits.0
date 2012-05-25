From: akpm@linux-foundation.org
Subject: [merged] keys-change-keyctl_session_to_parent-to-use-task_work_add.patch removed from -mm tree
Date: Fri, 25 May 2012 13:48:36 -0700
Message-ID: <20120525204836.A1E0EA00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:40388 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934093Ab2EYUsi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 May 2012 16:48:38 -0400
Received: by ggeh3 with SMTP id h3so150017gge.1
        for <mm-commits@vger.kernel.org>; Fri, 25 May 2012 13:48:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, agordeev@redhat.com, chris@zankel.net, dhowells@redhat.com, dsmith@redhat.com, fche@redhat.com, geert@linux-m68k.org, lwoodman@redhat.com, mingo@elte.hu, peterz@infradead.org, rkuo@codeaurora.org, tglx@linutronix.de, tj@kernel.org, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: keys: change keyctl_session_to_parent() to use task_work_add()
has been removed from the -mm tree.  Its filename was
     keys-change-keyctl_session_to_parent-to-use-task_work_add.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: keys: change keyctl_session_to_parent() to use task_work_add()

Change keyctl_session_to_parent() to use task_work_add() and move
key_replace_session_keyring() logic into task_work->func().

Note that we do task_work_cancel() before task_work_add() to ensure that
only one work can be pending at any time.  This is important, we must not
allow user-space to abuse the parent's ->task_works list.

The callback, replace_session_keyring(), checks PF_EXITING.  I guess this
is not really needed but looks better.

As a side effect, this fixes the (unlikely) race.  The callers of
key_replace_session_keyring() and keyctl_session_to_parent() lack the
necessary barriers, the parent can miss the request.

Now we can remove task_struct->replacement_session_keyring and related
code.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Gordeev <agordeev@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Smith <dsmith@redhat.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/key.h          |    6 --
 security/keys/internal.h     |    2 
 security/keys/keyctl.c       |   73 +++++++++++++++------------------
 security/keys/process_keys.c |   20 +++------
 4 files changed, 46 insertions(+), 55 deletions(-)

diff -puN include/linux/key.h~keys-change-keyctl_session_to_parent-to-use-task_work_add include/linux/key.h
--- a/include/linux/key.h~keys-change-keyctl_session_to_parent-to-use-task_work_add
+++ a/include/linux/key.h
@@ -33,6 +33,8 @@ typedef uint32_t key_perm_t;
 
 struct key;
 
+#define key_replace_session_keyring()	do { } while (0)
+
 #ifdef CONFIG_KEYS
 
 #undef KEY_DEBUGGING
@@ -302,9 +304,6 @@ static inline bool key_is_instantiated(c
 #ifdef CONFIG_SYSCTL
 extern ctl_table key_sysctls[];
 #endif
-
-extern void key_replace_session_keyring(void);
-
 /*
  * the userspace interface
  */
@@ -327,7 +326,6 @@ extern void key_init(void);
 #define key_fsuid_changed(t)		do { } while(0)
 #define key_fsgid_changed(t)		do { } while(0)
 #define key_init()			do { } while(0)
-#define key_replace_session_keyring()	do { } while(0)
 
 #endif /* CONFIG_KEYS */
 #endif /* __KERNEL__ */
diff -puN security/keys/internal.h~keys-change-keyctl_session_to_parent-to-use-task_work_add security/keys/internal.h
--- a/security/keys/internal.h~keys-change-keyctl_session_to_parent-to-use-task_work_add
+++ a/security/keys/internal.h
@@ -14,6 +14,7 @@
 
 #include <linux/sched.h>
 #include <linux/key-type.h>
+#include <linux/task_work.h>
 
 #ifdef __KDEBUG
 #define kenter(FMT, ...) \
@@ -148,6 +149,7 @@ extern key_ref_t lookup_user_key(key_ser
 #define KEY_LOOKUP_FOR_UNLINK	0x04
 
 extern long join_session_keyring(const char *name);
+extern void key_change_session_keyring(struct task_work *twork);
 
 extern struct work_struct key_gc_work;
 extern unsigned key_gc_delay;
diff -puN security/keys/keyctl.c~keys-change-keyctl_session_to_parent-to-use-task_work_add security/keys/keyctl.c
--- a/security/keys/keyctl.c~keys-change-keyctl_session_to_parent-to-use-task_work_add
+++ a/security/keys/keyctl.c
@@ -1423,50 +1423,57 @@ long keyctl_get_security(key_serial_t ke
  */
 long keyctl_session_to_parent(void)
 {
-#ifdef TIF_NOTIFY_RESUME
 	struct task_struct *me, *parent;
 	const struct cred *mycred, *pcred;
-	struct cred *cred, *oldcred;
+	struct task_work *newwork, *oldwork;
 	key_ref_t keyring_r;
+	struct cred *cred;
 	int ret;
 
 	keyring_r = lookup_user_key(KEY_SPEC_SESSION_KEYRING, 0, KEY_LINK);
 	if (IS_ERR(keyring_r))
 		return PTR_ERR(keyring_r);
 
+	ret = -ENOMEM;
+	newwork = kmalloc(sizeof(struct task_work), GFP_KERNEL);
+	if (!newwork)
+		goto error_keyring;
+
 	/* our parent is going to need a new cred struct, a new tgcred struct
 	 * and new security data, so we allocate them here to prevent ENOMEM in
 	 * our parent */
-	ret = -ENOMEM;
 	cred = cred_alloc_blank();
 	if (!cred)
-		goto error_keyring;
+		goto error_newwork;
 
 	cred->tgcred->session_keyring = key_ref_to_ptr(keyring_r);
-	keyring_r = NULL;
+	init_task_work(newwork, key_change_session_keyring, cred);
 
 	me = current;
 	rcu_read_lock();
 	write_lock_irq(&tasklist_lock);
 
-	parent = me->real_parent;
 	ret = -EPERM;
+	oldwork = NULL;
+	parent = me->real_parent;
 
 	/* the parent mustn't be init and mustn't be a kernel thread */
 	if (parent->pid <= 1 || !parent->mm)
-		goto not_permitted;
+		goto unlock;
 
 	/* the parent must be single threaded */
 	if (!thread_group_empty(parent))
-		goto not_permitted;
+		goto unlock;
 
 	/* the parent and the child must have different session keyrings or
 	 * there's no point */
 	mycred = current_cred();
 	pcred = __task_cred(parent);
 	if (mycred == pcred ||
-	    mycred->tgcred->session_keyring == pcred->tgcred->session_keyring)
-		goto already_same;
+	    mycred->tgcred->session_keyring == pcred->tgcred->session_keyring) {
+		ret = 0;
+		goto unlock;
+	}
 
 	/* the parent must have the same effective ownership and mustn't be
 	 * SUID/SGID */
@@ -1476,50 +1483,40 @@ long keyctl_session_to_parent(void)
 	    pcred->gid	!= mycred->egid	||
 	    pcred->egid	!= mycred->egid	||
 	    pcred->sgid	!= mycred->egid)
-		goto not_permitted;
+		goto unlock;
 
 	/* the keyrings must have the same UID */
 	if ((pcred->tgcred->session_keyring &&
 	     pcred->tgcred->session_keyring->uid != mycred->euid) ||
 	    mycred->tgcred->session_keyring->uid != mycred->euid)
-		goto not_permitted;
+		goto unlock;
 
-	/* if there's an already pending keyring replacement, then we replace
-	 * that */
-	oldcred = parent->replacement_session_keyring;
+	/* cancel an already pending keyring replacement */
+	oldwork = task_work_cancel(parent, key_change_session_keyring);
 
 	/* the replacement session keyring is applied just prior to userspace
 	 * restarting */
-	parent->replacement_session_keyring = cred;
-	cred = NULL;
-	set_ti_thread_flag(task_thread_info(parent), TIF_NOTIFY_RESUME);
-
-	write_unlock_irq(&tasklist_lock);
-	rcu_read_unlock();
-	if (oldcred)
-		put_cred(oldcred);
-	return 0;
-
-already_same:
-	ret = 0;
-not_permitted:
+	ret = task_work_add(parent, newwork, true);
+	if (!ret)
+		newwork = NULL;
+unlock:
 	write_unlock_irq(&tasklist_lock);
 	rcu_read_unlock();
-	put_cred(cred);
+	if (oldwork) {
+		put_cred(oldwork->data);
+		kfree(oldwork);
+	}
+	if (newwork) {
+		put_cred(newwork->data);
+		kfree(newwork);
+	}
 	return ret;
 
+error_newwork:
+	kfree(newwork);
 error_keyring:
 	key_ref_put(keyring_r);
 	return ret;
-
-#else /* !TIF_NOTIFY_RESUME */
-	/*
-	 * To be removed when TIF_NOTIFY_RESUME has been implemented on
-	 * m68k/xtensa
-	 */
-#warning TIF_NOTIFY_RESUME not implemented
-	return -EOPNOTSUPP;
-#endif /* !TIF_NOTIFY_RESUME */
 }
 
 /*
diff -puN security/keys/process_keys.c~keys-change-keyctl_session_to_parent-to-use-task_work_add security/keys/process_keys.c
--- a/security/keys/process_keys.c~keys-change-keyctl_session_to_parent-to-use-task_work_add
+++ a/security/keys/process_keys.c
@@ -832,23 +832,17 @@ error:
  * Replace a process's session keyring on behalf of one of its children when
  * the target  process is about to resume userspace execution.
  */
-void key_replace_session_keyring(void)
+void key_change_session_keyring(struct task_work *twork)
 {
-	const struct cred *old;
-	struct cred *new;
+	const struct cred *old = current_cred();
+	struct cred *new = twork->data;
 
-	if (!current->replacement_session_keyring)
+	kfree(twork);
+	if (unlikely(current->flags & PF_EXITING)) {
+		put_cred(new);
 		return;
+	}
 
-	write_lock_irq(&tasklist_lock);
-	new = current->replacement_session_keyring;
-	current->replacement_session_keyring = NULL;
-	write_unlock_irq(&tasklist_lock);
-
-	if (!new)
-		return;
-
-	old = current_cred();
 	new->  uid	= old->  uid;
 	new-> euid	= old-> euid;
 	new-> suid	= old-> suid;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
mm-fork-fix-overflow-in-vma-length-when-copying-mmap-on-clone.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
kmod-unexport-call_usermodehelper_freeinfo.patch
kmod-convert-two-call-sites-to-call_usermodehelper_fns.patch
kmod-move-call_usermodehelper_fns-to-c-file-and-unexport-all-its-helpers.patch
cred-remove-task_is_dead-from-__task_cred-validation.patch
stack-usage-add-pid-to-warning-printk-in-check_stack_usage.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-use-is_err_or_null.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
cpu-introduce-clear_tasks_mm_cpumask-helper.patch
arm-use-clear_tasks_mm_cpumask.patch
powerpc-use-clear_tasks_mm_cpumask.patch
sh-use-clear_tasks_mm_cpumask.patch
blackfin-a-couple-of-task-mm-handling-fixes.patch
blackfin-fix-possible-deadlock-in-decode_address.patch
um-should-hold-tasklist_lock-while-traversing-processes.patch
um-fix-possible-race-on-task-mm.patch
um-properly-check-all-process-threads-for-a-live-mm.patch
pidns-use-task_active_pid_ns-in-do_notify_parent.patch
pidns-make-killed-children-autoreap.patch
pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2.patch
pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2-fix.patch
aio-vfs-cleanup-of-rw_copy_check_uvector-and-compat_rw_copy_check_uvector.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9-fix.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment.patch

