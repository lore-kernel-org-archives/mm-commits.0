From: akpm@linux-foundation.org
Subject: + workqueue-fix-race-condition-in-schedule_on_each_cpu.patch added to -mm tree
Date: Fri, 13 Nov 2009 15:37:23 -0800
Message-ID: <200911132337.nADNbN1d004595@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932549AbZKMXhu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 18:37:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, ak@linux.intel.com, mingo@redhat.com, oleg@redhat.com


The patch titled
     workqueue: fix race condition in schedule_on_each_cpu()
has been added to the -mm tree.  Its filename is
     workqueue-fix-race-condition-in-schedule_on_each_cpu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: workqueue: fix race condition in schedule_on_each_cpu()
From: Tejun Heo <tj@kernel.org>

Commit 65a64464349883891e21e74af16c05d6e1eeb4e9 ("HWPOISON: Allow
schedule_on_each_cpu() from keventd") which allows schedule_on_each_cpu()
to be called from keventd added a race condition.  schedule_on_each_cpu()
may race with cpu hotplug and end up executing the function twice on a
cpu.

Fix it by moving direct execution into the section protected with
get/put_online_cpus().  While at it, update code such that direct
execution is done after works have been scheduled for all other cpus and
drop unnecessary cpu != orig test from flush loop.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff -puN kernel/workqueue.c~workqueue-fix-race-condition-in-schedule_on_each_cpu kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-fix-race-condition-in-schedule_on_each_cpu
+++ a/kernel/workqueue.c
@@ -692,31 +692,29 @@ int schedule_on_each_cpu(work_func_t fun
 	if (!works)
 		return -ENOMEM;
 
+	get_online_cpus();
+
 	/*
-	 * when running in keventd don't schedule a work item on itself.
-	 * Can just call directly because the work queue is already bound.
-	 * This also is faster.
-	 * Make this a generic parameter for other workqueues?
+	 * When running in keventd don't schedule a work item on
+	 * itself.  Can just call directly because the work queue is
+	 * already bound.  This also is faster.
 	 */
-	if (current_is_keventd()) {
+	if (current_is_keventd())
 		orig = raw_smp_processor_id();
-		INIT_WORK(per_cpu_ptr(works, orig), func);
-		func(per_cpu_ptr(works, orig));
-	}
 
-	get_online_cpus();
 	for_each_online_cpu(cpu) {
 		struct work_struct *work = per_cpu_ptr(works, cpu);
 
-		if (cpu == orig)
-			continue;
 		INIT_WORK(work, func);
-		schedule_work_on(cpu, work);
-	}
-	for_each_online_cpu(cpu) {
 		if (cpu != orig)
-			flush_work(per_cpu_ptr(works, cpu));
+			schedule_work_on(cpu, work);
 	}
+	if (orig >= 0)
+		func(per_cpu_ptr(works, orig));
+
+	for_each_online_cpu(cpu)
+		flush_work(per_cpu_ptr(works, cpu));
+
 	put_online_cpus();
 	free_percpu(works);
 	return 0;
_

Patches currently in -mm which might be from tj@kernel.org are

workqueue-fix-race-condition-in-schedule_on_each_cpu.patch
linux-next.patch
lib-vsprintfc-add-%pu-to-print-uuid-guids.patch
drivers-firmware-dmi_scanc-use-%pub-to-print-uuids.patch
efih-use-%pul-to-print-uuids.patch

