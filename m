Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46F836164E
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388517; cv=none; b=V1kEDfIcU1UNq40c0dOhc1NXAfro80Cnvfsvm1LdZgA9mxwrGvWFPXXrXqVB0rn01y9aucE1E6UeaqoYvuAlBoGbFoofFEnMTHMshWiR+6DzjFxcCKBqmc4IYQIoeeYdrgN/anxudFMOJKl1R6XYwT1CxYmEuzQEu79RRcLsols=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388517; c=relaxed/simple;
	bh=Sy8q2+6bcldS8m4h7xXBDcwdkPnbDb0SxxDF4ycUSgE=;
	h=Date:To:From:Subject:Message-Id; b=Wjd8cgZhSOZfBwzZt66wyUjGcQhhQbYU7cuP4Ib456NGYA1lZFwmrkazt9wVjRgtpbnzG0P1AbenSrvqVanbyj2xaV1VlgjWY4fyFW6Pb5BVpJTsaVxxgDH16PH84Pdo1k/1pfhlD7oZyzF1BRtKqGofbYYX95YnCpiw50T4ZPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=icsMiCD5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="icsMiCD5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2ADC19424;
	Tue, 24 Mar 2026 21:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388517;
	bh=Sy8q2+6bcldS8m4h7xXBDcwdkPnbDb0SxxDF4ycUSgE=;
	h=Date:To:From:Subject:From;
	b=icsMiCD5HKhUKxiqk9NagZwXQnkSFqdrbQw1JIdusEIn3WjXeiJqfNSglszXDOyIj
	 tyagdeTNYJ2DLrvi/x3xGasctffwJXZTpcp+2XCQWyJuM4ZWO8KreTkVZP+OP6Iyji
	 U+XvnRCelEpUXkJLQh0Bcfk3fmFpFL+VSCPIwQRE=
Date: Tue, 24 Mar 2026 14:41:57 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,sidhartha.kumar@oracle.com,lists@nerdbynature.de,kuninori.morimoto.gx@renesas.com,geert@linux-m68k.org,arnd@arndb.de,andrewjballance@gmail.com,aliceryhl@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-add-cp_is_new_root-helper.patch removed from -mm tree
Message-Id: <20260324214157.8D2ADC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: add cp_is_new_root() helper
has been removed from the -mm tree.  Its filename was
     maple_tree-add-cp_is_new_root-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: add cp_is_new_root() helper
Date: Fri, 30 Jan 2026 15:59:26 -0500

Add a helper to do what is needed when the maple copy node contains a new
root node.  This is useful for future commits and is self-documenting
code.

[Liam.Howlett@oracle.com: remove warnings on older compilers]
  Link: https://lkml.kernel.org/r/malwmirqnpuxqkqrobcmzfkmmxipoyzwfs2nwc5fbpxlt2r2ej@wchmjtaljvw3
[akpm@linux-foundation.org: s/cp->slot[0]/&cp->slot[0]/, per Liam]
Link: https://lkml.kernel.org/r/20260130205935.2559335-22-Liam.Howlett@oracle.com
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

 lib/maple_tree.c |   70 ++++++++++++++++++++++++---------------------
 1 file changed, 38 insertions(+), 32 deletions(-)

--- a/lib/maple_tree.c~maple_tree-add-cp_is_new_root-helper
+++ a/lib/maple_tree.c
@@ -3337,6 +3337,43 @@ static void mas_spanning_rebalance(struc
 	mas_spanning_rebalance_loop(mas, mast, count);
 }
 
+static inline bool cp_is_new_root(struct maple_copy *cp, struct ma_state *mas)
+{
+	if (cp->min || cp->max != ULONG_MAX)
+		return false;
+
+	if (cp->d_count != 1) {
+		enum maple_type mt = maple_arange_64;
+
+		if (!mt_is_alloc(mas->tree))
+			mt = maple_range_64;
+
+		cp->data = cp->d_count;
+		cp->s_count = 0;
+		dst_setup(cp, mas, mt);
+		init_cp_src(cp);
+		node_copy(mas, cp->src[0].node, 0, cp->data, cp->max, maple_copy,
+			  cp->dst[0].node, 0, mt);
+		node_finalise(cp->dst[0].node, mt, cp->end + 1);
+		/*
+		 * Warning, see cp_leaf_init() comment and rcu_assign_pointer()
+		 * documentation.  Since this is a new root, there are no
+		 * read-side operations that can view it until it is insert into
+		 * the tree after an rcu_assign_pointer() call.
+		 */
+		ma_init_slot(&cp->slot[0], cp->dst[0].node, mt);
+		cp->height++;
+	}
+	WARN_ON_ONCE(cp->dst[0].node != mte_to_node(
+				mt_slot_locked(mas->tree, cp->slot, 0)));
+	cp->dst[0].node->parent = ma_parent_ptr(mas_tree_parent(mas));
+	mas->min = 0;
+	mas->max = ULONG_MAX;
+	mas->depth = 0;
+	mas->node = mas_root_locked(mas);
+	return true;
+}
+
 /*
  * spanning_ascend() - See if a spanning store operation has to keep walking up
  * the tree
@@ -3359,39 +3396,8 @@ static bool spanning_ascend(struct maple
 	}
 
 	cp_dst_to_slots(cp, l_wr_mas->mas->min, r_wr_mas->mas->max, mas);
-	if (!cp->min && cp->max == ULONG_MAX) {
-		/* New root */
-		if (cp->d_count != 1) {
-			enum maple_type mt = maple_arange_64;
-
-			if (!mt_is_alloc(mas->tree))
-				mt = maple_range_64;
-
-			cp->data = cp->d_count;
-			cp->s_count = 0;
-			dst_setup(cp, mas, mt);
-			init_cp_src(cp);
-			node_copy(mas, cp->src[0].node, 0, cp->data, cp->max, maple_copy,
-				  cp->dst[0].node, 0, mt);
-			node_finalise(cp->dst[0].node, mt, cp->end + 1);
-			/*
-			 * Warning, see cp_leaf_init() comment and rcu_assign_pointer()
-			 * documentation.  Since this is a new root, there are no
-			 * read-side operations that can view it until it is insert into
-			 * the tree after an rcu_assign_pointer() call.
-			 */
-			ma_init_slot(&cp->slot[0], cp->dst[0].node, mt);
-			cp->height++;
-		}
-		WARN_ON_ONCE(cp->dst[0].node != mte_to_node(
-				mt_slot_locked(mas->tree, cp->slot, 0)));
-		cp->dst[0].node->parent = ma_parent_ptr(mas_tree_parent(mas));
-		mas->min = 0;
-		mas->max = ULONG_MAX;
-		mas->depth = 0;
-		mas->node = mas_root_locked(mas);
+	if (cp_is_new_root(cp, mas))
 		return false;
-	}
 
 	/* Converged and has a single destination */
 	if ((cp->d_count == 1) &&
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


