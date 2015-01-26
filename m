From: akpm@linux-foundation.org
Subject: +
 cpuset-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
 added to -mm tree
Date: Mon, 26 Jan 2015 15:07:04 -0800
Message-ID: <54c6c898.9Rr+QS20qorY73My%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46133 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586AbbAZXHF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jan 2015 18:07:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, lizefan@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cpuset: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been added to the -mm tree.  Its filename is
     cpuset-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cpuset-use-%25pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cpuset-use-%25pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

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
Subject: cpuset: use %*pb[l] to print bitmaps including cpumasks and nodemasks

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

* kernel/cpuset.c::cpuset_print_task_mems_allowed() used a static
  buffer which is protected by a dedicated spinlock.  Removed.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   42 +++++++++---------------------------------
 1 file changed, 9 insertions(+), 33 deletions(-)

diff -puN kernel/cpuset.c~cpuset-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/kernel/cpuset.c
@@ -1707,40 +1707,27 @@ static int cpuset_common_seq_show(struct
 {
 	struct cpuset *cs = css_cs(seq_css(sf));
 	cpuset_filetype_t type = seq_cft(sf)->private;
-	ssize_t count;
-	char *buf, *s;
 	int ret = 0;
 
-	count = seq_get_buf(sf, &buf);
-	s = buf;
-
 	spin_lock_irq(&callback_lock);
 
 	switch (type) {
 	case FILE_CPULIST:
-		s += cpulist_scnprintf(s, count, cs->cpus_allowed);
+		seq_printf(sf, "%*pbl\n", cpumask_pr_args(cs->cpus_allowed));
 		break;
 	case FILE_MEMLIST:
-		s += nodelist_scnprintf(s, count, cs->mems_allowed);
+		seq_printf(sf, "%*pbl\n", nodemask_pr_args(&cs->mems_allowed));
 		break;
 	case FILE_EFFECTIVE_CPULIST:
-		s += cpulist_scnprintf(s, count, cs->effective_cpus);
+		seq_printf(sf, "%*pbl\n", cpumask_pr_args(cs->effective_cpus));
 		break;
 	case FILE_EFFECTIVE_MEMLIST:
-		s += nodelist_scnprintf(s, count, cs->effective_mems);
+		seq_printf(sf, "%*pbl\n", nodemask_pr_args(&cs->effective_mems));
 		break;
 	default:
 		ret = -EINVAL;
-		goto out_unlock;
 	}
 
-	if (s < buf + count - 1) {
-		*s++ = '\n';
-		seq_commit(sf, s - buf);
-	} else {
-		seq_commit(sf, -1);
-	}
-out_unlock:
 	spin_unlock_irq(&callback_lock);
 	return ret;
 }
@@ -2610,8 +2597,6 @@ int cpuset_mems_allowed_intersects(const
 	return nodes_intersects(tsk1->mems_allowed, tsk2->mems_allowed);
 }
 
-#define CPUSET_NODELIST_LEN	(256)
-
 /**
  * cpuset_print_task_mems_allowed - prints task's cpuset and mems_allowed
  * @tsk: pointer to task_struct of some task.
@@ -2621,23 +2606,16 @@ int cpuset_mems_allowed_intersects(const
  */
 void cpuset_print_task_mems_allowed(struct task_struct *tsk)
 {
-	 /* Statically allocated to prevent using excess stack. */
-	static char cpuset_nodelist[CPUSET_NODELIST_LEN];
-	static DEFINE_SPINLOCK(cpuset_buffer_lock);
 	struct cgroup *cgrp;
 
-	spin_lock(&cpuset_buffer_lock);
 	rcu_read_lock();
 
 	cgrp = task_cs(tsk)->css.cgroup;
-	nodelist_scnprintf(cpuset_nodelist, CPUSET_NODELIST_LEN,
-			   tsk->mems_allowed);
 	pr_info("%s cpuset=", tsk->comm);
 	pr_cont_cgroup_name(cgrp);
-	pr_cont(" mems_allowed=%s\n", cpuset_nodelist);
+	pr_cont(" mems_allowed=%*pbl\n", nodemask_pr_args(&tsk->mems_allowed));
 
 	rcu_read_unlock();
-	spin_unlock(&cpuset_buffer_lock);
 }
 
 /*
@@ -2715,10 +2693,8 @@ out:
 /* Display task mems_allowed in /proc/<pid>/status file. */
 void cpuset_task_status_allowed(struct seq_file *m, struct task_struct *task)
 {
-	seq_puts(m, "Mems_allowed:\t");
-	seq_nodemask(m, &task->mems_allowed);
-	seq_puts(m, "\n");
-	seq_puts(m, "Mems_allowed_list:\t");
-	seq_nodemask_list(m, &task->mems_allowed);
-	seq_puts(m, "\n");
+	seq_printf(m, "Mems_allowed:\t%*pb\n",
+		   nodemask_pr_args(&task->mems_allowed));
+	seq_printf(m, "Mems_allowed_list:\t%*pbl\n",
+		   nodemask_pr_args(&task->mems_allowed));
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

