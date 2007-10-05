From: akpm@linux-foundation.org
Subject: - rt-ptracer-can-monopolize-cpu-was-cpu-hotplug-and-real-time.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:58:04 -0700
Message-ID: <200710051958.l95Jw4AJ022521@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33408 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763552AbXJEUBj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ego@in.ibm.com, mingo@elte.hu, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     rt ptracer can monopolize CPU (was: Cpu-Hotplug and Real-Time)
has been removed from the -mm tree.  Its filename was
     rt-ptracer-can-monopolize-cpu-was-cpu-hotplug-and-real-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rt ptracer can monopolize CPU (was: Cpu-Hotplug and Real-Time)
From: Gautham R Shenoy <ego@in.ibm.com>

yield() in wait_task_inactive(), can cause a high priority thread to be
scheduled back in, and there by loop forever while it is waiting for some
lower priority thread which is unfortunately still on the runqueue.

Use schedule_timeout_uninterruptible(1) instead.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Credit: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~rt-ptracer-can-monopolize-cpu-was-cpu-hotplug-and-real-time kernel/sched.c
--- a/kernel/sched.c~rt-ptracer-can-monopolize-cpu-was-cpu-hotplug-and-real-time
+++ a/kernel/sched.c
@@ -1130,7 +1130,7 @@ repeat:
 	 * yield - it could be a while.
 	 */
 	if (unlikely(on_rq)) {
-		yield();
+		schedule_timeout_uninterruptible(1);
 		goto repeat;
 	}
 
_

Patches currently in -mm which might be from ego@in.ibm.com are

git-sched.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
cpu-hotplug-topology-remove-topology_dev_map.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist.patch
migration_callcpu_dead-use-spin_lock_irq-instead-of-task_rq_lock.patch
