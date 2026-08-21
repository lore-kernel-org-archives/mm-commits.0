Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D85A392807
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 22:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787352222; cv=none; b=k/qSJbyylOoPOYf+7mcAlrKLgT3XbEof80AKqn6gVRzyqvuShs/2bV9YqlWFbItPCczsx/63Dx3GtBdffRWe386NdtYxqgWf7D5nnhbqS4zu1x5HK28cVeLq1r0EFNpNHwIrr8epyeYotp+NBfbvmWAWFB0XvKsv3AWTaRXNKjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787352222; c=relaxed/simple;
	bh=9XoolR5sv8BrINEGMqjrl6qnrWnAdLVyx2MkT+HVcrM=;
	h=Date:To:From:Subject:Message-Id; b=Sc6QE08RjvsioUEoWRhHlqyzePUbra5/XSWVAmMfi/rydjom2ncEsFpS/3s4LzbSxO8WDUo/80KlUqfSNZdEP3brGI3ktIGRCyDhf7c2PI/pf4gSQ97QKz1DTcGxbJ9OhavKABw7zZgUjsdcDh/UWTHF07Knn+mt6nmwxbeOQH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CcHKvb8J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CcHKvb8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA001F00A3A;
	Fri, 21 Aug 2026 22:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787352221;
	bh=ans5d5NOh6PqxJhJQqSP4GTFy0rwO4NvJHPurwJmM9Q=;
	h=Date:To:From:Subject;
	b=CcHKvb8Jz7tu8BqZWcFDG82YNdG36WiUu+TDpSwRvmy7OR57KSxuyu+uDxz/AOME7
	 GT68wQRvfnogjzKr+H+iEGVQaUz44Pumy5PdhVmOEXrn5geuOQtjNY29NJp/6pjcXc
	 3d2j+UAQ5bKK4O9D0XDma0e9Qu5PY1bSFAdKKfjo=
Date: Fri, 21 Aug 2026 15:43:40 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-drop-dead-code-from-mas_extend_spanning_null.patch added to mm-unstable branch
Message-Id: <20260821224341.4EA001F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: drop dead code from mas_extend_spanning_null()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-drop-dead-code-from-mas_extend_spanning_null.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-drop-dead-code-from-mas_extend_spanning_null.patch

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
Subject: maple_tree: drop dead code from mas_extend_spanning_null()
Date: Fri, 21 Aug 2026 15:26:13 -0400

mas_extend_spanning_null() had a clause if the end of the range being
written (mas->last) is the same as the end of the existing range it is
overwriting (wr_mas->r_max), action will be taken.

This code path is not possible because the only calling function
increments mas->last (unless it's ULONG_MAX) to walk to one beyond the
write and then resets the value back to the initial value.

In the case of mas->last == ULONG_MAX, then the second part of the
statement will always be false - mas->last cannot be less than the node
max.

This code never executed and is flawed anyways (the arguments are
incorrectly ordered), so removing it is the safest action.  Since the code
never executes, it is not fixing any issue so Fixes tag is not given.

Link: https://lore.kernel.org/20260821192627.4085470-6-liam@infradead.org
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

 lib/maple_tree.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/lib/maple_tree.c~maple_tree-drop-dead-code-from-mas_extend_spanning_null
+++ a/lib/maple_tree.c
@@ -2997,13 +2997,6 @@ static inline void mas_extend_spanning_n
 		if (r_mas->last < r_wr_mas->r_max)
 			r_mas->last = r_wr_mas->r_max;
 		r_mas->offset++;
-	} else if ((r_mas->last == r_wr_mas->r_max) &&
-	    (r_mas->last < r_mas->max) &&
-	    !mas_slot_locked(r_mas, r_wr_mas->slots, r_mas->offset + 1)) {
-		r_mas->last = mas_safe_pivot(r_mas, r_wr_mas->pivots,
-					     r_wr_mas->type, r_mas->offset + 1);
-		r_mas->offset++;
-		r_wr_mas->r_max = r_mas->last;
 	}
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

