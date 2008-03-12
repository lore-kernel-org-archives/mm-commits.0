From: akpm@linux-foundation.org
Subject: + memcgroup-add-the-max_usage-member-on-the-res_counter.patch added to -mm tree
Date: Tue, 11 Mar 2008 21:41:47 -0700
Message-ID: <200803120441.m2C4flNT010442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422AbYCLEl6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Mar 2008 00:41:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcgroup: add the max_usage member on the res_counter
has been added to the -mm tree.  Its filename is
     memcgroup-add-the-max_usage-member-on-the-res_counter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcgroup: add the max_usage member on the res_counter
From: Pavel Emelyanov <xemul@openvz.org>

This field is the maximal value of the usage one since the counter creation
(or since the latest reset).

To reset this to the usage value simply write anything to the appropriate
cgroup file.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |   14 ++++++++++++++
 kernel/res_counter.c        |    4 ++++
 mm/memcontrol.c             |   17 +++++++++++++++++
 3 files changed, 35 insertions(+)

diff -puN include/linux/res_counter.h~memcgroup-add-the-max_usage-member-on-the-res_counter include/linux/res_counter.h
--- a/include/linux/res_counter.h~memcgroup-add-the-max_usage-member-on-the-res_counter
+++ a/include/linux/res_counter.h
@@ -25,6 +25,10 @@ struct res_counter {
 	 */
 	unsigned long long usage;
 	/*
+	 * the maximal value of the usage from the counter creation
+	 */
+	unsigned long long max_usage;
+	/*
 	 * the limit that usage cannot exceed
 	 */
 	unsigned long long limit;
@@ -67,6 +71,7 @@ ssize_t res_counter_write(struct res_cou
 
 enum {
 	RES_USAGE,
+	RES_MAX_USAGE,
 	RES_LIMIT,
 	RES_FAILCNT,
 };
@@ -127,4 +132,13 @@ static inline bool res_counter_check_und
 	return ret;
 }
 
+static inline void res_counter_reset_max(struct res_counter *cnt)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cnt->lock, flags);
+	cnt->max_usage = cnt->usage;
+	spin_unlock_irqrestore(&cnt->lock, flags);
+}
+
 #endif
diff -puN kernel/res_counter.c~memcgroup-add-the-max_usage-member-on-the-res_counter kernel/res_counter.c
--- a/kernel/res_counter.c~memcgroup-add-the-max_usage-member-on-the-res_counter
+++ a/kernel/res_counter.c
@@ -27,6 +27,8 @@ int res_counter_charge_locked(struct res
 	}
 
 	counter->usage += val;
+	if (counter->usage > counter->max_usage)
+		counter->max_usage = counter->usage;
 	return 0;
 }
 
@@ -65,6 +67,8 @@ res_counter_member(struct res_counter *c
 	switch (member) {
 	case RES_USAGE:
 		return &counter->usage;
+	case RES_MAX_USAGE:
+		return &counter->max_usage;
 	case RES_LIMIT:
 		return &counter->limit;
 	case RES_FAILCNT:
diff -puN mm/memcontrol.c~memcgroup-add-the-max_usage-member-on-the-res_counter mm/memcontrol.c
--- a/mm/memcontrol.c~memcgroup-add-the-max_usage-member-on-the-res_counter
+++ a/mm/memcontrol.c
@@ -868,6 +868,17 @@ static ssize_t mem_cgroup_write(struct c
 				mem_cgroup_write_strategy);
 }
 
+static ssize_t mem_cgroup_max_reset(struct cgroup *cont, struct cftype *cft,
+				struct file *file, const char __user *userbuf,
+				size_t nbytes, loff_t *ppos)
+{
+	struct mem_cgroup *mem;
+
+	mem = mem_cgroup_from_cont(cont);
+	res_counter_reset_max(&mem->res);
+	return nbytes;
+}
+
 static ssize_t mem_force_empty_write(struct cgroup *cont,
 				struct cftype *cft, struct file *file,
 				const char __user *userbuf,
@@ -923,6 +934,12 @@ static struct cftype mem_cgroup_files[] 
 		.read_u64 = mem_cgroup_read,
 	},
 	{
+		.name = "max_usage_in_bytes",
+		.private = RES_MAX_USAGE,
+		.write = mem_cgroup_max_reset,
+		.read_u64 = mem_cgroup_read,
+	},
+	{
 		.name = "limit_in_bytes",
 		.private = RES_LIMIT,
 		.write = mem_cgroup_write,
_

Patches currently in -mm which might be from xemul@openvz.org are

git-kgdb-light.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-getpid-and-set_tid_address-fast-system-calls-for-pid-namespaces.patch
git-udf.patch
git-net.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time.patch
memory-controller-make-memory-resource-control-aware-of-boot-options.patch
memcgroup-add-the-max_usage-member-on-the-res_counter.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
signals-use-__group_complete_signal-for-the-specific-signals-too.patch
signals-fold-complete_signal-into-send_signal-do_send_sigqueue.patch
signals-unify-send_sigqueue-send_group_sigqueue-completely.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
deprecate-find_task_by_pid-warning-fix.patch
pidns-make-pid-level-and-pid_ns-level-unsigned.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

