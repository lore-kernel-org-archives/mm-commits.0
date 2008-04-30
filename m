From: akpm@linux-foundation.org
Subject: - memcgroup-implement-failcounter-reset.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:43:07 -0700
Message-ID: <200804300543.m3U5h7SA029293@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758330AbYD3GMk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     memcgroup: implement failcounter reset
has been removed from the -mm tree.  Its filename was
     memcgroup-implement-failcounter-reset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcgroup: implement failcounter reset
From: Pavel Emelyanov <xemul@openvz.org>

This is a very common requirement from people using the resource accounting
facilities (not only memcgroup but also OpenVZ beancounters).  They want to
put the cgroup in an initial state without re-creating it.

For example after re-configuring a group people want to observe how this new
configuration fits the group needs without saving the previous failcnt value.

Merge two resets into one mem_cgroup_reset() function to demonstrate how
multiplexing work.

Besides, I have plans to move the files, that correspond to res_counter to the
res_counter.c file and somehow "import" them into controller.  I don't know
how to make it gracefully yet, but merging resets of max_usage and failcnt in
one function will be there for sure.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |    8 ++++++++
 mm/memcontrol.c             |   14 +++++++++++---
 2 files changed, 19 insertions(+), 3 deletions(-)

diff -puN include/linux/res_counter.h~memcgroup-implement-failcounter-reset include/linux/res_counter.h
--- a/include/linux/res_counter.h~memcgroup-implement-failcounter-reset
+++ a/include/linux/res_counter.h
@@ -143,4 +143,12 @@ static inline void res_counter_reset_max
 	spin_unlock_irqrestore(&cnt->lock, flags);
 }
 
+static inline void res_counter_reset_failcnt(struct res_counter *cnt)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cnt->lock, flags);
+	cnt->failcnt = 0;
+	spin_unlock_irqrestore(&cnt->lock, flags);
+}
 #endif
diff -puN mm/memcontrol.c~memcgroup-implement-failcounter-reset mm/memcontrol.c
--- a/mm/memcontrol.c~memcgroup-implement-failcounter-reset
+++ a/mm/memcontrol.c
@@ -857,12 +857,19 @@ static ssize_t mem_cgroup_write(struct c
 				mem_cgroup_write_strategy);
 }
 
-static int mem_cgroup_max_reset(struct cgroup *cont, unsigned int event)
+static int mem_cgroup_reset(struct cgroup *cont, unsigned int event)
 {
 	struct mem_cgroup *mem;
 
 	mem = mem_cgroup_from_cont(cont);
-	res_counter_reset_max(&mem->res);
+	switch (event) {
+	case RES_MAX_USAGE:
+		res_counter_reset_max(&mem->res);
+		break;
+	case RES_FAILCNT:
+		res_counter_reset_failcnt(&mem->res);
+		break;
+	}
 	return 0;
 }
 
@@ -916,7 +923,7 @@ static struct cftype mem_cgroup_files[] 
 	{
 		.name = "max_usage_in_bytes",
 		.private = RES_MAX_USAGE,
-		.trigger = mem_cgroup_max_reset,
+		.trigger = mem_cgroup_reset,
 		.read_u64 = mem_cgroup_read,
 	},
 	{
@@ -928,6 +935,7 @@ static struct cftype mem_cgroup_files[] 
 	{
 		.name = "failcnt",
 		.private = RES_FAILCNT,
+		.trigger = mem_cgroup_reset,
 		.read_u64 = mem_cgroup_read,
 	},
 	{
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

