Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93725C433DB
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 10:51:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 643AA64F1C
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 10:51:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhCSKvI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 06:51:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229978AbhCSKuz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Mar 2021 06:50:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF8FA64EFC;
        Fri, 19 Mar 2021 10:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616151055;
        bh=Pr45y6cfXenajK8a4WGCxzt1fKQi5BzXGC1t0D0Bz3U=;
        h=Date:From:To:Subject:From;
        b=a73wGrbMxFil5JZjRnoaqTq7RcE0HzW7nHJ6NGGks0bzgmspuL5O9lVR2hf/udmLb
         AnIvLbcUlnzCR/ROLCzRi7/xTjxhmwBR4aMF95rWGH9AlJbVhlkwgzOj1iKj/440It
         Vpm9fetEYZnUdX4MRd9WwxtA2lSujJq14n30/GpY=
Date:   Fri, 19 Mar 2021 03:50:54 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20210319105054.pkcw6ZphP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/can/usb/peak_usb/pcan_usb_fd.c |    3 
 fs/btrfs/ctree.c                           |  295 -------------------
 fs/btrfs/extent-tree.c                     |    8 
 3 files changed, 306 deletions(-)

--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c~linux-next-git-rejects
+++ a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -16,14 +16,11 @@
 #include "pcan_usb_core.h"
 #include "pcan_usb_pro.h"
 
-<<<<<<< HEAD
-=======
 MODULE_SUPPORTED_DEVICE("PEAK-System PCAN-USB FD adapter");
 MODULE_SUPPORTED_DEVICE("PEAK-System PCAN-USB Pro FD adapter");
 MODULE_SUPPORTED_DEVICE("PEAK-System PCAN-Chip USB");
 MODULE_SUPPORTED_DEVICE("PEAK-System PCAN-USB X6 adapter");
 
->>>>>>> linux-next/akpm-base
 #define PCAN_USBPROFD_CHANNEL_COUNT	2
 #define PCAN_USBFD_CHANNEL_COUNT	1
 
--- a/fs/btrfs/ctree.c~linux-next-git-rejects
+++ a/fs/btrfs/ctree.c
@@ -537,301 +537,6 @@ static noinline int __btrfs_cow_block(st
 	return 0;
 }
 
-<<<<<<< HEAD
-/*
- * returns the logical address of the oldest predecessor of the given root.
- * entries older than time_seq are ignored.
- */
-static struct tree_mod_elem *__tree_mod_log_oldest_root(
-		struct extent_buffer *eb_root, u64 time_seq)
-{
-	struct tree_mod_elem *tm;
-	struct tree_mod_elem *found = NULL;
-	u64 root_logical = eb_root->start;
-	int looped = 0;
-
-	if (!time_seq)
-		return NULL;
-
-	/*
-	 * the very last operation that's logged for a root is the
-	 * replacement operation (if it is replaced at all). this has
-	 * the logical address of the *new* root, making it the very
-	 * first operation that's logged for this root.
-	 */
-	while (1) {
-		tm = tree_mod_log_search_oldest(eb_root->fs_info, root_logical,
-						time_seq);
-		if (!looped && !tm)
-			return NULL;
-		/*
-		 * if there are no tree operation for the oldest root, we simply
-		 * return it. this should only happen if that (old) root is at
-		 * level 0.
-		 */
-		if (!tm)
-			break;
-
-		/*
-		 * if there's an operation that's not a root replacement, we
-		 * found the oldest version of our root. normally, we'll find a
-		 * MOD_LOG_KEY_REMOVE_WHILE_FREEING operation here.
-		 */
-		if (tm->op != MOD_LOG_ROOT_REPLACE)
-			break;
-
-		found = tm;
-		root_logical = tm->old_root.logical;
-		looped = 1;
-	}
-
-	/* if there's no old root to return, return what we found instead */
-	if (!found)
-		found = tm;
-
-	return found;
-}
-
-/*
- * tm is a pointer to the first operation to rewind within eb. then, all
- * previous operations will be rewound (until we reach something older than
- * time_seq).
- */
-static void
-__tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
-		      u64 time_seq, struct tree_mod_elem *first_tm)
-{
-	u32 n;
-	struct rb_node *next;
-	struct tree_mod_elem *tm = first_tm;
-	unsigned long o_dst;
-	unsigned long o_src;
-	unsigned long p_size = sizeof(struct btrfs_key_ptr);
-
-	n = btrfs_header_nritems(eb);
-	read_lock(&fs_info->tree_mod_log_lock);
-	while (tm && tm->seq >= time_seq) {
-		/*
-		 * all the operations are recorded with the operator used for
-		 * the modification. as we're going backwards, we do the
-		 * opposite of each operation here.
-		 */
-		switch (tm->op) {
-		case MOD_LOG_KEY_REMOVE_WHILE_FREEING:
-			BUG_ON(tm->slot < n);
-			fallthrough;
-		case MOD_LOG_KEY_REMOVE_WHILE_MOVING:
-		case MOD_LOG_KEY_REMOVE:
-			btrfs_set_node_key(eb, &tm->key, tm->slot);
-			btrfs_set_node_blockptr(eb, tm->slot, tm->blockptr);
-			btrfs_set_node_ptr_generation(eb, tm->slot,
-						      tm->generation);
-			n++;
-			break;
-		case MOD_LOG_KEY_REPLACE:
-			BUG_ON(tm->slot >= n);
-			btrfs_set_node_key(eb, &tm->key, tm->slot);
-			btrfs_set_node_blockptr(eb, tm->slot, tm->blockptr);
-			btrfs_set_node_ptr_generation(eb, tm->slot,
-						      tm->generation);
-			break;
-		case MOD_LOG_KEY_ADD:
-			/* if a move operation is needed it's in the log */
-			n--;
-			break;
-		case MOD_LOG_MOVE_KEYS:
-			o_dst = btrfs_node_key_ptr_offset(tm->slot);
-			o_src = btrfs_node_key_ptr_offset(tm->move.dst_slot);
-			memmove_extent_buffer(eb, o_dst, o_src,
-					      tm->move.nr_items * p_size);
-			break;
-		case MOD_LOG_ROOT_REPLACE:
-			/*
-			 * this operation is special. for roots, this must be
-			 * handled explicitly before rewinding.
-			 * for non-roots, this operation may exist if the node
-			 * was a root: root A -> child B; then A gets empty and
-			 * B is promoted to the new root. in the mod log, we'll
-			 * have a root-replace operation for B, a tree block
-			 * that is no root. we simply ignore that operation.
-			 */
-			break;
-		}
-		next = rb_next(&tm->node);
-		if (!next)
-			break;
-		tm = rb_entry(next, struct tree_mod_elem, node);
-		if (tm->logical != first_tm->logical)
-			break;
-	}
-	read_unlock(&fs_info->tree_mod_log_lock);
-	btrfs_set_header_nritems(eb, n);
-}
-
-/*
- * Called with eb read locked. If the buffer cannot be rewound, the same buffer
- * is returned. If rewind operations happen, a fresh buffer is returned. The
- * returned buffer is always read-locked. If the returned buffer is not the
- * input buffer, the lock on the input buffer is released and the input buffer
- * is freed (its refcount is decremented).
- */
-static struct extent_buffer *
-tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
-		    struct extent_buffer *eb, u64 time_seq)
-{
-	struct extent_buffer *eb_rewin;
-	struct tree_mod_elem *tm;
-
-	if (!time_seq)
-		return eb;
-
-	if (btrfs_header_level(eb) == 0)
-		return eb;
-
-	tm = tree_mod_log_search(fs_info, eb->start, time_seq);
-	if (!tm)
-		return eb;
-
-	if (tm->op == MOD_LOG_KEY_REMOVE_WHILE_FREEING) {
-		BUG_ON(tm->slot != 0);
-		eb_rewin = alloc_dummy_extent_buffer(fs_info, eb->start);
-		if (!eb_rewin) {
-			btrfs_tree_read_unlock(eb);
-			free_extent_buffer(eb);
-			return NULL;
-		}
-		btrfs_set_header_bytenr(eb_rewin, eb->start);
-		btrfs_set_header_backref_rev(eb_rewin,
-					     btrfs_header_backref_rev(eb));
-		btrfs_set_header_owner(eb_rewin, btrfs_header_owner(eb));
-		btrfs_set_header_level(eb_rewin, btrfs_header_level(eb));
-	} else {
-		eb_rewin = btrfs_clone_extent_buffer(eb);
-		if (!eb_rewin) {
-			btrfs_tree_read_unlock(eb);
-			free_extent_buffer(eb);
-			return NULL;
-		}
-	}
-
-	btrfs_tree_read_unlock(eb);
-	free_extent_buffer(eb);
-
-	btrfs_set_buffer_lockdep_class(btrfs_header_owner(eb_rewin),
-				       eb_rewin, btrfs_header_level(eb_rewin));
-	btrfs_tree_read_lock(eb_rewin);
-	__tree_mod_log_rewind(fs_info, eb_rewin, time_seq, tm);
-	WARN_ON(btrfs_header_nritems(eb_rewin) >
-		BTRFS_NODEPTRS_PER_BLOCK(fs_info));
-
-	return eb_rewin;
-}
-
-/*
- * get_old_root() rewinds the state of @root's root node to the given @time_seq
- * value. If there are no changes, the current root->root_node is returned. If
- * anything changed in between, there's a fresh buffer allocated on which the
- * rewind operations are done. In any case, the returned buffer is read locked.
- * Returns NULL on error (with no locks held).
- */
-static inline struct extent_buffer *
-get_old_root(struct btrfs_root *root, u64 time_seq)
-{
-	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct tree_mod_elem *tm;
-	struct extent_buffer *eb = NULL;
-	struct extent_buffer *eb_root;
-	u64 eb_root_owner = 0;
-	struct extent_buffer *old;
-	struct tree_mod_root *old_root = NULL;
-	u64 old_generation = 0;
-	u64 logical;
-	int level;
-
-	eb_root = btrfs_read_lock_root_node(root);
-	tm = __tree_mod_log_oldest_root(eb_root, time_seq);
-	if (!tm)
-		return eb_root;
-
-	if (tm->op == MOD_LOG_ROOT_REPLACE) {
-		old_root = &tm->old_root;
-		old_generation = tm->generation;
-		logical = old_root->logical;
-		level = old_root->level;
-	} else {
-		logical = eb_root->start;
-		level = btrfs_header_level(eb_root);
-	}
-
-	tm = tree_mod_log_search(fs_info, logical, time_seq);
-	if (old_root && tm && tm->op != MOD_LOG_KEY_REMOVE_WHILE_FREEING) {
-		btrfs_tree_read_unlock(eb_root);
-		free_extent_buffer(eb_root);
-		old = read_tree_block(fs_info, logical, root->root_key.objectid,
-				      0, level, NULL);
-		if (WARN_ON(IS_ERR(old) || !extent_buffer_uptodate(old))) {
-			if (!IS_ERR(old))
-				free_extent_buffer(old);
-			btrfs_warn(fs_info,
-				   "failed to read tree block %llu from get_old_root",
-				   logical);
-		} else {
-			btrfs_tree_read_lock(old);
-			eb = btrfs_clone_extent_buffer(old);
-			btrfs_tree_read_unlock(old);
-			free_extent_buffer(old);
-		}
-	} else if (old_root) {
-		eb_root_owner = btrfs_header_owner(eb_root);
-		btrfs_tree_read_unlock(eb_root);
-		free_extent_buffer(eb_root);
-		eb = alloc_dummy_extent_buffer(fs_info, logical);
-	} else {
-		eb = btrfs_clone_extent_buffer(eb_root);
-		btrfs_tree_read_unlock(eb_root);
-		free_extent_buffer(eb_root);
-	}
-
-	if (!eb)
-		return NULL;
-	if (old_root) {
-		btrfs_set_header_bytenr(eb, eb->start);
-		btrfs_set_header_backref_rev(eb, BTRFS_MIXED_BACKREF_REV);
-		btrfs_set_header_owner(eb, eb_root_owner);
-		btrfs_set_header_level(eb, old_root->level);
-		btrfs_set_header_generation(eb, old_generation);
-	}
-	btrfs_set_buffer_lockdep_class(btrfs_header_owner(eb), eb,
-				       btrfs_header_level(eb));
-	btrfs_tree_read_lock(eb);
-	if (tm)
-		__tree_mod_log_rewind(fs_info, eb, time_seq, tm);
-	else
-		WARN_ON(btrfs_header_level(eb) != 0);
-	WARN_ON(btrfs_header_nritems(eb) > BTRFS_NODEPTRS_PER_BLOCK(fs_info));
-
-	return eb;
-}
-
-int btrfs_old_root_level(struct btrfs_root *root, u64 time_seq)
-{
-	struct tree_mod_elem *tm;
-	int level;
-	struct extent_buffer *eb_root = btrfs_root_node(root);
-
-	tm = __tree_mod_log_oldest_root(eb_root, time_seq);
-	if (tm && tm->op == MOD_LOG_ROOT_REPLACE) {
-		level = tm->old_root.level;
-	} else {
-		level = btrfs_header_level(eb_root);
-	}
-	free_extent_buffer(eb_root);
-
-	return level;
-}
-
-=======
->>>>>>> linux-next/akpm-base
 static inline int should_cow_block(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root,
 				   struct extent_buffer *buf)
--- a/fs/btrfs/extent-tree.c~linux-next-git-rejects
+++ a/fs/btrfs/extent-tree.c
@@ -3342,17 +3342,9 @@ void btrfs_free_tree_block(struct btrfs_
 		 * find a node pointing to this leaf and record operations that
 		 * point to this leaf.
 		 */
-<<<<<<< HEAD
-		if (btrfs_header_level(buf) == 0) {
-			read_lock(&fs_info->tree_mod_log_lock);
-			must_pin = !list_empty(&fs_info->tree_mod_seq_list);
-			read_unlock(&fs_info->tree_mod_log_lock);
-		}
-=======
 		if (btrfs_header_level(buf) == 0 &&
 		    test_bit(BTRFS_FS_TREE_MOD_LOG_USERS, &fs_info->flags))
 			must_pin = true;
->>>>>>> linux-next/akpm-base
 
 		if (must_pin || btrfs_is_zoned(fs_info)) {
 			btrfs_redirty_list_add(trans->transaction, buf);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
kasan-remove-redundant-config-option-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

