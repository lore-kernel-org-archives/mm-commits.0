Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BB937DEBA
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622975; cv=none; b=KLF+FiI9EdCrWV2Zm32bCjfdnMQsIAyFIn+5do1jJE5sXZaWvbq4Z/SffF9CusZ4/+agOOqDvmqZ1mJEW5omXhxkLgAt5HhlY20scQUKWz6wD0DGRen4YkODB9aY8syB024LM76fKO9VabtTiRJjRXS8djiFBwe05+pz/C+sFLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622975; c=relaxed/simple;
	bh=WuZ65EGJGElecUqabl6lW/ldLMe8xHO3z8yYtuPtkLc=;
	h=Date:To:From:Subject:Message-Id; b=BZY1voZGAkjlxCLg2mZaSP8x5YGaJEw3dapDOYN9uu/D26TdrcOHEmKIbWlJbeo/ZQE1pB7sgdhnGslzX3P9q2ZyTGy50+PK9tkMoXMaKYK13m+Vt0zVh+I1EJZIK1I7YGz0d/A9ct9OM6sGhr+RLYvm/NnZuABybeePPg18ZjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PkAQhO28; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PkAQhO28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0A81F000E9;
	Tue, 25 Aug 2026 01:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622974;
	bh=6xsAKILihcuRgOM5IXGcusuDlBOEH6kZZ9fqULLocTI=;
	h=Date:To:From:Subject;
	b=PkAQhO281vfdwODPU2NJy9SLIQJrzE5g5d3ucR2Gd9NVYia0WZNxsMHXBmt4OrOOK
	 SZzdBzTBepGnFumffRLIZm8S4aNBqvUqUJZhvbP7ZHkJKd+GdRk6JUt/GVPSNabMO4
	 QemebgeBWkmTgvWlAWZoglOp8e7vwLVrMw57QJE0=
Date: Mon, 24 Aug 2026 18:56:13 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,leitao@debian.org,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-optimise-mas_wr_node_store-when-not-in-rcu-mode.patch removed from -mm tree
Message-Id: <20260825015614.3C0A81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: optimise mas_wr_node_store() when not in rcu mode
has been removed from the -mm tree.  Its filename was
     maple_tree-optimise-mas_wr_node_store-when-not-in-rcu-mode.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: optimise mas_wr_node_store() when not in rcu mode
Date: Fri, 21 Aug 2026 15:26:17 -0400

Clearing the entire node on the stack is unnecessary since most of the
node will be overwritten anyways.  Just clear what isn't used after the
data is in place.

Benchmarking shows a speedup of 0.67% on a height 4 tree with 2048
entries.

Link: https://lore.kernel.org/20260821192627.4085470-10-liam@infradead.org
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


