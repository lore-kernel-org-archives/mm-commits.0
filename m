From: akpm@linux-foundation.org
Subject: + add-irq-protection-in-the-percpu-counters-cpu-hotplug-callback-path.patch added to -mm tree
Date: Sun, 14 Oct 2007 23:37:06 -0700
Message-ID: <200710150637.l9F6b6TB021326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33437 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753324AbXJOGiQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 02:38:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ego@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     Add irq protection in the percpu-counters cpu-hotplug-callback path
has been added to the -mm tree.  Its filename is
     add-irq-protection-in-the-percpu-counters-cpu-hotplug-callback-path.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add irq protection in the percpu-counters cpu-hotplug-callback path
From: Gautham R Shenoy <ego@in.ibm.com>

Some of the per-cpu counters and thus their locks are accessed from IRQ
contexts.  This can cause a deadlock if it interrupts a cpu-offline thread
which is transferring a dead-cpu's counts to the global counter.

Add appropriate IRQ protection in the cpu-hotplug callback path.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu_counter.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN lib/percpu_counter.c~add-irq-protection-in-the-percpu-counters-cpu-hotplug-callback-path lib/percpu_counter.c
--- a/lib/percpu_counter.c~add-irq-protection-in-the-percpu-counters-cpu-hotplug-callback-path
+++ a/lib/percpu_counter.c
@@ -124,12 +124,13 @@ static int __cpuinit percpu_counter_hotc
 	mutex_lock(&percpu_counters_lock);
 	list_for_each_entry(fbc, &percpu_counters, list) {
 		s32 *pcount;
+		unsigned long flags;
 
-		spin_lock(&fbc->lock);
+		spin_lock_irqsave(&fbc->lock, flags);
 		pcount = per_cpu_ptr(fbc->counters, cpu);
 		fbc->count += *pcount;
 		*pcount = 0;
-		spin_unlock(&fbc->lock);
+		spin_unlock_irqrestore(&fbc->lock, flags);
 	}
 	mutex_unlock(&percpu_counters_lock);
 	return NOTIFY_OK;
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
do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist-fix.patch
migration_callcpu_dead-use-spin_lock_irq-instead-of-task_rq_lock.patch
add-irq-protection-in-the-percpu-counters-cpu-hotplug-callback-path.patch
