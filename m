Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61DB3B9DAC
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 22:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787352229; cv=none; b=cc7p6kAJCCtlb5SuXIW1bDVkEkztYmRcWXp/YQrieFjBpXXaHesJj7pQvFlhMHfGrcy/SyNI5AQ5e6VgQC+BTPnNpcJx9pZ9i76ooLWD+5iQlq9PGSj4pOi956/uVsQi70cyGYKkupk4DzAyolfP+lxCPlpaQQPA3OBUkq7JflE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787352229; c=relaxed/simple;
	bh=4lCpKl2U2tJtL60XDT4Q3i8vpOyQfy4/MGjjzb8lTvk=;
	h=Date:To:From:Subject:Message-Id; b=pXDkntwrssFcHR4cnl+pcZjfBc/aUW3zPisu79DKTQxKSkwti7G3a1ipJ20gbzOwnT0p59W8Eei8EIvF15jxmYZOQKeF+EqEVY3Iwgs7f2QPv105XYwNFt3rHb8CJUzBOunQlvGfHfUE/Q6RpnJVyzN0gxxvxkh5pm2Bzu37wyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SDf1hXFQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SDf1hXFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E5D1F00A3A;
	Fri, 21 Aug 2026 22:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787352227;
	bh=3ia0LRWhjMyE3Vng8h2cWwKLxQmoGFwa9zfEM1afw68=;
	h=Date:To:From:Subject;
	b=SDf1hXFQoqvWQh5NIu+RtdnoCzuU+pQHFc6Lsm4SxgT4in8FO9zw6vP+Z/0qC1XBt
	 SCiwJHVTzOz1fJuEDwb1UvFGd2UOOR2L2Y3y6O8YkYl5pWnKLVKK70L4h3UYCWy/B+
	 MgCA152MfAzZd6rWozYVpM1cRhbTwOJW6qK2f1ys=
Date: Fri, 21 Aug 2026 15:43:46 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-use-prefetched-value-in-mas_wr_store_type.patch added to mm-unstable branch
Message-Id: <20260821224347.52E5D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: use prefetched value in mas_wr_store_type()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-use-prefetched-value-in-mas_wr_store_type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-use-prefetched-value-in-mas_wr_store_type.patch

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
Subject: maple_tree: use prefetched value in mas_wr_store_type()
Date: Fri, 21 Aug 2026 15:26:16 -0400

The slot contents exist in wr_mas->content, which has less overhead than
reading the slot again.

Link: https://lore.kernel.org/20260821192627.4085470-9-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-use-prefetched-value-in-mas_wr_store_type
+++ a/lib/maple_tree.c
@@ -3280,7 +3280,7 @@ static inline void mas_wr_slot_store(str
 	void __rcu **slots = wr_mas->slots;
 	bool gap = false;
 
-	gap |= !mt_slot_locked(mas->tree, slots, offset);
+	gap |= !wr_mas->content;
 	gap |= !mt_slot_locked(mas->tree, slots, offset + 1);
 
 	if (wr_mas->offset_end - offset == 1) {
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

