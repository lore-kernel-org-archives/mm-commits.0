From: akpm@linux-foundation.org
Subject: - add-irq-protection-in-the-percpu-counters-cpu-hotplug-callback-path.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:53:30 -0700
Message-ID: <200710192253.l9JMrUVT024430@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60816 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966966AbXJSXFe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ego@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Add irq protection in the percpu-counters cpu-hotplug-callback path
has been removed from the -mm tree.  Its filename was
     add-irq-protection-in-the-percpu-counters-cpu-hotplug-callback-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
