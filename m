From: akpm@linux-foundation.org
Subject: + umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init.patch added to -mm tree
Date: Fri, 19 Mar 2010 15:06:46 -0700
Message-ID: <201003192206.o2JM6lHZ015031@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751228Ab0CSWHH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 18:07:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, dhowells@redhat.com, nhorman@tuxdriver.com


The patch titled
     umh: creds: convert call_usermodehelper_keys() to use subprocess_info->init()
has been added to the -mm tree.  Its filename is
     umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init.patch

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
Subject: umh: creds: convert call_usermodehelper_keys() to use subprocess_info->init()
From: Oleg Nesterov <oleg@redhat.com>

call_usermodehelper_keys() uses call_usermodehelper_setkeys() to change
subprocess_info->cred in advance.  Now that we have info->init() we can
change this code to set tgcred->session_keyring in context of execing
kernel thread.

Note: since currently call_usermodehelper_keys() is never called with
UMH_NO_WAIT, call_usermodehelper_keys()->key_get() and umh_keys_cleanup()
are not really needed, we could rely on install_session_keyring_to_cred()
which does key_get() on success.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmod.h         |   17 -----------------
 kernel/kmod.c                |   18 ------------------
 security/keys/internal.h     |    1 +
 security/keys/process_keys.c |    3 +--
 security/keys/request_key.c  |   32 ++++++++++++++++++++++++++++++++
 5 files changed, 34 insertions(+), 37 deletions(-)

diff -puN include/linux/kmod.h~umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init include/linux/kmod.h
--- a/include/linux/kmod.h~umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init
+++ a/include/linux/kmod.h
@@ -72,8 +72,6 @@ struct subprocess_info *call_usermodehel
 						  char **envp, gfp_t gfp_mask);
 
 /* Set various pieces of state into the subprocess_info structure */
-void call_usermodehelper_setkeys(struct subprocess_info *info,
-				 struct key *session_keyring);
 void call_usermodehelper_setfns(struct subprocess_info *info,
 		    int (*init)(struct subprocess_info *info),
 		    void (*cleanup)(struct subprocess_info *info),
@@ -112,21 +110,6 @@ call_usermodehelper(char *path, char **a
 				       NULL, NULL, NULL);
 }
 
-static inline int
-call_usermodehelper_keys(char *path, char **argv, char **envp,
-			 struct key *session_keyring, enum umh_wait wait)
-{
-	struct subprocess_info *info;
-	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
-
-	info = call_usermodehelper_setup(path, argv, envp, gfp_mask);
-	if (info == NULL)
-		return -ENOMEM;
-
-	call_usermodehelper_setkeys(info, session_keyring);
-	return call_usermodehelper_exec(info, wait);
-}
-
 extern void usermodehelper_init(void);
 
 extern int usermodehelper_disable(void);
diff -puN kernel/kmod.c~umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init kernel/kmod.c
--- a/kernel/kmod.c~umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init
+++ a/kernel/kmod.c
@@ -367,24 +367,6 @@ struct subprocess_info *call_usermodehel
 EXPORT_SYMBOL(call_usermodehelper_setup);
 
 /**
- * call_usermodehelper_setkeys - set the session keys for usermode helper
- * @info: a subprocess_info returned by call_usermodehelper_setup
- * @session_keyring: the session keyring for the process
- */
-void call_usermodehelper_setkeys(struct subprocess_info *info,
-				 struct key *session_keyring)
-{
-#ifdef CONFIG_KEYS
-	struct thread_group_cred *tgcred = info->cred->tgcred;
-	key_put(tgcred->session_keyring);
-	tgcred->session_keyring = key_get(session_keyring);
-#else
-	BUG();
-#endif
-}
-EXPORT_SYMBOL(call_usermodehelper_setkeys);
-
-/**
  * call_usermodehelper_setfns - set a cleanup/init function
  * @info: a subprocess_info returned by call_usermodehelper_setup
  * @cleanup: a cleanup function
diff -puN security/keys/internal.h~umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init security/keys/internal.h
--- a/security/keys/internal.h~umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init
+++ a/security/keys/internal.h
@@ -115,6 +115,7 @@ extern struct key *find_keyring_by_name(
 extern int install_user_keyrings(void);
 extern int install_thread_keyring_to_cred(struct cred *);
 extern int install_process_keyring_to_cred(struct cred *);
+extern int install_session_keyring_to_cred(struct cred *, struct key *);
 
 extern struct key *request_key_and_link(struct key_type *type,
 					const char *description,
diff -puN security/keys/process_keys.c~umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init security/keys/process_keys.c
--- a/security/keys/process_keys.c~umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init
+++ a/security/keys/process_keys.c
@@ -217,8 +217,7 @@ static int install_process_keyring(void)
 /*
  * install a session keyring directly to a credentials struct
  */
-static int install_session_keyring_to_cred(struct cred *cred,
-					   struct key *keyring)
+int install_session_keyring_to_cred(struct cred *cred, struct key *keyring)
 {
 	unsigned long flags;
 	struct key *old;
diff -puN security/keys/request_key.c~umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init security/keys/request_key.c
--- a/security/keys/request_key.c~umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init
+++ a/security/keys/request_key.c
@@ -58,6 +58,38 @@ void complete_request_key(struct key_con
 }
 EXPORT_SYMBOL(complete_request_key);
 
+static int umh_keys_init(struct subprocess_info *info)
+{
+	struct cred *cred = (struct cred*)current_cred();
+	struct key *keyring = info->data;
+	/*
+	 * This is called in context of freshly forked kthread before
+	 * kernel_execve(), we can just change our ->session_keyring.
+	 */
+	return install_session_keyring_to_cred(cred, keyring);
+}
+
+static void umh_keys_cleanup(struct subprocess_info *info)
+{
+	struct key *keyring = info->data;
+	key_put(keyring);
+}
+
+static int call_usermodehelper_keys(char *path, char **argv, char **envp,
+			 struct key *session_keyring, enum umh_wait wait)
+{
+	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
+	struct subprocess_info *info =
+		call_usermodehelper_setup(path, argv, envp, gfp_mask);
+
+	if (!info)
+		return -ENOMEM;
+
+	call_usermodehelper_setfns(info, umh_keys_init, umh_keys_cleanup,
+					key_get(session_keyring));
+	return call_usermodehelper_exec(info, wait);
+}
+
 /*
  * request userspace finish the construction of a key
  * - execute "/sbin/request-key <op> <key> <uid> <gid> <keyring> <keyring> <keyring>"
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

