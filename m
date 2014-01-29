From: akpm@linux-foundation.org
Subject: + mm-oom-base-root-bonus-on-current-usage.patch added to -mm tree
Date: Wed, 29 Jan 2014 12:28:24 -0800
Message-ID: <52e96468.OxZ675hQZhWABAdE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaA2U2Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Jan 2014 15:28:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, rientjes@google.com

Subject: + mm-oom-base-root-bonus-on-current-usage.patch added to -mm tree
To: rientjes@google.com,hannes@cmpxchg.org,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Wed, 29 Jan 2014 12:28:24 -0800


The patch titled
     Subject: mm, oom: base root bonus on current usage
has been added to the -mm tree.  Its filename is
     mm-oom-base-root-bonus-on-current-usage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-base-root-bonus-on-current-usage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-base-root-bonus-on-current-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
memory for the OOM killer to do something stupid and kill sshd or
dhclient.  For example, on a 32G machine it can't tell the difference
between the 1M agetty and the 10G fork bomb member.

The changelog describes this 3% boost as the equivalent to the global
overcommit limit being 3% higher for privileged tasks, but this is not the
same as discounting 3% of overall memory from _every privileged task
individually_ during OOM selection.

Replace the 3% of system memory bonus with a 3% of current memory usage
bonus.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
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
slab-fix-wrong-retval-on-kmem_cache_create_memcg-error-path-2.patch
mm-oom-base-root-bonus-on-current-usage.patch
mm-remove-bug_on-from-mlock_vma_page.patch
mm-mempolicyc-fix-mempolicy-printing-in-numa_maps.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix.patch
numa-mem-hotplug-fix-array-index-overflow-when-synchronizing-nid-to-memblockreserved.patch
mm-slb-fix-misleading-comments.patch
mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
cpusets-allocate-heap-only-when-required.patch
linux-next.patch

