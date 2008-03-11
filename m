From: akpm@linux-foundation.org
Subject: - fix-mempolicy-reference-counting-bugs.patch removed from -mm tree
Date: Mon, 10 Mar 2008 20:22:07 -0700
Message-ID: <200803110322.m2B3M7hP019784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752252AbYCKDWb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 23:22:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, eric.whitney@hp.com, greg@kroah.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mempolicy: fix reference counting bugs
has been removed from the -mm tree.  Its filename was
     fix-mempolicy-reference-counting-bugs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy: fix reference counting bugs
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Address 3 known bugs in the current memory policy reference counting method. 
I have a series of patches to rework the reference counting to reduce overhead
in the allocation path.  However, that series will require testing in -mm once
I repost it.


1) alloc_page_vma() does not release the extra reference taken for
   vma/shared mempolicy when the mode == MPOL_INTERLEAVE.  This can result in
   leaking mempolicy structures.  This is probably occurring, but not being
   noticed.

   Fix:  add the conditional release of the reference.

2) hugezonelist unconditionally releases a reference on the mempolicy when
   mode == MPOL_INTERLEAVE.  This can result in decrementing the reference
   count for system default policy [should have no ill effect] or premature
   freeing of task policy.  If this occurred, the next allocation using task
   mempolicy would use the freed structure and probably BUG out.

   Fix:  add the necessary check to the release.

3) The current reference counting method assumes that vma 'get_policy()'
   methods automatically add an extra reference a non-NULL returned mempolicy.
    This is true for shmem_get_policy() used by tmpfs mappings, including
   regular page shm segments.  However, SHM_HUGETLB shm's, backed by
   hugetlbfs, just use the vma policy without the extra reference.  This
   results in freeing of the vma policy on the first allocation, with reuse of
   the freed mempolicy structure on subsequent allocations.

   Fix: Rather than add another condition to the conditional reference
   release, which occur in the allocation path, just add a reference when
   returning the vma policy in shm_get_policy() to match the assumptions.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Greg KH <greg@kroah.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>
Cc: <eric.whitney@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c      |    5 +++--
 mm/mempolicy.c |    7 ++++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff -puN ipc/shm.c~fix-mempolicy-reference-counting-bugs ipc/shm.c
--- a/ipc/shm.c~fix-mempolicy-reference-counting-bugs
+++ a/ipc/shm.c
@@ -271,9 +271,10 @@ static struct mempolicy *shm_get_policy(
 
 	if (sfd->vm_ops->get_policy)
 		pol = sfd->vm_ops->get_policy(vma, addr);
-	else if (vma->vm_policy)
+	else if (vma->vm_policy) {
 		pol = vma->vm_policy;
-	else
+		mpol_get(pol);	/* get_vma_policy() expects this */
+	} else
 		pol = current->mempolicy;
 	return pol;
 }
diff -puN mm/mempolicy.c~fix-mempolicy-reference-counting-bugs mm/mempolicy.c
--- a/mm/mempolicy.c~fix-mempolicy-reference-counting-bugs
+++ a/mm/mempolicy.c
@@ -1296,7 +1296,9 @@ struct zonelist *huge_zonelist(struct vm
 		unsigned nid;
 
 		nid = interleave_nid(pol, vma, addr, HPAGE_SHIFT);
-		__mpol_free(pol);		/* finished with pol */
+		if (unlikely(pol != &default_policy &&
+				pol != current->mempolicy))
+			__mpol_free(pol);	/* finished with pol */
 		return NODE_DATA(nid)->node_zonelists + gfp_zone(gfp_flags);
 	}
 
@@ -1360,6 +1362,9 @@ alloc_page_vma(gfp_t gfp, struct vm_area
 		unsigned nid;
 
 		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT);
+		if (unlikely(pol != &default_policy &&
+				pol != current->mempolicy))
+			__mpol_free(pol);	/* finished with pol */
 		return alloc_page_interleave(gfp, 0, nid);
 	}
 	zl = zonelist_policy(gfp, pol);
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

origin.patch
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
mempolicy-create-mempolicy_operations-structure-fix.patch
mempolicy-small-header-file-cleanup.patch

