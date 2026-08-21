Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56AE93B9DAC
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 22:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787352239; cv=none; b=oIeEWgW2miYgLKRZXuDTM4JRt9BSbZjcos696p82gx3+sx1OAf03IHlvyn05rPq61moZQRVCVRLFBx38TxODOgYSQ+jJqOJJpSIt9C/avyYEmb15UCe1GbfcnsZW19Eo1F0YJsJk9Zm/guol6T7QjW5NR0JfVcJWrGNUU+rZMBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787352239; c=relaxed/simple;
	bh=YwyhuOhTLuArDmDW7CPTEfClcPh+0aY8DVMEBsuW+vg=;
	h=Date:To:From:Subject:Message-Id; b=uAKYz5GFfa/OamT5bNc0d7kRIfozh30oEZeF1bGDCUD6etticI/1JSU/TlM/PgpSw5NSLHoQvXyTI/27Ao+mDF400pu1vMkkcK6z7lA0rjvzJYCh+mTBymEldJp8BEevg91ZousP0nCzbig/Hw57hdoamsaQ69ex7uRat0aAnRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U8TCQos4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U8TCQos4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD751F00A3A;
	Fri, 21 Aug 2026 22:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787352237;
	bh=9ADc7279BXsM/Z/nB8lU7ha8lnY2QBPHzmca5pe3ilw=;
	h=Date:To:From:Subject;
	b=U8TCQos4Nu9Icq4OjqwNjP08WyBkdZUGPHsmV13QUJAKOOs8DQblGksTcCWbVEw5R
	 ZMjRhJNX4BD+fXY7QHY6d3b8D49FNtzi896a6K7njjy5fliWX2Q528jpOi2Ua8dMSP
	 /0qcAy+RX3Fv76sZZvh6GCkBzGR0umcILDFJ+gjs=
Date: Fri, 21 Aug 2026 15:43:57 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-document-that-erase-may-use-gfp_kernel-for-allocations.patch added to mm-unstable branch
Message-Id: <20260821224357.CCD751F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: document that erase may use GFP_KERNEL for allocations
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-document-that-erase-may-use-gfp_kernel-for-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-document-that-erase-may-use-gfp_kernel-for-allocations.patch

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
Subject: maple_tree: document that erase may use GFP_KERNEL for allocations
Date: Fri, 21 Aug 2026 15:26:21 -0400

State that the mas_erase() and mtree_erase() functions may use GFP_KERNEL
on allocation retry.  Don't just depend on people reading the
documentation by adding a check that will warn of the use.

Link: https://lore.kernel.org/20260821192627.4085470-14-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
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

