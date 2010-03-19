From: akpm@linux-foundation.org
Subject: + umh-creds-kill-subprocess_info-cred-logic.patch added to -mm tree
Date: Fri, 19 Mar 2010 15:06:48 -0700
Message-ID: <201003192206.o2JM6mba015034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751370Ab0CSWHJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 18:07:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, dhowells@redhat.com, nhorman@tuxdriver.com


The patch titled
     umh: creds: kill subprocess_info->cred logic
has been added to the -mm tree.  Its filename is
     umh-creds-kill-subprocess_info-cred-logic.patch

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
Subject: umh: creds: kill subprocess_info->cred logic
From: Oleg Nesterov <oleg@redhat.com>

Now that nobody ever changes subprocess_info->cred we can kill this member
and related code.  ____call_usermodehelper() always runs in the context of
freshly forked kernel thread, it has the proper ->cred copied from its
parent kthread, keventd.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cred.h |    1 
 include/linux/kmod.h |    1 
 kernel/cred.c        |   54 -----------------------------------------
 kernel/kmod.c        |   19 --------------
 4 files changed, 75 deletions(-)

diff -puN include/linux/cred.h~umh-creds-kill-subprocess_info-cred-logic include/linux/cred.h
--- a/include/linux/cred.h~umh-creds-kill-subprocess_info-cred-logic
+++ a/include/linux/cred.h
@@ -156,7 +156,6 @@ extern int copy_creds(struct task_struct
 extern struct cred *cred_alloc_blank(void);
 extern struct cred *prepare_creds(void);
 extern struct cred *prepare_exec_creds(void);
-extern struct cred *prepare_usermodehelper_creds(void);
 extern int commit_creds(struct cred *);
 extern void abort_creds(struct cred *);
 extern const struct cred *override_creds(const struct cred *);
diff -puN include/linux/kmod.h~umh-creds-kill-subprocess_info-cred-logic include/linux/kmod.h
--- a/include/linux/kmod.h~umh-creds-kill-subprocess_info-cred-logic
+++ a/include/linux/kmod.h
@@ -56,7 +56,6 @@ enum umh_wait {
 struct subprocess_info {
 	struct work_struct work;
 	struct completion *complete;
-	struct cred *cred;
 	char *path;
 	char **argv;
 	char **envp;
diff -puN kernel/cred.c~umh-creds-kill-subprocess_info-cred-logic kernel/cred.c
--- a/kernel/cred.c~umh-creds-kill-subprocess_info-cred-logic
+++ a/kernel/cred.c
@@ -347,60 +347,6 @@ struct cred *prepare_exec_creds(void)
 }
 
 /*
- * prepare new credentials for the usermode helper dispatcher
- */
-struct cred *prepare_usermodehelper_creds(void)
-{
-#ifdef CONFIG_KEYS
-	struct thread_group_cred *tgcred = NULL;
-#endif
-	struct cred *new;
-
-#ifdef CONFIG_KEYS
-	tgcred = kzalloc(sizeof(*new->tgcred), GFP_ATOMIC);
-	if (!tgcred)
-		return NULL;
-#endif
-
-	new = kmem_cache_alloc(cred_jar, GFP_ATOMIC);
-	if (!new)
-		return NULL;
-
-	kdebug("prepare_usermodehelper_creds() alloc %p", new);
-
-	memcpy(new, &init_cred, sizeof(struct cred));
-
-	atomic_set(&new->usage, 1);
-	set_cred_subscribers(new, 0);
-	get_group_info(new->group_info);
-	get_uid(new->user);
-
-#ifdef CONFIG_KEYS
-	new->thread_keyring = NULL;
-	new->request_key_auth = NULL;
-	new->jit_keyring = KEY_REQKEY_DEFL_DEFAULT;
-
-	atomic_set(&tgcred->usage, 1);
-	spin_lock_init(&tgcred->lock);
-	new->tgcred = tgcred;
-#endif
-
-#ifdef CONFIG_SECURITY
-	new->security = NULL;
-#endif
-	if (security_prepare_creds(new, &init_cred, GFP_ATOMIC) < 0)
-		goto error;
-	validate_creds(new);
-
-	BUG_ON(atomic_read(&new->usage) != 1);
-	return new;
-
-error:
-	put_cred(new);
-	return NULL;
-}
-
-/*
  * Copy credentials for the new process created by fork()
  *
  * We share if we can, but under some circumstances we have to generate a new
diff -puN kernel/kmod.c~umh-creds-kill-subprocess_info-cred-logic kernel/kmod.c
--- a/kernel/kmod.c~umh-creds-kill-subprocess_info-cred-logic
+++ a/kernel/kmod.c
@@ -134,8 +134,6 @@ static int ____call_usermodehelper(void 
 	struct subprocess_info *sub_info = data;
 	int retval;
 
-	BUG_ON(atomic_read(&sub_info->cred->usage) != 1);
-
 	/* Unblock all signals */
 	spin_lock_irq(&current->sighand->siglock);
 	flush_signal_handlers(current, 1);
@@ -143,10 +141,6 @@ static int ____call_usermodehelper(void 
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 
-	/* Install the credentials */
-	commit_creds(sub_info->cred);
-	sub_info->cred = NULL;
-
 	/* We can run anywhere, unlike our parent keventd(). */
 	set_cpus_allowed_ptr(current, cpu_all_mask);
 
@@ -174,8 +168,6 @@ void call_usermodehelper_freeinfo(struct
 {
 	if (info->cleanup)
 		(*info->cleanup)(info);
-	if (info->cred)
-		put_cred(info->cred);
 	kfree(info);
 }
 EXPORT_SYMBOL(call_usermodehelper_freeinfo);
@@ -231,8 +223,6 @@ static void __call_usermodehelper(struct
 	pid_t pid;
 	enum umh_wait wait = sub_info->wait;
 
-	BUG_ON(atomic_read(&sub_info->cred->usage) != 1);
-
 	/* CLONE_VFORK: wait until the usermode helper has execve'd
 	 * successfully We need the data structures to stay around
 	 * until that is done.  */
@@ -355,12 +345,6 @@ struct subprocess_info *call_usermodehel
 	sub_info->path = path;
 	sub_info->argv = argv;
 	sub_info->envp = envp;
-	sub_info->cred = prepare_usermodehelper_creds();
-	if (!sub_info->cred) {
-		kfree(sub_info);
-		return NULL;
-	}
-
   out:
 	return sub_info;
 }
@@ -411,9 +395,6 @@ int call_usermodehelper_exec(struct subp
 	DECLARE_COMPLETION_ONSTACK(done);
 	int retval = 0;
 
-	BUG_ON(atomic_read(&sub_info->cred->usage) != 1);
-	validate_creds(sub_info->cred);
-
 	helper_lock();
 	if (sub_info->path[0] == '\0')
 		goto out;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch
cpu-timers-simplify-rlimit_cpu-handling.patch
cpu-timers-cleanup-arm_timer.patch
cpu-timers-return-correct-previous-timer-reload-value.patch
cpu-timers-change-sigev_none-timer-implementation.patch
cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check.patch
cpu-timers-optimize-run_posix_cpu_timers.patch
proc-cleanup-remove-unused-assignments.patch
kmod-add-init-function-to-usermodehelper.patch
exec-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch
umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init.patch
umh-creds-kill-subprocess_info-cred-logic.patch
call_usermodehelper-no-need-to-unblock-signals.patch
wait_for_helper-sigchld-from-user-space-can-lead-to-use-after-free.patch
call_usermodehelper-simplify-fix-umh_no_wait-case.patch
call_usermodehelper-umh_wait_exec-ignores-kernel_thread-failure.patch

