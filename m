From: akpm@linux-foundation.org
Subject: - mempolicy-rename-struct-mempolicy-policy-member-to-mode.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:53:12 -0700
Message-ID: <200804282153.m3SLrCwm017844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935243AbYD1Vxb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:53:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mempolicy: rename struct mempolicy 'policy' member to 'mode'
has been removed from the -mm tree.  Its filename was
     mempolicy-rename-struct-mempolicy-policy-member-to-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy: rename struct mempolicy 'policy' member to 'mode'
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

The terms 'policy' and 'mode' are both used in various places to describe the
semantics of the value stored in the 'policy' member of struct mempolicy. 
Furthermore, the term 'policy' is used to refer to that member, to the entire
struct mempolicy and to the more abstract concept of the tuple consisting of a
"mode" and an optional node or set of nodes.  Recently, we have added "mode
flags" that are passed in the upper bits of the 'mode' [or sometimes,
'policy'] member of the numa APIs.

I'd like to resolve this confusion, which perhaps only exists in my mind, by
renaming the 'policy' member to 'mode' throughout, and fixing up the
Documentation.  Man pages will be updated separately.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/numa_memory_policy.txt |    4 -
 include/linux/mempolicy.h               |    6 +-
 mm/mempolicy.c                          |   46 +++++++++++-----------
 3 files changed, 26 insertions(+), 30 deletions(-)

diff -puN Documentation/vm/numa_memory_policy.txt~mempolicy-rename-struct-mempolicy-policy-member-to-mode Documentation/vm/numa_memory_policy.txt
--- a/Documentation/vm/numa_memory_policy.txt~mempolicy-rename-struct-mempolicy-policy-member-to-mode
+++ a/Documentation/vm/numa_memory_policy.txt
@@ -145,10 +145,6 @@ Components of Memory Policies
    structure, struct mempolicy.  Details of this structure will be discussed
    in context, below, as required to explain the behavior.
 
-	Note:  in some functions AND in the struct mempolicy itself, the mode
-	is called "policy".  However, to avoid confusion with the policy tuple,
-	this document will continue to use the term "mode".
-
    Linux memory policy supports the following 4 behavioral modes:
 
 	Default Mode--MPOL_DEFAULT:  The behavior specified by this mode is
diff -puN include/linux/mempolicy.h~mempolicy-rename-struct-mempolicy-policy-member-to-mode include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mempolicy-rename-struct-mempolicy-policy-member-to-mode
+++ a/include/linux/mempolicy.h
@@ -80,7 +80,7 @@ struct mm_struct;
  */
 struct mempolicy {
 	atomic_t refcnt;
-	unsigned short policy; 	/* See MPOL_* above */
+	unsigned short mode; 	/* See MPOL_* above */
 	unsigned short flags;	/* See set_mempolicy() MPOL_F_* above */
 	union {
 		short 		 preferred_node; /* preferred */
@@ -149,7 +149,7 @@ struct shared_policy {
 	spinlock_t lock;
 };
 
-void mpol_shared_policy_init(struct shared_policy *info, unsigned short policy,
+void mpol_shared_policy_init(struct shared_policy *info, unsigned short mode,
 				unsigned short flags, nodemask_t *nodes);
 int mpol_set_shared_policy(struct shared_policy *info,
 				struct vm_area_struct *vma,
@@ -213,7 +213,7 @@ static inline int mpol_set_shared_policy
 }
 
 static inline void mpol_shared_policy_init(struct shared_policy *info,
-		unsigned short policy, unsigned short flags, nodemask_t *nodes)
+		unsigned short mode, unsigned short flags, nodemask_t *nodes)
 {
 }
 
diff -puN mm/mempolicy.c~mempolicy-rename-struct-mempolicy-policy-member-to-mode mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-rename-struct-mempolicy-policy-member-to-mode
+++ a/mm/mempolicy.c
@@ -106,7 +106,7 @@ enum zone_type policy_zone = 0;
 
 struct mempolicy default_policy = {
 	.refcnt = ATOMIC_INIT(1), /* never free it */
-	.policy = MPOL_DEFAULT,
+	.mode   = MPOL_DEFAULT,
 };
 
 static const struct mempolicy_operations {
@@ -211,7 +211,7 @@ static struct mempolicy *mpol_new(unsign
 	if (!policy)
 		return ERR_PTR(-ENOMEM);
 	atomic_set(&policy->refcnt, 1);
-	policy->policy = mode;
+	policy->mode = mode;
 	policy->flags = flags;
 
 	if (nodes) {
@@ -302,7 +302,7 @@ static void mpol_rebind_policy(struct me
 	if (!mpol_store_user_nodemask(pol) &&
 	    nodes_equal(pol->w.cpuset_mems_allowed, *newmask))
 		return;
-	mpol_ops[pol->policy].rebind(pol, newmask);
+	mpol_ops[pol->mode].rebind(pol, newmask);
 }
 
 /*
@@ -608,7 +608,7 @@ static long do_set_mempolicy(unsigned sh
 	mpol_put(current->mempolicy);
 	current->mempolicy = new;
 	mpol_set_task_struct_flag();
-	if (new && new->policy == MPOL_INTERLEAVE &&
+	if (new && new->mode == MPOL_INTERLEAVE &&
 	    nodes_weight(new->v.nodes))
 		current->il_next = first_node(new->v.nodes);
 	if (mm)
@@ -621,7 +621,7 @@ static long do_set_mempolicy(unsigned sh
 static void get_zonemask(struct mempolicy *p, nodemask_t *nodes)
 {
 	nodes_clear(*nodes);
-	switch (p->policy) {
+	switch (p->mode) {
 	case MPOL_DEFAULT:
 		break;
 	case MPOL_BIND:
@@ -700,14 +700,14 @@ static long do_get_mempolicy(int *policy
 				goto out;
 			*policy = err;
 		} else if (pol == current->mempolicy &&
-				pol->policy == MPOL_INTERLEAVE) {
+				pol->mode == MPOL_INTERLEAVE) {
 			*policy = current->il_next;
 		} else {
 			err = -EINVAL;
 			goto out;
 		}
 	} else
-		*policy = pol->policy | pol->flags;
+		*policy = pol->mode | pol->flags;
 
 	if (vma) {
 		up_read(&current->mm->mmap_sem);
@@ -1276,7 +1276,7 @@ static struct mempolicy *get_vma_policy(
 				pol = vpol;
 			shared_pol = 1;	/* if pol non-NULL, add ref below */
 		} else if (vma->vm_policy &&
-				vma->vm_policy->policy != MPOL_DEFAULT)
+				vma->vm_policy->mode != MPOL_DEFAULT)
 			pol = vma->vm_policy;
 	}
 	if (!pol)
@@ -1290,7 +1290,7 @@ static struct mempolicy *get_vma_policy(
 static nodemask_t *nodemask_policy(gfp_t gfp, struct mempolicy *policy)
 {
 	/* Lower zones don't get a nodemask applied for MPOL_BIND */
-	if (unlikely(policy->policy == MPOL_BIND) &&
+	if (unlikely(policy->mode == MPOL_BIND) &&
 			gfp_zone(gfp) >= policy_zone &&
 			cpuset_nodemask_valid_mems_allowed(&policy->v.nodes))
 		return &policy->v.nodes;
@@ -1303,7 +1303,7 @@ static struct zonelist *zonelist_policy(
 {
 	int nd;
 
-	switch (policy->policy) {
+	switch (policy->mode) {
 	case MPOL_PREFERRED:
 		nd = policy->v.preferred_node;
 		if (nd < 0)
@@ -1353,7 +1353,7 @@ static unsigned interleave_nodes(struct 
  */
 unsigned slab_node(struct mempolicy *policy)
 {
-	unsigned short pol = policy ? policy->policy : MPOL_DEFAULT;
+	unsigned short pol = policy ? policy->mode : MPOL_DEFAULT;
 
 	switch (pol) {
 	case MPOL_INTERLEAVE:
@@ -1454,9 +1454,9 @@ struct zonelist *huge_zonelist(struct vm
 
 	*mpol = NULL;		/* probably no unref needed */
 	*nodemask = NULL;	/* assume !MPOL_BIND */
-	if (pol->policy == MPOL_BIND) {
+	if (pol->mode == MPOL_BIND) {
 			*nodemask = &pol->v.nodes;
-	} else if (pol->policy == MPOL_INTERLEAVE) {
+	} else if (pol->mode == MPOL_INTERLEAVE) {
 		unsigned nid;
 
 		nid = interleave_nid(pol, vma, addr, HPAGE_SHIFT);
@@ -1468,7 +1468,7 @@ struct zonelist *huge_zonelist(struct vm
 
 	zl = zonelist_policy(GFP_HIGHUSER, pol);
 	if (unlikely(pol != &default_policy && pol != current->mempolicy)) {
-		if (pol->policy != MPOL_BIND)
+		if (pol->mode != MPOL_BIND)
 			__mpol_put(pol);	/* finished with pol */
 		else
 			*mpol = pol;	/* unref needed after allocation */
@@ -1522,7 +1522,7 @@ alloc_page_vma(gfp_t gfp, struct vm_area
 
 	cpuset_update_task_memory_state();
 
-	if (unlikely(pol->policy == MPOL_INTERLEAVE)) {
+	if (unlikely(pol->mode == MPOL_INTERLEAVE)) {
 		unsigned nid;
 
 		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT);
@@ -1574,7 +1574,7 @@ struct page *alloc_pages_current(gfp_t g
 		cpuset_update_task_memory_state();
 	if (!pol || in_interrupt() || (gfp & __GFP_THISNODE))
 		pol = &default_policy;
-	if (pol->policy == MPOL_INTERLEAVE)
+	if (pol->mode == MPOL_INTERLEAVE)
 		return alloc_page_interleave(gfp, order, interleave_nodes(pol));
 	return __alloc_pages_nodemask(gfp, order,
 			zonelist_policy(gfp, pol), nodemask_policy(gfp, pol));
@@ -1620,11 +1620,11 @@ int __mpol_equal(struct mempolicy *a, st
 {
 	if (!a || !b)
 		return 0;
-	if (a->policy != b->policy)
+	if (a->mode != b->mode)
 		return 0;
-	if (a->policy != MPOL_DEFAULT && !mpol_match_intent(a, b))
+	if (a->mode != MPOL_DEFAULT && !mpol_match_intent(a, b))
 		return 0;
-	switch (a->policy) {
+	switch (a->mode) {
 	case MPOL_DEFAULT:
 		return 1;
 	case MPOL_BIND:
@@ -1644,7 +1644,7 @@ void __mpol_put(struct mempolicy *p)
 {
 	if (!atomic_dec_and_test(&p->refcnt))
 		return;
-	p->policy = MPOL_DEFAULT;
+	p->mode = MPOL_DEFAULT;
 	kmem_cache_free(policy_cache, p);
 }
 
@@ -1710,7 +1710,7 @@ static void sp_insert(struct shared_poli
 	rb_link_node(&new->nd, parent, p);
 	rb_insert_color(&new->nd, &sp->root);
 	pr_debug("inserting %lx-%lx: %d\n", new->start, new->end,
-		 new->policy ? new->policy->policy : 0);
+		 new->policy ? new->policy->mode : 0);
 }
 
 /* Find shared policy intersecting idx */
@@ -1835,7 +1835,7 @@ int mpol_set_shared_policy(struct shared
 
 	pr_debug("set_shared_policy %lx sz %lu %d %d %lx\n",
 		 vma->vm_pgoff,
-		 sz, npol ? npol->policy : -1,
+		 sz, npol ? npol->mode : -1,
 		 npol ? npol->flags : -1,
 		 npol ? nodes_addr(npol->v.nodes)[0] : -1);
 
@@ -1935,7 +1935,7 @@ static inline int mpol_to_str(char *buff
 	char *p = buffer;
 	int l;
 	nodemask_t nodes;
-	unsigned short mode = pol ? pol->policy : MPOL_DEFAULT;
+	unsigned short mode = pol ? pol->mode : MPOL_DEFAULT;
 	unsigned short flags = pol ? pol->flags : 0;
 
 	switch (mode) {
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

origin.patch
mm-add-nr_writeback_temp-counter-fix.patch

