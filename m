From: akpm@linux-foundation.org
Subject: + mempolicy-add-mpol_f_relative_nodes-flag.patch added to -mm tree
Date: Wed, 05 Mar 2008 17:26:37 -0800
Message-ID: <200803060126.m261Qbmp002040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761308AbYCFB1X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 20:27:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, Lee.Schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, pj@sgi.com


The patch titled
     mempolicy: add MPOL_F_RELATIVE_NODES flag
has been added to the -mm tree.  Its filename is
     mempolicy-add-mpol_f_relative_nodes-flag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy: add MPOL_F_RELATIVE_NODES flag
From: David Rientjes <rientjes@google.com>

Adds another optional mode flag, MPOL_F_RELATIVE_NODES, that specifies
nodemasks passed via set_mempolicy() or mbind() should be considered relative
to the current task's mems_allowed.

When the mempolicy is created, the passed nodemask is folded and mapped onto
the current task's mems_allowed.  For example, consider a task using
set_mempolicy() to pass MPOL_INTERLEAVE | MPOL_F_RELATIVE_NODES with a
nodemask of 1-3.  If current's mems_allowed is 4-7, the effected nodemask is
5-7 (the second, third, and fourth node of mems_allowed).

If the same task is attached to a cpuset, the mempolicy nodemask is rebound
each time the mems are changed.  Some possible rebinds and results are:

	mems			result
	1-3			1-3
	1-7			2-4
	1,5-6			1,5-6
	1,5-7			5-7

Likewise, the zonelist built for MPOL_BIND acts on the set of zones assigned
to the resultant nodemask from the relative remap.

In the MPOL_PREFERRED case, the preferred node is remapped from the currently
effected nodemask to the relative nodemask.

This mempolicy mode flag was conceived of by Paul Jackson <pj@sgi.com>.

Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    3 ++-
 mm/mempolicy.c            |   33 +++++++++++++++++++++++++++++++--
 mm/shmem.c                |    6 ++++++
 3 files changed, 39 insertions(+), 3 deletions(-)

diff -puN include/linux/mempolicy.h~mempolicy-add-mpol_f_relative_nodes-flag include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mempolicy-add-mpol_f_relative_nodes-flag
+++ a/include/linux/mempolicy.h
@@ -25,12 +25,13 @@ enum {
 
 /* Flags for set_mempolicy */
 #define MPOL_F_STATIC_NODES	(1 << 15)
+#define MPOL_F_RELATIVE_NODES	(1 << 14)
 
 /*
  * MPOL_MODE_FLAGS is the union of all possible optional mode flags passed to
  * either set_mempolicy() or mbind().
  */
-#define MPOL_MODE_FLAGS	(MPOL_F_STATIC_NODES)
+#define MPOL_MODE_FLAGS	(MPOL_F_STATIC_NODES | MPOL_F_RELATIVE_NODES)
 
 /* Flags for get_mempolicy */
 #define MPOL_F_NODE	(1<<0)	/* return next IL mode instead of node mask */
diff -puN mm/mempolicy.c~mempolicy-add-mpol_f_relative_nodes-flag mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-add-mpol_f_relative_nodes-flag
+++ a/mm/mempolicy.c
@@ -136,7 +136,15 @@ static int is_valid_nodemask(nodemask_t 
 
 static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
 {
-	return pol->flags & MPOL_F_STATIC_NODES;
+	return pol->flags & (MPOL_F_STATIC_NODES | MPOL_F_RELATIVE_NODES);
+}
+
+static void mpol_relative_nodemask(nodemask_t *ret, const nodemask_t *orig,
+				   const nodemask_t *rel)
+{
+	nodemask_t tmp;
+	nodes_fold(tmp, *orig, nodes_weight(*rel));
+	nodes_onto(*ret, tmp, *rel);
 }
 
 /* Create a new policy */
@@ -157,7 +165,12 @@ static struct mempolicy *mpol_new(unsign
 		return ERR_PTR(-ENOMEM);
 	atomic_set(&policy->refcnt, 1);
 	cpuset_update_task_memory_state();
-	nodes_and(cpuset_context_nmask, *nodes, cpuset_current_mems_allowed);
+	if (flags & MPOL_F_RELATIVE_NODES)
+		mpol_relative_nodemask(&cpuset_context_nmask, nodes,
+				       &cpuset_current_mems_allowed);
+	else
+		nodes_and(cpuset_context_nmask, *nodes,
+			  cpuset_current_mems_allowed);
 	switch (mode) {
 	case MPOL_INTERLEAVE:
 		if (nodes_empty(*nodes) || nodes_empty(cpuset_context_nmask))
@@ -873,6 +886,9 @@ asmlinkage long sys_mbind(unsigned long 
 	mode &= ~MPOL_MODE_FLAGS;
 	if (mode >= MPOL_MAX)
 		return -EINVAL;
+	if ((mode_flags & MPOL_F_STATIC_NODES) &&
+	    (mode_flags & MPOL_F_RELATIVE_NODES))
+		return -EINVAL;
 	err = get_nodes(&nodes, nmask, maxnode);
 	if (err)
 		return err;
@@ -891,6 +907,8 @@ asmlinkage long sys_set_mempolicy(int mo
 	mode &= ~MPOL_MODE_FLAGS;
 	if ((unsigned int)mode >= MPOL_MAX)
 		return -EINVAL;
+	if ((flags & MPOL_F_STATIC_NODES) && (flags & MPOL_F_RELATIVE_NODES))
+		return -EINVAL;
 	err = get_nodes(&nodes, nmask, maxnode);
 	if (err)
 		return err;
@@ -1738,10 +1756,12 @@ static void mpol_rebind_policy(struct me
 {
 	nodemask_t tmp;
 	int static_nodes;
+	int relative_nodes;
 
 	if (!pol)
 		return;
 	static_nodes = pol->flags & MPOL_F_STATIC_NODES;
+	relative_nodes = pol->flags & MPOL_F_RELATIVE_NODES;
 	if (!mpol_store_user_nodemask(pol) &&
 	    nodes_equal(pol->w.cpuset_mems_allowed, *newmask))
 		return;
@@ -1754,6 +1774,9 @@ static void mpol_rebind_policy(struct me
 	case MPOL_INTERLEAVE:
 		if (static_nodes)
 			nodes_and(tmp, pol->w.user_nodemask, *newmask);
+		else if (relative_nodes)
+			mpol_relative_nodemask(&tmp, &pol->w.user_nodemask,
+					       newmask);
 		else {
 			nodes_remap(tmp, pol->v.nodes,
 				    pol->w.cpuset_mems_allowed, *newmask);
@@ -1776,6 +1799,10 @@ static void mpol_rebind_policy(struct me
 				pol->v.preferred_node = node;
 			else
 				pol->v.preferred_node = -1;
+		} else if (relative_nodes) {
+			mpol_relative_nodemask(&tmp, &pol->w.user_nodemask,
+					       newmask);
+			pol->v.preferred_node = first_node(tmp);
 		} else {
 			pol->v.preferred_node = node_remap(pol->v.preferred_node,
 					pol->w.cpuset_mems_allowed, *newmask);
@@ -1871,6 +1898,8 @@ static inline int mpol_to_str(char *buff
 
 		if (flags & MPOL_F_STATIC_NODES)
 			p += sprintf(p, "%sstatic", need_bar++ ? "|" : "");
+		if (flags & MPOL_F_RELATIVE_NODES)
+			p += sprintf(p, "%srelative", need_bar++ ? "|" : "");
 	}
 
 	if (!nodes_empty(nodes)) {
diff -puN mm/shmem.c~mempolicy-add-mpol_f_relative_nodes-flag mm/shmem.c
--- a/mm/shmem.c~mempolicy-add-mpol_f_relative_nodes-flag
+++ a/mm/shmem.c
@@ -1131,6 +1131,12 @@ static int shmem_parse_mpol(char *value,
 	if (flags) {
 		if (!strcmp(flags, "static"))
 			*mode_flags |= MPOL_F_STATIC_NODES;
+		if (!strcmp(flags, "relative"))
+			*mode_flags |= MPOL_F_RELATIVE_NODES;
+
+		if ((*mode_flags & MPOL_F_STATIC_NODES) &&
+		    (*mode_flags & MPOL_F_RELATIVE_NODES))
+			err = 1;
 	}
 out:
 	/* Restore string for error message */
_

Patches currently in -mm which might be from rientjes@google.com are

fix-mempolicy-reference-counting-bugs.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
mempolicy-convert-mpol-constants-to-enum.patch
mempolicy-support-optional-mode-flags.patch
mempolicy-add-mpol_f_static_nodes-flag.patch
mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch
mempolicy-add-mpol_f_relative_nodes-flag.patch
mempolicy-update-numa-memory-policy-documentation.patch
make-cgroup_enable_task_cg_lists-static.patch

