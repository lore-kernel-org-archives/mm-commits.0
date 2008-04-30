From: akpm@linux-foundation.org
Subject: - memcgroup-use-triggers-in-force_empty-and-max_usage-files.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:43:05 -0700
Message-ID: <200804300543.m3U5h5OG029290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759810AbYD3GMk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     memcgroup: use triggers in force_empty and max_usage files
has been removed from the -mm tree.  Its filename was
     memcgroup-use-triggers-in-force_empty-and-max_usage-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcgroup: use triggers in force_empty and max_usage files
From: Pavel Emelyanov <xemul@openvz.org>

These two files are essentially event callbacks.  They do not care about the
contents of the string, but only about the fact of the write itself.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff -puN mm/memcontrol.c~memcgroup-use-triggers-in-force_empty-and-max_usage-files mm/memcontrol.c
--- a/mm/memcontrol.c~memcgroup-use-triggers-in-force_empty-and-max_usage-files
+++ a/mm/memcontrol.c
@@ -857,27 +857,18 @@ static ssize_t mem_cgroup_write(struct c
 				mem_cgroup_write_strategy);
 }
 
-static ssize_t mem_cgroup_max_reset(struct cgroup *cont, struct cftype *cft,
-				struct file *file, const char __user *userbuf,
-				size_t nbytes, loff_t *ppos)
+static int mem_cgroup_max_reset(struct cgroup *cont, unsigned int event)
 {
 	struct mem_cgroup *mem;
 
 	mem = mem_cgroup_from_cont(cont);
 	res_counter_reset_max(&mem->res);
-	return nbytes;
+	return 0;
 }
 
-static ssize_t mem_force_empty_write(struct cgroup *cont,
-				struct cftype *cft, struct file *file,
-				const char __user *userbuf,
-				size_t nbytes, loff_t *ppos)
+static int mem_force_empty_write(struct cgroup *cont, unsigned int event)
 {
-	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
-	int ret = mem_cgroup_force_empty(mem);
-	if (!ret)
-		ret = nbytes;
-	return ret;
+	return mem_cgroup_force_empty(mem_cgroup_from_cont(cont));
 }
 
 static const struct mem_cgroup_stat_desc {
@@ -925,7 +916,7 @@ static struct cftype mem_cgroup_files[] 
 	{
 		.name = "max_usage_in_bytes",
 		.private = RES_MAX_USAGE,
-		.write = mem_cgroup_max_reset,
+		.trigger = mem_cgroup_max_reset,
 		.read_u64 = mem_cgroup_read,
 	},
 	{
@@ -941,7 +932,7 @@ static struct cftype mem_cgroup_files[] 
 	},
 	{
 		.name = "force_empty",
-		.write = mem_force_empty_write,
+		.trigger = mem_force_empty_write,
 	},
 	{
 		.name = "stat",
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
disable-the-memory-controller-by-default-v3.patch
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
ptrace-allow-to-ptrace-sbin-init.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
deprecate-find_task_by_pid-warning-fix.patch
pids-de_thread-dont-clear-session-pgrp-pids-for-the-old-leader.patch
pids-introduce-change_pid-helper.patch
pids-sys_setpgid-use-change_pid-helper.patch
pids-__set_special_pids-use-change_pid-helper.patch
pidns-make-pid-level-and-pid_ns-level-unsigned.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

