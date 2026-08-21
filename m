Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AC538F64D
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 22:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787352248; cv=none; b=TanvGMFPvZm2yBClz3bAiQiZlkEG9KAf/Auzme7yghuNSTolnvqGebl1la4norKmyIpXlA4gkt/BYEJ4OPOGyu6NwRcofKjsjF9Fp+x/5nQo1POU9QnoDkL4lYDPN05kWHQMnbiYNB4L1XJBqN+/P9PBqkbX2fwPwopbnPeZFtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787352248; c=relaxed/simple;
	bh=hI3phIW6cARztWAo6/EnPi7Ts9EeLzqRyrVP2EURGFA=;
	h=Date:To:From:Subject:Message-Id; b=hv9rsv6dE1h4L8gxc/twOeIWDeRZyw0vJWdNiQldYCOrFljz0BecocE39TWRvVjKZx9+liSCQfC6gtlmcqXA3W2SBM/FIEJuHOR8FeSt+9ckdRRTmy03yQSWCvExtXlNUfQoVggoAnVFxh1//1rD0SZNzb22aLlzsrsQYOYZR34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e2sc/LUv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e2sc/LUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883141F000E9;
	Fri, 21 Aug 2026 22:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787352246;
	bh=cZsxE4NpJBxnlt5qkoHblL8GrkBzbnnPlDJXtRvowiM=;
	h=Date:To:From:Subject;
	b=e2sc/LUvuHXZo0fIowBzS+5/tr5KRP7AxKLuAOoNI6QV4oyOx8iPN+n+pDAVFGpRk
	 gY4eOR6TcX7EB6tLabPZYh5wKKSNcmdESfhSgFfIZBBXhusdNW2X2HObV6e/C7IneW
	 HSegxxp8k6o/RJCI5g+rmZU94z9VOXrqhAHQ2/Eo=
Date: Fri, 21 Aug 2026 15:44:06 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-change-two-gfp-flags-in-tests.patch added to mm-unstable branch
Message-Id: <20260821224406.883141F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: change two GFP flags in tests
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-change-two-gfp-flags-in-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-change-two-gfp-flags-in-tests.patch

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
Subject: maple_tree: change two GFP flags in tests
Date: Fri, 21 Aug 2026 15:26:24 -0400

The GFP flags in two tests are obviously incorrect.  Make the tests
correctly run by updating the GFP flags.

Link: https://lore.kernel.org/all/d9cbb89faa5bdb71d451781d214a51ce8923a83e.camel@perches.com/
Link: https://lore.kernel.org/20260821192627.4085470-17-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Reported-by: Joe Perches <joe@perches.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/maple.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/radix-tree/maple.c~maple_tree-change-two-gfp-flags-in-tests
+++ a/tools/testing/radix-tree/maple.c
@@ -35234,7 +35234,7 @@ static noinline void __init check_preall
 	mt_set_non_kernel(1);
 	/* Spanning store */
 	mas_set_range(&mas, 1, 100);
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL & GFP_NOWAIT) == 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_NOWAIT) == 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated != 0);
@@ -35257,7 +35257,7 @@ static noinline void __init check_preall
 	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
 	mas_set_range(&mas, 0, 200);
 	mt_set_non_kernel(1);
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL & GFP_NOWAIT) == 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_NOWAIT) == 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated != 0);
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

