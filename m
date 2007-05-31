From: akpm@linux-foundation.org
Subject: + freezer-make-kernel-threads-nonfreezable-by-default-fix-2.patch added to -mm tree
Date: Thu, 31 May 2007 14:35:59 -0700
Message-ID: <200705312135.l4VLZxH6028510@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbXEaVgh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2007 17:36:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, ego@in.ibm.com, nigel@nigel.suspend2.net, oleg@tv-sign.ru, pavel@ucw.cz


The patch titled
     freezer-make-kernel-threads-nonfreezable-by-default fix 2
has been added to the -mm tree.  Its filename is
     freezer-make-kernel-threads-nonfreezable-by-default-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 3 deletions(-)

diff -puN kernel/sched.c~freezer-make-kernel-threads-nonfreezable-by-default-fix-2 kernel/sched.c
--- a/kernel/sched.c~freezer-make-kernel-threads-nonfreezable-by-default-fix-2
+++ a/kernel/sched.c
@@ -5157,13 +5157,10 @@ static int migration_thread(void *data)
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

at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
x86_64-pm_trace-support.patch
freezer-make-kernel-threads-nonfreezable-by-default.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-2.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-do-not-require-dev-spew-to-get-pm_debug.patch
swsusp-remove-incorrect-code-from-userc.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
swsusp-introduce-restore-platform-operations.patch
swsusp-fix-hibernation-code-ordering.patch
hibernation-prepare-to-enter-the-low-power-state.patch
freezer-avoid-freezing-kernel-threads-prematurely.patch
freezer-use-__set_current_state-in-refrigerator.patch
freezer-return-int-from-freeze_processes.patch
freezer-remove-redundant-check-in-try_to_freeze_tasks.patch
add-suspend-related-notifications-for-cpu-hotplug-statistics.patch
shrink_slab-handle-bad-shrinkers.patch
