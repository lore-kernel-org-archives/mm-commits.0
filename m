From: akpm@linux-foundation.org
Subject: + oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch added to -mm tree
Date: Thu, 12 Nov 2009 13:52:40 -0800
Message-ID: <200911122152.nACLqeN6024583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754312AbZKLVwn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 16:52:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hioryu@jp.fujitsu.com, cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com


The patch titled
     oom-kill: fix NUMA constraint check with nodemask
has been added to the -mm tree.  Its filename is
     oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch

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
Subject: oom-kill: fix NUMA constraint check with nodemask
From: KAMEZAWA Hiroyuki <kamezawa.hioryu@jp.fujitsu.com>

Fix node-oriented allocation handling in oom-kill.c I myself think of this
as a bugfix not as an ehnancement.

In these days, things are changed as
  - alloc_pages() eats nodemask as its arguments, __alloc_pages_nodemask().
  - mempolicy don't maintain its own private zonelists.
  (And cpuset doesn't use nodemask for __alloc_pages_nodemask())

So, current oom-killer's check function is wrong.

This patch does
  - check nodemask, if nodemask && nodemask doesn't cover all
    node_states[N_HIGH_MEMORY], this is CONSTRAINT_MEMORY_POLICY.
  - Scan all zonelist under nodemask, if it hits cpuset's wall
    this faiulre is from cpuset.
And
  - modifies the caller of out_of_memory not to call oom if __GFP_THISNODE.
    This doesn't change "current" behavior. If callers use __GFP_THISNODE
    it should handle "page allocation failure" by itself.

  - handle __GFP_NOFAIL+__GFP_THISNODE path.
    This is something like a FIXME but this gfpmask is not used now.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hioryu@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sysrq.c |    2 -
 include/linux/oom.h  |    4 ++-
 mm/oom_kill.c        |   46 +++++++++++++++++++++++++++++------------
 mm/page_alloc.c      |   20 +++++++++++++----
 4 files changed, 52 insertions(+), 20 deletions(-)

diff -puN drivers/char/sysrq.c~oom-kill-fix-numa-consraint-check-with-nodemask-v42 drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~oom-kill-fix-numa-consraint-check-with-nodemask-v42
+++ a/drivers/char/sysrq.c
@@ -339,7 +339,7 @@ static struct sysrq_key_op sysrq_term_op
 
 static void moom_callback(struct work_struct *ignored)
 {
-	out_of_memory(node_zonelist(0, GFP_KERNEL), GFP_KERNEL, 0);
+	out_of_memory(node_zonelist(0, GFP_KERNEL), GFP_KERNEL, 0, NULL);
 }
 
 static DECLARE_WORK(moom_work, moom_callback);
diff -puN include/linux/oom.h~oom-kill-fix-numa-consraint-check-with-nodemask-v42 include/linux/oom.h
--- a/include/linux/oom.h~oom-kill-fix-numa-consraint-check-with-nodemask-v42
+++ a/include/linux/oom.h
@@ -10,6 +10,7 @@
 #ifdef __KERNEL__
 
 #include <linux/types.h>
+#include <linux/nodemask.h>
 
 struct zonelist;
 struct notifier_block;
@@ -26,7 +27,8 @@ enum oom_constraint {
 extern int try_set_zone_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 extern void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 
-extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order);
+extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
+		int order, nodemask_t *mask);
 extern int register_oom_notifier(struct notifier_block *nb);
 extern int unregister_oom_notifier(struct notifier_block *nb);
 
diff -puN mm/oom_kill.c~oom-kill-fix-numa-consraint-check-with-nodemask-v42 mm/oom_kill.c
--- a/mm/oom_kill.c~oom-kill-fix-numa-consraint-check-with-nodemask-v42
+++ a/mm/oom_kill.c
@@ -196,27 +196,46 @@ unsigned long badness(struct task_struct
 /*
  * Determine the type of allocation constraint.
  */
-static inline enum oom_constraint constrained_alloc(struct zonelist *zonelist,
-						    gfp_t gfp_mask)
-{
 #ifdef CONFIG_NUMA
+static enum oom_constraint constrained_alloc(struct zonelist *zonelist,
+				    gfp_t gfp_mask, nodemask_t *nodemask)
+{
 	struct zone *zone;
 	struct zoneref *z;
 	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
-	nodemask_t nodes = node_states[N_HIGH_MEMORY];
 
-	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx)
-		if (cpuset_zone_allowed_softwall(zone, gfp_mask))
-			node_clear(zone_to_nid(zone), nodes);
-		else
-			return CONSTRAINT_CPUSET;
+	/*
+	 * Reach here only when __GFP_NOFAIL is used. So, we should avoid
+ 	 * to kill current.We have to random task kill in this case.
+ 	 * Hopefully, CONSTRAINT_THISNODE...but no way to handle it, now.
+ 	 */
+	if (gfp_mask & __GFP_THISNODE)
+		return CONSTRAINT_NONE;
 
-	if (!nodes_empty(nodes))
+	/*
+ 	 * The nodemask here is a nodemask passed to alloc_pages(). Now,
+ 	 * cpuset doesn't use this nodemask for its hardwall/softwall/hierarchy
+ 	 * feature. mempolicy is an only user of nodemask here.
+	 * check mempolicy's nodemask contains all N_HIGH_MEMORY
+ 	 */
+	if (nodemask && !nodes_subset(node_states[N_HIGH_MEMORY], *nodemask))
 		return CONSTRAINT_MEMORY_POLICY;
-#endif
 
+	/* Check this allocation failure is caused by cpuset's wall function */
+	for_each_zone_zonelist_nodemask(zone, z, zonelist,
+			high_zoneidx, nodemask)
+		if (!cpuset_zone_allowed_softwall(zone, gfp_mask))
+			return CONSTRAINT_CPUSET;
+
+	return CONSTRAINT_NONE;
+}
+#else
+static enum oom_constraint constrained_alloc(struct zonelist *zonelist,
+				gfp_t gfp_mask, nodemask_t *nodemask)
+{
 	return CONSTRAINT_NONE;
 }
+#endif
 
 /*
  * Simple selection loop. We chose the process with the highest
@@ -613,7 +632,8 @@ rest_and_return:
  * OR try to be smart about which process to kill. Note that we
  * don't have to be perfect here, we just have to be good.
  */
-void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order)
+void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
+		int order, nodemask_t *nodemask)
 {
 	unsigned long freed = 0;
 	enum oom_constraint constraint;
@@ -632,7 +652,7 @@ void out_of_memory(struct zonelist *zone
 	 * Check if there were limitations on the allocation (only relevant for
 	 * NUMA) that may require different handling.
 	 */
-	constraint = constrained_alloc(zonelist, gfp_mask);
+	constraint = constrained_alloc(zonelist, gfp_mask, nodemask);
 	read_lock(&tasklist_lock);
 
 	switch (constraint) {
diff -puN mm/page_alloc.c~oom-kill-fix-numa-consraint-check-with-nodemask-v42 mm/page_alloc.c
--- a/mm/page_alloc.c~oom-kill-fix-numa-consraint-check-with-nodemask-v42
+++ a/mm/page_alloc.c
@@ -1664,12 +1664,22 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	if (page)
 		goto out;
 
-	/* The OOM killer will not help higher order allocs */
-	if (order > PAGE_ALLOC_COSTLY_ORDER && !(gfp_mask & __GFP_NOFAIL))
-		goto out;
-
+	if (!(gfp_mask & __GFP_NOFAIL)) {
+		/* The OOM killer will not help higher order allocs */
+		if (order > PAGE_ALLOC_COSTLY_ORDER)
+			goto out;
+		/*
+	 	* GFP_THISNODE contains __GFP_NORETRY and we never hit this.
+	 	* Sanity check for bare calls of __GFP_THISNODE, not real OOM.
+	 	* The caller should handle page allocation failure by itself if
+	 	* it specifies __GFP_THISNODE.
+	 	* Note: Hugepage uses it but will hit PAGE_ALLOC_COSTLY_ORDER.
+	 	*/
+		if (gfp_mask & __GFP_THISNODE)
+			goto out;
+	}
 	/* Exhausted what can be done so it's blamo time */
-	out_of_memory(zonelist, gfp_mask, order);
+	out_of_memory(zonelist, gfp_mask, order, nodemask);
 
 out:
 	clear_zonelist_oom(zonelist, gfp_mask);
_

Patches currently in -mm which might be from kamezawa.hioryu@jp.fujitsu.com are

oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch

