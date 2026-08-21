Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FC740B107
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 22:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787350923; cv=none; b=aHpDGfmvaVt520Q1R3SbYIn5ZUmqDP9bBijWK3gD7OOzFV6oqx6nKR8CANk99LmlIKyJQ+HdlaLV1/XQk73JXcLr6kqnbfbS6kgWcivoZZR+S/AFpVCjANsYyq+QnOyL8W4jkQ2/Ua5HiSZZwdr5wXLd+KA0UDyBnPqHPjyydvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787350923; c=relaxed/simple;
	bh=bWhDujMoOcVarkeZSZNUmWr5rcPtGwGiGZJTnzfskw0=;
	h=Date:To:From:Subject:Message-Id; b=sM43aG/P9WB3e0YCGApoGOJxZSf9O9CN2qtW3Tn22Oz+eHP31O5OS2BQB2+Lbe9UuMcU/NZhq7tPRGJLGSkg+BGwgNmTG3KKyMSerUywxaj5J1Amvzqoazyl315+v7QD0VRhHTutYZ7Q2EMSohJesfibE+xGjsDoPCXxxP+4fY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DW1xjz25; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DW1xjz25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79C11F00A3A;
	Fri, 21 Aug 2026 22:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787350921;
	bh=pqrcIAlwEcU/ucCj2K8Etidhr4zUK/phHjJiBcCo++g=;
	h=Date:To:From:Subject;
	b=DW1xjz25/Oyoq0+fWHF5pnJ3Tu6+wzzd5a8gLn/IQgRLJ6BrNSATecnaAS70vsKFR
	 f0pR8nvnZQxHgDXrlSveWaPAXdcOi2LT7E2FKt3txpSszDFyCcq8OTv++qsIPy9HHw
	 IdD6BDnT7MZKtkAL9FBc5l5EMwZLM9Kd2nzaGd4Q=
Date: Fri, 21 Aug 2026 15:22:01 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] maple_tree-add-helper-mas_make_walkable.patch removed from -mm tree
Message-Id: <20260821222201.C79C11F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: add helper mas_make_walkable()
has been removed from the -mm tree.  Its filename was
     maple_tree-add-helper-mas_make_walkable.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: add helper mas_make_walkable()
Date: Tue, 30 Jun 2026 15:08:43 -0400

A check in mas_walk() was incorrect and caused inefficient use of the
maple state.  The same issue existed in mas_erase(), but was left unfixed.
Making a helper function is the obvious answer.

Link: https://lore.kernel.org/20260630190843.3563858-20-liam@infradead.org
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

 lib/maple_tree.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/lib/maple_tree.c~maple_tree-add-helper-mas_make_walkable
+++ a/lib/maple_tree.c
@@ -261,6 +261,12 @@ static inline bool mas_is_underflow(stru
 	return mas->status == ma_underflow;
 }
 
+static inline void mas_make_walkable(struct ma_state *mas)
+{
+	if (!mas_is_active(mas) && !mas_is_start(mas))
+		mas->status = ma_start;
+}
+
 static __always_inline struct maple_node *mte_to_node(
 		const struct maple_enode *entry)
 {
@@ -4447,8 +4453,7 @@ void *mas_walk(struct ma_state *mas)
 	void *entry;
 
 	mas_may_init_lock_check(mas);
-	if (!mas_is_active(mas) && !mas_is_start(mas))
-		mas->status = ma_start;
+	mas_make_walkable(mas);
 retry:
 	entry = mas_state_walk(mas);
 	if (mas_is_start(mas)) {
@@ -5684,9 +5689,7 @@ void *mas_erase(struct ma_state *mas)
 	if (mt_external_lock(mas->tree))
 		might_alloc(GFP_KERNEL);
 
-	if (!mas_is_active(mas) || !mas_is_start(mas))
-		mas->status = ma_start;
-
+	mas_make_walkable(mas);
 write_retry:
 	entry = mas_state_walk(mas);
 	if (!entry)
_

Patches currently in -mm which might be from liam@infradead.org are


