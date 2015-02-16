From: akpm@linux-foundation.org
Subject: [merged]
 net-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch removed from -mm tree
Date: Mon, 16 Feb 2015 12:16:35 -0800
Message-ID: <54e25023.qpOsuZVbeirCopXe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbbBPURL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:17:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: net: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been removed from the -mm tree.  Its filename was
     net-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: net: use %*pb[l] to print bitmaps including cpumasks and nodemasks

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/net-sysfs.c       |   28 +++++++---------------------
 net/core/sysctl_net_core.c |    2 +-
 2 files changed, 8 insertions(+), 22 deletions(-)

diff -puN net/core/net-sysfs.c~net-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks net/core/net-sysfs.c
--- a/net/core/net-sysfs.c~net-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/net/core/net-sysfs.c
@@ -614,8 +614,7 @@ static ssize_t show_rps_map(struct netde
 {
 	struct rps_map *map;
 	cpumask_var_t mask;
-	size_t len = 0;
-	int i;
+	int i, len;
 
 	if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
 		return -ENOMEM;
@@ -626,17 +625,11 @@ static ssize_t show_rps_map(struct netde
 		for (i = 0; i < map->len; i++)
 			cpumask_set_cpu(map->cpus[i], mask);
 
-	len += cpumask_scnprintf(buf + len, PAGE_SIZE, mask);
-	if (PAGE_SIZE - len < 3) {
-		rcu_read_unlock();
-		free_cpumask_var(mask);
-		return -EINVAL;
-	}
+	len = snprintf(buf, PAGE_SIZE, "%*pb\n", cpumask_pr_args(mask));
 	rcu_read_unlock();
-
 	free_cpumask_var(mask);
-	len += sprintf(buf + len, "\n");
-	return len;
+
+	return len < PAGE_SIZE ? len : -EINVAL;
 }
 
 static ssize_t store_rps_map(struct netdev_rx_queue *queue,
@@ -1090,8 +1083,7 @@ static ssize_t show_xps_map(struct netde
 	struct xps_dev_maps *dev_maps;
 	cpumask_var_t mask;
 	unsigned long index;
-	size_t len = 0;
-	int i;
+	int i, len;
 
 	if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
 		return -ENOMEM;
@@ -1117,15 +1109,9 @@ static ssize_t show_xps_map(struct netde
 	}
 	rcu_read_unlock();
 
-	len += cpumask_scnprintf(buf + len, PAGE_SIZE, mask);
-	if (PAGE_SIZE - len < 3) {
-		free_cpumask_var(mask);
-		return -EINVAL;
-	}
-
+	len = snprintf(buf, PAGE_SIZE, "%*pb\n", cpumask_pr_args(mask));
 	free_cpumask_var(mask);
-	len += sprintf(buf + len, "\n");
-	return len;
+	return len < PAGE_SIZE ? len : -EINVAL;
 }
 
 static ssize_t store_xps_map(struct netdev_queue *queue,
diff -puN net/core/sysctl_net_core.c~net-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks net/core/sysctl_net_core.c
--- a/net/core/sysctl_net_core.c~net-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/net/core/sysctl_net_core.c
@@ -155,7 +155,7 @@ write_unlock:
 		rcu_read_unlock();
 
 		len = min(sizeof(kbuf) - 1, *lenp);
-		len = cpumask_scnprintf(kbuf, len, mask);
+		len = scnprintf(kbuf, len, "%*pb", cpumask_pr_args(mask));
 		if (!len) {
 			*lenp = 0;
 			goto done;
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch

