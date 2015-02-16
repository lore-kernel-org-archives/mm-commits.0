From: akpm@linux-foundation.org
Subject: [merged]
 drivers-base-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch removed from -mm tree
Date: Mon, 16 Feb 2015 12:16:45 -0800
Message-ID: <54e2502d.PDor9dFFzcq7ns4W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbbBPURV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:17:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/base: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been removed from the -mm tree.  Its filename was
     drivers-base-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: drivers/base: use %*pb[l] to print bitmaps including cpumasks and nodemasks

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

* Line termination only requires one extra space at the end of the
  buffer.  Use PAGE_SIZE - 1 instead of PAGE_SIZE - 2 when formatting.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/cpu.c  |    2 +-
 drivers/base/node.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/base/cpu.c~drivers-base-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks drivers/base/cpu.c
--- a/drivers/base/cpu.c~drivers-base-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/drivers/base/cpu.c
@@ -245,7 +245,7 @@ static ssize_t print_cpus_offline(struct
 	if (!alloc_cpumask_var(&offline, GFP_KERNEL))
 		return -ENOMEM;
 	cpumask_andnot(offline, cpu_possible_mask, cpu_online_mask);
-	n = cpulist_scnprintf(buf, len, offline);
+	n = scnprintf(buf, len, "%*pbl", cpumask_pr_args(offline));
 	free_cpumask_var(offline);
 
 	/* display offline cpus >= nr_cpu_ids */
diff -puN drivers/base/node.c~drivers-base-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks drivers/base/node.c
--- a/drivers/base/node.c~drivers-base-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/drivers/base/node.c
@@ -605,7 +605,8 @@ static ssize_t print_nodes_state(enum no
 {
 	int n;
 
-	n = nodelist_scnprintf(buf, PAGE_SIZE-2, node_states[state]);
+	n = scnprintf(buf, PAGE_SIZE - 1, "%*pbl",
+		      nodemask_pr_args(&node_states[state]));
 	buf[n++] = '\n';
 	buf[n] = '\0';
 	return n;
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch

