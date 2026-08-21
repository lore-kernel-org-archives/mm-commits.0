Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8086A39021C
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 22:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787352226; cv=none; b=k4FuP8+yYoFOH1JHsMZq+uwkFnv8QQbuQ42F54fDFn7jURrU6+udAeD4PvmRUSo9imc3yzXKvFtjx0X3OeqTw0eSBfUOK2M/s9QLqCod51b9L9kKlzMoQSFEzbxlKRQmQT60QeVqvTWrs40Q4XQnTYnlkcM/WfGhZ3cNcM0pU80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787352226; c=relaxed/simple;
	bh=9elKwhtE6VazgkBuSSQaKpriWGY0/zkjP48HGZeelq0=;
	h=Date:To:From:Subject:Message-Id; b=hqg5HC6VuEMvvoZsoyOPUOVZnejcVBteQJLFcGZ6A9K6baOTqlLCESlWjKW91C7LO0G1oyLROWFyCyccjDhFQte3XKX2LuvbCfnuIM4MaITgkXF+QzjQieufc8Cfv3vJtZ4oaslp64ZijODwGitLMS/ES8IScSqoRb0OSn9f3MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xg5XFGyc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xg5XFGyc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DCE51F000E9;
	Fri, 21 Aug 2026 22:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787352225;
	bh=UTNCbly82S3Jq3qr4I8TNrnKg13DnJhYSfXjVOvb8Bs=;
	h=Date:To:From:Subject;
	b=Xg5XFGycZJlA4QWj66svlWWF2RhBWa9e+wBONYJyxvkbmrDBS8zfdGj/SUsCEyRkY
	 zyACXmbEpdsW5PZRxg7rNwwNSNkigxPs1F7OnaOv9jvneTVVQ4PXKMEonau0fX5dFW
	 mMqt0SA2ajvLG6FcqvfoSlbaTDBmVtBxwlbXO1kU=
Date: Fri, 21 Aug 2026 15:43:44 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-clarify-comments-on-mas_nomem.patch added to mm-unstable branch
Message-Id: <20260821224345.4DCE51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: clarify comments on mas_nomem()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-clarify-comments-on-mas_nomem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-clarify-comments-on-mas_nomem.patch

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
Subject: maple_tree: clarify comments on mas_nomem()
Date: Fri, 21 Aug 2026 15:26:15 -0400

When an allocation completely fails, the return is false.  If the
allocation succeeds or partially succeeds, return true to indicate a retry
of the operation.  Note that since the lock may have been dropped, the
operation is retried from the start - including potentially allocating
more memory.

Link: https://lore.kernel.org/20260821192627.4085470-8-liam@infradead.org
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

 lib/maple_tree.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-clarify-comments-on-mas_nomem
+++ a/lib/maple_tree.c
@@ -5677,10 +5677,11 @@ EXPORT_SYMBOL_GPL(mas_erase);
 
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
@@ -5696,6 +5697,10 @@ bool mas_nomem(struct ma_state *mas, gfp
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
maple_tree-avoid-mas_erase-and-mtree_erase-failures.patch
maple_tree-document-erase-and-allocations-better.patch
maple_tree-change-two-gfp-flags-in-tests.patch
maple_tree-fix-argument-name-in-header.patch
maple_tree-avoid-extra-gap-calculation.patch
maple_tree-add-helper-mas_make_walkable.patch

