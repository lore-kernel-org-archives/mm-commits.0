From: akpm@linux-foundation.org
Subject: + revert-sched-fix-uneven-per-cpu-task_group-share-distribution.patch added to -mm tree
Date: Fri, 19 Dec 2008 14:24:44 -0800
Message-ID: <200812192240.mBJMehTZ019606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37030 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750976AbYLSWlV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Dec 2008 17:41:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, kenchen@google.com, mingo@elte.hu


The patch titled
     revert "sched: fix uneven per-cpu task_group share distribution"
has been added to the -mm tree.  Its filename is
     revert-sched-fix-uneven-per-cpu-task_group-share-distribution.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "sched: fix uneven per-cpu task_group share distribution"
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Ken Chen <kenchen@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   43 +++++++++++++++++++------------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff -puN kernel/sched.c~revert-sched-fix-uneven-per-cpu-task_group-share-distribution kernel/sched.c
--- a/kernel/sched.c~revert-sched-fix-uneven-per-cpu-task_group-share-distribution
+++ a/kernel/sched.c
@@ -1475,34 +1475,24 @@ static void __set_se_shares(struct sched
  * Calculate and set the cpu's group shares.
  */
 static void
-update_group_shares_cpu(struct task_group *tg, int cpu, int empty,
+update_group_shares_cpu(struct task_group *tg, int cpu,
 			unsigned long sd_shares, unsigned long sd_rq_weight)
 {
-	unsigned long shares, raw_shares;
+	unsigned long shares;
 	unsigned long rq_weight;
 
 	if (!tg->se[cpu])
 		return;
 
 	rq_weight = tg->cfs_rq[cpu]->rq_weight;
-	if (rq_weight) {
-		/*
-		 *           \Sum shares * rq_weight
-		 * shares =  -----------------------
-		 *               \Sum rq_weight
-		 *
-		 */
-		raw_shares = (sd_shares * rq_weight) / sd_rq_weight;
-		shares = raw_shares;
-	} else {
-		/*
-		 * If there are currently no tasks on the cpu pretend there
-		 * is one of average load so that when a new task gets to
-		 * run here it will not get delayed by group starvation.
-		 */
-		raw_shares = 0;
-		shares = sd_shares / empty;
-	}
+
+	/*
+	 *           \Sum shares * rq_weight
+	 * shares =  -----------------------
+	 *               \Sum rq_weight
+	 *
+	 */
+	shares = (sd_shares * rq_weight) / sd_rq_weight;
 	shares = clamp_t(unsigned long, shares, MIN_SHARES, MAX_SHARES);
 
 	if (abs(shares - tg->se[cpu]->load.weight) >
@@ -1511,7 +1501,7 @@ update_group_shares_cpu(struct task_grou
 		unsigned long flags;
 
 		spin_lock_irqsave(&rq->lock, flags);
-		tg->cfs_rq[cpu]->shares = raw_shares;
+		tg->cfs_rq[cpu]->shares = shares;
 
 		__set_se_shares(tg->se[cpu], shares);
 		spin_unlock_irqrestore(&rq->lock, flags);
@@ -1528,12 +1518,17 @@ static int tg_shares_up(struct task_grou
 	unsigned long weight, rq_weight = 0;
 	unsigned long shares = 0;
 	struct sched_domain *sd = data;
-	int i, empty = 0;
+	int i;
 
 	for_each_cpu(i, sched_domain_span(sd)) {
+		/*
+		 * If there are currently no tasks on the cpu pretend there
+		 * is one of average load so that when a new task gets to
+		 * run here it will not get delayed by group starvation.
+		 */
 		weight = tg->cfs_rq[i]->load.weight;
 		if (!weight)
-			empty++;
+			weight = NICE_0_LOAD;
 
 		tg->cfs_rq[i]->rq_weight = weight;
 		rq_weight += weight;
@@ -1547,7 +1542,7 @@ static int tg_shares_up(struct task_grou
 		shares = tg->shares;
 
 	for_each_cpu(i, sched_domain_span(sd))
-		update_group_shares_cpu(tg, i, empty, shares, rq_weight);
+		update_group_shares_cpu(tg, i, shares, rq_weight);
 
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
revert-sched-fix-uneven-per-cpu-task_group-share-distribution.patch
sched-hackery.patch
fs-dlm-astc-fix-warning.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error-fix.patch
vmscan-shrink_active_list-reduce-lru_lock-hold-time.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-mmapc-fix-coding-style-fix.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take6.patch
ioc4-automatically-load-sgiioc4-subordinate-module-checkpatch-fixes.patch
smp_call_function_single-be-slightly-less-stupid.patch
kernel-hrtimerc-kill-warning.patch
binfmtsh-include-listh-fix.patch
spi_gpio-driver-cleanups.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-support-probing-module-__exit-function-fix-2.patch
nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes.patch
nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes-checkpatch-fixes.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
edac-x38-use-the-architectures-readq-function-fix-fix.patch
parport-ieee1284-use-del_timer_sync-in-parport_wait_event-checkpatch-fixes.patch
w1-allow-master-io-commands-fix.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

