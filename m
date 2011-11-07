From: akpm@linux-foundation.org
Subject: [merged] cpusets-avoid-looping-when-storing-to-mems_allowed-if-one-node-remains-set.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:27:36 -0800
Message-ID: <201111072027.pA7KRa2o028458@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:47274 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab1KGU1t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:27:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, miaox@cn.fujitsu.com, npiggin@kernel.dk, paul@paulmenage.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cpusets: avoid looping when storing to mems_allowed if one node remains set
has been removed from the -mm tree.  Its filename was
     cpusets-avoid-looping-when-storing-to-mems_allowed-if-one-node-remains-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: cpusets: avoid looping when storing to mems_allowed if one node remains set

{get,put}_mems_allowed() exist so that general kernel code may locklessly
access a task's set of allowable nodes without having the chance that a
concurrent write will cause the nodemask to be empty on configurations
where MAX_NUMNODES > BITS_PER_LONG.

This could incur a significant delay, however, especially in low memory
conditions because the page allocator is blocking and reclaim requires
get_mems_allowed() itself.  It is not atypical to see writes to
cpuset.mems take over 2 seconds to complete, for example.  In low memory
conditions, this is problematic because it's one of the most imporant
times to change cpuset.mems in the first place!

The only way a task's set of allowable nodes may change is through cpusets
by writing to cpuset.mems and when attaching a task to a generic code is
not reading the nodemask with get_mems_allowed() at the same time, and
then clearing all the old nodes.  This prevents the possibility that a
reader will see an empty nodemask at the same time the writer is storing a
new nodemask.

If at least one node remains unchanged, though, it's possible to simply
set all new nodes and then clear all the old nodes.  Changing a task's
nodemask is protected by cgroup_mutex so it's guaranteed that two threads
are not changing the same task's nodemask at the same time, so the
nodemask is guaranteed to be stored before another thread changes it and
determines whether a node remains set or not.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Paul Menage <paul@paulmenage.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN kernel/cpuset.c~cpusets-avoid-looping-when-storing-to-mems_allowed-if-one-node-remains-set kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-avoid-looping-when-storing-to-mems_allowed-if-one-node-remains-set
+++ a/kernel/cpuset.c
@@ -949,6 +949,8 @@ static void cpuset_migrate_mm(struct mm_
 static void cpuset_change_task_nodemask(struct task_struct *tsk,
 					nodemask_t *newmems)
 {
+	bool masks_disjoint = !nodes_intersects(*newmems, tsk->mems_allowed);
+
 repeat:
 	/*
 	 * Allow tasks that have access to memory reserves because they have
@@ -963,7 +965,6 @@ repeat:
 	nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);
 	mpol_rebind_task(tsk, newmems, MPOL_REBIND_STEP1);
 
-
 	/*
 	 * ensure checking ->mems_allowed_change_disable after setting all new
 	 * allowed nodes.
@@ -980,9 +981,11 @@ repeat:
 
 	/*
 	 * Allocation of memory is very fast, we needn't sleep when waiting
-	 * for the read-side.
+	 * for the read-side.  No wait is necessary, however, if at least one
+	 * node remains unchanged.
 	 */
-	while (ACCESS_ONCE(tsk->mems_allowed_change_disable)) {
+	while (masks_disjoint &&
+			ACCESS_ONCE(tsk->mems_allowed_change_disable)) {
 		task_unlock(tsk);
 		if (!task_curr(tsk))
 			yield();
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
drm-avoid-switching-to-text-console-if-there-is-no-panic-timeout.patch

