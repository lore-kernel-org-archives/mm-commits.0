Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487DC6FDC
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141597; cv=none; b=YB5yFC8BjqNKoiBqF7I7XGg04n8CDiWFxQHr712VjeQgWFQ7MkFoNElyuIeoST7ivrJjUTgu+HylsUchInEGIk3OBujwxbNw7uCwP1KJyTXw3msb6mgyW2B2v6JzcHzzf6x0JrVibVREds+W4F/bcItpSNpLKQ26jnee29eF/vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141597; c=relaxed/simple;
	bh=znpZXxMlotvxETmkowcOyNEER9Ldm48EtN1ePPtXYRk=;
	h=Date:To:From:Subject:Message-Id; b=I/cR7YIbrc2+oqWQPYXYOOl+cTpDSky3Ay9BEU8NxxhaTsysKa6WNU5B3TAgM8yjoIJ7tdpB7PEUOFC95g7rhYbsCbZ0LJSlJw+qyAdb1hFccEi1l3GvHNjVze+OcsW2tMDMNv7O33AuA2rRr7W5weo8bxbNO6vG3y0duYgvSlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tKhYAVN6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tKhYAVN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5D9C3277B;
	Fri,  5 Jul 2024 01:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141596;
	bh=znpZXxMlotvxETmkowcOyNEER9Ldm48EtN1ePPtXYRk=;
	h=Date:To:From:Subject:From;
	b=tKhYAVN6h6kPe3debi9vXsXO2v/A3ZqaH9paufC6GLIgen0d9YvzM9PkFRTGDj3HT
	 hJ9Jzuu0HyuY2S11rkg4jgWHqXUZt/Xlztr5UEyQuiBmKT6cb+zBXCq7tficZw5uUZ
	 XHe6c2Q2/BFYiic1OPSv2S1YftkNLdMQtBQ3GZes=
Date: Thu, 04 Jul 2024 18:06:36 -0700
To: mm-commits@vger.kernel.org,shr@devkernel.io,hughd@google.com,david@redhat.com,aarcange@redhat.com,chengming.zhou@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-optimize-the-chain-chain_prune-interfaces.patch removed from -mm tree
Message-Id: <20240705010636.CE5D9C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: optimize the chain()/chain_prune() interfaces
has been removed from the -mm tree.  Its filename was
     mm-ksm-optimize-the-chain-chain_prune-interfaces.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengming Zhou <chengming.zhou@linux.dev>
Subject: mm/ksm: optimize the chain()/chain_prune() interfaces
Date: Fri, 21 Jun 2024 15:54:31 +0800

Now the implementation of stable_node_dup() causes chain()/chain_prune()
interfaces and usages are overcomplicated.

Why?  stable_node_dup() only find and return a candidate stable_node for
sharing, so the users have to recheck using stable_node_dup_any() if any
non-candidate stable_node exist.  And try to ksm_get_folio() from it
again.

Actually, stable_node_dup() can just return a best stable_node as it can,
then the users can check if it's a candidate for sharing or not.

The code is simplified too and fewer corner cases: such as stable_node and
stable_node_dup can't be NULL if returned tree_folio is not NULL.

Link: https://lkml.kernel.org/r/20240621-b4-ksm-scan-optimize-v2-3-1c328aa9e30b@linux.dev
Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |  152 +++++++++--------------------------------------------
 1 file changed, 27 insertions(+), 125 deletions(-)

--- a/mm/ksm.c~mm-ksm-optimize-the-chain-chain_prune-interfaces
+++ a/mm/ksm.c
@@ -1659,7 +1659,6 @@ static struct folio *stable_node_dup(str
 	struct ksm_stable_node *dup, *found = NULL, *stable_node = *_stable_node;
 	struct hlist_node *hlist_safe;
 	struct folio *folio, *tree_folio = NULL;
-	int nr = 0;
 	int found_rmap_hlist_len;
 
 	if (!prune_stale_stable_nodes ||
@@ -1686,33 +1685,26 @@ static struct folio *stable_node_dup(str
 		folio = ksm_get_folio(dup, KSM_GET_FOLIO_NOLOCK);
 		if (!folio)
 			continue;
-		nr += 1;
-		if (is_page_sharing_candidate(dup)) {
-			if (!found ||
-			    dup->rmap_hlist_len > found_rmap_hlist_len) {
-				if (found)
-					folio_put(tree_folio);
-				found = dup;
-				found_rmap_hlist_len = found->rmap_hlist_len;
-				tree_folio = folio;
-
-				/* skip put_page for found dup */
-				if (!prune_stale_stable_nodes)
-					break;
-				continue;
-			}
+		/* Pick the best candidate if possible. */
+		if (!found || (is_page_sharing_candidate(dup) &&
+		    (!is_page_sharing_candidate(found) ||
+		     dup->rmap_hlist_len > found_rmap_hlist_len))) {
+			if (found)
+				folio_put(tree_folio);
+			found = dup;
+			found_rmap_hlist_len = found->rmap_hlist_len;
+			tree_folio = folio;
+			/* skip put_page for found candidate */
+			if (!prune_stale_stable_nodes &&
+			    is_page_sharing_candidate(found))
+				break;
+			continue;
 		}
 		folio_put(folio);
 	}
 
 	if (found) {
-		/*
-		 * nr is counting all dups in the chain only if
-		 * prune_stale_stable_nodes is true, otherwise we may
-		 * break the loop at nr == 1 even if there are
-		 * multiple entries.
-		 */
-		if (prune_stale_stable_nodes && nr == 1) {
+		if (hlist_is_singular_node(&found->hlist_dup, &stable_node->hlist)) {
 			/*
 			 * If there's not just one entry it would
 			 * corrupt memory, better BUG_ON. In KSM
@@ -1764,25 +1756,15 @@ static struct folio *stable_node_dup(str
 			hlist_add_head(&found->hlist_dup,
 				       &stable_node->hlist);
 		}
+	} else {
+		/* Its hlist must be empty if no one found. */
+		free_stable_node_chain(stable_node, root);
 	}
 
 	*_stable_node_dup = found;
 	return tree_folio;
 }
 
-static struct ksm_stable_node *stable_node_dup_any(struct ksm_stable_node *stable_node,
-					       struct rb_root *root)
-{
-	if (!is_stable_node_chain(stable_node))
-		return stable_node;
-	if (hlist_empty(&stable_node->hlist)) {
-		free_stable_node_chain(stable_node, root);
-		return NULL;
-	}
-	return hlist_entry(stable_node->hlist.first,
-			   typeof(*stable_node), hlist_dup);
-}
-
 /*
  * Like for ksm_get_folio, this function can free the *_stable_node and
  * *_stable_node_dup if the returned tree_page is NULL.
@@ -1803,17 +1785,10 @@ static struct folio *__stable_node_chain
 					 bool prune_stale_stable_nodes)
 {
 	struct ksm_stable_node *stable_node = *_stable_node;
+
 	if (!is_stable_node_chain(stable_node)) {
-		if (is_page_sharing_candidate(stable_node)) {
-			*_stable_node_dup = stable_node;
-			return ksm_get_folio(stable_node, KSM_GET_FOLIO_NOLOCK);
-		}
-		/*
-		 * _stable_node_dup set to NULL means the stable_node
-		 * reached the ksm_max_page_sharing limit.
-		 */
-		*_stable_node_dup = NULL;
-		return NULL;
+		*_stable_node_dup = stable_node;
+		return ksm_get_folio(stable_node, KSM_GET_FOLIO_NOLOCK);
 	}
 	return stable_node_dup(_stable_node_dup, _stable_node, root,
 			       prune_stale_stable_nodes);
@@ -1827,16 +1802,10 @@ static __always_inline struct folio *cha
 }
 
 static __always_inline struct folio *chain(struct ksm_stable_node **s_n_d,
-					   struct ksm_stable_node *s_n,
+					   struct ksm_stable_node **s_n,
 					   struct rb_root *root)
 {
-	struct ksm_stable_node *old_stable_node = s_n;
-	struct folio *tree_folio;
-
-	tree_folio = __stable_node_chain(s_n_d, &s_n, root, false);
-	/* not pruning dups so s_n cannot have changed */
-	VM_BUG_ON(s_n != old_stable_node);
-	return tree_folio;
+	return __stable_node_chain(s_n_d, s_n, root, false);
 }
 
 /*
@@ -1854,7 +1823,7 @@ static struct page *stable_tree_search(s
 	struct rb_root *root;
 	struct rb_node **new;
 	struct rb_node *parent;
-	struct ksm_stable_node *stable_node, *stable_node_dup, *stable_node_any;
+	struct ksm_stable_node *stable_node, *stable_node_dup;
 	struct ksm_stable_node *page_node;
 	struct folio *folio;
 
@@ -1878,45 +1847,7 @@ again:
 
 		cond_resched();
 		stable_node = rb_entry(*new, struct ksm_stable_node, node);
-		stable_node_any = NULL;
 		tree_folio = chain_prune(&stable_node_dup, &stable_node, root);
-		/*
-		 * NOTE: stable_node may have been freed by
-		 * chain_prune() if the returned stable_node_dup is
-		 * not NULL. stable_node_dup may have been inserted in
-		 * the rbtree instead as a regular stable_node (in
-		 * order to collapse the stable_node chain if a single
-		 * stable_node dup was found in it). In such case the
-		 * stable_node is overwritten by the callee to point
-		 * to the stable_node_dup that was collapsed in the
-		 * stable rbtree and stable_node will be equal to
-		 * stable_node_dup like if the chain never existed.
-		 */
-		if (!stable_node_dup) {
-			/*
-			 * Either all stable_node dups were full in
-			 * this stable_node chain, or this chain was
-			 * empty and should be rb_erased.
-			 */
-			stable_node_any = stable_node_dup_any(stable_node,
-							      root);
-			if (!stable_node_any) {
-				/* rb_erase just run */
-				goto again;
-			}
-			/*
-			 * Take any of the stable_node dups page of
-			 * this stable_node chain to let the tree walk
-			 * continue. All KSM pages belonging to the
-			 * stable_node dups in a stable_node chain
-			 * have the same content and they're
-			 * write protected at all times. Any will work
-			 * fine to continue the walk.
-			 */
-			tree_folio = ksm_get_folio(stable_node_any,
-						   KSM_GET_FOLIO_NOLOCK);
-		}
-		VM_BUG_ON(!stable_node_dup ^ !!stable_node_any);
 		if (!tree_folio) {
 			/*
 			 * If we walked over a stale stable_node,
@@ -1954,7 +1885,7 @@ again:
 					goto chain_append;
 			}
 
-			if (!stable_node_dup) {
+			if (!is_page_sharing_candidate(stable_node_dup)) {
 				/*
 				 * If the stable_node is a chain and
 				 * we got a payload match in memcmp
@@ -2063,9 +1994,6 @@ replace:
 	return &folio->page;
 
 chain_append:
-	/* stable_node_dup could be null if it reached the limit */
-	if (!stable_node_dup)
-		stable_node_dup = stable_node_any;
 	/*
 	 * If stable_node was a chain and chain_prune collapsed it,
 	 * stable_node has been updated to be the new regular
@@ -2110,7 +2038,7 @@ static struct ksm_stable_node *stable_tr
 	struct rb_root *root;
 	struct rb_node **new;
 	struct rb_node *parent;
-	struct ksm_stable_node *stable_node, *stable_node_dup, *stable_node_any;
+	struct ksm_stable_node *stable_node, *stable_node_dup;
 	bool need_chain = false;
 
 	kpfn = folio_pfn(kfolio);
@@ -2126,33 +2054,7 @@ again:
 
 		cond_resched();
 		stable_node = rb_entry(*new, struct ksm_stable_node, node);
-		stable_node_any = NULL;
-		tree_folio = chain(&stable_node_dup, stable_node, root);
-		if (!stable_node_dup) {
-			/*
-			 * Either all stable_node dups were full in
-			 * this stable_node chain, or this chain was
-			 * empty and should be rb_erased.
-			 */
-			stable_node_any = stable_node_dup_any(stable_node,
-							      root);
-			if (!stable_node_any) {
-				/* rb_erase just run */
-				goto again;
-			}
-			/*
-			 * Take any of the stable_node dups page of
-			 * this stable_node chain to let the tree walk
-			 * continue. All KSM pages belonging to the
-			 * stable_node dups in a stable_node chain
-			 * have the same content and they're
-			 * write protected at all times. Any will work
-			 * fine to continue the walk.
-			 */
-			tree_folio = ksm_get_folio(stable_node_any,
-						   KSM_GET_FOLIO_NOLOCK);
-		}
-		VM_BUG_ON(!stable_node_dup ^ !!stable_node_any);
+		tree_folio = chain(&stable_node_dup, &stable_node, root);
 		if (!tree_folio) {
 			/*
 			 * If we walked over a stale stable_node,
_

Patches currently in -mm which might be from chengming.zhou@linux.dev are

mm-zswap-use-only-one-pool-in-zswap.patch
mm-zswap-use-only-one-pool-in-zswap-v2.patch
mm-zswap-use-only-one-pool-in-zswap-v3.patch
mm-zsmalloc-fix-class-per-fullness-zspage-counts.patch
mm-zsmalloc-move-record_obj-into-obj_malloc.patch

