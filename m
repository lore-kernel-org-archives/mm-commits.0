Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D5D3890F8
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622989; cv=none; b=UxwP/rgSpYwx06A52aq5DU89uTqgm5BKq5sKiS3mamvNoXfW+cUDRNNsZD4peZf9FTgVOl/BXewr1Vfyva0I7JOnyNxnpz83oJHt2C8bg9hkN8usi9TtUFiKQCBsXdGn5RH+fqR7TyG2gns4E10JBtRYDw2ujfm33ibcZWmhAzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622989; c=relaxed/simple;
	bh=hbMD/Xvign3+SYjlmM+wpVwAazTowqPOsu92CEXNDZg=;
	h=Date:To:From:Subject:Message-Id; b=MBP828YqquyldLZIYCH2vMjkNzkdpbp5AKwHoboB2FlAIlcYTa+PA2e3KZWKIQD+4Epdon9F/oFuqHHVHHJa13Btu8z0iMvi5kkkXeASBlZCtYJ8fllfoux4sbtqdxiYv2Lu/aeEpxvB74GfaiD3ZMwY+2qkNlHLBebiLc47QAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=poghhXT2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="poghhXT2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB771F000E9;
	Tue, 25 Aug 2026 01:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622988;
	bh=Yy/+Exox1S6ZBqA1fObP553583o9tNQ+N8N2O3eKXig=;
	h=Date:To:From:Subject;
	b=poghhXT2L9aBUZ5KK+gMI2IAjeTy5jRdwneirhihTjiamLys9q3pyl/lxeqIA1wqw
	 3v301AtTzHecVuFv6h73xRid7IUk/lBmQK6X4FiwKOUIDAarpIBk1i0eh2VpIf+dvC
	 xZNWD0ccVWDcbfO3V9hTqNA+mBrUkNfk4ZdXGgss=
Date: Mon, 24 Aug 2026 18:56:27 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,leitao@debian.org,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-avoid-extra-gap-calculation.patch removed from -mm tree
Message-Id: <20260825015628.4CB771F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: avoid extra gap calculation
has been removed from the -mm tree.  Its filename was
     maple_tree-avoid-extra-gap-calculation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: avoid extra gap calculation
Date: Fri, 21 Aug 2026 15:26:26 -0400

Prior to ending the ascension loop of larger operations like split,
rebalance, and spanning store the gap in the node had been calculated. 
Once the node is inserted into the tree, the gap is recalculated in
mas_update_gap().  This can be avoided by creating a helper for
mas_update_gap() that accepts the known gap value, which reduces the
operations required for gap updating path.

Link: https://lore.kernel.org/20260821192627.4085470-19-liam@infradead.org
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

 lib/maple_tree.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/lib/maple_tree.c~maple_tree-avoid-extra-gap-calculation
+++ a/lib/maple_tree.c
@@ -1566,14 +1566,26 @@ ascend:
 	goto ascend;
 }
 
+static __always_inline void mas_update_gap_known(struct ma_state *mas,
+		unsigned long gap)
+{
+	unsigned char pslot;
+	unsigned long p_gap;
+
+	pslot = mte_parent_slot(mas->node);
+	p_gap = ma_gaps(mte_parent(mas->node),
+			mas_parent_type(mas, mas->node))[pslot];
+
+	if (p_gap != gap)
+		mas_parent_gap(mas, pslot, gap);
+}
+
 /*
  * mas_update_gap() - Update a nodes gaps and propagate up if necessary.
  * @mas: the maple state.
  */
 static inline void mas_update_gap(struct ma_state *mas)
 {
-	unsigned char pslot;
-	unsigned long p_gap;
 	unsigned long max_gap;
 
 	if (!mt_is_alloc(mas->tree))
@@ -1583,13 +1595,7 @@ static inline void mas_update_gap(struct
 		return;
 
 	max_gap = mas_max_gap(mas);
-
-	pslot = mte_parent_slot(mas->node);
-	p_gap = ma_gaps(mte_parent(mas->node),
-			mas_parent_type(mas, mas->node))[pslot];
-
-	if (p_gap != max_gap)
-		mas_parent_gap(mas, pslot, max_gap);
+	mas_update_gap_known(mas, max_gap);
 }
 
 /*
@@ -2137,8 +2143,8 @@ static inline void mas_wmb_replace(struc
 	mas->node = mt_slot_locked(mas->tree, cp->slot, 0);
 	/* Insert the new data in the tree */
 	mas_topiary_replace(mas, old_enode, cp->height);
-	if (!mte_is_leaf(mas->node))
-		mas_update_gap(mas);
+	if (mt_is_alloc(mas->tree) && !mte_is_root(mas->node))
+		mas_update_gap_known(mas, cp->gap[0]);
 
 	mtree_range_walk(mas);
 }
_

Patches currently in -mm which might be from liam@infradead.org are


