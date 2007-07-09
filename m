From: akpm@linux-foundation.org
Subject: - freezer-make-kernel-threads-nonfreezable-by-default-fix-2.patch removed from -mm tree
Date: Mon, 09 Jul 2007 14:14:57 -0700
Message-ID: <200707092114.l69LEvJ2012178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39649 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755045AbXGIVPd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 17:15:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, ego@in.ibm.com, nigel@nigel.suspend2.net, oleg@tv-sign.ru, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     freezer-make-kernel-threads-nonfreezable-by-default fix 2
has been removed from the -mm tree.  Its filename was
     freezer-make-kernel-threads-nonfreezable-by-default-fix-2.patch

This patch was dropped because it was folded into freezer-make-kernel-threads-nonfreezable-by-default.patch

------------------------------------------------------
Subject: freezer-make-kernel-threads-nonfreezable-by-default fix 2
From: "Rafael J. Wysocki" <rjw@sisk.pl>

migration_thread should not be freezable, or it will break hibernation and
suspend on SMP.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN kernel/sched.c~freezer-make-kernel-threads-nonfreezable-by-default-fix-2 kernel/sched.c
--- a/kernel/sched.c~freezer-make-kernel-threads-nonfreezable-by-default-fix-2
+++ a/kernel/sched.c
@@ -5213,13 +5213,10 @@ static int migration_thread(void *data)
 	BUG_ON(rq->migration_thread != current);
 
 	set_current_state(TASK_INTERRUPTIBLE);
-	set_freezable();
 	while (!kthread_should_stop()) {
 		struct migration_req *req;
 		struct list_head *head;
 
-		try_to_freeze();
-
 		spin_lock_irq(&rq->lock);
 
 		if (cpu_is_offline(cpu)) {
_

Patches currently in -mm which might be from rjw@sisk.pl are

pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm.patch
x86_64-pm_trace-support.patch
i386-do-not-restore-reserved-memory-after-hibernation.patch
freezer-make-kernel-threads-nonfreezable-by-default.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-2.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-do-not-require-dev-spew-to-get-pm_debug.patch
swsusp-remove-incorrect-code-from-userc.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
swsusp-remove-code-duplication-between-diskc-and-userc-fix.patch
swsusp-introduce-restore-platform-operations.patch
swsusp-fix-hibernation-code-ordering.patch
hibernation-prepare-to-enter-the-low-power-state.patch
freezer-avoid-freezing-kernel-threads-prematurely.patch
freezer-use-__set_current_state-in-refrigerator.patch
freezer-return-int-from-freeze_processes.patch
freezer-remove-redundant-check-in-try_to_freeze_tasks.patch
pm-introduce-hibernation-and-suspend-notifiers.patch
pm-introduce-hibernation-and-suspend-notifiers-fix.patch
pm-introduce-hibernation-and-suspend-notifiers-tidy.patch
pm-introduce-hibernation-and-suspend-notifiers-fix-fix.patch
pm-disable-usermode-helper-before-hibernation-and-suspend.patch
pm-disable-usermode-helper-before-hibernation-and-suspend-fix.patch
pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2.patch
pm-reduce-code-duplication-between-mainc-and-userc-updated.patch
acpi-do-not-prepare-for-hibernation-in-acpi_shutdown.patch
pm-introduce-pm_power_off_prepare.patch
pm-optional-beeping-during-resume-from-suspend-to-ram.patch
pm-integrate-beeping-flag-with-existing-acpi_sleep-flags.patch
shrink_slab-handle-bad-shrinkers.patch
