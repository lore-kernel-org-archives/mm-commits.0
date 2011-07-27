From: akpm@linux-foundation.org
Subject: [merged] cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:28:25 -0700
Message-ID: <201107271927.p6RJRCkm003190@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974Ab1G0T1z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:27:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, cl@linux-foundation.org, holt@sgi.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, menage@google.com, penberg@cs.helsinki.fi, rientjes@google.com, steiner


The patch titled
     cpusets: randomize node rotor used in cpuset_mem_spread_node()
has been removed from the -mm tree.  Its filename was
     cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusets: randomize node rotor used in cpuset_mem_spread_node()
From: Michal Hocko <mhocko@suse.cz>

[This patch has already been accepted as 0ac0c0d but later reverted
(35926ff) because it itroduced arch specific __node_random which was
defined only for x86 code so it broke other archs.  This is a followup
without any arch specific code.  Other than that there are no functional
changes.]

Some workloads that create a large number of small files tend to assign
too many pages to node 0 (multi-node systems).  Part of the reason is that
the rotor (in cpuset_mem_spread_node()) used to assign nodes starts at
node 0 for newly created tasks.

This patch changes the rotor to be initialized to a random node number of
the cpuset.

[akpm@linux-foundation.org: fix layout]
[Lee.Schermerhorn@hp.com: Define stub numa_random() for !NUMA configuration]
[mhocko@suse.cz: Make it arch independent]
[akpm@linux-foundation.org: fix CONFIG_NUMA=y, MAX_NUMNODES>1 build]
Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Paul Menage <menage@google.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Paul Menage <menage@google.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h   |    1 +
 include/linux/nodemask.h |   13 +++++++++++++
 kernel/cpuset.c          |    8 ++++++++
 kernel/fork.c            |    4 ++++
 lib/bitmap.c             |    2 +-
 mm/mempolicy.c           |   16 ++++++++++++++++
 6 files changed, 43 insertions(+), 1 deletion(-)

diff -puN include/linux/bitmap.h~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node include/linux/bitmap.h
--- a/include/linux/bitmap.h~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node
+++ a/include/linux/bitmap.h
@@ -144,6 +144,7 @@ extern int bitmap_find_free_region(unsig
 extern void bitmap_release_region(unsigned long *bitmap, int pos, int order);
 extern int bitmap_allocate_region(unsigned long *bitmap, int pos, int order);
 extern void bitmap_copy_le(void *dst, const unsigned long *src, int nbits);
+extern int bitmap_ord_to_pos(const unsigned long *bitmap, int n, int bits);
 
 #define BITMAP_LAST_WORD_MASK(nbits)					\
 (									\
diff -puN include/linux/nodemask.h~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node include/linux/nodemask.h
--- a/include/linux/nodemask.h~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node
+++ a/include/linux/nodemask.h
@@ -66,6 +66,8 @@
  * int num_online_nodes()		Number of online Nodes
  * int num_possible_nodes()		Number of all possible Nodes
  *
+ * int node_random(mask)		Random node with set bit in mask
+ *
  * int node_online(node)		Is some node online?
  * int node_possible(node)		Is some node possible?
  *
@@ -430,6 +432,7 @@ static inline void node_set_offline(int 
 	node_clear_state(nid, N_ONLINE);
 	nr_online_nodes = num_node_state(N_ONLINE);
 }
+
 #else
 
 static inline int node_state(int node, enum node_states state)
@@ -460,6 +463,16 @@ static inline int num_node_state(enum no
 
 #define node_set_online(node)	   node_set_state((node), N_ONLINE)
 #define node_set_offline(node)	   node_clear_state((node), N_ONLINE)
+
+#endif
+
+#if defined(CONFIG_NUMA) && (MAX_NUMNODES > 1)
+extern int node_random(const nodemask_t *maskp);
+#else
+static inline int node_random(const nodemask_t *mask)
+{
+	return 0;
+}
 #endif
 
 #define node_online_map 	node_states[N_ONLINE]
diff -puN kernel/cpuset.c~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node
+++ a/kernel/cpuset.c
@@ -2460,11 +2460,19 @@ static int cpuset_spread_node(int *rotor
 
 int cpuset_mem_spread_node(void)
 {
+	if (current->cpuset_mem_spread_rotor == NUMA_NO_NODE)
+		current->cpuset_mem_spread_rotor =
+			node_random(&current->mems_allowed);
+
 	return cpuset_spread_node(&current->cpuset_mem_spread_rotor);
 }
 
 int cpuset_slab_spread_node(void)
 {
+	if (current->cpuset_slab_spread_rotor == NUMA_NO_NODE)
+		current->cpuset_slab_spread_rotor =
+			node_random(&current->mems_allowed);
+
 	return cpuset_spread_node(&current->cpuset_slab_spread_rotor);
 }
 
diff -puN kernel/fork.c~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node kernel/fork.c
--- a/kernel/fork.c~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node
+++ a/kernel/fork.c
@@ -1173,6 +1173,10 @@ static struct task_struct *copy_process(
  	}
 	mpol_fix_fork_child_flag(p);
 #endif
+#ifdef CONFIG_CPUSETS
+	p->cpuset_mem_spread_rotor = NUMA_NO_NODE;
+	p->cpuset_slab_spread_rotor = NUMA_NO_NODE;
+#endif
 #ifdef CONFIG_TRACE_IRQFLAGS
 	p->irq_events = 0;
 #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
diff -puN lib/bitmap.c~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node lib/bitmap.c
--- a/lib/bitmap.c~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node
+++ a/lib/bitmap.c
@@ -756,7 +756,7 @@ static int bitmap_pos_to_ord(const unsig
  *
  * The bit positions 0 through @bits are valid positions in @buf.
  */
-static int bitmap_ord_to_pos(const unsigned long *buf, int ord, int bits)
+int bitmap_ord_to_pos(const unsigned long *buf, int ord, int bits)
 {
 	int pos = 0;
 
diff -puN mm/mempolicy.c~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node mm/mempolicy.c
--- a/mm/mempolicy.c~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node
+++ a/mm/mempolicy.c
@@ -93,6 +93,7 @@
 
 #include <asm/tlbflush.h>
 #include <asm/uaccess.h>
+#include <linux/random.h>
 
 #include "internal.h"
 
@@ -1645,6 +1646,21 @@ static inline unsigned interleave_nid(st
 		return interleave_nodes(pol);
 }
 
+/*
+ * Return the bit number of a random bit set in the nodemask.
+ * (returns -1 if nodemask is empty)
+ */
+int node_random(const nodemask_t *maskp)
+{
+	int w, bit = -1;
+
+	w = nodes_weight(*maskp);
+	if (w)
+		bit = bitmap_ord_to_pos(maskp->bits,
+			get_random_int() % w, MAX_NUMNODES);
+	return bit;
+}
+
 #ifdef CONFIG_HUGETLBFS
 /*
  * huge_zonelist(@vma, @addr, @gfp_flags, @mpol)
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch

