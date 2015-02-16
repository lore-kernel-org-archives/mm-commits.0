From: akpm@linux-foundation.org
Subject: [merged]
 rcu-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch removed from -mm tree
Date: Mon, 16 Feb 2015 12:16:23 -0800
Message-ID: <54e25017.0UEmmYzlco2kdke3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50965 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbbBPUQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:16:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rcu: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been removed from the -mm tree.  Its filename was
     rcu-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: rcu: use %*pb[l] to print bitmaps including cpumasks and nodemasks

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcu/tree_plugin.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/rcu/tree_plugin.h~rcu-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks kernel/rcu/tree_plugin.h
--- a/kernel/rcu/tree_plugin.h~rcu-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/kernel/rcu/tree_plugin.h
@@ -49,7 +49,6 @@ DEFINE_PER_CPU(char, rcu_cpu_has_work);
 static cpumask_var_t rcu_nocb_mask; /* CPUs to have callbacks offloaded. */
 static bool have_rcu_nocb_mask;	    /* Was rcu_nocb_mask allocated? */
 static bool __read_mostly rcu_nocb_poll;    /* Offload kthread are to poll. */
-static char __initdata nocb_buf[NR_CPUS * 5];
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 
 /*
@@ -2386,8 +2385,8 @@ void __init rcu_init_nohz(void)
 		cpumask_and(rcu_nocb_mask, cpu_possible_mask,
 			    rcu_nocb_mask);
 	}
-	cpulist_scnprintf(nocb_buf, sizeof(nocb_buf), rcu_nocb_mask);
-	pr_info("\tOffload RCU callbacks from CPUs: %s.\n", nocb_buf);
+	pr_info("\tOffload RCU callbacks from CPUs: %*pbl.\n",
+		cpumask_pr_args(rcu_nocb_mask));
 	if (rcu_nocb_poll)
 		pr_info("\tPoll for callbacks from no-CBs CPUs.\n");
 
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch

