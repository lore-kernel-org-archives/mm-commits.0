From: akpm@linux-foundation.org
Subject: + mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework.patch added to -mm tree
Date: Fri, 07 Mar 2008 00:51:52 -0800
Message-ID: <200803070851.m278pqhk013917@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753396AbYCGIwW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 03:52:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, clameter@sgi.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, nacc@us.ibm.com, nickpiggin@yahoo.com.au, rientjes@google.com


The patch titled
     Mempolicy: make dequeue_huge_page_vma() obey MPOL_BIND nodemask rework
has been added to the -mm tree.  Its filename is
     mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework.patch

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
Subject: Mempolicy: make dequeue_huge_page_vma() obey MPOL_BIND nodemask rework
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Fix for earlier patch:
"mempolicy-make-dequeue_huge_page_vma-obey-bind-policy"

Against: 2.6.25-rc3-mm1 atop the above patch.

As suggested by Nish Aravamudan, remove the mpol_bind_nodemask()
helper and return a pointer to the policy node mask from
huge_zonelist for MPOL_BIND.  This hides more of the mempolicy
quirks from hugetlb.

In making this change, I noticed that the huge_zonelist() stub
for !NUMA wasn't nulling out the mpol.  Added that as well.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |   21 ++++++---------------
 mm/hugetlb.c              |    4 ++--
 mm/mempolicy.c            |   18 ++++++++++++------
 3 files changed, 20 insertions(+), 23 deletions(-)

diff -puN include/linux/mempolicy.h~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework
+++ a/include/linux/mempolicy.h
@@ -152,7 +152,8 @@ extern void mpol_fix_fork_child_flag(str
 
 extern struct mempolicy default_policy;
 extern struct zonelist *huge_zonelist(struct vm_area_struct *vma,
-		unsigned long addr, gfp_t gfp_flags, struct mempolicy **mpol);
+				unsigned long addr, gfp_t gfp_flags,
+				struct mempolicy **mpol, nodemask_t **nodemask);
 extern unsigned slab_node(struct mempolicy *policy);
 
 extern enum zone_type policy_zone;
@@ -163,14 +164,6 @@ static inline void check_highest_zone(en
 		policy_zone = k;
 }
 
-static inline nodemask_t *mpol_bind_nodemask(struct mempolicy *mpol)
-{
-	if (mpol->policy == MPOL_BIND)
-		return &mpol->v.nodes;
-	else
-		return NULL;
-}
-
 int do_migrate_pages(struct mm_struct *mm,
 	const nodemask_t *from_nodes, const nodemask_t *to_nodes, int flags);
 
@@ -248,8 +241,11 @@ static inline void mpol_fix_fork_child_f
 }
 
 static inline struct zonelist *huge_zonelist(struct vm_area_struct *vma,
- 		unsigned long addr, gfp_t gfp_flags, struct mempolicy **mpol)
+				unsigned long addr, gfp_t gfp_flags,
+				struct mempolicy **mpol, nodemask_t **nodemask)
 {
+	*mpol = NULL;
+	*nodemask = NULL;
 	return node_zonelist(0, gfp_flags);
 }
 
@@ -263,11 +259,6 @@ static inline int do_migrate_pages(struc
 static inline void check_highest_zone(int k)
 {
 }
-
-static inline nodemask_t *mpol_bind_nodemask(struct mempolicy *mpol)
-{
-	return NULL;
-}
 #endif /* CONFIG_NUMA */
 #endif /* __KERNEL__ */
 
diff -puN mm/hugetlb.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework mm/hugetlb.c
--- a/mm/hugetlb.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework
+++ a/mm/hugetlb.c
@@ -95,11 +95,11 @@ static struct page *dequeue_huge_page_vm
 	int nid;
 	struct page *page = NULL;
 	struct mempolicy *mpol;
+	nodemask_t *nodemask;
 	struct zonelist *zonelist = huge_zonelist(vma, address,
-					htlb_alloc_mask, &mpol);
+					htlb_alloc_mask, &mpol, &nodemask);
 	struct zone *zone;
 	struct zoneref *z;
-	nodemask_t *nodemask = mpol_bind_nodemask(mpol);
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 						MAX_NR_ZONES - 1, nodemask) {
diff -puN mm/mempolicy.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework mm/mempolicy.c
--- a/mm/mempolicy.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework
+++ a/mm/mempolicy.c
@@ -1276,25 +1276,31 @@ static inline unsigned interleave_nid(st
  * @vma = virtual memory area whose policy is sought
  * @addr = address in @vma for shared policy lookup and interleave policy
  * @gfp_flags = for requested zone
- * @mpol = pointer to mempolicy pointer for reference counted 'BIND policy
+ * @mpol = pointer to mempolicy pointer for reference counted mempolicy
+ * @nodemask = pointer to nodemask pointer for MPOL_BIND nodemask
  *
  * Returns a zonelist suitable for a huge page allocation.
- * If the effective policy is 'BIND, returns pointer to policy's zonelist.
+ * If the effective policy is 'BIND, returns pointer to local node's zonelist,
+ * and a pointer to the mempolicy's @nodemask for filtering the zonelist.
  * If it is also a policy for which get_vma_policy() returns an extra
- * reference, we must hold that reference until after allocation.
+ * reference, we must hold that reference until after the allocation.
  * In that case, return policy via @mpol so hugetlb allocation can drop
- * the reference.  For non-'BIND referenced policies, we can/do drop the
+ * the reference. For non-'BIND referenced policies, we can/do drop the
  * reference here, so the caller doesn't need to know about the special case
  * for default and current task policy.
  */
 struct zonelist *huge_zonelist(struct vm_area_struct *vma, unsigned long addr,
-				gfp_t gfp_flags, struct mempolicy **mpol)
+				gfp_t gfp_flags, struct mempolicy **mpol,
+				nodemask_t **nodemask)
 {
 	struct mempolicy *pol = get_vma_policy(current, vma, addr);
 	struct zonelist *zl;
 
 	*mpol = NULL;		/* probably no unref needed */
-	if (pol->policy == MPOL_INTERLEAVE) {
+	*nodemask = NULL;	/* assume !MPOL_BIND */
+	if (pol->policy == MPOL_BIND) {
+			*nodemask = &pol->v.nodes;
+	} else if (pol->policy == MPOL_INTERLEAVE) {
 		unsigned nid;
 
 		nid = interleave_nid(pol, vma, addr, HPAGE_SHIFT);
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

fix-mempolicy-reference-counting-bugs.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework.patch
mempolicy-convert-mpol-constants-to-enum.patch
mempolicy-support-optional-mode-flags.patch
mempolicy-add-mpol_f_static_nodes-flag.patch
mempolicy-add-mpol_f_relative_nodes-flag.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-move-rebind-functions.patch
mempolicy-create-mempolicy_operations-structure.patch
mempolicy-small-header-file-cleanup.patch

