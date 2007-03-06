From: akpm@linux-foundation.org
Subject: - reiser4-use-list_head-instead-of-struct-blocknr.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:00:45 -0800
Message-ID: <200703060200.l2620jM7008750@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46662 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965693AbXCFCBD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:01:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward@namesys.com, hans_thomas_reiser@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: use list_head instead of struct blocknr
has been removed from the -mm tree.  Its filename was
     reiser4-use-list_head-instead-of-struct-blocknr.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: use list_head instead of struct blocknr
From: Edward Shishkin <edward@namesys.com>

. remove `struct blocknr_set' and just use list_head
. remove empty lines

Signed-off-by: Edward Shishkin <edward@namesys.com>
Cc: Hans Reiser <hans_thomas_reiser@yahoo.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/blocknrset.c                   |   51 +++++++++-----------
 fs/reiser4/carry.c                        |    1 
 fs/reiser4/debug.h                        |    1 
 fs/reiser4/dformat.h                      |    1 
 fs/reiser4/export_ops.c                   |    1 
 fs/reiser4/flush.c                        |    1 
 fs/reiser4/flush_queue.c                  |    1 
 fs/reiser4/forward.h                      |    1 
 fs/reiser4/fsdata.c                       |    1 
 fs/reiser4/fsdata.h                       |    3 -
 fs/reiser4/lock.c                         |    2 
 fs/reiser4/lock.h                         |    2 
 fs/reiser4/plugin/crypto/cipher.h         |    1 
 fs/reiser4/plugin/item/extent.c           |    1 
 fs/reiser4/plugin/item/extent_file_ops.c  |    1 
 fs/reiser4/plugin/item/extent_flush_ops.c |    1 
 fs/reiser4/plugin/item/internal.c         |    1 
 fs/reiser4/plugin/node/node40.c           |    1 
 fs/reiser4/pool.c                         |    1 
 fs/reiser4/super.c                        |    1 
 fs/reiser4/tree.h                         |    3 -
 fs/reiser4/txnmgr.c                       |    2 
 fs/reiser4/txnmgr.h                       |   21 +++-----
 fs/reiser4/vfs_ops.c                      |    8 ---
 fs/reiser4/vfs_ops.h                      |    3 -
 fs/reiser4/wander.c                       |    2 
 fs/reiser4/znode.h                        |    1 
 27 files changed, 32 insertions(+), 82 deletions(-)

diff -puN fs/reiser4/blocknrset.c~reiser4-use-list_head-instead-of-struct-blocknr fs/reiser4/blocknrset.c
--- a/fs/reiser4/blocknrset.c~reiser4-use-list_head-instead-of-struct-blocknr
+++ a/fs/reiser4/blocknrset.c
@@ -143,7 +143,7 @@ bse_put_pair(blocknr_set_entry * bse, co
    returned with the atom unlocked for the operation to be tried again.  If
    the operation succeeds, 0 is returned.  If new_bsep is non-NULL and not
    used during the call, it will be freed automatically. */
-static int blocknr_set_add(txn_atom *atom, blocknr_set *bset,
+static int blocknr_set_add(txn_atom *atom, struct list_head *bset,
 			   blocknr_set_entry **new_bsep, const reiser4_block_nr *a,
 			   const reiser4_block_nr *b)
 {
@@ -153,8 +153,8 @@ static int blocknr_set_add(txn_atom *ato
 	assert("jmacd-5101", a != NULL);
 
 	entries_needed = (b == NULL) ? 1 : 2;
-	if (list_empty(&bset->entries) ||
-	    bse_avail(list_entry(bset->entries.next, blocknr_set_entry, link)) < entries_needed) {
+	if (list_empty(bset) ||
+	    bse_avail(list_entry(bset->next, blocknr_set_entry, link)) < entries_needed) {
 		/* See if a bse was previously allocated. */
 		if (*new_bsep == NULL) {
 			spin_unlock_atom(atom);
@@ -164,13 +164,13 @@ static int blocknr_set_add(txn_atom *ato
 		}
 
 		/* Put it on the head of the list. */
-		list_add(&((*new_bsep)->link), &bset->entries);
+		list_add(&((*new_bsep)->link), bset);
 
 		*new_bsep = NULL;
 	}
 
 	/* Add the single or pair. */
-	bse = list_entry(bset->entries.next, blocknr_set_entry, link);
+	bse = list_entry(bset->next, blocknr_set_entry, link);
 	if (b == NULL) {
 		bse_put_single(bse, a);
 	} else {
@@ -194,7 +194,7 @@ static int blocknr_set_add(txn_atom *ato
    properly freed. */
 int
 blocknr_set_add_extent(txn_atom * atom,
-		       blocknr_set * bset,
+		       struct list_head * bset,
 		       blocknr_set_entry ** new_bsep,
 		       const reiser4_block_nr * start,
 		       const reiser4_block_nr * len)
@@ -212,7 +212,7 @@ blocknr_set_add_extent(txn_atom * atom,
    properly freed. */
 int
 blocknr_set_add_pair(txn_atom * atom,
-		     blocknr_set * bset,
+		     struct list_head * bset,
 		     blocknr_set_entry ** new_bsep, const reiser4_block_nr * a,
 		     const reiser4_block_nr * b)
 {
@@ -221,18 +221,18 @@ blocknr_set_add_pair(txn_atom * atom,
 }
 
 /* Initialize a blocknr_set. */
-void blocknr_set_init(blocknr_set *bset)
+void blocknr_set_init(struct list_head *bset)
 {
-	INIT_LIST_HEAD(&bset->entries);
+	INIT_LIST_HEAD(bset);
 }
 
 /* Release the entries of a blocknr_set. */
-void blocknr_set_destroy(blocknr_set *bset)
+void blocknr_set_destroy(struct list_head *bset)
 {
 	blocknr_set_entry *bse;
 
-	while (!list_empty_careful(&bset->entries)) {
-		bse = list_entry(bset->entries.next, blocknr_set_entry, link);
+	while (!list_empty_careful(bset)) {
+		bse = list_entry(bset->next, blocknr_set_entry, link);
 		list_del_init(&bse->link);
 		bse_free(bse);
 	}
@@ -248,25 +248,23 @@ void blocknr_set_destroy(blocknr_set *bs
    actual processing of this set. Testing this kind of stuff right here is
    also complicated by the fact that these sets are not sorted and going
    through whole set on each element addition is going to be CPU-heavy task */
-void blocknr_set_merge(blocknr_set * from, blocknr_set * into)
+void blocknr_set_merge(struct list_head * from, struct list_head * into)
 {
 	blocknr_set_entry *bse_into = NULL;
 
 	/* If @from is empty, no work to perform. */
-	if (list_empty_careful(&from->entries)) {
+	if (list_empty_careful(from))
 		return;
-	}
-
 	/* If @into is not empty, try merging partial-entries. */
-	if (!list_empty_careful(&into->entries)) {
+	if (!list_empty_careful(into)) {
 
 		/* Neither set is empty, pop the front to members and try to combine them. */
 		blocknr_set_entry *bse_from;
 		unsigned into_avail;
 
-		bse_into = list_entry(into->entries.next, blocknr_set_entry, link);
+		bse_into = list_entry(into->next, blocknr_set_entry, link);
 		list_del_init(&bse_into->link);
-		bse_from = list_entry(from->entries.next, blocknr_set_entry, link);
+		bse_from = list_entry(from->next, blocknr_set_entry, link);
 		list_del_init(&bse_from->link);
 
 		/* Combine singles. */
@@ -294,22 +292,21 @@ void blocknr_set_merge(blocknr_set * fro
 			   it could have one slot avail and bse_from has one
 			   pair left).  Push it back onto the list.  bse_from
 			   becomes bse_into, which will be the new partial. */
-			list_add(&bse_into->link, &into->entries);
+			list_add(&bse_into->link, into);
 			bse_into = bse_from;
 		}
 	}
 
 	/* Splice lists together. */
-	list_splice_init(&from->entries, into->entries.prev);
+	list_splice_init(from, into->prev);
 
 	/* Add the partial entry back to the head of the list. */
-	if (bse_into != NULL) {
-		list_add(&bse_into->link, &into->entries);
-	}
+	if (bse_into != NULL)
+		list_add(&bse_into->link, into);
 }
 
 /* Iterate over all blocknr set elements. */
-int blocknr_set_iterator(txn_atom *atom, blocknr_set *bset,
+int blocknr_set_iterator(txn_atom *atom, struct list_head *bset,
 			 blocknr_set_actor_f actor, void *data, int delete)
 {
 
@@ -320,8 +317,8 @@ int blocknr_set_iterator(txn_atom *atom,
 	assert("zam-431", bset != 0);
 	assert("zam-432", actor != NULL);
 
-	entry = list_entry(bset->entries.next, blocknr_set_entry, link);
-	while (&bset->entries != &entry->link) {
+	entry = list_entry(bset->next, blocknr_set_entry, link);
+	while (bset != &entry->link) {
 		blocknr_set_entry *tmp = list_entry(entry->link.next, blocknr_set_entry, link);
 		unsigned int i;
 		int ret;
diff -puN fs/reiser4/carry.c~reiser4-use-list_head-instead-of-struct-blocknr fs/reiser4/carry.c
--- a/fs/reiser4/carry.c~reiser4-use-list_head-instead-of-struct-blocknr
+++ a/fs/reiser4/carry.c
@@ -168,7 +168,6 @@ static carry_op *add_op(carry_level * le
 static void fatal_carry_error(carry_level * doing, int ecode);
 static int add_new_root(carry_level * level, carry_node * node, znode * fake);
 
-
 static void print_level(const char *prefix, carry_level * level);
 
 #if REISER4_DEBUG
diff -puN fs/reiser4/debug.h~reiser4-use-list_head-instead-of-struct-blocknr fs/reiser4/debug.h
--- a/fs/reiser4/debug.h~reiser4-use-list_head-instead-of-struct-blocknr
+++ a/fs/reiser4/debug.h
@@ -230,7 +230,6 @@ extern void reiser4_print_prefix(const c
 extern int reiser4_preempt_point(void);
 extern void reiser4_print_stats(void);
 
-
 #if REISER4_DEBUG
 extern int reiser4_no_counters_are_held(void);
 extern int reiser4_commit_check_locks(void);
diff -puN fs/reiser4/dformat.h~reiser4-use-list_head-instead-of-struct-blocknr fs/reiser4/dformat.h
--- a/fs/reiser4/dformat.h~reiser4-use-list_head-instead-of-struct-blocknr
+++ a/fs/reiser4/dformat.h
@@ -17,7 +17,6 @@
 #include <asm/unaligned.h>
 #include <linux/types.h>
 
-
 typedef __u8 d8;
 typedef __le16 d16;
 typedef __le32 d32;
diff -puN fs/reiser4/export_ops.c~reiser4-use-list_head-instead-of-struct-blocknr fs/reiser4/export_ops.c
--- a/fs/reiser4/export_ops.c~reiser4-use-list_head-instead-of-struct-blocknr
+++ a/fs/reiser4/export_ops.c
@@ -4,7 +4,6 @@
 #include "inode.h"
 #include "plugin/plugin.h"
 
-
 /*
  * Supported file-handle types
  */
diff -puN fs/reiser4/flush.c~reiser4-use-list_head-instead-of-struct-blocknr fs/reiser4/flush.c
--- a/fs/reiser4/flush.c~reiser4-use-list_head-instead-of-struct-blocknr
+++ a/fs/reiser4/flush.c
@@ -965,7 +965,6 @@ static jnode *find_flush_start_jnode(jno
 	return node;
 }
 
-
 /* Flush some nodes of current atom, usually slum, return -E_REPEAT if there are more nodes
  * to flush, return 0 if atom's dirty lists empty and keep current atom locked, return
  * other errors as they are. */
diff -puN fs/reiser4/flush_queue.c~reiser4-use-list_head-instead-of-struct-blocknr fs/reiser4/flush_queue.c
--- a/fs/reiser4/flush_queue.c~reiser4-use-list_head-instead-of-struct-blocknr
+++ a/fs/reiser4/flush_queue.c
@@ -109,7 +109,6 @@ static void init_fq(flush_queue_t * fq)
 /* slab for flush queues */
 static kmem_cache_t *fq_slab;
 
-
 /**
  * reiser4_init_fqs - create flush queue cache
  *
diff -puN fs/reiser4/forward.h~reiser4-use-list_head-instead-of-struct-blocknr fs/reiser4/forward.h
--- a/fs/reiser4/forward.h~reiser4-use-list_head-instead-of-struct-blocknr
+++ a/fs/reiser4/forward.h
@@ -38,7 +38,6 @@ typedef struct txn_mgr txn_mgr;
 typedef struct reiser4_dir_entry_desc reiser4_dir_entry_desc;
 typedef struct reiser4_context reiser4_context;
 typedef struct carry_level carry_level;
-typedef struct blocknr_set blocknr_set;
 typedef struct blocknr_set_entry blocknr_set_entry;
 /* super_block->s_fs_info points to this */
 typedef struct reiser4_super_info_data reiser4_super_info_data;
diff -puN fs/reiser4/fsdata.c~reiser4-use-list_head-instead-of-struct-blocknr fs/reiser4/fsdata.c
--- a/fs/reiser4/fsdata.c~reiser4-use-list_head-instead-of-struct-blocknr
+++ a/fs/reiser4/fsdata.c
@@ -661,7 +661,6 @@ void reiser4_free_dentry_fsdata(struct d
 	}
 }
 
-
 /* slab for reiser4_file_fsdata */
 static kmem_cache_t *file_fsdata_cache;
 
diff -puN fs/reiser4/fsdata.h~reiser4-use-list_head-instead-of-struct-blocknr fs/reiser4/fsdata.h
--- a/fs/reiser4/fsdata.h~reiser4-use-list_head-instead-of-struct-blocknr
+++ a/fs/reiser4/fsdata.h
@@ -87,7 +87,6 @@ extern void reiser4_done_dentry_fsdata(v
 extern reiser4_dentry_fsdata *reiser4_get_dentry_fsdata(struct dentry *);
 extern void reiser4_free_dentry_fsdata(struct dentry *dentry);
 
-
 /**
  * reiser4_file_fsdata - reiser4-specific data attached to file->private_data
  *
@@ -127,7 +126,6 @@ extern void reiser4_done_file_fsdata(voi
 extern reiser4_file_fsdata *reiser4_get_file_fsdata(struct file *);
 extern void reiser4_free_file_fsdata(struct file *);
 
-
 /*
  * d_cursor is reiser4_file_fsdata not attached to struct file. d_cursors are
  * used to address problem reiser4 has with readdir accesses via NFS. See
@@ -175,7 +173,6 @@ extern loff_t reiser4_get_dir_fpos(struc
 extern int reiser4_attach_fsdata(struct file *, struct inode *);
 extern void reiser4_detach_fsdata(struct file *);
 
-
 /* these are needed for "stateless" readdir. See plugin/file_ops_readdir.c for
    more details */
 void reiser4_dispose_cursors(struct inode *inode);
diff -puN fs/reiser4/lock.c~reiser4-use-list_head-instead-of-struct-blocknr fs/reiser4/lock.c
--- a/fs/reiser4/lock.c~reiser4-use-list_head-instead-of-struct-blocknr
+++ a/fs/reiser4/lock.c
@@ -350,7 +350,6 @@ static int recursive(lock_stack * owner)
 	assert("nikita-1841", owner == get_current_lock_stack());
 	assert_spin_locked(&(node->lock.guard));
 
-
 	lh = list_entry(node->lock.owners.next, lock_handle, owners_link);
 	ret = (lh->owner == owner);
 
@@ -552,7 +551,6 @@ static void remove_lock_request(lock_sta
 	list_del(&requestor->requestors_link);
 }
 
-
 static void invalidate_all_lock_requests(znode * node)
 {
 	lock_stack *requestor, *tmp;
diff -puN fs/reiser4/lock.h~reiser4-use-list_head-instead-of-struct-blocknr fs/reiser4/lock.h
--- a/fs/reiser4/lock.h~reiser4-use-list_head-instead-of-struct-blocknr
+++ a/fs/reiser4/lock.h
@@ -142,7 +142,6 @@ struct lock_stack {
 #endif
 };
 
-
 /*
   User-visible znode locking functions
 */
@@ -219,7 +218,6 @@ static inline void spin_unlock_stack(loc
 	spin_unlock(&(stack->sguard));
 }
 
-
 static inline void reiser4_wake_up(lock_stack * owner)
 {
 	spin_lock_stack(owner);
diff -puN fs/reiser4/plugin/crypto/cipher.h~reiser4-use-list_head-instead-of-struct-blocknr fs/reiser4/plugin/crypto/cipher.h
--- a/fs/reiser4/plugin/crypto/cipher.h~reiser4-use-list_head-instead-of-struct-blocknr
+++ a/fs/reiser4/plugin/crypto/cipher.h
@@ -8,7 +8,6 @@
 
 #include <linux/crypto.h>
 
-
 /* key info imported from user space */
 typedef struct crypto_data {
 	int keysize;    /* uninstantiated key size */
diff -puN fs/reiser4/plugin/item/extent.c~reiser4-use-list_head-instead-of-struct-blocknr fs/reiser4/plugin/item/extent.c
--- a/fs/reiser4/plugin/item/extent.c~reiser4-use-list_head-instead-of-struct-blocknr
+++ a/fs/reiser4/plugin/item/extent.c
@@ -69,7 +69,6 @@ void reiser4_set_extent(reiser4_extent *
 	extent_set_width(ext, width);
 }
 
-
 /**
  * reiser4_replace_extent - replace extent and paste 1 or 2 after it
  * @un_extent: coordinate of extent to be overwritten
diff -puN fs/reiser4/plugin/item/extent_file_ops.c~reiser4-use-list_head-instead-of-struct-blocknr fs/reiser4/plugin/item/extent_file_ops.c
--- a/fs/reiser4/plugin/item/extent_file_ops.c~reiser4-use-list_head-instead-of-struct-blocknr
+++ a/fs/reiser4/plugin/item/extent_file_ops.c
@@ -9,7 +9,6 @@
 #include <linux/swap.h>
 #include "../../../../mm/filemap.h"
 
-
 static inline reiser4_extent *ext_by_offset(const znode *node, int offset)
 {
 	reiser4_extent *ext;
diff -puN fs/reiser4/plugin/item/extent_flush_ops.c~reiser4-use-list_head-instead-of-struct-blocknr fs/reiser4/plugin/item/extent_flush_ops.c
--- a/fs/reiser4/plugin/item/extent_flush_ops.c~reiser4-use-list_head-instead-of-struct-blocknr
+++ a/fs/reiser4/plugin/item/extent_flush_ops.c
@@ -806,7 +806,6 @@ int reiser4_alloc_extent(flush_pos_t *fl
 		/* assign new block numbers to protected nodes */
 		assign_real_blocknrs(flush_pos, oid, index, allocated, first_allocated);
 
-
 		/* prepare extent which will replace current one */
 		reiser4_set_extent(&replace_ext, first_allocated, allocated);
 
diff -puN fs/reiser4/plugin/item/internal.c~reiser4-use-list_head-instead-of-struct-blocknr fs/reiser4/plugin/item/internal.c
--- a/fs/reiser4/plugin/item/internal.c~reiser4-use-list_head-instead-of-struct-blocknr
+++ a/fs/reiser4/plugin/item/internal.c
@@ -297,7 +297,6 @@ int create_hook_internal(const coord_t *
     . when last reference to this node will be dropped, bitmap will be updated
     and node will be actually removed from the memory.
 
-
 */
 int kill_hook_internal(const coord_t * item /* coord of item */ ,
 		       pos_in_node_t from UNUSED_ARG /* start unit */ ,
diff -puN fs/reiser4/plugin/node/node40.c~reiser4-use-list_head-instead-of-struct-blocknr fs/reiser4/plugin/node/node40.c
--- a/fs/reiser4/plugin/node/node40.c~reiser4-use-list_head-instead-of-struct-blocknr
+++ a/fs/reiser4/plugin/node/node40.c
@@ -64,7 +64,6 @@ static inline node40_header *node40_node
 #define nh40_set_num_items(nh, value) put_unaligned(cpu_to_le16(value), &(nh)->nr_items)
 #define nh40_set_mkfs_id(nh, value) put_unaligned(cpu_to_le32(value), &(nh)->mkfs_id)
 
-
 /* plugin field of node header should be read/set by
    plugin_by_disk_id/save_disk_plugin */
 
diff -puN fs/reiser4/pool.c~reiser4-use-list_head-instead-of-struct-blocknr fs/reiser4/pool.c
--- a/fs/reiser4/pool.c~reiser4-use-list_head-instead-of-struct-blocknr
+++ a/fs/reiser4/pool.c
@@ -41,7 +41,6 @@
    functions in the style of tslist/tshash, i.e., make them unreadable, but
    type-safe.
 
-
 */
 
 #include "debug.h"
diff -puN fs/reiser4/super.c~reiser4-use-list_head-instead-of-struct-blocknr fs/reiser4/super.c
--- a/fs/reiser4/super.c~reiser4-use-list_head-instead-of-struct-blocknr
+++ a/fs/reiser4/super.c
@@ -17,7 +17,6 @@
 #include <linux/types.h>	/* for __u??  */
 #include <linux/fs.h>		/* for struct super_block  */
 
-
 static __u64 reserved_for_gid(const struct super_block *super, gid_t gid);
 static __u64 reserved_for_uid(const struct super_block *super, uid_t uid);
 static __u64 reserved_for_root(const struct super_block *super);
diff -puN fs/reiser4/tree.h~reiser4-use-list_head-instead-of-struct-blocknr fs/reiser4/tree.h
--- a/fs/reiser4/tree.h~reiser4-use-list_head-instead-of-struct-blocknr
+++ a/fs/reiser4/tree.h
@@ -66,7 +66,6 @@ typedef struct cbk_cache {
 	cbk_cache_slot *slot;
 } cbk_cache;
 
-
 /* level_lookup_result - possible outcome of looking up key at some level.
    This is used by coord_by_key when traversing tree downward. */
 typedef enum {
@@ -433,7 +432,6 @@ int lookup_couple(reiser4_tree * tree,
 		  tree_level lock_level, tree_level stop_level, __u32 flags,
 		  int *result1, int *result2);
 
-
 static inline void read_lock_tree(reiser4_tree *tree)
 {
 	/* check that tree is not locked */
@@ -564,7 +562,6 @@ reiser4_block_nr estimate_dirty_cluster(
 reiser4_block_nr estimate_insert_cluster(struct inode *);
 reiser4_block_nr estimate_update_cluster(struct inode *);
 
-
 /* __REISER4_TREE_H__ */
 #endif
 
diff -puN fs/reiser4/txnmgr.c~reiser4-use-list_head-instead-of-struct-blocknr fs/reiser4/txnmgr.c
--- a/fs/reiser4/txnmgr.c~reiser4-use-list_head-instead-of-struct-blocknr
+++ a/fs/reiser4/txnmgr.c
@@ -2802,7 +2802,6 @@ static void lock_two_atoms(txn_atom * on
 	}
 }
 
-
 /* Perform the necessary work to prepare for fusing two atoms, which involves
  * acquiring two atom locks in the proper order.  If one of the node's atom is
  * blocking fusion (i.e., it is in the CAPTURE_WAIT stage) and the handle's
@@ -3095,7 +3094,6 @@ void insert_into_atom_ovrwr_list(txn_ato
 	ON_DEBUG(count_jnode(atom, node, NODE_LIST(node), OVRWR_LIST, 1));
 }
 
-
 #if REISER4_DEBUG
 
 void reiser4_info_atom(const char *prefix, const txn_atom * atom)
diff -puN fs/reiser4/txnmgr.h~reiser4-use-list_head-instead-of-struct-blocknr fs/reiser4/txnmgr.h
--- a/fs/reiser4/txnmgr.h~reiser4-use-list_head-instead-of-struct-blocknr
+++ a/fs/reiser4/txnmgr.h
@@ -192,11 +192,6 @@ typedef enum {
    code above and proceed without restarting if they are still satisfied.
 */
 
-/* A block number set consists of only the list head. */
-struct blocknr_set {
-	struct list_head entries;
-};
-
 /* An atomic transaction: this is the underlying system representation
    of a transaction, not the one seen by clients.
 
@@ -252,10 +247,10 @@ struct txn_atom {
 
 	/* The atom's delete set. It collects block numbers of the nodes
 	   which were deleted during the transaction. */
-	blocknr_set delete_set;
+	struct list_head delete_set;
 
 	/* The atom's wandered_block mapping. */
-	blocknr_set wandered_map;
+	struct list_head wandered_map;
 
 	/* The transaction's list of dirty captured nodes--per level.  Index
 	   by (level). dirty_nodes[0] is for znode-above-root */
@@ -475,15 +470,15 @@ int capture_bulk(jnode **, int count);
 
 /* See the comment on the function blocknrset.c:blocknr_set_add for the
    calling convention of these three routines. */
-extern void blocknr_set_init(blocknr_set * bset);
-extern void blocknr_set_destroy(blocknr_set * bset);
-extern void blocknr_set_merge(blocknr_set * from, blocknr_set * into);
+extern void blocknr_set_init(struct list_head * bset);
+extern void blocknr_set_destroy(struct list_head * bset);
+extern void blocknr_set_merge(struct list_head * from, struct list_head * into);
 extern int blocknr_set_add_extent(txn_atom * atom,
-				  blocknr_set * bset,
+				  struct list_head * bset,
 				  blocknr_set_entry ** new_bsep,
 				  const reiser4_block_nr * start,
 				  const reiser4_block_nr * len);
-extern int blocknr_set_add_pair(txn_atom * atom, blocknr_set * bset,
+extern int blocknr_set_add_pair(txn_atom * atom, struct list_head * bset,
 				blocknr_set_entry ** new_bsep,
 				const reiser4_block_nr * a,
 				const reiser4_block_nr * b);
@@ -491,7 +486,7 @@ extern int blocknr_set_add_pair(txn_atom
 typedef int (*blocknr_set_actor_f) (txn_atom *, const reiser4_block_nr *,
 				    const reiser4_block_nr *, void *);
 
-extern int blocknr_set_iterator(txn_atom * atom, blocknr_set * bset,
+extern int blocknr_set_iterator(txn_atom * atom, struct list_head * bset,
 				blocknr_set_actor_f actor, void *data,
 				int delete);
 
diff -puN fs/reiser4/vfs_ops.c~reiser4-use-list_head-instead-of-struct-blocknr fs/reiser4/vfs_ops.c
--- a/fs/reiser4/vfs_ops.c~reiser4-use-list_head-instead-of-struct-blocknr
+++ a/fs/reiser4/vfs_ops.c
@@ -51,7 +51,6 @@
 #include <linux/reboot.h>
 #include <linux/rcupdate.h>
 
-
 /* update inode stat-data by calling plugin */
 int reiser4_update_sd(struct inode *object)
 {
@@ -131,9 +130,6 @@ int reiser4_del_nlink(struct inode *obje
 	return result;
 }
 
-
-
-
 /* Release reiser4 dentry. This is d_op->d_release() method. */
 static void reiser4_d_release(struct dentry *dentry /* dentry released */ )
 {
@@ -205,7 +201,6 @@ void reiser4_writeout(struct super_block
 	} while (wbc->nr_to_write > 0);
 }
 
-
 void reiser4_throttle_write(struct inode *inode)
 {
 	reiser4_txn_restart_current();
@@ -216,8 +211,6 @@ const char *REISER4_SUPER_MAGIC_STRING =
 const int REISER4_MAGIC_OFFSET = 16 * 4096;	/* offset to magic string from the
 						 * beginning of device */
 
-
-
 /*
  * Reiser4 initialization/shutdown.
  *
@@ -226,7 +219,6 @@ const int REISER4_MAGIC_OFFSET = 16 * 40
  * during reiser4 module load (when compiled as module).
  */
 
-
 void reiser4_handle_error(void)
 {
 	struct super_block *sb = reiser4_get_current_sb();
diff -puN fs/reiser4/vfs_ops.h~reiser4-use-list_head-instead-of-struct-blocknr fs/reiser4/vfs_ops.h
--- a/fs/reiser4/vfs_ops.h~reiser4-use-list_head-instead-of-struct-blocknr
+++ a/fs/reiser4/vfs_ops.h
@@ -29,7 +29,6 @@ extern int reiser4_update_sd(struct inod
 extern int reiser4_add_nlink(struct inode *, struct inode *, int);
 extern int reiser4_del_nlink(struct inode *, struct inode *, int);
 
-
 extern int reiser4_start_up_io(struct page *page);
 extern void reiser4_throttle_write(struct inode *);
 extern int jnode_is_releasable(jnode *);
@@ -37,10 +36,8 @@ extern int jnode_is_releasable(jnode *);
 #define CAPTURE_APAGE_BURST (1024l)
 void reiser4_writeout(struct super_block *, struct writeback_control *);
 
-
 extern void reiser4_handle_error(void);
 
-
 /* __FS_REISER4_VFS_OPS_H__ */
 #endif
 
diff -puN fs/reiser4/wander.c~reiser4-use-list_head-instead-of-struct-blocknr fs/reiser4/wander.c
--- a/fs/reiser4/wander.c~reiser4-use-list_head-instead-of-struct-blocknr
+++ a/fs/reiser4/wander.c
@@ -235,7 +235,6 @@ static void disable_write_barrier(struct
 	set_bit((int)REISER4_NO_WRITE_BARRIER, &get_super_private(s)->fs_flags);
 }
 
-
 /* fill journal header block data  */
 static void format_journal_header(struct commit_handle *ch)
 {
@@ -1150,7 +1149,6 @@ static int commit_tx(struct commit_handl
 	return ret;
 }
 
-
 static int write_tx_back(struct commit_handle * ch)
 {
 	flush_queue_t *fq;
diff -puN fs/reiser4/znode.h~reiser4-use-list_head-instead-of-struct-blocknr fs/reiser4/znode.h
--- a/fs/reiser4/znode.h~reiser4-use-list_head-instead-of-struct-blocknr
+++ a/fs/reiser4/znode.h
@@ -230,7 +230,6 @@ extern znode *zalloc(gfp_t gfp_flag);
 extern void zinit(znode *, const znode * parent, reiser4_tree *);
 extern int zparse(znode * node);
 
-
 extern int znode_just_created(const znode * node);
 
 extern void zfree(znode * node);
_

Patches currently in -mm which might be from edward@namesys.com are

reiser4.patch
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
