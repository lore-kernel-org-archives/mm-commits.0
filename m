Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AAF3D9DA6
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 22:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787350912; cv=none; b=U1cNBPS3TT6bmoD25TWWPoG5M8vngHLDH6GRIl4JnjpXcO9ZBwLp26Ne6js/OvocXwhuIaFRaoPSUDkAiFHEXcc6VvlwHMN0sjhfDBGVlIXoCY2vUoMmXlVAkcABSX4/6/JOZjC1XJW4RzJTevgu1/FSjZom4nYGOajPuAkSgMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787350912; c=relaxed/simple;
	bh=bep0gg/Cr0LTX/fuDKl2tTSCib2EjCrbEc9i/gCXraE=;
	h=Date:To:From:Subject:Message-Id; b=twiC/sAeDyEFE/U4BOWOcTyKxd7G0BWxPlWygZHCIjvLZyd6F44lpK3CZC2Do8V8wRyKwC+/V6sN+FJXS+dcwf93C3V0M8HJbeGo7YkOdyrvQyPEwW0CvMNE5s6ebwvGiAIuk+bpXK42KmHLdHJw1LBgHH0VXKM0DDiKyfAj6G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iuhO+O+J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iuhO+O+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FAD61F00A3A;
	Fri, 21 Aug 2026 22:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787350910;
	bh=M47jJYVu7q0Zg8g/Kk3ed3I0XYtH63SQniPj46RUhbM=;
	h=Date:To:From:Subject;
	b=iuhO+O+J/fObZ/Rj1Kmv09EA4fCE6iwrYqjaiu3i7ODsTQFCun2VUUNHVugbC8hCN
	 hfzN+CGLbjXCtm75Gmm3vx0LgBC5f+qlUTHfziCgbMKKHbgJM0Tiv3R6ttT2yHg5+f
	 m6j6Vnj5lR5g637vUidH9EzVpTGLMPg9qxHB7TqA=
Date: Fri, 21 Aug 2026 15:21:50 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] maple_tree-micro-optimisation-of-mas_wr_store_type.patch removed from -mm tree
Message-Id: <20260821222150.8FAD61F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: micro optimisation of mas_wr_store_type()
has been removed from the -mm tree.  Its filename was
     maple_tree-micro-optimisation-of-mas_wr_store_type.patch

This patch was dropped because an updated version will be issued

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

maple_tree-add-bulk-parent-set-helper.patch
maple_tree-catch-race-in-mas_alloc_cyclic.patch
maple_tree-document-that-erase-may-use-gfp_kernel-for-allocations.patch
maple_tree-warn_on_once-when-allocations-fail.patch
maple_tree-document-erase-and-allocations-better.patch
maple_tree-change-two-gfp-flags-in-tests.patch
maple_tree-fix-argument-name-in-header.patch
maple_tree-avoid-extra-gap-calculation.patch
maple_tree-add-helper-mas_make_walkable.patch

