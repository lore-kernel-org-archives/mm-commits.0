From: akpm@linux-foundation.org
Subject: + cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix.patch added to -mm tree
Date: Fri, 27 May 2011 13:15:36 -0700
Message-ID: <201105272015.p4RKFaLY018666@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753732Ab1E0UQ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 16:16:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz


The patch titled
     cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix
has been added to the -mm tree.  Its filename is
     cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix.patch

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
Subject: cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix
From: Michal Hocko <mhocko@suse.cz>

Define node_random directly in the mempolicy header

Alpha allows a strange configuration CONFIG_NUMA=n and CONFIG_NODES_SHIFT=7
which means that mempolicy.c is not compiled and linked while we still have
MAX_NUMNODES>1 which means that node_random is not defined.

Let's move node_random definition into the header. We will be consistent with
other node_* functions.

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
+unsigned int get_random_int(void );
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
