Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917D913A26F
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854716; cv=none; b=ThwQDrUyWSQple2MtQffZS35lYyAvrxvyLHOxIkwlgBb+k2Qb9OZP7lIVo32cMWFvaG8mThfwg0Rl/4J6SZ+3oHqiCd0p4oeY3y8q6K1TyeZm/CNqbMQtvG1IDaT2b//llFErOz0fSvZx/huTWfE3D8wcpnnG5Omqr0CeE+g8WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854716; c=relaxed/simple;
	bh=uHD9b4DpbbiCm0GllLMMlKckbkUProDdcE4Oyjv7f/8=;
	h=Date:To:From:Subject:Message-Id; b=h14ylh4BJ40k8a0tpYk2utUpZTTwINqrEza9mD+JSelgTYp2uWqbrO/PHH16d0T7cDs/W5KZIxQ/8KzsIxbDZ8H/eF8d9SALkn1F5XDK66WVZfTuRSKagsGehCEoSDMA4BUydG3Z4BCeg5vx3sdNhxS6lX4sLK7M4SxDSOIBkkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KUD4LHX1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KUD4LHX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0755AC4CED1;
	Wed,  6 Nov 2024 00:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854716;
	bh=uHD9b4DpbbiCm0GllLMMlKckbkUProDdcE4Oyjv7f/8=;
	h=Date:To:From:Subject:From;
	b=KUD4LHX1e7xe3LDOz0f6RSQ0izJhp7JZVuX0G7LGWZsM17zCHE9SD6QA90jgZoDwf
	 aWElZ3nrOWr/Ae6Q9ItYfiR7wtxN5Z7t2k/3MvTQ5M/8la2XmsUnYMBnCMt5w+R7ke
	 LligvdxfDS2fEH/QT5ieSjKJem/0Lrgwe+HGmdjA=
Date: Tue, 05 Nov 2024 16:58:35 -0800
To: mm-commits@vger.kernel.org,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-memset-maple_big_node-as-a-whole.patch removed from -mm tree
Message-Id: <20241106005836.0755AC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: memset maple_big_node as a whole
has been removed from the -mm tree.  Its filename was
     maple_tree-memset-maple_big_node-as-a-whole.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: memset maple_big_node as a whole
Date: Sun, 8 Sep 2024 14:05:54 +0000

In mast_fill_bnode(), we first clear some fields of maple_big_node and set
the 'type' unconditionally before return.  This means we won't leverage
any information in maple_big_node and it is safe to clear the whole
structure.

In maple_big_node, we define slot and padding/gap in a union.  And based
on current definition of MAPLE_BIG_NODE_SLOTS/GAPS, padding is always less
than slot and part of the gap is overlapped by slot.

For example on 64bit system:

  MAPLE_BIG_NODE_SLOT is 34
  MAPLE_BIG_NODE_GAP  is 21

With this knowledge, current code may clear some space by twice. And
this could be avoid by clearing the structure as a whole.

Link: https://lkml.kernel.org/r/20240908140554.20378-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/lib/maple_tree.c~maple_tree-memset-maple_big_node-as-a-whole
+++ a/lib/maple_tree.c
@@ -3157,10 +3157,7 @@ static inline void mast_fill_bnode(struc
 	bool cp = true;
 	unsigned char split;
 
-	memset(mast->bn->gap, 0, sizeof(unsigned long) * ARRAY_SIZE(mast->bn->gap));
-	memset(mast->bn->slot, 0, sizeof(unsigned long) * ARRAY_SIZE(mast->bn->slot));
-	memset(mast->bn->pivot, 0, sizeof(unsigned long) * ARRAY_SIZE(mast->bn->pivot));
-	mast->bn->b_end = 0;
+	memset(mast->bn, 0, sizeof(struct maple_big_node));
 
 	if (mte_is_root(mas->node)) {
 		cp = false;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mlock-set-the-correct-prev-on-failure.patch
maple_tree-print-empty-for-an-empty-tree-on-mt_dump.patch
maple_tree-the-return-value-of-mas_root_expand-is-not-used.patch
maple_tree-not-necessary-to-check-index-last-again.patch
maple_tree-refine-mas_store_root-on-storing-null.patch
maple_tree-add-a-test-checking-storing-null.patch

