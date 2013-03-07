From: akpm@linux-foundation.org
Subject: + thinkpad-acpi-kill-hotkey_thread_mutex.patch added to -mm tree
Date: Thu, 07 Mar 2013 13:48:05 -0800
Message-ID: <20130307214805.8E99D31C3A8@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:47139 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab3CGVsI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Mar 2013 16:48:08 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so94312vcd.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Mar 2013 13:48:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, aaron.lu@intel.com, artem.savkov@gmail.com, ibm-acpi@hmh.eng.br, maciej.rutecki@gmail.com, matthew.garrett@nebula.com, msb@chromium.org, rjw@sisk.pl, tj@kernel.org


The patch titled
     Subject: thinkpad-acpi: kill hotkey_thread_mutex
has been added to the -mm tree.  Its filename is
     thinkpad-acpi-kill-hotkey_thread_mutex.patch

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
Subject: thinkpad-acpi: kill hotkey_thread_mutex

hotkey_kthread() does try_to_freeze() under hotkey_thread_mutex.

We can simply kill this mutex, hotkey_poll_stop_sync() does not need to
serialize with hotkey_kthread().  When kthread_stop() returns the thread
is already dead, it called do_exit()->complete_vfork_done().

Reported-by: Artem Savkov <artem.savkov@gmail.com>
Reported-by: Maciej Rutecki <maciej.rutecki@gmail.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
Cc: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mandeep Singh Baines <msb@chromium.org>
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

thinkpad-acpi-kill-hotkey_thread_mutex.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
ptrace-add-ability-to-retrieve-signals-without-removing-from-a-queue-v4.patch
selftest-add-a-test-case-for-ptrace_peeksiginfo.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch

