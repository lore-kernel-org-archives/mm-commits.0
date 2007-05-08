From: akpm@linux-foundation.org
Subject: + swsusp-use-reasonable-default-for-hibernation_mode.patch added to -mm tree
Date: Tue, 08 May 2007 14:05:33 -0700
Message-ID: <200705082105.l48L5Yc7001634@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032161AbXEHVGf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 17:06:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, johannes@sipsolutions.net, nigel@nigel.suspend2.net, pavel@ucw.cz, penberg@cs.helsinki.fi


The patch titled
     swsusp: use reasonable default for hibernation_mode
has been added to the -mm tree.  Its filename is
     swsusp-use-reasonable-default-for-hibernation_mode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: swsusp: use reasonable default for hibernation_mode
From: Rafael J. Wysocki <rjw@sisk.pl>

Make sure that hibernation_mode is set to a reasonable value by default.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/disk.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff -puN kernel/power/disk.c~swsusp-use-reasonable-default-for-hibernation_mode kernel/power/disk.c
--- a/kernel/power/disk.c~swsusp-use-reasonable-default-for-hibernation_mode
+++ a/kernel/power/disk.c
@@ -30,8 +30,6 @@ char resume_file[256] = CONFIG_PM_STD_PA
 dev_t swsusp_resume_device;
 sector_t swsusp_resume_block;
 
-static int hibernation_mode;
-
 enum {
 	HIBERNATION_INVALID,
 	HIBERNATION_PLATFORM,
@@ -45,6 +43,8 @@ enum {
 #define HIBERNATION_MAX (__HIBERNATION_AFTER_LAST-1)
 #define HIBERNATION_FIRST (HIBERNATION_INVALID + 1)
 
+static int hibernation_mode = HIBERNATION_SHUTDOWN;
+
 struct hibernation_ops *hibernation_ops;
 
 /**
@@ -60,6 +60,11 @@ void hibernation_set_ops(struct hibernat
 	}
 	mutex_lock(&pm_mutex);
 	hibernation_ops = ops;
+	if (ops)
+		hibernation_mode = HIBERNATION_PLATFORM;
+	else if (hibernation_mode == HIBERNATION_PLATFORM)
+		hibernation_mode = HIBERNATION_SHUTDOWN;
+
 	mutex_unlock(&pm_mutex);
 }
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
swsusp-clean-up-print.patch
pm-separate-hibernation-code-from-suspend-code.patch
swsusp-use-reasonable-default-for-hibernation_mode.patch
workqueues-shift-kthread_bind-from-cpu_up_prepare-to-cpu_online.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
remvoe-kthread_bind-call-from-_cpu_down.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
add-suspend-related-notifications-for-cpu-hotplug.patch
add-suspend-related-notifications-for-cpu-hotplug-cleanup.patch
microcode-use-suspend-related-cpu-hotplug-notifications.patch
add-suspend-related-notifications-for-cpu-hotplug-statistics.patch
shrink_slab-handle-bad-shrinkers.patch
