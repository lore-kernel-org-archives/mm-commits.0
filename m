From: akpm@linux-foundation.org
Subject: [merged] usermodehelper-kill-umh_wait-renumber-umh_-constants.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:32:30 -0700
Message-ID: <20120326193230.7EF3DA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:58080 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802Ab2CZTcb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:32:31 -0400
Received: by mail-gx0-f202.google.com with SMTP id d2so830938ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:32:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, rusty@rustcorp.com.au, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: usermodehelper: kill umh_wait, renumber UMH_* constants
has been removed from the -mm tree.  Its filename was
     usermodehelper-kill-umh_wait-renumber-umh_-constants.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: usermodehelper: kill umh_wait, renumber UMH_* constants

No functional changes.  It is not sane to use UMH_KILLABLE with enum
umh_wait, but obviously we do not want another argument in
call_usermodehelper_* helpers.  Kill this enum, use the plain int.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmod.h        |   18 +++++++-----------
 kernel/kmod.c               |    8 ++------
 security/keys/request_key.c |    2 +-
 3 files changed, 10 insertions(+), 18 deletions(-)

diff -puN include/linux/kmod.h~usermodehelper-kill-umh_wait-renumber-umh_-constants include/linux/kmod.h
--- a/include/linux/kmod.h~usermodehelper-kill-umh_wait-renumber-umh_-constants
+++ a/include/linux/kmod.h
@@ -48,12 +48,9 @@ static inline int request_module_nowait(
 struct cred;
 struct file;
 
-enum umh_wait {
-	UMH_NO_WAIT = -1,	/* don't wait at all */
-	UMH_WAIT_EXEC = 0,	/* wait for the exec, but not the process */
-	UMH_WAIT_PROC = 1,	/* wait for the process to complete */
-};
-
+#define UMH_NO_WAIT	0	/* don't wait at all */
+#define UMH_WAIT_EXEC	1	/* wait for the exec, but not the process */
+#define UMH_WAIT_PROC	2	/* wait for the process to complete */
 #define UMH_KILLABLE	4	/* wait for EXEC/PROC killable */
 
 struct subprocess_info {
@@ -62,7 +59,7 @@ struct subprocess_info {
 	char *path;
 	char **argv;
 	char **envp;
-	enum umh_wait wait;
+	int wait;
 	int retval;
 	int (*init)(struct subprocess_info *info, struct cred *new);
 	void (*cleanup)(struct subprocess_info *info);
@@ -80,15 +77,14 @@ void call_usermodehelper_setfns(struct s
 		    void *data);
 
 /* Actually execute the sub-process */
-int call_usermodehelper_exec(struct subprocess_info *info, enum umh_wait wait);
+int call_usermodehelper_exec(struct subprocess_info *info, int wait);
 
 /* Free the subprocess_info. This is only needed if you're not going
    to call call_usermodehelper_exec */
 void call_usermodehelper_freeinfo(struct subprocess_info *info);
 
 static inline int
-call_usermodehelper_fns(char *path, char **argv, char **envp,
-			enum umh_wait wait,
+call_usermodehelper_fns(char *path, char **argv, char **envp, int wait,
 			int (*init)(struct subprocess_info *info, struct cred *new),
 			void (*cleanup)(struct subprocess_info *), void *data)
 {
@@ -106,7 +102,7 @@ call_usermodehelper_fns(char *path, char
 }
 
 static inline int
-call_usermodehelper(char *path, char **argv, char **envp, enum umh_wait wait)
+call_usermodehelper(char *path, char **argv, char **envp, int wait)
 {
 	return call_usermodehelper_fns(path, argv, envp, wait,
 				       NULL, NULL, NULL);
diff -puN kernel/kmod.c~usermodehelper-kill-umh_wait-renumber-umh_-constants kernel/kmod.c
--- a/kernel/kmod.c~usermodehelper-kill-umh_wait-renumber-umh_-constants
+++ a/kernel/kmod.c
@@ -257,12 +257,9 @@ static void __call_usermodehelper(struct
 {
 	struct subprocess_info *sub_info =
 		container_of(work, struct subprocess_info, work);
-	enum umh_wait wait = sub_info->wait;
+	int wait = sub_info->wait & ~UMH_KILLABLE;
 	pid_t pid;
 
-	if (wait != UMH_NO_WAIT)
-		wait &= ~UMH_KILLABLE;
-
 	/* CLONE_VFORK: wait until the usermode helper has execve'd
 	 * successfully We need the data structures to stay around
 	 * until that is done.  */
@@ -451,8 +448,7 @@ EXPORT_SYMBOL(call_usermodehelper_setfns
  * asynchronously if wait is not set, and runs as a child of keventd.
  * (ie. it runs with full root capabilities).
  */
-int call_usermodehelper_exec(struct subprocess_info *sub_info,
-			     enum umh_wait wait)
+int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
 {
 	DECLARE_COMPLETION_ONSTACK(done);
 	int retval = 0;
diff -puN security/keys/request_key.c~usermodehelper-kill-umh_wait-renumber-umh_-constants security/keys/request_key.c
--- a/security/keys/request_key.c~usermodehelper-kill-umh_wait-renumber-umh_-constants
+++ a/security/keys/request_key.c
@@ -91,7 +91,7 @@ static void umh_keys_cleanup(struct subp
  * Call a usermode helper with a specific session keyring.
  */
 static int call_usermodehelper_keys(char *path, char **argv, char **envp,
-			 struct key *session_keyring, enum umh_wait wait)
+			 		struct key *session_keyring, int wait)
 {
 	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
 	struct subprocess_info *info =
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
avr32-dont-mask-signals-in-the-error-path.patch
avr32-use-set_current_blocked-in-handle_signal-sys_rt_sigreturn.patch
avr32-use-block_sigmask.patch
ia64-use-set_current_blocked-and-block_sigmask.patch
microblaze-dont-reimplement-force_sigsegv.patch
microblaze-no-need-to-reset-handler-if-sa_oneshot.patch
microblaze-fix-signal-masking.patch
microblaze-use-set_current_blocked-and-block_sigmask.patch
mips-use-set_current_blocked-and-block_sigmask.patch
score-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
score-use-set_current_blocked-and-block_sigmask.patch
unicore32-use-block_sigmask.patch
blackfin-use-set_current_blocked-and-block_sigmask.patch
parisc-use-set_current_blocked-and-block_sigmask.patch
mm-coredump-fail-allocations-when-coredumping-instead-of-oom-killing.patch
frv-use-set_current_blocked-and-block_sigmask.patch
sh-no-need-to-reset-handler-if-sa_oneshot.patch
sh-use-set_current_blocked-and-block_sigmask.patch
h8300-use-set_current_blocked-and-block_sigmask.patch
alpha-use-set_current_blocked-and-block_sigmask.patch
m32r-use-set_current_blocked-and-block_sigmask.patch
m68k-use-set_current_blocked-and-block_sigmask.patch
mn10300-use-set_current_blocked-and-block_sigmask.patch
c6x-use-set_current_blocked-and-block_sigmask.patch
cris-use-set_current_blocked-and-block_sigmask.patch
powerpc-eeh-remove-eeh_event_handler-daemonize.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch

