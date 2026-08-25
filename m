Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7440537CD2C
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622984; cv=none; b=p9d3SJXhA22gpi3/i1YoaeSRedcYmqUTY2XfRSzEh1LAexGubS2RTcp7hTRfTjTZvSl4fXscLIRiWT/FX0A5wPfxjAWPgzbpNh+u2NvFaDPYjEaCiA/CTMkCx5jzVH3gVigsi74u1wJvtoXA38XyZST/DIWmq1qB5jYSQklPspE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622984; c=relaxed/simple;
	bh=4ruUGctME6FdbXjytB7blsFB/8tPoPdULVBo8fG1h5c=;
	h=Date:To:From:Subject:Message-Id; b=tPdo2L+HKhc17/ayhGvMeGyvJNpD68InoYnJnKZFSkYzQt132oZBn26ouzCJdRT/CiuAnOT1aSGB4DNHE11nYWJNrnT8v7H5px/oW+9zc9+FwIbkRkJTvI/Zmr7D964jIMYTjen3kSAKH/0PrlpFnXb8cRuMyhnJ7fR4JHaLCE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lnXoazNS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lnXoazNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A741F00A3A;
	Tue, 25 Aug 2026 01:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622982;
	bh=e9YyeyOF56k5q3lYNC+4Q4VpRGrDiNOy4anQD+7aLJ8=;
	h=Date:To:From:Subject;
	b=lnXoazNSDLQhRPSA2gYjBkvwkrqewh+ovyRRk6foYpkM6botrRk7O2BLw2iLi8J2b
	 XqHfBEtrxftwAiBEmic/NRRybWj9b/qvgobfO73GidMy7H10CBLrX+IXmeTYSItcxG
	 hJ7/SngLzW2/kXInqAI/7kRqgKpC3N/Z1H/CupCk=
Date: Mon, 24 Aug 2026 18:56:21 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,leitao@debian.org,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-avoid-mas_erase-and-mtree_erase-failures.patch removed from -mm tree
Message-Id: <20260825015622.48A741F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: avoid mas_erase() and mtree_erase() failures
has been removed from the -mm tree.  Its filename was
     maple_tree-avoid-mas_erase-and-mtree_erase-failures.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


