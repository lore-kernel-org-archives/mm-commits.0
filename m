From: akpm@linux-foundation.org
Subject: [alternative-merged] cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix.patch removed from -mm tree
Date: Fri, 27 May 2011 17:39:50 -0700
Message-ID: <201105280037.p4S0bsXs031476@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757578Ab1E1Ai1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 20:38:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix
has been removed from the -mm tree.  Its filename was
     cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix
From: Michal Hocko <mhocko@suse.cz>

Define node_random directly in the mempolicy header

Alpha allows a strange configuration CONFIG_NUMA=n and CONFIG_NODES_SHIFT=7
which means that mempolicy.c is not compiled and linked while we still have
MAX_NUMNODES>1 which means that node_random is not defined.

Let's move node_random definition into the header. We will be consistent with
other node_* functions.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |   16 +++++++++++++++-
 mm/mempolicy.c           |   15 ---------------
 2 files changed, 15 insertions(+), 16 deletions(-)

diff -puN include/linux/nodemask.h~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix include/linux/nodemask.h
--- a/include/linux/nodemask.h~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix
+++ a/include/linux/nodemask.h
@@ -433,7 +433,21 @@ static inline void node_set_offline(int 
 	nr_online_nodes = num_node_state(N_ONLINE);
 }
 
-extern int node_random(const nodemask_t *maskp);
+unsigned int get_random_int(void);
+/*
+ * Return the bit number of a random bit set in the nodemask.
+ * (returns -1 if nodemask is empty)
+ */
+static inline int node_random(const nodemask_t *maskp)
+{
+	int w, bit = -1;
+
+	w = nodes_weight(*maskp);
+	if (w)
+		bit = bitmap_ord_to_pos(maskp->bits,
+			get_random_int() % w, MAX_NUMNODES);
+	return bit;
+}
 
 #else
 
diff -puN mm/mempolicy.c~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix mm/mempolicy.c
--- a/mm/mempolicy.c~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix
+++ a/mm/mempolicy.c
@@ -1646,21 +1646,6 @@ static inline unsigned interleave_nid(st
 		return interleave_nodes(pol);
 }
 
-/*
- * Return the bit number of a random bit set in the nodemask.
- * (returns -1 if nodemask is empty)
- */
-int node_random(const nodemask_t *maskp)
-{
-	int w, bit = -1;
-
-	w = nodes_weight(*maskp);
-	if (w)
-		bit = bitmap_ord_to_pos(maskp->bits,
-			get_random_int() % w, MAX_NUMNODES);
-	return bit;
-}
