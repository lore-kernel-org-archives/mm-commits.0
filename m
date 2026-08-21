Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7433D9DA6
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 22:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787350915; cv=none; b=CAj0AMmGgsyvb3abctWfj+9rDH8zRuR/PvglHZDpZhaOPOIM+0pkd+GcDvCTxyBkyeMvmG7sBQyARNGfuzEN0pTp6MwIqlmVO6jFKwNV5xAehwBGC2+gSPySunrZDnTWtN3j6UUDsKLdFETFLSfP0heBxR9H1c7LrGNxuO7cNlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787350915; c=relaxed/simple;
	bh=gopKk4o6DKaogCISTfkNUwUvX2/rDMHbr0Ca5NzoaQM=;
	h=Date:To:From:Subject:Message-Id; b=mjhq8Qo37I14FnUT3HeRWELr5sHsnXscZARzh08kF2QHepuqGn7V4x84ZfQvVt2LBRZ8TfscPXZ2w9NqkTIG9vmVJ94fSlo/SL/xl1uqP3esiVkVuS3PcxdKD3kpTi8kWSqwvqb3EYXySx34P/zOvcgQbU7OBSEoV/UTxNTwiDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bEqMhqqs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bEqMhqqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540771F000E9;
	Fri, 21 Aug 2026 22:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787350914;
	bh=rx56tlQofZQ5bffTKzMzz2Zm+iubW/uKErUCIM4HpJ8=;
	h=Date:To:From:Subject;
	b=bEqMhqqsGO+3zFBROYrPUpnjcv+0BiEawxyg1GwFgrncBTfDcfmNFzFdaFeUrbb1W
	 cBGii2pIzdzkaUCa8V8E8bcmIzNc/qQOszTZtI1ecnKkFcMoriVxCX7O3pBlrcTPng
	 O8QRG8bTZAIH//rn+GttMHkRZw2/BO3IUdgkSpMY=
Date: Fri, 21 Aug 2026 15:21:53 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] maple_tree-document-that-erase-may-use-gfp_kernel-for-allocations.patch removed from -mm tree
Message-Id: <20260821222154.540771F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: document that erase may use GFP_KERNEL for allocations
has been removed from the -mm tree.  Its filename was
     maple_tree-document-that-erase-may-use-gfp_kernel-for-allocations.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: document that erase may use GFP_KERNEL for allocations
Date: Tue, 30 Jun 2026 15:08:37 -0400

State that the mas_erase() and mtree_erase() functions may use GFP_KERNEL
on allocation retry.  Don't just depend on people reading the
documentation by adding a check that will warn of the use.

Link: https://lore.kernel.org/20260630190843.3563858-14-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-document-that-erase-may-use-gfp_kernel-for-allocations
+++ a/lib/maple_tree.c
@@ -5658,6 +5658,10 @@ EXPORT_SYMBOL_GPL(mas_find_range_rev);
  * Searches for @mas->index, sets @mas->index and @mas->last to the range and
  * erases that range.
  *
+ * Note that erase requires allocations and will use GFP_KERNEL to do so if
+ * necessary.  If the allocation fails, the internal lock will be dropped to
+ * retry.
+ *
  * Return: the entry that was erased or %NULL, @mas->index and @mas->last are updated.
  */
 void *mas_erase(struct ma_state *mas)
@@ -5666,13 +5670,21 @@ void *mas_erase(struct ma_state *mas)
 	unsigned long index = mas->index;
 	MA_WR_STATE(wr_mas, mas, NULL);
 
+	/*
+	 * In low memory situations, the allocation is retried with the gfp flag
+	 * GFP_KERNEL.  The internal spinlock is dropped in mas_nomem(), however
+	 * the external lock is not dropped.
+	 */
+	if (mt_external_lock(mas->tree))
+		might_alloc(GFP_KERNEL);
+
 	if (!mas_is_active(mas) || !mas_is_start(mas))
 		mas->status = ma_start;
 
 write_retry:
 	entry = mas_state_walk(mas);
 	if (!entry)
-		return NULL;
+		goto out;
 
 	/* Must reset to ensure spanning writes of last slot are detected */
 	mas_reset(mas);
@@ -5683,8 +5695,10 @@ write_retry:
 		goto write_retry;
 	}
 
-	if (mas_is_err(mas))
+	if (mas_is_err(mas)) {
+		entry = NULL;
 		goto out;
+	}
 
 	mas_wr_store_entry(&wr_mas);
 out:
@@ -6012,6 +6026,10 @@ EXPORT_SYMBOL(mtree_alloc_rrange);
  * Erasing is the same as a walk to an entry then a store of a NULL to that
  * ENTIRE range.  In fact, it is implemented as such using the advanced API.
  *
+ * Note that erase requires allocations and will use GFP_KERNEL to do so if
+ * necessary.  If the allocation fails, the internal lock will be dropped to
+ * retry.
+ *
  * Return: The entry stored at the @index or %NULL
  */
 void *mtree_erase(struct maple_tree *mt, unsigned long index)
@@ -6021,6 +6039,7 @@ void *mtree_erase(struct maple_tree *mt,
 	MA_STATE(mas, mt, index, index);
 	trace_ma_op(TP_FCT, &mas);
 
+	might_alloc(GFP_KERNEL);
 	mtree_lock(mt);
 	entry = mas_erase(&mas);
 	mtree_unlock(mt);
_

Patches currently in -mm which might be from liam@infradead.org are

maple_tree-warn_on_once-when-allocations-fail.patch
maple_tree-document-erase-and-allocations-better.patch
maple_tree-change-two-gfp-flags-in-tests.patch
maple_tree-fix-argument-name-in-header.patch
maple_tree-avoid-extra-gap-calculation.patch
maple_tree-add-helper-mas_make_walkable.patch

