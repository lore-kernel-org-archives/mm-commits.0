From: akpm@linux-foundation.org
Subject: + cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch added to -mm tree
Date: Fri, 30 Apr 2010 13:53:38 -0700
Message-ID: <201004302053.o3UKrcwR012896@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753524Ab0D3UyV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 16:54:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com, cl@linux-foundation.org, holt@sgi.com, menage@google.com, penberg@cs.helsinki.fi


The patch titled
     cpusets: randomize node rotor used in cpuset_mem_spread_node()
has been added to the -mm tree.  Its filename is
     cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch

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
Subject: cpusets: randomize node rotor used in cpuset_mem_spread_node()
From: Jack Steiner <steiner@sgi.com>

Some workloads that create a large number of small files tend to assign
too many pages to node 0 (multi-node systems).  Part of the reason is that
the rotor (in cpuset_mem_spread_node()) used to assign nodes starts at
node 0 for newly created tasks.

This patch changes the rotor to be initialized to a random node number of
the cpuset.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Paul Menage <menage@google.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa.c       |   17 +++++++++++++++++
 include/linux/bitmap.h   |    1 +
 include/linux/nodemask.h |    5 +++++
 kernel/fork.c            |    4 ++++
 lib/bitmap.c             |    2 +-
 5 files changed, 28 insertions(+), 1 deletion(-)

diff -puN arch/x86/mm/numa.c~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node
+++ a/arch/x86/mm/numa.c
@@ -2,6 +2,7 @@
 #include <linux/topology.h>
 #include <linux/module.h>
 #include <linux/bootmem.h>
+#include <linux/random.h>
 
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 # define DBG(x...) printk(KERN_DEBUG x)
@@ -65,3 +66,19 @@ const struct cpumask *cpumask_of_node(in
 }
 EXPORT_SYMBOL(cpumask_of_node);
 #endif
+
+/*
+ * Return the bit number of a random bit set in the nodemask.
+ *   (returns -1 if nodemask is empty)
+ */
+int __node_random(const nodemask_t *maskp)
+{
+	int w, bit = -1;
+
+	w = nodes_weight(*maskp);
+	if (w)
+		bit = bitmap_ord_to_pos(maskp->bits,
+			get_random_int() % w, MAX_NUMNODES);
+	return bit;
+}
+EXPORT_SYMBOL(__node_random);
diff -puN include/linux/bitmap.h~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node include/linux/bitmap.h
--- a/include/linux/bitmap.h~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node
+++ a/include/linux/bitmap.h
@@ -141,6 +141,7 @@ extern int bitmap_find_free_region(unsig
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
+ * int node_random(mask)              Random node with set bit in mask
+ *
  * int node_online(node)		Is some node online?
  * int node_possible(node)		Is some node possible?
  *
@@ -267,6 +269,9 @@ static inline int __first_unset_node(con
 			find_first_zero_bit(maskp->bits, MAX_NUMNODES));
 }
 
+#define node_random(mask) __node_random(&(mask))
+extern int __node_random(const nodemask_t *maskp);
+
 #define NODE_MASK_LAST_WORD BITMAP_LAST_WORD_MASK(MAX_NUMNODES)
 
 #if MAX_NUMNODES <= BITS_PER_LONG
diff -puN kernel/fork.c~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node kernel/fork.c
--- a/kernel/fork.c~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node
+++ a/kernel/fork.c
@@ -1080,6 +1080,10 @@ static struct task_struct *copy_process(
  	}
 	mpol_fix_fork_child_flag(p);
 #endif
+#ifdef CONFIG_CPUSETS
+	p->cpuset_mem_spread_rotor = node_random(p->mems_allowed);
+	p->cpuset_slab_spread_rotor = node_random(p->mems_allowed);
+#endif
 #ifdef CONFIG_TRACE_IRQFLAGS
 	p->irq_events = 0;
 #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
diff -puN lib/bitmap.c~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node lib/bitmap.c
--- a/lib/bitmap.c~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node
+++ a/lib/bitmap.c
@@ -672,7 +672,7 @@ static int bitmap_pos_to_ord(const unsig
  *
  * The bit positions 0 through @bits are valid positions in @buf.
  */
-static int bitmap_ord_to_pos(const unsigned long *buf, int ord, int bits)
+int bitmap_ord_to_pos(const unsigned long *buf, int ord, int bits)
 {
 	int pos = 0;
 
_

Patches currently in -mm which might be from steiner@sgi.com are

linux-next.patch
cpusets-new-round-robin-rotor-for-slab-allocations.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
pids-increase-pid_max-based-on-num_possible_cpus.patch

