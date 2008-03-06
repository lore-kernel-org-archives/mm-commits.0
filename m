From: akpm@linux-foundation.org
Subject: + mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch added to -mm tree
Date: Wed, 05 Mar 2008 16:40:05 -0800
Message-ID: <200803060040.m260e5kF032685@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763126AbYCFAlG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 19:41:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, clameter@sgi.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, nacc@us.ibm.com, nickpiggin@yahoo.com.au, rientjes@google.com


The patch titled
     Mempolicy: make dequeue_huge_page_vma() obey MPOL_BIND nodemask
has been added to the -mm tree.  Its filename is
     mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch

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

fix-mempolicy-reference-counting-bugs.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch

