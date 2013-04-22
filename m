From: akpm@linux-foundation.org
Subject: [merged] thinkpad-acpi-kill-hotkey_thread_mutex.patch removed from -mm tree
Date: Mon, 22 Apr 2013 13:06:34 -0700
Message-ID: <20130422200634.91E1E5A429F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:36882 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab3DVUGi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Apr 2013 16:06:38 -0400
Received: by mail-yh0-f74.google.com with SMTP id q10so733402yhf.5
        for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2013 13:06:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, aaron.lu@intel.com, artem.savkov@gmail.com, hmh@hmh.eng.br, maciej.rutecki@gmail.com, matthew.garrett@nebula.com, msb@chromium.org, rjw@sisk.pl, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: thinkpad-acpi: kill hotkey_thread_mutex
has been removed from the -mm tree.  Its filename was
     thinkpad-acpi-kill-hotkey_thread_mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: thinkpad-acpi: kill hotkey_thread_mutex

hotkey_kthread() does try_to_freeze() under hotkey_thread_mutex.

We can simply kill this mutex, hotkey_poll_stop_sync() does not need to
serialize with hotkey_kthread().  When kthread_stop() returns the thread
is already dead, it called do_exit()->complete_vfork_done().

Reported-by: Artem Savkov <artem.savkov@gmail.com>
Reported-by: Maciej Rutecki <maciej.rutecki@gmail.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Reviewed-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/thinkpad_acpi.c |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN drivers/platform/x86/thinkpad_acpi.c~thinkpad-acpi-kill-hotkey_thread_mutex drivers/platform/x86/thinkpad_acpi.c
--- a/drivers/platform/x86/thinkpad_acpi.c~thinkpad-acpi-kill-hotkey_thread_mutex
+++ a/drivers/platform/x86/thinkpad_acpi.c
@@ -1964,9 +1964,6 @@ struct tp_nvram_state {
 /* kthread for the hotkey poller */
 static struct task_struct *tpacpi_hotkey_task;
 
-/* Acquired while the poller kthread is running, use to sync start/stop */
-static struct mutex hotkey_thread_mutex;
-
 /*
  * Acquire mutex to write poller control variables as an
  * atomic block.
@@ -2462,8 +2459,6 @@ static int hotkey_kthread(void *data)
 	unsigned int poll_freq;
 	bool was_frozen;
 
-	mutex_lock(&hotkey_thread_mutex);
-
 	if (tpacpi_lifecycle == TPACPI_LIFE_EXITING)
 		goto exit;
 
@@ -2523,7 +2518,6 @@ static int hotkey_kthread(void *data)
 	}
 
 exit:
-	mutex_unlock(&hotkey_thread_mutex);
 	return 0;
 }
 
@@ -2533,9 +2527,6 @@ static void hotkey_poll_stop_sync(void)
 	if (tpacpi_hotkey_task) {
 		kthread_stop(tpacpi_hotkey_task);
 		tpacpi_hotkey_task = NULL;
-		mutex_lock(&hotkey_thread_mutex);
-		/* at this point, the thread did exit */
-		mutex_unlock(&hotkey_thread_mutex);
 	}
 }
 
@@ -3234,7 +3225,6 @@ static int __init hotkey_init(struct ibm
 	mutex_init(&hotkey_mutex);
 
 #ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
-	mutex_init(&hotkey_thread_mutex);
 	mutex_init(&hotkey_thread_data_mutex);
 #endif
 
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
kthread-introduce-to_live_kthread.patch
kthread-kill-task_get_live_kthread.patch
posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
kthread-implement-probe_kthread_data.patch
workqueue-include-workqueue-info-when-printing-debug-dump-of-a-worker-task.patch
writeback-set-worker-desc-to-identify-writeback-workers-in-task-dumps.patch
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

