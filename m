Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E863E3D34B9
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 22:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787352237; cv=none; b=Nd9bnPVF9x6ohef0fQN65jXx6m87UM3t8gPR4cbmrpCIZdZI997cG/YuHDv3Y2vyBMPm5fRAHKUzcMZe9pTHsneKyTy9lZle7W0Sublk/H6zqRf9XIO+imn+bpvVXcm+giOKdSp5ievz84lKAnFaHH2KWHwK0uAgtD0HlBKJdFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787352237; c=relaxed/simple;
	bh=qA47oKHSez1uTy4qWKACFBSw8ounIZgBZt5ewlBKgPY=;
	h=Date:To:From:Subject:Message-Id; b=AYEQWP6ilkwyhfwkqtogQZ58q9ArIfN7e9ZWLlZgc2SEFJ4hmgKdZPtECn+XMQL3G29fAZg8rYW3ALEBW91hXfAgfoDPaONkZc0Ag7gvb5WRrLVXv5niFDtLmkQ+7xYZ4oCammCOn+gCAhQyDaaiuDBXLz/uszfoxB4RIXPMbmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qh0MLsfS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qh0MLsfS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8E51F00A3A;
	Fri, 21 Aug 2026 22:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787352235;
	bh=8yW5ZhOZklGxKpqo84qO00OyrQMughbbM4D5LiEBb8s=;
	h=Date:To:From:Subject;
	b=qh0MLsfSRacBtHHQuRiI6tQsaKXvjgePedAY0Wn9j2P0JM5zhV7zypWx16396p405
	 BVaihqsjlc1L21f8nrrFmuZYtOiw3w3xDGoO5cF512KnUMijg0O9kgD15kmbYBSq0K
	 CkXKcMHMQaqKgxq1XsezeZlY9p1aJsqY0oFp6bbU=
Date: Fri, 21 Aug 2026 15:43:55 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-catch-race-in-mas_alloc_cyclic.patch added to mm-unstable branch
Message-Id: <20260821224355.BD8E51F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: catch race in mas_alloc_cyclic()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-catch-race-in-mas_alloc_cyclic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-catch-race-in-mas_alloc_cyclic.patch

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
Subject: maple_tree: catch race in mas_alloc_cyclic()
Date: Fri, 21 Aug 2026 15:26:20 -0400

If mas_alloc_cyclic() is called during a low memory situation, it is
possible the lock may be dropped so reclaim can occur.  There is a window
where some other task may allocate the same id and cause the mas_insert()
to fail with -EEXIST.  In this scenario the function will return -EEXIST,
which is not expected.

Modifying the retry on mas_nomem() to re-search for a slot means that any
race with other writes will not matter as the lock will be held between
finding the index and writing the index.

Moving the flag logic avoids cases where the flag is modified on drop
lock/reacquire or when the write fails after clearing the flag.

No existing users are exposed to this issue.

Link: https://lore.kernel.org/20260821192627.4085470-13-liam@infradead.org
Fixes: 9b6713cc75229 ("maple_tree: Add mtree_alloc_cyclic()")
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Reported-by: Chris Mason <clm@meta.com>
Reviewed-by: Chuck Lever <cel@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

--- a/lib/maple_tree.c~maple_tree-catch-race-in-mas_alloc_cyclic
+++ a/lib/maple_tree.c
@@ -3868,35 +3868,40 @@ int mas_alloc_cyclic(struct ma_state *ma
 		void *entry, unsigned long range_lo, unsigned long range_hi,
 		unsigned long *next, gfp_t gfp)
 {
-	unsigned long min = range_lo;
-	int ret = 0;
-
-	range_lo = max(min, *next);
-	ret = mas_empty_area(mas, range_lo, range_hi, 1);
-	if ((mas->tree->ma_flags & MT_FLAGS_ALLOC_WRAPPED) && ret == 0) {
-		mas->tree->ma_flags &= ~MT_FLAGS_ALLOC_WRAPPED;
-		ret = 1;
-	}
-	if (ret < 0 && range_lo > min) {
-		mas_reset(mas);
-		ret = mas_empty_area(mas, min, range_hi, 1);
-		if (ret == 0)
-			ret = 1;
-	}
-	if (ret < 0)
-		return ret;
+	int ret;
+	unsigned long min;
 
+	min = range_lo;
 	do {
+		range_lo = max(min, *next);
+		ret = mas_empty_area(mas, range_lo, range_hi, 1);
+		if (ret < 0 && range_lo > min) {
+			mas_reset(mas);
+			ret = mas_empty_area(mas, min, range_hi, 1);
+			if (ret == 0)
+				ret = 1;
+		}
+		if (ret < 0)
+			goto out;
+
 		mas_insert(mas, entry);
 	} while (mas_nomem(mas, gfp));
-	if (mas_is_err(mas))
-		return xa_err(mas->node);
 
+	if (mas_is_err(mas)) {
+		ret = xa_err(mas->node);
+		goto out;
+	}
+
+	if ((mas->tree->ma_flags & MT_FLAGS_ALLOC_WRAPPED) && ret == 0) {
+		mas->tree->ma_flags &= ~MT_FLAGS_ALLOC_WRAPPED;
+		ret = 1;
+	}
 	*startp = mas->index;
 	*next = *startp + 1;
 	if (*next == 0)
 		mas->tree->ma_flags |= MT_FLAGS_ALLOC_WRAPPED;
 
+out:
 	mas_destroy(mas);
 	return ret;
 }
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

