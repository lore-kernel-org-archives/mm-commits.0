From: akpm@linux-foundation.org
Subject: [merged] taskstats-add-e-u-stime-for-tgid-command.patch
 removed from -mm tree
Date: Tue, 09 May 2017 11:02:03 -0700
Message-ID: <20170509180203.biIKGTGjS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34568 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753907AbdEISCE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:02:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bsingharora@gmail.com, mm-commits@vger.kernel.org, oleg@redhat.com, xiao.zhang@windriver.com


The patch titled
     Subject: taskstats: add e/u/stime for TGID command
has been removed from the -mm tree.  Its filename was
     taskstats-add-e-u-stime-for-tgid-command.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Xiao <xiao.zhang@windriver.com>
Subject: taskstats: add e/u/stime for TGID command

The elapsed time, user CPU time and system CPU time for the thread group
status request are presently left at zero.  Fill these in.

[akpm@linux-foundation.org: run ktime_get_ns() a single time]
[akpm@linux-foundation.org: include linux/sched/cputime.h for task_cputime()]
Link: http://lkml.kernel.org/r/1488508424-12322-1-git-send-email-xiao.zhang@windriver.com
Signed-off-by: Zhang Xiao <xiao.zhang@windriver.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN kernel/taskstats.c~taskstats-add-e-u-stime-for-tgid-command kernel/taskstats.c
--- a/kernel/taskstats.c~taskstats-add-e-u-stime-for-tgid-command
+++ a/kernel/taskstats.c
@@ -30,6 +30,7 @@
 #include <linux/pid_namespace.h>
 #include <net/genetlink.h>
 #include <linux/atomic.h>
+#include <linux/sched/cputime.h>
 
 /*
  * Maximum length of a cpumask that can be specified in
@@ -210,6 +211,8 @@ static int fill_stats_for_tgid(pid_t tgi
 	struct task_struct *tsk, *first;
 	unsigned long flags;
 	int rc = -ESRCH;
+	u64 delta, utime, stime;
+	u64 start_time;
 
 	/*
 	 * Add additional stats from live tasks except zombie thread group
@@ -227,6 +230,7 @@ static int fill_stats_for_tgid(pid_t tgi
 		memset(stats, 0, sizeof(*stats));
 
 	tsk = first;
+	start_time = ktime_get_ns();
 	do {
 		if (tsk->exit_state)
 			continue;
@@ -238,6 +242,16 @@ static int fill_stats_for_tgid(pid_t tgi
 		 */
 		delayacct_add_tsk(stats, tsk);
 
+		/* calculate task elapsed time in nsec */
+		delta = start_time - tsk->start_time;
+		/* Convert to micro seconds */
+		do_div(delta, NSEC_PER_USEC);
+		stats->ac_etime += delta;
+
+		task_cputime(tsk, &utime, &stime);
+		stats->ac_utime += div_u64(utime, NSEC_PER_USEC);
+		stats->ac_stime += div_u64(stime, NSEC_PER_USEC);
+
 		stats->nvcsw += tsk->nvcsw;
 		stats->nivcsw += tsk->nivcsw;
 	} while_each_thread(first, tsk);
_

Patches currently in -mm which might be from xiao.zhang@windriver.com are


