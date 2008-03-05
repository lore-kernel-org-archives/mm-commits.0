From: akpm@linux-foundation.org
Subject: + mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch added to -mm tree
Date: Wed, 05 Mar 2008 15:39:34 -0800
Message-ID: <200803052339.m25NdZwt027566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756377AbYCEXko (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 18:40:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, clameter@sgi.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au, pj@sgi.com


The patch titled
     Mempolicy: update stale documentation and comments
has been added to the -mm tree.  Its filename is
     mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch

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

fix-mempolicy-reference-counting-bugs.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch

