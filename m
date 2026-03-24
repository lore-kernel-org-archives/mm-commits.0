Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCC1361641
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388529; cv=none; b=AUv8gwUtP5BP7FYrzeTslaVEexKWyKGi3sk5dISsZK+zucdtqjsQoPK4U4OnD8E1SfUjrWhN4CLKNVshJuuRIYcsLEv2El/2GtRby7l1aMKhVQ6aTO1W6MEK50NRTgqZciAJhd3DFqlvor7EkORzdkKwiCeb2zkJeNvlpsX4GeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388529; c=relaxed/simple;
	bh=zta96CJwCbwZ2jnbnrIZXkYPSiNn7P9PlP8U3yhse6g=;
	h=Date:To:From:Subject:Message-Id; b=FRGT+fFaWX/RtiTfu4bpF0GjbMWnj1Cwhl8SVjfDKMotdAbNFqgQSZyTth/mRJRgVffrzQ4lZt4SshmGRP+zA1tEKS/Ij23/ZOtV4AsML7lTpmutHxrIbejEcjC9FOhz/S95od68l14w5GyNVBIlDkjSyHiHBMLCBwUmT6h59So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S9Gk5zSQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S9Gk5zSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9EAC2BCB1;
	Tue, 24 Mar 2026 21:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388529;
	bh=zta96CJwCbwZ2jnbnrIZXkYPSiNn7P9PlP8U3yhse6g=;
	h=Date:To:From:Subject:From;
	b=S9Gk5zSQS8/0o/1ykVNt4LjqM+0W5dmOyzRoKBjqU+3KLBPklQ6ACKGKLL3sqDy66
	 rhhULJSO1imfEXjfD8lK21FbgvptNS62vv8Aj6R3v61Ru5YPzIkFSN64m1iEhxyi9e
	 DpoRHDWtJoyxnZ/ZdJnvfGLGSxD8SYB7I7DKW8yw=
Date: Tue, 24 Mar 2026 14:42:08 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,sidhartha.kumar@oracle.com,lists@nerdbynature.de,kuninori.morimoto.gx@renesas.com,geert@linux-m68k.org,arnd@arndb.de,andrewjballance@gmail.com,aliceryhl@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-pass-maple-copy-node-to-mas_wmb_replace.patch removed from -mm tree
Message-Id: <20260324214208.ED9EAC2BCB1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: pass maple copy node to mas_wmb_replace()
has been removed from the -mm tree.  Its filename was
     maple_tree-pass-maple-copy-node-to-mas_wmb_replace.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: pass maple copy node to mas_wmb_replace()
Date: Fri, 30 Jan 2026 15:59:33 -0500

mas_wmb_replace() is called in three places with the same setup, move the
setup into the function itself.  The function needs to be relocated as it
calls mtree_range_walk().

Link: https://lkml.kernel.org/r/20260130205935.2559335-29-Liam.Howlett@oracle.com
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

 lib/maple_tree.c |   60 ++++++++++++++++++---------------------------
 1 file changed, 25 insertions(+), 35 deletions(-)

--- a/lib/maple_tree.c~maple_tree-pass-maple-copy-node-to-mas_wmb_replace
+++ a/lib/maple_tree.c
@@ -1901,26 +1901,6 @@ static inline void mas_topiary_replace(s
 }
 
 /*
- * mas_wmb_replace() - Write memory barrier and replace
- * @mas: The maple state
- * @old_enode: The old maple encoded node that is being replaced.
- * @new_height: The new height of the tree as a result of the operation
- *
- * Updates gap as necessary.
- */
-static inline void mas_wmb_replace(struct ma_state *mas,
-		struct maple_enode *old_enode, unsigned char new_height)
-{
-	/* Insert the new data in the tree */
-	mas_topiary_replace(mas, old_enode, new_height);
-
-	if (mte_is_leaf(mas->node))
-		return;
-
-	mas_update_gap(mas);
-}
-
-/*
  * node_copy() - Copy from one node to another.
  *
  * @mas: The maple state
@@ -2087,6 +2067,28 @@ dead_node:
 }
 
 /*
+ * mas_wmb_replace() - Write memory barrier and replace
+ * @mas: The maple state
+ * @cp: The maple copy node
+ *
+ * Updates gap as necessary.
+ */
+static inline void mas_wmb_replace(struct ma_state *mas, struct maple_copy *cp)
+{
+	struct maple_enode *old_enode;
+
+	old_enode = mas->node;
+	mas->node = mt_slot_locked(mas->tree, cp->slot, 0);
+	/* Insert the new data in the tree */
+	mas_topiary_replace(mas, old_enode, cp->height);
+	if (!mte_is_leaf(mas->node))
+		mas_update_gap(mas);
+
+	mtree_range_walk(mas);
+}
+
+
+/*
  * cp_leaf_init() - Initialize a maple_copy node for the leaf level of a
  * spanning store
  * @cp: The maple copy node
@@ -3044,7 +3046,6 @@ done:
  */
 static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 {
-	struct maple_enode *old_enode;
 	struct maple_copy cp;
 	struct ma_state *mas;
 	struct ma_state sib;
@@ -3112,10 +3113,7 @@ static void mas_wr_spanning_store(struct
 		cp_data_write(&cp, mas);
 	} while (spanning_ascend(&cp, mas, wr_mas, &r_wr_mas, &sib));
 
-	old_enode = mas->node;
-	mas->node = mt_slot_locked(mas->tree, cp.slot, 0);
-	mas_wmb_replace(mas, old_enode, cp.height);
-	mtree_range_walk(mas);
+	mas_wmb_replace(mas, &cp);
 }
 
 /*
@@ -3433,7 +3431,6 @@ static inline void split_data(struct map
  */
 static void mas_wr_split(struct ma_wr_state *wr_mas)
 {
-	struct maple_enode *old_enode;
 	struct ma_state parent;
 	struct ma_state *mas;
 	struct maple_copy cp;
@@ -3454,10 +3451,7 @@ static void mas_wr_split(struct ma_wr_st
 		cp_data_write(&cp, mas);
 	} while (split_ascend(&cp, wr_mas, &sib, &parent));
 
-	old_enode = mas->node;
-	mas->node = mt_slot_locked(mas->tree, cp.slot, 0);
-	mas_wmb_replace(mas, old_enode, cp.height);
-	mtree_range_walk(mas);
+	mas_wmb_replace(mas, &cp);
 }
 
 /*
@@ -3470,7 +3464,6 @@ static void mas_wr_split(struct ma_wr_st
  */
 static void mas_wr_rebalance(struct ma_wr_state *wr_mas)
 {
-	struct maple_enode *old_enode;
 	struct ma_state parent;
 	struct ma_state *mas;
 	struct maple_copy cp;
@@ -3501,10 +3494,7 @@ static void mas_wr_rebalance(struct ma_w
 		cp_data_write(&cp, mas);
 	} while (rebalance_ascend(&cp, wr_mas, &sib, &parent));
 
-	old_enode = mas->node;
-	mas->node = mt_slot_locked(mas->tree, cp.slot, 0);
-	mas_wmb_replace(mas, old_enode, cp.height);
-	mtree_range_walk(mas);
+	mas_wmb_replace(mas, &cp);
 }
 
 /*
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


