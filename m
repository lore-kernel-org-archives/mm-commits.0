Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B022878F26
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388512; cv=none; b=mfTHDltpev5r1dN1ktcA0RpM45RSFA/eV61/irZB8EH8d+w8VX8G01akwx4wsRFV0YB3hPEe4cbldoxBlgjNCab7NJQx0LWOBegXjAecCT4SkFAFbt7146LBaU1FQhNwLfC6glyrZqOFE6oknSNGbc0YuJoR6k+RtHPx+Q0mCVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388512; c=relaxed/simple;
	bh=FNCrtCYtzOyiOQVjbS3p3bhRJsj2q2NQ+7ToRzHte3I=;
	h=Date:To:From:Subject:Message-Id; b=JZXFqz2CUr4N9V9D0NlrEA52+EGBW4DR+EyF6n+3m4TUhZVYJIV7FzhVsoiaF4e7ByKmr/P8aISEOpPQ80xmY98HxUjA8SxkehfCQ6XO7ivtBLviG53r2nfF9sSUoU1Hm/u0I+FcDiNhAJRrcQ2g3+osp6y6/W5eybHfGBQZ0v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PRpmqXWH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PRpmqXWH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8882BC2BC9E;
	Tue, 24 Mar 2026 21:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388512;
	bh=FNCrtCYtzOyiOQVjbS3p3bhRJsj2q2NQ+7ToRzHte3I=;
	h=Date:To:From:Subject:From;
	b=PRpmqXWHJ8wIUE6XiinWbcvjSHGbtG6zthVxB0gLAzFlsdi8nKDx2iumoviDmbJzw
	 L54x01wAyMWQe5GFaACiwGhvdoEwtXpcHZIdum5j2lq4l3lcT7qxTnTFnzE+vnanDf
	 CU4jjWlNGFnfYaiekE3AmSk+y69dB5R+Do9qQN3U=
Date: Tue, 24 Mar 2026 14:41:52 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,sidhartha.kumar@oracle.com,lists@nerdbynature.de,kuninori.morimoto.gx@renesas.com,geert@linux-m68k.org,arnd@arndb.de,andrewjballance@gmail.com,aliceryhl@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-inline-mas_wr_spanning_rebalance.patch removed from -mm tree
Message-Id: <20260324214152.8882BC2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: inline mas_wr_spanning_rebalance()
has been removed from the -mm tree.  Its filename was
     maple_tree-inline-mas_wr_spanning_rebalance.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: inline mas_wr_spanning_rebalance()
Date: Fri, 30 Jan 2026 15:59:23 -0500

Now that the spanning rebalance is small, fully inline it in
mas_wr_spanning_store().

No functional change.

Link: https://lkml.kernel.org/r/20260130205935.2559335-19-Liam.Howlett@oracle.com
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

 lib/maple_tree.c |   38 +++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 23 deletions(-)

--- a/lib/maple_tree.c~maple_tree-inline-mas_wr_spanning_rebalance
+++ a/lib/maple_tree.c
@@ -3407,28 +3407,6 @@ static bool spanning_ascend(struct maple
 	return true;
 }
 
-static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
-		struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas)
-{
-
-	struct maple_enode *old_enode;
-	struct maple_copy cp;
-	struct ma_state sib;
-
-	cp_leaf_init(&cp, mas, l_wr_mas, r_wr_mas);
-	do {
-		spanning_data(&cp, l_wr_mas, r_wr_mas, &sib);
-		multi_src_setup(&cp, l_wr_mas, r_wr_mas, &sib);
-		dst_setup(&cp, mas, l_wr_mas->type);
-		cp_data_write(&cp, mas);
-	} while (spanning_ascend(&cp, mas, l_wr_mas, r_wr_mas, &sib));
-
-	old_enode = mas->node;
-	mas->node = mt_slot_locked(mas->tree, cp.slot, 0);
-	mas_wmb_replace(mas, old_enode, cp.height);
-	mtree_range_walk(mas);
-}
-
 /*
  * mas_rebalance() - Rebalance a given node.
  * @mas: The maple state
@@ -4085,7 +4063,10 @@ done:
  */
 static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 {
+	struct maple_enode *old_enode;
+	struct maple_copy cp;
 	struct ma_state *mas;
+	struct ma_state sib;
 
 	/* Left and Right side of spanning store */
 	MA_STATE(r_mas, NULL, 0, 0);
@@ -4142,7 +4123,18 @@ static void mas_wr_spanning_store(struct
 		return mas_new_root(mas, wr_mas->entry);
 	}
 
-	mas_wr_spanning_rebalance(mas, wr_mas, &r_wr_mas);
+	cp_leaf_init(&cp, mas, wr_mas, &r_wr_mas);
+	do {
+		spanning_data(&cp, wr_mas, &r_wr_mas, &sib);
+		multi_src_setup(&cp, wr_mas, &r_wr_mas, &sib);
+		dst_setup(&cp, mas, wr_mas->type);
+		cp_data_write(&cp, mas);
+	} while (spanning_ascend(&cp, mas, wr_mas, &r_wr_mas, &sib));
+
+	old_enode = mas->node;
+	mas->node = mt_slot_locked(mas->tree, cp.slot, 0);
+	mas_wmb_replace(mas, old_enode, cp.height);
+	mtree_range_walk(mas);
 }
 
 /*
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


