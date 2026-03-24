Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940C93612E7
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388487; cv=none; b=Ux7rpy+zc4y8OPi83SU0zO2UO7Wlo75tjCI/uq4BD7oI9JKtmQ2Y5a/m2la7o1jnFEdjY9rPc+1XJ6Q8RKAG2NwLyIocfItj250LAbkVxifIT3HFQBnuggUYSAnL7dmYgcZyaMdASFjqiOl0AA5ElF8w7WaaHAq/eWPkhUj/VRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388487; c=relaxed/simple;
	bh=F96NROqjf22BFVxuqVNCVlq+xjlqEZhHPWTTkJD1Xq8=;
	h=Date:To:From:Subject:Message-Id; b=LwKZvo33mMzBMbmHQi6TApLjPnizQ+zabq0fYEzQ/c4E3UCXPygLgJA2u+l29JIDH0xoDJejR0vP8aOZPLBUc2LLtQzKunBojxbo+jpuN2vn96SHTqeqGvD75c+OHNGxoRJQAKAhhsHC+5azs0sR2K1U9GOnMJLwn7d+cyjpUiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZVi1O92a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZVi1O92a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E87BC19424;
	Tue, 24 Mar 2026 21:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388487;
	bh=F96NROqjf22BFVxuqVNCVlq+xjlqEZhHPWTTkJD1Xq8=;
	h=Date:To:From:Subject:From;
	b=ZVi1O92a9Qg5b7vNyx2tYto6BsZTwIlfa3xW7Mz0vMBHXtDs7sA1AqlwKJiDmXlKY
	 XOTGEfBx+NY7o7Gs5n/b5TQTDcTpPKQfiwr/Tkx+x56wt9voRosRFQ1ZvuLrBK1ufg
	 ypVMBABquCAhotPICjewuEzG7sMvEr10Cs57EUI8=
Date: Tue, 24 Mar 2026 14:41:26 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,sidhartha.kumar@oracle.com,lists@nerdbynature.de,kuninori.morimoto.gx@renesas.com,geert@linux-m68k.org,arnd@arndb.de,andrewjballance@gmail.com,aliceryhl@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-extract-use-of-big-node-from-mas_wr_spanning_store.patch removed from -mm tree
Message-Id: <20260324214127.4E87BC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: extract use of big node from mas_wr_spanning_store()
has been removed from the -mm tree.  Its filename was
     maple_tree-extract-use-of-big-node-from-mas_wr_spanning_store.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: extract use of big node from mas_wr_spanning_store()
Date: Fri, 30 Jan 2026 15:59:08 -0500

Isolate big node to use in its own function.

No functional changes intended.

Link: https://lkml.kernel.org/r/20260130205935.2559335-4-Liam.Howlett@oracle.com
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

 lib/maple_tree.c |   44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

--- a/lib/maple_tree.c~maple_tree-extract-use-of-big-node-from-mas_wr_spanning_store
+++ a/lib/maple_tree.c
@@ -2748,6 +2748,30 @@ static void mas_spanning_rebalance(struc
 	mas_spanning_rebalance_loop(mas, mast, count);
 }
 
+
+static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
+		struct maple_subtree_state *mast, unsigned char height,
+		struct ma_wr_state *l_wr_mas)
+{
+	struct maple_big_node b_node;
+
+	memset(&b_node, 0, sizeof(struct maple_big_node));
+	/* Copy l_mas and store the value in b_node. */
+	mas_store_b_node(l_wr_mas, &b_node, mast->orig_l->end);
+	/* Copy r_mas into b_node if there is anything to copy. */
+	if (mast->orig_r->max > mast->orig_r->last)
+		mas_mab_cp(mast->orig_r, mast->orig_r->offset,
+			   mast->orig_r->end, &b_node, b_node.b_end + 1);
+	else
+		b_node.b_end++;
+
+	/* Stop spanning searches by searching for just index. */
+	mast->orig_l->index = mast->orig_l->last = mas->index;
+
+	mast->bn = &b_node;
+	/* Combine l_mas and r_mas and split them up evenly again. */
+	return mas_spanning_rebalance(mas, mast, height);
+}
 /*
  * mas_rebalance() - Rebalance a given node.
  * @mas: The maple state
@@ -3400,10 +3424,9 @@ done:
  * span.
  * @wr_mas: The maple write state
  */
-static noinline void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
+static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 {
 	struct maple_subtree_state mast;
-	struct maple_big_node b_node;
 	struct ma_state *mas;
 	unsigned char height;
 
@@ -3467,24 +3490,9 @@ static noinline void mas_wr_spanning_sto
 		return mas_new_root(mas, wr_mas->entry);
 	}
 
-	memset(&b_node, 0, sizeof(struct maple_big_node));
-	/* Copy l_mas and store the value in b_node. */
-	mas_store_b_node(&l_wr_mas, &b_node, l_mas.end);
-	/* Copy r_mas into b_node if there is anything to copy. */
-	if (r_mas.max > r_mas.last)
-		mas_mab_cp(&r_mas, r_mas.offset, r_mas.end,
-			   &b_node, b_node.b_end + 1);
-	else
-		b_node.b_end++;
-
-	/* Stop spanning searches by searching for just index. */
-	l_mas.index = l_mas.last = mas->index;
-
-	mast.bn = &b_node;
 	mast.orig_l = &l_mas;
 	mast.orig_r = &r_mas;
-	/* Combine l_mas and r_mas and split them up evenly again. */
-	return mas_spanning_rebalance(mas, &mast, height + 1);
+	mas_wr_spanning_rebalance(mas, &mast, height + 1, &l_wr_mas);
 }
 
 /*
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


