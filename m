From: akpm@linux-foundation.org
Subject: - mempolicy-mark-shared-policies-for-unref.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:53:15 -0700
Message-ID: <200804282153.m3SLrF03017849@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935541AbYD1Vxe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:53:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mempolicy:  mark shared policies for unref
has been removed from the -mm tree.  Its filename was
     mempolicy-mark-shared-policies-for-unref.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy:  mark shared policies for unref
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

As part of yet another rework of mempolicy reference counting, we want to be
able to identify shared policies efficiently, because they have an extra ref
taken on lookup that needs to be removed when we're finished using the policy.

  Note:  the extra ref is required because the policies are
  shared between tasks/processes and can be changed/freed
  by one task while another task is using them--e.g., for
  page allocation.

Building on David Rientjes mempolicy "mode flags" enhancement, this patch
indicates a "shared" policy by setting a new MPOL_F_SHARED flag in the flags
member of the struct mempolicy added by David.  MPOL_F_SHARED, and any future
"internal mode flags" are reserved from bit zero up, as they will never be
passed in the upper bits of the mode argument of a mempolicy API.

I set the MPOL_F_SHARED flag when the policy is installed in the shared policy
rb-tree.  Don't need/want to clear the flag when removing from the tree as the
mempolicy is freed [unref'd] internally to the sp_delete() function.  However,
a task could hold another reference on this mempolicy from a prior lookup.  We
need the MPOL_F_SHARED flag to stay put so that any tasks holding a ref will
unref, eventually freeing, the mempolicy.

A later patch in this series will introduce a function to conditionally unref
[mpol_free] a policy.  The MPOL_F_SHARED flag is one reason [currently the
only reason] to unref/free a policy via the conditional free.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    7 +++++++
 mm/mempolicy.c            |    1 +
 2 files changed, 8 insertions(+)

diff -puN include/linux/mempolicy.h~mempolicy-mark-shared-policies-for-unref include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mempolicy-mark-shared-policies-for-unref
+++ a/include/linux/mempolicy.h
@@ -44,6 +44,13 @@ enum {
 #define MPOL_MF_MOVE_ALL (1<<2)	/* Move every page to conform to mapping */
 #define MPOL_MF_INTERNAL (1<<3)	/* Internal flags start here */
 
+/*
+ * Internal flags that share the struct mempolicy flags word with
+ * "mode flags".  These flags are allocated from bit 0 up, as they
+ * are never OR'ed into the mode in mempolicy API arguments.
+ */
+#define MPOL_F_SHARED  (1 << 0)	/* identify shared policies */
+
 #ifdef __KERNEL__
 
 #include <linux/mmzone.h>
diff -puN mm/mempolicy.c~mempolicy-mark-shared-policies-for-unref mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-mark-shared-policies-for-unref
+++ a/mm/mempolicy.c
@@ -1750,6 +1750,7 @@ static struct sp_node *sp_alloc(unsigned
 	n->start = start;
 	n->end = end;
 	mpol_get(pol);
+	pol->flags |= MPOL_F_SHARED;	/* for unref */
 	n->policy = pol;
 	return n;
 }
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

origin.patch
mm-add-nr_writeback_temp-counter-fix.patch

