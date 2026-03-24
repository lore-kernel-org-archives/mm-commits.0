Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B92C36074F
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388496; cv=none; b=Z/uc4cGSi+wgzaV3Y+aKog3zvG3623dstW1+I9CKbvYg6uAFJOzI5molmjgiILn1Ix0Qy/oUTa8LYDsX6padAihmBbFN6RYfV8dzkhomum7y6SY0IUOoRnOYI8fIWPkPaCrlZcyQgtSSHbOjf6dJc921QCy++u5cOnGGbzr0OsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388496; c=relaxed/simple;
	bh=VahGyD4VYEC3GLIkWAyJGH4MsiF+Or8zV16gp0Z2ugM=;
	h=Date:To:From:Subject:Message-Id; b=hZvS4uyVTkZ6varoL/GCcOe3xeWGVD7pXZYcPWijTwP/pgNBGYONOZB9qGpL8xpiJpch2YBu963bqN+Ry1Y6VZHvJDN1lPr5KM7Muah8YXgGcRJNTx/uIYEkNGAVbXeT2n2l6jVsYtVfoRNWlHOt78bfgMkikUP6ORIT6hJg26w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iqj7BFmy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iqj7BFmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A866EC2BC9E;
	Tue, 24 Mar 2026 21:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388495;
	bh=VahGyD4VYEC3GLIkWAyJGH4MsiF+Or8zV16gp0Z2ugM=;
	h=Date:To:From:Subject:From;
	b=iqj7BFmyIpWxqdE58vc6/H6KAhcQerUEzbd56VO9ZI3rDWPeYuhqkXA7PDub7DISi
	 GIFXOkPugKUSnltScCvYaoA2fw/M0zYK7S5rziZF0GNIF1+9ULGCQAkIwbZBSqmauT
	 eHnseBFsW3l+H5RKmwrXPEasvDLfgjQImz8Jgz+w=
Date: Tue, 24 Mar 2026 14:41:35 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,sidhartha.kumar@oracle.com,lists@nerdbynature.de,kuninori.morimoto.gx@renesas.com,geert@linux-m68k.org,arnd@arndb.de,andrewjballance@gmail.com,aliceryhl@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-dont-pass-through-height-in-mas_wr_spanning_store.patch removed from -mm tree
Message-Id: <20260324214135.A866EC2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: don't pass through height in mas_wr_spanning_store
has been removed from the -mm tree.  Its filename was
     maple_tree-dont-pass-through-height-in-mas_wr_spanning_store.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: don't pass through height in mas_wr_spanning_store
Date: Fri, 30 Jan 2026 15:59:13 -0500

Height is not used locally in the function, so call the height argument
closer to where it is passed in the next level.

Link: https://lkml.kernel.org/r/20260130205935.2559335-9-Liam.Howlett@oracle.com
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

 lib/maple_tree.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/lib/maple_tree.c~maple_tree-dont-pass-through-height-in-mas_wr_spanning_store
+++ a/lib/maple_tree.c
@@ -2750,10 +2750,10 @@ static void mas_spanning_rebalance(struc
 
 
 static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
-		struct maple_subtree_state *mast, unsigned char height,
-		struct ma_wr_state *wr_mas)
+		struct maple_subtree_state *mast, struct ma_wr_state *wr_mas)
 {
 	struct maple_big_node b_node;
+	unsigned char height;
 	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
 	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
 	MA_STATE(m_mas, mas->tree, mas->index, mas->index);
@@ -2788,6 +2788,7 @@ static noinline void mas_wr_spanning_reb
 	    unlikely(mast->bn->b_end <= mt_min_slots[mast->bn->type]))
 		mast_spanning_rebalance(mast);
 
+	height = mas_mt_height(mas) + 1;
 	mas_spanning_rebalance_loop(mas, mast, height);
 }
 /*
@@ -3448,7 +3449,6 @@ static void mas_wr_spanning_store(struct
 {
 	struct maple_subtree_state mast;
 	struct ma_state *mas;
-	unsigned char height;
 
 	/* Left and Right side of spanning store */
 	MA_STATE(l_mas, NULL, 0, 0);
@@ -3476,7 +3476,6 @@ static void mas_wr_spanning_store(struct
 	 * Node rebalancing may occur due to this store, so there may be three new
 	 * entries per level plus a new root.
 	 */
-	height = mas_mt_height(mas);
 
 	/*
 	 * Set up right side.  Need to get to the next offset after the spanning
@@ -3509,7 +3508,7 @@ static void mas_wr_spanning_store(struct
 	l_mas = *mas;
 	mast.orig_l = &l_mas;
 	mast.orig_r = &r_mas;
-	mas_wr_spanning_rebalance(mas, &mast, height + 1, wr_mas);
+	mas_wr_spanning_rebalance(mas, &mast, wr_mas);
 }
 
 /*
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


