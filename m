Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769E02F7EEE
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 23:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782860835; cv=none; b=pBRIObUSNaeWri3PlihFTmDQdizV8+21iMtXHNnlVRVgKWcY64CgUaAUnVUg4cjukP8G3fOOLLbnIEs27omK/Q1BpzVioLKterw5/QAI3ELa06wTa/eiSYT2flIL5HvQTEV8D5cW1NV0ZSbpRlgrCA6tbddQm01a9jmx92RJD2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782860835; c=relaxed/simple;
	bh=4eiZO0mVrQjNlpDi0R3dDb2MRKMqtDTus2jEoT/XNgI=;
	h=Date:To:From:Subject:Message-Id; b=qqn9Rzle8SHoHj8gKn4jawxvwfk84pIeld6e3AGxDfQ9tJi3e2LoD+PLYbXrizIqa9D/xMq9s1GA9gDCHFqMIZOzErd+RBAbR3QPtROka4LtpigG9xxZIyllT7MIUeF+iArhwfmjeCJBhbeo1Dua/YmCGYjjv07G9UqRNjENofs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DhxAmweM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DhxAmweM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141A61F000E9;
	Tue, 30 Jun 2026 23:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782860834;
	bh=sQ0XpIq0qXArM6SfoY5Do7OANyvxFsH03kF4X8Pm0Is=;
	h=Date:To:From:Subject;
	b=DhxAmweMUQl+0LY9r7q4tMiCe5JoEWAVLkNBuuQVr5Hbewc1RkU1mLEgs4ZzqTk0K
	 /rD228pfDO4EF8Nn9OmU8H0+DsQJc3f+q9hTN5S9vcMus5Yqr9+LSMfLTGCqzcMET6
	 /FchSTjQs+BP5BRFp/3CFg7cC3e9tEswozc278xE=
Date: Tue, 30 Jun 2026 16:07:13 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-document-that-erase-may-use-gfp_kernel-for-allocations.patch added to mm-new branch
Message-Id: <20260630230714.141A61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: document that erase may use GFP_KERNEL for allocations
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-document-that-erase-may-use-gfp_kernel-for-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-document-that-erase-may-use-gfp_kernel-for-allocations.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
@@ -5657,6 +5657,10 @@ EXPORT_SYMBOL_GPL(mas_find_range_rev);
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
@@ -5665,13 +5669,21 @@ void *mas_erase(struct ma_state *mas)
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
@@ -5682,8 +5694,10 @@ write_retry:
 		goto write_retry;
 	}
 
-	if (mas_is_err(mas))
+	if (mas_is_err(mas)) {
+		entry = NULL;
 		goto out;
+	}
 
 	mas_wr_store_entry(&wr_mas);
 out:
@@ -6011,6 +6025,10 @@ EXPORT_SYMBOL(mtree_alloc_rrange);
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
@@ -6020,6 +6038,7 @@ void *mtree_erase(struct maple_tree *mt,
 	MA_STATE(mas, mt, index, index);
 	trace_ma_op(TP_FCT, &mas);
 
+	might_alloc(GFP_KERNEL);
 	mtree_lock(mt);
 	entry = mas_erase(&mas);
 	mtree_unlock(mt);
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
maple_tree-warn_on_once-when-allocations-fail.patch
maple_tree-document-erase-and-allocations-better.patch
maple_tree-change-two-gfp-flags-in-tests.patch
maple_tree-fix-argument-name-in-header.patch
maple_tree-avoid-extra-gap-calculation.patch
maple_tree-add-helper-mas_make_walkable.patch

