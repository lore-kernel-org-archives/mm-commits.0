From: akpm@linux-foundation.org
Subject: + set_task_comm-kill-the-pointless-memset-wmb.patch added to -mm tree
Date: Mon, 18 Mar 2013 14:36:21 -0700
Message-ID: <20130318213621.79F8331C240@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:60490 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab3CRVgW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Mar 2013 17:36:22 -0400
Received: by mail-ve0-f201.google.com with SMTP id 14so624138vea.4
        for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2013 14:36:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, andi@firstfloor.org, johnstul@us.ibm.com


The patch titled
     Subject: set_task_comm: kill the pointless memset() + wmb()
has been added to the -mm tree.  Its filename is
     set_task_comm-kill-the-pointless-memset-wmb.patch

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
Subject: set_task_comm: kill the pointless memset() + wmb()

set_task_comm() does memset() + wmb() before strlcpy().  This buys nothing
and to add to the confusion, the comment is wrong.

- We do not need memset() to be "safe from non-terminating string
  reads", the final char is always zero and we never change it.

- wmb() is paired with nothing, it cannot prevent from printing
  the mixture of the old/new data unless the reader takes the lock.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN fs/exec.c~set_task_comm-kill-the-pointless-memset-wmb fs/exec.c
--- a/fs/exec.c~set_task_comm-kill-the-pointless-memset-wmb
+++ a/fs/exec.c
@@ -1027,17 +1027,7 @@ EXPORT_SYMBOL_GPL(get_task_comm);
 void set_task_comm(struct task_struct *tsk, char *buf)
 {
 	task_lock(tsk);
-
 	trace_task_rename(tsk, buf);
-
-	/*
-	 * Threads may access current->comm without holding
-	 * the task lock, so write the string carefully.
-	 * Readers without a lock may see incomplete new
-	 * names but are safe from non-terminating string reads.
-	 */
-	memset(tsk->comm, 0, TASK_COMM_LEN);
-	wmb();
 	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
 	task_unlock(tsk);
 	perf_event_comm(tsk);
_

Patches currently in -mm which might be from oleg@redhat.com are

poweroff-change-orderly_poweroff-to-use-schedule_work.patch
thinkpad-acpi-kill-hotkey_thread_mutex.patch
kthread-introduce-to_live_kthread.patch
kthread-kill-task_get_live_kthread.patch
posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
teach-argv_split-to-handle-the-mutable-strings.patch
epoll-use-rcu-to-protect-wakeup_source-in-epitem.patch
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

