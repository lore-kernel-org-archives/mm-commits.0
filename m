Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC8D78F26
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388497; cv=none; b=buMYZ1/eZ3fyF7FvWSzJRHwmd7BWU2SY4DavP6FzGXwLRjMg7XF3oPmSVTEfuDR30N/kKd2Z+08aFG3agPdc02jmmWcqa536S2srIH1ebisovrAI8fZWX3E2Vsc8PCJRurBGVMYYpIVX6Ck4jZoRVHYjv07tsd1m3bkuph966B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388497; c=relaxed/simple;
	bh=/O9t5KacJr7CxqxeZUh4wRENRmjWcdSrKP1KuqrWbDY=;
	h=Date:To:From:Subject:Message-Id; b=sm7EfZvLOEFpxI41h3Q/VBBRxwFgrk+jKZtwhL0FkTXjjDL4PGfHzTsMScYzcMgmTxe4ic2OU+zUO6UdTj+xTyG86Tw0GypSudhAJBaKsnV8b1m3WE5ZdQJXzYC/F6zJGKoQ4r2zMYSmtHfjP4IHOfUopv6JbdJVFgMFh0dPSao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YNCwklTT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YNCwklTT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5802BC19424;
	Tue, 24 Mar 2026 21:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388497;
	bh=/O9t5KacJr7CxqxeZUh4wRENRmjWcdSrKP1KuqrWbDY=;
	h=Date:To:From:Subject:From;
	b=YNCwklTTA+IDIcOZe6SyfyjbRlhOBqIsxdJoUfpyrcHvD5pjTnxzGVVkDQjZX9eSP
	 J+tPeYVGRQbmWRpU0qxXR3WzidCYmc9hbwzmerSFtIqNFeTXdcVKP+Wq9kGs8/yQjW
	 JERm7Vdn62QpdjnOk22BQ+jx6h7zInGGoYp0T1oY=
Date: Tue, 24 Mar 2026 14:41:36 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,sidhartha.kumar@oracle.com,lists@nerdbynature.de,kuninori.morimoto.gx@renesas.com,geert@linux-m68k.org,arnd@arndb.de,andrewjballance@gmail.com,aliceryhl@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-move-maple_subtree_state-from-mas_wr_spanning_store-to-mas_wr_spanning_rebalance.patch removed from -mm tree
Message-Id: <20260324214137.5802BC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: move maple_subtree_state from mas_wr_spanning_store to mas_wr_spanning_rebalance
has been removed from the -mm tree.  Its filename was
     maple_tree-move-maple_subtree_state-from-mas_wr_spanning_store-to-mas_wr_spanning_rebalance.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: move maple_subtree_state from mas_wr_spanning_store to mas_wr_spanning_rebalance
Date: Fri, 30 Jan 2026 15:59:14 -0500

Moving the maple_subtree_state is necessary for future cleanups and is
only set up in mas_wr_spanning_rebalance() but never used.

Link: https://lkml.kernel.org/r/20260130205935.2559335-10-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

--- a/lib/maple_tree.c~maple_tree-move-maple_subtree_state-from-mas_wr_spanning_store-to-mas_wr_spanning_rebalance
+++ a/lib/maple_tree.c
@@ -2750,46 +2750,52 @@ static void mas_spanning_rebalance(struc
 
 
 static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
-		struct maple_subtree_state *mast, struct ma_wr_state *wr_mas)
+		struct ma_wr_state *wr_mas, struct ma_wr_state *r_wr_mas)
 {
+	struct maple_subtree_state mast;
 	struct maple_big_node b_node;
 	unsigned char height;
 	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
 	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
 	MA_STATE(m_mas, mas->tree, mas->index, mas->index);
+	MA_STATE(mast_l_mas, NULL, 0, 0);
+
 
+	mast_l_mas = *mas;
+	mast.orig_l = &mast_l_mas;
+	mast.orig_r = r_wr_mas->mas;
 	memset(&b_node, 0, sizeof(struct maple_big_node));
 	/* Copy l_mas and store the value in b_node. */
-	mas_store_b_node(wr_mas, &b_node, mast->orig_l->end);
+	mas_store_b_node(wr_mas, &b_node, mast.orig_l->end);
 	/* Copy r_mas into b_node if there is anything to copy. */
-	if (mast->orig_r->max > mast->orig_r->last)
-		mas_mab_cp(mast->orig_r, mast->orig_r->offset,
-			   mast->orig_r->end, &b_node, b_node.b_end + 1);
+	if (mast.orig_r->max > mast.orig_r->last)
+		mas_mab_cp(mast.orig_r, mast.orig_r->offset,
+			   mast.orig_r->end, &b_node, b_node.b_end + 1);
 	else
 		b_node.b_end++;
 
 	/* Stop spanning searches by searching for just index. */
-	mast->orig_l->last = mas->index;
+	mast.orig_l->last = mas->index;
 
-	mast->bn = &b_node;
+	mast.bn = &b_node;
 	/* Combine l_mas and r_mas and split them up evenly again. */
 
 	/*
 	 * The tree needs to be rebalanced and leaves need to be kept at the same level.
 	 * Rebalancing is done by use of the ``struct maple_topiary``.
 	 */
-	mast->l = &l_mas;
-	mast->m = &m_mas;
-	mast->r = &r_mas;
+	mast.l = &l_mas;
+	mast.m = &m_mas;
+	mast.r = &r_mas;
 	l_mas.status = r_mas.status = m_mas.status = ma_none;
 
 	/* Check if this is not root and has sufficient data.  */
-	if (((mast->orig_l->min != 0) || (mast->orig_r->max != ULONG_MAX)) &&
-	    unlikely(mast->bn->b_end <= mt_min_slots[mast->bn->type]))
-		mast_spanning_rebalance(mast);
+	if (((mast.orig_l->min != 0) || (mast.orig_r->max != ULONG_MAX)) &&
+	    unlikely(mast.bn->b_end <= mt_min_slots[mast.bn->type]))
+		mast_spanning_rebalance(&mast);
 
 	height = mas_mt_height(mas) + 1;
-	mas_spanning_rebalance_loop(mas, mast, height);
+	mas_spanning_rebalance_loop(mas, &mast, height);
 }
 /*
  * mas_rebalance() - Rebalance a given node.
@@ -3447,11 +3453,9 @@ done:
  */
 static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 {
-	struct maple_subtree_state mast;
 	struct ma_state *mas;
 
 	/* Left and Right side of spanning store */
-	MA_STATE(l_mas, NULL, 0, 0);
 	MA_STATE(r_mas, NULL, 0, 0);
 	MA_WR_STATE(r_wr_mas, &r_mas, wr_mas->entry);
 
@@ -3505,10 +3509,7 @@ static void mas_wr_spanning_store(struct
 		return mas_new_root(mas, wr_mas->entry);
 	}
 
-	l_mas = *mas;
-	mast.orig_l = &l_mas;
-	mast.orig_r = &r_mas;
-	mas_wr_spanning_rebalance(mas, &mast, wr_mas);
+	mas_wr_spanning_rebalance(mas, wr_mas, &r_wr_mas);
 }
 
 /*
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


