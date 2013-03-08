From: akpm@linux-foundation.org
Subject: [to-be-updated] freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch removed from -mm tree
Date: Fri, 08 Mar 2013 13:07:51 -0800
Message-ID: <20130308210751.8A3715A4123@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:50381 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932987Ab3CHVHw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Mar 2013 16:07:52 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so201830yhz.3
        for <mm-commits@vger.kernel.org>; Fri, 08 Mar 2013 13:07:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, msb@chromium.org, nhorman@redhat.com, rafael.j.wysocki@intel.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: freezer: do not send a fake signal to a PF_DUMPCORE thread
has been removed from the -mm tree.  Its filename was
     freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: freezer: do not send a fake signal to a PF_DUMPCORE thread

A coredumping thread can't be frozen anyway but the fake signal sent by
freeze_task() can confuse dump_write/wait_for_dump_helpers/etc and
interrupt the coredump.

We are going to make the do_coredump() paths freezable but the fake
TIF_SIGPENDING doesn't help, it only makes sense when we assume that the
target can return to user-mode and call get_signal_to_deliver().

Change freeze_task() to check PF_DUMPCORE along with PF_KTHREAD.  We need
to recheck PF_DUMPCORE under ->siglock to avoid the race with
zap_threads() which can set this flag right before we take the lock.
 
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Mandeep Singh Baines <msb@chromium.org>
Cc: Neil Horman <nhorman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/freezer.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff -puN kernel/freezer.c~freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread kernel/freezer.c
--- a/kernel/freezer.c~freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread
+++ a/kernel/freezer.c
@@ -85,14 +85,21 @@ bool __refrigerator(bool check_kthr_stop
 }
 EXPORT_SYMBOL(__refrigerator);
 
-static void fake_signal_wake_up(struct task_struct *p)
+static bool fake_signal_wake_up(struct task_struct *p)
 {
 	unsigned long flags;
+	bool ret = false;
+
+	if (p->flags & (PF_KTHREAD | PF_DUMPCORE))
+		return ret;
 
 	if (lock_task_sighand(p, &flags)) {
-		signal_wake_up(p, 0);
+		ret = !(p->flags & PF_DUMPCORE);
+		if (ret)
+			signal_wake_up(p, 0);
 		unlock_task_sighand(p, &flags);
 	}
+	return ret;
 }
 
 /**
@@ -100,8 +107,8 @@ static void fake_signal_wake_up(struct t
  * @p: task to send the request to
  *
  * If @p is freezing, the freeze request is sent either by sending a fake
- * signal (if it's not a kernel thread) or waking it up (if it's a kernel
- * thread).
+ * signal (if it's not a kernel thread or a coredumping thread) or waking
+ * it up otherwise.
  *
  * RETURNS:
  * %false, if @p is not freezing or already frozen; %true, otherwise
@@ -116,9 +123,7 @@ bool freeze_task(struct task_struct *p)
 		return false;
 	}
 
-	if (!(p->flags & PF_KTHREAD))
-		fake_signal_wake_up(p);
-	else
+	if (!fake_signal_wake_up(p))
 		wake_up_state(p, TASK_INTERRUPTIBLE);
 
 	spin_unlock_irqrestore(&freezer_lock, flags);
_

Patches currently in -mm which might be from oleg@redhat.com are

thinkpad-acpi-kill-hotkey_thread_mutex.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
ptrace-add-ability-to-retrieve-signals-without-removing-from-a-queue-v4.patch
selftest-add-a-test-case-for-ptrace_peeksiginfo.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-make-wait_for_dump_helpers-freezable.patch

