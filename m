Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0405637C936
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622977; cv=none; b=iP9+E8BFGRYXQFOvJnQrm5qha0RX6SBIuevfVP8C8Gjsb3B7+yLeXQJBDytkrNlWZ1KqCWBA6XewFJYbEesKCZw3WqlBc7VKFuzydXAFUEK0o9Hm0bKBrPxJIqmKWAoBbOYBJu5yfgLqPY6L3oddH2WK/hb7YQJIkRz6xk9xfK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622977; c=relaxed/simple;
	bh=TaFpfAvX/9PAhLKMxPdEhVGwc6Q8C7IrllFXxskymmU=;
	h=Date:To:From:Subject:Message-Id; b=jIT6Mdk5Mbc86jk1TtMannw7CVmn8UJ0XXafb97kp4H4cVeNr3XhM2RbTnzPhFx2YwfG9L5wDcyOpkyOUQ2Ad5pnHSWY2RR4jiJ1Kq65ydRZJjofgqS1MaJKwPNFjfvo3zx4B4SIXPGoiCYdq6xxekcolRj/kwkeBCxDz+f8tC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H1QdlPoU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H1QdlPoU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBAEB1F000E9;
	Tue, 25 Aug 2026 01:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622975;
	bh=uyP5obIkuBtWqdebCMru8Z/AKjsLsSD2wXBfsQ4KhC4=;
	h=Date:To:From:Subject;
	b=H1QdlPoU3/3A9Ombn/QDlcaz1yYTqrBpQsOOMWsX6NE4kP11VZGB5Rx2VtEwbOJ8e
	 NrfMA8rSemVQtbq0G7yrclDtFplj150pT9UEZXv0qMKJrBcQ214PT4u26ACdh/SdVd
	 37zC607E7NdGdwNPU+zFELi27+DqHcHP1W77G++M=
Date: Mon, 24 Aug 2026 18:56:15 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,leitao@debian.org,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-micro-optimisation-of-mas_wr_store_type.patch removed from -mm tree
Message-Id: <20260825015615.CBAEB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: micro optimisation of mas_wr_store_type()
has been removed from the -mm tree.  Its filename was
     maple_tree-micro-optimisation-of-mas_wr_store_type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


