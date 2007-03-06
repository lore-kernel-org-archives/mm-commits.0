From: akpm@linux-foundation.org
Subject: - reiser4-format-subversion-numbers-heir-set-and-file-conversion.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:00:28 -0800
Message-ID: <200703060200.l2620Sd1008729@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46683 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965693AbXCFCBn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:01:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward@namesys.com, reiser@namesys.com, mm-commits@vger.kernel.org


The patch titled
     Reiser4: format subversion numbers, heir set and file conversion support
has been removed from the -mm tree.  Its filename was
     reiser4-format-subversion-numbers-heir-set-and-file-conversion.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: Reiser4: format subversion numbers, heir set and file conversion support
From: Edward Shishkin <edward@namesys.com>

This patch addresses numerous questions about compatibility
in accordance with this design document:
http://www.namesys.com/v4/format.txt

Also it is important to add heir set support right now to
keep the compatibility when developing within format40.

. Managing subversion numbers for disk format40 (for fsck
  needs and compatibility issues). Supporting format 4.0.0.

. Supporting heir_set, i.e. additional plugin table optionally
  binded to an object of the semantic tree for non-default
  inheritance (by default, children inherit main plugin table
  (pset) of their ancestor).

. Added on-the-fly file conversion (converting fragments to
  extents and passing management to unix-file plugin for
  incompressible files).

Signed-off-by: Edward Shishkin <edward@namesys.com>
Cc: Hans Reiser <reiser@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/Makefile                           |    5 
 fs/reiser4/as_ops.c                           |    3 
 fs/reiser4/block_alloc.c                      |   11 
 fs/reiser4/carry_ops.c                        |   18 
 fs/reiser4/context.c                          |   11 
 fs/reiser4/context.h                          |    2 
 fs/reiser4/estimate.c                         |    6 
 fs/reiser4/forward.h                          |    3 
 fs/reiser4/init_super.c                       |   39 -
 fs/reiser4/inode.c                            |   67 -
 fs/reiser4/inode.h                            |   37 
 fs/reiser4/jnode.c                            |    5 
 fs/reiser4/jnode.h                            |    1 
 fs/reiser4/page_cache.h                       |   10 
 fs/reiser4/plugin/cluster.c                   |   23 
 fs/reiser4/plugin/cluster.h                   |   33 
 fs/reiser4/plugin/compress/compress.c         |   26 
 fs/reiser4/plugin/compress/compress_mode.c    |   31 
 fs/reiser4/plugin/disk_format/disk_format.c   |    3 
 fs/reiser4/plugin/disk_format/disk_format40.c |  128 +++
 fs/reiser4/plugin/disk_format/disk_format40.h |   22 
 fs/reiser4/plugin/fibration.c                 |    9 
 fs/reiser4/plugin/file/cryptcompress.c        |  486 ++++++-------
 fs/reiser4/plugin/file/cryptcompress.h        |   39 -
 fs/reiser4/plugin/file/file.c                 |   28 
 fs/reiser4/plugin/file/file.h                 |   60 +
 fs/reiser4/plugin/file/file_conversion.c      |  594 ++++++++++++++++
 fs/reiser4/plugin/file/tail_conversion.c      |    2 
 fs/reiser4/plugin/file_ops_readdir.c          |    8 
 fs/reiser4/plugin/file_plugin_common.c        |  101 ++
 fs/reiser4/plugin/hash.c                      |   13 
 fs/reiser4/plugin/inode_ops.c                 |   15 
 fs/reiser4/plugin/inode_ops_rename.c          |    6 
 fs/reiser4/plugin/item/ctail.c                |   62 -
 fs/reiser4/plugin/item/ctail.h                |    8 
 fs/reiser4/plugin/item/item.c                 |   35 
 fs/reiser4/plugin/item/item.h                 |   17 
 fs/reiser4/plugin/item/static_stat.c          |  142 ++-
 fs/reiser4/plugin/item/static_stat.h          |   25 
 fs/reiser4/plugin/item/tail.c                 |    4 
 fs/reiser4/plugin/object.c                    |   41 -
 fs/reiser4/plugin/object.h                    |    2 
 fs/reiser4/plugin/plugin.c                    |  118 ++-
 fs/reiser4/plugin/plugin.h                    |   80 --
 fs/reiser4/plugin/plugin_header.h             |   12 
 fs/reiser4/plugin/plugin_set.c                |  176 ++--
 fs/reiser4/plugin/plugin_set.h                |   27 
 fs/reiser4/plugin/regular.c                   |   44 -
 fs/reiser4/plugin/space/bitmap.c              |   29 
 fs/reiser4/search.c                           |    4 
 fs/reiser4/status_flags.c                     |    5 
 fs/reiser4/super.h                            |   10 
 fs/reiser4/super_ops.c                        |   12 
 fs/reiser4/znode.c                            |    2 
 54 files changed, 1844 insertions(+), 856 deletions(-)

diff -puN fs/reiser4/Makefile~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/Makefile
--- a/fs/reiser4/Makefile~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/Makefile
@@ -59,6 +59,7 @@ reiser4-y := \
 		   plugin/file_plugin_common.o \
 		   plugin/file/file.o \
 		   plugin/file/tail_conversion.o \
+		   plugin/file/file_conversion.o \
 		   plugin/file/symlink.o \
 		   plugin/file/cryptcompress.o \
 		   plugin/dir_plugin_common.o \
@@ -94,7 +95,5 @@ reiser4-y := \
 		   plugin/space/bitmap.o \
            \
 		   plugin/disk_format/disk_format40.o \
-		   plugin/disk_format/disk_format.o \
-	   \
-		   plugin/regular.o
+		   plugin/disk_format/disk_format.o
 
diff -puN fs/reiser4/as_ops.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/as_ops.c
--- a/fs/reiser4/as_ops.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/as_ops.c
@@ -160,7 +160,8 @@ void reiser4_invalidatepage(struct page 
 	       page->mapping == jnode_get_mapping(jnode_by_page(page)));
 	assert("", jprivate(page) != NULL);
 	assert("", ergo(inode_file_plugin(inode) !=
-			file_plugin_by_id(CRC_FILE_PLUGIN_ID), offset == 0));
+			file_plugin_by_id(CRYPTCOMPRESS_FILE_PLUGIN_ID),
+			offset == 0));
 
 	ctx = reiser4_init_context(inode->i_sb);
 	if (IS_ERR(ctx))
diff -puN fs/reiser4/block_alloc.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/block_alloc.c
--- a/fs/reiser4/block_alloc.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/block_alloc.c
@@ -491,18 +491,11 @@ void cluster_reserved2free(int count)
 	reiser4_context *ctx;
 	reiser4_super_info_data *sbinfo;
 
-	assert("edward-503", get_current_context()->grabbed_blocks == 0);
-
 	ctx = get_current_context();
 	sbinfo = get_super_private(ctx->super);
-	spin_lock_reiser4_super(sbinfo);
-
-	sub_from_cluster_reserved(sbinfo, count);
-	sbinfo->blocks_free += count;
 
-	assert("edward-502", reiser4_check_block_counters(ctx->super));
-
-	spin_unlock_reiser4_super(sbinfo);
+	cluster_reserved2grabbed(count);
+	grabbed2free(ctx, sbinfo, count);
 }
 
 static DEFINE_SPINLOCK(fake_lock);
diff -puN fs/reiser4/carry_ops.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/carry_ops.c
--- a/fs/reiser4/carry_ops.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/carry_ops.c
@@ -577,6 +577,24 @@ static int make_space(carry_op * op /* c
 		    (blk_alloc > 0) ||
 		    coord_is_after_rightmost(op->u.insert.d->coord);
 
+		if (gointo &&
+		    op->op == COP_PASTE &&
+		    coord_is_existing_item(op->u.insert.d->coord) &&
+		    is_solid_item((item_plugin_by_coord(op->u.insert.d->coord)))) {
+			/* paste into solid (atomic) item, which can contain
+			   only one unit, so we need to shift it right, where
+			   insertion point supposed to be */
+
+			assert("edward-1444", op->u.insert.d->data->iplug ==
+			       item_plugin_by_id(STATIC_STAT_DATA_ID));
+			assert("edward-1445",
+			       op->u.insert.d->data->length >
+			       node_plugin_by_node(coord->node)->free_space
+			       (coord->node));
+
+			op->u.insert.d->coord->between = BEFORE_UNIT;
+		}
+
 		result = carry_shift_data(RIGHT_SIDE, coord,
 					  reiser4_carry_real(fresh),
 					  doing, todo, gointo);
diff -puN fs/reiser4/context.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/context.c
--- a/fs/reiser4/context.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/context.c
@@ -41,7 +41,6 @@
 #include <linux/writeback.h>	/* balance_dirty_pages() */
 #include <linux/hardirq.h>
 
-
 static void _reiser4_init_context(reiser4_context * context,
 				  struct super_block *super)
 {
@@ -267,6 +266,16 @@ void reiser4_ctx_gfp_mask_set(void)
 		ctx->gfp_mask = GFP_NOFS;
 }
 
+void reiser4_ctx_gfp_mask_force (gfp_t mask)
+{
+	reiser4_context *ctx;
+	ctx = get_current_context();
+
+	assert("edward-1454", ctx != NULL);
+
+	ctx->gfp_mask = mask;
+}
+
 /*
  * Local variables:
  * c-indentation-style: "K&R"
diff -puN fs/reiser4/context.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/context.h
--- a/fs/reiser4/context.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/context.h
@@ -17,7 +17,6 @@
 #include <linux/spinlock.h>
 #include <linux/sched.h>	/* for struct task_struct */
 
-
 /* reiser4 per-thread context */
 struct reiser4_context {
 	/* magic constant. For identification of reiser4 contexts. */
@@ -155,6 +154,7 @@ static inline gfp_t reiser4_ctx_gfp_mask
 }
 
 void reiser4_ctx_gfp_mask_set(void);
+void reiser4_ctx_gfp_mask_force (gfp_t mask);
 
 /*
  * true if current thread is in the write-out mode. Thread enters write-out
diff -puN fs/reiser4/estimate.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/estimate.c
--- a/fs/reiser4/estimate.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/estimate.c
@@ -93,10 +93,12 @@ reiser4_block_nr estimate_update_cluster
 	return estimate_cluster(inode, 0); /* 44, for 64K-cluster */
 }
 
-/* how many nodes occupied by a disk cluster might get dirty */
+/* how many nodes occupied by a disk cluster might get dirty
+   FIXME-EDWARD: This estimation is pretty bad (65536 nodes for
+   64K-cluster, it means 256M of dead space on the partition) */
 reiser4_block_nr estimate_dirty_cluster(struct inode * inode)
 {
-	return 2 + cluster_nrpages(inode);
+	return inode_cluster_size(inode);
 }
 
 /* Make Linus happy.
diff -puN fs/reiser4/forward.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/forward.h
--- a/fs/reiser4/forward.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/forward.h
@@ -20,6 +20,7 @@ typedef struct shift_params shift_params
 typedef struct reiser4_object_create_data reiser4_object_create_data;
 typedef union reiser4_plugin reiser4_plugin;
 typedef __u16 reiser4_plugin_id;
+typedef __u64 reiser4_plugin_groups;
 typedef struct item_plugin item_plugin;
 typedef struct jnode_plugin jnode_plugin;
 typedef struct reiser4_item_data reiser4_item_data;
@@ -242,8 +243,6 @@ typedef enum {
 	OVRWR_LIST
 } atom_list;
 
-
-
 /* __REISER4_FORWARD_H__ */
 #endif
 
diff -puN fs/reiser4/init_super.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/init_super.c
--- a/fs/reiser4/init_super.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/init_super.c
@@ -6,7 +6,6 @@
 
 #include <linux/swap.h>
 
-
 /**
  * init_fs_info - allocate reiser4 specific super block
  * @super: super block of filesystem
@@ -656,14 +655,14 @@ static struct {
 		.type = REISER4_CLUSTER_PLUGIN_TYPE,
 		.id = CLUSTER_64K_ID
 	},
-	[PSET_REGULAR_ENTRY] = {
-		.type = REISER4_REGULAR_PLUGIN_TYPE,
-		.id = UF_REGULAR_ID
+	[PSET_CREATE] = {
+		.type = REISER4_FILE_PLUGIN_TYPE,
+		.id = UNIX_FILE_PLUGIN_ID
 	}
 };
 
 /* access to default plugin table */
-static reiser4_plugin *get_default_plugin(pset_member memb)
+reiser4_plugin *get_default_plugin(pset_member memb)
 {
 	return plugin_by_id(default_plugins[memb].type,
 			    default_plugins[memb].id);
@@ -696,30 +695,46 @@ int reiser4_init_root_inode(struct super
 
 	if (!is_inode_loaded(inode)) {
 		pset_member memb;
+		plugin_set *pset;
 
+		pset = reiser4_inode_data(inode)->pset;
 		for (memb = 0; memb < PSET_LAST; ++memb) {
-			reiser4_plugin *plug;
 
-			plug = get_default_plugin(memb);
-			result = grab_plugin_from(inode, memb, plug);
+			if (aset_get(pset, memb) != NULL)
+				continue;
+
+			result = grab_plugin_pset(inode, NULL, memb);
 			if (result != 0)
 				break;
+
+			reiser4_inode_clr_flag(inode, REISER4_SDLEN_KNOWN);
 		}
 
 		if (result == 0) {
 			if (REISER4_DEBUG) {
-				plugin_set *pset;
-
-				pset = reiser4_inode_data(inode)->pset;
 				for (memb = 0; memb < PSET_LAST; ++memb)
 					assert("nikita-3500",
-					       pset_get(pset, memb) != NULL);
+					       aset_get(pset, memb) != NULL);
 			}
 		} else
 			warning("nikita-3448", "Cannot set plugins of root: %i",
 				result);
 		reiser4_iget_complete(inode);
+
+		/* As the default pset kept in the root dir may has been changed
+		   (length is unknown), call update_sd. */
+		if (!reiser4_inode_get_flag(inode, REISER4_SDLEN_KNOWN)) {
+			result = reiser4_grab_space(
+				inode_file_plugin(inode)->estimate.update(inode),
+				BA_CAN_COMMIT);
+
+			if (result == 0)
+				result = reiser4_update_sd(inode);
+
+			all_grabbed2free();
+		}
 	}
+
 	super->s_maxbytes = MAX_LFS_FILESIZE;
 	return result;
 }
diff -puN fs/reiser4/inode.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/inode.c
--- a/fs/reiser4/inode.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/inode.c
@@ -179,7 +179,7 @@ int setup_inode_ops(struct inode *inode 
 	case S_IFREG:
 		assert("vs-46", fplug != NULL);
 		assert("vs-43", (fplug->h.id == UNIX_FILE_PLUGIN_ID ||
-				 fplug->h.id == CRC_FILE_PLUGIN_ID));
+				 fplug->h.id == CRYPTCOMPRESS_FILE_PLUGIN_ID));
 		inode->i_op = &file_plugins[fplug->h.id].inode_ops;
 		inode->i_fop = &file_plugins[fplug->h.id].file_ops;
 		inode->i_mapping->a_ops = &file_plugins[fplug->h.id].as_ops;
@@ -194,8 +194,8 @@ int setup_inode_ops(struct inode *inode 
 	return 0;
 }
 
-/* initialize inode from disk data. Called with inode locked.
-    Return inode locked. */
+/* Initialize inode from disk data. Called with inode locked.
+   Return inode locked. */
 static int init_inode(struct inode *inode /* inode to intialise */ ,
 		      coord_t * coord /* coord of stat data */ )
 {
@@ -225,29 +225,12 @@ static int init_inode(struct inode *inod
 	state = reiser4_inode_data(inode);
 	/* call stat-data plugin method to load sd content into inode */
 	result = iplug->s.sd.init_inode(inode, body, length);
-	plugin_set_sd(&state->pset, iplug);
+	set_plugin(&state->pset, PSET_SD, item_plugin_to_plugin(iplug));
 	if (result == 0) {
 		result = setup_inode_ops(inode, NULL);
-		if (result == 0 &&
-		    inode->i_sb->s_root && inode->i_sb->s_root->d_inode) {
-			struct inode *root;
-			pset_member ind;
-
-			/* take missing plugins from file-system defaults */
-			root = inode->i_sb->s_root->d_inode;
-			/* file and directory plugins are already initialized. */
-			for (ind = PSET_DIR + 1; ind < PSET_LAST; ++ind) {
-				result = grab_plugin(inode, root, ind);
-				if (result != 0)
-					break;
-			}
-			if (result != 0) {
-				warning("nikita-3447",
-					"Cannot set up plugins for %lli",
-					(unsigned long long)
-					get_inode_oid(inode));
-			}
-		}
+		if (result == 0 && inode->i_sb->s_root &&
+		    inode->i_sb->s_root->d_inode)
+			result = finish_pset(inode);
 	}
 	zrelse(coord->node);
 	return result;
@@ -402,7 +385,7 @@ static void loading_end(reiser4_inode * 
  * @silent:
  *
  * This is our helper function a la iget(). This is be called by
- * reiser4_lookup() and reiser4_read_super(). Return inode locked or error
+ * lookup_common() and reiser4_read_super(). Return inode locked or error
  * encountered.
  */
 struct inode *reiser4_iget(struct super_block *super, const reiser4_key *key,
@@ -516,14 +499,6 @@ dir_plugin *inode_dir_plugin(const struc
 	return reiser4_inode_data(inode)->pset->dir;
 }
 
-#if 0
-perm_plugin *inode_perm_plugin(const struct inode * inode)
-{
-	assert("nikita-1999", inode != NULL);
-	return reiser4_inode_data(inode)->pset->perm;
-}
-#endif  /*  0  */
-
 formatting_plugin *inode_formatting_plugin(const struct inode * inode)
 {
 	assert("nikita-2000", inode != NULL);
@@ -567,10 +542,10 @@ cluster_plugin *inode_cluster_plugin(con
 	return reiser4_inode_data(inode)->pset->cluster;
 }
 
-regular_plugin *inode_regular_plugin(const struct inode * inode)
+file_plugin *inode_create_plugin(const struct inode * inode)
 {
 	assert("edward-1329", inode != NULL);
-	return reiser4_inode_data(inode)->pset->regular_entry;
+	return reiser4_inode_data(inode)->pset->create;
 }
 
 digest_plugin *inode_digest_plugin(const struct inode * inode)
@@ -591,6 +566,12 @@ item_plugin *inode_dir_item_plugin(const
 	return reiser4_inode_data(inode)->pset->dir_item;
 }
 
+file_plugin *child_create_plugin(const struct inode * inode)
+{
+	assert("edward-1329", inode != NULL);
+	return reiser4_inode_data(inode)->hset->create;
+}
+
 void inode_set_extension(struct inode *inode, sd_ext_bits ext)
 {
 	reiser4_inode *state;
@@ -606,13 +587,19 @@ void inode_set_extension(struct inode *i
 	reiser4_inode_clr_flag(inode, REISER4_SDLEN_KNOWN);
 }
 
-void
-inode_set_plugin(struct inode *inode, reiser4_plugin * plug, pset_member memb)
+void inode_clr_extension(struct inode *inode, sd_ext_bits ext)
 {
-	assert("nikita-2718", inode != NULL);
-	assert("nikita-2719", plug != NULL);
+	reiser4_inode *state;
 
-	reiser4_inode_data(inode)->plugin_mask |= (1 << memb);
+	assert("vpf-1926", inode != NULL);
+	assert("vpf-1927", ext < LAST_SD_EXTENSION);
+	assert("vpf-1928", spin_inode_is_locked(inode));
+
+	state = reiser4_inode_data(inode);
+	state->extmask &= ~(1 << ext);
+	/* force re-calculation of stat-data length on next call to
+	   update_sd(). */
+	reiser4_inode_clr_flag(inode, REISER4_SDLEN_KNOWN);
 }
 
 void inode_check_scale_nolock(struct inode *inode, __u64 old, __u64 new)
diff -puN fs/reiser4/inode.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/inode.h
--- a/fs/reiser4/inode.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/inode.h
@@ -57,9 +57,10 @@ typedef enum {
 	 * kill-hook of tail items. It is never cleared once set. This bit is
 	 * modified and inspected under i_mutex. */
 	REISER4_HAS_MMAP = 8,
-
 	REISER4_PART_MIXED = 9,
-	REISER4_PART_IN_CONV = 10
+	REISER4_PART_IN_CONV = 10,
+	/* This flag indicates that file plugin conversion is in progress */
+	REISER4_FILE_CONV_IN_PROGRESS = 11
 } reiser4_file_plugin_flags;
 
 /* state associated with each inode.
@@ -99,9 +100,11 @@ typedef __u32 oid_hi_t;
 struct reiser4_inode {
 	/* spin lock protecting fields of this structure. */
 	spinlock_t guard;
-	/* object plugins */
+	/* main plugin set that control the file
+	   (see comments in plugin/plugin_set.c) */
 	plugin_set *pset;
-	/* plugins set for inheritance */
+	/* plugin set for inheritance
+	   (see comments in plugin/plugin_set.c) */
 	plugin_set *hset;
 	/* high 32 bits of object id */
 	oid_hi_t oid_hi;
@@ -118,6 +121,8 @@ struct reiser4_inode {
 	__u64 extmask;
 	/* bitmask of non-default plugins for this inode */
 	__u16 plugin_mask;
+	/* bitmask of set heir plugins for this inode. */
+	__u16 heir_mask;
 	union {
 		struct list_head readdir_list;
 		struct list_head not_used;
@@ -131,6 +136,22 @@ struct reiser4_inode {
 		cryptcompress_info_t cryptcompress_info;
 	} file_plugin_data;
 
+ 	/* this semaphore is used to serialize writes of any file plugin,
+	 * and should be invariant during file plugin conversion (which
+	 * is going in the context of ->write()).
+ 	 * inode->i_mutex can not be used for the serialization, because
+ 	 * write_unix_file uses get_user_pages which is to be used under
+ 	 * mm->mmap_sem and because it is required to take mm->mmap_sem before
+ 	 * inode->i_mutex, so inode->i_mutex would have to be up()-ed before
+ 	 * calling to get_user_pages which is unacceptable.
+	 */
+ 	struct semaphore mutex_write;
+
+	/* this semaphore is to serialize readers and writers of @pset->file
+	 * when file plugin conversion is enabled
+	 */
+ 	struct rw_semaphore conv_sem;
+
 	/* tree of jnodes. Phantom jnodes (ones not attched to any atom) are
 	   tagged in that tree by EFLUSH_TAG_ANONYMOUS */
 	struct radix_tree_root jnodes_tree;
@@ -248,7 +269,6 @@ static inline struct inode *unix_file_in
 			     p.file_plugin_data.unix_file_info)->vfs_inode;
 }
 
-
 extern ino_t oid_to_ino(oid_t oid) __attribute__ ((const));
 extern ino_t oid_to_uino(oid_t oid) __attribute__ ((const));
 
@@ -310,7 +330,6 @@ static inline void spin_unlock_inode(str
 	spin_unlock(&reiser4_inode_data(inode)->guard);
 }
 
-
 extern znode *inode_get_vroot(struct inode *inode);
 extern void inode_set_vroot(struct inode *inode, znode * vroot);
 
@@ -346,15 +365,15 @@ extern compression_plugin *inode_compres
 extern compression_mode_plugin *inode_compression_mode_plugin(const struct inode
 							      *inode);
 extern cluster_plugin *inode_cluster_plugin(const struct inode *inode);
-extern regular_plugin *inode_regular_plugin(const struct inode *inode);
+extern file_plugin *inode_create_plugin(const struct inode *inode);
 extern item_plugin *inode_sd_plugin(const struct inode *inode);
 extern item_plugin *inode_dir_item_plugin(const struct inode *inode);
+extern file_plugin *child_create_plugin(const struct inode *inode);
 
-extern void inode_set_plugin(struct inode *inode,
-			     reiser4_plugin * plug, pset_member memb);
 extern void reiser4_make_bad_inode(struct inode *inode);
 
 extern void inode_set_extension(struct inode *inode, sd_ext_bits ext);
+extern void inode_clr_extension(struct inode *inode, sd_ext_bits ext);
 extern void inode_check_scale(struct inode *inode, __u64 old, __u64 new);
 extern void inode_check_scale_nolock(struct inode * inode, __u64 old, __u64 new);
 
diff -puN fs/reiser4/jnode.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/jnode.c
--- a/fs/reiser4/jnode.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/jnode.c
@@ -119,7 +119,6 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/pagemap.h>
-#include <linux/vmalloc.h>	/* for vmalloc(), vfree() */
 #include <linux/swap.h>
 #include <linux/fs.h>		/* for struct address_space  */
 #include <linux/writeback.h>	/* for inode_lock */
@@ -163,7 +162,7 @@ jnode_key_hashfn(j_hash_table * table, c
 }
 
 /* The hash table definition */
-#define KMALLOC(size) vmalloc(size)
+#define KMALLOC(size) reiser4_vmalloc(size)
 #define KFREE(ptr, size) vfree(ptr)
 TYPE_SAFE_HASH_DEFINE(j, jnode, jnode_key_t, key.j, link.j, jnode_key_hashfn,
 		      jnode_key_eq);
@@ -615,6 +614,8 @@ static jnode *do_jget(reiser4_tree * tre
 		return result;
 	}
 
+	/* since page is locked, jnode should be allocated with GFP_NOFS flag */
+	reiser4_ctx_gfp_mask_force(GFP_NOFS);
 	result = find_get_jnode(tree, pg->mapping, oid, pg->index);
 	if (unlikely(IS_ERR(result)))
 		return result;
diff -puN fs/reiser4/jnode.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/jnode.h
--- a/fs/reiser4/jnode.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/jnode.h
@@ -12,6 +12,7 @@
 #include "key.h"
 #include "debug.h"
 #include "dformat.h"
+#include "page_cache.h"
 #include "context.h"
 
 #include "plugin/plugin.h"
diff -puN fs/reiser4/page_cache.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/page_cache.h
--- a/fs/reiser4/page_cache.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/page_cache.h
@@ -6,12 +6,12 @@
 #define __REISER4_PAGE_CACHE_H__
 
 #include "forward.h"
-#include "debug.h"
+#include "context.h"            /* for reiser4_ctx_gfp_mask_get() */
 
 #include <linux/fs.h>		/* for struct super_block, address_space  */
 #include <linux/mm.h>		/* for struct page  */
 #include <linux/pagemap.h>	/* for lock_page()  */
-
+#include <linux/vmalloc.h>	/* for __vmalloc()  */
 
 extern int reiser4_init_formatted_fake(struct super_block *);
 extern void reiser4_done_formatted_fake(struct super_block *);
@@ -38,6 +38,12 @@ extern void reiser4_invalidate_pages(str
 				     unsigned long count, int even_cows);
 extern void capture_reiser4_inodes(struct super_block *,
 				   struct writeback_control *);
+static inline void * reiser4_vmalloc (unsigned long size)
+{
+	return __vmalloc(size,
+			 reiser4_ctx_gfp_mask_get() | __GFP_HIGHMEM,
+			 PAGE_KERNEL);
+}
 
 #define PAGECACHE_TAG_REISER4_MOVED PAGECACHE_TAG_DIRTY
 
diff -puN fs/reiser4/plugin/cluster.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/cluster.c
--- a/fs/reiser4/plugin/cluster.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/cluster.c
@@ -8,21 +8,26 @@
 #include "plugin.h"
 #include "../inode.h"
 
-static int change_cluster(struct inode *inode, reiser4_plugin * plugin)
+static int change_cluster(struct inode *inode,
+			  reiser4_plugin * plugin,
+			  pset_member memb)
 {
-	int result = 0;
-
 	assert("edward-1324", inode != NULL);
 	assert("edward-1325", plugin != NULL);
 	assert("edward-1326", is_reiser4_inode(inode));
 	assert("edward-1327", plugin->h.type_id == REISER4_CLUSTER_PLUGIN_TYPE);
 
-	if (inode_file_plugin(inode)->h.id == DIRECTORY_FILE_PLUGIN_ID)
-		result = plugin_set_cluster(&reiser4_inode_data(inode)->pset,
-					    &plugin->clust);
-	else
-		result = RETERR(-EINVAL);
-	return result;
+	/* Can't change the cluster plugin for already existent regular files. */
+	if (!plugin_of_group(inode_file_plugin(inode), REISER4_DIRECTORY_FILE))
+		return RETERR(-EINVAL);
+
+	/* If matches, nothing to change. */
+	if (inode_hash_plugin(inode) != NULL &&
+	    inode_hash_plugin(inode)->h.id == plugin->h.id)
+		return 0;
+
+	return aset_set_unsafe(&reiser4_inode_data(inode)->pset,
+			       PSET_CLUSTER, plugin);
 }
 
 static reiser4_plugin_ops cluster_plugin_ops = {
diff -puN fs/reiser4/plugin/cluster.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/cluster.h
--- a/fs/reiser4/plugin/cluster.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/cluster.h
@@ -176,8 +176,15 @@ static inline void reiser4_slide_init(re
 	memset(win, 0, sizeof *win);
 }
 
+static inline tfm_action
+cluster_get_tfm_act(tfm_cluster_t * tc)
+{
+	assert("edward-1356", tc != NULL);
+	return tc->act;
+}
+
 static inline void
-tfm_cluster_init_act(tfm_cluster_t * tc, tfm_action act)
+cluster_set_tfm_act(tfm_cluster_t * tc, tfm_action act)
 {
 	assert("edward-1356", tc != NULL);
 	tc->act = act;
@@ -187,7 +194,7 @@ static inline void
 cluster_init_act (reiser4_cluster_t * clust, tfm_action act, reiser4_slide_t * window){
 	assert("edward-84", clust != NULL);
 	memset(clust, 0, sizeof *clust);
-	tfm_cluster_init_act(&clust->tc, act);
+	cluster_set_tfm_act(&clust->tc, act);
 	clust->dstat = INVAL_DISK_CLUSTER;
 	clust->win = window;
 }
@@ -204,12 +211,22 @@ cluster_init_write(reiser4_cluster_t * c
 	cluster_init_act (clust, TFM_WRITE_ACT, window);
 }
 
-static inline int dclust_get_extension(hint_t * hint)
+static inline int dclust_get_extension_dsize(hint_t * hint)
+{
+	return hint->ext_coord.extension.ctail.dsize;
+}
+
+static inline void dclust_set_extension_dsize(hint_t * hint, int dsize)
+{
+	hint->ext_coord.extension.ctail.dsize = dsize;
+}
+
+static inline int dclust_get_extension_shift(hint_t * hint)
 {
 	return hint->ext_coord.extension.ctail.shift;
 }
 
-static inline void dclust_set_extension(hint_t * hint)
+static inline void dclust_set_extension_shift(hint_t * hint)
 {
 	assert("edward-1270",
 	       item_id_by_coord(&hint->ext_coord.coord) == CTAIL_ID);
@@ -219,7 +236,8 @@ static inline void dclust_set_extension(
 
 static inline int hint_is_unprepped_dclust(hint_t * hint)
 {
-	return dclust_get_extension(hint) == (int)UCTAIL_SHIFT;
+	assert("edward-1451", hint_is_valid(hint));
+	return dclust_get_extension_shift(hint) == (int)UCTAIL_SHIFT;
 }
 
 static inline void coord_set_between_clusters(coord_t * coord)
@@ -239,7 +257,8 @@ static inline void coord_set_between_clu
 }
 
 int reiser4_inflate_cluster(reiser4_cluster_t *, struct inode *);
-int find_disk_cluster(reiser4_cluster_t *, struct inode *, int read, int write);
+int find_disk_cluster(reiser4_cluster_t *, struct inode *, int read,
+		      znode_lock_mode mode);
 int flush_cluster_pages(reiser4_cluster_t *, jnode *, struct inode *);
 int reiser4_deflate_cluster(reiser4_cluster_t *, struct inode *);
 void truncate_page_cluster(struct inode *inode, cloff_t start);
@@ -290,7 +309,7 @@ alloc_clust_pages(reiser4_cluster_t * cl
 	assert("edward-792", inode != NULL);
 	clust->pages =
 		kmalloc(sizeof(*clust->pages) << inode_cluster_shift(inode),
-			GFP_KERNEL);
+			reiser4_ctx_gfp_mask_get());
 	if (!clust->pages)
 		return -ENOMEM;
 	return 0;
diff -puN fs/reiser4/plugin/compress/compress.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/compress/compress.c
--- a/fs/reiser4/plugin/compress/compress.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/compress/compress.c
@@ -10,15 +10,27 @@
 #include <linux/types.h>
 #include <linux/hardirq.h>
 
-static int change_compression(struct inode *inode, reiser4_plugin * plugin)
+static int change_compression(struct inode *inode,
+			      reiser4_plugin * plugin,
+			      pset_member memb)
 {
 	assert("edward-1316", inode != NULL);
 	assert("edward-1317", plugin != NULL);
 	assert("edward-1318", is_reiser4_inode(inode));
 	assert("edward-1319",
 	       plugin->h.type_id == REISER4_COMPRESSION_PLUGIN_TYPE);
-	/* cannot change compression plugin of already existing object */
-	return RETERR(-EINVAL);
+
+	/* cannot change compression plugin of already existing regular object */
+	if (!plugin_of_group(inode_file_plugin(inode), REISER4_DIRECTORY_FILE))
+		return RETERR(-EINVAL);
+
+	/* If matches, nothing to change. */
+	if (inode_hash_plugin(inode) != NULL &&
+	    inode_hash_plugin(inode)->h.id == plugin->h.id)
+		return 0;
+
+	return aset_set_unsafe(&reiser4_inode_data(inode)->pset,
+			       PSET_COMPRESSION, plugin);
 }
 
 static reiser4_plugin_ops compression_plugin_ops = {
@@ -60,7 +72,7 @@ static coa_t gzip1_alloc(tfm_action act)
 	int ret = 0;
 	switch (act) {
 	case TFM_WRITE_ACT:	/* compress */
-		coa = vmalloc(zlib_deflate_workspacesize());
+		coa = reiser4_vmalloc(zlib_deflate_workspacesize());
 		if (!coa) {
 			ret = -ENOMEM;
 			break;
@@ -68,7 +80,7 @@ static coa_t gzip1_alloc(tfm_action act)
 		memset(coa, 0, zlib_deflate_workspacesize());
 		break;
 	case TFM_READ_ACT:	/* decompress */
-		coa = vmalloc(zlib_inflate_workspacesize());
+		coa = reiser4_vmalloc(zlib_inflate_workspacesize());
 		if (!coa) {
 			ret = -ENOMEM;
 			break;
@@ -236,7 +248,7 @@ static coa_t lzo1_alloc(tfm_action act)
 
 	switch (act) {
 	case TFM_WRITE_ACT:	/* compress */
-		coa = vmalloc(LZO_HEAP_SIZE(LZO1X_1_MEM_COMPRESS));
+		coa = reiser4_vmalloc(LZO_HEAP_SIZE(LZO1X_1_MEM_COMPRESS));
 		if (!coa) {
 			ret = -ENOMEM;
 			break;
@@ -351,7 +363,7 @@ compression_plugin compression_plugins[L
 		.alloc = gzip1_alloc,
 		.free = gzip1_free,
 		.min_size_deflate = gzip1_min_size_deflate,
-		.checksum = NULL,
+		.checksum = reiser4_adler32,
 		.compress = gzip1_compress,
 		.decompress = gzip1_decompress
 	}
diff -puN fs/reiser4/plugin/compress/compress_mode.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/compress/compress_mode.c
--- a/fs/reiser4/plugin/compress/compress_mode.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/compress/compress_mode.c
@@ -36,14 +36,6 @@ static int turn_on_compression(struct in
 	return 0;
 }
 
-static int turn_off_compression_on_zero(struct inode *inode, cloff_t index)
-{
-	assert("edward-1308", inode != NULL);
-	if (index == 0)
-		toggle_compression(cryptcompress_inode_data(inode), 0);
-	return 0;
-}
-
 /* Check on lattice (COL) of some sparseness factor,
    the family of adaptive compression modes which define
    the following behavior:
@@ -97,31 +89,34 @@ compression_mode_plugin compression_mode
 			.id = NONE_COMPRESSION_MODE_ID,
 			.pops = NULL,
 			.label = "none",
-			.desc = "Don't compress",
+			.desc = "Compress nothing",
 			.linkage = {NULL, NULL}
 		},
 		.should_deflate = should_deflate_none,
 		.accept_hook = NULL,
 		.discard_hook = NULL
 	},
-	/* Check-on-lattice adaptive compression modes */
+	/* Check-on-lattice adaptive compression modes.
+	   Turn compression on/off in flush time */
 	SUPPORT_COL_COMPRESSION_MODE(8, "col8"),
 	SUPPORT_COL_COMPRESSION_MODE(16, "col16"),
 	SUPPORT_COL_COMPRESSION_MODE(32, "col32"),
-	/* Turn off compression if logical cluster of index == 0
-	   is incompressible, then don't check anymore */
-	[COZ_COMPRESSION_MODE_ID] = {
+	/* In this mode items will be converted to extents and management
+	   will be passed to (classic) unix file plugin as soon as ->write()
+	   detects that the first complete logical cluster (of index #0) is
+	   incompressible. */
+	[CONVX_COMPRESSION_MODE_ID] = {
 		.h = {
 			.type_id = REISER4_COMPRESSION_MODE_PLUGIN_TYPE,
-			.id = COZ_COMPRESSION_MODE_ID,
+			.id = CONVX_COMPRESSION_MODE_ID,
 			.pops = NULL,
-			.label = "coz",
-			.desc = "Check on zero",
+			.label = "conv",
+			.desc = "Convert to extent",
 			.linkage = {NULL, NULL}
 		},
 		.should_deflate = should_deflate_common,
 		.accept_hook = NULL,
-		.discard_hook = turn_off_compression_on_zero
+		.discard_hook = NULL
 	},
 	[FORCE_COMPRESSION_MODE_ID] = {
 		.h = {
@@ -129,7 +124,7 @@ compression_mode_plugin compression_mode
 			.id = FORCE_COMPRESSION_MODE_ID,
 			.pops = NULL,
 			.label = "force",
-			.desc = "Compress everything",
+			.desc = "Force to compress everything",
 			.linkage = {NULL, NULL}
 		},
 		.should_deflate = NULL,
diff -puN fs/reiser4/plugin/disk_format/disk_format.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/disk_format/disk_format.c
--- a/fs/reiser4/plugin/disk_format/disk_format.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/disk_format/disk_format.c
@@ -21,7 +21,8 @@ disk_format_plugin format_plugins[LAST_F
 		.root_dir_key = root_dir_key_format40,
 		.release = release_format40,
 		.log_super = log_super_format40,
-		.check_open = check_open_format40
+		.check_open = check_open_format40,
+		.version_update = version_update_format40
 	}
 };
 
diff -puN fs/reiser4/plugin/disk_format/disk_format40.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/disk_format/disk_format40.c
--- a/fs/reiser4/plugin/disk_format/disk_format40.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/disk_format/disk_format40.c
@@ -27,6 +27,13 @@
    & tx record. */
 #define RELEASE_RESERVED 4
 
+/* The greatest supported format40 version number */
+#define FORMAT40_VERSION PLUGIN_LIBRARY_VERSION
+
+/* This flag indicates that backup should be updated
+   (the update is performed by fsck) */
+#define FORMAT40_UPDATE_BACKUP (1 << 31)
+
 /* functions to access fields of format40_disk_super_block */
 static __u64 get_format40_block_count(const format40_disk_super_block * sb)
 {
@@ -68,6 +75,28 @@ static __u64 get_format40_flags(const fo
 	return le64_to_cpu(get_unaligned(&sb->flags));
 }
 
+static __u32 get_format40_version(const format40_disk_super_block * sb)
+{
+	return le32_to_cpu(get_unaligned(&sb->version)) &
+		~FORMAT40_UPDATE_BACKUP;
+}
+
+static int update_backup_version(const format40_disk_super_block * sb)
+{
+	return (le32_to_cpu(get_unaligned(&sb->version)) &
+		FORMAT40_UPDATE_BACKUP);
+}
+
+static int update_disk_version(const format40_disk_super_block * sb)
+{
+	return (get_format40_version(sb) < FORMAT40_VERSION);
+}
+
+static int incomplete_compatibility(const format40_disk_super_block * sb)
+{
+	return (get_format40_version(sb) > FORMAT40_VERSION);
+}
+
 static format40_super_info *get_sb_info(struct super_block *super)
 {
 	return &get_super_private(super)->u.format40;
@@ -246,6 +275,8 @@ static int try_init_format40(struct supe
 	brelse(super_bh);
 	*stage = FIND_A_SUPER;
 
+	/* ok, we are sure that filesystem format is a format40 format */
+
 	/* map jnodes for journal control blocks (header, footer) to disk  */
 	result = reiser4_init_journal_info(super);
 	if (result)
@@ -263,14 +294,11 @@ static int try_init_format40(struct supe
 
 	result = reiser4_status_query(NULL, NULL);
 	if (result == REISER4_STATUS_MOUNT_WARN)
-		printk("Warning, mounting filesystem with errors\n");
-	if (result == REISER4_STATUS_MOUNT_RO) {
-		printk
-		    ("Warning, mounting filesystem with fatal errors, forcing read-only mount\n");
-		/* FIXME: here we should actually enforce read-only mount,
-		 * only it is unsupported yet. */
-	}
-
+		notice("vpf-1363", "Warning: mounting %s with errors.",
+		       super->s_id);
+	if (result == REISER4_STATUS_MOUNT_RO)
+		notice("vpf-1364", "Warning: mounting %s with fatal errors,"
+		       " forcing read-only mount.", super->s_id);
 	result = reiser4_journal_replay(super);
 	if (result)
 		return result;
@@ -284,10 +312,18 @@ static int try_init_format40(struct supe
 	/* allocate and make a copy of format40_disk_super_block */
 	sb_copy = copy_sb(super_bh);
 	brelse(super_bh);
+
 	if (IS_ERR(sb_copy))
 		return PTR_ERR(sb_copy);
-
-	/* make sure that key format of kernel and filesyste match */
+	printk("reiser4: %s: found disk format 4.0.%u.\n",
+	       super->s_id,
+	       get_format40_version(sb_copy));
+	if (incomplete_compatibility(sb_copy))
+		printk("reiser4: Warning: The last completely supported "
+		       "version of disk format40 is %u. Some objects of "
+		       "the semantic tree can be unaccessible.\n",
+		       FORMAT40_VERSION);
+	/* make sure that key format of kernel and filesystem match */
 	result = check_key_format(sb_copy);
 	if (result) {
 		kfree(sb_copy);
@@ -308,7 +344,6 @@ static int try_init_format40(struct supe
 	height = get_format40_tree_height(sb_copy);
 	nplug = node_plugin_by_id(NODE40_ID);
 
-
 	/* initialize reiser4_super_info_data */
 	sbinfo = get_super_private(super);
 	assert("", sbinfo->tree.super == super);
@@ -330,8 +365,14 @@ static int try_init_format40(struct supe
 	/* number of blocks in filesystem and reserved space */
 	reiser4_set_block_count(super, get_format40_block_count(sb_copy));
 	sbinfo->blocks_free = get_format40_free_blocks(sb_copy);
+	sbinfo->version = get_format40_version(sb_copy);
 	kfree(sb_copy);
 
+	if (update_backup_version(sb_copy))
+		printk("reiser4: Warning: metadata backup is not updated. "
+		       "Please run 'fsck.reiser4 --fix' on %s.\n",
+		       super->s_id);
+
 	sbinfo->fsuid = 0;
 	sbinfo->fs_flags |= (1 << REISER4_ADG);	/* hard links for directories
 						 * are not supported */
@@ -425,18 +466,31 @@ static void pack_format40_super(const st
 {
 	format40_disk_super_block *super_data =
 	    (format40_disk_super_block *) data;
+
 	reiser4_super_info_data *sbinfo = get_super_private(s);
 
 	assert("zam-591", data != NULL);
 
 	put_unaligned(cpu_to_le64(reiser4_free_committed_blocks(s)),
 		      &super_data->free_blocks);
-	put_unaligned(cpu_to_le64(sbinfo->tree.root_block), &super_data->root_block);
 
-	put_unaligned(cpu_to_le64(oid_next(s)), &super_data->oid);
-	put_unaligned(cpu_to_le64(oids_used(s)), &super_data->file_count);
+	put_unaligned(cpu_to_le64(sbinfo->tree.root_block),
+		      &super_data->root_block);
+
+	put_unaligned(cpu_to_le64(oid_next(s)),
+		      &super_data->oid);
 
-	put_unaligned(cpu_to_le16(sbinfo->tree.height), &super_data->tree_height);
+	put_unaligned(cpu_to_le64(oids_used(s)),
+		      &super_data->file_count);
+
+	put_unaligned(cpu_to_le16(sbinfo->tree.height),
+		      &super_data->tree_height);
+
+	if (update_disk_version(super_data)) {
+		__u32 version = FORMAT40_VERSION | FORMAT40_UPDATE_BACKUP;
+
+		put_unaligned(cpu_to_le32(version), &super_data->version);
+	}
 }
 
 /* plugin->u.format.log_super
@@ -537,7 +591,7 @@ int check_open_format40(const struct ino
 	/* Check the locality. */
 	oid = reiser4_inode_data(object)->locality_id;
 	if (oid > max) {
-		warning("vpf-1360", "The object with the locality %llu "
+		warning("vpf-1361", "The object with the locality %llu "
 			"greater then the max used oid %llu found.",
 			(unsigned long long)oid, (unsigned long long)max);
 
@@ -547,6 +601,48 @@ int check_open_format40(const struct ino
 	return 0;
 }
 
+/* plugin->u.format.version_update.
+   Perform all version update operations from the on-disk
+   format40_disk_super_block.version on disk to FORMAT40_VERSION.
+ */
+int version_update_format40(struct super_block *super) {
+	txn_handle * trans;
+	lock_handle lh;
+	txn_atom *atom;
+	int ret;
+
+	/* Nothing to do if RO mount or the on-disk version is not less. */
+	if (super->s_flags & MS_RDONLY)
+ 		return 0;
+
+	if (get_super_private(super)->version >= FORMAT40_VERSION)
+		return 0;
+
+	printk("reiser4: Updating disk format to 4.0.%u. The reiser4 metadata "
+	       "backup is left unchanged. Please run 'fsck.reiser4 --fix' "
+	       "on %s to update it too.\n", FORMAT40_VERSION, super->s_id);
+
+	/* Mark the uber znode dirty to call log_super on write_logs. */
+	init_lh(&lh);
+	ret = get_uber_znode(reiser4_get_tree(super), ZNODE_WRITE_LOCK,
+			     ZNODE_LOCK_HIPRI, &lh);
+	if (ret != 0)
+		return ret;
+
+	znode_make_dirty(lh.node);
+	done_lh(&lh);
+
+	/* Update the backup blocks. */
+
+	/* Force write_logs immediately. */
+	trans = get_current_context()->trans;
+	atom = get_current_atom_locked();
+	assert("vpf-1906", atom != NULL);
+
+	spin_lock_txnh(trans);
+	return force_commit_atom(trans);
+}
+
 /* Make Linus happy.
    Local variables:
    c-indentation-style: "K&R"
diff -puN fs/reiser4/plugin/disk_format/disk_format40.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/disk_format/disk_format40.h
--- a/fs/reiser4/plugin/disk_format/disk_format40.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/disk_format/disk_format40.h
@@ -47,8 +47,17 @@ typedef struct format40_disk_super_block
 	/*  68 */ d16 tree_height;
 	/* height of filesystem tree */
 	/*  70 */ d16 formatting_policy;
+	/* not used anymore */
 	/*  72 */ d64 flags;
-	/*  72 */ char not_used[432];
+	/*  80 */ d32 version;
+	/* on-disk format version number
+	   initially assigned by mkfs as the greatest format40
+	   version number supported by reiser4progs and updated
+	   in mount time in accordance with the greatest format40
+	   version number supported by kernel.
+	   Is used by fsck to catch possible corruption and
+	   for various compatibility issues */
+	/*  84 */ char not_used[428];
 } format40_disk_super_block;
 
 /* format 40 specific part of reiser4_super_info_data */
@@ -78,11 +87,12 @@ typedef struct format40_super_info {
 
 /* declarations of functions implementing methods of layout plugin for
    format 40. The functions theirself are in disk_format40.c */
-int init_format_format40(struct super_block *, void *data);
-const reiser4_key *root_dir_key_format40(const struct super_block *);
-int release_format40(struct super_block *s);
-jnode *log_super_format40(struct super_block *s);
-int check_open_format40(const struct inode *object);
+extern int init_format_format40(struct super_block *, void *data);
+extern const reiser4_key *root_dir_key_format40(const struct super_block *);
+extern int release_format40(struct super_block *s);
+extern jnode *log_super_format40(struct super_block *s);
+extern int check_open_format40(const struct inode *object);
+extern int version_update_format40(struct super_block *super);
 
 /* __DISK_FORMAT40_H__ */
 #endif
diff -puN fs/reiser4/plugin/fibration.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/fibration.c
--- a/fs/reiser4/plugin/fibration.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/fibration.c
@@ -81,7 +81,9 @@ static __u64 fibre_ext_3(const struct in
 		return FIBRE_NO(0);
 }
 
-static int change_fibration(struct inode *inode, reiser4_plugin * plugin)
+static int change_fibration(struct inode *inode,
+			    reiser4_plugin * plugin,
+			    pset_member memb)
 {
 	int result;
 
@@ -97,9 +99,8 @@ static int change_fibration(struct inode
 	if (inode_fibration_plugin(inode) == NULL ||
 	    inode_fibration_plugin(inode)->h.id != plugin->h.id) {
 		if (is_dir_empty(inode) == 0)
-			result =
-			    plugin_set_fibration(&reiser4_inode_data(inode)->
-						 pset, &plugin->fibration);
+			result = aset_set_unsafe(&reiser4_inode_data(inode)->pset,
+						 PSET_FIBRATION, plugin);
 		else
 			result = RETERR(-ENOTEMPTY);
 
diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -7,7 +7,6 @@
  * CTAIL_ID (see http://www.namesys.com/cryptcompress_design.html for details).
  */
 
-#include "../../page_cache.h"
 #include "../../inode.h"
 #include "../cluster.h"
 #include "../object.h"
@@ -28,9 +27,9 @@ cryptcompress_info_t *cryptcompress_inod
 }
 
 /* plugin->u.file.init_inode_data */
-void
-init_inode_data_cryptcompress(struct inode *inode,
-			      reiser4_object_create_data * crd, int create)
+void init_inode_data_cryptcompress(struct inode *inode,
+				   reiser4_object_create_data * crd,
+				   int create)
 {
 	cryptcompress_info_t *data;
 
@@ -47,10 +46,11 @@ init_inode_data_cryptcompress(struct ino
 #if REISER4_DEBUG
 int cryptcompress_inode_ok(struct inode *inode)
 {
-	if (cluster_shift_ok(inode_cluster_shift(inode)))
-		return 1;
-	assert("edward-686", 0);
-	return 0;
+	if (!(reiser4_inode_data(inode)->plugin_mask & (1 << PSET_FILE)))
+		return 0;
+	if (!cluster_shift_ok(inode_cluster_shift(inode)))
+		return 0;
+	return 1;
 }
 #endif
 
@@ -95,12 +95,12 @@ crypto_stat_t * reiser4_alloc_crypto_sta
 	int fipsize;
 
 	assert("edward-1421", 0);
-	info = kmalloc(sizeof(*info), GFP_KERNEL);
+	info = kmalloc(sizeof(*info), reiser4_ctx_gfp_mask_get());
 	if (!info)
 		return ERR_PTR(-ENOMEM);
 	memset(info, 0, sizeof (*info));
 	fipsize = inode_digest_plugin(inode)->fipsize;
-	info->keyid = kmalloc(fipsize, GFP_KERNEL);
+	info->keyid = kmalloc(fipsize, reiser4_ctx_gfp_mask_get());
 	if (!info->keyid) {
 		kfree(info);
 		return ERR_PTR(-ENOMEM);
@@ -185,7 +185,7 @@ static int create_keyid (crypto_stat_t *
 	ctfm = info_cipher_tfm(info);
 
 	dmem = kmalloc((size_t)crypto_tfm_alg_digestsize(dtfm),
-			       GFP_KERNEL);
+		       reiser4_ctx_gfp_mask_get());
 	if (!dmem)
 		goto exit1;
 
@@ -194,7 +194,8 @@ static int create_keyid (crypto_stat_t *
 	pad = data->keyid_size % blk;
 	pad = (pad ? blk - pad : 0);
 
-	cmem = kmalloc((size_t)data->keyid_size + pad, GFP_KERNEL);
+	cmem = kmalloc((size_t)data->keyid_size + pad,
+		       reiser4_ctx_gfp_mask_get());
 	if (!cmem)
 		goto exit2;
 	memcpy(cmem, data->keyid, data->keyid_size);
@@ -370,7 +371,7 @@ static int host_allows_crypto_stat(struc
 	file_plugin * fplug = inode_file_plugin(host);
 
 	switch (fplug->h.id) {
-	case CRC_FILE_PLUGIN_ID:
+	case CRYPTCOMPRESS_FILE_PLUGIN_ID:
 		ret = 1;
 		break;
 	default:
@@ -428,7 +429,6 @@ static int inode_set_crypto(struct inode
 	}
 	info = reiser4_inode_data(object);
 	info->extmask |= (1 << CRYPTO_STAT);
-	info->plugin_mask |= (1 << PSET_CIPHER) | (1 << PSET_DIGEST);
  	return 0;
 }
 
@@ -437,7 +437,6 @@ inode_set_compression(struct inode * obj
 {
 	int result = 0;
 	compression_plugin * cplug;
-	reiser4_inode * info = reiser4_inode_data(object);
 
 	cplug = inode_compression_plugin(object);
 
@@ -446,37 +445,22 @@ inode_set_compression(struct inode * obj
 		if (result)
 			return result;
 	}
-	info->plugin_mask |= (1 << PSET_COMPRESSION);
 
 	return 0;
 }
 
-static void
-inode_set_compression_mode(struct inode * object)
-{
-	reiser4_inode * info = reiser4_inode_data(object);
-
-	info->plugin_mask |= (1 << PSET_COMPRESSION_MODE);
-	return;
-}
-
 static int inode_set_cluster(struct inode *object)
 {
-	reiser4_inode *info;
-	cluster_plugin *cplug;
-
 	assert("edward-696", object != NULL);
 
-	info = reiser4_inode_data(object);
-	cplug = inode_cluster_plugin(object);
-
-	if (cplug->shift < PAGE_CACHE_SHIFT) {
-		warning("edward-1320",
-			"Can not support %p clusters (less then page size)",
-			cplug->h.label);
+	/* Check size of logical cluster */
+	if (inode_cluster_plugin(object)->shift < PAGE_CACHE_SHIFT) {
+		warning("edward-1320", "Can not support '%s' "
+			"cluster: (less then page size)",
+			inode_cluster_plugin(object)->h.label);
 		return RETERR(-EINVAL);
 	}
-	info->plugin_mask |= (1 << PSET_CLUSTER);
+
 	return 0;
 }
 
@@ -506,7 +490,7 @@ create_cryptcompress(struct inode *objec
 	assert("edward-24", parent != NULL);
 	assert("edward-30", data != NULL);
 	assert("edward-26", reiser4_inode_get_flag(object, REISER4_NO_SD));
-	assert("edward-27", data->id == CRC_FILE_PLUGIN_ID);
+	assert("edward-27", data->id == CRYPTCOMPRESS_FILE_PLUGIN_ID);
 
 	info = reiser4_inode_data(object);
 
@@ -523,14 +507,10 @@ create_cryptcompress(struct inode *objec
 	result = inode_set_compression(object);
 	if (result)
 		goto error;
-	inode_set_compression_mode(object);
-
-	/* set cluster info */
+	/* set cluster */
 	result = inode_set_cluster(object);
 	if (result)
 		goto error;
-	/* set plugin mask */
-	info->extmask |= (1 << PLUGIN_STAT);
 
 	/* save everything in disk stat-data */
 	result = write_sd_by_inode_common(object);
@@ -542,7 +522,7 @@ create_cryptcompress(struct inode *objec
 }
 
 /* ->open() method of the cryptcompress plugin */
-int open_cryptcompress(struct inode * inode, struct file * file)
+int open_object_cryptcompress(struct inode * inode, struct file * file)
 {
 	struct inode * parent;
 
@@ -554,7 +534,7 @@ int open_cryptcompress(struct inode * in
 	assert("edward-1399", file->f_dentry->d_parent->d_inode != NULL);
 	assert("edward-698",
 	       inode_file_plugin(inode) ==
-	       file_plugin_by_id(CRC_FILE_PLUGIN_ID));
+	       file_plugin_by_id(CRYPTCOMPRESS_FILE_PLUGIN_ID));
 
 	if (!need_cipher(inode))
 		/* the file is not to be ciphered */
@@ -671,9 +651,6 @@ flow_by_inode_cryptcompress(struct inode
 	assert("edward-436", f != NULL);
 	assert("edward-149", inode != NULL);
 	assert("edward-150", inode_file_plugin(inode) != NULL);
-	assert("edward-151",
-	       inode_file_plugin(inode)->key_by_inode ==
-	       key_by_inode_cryptcompress);
 
 	f->length = size;
 	memcpy(&f->data, &buf, sizeof(buf));
@@ -692,7 +669,7 @@ cryptcompress_hint_validate(hint_t * hin
 	coord_t *coord;
 
 	assert("edward-704", hint != NULL);
-	assert("edward-1089", !hint->ext_coord.valid);
+	assert("edward-1089", !hint_is_valid(hint));
 	assert("edward-706", hint->lh.owner == NULL);
 
 	coord = &hint->ext_coord.coord;
@@ -721,7 +698,6 @@ static int reserve4cluster(struct inode 
 	assert("edward-439", inode != NULL);
 	assert("edward-440", clust != NULL);
 	assert("edward-441", clust->pages != NULL);
-	assert("edward-1261", get_current_context()->grabbed_blocks == 0);
 
 	if (clust->nr_pages == 0) {
 		assert("edward-1152", clust->win != NULL);
@@ -744,7 +720,6 @@ static int reserve4cluster(struct inode 
 	clust->reserved_unprepped = estimate_insert_cluster(inode);
 #endif
 	/* there can be space grabbed by txnmgr_force_commit_all */
-	all_grabbed2free();
 	return 0;
 }
 
@@ -773,7 +748,7 @@ static int find_cluster_item(hint_t * hi
 
 	assert("edward-152", hint != NULL);
 
-	if (hint->ext_coord.valid == 0) {
+	if (!hint_is_valid(hint)) {
 		result = cryptcompress_hint_validate(hint, key, lock_mode);
 		if (result == -E_REPEAT)
 			goto traverse_tree;
@@ -781,7 +756,7 @@ static int find_cluster_item(hint_t * hi
 			assert("edward-1216", 0);
 			return result;
 		}
-		hint->ext_coord.valid = 1;
+		hint_set_valid(hint);
 	}
 	assert("edward-709", znode_is_any_locked(coord->node));
 
@@ -836,7 +811,7 @@ static int find_cluster_item(hint_t * hi
 			      CBK_UNIQUE | flags, ra_info);
 	if (cbk_errored(result))
 		return result;
-	hint->ext_coord.valid = 1;
+	hint_set_valid(hint);
 	return result;
 }
 
@@ -1035,7 +1010,7 @@ int grab_tfm_stream(struct inode * inode
 	assert("edward-901", tc != NULL);
 	assert("edward-1027", inode_compression_plugin(inode) != NULL);
 
-	if (tc->act == TFM_WRITE_ACT)
+	if (cluster_get_tfm_act(tc) == TFM_WRITE_ACT)
 		size += deflate_overrun(inode, inode_cluster_size(inode));
 
 	if (!tfm_stream(tc, id) && id == INPUT_STREAM)
@@ -1061,7 +1036,7 @@ int reiser4_deflate_cluster(reiser4_clus
 
 	assert("edward-401", inode != NULL);
 	assert("edward-903", tfm_stream_is_set(tc, INPUT_STREAM));
-	assert("edward-1348", tc->act == TFM_WRITE_ACT);
+	assert("edward-1348", cluster_get_tfm_act(tc) == TFM_WRITE_ACT);
 	assert("edward-498", !tfm_cluster_is_uptodate(tc));
 
 	coplug = inode_compression_plugin(inode);
@@ -1334,7 +1309,7 @@ static void clear_cluster_pages_dirty(re
 		lock_page(clust->pages[i]);
 		if (PageDirty(clust->pages[i])) {
 			assert("edward-1277", PageUptodate(clust->pages[i]));
-			clear_page_dirty_for_io(clust->pages[i]);
+			test_clear_page_dirty(clust->pages[i]);
 		}
 #if REISER4_DEBUG
 		else
@@ -1363,6 +1338,7 @@ static void inode_set_new_size(reiser4_c
 
 	win = clust->win;
 	assert("edward-1183", win != NULL);
+	assert("edward-1183", win->count != 0);
 
 	size = clust_to_off(clust->index, inode) + win->off;
 
@@ -1402,7 +1378,7 @@ make_cluster_jnode_dirty_locked(reiser4_
 	assert("edward-221", node != NULL);
 	assert("edward-971", clust->reserved == 1);
 	assert_spin_locked(&(node->guard));
-	assert("edward-972", node->page_count < cluster_nrpages(inode));
+	assert("edward-972", node->page_count <= cluster_nrpages(inode));
 	assert("edward-1263",
 	       clust->reserved_prepped == estimate_update_cluster(inode));
 	assert("edward-1264", clust->reserved_unprepped == 0);
@@ -1443,7 +1419,7 @@ make_cluster_jnode_dirty_locked(reiser4_
 	}
 #if REISER4_DEBUG
 	clust->reserved_prepped -= estimate_update_cluster(inode);
-	node->page_count = new_nrpages - 1;
+	node->page_count = new_nrpages;
 #endif
 	return;
 }
@@ -1464,10 +1440,11 @@ static int try_capture_cluster(reiser4_c
 	assert("edward-1033", clust->pages[0] != NULL);
 
 	node = jprivate(clust->pages[0]);
-
 	assert("edward-1035", node != NULL);
+	assert("edward-1446", jnode_is_cluster_page(node));
 
 	spin_lock_jnode(node);
+
 	old_size = inode->i_size;
 	if (clust->win)
 		inode_set_new_size(clust, inode);
@@ -1507,8 +1484,9 @@ grab_cluster_pages_jnode(struct inode *i
 		assert("edward-1044", clust->pages[i] == NULL);
 
 		clust->pages[i] =
-		    grab_cache_page(inode->i_mapping,
-				    clust_to_pg(clust->index, inode) + i);
+			find_or_create_page(inode->i_mapping,
+					    clust_to_pg(clust->index, inode) + i,
+					    reiser4_ctx_gfp_mask_get());
 		if (!clust->pages[i]) {
 			result = RETERR(-ENOMEM);
 			break;
@@ -1542,7 +1520,7 @@ grab_cluster_pages_jnode(struct inode *i
 }
 
 /* Collect unlocked cluster pages only for read (not to modify) */
-static int grab_cluster_pages(struct inode *inode, reiser4_cluster_t * clust)
+int grab_cluster_pages(struct inode *inode, reiser4_cluster_t * clust)
 {
 	int i;
 	int result = 0;
@@ -1556,8 +1534,9 @@ static int grab_cluster_pages(struct ino
 
 	for (i = 0; i < clust->nr_pages; i++) {
 		clust->pages[i] =
-		    grab_cache_page(inode->i_mapping,
-				    clust_to_pg(clust->index, inode) + i);
+		       find_or_create_page(inode->i_mapping,
+					   clust_to_pg(clust->index, inode) + i,
+					   reiser4_ctx_gfp_mask_get());
 		if (!clust->pages[i]) {
 			result = RETERR(-ENOMEM);
 			break;
@@ -1587,7 +1566,7 @@ int jnode_of_cluster(const jnode * node,
 		    get_inode_oid(page->mapping->host) ==
 		    node->key.j.objectid));
 	if (inode_file_plugin(page->mapping->host) ==
-	    file_plugin_by_id(CRC_FILE_PLUGIN_ID)) {
+	    file_plugin_by_id(CRYPTCOMPRESS_FILE_PLUGIN_ID)) {
 #if REISER4_DEBUG
 		if (!jnode_is_cluster_page(node))
 			warning("edward-1345",
@@ -1718,7 +1697,6 @@ static int update_sd_cryptcompress(struc
 	int result = 0;
 
 	assert("edward-978", reiser4_schedulable());
-	assert("edward-1265", get_current_context()->grabbed_blocks == 0);
 
 	result = reiser4_grab_space_force(	/* one for stat data update */
 						 estimate_update_common(inode),
@@ -1729,11 +1707,9 @@ static int update_sd_cryptcompress(struc
 	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
 	result = reiser4_update_sd(inode);
 
-	all_grabbed2free();
 	return result;
 }
 
-
 /* NOTE-Edward: this is too similar to reiser4/txnmgr.c:uncapture_jnode() */
 static void uncapture_cluster_jnode(jnode * node)
 {
@@ -1775,7 +1751,9 @@ flush_cluster_pages(reiser4_cluster_t * 
 	int i;
 	int nr_pages = 0;
 	tfm_cluster_t *tc = &clust->tc;
-
+#if REISER4_DEBUG
+	int node_pgcount;
+#endif
 	assert("edward-980", node != NULL);
 	assert("edward-236", inode != NULL);
 	assert("edward-237", clust != NULL);
@@ -1790,14 +1768,25 @@ flush_cluster_pages(reiser4_cluster_t * 
 		return result;
 	}
 	spin_lock_jnode(node);
-	assert("edward-1435", JF_ISSET(node, JNODE_DIRTY));
-
+#if REISER4_DEBUG
+ 	node_pgcount = node->page_count;
+#endif
+ 	if (!JF_ISSET(node, JNODE_DIRTY)) {
+ 		/* race with another flush */
+#if REISER4_DEBUG
+ 		assert("edward-981", node_pgcount == 0);
+ 		warning("edward-982", "flush_cluster_pages: jnode is not dirty "
+ 			"clust %lu, inode %llu\n",
+ 			clust->index, (unsigned long long)get_inode_oid(inode));
+#endif
+ 		spin_unlock_jnode(node);
+ 		return RETERR(-E_REPEAT);
+ 	}
 	/* Check out a size of logical cluster and
 	   set a number of cluster pages to commit. */
 	tc->len = tc->lsize = fsize_to_count(clust, inode);
 	clust->nr_pages = count_to_nrpages(tc->len);
 
-	assert("edward-983", clust->nr_pages == node->page_count + 1);
 #if REISER4_DEBUG
 	node->page_count = 0;
 #endif
@@ -1805,21 +1794,24 @@ flush_cluster_pages(reiser4_cluster_t * 
 	uncapture_cluster_jnode(node);
 
 	assert("edward-1224", reiser4_schedulable());
-	/* Check out cluster pages to commit */
+	/* Check out page cluster for commit */
 	nr_pages =
 	      find_get_pages(inode->i_mapping, clust_to_pg(clust->index, inode),
 			     clust->nr_pages, clust->pages);
+ 	if (nr_pages != clust->nr_pages)
+ 		goto checkout_failed;
 
-	assert("edward-1280", nr_pages == clust->nr_pages);
-	/* Construct input stream from the checked out pages */
+	/* Try to construct input stream from the checked out pages */
 	for (i = 0; i < clust->nr_pages; i++) {
 		char *data;
 
 		assert("edward-242", clust->pages[i] != NULL);
-		assert("edward-1436", clust->pages[i]->index ==
-		       clust_to_pg(clust->index, inode) + i);
-		assert("edward-1437", PageUptodate(clust->pages[i]));
-		/* flush the page into the input stream */
+ 		if (clust->pages[i]->index !=
+ 		    clust_to_pg(clust->index, inode) + i)
+ 			goto checkout_failed;
+ 		BUG_ON(!PageUptodate(clust->pages[i]));
+
+ 		/* flush the page into input transform stream */
 		lock_page(clust->pages[i]);
 		data = kmap(clust->pages[i]);
 
@@ -1830,13 +1822,25 @@ flush_cluster_pages(reiser4_cluster_t * 
 		kunmap(clust->pages[i]);
 		unlock_page(clust->pages[i]);
 	}
+	/* page cluster flushed successfully */
+
 	clear_cluster_pages_dirty(clust);
       	reiser4_release_cluster_pages(clust);
 #if REISER4_DEBUG
 	cryptcompress_inode_data(inode)->pgcount -= clust->nr_pages;
 #endif
+	goto out;
+ checkout_failed:
+#if REISER4_DEBUG
+	assert("edward-1282", node_pgcount == 0);
+	warning("edward-1435", "Inode %llu : checkout page cluster"
+		"of index %lu failed\n",
+			(unsigned long long)get_inode_oid(inode), clust->index);
+#endif /* REISER4_DEBUG */
+	result = RETERR(-E_REPEAT);
+ out:
 	/* put pages that were found here */
-	reiser4_release_cluster_pages(clust);
+	forget_cluster_pages(clust->pages, nr_pages);
 	return result;
 }
 
@@ -1848,7 +1852,7 @@ static void set_hint_cluster(struct inod
 	assert("edward-722", cryptcompress_inode_ok(inode));
 	assert("edward-723",
 	       inode_file_plugin(inode) ==
-	       file_plugin_by_id(CRC_FILE_PLUGIN_ID));
+	       file_plugin_by_id(CRYPTCOMPRESS_FILE_PLUGIN_ID));
 
 	inode_file_plugin(inode)->key_by_inode(inode,
 					       clust_to_off(index, inode),
@@ -1865,7 +1869,7 @@ void invalidate_hint_cluster(reiser4_clu
 	assert("edward-1292", clust->hint != NULL);
 
 	done_lh(&clust->hint->lh);
-	clust->hint->ext_coord.valid = 0;
+	hint_clr_valid(clust->hint);
 }
 
 void put_hint_cluster(reiser4_cluster_t * clust, struct inode *inode,
@@ -1886,7 +1890,6 @@ balance_dirty_page_cluster(reiser4_clust
 
 	assert("edward-724", inode != NULL);
 	assert("edward-725", cryptcompress_inode_ok(inode));
-	assert("edward-1272", get_current_context()->grabbed_blocks == 0);
 
 	/* set next window params */
 	update_cluster(inode, clust, off, to_file);
@@ -1898,7 +1901,6 @@ balance_dirty_page_cluster(reiser4_clust
 	assert("edward-726", clust->hint->lh.owner == NULL);
 
 	reiser4_throttle_write(inode);
-	all_grabbed2free();
 	return 0;
 }
 
@@ -1972,15 +1974,15 @@ write_hole(struct inode *inode, reiser4_
 
 /*
   The main disk search procedure for cryptcompress plugins, which
-  . scans all items of disk cluster
-  . maybe reads each one (if @read != 0)
-  . maybe makes its znode dirty  (if @write != 0)
+  . scans all items of disk cluster with the lock mode @mode
+  . maybe reads each one (if @read)
+  . maybe makes its znode dirty (if write lock mode was specified)
 
   NOTE-EDWARD: Callers should handle the case when disk cluster
   is incomplete (-EIO)
 */
 int find_disk_cluster(reiser4_cluster_t * clust,
-		      struct inode *inode, int read, int write)
+		      struct inode *inode, int read, znode_lock_mode mode)
 {
 	flow_t f;
 	hint_t *hint;
@@ -1994,7 +1996,6 @@ int find_disk_cluster(reiser4_cluster_t 
 
 	assert("edward-138", clust != NULL);
 	assert("edward-728", clust->hint != NULL);
-	assert("edward-225", read || write);
 	assert("edward-226", reiser4_schedulable());
 	assert("edward-137", inode != NULL);
 	assert("edward-729", cryptcompress_inode_ok(inode));
@@ -2014,7 +2015,7 @@ int find_disk_cluster(reiser4_cluster_t 
 			     0 /* kernel space */ ,
 			     inode_scaled_cluster_size(inode),
 			     clust_to_off(cl_idx, inode), READ_OP, &f);
-	if (write) {
+	if (mode == ZNODE_WRITE_LOCK) {
 		/* reserve for flush to make dirty all the leaf nodes
 		   which contain disk cluster */
 		result =
@@ -2029,11 +2030,10 @@ int find_disk_cluster(reiser4_cluster_t 
 	set_key_offset(&ra_info.key_to_stop, get_key_offset(reiser4_max_key()));
 
 	while (f.length) {
-		result = find_cluster_item(hint,
-					   &f.key,
-					   (write ? ZNODE_WRITE_LOCK :
-					    ZNODE_READ_LOCK), NULL, FIND_EXACT,
-					   (write ? CBK_FOR_INSERT : 0));
+		result = find_cluster_item(hint, &f.key, mode,
+					   NULL, FIND_EXACT,
+					   (mode == ZNODE_WRITE_LOCK ?
+					    CBK_FOR_INSERT : 0));
 		switch (result) {
 		case CBK_COORD_NOTFOUND:
 			result = 0;
@@ -2070,7 +2070,7 @@ int find_disk_cluster(reiser4_cluster_t 
 				zrelse(hint->ext_coord.coord.node);
 				goto out;
 			}
-			if (write) {
+			if (mode == ZNODE_WRITE_LOCK) {
 				znode_make_dirty(hint->ext_coord.coord.node);
 				znode_set_convertible(hint->ext_coord.coord.
 						      node);
@@ -2092,8 +2092,10 @@ int find_disk_cluster(reiser4_cluster_t 
 
 	if (hint_is_unprepped_dclust(clust->hint))
 		clust->dstat = UNPR_DISK_CLUSTER;
-	else
+	else {
+		dclust_set_extension_dsize(clust->hint, tc->len);
 		clust->dstat = PREP_DISK_CLUSTER;
+	}
  out:
 	assert("edward-1339",
 	       get_current_context()->grabbed_blocks >= was_grabbed);
@@ -2114,7 +2116,7 @@ get_disk_cluster_locked(reiser4_cluster_
 	assert("edward-731", clust != NULL);
 	assert("edward-732", inode != NULL);
 
-	if (clust->hint->ext_coord.valid) {
+	if (hint_is_valid(clust->hint)) {
 		assert("edward-1293", clust->dstat != INVAL_DISK_CLUSTER);
 		assert("edward-1294",
 		       znode_is_write_locked(clust->hint->lh.node));
@@ -2145,10 +2147,10 @@ read_some_cluster_pages(struct inode *in
 	int result = 0;
 	item_plugin *iplug;
 	reiser4_slide_t *win = clust->win;
+	znode_lock_mode mode = ZNODE_WRITE_LOCK;
 
 	iplug = item_plugin_by_id(CTAIL_ID);
 
-	assert("edward-733", get_current_context()->grabbed_blocks == 0);
 	assert("edward-924", !tfm_cluster_is_uptodate(&clust->tc));
 
 #if REISER4_DEBUG
@@ -2237,7 +2239,7 @@ read_some_cluster_pages(struct inode *in
 			break;
 		}
 		if (!tfm_cluster_is_uptodate(&clust->tc)) {
-			result = ctail_read_disk_cluster(clust, inode, 1);
+			result = ctail_read_disk_cluster(clust, inode, mode);
 			assert("edward-992", !result);
 			if (result)
 				goto out;
@@ -2245,7 +2247,7 @@ read_some_cluster_pages(struct inode *in
 			       tfm_cluster_is_uptodate(&clust->tc));
 		}
 		lock_page(pg);
-		result = do_readpage_ctail(inode, clust, pg);
+		result = do_readpage_ctail(inode, clust, pg, mode);
 		unlock_page(pg);
 		assert("edward-993", !result);
 		if (result) {
@@ -2257,9 +2259,8 @@ read_some_cluster_pages(struct inode *in
 	if (!tfm_cluster_is_uptodate(&clust->tc)) {
 		/* disk cluster unclaimed, but we need to make its znodes dirty
 		   to make flush update convert its content */
-		result =
-			find_disk_cluster(clust, inode, 0 /* do not read */ ,
-					  1 /* write */ );
+		result = find_disk_cluster(clust, inode, 0 /* do not read items */,
+					   mode);
 		assert("edward-994", !result);
 	}
  out:
@@ -2300,30 +2301,34 @@ cryptcompress_make_unprepped_cluster(rei
 	assert("edward-738", inode != NULL);
 	assert("edward-739", cryptcompress_inode_ok(inode));
 	assert("edward-1053", clust->hint != NULL);
-	assert("edward-1266", get_current_context()->grabbed_blocks == 0);
 
-	if (clust->reserved) {
-		cluster_reserved2grabbed(estimate_insert_cluster(inode));
+ 	if (!should_create_unprepped_cluster(clust, inode)) {
+ 		if (clust->reserved) {
+ 			cluster_reserved2free(estimate_insert_cluster(inode));
 #if REISER4_DEBUG
-		assert("edward-1267",
-		       clust->reserved_unprepped ==
-		       estimate_insert_cluster(inode));
-		clust->reserved_unprepped -= estimate_insert_cluster(inode);
+ 			assert("edward-1267",
+ 			       clust->reserved_unprepped ==
+ 			       estimate_insert_cluster(inode));
+ 			clust->reserved_unprepped -=
+ 				estimate_insert_cluster(inode);
 #endif
-	}
-	if (!should_create_unprepped_cluster(clust, inode)) {
-		all_grabbed2free();
+		}
 		return 0;
-	} else {
-		assert("edward-1268", clust->reserved == 1);
 	}
+ 	assert("edward-1268", clust->reserved);
+ 	cluster_reserved2grabbed(estimate_insert_cluster(inode));
+#if REISER4_DEBUG
+ 	assert("edward-1441",
+ 	       clust->reserved_unprepped == estimate_insert_cluster(inode));
+ 	clust->reserved_unprepped -= estimate_insert_cluster(inode);
+#endif
 	result = ctail_insert_unprepped_cluster(clust, inode);
-	all_grabbed2free();
 	if (result)
 		return result;
 
+	inode_add_bytes(inode, inode_cluster_size(inode));
+
 	assert("edward-743", cryptcompress_inode_ok(inode));
-	assert("edward-1269", get_current_context()->grabbed_blocks == 0);
 	assert("edward-744", znode_is_write_locked(clust->hint->lh.node));
 
 	clust->dstat = UNPR_DISK_CLUSTER;
@@ -2363,6 +2368,22 @@ prepare_page_cluster(struct inode *inode
 		grab_cluster_pages(inode, clust));
 }
 
+static void __truncate_page_cluster(struct inode * inode, cloff_t index)
+{
+	if (reiser4_inode_get_flag(inode, REISER4_FILE_CONV_IN_PROGRESS) &&
+	    index == 0)
+		return;
+	truncate_inode_pages_range(inode->i_mapping,
+				   clust_to_off(index, inode),
+				   clust_to_off(index,
+						inode) +
+				   inode_cluster_size(inode) - 1);
+	assert("edward-1201",
+	       ergo(!reiser4_inode_get_flag(inode,
+					    REISER4_FILE_CONV_IN_PROGRESS),
+		    jnode_truncate_ok(inode, index)));
+}
+
 /* Truncate all pages of the cluster of index @index.
    This is called by ->kill_hook() method of item plugin */
 void truncate_page_cluster(struct inode *inode, cloff_t index)
@@ -2378,20 +2399,19 @@ void truncate_page_cluster(struct inode 
 		    clust_to_pg(index, inode));
 	/* jnode is absent, just drop pages which can not
 	   acquire jnode because of exclusive access */
-	if (!node) {
-		truncate_inode_pages_range(inode->i_mapping,
-					   clust_to_off(index, inode),
-					   clust_to_off(index,
-							inode) +
-					   inode_cluster_size(inode) - 1);
-		return;
-	}
+	if (!node)
+		goto truncate;
 	/* jnode is present and may be dirty */
 	nr_pages = count_to_nrpages(cnt_to_clcnt(inode->i_size, index, inode));
 
 	found = find_get_pages(inode->i_mapping, clust_to_pg(index, inode),
 			       nr_pages, pages);
 	spin_lock_jnode(node);
+
+	if (reiser4_inode_get_flag(inode, REISER4_FILE_CONV_IN_PROGRESS)
+	    && index == 0)
+		/* converting to unix_file in progress */
+		JF_CLR(node, JNODE_CLUSTER_PAGE);
 	if (JF_ISSET(node, JNODE_DIRTY)) {
 		/* someone has done modifications which are not
 		   yet committed, so we need to release some resources */
@@ -2403,7 +2423,7 @@ void truncate_page_cluster(struct inode 
 			     estimate_update_cluster(inode));
 
 		assert("edward-1198", found == nr_pages);
-		assert("edward-1199", node->page_count + 1 == nr_pages);
+		assert("edward-1199", node->page_count == nr_pages);
 #if REISER4_DEBUG
 		node->page_count = 0;
 #endif
@@ -2425,12 +2445,8 @@ void truncate_page_cluster(struct inode 
 	jput(node);
 	/* put pages found here */
 	forget_cluster_pages(pages, found);
-	truncate_inode_pages_range(inode->i_mapping,
-				   clust_to_off(index, inode),
-				   clust_to_off(index,
-						inode) +
-				   inode_cluster_size(inode) - 1);
-	assert("edward-1201", jnode_truncate_ok(inode, index));
+ truncate:
+	__truncate_page_cluster(inode, index);
 	return;
 }
 
@@ -2454,8 +2470,8 @@ prepare_cluster(struct inode *inode,
 	int result = 0;
 	reiser4_slide_t *win = clust->win;
 
-	assert("edward-1273", get_current_context()->grabbed_blocks == 0);
 	reset_cluster_params(clust);
+	cluster_set_tfm_act(&clust->tc, TFM_READ_ACT);
 #if REISER4_DEBUG
 	clust->ctx = get_current_context();
 #endif
@@ -2466,6 +2482,9 @@ prepare_cluster(struct inode *inode,
 	result = prepare_page_cluster(inode, clust, 1);
 	if (result)
 		return result;
+	assert("edward-1447", jprivate(clust->pages[0]));
+	assert("edward-1448", jnode_is_cluster_page(jprivate(clust->pages[0])));
+
 	result = reserve4cluster(inode, clust);
 	if (result)
 		goto err1;
@@ -2584,7 +2603,8 @@ void reset_cluster_params(reiser4_cluste
 */
 static loff_t
 write_cryptcompress_flow(struct file *file, struct inode *inode,
-			 const char __user *buf, size_t count, loff_t pos)
+			 const char __user *buf, size_t count, loff_t pos,
+			 int *conv_occured)
 {
 	int i;
 	flow_t f;
@@ -2603,7 +2623,7 @@ write_cryptcompress_flow(struct file *fi
 	result = check_cryptcompress(inode);
 	if (result)
 		return result;
-	hint = kmalloc(sizeof(*hint), GFP_KERNEL);
+	hint = kmalloc(sizeof(*hint), reiser4_ctx_gfp_mask_get());
 	if (hint == NULL)
 		return RETERR(-ENOMEM);
 
@@ -2631,6 +2651,9 @@ write_cryptcompress_flow(struct file *fi
 		goto out;
 
 	if (next_window_stat(&win) == HOLE_WINDOW) {
+		result = write_conversion_hook(file, inode, pos, &clust, NULL);
+		if (result)
+			goto out;
 		result =
 		    prepare_cluster(inode, file_off, f.length, &clust,
 				    PCL_APPEND);
@@ -2643,6 +2666,10 @@ write_cryptcompress_flow(struct file *fi
 
 		assert("edward-750", reiser4_schedulable());
 
+		result = write_conversion_hook(file, inode, pos, &clust,
+					       conv_occured);
+		if (result || *conv_occured)
+			goto out;
 		result =
 		    prepare_cluster(inode, file_off, f.length, &clust,
 				    PCL_APPEND);
@@ -2651,7 +2678,7 @@ write_cryptcompress_flow(struct file *fi
 
 		assert("edward-751", cryptcompress_inode_ok(inode));
 		assert("edward-204", win.stat == DATA_WINDOW);
-		assert("edward-1288", clust.hint->ext_coord.valid);
+		assert("edward-1288", hint_is_valid(clust.hint));
 		assert("edward-752",
 		       znode_is_write_locked(hint->ext_coord.coord.node));
 
@@ -2730,52 +2757,13 @@ write_cryptcompress_flow(struct file *fi
 	kfree(hint);
 	if (buf) {
 		/* if nothing were written - there must be an error */
-		assert("edward-195", ergo((to_write == f.length), result < 0));
+		assert("edward-195", ergo((to_write == f.length),
+					  (result < 0 || *conv_occured)));
 		return (to_write - f.length) ? (to_write - f.length) : result;
 	}
 	return result;
 }
 
-static ssize_t write_cryptcompress_file(struct file *file, struct inode *inode,
-					const char __user * buf, size_t count,
-					loff_t * off)
-{
-
-	int result;
-	loff_t pos;
-	ssize_t written;
-	cryptcompress_info_t *info = cryptcompress_inode_data(inode);
-
-	assert("edward-196", cryptcompress_inode_ok(inode));
-
-	result = generic_write_checks(file, off, &count, 0);
-	if (unlikely(result != 0))
-		return result;
-
-	if (unlikely(count == 0))
-		return 0;
-
-	down_write(&info->lock);
-	LOCK_CNT_INC(inode_sem_w);
-
-	pos = *off;
-	written =
-	    write_cryptcompress_flow(file, inode, buf, count, pos);
-
-	up_write(&info->lock);
-	LOCK_CNT_DEC(inode_sem_w);
-
-	if (written < 0) {
-		if (written == -EEXIST)
-			printk("write_cryptcompress_file returns EEXIST!\n");
-		return written;
-	}
-	/* update position in a file */
-	*off = pos + written;
-	/* return number of written bytes */
-	return written;
-}
-
 /**
  * write_cryptcompress - write of struct file_operations
  * @file: file to write to
@@ -2787,23 +2775,48 @@ static ssize_t write_cryptcompress_file(
  * cryptcompress plugin.
  */
 ssize_t write_cryptcompress(struct file *file, const char __user *buf,
-			    size_t count, loff_t *off)
+			    size_t count, loff_t *off, int *conv)
 {
 	ssize_t result;
 	struct inode *inode;
 	reiser4_context *ctx;
+  	loff_t pos;
+  	cryptcompress_info_t *info;
+
+  	assert("edward-1449", *conv == 0);
 
 	inode = file->f_dentry->d_inode;
+	assert("edward-196", cryptcompress_inode_ok(inode));
+
+	info = cryptcompress_inode_data(inode);
 
 	ctx = reiser4_init_context(inode->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
-	mutex_lock(&inode->i_mutex);
-
-	result = write_cryptcompress_file(file, inode, buf, count, off);
+  	down(&reiser4_inode_data(inode)->mutex_write);
 
-	mutex_unlock(&inode->i_mutex);
+	result = generic_write_checks(file, off, &count, 0);
+  	if (unlikely(result != 0))
+  		return result;
+  	if (unlikely(count == 0))
+  		return 0;
+
+  	down_write(&info->lock);
+
+  	pos = *off;
+  	result = write_cryptcompress_flow(file, inode, buf, count, pos, conv);
+  	if (*conv == 0)
+  		up_write(&info->lock);
+
+  	up(&reiser4_inode_data(inode)->mutex_write);
+  	if (result < 0) {
+  		if (result == -EEXIST)
+  			printk("write_cryptcompress_flow returns EEXIST!\n");
+  		return result;
+  	}
+  	/* update position in a file */
+  	*off = pos + result;
 
 	context_set_commit_async(ctx);
 	reiser4_exit_context(ctx);
@@ -2869,8 +2882,6 @@ ssize_t read_cryptcompress(struct file *
 	info = cryptcompress_inode_data(inode);
 	needed = cryptcompress_estimate_read(inode);
 
-	/* FIXME-EDWARD:
-	   Grab space for sd_update so find_disk_cluster will be happy */
 	result = reiser4_grab_space(needed, BA_CAN_COMMIT);
 	if (result != 0) {
 		reiser4_exit_context(ctx);
@@ -2915,7 +2926,7 @@ find_real_disk_cluster(struct inode *ino
 	assert("edward-1131", inode != NULL);
 	assert("edward-95", cryptcompress_inode_ok(inode));
 
-	hint = kmalloc(sizeof(*hint), GFP_KERNEL);
+	hint = kmalloc(sizeof(*hint), reiser4_ctx_gfp_mask_get());
 	if (hint == NULL)
 		return RETERR(-ENOMEM);
 	hint_init_zero(hint);
@@ -3130,7 +3141,7 @@ cryptcompress_append_hole(struct inode *
 	assert("edward-1136", current_blocksize == PAGE_CACHE_SIZE);
 	assert("edward-1333", off_to_cloff(inode->i_size, inode) != 0);
 
-	hint = kmalloc(sizeof(*hint), GFP_KERNEL);
+	hint = kmalloc(sizeof(*hint), reiser4_ctx_gfp_mask_get());
 	if (hint == NULL)
 		return RETERR(-ENOMEM);
 	hint_init_zero(hint);
@@ -3254,7 +3265,9 @@ prune_cryptcompress(struct inode *inode,
 	assert("edward-1142", cryptcompress_inode_ok(inode));
 	assert("edward-1143", current_blocksize == PAGE_CACHE_SIZE);
 
-	hint = kmalloc(sizeof(*hint), GFP_KERNEL);
+	old_size = inode->i_size;
+
+	hint = kmalloc(sizeof(*hint), reiser4_ctx_gfp_mask_get());
 	if (hint == NULL)
 		return RETERR(-ENOMEM);
 	hint_init_zero(hint);
@@ -3402,9 +3415,12 @@ static int cryptcompress_truncate(struct
 	if (inode->i_size == new_size)
 		/* nothing to truncate anymore */
 		return 0;
-	return (inode->i_size < new_size ?
-		cryptcompress_append_hole(inode, new_size) :
-		prune_cryptcompress(inode, new_size, update_sd, aidx));
+	result = (inode->i_size < new_size ?
+		  cryptcompress_append_hole(inode, new_size) :
+		  prune_cryptcompress(inode, new_size, update_sd, aidx));
+	if (!result && update_sd)
+		result = update_sd_cryptcompress(inode);
+	return result;
 }
 
 static void clear_moved_tag_cluster(struct address_space * mapping,
@@ -3475,7 +3491,7 @@ capture_anonymous_clusters(struct addres
 	assert("edward-1128", mapping->host != NULL);
 	assert("edward-1440",  mapping->host->i_mapping == mapping);
 
-	hint = kmalloc(sizeof(*hint), GFP_KERNEL);
+	hint = kmalloc(sizeof(*hint), reiser4_ctx_gfp_mask_get());
 	if (hint == NULL)
 		return RETERR(-ENOMEM);
 	hint_init_zero(hint);
@@ -3504,7 +3520,7 @@ capture_anonymous_clusters(struct addres
 		page_cache_release(page);
 		if (result)
 			break;
-		to_capture--;
+		to_capture -= clust.nr_pages;
 	}
 	if (result) {
 		warning("edward-1077",
@@ -3566,9 +3582,6 @@ writepages_cryptcompress(struct address_
 		reiser4_context *ctx;
 
 		if (is_in_reiser4_context()) {
-			/* FIXME-EDWARD: REMOVEME */
-			all_grabbed2free();
-
 			/* It can be in the context of write system call from
 			   balance_dirty_pages() */
 			if (down_read_trylock(&info->lock) == 0) {
@@ -3621,8 +3634,28 @@ writepages_cryptcompress(struct address_
 /* plugin->u.file.mmap */
 int mmap_cryptcompress(struct file *file, struct vm_area_struct *vma)
 {
-	//return -ENOSYS;
-	return generic_file_mmap(file, vma);
+	int result;
+	struct inode *inode;
+	reiser4_context *ctx;
+
+	inode = file->f_dentry->d_inode;
+	ctx = reiser4_init_context(inode->i_sb);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+	/*
+	 * generic_file_mmap will do update_atime. Grab space for stat data
+	 * update.
+	 */
+	result = reiser4_grab_space_force
+		(inode_file_plugin(inode)->estimate.update(inode),
+		 BA_CAN_COMMIT);
+	if (result) {
+		reiser4_exit_context(ctx);
+		return result;
+	}
+	result = generic_file_mmap(file, vma);
+	reiser4_exit_context(ctx);
+	return result;
 }
 
 /* plugin->u.file.release */
@@ -3630,22 +3663,23 @@ int mmap_cryptcompress(struct file *file
 
 /* this is implementation of delete method of file plugin for
    cryptcompress objects */
-int delete_cryptcompress(struct inode *inode)
+int delete_object_cryptcompress(struct inode *inode)
 {
 	int result;
-
+	cryptcompress_info_t *info = cryptcompress_inode_data(inode);
 	assert("edward-429", inode->i_nlink == 0);
 
-	if (inode->i_size) {
-		result = cryptcompress_truncate(inode, 0, 0);
-		if (result) {
-			warning("edward-430",
-				"cannot truncate cryptcompress file  %lli: %i",
-				(unsigned long long)get_inode_oid(inode),
-				result);
-			return result;
-		}
+	reiser4_txn_restart_current();
+	down_write(&info->lock);
+	result = cryptcompress_truncate(inode, 0, 0);
+	up_write(&info->lock);
+	if (result) {
+		warning("edward-430",
+			"cannot truncate cryptcompress file  %lli: %i",
+			(unsigned long long)get_inode_oid(inode),
+			result);
 	}
+	truncate_inode_pages(inode->i_mapping, 0);
 	/* and remove stat data */
 	return reiser4_delete_object_common(inode);
 }
@@ -3769,40 +3803,12 @@ int release_cryptcompress(struct inode *
 	return 0;
 }
 
-static int
-save_len_cryptcompress_plugin(struct inode *inode, reiser4_plugin * plugin)
-{
-	assert("edward-457", inode != NULL);
-	assert("edward-458", plugin != NULL);
-	assert("edward-459", plugin->h.id == CRC_FILE_PLUGIN_ID);
-	return 0;
-}
-
-static int
-load_cryptcompress_plugin(struct inode *inode, reiser4_plugin * plugin,
-			  char **area, int *len)
-{
-	assert("edward-455", inode != NULL);
-	assert("edward-456", (reiser4_inode_data(inode)->pset != NULL));
-
-	plugin_set_file(&reiser4_inode_data(inode)->pset,
-			file_plugin_by_id(CRC_FILE_PLUGIN_ID));
-	return 0;
-}
-
-static int change_cryptcompress(struct inode *inode, reiser4_plugin * plugin)
+int prepare_write_cryptcompress(struct file *file, struct page *page,
+				unsigned from, unsigned to)
 {
-	/* cannot change object plugin of already existing object */
-	return RETERR(-EINVAL);
+	return prepare_write_common(file, page, from, to);
 }
 
-struct reiser4_plugin_ops cryptcompress_plugin_ops = {
-	.load = load_cryptcompress_plugin,
-	.save_len = save_len_cryptcompress_plugin,
-	.save = NULL,
-	.alignment = 8,
-	.change = change_cryptcompress
-};
 
 /*
   Local variables:
diff -puN fs/reiser4/plugin/file/cryptcompress.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/file/cryptcompress.h
--- a/fs/reiser4/plugin/file/cryptcompress.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/file/cryptcompress.h
@@ -4,11 +4,11 @@
 #if !defined( __FS_REISER4_CRYPTCOMPRESS_H__ )
 #define __FS_REISER4_CRYPTCOMPRESS_H__
 
+#include "../../page_cache.h"
 #include "../compress/compress.h"
 #include "../crypto/cipher.h"
 
 #include <linux/pagemap.h>
-#include <linux/vmalloc.h>
 
 #define MIN_CLUSTER_SIZE PAGE_CACHE_SIZE
 #define MIN_CLUSTER_SHIFT PAGE_CACHE_SHIFT
@@ -16,6 +16,17 @@
 #define MAX_CLUSTER_NRPAGES (1U << MAX_CLUSTER_SHIFT >> PAGE_CACHE_SHIFT)
 #define DC_CHECKSUM_SIZE 4
 
+/* this mask contains all non-standard plugins that might
+   be present in reiser4-specific part of inode managed by
+   cryptcompress file plugin */
+#define cryptcompress_mask				\
+	((1 << PSET_FILE) |				\
+	 (1 << PSET_CLUSTER) |				\
+	 (1 << PSET_CIPHER) |				\
+	 (1 << PSET_DIGEST) |				\
+	 (1 << PSET_COMPRESSION) |			\
+	 (1 << PSET_COMPRESSION_MODE))
+
 static inline loff_t min_count(loff_t a, loff_t b)
 {
 	return (a < b ? a : b);
@@ -70,7 +81,7 @@ static inline int alloc_ts(tfm_stream_t 
 	assert("edward-931", stm);
 	assert("edward-932", *stm == NULL);
 
-	*stm = kmalloc(sizeof **stm, GFP_KERNEL);
+	*stm = kmalloc(sizeof **stm, reiser4_ctx_gfp_mask_get());
 	if (*stm == NULL)
 		return -ENOMEM;
 	memset(*stm, 0, sizeof **stm);
@@ -91,7 +102,7 @@ static inline int alloc_ts_data(tfm_stre
 	assert("edward-936", !ts_size(stm));
 	assert("edward-937", size != 0);
 
-	stm->data = vmalloc(size);
+	stm->data = reiser4_vmalloc(size);
 	if (!stm->data)
 		return -ENOMEM;
 	set_ts_size(stm, size);
@@ -224,7 +235,7 @@ alloc_tfm_stream(tfm_cluster_t * tc, siz
 	assert("edward-939", tc != NULL);
 	assert("edward-940", !tfm_stream(tc, id));
 
-	tc->tun[id] = kmalloc(sizeof(tfm_stream_t), GFP_KERNEL);
+	tc->tun[id] = kmalloc(sizeof(tfm_stream_t), reiser4_ctx_gfp_mask_get());
 	if (!tc->tun[id])
 		return -ENOMEM;
 	memset(tfm_stream(tc, id), 0, sizeof(tfm_stream_t));
@@ -393,7 +404,8 @@ static inline int alloc_cluster_pgset(re
 	assert("edward-950", nrpages != 0 && nrpages <= MAX_CLUSTER_NRPAGES);
 
 	clust->pages =
-		kmalloc(sizeof(*clust->pages) * nrpages, GFP_KERNEL);
+		kmalloc(sizeof(*clust->pages) * nrpages,
+			reiser4_ctx_gfp_mask_get());
 	if (!clust->pages)
 		return RETERR(-ENOMEM);
 	reset_cluster_pgset(clust, nrpages);
@@ -441,7 +453,6 @@ typedef struct cryptcompress_info {
 #endif
 } cryptcompress_info_t;
 
-
 static inline void toggle_compression (cryptcompress_info_t * info, int val)
 {
 	info->compress_toggle = val;
@@ -455,18 +466,21 @@ static inline int compression_is_on (cry
 cryptcompress_info_t *cryptcompress_inode_data(const struct inode *);
 int equal_to_rdk(znode *, const reiser4_key *);
 int goto_right_neighbor(coord_t *, lock_handle *);
-int load_file_hint(struct file *, hint_t *);
-void save_file_hint(struct file *, const hint_t *);
-void hint_init_zero(hint_t *);
 int cryptcompress_inode_ok(struct inode *inode);
-extern int ctail_read_disk_cluster (reiser4_cluster_t *, struct inode *, int);
+int coord_is_unprepped_ctail(const coord_t * coord);
+extern int ctail_read_disk_cluster (reiser4_cluster_t *, struct inode *,
+				    znode_lock_mode mode);
 extern int do_readpage_ctail(struct inode *, reiser4_cluster_t *,
-			     struct page * page);
+			     struct page * page, znode_lock_mode mode);
 extern int ctail_insert_unprepped_cluster(reiser4_cluster_t * clust,
 					  struct inode * inode);
-extern int readpages_cryptcompress(struct file*, struct address_space*, struct list_head*, unsigned);
+extern int readpages_cryptcompress(struct file*, struct address_space*,
+				   struct list_head*, unsigned);
 int bind_cryptcompress(struct inode *child, struct inode *parent);
 void destroy_inode_cryptcompress(struct inode * inode);
+int grab_cluster_pages(struct inode *inode, reiser4_cluster_t * clust);
+int write_conversion_hook(struct file *file, struct inode * inode, loff_t pos,
+ 			  reiser4_cluster_t * clust, int * progress);
 crypto_stat_t * inode_crypto_stat (struct inode * inode);
 void inherit_crypto_stat_common(struct inode * parent, struct inode * object,
 				int (*can_inherit)(struct inode * child,
@@ -475,7 +489,6 @@ void reiser4_attach_crypto_stat(struct i
 void change_crypto_stat(struct inode * inode, crypto_stat_t * new);
 crypto_stat_t * reiser4_alloc_crypto_stat (struct inode * inode);
 
-
 static inline reiser4_tfma_t *
 info_get_tfma (crypto_stat_t * info, reiser4_tfm id)
 {
diff -puN fs/reiser4/plugin/file/file.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/file/file.c
@@ -373,7 +373,7 @@ cut_file_items(struct inode *inode, loff
 
 	assert("vs-1248",
 	       fplug == file_plugin_by_id(UNIX_FILE_PLUGIN_ID) ||
-	       fplug == file_plugin_by_id(CRC_FILE_PLUGIN_ID));
+	       fplug == file_plugin_by_id(CRYPTCOMPRESS_FILE_PLUGIN_ID));
 
 	fplug->key_by_inode(inode, new_size, &from_key);
 	to_key = from_key;
@@ -1933,7 +1933,7 @@ int mmap_unix_file(struct file *file, st
 
 	uf_info = unix_file_inode_data(inode);
 
-	down(&uf_info->write);
+	down(&reiser4_inode_data(inode)->mutex_write);
 	get_exclusive_access(uf_info);
 
 	if (!IS_RDONLY(inode) && (vma->vm_flags & (VM_MAYWRITE | VM_SHARED))) {
@@ -1945,7 +1945,7 @@ int mmap_unix_file(struct file *file, st
 		result = find_file_state(inode, uf_info);
 		if (result != 0) {
 			drop_exclusive_access(uf_info);
-			up(&uf_info->write);
+			up(&reiser4_inode_data(inode)->mutex_write);
 			reiser4_exit_context(ctx);
 			return result;
 		}
@@ -1961,7 +1961,7 @@ int mmap_unix_file(struct file *file, st
 			result = check_pages_unix_file(file, inode);
 			if (result) {
 				drop_exclusive_access(uf_info);
-				up(&uf_info->write);
+				up(&reiser4_inode_data(inode)->mutex_write);
 				reiser4_exit_context(ctx);
 				return result;
 			}
@@ -1976,7 +1976,7 @@ int mmap_unix_file(struct file *file, st
 	result = reiser4_grab_space_force(needed, BA_CAN_COMMIT);
 	if (result) {
 		drop_exclusive_access(uf_info);
-		up(&uf_info->write);
+		up(&reiser4_inode_data(inode)->mutex_write);
 		reiser4_exit_context(ctx);
 		return result;
 	}
@@ -1988,7 +1988,7 @@ int mmap_unix_file(struct file *file, st
 	}
 
 	drop_exclusive_access(uf_info);
-	up(&uf_info->write);
+	up(&reiser4_inode_data(inode)->mutex_write);
 	reiser4_exit_context(ctx);
 	return result;
 }
@@ -2368,7 +2368,7 @@ int release_unix_file(struct inode *inod
 	if (in_reiser4 == 0) {
 		uf_info = unix_file_inode_data(inode);
 
-		down(&uf_info->write);
+		down(&reiser4_inode_data(inode)->mutex_write);
 		get_exclusive_access(uf_info);
 		if (atomic_read(&file->f_dentry->d_count) == 1 &&
 		    uf_info->container == UF_CONTAINER_EXTENTS &&
@@ -2384,7 +2384,7 @@ int release_unix_file(struct inode *inod
 			}
 		}
 		drop_exclusive_access(uf_info);
-		up(&uf_info->write);
+		up(&reiser4_inode_data(inode)->mutex_write);
 	} else {
 		/*
 		   we are within reiser4 context already. How latter is
@@ -2430,9 +2430,7 @@ static void set_file_notail(struct inode
 
 	state = reiser4_inode_data(inode);
 	tplug = formatting_plugin_by_id(NEVER_TAILS_FORMATTING_ID);
-	plugin_set_formatting(&state->pset, tplug);
-	inode_set_plugin(inode,
-			 formatting_plugin_to_plugin(tplug), PSET_FORMATTING);
+	force_plugin_pset(inode, PSET_FORMATTING, (reiser4_plugin *)tplug);
 }
 
 /* if file is built of tails - convert it to extents */
@@ -2618,7 +2616,8 @@ owns_item_unix_file(const struct inode *
 	result = owns_item_common(inode, coord);
 	if (!result)
 		return 0;
-	if (item_type_by_coord(coord) != UNIX_FILE_METADATA_ITEM_TYPE)
+	if (!plugin_of_group(item_plugin_by_coord(coord),
+			     UNIX_FILE_METADATA_ITEM_TYPE))
 		return 0;
 	assert("vs-547",
 	       item_id_by_coord(coord) == EXTENT_POINTER_ID ||
@@ -2680,11 +2679,11 @@ int setattr_unix_file(struct dentry *den
 			return PTR_ERR(ctx);
 
 		uf_info = unix_file_inode_data(dentry->d_inode);
-		down(&uf_info->write);
+		down(&reiser4_inode_data(dentry->d_inode)->mutex_write);
 		get_exclusive_access(uf_info);
 		result = setattr_truncate(dentry->d_inode, attr);
 		drop_exclusive_access(uf_info);
-		up(&uf_info->write);
+		up(&reiser4_inode_data(dentry->d_inode)->mutex_write);
 		context_set_commit_async(ctx);
 		reiser4_exit_context(ctx);
 	} else
@@ -2703,7 +2702,6 @@ init_inode_data_unix_file(struct inode *
 	data = unix_file_inode_data(inode);
 	data->container = create ? UF_CONTAINER_EMPTY : UF_CONTAINER_UNKNOWN;
 	init_rwsem(&data->latch);
-	sema_init(&data->write, 1);
 	data->tplug = inode_formatting_plugin(inode);
 	data->exclusive_use = 0;
 
diff -puN fs/reiser4/plugin/file/file.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/file/file.h
--- a/fs/reiser4/plugin/file/file.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/file/file.h
@@ -1,8 +1,9 @@
 /* Copyright 2001, 2002, 2003, 2004 by Hans Reiser, licensing governed by
  * reiser4/README */
 
-/* this file contains declarations of methods implementing file plugins
-   (UNIX_FILE_PLUGIN_ID, SYMLINK_FILE_PLUGIN_ID and CRC_FILE_PLUGIN_ID) */
+/* this file contains declarations of methods implementing
+   file plugins (UNIX_FILE_PLUGIN_ID, CRYPTCOMPRESS_FILE_PLUGIN_ID
+   and SYMLINK_FILE_PLUGIN_ID) */
 
 #if !defined( __REISER4_FILE_H__ )
 #define __REISER4_FILE_H__
@@ -77,14 +78,6 @@ typedef struct unix_file_info {
 	 * take write-lock.
 	 */
 	struct rw_semaphore latch;
-	/*
-	 * this semaphore is used to serialize writes instead of inode->i_mutex,
-	 * because write_unix_file uses get_user_pages which is to be used
-	 * under mm->mmap_sem and because it is required to take mm->mmap_sem
-	 * before inode->i_mutex, so inode->i_mutex would have to be unlocked
-	 * before calling to get_user_pages which is unacceptable
-	 */
-	struct semaphore write;
 	/* this enum specifies which items are used to build the file */
 	file_container_t container;
 	/*
@@ -117,7 +110,6 @@ int find_file_item_nohint(coord_t *, loc
 int load_file_hint(struct file *, hint_t *);
 void save_file_hint(struct file *, const hint_t *);
 
-
 #include "../item/extent.h"
 #include "../item/tail.h"
 #include "../item/ctail.h"
@@ -152,17 +144,32 @@ struct hint {
 	lock_handle lh;
 };
 
+static inline int hint_is_valid(hint_t * hint)
+{
+	return hint->ext_coord.valid;
+}
+
+static inline void hint_set_valid(hint_t * hint)
+{
+	hint->ext_coord.valid = 1;
+}
+
+static inline void hint_clr_valid(hint_t * hint)
+{
+	hint->ext_coord.valid = 0;
+}
+
+int load_file_hint(struct file *, hint_t *);
+void save_file_hint(struct file *, const hint_t *);
+void hint_init_zero(hint_t *);
 void reiser4_set_hint(hint_t *, const reiser4_key *, znode_lock_mode);
 int hint_is_set(const hint_t *);
 void reiser4_unset_hint(hint_t *);
-void hint_init_zero(hint_t *);
 
 int reiser4_update_file_size(struct inode *, reiser4_key *, int update_sd);
 int cut_file_items(struct inode *, loff_t new_size, int update_sd,
 		   loff_t cur_size, int (*update_actor) (struct inode *,
 							 reiser4_key *, int));
-
-
 #if REISER4_DEBUG
 
 /* return 1 is exclusive access is obtained, 0 - otherwise */
@@ -183,34 +190,47 @@ int reiser4_create_symlink(struct inode 
 			   reiser4_object_create_data *);
 void destroy_inode_symlink(struct inode *);
 
-/* declarations of functions implementing CRC_FILE_PLUGIN_ID file plugin */
+/* declarations of functions implementing CRYPTCOMPRESS_FILE_PLUGIN_ID
+   file plugin */
 
 /* inode operations */
 int setattr_cryptcompress(struct dentry *, struct iattr *);
+int prot_setattr_cryptcompress(struct dentry *, struct iattr *);
 
 /* file operations */
 ssize_t read_cryptcompress(struct file *, char __user *buf, size_t read_amount,
 			   loff_t * off);
+ssize_t prot_read_cryptcompress(struct file *, char __user *buf,
+				size_t read_amount, loff_t * off);
+
+int prepare_write_cryptcompress(struct file *file, struct page *page,
+				unsigned from, unsigned to);
 ssize_t write_cryptcompress(struct file *, const char __user *buf, size_t write_amount,
-			    loff_t * off);
+			    loff_t * off, int * conv);
+ssize_t prot_write_cryptcompress(struct file *, const char __user *buf, size_t write_amount,
+				 loff_t * off);
 int mmap_cryptcompress(struct file *, struct vm_area_struct *);
+int prot_mmap_cryptcompress(struct file *, struct vm_area_struct *);
 ssize_t sendfile_cryptcompress(struct file *file, loff_t *ppos, size_t count,
 			       read_actor_t actor, void *target);
+ssize_t prot_sendfile_cryptcompress(struct file *file, loff_t *ppos, size_t count,
+				    read_actor_t actor, void *target);
+
 int release_cryptcompress(struct inode *, struct file *);
+int prot_release_cryptcompress(struct inode *, struct file *);
 
 /* address space operations */
 extern int readpage_cryptcompress(struct file *, struct page *);
 extern int writepages_cryptcompress(struct address_space *,
 				     struct writeback_control *);
-
-
 /* file plugin operations */
 int flow_by_inode_cryptcompress(struct inode *, const char __user *buf,
 				int user, loff_t, loff_t, rw_op, flow_t *);
 int key_by_inode_cryptcompress(struct inode *, loff_t off, reiser4_key *);
 int create_cryptcompress(struct inode *, struct inode *,
 			 reiser4_object_create_data *);
-int delete_cryptcompress(struct inode *);
+int delete_object_cryptcompress(struct inode *);
+int prot_delete_object_cryptcompress(struct inode *);
 void init_inode_data_cryptcompress(struct inode *, reiser4_object_create_data *,
 				   int create);
 int cut_tree_worker_cryptcompress(tap_t *, const reiser4_key * from_key,
@@ -219,12 +239,12 @@ int cut_tree_worker_cryptcompress(tap_t 
 				  struct inode *object, int truncate,
 				  int *progress);
 void destroy_inode_cryptcompress(struct inode *);
+int open_object_cryptcompress(struct inode * inode, struct file * file);
 
 extern reiser4_plugin_ops cryptcompress_plugin_ops;
 
 #define WRITE_GRANULARITY 32
 
-
 int tail2extent(unix_file_info_t *);
 int extent2tail(unix_file_info_t *);
 
diff -puN /dev/null fs/reiser4/plugin/file/file_conversion.c
--- /dev/null
+++ a/fs/reiser4/plugin/file/file_conversion.c
@@ -0,0 +1,594 @@
+/* Copyright 2001, 2002, 2003 by Hans Reiser,
+   licensing governed by reiser4/README */
+
+/* This file contains hooks that converts (*) cryptcompress files to unix-files,
+   and a set of protected (**) methods of a cryptcompress file plugin to perform
+   such conversion.
+
+(*)
+   The conversion is performed for incompressible files to reduce cpu and memory
+   usage. If first logical cluster (64K by default) of a file is incompressible,
+   then we make a desicion, that the whole file is incompressible.
+   The conversion can be enabled via installing a special compression mode
+   plugin (CONVX_COMPRESSION_MODE_ID, see plugin/compress/compress_mode.c for
+   details).
+
+(**)
+   The protection means serialization of critical sections (readers and writers
+   of @pset->file)
+*/
+
+#include "../../inode.h"
+#include "../cluster.h"
+#include "file.h"
+
+#define conversion_enabled(inode)                                      \
+	 (inode_compression_mode_plugin(inode) ==		       \
+	  compression_mode_plugin_by_id(CONVX_COMPRESSION_MODE_ID))
+
+
+/* Located sections (readers and writers of @pset->file) are not
+   permanently critical: cryptcompress file can be converted only
+   if the conversion is enabled (see the macrio above). And we don't
+   convert unix files at all.
+   The following helper macro is a sanity check to decide if we
+   need to protect a located section.
+*/
+#define should_protect(inode)						\
+	(inode_file_plugin(inode) ==					\
+	 file_plugin_by_id(CRYPTCOMPRESS_FILE_PLUGIN_ID) &&		\
+	 conversion_enabled(inode))
+
+/* All protected methods have prefix "prot" in their names.
+   It is convenient to construct them by usual (unprotected) ones
+   using the following common macros:
+*/
+
+/* Macro for passive protection.
+   method_cryptcompress contains only readers */
+#define PROT_PASSIVE(type, method, args)				\
+({							                \
+	type _result;							\
+	struct rw_semaphore * guard =					\
+		&reiser4_inode_data(inode)->conv_sem;			\
+									\
+	if (should_protect(inode)) {					\
+		down_read(guard);					\
+		if (!should_protect(inode))				\
+			up_read(guard);					\
+	}								\
+	if (inode_file_plugin(inode) ==					\
+	    file_plugin_by_id(UNIX_FILE_PLUGIN_ID))			\
+		_result = method ## _unix_file args;			\
+	else								\
+		_result = method ## _cryptcompress args;		\
+	if (should_protect(inode))					\
+		up_read(guard);						\
+	_result;							\
+})
+
+#define PROT_PASSIVE_VOID(method, args)					\
+({							                \
+	struct rw_semaphore * guard =					\
+		&reiser4_inode_data(inode)->conv_sem;			\
+									\
+	if (should_protect(inode)) {					\
+		down_read(guard);					\
+		if (!should_protect(inode))				\
+			up_read(guard);					\
+	}								\
+	if (inode_file_plugin(inode) ==					\
+	    file_plugin_by_id(UNIX_FILE_PLUGIN_ID))			\
+		method ## _unix_file args;				\
+	else								\
+		method ## _cryptcompress args;				\
+	if (should_protect(inode))					\
+		up_read(guard);						\
+})
+
+/* Macro for active protection.
+   active_expr contains readers and writers; after its
+   evaluation conversion should be disabled */
+#define PROT_ACTIVE(type, method, args, active_expr)			\
+({	                 						\
+	type _result = 0;						\
+	struct rw_semaphore * guard =					\
+		&reiser4_inode_data(inode)->conv_sem;			\
+	reiser4_context * ctx =	reiser4_init_context(inode->i_sb);	\
+	if (IS_ERR(ctx))						\
+		return PTR_ERR(ctx);					\
+									\
+	if (should_protect(inode)) {					\
+		down_write(guard);					\
+		if (should_protect(inode))				\
+			_result = active_expr;				\
+		up_write(guard);					\
+	}								\
+	if (_result == 0) {						\
+		if (inode_file_plugin(inode) ==				\
+		    file_plugin_by_id(UNIX_FILE_PLUGIN_ID))		\
+			_result =  method ## _unix_file args;		\
+		else							\
+			_result =  method ## _cryptcompress args;	\
+	}								\
+	reiser4_exit_context(ctx);					\
+	_result;							\
+})
+
+/* Pass management to the unix file plugin */
+static int __cryptcompress2unixfile(struct file *file, struct inode * inode)
+{
+	int result;
+	reiser4_inode *info;
+	unix_file_info_t * uf;
+	info = reiser4_inode_data(inode);
+
+	result = aset_set_unsafe(&info->pset, PSET_FILE, (reiser4_plugin *)
+				 file_plugin_by_id(UNIX_FILE_PLUGIN_ID));
+	if (result)
+		return result;
+	/* get rid of non-standard plugins */
+	info->plugin_mask &= ~cryptcompress_mask;
+	/* get rid of plugin stat-data extension */
+	info->extmask &= ~(1 << PLUGIN_STAT);
+
+	reiser4_inode_clr_flag(inode, REISER4_SDLEN_KNOWN);
+
+	/* FIXME use init_inode_data_unix_file() instead,
+	   but aviod init_inode_ordering() */
+	/* Init unix-file specific part of inode */
+	uf = unix_file_inode_data(inode);
+	uf->container = UF_CONTAINER_UNKNOWN;
+	init_rwsem(&uf->latch);
+	uf->tplug = inode_formatting_plugin(inode);
+	uf->exclusive_use = 0;
+#if REISER4_DEBUG
+	uf->ea_owner = NULL;
+	atomic_set(&uf->nr_neas, 0);
+#endif
+	inode->i_op =
+		&file_plugin_by_id(UNIX_FILE_PLUGIN_ID)->inode_ops;
+	inode->i_fop =
+		&file_plugin_by_id(UNIX_FILE_PLUGIN_ID)->file_ops;
+	inode->i_mapping->a_ops =
+		&file_plugin_by_id(UNIX_FILE_PLUGIN_ID)->as_ops;
+	file->f_op = inode->i_fop;
+	return 0;
+}
+
+#if REISER4_DEBUG
+static int disabled_conversion_inode_ok(struct inode * inode)
+{
+	__u64 extmask = reiser4_inode_data(inode)->extmask;
+	__u16 plugin_mask = reiser4_inode_data(inode)->plugin_mask;
+
+	return ((extmask & (1 << LIGHT_WEIGHT_STAT)) &&
+		(extmask & (1 << UNIX_STAT)) &&
+		(extmask & (1 << LARGE_TIMES_STAT)) &&
+		(extmask & (1 << PLUGIN_STAT)) &&
+		(plugin_mask & (1 << PSET_COMPRESSION_MODE)));
+}
+#endif
+
+/* Assign another mode that will control
+   compression at flush time only */
+static int disable_conversion_no_update_sd(struct inode * inode)
+{
+	int result;
+	result =
+	       force_plugin_pset(inode,
+				 PSET_COMPRESSION_MODE,
+				 (reiser4_plugin *)compression_mode_plugin_by_id
+				 (COL_8_COMPRESSION_MODE_ID));
+	assert("edward-1500",
+	       ergo(!result, disabled_conversion_inode_ok(inode)));
+	return result;
+}
+
+/* Disable future attempts to check/convert. This function is called by
+   conversion hooks. */
+static int disable_conversion(struct inode * inode)
+{
+	return disable_conversion_no_update_sd(inode);
+}
+
+static int check_position(struct inode * inode,
+			  loff_t pos /* initial position in the file */,
+			  reiser4_cluster_t * clust,
+			  int * check_compress)
+{
+	assert("edward-1505", conversion_enabled(inode));
+	assert("edward-1506", inode->i_size <= inode_cluster_size(inode));
+	/* if file size is more then cluster size, then compressible
+	   status must be figured out (i.e. compression was disabled,
+	   or file plugin was converted to unix_file) */
+
+	if (pos > inode->i_size)
+		/* first logical cluster will contain a (partial) hole */
+		return disable_conversion(inode);
+	if (inode->i_size == inode_cluster_size(inode))
+		*check_compress = 1;
+	return 0;
+}
+
+static void start_check_compressibility(struct inode * inode,
+					reiser4_cluster_t * clust,
+					hint_t * hint)
+{
+	assert("edward-1507", clust->index == 1);
+	assert("edward-1508", !tfm_cluster_is_uptodate(&clust->tc));
+	assert("edward-1509", cluster_get_tfm_act(&clust->tc) == TFM_READ_ACT);
+
+	hint_init_zero(hint);
+	clust->hint = hint;
+	clust->index --;
+	clust->nr_pages = count_to_nrpages(fsize_to_count(clust, inode));
+
+	/* first logical cluster (of index #0) must be complete */
+	assert("edward-1510", fsize_to_count(clust, inode) ==
+	       inode_cluster_size(inode));
+}
+
+static void finish_check_compressibility(struct inode * inode,
+					 reiser4_cluster_t * clust,
+					 hint_t * hint)
+{
+	reiser4_unset_hint(clust->hint);
+	clust->hint = hint;
+	clust->index ++;
+}
+
+#if REISER4_DEBUG
+int prepped_dclust_ok(hint_t * hint)
+{
+	reiser4_key key;
+	coord_t * coord = &hint->ext_coord.coord;
+
+	item_key_by_coord(coord, &key);
+	return (item_id_by_coord(coord) == CTAIL_ID &&
+		!coord_is_unprepped_ctail(coord) &&
+		(get_key_offset(&key) + nr_units_ctail(coord) ==
+		 dclust_get_extension_dsize(hint)));
+}
+#endif
+
+#define thirty_persent(size) ((307 * size) >> 10)
+/* evaluation of data compressibility */
+#define data_is_compressible(osize, isize)		\
+	(osize < (isize - thirty_persent(isize)))
+
+/* This is called only once per file life.
+   Read first logical cluster (of index #0) and estimate its compressibility.
+   Save estimation result in @compressible */
+static int read_check_compressibility(struct inode * inode,
+				      reiser4_cluster_t * clust,
+				      int * compressible)
+{
+	int i;
+	int result;
+	__u32 dst_len;
+	hint_t tmp_hint;
+	hint_t * cur_hint = clust->hint;
+
+	start_check_compressibility(inode, clust, &tmp_hint);
+
+	result = grab_cluster_pages(inode, clust);
+	if (result)
+		return result;
+	/* Read page cluster here */
+	for (i = 0; i < clust->nr_pages; i++) {
+		struct page *page = clust->pages[i];
+		lock_page(page);
+		result = do_readpage_ctail(inode, clust, page,
+					   ZNODE_READ_LOCK);
+		unlock_page(page);
+		if (result)
+			goto error;
+	}
+	tfm_cluster_clr_uptodate(&clust->tc);
+
+	cluster_set_tfm_act(&clust->tc, TFM_WRITE_ACT);
+
+	if (hint_is_valid(&tmp_hint) && !hint_is_unprepped_dclust(&tmp_hint)) {
+		/* lenght of compressed data is known, no need to compress */
+		assert("edward-1511",
+		       znode_is_write_locked(tmp_hint.ext_coord.coord.node));
+		assert("edward-1512",
+		       WITH_DATA(tmp_hint.ext_coord.coord.node,
+				 prepped_dclust_ok(&tmp_hint)));
+		dst_len = dclust_get_extension_dsize(&tmp_hint);
+	}
+	else {
+		tfm_cluster_t * tc = &clust->tc;
+		compression_plugin * cplug = inode_compression_plugin(inode);
+		result = grab_tfm_stream(inode, tc, INPUT_STREAM);
+		if (result)
+			goto error;
+		for (i = 0; i < clust->nr_pages; i++) {
+			char *data;
+			lock_page(clust->pages[i]);
+			BUG_ON(!PageUptodate(clust->pages[i]));
+			data = kmap(clust->pages[i]);
+			memcpy(tfm_stream_data(tc, INPUT_STREAM) + pg_to_off(i),
+			       data, PAGE_CACHE_SIZE);
+			kunmap(clust->pages[i]);
+			unlock_page(clust->pages[i]);
+		}
+		result = grab_tfm_stream(inode, tc, OUTPUT_STREAM);
+		if (result)
+			goto error;
+		result = grab_coa(tc, cplug);
+		if (result)
+			goto error;
+		tc->len = tc->lsize = fsize_to_count(clust, inode);
+		assert("edward-1513", tc->len == inode_cluster_size(inode));
+		dst_len = tfm_stream_size(tc, OUTPUT_STREAM);
+		cplug->compress(get_coa(tc, cplug->h.id, tc->act),
+				tfm_input_data(clust), tc->len,
+				tfm_output_data(clust), &dst_len);
+		assert("edward-1514",
+		       dst_len <= tfm_stream_size(tc, OUTPUT_STREAM));
+	}
+	finish_check_compressibility(inode, clust, cur_hint);
+	*compressible = data_is_compressible(dst_len,
+					     inode_cluster_size(inode));
+	return 0;
+ error:
+	reiser4_release_cluster_pages(clust);
+	return result;
+}
+
+/* Cut disk cluster of index @idx */
+static int cut_disk_cluster(struct inode * inode, cloff_t idx)
+{
+	reiser4_key from, to;
+	assert("edward-1515", inode_file_plugin(inode) ==
+	       file_plugin_by_id(CRYPTCOMPRESS_FILE_PLUGIN_ID));
+	key_by_inode_cryptcompress(inode, clust_to_off(idx, inode), &from);
+	to = from;
+	set_key_offset(&to,
+		       get_key_offset(&from) + inode_cluster_size(inode) - 1);
+	return reiser4_cut_tree(reiser4_tree_by_inode(inode),
+				&from, &to, inode, 0);
+}
+
+static int reserve_cryptcompress2unixfile(struct inode *inode)
+{
+	reiser4_block_nr unformatted_nodes;
+	reiser4_tree *tree;
+
+	tree = reiser4_tree_by_inode(inode);
+
+	/* number of unformatted nodes which will be created */
+	unformatted_nodes = cluster_nrpages(inode); /* N */
+
+	/*
+	 * space required for one iteration of extent->tail conversion:
+	 *
+	 *     1. kill ctail items
+	 *
+	 *     2. insert N unformatted nodes
+	 *
+	 *     3. insert N (worst-case single-block
+	 *     extents) extent units.
+	 *
+	 *     4. drilling to the leaf level by coord_by_key()
+	 *
+	 *     5. possible update of stat-data
+	 *
+	 */
+	grab_space_enable();
+	return reiser4_grab_space
+		(2 * tree->height +
+		 unformatted_nodes  +
+		 unformatted_nodes * estimate_one_insert_into_item(tree) +
+		 1 + estimate_one_insert_item(tree) +
+		 inode_file_plugin(inode)->estimate.update(inode),
+		 BA_CAN_COMMIT);
+}
+
+/* clear flag that indicated conversion and update
+   stat-data with new (unix-file - specific) info */
+static int complete_file_conversion(struct inode *inode)
+{
+	int result;
+
+	grab_space_enable();
+	result =
+	    reiser4_grab_space(inode_file_plugin(inode)->estimate.update(inode),
+			       BA_CAN_COMMIT);
+	if (result == 0) {
+		reiser4_inode_clr_flag(inode, REISER4_FILE_CONV_IN_PROGRESS);
+		result = reiser4_update_sd(inode);
+	}
+	if (result)
+		warning("edward-1452",
+			"Converting %llu to unix-file: update sd failed (%i)",
+			(unsigned long long)get_inode_oid(inode), result);
+	return 0;
+}
+
+
+/* do conversion */
+int cryptcompress2unixfile(struct file *file, struct inode * inode,
+			   reiser4_cluster_t * clust)
+{
+	int i;
+	int result = 0;
+	cryptcompress_info_t *cr_info;
+	unix_file_info_t *uf_info;
+
+	assert("edward-1516", clust->pages[0]->index == 0);
+	assert("edward-1517", clust->hint != NULL);
+
+	/* release all cryptcompress-specific recources */
+	cr_info = cryptcompress_inode_data(inode);
+	result = reserve_cryptcompress2unixfile(inode);
+	if (result)
+		goto out;
+	reiser4_inode_set_flag(inode, REISER4_FILE_CONV_IN_PROGRESS);
+	reiser4_unset_hint(clust->hint);
+	result = cut_disk_cluster(inode, 0);
+	if (result)
+		goto out;
+	/* captured jnode of cluster and assotiated resources (pages,
+	   reserved disk space) were released by ->kill_hook() method
+	   of the item plugin */
+
+	up_write(&cr_info->lock);
+	result = __cryptcompress2unixfile(file, inode);
+	if (result)
+		goto out;
+	/* At this point file is managed by unix file plugin */
+
+	uf_info = unix_file_inode_data(inode);
+	//	get_exclusive_access(uf_info);
+
+	assert("edward-1518",
+	       ergo(jprivate(clust->pages[0]),
+		    !jnode_is_cluster_page(jprivate(clust->pages[0]))));
+	for(i = 0; i < clust->nr_pages; i++) {
+		assert("edward-1519", clust->pages[i]);
+		assert("edward-1520", PageUptodate(clust->pages[i]));
+
+		result = find_or_create_extent(clust->pages[i]);
+		if (result)
+			break;
+	}
+	if (!result) {
+		uf_info->container = UF_CONTAINER_EXTENTS;
+		complete_file_conversion(inode);
+	}
+	//	drop_exclusive_access(uf_info);
+ out:
+	all_grabbed2free();
+	if (result)
+		warning("edward-1453", "Failed to convert file %llu: %i",
+			(unsigned long long)get_inode_oid(inode), result);
+	return result;
+}
+
+/* Check, then perform or disable conversion if needed */
+int write_conversion_hook(struct file *file, struct inode * inode, loff_t pos,
+			  reiser4_cluster_t * clust, int * progress)
+{
+	int result;
+	int check_compress = 0;
+	int compressible = 0;
+
+	if (!conversion_enabled(inode))
+		return 0;
+	result = check_position(inode, pos, clust, &check_compress);
+	if (result || !check_compress)
+		return result;
+	result = read_check_compressibility(inode, clust, &compressible);
+	if (result)
+		return result;
+
+	/* At this point page cluster is grabbed and uptodate */
+	if (!compressible) {
+		result = cryptcompress2unixfile(file, inode, clust);
+		if (result == 0)
+			*progress = 1;
+	}
+	else
+		result = disable_conversion(inode);
+
+	reiser4_release_cluster_pages(clust);
+	return result;
+}
+
+static int setattr_conversion_hook(struct inode * inode, struct iattr *attr)
+{
+	return (attr->ia_valid & ATTR_SIZE ? disable_conversion(inode) : 0);
+}
+
+/* Protected methods of cryptcompress file plugin constructed
+   by the macros above */
+
+/* Wrappers with active protection for:
+   . write_cryptcompress;
+   . setattr_cryptcompress;
+*/
+
+ssize_t prot_write_cryptcompress(struct file *file, const char __user *buf,
+				 size_t count, loff_t *off)
+{
+	int prot = 0;
+	int conv = 0;
+	ssize_t written_cr = 0;
+	ssize_t written_uf = 0;
+	struct inode * inode = file->f_dentry->d_inode;
+	struct rw_semaphore * guard = &reiser4_inode_data(inode)->conv_sem;
+
+	if (should_protect(inode)) {
+		prot = 1;
+		down_write(guard);
+	}
+	written_cr = write_cryptcompress(file, buf, count, off, &conv);
+	if (prot)
+		up_write(guard);
+	if (written_cr < 0)
+		return written_cr;
+	if (conv)
+		written_uf = write_unix_file(file, buf + written_cr,
+					     count - written_cr, off);
+	return written_cr + (written_uf < 0 ? 0 : written_uf);
+}
+
+int prot_setattr_cryptcompress(struct dentry *dentry, struct iattr *attr)
+{
+	struct inode * inode = dentry->d_inode;
+	return PROT_ACTIVE(int, setattr, (dentry, attr),
+			   setattr_conversion_hook(inode, attr));
+}
+
+/* Wrappers with passive protection for:
+   . read_cryptcomperess;
+   . mmap_cryptcompress;
+   . release_cryptcompress;
+   . sendfile_cryptcompress;
+   . delete_object_cryptcompress.
+*/
+ssize_t prot_read_cryptcompress(struct file * file, char __user * buf,
+				size_t size, loff_t * off)
+{
+	struct inode * inode = file->f_dentry->d_inode;
+	return PROT_PASSIVE(ssize_t, read, (file, buf, size, off));
+}
+
+int prot_mmap_cryptcompress(struct file *file, struct vm_area_struct *vma)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+	return PROT_PASSIVE(int, mmap, (file, vma));
+}
+
+int prot_release_cryptcompress(struct inode *inode, struct file *file)
+{
+	return PROT_PASSIVE(int, release, (inode, file));
+}
+
+ssize_t prot_sendfile_cryptcompress(struct file *file, loff_t *ppos,
+				    size_t count, read_actor_t actor,
+				    void *target)
+{
+	struct inode * inode = file->f_dentry->d_inode;
+	return PROT_PASSIVE(ssize_t, sendfile,
+			    (file, ppos, count, actor, target));
+}
+
+int prot_delete_object_cryptcompress(struct inode *inode)
+{
+	return PROT_PASSIVE(int, delete_object, (inode));
+}
+
+/*
+  Local variables:
+  c-indentation-style: "K&R"
+  mode-name: "LC"
+  c-basic-offset: 8
+  tab-width: 8
+  fill-column: 80
+  scroll-step: 1
+  End:
+*/
diff -puN fs/reiser4/plugin/file/tail_conversion.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/file/tail_conversion.c
--- a/fs/reiser4/plugin/file/tail_conversion.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/file/tail_conversion.c
@@ -474,7 +474,7 @@ int tail2extent(unix_file_info_t *uf_inf
 			 * non-exclusive access to a file. It is safe to drop
 			 * EA in the middle of tail2extent conversion because
 			 * write_unix_file/unix_setattr(truncate)/release_unix_file(extent2tail)
-			 * are serialized by uf_info->write semaphore and
+			 * are serialized by reiser4_inode->mutex_write semaphore and
 			 * because read_unix_file works (should at least) on
 			 * partially converted files
 			 */
diff -puN fs/reiser4/plugin/file_ops_readdir.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/file_ops_readdir.c
--- a/fs/reiser4/plugin/file_ops_readdir.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/file_ops_readdir.c
@@ -7,9 +7,9 @@
  * @inode directory. */
 static int is_valid_dir_coord(struct inode *inode, coord_t * coord)
 {
-	return
-	    item_type_by_coord(coord) == DIR_ENTRY_ITEM_TYPE &&
-	    inode_file_plugin(inode)->owns_item(inode, coord);
+	return plugin_of_group(item_plugin_by_coord(coord),
+			       DIR_ENTRY_ITEM_TYPE) &&
+	       inode_file_plugin(inode)->owns_item(inode, coord);
 }
 
 /* compare two logical positions within the same directory */
@@ -31,7 +31,6 @@ static cmp_t dir_pos_cmp(const dir_pos *
 	return result;
 }
 
-
 /* see comment before reiser4_readdir_common() for overview of why "adjustment" is
  * necessary. */
 static void
@@ -430,7 +429,6 @@ static void move_entry(readdir_pos * pos
  *
  */
 
-
 /*
  * prepare for readdir.
  */
diff -puN fs/reiser4/plugin/file_plugin_common.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/file_plugin_common.c
--- a/fs/reiser4/plugin/file_plugin_common.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/file_plugin_common.c
@@ -111,10 +111,10 @@ int adjust_to_parent_common(struct inode
 	 * inherit missing plugins from parent
 	 */
 
-	grab_plugin(object, parent, PSET_FILE);
-	grab_plugin(object, parent, PSET_SD);
-	grab_plugin(object, parent, PSET_FORMATTING);
-	grab_plugin(object, parent, PSET_PERM);
+	grab_plugin_pset(object, parent, PSET_FILE);
+	grab_plugin_pset(object, parent, PSET_SD);
+	grab_plugin_pset(object, parent, PSET_FORMATTING);
+	grab_plugin_pset(object, parent, PSET_PERM);
 	return 0;
 }
 
@@ -137,7 +137,7 @@ int adjust_to_parent_common_dir(struct i
 	 * inherit missing plugins from parent
 	 */
 	for (memb = 0; memb < PSET_LAST; ++memb) {
-		result = grab_plugin(object, parent, memb);
+		result = grab_plugin_pset(object, parent, memb);
 		if (result != 0)
 			break;
 	}
@@ -154,11 +154,11 @@ int adjust_to_parent_cryptcompress(struc
  		return result;
  	assert("edward-1416", parent != NULL);
 
- 	grab_plugin(object, parent, PSET_CLUSTER);
- 	grab_plugin(object, parent, PSET_CIPHER);
- 	grab_plugin(object, parent, PSET_DIGEST);
- 	grab_plugin(object, parent, PSET_COMPRESSION);
- 	grab_plugin(object, parent, PSET_COMPRESSION_MODE);
+ 	grab_plugin_pset(object, parent, PSET_CLUSTER);
+ 	grab_plugin_pset(object, parent, PSET_CIPHER);
+ 	grab_plugin_pset(object, parent, PSET_DIGEST);
+ 	grab_plugin_pset(object, parent, PSET_COMPRESSION);
+ 	grab_plugin_pset(object, parent, PSET_COMPRESSION_MODE);
 
  	return 0;
 }
@@ -200,7 +200,6 @@ int reiser4_delete_object_common(struct 
 	assert("nikita-3420", inode->i_size == 0 || S_ISLNK(inode->i_mode));
 	assert("nikita-3421", inode->i_nlink == 0);
 
-
 	if (!reiser4_inode_get_flag(inode, REISER4_NO_SD)) {
 		reiser4_block_nr reserve;
 
@@ -326,7 +325,7 @@ int owns_item_common_dir(const struct in
 	assert("nikita-1335", inode != NULL);
 	assert("nikita-1334", coord != NULL);
 
-	if (item_type_by_coord(coord) == DIR_ENTRY_ITEM_TYPE)
+	if (plugin_of_group(item_plugin_by_coord(coord), DIR_ENTRY_ITEM_TYPE))
 		return get_key_locality(item_key_by_coord(coord, &item_key)) ==
 		    get_inode_oid(inode);
 	else
@@ -745,6 +744,64 @@ locate_inode_sd(struct inode *inode,
 	return result;
 }
 
+#if REISER4_DEBUG
+static int all_but_offset_key_eq(const reiser4_key * k1, const reiser4_key * k2)
+{
+	return (get_key_locality(k1) == get_key_locality(k2) &&
+		get_key_type(k1) == get_key_type(k2) &&
+		get_key_band(k1) == get_key_band(k2) &&
+		get_key_ordering(k1) == get_key_ordering(k2) &&
+		get_key_objectid(k1) == get_key_objectid(k2));
+}
+
+#include "../tree_walk.h"
+
+/* make some checks before and after stat-data resize operation */
+static int check_sd_resize(struct inode * inode, coord_t * coord,
+			   int length, int progress /* 1 means after resize */)
+{
+	int ret = 0;
+	lock_handle left_lock;
+	coord_t left_coord;
+	reiser4_key left_key;
+	reiser4_key key;
+
+	if (inode_file_plugin(inode) !=
+	    file_plugin_by_id(CRYPTCOMPRESS_FILE_PLUGIN_ID))
+		return 0;
+	if (!length)
+		return 0;
+	if (coord->item_pos != 0)
+		return 0;
+
+	init_lh(&left_lock);
+	ret = reiser4_get_left_neighbor(&left_lock,
+					coord->node,
+					ZNODE_WRITE_LOCK,
+					GN_CAN_USE_UPPER_LEVELS);
+	if (ret == -E_REPEAT || ret == -E_NO_NEIGHBOR ||
+	    ret == -ENOENT || ret == -EINVAL
+	    || ret == -E_DEADLOCK) {
+		ret = 0;
+		goto exit;
+	}
+	ret = zload(left_lock.node);
+	if (ret)
+		goto exit;
+	coord_init_last_unit(&left_coord, left_lock.node);
+	item_key_by_coord(&left_coord, &left_key);
+	item_key_by_coord(coord, &key);
+
+	if (all_but_offset_key_eq(&key, &left_key))
+		/* corruption occured */
+		ret = 1;
+	zrelse(left_lock.node);
+ exit:
+	done_lh(&left_lock);
+	return ret;
+}
+#endif
+
 /* update stat-data at @coord */
 static int
 update_sd_at(struct inode *inode, coord_t * coord, reiser4_key * key,
@@ -770,9 +827,18 @@ update_sd_at(struct inode *inode, coord_
 
 	/* if inode has non-standard plugins, add appropriate stat data
 	 * extension */
-	if (state->plugin_mask != 0)
+	if (state->extmask & (1 << PLUGIN_STAT)) {
+		if (state->plugin_mask == 0)
+			inode_clr_extension(inode, PLUGIN_STAT);
+	} else if (state->plugin_mask != 0)
 		inode_set_extension(inode, PLUGIN_STAT);
 
+	if (state->extmask & (1 << HEIR_STAT)) {
+		if (state->heir_mask == 0)
+			inode_clr_extension(inode, HEIR_STAT);
+	} else if (state->heir_mask != 0)
+			inode_set_extension(inode, HEIR_STAT);
+
 	/* data.length is how much space to add to (or remove
 	   from if negative) sd */
 	if (!reiser4_inode_get_flag(inode, REISER4_SDLEN_KNOWN)) {
@@ -787,10 +853,15 @@ update_sd_at(struct inode *inode, coord_
 
 	/* if on-disk stat data is of different length than required
 	   for this inode, resize it */
+
 	if (data.length != 0) {
 		data.data = NULL;
 		data.user = 0;
 
+		assert("edward-1441",
+		       !check_sd_resize(inode, coord,
+					data.length, 0/* before resize */));
+
 		/* insertion code requires that insertion point (coord) was
 		 * between units. */
 		coord->between = AFTER_UNIT;
@@ -811,8 +882,10 @@ update_sd_at(struct inode *inode, coord_
 				return result;
 			loaded = coord->node;
 		}
+		assert("edward-1442",
+		       !check_sd_resize(inode, coord,
+					data.length, 1/* after resize */));
 	}
-
 	area = item_body_by_coord(coord);
 	spin_lock_inode(inode);
 	result = data.iplug->s.sd.save(inode, &area);
diff -puN fs/reiser4/plugin/hash.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/hash.c
--- a/fs/reiser4/plugin/hash.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/hash.c
@@ -247,7 +247,9 @@ static __u64 hash_deg(const unsigned cha
 	return 0xc0c0c0c010101010ull;
 }
 
-static int change_hash(struct inode *inode, reiser4_plugin * plugin)
+static int change_hash(struct inode *inode,
+		       reiser4_plugin * plugin,
+		       pset_member memb)
 {
 	int result;
 
@@ -255,16 +257,17 @@ static int change_hash(struct inode *ino
 	assert("nikita-3504", plugin != NULL);
 
 	assert("nikita-3505", is_reiser4_inode(inode));
-	assert("nikita-3506", inode_dir_plugin(inode) != NULL);
 	assert("nikita-3507", plugin->h.type_id == REISER4_HASH_PLUGIN_TYPE);
 
+	if (!plugin_of_group(inode_file_plugin(inode), REISER4_DIRECTORY_FILE))
+		return RETERR(-EINVAL);
+
 	result = 0;
 	if (inode_hash_plugin(inode) == NULL ||
 	    inode_hash_plugin(inode)->h.id != plugin->h.id) {
 		if (is_dir_empty(inode) == 0)
-			result =
-			    plugin_set_hash(&reiser4_inode_data(inode)->pset,
-					    &plugin->hash);
+			result = aset_set_unsafe(&reiser4_inode_data(inode)->pset,
+						 PSET_HASH, plugin);
 		else
 			result = RETERR(-ENOTEMPTY);
 
diff -puN fs/reiser4/plugin/inode_ops.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/inode_ops.c
--- a/fs/reiser4/plugin/inode_ops.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/inode_ops.c
@@ -13,7 +13,6 @@
 #include <linux/quotaops.h>
 #include <linux/namei.h>
 
-
 static int create_vfs_object(struct inode *parent, struct dentry *dentry,
 		      reiser4_object_create_data *data);
 
@@ -32,10 +31,17 @@ int reiser4_create_common(struct inode *
 			  int mode, struct nameidata *nameidata)
 {
 	reiser4_object_create_data data;
+	file_plugin *fplug;
 
 	memset(&data, 0, sizeof data);
 	data.mode = S_IFREG | mode;
-	data.id = inode_regular_plugin(parent)->id;
+	fplug = child_create_plugin(parent) ? : inode_create_plugin(parent);
+	if (!plugin_of_group(fplug, REISER4_REGULAR_FILE)) {
+		warning("vpf-1900", "'%s' is not a regular file plugin.",
+			fplug->h.label);
+		return RETERR(-EIO);
+	}
+	data.id = fplug->h.id;
 	return create_vfs_object(parent, dentry, &data);
 }
 
@@ -595,7 +601,8 @@ static int do_create_vfs_child(reiser4_o
 	memset(&entry, 0, sizeof entry);
 	entry.obj = object;
 
-	plugin_set_file(&reiser4_inode_data(object)->pset, obj_plug);
+	set_plugin(&reiser4_inode_data(object)->pset, PSET_FILE,
+		   file_plugin_to_plugin(obj_plug));
 	result = obj_plug->set_plug_in_inode(object, parent, data);
 	if (result) {
 		warning("nikita-431", "Cannot install plugin %i on %llx",
@@ -622,6 +629,8 @@ static int do_create_vfs_child(reiser4_o
 	result = obj_plug->adjust_to_parent(object,
 					    parent,
 					    object->i_sb->s_root->d_inode);
+	if (result == 0)
+		result = finish_pset(object);
 	if (result != 0) {
 		warning("nikita-432", "Cannot inherit from %llx to %llx",
 			(unsigned long long)get_inode_oid(parent),
diff -puN fs/reiser4/plugin/inode_ops_rename.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/inode_ops_rename.c
--- a/fs/reiser4/plugin/inode_ops_rename.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/inode_ops_rename.c
@@ -29,7 +29,9 @@ static int replace_name(struct inode *to
 	if (result != 0)
 		return result;
 	from_item = item_plugin_by_coord(from_coord);
-	if (item_type_by_coord(from_coord) == DIR_ENTRY_ITEM_TYPE) {
+	if (plugin_of_group(item_plugin_by_coord(from_coord),
+			    DIR_ENTRY_ITEM_TYPE))
+	{
 		reiser4_key to_key;
 
 		build_sd_key(to_inode, &to_key);
@@ -392,7 +394,7 @@ int reiser4_rename_common(struct inode *
 
 	old_entry = kmalloc(3 * sizeof(*old_entry) + 2 * sizeof(*new_lh) +
 			    sizeof(*dotdot_name) + sizeof(*dataonstack),
-			    GFP_KERNEL);
+			    reiser4_ctx_gfp_mask_get());
 	if (old_entry == NULL) {
 		context_set_commit_async(ctx);
 		reiser4_exit_context(ctx);
diff -puN fs/reiser4/plugin/item/ctail.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/item/ctail.c
--- a/fs/reiser4/plugin/item/ctail.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/item/ctail.c
@@ -56,7 +56,7 @@ static loff_t off_by_coord(const coord_t
 	return get_key_offset(item_key_by_coord(coord, &key));
 }
 
-static int coord_is_unprepped_ctail(const coord_t * coord)
+int coord_is_unprepped_ctail(const coord_t * coord)
 {
 	assert("edward-1233", coord != NULL);
 	assert("edward-1234", item_id_by_coord(coord) == CTAIL_ID);
@@ -142,8 +142,8 @@ int mergeable_ctail(const coord_t * p1, 
 	reiser4_key key1, key2;
 
 	assert("edward-62", item_id_by_coord(p1) == CTAIL_ID);
-	assert("edward-61",
-	       item_type_by_coord(p1) == UNIX_FILE_METADATA_ITEM_TYPE);
+	assert("edward-61", plugin_of_group(item_plugin_by_coord(p1),
+					    UNIX_FILE_METADATA_ITEM_TYPE));
 
 	if (item_id_by_coord(p2) != CTAIL_ID) {
 		/* second item is of another type */
@@ -369,9 +369,11 @@ kill_hook_ctail(const coord_t * coord, p
 		item_key_by_coord(coord, &key);
 
 		if (from == 0 && is_disk_cluster_key(&key, coord)) {
+			/* disk cluster is killed */
 			cloff_t start =
 			    off_to_clust(get_key_offset(&key), inode);
 			truncate_page_cluster(inode, start);
+			inode_sub_bytes(inode, inode_cluster_size(inode));
 		}
 	}
 	return 0;
@@ -522,7 +524,7 @@ int read_ctail(struct file *file UNUSED_
 		memcpy(f->data, (char *)first_unit(coord),
 		       (size_t) nr_units_ctail(coord));
 
-	dclust_set_extension(hint);
+	dclust_set_extension_shift(hint);
 	mark_page_accessed(znode_page(coord->node));
 	move_flow_forward(f, nr_units_ctail(coord));
 
@@ -532,9 +534,10 @@ int read_ctail(struct file *file UNUSED_
 /* Reads a disk cluster consists of ctail items,
    attaches a transform stream with plain text */
 int ctail_read_disk_cluster(reiser4_cluster_t * clust, struct inode *inode,
-			    int write)
+			    znode_lock_mode mode)
 {
 	int result;
+	assert("edward-1450", mode == ZNODE_READ_LOCK || ZNODE_WRITE_LOCK);
 	assert("edward-671", clust->hint != NULL);
 	assert("edward-140", clust->dstat == INVAL_DISK_CLUSTER);
 	assert("edward-672", cryptcompress_inode_ok(inode));
@@ -544,18 +547,15 @@ int ctail_read_disk_cluster(reiser4_clus
 	if (result)
 		return result;
 
-	result = find_disk_cluster(clust, inode, 1 /* read */ , write);
+	result = find_disk_cluster(clust, inode, 1 /* read items */, mode);
 	assert("edward-1340", !result);
 	if (result)
 		return result;
-	if (!write)
+	if (mode == ZNODE_READ_LOCK)
 		/* write still need the lock to insert unprepped
 		   items, etc... */
 		put_hint_cluster(clust, inode, ZNODE_READ_LOCK);
 
-	assert("edward-673",
-	       ergo(write, znode_is_write_locked(clust->hint->lh.node)));
-
 	if (clust->dstat == FAKE_DISK_CLUSTER ||
 	    clust->dstat == UNPR_DISK_CLUSTER) {
 		tfm_cluster_set_uptodate(&clust->tc);
@@ -573,7 +573,7 @@ int ctail_read_disk_cluster(reiser4_clus
 
 /* read one locked page */
 int do_readpage_ctail(struct inode * inode, reiser4_cluster_t * clust,
-		      struct page *page)
+		      struct page *page, znode_lock_mode mode)
 {
 	int ret;
 	unsigned cloff;
@@ -589,7 +589,7 @@ int do_readpage_ctail(struct inode * ino
 	if (!tfm_cluster_is_uptodate(&clust->tc)) {
 		clust->index = pg_to_clust(page->index, inode);
 		unlock_page(page);
-		ret = ctail_read_disk_cluster(clust, inode, 0 /* read */ );
+		ret = ctail_read_disk_cluster(clust, inode, mode);
 		lock_page(page);
 		if (ret)
 			return ret;
@@ -661,7 +661,7 @@ int readpage_ctail(void *vp, struct page
 	assert("edward-118", page->mapping && page->mapping->host);
 	assert("edward-867", !tfm_cluster_is_uptodate(&clust->tc));
 
-	hint = kmalloc(sizeof(*hint), GFP_KERNEL);
+	hint = kmalloc(sizeof(*hint), reiser4_ctx_gfp_mask_get());
 	if (hint == NULL)
 		return RETERR(-ENOMEM);
 	clust->hint = hint;
@@ -671,7 +671,8 @@ int readpage_ctail(void *vp, struct page
 		return result;
 	}
 	assert("vs-25", hint->ext_coord.lh == &hint->lh);
-	result = do_readpage_ctail(page->mapping->host, clust, page);
+	result = do_readpage_ctail(page->mapping->host, clust, page,
+				   ZNODE_READ_LOCK);
 
 	assert("edward-213", PageLocked(page));
 	assert("edward-1163", ergo(!result, PageUptodate(page)));
@@ -688,8 +689,7 @@ int readpage_ctail(void *vp, struct page
 	return result;
 }
 
-/* This unconditionally reads a disk cluster.
-   Helper function for ->readpages() */
+/* Helper function for ->readpages() */
 static int
 ctail_read_page_cluster(reiser4_cluster_t * clust, struct inode *inode)
 {
@@ -702,7 +702,7 @@ ctail_read_page_cluster(reiser4_cluster_
 	result = prepare_page_cluster(inode, clust, 0 /* do not capture */ );
 	if (result)
 		return result;
-	result = ctail_read_disk_cluster(clust, inode, 0 /* read */ );
+	result = ctail_read_disk_cluster(clust, inode, ZNODE_READ_LOCK);
 	if (result)
 		goto out;
 	/* at this point stream with valid plain text is attached */
@@ -711,7 +711,7 @@ ctail_read_page_cluster(reiser4_cluster_
 	for (i = 0; i < clust->nr_pages; i++) {
 		struct page *page = clust->pages[i];
 		lock_page(page);
-		result = do_readpage_ctail(inode, clust, page);
+		result = do_readpage_ctail(inode, clust, page, ZNODE_READ_LOCK);
 		unlock_page(page);
 		if (result)
 			break;
@@ -731,13 +731,11 @@ assert("edward-214", ergo(!list_empty(pa
        list_to_page(pages)->index < list_to_next_page(pages)->index))
 #endif
 
-/* plugin->u.item.s.file.readpages
-   Populate an address space with some page clusters,
-   and start reads against them.
-   FIXME-EDWARD: this function should return errors?
-*/
+/* Populate an address space with some page clusters,
+ * and start reads against them.
+ */
 int readpages_ctail(struct file *file, struct address_space *mapping,
-		struct list_head *pages)
+		    struct list_head *pages)
 {
 	int ret = 0;
 	hint_t *hint;
@@ -754,7 +752,7 @@ int readpages_ctail(struct file *file, s
 	pagevec_init(&lru_pvec, 0);
 	cluster_init_read(&clust, NULL);
 	clust.file = file;
-	hint = kmalloc(sizeof(*hint), GFP_KERNEL);
+	hint = kmalloc(sizeof(*hint), reiser4_ctx_gfp_mask_get());
 	if (hint == NULL) {
 		warning("vs-28", "failed to allocate hint");
 		ret = RETERR(-ENOMEM);
@@ -777,7 +775,8 @@ int readpages_ctail(struct file *file, s
 	while (!list_empty(pages)) {
 		page = list_to_page(pages);
 		list_del(&page->lru);
-		if (add_to_page_cache(page, mapping, page->index, GFP_KERNEL)) {
+		if (add_to_page_cache(page, mapping, page->index,
+				      reiser4_ctx_gfp_mask_get())) {
 			page_cache_release(page);
 			continue;
 		}
@@ -796,7 +795,7 @@ int readpages_ctail(struct file *file, s
 		assert("edward-869", !tfm_cluster_is_uptodate(&clust.tc));
 		lock_page(page);
 
-		ret = do_readpage_ctail(inode, &clust, page);
+		ret = do_readpage_ctail(inode, &clust, page, ZNODE_READ_LOCK);
 		if (!pagevec_add(&lru_pvec, page))
 			__pagevec_lru_add(&lru_pvec);
 		if (ret) {
@@ -1006,8 +1005,6 @@ ctail_insert_unprepped_cluster(reiser4_c
 	assert("edward-1245", clust->hint != NULL);
 	assert("edward-1246", clust->dstat == FAKE_DISK_CLUSTER);
 	assert("edward-1247", clust->reserved == 1);
-	assert("edward-1248", get_current_context()->grabbed_blocks ==
-	       estimate_insert_cluster(inode));
 
 	result = get_disk_cluster_locked(clust, inode, ZNODE_WRITE_LOCK);
 	if (cbk_errored(result))
@@ -1153,7 +1150,7 @@ static int alloc_item_convert_data(conve
 	assert("edward-816", sq != NULL);
 	assert("edward-817", sq->itm == NULL);
 
-	sq->itm = kmalloc(sizeof(*sq->itm), GFP_KERNEL);
+	sq->itm = kmalloc(sizeof(*sq->itm), reiser4_ctx_gfp_mask_get());
 	if (sq->itm == NULL)
 		return RETERR(-ENOMEM);
 	return 0;
@@ -1175,7 +1172,7 @@ static int alloc_convert_data(flush_pos_
 	assert("edward-821", pos != NULL);
 	assert("edward-822", pos->sq == NULL);
 
-	pos->sq = kmalloc(sizeof(*pos->sq), GFP_KERNEL);
+	pos->sq = kmalloc(sizeof(*pos->sq), reiser4_ctx_gfp_mask_get());
 	if (!pos->sq)
 		return RETERR(-ENOMEM);
 	memset(pos->sq, 0, sizeof(*pos->sq));
@@ -1230,7 +1227,8 @@ static int attach_convert_idata(flush_po
 	assert("edward-249", pos->child != NULL);
 	assert("edward-251", inode != NULL);
 	assert("edward-682", cryptcompress_inode_ok(inode));
-	assert("edward-252", fplug == file_plugin_by_id(CRC_FILE_PLUGIN_ID));
+	assert("edward-252",
+	       fplug == file_plugin_by_id(CRYPTCOMPRESS_FILE_PLUGIN_ID));
 	assert("edward-473",
 	       item_plugin_by_coord(&pos->coord) ==
 	       item_plugin_by_id(CTAIL_ID));
diff -puN fs/reiser4/plugin/item/ctail.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/item/ctail.h
--- a/fs/reiser4/plugin/item/ctail.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/item/ctail.h
@@ -5,6 +5,8 @@
 
 /* cryptcompress object item. See ctail.c for description. */
 
+/* number of units and cluster_shift of ctail item
+   that represents unprepped disk cluster */
 #define UCTAIL_NR_UNITS 1
 #define UCTAIL_SHIFT 0xff
 
@@ -26,8 +28,10 @@ typedef enum {
 } dc_item_stat;
 
 typedef struct {
-	int shift;		/* we keep here a cpu value of cluster_shift field
-				   of ctail_item_format (see above) */
+	int shift; /* this contains cluster_shift extracted from
+		      ctail_item_format (above), or UCTAIL_SHIFT
+		      (the last one is for unprepped disk clusters) */
+	int dsize; /* size of a prepped disk cluster */
 } ctail_coord_extension_t;
 
 struct cut_list;
diff -puN fs/reiser4/plugin/item/item.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/item/item.c
--- a/fs/reiser4/plugin/item/item.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/item/item.c
@@ -75,17 +75,6 @@ void obtain_item_plugin(const coord_t * 
 	       node_plugin_by_node(coord->node)->plugin_by_coord(coord));
 }
 
-/* return type of item at @coord */
-item_type_id item_type_by_coord(const coord_t * coord /* coord to query */ )
-{
-	assert("nikita-333", coord != NULL);
-	assert("nikita-334", coord->node != NULL);
-	assert("nikita-335", znode_is_loaded(coord->node));
-	assert("nikita-336", item_plugin_by_coord(coord) != NULL);
-
-	return item_plugin_by_coord(coord)->b.item_type;
-}
-
 /* return id of item */
 /* Audited by: green(2002.06.15) */
 item_id item_id_by_coord(const coord_t * coord /* coord to query */ )
@@ -174,7 +163,7 @@ static reiser4_key *max_key_inside_singl
 }
 
 /* ->nr_units() method for items consisting of exactly one unit always */
-static pos_in_node_t
+pos_in_node_t
 nr_units_single_unit(const coord_t * coord UNUSED_ARG /* coord of item */ )
 {
 	return 1;
@@ -285,7 +274,7 @@ int item_is_tail(const coord_t * item)
 int item_is_statdata(const coord_t * item)
 {
 	assert("vs-516", coord_is_existing_item(item));
-	return item_type_by_coord(item) == STAT_DATA_ITEM_TYPE;
+	return plugin_of_group(item_plugin_by_coord(item), STAT_DATA_ITEM_TYPE);
 }
 
 int item_is_ctail(const coord_t * item)
@@ -294,7 +283,9 @@ int item_is_ctail(const coord_t * item)
 	return item_id_by_coord(item) == CTAIL_ID;
 }
 
-static int change_item(struct inode *inode, reiser4_plugin * plugin)
+static int change_item(struct inode *inode,
+		       reiser4_plugin * plugin,
+		       pset_member memb)
 {
 	/* cannot change constituent item (sd, or dir_item) */
 	return RETERR(-EINVAL);
@@ -313,13 +304,13 @@ item_plugin item_plugins[LAST_ITEM_ID] =
 		.h = {
 			.type_id = REISER4_ITEM_PLUGIN_TYPE,
 			.id = STATIC_STAT_DATA_ID,
+			.groups = (1 << STAT_DATA_ITEM_TYPE),
 			.pops = &item_plugin_ops,
 			.label = "sd",
 			.desc = "stat-data",
 			.linkage = {NULL, NULL}
 		},
 		.b = {
-			.item_type = STAT_DATA_ITEM_TYPE,
 			.max_key_inside = max_key_inside_single_key,
 			.can_contain_key = NULL,
 			.mergeable = not_mergeable,
@@ -362,13 +353,13 @@ item_plugin item_plugins[LAST_ITEM_ID] =
 		.h = {
 			.type_id = REISER4_ITEM_PLUGIN_TYPE,
 			.id = SIMPLE_DIR_ENTRY_ID,
+			.groups = (1 << DIR_ENTRY_ITEM_TYPE),
 			.pops = &item_plugin_ops,
 			.label = "de",
 			.desc = "directory entry",
 			.linkage = {NULL, NULL}
 		},
 		.b = {
-			.item_type = DIR_ENTRY_ITEM_TYPE,
 			.max_key_inside = max_key_inside_single_key,
 			.can_contain_key = NULL,
 			.mergeable = NULL,
@@ -415,13 +406,13 @@ item_plugin item_plugins[LAST_ITEM_ID] =
 		.h = {
 			.type_id = REISER4_ITEM_PLUGIN_TYPE,
 			.id = COMPOUND_DIR_ID,
+			.groups = (1 << DIR_ENTRY_ITEM_TYPE),
 			.pops = &item_plugin_ops,
 			.label = "cde",
 			.desc = "compressed directory entry",
 			.linkage = {NULL, NULL}
 		},
 		.b = {
-			.item_type = DIR_ENTRY_ITEM_TYPE,
 			.max_key_inside = max_key_inside_cde,
 			.can_contain_key = can_contain_key_cde,
 			.mergeable = mergeable_cde,
@@ -468,13 +459,13 @@ item_plugin item_plugins[LAST_ITEM_ID] =
 		.h = {
 			.type_id = REISER4_ITEM_PLUGIN_TYPE,
 			.id = NODE_POINTER_ID,
+			.groups = (1 << INTERNAL_ITEM_TYPE),
 			.pops = NULL,
 			.label = "internal",
 			.desc = "internal item",
 			.linkage = {NULL, NULL}
 		},
 		.b = {
-			.item_type = INTERNAL_ITEM_TYPE,
 			.max_key_inside = NULL,
 			.can_contain_key = NULL,
 			.mergeable = mergeable_internal,
@@ -517,13 +508,13 @@ item_plugin item_plugins[LAST_ITEM_ID] =
 		.h = {
 			.type_id = REISER4_ITEM_PLUGIN_TYPE,
 			.id = EXTENT_POINTER_ID,
+			.groups = (1 << UNIX_FILE_METADATA_ITEM_TYPE),
 			.pops = NULL,
 			.label = "extent",
 			.desc = "extent item",
 			.linkage = {NULL, NULL}
 		},
 		.b = {
-			.item_type = UNIX_FILE_METADATA_ITEM_TYPE,
 			.max_key_inside = max_key_inside_extent,
 			.can_contain_key = can_contain_key_extent,
 			.mergeable = mergeable_extent,
@@ -572,13 +563,13 @@ item_plugin item_plugins[LAST_ITEM_ID] =
 		.h = {
 			.type_id = REISER4_ITEM_PLUGIN_TYPE,
 			.id = FORMATTING_ID,
+			.groups = (1 << UNIX_FILE_METADATA_ITEM_TYPE),
 			.pops = NULL,
 			.label = "body",
 			.desc = "body (or tail?) item",
 			.linkage = {NULL, NULL}
 		},
 		.b = {
-			.item_type = UNIX_FILE_METADATA_ITEM_TYPE,
 			.max_key_inside = max_key_inside_tail,
 			.can_contain_key = can_contain_key_tail,
 			.mergeable = mergeable_tail,
@@ -625,13 +616,13 @@ item_plugin item_plugins[LAST_ITEM_ID] =
 		.h = {
 			.type_id = REISER4_ITEM_PLUGIN_TYPE,
 			.id = CTAIL_ID,
+			.groups = (1 << UNIX_FILE_METADATA_ITEM_TYPE),
 			.pops = NULL,
 			.label = "ctail",
 			.desc = "cryptcompress tail item",
 			.linkage = {NULL, NULL}
 		},
 		.b = {
-			.item_type = UNIX_FILE_METADATA_ITEM_TYPE,
 			.max_key_inside = max_key_inside_tail,
 			.can_contain_key = can_contain_key_ctail,
 			.mergeable = mergeable_ctail,
@@ -679,13 +670,13 @@ item_plugin item_plugins[LAST_ITEM_ID] =
 		.h = {
 			.type_id = REISER4_ITEM_PLUGIN_TYPE,
 			.id = BLACK_BOX_ID,
+			.groups = (1 << OTHER_ITEM_TYPE),
 			.pops = NULL,
 			.label = "blackbox",
 			.desc = "black box item",
 			.linkage = {NULL, NULL}
 		},
 		.b = {
-			.item_type = OTHER_ITEM_TYPE,
 			.max_key_inside = NULL,
 			.can_contain_key = NULL,
 			.mergeable = not_mergeable,
diff -puN fs/reiser4/plugin/item/item.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/item/item.h
--- a/fs/reiser4/plugin/item/item.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/item/item.h
@@ -35,8 +35,6 @@ typedef enum {
    support or at least explicitly fail to support by setting the
    pointer to null. */
 typedef struct {
-	item_type_id item_type;
-
 	/* operations called by balancing
 
 	   It is interesting to consider that some of these item
@@ -76,8 +74,12 @@ typedef struct {
 	 */
 	int (*mergeable) (const coord_t *, const coord_t *);
 
-	/* number of atomic things in an item */
-	 pos_in_node_t(*nr_units) (const coord_t *);
+	/* number of atomic things in an item.
+	   NOTE FOR CONTRIBUTORS: use a generic method
+	   nr_units_single_unit() for solid (atomic) items, as
+	   tree operations use it as a criterion of solidness
+	   (see is_solid_item macro) */
+	pos_in_node_t(*nr_units) (const coord_t *);
 
 	/* search within item for a unit within the item, and return a
 	   pointer to it.  This can be used to calculate how many
@@ -288,6 +290,8 @@ struct item_plugin {
 
 };
 
+#define is_solid_item(iplug) ((iplug)->b.nr_units == nr_units_single_unit)
+
 static inline item_id item_id_by_plugin(item_plugin * plugin)
 {
 	return plugin->h.id;
@@ -328,14 +332,13 @@ extern int item_is_statdata(const coord_
 extern int item_is_ctail(const coord_t *);
 
 extern pos_in_node_t item_length_by_coord(const coord_t * coord);
-extern item_type_id item_type_by_coord(const coord_t * coord);
+extern pos_in_node_t nr_units_single_unit(const coord_t * coord);
 extern item_id item_id_by_coord(const coord_t * coord /* coord to query */ );
 extern reiser4_key *item_key_by_coord(const coord_t * coord, reiser4_key * key);
 extern reiser4_key *max_item_key_by_coord(const coord_t *, reiser4_key *);
 extern reiser4_key *unit_key_by_coord(const coord_t * coord, reiser4_key * key);
 extern reiser4_key *max_unit_key_by_coord(const coord_t * coord,
 					  reiser4_key * key);
-
 extern void obtain_item_plugin(const coord_t * coord);
 
 #if defined(REISER4_DEBUG)
@@ -359,7 +362,7 @@ static inline item_plugin *item_plugin_b
 static inline int item_is_internal(const coord_t * item)
 {
 	assert("vs-483", coord_is_existing_item(item));
-	return item_type_by_coord(item) == INTERNAL_ITEM_TYPE;
+	return plugin_of_group(item_plugin_by_coord(item), INTERNAL_ITEM_TYPE);
 }
 
 extern void item_body_by_coord_hard(coord_t * coord);
diff -puN fs/reiser4/plugin/item/static_stat.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/item/static_stat.c
--- a/fs/reiser4/plugin/item/static_stat.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/item/static_stat.c
@@ -345,7 +345,7 @@ static int absent_unix_sd(struct inode *
 	inode->i_gid = get_super_private(inode->i_sb)->default_gid;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 	inode_set_bytes(inode, inode->i_size);
-	/* mark inode as lightweight, so that caller (reiser4_lookup) will
+	/* mark inode as lightweight, so that caller (lookup_common) will
 	   complete initialisation by copying [ug]id from a parent. */
 	reiser4_inode_set_flag(inode, REISER4_LIGHT_WEIGHT);
 	return 0;
@@ -565,10 +565,12 @@ static int save_flags_sd(struct inode *i
 static int absent_plugin_sd(struct inode *inode);
 static int present_plugin_sd(struct inode *inode /* object being processed */ ,
 			     char **area /* position in stat-data */ ,
-			     int *len /* remaining length */ )
+			     int *len /* remaining length */,
+			     int is_pset /* 1 if plugin set, 0 if heir set. */)
 {
 	reiser4_plugin_stat *sd;
 	reiser4_plugin *plugin;
+	reiser4_inode *info;
 	int i;
 	__u16 mask;
 	int result;
@@ -584,6 +586,7 @@ static int present_plugin_sd(struct inod
 		return not_enough_space(inode, "plugin");
 
 	sd = (reiser4_plugin_stat *) * area;
+	info = reiser4_inode_data(inode);
 
 	mask = 0;
 	num_of_plugins = le16_to_cpu(get_unaligned(&sd->plugins_no));
@@ -599,10 +602,12 @@ static int present_plugin_sd(struct inod
 			return not_enough_space(inode, "additional plugin");
 
 		memb = le16_to_cpu(get_unaligned(&slot->pset_memb));
-		type = pset_member_to_type_unsafe(memb);
+		type = aset_member_to_type_unsafe(memb);
+
 		if (type == REISER4_PLUGIN_TYPES) {
 			warning("nikita-3502",
-				"wrong pset member (%i) for %llu", memb,
+				"wrong %s member (%i) for %llu", is_pset ?
+				"pset" : "hset", memb,
 				(unsigned long long)get_inode_oid(inode));
 			return RETERR(-EINVAL);
 		}
@@ -622,23 +627,31 @@ static int present_plugin_sd(struct inod
 		}
 		move_on(len, area, sizeof *slot);
 		/* load plugin data, if any */
-		if (plugin->h.pops != NULL && plugin->h.pops->load) {
+		if (plugin->h.pops != NULL && plugin->h.pops->load)
 			result = plugin->h.pops->load(inode, plugin, area, len);
-			if (result != 0)
-				return result;
-		} else
-			result = grab_plugin_from(inode, memb, plugin);
-	}
-	/* if object plugin wasn't loaded from stat-data, guess it by
-	   mode bits */
-	plugin = file_plugin_to_plugin(inode_file_plugin(inode));
-	if (plugin == NULL)
-		result = absent_plugin_sd(inode);
+		else
+			result = aset_set_unsafe(is_pset ? &info->pset :
+						 &info->hset, memb, plugin);
+		if (result)
+			return result;
+	}
+	if (is_pset) {
+		/* if object plugin wasn't loaded from stat-data, guess it by
+		   mode bits */
+		plugin = file_plugin_to_plugin(inode_file_plugin(inode));
+		if (plugin == NULL)
+			result = absent_plugin_sd(inode);
+		info->plugin_mask = mask;
+	} else
+		info->heir_mask = mask;
 
-	reiser4_inode_data(inode)->plugin_mask = mask;
 	return result;
 }
 
+static int present_pset_sd(struct inode *inode, char **area, int *len) {
+	return present_plugin_sd(inode, area, len, 1 /* pset */);
+}
+
 /* Determine object plugin for @inode based on i_mode.
 
    Many objects in reiser4 file system are controlled by standard object
@@ -681,10 +694,10 @@ guess_plugin_by_mode(struct inode *inode
 		break;
 	}
 	info = reiser4_inode_data(inode);
-	plugin_set_file(&info->pset,
-			(fplug_id >= 0) ? file_plugin_by_id(fplug_id) : NULL);
-	plugin_set_dir(&info->pset,
-		       (dplug_id >= 0) ? dir_plugin_by_id(dplug_id) : NULL);
+	set_plugin(&info->pset, PSET_FILE, (fplug_id >= 0) ?
+		   plugin_by_id(REISER4_FILE_PLUGIN_TYPE, fplug_id) : NULL);
+	set_plugin(&info->pset, PSET_DIR, (dplug_id >= 0) ?
+		   plugin_by_id(REISER4_DIR_PLUGIN_TYPE, dplug_id) : NULL);
 	return 0;
 }
 
@@ -709,13 +722,19 @@ static int absent_plugin_sd(struct inode
 /* Audited by: green(2002.06.14) */
 static int len_for(reiser4_plugin * plugin /* plugin to save */ ,
 		   struct inode *inode /* object being processed */ ,
-		   pset_member memb, int len)
+		   pset_member memb,
+		   int len, int is_pset)
 {
 	reiser4_inode *info;
 	assert("nikita-661", inode != NULL);
 
+	if (plugin == NULL)
+		return len;
+
 	info = reiser4_inode_data(inode);
-	if (plugin != NULL && (info->plugin_mask & (1 << memb))) {
+	if (is_pset ?
+	    info->plugin_mask & (1 << memb) :
+	    info->heir_mask & (1 << memb)) {
 		len += sizeof(reiser4_plugin_slot);
 		if (plugin->h.pops && plugin->h.pops->save_len != NULL) {
 			/* non-standard plugin, call method */
@@ -730,33 +749,44 @@ static int len_for(reiser4_plugin * plug
 
 /* calculate how much space is required to save state of all plugins,
     associated with inode */
-static int save_len_plugin_sd(struct inode *inode /* object being processed */ )
+static int save_len_plugin_sd(struct inode *inode /* object being processed */,
+			      int is_pset)
 {
 	int len;
+	int last;
 	reiser4_inode *state;
 	pset_member memb;
 
 	assert("nikita-663", inode != NULL);
 
 	state = reiser4_inode_data(inode);
+
 	/* common case: no non-standard plugins */
-	if (state->plugin_mask == 0)
+	if (is_pset ? state->plugin_mask == 0 : state->heir_mask == 0)
 		return 0;
 	len = sizeof(reiser4_plugin_stat);
-	for (memb = 0; memb < PSET_LAST; ++memb)
-		len = len_for(pset_get(state->pset, memb), inode, memb, len);
+	last = PSET_LAST;
+
+	for (memb = 0; memb < last; ++memb) {
+	      len = len_for(aset_get(is_pset ? state->pset : state->hset, memb),
+			    inode, memb, len, is_pset);
+	}
 	assert("nikita-664", len > (int)sizeof(reiser4_plugin_stat));
 	return len;
 }
 
+static int save_len_pset_sd(struct inode *inode) {
+	return save_len_plugin_sd(inode, 1 /* pset */);
+}
+
 /* helper function for plugin_sd_save(): save plugin, associated with
     inode. */
 static int save_plug(reiser4_plugin * plugin /* plugin to save */ ,
 		     struct inode *inode /* object being processed */ ,
-		     pset_member memb /* what element of pset is saved */ ,
+		     int memb /* what element of pset is saved */ ,
 		     char **area /* position in stat-data */ ,
-		     int *count	/* incremented if plugin were actually
-				 * saved. */ )
+		     int *count	/* incremented if plugin were actually saved. */,
+		     int is_pset /* 1 for plugin set, 0 for heir set */)
 {
 	reiser4_plugin_slot *slot;
 	int fake_len;
@@ -768,7 +798,10 @@ static int save_plug(reiser4_plugin * pl
 
 	if (plugin == NULL)
 		return 0;
-	if (!(reiser4_inode_data(inode)->plugin_mask & (1 << memb)))
+
+	if (is_pset ?
+	    !(reiser4_inode_data(inode)->plugin_mask & (1 << memb)) :
+	    !(reiser4_inode_data(inode)->heir_mask & (1 << memb)))
 		return 0;
 	slot = (reiser4_plugin_slot *) * area;
 	put_unaligned(cpu_to_le16(memb), &slot->pset_memb);
@@ -786,13 +819,14 @@ static int save_plug(reiser4_plugin * pl
 
 /* save state of all non-standard plugins associated with inode */
 static int save_plugin_sd(struct inode *inode /* object being processed */ ,
-			  char **area /* position in stat-data */ )
+			  char **area /* position in stat-data */,
+			  int is_pset /* 1 for pset, 0 for hset */)
 {
+	int fake_len;
 	int result = 0;
 	int num_of_plugins;
 	reiser4_plugin_stat *sd;
 	reiser4_inode *state;
-	int fake_len;
 	pset_member memb;
 
 	assert("nikita-669", inode != NULL);
@@ -800,7 +834,7 @@ static int save_plugin_sd(struct inode *
 	assert("nikita-671", *area != NULL);
 
 	state = reiser4_inode_data(inode);
-	if (state->plugin_mask == 0)
+	if (is_pset ? state->plugin_mask == 0 : state->heir_mask == 0)
 		return 0;
 	sd = (reiser4_plugin_stat *) * area;
 	fake_len = (int)0xffff;
@@ -808,8 +842,9 @@ static int save_plugin_sd(struct inode *
 
 	num_of_plugins = 0;
 	for (memb = 0; memb < PSET_LAST; ++memb) {
-		result = save_plug(pset_get(state->pset, memb),
-				   inode, memb, area, &num_of_plugins);
+		result = save_plug(aset_get(is_pset ? state->pset : state->hset,
+					    memb),
+				   inode, memb, area, &num_of_plugins, is_pset);
 		if (result != 0)
 			break;
 	}
@@ -818,6 +853,22 @@ static int save_plugin_sd(struct inode *
 	return result;
 }
 
+static int save_pset_sd(struct inode *inode, char **area) {
+	return save_plugin_sd(inode, area, 1 /* pset */);
+}
+
+static int present_hset_sd(struct inode *inode, char **area, int *len) {
+	return present_plugin_sd(inode, area, len, 0 /* hset */);
+}
+
+static int save_len_hset_sd(struct inode *inode) {
+	return save_len_plugin_sd(inode, 0 /* pset */);
+}
+
+static int save_hset_sd(struct inode *inode, char **area) {
+	return save_plugin_sd(inode, area, 0 /* hset */);
+}
+
 /* helper function for crypto_sd_present(), crypto_sd_save.
    Allocates memory for crypto stat, keyid and attaches it to the inode */
 static int extract_crypto_stat (struct inode * inode,
@@ -977,10 +1028,25 @@ sd_ext_plugin sd_ext_plugins[LAST_SD_EXT
 			.desc = "plugin stat-data fields",
 			.linkage = {NULL,NULL}
 		},
-		.present = present_plugin_sd,
+		.present = present_pset_sd,
 		.absent = absent_plugin_sd,
-		.save_len = save_len_plugin_sd,
-		.save = save_plugin_sd,
+		.save_len = save_len_pset_sd,
+		.save = save_pset_sd,
+		.alignment = 8
+	},
+	[HEIR_STAT] = {
+		.h = {
+			.type_id = REISER4_SD_EXT_PLUGIN_TYPE,
+			.id = HEIR_STAT,
+			.pops = NULL,
+			.label = "heir-plugin-sd",
+			.desc = "heir plugin stat-data fields",
+			.linkage = {NULL,NULL}
+		},
+		.present = present_hset_sd,
+		.absent = NULL,
+		.save_len = save_len_hset_sd,
+		.save = save_hset_sd,
 		.alignment = 8
 	},
 	[FLAGS_STAT] = {
diff -puN fs/reiser4/plugin/item/static_stat.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/item/static_stat.h
--- a/fs/reiser4/plugin/item/static_stat.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/item/static_stat.h
@@ -68,9 +68,9 @@ typedef enum {
 	LARGE_TIMES_STAT,
 	/* stat data has link name included */
 	SYMLINK_STAT,
-	/* if this is present, file is controlled by non-standard
-	   plugin (that is, plugin that cannot be deduced from file
-	   mode bits), for example, aggregation, interpolation etc. */
+	/* on-disk slots of non-standard plugins for main plugin table
+	   (@reiser4_inode->pset), that is, plugins that cannot be deduced
+	   from file mode bits), for example, aggregation, interpolation etc. */
 	PLUGIN_STAT,
 	/* this extension contains persistent inode flags. These flags are
 	   single bits: immutable, append, only, etc. Layout is in
@@ -82,6 +82,11 @@ typedef enum {
 	/* this extension contains size and public id of the secret key.
 	   Layout is in reiser4_crypto_stat */
 	CRYPTO_STAT,
+	/* on-disk slots of non-default plugins for inheritance, which
+	   are extracted to special plugin table (@reiser4_inode->hset).
+	   By default, children of the object will inherit plugins from
+	   its main plugin table (pset). */
+	HEIR_STAT,
 	LAST_SD_EXTENSION,
 	/*
 	 * init_inode_static_sd() iterates over extension mask until all
@@ -95,7 +100,7 @@ typedef enum {
 	 * ->present(), or ->absent() method will be called, independently of
 	 * what other extensions are present.
 	 */
-	LAST_IMPORTANT_SD_EXTENSION = PLUGIN_STAT,
+	LAST_IMPORTANT_SD_EXTENSION = PLUGIN_STAT
 } sd_ext_bits;
 
 /* minimal stat-data. This allows to support light-weight files. */
@@ -107,9 +112,9 @@ typedef struct reiser4_stat_data_base {
 typedef struct reiser4_light_weight_stat {
 	/*  0 */ __le16 mode;
 	/*  2 */ __le32 nlink;
-	/*  8 */ __le64 size;
+	/*  6 */ __le64 size;
 	/* size in bytes */
-	/* 16 */
+	/* 14 */
 } PACKED reiser4_light_weight_stat;
 
 typedef struct reiser4_unix_stat {
@@ -181,12 +186,12 @@ typedef struct reiser4_crypto_stat {
 
 typedef struct reiser4_large_times_stat {
 	/* access time */
-	/*  0 */ d32 atime;
+	/* 0 */ d32 atime;
 	/* modification time */
-	/*  8 */ d32 mtime;
+	/* 4 */ d32 mtime;
 	/* change time */
-	/* 16 */ d32 ctime;
-	/* 24 */
+	/* 8 */ d32 ctime;
+	/* 12 */
 } PACKED reiser4_large_times_stat;
 
 /* this structure is filled by sd_item_stat */
diff -puN fs/reiser4/plugin/item/tail.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/item/tail.c
--- a/fs/reiser4/plugin/item/tail.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/item/tail.c
@@ -43,8 +43,8 @@ int mergeable_tail(const coord_t *p1, co
 {
 	reiser4_key key1, key2;
 
-	assert("vs-535",
-	       item_type_by_coord(p1) == UNIX_FILE_METADATA_ITEM_TYPE);
+	assert("vs-535", plugin_of_group(item_plugin_by_coord(p1),
+					 UNIX_FILE_METADATA_ITEM_TYPE));
 	assert("vs-365", item_id_by_coord(p1) == FORMATTING_ID);
 
 	if (item_id_by_coord(p2) != FORMATTING_ID) {
diff -puN fs/reiser4/plugin/object.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/object.c
--- a/fs/reiser4/plugin/object.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/object.c
@@ -68,10 +68,16 @@ static int _dummyop(void)
 
 #define dummyop ((void *)_dummyop)
 
-static int change_file(struct inode *inode, reiser4_plugin * plugin)
+static int change_file(struct inode *inode,
+		       reiser4_plugin * plugin,
+		       pset_member memb)
 {
 	/* cannot change object plugin of already existing object */
-	return RETERR(-EINVAL);
+	if (memb == PSET_FILE)
+		return RETERR(-EINVAL);
+
+	/* Change PSET_CREATE */
+	return aset_set_unsafe(&reiser4_inode_data(inode)->pset, memb, plugin);
 }
 
 static reiser4_plugin_ops file_plugin_ops = {
@@ -87,6 +93,7 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 		.h = {
 			.type_id = REISER4_FILE_PLUGIN_TYPE,
 			.id = UNIX_FILE_PLUGIN_ID,
+			.groups = (1 << REISER4_REGULAR_FILE),
 			.pops = &file_plugin_ops,
 			.label = "reg",
 			.desc = "regular file",
@@ -155,6 +162,7 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 		.h = {
 			.type_id = REISER4_FILE_PLUGIN_TYPE,
 			.id = DIRECTORY_FILE_PLUGIN_ID,
+			.groups = (1 << REISER4_DIRECTORY_FILE),
 			.pops = &file_plugin_ops,
 			.label = "dir",
 			.desc = "directory",
@@ -198,6 +206,7 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 		.h = {
 			.type_id = REISER4_FILE_PLUGIN_TYPE,
 			.id = SYMLINK_FILE_PLUGIN_ID,
+			.groups = (1 << REISER4_SYMLINK_FILE),
 			.pops = &file_plugin_ops,
 			.label = "symlink",
 			.desc = "symbolic link",
@@ -245,6 +254,7 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 		.h = {
 			.type_id = REISER4_FILE_PLUGIN_TYPE,
 			.id = SPECIAL_FILE_PLUGIN_ID,
+			.groups = (1 << REISER4_SPECIAL_FILE),
 			.pops = &file_plugin_ops,
 			.label = "special",
 			.desc =
@@ -288,29 +298,30 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 			.done = wire_done_common
 		}
 	},
-	[CRC_FILE_PLUGIN_ID] = {
+	[CRYPTCOMPRESS_FILE_PLUGIN_ID] = {
 		.h = {
 			.type_id = REISER4_FILE_PLUGIN_TYPE,
-			.id = CRC_FILE_PLUGIN_ID,
-			.pops = &cryptcompress_plugin_ops,
+			.id = CRYPTCOMPRESS_FILE_PLUGIN_ID,
+			.groups = (1 << REISER4_REGULAR_FILE),
+			.pops = &file_plugin_ops,
 			.label = "cryptcompress",
 			.desc = "cryptcompress file",
 			.linkage = {NULL, NULL}
 		},
 		.inode_ops = {
 			.permission = reiser4_permission_common,
-			.setattr = setattr_cryptcompress,
+			.setattr = prot_setattr_cryptcompress,
 			.getattr = reiser4_getattr_common
 		},
 		.file_ops = {
 			.llseek = generic_file_llseek,
-			.read = read_cryptcompress,
-			.write = write_cryptcompress,
+			.read = prot_read_cryptcompress,
+			.write = prot_write_cryptcompress,
 			.aio_read = generic_file_aio_read,
-			.mmap = mmap_cryptcompress,
-			.release = release_cryptcompress,
+			.mmap = prot_mmap_cryptcompress,
+			.release = prot_release_cryptcompress,
 			.fsync = reiser4_sync_common,
-			.sendfile = sendfile_cryptcompress
+			.sendfile = prot_sendfile_cryptcompress
 		},
 		.as_ops = {
 			.writepage = reiser4_writepage,
@@ -329,8 +340,8 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 		.set_plug_in_inode = set_plug_in_inode_common,
 		.adjust_to_parent = adjust_to_parent_cryptcompress,
 		.create_object = create_cryptcompress,
-		.open_object = open_cryptcompress,
-		.delete_object = delete_cryptcompress,
+		.open_object = open_object_cryptcompress,
+		.delete_object = delete_object_cryptcompress,
 		.add_link = reiser4_add_link_common,
 		.rem_link = reiser4_rem_link_common,
 		.owns_item = owns_item_common,
@@ -356,7 +367,9 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 	}
 };
 
-static int change_dir(struct inode *inode, reiser4_plugin * plugin)
+static int change_dir(struct inode *inode,
+		      reiser4_plugin * plugin,
+		      pset_member memb)
 {
 	/* cannot change dir plugin of already existing object */
 	return RETERR(-EINVAL);
diff -puN fs/reiser4/plugin/object.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/object.h
--- a/fs/reiser4/plugin/object.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/object.h
@@ -64,7 +64,6 @@ int owns_item_common_dir(const struct in
 int can_add_link_common(const struct inode *);
 int can_rem_link_common_dir(const struct inode *);
 int reiser4_detach_common_dir(struct inode *child, struct inode *parent);
-int open_cryptcompress(struct inode * inode, struct file * file);
 int reiser4_bind_common_dir(struct inode *child, struct inode *parent);
 int safelink_common(struct inode *, reiser4_safe_link_t, __u64 value);
 reiser4_block_nr estimate_create_common(const struct inode *);
@@ -108,7 +107,6 @@ int do_prepare_write(struct file *, stru
 int lookup_sd(struct inode *, znode_lock_mode, coord_t *, lock_handle *,
 	      const reiser4_key *, int silent);
 
-
 /* __FS_REISER4_PLUGIN_OBJECT_H__ */
 #endif
 
diff -puN fs/reiser4/plugin/plugin.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/plugin.c
--- a/fs/reiser4/plugin/plugin.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/plugin.c
@@ -188,7 +188,6 @@ int init_plugins(void);
 int setup_plugins(struct super_block *super, reiser4_plugin ** area);
 int locate_plugin(struct inode *inode, plugin_locator * loc);
 
-
 /**
  * init_plugins - initialize plugins
  *
@@ -302,21 +301,13 @@ struct list_head *get_plugin_list(reiser
 	return &plugins[type].plugins_list;
 }
 
-int grab_plugin(struct inode *self, struct inode *ancestor, pset_member memb)
-{
-	reiser4_plugin *plug;
-	reiser4_inode *parent;
-
-	parent = reiser4_inode_data(ancestor);
-	plug = pset_get(parent->hset, memb) ? : pset_get(parent->pset, memb);
-	return grab_plugin_from(self, memb, plug);
-}
-
-static void update_plugin_mask(reiser4_inode * info, pset_member memb)
+static void update_pset_mask(reiser4_inode * info, pset_member memb)
 {
 	struct dentry *rootdir;
 	reiser4_inode *root;
 
+	assert("edward-1443", memb != PSET_FILE);
+
 	rootdir = inode_by_reiser4_inode(info)->i_sb->s_root;
 	if (rootdir != NULL) {
 		root = reiser4_inode_data(rootdir->d_inode);
@@ -324,43 +315,108 @@ static void update_plugin_mask(reiser4_i
 		 * if inode is different from the default one, or we are
 		 * changing plugin of root directory, update plugin_mask
 		 */
-		if (pset_get(info->pset, memb) != pset_get(root->pset, memb) ||
+		if (aset_get(info->pset, memb) !=
+		    aset_get(root->pset, memb) ||
 		    info == root)
 			info->plugin_mask |= (1 << memb);
+		else
+			info->plugin_mask &= ~(1 << memb);
 	}
 }
 
-int
-grab_plugin_from(struct inode *self, pset_member memb, reiser4_plugin * plug)
+/* Get specified plugin set member from parent,
+   or from fs-defaults (if no parent is given) and
+   install the result to pset of @self */
+int grab_plugin_pset(struct inode *self,
+		     struct inode *ancestor,
+		     pset_member memb)
 {
+	reiser4_plugin *plug;
 	reiser4_inode *info;
 	int result = 0;
 
+	/* Do not grab if initialised already. */
 	info = reiser4_inode_data(self);
-	if (pset_get(info->pset, memb) == NULL) {
-		result = pset_set(&info->pset, memb, plug);
-		if (result == 0)
-			update_plugin_mask(info, memb);
+	if (aset_get(info->pset, memb) != NULL)
+		return 0;
+	if (ancestor) {
+		reiser4_inode *parent;
+
+		parent = reiser4_inode_data(ancestor);
+		plug = aset_get(parent->hset, memb) ? :
+			aset_get(parent->pset, memb);
+	}
+	else
+		plug = get_default_plugin(memb);
+
+	result = set_plugin(&info->pset, memb, plug);
+	if (result == 0) {
+		if (!ancestor || self->i_sb->s_root->d_inode != self)
+			update_pset_mask(info, memb);
 	}
 	return result;
 }
 
-#if 0
-int force_plugin(struct inode *self, pset_member memb, reiser4_plugin * plug)
+/* Take missing pset members from root inode */
+int finish_pset(struct inode *inode)
 {
+	reiser4_plugin *plug;
+	reiser4_inode *root;
 	reiser4_inode *info;
+	pset_member memb;
 	int result = 0;
 
+	root = reiser4_inode_data(inode->i_sb->s_root->d_inode);
+	info = reiser4_inode_data(inode);
+
+	assert("edward-1455", root != NULL);
+	assert("edward-1456", info != NULL);
+
+	/* file and directory plugins are already initialized. */
+	for (memb = PSET_DIR + 1; memb < PSET_LAST; ++memb) {
+
+		/* Do not grab if initialised already. */
+		if (aset_get(info->pset, memb) != NULL)
+			continue;
+
+		plug = aset_get(root->pset, memb);
+		result = set_plugin(&info->pset, memb, plug);
+		if (result != 0)
+			break;
+	}
+	if (result != 0) {
+		warning("nikita-3447",
+			"Cannot set up plugins for %lli",
+			(unsigned long long)
+			get_inode_oid(inode));
+	}
+	return result;
+}
+
+int force_plugin_pset(struct inode *self, pset_member memb, reiser4_plugin * plug)
+{
+	reiser4_inode *info;
+	int result = 0;
+
+	if (!self->i_sb->s_root || self->i_sb->s_root->d_inode == self) {
+		/* Changing pset in the root object. */
+		return RETERR(-EINVAL);
+	}
+
 	info = reiser4_inode_data(self);
 	if (plug->h.pops != NULL && plug->h.pops->change != NULL)
-		result = plug->h.pops->change(self, plug);
+		result = plug->h.pops->change(self, plug, memb);
 	else
-		result = pset_set(&info->pset, memb, plug);
-	if (result == 0)
-		update_plugin_mask(info, memb);
+		result = aset_set_unsafe(&info->pset, memb, plug);
+	if (result == 0) {
+		__u16 oldmask = info->plugin_mask;
+
+		update_pset_mask(info, memb);
+		if (oldmask != info->plugin_mask)
+			reiser4_inode_clr_flag(self, REISER4_SDLEN_KNOWN);
+	}
 	return result;
 }
-#endif  /*  0  */
 
 reiser4_plugin_type_data plugins[REISER4_PLUGIN_TYPES] = {
 	/* C90 initializers */
@@ -508,16 +564,6 @@ reiser4_plugin_type_data plugins[REISER4
 		.builtin = cluster_plugins,
 		.plugins_list = {NULL, NULL},
 		.size = sizeof(cluster_plugin)
-	},
-	[REISER4_REGULAR_PLUGIN_TYPE] = {
-		.type_id = REISER4_REGULAR_PLUGIN_TYPE,
-		.label = "regular",
-		.desc = "Defines kind of regular file",
-		.builtin_num =
-		sizeof_array(regular_plugins),
-		.builtin = regular_plugins,
-		.plugins_list = {NULL, NULL},
-		.size = sizeof(regular_plugin)
 	}
 };
 
diff -puN fs/reiser4/plugin/plugin.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/plugin.h
--- a/fs/reiser4/plugin/plugin.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/plugin.h
@@ -150,6 +150,32 @@ typedef struct reiser4_object_on_wire re
  * them, and which are only invoked by other plugins.
  */
 
+/* This should be incremented with each new contributed
+   pair (plugin type, plugin id).
+   NOTE: Make sure there is a release of reiser4progs
+   with the corresponding version number */
+#define PLUGIN_LIBRARY_VERSION 0
+
+ /* enumeration of fields within plugin_set */
+typedef enum {
+	PSET_FILE,
+	PSET_DIR,		/* PSET_FILE and PSET_DIR should be first elements:
+				 * inode.c:read_inode() depends on this. */
+	PSET_PERM,
+	PSET_FORMATTING,
+	PSET_HASH,
+	PSET_FIBRATION,
+	PSET_SD,
+	PSET_DIR_ITEM,
+	PSET_CIPHER,
+	PSET_DIGEST,
+	PSET_COMPRESSION,
+	PSET_COMPRESSION_MODE,
+	PSET_CLUSTER,
+	PSET_CREATE,
+	PSET_LAST
+} pset_member;
+
 /* builtin file-plugins */
 typedef enum {
 	/* regular file */
@@ -162,7 +188,7 @@ typedef enum {
 	   sockets  */
 	SPECIAL_FILE_PLUGIN_ID,
 	/* regular cryptcompress file */
-	CRC_FILE_PLUGIN_ID,
+	CRYPTCOMPRESS_FILE_PLUGIN_ID,
 	/* number of file plugins. Used as size of arrays to hold
 	   file plugins. */
 	LAST_FILE_PLUGIN_ID
@@ -511,13 +537,6 @@ typedef struct compression_mode_plugin {
 	int (*discard_hook) (struct inode * inode, cloff_t index);
 } compression_mode_plugin;
 
-typedef struct regular_plugin {
-	/* generic fields */
-	plugin_header h;
-	/* file plugin id which implements regular file */
-	reiser4_file_id id;
-} regular_plugin;
-
 typedef struct cluster_plugin {
 	/* generic fields */
 	plugin_header h;
@@ -576,6 +595,7 @@ typedef struct disk_format_plugin {
 	int (*release) (struct super_block *);
 	jnode *(*log_super) (struct super_block *);
 	int (*check_open) (const struct inode * object);
+	int (*version_update) (struct super_block *);
 } disk_format_plugin;
 
 struct jnode_plugin {
@@ -638,8 +658,6 @@ union reiser4_plugin {
 	compression_mode_plugin compression_mode;
 	/* cluster plugin, used by object plugin */
 	cluster_plugin clust;
-	/* regular plugin, used by directory plugin */
-	regular_plugin regular;
 	/* place-holder for new plugin types that can be registered
 	   dynamically, and used by other dynamically loaded plugins.  */
 	void *generic;
@@ -664,7 +682,8 @@ struct reiser4_plugin_ops {
 	int alignment;
 	/* install itself into given inode. This can return error
 	   (e.g., you cannot change hash of non-empty directory). */
-	int (*change) (struct inode * inode, reiser4_plugin * plugin);
+	int (*change) (struct inode * inode, reiser4_plugin * plugin,
+		       pset_member memb);
 	/* install itself into given inode. This can return error
 	   (e.g., you cannot change hash of non-empty directory). */
 	int (*inherit) (struct inode * inode, struct inode * parent,
@@ -712,7 +731,7 @@ typedef enum {
 	COL_8_COMPRESSION_MODE_ID,
 	COL_16_COMPRESSION_MODE_ID,
 	COL_32_COMPRESSION_MODE_ID,
-	COZ_COMPRESSION_MODE_ID,
+	CONVX_COMPRESSION_MODE_ID,
 	FORCE_COMPRESSION_MODE_ID,
 	TEST_COMPRESSION_MODE_ID,
   	LAST_COMPRESSION_MODE_ID
@@ -728,13 +747,6 @@ typedef enum {
 	LAST_CLUSTER_ID
 } reiser4_cluster_id;
 
-/* builtin regular plugins */
-typedef enum {
-	UF_REGULAR_ID,
-	CRC_REGULAR_ID,
-	LAST_REGULAR_ID
-} reiser4_regular_id;
-
 /* builtin tail-plugins */
 
 typedef enum {
@@ -807,7 +819,6 @@ typedef struct plugin_locator {
 
 extern int locate_plugin(struct inode *inode, plugin_locator * loc);
 
-
 #define PLUGIN_BY_ID(TYPE,ID,FIELD)					\
 static inline TYPE *TYPE ## _by_id( reiser4_plugin_id id )		\
 {									\
@@ -851,7 +862,6 @@ PLUGIN_BY_ID(jnode_plugin, REISER4_JNODE
 PLUGIN_BY_ID(compression_mode_plugin, REISER4_COMPRESSION_MODE_PLUGIN_TYPE,
 	     compression_mode);
 PLUGIN_BY_ID(cluster_plugin, REISER4_CLUSTER_PLUGIN_TYPE, clust);
-PLUGIN_BY_ID(regular_plugin, REISER4_REGULAR_PLUGIN_TYPE, regular);
 
 extern int save_plugin_id(reiser4_plugin * plugin, d16 * area);
 
@@ -863,29 +873,9 @@ for (plugin = list_entry(get_plugin_list
      plugin = list_entry(plugin->h.linkage.next, reiser4_plugin, h.linkage))
 
 
-/* enumeration of fields within plugin_set */
-typedef enum {
-	PSET_FILE,
-	PSET_DIR,		/* PSET_FILE and PSET_DIR should be first elements:
-				 * inode.c:read_inode() depends on this. */
-	PSET_PERM,
-	PSET_FORMATTING,
-	PSET_HASH,
-	PSET_FIBRATION,
-	PSET_SD,
-	PSET_DIR_ITEM,
-	PSET_CIPHER,
-	PSET_DIGEST,
-	PSET_COMPRESSION,
-	PSET_COMPRESSION_MODE,
-	PSET_CLUSTER,
-	PSET_REGULAR_ENTRY,
-	PSET_LAST
-} pset_member;
-
-int grab_plugin(struct inode *self, struct inode *ancestor, pset_member memb);
-int grab_plugin_from(struct inode *self, pset_member memb,
-		     reiser4_plugin * plug);
+extern int grab_plugin_pset(struct inode *self, struct inode *ancestor, pset_member memb);
+extern int force_plugin_pset(struct inode *self, pset_member memb, reiser4_plugin *plug);
+extern int finish_pset(struct inode *inode);
 
 /* defined in fs/reiser4/plugin/object.c */
 extern file_plugin file_plugins[LAST_FILE_PLUGIN_ID];
@@ -908,8 +898,6 @@ extern compression_mode_plugin
 compression_mode_plugins[LAST_COMPRESSION_MODE_ID];
 /* defined in fs/reiser4/plugin/cluster.c */
 extern cluster_plugin cluster_plugins[LAST_CLUSTER_ID];
-/* defined in fs/reiser4/plugin/regular.c */
-extern regular_plugin regular_plugins[LAST_REGULAR_ID];
 /* defined in fs/reiser4/plugin/tail.c */
 extern formatting_plugin formatting_plugins[LAST_TAIL_FORMATTING_ID];
 /* defined in fs/reiser4/plugin/security/security.c */
diff -puN fs/reiser4/plugin/plugin_header.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/plugin_header.h
--- a/fs/reiser4/plugin/plugin_header.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/plugin_header.h
@@ -27,10 +27,16 @@ typedef enum {
 	REISER4_COMPRESSION_PLUGIN_TYPE,
 	REISER4_COMPRESSION_MODE_PLUGIN_TYPE,
 	REISER4_CLUSTER_PLUGIN_TYPE,
-	REISER4_REGULAR_PLUGIN_TYPE,
 	REISER4_PLUGIN_TYPES
 } reiser4_plugin_type;
 
+typedef enum {
+	REISER4_DIRECTORY_FILE,
+	REISER4_REGULAR_FILE,
+	REISER4_SYMLINK_FILE,
+	REISER4_SPECIAL_FILE,
+} reiser4_plugin_group;
+
 struct reiser4_plugin_ops;
 /* generic plugin operations, supported by each
     plugin type. */
@@ -42,6 +48,8 @@ typedef struct plugin_header {
 	reiser4_plugin_type type_id;
 	/* id of this plugin */
 	reiser4_plugin_id id;
+	/* bitmask of groups the plugin belongs to. */
+	reiser4_plugin_groups groups;
 	/* plugin operations */
 	reiser4_plugin_ops *pops;
 /* NIKITA-FIXME-HANS: usage of and access to label and desc is not commented and defined. */
@@ -53,6 +61,8 @@ typedef struct plugin_header {
 	struct list_head linkage;
 } plugin_header;
 
+#define plugin_of_group(plug, group) (plug->h.groups & (1 << group))
+
 /* PRIVATE INTERFACES */
 /* NIKITA-FIXME-HANS: what is this for and why does it duplicate what is in plugin_header? */
 /* plugin type representation. */
diff -puN fs/reiser4/plugin/plugin_set.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/plugin_set.c
--- a/fs/reiser4/plugin/plugin_set.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/plugin_set.c
@@ -1,24 +1,26 @@
 /* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
  * reiser4/README */
-/* NIKITA-FIXME-HANS: you didn't discuss this with me before coding it did you?  Remove plugin-sets from code by March 15th, 2004 */
-/* plugin-sets */
+/* This file contains Reiser4 plugin set operations */
 
-/*
- * Each inode comes with a whole set of plugins: file plugin, directory
- * plugin, hash plugin, tail policy plugin, security plugin, etc.
+/* plugin sets
  *
- * Storing them (pointers to them, that is) in inode is a waste of
- * space. Especially, given that on average file system plugins of vast
- * majority of files will belong to few sets (e.g., one set for regular files,
- * another set for standard directory, etc.)
+ * Each file in reiser4 is controlled by a whole set of plugins (file plugin,
+ * directory plugin, hash plugin, tail policy plugin, security plugin, etc.)
+ * assigned (inherited, deduced from mode bits, etc.) at creation time. This
+ * set of plugins (so called pset) is described by structure plugin_set (see
+ * plugin/plugin_set.h), which contains pointers to all required plugins.
  *
- * Plugin set (pset) is an object containing pointers to all plugins required
- * by inode. Inode only stores a pointer to pset. psets are "interned", that
- * is, different inodes with the same set of plugins point to the same
- * pset. This is archived by storing psets in global hash table. Races are
- * avoided by simple (and efficient so far) solution of never recycling psets,
- * even when last inode pointing to it is destroyed.
+ * Children can inherit some pset members from their parent, however sometimes
+ * it is useful to specify members different from parent ones. Since object's
+ * pset can not be easily changed without fatal consequences, we use for this
+ * purpose another special plugin table (so called hset, or heir set) described
+ * by the same structure.
  *
+ * Inode only stores a pointers to pset and hset. Different inodes with the
+ * same set of pset (hset) members point to the same pset (hset). This is
+ * archived by storing psets and hsets in global hash table. Races are avoided
+ * by simple (and efficient so far) solution of never recycling psets, even
+ * when last inode pointing to it is destroyed.
  */
 
 #include "../debug.h"
@@ -65,7 +67,8 @@ static inline int pseq(const unsigned lo
 		sizeof set1->digest +
 		sizeof set1->compression +
 		sizeof set1->compression_mode +
-		sizeof set1->cluster + sizeof set1->regular_entry);
+		sizeof set1->cluster +
+		sizeof set1->create);
 
 	set1 = cast_to(a1);
 	set2 = cast_to(a2);
@@ -84,7 +87,7 @@ static inline int pseq(const unsigned lo
 	    set1->compression == set2->compression &&
 	    set1->compression_mode == set2->compression_mode &&
 	    set1->cluster == set2->cluster &&
-	    set1->regular_entry == set2->regular_entry;
+	    set1->create == set2->create;
 }
 
 #define HASH_FIELD(hash, set, field)		\
@@ -110,7 +113,7 @@ static inline unsigned long calculate_ha
 	HASH_FIELD(result, set, compression);
 	HASH_FIELD(result, set, compression_mode);
 	HASH_FIELD(result, set, cluster);
-	HASH_FIELD(result, set, regular_entry);
+	HASH_FIELD(result, set, create);
 	return result & (PS_TABLE_SIZE - 1);
 }
 
@@ -144,7 +147,7 @@ static plugin_set empty_set = {
 	.compression = NULL,
 	.compression_mode = NULL,
 	.cluster = NULL,
-	.regular_entry = NULL,
+	.create = NULL,
 	.link = {NULL}
 };
 
@@ -211,126 +214,123 @@ static int plugin_set_field(plugin_set *
 
 static struct {
 	int offset;
+	reiser4_plugin_groups groups;
 	reiser4_plugin_type type;
 } pset_descr[PSET_LAST] = {
 	[PSET_FILE] = {
 		.offset = offsetof(plugin_set, file),
-		.type = REISER4_FILE_PLUGIN_TYPE
+		.type = REISER4_FILE_PLUGIN_TYPE,
+		.groups = 0
 	},
 	[PSET_DIR] = {
 		.offset = offsetof(plugin_set, dir),
-		.type = REISER4_DIR_PLUGIN_TYPE
+		.type = REISER4_DIR_PLUGIN_TYPE,
+		.groups = 0
 	},
 	[PSET_PERM] = {
 		.offset = offsetof(plugin_set, perm),
-		.type = REISER4_PERM_PLUGIN_TYPE
+		.type = REISER4_PERM_PLUGIN_TYPE,
+		.groups = 0
 	},
 	[PSET_FORMATTING] = {
 		.offset = offsetof(plugin_set, formatting),
-		.type = REISER4_FORMATTING_PLUGIN_TYPE
+		.type = REISER4_FORMATTING_PLUGIN_TYPE,
+		.groups = 0
 	},
 	[PSET_HASH] = {
 		.offset = offsetof(plugin_set, hash),
-		.type = REISER4_HASH_PLUGIN_TYPE
+		.type = REISER4_HASH_PLUGIN_TYPE,
+		.groups = 0
 	},
 	[PSET_FIBRATION] = {
 		.offset = offsetof(plugin_set, fibration),
-		.type = REISER4_FIBRATION_PLUGIN_TYPE
+		.type = REISER4_FIBRATION_PLUGIN_TYPE,
+		.groups = 0
 	},
 	[PSET_SD] = {
 		.offset = offsetof(plugin_set, sd),
-		.type = REISER4_ITEM_PLUGIN_TYPE
+		.type = REISER4_ITEM_PLUGIN_TYPE,
+		.groups = (1 << STAT_DATA_ITEM_TYPE)
 	},
 	[PSET_DIR_ITEM] = {
 		.offset = offsetof(plugin_set, dir_item),
-		.type = REISER4_ITEM_PLUGIN_TYPE
+		.type = REISER4_ITEM_PLUGIN_TYPE,
+		.groups = (1 << DIR_ENTRY_ITEM_TYPE)
 	},
 	[PSET_CIPHER] = {
 		.offset = offsetof(plugin_set, cipher),
-		.type = REISER4_CIPHER_PLUGIN_TYPE
+		.type = REISER4_CIPHER_PLUGIN_TYPE,
+		.groups = 0
 	},
 	[PSET_DIGEST] = {
 		.offset = offsetof(plugin_set, digest),
-		.type = REISER4_DIGEST_PLUGIN_TYPE
+		.type = REISER4_DIGEST_PLUGIN_TYPE,
+		.groups = 0
 	},
 	[PSET_COMPRESSION] = {
 		.offset = offsetof(plugin_set, compression),
-		.type = REISER4_COMPRESSION_PLUGIN_TYPE
+		.type = REISER4_COMPRESSION_PLUGIN_TYPE,
+		.groups = 0
 	},
 	[PSET_COMPRESSION_MODE] = {
 		.offset = offsetof(plugin_set, compression_mode),
-		.type = REISER4_COMPRESSION_MODE_PLUGIN_TYPE
+		.type = REISER4_COMPRESSION_MODE_PLUGIN_TYPE,
+		.groups = 0
 	},
 	[PSET_CLUSTER] = {
 		.offset = offsetof(plugin_set, cluster),
-		.type = REISER4_CLUSTER_PLUGIN_TYPE
+		.type = REISER4_CLUSTER_PLUGIN_TYPE,
+		.groups = 0
 	},
-	[PSET_REGULAR_ENTRY] = {
-		.offset = offsetof(plugin_set, regular_entry),
-		.type = REISER4_REGULAR_PLUGIN_TYPE
+	[PSET_CREATE] = {
+		.offset = offsetof(plugin_set, create),
+		.type = REISER4_FILE_PLUGIN_TYPE,
+		.groups = (1 << REISER4_REGULAR_FILE)
 	}
 };
 
-#if REISER4_DEBUG
-static reiser4_plugin_type pset_member_to_type(pset_member memb)
-{
-	assert("nikita-3501", memb < PSET_LAST);
-	return pset_descr[memb].type;
-}
-#endif
-
-reiser4_plugin_type pset_member_to_type_unsafe(pset_member memb)
-{
-	if (memb < PSET_LAST)
-		return pset_descr[memb].type;
-	else
-		return REISER4_PLUGIN_TYPES;
+#define DEFINE_PSET_OPS(PREFIX)						       \
+	reiser4_plugin_type PREFIX##_member_to_type_unsafe(pset_member memb)   \
+{								               \
+	if (memb > PSET_LAST)						       \
+		return REISER4_PLUGIN_TYPES;				       \
+	return pset_descr[memb].type;					       \
+}									       \
+									       \
+int PREFIX##_set_unsafe(plugin_set ** set, pset_member memb,		       \
+		     reiser4_plugin * plugin)				       \
+{									       \
+	assert("nikita-3492", set != NULL);				       \
+	assert("nikita-3493", *set != NULL);				       \
+	assert("nikita-3494", plugin != NULL);				       \
+	assert("nikita-3495", 0 <= memb && memb < PSET_LAST);		       \
+	assert("nikita-3496", plugin->h.type_id == pset_descr[memb].type);     \
+									       \
+	if (pset_descr[memb].groups)					       \
+		if (!(pset_descr[memb].groups & plugin->h.groups))	       \
+			return -EINVAL;					       \
+									       \
+	return plugin_set_field(set,					       \
+			(unsigned long)plugin, pset_descr[memb].offset);       \
+}									       \
+									       \
+reiser4_plugin *PREFIX##_get(plugin_set * set, pset_member memb)	       \
+{									       \
+	assert("nikita-3497", set != NULL);				       \
+	assert("nikita-3498", 0 <= memb && memb < PSET_LAST);		       \
+									       \
+	return *(reiser4_plugin **) (((char *)set) + pset_descr[memb].offset); \
 }
 
-int pset_set(plugin_set ** set, pset_member memb, reiser4_plugin * plugin)
-{
-	assert("nikita-3492", set != NULL);
-	assert("nikita-3493", *set != NULL);
-	assert("nikita-3494", plugin != NULL);
-	assert("nikita-3495", memb < PSET_LAST);
-	assert("nikita-3496", plugin->h.type_id == pset_member_to_type(memb));
+DEFINE_PSET_OPS(aset);
 
+int set_plugin(plugin_set ** set, pset_member memb, reiser4_plugin * plugin) {
 	return plugin_set_field(set,
-				(unsigned long)plugin, pset_descr[memb].offset);
+		(unsigned long)plugin, pset_descr[memb].offset);
 }
 
-reiser4_plugin *pset_get(plugin_set * set, pset_member memb)
-{
-	assert("nikita-3497", set != NULL);
-	assert("nikita-3498", memb < PSET_LAST);
-
-	return *(reiser4_plugin **) (((char *)set) + pset_descr[memb].offset);
-}
-
-#define DEFINE_PLUGIN_SET(type, field)					\
-int plugin_set_ ## field(plugin_set **set, type *val)	\
-{									\
-	cassert(sizeof val == sizeof(unsigned long));			\
-	return plugin_set_field(set, (unsigned long)val,		\
-				offsetof(plugin_set, field));		\
-}
-
-DEFINE_PLUGIN_SET(file_plugin, file)
-    DEFINE_PLUGIN_SET(dir_plugin, dir)
-    DEFINE_PLUGIN_SET(formatting_plugin, formatting)
-    DEFINE_PLUGIN_SET(hash_plugin, hash)
-    DEFINE_PLUGIN_SET(fibration_plugin, fibration)
-    DEFINE_PLUGIN_SET(item_plugin, sd)
-    /* DEFINE_PLUGIN_SET(cipher_plugin, cipher) */
-    /* DEFINE_PLUGIN_SET(digest_plugin, digest) */
-    /* DEFINE_PLUGIN_SET(compression_plugin, compression) */
-    /* DEFINE_PLUGIN_SET(compression_mode_plugin, compression_mode) */
-    DEFINE_PLUGIN_SET(cluster_plugin, cluster)
-    /* DEFINE_PLUGIN_SET(regular_plugin, regular_entry) */
-
-
 /**
- * init_plugin_set - create pset cache and hash table
+ * init_plugin_set - create plugin set cache and hash table
  *
  * Initializes slab cache of plugin_set-s and their hash table. It is part of
  * reiser4 module initialization.
diff -puN fs/reiser4/plugin/plugin_set.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/plugin_set.h
--- a/fs/reiser4/plugin/plugin_set.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/plugin_set.h
@@ -1,6 +1,7 @@
 /* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
 
-/* plugin-sets. see fs/reiser4/plugin/plugin_set.c for details */
+/* Reiser4 plugin set definition.
+   See fs/reiser4/plugin/plugin_set.c for details */
 
 #if !defined( __PLUGIN_SET_H__ )
 #define __PLUGIN_SET_H__
@@ -43,30 +44,24 @@ struct plugin_set {
 	compression_mode_plugin *compression_mode;
 	/* cluster plugin */
 	cluster_plugin *cluster;
-	/* plugin of regular child should be created */
-	regular_plugin *regular_entry;
+	/* this specifies file plugin of regular children.
+	   only meaningful for directories */
+	file_plugin *create;
 	ps_hash_link link;
 };
 
 extern plugin_set *plugin_set_get_empty(void);
 extern void plugin_set_put(plugin_set * set);
 
-extern int plugin_set_file(plugin_set ** set, file_plugin * plug);
-extern int plugin_set_dir(plugin_set ** set, dir_plugin * plug);
-extern int plugin_set_formatting(plugin_set ** set, formatting_plugin * plug);
-extern int plugin_set_hash(plugin_set ** set, hash_plugin * plug);
-extern int plugin_set_fibration(plugin_set ** set, fibration_plugin * plug);
-extern int plugin_set_sd(plugin_set ** set, item_plugin * plug);
-extern int plugin_set_cluster(plugin_set ** set, cluster_plugin * plug);
-
 extern int init_plugin_set(void);
 extern void done_plugin_set(void);
 
-extern int pset_set(plugin_set ** set, pset_member memb,
-		    reiser4_plugin * plugin);
-extern reiser4_plugin *pset_get(plugin_set * set, pset_member memb);
-
-extern reiser4_plugin_type pset_member_to_type_unsafe(pset_member memb);
+extern reiser4_plugin *aset_get(plugin_set * set, pset_member memb);
+extern int set_plugin(plugin_set ** set, pset_member memb,
+		      reiser4_plugin * plugin);
+extern int aset_set_unsafe(plugin_set ** set, pset_member memb,
+			   reiser4_plugin * plugin);
+extern reiser4_plugin_type aset_member_to_type_unsafe(pset_member memb);
 
 /* __PLUGIN_SET_H__ */
 #endif
diff -puN fs/reiser4/plugin/regular.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion /dev/null
--- a/fs/reiser4/plugin/regular.c
+++ /dev/null
@@ -1,44 +0,0 @@
-/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
-
-/* Contains Reiser4 regular plugins which:
-   . specify a set of reiser4 regular object plugins,
-   . used by directory plugin to create entries powered by specified
-     regular plugins */
-
-#include "plugin.h"
-
-regular_plugin regular_plugins[LAST_REGULAR_ID] = {
-	[UF_REGULAR_ID] = {
-		.h = {
-			.type_id = REISER4_REGULAR_PLUGIN_TYPE,
-			.id = UF_REGULAR_ID,
-			.pops = NULL,
-			.label = "unixfile",
-			.desc = "Unix file regular plugin",
-			.linkage = {NULL, NULL}
-		},
-		.id = UNIX_FILE_PLUGIN_ID
-	},
-	[CRC_REGULAR_ID] = {
-		.h = {
-			.type_id = REISER4_REGULAR_PLUGIN_TYPE,
-			.id = CRC_REGULAR_ID,
-			.pops = NULL,
-			.label = "cryptcompress",
-			.desc = "Cryptcompress regular plugin",
-			.linkage = {NULL, NULL}
-		},
-		.id = CRC_FILE_PLUGIN_ID
-	}
-};
-
-/*
-  Local variables:
-  c-indentation-style: "K&R"
-  mode-name: "LC"
-  c-basic-offset: 8
-  tab-width: 8
-  fill-column: 120
-  scroll-step: 1
-  End:
-*/
diff -puN fs/reiser4/plugin/space/bitmap.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/plugin/space/bitmap.c
--- a/fs/reiser4/plugin/space/bitmap.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/plugin/space/bitmap.c
@@ -14,7 +14,6 @@
 #include <linux/types.h>
 #include <linux/fs.h>		/* for struct super_block  */
 #include <linux/mutex.h>
-#include <linux/vmalloc.h>
 #include <asm/div64.h>
 
 /* Proposed (but discarded) optimization: dynamic loading/unloading of bitmap
@@ -728,9 +727,8 @@ static void done_bnode(struct bitmap_nod
 }
 
 /* ZAM-FIXME-HANS: comment this.  Called only by load_and_lock_bnode()*/
-static int
-prepare_bnode(struct bitmap_node *bnode, jnode ** cjnode_ret,
-	      jnode ** wjnode_ret)
+static int prepare_bnode(struct bitmap_node *bnode, jnode **cjnode_ret,
+			 jnode **wjnode_ret)
 {
 	struct super_block *super;
 	jnode *cjnode;
@@ -1466,7 +1464,8 @@ int reiser4_init_allocator_bitmap(reiser
 
 	/* getting memory for bitmap allocator private data holder */
 	data =
-		kmalloc(sizeof(struct bitmap_allocator_data), GFP_KERNEL);
+		kmalloc(sizeof(struct bitmap_allocator_data),
+			reiser4_ctx_gfp_mask_get());
 
 	if (data == NULL)
 		return RETERR(-ENOMEM);
@@ -1482,7 +1481,7 @@ int reiser4_init_allocator_bitmap(reiser
 	   probably, another dynamic data structure should replace a static
 	   array of bnodes. */
 	/*data->bitmap = reiser4_kmalloc((size_t) (sizeof (struct bitmap_node) * bitmap_blocks_nr), GFP_KERNEL); */
-	data->bitmap = vmalloc(sizeof(struct bitmap_node) * bitmap_blocks_nr);
+	data->bitmap = reiser4_vmalloc(sizeof(struct bitmap_node) * bitmap_blocks_nr);
 	if (data->bitmap == NULL) {
 		kfree(data);
 		return RETERR(-ENOMEM);
@@ -1575,12 +1574,12 @@ int reiser4_destroy_allocator_bitmap(rei
 }
 
 /*
-   Local variables:
-   c-indentation-style: "K&R"
-   mode-name: "LC"
-   c-basic-offset: 8
-   tab-width: 8
-   fill-column: 80
-   scroll-step: 1
-   End:
-*/
+ * Local variables:
+ * c-indentation-style: "K&R"
+ * mode-name: "LC"
+ * c-basic-offset: 8
+ * tab-width: 8
+ * fill-column: 79
+ * scroll-step: 1
+ * End:
+ */
diff -puN fs/reiser4/search.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/search.c
--- a/fs/reiser4/search.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/search.c
@@ -55,7 +55,8 @@ int cbk_cache_init(cbk_cache *cache /* c
 	assert("nikita-346", cache != NULL);
 
 	cache->slot =
-	    kmalloc(sizeof(cbk_cache_slot) * cache->nr_slots, GFP_KERNEL);
+		kmalloc(sizeof(cbk_cache_slot) * cache->nr_slots,
+			reiser4_ctx_gfp_mask_get());
 	if (cache->slot == NULL)
 		return RETERR(-ENOMEM);
 
@@ -84,7 +85,6 @@ void cbk_cache_done(cbk_cache * cache /*
 	     &(cache)->lru != &(slot)->lru;					\
 	     (slot) = list_entry(slot->lru.next, cbk_cache_slot, lru))
 
-
 #if REISER4_DEBUG
 /* this function assures that [cbk-cache-invariant] invariant holds */
 static int cbk_cache_invariant(const cbk_cache *cache)
diff -puN fs/reiser4/status_flags.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/status_flags.c
--- a/fs/reiser4/status_flags.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/status_flags.c
@@ -40,15 +40,14 @@ int reiser4_status_init(reiser4_block_nr
 	struct bio *bio;
 	struct page *page;
 
-
 	get_super_private(sb)->status_page = NULL;
 	get_super_private(sb)->status_bio = NULL;
 
-	page = alloc_pages(GFP_KERNEL, 0);
+	page = alloc_pages(reiser4_ctx_gfp_mask_get(), 0);
 	if (!page)
 		return -ENOMEM;
 
-	bio = bio_alloc(GFP_KERNEL, 1);
+	bio = bio_alloc(reiser4_ctx_gfp_mask_get(), 1);
 	if (bio != NULL) {
 		bio->bi_sector = block * (sb->s_blocksize >> 9);
 		bio->bi_bdev = sb->s_bdev;
diff -puN fs/reiser4/super.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/super.h
--- a/fs/reiser4/super.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/super.h
@@ -50,7 +50,6 @@ typedef enum {
 	REISER4_ATOMIC_WRITE = 6,
 	/* don't use write barriers in the log writer code. */
 	REISER4_NO_WRITE_BARRIER = 7
-
 } reiser4_fs_flag;
 
 /*
@@ -189,6 +188,11 @@ struct reiser4_super_info_data {
 	/* unique file-system identifier */
 	__u32 fsuid;
 
+	/* On-disk format version. If does not equal to the disk_format
+	   plugin version, some format updates (e.g. enlarging plugin
+	   set, etc) may have place on mount. */
+	int version;
+
 	/* file-system wide flags. See reiser4_fs_flag enum */
 	unsigned long fs_flags;
 
@@ -295,7 +299,6 @@ struct reiser4_super_info_data {
 extern reiser4_super_info_data *get_super_private_nocheck(const struct
 							  super_block *super);
 
-
 /* Return reiser4-specific part of super block */
 static inline reiser4_super_info_data *get_super_private(const struct
 							 super_block *super)
@@ -311,7 +314,6 @@ static inline entd_context *get_entd_con
 	return &get_super_private(super)->entd;
 }
 
-
 /* "Current" super-block: main super block used during current system
    call. Reference to this super block is stored in reiser4_context. */
 static inline struct super_block *reiser4_get_current_sb(void)
@@ -424,7 +426,7 @@ extern void reiser4_done_fs_info(struct 
 extern int reiser4_init_super_data(struct super_block *, char *opt_string);
 extern int reiser4_init_read_super(struct super_block *, int silent);
 extern int reiser4_init_root_inode(struct super_block *);
-
+extern reiser4_plugin *get_default_plugin(pset_member memb);
 
 /* Maximal possible object id. */
 #define  ABSOLUTE_MAX_OID ((oid_t)~0)
diff -puN fs/reiser4/super_ops.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/super_ops.c
--- a/fs/reiser4/super_ops.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/super_ops.c
@@ -44,6 +44,8 @@ static void init_once(void *obj, kmem_ca
 		 * etc. that will be added to our private inode part.
 		 */
 		INIT_LIST_HEAD(get_readdir_list(&info->vfs_inode));
+		sema_init(&info->p.mutex_write, 1);
+		init_rwsem(&info->p.conv_sem);
 		/* init semaphore which is used during inode loading */
 		loading_init_once(&info->p);
 		INIT_RADIX_TREE(jnode_tree_by_reiser4_inode(&info->p),
@@ -98,10 +100,12 @@ static struct inode *reiser4_alloc_inode
 
 		info = &obj->p;
 
-		info->hset = info->pset = plugin_set_get_empty();
+		info->pset = plugin_set_get_empty();
+		info->hset = plugin_set_get_empty();
 		info->extmask = 0;
 		info->locality_id = 0ull;
 		info->plugin_mask = 0;
+		info->heir_mask = 0;
 #if !REISER4_INO_IS_OID
 		info->oid_hi = 0;
 #endif
@@ -139,6 +143,8 @@ static void reiser4_destroy_inode(struct
 	reiser4_dispose_cursors(inode);
 	if (info->pset)
 		plugin_set_put(info->pset);
+	if (info->hset)
+		plugin_set_put(info->hset);
 
 	/*
 	 * cannot add similar assertion about ->i_list as prune_icache return
@@ -524,6 +530,9 @@ static int fill_super(struct super_block
 	if ((result = reiser4_init_root_inode(super)) != 0)
 		goto failed_init_root_inode;
 
+	if ((result = get_super_private(super)->df_plug->version_update(super)) != 0 )
+		goto failed_update_format_version;
+
 	process_safelinks(super);
 	reiser4_exit_context(&ctx);
 
@@ -541,6 +550,7 @@ static int fill_super(struct super_block
 	}
 	return 0;
 
+ failed_update_format_version:
  failed_init_root_inode:
 	if (sbinfo->df_plug->release)
 		sbinfo->df_plug->release(super);
diff -puN fs/reiser4/znode.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion fs/reiser4/znode.c
--- a/fs/reiser4/znode.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion
+++ a/fs/reiser4/znode.c
@@ -188,7 +188,7 @@ blknrhashfn(z_hash_table * table, const 
 }
 
 /* The hash table definition */
-#define KMALLOC(size) kmalloc((size), GFP_KERNEL)
+#define KMALLOC(size) kmalloc((size), reiser4_ctx_gfp_mask_get())
 #define KFREE(ptr, size) kfree(ptr)
 TYPE_SAFE_HASH_DEFINE(z, znode, reiser4_block_nr, zjnode.key.z, zjnode.link.z,
 		      blknrhashfn, blknreq);
_

Patches currently in -mm which might be from edward@namesys.com are

reiser4.patch
reiser4-format-subversion-numbers-heir-set-and-file-conversion.patch
reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress.patch
reiser4-cleanups-in-lzo-compression-library.patch
reiser4-get-rid-of-deprecated-crypto-api.patch
reiser4-get-rid-of-deprecated-crypto-api-build-fix.patch
reiser4-fix-missed-unlock-and-exit_context.patch
reiser4-use-list_head-instead-of-struct-blocknr.patch
reiser4-use-list_empty-instead-of-list_empty_careful-for.patch
reiser4-update-comments-fix-write-and-truncate-cryptcompress.patch
reiser4-temp-fix.patch
reiser4-fix-write_extent-1.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
reiser4-use-null-for-pointers.patch
reiser4-test_clear_page_dirty.patch
reiser4-fix-readpage_cryptcompress.patch
reiser4-improve-estimation-for-number-of-nodes-occupied.patch
reiser4-drop-check_cryptcompress.patch
reiser4-drop-unused-semaphores.patch
reiser4-use-dynamic-lattice-for-adaptive-compression.patch
reiser4-fix-freeze-and-corruption.patch
