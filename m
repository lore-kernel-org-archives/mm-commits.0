From: akpm@linux-foundation.org
Subject: +
 mips-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch added
 to -mm tree
Date: Mon, 26 Jan 2015 15:06:50 -0800
Message-ID: <54c6c88a.2XAhmtmKA+0inMc3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbbAZXGv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jan 2015 18:06:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mips: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been added to the -mm tree.  Its filename is
     mips-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mips-use-%25pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mips-use-%25pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

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
Subject: mips: use %*pb[l] to print bitmaps including cpumasks and nodemasks

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/netlogic/common/smp.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN arch/mips/netlogic/common/smp.c~mips-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks arch/mips/netlogic/common/smp.c
--- a/arch/mips/netlogic/common/smp.c~mips-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/arch/mips/netlogic/common/smp.c
@@ -162,7 +162,6 @@ void __init nlm_smp_setup(void)
 	unsigned int boot_cpu;
 	int num_cpus, i, ncore, node;
 	volatile u32 *cpu_ready = nlm_get_boot_data(BOOT_CPU_READY);
-	char buf[64];
 
 	boot_cpu = hard_smp_processor_id();
 	cpumask_clear(&phys_cpu_present_mask);
@@ -189,10 +188,10 @@ void __init nlm_smp_setup(void)
 		}
 	}
 
-	cpumask_scnprintf(buf, ARRAY_SIZE(buf), &phys_cpu_present_mask);
-	pr_info("Physical CPU mask: %s\n", buf);
-	cpumask_scnprintf(buf, ARRAY_SIZE(buf), cpu_possible_mask);
-	pr_info("Possible CPU mask: %s\n", buf);
+	pr_info("Physical CPU mask: %*pb\n",
+		cpumask_pr_args(&phys_cpu_present_mask));
+	pr_info("Possible CPU mask: %*pb\n",
+		cpumask_pr_args(cpu_possible_mask));
 
 	/* check with the cores we have woken up */
 	for (ncore = 0, i = 0; i < NLM_NR_NODES; i++)
@@ -209,7 +208,6 @@ static int nlm_parse_cpumask(cpumask_t *
 {
 	uint32_t core0_thr_mask, core_thr_mask;
 	int threadmode, i, j;
-	char buf[64];
 
 	core0_thr_mask = 0;
 	for (i = 0; i < NLM_THREADS_PER_CORE; i++)
@@ -244,8 +242,7 @@ static int nlm_parse_cpumask(cpumask_t *
 	return threadmode;
 
 unsupp:
-	cpumask_scnprintf(buf, ARRAY_SIZE(buf), wakeup_mask);
-	panic("Unsupported CPU mask %s", buf);
+	panic("Unsupported CPU mask %*pb", cpumask_pr_args(wakeup_mask));
 	return 0;
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

