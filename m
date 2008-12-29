From: akpm@linux-foundation.org
Subject: - cpuacct-refactoring-cpuusage_read-cpuusage_write.patch removed from -mm tree
Date: Mon, 29 Dec 2008 11:19:14 -0800
Message-ID: <200812291919.mBTJJEYW031522@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752033AbYL2T0b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 14:26:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenchen@google.com, lizf@cn.fujitsu.com, menage@google.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     cpuacct: refactoring cpuusage_read / cpuusage_write
has been removed from the -mm tree.  Its filename was
     cpuacct-refactoring-cpuusage_read-cpuusage_write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuacct: refactoring cpuusage_read / cpuusage_write
From: Ken Chen <kenchen@google.com>

In the thread regarding to 'export percpu cpuacct cgroup stats'
http://lkml.org/lkml/2008/12/7/13

akpm pointed out that current cpuacct code is inefficient.  This patch
refactoring the following:

* make cpu_rq locking only on 32-bit
* change iterator to each_present_cpu instead of each_possible_cpu to
  make it hotplug friendly.

It's a bit of code churn, but I was rewarded with 160 byte code size saving
on x86-64 arch and zero code size change on i386.

Signed-off-by: Ken Chen <kenchen@google.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   56 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 17 deletions(-)

diff -puN kernel/sched.c~cpuacct-refactoring-cpuusage_read-cpuusage_write kernel/sched.c
--- a/kernel/sched.c~cpuacct-refactoring-cpuusage_read-cpuusage_write
+++ a/kernel/sched.c
@@ -9391,6 +9391,41 @@ cpuacct_destroy(struct cgroup_subsys *ss
 	kfree(ca);
 }
 
+static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu)
+{
+	u64 *cpuusage = percpu_ptr(ca->cpuusage, cpu);
+	u64 data;
+
+#ifndef CONFIG_64BIT
+	/*
+	 * Take rq->lock to make 64-bit read safe on 32-bit platforms.
+	 */
+	spin_lock_irq(&cpu_rq(cpu)->lock);
+	data = *cpuusage;
+	spin_unlock_irq(&cpu_rq(cpu)->lock);
+#else
+	data = *cpuusage;
+#endif
+
+	return data;
+}
+
+static void cpuacct_cpuusage_write(struct cpuacct *ca, int cpu, u64 val)
+{
+	u64 *cpuusage = percpu_ptr(ca->cpuusage, cpu);
+
+#ifndef CONFIG_64BIT
+	/*
+	 * Take rq->lock to make 64-bit write safe on 32-bit platforms.
+	 */
+	spin_lock_irq(&cpu_rq(cpu)->lock);
+	*cpuusage = val;
+	spin_unlock_irq(&cpu_rq(cpu)->lock);
+#else
+	*cpuusage = val;
+#endif
+}
+
 /* return total cpu usage (in nanoseconds) of a group */
 static u64 cpuusage_read(struct cgroup *cgrp, struct cftype *cft)
 {
@@ -9398,17 +9433,8 @@ static u64 cpuusage_read(struct cgroup *
 	u64 totalcpuusage = 0;
 	int i;
 
-	for_each_possible_cpu(i) {
-		u64 *cpuusage = percpu_ptr(ca->cpuusage, i);
-
-		/*
-		 * Take rq->lock to make 64-bit addition safe on 32-bit
-		 * platforms.
-		 */
-		spin_lock_irq(&cpu_rq(i)->lock);
-		totalcpuusage += *cpuusage;
-		spin_unlock_irq(&cpu_rq(i)->lock);
-	}
+	for_each_present_cpu(i)
+		totalcpuusage += cpuacct_cpuusage_read(ca, i);
 
 	return totalcpuusage;
 }
@@ -9425,13 +9451,9 @@ static int cpuusage_write(struct cgroup 
 		goto out;
 	}
 
-	for_each_possible_cpu(i) {
-		u64 *cpuusage = percpu_ptr(ca->cpuusage, i);
+	for_each_present_cpu(i)
+		cpuacct_cpuusage_write(ca, i, 0);
 
-		spin_lock_irq(&cpu_rq(i)->lock);
-		*cpuusage = 0;
-		spin_unlock_irq(&cpu_rq(i)->lock);
-	}
 out:
 	return err;
 }
_

Patches currently in -mm which might be from kenchen@google.com are

origin.patch
linux-next.patch
hugetlb-unsigned-ret-cannot-be-negative.patch

