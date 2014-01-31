From: akpm@linux-foundation.org
Subject: [merged] mm-oom-base-root-bonus-on-current-usage.patch removed
 from -mm tree
Date: Fri, 31 Jan 2014 11:16:42 -0800
Message-ID: <52ebf69a.uZpMa0oCrrHjFqSh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651AbaAaTQn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 14:16:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, rientjes@google.com

Subject: [merged] mm-oom-base-root-bonus-on-current-usage.patch removed from -mm tree
To: rientjes@google.com,hannes@cmpxchg.org,mhocko@suse.cz,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 11:16:42 -0800


The patch titled
     Subject: mm, oom: base root bonus on current usage
has been removed from the -mm tree.  Its filename was
     mm-oom-base-root-bonus-on-current-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: base root bonus on current usage

A 3% of system memory bonus is sometimes too excessive in comparison to
other processes.

With a63d83f427fb ("oom: badness heuristic rewrite"), the OOM killer tries
to avoid killing privileged tasks by subtracting 3% of overall memory
(system or cgroup) from their per-task consumption.  But as a result, all
root tasks that consume less than 3% of overall memory are considered
equal, and so it only takes 33+ privileged tasks pushing the system out of
memory for the OOM killer to do something stupid and kill dhclient or
other root-owned processes.  For example, on a 32G machine it can't tell
the difference between the 1M agetty and the 10G fork bomb member.

The changelog describes this 3% boost as the equivalent to the global
overcommit limit being 3% higher for privileged tasks, but this is not the
same as discounting 3% of overall memory from _every privileged task
individually_ during OOM selection.

Replace the 3% of system memory bonus with a 3% of current memory usage
bonus.

By giving root tasks a bonus that is proportional to their actual size,
they remain comparable even when relatively small.  In the example above,
the OOM killer will discount the 1M agetty's 256 badness points down to
179, and the 10G fork bomb's 262144 points down to 183500 points and make
the right choice, instead of discounting both to 0 and killing agetty
because it's first in the task list.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    4 ++--
 mm/oom_kill.c                      |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-oom-base-root-bonus-on-current-usage Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-oom-base-root-bonus-on-current-usage
+++ a/Documentation/filesystems/proc.txt
@@ -1386,8 +1386,8 @@ may allocate from based on an estimation
 For example, if a task is using all allowed memory, its badness score will be
 1000.  If it is using half of its allowed memory, its score will be 500.
 
-There is an additional factor included in the badness score: root
-processes are given 3% extra memory over other tasks.
+There is an additional factor included in the badness score: the current memory
+and swap usage is discounted by 3% for root processes.
 
 The amount of "allowed" memory depends on the context in which the oom killer
 was called.  If it is due to the memory assigned to the allocating task's cpuset
diff -puN mm/oom_kill.c~mm-oom-base-root-bonus-on-current-usage mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-base-root-bonus-on-current-usage
+++ a/mm/oom_kill.c
@@ -178,7 +178,7 @@ unsigned long oom_badness(struct task_st
 	 * implementation used by LSMs.
 	 */
 	if (has_capability_noaudit(p, CAP_SYS_ADMIN))
-		adj -= 30;
+		points -= (points * 3) / 100;
 
 	/* Normalize to oom_score_adj units */
 	adj *= totalpages / 1000;
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix.patch
numa-mem-hotplug-fix-array-index-overflow-when-synchronizing-nid-to-memblockreserved.patch
mm-slb-fix-misleading-comments.patch
mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
mm-remove-bug_on-from-mlock_vma_page.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
cpusets-allocate-heap-only-when-required.patch
linux-next.patch

