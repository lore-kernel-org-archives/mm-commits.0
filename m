From: akpm@linux-foundation.org
Subject: +
 net-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch added
 to -mm tree
Date: Mon, 26 Jan 2015 15:07:18 -0800
Message-ID: <54c6c8a6.OL5I7HCbYkkD/85I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46158 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757197AbbAZXHT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jan 2015 18:07:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: net: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been added to the -mm tree.  Its filename is
     net-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/net-use-%25pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/net-use-%25pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: "David S. Miller" <davem@davemloft.net>
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

block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
vmscan-force-scan-offline-memory-cgroups.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
oom-add-helpers-for-setting-and-clearing-tif_memdie.patch
oom-thaw-the-oom-victim-if-it-is-frozen.patch
pm-convert-printk-to-pr_-equivalent.patch
sysrq-convert-printk-to-pr_-equivalent.patch
oom-pm-make-oom-detection-in-the-freezer-path-raceless.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
mm-util-add-kstrdup_const.patch
kernfs-convert-node-name-allocation-to-kstrdup_const.patch
kernfs-remove-kernfs_static_name.patch
clk-convert-clock-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
fs-namespace-convert-devname-allocation-to-kstrdup_const.patch
cpumask-always-use-nr_cpu_ids-in-formatting-and-parsing-functions.patch
lib-vsprintf-implement-bitmap-printing-through-%pb.patch
cpumask-nodemask-implement-cpumask-nodemask_pr_args.patch
bitmap-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
mips-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
powerpc-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
tile-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
x86-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
ia64-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
xtensa-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
arm-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
cpuset-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
rcu-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
sched-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
time-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
percpu-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
workqueue-use-%pb-to-format-bitmaps-including-cpumasks-and-nodemasks.patch
tracing-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
net-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
wireless-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
input-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
scsi-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
usb-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
drivers-base-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
slub-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
mm-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
padata-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
proc-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
irq-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
profile-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
bitmap-cpumask-nodemask-remove-dedicated-formatting-functions.patch
linux-next.patch

