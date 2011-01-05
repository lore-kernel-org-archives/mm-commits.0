From: akpm@linux-foundation.org
Subject: [folded] reiser4-rename-quota-methods.patch removed from -mm tree
Date: Tue, 04 Jan 2011 16:35:55 -0800
Message-ID: <201101050035.p050ZtQg000697@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750957Ab1AEAf6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 19:35:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward.shishkin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: rename quota methods
has been removed from the -mm tree.  Its filename was
     reiser4-rename-quota-methods.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: rename quota methods
From: Edward Shishkin <edward.shishkin@gmail.com>

Rename quota methods.

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file_plugin_common.c   |    4 ++--
 fs/reiser4/plugin/inode_ops.c            |   20 ++++++++++----------
 fs/reiser4/plugin/item/cde.c             |    4 ++--
 fs/reiser4/plugin/item/extent_file_ops.c |   12 ++++++------
 fs/reiser4/plugin/item/extent_item_ops.c |    2 +-
 fs/reiser4/plugin/item/sde.c             |    4 ++--
 fs/reiser4/plugin/item/tail.c            |   16 ++++++++--------
 7 files changed, 31 insertions(+), 31 deletions(-)

diff -puN fs/reiser4/plugin/file_plugin_common.c~reiser4-rename-quota-methods fs/reiser4/plugin/file_plugin_common.c
--- a/fs/reiser4/plugin/file_plugin_common.c~reiser4-rename-quota-methods
+++ a/fs/reiser4/plugin/file_plugin_common.c
@@ -944,8 +944,8 @@ common_object_delete_no_reserve(struct i
 	if (!reiser4_inode_get_flag(inode, REISER4_NO_SD)) {
 		reiser4_key sd_key;
 
-		vfs_dq_free_inode(inode);
-		vfs_dq_drop(inode);
+		dquot_free_inode(inode);
+		dquot_drop(inode);
 
 		build_sd_key(inode, &sd_key);
 		result =
diff -puN fs/reiser4/plugin/inode_ops.c~reiser4-rename-quota-methods fs/reiser4/plugin/inode_ops.c
--- a/fs/reiser4/plugin/inode_ops.c~reiser4-rename-quota-methods
+++ a/fs/reiser4/plugin/inode_ops.c
@@ -453,7 +453,7 @@ int reiser4_setattr_common(struct dentry
 		if ((attr->ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid)
 		    || (attr->ia_valid & ATTR_GID
 			&& attr->ia_gid != inode->i_gid)) {
-			result = vfs_dq_transfer(inode, attr) ? -EDQUOT : 0;
+			result = dquot_transfer(inode, attr) ? -EDQUOT : 0;
 			if (result) {
 				context_set_commit_async(ctx);
 				reiser4_exit_context(ctx);
@@ -593,8 +593,8 @@ static int do_create_vfs_child(reiser4_o
 	/* So that on error iput will be called. */
 	*retobj = object;
 
-	if (vfs_dq_alloc_inode(object)) {
-		vfs_dq_drop(object);
+	if (dquot_alloc_inode(object)) {
+		dquot_drop(object);
 		object->i_flags |= S_NOQUOTA;
 		return RETERR(-EDQUOT);
 	}
@@ -608,7 +608,7 @@ static int do_create_vfs_child(reiser4_o
 	if (result) {
 		warning("nikita-431", "Cannot install plugin %i on %llx",
 			data->id, (unsigned long long)get_inode_oid(object));
-		vfs_dq_free_inode(object);
+		dquot_free_inode(object);
 		object->i_flags |= S_NOQUOTA;
 		return result;
 	}
@@ -617,7 +617,7 @@ static int do_create_vfs_child(reiser4_o
 	obj_plug = inode_file_plugin(object);
 
 	if (obj_plug->create_object == NULL) {
-		vfs_dq_free_inode(object);
+		dquot_free_inode(object);
 		object->i_flags |= S_NOQUOTA;
 		return RETERR(-EPERM);
 	}
@@ -636,7 +636,7 @@ static int do_create_vfs_child(reiser4_o
 		warning("nikita-432", "Cannot inherit from %llx to %llx",
 			(unsigned long long)get_inode_oid(parent),
 			(unsigned long long)get_inode_oid(object));
-		vfs_dq_free_inode(object);
+		dquot_free_inode(object);
 		object->i_flags |= S_NOQUOTA;
 		return result;
 	}
@@ -652,7 +652,7 @@ static int do_create_vfs_child(reiser4_o
 	/* obtain directory plugin (if any) for new object. */
 	obj_dir = inode_dir_plugin(object);
 	if (obj_dir != NULL && obj_dir->init == NULL) {
-		vfs_dq_free_inode(object);
+		dquot_free_inode(object);
 		object->i_flags |= S_NOQUOTA;
 		return RETERR(-EPERM);
 	}
@@ -661,7 +661,7 @@ static int do_create_vfs_child(reiser4_o
 
 	reserve = estimate_create_vfs_object(parent, object);
 	if (reiser4_grab_space(reserve, BA_CAN_COMMIT)) {
-		vfs_dq_free_inode(object);
+		dquot_free_inode(object);
 		object->i_flags |= S_NOQUOTA;
 		return RETERR(-ENOSPC);
 	}
@@ -692,7 +692,7 @@ static int do_create_vfs_child(reiser4_o
 			warning("nikita-2219",
 				"Failed to create sd for %llu",
 				(unsigned long long)get_inode_oid(object));
-		vfs_dq_free_inode(object);
+		dquot_free_inode(object);
 		object->i_flags |= S_NOQUOTA;
 		return result;
 	}
@@ -735,7 +735,7 @@ static int do_create_vfs_child(reiser4_o
 	 */
 	reiser4_update_sd(object);
 	if (result != 0) {
-		vfs_dq_free_inode(object);
+		dquot_free_inode(object);
 		object->i_flags |= S_NOQUOTA;
 		/* if everything was ok (result == 0), parent stat-data is
 		 * already updated above (update_parent_dir()) */
diff -puN fs/reiser4/plugin/item/cde.c~reiser4-rename-quota-methods fs/reiser4/plugin/item/cde.c
--- a/fs/reiser4/plugin/item/cde.c~reiser4-rename-quota-methods
+++ a/fs/reiser4/plugin/item/cde.c
@@ -932,7 +932,7 @@ int add_entry_cde(struct inode *dir /* d
 	data.length = estimate_cde(result ? coord : NULL, &data);
 
 	/* NOTE-NIKITA quota plugin? */
-	if (vfs_dq_alloc_space_nodirty(dir, cde_bytes(result, &data)))
+	if (dquot_alloc_space_nodirty(dir, cde_bytes(result, &data)))
 		return RETERR(-EDQUOT);
 
 	if (result)
@@ -983,7 +983,7 @@ int rem_entry_cde(struct inode *dir /* d
 	    kill_node_content(coord, &shadow, NULL, NULL, NULL, NULL, NULL, 0);
 	if (result == 0) {
 		/* NOTE-NIKITA quota plugin? */
-		vfs_dq_free_space_nodirty(dir, length);
+		dquot_free_space_nodirty(dir, length);
 	}
 	return result;
 }
diff -puN fs/reiser4/plugin/item/extent_file_ops.c~reiser4-rename-quota-methods fs/reiser4/plugin/item/extent_file_ops.c
--- a/fs/reiser4/plugin/item/extent_file_ops.c~reiser4-rename-quota-methods
+++ a/fs/reiser4/plugin/item/extent_file_ops.c
@@ -260,8 +260,8 @@ static int append_last_extent(uf_coord_t
 
 	assert("", get_key_offset(key) == (loff_t)index_jnode(jnodes[0]) * PAGE_CACHE_SIZE);
 
-	result = vfs_dq_alloc_block_nodirty(mapping_jnode(jnodes[0])->host,
-					    count);
+	result = dquot_alloc_block_nodirty(mapping_jnode(jnodes[0])->host,
+					   count);
 	BUG_ON(result != 0);
 
 	switch (state_of_extent(ext)) {
@@ -408,8 +408,8 @@ static int insert_first_extent(uf_coord_
 	if (count == 0)
 		return 0;
 
-	result = vfs_dq_alloc_block_nodirty(mapping_jnode(jnodes[0])->host,
-					    count);
+	result = dquot_alloc_block_nodirty(mapping_jnode(jnodes[0])->host,
+					   count);
 	BUG_ON(result != 0);
 
 	/*
@@ -623,8 +623,8 @@ static int overwrite_one_block(uf_coord_
 		break;
 
 	case HOLE_EXTENT:
-		result = vfs_dq_alloc_block_nodirty(mapping_jnode(node)->host,
-						    1);
+		result = dquot_alloc_block_nodirty(mapping_jnode(node)->host,
+						   1);
 		BUG_ON(result != 0);
 		result = plug_hole(uf_coord, key, &how);
 		if (result)
diff -puN fs/reiser4/plugin/item/extent_item_ops.c~reiser4-rename-quota-methods fs/reiser4/plugin/item/extent_item_ops.c
--- a/fs/reiser4/plugin/item/extent_item_ops.c~reiser4-rename-quota-methods
+++ a/fs/reiser4/plugin/item/extent_item_ops.c
@@ -468,7 +468,7 @@ kill_hook_extent(const coord_t * coord, 
 			length = to_off - offset;
 		}
 
-		vfs_dq_free_block_nodirty(inode, length);
+		dquot_free_block_nodirty(inode, length);
 
 		if (state_of_extent(ext) == UNALLOCATED_EXTENT) {
 			/* some jnodes corresponding to this unallocated extent */
diff -puN fs/reiser4/plugin/item/sde.c~reiser4-rename-quota-methods fs/reiser4/plugin/item/sde.c
--- a/fs/reiser4/plugin/item/sde.c~reiser4-rename-quota-methods
+++ a/fs/reiser4/plugin/item/sde.c
@@ -120,7 +120,7 @@ int add_entry_de(struct inode *dir /* di
 	data.iplug = item_plugin_by_id(SIMPLE_DIR_ENTRY_ID);
 
 	/* NOTE-NIKITA quota plugin */
-	if (vfs_dq_alloc_space_nodirty(dir, data.length))
+	if (dquot_alloc_space_nodirty(dir, data.length))
 		return -EDQUOT;
 
 	result = insert_by_coord(coord, &data, &entry->key, lh, 0 /*flags */ );
@@ -168,7 +168,7 @@ int rem_entry_de(struct inode *dir /* di
 	    kill_node_content(coord, &shadow, NULL, NULL, NULL, NULL, NULL, 0);
 	if (result == 0) {
 		/* NOTE-NIKITA quota plugin */
-		vfs_dq_free_space_nodirty(dir, length);
+		dquot_free_space_nodirty(dir, length);
 	}
 	return result;
 }
diff -puN fs/reiser4/plugin/item/tail.c~reiser4-rename-quota-methods fs/reiser4/plugin/item/tail.c
--- a/fs/reiser4/plugin/item/tail.c~reiser4-rename-quota-methods
+++ a/fs/reiser4/plugin/item/tail.c
@@ -494,11 +494,11 @@ static ssize_t insert_first_tail(struct 
 		 * were real data which are all zeros. Therefore we have to
 		 * allocate quota here as well
 		 */
-		if (vfs_dq_alloc_space_nodirty(inode, flow->length))
+		if (dquot_alloc_space_nodirty(inode, flow->length))
 			return RETERR(-EDQUOT);
 		result = reiser4_insert_flow(coord, lh, flow);
 		if (flow->length)
-			vfs_dq_free_space_nodirty(inode, flow->length);
+			dquot_free_space_nodirty(inode, flow->length);
 
 		uf_info = unix_file_inode_data(inode);
 
@@ -518,13 +518,13 @@ static ssize_t insert_first_tail(struct 
 	}
 
 	/* check quota before appending data */
-	if (vfs_dq_alloc_space_nodirty(inode, flow->length))
+	if (dquot_alloc_space_nodirty(inode, flow->length))
 		return RETERR(-EDQUOT);
 
 	to_write = flow->length;
 	result = reiser4_insert_flow(coord, lh, flow);
 	if (flow->length)
-		vfs_dq_free_space_nodirty(inode, flow->length);
+		dquot_free_space_nodirty(inode, flow->length);
 	return (to_write - flow->length) ? (to_write - flow->length) : result;
 }
 
@@ -553,22 +553,22 @@ static ssize_t append_tail(struct inode 
 		 * were real data which are all zeros. Therefore we have to
 		 * allocate quota here as well
 		 */
-		if (vfs_dq_alloc_space_nodirty(inode, flow->length))
+		if (dquot_alloc_space_nodirty(inode, flow->length))
 			return RETERR(-EDQUOT);
 		result = reiser4_insert_flow(coord, lh, flow);
 		if (flow->length)
-			vfs_dq_free_space_nodirty(inode, flow->length);
+			dquot_free_space_nodirty(inode, flow->length);
 		return result;
 	}
 
 	/* check quota before appending data */
-	if (vfs_dq_alloc_space_nodirty(inode, flow->length))
+	if (dquot_alloc_space_nodirty(inode, flow->length))
 		return RETERR(-EDQUOT);
 
 	to_write = flow->length;
 	result = reiser4_insert_flow(coord, lh, flow);
 	if (flow->length)
-		vfs_dq_free_space_nodirty(inode, flow->length);
+		dquot_free_space_nodirty(inode, flow->length);
 	return (to_write - flow->length) ? (to_write - flow->length) : result;
 }
 
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

linux-next.patch
reiserfs-make-sure-va_end-is-always-called-after-va_start.patch
vfs-add-super-operation-writeback_inodes.patch
vfs-add-super-operation-writeback_inodes-fix.patch
vfs-take-2add-set_page_dirty_notag.patch
vfs-change-writeback_inodes-signature.patch
reiser4.patch
reiser4-remove-inode_setattr.patch
reiser4-change-fsync-signature.patch
reiser4-writeback_inodes-implementation.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-writeback_inodes-implementation-adjust-to-writeback-changes.patch
reiser4-fixup-checkin-checkout-jnodes-for-entd.patch
reiser4-fixups.patch
reiser4-broke.patch

