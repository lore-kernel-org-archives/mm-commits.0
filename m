From: akpm@linux-foundation.org
Subject: [folded] cpusetmm-update-tasks-mems_allowed-in-time-fix.patch removed from -mm tree
Date: Tue, 16 Jun 2009 14:50:38 -0700
Message-ID: <200906162150.n5GLoc02020436@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35108 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752506AbZFPVvf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 17:51:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, menage@google.com, miaox@cn.fujitsu.com, mingo@elte.hu, nickpiggin@yahoo.com.au, penberg@cs.helsinki.fi, rien


The patch titled
     cpusetmm-update-tasks-mems_allowed-in-time-fix
has been removed from the -mm tree.  Its filename was
     cpusetmm-update-tasks-mems_allowed-in-time-fix.patch

This patch was dropped because it was folded into cpusetmm-update-tasks-mems_allowed-in-time.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusetmm-update-tasks-mems_allowed-in-time-fix
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

The rework of mpol_new() to extract the adjusting of the node mask to
apply cpuset and mpol flags "context" breaks set_mempolicy() and mbind()
with MPOL_PREFERRED and a NULL nodemask--i.e., explicit local allocation. 
Fix this by adding the check for MPOL_PREFERRED and empty node mask to
mpol_new_mpolicy().

Remove the now unneeded 'nodes = NULL' from mpol_new().

Note that mpol_new_mempolicy() is always called with a non-NULL 'nodes'
parameter now that it has been removed from mpol_new().  Therefore, we
don't need to test nodes for NULL before testing it for 'empty'.  However,
just to be extra paranoid, add a VM_BUG_ON() to verify this assumption.

Tested on x86_64 with numactl-2.0.3-rc2+ regression test.

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

 mm/mempolicy.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN mm/mempolicy.c~cpusetmm-update-tasks-mems_allowed-in-time-fix mm/mempolicy.c
--- a/mm/mempolicy.c~cpusetmm-update-tasks-mems_allowed-in-time-fix
+++ a/mm/mempolicy.c
@@ -182,8 +182,9 @@ static int mpol_new_bind(struct mempolic
 	return 0;
 }
 /*
- * This function is called after mpol_new(). The parameter -- nodes needn't
- * been check because mpol_new() has done it. Maybe this implement is ugly.
+ * This function is called after mpol_new().  mpol_new() has already validated
+ * the nodes parameter with respect to the policy mode and flags.  But, we
+ * need to handle an empty nodemaks with MPOL_PREFERRED here.
  *
  * We use task's alloc_lock to protect task's mems_allowed and mempolicy.
  * so this function should be called with task's alloc_lock held.
@@ -197,7 +198,10 @@ static int mpol_new_mempolicy(struct mem
 	if (pol == NULL)
 		return 0;
 
-	if (nodes) {
+	VM_BUG_ON(!nodes);
+	if (pol->mode == MPOL_PREFERRED && nodes_empty(*nodes))
+		nodes = NULL;	/* explicit local allocation */
+	else {
 		if (pol->flags & MPOL_F_RELATIVE_NODES)
 			mpol_relative_nodemask(&cpuset_context_nmask, nodes,
 					       &cpuset_current_mems_allowed);
@@ -243,7 +247,6 @@ static struct mempolicy *mpol_new(unsign
 			if (((flags & MPOL_F_STATIC_NODES) ||
 			     (flags & MPOL_F_RELATIVE_NODES)))
 				return ERR_PTR(-EINVAL);
-			nodes = NULL;	/* flag local alloc */
 		}
 	} else if (nodes_empty(*nodes))
 		return ERR_PTR(-EINVAL);
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

cpusetmm-update-tasks-mems_allowed-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time-fix.patch
cpusetmm-update-tasks-mems_allowed-in-time-cleanup.patch
vmscan-evict-use-once-pages-first-v3.patch
vmscan-zvc-updates-in-shrink_active_list-can-be-done-once.patch
migration-only-migrate_prep-once-per-move_pages.patch
mm-remove-config_unevictable_lru-config-option.patch
vmscan-handle-may_swap-more-strictly.patch

