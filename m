From: akpm@linux-foundation.org
Subject: [merged] nilfs2-clean-up-indirect-function-calling-conventions.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:09:27 -0700
Message-ID: <200904071909.n37J9RJf012345@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752579AbZDGTMC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:12:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     nilfs2: clean up indirect function calling conventions
has been removed from the -mm tree.  Its filename was
     nilfs2-clean-up-indirect-function-calling-conventions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: clean up indirect function calling conventions
From: Pekka Enberg <penberg@cs.helsinki.fi>

This cleans up the strange indirect function calling convention used in
nilfs to follow the normal kernel coding style.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/bmap.c   |   46 +++++++++++++++----------------
 fs/nilfs2/btree.c  |   62 +++++++++++++++++++++----------------------
 fs/nilfs2/direct.c |   28 +++++++++----------
 fs/nilfs2/ioctl.c  |    2 -
 4 files changed, 69 insertions(+), 69 deletions(-)

diff -puN fs/nilfs2/bmap.c~nilfs2-clean-up-indirect-function-calling-conventions fs/nilfs2/bmap.c
--- a/fs/nilfs2/bmap.c~nilfs2-clean-up-indirect-function-calling-conventions
+++ a/fs/nilfs2/bmap.c
@@ -38,11 +38,11 @@ int nilfs_bmap_lookup_at_level(struct ni
 	int ret;
 
 	down_read(&bmap->b_sem);
-	ret = (*bmap->b_ops->bop_lookup)(bmap, key, level, ptrp);
+	ret = bmap->b_ops->bop_lookup(bmap, key, level, ptrp);
 	if (ret < 0)
 		goto out;
 	if (bmap->b_pops->bpop_translate != NULL) {
-		ret = (*bmap->b_pops->bpop_translate)(bmap, *ptrp, &ptr);
+		ret = bmap->b_pops->bpop_translate(bmap, *ptrp, &ptr);
 		if (ret < 0)
 			goto out;
 		*ptrp = ptr;
@@ -94,9 +94,9 @@ static int nilfs_bmap_do_insert(struct n
 	int ret, n;
 
 	if (bmap->b_ops->bop_check_insert != NULL) {
-		ret = (*bmap->b_ops->bop_check_insert)(bmap, key);
+		ret = bmap->b_ops->bop_check_insert(bmap, key);
 		if (ret > 0) {
-			n = (*bmap->b_ops->bop_gather_data)(
+			n = bmap->b_ops->bop_gather_data(
 				bmap, keys, ptrs, NILFS_BMAP_SMALL_HIGH + 1);
 			if (n < 0)
 				return n;
@@ -111,7 +111,7 @@ static int nilfs_bmap_do_insert(struct n
 			return ret;
 	}
 
-	return (*bmap->b_ops->bop_insert)(bmap, key, ptr);
+	return bmap->b_ops->bop_insert(bmap, key, ptr);
 }
 
 /**
@@ -151,9 +151,9 @@ static int nilfs_bmap_do_delete(struct n
 	int ret, n;
 
 	if (bmap->b_ops->bop_check_delete != NULL) {
-		ret = (*bmap->b_ops->bop_check_delete)(bmap, key);
+		ret = bmap->b_ops->bop_check_delete(bmap, key);
 		if (ret > 0) {
-			n = (*bmap->b_ops->bop_gather_data)(
+			n = bmap->b_ops->bop_gather_data(
 				bmap, keys, ptrs, NILFS_BMAP_LARGE_LOW + 1);
 			if (n < 0)
 				return n;
@@ -168,7 +168,7 @@ static int nilfs_bmap_do_delete(struct n
 			return ret;
 	}
 
-	return (*bmap->b_ops->bop_delete)(bmap, key);
+	return bmap->b_ops->bop_delete(bmap, key);
 }
 
 int nilfs_bmap_last_key(struct nilfs_bmap *bmap, unsigned long *key)
@@ -177,7 +177,7 @@ int nilfs_bmap_last_key(struct nilfs_bma
 	int ret;
 
 	down_read(&bmap->b_sem);
-	ret = (*bmap->b_ops->bop_last_key)(bmap, &lastkey);
+	ret = bmap->b_ops->bop_last_key(bmap, &lastkey);
 	if (!ret)
 		*key = lastkey;
 	up_read(&bmap->b_sem);
@@ -216,7 +216,7 @@ static int nilfs_bmap_do_truncate(struct
 	__u64 lastkey;
 	int ret;
 
-	ret = (*bmap->b_ops->bop_last_key)(bmap, &lastkey);
+	ret = bmap->b_ops->bop_last_key(bmap, &lastkey);
 	if (ret < 0) {
 		if (ret == -ENOENT)
 			ret = 0;
@@ -227,7 +227,7 @@ static int nilfs_bmap_do_truncate(struct
 		ret = nilfs_bmap_do_delete(bmap, lastkey);
 		if (ret < 0)
 			return ret;
-		ret = (*bmap->b_ops->bop_last_key)(bmap, &lastkey);
+		ret = bmap->b_ops->bop_last_key(bmap, &lastkey);
 		if (ret < 0) {
 			if (ret == -ENOENT)
 				ret = 0;
@@ -272,7 +272,7 @@ void nilfs_bmap_clear(struct nilfs_bmap 
 {
 	down_write(&bmap->b_sem);
 	if (bmap->b_ops->bop_clear != NULL)
-		(*bmap->b_ops->bop_clear)(bmap);
+		bmap->b_ops->bop_clear(bmap);
 	up_write(&bmap->b_sem);
 }
 
@@ -296,7 +296,7 @@ int nilfs_bmap_propagate(struct nilfs_bm
 	int ret;
 
 	down_write(&bmap->b_sem);
-	ret = (*bmap->b_ops->bop_propagate)(bmap, bh);
+	ret = bmap->b_ops->bop_propagate(bmap, bh);
 	up_write(&bmap->b_sem);
 	return ret;
 }
@@ -310,7 +310,7 @@ void nilfs_bmap_lookup_dirty_buffers(str
 				     struct list_head *listp)
 {
 	if (bmap->b_ops->bop_lookup_dirty_buffers != NULL)
-		(*bmap->b_ops->bop_lookup_dirty_buffers)(bmap, listp);
+		bmap->b_ops->bop_lookup_dirty_buffers(bmap, listp);
 }
 
 /**
@@ -340,7 +340,7 @@ int nilfs_bmap_assign(struct nilfs_bmap 
 	int ret;
 
 	down_write(&bmap->b_sem);
-	ret = (*bmap->b_ops->bop_assign)(bmap, bh, blocknr, binfo);
+	ret = bmap->b_ops->bop_assign(bmap, bh, blocknr, binfo);
 	up_write(&bmap->b_sem);
 	return ret;
 }
@@ -369,7 +369,7 @@ int nilfs_bmap_mark(struct nilfs_bmap *b
 		return 0;
 
 	down_write(&bmap->b_sem);
-	ret = (*bmap->b_ops->bop_mark)(bmap, key, level);
+	ret = bmap->b_ops->bop_mark(bmap, key, level);
 	up_write(&bmap->b_sem);
 	return ret;
 }
@@ -572,12 +572,12 @@ int nilfs_bmap_prepare_update(struct nil
 {
 	int ret;
 
-	ret = (*bmap->b_pops->bpop_prepare_end_ptr)(bmap, oldreq);
+	ret = bmap->b_pops->bpop_prepare_end_ptr(bmap, oldreq);
 	if (ret < 0)
 		return ret;
-	ret = (*bmap->b_pops->bpop_prepare_alloc_ptr)(bmap, newreq);
+	ret = bmap->b_pops->bpop_prepare_alloc_ptr(bmap, newreq);
 	if (ret < 0)
-		(*bmap->b_pops->bpop_abort_end_ptr)(bmap, oldreq);
+		bmap->b_pops->bpop_abort_end_ptr(bmap, oldreq);
 
 	return ret;
 }
@@ -586,16 +586,16 @@ void nilfs_bmap_commit_update(struct nil
 			      union nilfs_bmap_ptr_req *oldreq,
 			      union nilfs_bmap_ptr_req *newreq)
 {
-	(*bmap->b_pops->bpop_commit_end_ptr)(bmap, oldreq);
-	(*bmap->b_pops->bpop_commit_alloc_ptr)(bmap, newreq);
+	bmap->b_pops->bpop_commit_end_ptr(bmap, oldreq);
+	bmap->b_pops->bpop_commit_alloc_ptr(bmap, newreq);
 }
 
 void nilfs_bmap_abort_update(struct nilfs_bmap *bmap,
 			     union nilfs_bmap_ptr_req *oldreq,
 			     union nilfs_bmap_ptr_req *newreq)
 {
-	(*bmap->b_pops->bpop_abort_end_ptr)(bmap, oldreq);
-	(*bmap->b_pops->bpop_abort_alloc_ptr)(bmap, newreq);
+	bmap->b_pops->bpop_abort_end_ptr(bmap, oldreq);
+	bmap->b_pops->bpop_abort_alloc_ptr(bmap, newreq);
 }
 
 static int nilfs_bmap_translate_v(const struct nilfs_bmap *bmap, __u64 ptr,
diff -puN fs/nilfs2/btree.c~nilfs2-clean-up-indirect-function-calling-conventions fs/nilfs2/btree.c
--- a/fs/nilfs2/btree.c~nilfs2-clean-up-indirect-function-calling-conventions
+++ a/fs/nilfs2/btree.c
@@ -902,9 +902,9 @@ static int nilfs_btree_prepare_insert(st
 	/* allocate a new ptr for data block */
 	if (btree->bt_ops->btop_find_target != NULL)
 		path[level].bp_newreq.bpr_ptr =
-			(*btree->bt_ops->btop_find_target)(btree, path, key);
+			btree->bt_ops->btop_find_target(btree, path, key);
 
-	ret = (*btree->bt_bmap.b_pops->bpop_prepare_alloc_ptr)(
+	ret = btree->bt_bmap.b_pops->bpop_prepare_alloc_ptr(
 		&btree->bt_bmap, &path[level].bp_newreq);
 	if (ret < 0)
 		goto err_out_data;
@@ -965,7 +965,7 @@ static int nilfs_btree_prepare_insert(st
 		/* split */
 		path[level].bp_newreq.bpr_ptr =
 			path[level - 1].bp_newreq.bpr_ptr + 1;
-		ret = (*btree->bt_bmap.b_pops->bpop_prepare_alloc_ptr)(
+		ret = btree->bt_bmap.b_pops->bpop_prepare_alloc_ptr(
 			&btree->bt_bmap, &path[level].bp_newreq);
 		if (ret < 0)
 			goto err_out_child_node;
@@ -997,7 +997,7 @@ static int nilfs_btree_prepare_insert(st
 
 	/* grow */
 	path[level].bp_newreq.bpr_ptr = path[level - 1].bp_newreq.bpr_ptr + 1;
-	ret = (*btree->bt_bmap.b_pops->bpop_prepare_alloc_ptr)(
+	ret = btree->bt_bmap.b_pops->bpop_prepare_alloc_ptr(
 		&btree->bt_bmap, &path[level].bp_newreq);
 	if (ret < 0)
 		goto err_out_child_node;
@@ -1026,17 +1026,17 @@ static int nilfs_btree_prepare_insert(st
 
 	/* error */
  err_out_curr_node:
-	(*btree->bt_bmap.b_pops->bpop_abort_alloc_ptr)(&btree->bt_bmap,
-						       &path[level].bp_newreq);
+	btree->bt_bmap.b_pops->bpop_abort_alloc_ptr(&btree->bt_bmap,
+						    &path[level].bp_newreq);
  err_out_child_node:
 	for (level--; level > NILFS_BTREE_LEVEL_DATA; level--) {
 		nilfs_bmap_delete_block(&btree->bt_bmap, path[level].bp_sib_bh);
-		(*btree->bt_bmap.b_pops->bpop_abort_alloc_ptr)(
+		btree->bt_bmap.b_pops->bpop_abort_alloc_ptr(
 			&btree->bt_bmap, &path[level].bp_newreq);
 
 	}
 
-	(*btree->bt_bmap.b_pops->bpop_abort_alloc_ptr)(&btree->bt_bmap,
+	btree->bt_bmap.b_pops->bpop_abort_alloc_ptr(&btree->bt_bmap,
 						       &path[level].bp_newreq);
  err_out_data:
 	*levelp = level;
@@ -1053,14 +1053,14 @@ static void nilfs_btree_commit_insert(st
 	set_buffer_nilfs_volatile((struct buffer_head *)((unsigned long)ptr));
 	ptr = path[NILFS_BTREE_LEVEL_DATA].bp_newreq.bpr_ptr;
 	if (btree->bt_ops->btop_set_target != NULL)
-		(*btree->bt_ops->btop_set_target)(btree, key, ptr);
+		btree->bt_ops->btop_set_target(btree, key, ptr);
 
 	for (level = NILFS_BTREE_LEVEL_NODE_MIN; level <= maxlevel; level++) {
 		if (btree->bt_bmap.b_pops->bpop_commit_alloc_ptr != NULL) {
-			(*btree->bt_bmap.b_pops->bpop_commit_alloc_ptr)(
+			btree->bt_bmap.b_pops->bpop_commit_alloc_ptr(
 				&btree->bt_bmap, &path[level - 1].bp_newreq);
 		}
-		(*path[level].bp_op)(btree, path, level, &key, &ptr);
+		path[level].bp_op(btree, path, level, &key, &ptr);
 	}
 
 	if (!nilfs_bmap_dirty(&btree->bt_bmap))
@@ -1304,7 +1304,7 @@ static int nilfs_btree_prepare_delete(st
 			nilfs_btree_node_get_ptr(btree, node,
 						 path[level].bp_index);
 		if (btree->bt_bmap.b_pops->bpop_prepare_end_ptr != NULL) {
-			ret = (*btree->bt_bmap.b_pops->bpop_prepare_end_ptr)(
+			ret = btree->bt_bmap.b_pops->bpop_prepare_end_ptr(
 				&btree->bt_bmap, &path[level].bp_oldreq);
 			if (ret < 0)
 				goto err_out_child_node;
@@ -1385,7 +1385,7 @@ static int nilfs_btree_prepare_delete(st
 	path[level].bp_oldreq.bpr_ptr =
 		nilfs_btree_node_get_ptr(btree, node, path[level].bp_index);
 	if (btree->bt_bmap.b_pops->bpop_prepare_end_ptr != NULL) {
-		ret = (*btree->bt_bmap.b_pops->bpop_prepare_end_ptr)(
+		ret = btree->bt_bmap.b_pops->bpop_prepare_end_ptr(
 			&btree->bt_bmap, &path[level].bp_oldreq);
 		if (ret < 0)
 			goto err_out_child_node;
@@ -1402,13 +1402,13 @@ static int nilfs_btree_prepare_delete(st
 	/* error */
  err_out_curr_node:
 	if (btree->bt_bmap.b_pops->bpop_abort_end_ptr != NULL)
-		(*btree->bt_bmap.b_pops->bpop_abort_end_ptr)(
+		btree->bt_bmap.b_pops->bpop_abort_end_ptr(
 			&btree->bt_bmap, &path[level].bp_oldreq);
  err_out_child_node:
 	for (level--; level >= NILFS_BTREE_LEVEL_NODE_MIN; level--) {
 		nilfs_bmap_put_block(&btree->bt_bmap, path[level].bp_sib_bh);
 		if (btree->bt_bmap.b_pops->bpop_abort_end_ptr != NULL)
-			(*btree->bt_bmap.b_pops->bpop_abort_end_ptr)(
+			btree->bt_bmap.b_pops->bpop_abort_end_ptr(
 				&btree->bt_bmap, &path[level].bp_oldreq);
 	}
 	*levelp = level;
@@ -1424,9 +1424,9 @@ static void nilfs_btree_commit_delete(st
 
 	for (level = NILFS_BTREE_LEVEL_NODE_MIN; level <= maxlevel; level++) {
 		if (btree->bt_bmap.b_pops->bpop_commit_end_ptr != NULL)
-			(*btree->bt_bmap.b_pops->bpop_commit_end_ptr)(
+			btree->bt_bmap.b_pops->bpop_commit_end_ptr(
 				&btree->bt_bmap, &path[level].bp_oldreq);
-		(*path[level].bp_op)(btree, path, level, NULL, NULL);
+		path[level].bp_op(btree, path, level, NULL, NULL);
 	}
 
 	if (!nilfs_bmap_dirty(&btree->bt_bmap))
@@ -1589,8 +1589,8 @@ nilfs_btree_prepare_convert_and_insert(s
 	/* cannot find near ptr */
 	if (btree->bt_ops->btop_find_target != NULL)
 		dreq->bpr_ptr
-			= (*btree->bt_ops->btop_find_target)(btree, NULL, key);
-	ret = (*bmap->b_pops->bpop_prepare_alloc_ptr)(bmap, dreq);
+			= btree->bt_ops->btop_find_target(btree, NULL, key);
+	ret = bmap->b_pops->bpop_prepare_alloc_ptr(bmap, dreq);
 	if (ret < 0)
 		return ret;
 
@@ -1598,7 +1598,7 @@ nilfs_btree_prepare_convert_and_insert(s
 	stats->bs_nblocks++;
 	if (nreq != NULL) {
 		nreq->bpr_ptr = dreq->bpr_ptr + 1;
-		ret = (*bmap->b_pops->bpop_prepare_alloc_ptr)(bmap, nreq);
+		ret = bmap->b_pops->bpop_prepare_alloc_ptr(bmap, nreq);
 		if (ret < 0)
 			goto err_out_dreq;
 
@@ -1615,9 +1615,9 @@ nilfs_btree_prepare_convert_and_insert(s
 
 	/* error */
  err_out_nreq:
-	(*bmap->b_pops->bpop_abort_alloc_ptr)(bmap, nreq);
+	bmap->b_pops->bpop_abort_alloc_ptr(bmap, nreq);
  err_out_dreq:
-	(*bmap->b_pops->bpop_abort_alloc_ptr)(bmap, dreq);
+	bmap->b_pops->bpop_abort_alloc_ptr(bmap, dreq);
 	stats->bs_nblocks = 0;
 	return ret;
 
@@ -1638,7 +1638,7 @@ nilfs_btree_commit_convert_and_insert(st
 
 	/* free resources */
 	if (bmap->b_ops->bop_clear != NULL)
-		(*bmap->b_ops->bop_clear)(bmap);
+		bmap->b_ops->bop_clear(bmap);
 
 	/* ptr must be a pointer to a buffer head. */
 	set_buffer_nilfs_volatile((struct buffer_head *)((unsigned long)ptr));
@@ -1648,8 +1648,8 @@ nilfs_btree_commit_convert_and_insert(st
 	nilfs_btree_init(bmap, low, high);
 	if (nreq != NULL) {
 		if (bmap->b_pops->bpop_commit_alloc_ptr != NULL) {
-			(*bmap->b_pops->bpop_commit_alloc_ptr)(bmap, dreq);
-			(*bmap->b_pops->bpop_commit_alloc_ptr)(bmap, nreq);
+			bmap->b_pops->bpop_commit_alloc_ptr(bmap, dreq);
+			bmap->b_pops->bpop_commit_alloc_ptr(bmap, nreq);
 		}
 
 		/* create child node at level 1 */
@@ -1673,7 +1673,7 @@ nilfs_btree_commit_convert_and_insert(st
 				      2, 1, &keys[0], &tmpptr);
 	} else {
 		if (bmap->b_pops->bpop_commit_alloc_ptr != NULL)
-			(*bmap->b_pops->bpop_commit_alloc_ptr)(bmap, dreq);
+			bmap->b_pops->bpop_commit_alloc_ptr(bmap, dreq);
 
 		/* create root node at level 1 */
 		node = nilfs_btree_get_root(btree);
@@ -1686,7 +1686,7 @@ nilfs_btree_commit_convert_and_insert(st
 	}
 
 	if (btree->bt_ops->btop_set_target != NULL)
-		(*btree->bt_ops->btop_set_target)(btree, key, dreq->bpr_ptr);
+		btree->bt_ops->btop_set_target(btree, key, dreq->bpr_ptr);
 }
 
 /**
@@ -1937,7 +1937,7 @@ static int nilfs_btree_propagate(const s
 		goto out;
 	}
 
-	ret = (*btree->bt_ops->btop_propagate)(btree, path, level, bh);
+	ret = btree->bt_ops->btop_propagate(btree, path, level, bh);
 
  out:
 	nilfs_btree_clear_path(btree, path);
@@ -2073,11 +2073,11 @@ static int nilfs_btree_assign_v(struct n
 	ptr = nilfs_btree_node_get_ptr(btree, parent,
 				       path[level + 1].bp_index);
 	req.bpr_ptr = ptr;
-	ret = (*btree->bt_bmap.b_pops->bpop_prepare_start_ptr)(&btree->bt_bmap,
+	ret = btree->bt_bmap.b_pops->bpop_prepare_start_ptr(&btree->bt_bmap,
 							       &req);
 	if (ret < 0)
 		return ret;
-	(*btree->bt_bmap.b_pops->bpop_commit_start_ptr)(&btree->bt_bmap,
+	btree->bt_bmap.b_pops->bpop_commit_start_ptr(&btree->bt_bmap,
 							&req, blocknr);
 
 	key = nilfs_btree_node_get_key(btree, parent,
@@ -2121,7 +2121,7 @@ static int nilfs_btree_assign(struct nil
 		goto out;
 	}
 
-	ret = (*btree->bt_ops->btop_assign)(btree, path, level, bh,
+	ret = btree->bt_ops->btop_assign(btree, path, level, bh,
 					    blocknr, binfo);
 
  out:
diff -puN fs/nilfs2/direct.c~nilfs2-clean-up-indirect-function-calling-conventions fs/nilfs2/direct.c
--- a/fs/nilfs2/direct.c~nilfs2-clean-up-indirect-function-calling-conventions
+++ a/fs/nilfs2/direct.c
@@ -91,8 +91,8 @@ static int nilfs_direct_prepare_insert(s
 	int ret;
 
 	if (direct->d_ops->dop_find_target != NULL)
-		req->bpr_ptr = (*direct->d_ops->dop_find_target)(direct, key);
-	ret = (*direct->d_bmap.b_pops->bpop_prepare_alloc_ptr)(&direct->d_bmap,
+		req->bpr_ptr = direct->d_ops->dop_find_target(direct, key);
+	ret = direct->d_bmap.b_pops->bpop_prepare_alloc_ptr(&direct->d_bmap,
 							       req);
 	if (ret < 0)
 		return ret;
@@ -112,7 +112,7 @@ static void nilfs_direct_commit_insert(s
 	set_buffer_nilfs_volatile(bh);
 
 	if (direct->d_bmap.b_pops->bpop_commit_alloc_ptr != NULL)
-		(*direct->d_bmap.b_pops->bpop_commit_alloc_ptr)(
+		direct->d_bmap.b_pops->bpop_commit_alloc_ptr(
 			&direct->d_bmap, req);
 	nilfs_direct_set_ptr(direct, key, req->bpr_ptr);
 
@@ -120,7 +120,7 @@ static void nilfs_direct_commit_insert(s
 		nilfs_bmap_set_dirty(&direct->d_bmap);
 
 	if (direct->d_ops->dop_set_target != NULL)
-		(*direct->d_ops->dop_set_target)(direct, key, req->bpr_ptr);
+		direct->d_ops->dop_set_target(direct, key, req->bpr_ptr);
 }
 
 static int nilfs_direct_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
@@ -154,7 +154,7 @@ static int nilfs_direct_prepare_delete(s
 
 	if (direct->d_bmap.b_pops->bpop_prepare_end_ptr != NULL) {
 		req->bpr_ptr = nilfs_direct_get_ptr(direct, key);
-		ret = (*direct->d_bmap.b_pops->bpop_prepare_end_ptr)(
+		ret = direct->d_bmap.b_pops->bpop_prepare_end_ptr(
 			&direct->d_bmap, req);
 		if (ret < 0)
 			return ret;
@@ -169,7 +169,7 @@ static void nilfs_direct_commit_delete(s
 				       __u64 key)
 {
 	if (direct->d_bmap.b_pops->bpop_commit_end_ptr != NULL)
-		(*direct->d_bmap.b_pops->bpop_commit_end_ptr)(
+		direct->d_bmap.b_pops->bpop_commit_end_ptr(
 			&direct->d_bmap, req);
 	nilfs_direct_set_ptr(direct, key, NILFS_BMAP_INVALID_PTR);
 }
@@ -255,13 +255,13 @@ int nilfs_direct_delete_and_convert(stru
 	/* no need to allocate any resource for conversion */
 
 	/* delete */
-	ret = (*bmap->b_ops->bop_delete)(bmap, key);
+	ret = bmap->b_ops->bop_delete(bmap, key);
 	if (ret < 0)
 		return ret;
 
 	/* free resources */
 	if (bmap->b_ops->bop_clear != NULL)
-		(*bmap->b_ops->bop_clear)(bmap);
+		bmap->b_ops->bop_clear(bmap);
 
 	/* convert */
 	direct = (struct nilfs_direct *)bmap;
@@ -314,7 +314,7 @@ static int nilfs_direct_propagate(const 
 
 	direct = (struct nilfs_direct *)bmap;
 	return (direct->d_ops->dop_propagate != NULL) ?
-		(*direct->d_ops->dop_propagate)(direct, bh) :
+		direct->d_ops->dop_propagate(direct, bh) :
 		0;
 }
 
@@ -328,12 +328,12 @@ static int nilfs_direct_assign_v(struct 
 	int ret;
 
 	req.bpr_ptr = ptr;
-	ret = (*direct->d_bmap.b_pops->bpop_prepare_start_ptr)(
+	ret = direct->d_bmap.b_pops->bpop_prepare_start_ptr(
 		&direct->d_bmap, &req);
 	if (ret < 0)
 		return ret;
-	(*direct->d_bmap.b_pops->bpop_commit_start_ptr)(&direct->d_bmap,
-							&req, blocknr);
+	direct->d_bmap.b_pops->bpop_commit_start_ptr(&direct->d_bmap,
+						     &req, blocknr);
 
 	binfo->bi_v.bi_vblocknr = nilfs_bmap_ptr_to_dptr(ptr);
 	binfo->bi_v.bi_blkoff = nilfs_bmap_key_to_dkey(key);
@@ -370,8 +370,8 @@ static int nilfs_direct_assign(struct ni
 	ptr = nilfs_direct_get_ptr(direct, key);
 	BUG_ON(ptr == NILFS_BMAP_INVALID_PTR);
 
-	return (*direct->d_ops->dop_assign)(direct, key, ptr, bh,
-					    blocknr, binfo);
+	return direct->d_ops->dop_assign(direct, key, ptr, bh,
+					 blocknr, binfo);
 }
 
 static const struct nilfs_bmap_operations nilfs_direct_ops = {
diff -puN fs/nilfs2/ioctl.c~nilfs2-clean-up-indirect-function-calling-conventions fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~nilfs2-clean-up-indirect-function-calling-conventions
+++ a/fs/nilfs2/ioctl.c
@@ -71,7 +71,7 @@ static int nilfs_ioctl_wrap_copy(struct 
 			break;
 		}
 		ppos = pos;
-		nr = (*dofunc)(nilfs, &pos, argv->v_flags, buf, argv->v_size,
+		nr = dofunc(nilfs, &pos, argv->v_flags, buf, argv->v_size,
 			       n);
 		if (nr < 0) {
 			ret = nr;
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

origin.patch
repeatable-slab-corruption-with-ltp-msgctl08.patch
linux-next.patch
slab-leaks3-default-y.patch

