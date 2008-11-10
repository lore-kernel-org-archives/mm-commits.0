From: akpm@linux-foundation.org
Subject: - oom-do-not-dump-task-state-for-non-thread-group-leaders.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:32:23 -0800
Message-ID: <200811102032.mAAKWNxs023918@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48371 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753227AbYKJUc5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:32:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, cl@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     oom: do not dump task state for non thread group leaders
has been removed from the -mm tree.  Its filename was
     oom-do-not-dump-task-state-for-non-thread-group-leaders.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: do not dump task state for non thread group leaders
From: David Rientjes <rientjes@google.com>

When /proc/sys/vm/oom_dump_tasks is enabled, it's only necessary to dump
task state information for thread group leaders.  The kernel log gets
quickly overwhelmed on machines with a massive number of threads by
dumping non-thread group leaders.

Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/oom_kill.c~oom-do-not-dump-task-state-for-non-thread-group-leaders mm/oom_kill.c
--- a/mm/oom_kill.c~oom-do-not-dump-task-state-for-non-thread-group-leaders
+++ a/mm/oom_kill.c
@@ -295,6 +295,8 @@ static void dump_tasks(const struct mem_
 			continue;
 		if (mem && !task_in_mem_cgroup(p, mem))
 			continue;
+		if (!thread_group_leader(p))
+			continue;
 
 		task_lock(p);
 		printk(KERN_INFO "[%5d] %5d %5d %8lu %8lu %3d     %3d %s\n",
_

Patches currently in -mm which might be from rientjes@google.com are

cpusets-update-mems-allowed-in-page-allocator.patch
cpusets-update-mems-allowed-in-page-allocator-fix.patch
oom-fix-zone_scan_mutex-name.patch
oom-print-triggering-tasks-cpuset-and-mems-allowed.patch

