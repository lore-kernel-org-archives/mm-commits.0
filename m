From: akpm@linux-foundation.org
Subject: - mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch removed from -mm tree
Date: Sun, 27 Apr 2008 23:52:54 -0700
Message-ID: <200804280652.m3S6qsIr012628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756469AbYD1Gxv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 02:53:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, clameter@sgi.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, nacc@us.ibm.com, nickpiggin@yahoo.com.au, rientjes


The patch titled
     Mempolicy: make dequeue_huge_page_vma() obey MPOL_BIND nodemask
has been removed from the -mm tree.  Its filename was
     mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch

This patch was dropped because it was folded into mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Mempolicy: make dequeue_huge_page_vma() obey MPOL_BIND nodemask
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

dequeue_huge_page_vma() is not obeying the MPOL_BIND nodemask with the
zonelist rework.  It needs to search only zones in the mempolicy nodemask for
hugepages.

Use for_each_zone_zonelist_nodemask() instead of for_each_zone_zonelist().

Note: this will bloat mm/hugetlb.o a bit until Mel reworks the inlining of the
for_each_zone...  macros and helpers.

Added mempolicy helper function mpol_bind_nodemask() to hide the details of
mempolicy from hugetlb and to avoid #ifdef CONFIG_NUMA in
dequeue_huge_page_vma().

Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |   13 +++++++++++++
 mm/hugetlb.c              |    4 +++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff -puN include/linux/mempolicy.h~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask
+++ a/include/linux/mempolicy.h
@@ -163,6 +163,14 @@ static inline void check_highest_zone(en
 		policy_zone = k;
 }
 
+static inline nodemask_t *mpol_bind_nodemask(struct mempolicy *mpol)
+{
+	if (mpol->policy == MPOL_BIND)
+		return &mpol->v.nodes;
+	else
+		return NULL;
+}
+
 int do_migrate_pages(struct mm_struct *mm,
 	const nodemask_t *from_nodes, const nodemask_t *to_nodes, int flags);
 
@@ -255,6 +263,11 @@ static inline int do_migrate_pages(struc
 static inline void check_highest_zone(int k)
 {
 }
+
+static inline nodemask_t *mpol_bind_nodemask(struct mempolicy *mpol)
+{
+	return NULL;
+}
 #endif /* CONFIG_NUMA */
 #endif /* __KERNEL__ */
 
diff -puN mm/hugetlb.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask mm/hugetlb.c
--- a/mm/hugetlb.c~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask
+++ a/mm/hugetlb.c
@@ -99,8 +99,10 @@ static struct page *dequeue_huge_page_vm
 					htlb_alloc_mask, &mpol);
 	struct zone *zone;
 	struct zoneref *z;
+	nodemask_t *nodemask = mpol_bind_nodemask(mpol);
 
-	for_each_zone_zonelist(zone, z, zonelist, MAX_NR_ZONES - 1) {
+	for_each_zone_zonelist_nodemask(zone, z, zonelist,
+						MAX_NR_ZONES - 1, nodemask) {
 		nid = zone_to_nid(zone);
 		if (cpuset_zone_allowed_softwall(zone, htlb_alloc_mask) &&
 		    !list_empty(&hugepage_freelists[nid])) {
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework.patch
mempolicy-convert-mpol-constants-to-enum.patch
mempolicy-support-optional-mode-flags.patch
mempolicy-support-optional-mode-flags-fix.patch
mempolicy-add-mpol_f_static_nodes-flag.patch
mempolicy-add-mpol_f_relative_nodes-flag.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-move-rebind-functions.patch
mempolicy-create-mempolicy_operations-structure.patch
mempolicy-create-mempolicy_operations-structure-fix.patch
mempolicy-small-header-file-cleanup.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
mempolicy-fix-parsing-of-tmpfs-mpol-mount-option.patch
fix-indentation.patch
mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy-fix.patch

