Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C124F40B398
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 22:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787350911; cv=none; b=KWN/iCJAEOcdK5rHedOqlnGZzypOpSnAC/zbLeUK9FWNxGM8tj+nE8wdQQ/QjRGvvF0SgrbfXw07j9z+jOjwbZlMhZUi+BuDAMMMyXn4c+Mzt/SOuvJlMMXrEmKkMN+PUhUI8/3Q7zh391oZaIhd1B9dUNqgH04+JKTP39NRJfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787350911; c=relaxed/simple;
	bh=0xwUkT2XpVurGKUBk37QLvdsKm5CPyV7S6R7+1JZcR0=;
	h=Date:To:From:Subject:Message-Id; b=Jxwuk8xQ1ZCVczMW2AfxdfulPFW8m9btyd7v4FQBQy9yl7uRO9kUycHZ/Bjt2jlyo+5qHwDAK6i3iUR6TIzqFTPwk8XPyU1pS3pHntHKQ4ZQXDCrFf27qMmdJljK7Fn87ArtULttySjk0XkRm5uRHAgCl1jnF2i1aQ3GxHhikhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BtBr8DCR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BtBr8DCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CDB1F000E9;
	Fri, 21 Aug 2026 22:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787350909;
	bh=R3fzTSYlaCvmy9hoCF8DQP0AjNjBBnDa6y7jQDNWD1w=;
	h=Date:To:From:Subject;
	b=BtBr8DCRsKZYnnEWwWeftlY2iqXzZaPuLxE455OdQuWdC2XBXPllSmWVTv/PtaVJE
	 vAU9jxzII35cRfbIEoe4sEiP3KXsgu1cy/brjKyvDzjWZgJI45A/nhBnDmLgBhQ1nq
	 cgAxGjSMLe7IS8vY766YKcy3L4zgwbiFxVnm9kDY=
Date: Fri, 21 Aug 2026 15:21:48 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] maple_tree-optimise-mas_wr_node_store-when-not-in-rcu-mode.patch removed from -mm tree
Message-Id: <20260821222149.55CDB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: optimise mas_wr_node_store() when not in rcu mode
has been removed from the -mm tree.  Its filename was
     maple_tree-optimise-mas_wr_node_store-when-not-in-rcu-mode.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: optimise mas_wr_node_store() when not in rcu mode
Date: Tue, 30 Jun 2026 15:08:33 -0400

Clearing the entire node on the stack is unnecessary since most of the
node will be overwritten anyways.  Just clear what isn't used after the
data is in place.

Benchmarking shows a speedup of 0.67% on a height 4 tree with 2048
entries.

Link: https://lore.kernel.org/20260630190843.3563858-10-liam@infradead.org
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

 lib/maple_tree.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-optimise-mas_wr_node_store-when-not-in-rcu-mode
+++ a/lib/maple_tree.c
@@ -3187,7 +3187,7 @@ static void mas_wr_spanning_store(struct
 static inline void mas_wr_node_store(struct ma_wr_state *wr_mas)
 {
 	unsigned char dst_offset, offset_end;
-	unsigned char copy_size, node_pivots;
+	unsigned char copy_size, node_pivots, node_slots;
 	struct maple_node reuse, *newnode;
 	unsigned long *dst_pivots;
 	void __rcu **dst_slots;
@@ -3200,6 +3200,7 @@ static inline void mas_wr_node_store(str
 	in_rcu = mt_in_rcu(mas->tree);
 	offset_end = wr_mas->offset_end;
 	node_pivots = mt_pivots[wr_mas->type];
+	node_slots = mt_slots[wr_mas->type];
 	/* Assume last adds an entry */
 	new_end = mas->end + 1 - offset_end + mas->offset;
 	if (mas->last == wr_mas->end_piv) {
@@ -3211,7 +3212,6 @@ static inline void mas_wr_node_store(str
 	if (in_rcu) {
 		newnode = mas_pop_node(mas);
 	} else {
-		memset(&reuse, 0, sizeof(struct maple_node));
 		newnode = &reuse;
 	}
 
@@ -3255,7 +3255,21 @@ static inline void mas_wr_node_store(str
 		dst_pivots[new_end] = mas->max;
 
 done:
-	mas_leaf_set_meta(newnode, maple_leaf_64, new_end);
+	if (!in_rcu && new_end + 2 < node_slots) {
+		unsigned char clear_from = new_end + 1;
+
+		/*
+		 * Note that the last slot is never cleared, since the metadata
+		 * will be stored there or it has a value.
+		 */
+		memset(dst_slots + clear_from, 0,
+		       sizeof(void __rcu *) * (node_slots - clear_from));
+		if (clear_from < node_pivots)
+			memset(dst_pivots + clear_from, 0,
+			       sizeof(unsigned long) * (node_pivots - clear_from));
+	}
+
+	mas_leaf_set_meta(newnode, wr_mas->type, new_end);
 	if (in_rcu) {
 		struct maple_enode *old_enode = mas->node;
 
_

Patches currently in -mm which might be from liam@infradead.org are

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

