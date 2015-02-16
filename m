From: akpm@linux-foundation.org
Subject: [merged]
 ia64-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:16:15 -0800
Message-ID: <54e2500f.GPcCkRiaTSk9QEXU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbbBPUQv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:16:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, fenghua.yu@intel.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been removed from the -mm tree.  Its filename was
     ia64-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: ia64: use %*pb[l] to print bitmaps including cpumasks and nodemasks

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/topology.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN arch/ia64/kernel/topology.c~ia64-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks arch/ia64/kernel/topology.c
--- a/arch/ia64/kernel/topology.c~ia64-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/arch/ia64/kernel/topology.c
@@ -217,14 +217,12 @@ static ssize_t show_number_of_sets(struc
 
 static ssize_t show_shared_cpu_map(struct cache_info *this_leaf, char *buf)
 {
-	ssize_t	len;
 	cpumask_t shared_cpu_map;
 
 	cpumask_and(&shared_cpu_map,
 				&this_leaf->shared_cpu_map, cpu_online_mask);
-	len = cpumask_scnprintf(buf, NR_CPUS+1, &shared_cpu_map);
-	len += sprintf(buf+len, "\n");
-	return len;
+	return scnprintf(buf, PAGE_SIZE, "%*pb\n",
+			 cpumask_pr_args(&shared_cpu_map));
 }
 
 static ssize_t show_type(struct cache_info *this_leaf, char *buf)
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch

