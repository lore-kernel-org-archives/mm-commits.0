From: akpm@linux-foundation.org
Subject: [folded] cpusetmm-update-tasks-mems_allowed-in-time-cleanup.patch removed from -mm tree
Date: Tue, 16 Jun 2009 14:50:41 -0700
Message-ID: <200906162150.n5GLofP2020444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753003AbZFPVvh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 17:51:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, menage@google.com, miaox@cn.fujitsu.com, mingo@elte.hu, nickpiggin@yahoo.com.au, penberg@cs.helsinki.fi, rien


The patch titled
     cpusetmm-update-tasks-mems_allowed-in-time-cleanup
has been removed from the -mm tree.  Its filename was
     cpusetmm-update-tasks-mems_allowed-in-time-cleanup.patch

This patch was dropped because it was folded into cpusetmm-update-tasks-mems_allowed-in-time.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusetmm-update-tasks-mems_allowed-in-time-cleanup
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

I don't think the function name 'mpol_new_mempolicy' is descriptive enough
to differentiate it from mpol_new().

This function applies cpuset set context, usually constraining nodes to
those allowed by the cpuset.  However, when the 'RELATIVE_NODES flag is
set, it also translates the nodes.  So I settled on 'mpol_set_nodemask()',
because the comment block for mpol_new() mentions that we need to call
this function to "set nodes".

Some additional minor line length, whitespace and typo cleanup.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Paul Menage <menage@google.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff -puN mm/mempolicy.c~cpusetmm-update-tasks-mems_allowed-in-time-cleanup mm/mempolicy.c
--- a/mm/mempolicy.c~cpusetmm-update-tasks-mems_allowed-in-time-cleanup
+++ a/mm/mempolicy.c
@@ -181,15 +181,17 @@ static int mpol_new_bind(struct mempolic
 	pol->v.nodes = *nodes;
 	return 0;
 }
+
 /*
- * This function is called after mpol_new().  mpol_new() has already validated
- * the nodes parameter with respect to the policy mode and flags.  But, we
- * need to handle an empty nodemaks with MPOL_PREFERRED here.
+ * mpol_set_nodemask is called after mpol_new() to set up the nodemask, if
+ * any, for the new policy.  mpol_new() has already validated the nodes
+ * parameter with respect to the policy mode and flags.  But, we need to
+ * handle an empty nodemask with MPOL_PREFERRED here.
  *
- * We use task's alloc_lock to protect task's mems_allowed and mempolicy.
- * so this function should be called with task's alloc_lock held.
+ * Must be called holding task's alloc_lock to protect task's mems_allowed
+ * and mempolicy.  May also be called holding the mmap_semaphore for write.
  */
-static int mpol_new_mempolicy(struct mempolicy *pol, const nodemask_t *nodes)
+static int mpol_set_nodemask(struct mempolicy *pol, const nodemask_t *nodes)
 {
 	nodemask_t cpuset_context_nmask;
 	int ret;
@@ -220,8 +222,10 @@ static int mpol_new_mempolicy(struct mem
 	return ret;
 }
 
-/* This function just creates a new policy, does some check and simple
- * initializtion. You must invoke mpol_new_mempolicy to set nodes */
+/*
+ * This function just creates a new policy, does some check and simple
+ * initialization. You must invoke mpol_set_nodemask() to set nodes.
+ */
 static struct mempolicy *mpol_new(unsigned short mode, unsigned short flags,
 				  nodemask_t *nodes)
 {
@@ -631,7 +635,7 @@ static long do_set_mempolicy(unsigned sh
 	if (mm)
 		down_write(&mm->mmap_sem);
 	task_lock(current);
-	ret = mpol_new_mempolicy(new, nodes);
+	ret = mpol_set_nodemask(new, nodes);
 	if (ret) {
 		task_unlock(current);
 		if (mm)
@@ -1012,7 +1016,7 @@ static long do_mbind(unsigned long start
 	}
 	down_write(&mm->mmap_sem);
 	task_lock(current);
-	err = mpol_new_mempolicy(new, nmask);
+	err = mpol_set_nodemask(new, nmask);
 	task_unlock(current);
 	if (err) {
 		up_write(&mm->mmap_sem);
@@ -1907,7 +1911,7 @@ void mpol_shared_policy_init(struct shar
 		}
 
 		task_lock(current);
-		ret = mpol_new_mempolicy(new, &mpol->w.user_nodemask);
+		ret = mpol_set_nodemask(new, &mpol->w.user_nodemask);
 		task_unlock(current);
 		mpol_put(mpol);	/* drop our ref on sb mpol */
 		if (ret) {
@@ -2138,7 +2142,7 @@ int mpol_parse_str(char *str, struct mem
 		int ret;
 
 		task_lock(current);
-		ret = mpol_new_mempolicy(new, &nodes);
+		ret = mpol_set_nodemask(new, &nodes);
 		task_unlock(current);
 		if (ret)
 			err = 1;
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

cpusetmm-update-tasks-mems_allowed-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time-cleanup.patch
vmscan-evict-use-once-pages-first-v3.patch
vmscan-zvc-updates-in-shrink_active_list-can-be-done-once.patch
migration-only-migrate_prep-once-per-move_pages.patch
mm-remove-config_unevictable_lru-config-option.patch
vmscan-handle-may_swap-more-strictly.patch

