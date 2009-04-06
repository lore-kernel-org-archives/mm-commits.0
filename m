From: akpm@linux-foundation.org
Subject: [merged] cpusets-replace-zone-allowed-functions-with-node-allowed.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:35:06 -0700
Message-ID: <200904061935.n36JZ6nr011913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752219AbZDFUTR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:19:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, menage@google.com, mingo@elte.hu, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     cpusets: replace zone allowed functions with node allowed
has been removed from the -mm tree.  Its filename was
     cpusets-replace-zone-allowed-functions-with-node-allowed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusets: replace zone allowed functions with node allowed
From: David Rientjes <rientjes@google.com>

The cpuset_zone_allowed() variants are actually only a function of the
zone's node.

Cc: Paul Menage <menage@google.com>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuset.h |   33 +++++++++++++++++----
 kernel/cpuset.c        |   59 ++++++++++++++++-----------------------
 2 files changed, 52 insertions(+), 40 deletions(-)

diff -puN include/linux/cpuset.h~cpusets-replace-zone-allowed-functions-with-node-allowed include/linux/cpuset.h
--- a/include/linux/cpuset.h~cpusets-replace-zone-allowed-functions-with-node-allowed
+++ a/include/linux/cpuset.h
@@ -12,6 +12,7 @@
 #include <linux/cpumask.h>
 #include <linux/nodemask.h>
 #include <linux/cgroup.h>
+#include <linux/mm.h>
 
 #ifdef CONFIG_CPUSETS
 
@@ -29,19 +30,29 @@ void cpuset_init_current_mems_allowed(vo
 void cpuset_update_task_memory_state(void);
 int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask);
 
-extern int __cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask);
-extern int __cpuset_zone_allowed_hardwall(struct zone *z, gfp_t gfp_mask);
+extern int __cpuset_node_allowed_softwall(int node, gfp_t gfp_mask);
+extern int __cpuset_node_allowed_hardwall(int node, gfp_t gfp_mask);
 
-static int inline cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask)
+static inline int cpuset_node_allowed_softwall(int node, gfp_t gfp_mask)
 {
 	return number_of_cpusets <= 1 ||
-		__cpuset_zone_allowed_softwall(z, gfp_mask);
+		__cpuset_node_allowed_softwall(node, gfp_mask);
 }
 
-static int inline cpuset_zone_allowed_hardwall(struct zone *z, gfp_t gfp_mask)
+static inline int cpuset_node_allowed_hardwall(int node, gfp_t gfp_mask)
 {
 	return number_of_cpusets <= 1 ||
-		__cpuset_zone_allowed_hardwall(z, gfp_mask);
+		__cpuset_node_allowed_hardwall(node, gfp_mask);
+}
+
+static inline int cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask)
+{
+	return cpuset_node_allowed_softwall(zone_to_nid(z), gfp_mask);
+}
+
+static inline int cpuset_zone_allowed_hardwall(struct zone *z, gfp_t gfp_mask)
+{
+	return cpuset_node_allowed_hardwall(zone_to_nid(z), gfp_mask);
 }
 
 extern int cpuset_mems_allowed_intersects(const struct task_struct *tsk1,
@@ -112,6 +123,16 @@ static inline int cpuset_nodemask_valid_
 	return 1;
 }
 
+static inline int cpuset_node_allowed_softwall(int node, gfp_t gfp_mask)
+{
+	return 1;
+}
+
+static inline int cpuset_node_allowed_hardwall(int node, gfp_t gfp_mask)
+{
+	return 1;
+}
+
 static inline int cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask)
 {
 	return 1;
diff -puN kernel/cpuset.c~cpusets-replace-zone-allowed-functions-with-node-allowed kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-replace-zone-allowed-functions-with-node-allowed
+++ a/kernel/cpuset.c
@@ -2181,26 +2181,24 @@ static const struct cpuset *nearest_hard
 }
 
 /**
- * cpuset_zone_allowed_softwall - Can we allocate on zone z's memory node?
- * @z: is this zone on an allowed node?
+ * cpuset_node_allowed_softwall - Can we allocate on a memory node?
+ * @node: is this an allowed node?
  * @gfp_mask: memory allocation flags
  *
- * If we're in interrupt, yes, we can always allocate.  If
- * __GFP_THISNODE is set, yes, we can always allocate.  If zone
- * z's node is in our tasks mems_allowed, yes.  If it's not a
- * __GFP_HARDWALL request and this zone's nodes is in the nearest
- * hardwalled cpuset ancestor to this tasks cpuset, yes.
- * If the task has been OOM killed and has access to memory reserves
- * as specified by the TIF_MEMDIE flag, yes.
+ * If we're in interrupt, yes, we can always allocate.  If __GFP_THISNODE is
+ * set, yes, we can always allocate.  If node is in our task's mems_allowed,
+ * yes.  If it's not a __GFP_HARDWALL request and this node is in the nearest
+ * hardwalled cpuset ancestor to this task's cpuset, yes.  If the task has been
+ * OOM killed and has access to memory reserves as specified by the TIF_MEMDIE
+ * flag, yes.
  * Otherwise, no.
  *
- * If __GFP_HARDWALL is set, cpuset_zone_allowed_softwall()
- * reduces to cpuset_zone_allowed_hardwall().  Otherwise,
- * cpuset_zone_allowed_softwall() might sleep, and might allow a zone
- * from an enclosing cpuset.
+ * If __GFP_HARDWALL is set, cpuset_node_allowed_softwall() reduces to
+ * cpuset_node_allowed_hardwall().  Otherwise, cpuset_node_allowed_softwall()
+ * might sleep, and might allow a node from an enclosing cpuset.
  *
- * cpuset_zone_allowed_hardwall() only handles the simpler case of
- * hardwall cpusets, and never sleeps.
+ * cpuset_node_allowed_hardwall() only handles the simpler case of hardwall
+ * cpusets, and never sleeps.
  *
  * The __GFP_THISNODE placement logic is really handled elsewhere,
  * by forcibly using a zonelist starting at a specified node, and by
@@ -2239,20 +2237,17 @@ static const struct cpuset *nearest_hard
  *	GFP_USER     - only nodes in current tasks mems allowed ok.
  *
  * Rule:
- *    Don't call cpuset_zone_allowed_softwall if you can't sleep, unless you
+ *    Don't call cpuset_node_allowed_softwall if you can't sleep, unless you
  *    pass in the __GFP_HARDWALL flag set in gfp_flag, which disables
  *    the code that might scan up ancestor cpusets and sleep.
  */
-
-int __cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask)
+int __cpuset_node_allowed_softwall(int node, gfp_t gfp_mask)
 {
-	int node;			/* node that zone z is on */
 	const struct cpuset *cs;	/* current cpuset ancestors */
 	int allowed;			/* is allocation in zone z allowed? */
 
 	if (in_interrupt() || (gfp_mask & __GFP_THISNODE))
 		return 1;
-	node = zone_to_nid(z);
 	might_sleep_if(!(gfp_mask & __GFP_HARDWALL));
 	if (node_isset(node, current->mems_allowed))
 		return 1;
@@ -2281,15 +2276,15 @@ int __cpuset_zone_allowed_softwall(struc
 }
 
 /*
- * cpuset_zone_allowed_hardwall - Can we allocate on zone z's memory node?
- * @z: is this zone on an allowed node?
+ * cpuset_node_allowed_hardwall - Can we allocate on a memory node?
+ * @node: is this an allowed node?
  * @gfp_mask: memory allocation flags
  *
- * If we're in interrupt, yes, we can always allocate.
- * If __GFP_THISNODE is set, yes, we can always allocate.  If zone
- * z's node is in our tasks mems_allowed, yes.   If the task has been
- * OOM killed and has access to memory reserves as specified by the
- * TIF_MEMDIE flag, yes.  Otherwise, no.
+ * If we're in interrupt, yes, we can always allocate.  If __GFP_THISNODE is
+ * set, yes, we can always allocate.  If node is in our task's mems_allowed,
+ * yes.  If the task has been OOM killed and has access to memory reserves as
+ * specified by the TIF_MEMDIE flag, yes.
+ * Otherwise, no.
  *
  * The __GFP_THISNODE placement logic is really handled elsewhere,
  * by forcibly using a zonelist starting at a specified node, and by
@@ -2297,20 +2292,16 @@ int __cpuset_zone_allowed_softwall(struc
  * any node on the zonelist except the first.  By the time any such
  * calls get to this routine, we should just shut up and say 'yes'.
  *
- * Unlike the cpuset_zone_allowed_softwall() variant, above,
- * this variant requires that the zone be in the current tasks
+ * Unlike the cpuset_node_allowed_softwall() variant, above,
+ * this variant requires that the node be in the current task's
  * mems_allowed or that we're in interrupt.  It does not scan up the
  * cpuset hierarchy for the nearest enclosing mem_exclusive cpuset.
  * It never sleeps.
  */
-
-int __cpuset_zone_allowed_hardwall(struct zone *z, gfp_t gfp_mask)
+int __cpuset_node_allowed_hardwall(int node, gfp_t gfp_mask)
 {
-	int node;			/* node that zone z is on */
