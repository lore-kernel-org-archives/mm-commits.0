From: akpm@linux-foundation.org
Subject: [merged] poweroff-change-orderly_poweroff-to-use-schedule_work.patch removed from -mm tree
Date: Mon, 25 Mar 2013 12:45:03 -0700
Message-ID: <20130325194503.DA17E5A419C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:34684 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932604Ab3CYTpF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Mar 2013 15:45:05 -0400
Received: by mail-qa0-f73.google.com with SMTP id hg5so313517qab.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2013 12:45:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, benh@kernel.crashing.org, david@gibson.dropbear.id.au, ebiederm@xmission.com, hongfeng@marvell.com, keescook@chromium.org, lucas.demarchi@profusion.mobi, rjw@sisk.pl, serge.hallyn@canonical.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: poweroff: change orderly_poweroff() to use schedule_work()
has been removed from the -mm tree.  Its filename was
     poweroff-change-orderly_poweroff-to-use-schedule_work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: poweroff: change orderly_poweroff() to use schedule_work()

David said:

    Commit 6c0c0d4d108 ("poweroff: fix bug in orderly_poweroff()")
    apparently fixes one bug in orderly_poweroff(), but introduces
    another.  The comments on orderly_poweroff() claim it can be called
    from any context - and indeed we call it from interrupt context in
    arch/powerpc/platforms/pseries/ras.c for example.  But since that
    commit this is no longer safe, since call_usermodehelper_fns() is not
    safe in interrupt context without the UMH_NO_WAIT option.


orderly_poweroff() can be used from any context but UMH_WAIT_EXEC is
sleepable.  Move the "force" logic into __orderly_poweroff() and change
orderly_poweroff() to use the global poweroff_work which simply calls
__orderly_poweroff().

While at it, remove the unneeded "int argc" and change argv_split() to use
GFP_KERNEL.

We use the global "bool poweroff_force" to pass the argument, this can
obviously affect the previous request if it is pending/running.  So we
only allow the "false => true" transition assuming that the pending "true"
should succeed anyway.  If schedule_work() fails after that we know that
work->func() was not called yet, it must see the new value.

This means that orderly_poweroff() becomes async even if we do not run the
command and always succeeds, schedule_work() can only fail if the work is
already pending.  We can export __orderly_poweroff() and change the
non-atomic callers which want the old semantics.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reported-by: David Gibson <david@gibson.dropbear.id.au>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Feng Hong <hongfeng@marvell.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   57 +++++++++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 25 deletions(-)

diff -puN kernel/sys.c~poweroff-change-orderly_poweroff-to-use-schedule_work kernel/sys.c
--- a/kernel/sys.c~poweroff-change-orderly_poweroff-to-use-schedule_work
+++ a/kernel/sys.c
@@ -2185,9 +2185,8 @@ SYSCALL_DEFINE3(getcpu, unsigned __user
 
 char poweroff_cmd[POWEROFF_CMD_PATH_LEN] = "/sbin/poweroff";
 
-static int __orderly_poweroff(void)
+static int __orderly_poweroff(bool force)
 {
-	int argc;
 	char **argv;
 	static char *envp[] = {
 		"HOME=/",
@@ -2196,20 +2195,40 @@ static int __orderly_poweroff(void)
 	};
 	int ret;
 
-	argv = argv_split(GFP_ATOMIC, poweroff_cmd, &argc);
-	if (argv == NULL) {
+	argv = argv_split(GFP_KERNEL, poweroff_cmd, NULL);
+	if (argv) {
+		ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
+		argv_free(argv);
+	} else {
 		printk(KERN_WARNING "%s failed to allocate memory for \"%s\"\n",
-		       __func__, poweroff_cmd);
-		return -ENOMEM;
+					 __func__, poweroff_cmd);
+		ret = -ENOMEM;
 	}
 
-	ret = call_usermodehelper_fns(argv[0], argv, envp, UMH_WAIT_EXEC,
-				      NULL, NULL, NULL);
-	argv_free(argv);
+	if (ret && force) {
+		printk(KERN_WARNING "Failed to start orderly shutdown: "
+					"forcing the issue\n");
+		/*
+		 * I guess this should try to kick off some daemon to sync and
+		 * poweroff asap.  Or not even bother syncing if we're doing an
+		 * emergency shutdown?
+		 */
+		emergency_sync();
+		kernel_power_off();
+	}
 
 	return ret;
 }
 
+static bool poweroff_force;
+
+static void poweroff_work_func(struct work_struct *work)
+{
+	__orderly_poweroff(poweroff_force);
+}
+
+static DECLARE_WORK(poweroff_work, poweroff_work_func);
+
 /**
  * orderly_poweroff - Trigger an orderly system poweroff
  * @force: force poweroff if command execution fails
@@ -2219,21 +2238,9 @@ static int __orderly_poweroff(void)
  */
 int orderly_poweroff(bool force)
 {
-	int ret = __orderly_poweroff();
-
-	if (ret && force) {
-		printk(KERN_WARNING "Failed to start orderly shutdown: "
-		       "forcing the issue\n");
-
-		/*
-		 * I guess this should try to kick off some daemon to sync and
-		 * poweroff asap.  Or not even bother syncing if we're doing an
-		 * emergency shutdown?
-		 */
-		emergency_sync();
-		kernel_power_off();
-	}
-
-	return ret;
+	if (force) /* do not override the pending "true" */
+		poweroff_force = true;
+	schedule_work(&poweroff_work);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(orderly_poweroff);
_

Patches currently in -mm which might be from oleg@redhat.com are

thinkpad-acpi-kill-hotkey_thread_mutex.patch
kthread-introduce-to_live_kthread.patch
kthread-kill-task_get_live_kthread.patch
posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
argv_split-teach-it-to-handle-mutable-strings.patch
argv_split-teach-it-to-handle-mutable-strings-fix.patch
argv_split-teach-it-to-handle-mutable-strings-fix-2.patch
epoll-use-rcu-to-protect-wakeup_source-in-epitem.patch
epoll-lock-ep-mtx-in-ep_free-to-silence-lockdep.patch
ptrace-add-ability-to-retrieve-signals-without-removing-from-a-queue-v4.patch
selftest-add-a-test-case-for-ptrace_peeksiginfo.patch
usermodehelper-export-_exec-and-_setup-functions.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kmod-split-call-to-call_usermodehelper_fns.patch
keys-split-call-to-call_usermodehelper_fns.patch
coredump-remove-trailling-whitespaces.patch
split-remaining-calls-to-call_usermodehelper_fns.patch
kmod-remove-call_usermodehelper_fns.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-introduce-dump_interrupted.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
coredump-change-wait_for_dump_helpers-to-use-wait_event_interruptible.patch
set_task_comm-kill-the-pointless-memset-wmb.patch
exec-do-not-abuse-cred_guard_mutex-in-threadgroup_lock.patch

