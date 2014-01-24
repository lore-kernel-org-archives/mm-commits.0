From: akpm@linux-foundation.org
Subject: [merged] numa-add-a-sysctl-for-numa_balancing.patch removed from
 -mm tree
Date: Fri, 24 Jan 2014 10:59:01 -0800
Message-ID: <52e2b7f5.LWqRJo2bxZ84p+X6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43261 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS7C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:59:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mingo@elte.hu, mgorman@suse.de, ak@linux.intel.com

Subject: [merged] numa-add-a-sysctl-for-numa_balancing.patch removed from -mm tree
To: ak@linux.intel.com,mgorman@suse.de,mingo@elte.hu,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:59:01 -0800


The patch titled
     Subject: numa: add a sysctl for numa_balancing
has been removed from the -mm tree.  Its filename was
     numa-add-a-sysctl-for-numa_balancing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: numa: add a sysctl for numa_balancing

Add a working sysctl to enable/disable automatic numa memory balancing at
runtime.

This allows us to track down performance problems with this feature and is
generally a good idea.

This was possible earlier through debugfs, but only with special debugging
options set.  Also fix the boot message.

[akpm@linux-foundation.org: s/sched_numa_balancing/sysctl_numa_balancing/]
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/sysctl.h |    4 ++++
 kernel/sched/core.c          |   24 +++++++++++++++++++++++-
 kernel/sysctl.c              |    9 +++++++++
 mm/mempolicy.c               |    2 +-
 4 files changed, 37 insertions(+), 2 deletions(-)

diff -puN include/linux/sched/sysctl.h~numa-add-a-sysctl-for-numa_balancing include/linux/sched/sysctl.h
--- a/include/linux/sched/sysctl.h~numa-add-a-sysctl-for-numa_balancing
+++ a/include/linux/sched/sysctl.h
@@ -99,4 +99,8 @@ extern int sched_rt_handler(struct ctl_t
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos);
 
+extern int sysctl_numa_balancing(struct ctl_table *table, int write,
+				 void __user *buffer, size_t *lenp,
+				 loff_t *ppos);
+
 #endif /* _SCHED_SYSCTL_H */
diff -puN kernel/sched/core.c~numa-add-a-sysctl-for-numa_balancing kernel/sched/core.c
--- a/kernel/sched/core.c~numa-add-a-sysctl-for-numa_balancing
+++ a/kernel/sched/core.c
@@ -1770,7 +1770,29 @@ void set_numabalancing_state(bool enable
 	numabalancing_enabled = enabled;
 }
 #endif /* CONFIG_SCHED_DEBUG */
-#endif /* CONFIG_NUMA_BALANCING */
+
+#ifdef CONFIG_PROC_SYSCTL
+int sysctl_numa_balancing(struct ctl_table *table, int write,
+			 void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table t;
+	int err;
+	int state = numabalancing_enabled;
+
+	if (write && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	t = *table;
+	t.data = &state;
+	err = proc_dointvec_minmax(&t, write, buffer, lenp, ppos);
+	if (err < 0)
+		return err;
+	if (write)
+		set_numabalancing_state(state);
+	return err;
+}
+#endif
+#endif
 
 /*
  * fork()/clone()-time setup:
diff -puN kernel/sysctl.c~numa-add-a-sysctl-for-numa_balancing kernel/sysctl.c
--- a/kernel/sysctl.c~numa-add-a-sysctl-for-numa_balancing
+++ a/kernel/sysctl.c
@@ -389,6 +389,15 @@ static struct ctl_table kern_table[] = {
 		.mode           = 0644,
 		.proc_handler   = proc_dointvec,
 	},
+	{
+		.procname	= "numa_balancing",
+		.data		= NULL, /* filled in by handler */
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= sysctl_numa_balancing,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
 #endif /* CONFIG_NUMA_BALANCING */
 #endif /* CONFIG_SCHED_DEBUG */
 	{
diff -puN mm/mempolicy.c~numa-add-a-sysctl-for-numa_balancing mm/mempolicy.c
--- a/mm/mempolicy.c~numa-add-a-sysctl-for-numa_balancing
+++ a/mm/mempolicy.c
@@ -2668,7 +2668,7 @@ static void __init check_numabalancing_e
 
 	if (nr_node_ids > 1 && !numabalancing_override) {
 		printk(KERN_INFO "Enabling automatic NUMA balancing. "
-			"Configure with numa_balancing= or sysctl");
+			"Configure with numa_balancing= or the kernel.numa_balancing sysctl");
 		set_numabalancing_state(numabalancing_default);
 	}
 }
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch

