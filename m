From: akpm@linux-foundation.org
Subject: + freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch added to -mm tree
Date: Mon, 25 Feb 2013 15:05:46 -0800
Message-ID: <20130225230547.32E9131C233@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:38899 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402Ab3BYXFs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 18:05:48 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so366224vcd.3
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 15:05:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, msb@chromium.org, nhorman@redhat.com, rafael.j.wysocki@intel.com, tj@kernel.org


The patch titled
     Subject: freezer: do not send a fake signal to a PF_DUMPCORE thread
has been added to the -mm tree.  Its filename is
     freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
usermodehelper-cleanup-fix-__orderly_poweroff-argv_free.patch
signal-allow-to-send-any-siginfo-to-itself.patch
kernel-signalc-fix-suboptimal-printk-usage.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
lockdep-check-that-no-locks-held-at-freeze-time.patch
lockdep-check-that-no-locks-held-at-freeze-time-v2.patch
lockdep-check-that-no-locks-held-at-freeze-time-fix.patch
coredump-use-a-freezable_schedule-for-the-coredump_finish-wait.patch

