Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C0835F61F
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388494; cv=none; b=b5NI+aBM17v31A+YtFOlsdTkFS1IHOkfLxVbzzguPtwrVBNMPCLkIX9NgkLCnCU++FNKS3yGnh7sDsS5usjpe5fjxGzSQBMsYCNEmcuIl3R2VrrzN+2nd+xlVcusR7+G85uF+OggHAQROOnlp6AIpXOab6D7uBD3GoHBN/G3Lt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388494; c=relaxed/simple;
	bh=xU2pthaQw7AeRVMv2+ZU8zF0rdj+Hxeuhkk2a5fclrM=;
	h=Date:To:From:Subject:Message-Id; b=LvIFNQYTxuwl1yid/1bUGv6i5EY/lLLO1c8FKaO+JoiXDugPZt6dI3gXMEmcCR9Kva5eGQFUhWc5Np4ia+gNGFggNscHhUGGM6LaYCLLwSIozmEkc6GoYzRag8VAvUTehaiArMYAIp0x+BBsgxU2de5GmeeGKd3oJUsk3QyUzy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V21oudLA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V21oudLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C202C19424;
	Tue, 24 Mar 2026 21:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388494;
	bh=xU2pthaQw7AeRVMv2+ZU8zF0rdj+Hxeuhkk2a5fclrM=;
	h=Date:To:From:Subject:From;
	b=V21oudLAVQN60+JMlLawBPru7SfoTj7rFTPF/ueufTXF+MN/molVOWdrlsccnCWMF
	 dU05uYhXqgZ6mfU7yLdc2/I7fHHh7Zj+9PG63R1uP2N8QsISFf0QJtrjx2KqVxEP62
	 kn4azH7VGlsIzzbGvv8nJxaA2/Vc6NUj5u8flsEY=
Date: Tue, 24 Mar 2026 14:41:33 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,sidhartha.kumar@oracle.com,lists@nerdbynature.de,kuninori.morimoto.gx@renesas.com,geert@linux-m68k.org,arnd@arndb.de,andrewjballance@gmail.com,aliceryhl@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-remove-l_wr_mas-from-mas_wr_spanning_rebalance.patch removed from -mm tree
Message-Id: <20260324214134.0C202C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: remove l_wr_mas from mas_wr_spanning_rebalance
has been removed from the -mm tree.  Its filename was
     maple_tree-remove-l_wr_mas-from-mas_wr_spanning_rebalance.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: remove l_wr_mas from mas_wr_spanning_rebalance
Date: Fri, 30 Jan 2026 15:59:12 -0500

Use the wr_mas instead of creating another variable on the stack.  Take
the opportunity to remove l_mas from being used anywhere but in the
maple_subtree_state.

Link: https://lkml.kernel.org/r/20260130205935.2559335-8-Liam.Howlett@oracle.com
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

 lib/maple_tree.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-l_wr_mas-from-mas_wr_spanning_rebalance
+++ a/lib/maple_tree.c
@@ -2751,7 +2751,7 @@ static void mas_spanning_rebalance(struc
 
 static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 		struct maple_subtree_state *mast, unsigned char height,
-		struct ma_wr_state *l_wr_mas)
+		struct ma_wr_state *wr_mas)
 {
 	struct maple_big_node b_node;
 	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
@@ -2760,7 +2760,7 @@ static noinline void mas_wr_spanning_reb
 
 	memset(&b_node, 0, sizeof(struct maple_big_node));
 	/* Copy l_mas and store the value in b_node. */
-	mas_store_b_node(l_wr_mas, &b_node, mast->orig_l->end);
+	mas_store_b_node(wr_mas, &b_node, mast->orig_l->end);
 	/* Copy r_mas into b_node if there is anything to copy. */
 	if (mast->orig_r->max > mast->orig_r->last)
 		mas_mab_cp(mast->orig_r, mast->orig_r->offset,
@@ -3454,7 +3454,6 @@ static void mas_wr_spanning_store(struct
 	MA_STATE(l_mas, NULL, 0, 0);
 	MA_STATE(r_mas, NULL, 0, 0);
 	MA_WR_STATE(r_wr_mas, &r_mas, wr_mas->entry);
-	MA_WR_STATE(l_wr_mas, &l_mas, wr_mas->entry);
 
 	/*
 	 * A store operation that spans multiple nodes is called a spanning
@@ -3494,25 +3493,23 @@ static void mas_wr_spanning_store(struct
 	r_mas.last = r_mas.index = mas->last;
 
 	/* Set up left side. */
-	l_mas = *mas;
-	mas_wr_walk_index(&l_wr_mas);
+	mas_wr_walk_index(wr_mas);
 
 	if (!wr_mas->entry) {
-		mas_extend_spanning_null(&l_wr_mas, &r_wr_mas);
-		mas->offset = l_mas.offset;
-		mas->index = l_mas.index;
-		mas->last = l_mas.last = r_mas.last;
+		mas_extend_spanning_null(wr_mas, &r_wr_mas);
+		mas->last = r_mas.last;
 	}
 
 	/* expanding NULLs may make this cover the entire range */
-	if (!l_mas.index && r_mas.last == ULONG_MAX) {
+	if (!mas->index && r_mas.last == ULONG_MAX) {
 		mas_set_range(mas, 0, ULONG_MAX);
 		return mas_new_root(mas, wr_mas->entry);
 	}
 
+	l_mas = *mas;
 	mast.orig_l = &l_mas;
 	mast.orig_r = &r_mas;
-	mas_wr_spanning_rebalance(mas, &mast, height + 1, &l_wr_mas);
+	mas_wr_spanning_rebalance(mas, &mast, height + 1, wr_mas);
 }
 
 /*
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


