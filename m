Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8235E2F7EEE
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 23:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782860837; cv=none; b=mYEYTFLrel3ysMJgc5Ds0HDBliywLXth3tUpX6JM6eHThs2R9zXCDgFpkhm4NU3h9xkzLDG3hzJnibU0Rpx6KERfVPhjjDCiC32eofGXhwFkKVqnhKYr0QHbi0LPsXH7DBIfDeygPYgkGpXuqhKjaYspVTLyFq8B8vAeaq3W32E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782860837; c=relaxed/simple;
	bh=HW4P/YanU51krrae0gYPYJiP6XVnxG2rqZhSdK74zRM=;
	h=Date:To:From:Subject:Message-Id; b=DRgp4BNUe45PB7duv404FxXv4NZVYaPc8SzfoJ3bkN/XCPSabJMZyNaw9Lmxw7f5JQL3/TdZ4Y5aNbC9Vk5qgMXQLYuuTxjPzjw+W0/+IKzKDmevam8LuktaT92neC7jEgBQGyUM7y2VIiVbuBcI/ZOObSOV1/a5l+X8TidBPnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BwCURBED; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BwCURBED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269B91F000E9;
	Tue, 30 Jun 2026 23:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782860836;
	bh=MleSf6h2fNnqRBb9epws+EVSRVpBCYU/cU6Z7xN9G/M=;
	h=Date:To:From:Subject;
	b=BwCURBEDXIk+Ml1WzLLr0bxBzT/tzOKLsil3iRLXo1tPf/twDT48YzOeXhecfi1Wf
	 B74+p4SEP3TW4js4MEZr5m5lB2mLyx6a4zyUWqUoQr0Kaj4xPIp28T7YEWScP336Nh
	 OX/2sYkKXUR/SToAiyagWZkCMDb2vLAV/szsM388=
Date: Tue, 30 Jun 2026 16:07:15 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-warn_on_once-when-allocations-fail.patch added to mm-new branch
Message-Id: <20260630230716.269B91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: WARN_ON_ONCE when allocations fail
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-warn_on_once-when-allocations-fail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-warn_on_once-when-allocations-fail.patch

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
Subject: maple_tree: WARN_ON_ONCE when allocations fail
Date: Tue, 30 Jun 2026 15:08:38 -0400

Allocations should never fail in the circumstances that are expected to
occur.  Add checks in the code to ensure the circumstances are correctly
set up by the user and warn if they are not.

Also add a warning on failure to allocate, which should never happen.

Link: https://lore.kernel.org/20260630190843.3563858-15-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
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

 lib/maple_tree.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-warn_on_once-when-allocations-fail
+++ a/lib/maple_tree.c
@@ -5720,6 +5720,10 @@ bool mas_nomem(struct ma_state *mas, gfp
 	if (likely(mas->node != MA_ERROR(-ENOMEM)))
 		return false;
 
+	/* Allocations can fail, don't do this. */
+	WARN_ON_ONCE(!gfpflags_allow_blocking(gfp) &&
+		     mt_external_lock(mas->tree));
+
 	if (gfpflags_allow_blocking(gfp) && !mt_external_lock(mas->tree)) {
 		mtree_unlock(mas->tree);
 		mas_alloc_nodes(mas, gfp);
@@ -5730,9 +5734,12 @@ bool mas_nomem(struct ma_state *mas, gfp
 
 	/*
 	 * Return false on zero forward progress.  Partial allocations are kept
-	 * so the retry path will attempt to get the rest.
+	 * so the retry path will attempt to get the rest.  The failure should
+	 * not happen as we try our best to reclaim.  The user would need an
+	 * external lock with a non-blocking gfp in a low memory situation -
+	 * which would have triggered the first warning in this function.
 	 */
-	if (!mas->sheaf && !mas->alloc)
+	if (WARN_ON_ONCE(!mas->sheaf && !mas->alloc))
 		return false;
 
 	mas_reset(mas);
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

