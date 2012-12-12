From: akpm@linux-foundation.org
Subject: [merged] tmpfs-fix-shared-mempolicy-leak.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:56:39 -0800
Message-ID: <20121212195639.A15B3100047__18155.0449612134$1355342733$gmane$org@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:47649 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792Ab2LLUE4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 15:04:56 -0500
Received: by mail-qa0-f73.google.com with SMTP id a19so119652qad.0
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 12:04:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, hughd@google.com, stable@vger.kernel.org, tt.rantala@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: fix shared mempolicy leak
has been removed from the -mm tree.  Its filename was
     tmpfs-fix-shared-mempolicy-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: tmpfs: fix shared mempolicy leak

This fixes a regression in 3.7-rc, which has since gone into stable.

Commit 00442ad04a5e ("mempolicy: fix a memory corruption by refcount
imbalance in alloc_pages_vma()") changed get_vma_policy() to raise the
refcount on a shmem shared mempolicy; whereas shmem_alloc_page() went on
expecting alloc_page_vma() to drop the refcount it had acquired.  This
deserves a rework: but for now fix the leak in shmem_alloc_page().

Hugh: shmem_swapin() did not need a fix, but surely it's clearer to use
the same refcounting there as in shmem_alloc_page(), delete its onstack
mempolicy, and the strange mpol_cond_copy() and __mpol_cond_copy() - those
were invented to let swapin_readahead() make an unknown number of calls to
alloc_pages_vma() with one mempolicy; but since 00442ad04a5e,
alloc_pages_vma() has kept refcount in balance, so now no problem.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Tommi Rantala <tt.rantala@gmail.com>
Tested-by: Tommi Rantala <tt.rantala@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |   16 ----------------
 mm/mempolicy.c            |   22 ----------------------
 mm/shmem.c                |   26 ++++++++++++++++----------
 3 files changed, 16 insertions(+), 48 deletions(-)

diff -puN include/linux/mempolicy.h~tmpfs-fix-shared-mempolicy-leak include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~tmpfs-fix-shared-mempolicy-leak
+++ a/include/linux/mempolicy.h
@@ -82,16 +82,6 @@ static inline void mpol_cond_put(struct 
 		__mpol_put(pol);
 }
 
-extern struct mempolicy *__mpol_cond_copy(struct mempolicy *tompol,
-					  struct mempolicy *frompol);
-static inline struct mempolicy *mpol_cond_copy(struct mempolicy *tompol,
-						struct mempolicy *frompol)
-{
-	if (!frompol)
-		return frompol;
-	return __mpol_cond_copy(tompol, frompol);
-}
-
 extern struct mempolicy *__mpol_dup(struct mempolicy *pol);
 static inline struct mempolicy *mpol_dup(struct mempolicy *pol)
 {
@@ -215,12 +205,6 @@ static inline void mpol_cond_put(struct 
 {
 }
 
-static inline struct mempolicy *mpol_cond_copy(struct mempolicy *to,
-						struct mempolicy *from)
-{
-	return from;
-}
-
 static inline void mpol_get(struct mempolicy *pol)
 {
 }
diff -puN mm/mempolicy.c~tmpfs-fix-shared-mempolicy-leak mm/mempolicy.c
--- a/mm/mempolicy.c~tmpfs-fix-shared-mempolicy-leak
+++ a/mm/mempolicy.c
@@ -2037,28 +2037,6 @@ struct mempolicy *__mpol_dup(struct memp
 	return new;
 }
 
-/*
- * If *frompol needs [has] an extra ref, copy *frompol to *tompol ,
- * eliminate the * MPOL_F_* flags that require conditional ref and
- * [NOTE!!!] drop the extra ref.  Not safe to reference *frompol directly
- * after return.  Use the returned value.
- *
- * Allows use of a mempolicy for, e.g., multiple allocations with a single
- * policy lookup, even if the policy needs/has extra ref on lookup.
- * shmem_readahead needs this.
- */
-struct mempolicy *__mpol_cond_copy(struct mempolicy *tompol,
-						struct mempolicy *frompol)
-{
-	if (!mpol_needs_cond_ref(frompol))
-		return frompol;
-
-	*tompol = *frompol;
-	tompol->flags &= ~MPOL_F_SHARED;	/* copy doesn't need unref */
-	__mpol_put(frompol);
-	return tompol;
-}
-
 /* Slow path of a mempolicy comparison */
 bool __mpol_equal(struct mempolicy *a, struct mempolicy *b)
 {
diff -puN mm/shmem.c~tmpfs-fix-shared-mempolicy-leak mm/shmem.c
--- a/mm/shmem.c~tmpfs-fix-shared-mempolicy-leak
+++ a/mm/shmem.c
@@ -910,25 +910,29 @@ static struct mempolicy *shmem_get_sbmpo
 static struct page *shmem_swapin(swp_entry_t swap, gfp_t gfp,
 			struct shmem_inode_info *info, pgoff_t index)
 {
-	struct mempolicy mpol, *spol;
 	struct vm_area_struct pvma;
-
-	spol = mpol_cond_copy(&mpol,
-			mpol_shared_policy_lookup(&info->policy, index));
+	struct page *page;
 
 	/* Create a pseudo vma that just contains the policy */
 	pvma.vm_start = 0;
 	/* Bias interleave by inode number to distribute better across nodes */
 	pvma.vm_pgoff = index + info->vfs_inode.i_ino;
 	pvma.vm_ops = NULL;
-	pvma.vm_policy = spol;
-	return swapin_readahead(swap, gfp, &pvma, 0);
+	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, index);
+
+	page = swapin_readahead(swap, gfp, &pvma, 0);
+
+	/* Drop reference taken by mpol_shared_policy_lookup() */
+	mpol_cond_put(pvma.vm_policy);
+
+	return page;
 }
 
 static struct page *shmem_alloc_page(gfp_t gfp,
 			struct shmem_inode_info *info, pgoff_t index)
 {
 	struct vm_area_struct pvma;
+	struct page *page;
 
 	/* Create a pseudo vma that just contains the policy */
 	pvma.vm_start = 0;
@@ -937,10 +941,12 @@ static struct page *shmem_alloc_page(gfp
 	pvma.vm_ops = NULL;
 	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, index);
 
-	/*
-	 * alloc_page_vma() will drop the shared policy reference
-	 */
-	return alloc_page_vma(gfp, &pvma, 0);
+	page = alloc_page_vma(gfp, &pvma, 0);
+
+	/* Drop reference taken by mpol_shared_policy_lookup() */
+	mpol_cond_put(pvma.vm_policy);
+
+	return page;
 }
 #else /* !CONFIG_NUMA */
 #ifdef CONFIG_TMPFS
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-compaction-fix-compiler-warning.patch
mm-add-a-reminder-comment-for-__gfp_bits_shift.patch
numa-add-config_movable_node-for-movable-dedicated-node.patch
numa-add-config_movable_node-for-movable-dedicated-node-fix.patch
memory_hotplug-allow-online-offline-memory-to-result-movable-node.patch
mm-introduce-new-field-managed_pages-to-struct-zone.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix.patch
linux-next.patch
mm-memmap_init_zone-performance-improvement.patch

