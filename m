Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FA02F7F06
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 23:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782860823; cv=none; b=WRCGtbEodLhRHFfkfL0p2Q/OhdYs6WNhLfac7ZAGPUmHPTN3ueHqECgPJ9qsmqQPLzGUPt7CkwEuOqQxu5TC65mRwHOgXX5HplcKOg0Zsn0IAA5pazGT8hKQ/3wTD5zoEFvHgUSfR+FFrRTz7otTCJ3BaAPqSPhhUBseXNtA254=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782860823; c=relaxed/simple;
	bh=79G70V9ex3UGbdPf04A2rzRaF0vMRvj8Jg/SPhjwrtM=;
	h=Date:To:From:Subject:Message-Id; b=rI27HzkXy1yNjfOnJhGC62tr31WwohSYl8lMYC5KStj/WPCpDTw1R6MEKtGyJkoBnt8qdav5gPDB1Cispom0++9XJVQdgsHkg2DNr4v4zO6U+SxkTORHaLMR2NoW/pU9BrisRYb8TTPD4yrX6axSrqO38Qm1tmz7RGFjJlVlCpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o+lM8cGQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o+lM8cGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9426C1F000E9;
	Tue, 30 Jun 2026 23:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782860821;
	bh=aqEcmnXsCiCjyH8W5hu9uLL4JgC84xK/+zlof0/GaUM=;
	h=Date:To:From:Subject;
	b=o+lM8cGQvR5Wjus02YVegNEt1yLbhdPox/oWeIBnvqfGKypUjXauao8f8Oymu+kOG
	 +m2E7cYoPPgZFXGLCTH/6IQgFjvzaAsry3ET4yYWd06+hyNyHHbVnFEPQ3tV51lDei
	 qmukfc7Aflp7ERngoEZVgwJOTsVwD9QtetceIfn8=
Date: Tue, 30 Jun 2026 16:07:01 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-clarify-comments-on-mas_nomem.patch added to mm-new branch
Message-Id: <20260630230701.9426C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: clarify comments on mas_nomem()
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-clarify-comments-on-mas_nomem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-clarify-comments-on-mas_nomem.patch

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
Subject: maple_tree: clarify comments on mas_nomem()
Date: Tue, 30 Jun 2026 15:08:31 -0400

When an allocation completely fails, the return is false.  If the
allocation succeeds or partially succeeds, return true to indicate a retry
of the operation.  Note that since the lock may have been dropped, the
operation is retried from the start - including potentially allocating
more memory.

Link: https://lore.kernel.org/20260630190843.3563858-8-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
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

 lib/maple_tree.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-clarify-comments-on-mas_nomem
+++ a/lib/maple_tree.c
@@ -5676,10 +5676,11 @@ EXPORT_SYMBOL_GPL(mas_erase);
 
 /**
  * mas_nomem() - Check if there was an error allocating and do the allocation
- * if necessary If there are allocations, then free them.
+ * if necessary.
+ *
  * @mas: The maple state
  * @gfp: The GFP_FLAGS to use for allocations
- * Return: true on allocation, false otherwise.
+ * Return: False on no memory.  True otherwise (partial success as well)
  */
 bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 	__must_hold(mas->tree->ma_lock)
@@ -5695,6 +5696,10 @@ bool mas_nomem(struct ma_state *mas, gfp
 		mas_alloc_nodes(mas, gfp);
 	}
 
+	/*
+	 * Return false on zero forward progress.  Partial allocations are kept
+	 * so the retry path will attempt to get the rest.
+	 */
 	if (!mas->sheaf && !mas->alloc)
 		return false;
 
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

