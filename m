From: akpm@linux-foundation.org
Subject: + cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask.patch added to -mm tree
Date: Thu, 17 Nov 2011 16:00:49 -0800
Message-ID: <201111180000.pAI00nxt000345@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:41268 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab1KRAAw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2011 19:00:52 -0500
Received: by qyd20 with SMTP id 20so430818qyd.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2011 16:00:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, miaox@cn.fujitsu.com, paul@paulmenage.org


The patch titled
     Subject: cpusets: stall when updating mems_allowed for mempolicy or disjoint nodemask
has been added to the -mm tree.  Its filename is
     cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask.patch

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
From: David Rientjes <rientjes@google.com>
Subject: cpusets: stall when updating mems_allowed for mempolicy or disjoint nodemask

c0ff7453bb5c ("cpuset,mm: fix no node to alloc memory when changing
cpuset's mems") adds get_mems_allowed() to prevent the set of allowed
nodes from changing for a thread.  This causes any update to a set of
allowed nodes to stall until put_mems_allowed() is called.

This stall is unncessary, however, if at least one node remains unchanged
in the update to the set of allowed nodes.  This was addressed by
89e8a244b97e ("cpusets: avoid looping when storing to mems_allowed if one
node remains set"), but it's still possible that an empty nodemask may be
read from a mempolicy because the old nodemask may be remapped to the new
nodemask during rebind.  To prevent this, only avoid the stall if there is
no mempolicy for the thread being changed.

This is a temporary solution until all reads from mempolicy nodemasks can
be guaranteed to not be empty without the get_mems_allowed()
synchronization.

Also moves the check for nodemask intersection inside task_lock() so that
tsk->mems_allowed cannot change.  This ensures that nothing can set this
tsk's mems_allowed out from under us and also protects tsk->mempolicy.

Reported-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Paul Menage <paul@paulmenage.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff -puN kernel/cpuset.c~cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask
+++ a/kernel/cpuset.c
@@ -949,7 +949,7 @@ static void cpuset_migrate_mm(struct mm_
 static void cpuset_change_task_nodemask(struct task_struct *tsk,
 					nodemask_t *newmems)
 {
-	bool masks_disjoint = !nodes_intersects(*newmems, tsk->mems_allowed);
+	bool need_loop;
 
 repeat:
 	/*
@@ -962,6 +962,14 @@ repeat:
 		return;
 
 	task_lock(tsk);
+	/*
+	 * Determine if a loop is necessary if another thread is doing
+	 * get_mems_allowed().  If at least one node remains unchanged and
+	 * tsk does not have a mempolicy, then an empty nodemask will not be
+	 * possible when mems_allowed is larger than a word.
+	 */
+	need_loop = tsk->mempolicy ||
+			!nodes_intersects(*newmems, tsk->mems_allowed);
 	nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);
 	mpol_rebind_task(tsk, newmems, MPOL_REBIND_STEP1);
 
@@ -981,11 +989,9 @@ repeat:
 
 	/*
 	 * Allocation of memory is very fast, we needn't sleep when waiting
-	 * for the read-side.  No wait is necessary, however, if at least one
-	 * node remains unchanged.
+	 * for the read-side.
 	 */
-	while (masks_disjoint &&
-			ACCESS_ONCE(tsk->mems_allowed_change_disable)) {
+	while (need_loop && ACCESS_ONCE(tsk->mems_allowed_change_disable)) {
 		task_unlock(tsk);
 		if (!task_curr(tsk))
 			yield();
_
Subject: Subject: cpusets: stall when updating mems_allowed for mempolicy or disjoint nodemask

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
drivers-base-nodec-fix-compilation-error.patch
hugetlb-provide-a-default-hpage_shift-if-config_hugetlb_page.patch
drm-avoid-switching-to-text-console-if-there-is-no-panic-timeout.patch
mm-avoid-livelock-on-__gfp_fs-allocations-v2.patch
hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size.patch
hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size-fix.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch

