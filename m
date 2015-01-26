From: akpm@linux-foundation.org
Subject: +
 x86-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch added
 to -mm tree
Date: Mon, 26 Jan 2015 15:06:56 -0800
Message-ID: <54c6c890.T2f55KMzGh1K04Vy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890AbbAZXG5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jan 2015 18:06:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, travis@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been added to the -mm tree.  Its filename is
     x86-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-use-%25pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-use-%25pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

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
Subject: x86: use %*pb[l] to print bitmaps including cpumasks and nodemasks

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

* Unnecessary buffer size calculation and condition on the lenght
  removed from intel_cacheinfo.c::show_shared_cpu_map_func().

* uv_nmi_nr_cpus_pr() got overly smart and implemented "..."
  abbreviation if the output stretched over the predefined 1024 byte
  buffer.  Replaced with plain printk.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mike Travis <travis@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/intel_cacheinfo.c |   24 ++++++++++-------------
 arch/x86/mm/numa.c                    |    6 +----
 arch/x86/platform/uv/uv_nmi.c         |   25 ++++++------------------
 3 files changed, 20 insertions(+), 35 deletions(-)

diff -puN arch/x86/kernel/cpu/intel_cacheinfo.c~x86-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks arch/x86/kernel/cpu/intel_cacheinfo.c
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c~x86-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -952,20 +952,18 @@ static ssize_t show_size(struct _cpuid4_
 static ssize_t show_shared_cpu_map_func(struct _cpuid4_info *this_leaf,
 					int type, char *buf)
 {
-	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf;
-	int n = 0;
+	const struct cpumask *mask = to_cpumask(this_leaf->shared_cpu_map);
+	int ret;
 
-	if (len > 1) {
-		const struct cpumask *mask;
-
-		mask = to_cpumask(this_leaf->shared_cpu_map);
-		n = type ?
-			cpulist_scnprintf(buf, len-2, mask) :
-			cpumask_scnprintf(buf, len-2, mask);
-		buf[n++] = '\n';
-		buf[n] = '\0';
-	}
-	return n;
+	if (type)
+		ret = scnprintf(buf, PAGE_SIZE - 1, "%*pbl",
+				cpumask_pr_args(mask));
+	else
+		ret = scnprintf(buf, PAGE_SIZE - 1, "%*pb",
+				cpumask_pr_args(mask));
+	buf[ret++] = '\n';
+	buf[ret] = '\0';
+	return ret;
 }
 
 static inline ssize_t show_shared_cpu_map(struct _cpuid4_info *leaf, char *buf,
diff -puN arch/x86/mm/numa.c~x86-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~x86-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/arch/x86/mm/numa.c
@@ -794,7 +794,6 @@ int early_cpu_to_node(int cpu)
 void debug_cpumask_set_cpu(int cpu, int node, bool enable)
 {
 	struct cpumask *mask;
-	char buf[64];
 
 	if (node == NUMA_NO_NODE) {
 		/* early_cpu_to_node() already emits a warning and trace */
@@ -812,10 +811,9 @@ void debug_cpumask_set_cpu(int cpu, int
 	else
 		cpumask_clear_cpu(cpu, mask);
 
-	cpulist_scnprintf(buf, sizeof(buf), mask);
-	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
+	printk(KERN_DEBUG "%s cpu %d node %d: mask now %*pbl\n",
 		enable ? "numa_add_cpu" : "numa_remove_cpu",
-		cpu, node, buf);
+		cpu, node, cpumask_pr_args(mask));
 	return;
 }
 
diff -puN arch/x86/platform/uv/uv_nmi.c~x86-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks arch/x86/platform/uv/uv_nmi.c
--- a/arch/x86/platform/uv/uv_nmi.c~x86-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/arch/x86/platform/uv/uv_nmi.c
@@ -273,20 +273,6 @@ static inline void uv_clear_nmi(int cpu)
 	}
 }
 
-/* Print non-responding cpus */
-static void uv_nmi_nr_cpus_pr(char *fmt)
-{
-	static char cpu_list[1024];
-	int len = sizeof(cpu_list);
-	int c = cpumask_weight(uv_nmi_cpu_mask);
-	int n = cpulist_scnprintf(cpu_list, len, uv_nmi_cpu_mask);
-
-	if (n >= len-1)
-		strcpy(&cpu_list[len - 6], "...\n");
-
-	printk(fmt, c, cpu_list);
-}
-
 /* Ping non-responding cpus attemping to force them into the NMI handler */
 static void uv_nmi_nr_cpus_ping(void)
 {
@@ -371,16 +357,19 @@ static void uv_nmi_wait(int master)
 			break;
 
 		/* if not all made it in, send IPI NMI to them */
-		uv_nmi_nr_cpus_pr(KERN_ALERT
-			"UV: Sending NMI IPI to %d non-responding CPUs: %s\n");
+		pr_alert("UV: Sending NMI IPI to %d non-responding CPUs: %*pbl\n",
+			 cpumask_weight(uv_nmi_cpu_mask),
+			 cpumask_pr_args(uv_nmi_cpu_mask));
+
 		uv_nmi_nr_cpus_ping();
 
 		/* if all cpus are in, then done */
 		if (!uv_nmi_wait_cpus(0))
 			break;
 
-		uv_nmi_nr_cpus_pr(KERN_ALERT
-			"UV: %d CPUs not in NMI loop: %s\n");
+		pr_alert("UV: %d CPUs not in NMI loop: %*pbl\n",
+			 cpumask_weight(uv_nmi_cpu_mask),
+			 cpumask_pr_args(uv_nmi_cpu_mask));
 	} while (0);
 
 	pr_alert("UV: %d of %d CPUs in NMI\n",
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

