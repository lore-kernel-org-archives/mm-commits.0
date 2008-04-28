From: akpm@linux-foundation.org
Subject: - mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch removed from -mm tree
Date: Sun, 27 Apr 2008 23:52:52 -0700
Message-ID: <200804280652.m3S6qqQ7012625@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53467 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608AbYD1Gxk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 02:53:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, clameter@sgi.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au, pj@sgi.com, mm-commits@vg


The patch titled
     Mempolicy: update stale documentation and comments
has been removed from the -mm tree.  Its filename was
     mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch

This patch was dropped because it was folded into mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Mempolicy: update stale documentation and comments
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Address stale comments and numa_memory_policy.txt discussion based on Mel
Gorman's changes to page allocation zonelist handling.

Specifically: mpol_free() and mpol_copy() no longer need to deal with a custom
zonelist for MPOL_BIND policy, and MPOL_BIND now allocates memory from the
nearest node with available memory in the specified nodemask.

In "fixing" the mpol_free() and mpol_copy() comments in mempolicy.h, I wanted
to replace them with something, rather than just deleting them.  So, I
described the reference counting.  Not directly related to the zonelist
changes, but useful, IMO.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Paul Jackson <pj@sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/numa_memory_policy.txt |   11 +++--------
 include/linux/mempolicy.h               |    8 +++++---
 2 files changed, 8 insertions(+), 11 deletions(-)

diff -puN Documentation/vm/numa_memory_policy.txt~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes Documentation/vm/numa_memory_policy.txt
--- a/Documentation/vm/numa_memory_policy.txt~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes
+++ a/Documentation/vm/numa_memory_policy.txt
@@ -182,14 +182,9 @@ Components of Memory Policies
 	    The Default mode does not use the optional set of nodes.
 
 	MPOL_BIND:  This mode specifies that memory must come from the
-	set of nodes specified by the policy.
-
-	    The memory policy APIs do not specify an order in which the nodes
-	    will be searched.  However, unlike "local allocation", the Bind
-	    policy does not consider the distance between the nodes.  Rather,
-	    allocations will fallback to the nodes specified by the policy in
-	    order of numeric node id.  Like everything in Linux, this is subject
-	    to change.
+	set of nodes specified by the policy.  Memory will be allocated from
+	the node in the set with sufficient free memory that is closest to
+	the node where the allocation takes place.
 
 	MPOL_PREFERRED:  This mode specifies that the allocation should be
 	attempted from the single node specified in the policy.  If that
diff -puN include/linux/mempolicy.h~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes
+++ a/include/linux/mempolicy.h
@@ -54,11 +54,13 @@ struct mm_struct;
  * mmap_sem.
  *
  * Freeing policy:
- * When policy is MPOL_BIND v.zonelist is kmalloc'ed and must be kfree'd.
- * All other policies don't have any external state. mpol_free() handles this.
+ * Mempolicy objects are reference counted.  A mempolicy will be freed when
+ * mpol_free() decrements the reference count to zero.
  *
  * Copying policy objects:
- * For MPOL_BIND the zonelist must be always duplicated. mpol_clone() does this.
+ * mpol_copy() allocates a new mempolicy and copies the specified mempolicy
+ * to the new storage.  The reference count of the new object is initialized
+ * to 1, representing the caller of mpol_copy().
  */
 struct mempolicy {
 	atomic_t refcnt;
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch
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

