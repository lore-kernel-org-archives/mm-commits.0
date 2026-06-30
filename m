Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29630328610
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 23:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782860829; cv=none; b=h5XfXp6vPVTsB0Tc09+hMx/q62rXLFIymcZ814L2lXj1h8Ww4/TbwxnvdJrpb6cPbCigPDrghkodJHtgUPhiyH0epNEszbJXZQeuJCQYn2KP/9D++EhjI9TbRps7tyyxCMYvPQJ7rcM+9bHQinmPrEJ8cmxlHAsTrosmTOvoqMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782860829; c=relaxed/simple;
	bh=30SqU3mJnAPm7ap+1q+ciPd2GpCZ9xLHl6wPzKPHLJI=;
	h=Date:To:From:Subject:Message-Id; b=roxTHY3euhxr8rGBHx2IRKXB1SzsZ12SggYxniWglEOQWHh4WTW4yXOVw4qhf/hobu97D+gi1oPmFpGmjKsN3j7Z5GFb2rW+xRoS5HZ14lJEWegJSPq6q6XRNT4g+iksIZn0+JLQJdkUQ6wbUKSZ9Cyctb3fE484HUfLU+z5Gg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v7ac5h5L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v7ac5h5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19DD1F000E9;
	Tue, 30 Jun 2026 23:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782860827;
	bh=J0vrlyez2GW+tPHAXoVnsAwmubBkd/xGOKnW504XppY=;
	h=Date:To:From:Subject;
	b=v7ac5h5LprZD/DwZCaQx9deBVOkvl0SXYAEZ2drbRB2QWUh7A0Kg9tfMwE/87voQ2
	 68DRPDFp24efrSy19PVvB1Z/slNKV5RDFtKmV0djZx2z4W9Rlon3anU9N8GGUJdjtu
	 2l7hr1v6hljwp9D1rI0lYyvlW/RWdUpIVAeesrXA=
Date: Tue, 30 Jun 2026 16:07:07 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-micro-optimisation-of-mas_wr_store_type.patch added to mm-new branch
Message-Id: <20260630230707.B19DD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: micro optimisation of mas_wr_store_type()
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-micro-optimisation-of-mas_wr_store_type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-micro-optimisation-of-mas_wr_store_type.patch

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
Subject: maple_tree: micro optimisation of mas_wr_store_type()
Date: Tue, 30 Jun 2026 15:08:34 -0400

Use three new local booleans instead of reading other structures.  This
has shown an increase of 0.62% on a 2048 entry tree of height 4.

Link: https://lore.kernel.org/20260630190843.3563858-11-liam@infradead.org
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

 lib/maple_tree.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-micro-optimisation-of-mas_wr_store_type
+++ a/lib/maple_tree.c
@@ -3736,6 +3736,9 @@ static inline enum store_type mas_wr_sto
 {
 	struct ma_state *mas = wr_mas->mas;
 	unsigned char new_end;
+	bool appending;
+	bool one_slot;
+	bool in_rcu;
 
 	if (unlikely(mas_is_none(mas) || mas_is_ptr(mas)))
 		return wr_store_root;
@@ -3755,21 +3758,30 @@ static inline enum store_type mas_wr_sto
 		return wr_new_root;
 
 	new_end = mas_wr_new_end(wr_mas);
+	in_rcu = mt_in_rcu(mas->tree);
+	appending = mas->offset == mas->end;
+	one_slot = wr_mas->offset_end - mas->offset == 1;
+
 	/* Potential spanning rebalance collapsing a node */
 	if (new_end < mt_min_slots[wr_mas->type]) {
 		if (!mte_is_root(mas->node))
 			return  wr_rebalance;
+		if (!in_rcu) {
+			if (appending)
+				return wr_append;
+			else if (mas->end == new_end && one_slot)
+				return wr_slot_store;
+		}
 		return wr_node_store;
 	}
 
 	if (new_end >= mt_slots[wr_mas->type])
 		return wr_split_store;
 
-	if (!mt_in_rcu(mas->tree) && (mas->offset == mas->end))
+	if (!in_rcu && appending)
 		return wr_append;
 
-	if ((new_end == mas->end) && (!mt_in_rcu(mas->tree) ||
-		(wr_mas->offset_end - mas->offset == 1)))
+	if (new_end == mas->end && (!in_rcu || one_slot))
 		return wr_slot_store;
 
 	return wr_node_store;
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

