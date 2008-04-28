From: akpm@linux-foundation.org
Subject: - mempolicy-mpol_preferred-cleanups-for-local-allocation.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:53:26 -0700
Message-ID: <200804282153.m3SLrQda017868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936068AbYD1Vxo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:53:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mempolicy: mPOL_PREFERRED cleanups for "local allocation"
has been removed from the -mm tree.  Its filename was
     mempolicy-mpol_preferred-cleanups-for-local-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy: mPOL_PREFERRED cleanups for "local allocation"
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Here are a couple of "cleanups" for MPOL_PREFERRED behavior when
v.preferred_node < 0 -- i.e., "local allocation":

1)  [do_]get_mempolicy() calls the now renamed get_policy_nodemask()
    to fetch the nodemask associated with a policy.  Currently,
    get_policy_nodemask() returns the set of nodes with memory, when
    the policy 'mode' is 'PREFERRED, and the preferred_node is < 0.
    Change to return an empty nodemask, as this is what was specified
    to achieve "local allocation".

2)  When a task is moved into a [new] cpuset, mpol_rebind_policy() is
    called to adjust any task and vma policy nodes to be valid in the
    new cpuset.  However, when the policy is MPOL_PREFERRED, and the
    preferred_node is <0, no rebind is necessary.  The "local allocation"
    indication is valid in any cpuset.  Existing code will "do the right
    thing" because node_remap() will just return the argument node when
    it is outside of the valid range of node ids.  However, I think it is
    clearer and cleaner to skip the remap explicitly in this case.

3)  mpol_to_str() produces a printable, "human readable" string from a
    struct mempolicy.  For MPOL_PREFERRED with preferred_node <0,  show
    "local", as this indicates local allocation, as the task migrates
    among nodes.  Note that this matches the usage of "local allocation"
    in libnuma() and numactl.  Without this change, I believe that node_set()
    [via set_bit()] will set bit 31, resulting in a misleading display.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-mpol_preferred-cleanups-for-local-allocation mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-mpol_preferred-cleanups-for-local-allocation
+++ a/mm/mempolicy.c
@@ -645,11 +645,9 @@ static void get_policy_nodemask(struct m
 		*nodes = p->v.nodes;
 		break;
 	case MPOL_PREFERRED:
-		/* or use current node instead of memory_map? */
-		if (p->v.preferred_node < 0)
-			*nodes = node_states[N_HIGH_MEMORY];
-		else
+		if (p->v.preferred_node >= 0)
 			node_set(p->v.preferred_node, *nodes);
+		/* else return empty node mask for local allocation */
 		break;
 	default:
 		BUG();
@@ -804,7 +802,7 @@ int do_migrate_pages(struct mm_struct *m
 	int err = 0;
 	nodemask_t tmp;
 
-  	down_read(&mm->mmap_sem);
+	down_read(&mm->mmap_sem);
 
 	err = migrate_vmas(mm, from_nodes, to_nodes, flags);
 	if (err)
@@ -1948,10 +1946,12 @@ void numa_default_policy(void)
 }
 
 /*
- * Display pages allocated per node and memory policy via /proc.
+ * "local" is pseudo-policy:  MPOL_PREFERRED with preferred_node == -1
+ * Used only for mpol_to_str()
  */
+#define MPOL_LOCAL (MPOL_INTERLEAVE + 1)
 static const char * const policy_types[] =
-	{ "default", "prefer", "bind", "interleave" };
+	{ "default", "prefer", "bind", "interleave", "local" };
 
 /*
  * Convert a mempolicy into a string.
@@ -1962,6 +1962,7 @@ static inline int mpol_to_str(char *buff
 {
 	char *p = buffer;
 	int l;
+	int nid;
 	nodemask_t nodes;
 	unsigned short mode;
 	unsigned short flags = pol ? pol->flags : 0;
@@ -1978,7 +1979,11 @@ static inline int mpol_to_str(char *buff
 
 	case MPOL_PREFERRED:
 		nodes_clear(nodes);
-		node_set(pol->v.preferred_node, nodes);
+		nid = pol->v.preferred_node;
+		if (nid < 0)
+			mode = MPOL_LOCAL;	/* pseudo-policy */
+		else
+			node_set(nid, nodes);
 		break;
 
 	case MPOL_BIND:
@@ -1993,8 +1998,8 @@ static inline int mpol_to_str(char *buff
 	}
 
 	l = strlen(policy_types[mode]);
- 	if (buffer + maxlen < p + l + 1)
- 		return -ENOSPC;
+	if (buffer + maxlen < p + l + 1)
+		return -ENOSPC;
 
 	strcpy(p, policy_types[mode]);
 	p += l;
@@ -2093,6 +2098,9 @@ static inline void check_huge_range(stru
 }
 #endif
 
+/*
+ * Display pages allocated per node and memory policy via /proc.
+ */
 int show_numa_map(struct seq_file *m, void *v)
 {
 	struct proc_maps_private *priv = m->private;
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

origin.patch
mm-add-nr_writeback_temp-counter-fix.patch

