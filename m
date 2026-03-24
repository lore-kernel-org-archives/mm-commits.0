Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800CF36164E
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388532; cv=none; b=F+5PqlZAOSwPKNuz2bOZTWQ4lgBwhKhNWANUHGT+Ale5X5p44JmwC6qWteBSd66rVp+WGMTnXRdR6OR0uicFC2m/Fh9YGLKOeYCEEc/ePzRd5jTUYVJcqKoVXHxw/VhVBTS978D6l9H8kWhn3mXmnKOnOe3irgCk4l3YgdR1AkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388532; c=relaxed/simple;
	bh=jT7PQUusTKpLQ6SD/OcGCW2Ect9dpR2Wz6YqcFFsjaE=;
	h=Date:To:From:Subject:Message-Id; b=ODPGGa1IyC5zkOgSexzX/VLVn7y58Ow74kBtV7MHno514qNP3ZNPbzpbkj/GZzj7ouv9GB3VPFZVQbWSXP0Xi2/U9V7RTmvq+zA8DyiVT3P7/Z+DngsGrrZ5k7H2WPR655Rvus3eFw3BchB0Zt/gj2AKE8xvykaAwyWphu8If9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WT4LiSNj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WT4LiSNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B01FC2BCC4;
	Tue, 24 Mar 2026 21:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388532;
	bh=jT7PQUusTKpLQ6SD/OcGCW2Ect9dpR2Wz6YqcFFsjaE=;
	h=Date:To:From:Subject:From;
	b=WT4LiSNj6L/A52lzou4d+uA0E7MP3Hm8Rw2Ym7i9nt+XTBgZJo3y0TcLu/aX7+NTN
	 F/3PiSnVfxTWJq+avQtP+ToP5aK8xjhN1o0CEBT3SsmemGyOkg9sQyGHS/2w3KBmqt
	 MpQlSui6Y2PHUx9jL2pnP6oa97xGcQZOgF5vNsjc=
Date: Tue, 24 Mar 2026 14:42:11 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,sidhartha.kumar@oracle.com,lists@nerdbynature.de,kuninori.morimoto.gx@renesas.com,geert@linux-m68k.org,arnd@arndb.de,andrewjballance@gmail.com,aliceryhl@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-clean-up-mas_wr_node_store.patch removed from -mm tree
Message-Id: <20260324214212.5B01FC2BCC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: clean up mas_wr_node_store()
has been removed from the -mm tree.  Its filename was
     maple_tree-clean-up-mas_wr_node_store.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: clean up mas_wr_node_store()
Date: Fri, 30 Jan 2026 15:59:35 -0500

The new_end does not need to be passed in as the data is already being
checked.  This allows for other areas to skip getting the node new_end in
the calling function.

The type was incorrectly void * instead of void __rcu *, which isn't an
issue but is technically incorrect.

Move the variable assignment to after the declarations to clean up the
initial setup.

Ensure there is something to copy before calling memcpy().

Link: https://lkml.kernel.org/r/20260130205935.2559335-31-Liam.Howlett@oracle.com
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

 lib/maple_tree.c |   42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

--- a/lib/maple_tree.c~maple_tree-clean-up-mas_wr_node_store
+++ a/lib/maple_tree.c
@@ -3122,20 +3122,28 @@ static void mas_wr_spanning_store(struct
  *
  * Attempts to reuse the node, but may allocate.
  */
-static inline void mas_wr_node_store(struct ma_wr_state *wr_mas,
-				     unsigned char new_end)
+static inline void mas_wr_node_store(struct ma_wr_state *wr_mas)
 {
-	struct ma_state *mas = wr_mas->mas;
-	void __rcu **dst_slots;
-	unsigned long *dst_pivots;
-	unsigned char dst_offset, offset_end = wr_mas->offset_end;
+	unsigned char dst_offset, offset_end;
+	unsigned char copy_size, node_pivots;
 	struct maple_node reuse, *newnode;
-	unsigned char copy_size, node_pivots = mt_pivots[wr_mas->type];
-	bool in_rcu = mt_in_rcu(mas->tree);
-	unsigned char height = mas_mt_height(mas);
+	unsigned long *dst_pivots;
+	void __rcu **dst_slots;
+	unsigned char new_end;
+	struct ma_state *mas;
+	bool in_rcu;
 
-	if (mas->last == wr_mas->end_piv)
+	mas = wr_mas->mas;
+	trace_ma_op(TP_FCT, mas);
+	in_rcu = mt_in_rcu(mas->tree);
+	offset_end = wr_mas->offset_end;
+	node_pivots = mt_pivots[wr_mas->type];
+	/* Assume last adds an entry */
+	new_end = mas->end + 1 - offset_end + mas->offset;
+	if (mas->last == wr_mas->end_piv) {
 		offset_end++; /* don't copy this offset */
+		new_end--;
+	}
 
 	/* set up node. */
 	if (in_rcu) {
@@ -3149,13 +3157,16 @@ static inline void mas_wr_node_store(str
 	dst_pivots = ma_pivots(newnode, wr_mas->type);
 	dst_slots = ma_slots(newnode, wr_mas->type);
 	/* Copy from start to insert point */
-	memcpy(dst_pivots, wr_mas->pivots, sizeof(unsigned long) * mas->offset);
-	memcpy(dst_slots, wr_mas->slots, sizeof(void *) * mas->offset);
+	if (mas->offset) {
+		memcpy(dst_pivots, wr_mas->pivots, sizeof(unsigned long) * mas->offset);
+		memcpy(dst_slots, wr_mas->slots, sizeof(void __rcu *) * mas->offset);
+	}
 
 	/* Handle insert of new range starting after old range */
 	if (wr_mas->r_min < mas->index) {
 		rcu_assign_pointer(dst_slots[mas->offset], wr_mas->content);
 		dst_pivots[mas->offset++] = mas->index - 1;
+		new_end++;
 	}
 
 	/* Store the new entry and range end. */
@@ -3174,7 +3185,7 @@ static inline void mas_wr_node_store(str
 	/* Copy to the end of node if necessary. */
 	copy_size = mas->end - offset_end + 1;
 	memcpy(dst_slots + dst_offset, wr_mas->slots + offset_end,
-	       sizeof(void *) * copy_size);
+	       sizeof(void __rcu *) * copy_size);
 	memcpy(dst_pivots + dst_offset, wr_mas->pivots + offset_end,
 	       sizeof(unsigned long) * (copy_size - 1));
 
@@ -3187,7 +3198,7 @@ done:
 		struct maple_enode *old_enode = mas->node;
 
 		mas->node = mt_mk_node(newnode, wr_mas->type);
-		mas_replace_node(mas, old_enode, height);
+		mas_replace_node(mas, old_enode, mas_mt_height(mas));
 	} else {
 		memcpy(wr_mas->node, newnode, sizeof(struct maple_node));
 	}
@@ -3503,7 +3514,6 @@ static void mas_wr_rebalance(struct ma_w
 static inline void mas_wr_store_entry(struct ma_wr_state *wr_mas)
 {
 	struct ma_state *mas = wr_mas->mas;
-	unsigned char new_end = mas_wr_new_end(wr_mas);
 
 	switch (mas->store_type) {
 	case wr_exact_fit:
@@ -3518,7 +3528,7 @@ static inline void mas_wr_store_entry(st
 		mas_wr_slot_store(wr_mas);
 		break;
 	case wr_node_store:
-		mas_wr_node_store(wr_mas, new_end);
+		mas_wr_node_store(wr_mas);
 		break;
 	case wr_spanning_store:
 		mas_wr_spanning_store(wr_mas);
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


