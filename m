From: akpm@linux-foundation.org
Subject: [merged]
 mm-mempolicy-stop-adjusting-current-il_next-in-mpol_rebind_nodemask.patch
 removed from -mm tree
Date: Fri, 07 Jul 2017 12:10:51 -0700
Message-ID: <20170707191051.7bFiyTjfn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34362 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752446AbdGGTK7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:10:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, cl@linux.com, hughd@google.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, lizefan@huawei.com, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org, rientjes@google.com, sivanich@sgi.com, vbabka@suse.cz


The patch titled
     Subject: mm, mempolicy: stop adjusting current->il_next in mpol_rebind_nodemask()
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-stop-adjusting-current-il_next-in-mpol_rebind_nodemask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, mempolicy: stop adjusting current->il_next in mpol_rebind_nodemask()

The task->il_next variable stores the next allocation node id for task's
MPOL_INTERLEAVE policy.  mpol_rebind_nodemask() updates interleave and
bind mempolicies due to changing cpuset mems.  Currently it also tries to
make sure that current->il_next is valid within the updated nodemask. 
This is bogus, because 1) we are updating potentially any task's
mempolicy, not just current, and 2) we might be updating a per-vma
mempolicy, not task one.

The interleave_nodes() function that uses il_next can cope fine with the
value not being within the currently allowed nodes, so this hasn't
manifested as an actual issue.

We can remove the need for updating il_next completely by changing it to
il_prev and store the node id of the previous interleave allocation
instead of the next id.  Then interleave_nodes() can calculate the next id
using the current nodemask and also store it as il_prev, except when
querying the next node via do_get_mempolicy().

Link: http://lkml.kernel.org/r/20170517081140.30654-3-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Christoph Lameter <cl@linux.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +-
 mm/mempolicy.c        |   22 +++++++---------------
 2 files changed, 8 insertions(+), 16 deletions(-)

diff -puN include/linux/sched.h~mm-mempolicy-stop-adjusting-current-il_next-in-mpol_rebind_nodemask include/linux/sched.h
--- a/include/linux/sched.h~mm-mempolicy-stop-adjusting-current-il_next-in-mpol_rebind_nodemask
+++ a/include/linux/sched.h
@@ -904,7 +904,7 @@ struct task_struct {
 #ifdef CONFIG_NUMA
 	/* Protected by alloc_lock: */
 	struct mempolicy		*mempolicy;
-	short				il_next;
+	short				il_prev;
 	short				pref_node_fork;
 #endif
 #ifdef CONFIG_NUMA_BALANCING
diff -puN mm/mempolicy.c~mm-mempolicy-stop-adjusting-current-il_next-in-mpol_rebind_nodemask mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-stop-adjusting-current-il_next-in-mpol_rebind_nodemask
+++ a/mm/mempolicy.c
@@ -349,12 +349,6 @@ static void mpol_rebind_nodemask(struct
 		pol->v.nodes = tmp;
 	else
 		BUG();
-
-	if (!node_isset(current->il_next, tmp)) {
-		current->il_next = next_node_in(current->il_next, tmp);
-		if (current->il_next >= MAX_NUMNODES)
-			current->il_next = numa_node_id();
-	}
 }
 
 static void mpol_rebind_preferred(struct mempolicy *pol,
@@ -812,9 +806,8 @@ static long do_set_mempolicy(unsigned sh
 	}
 	old = current->mempolicy;
 	current->mempolicy = new;
-	if (new && new->mode == MPOL_INTERLEAVE &&
-	    nodes_weight(new->v.nodes))
-		current->il_next = first_node(new->v.nodes);
+	if (new && new->mode == MPOL_INTERLEAVE)
+		current->il_prev = MAX_NUMNODES-1;
 	task_unlock(current);
 	mpol_put(old);
 	ret = 0;
@@ -916,7 +909,7 @@ static long do_get_mempolicy(int *policy
 			*policy = err;
 		} else if (pol == current->mempolicy &&
 				pol->mode == MPOL_INTERLEAVE) {
-			*policy = current->il_next;
+			*policy = next_node_in(current->il_prev, pol->v.nodes);
 		} else {
 			err = -EINVAL;
 			goto out;
@@ -1697,14 +1690,13 @@ static struct zonelist *policy_zonelist(
 /* Do dynamic interleaving for a process */
 static unsigned interleave_nodes(struct mempolicy *policy)
 {
-	unsigned nid, next;
+	unsigned next;
 	struct task_struct *me = current;
 
-	nid = me->il_next;
-	next = next_node_in(nid, policy->v.nodes);
+	next = next_node_in(me->il_prev, policy->v.nodes);
 	if (next < MAX_NUMNODES)
-		me->il_next = next;
-	return nid;
+		me->il_prev = next;
+	return next;
 }
 
 /*
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-fallback-to-smallest-page-when-not-stealing-whole-pageblock.patch

