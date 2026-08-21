Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1833B47E6
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 22:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787352233; cv=none; b=PmLAyBIFNCYMpb2Ugc2UrL83G2s5ZMpXHUEBdGMC/0AZLeoMphq6GhbY93gznyr07czKhAIRrGzCpTTXjwb5+OMkVKQ4MzHXoZ58/rm+xwjCFpJP0On8fBNza7EqyfTgZzwzE2pR6K8kP9iPNtairqE1GElLuFNup7t7PKMqhsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787352233; c=relaxed/simple;
	bh=zRtRvhTN+f1Pp23XzqfvNVs4JsvYYeXRuPP4ffUjPZc=;
	h=Date:To:From:Subject:Message-Id; b=geBN4NTNp0a4bSBq8icb98Vg8906wCk6JSywTA0iT4mEP7YPStag2Kp6Rl7PXkGqKd3VFceYi8RC5Uv6TrncHD6EcqklF1cbd6Wb/xhpBD8+RdtoGtjUV4CwIHMMCrRvSkzFdPtPA5OKiTmL8/amEh0NYWPbsgkDS0Ov4iMhRoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PJKYKnoe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PJKYKnoe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5591F000E9;
	Fri, 21 Aug 2026 22:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787352231;
	bh=o1bLjIqkGHQ+WmIUKoJLaw16hP6cOfbtS5Sz/QAGhdg=;
	h=Date:To:From:Subject;
	b=PJKYKnoeI3F6s2sJbJSb9asXYk0hR4kU4c2zCDljFiWLjweA2P+yW6/+s3/1BT1og
	 h1xuS0cvVPaiXEakdheqzUzVIAqMz7YmwlgdLe8u29bh1V1ki5jeaN/PgalqzdrALy
	 R4wiSxDBHWg2HphDKbE38cv2bJHO7eUqMhHKBogk=
Date: Fri, 21 Aug 2026 15:43:51 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-micro-optimisation-of-mas_wr_store_type.patch added to mm-unstable branch
Message-Id: <20260821224351.7E5591F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: micro optimisation of mas_wr_store_type()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-micro-optimisation-of-mas_wr_store_type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-micro-optimisation-of-mas_wr_store_type.patch

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
Subject: maple_tree: micro optimisation of mas_wr_store_type()
Date: Fri, 21 Aug 2026 15:26:18 -0400

Use three new local booleans instead of reading other structures.  This
has shown an increase of 0.62% on a 2048 entry tree of height 4.

Link: https://lore.kernel.org/20260821192627.4085470-11-liam@infradead.org
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

 lib/maple_tree.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-micro-optimisation-of-mas_wr_store_type
+++ a/lib/maple_tree.c
@@ -3737,6 +3737,9 @@ static inline enum store_type mas_wr_sto
 {
 	struct ma_state *mas = wr_mas->mas;
 	unsigned char new_end;
+	bool appending;
+	bool one_slot;
+	bool in_rcu;
 
 	if (unlikely(mas_is_none(mas) || mas_is_ptr(mas)))
 		return wr_store_root;
@@ -3756,21 +3759,30 @@ static inline enum store_type mas_wr_sto
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
maple_tree-avoid-mas_erase-and-mtree_erase-failures.patch
maple_tree-document-erase-and-allocations-better.patch
maple_tree-change-two-gfp-flags-in-tests.patch
maple_tree-fix-argument-name-in-header.patch
maple_tree-avoid-extra-gap-calculation.patch
maple_tree-add-helper-mas_make_walkable.patch

