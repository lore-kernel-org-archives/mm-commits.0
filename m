From: akpm@linux-foundation.org
Subject: +
 tile-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch added
 to -mm tree
Date: Mon, 26 Jan 2015 15:06:54 -0800
Message-ID: <54c6c88e.baJGQU/IG0pZsTsK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46117 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890AbbAZXGz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jan 2015 18:06:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, cmetcalf@tilera.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tile: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been added to the -mm tree.  Its filename is
     tile-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tile-use-%25pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tile-use-%25pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

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
Subject: tile: use %*pb[l] to print bitmaps including cpumasks and nodemasks

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/kernel/hardwall.c         |    5 +----
 arch/tile/kernel/proc.c             |    5 ++---
 arch/tile/kernel/setup.c            |   13 +++++--------
 arch/tile/mm/homecache.c            |   12 +++++-------
 arch/tile/mm/init.c                 |   18 +++++++-----------
 drivers/net/ethernet/tile/tilegx.c  |    5 ++---
 drivers/net/ethernet/tile/tilepro.c |    5 ++---
 7 files changed, 24 insertions(+), 39 deletions(-)

diff -puN arch/tile/kernel/hardwall.c~tile-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks arch/tile/kernel/hardwall.c
--- a/arch/tile/kernel/hardwall.c~tile-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/arch/tile/kernel/hardwall.c
@@ -909,11 +909,8 @@ static void hardwall_destroy(struct hard
 static int hardwall_proc_show(struct seq_file *sf, void *v)
 {
 	struct hardwall_info *info = sf->private;
-	char buf[256];
 
-	int rc = cpulist_scnprintf(buf, sizeof(buf), &info->cpumask);
-	buf[rc++] = '\n';
-	seq_write(sf, buf, rc);
+	seq_printf(sf, "%*pbl\n", cpumask_pr_args(&info->cpumask));
 	return 0;
 }
 
diff -puN arch/tile/kernel/proc.c~tile-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks arch/tile/kernel/proc.c
--- a/arch/tile/kernel/proc.c~tile-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/arch/tile/kernel/proc.c
@@ -45,10 +45,9 @@ static int show_cpuinfo(struct seq_file
 	int n = ptr_to_cpu(v);
 
 	if (n == 0) {
-		char buf[NR_CPUS*5];
-		cpulist_scnprintf(buf, sizeof(buf), cpu_online_mask);
 		seq_printf(m, "cpu count\t: %d\n", num_online_cpus());
-		seq_printf(m, "cpu list\t: %s\n", buf);
+		seq_printf(m, "cpu list\t: %*pbl\n",
+			   cpumask_pr_args(cpu_online_mask));
 		seq_printf(m, "model name\t: %s\n", chip_model);
 		seq_printf(m, "flags\t\t:\n");  /* nothing for now */
 		seq_printf(m, "cpu MHz\t\t: %llu.%06llu\n",
diff -puN arch/tile/kernel/setup.c~tile-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks arch/tile/kernel/setup.c
--- a/arch/tile/kernel/setup.c~tile-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/arch/tile/kernel/setup.c
@@ -215,12 +215,11 @@ early_param("mem", setup_mem);  /* compa
 
 static int __init setup_isolnodes(char *str)
 {
-	char buf[MAX_NUMNODES * 5];
 	if (str == NULL || nodelist_parse(str, isolnodes) != 0)
 		return -EINVAL;
 
-	nodelist_scnprintf(buf, sizeof(buf), isolnodes);
-	pr_info("Set isolnodes value to '%s'\n", buf);
+	pr_info("Set isolnodes value to '%*pbl'\n",
+		nodemask_pr_args(&isolnodes));
 	return 0;
 }
 early_param("isolnodes", setup_isolnodes);
@@ -1315,11 +1314,9 @@ early_param("disabled_cpus", disabled_cp
 
 void __init print_disabled_cpus(void)
 {
-	if (!cpumask_empty(&disabled_map)) {
-		char buf[100];
-		cpulist_scnprintf(buf, sizeof(buf), &disabled_map);
-		pr_info("CPUs not available for Linux: %s\n", buf);
-	}
+	if (!cpumask_empty(&disabled_map))
+		pr_info("CPUs not available for Linux: %*pbl\n",
+			cpumask_pr_args(&disabled_map));
 }
 
 static void __init setup_cpu_maps(void)
diff -puN arch/tile/mm/homecache.c~tile-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks arch/tile/mm/homecache.c
--- a/arch/tile/mm/homecache.c~tile-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/arch/tile/mm/homecache.c
@@ -115,7 +115,6 @@ void flush_remote(unsigned long cache_pf
 	struct cpumask cache_cpumask_copy, tlb_cpumask_copy;
 	struct cpumask *cache_cpumask, *tlb_cpumask;
 	HV_PhysAddr cache_pa;
-	char cache_buf[NR_CPUS*5], tlb_buf[NR_CPUS*5];
 
 	mb();   /* provided just to simplify "magic hypervisor" mode */
 
@@ -149,13 +148,12 @@ void flush_remote(unsigned long cache_pf
 			     asids, asidcount);
 	if (rc == 0)
 		return;
-	cpumask_scnprintf(cache_buf, sizeof(cache_buf), &cache_cpumask_copy);
-	cpumask_scnprintf(tlb_buf, sizeof(tlb_buf), &tlb_cpumask_copy);
 
-	pr_err("hv_flush_remote(%#llx, %#lx, %p [%s], %#lx, %#lx, %#lx, %p [%s], %p, %d) = %d\n",
-	       cache_pa, cache_control, cache_cpumask, cache_buf,
-	       (unsigned long)tlb_va, tlb_length, tlb_pgsize,
-	       tlb_cpumask, tlb_buf, asids, asidcount, rc);
+	pr_err("hv_flush_remote(%#llx, %#lx, %p [%*pb], %#lx, %#lx, %#lx, %p [%*pb], %p, %d) = %d\n",
+	       cache_pa, cache_control, cache_cpumask,
+	       cpumask_pr_args(&cache_cpumask_copy),
+	       (unsigned long)tlb_va, tlb_length, tlb_pgsize, tlb_cpumask,
+	       cpumask_pr_args(&tlb_cpumask_copy), asids, asidcount, rc);
 	panic("Unsafe to continue.");
 }
 
diff -puN arch/tile/mm/init.c~tile-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks arch/tile/mm/init.c
--- a/arch/tile/mm/init.c~tile-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/arch/tile/mm/init.c
@@ -353,15 +353,13 @@ static int __init setup_ktext(char *str)
 
 	/* Neighborhood ktext pages on specified mask */
 	else if (cpulist_parse(str, &ktext_mask) == 0) {
-		char buf[NR_CPUS * 5];
-		cpulist_scnprintf(buf, sizeof(buf), &ktext_mask);
 		if (cpumask_weight(&ktext_mask) > 1) {
 			ktext_small = 1;
-			pr_info("ktext: using caching neighborhood %s with small pages\n",
-				buf);
+			pr_info("ktext: using caching neighborhood %*pbl with small pages\n",
+				cpumask_pr_args(&ktext_mask));
 		} else {
-			pr_info("ktext: caching on cpu %s with one huge page\n",
-				buf);
+			pr_info("ktext: caching on cpu %*pbl with one huge page\n",
+				cpumask_pr_args(&ktext_mask));
 		}
 	}
 
@@ -492,11 +490,9 @@ static void __init kernel_physical_mappi
 		struct cpumask bad;
 		cpumask_andnot(&bad, &ktext_mask, cpu_possible_mask);
 		cpumask_and(&ktext_mask, &ktext_mask, cpu_possible_mask);
-		if (!cpumask_empty(&bad)) {
-			char buf[NR_CPUS * 5];
-			cpulist_scnprintf(buf, sizeof(buf), &bad);
-			pr_info("ktext: not using unavailable cpus %s\n", buf);
-		}
+		if (!cpumask_empty(&bad))
+			pr_info("ktext: not using unavailable cpus %*pbl\n",
+				cpumask_pr_args(&bad));
 		if (cpumask_empty(&ktext_mask)) {
 			pr_warn("ktext: no valid cpus; caching on %d\n",
 				smp_processor_id());
diff -puN drivers/net/ethernet/tile/tilegx.c~tile-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks drivers/net/ethernet/tile/tilegx.c
--- a/drivers/net/ethernet/tile/tilegx.c~tile-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/drivers/net/ethernet/tile/tilegx.c
@@ -292,7 +292,6 @@ static inline int mpipe_instance(struct
  */
 static bool network_cpus_init(void)
 {
-	char buf[1024];
 	int rc;
 
 	if (network_cpus_string == NULL)
@@ -314,8 +313,8 @@ static bool network_cpus_init(void)
 		return false;
 	}
 
-	cpulist_scnprintf(buf, sizeof(buf), &network_cpus_map);
-	pr_info("Linux network CPUs: %s\n", buf);
+	pr_info("Linux network CPUs: %*pbl\n",
+		cpumask_pr_args(&network_cpus_map));
 	return true;
 }
 
diff -puN drivers/net/ethernet/tile/tilepro.c~tile-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks drivers/net/ethernet/tile/tilepro.c
--- a/drivers/net/ethernet/tile/tilepro.c~tile-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/drivers/net/ethernet/tile/tilepro.c
@@ -2410,9 +2410,8 @@ static int __init network_cpus_setup(cha
 		if (cpumask_empty(&network_cpus_map)) {
 			pr_warn("Ignoring network_cpus='%s'\n", str);
 		} else {
-			char buf[1024];
-			cpulist_scnprintf(buf, sizeof(buf), &network_cpus_map);
-			pr_info("Linux network CPUs: %s\n", buf);
+			pr_info("Linux network CPUs: %*pbl\n",
+				cpumask_pr_args(&network_cpus_map));
 			network_cpus_used = true;
 		}
 	}
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

