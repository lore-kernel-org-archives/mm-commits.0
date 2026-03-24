Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FD620E702
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388491; cv=none; b=A1Kn+3OvieMouKLvh6OQtYuMDFfkdSDINY971PeCN4RNfIfiw/Yu71hegwIps8EWWVyZZJkMMVarYvfp5HWO3WgpbmwEyGcdiFBV9iFvfJr2SPsVX3xAiaZ0Iw2i13z3ghFAfjH5ae58Il2+Vufhx5oVNnllnNojgDpiNjDDQQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388491; c=relaxed/simple;
	bh=54ui89i5O1DtkaYnAxOpviJgX6R8vqMrFrRpGxqLZxo=;
	h=Date:To:From:Subject:Message-Id; b=N2+MoDBy/V4l+sz7cTxSjRsZvzvxt1Ob+Ez+xabMcxPCGbLXn9G2sZTJnpjvxS5op/A/GobdWWIoKj7plHfV242s30V9StJv+ZDc5mS9yqIN8aYMHuUzC4Jsrgl8n+exqaHdyDWjugqRYpigT0BEnuU+11nppuTgyg1DXwmttfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SXIC6KBM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SXIC6KBM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF62BC19424;
	Tue, 24 Mar 2026 21:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388490;
	bh=54ui89i5O1DtkaYnAxOpviJgX6R8vqMrFrRpGxqLZxo=;
	h=Date:To:From:Subject:From;
	b=SXIC6KBMW8Mhzb2JyWU+sOY4NrkEt87g2Lo/Ijnm2X6qvWa7VTdvsY5MceATVhjw+
	 trKNN5s33DBApf3RwsVPJEkkhT5Jez0E7WJIfOgpeYWlk8CcK9IITLxXOttBKORZih
	 xmPQ/MrRJGnc2YNWn8QwbeRBI69orse3R4esHjO4=
Date: Tue, 24 Mar 2026 14:41:30 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,sidhartha.kumar@oracle.com,lists@nerdbynature.de,kuninori.morimoto.gx@renesas.com,geert@linux-m68k.org,arnd@arndb.de,andrewjballance@gmail.com,aliceryhl@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-inline-mas_spanning_rebalance-into-mas_wr_spanning_rebalance.patch removed from -mm tree
Message-Id: <20260324214130.AF62BC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: inline mas_spanning_rebalance() into mas_wr_spanning_rebalance()
has been removed from the -mm tree.  Its filename was
     maple_tree-inline-mas_spanning_rebalance-into-mas_wr_spanning_rebalance.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: inline mas_spanning_rebalance() into mas_wr_spanning_rebalance()
Date: Fri, 30 Jan 2026 15:59:10 -0500

Copy the contents of mas_spanning_rebalance() into
mas_wr_spanning_rebalance(), in preparation of removing initial big node
use.

No functional changes intended.

Link: https://lkml.kernel.org/r/20260130205935.2559335-6-Liam.Howlett@oracle.com
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

 lib/maple_tree.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-inline-mas_spanning_rebalance-into-mas_wr_spanning_rebalance
+++ a/lib/maple_tree.c
@@ -2754,6 +2754,9 @@ static noinline void mas_wr_spanning_reb
 		struct ma_wr_state *l_wr_mas)
 {
 	struct maple_big_node b_node;
+	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
+	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
+	MA_STATE(m_mas, mas->tree, mas->index, mas->index);
 
 	memset(&b_node, 0, sizeof(struct maple_big_node));
 	/* Copy l_mas and store the value in b_node. */
@@ -2770,7 +2773,22 @@ static noinline void mas_wr_spanning_reb
 
 	mast->bn = &b_node;
 	/* Combine l_mas and r_mas and split them up evenly again. */
-	return mas_spanning_rebalance(mas, mast, height);
+
+	/*
+	 * The tree needs to be rebalanced and leaves need to be kept at the same level.
+	 * Rebalancing is done by use of the ``struct maple_topiary``.
+	 */
+	mast->l = &l_mas;
+	mast->m = &m_mas;
+	mast->r = &r_mas;
+	l_mas.status = r_mas.status = m_mas.status = ma_none;
+
+	/* Check if this is not root and has sufficient data.  */
+	if (((mast->orig_l->min != 0) || (mast->orig_r->max != ULONG_MAX)) &&
+	    unlikely(mast->bn->b_end <= mt_min_slots[mast->bn->type]))
+		mast_spanning_rebalance(mast);
+
+	mas_spanning_rebalance_loop(mas, mast, height);
 }
 /*
  * mas_rebalance() - Rebalance a given node.
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


