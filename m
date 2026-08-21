Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5E43B9DAC
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 22:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787352241; cv=none; b=KZCIIKUNKGwhIps5DleMmVahZkSr488p4CnxcFNLS6IXcHtcX4sn1eHMr3FujqOf1kb+PlLEi0LXV4AcM9GxNicZmQEiESQi5fJ+evrYzNMu5vKYIlB2w+xnGRgKVhUX1THBOieSEb5EaJzNoXzdL0Un32+sQ+mhOIKLyjjhHOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787352241; c=relaxed/simple;
	bh=lFjcPScc6RlHDAWOo5R/J9tZ/2JHwBic/hFFtQlCHs8=;
	h=Date:To:From:Subject:Message-Id; b=d86DwyIeA+YM67cygSYEkszPmSrXge+M1Eko/2Tjdwr38OQjCK6wrC2hv5jz+jQ5rc5nZn3TymtA+iYlm2zDjOlNfaqKre4FoOllOlqv76fqLsbf8xgB73Ehv9Qz7mgBQsW7BLZ4JNoypNaixJdT0pCP2jIXPavryt5gKmwy7rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sUvdcyU1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sUvdcyU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40881F000E9;
	Fri, 21 Aug 2026 22:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787352240;
	bh=tiJEk1ZpE2zwQtOWb3ZeHOgzzt7tNAucZra7ZZND/eM=;
	h=Date:To:From:Subject;
	b=sUvdcyU13F7r5mkCeJVDg8u/mfV4Q+i/LarzYWrtjMJ90FbNwkPlxYdQsQESKmp5Q
	 o/fwdfx4aT+zl+b5UnfedS+ae66acfiYxk8SEdqLJC5xZxkPfuqaqSnTmkPmVF5n7C
	 nygmZlvQKoYY14mCVl+695DKQXrWJENfMNLVafgc=
Date: Fri, 21 Aug 2026 15:43:59 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-avoid-mas_erase-and-mtree_erase-failures.patch added to mm-unstable branch
Message-Id: <20260821224359.E40881F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: avoid mas_erase() and mtree_erase() failures
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-avoid-mas_erase-and-mtree_erase-failures.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-avoid-mas_erase-and-mtree_erase-failures.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: avoid mas_erase() and mtree_erase() failures
Date: Fri, 21 Aug 2026 15:26:22 -0400

Failures to remove entries using the two APIs to erase the entries may
result in allocation failures.  The failures may go unnoticed and an
unexpected entry may remain.  Instead, fall back to retrying with
GFP_KERNEL | __GFP_NOFAIL so that the entry will be removed.

Link: https://lore.kernel.org/20260821192627.4085470-15-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    2 +
 lib/maple_tree.c           |   68 +++++++++++++++++++++++++----------
 2 files changed, 52 insertions(+), 18 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-avoid-mas_erase-and-mtree_erase-failures
+++ a/include/linux/maple_tree.h
@@ -570,6 +570,8 @@ int mas_alloc_cyclic(struct ma_state *ma
 		unsigned long *next, gfp_t gfp);
 
 bool mas_nomem(struct ma_state *mas, gfp_t gfp);
+bool mas_nomem_nofail(struct ma_state *mas, unsigned long index,
+		      unsigned long last);
 void mas_pause(struct ma_state *mas);
 void maple_tree_init(void);
 void mas_destroy(struct ma_state *mas);
--- a/lib/maple_tree.c~maple_tree-avoid-mas_erase-and-mtree_erase-failures
+++ a/lib/maple_tree.c
@@ -5658,9 +5658,10 @@ EXPORT_SYMBOL_GPL(mas_find_range_rev);
  * Searches for @mas->index, sets @mas->index and @mas->last to the range and
  * erases that range.
  *
- * Note that erase requires allocations and will use GFP_KERNEL to do so if
- * necessary.  If the allocation fails, the internal lock will be dropped to
- * retry.
+ * Note that erase requires allocations and will use GFP_KERNEL | __GFP_NOFAIL
+ * to do so if necessary.  If the allocation fails, the internal lock will be
+ * dropped to retry.  An externally locked tree must be protected by a lock that
+ * allows blocking for this API.
  *
  * Return: the entry that was erased or %NULL, @mas->index and @mas->last are updated.
  */
@@ -5672,8 +5673,8 @@ void *mas_erase(struct ma_state *mas)
 
 	/*
 	 * In low memory situations, the allocation is retried with the gfp flag
-	 * GFP_KERNEL.  The internal spinlock is dropped in mas_nomem(), however
-	 * the external lock is not dropped.
+	 * GFP_KERNEL | __GFP_NOFAIL.  The internal spinlock is dropped in
+	 * mas_nomem_nofail(), however the external lock is not dropped.
 	 */
 	if (mt_external_lock(mas->tree))
 		might_alloc(GFP_KERNEL);
@@ -5689,16 +5690,8 @@ write_retry:
 	/* Must reset to ensure spanning writes of last slot are detected */
 	mas_reset(mas);
 	mas_wr_preallocate(&wr_mas, NULL);
-	if (mas_nomem(mas, GFP_KERNEL)) {
-		/* in case the range of entry changed when unlocked */
-		mas->index = mas->last = index;
+	if (mas_nomem_nofail(mas, index, index))
 		goto write_retry;
-	}
-
-	if (mas_is_err(mas)) {
-		entry = NULL;
-		goto out;
-	}
 
 	mas_wr_store_entry(&wr_mas);
 out:
@@ -5721,6 +5714,10 @@ bool mas_nomem(struct ma_state *mas, gfp
 	if (likely(mas->node != MA_ERROR(-ENOMEM)))
 		return false;
 
+	/* Allocations can fail, don't do this. */
+	WARN_ON_ONCE(!gfpflags_allow_blocking(gfp) &&
+		     mt_external_lock(mas->tree));
+
 	if (gfpflags_allow_blocking(gfp) && !mt_external_lock(mas->tree)) {
 		mtree_unlock(mas->tree);
 		mas_alloc_nodes(mas, gfp);
@@ -5731,7 +5728,9 @@ bool mas_nomem(struct ma_state *mas, gfp
 
 	/*
 	 * Return false on zero forward progress.  Partial allocations are kept
-	 * so the retry path will attempt to get the rest.
+	 * so the retry path will attempt to get the rest.  The failure should
+	 * not happen as we try our best to reclaim.  The user would need an
+	 * external lock with a non-blocking gfp in a low memory situation.
 	 */
 	if (!mas->sheaf && !mas->alloc)
 		return false;
@@ -5740,6 +5739,39 @@ bool mas_nomem(struct ma_state *mas, gfp
 	return true;
 }
 
+/**
+ * mas_nomem_nofail() - Retry allocations with __GFP_NOFAIL, if the maple state
+ * has stored the -ENOMEM error.
+ * @mas: The maple state
+ * @index: The start of the range for the @mas reset
+ * @last: The end of the range for the @mas reset
+ *
+ * Return: false if @mas isn't in an -ENOMEM state.  True if the allocation
+ * happens, the state is reset.  The internal lock will be dropped and external
+ * locks must allow blocking.
+ */
+bool mas_nomem_nofail(struct ma_state *mas, unsigned long index,
+		unsigned long last)
+	__must_hold(mas->tree->ma_lock)
+{
+	gfp_t gfp;
+
+	if (likely(mas->node != MA_ERROR(-ENOMEM)))
+		return false;
+
+	gfp = GFP_KERNEL | __GFP_NOFAIL;
+	if (!mt_external_lock(mas->tree)) {
+		mtree_unlock(mas->tree);
+		mas_alloc_nodes(mas, gfp);
+		mtree_lock(mas->tree);
+	} else {
+		mas_alloc_nodes(mas, gfp);
+	}
+
+	mas_set_range(mas, index, last);
+	return true;
+}
+
 void __init maple_tree_init(void)
 {
 	struct kmem_cache_args args = {
@@ -6026,9 +6058,9 @@ EXPORT_SYMBOL(mtree_alloc_rrange);
  * Erasing is the same as a walk to an entry then a store of a NULL to that
  * ENTIRE range.  In fact, it is implemented as such using the advanced API.
  *
- * Note that erase requires allocations and will use GFP_KERNEL to do so if
- * necessary.  If the allocation fails, the internal lock will be dropped to
- * retry.
+ * Note that erase requires allocations and will use GFP_KERNEL | __GFP_NOFAIL
+ * to do so if necessary.  If the allocation fails, the internal lock will be
+ * dropped to retry.
  *
  * Return: The entry stored at the @index or %NULL
  */
_

Patches currently in -mm which might be from liam@infradead.org are

maple_tree-add-rcu-locking-check-when-lockdep-is-enabled.patch
locking-lockdep-add-sequence-counter-to-held_lock.patch
maple_tree-add-write-lock-checking-with-lockdep-sequence-numbers.patch
maple_tree-documentation-fix.patch
maple_tree-drop-dead-code-from-mas_extend_spanning_null.patch
maple_tree-drop-maple_alloc_slots.patch
maple_tree-clarify-comments-on-mas_nomem.patch
maple_tree-use-prefetched-value-in-mas_wr_store_type.patch
maple_tree-optimise-mas_wr_node_store-when-not-in-rcu-mode.patch
maple_tree-micro-optimisation-of-mas_wr_store_type.patch
maple_tree-add-bulk-parent-set-helper.patch
maple_tree-catch-race-in-mas_alloc_cyclic.patch
maple_tree-document-that-erase-may-use-gfp_kernel-for-allocations.patch
maple_tree-avoid-mas_erase-and-mtree_erase-failures.patch
maple_tree-document-erase-and-allocations-better.patch
maple_tree-change-two-gfp-flags-in-tests.patch
maple_tree-fix-argument-name-in-header.patch
maple_tree-avoid-extra-gap-calculation.patch
maple_tree-add-helper-mas_make_walkable.patch

