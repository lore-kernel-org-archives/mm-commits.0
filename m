From: akpm@linux-foundation.org
Subject: - reiser4-remove-typedefs.patch removed from -mm tree
Date: Mon, 09 Jul 2007 16:58:35 -0700
Message-ID: <200707092358.l69NwZkA021973@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44001 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760306AbXGIX7I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 19:59:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: remove typedefs
has been removed from the -mm tree.  Its filename was
     reiser4-remove-typedefs.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: remove typedefs
From: Edward Shishkin <edward@namesys.com>

. Reduce number of typedefs from 289 to 248
. Remove unused file plugin/file/invert.c
. Update comments


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/blocknrset.c                    |   16 
 fs/reiser4/carry.h                         |    8 
 fs/reiser4/context.h                       |    2 
 fs/reiser4/debug.c                         |    8 
 fs/reiser4/debug.h                         |   12 
 fs/reiser4/flush.h                         |   25 
 fs/reiser4/forward.h                       |    4 
 fs/reiser4/fsdata.c                        |   38 -
 fs/reiser4/fsdata.h                        |   34 -
 fs/reiser4/init_super.c                    |   26 -
 fs/reiser4/inode.h                         |   20 
 fs/reiser4/jnode.c                         |   13 
 fs/reiser4/jnode.h                         |    6 
 fs/reiser4/lock.c                          |    2 
 fs/reiser4/lock.h                          |    6 
 fs/reiser4/plugin/cluster.h                |   68 +-
 fs/reiser4/plugin/compress/compress.h      |   13 
 fs/reiser4/plugin/compress/compress_mode.c |    2 
 fs/reiser4/plugin/crypto/cipher.h          |    8 
 fs/reiser4/plugin/dir_plugin_common.c      |   18 
 fs/reiser4/plugin/file/cryptcompress.c     |  376 +++++++-------
 fs/reiser4/plugin/file/cryptcompress.h     |  190 +++----
 fs/reiser4/plugin/file/file.c              |   46 -
 fs/reiser4/plugin/file/file.h              |   26 -
 fs/reiser4/plugin/file/file_conversion.c   |   24 
 fs/reiser4/plugin/file/invert.c            |  493 -------------------
 fs/reiser4/plugin/file/tail_conversion.c   |   18 
 fs/reiser4/plugin/file_ops_readdir.c       |   29 -
 fs/reiser4/plugin/inode_ops_rename.c       |   12 
 fs/reiser4/plugin/item/cde.c               |   16 
 fs/reiser4/plugin/item/cde.h               |   10 
 fs/reiser4/plugin/item/ctail.c             |   55 +-
 fs/reiser4/plugin/item/ctail.h             |   15 
 fs/reiser4/plugin/item/extent.h            |    8 
 fs/reiser4/plugin/item/extent_file_ops.c   |   16 
 fs/reiser4/plugin/item/item.h              |   39 -
 fs/reiser4/plugin/item/static_stat.c       |   16 
 fs/reiser4/plugin/item/tail.c              |    2 
 fs/reiser4/plugin/item/tail.h              |    4 
 fs/reiser4/plugin/plugin.c                 |   55 --
 fs/reiser4/plugin/plugin.h                 |   23 
 fs/reiser4/plugin/plugin_header.h          |   53 +-
 fs/reiser4/plugin/security/perm.c          |   17 
 fs/reiser4/plugin/security/perm.h          |   58 --
 fs/reiser4/pool.c                          |   45 -
 fs/reiser4/pool.h                          |   23 
 fs/reiser4/readahead.c                     |    2 
 fs/reiser4/readahead.h                     |   13 
 fs/reiser4/safe_link.c                     |   15 
 fs/reiser4/super.h                         |   20 
 fs/reiser4/super_ops.c                     |    8 
 fs/reiser4/txnmgr.h                        |    7 
 fs/reiser4/znode.h                         |    2 
 53 files changed, 747 insertions(+), 1318 deletions(-)

diff -puN fs/reiser4/blocknrset.c~reiser4-remove-typedefs fs/reiser4/blocknrset.c
--- a/fs/reiser4/blocknrset.c~reiser4-remove-typedefs
+++ a/fs/reiser4/blocknrset.c
@@ -31,8 +31,6 @@
 /* Protection: blocknr sets belong to reiser4 atom, and
  * their modifications are performed with the atom lock held */
 
-typedef struct blocknr_pair blocknr_pair;
-
 /* The total size of a blocknr_set_entry. */
 #define BLOCKNR_SET_ENTRY_SIZE 128
 
@@ -111,12 +109,14 @@ bse_put_single(blocknr_set_entry * bse, 
 
 /* Get a pair of block numbers */
 /* Audited by: green(2002.06.11) */
-static inline blocknr_pair *bse_get_pair(blocknr_set_entry * bse, unsigned pno)
+static inline struct blocknr_pair *bse_get_pair(blocknr_set_entry * bse,
+						unsigned pno)
 {
 	assert("green-1", BLOCKNR_SET_ENTRIES_NUMBER >= 2 * (pno + 1));
 
-	return (blocknr_pair *) (bse->entries + BLOCKNR_SET_ENTRIES_NUMBER -
-				 2 * (pno + 1));
+	return (struct blocknr_pair *) (bse->entries +
+					BLOCKNR_SET_ENTRIES_NUMBER -
+					2 * (pno + 1));
 }
 
 /* Add a pair of block numbers to a blocknr_set_entry */
@@ -125,7 +125,7 @@ static void
 bse_put_pair(blocknr_set_entry * bse, const reiser4_block_nr * a,
 	     const reiser4_block_nr * b)
 {
-	blocknr_pair *pair;
+	struct blocknr_pair *pair;
 
 	assert("jmacd-5100", bse_avail(bse) >= 2 && a != NULL && b != NULL);
 
@@ -282,8 +282,8 @@ void blocknr_set_merge(struct list_head 
 		/* Combine pairs. */
 		for (; into_avail > 1 && bse_from->nr_pairs != 0;
 		     into_avail -= 2) {
-			blocknr_pair *pair =
-			    bse_get_pair(bse_from, --bse_from->nr_pairs);
+			struct blocknr_pair *pair =
+				bse_get_pair(bse_from, --bse_from->nr_pairs);
 			bse_put_pair(bse_into, &pair->a, &pair->b);
 		}
 
diff -puN fs/reiser4/carry.h~reiser4-remove-typedefs fs/reiser4/carry.h
--- a/fs/reiser4/carry.h~reiser4-remove-typedefs
+++ a/fs/reiser4/carry.h
@@ -27,7 +27,7 @@
 */
 typedef struct carry_node {
 	/* pool linkage */
-	reiser4_pool_header header;
+	struct reiser4_pool_header header;
 
 	/* base node from which real_node is calculated. See
 	   fs/reiser4/carry.c:lock_carry_node(). */
@@ -213,7 +213,7 @@ struct carry_kill_data {
 */
 typedef struct carry_op {
 	/* pool linkage */
-	reiser4_pool_header header;
+	struct reiser4_pool_header header;
 	carry_opcode op;
 	/* node on which operation is to be performed:
 
@@ -287,9 +287,9 @@ typedef struct carry_op {
 /* &carry_op_pool - preallocated pool of carry operations, and nodes */
 typedef struct carry_pool {
 	carry_op op[CARRIES_POOL_SIZE];
-	reiser4_pool op_pool;
+	struct reiser4_pool op_pool;
 	carry_node node[NODES_LOCKED_POOL_SIZE];
-	reiser4_pool node_pool;
+	struct reiser4_pool node_pool;
 } carry_pool;
 
 /* &carry_tree_level - carry process on given level
diff -puN fs/reiser4/context.h~reiser4-remove-typedefs fs/reiser4/context.h
--- a/fs/reiser4/context.h~reiser4-remove-typedefs
+++ a/fs/reiser4/context.h
@@ -76,7 +76,7 @@ struct reiser4_context {
 #if REISER4_DEBUG
 	/* debugging information about reiser4 locks held by the current
 	 * thread */
-	reiser4_lock_counters_info locks;
+	reiser4_lock_cnt_info locks;
 	struct task_struct *task;	/* so we can easily find owner of the stack */
 
 	/*
diff -puN fs/reiser4/debug.c~reiser4-remove-typedefs fs/reiser4/debug.c
--- a/fs/reiser4/debug.c~reiser4-remove-typedefs
+++ a/fs/reiser4/debug.c
@@ -134,7 +134,7 @@ int reiser4_preempt_point(void)
    constraints and various assertions.
 
 */
-reiser4_lock_counters_info *reiser4_lock_counters(void)
+reiser4_lock_cnt_info *reiser4_lock_counters(void)
 {
 	reiser4_context *ctx = get_current_context();
 	assert("jmacd-1123", ctx != NULL);
@@ -145,7 +145,7 @@ reiser4_lock_counters_info *reiser4_lock
  * print human readable information about locks held by the reiser4 context.
  */
 static void print_lock_counters(const char *prefix,
-				const reiser4_lock_counters_info * info)
+				const reiser4_lock_cnt_info * info)
 {
 	printk("%s: jnode: %i, tree: %i (r:%i,w:%i), dk: %i (r:%i,w:%i)\n"
 	       "jload: %i, "
@@ -195,7 +195,7 @@ int reiser4_schedulable(void)
  */
 int reiser4_no_counters_are_held(void)
 {
-	reiser4_lock_counters_info *counters;
+	reiser4_lock_cnt_info *counters;
 
 	counters = reiser4_lock_counters();
 	return
@@ -224,7 +224,7 @@ int reiser4_no_counters_are_held(void)
  */
 int reiser4_commit_check_locks(void)
 {
-	reiser4_lock_counters_info *counters;
+	reiser4_lock_cnt_info *counters;
 	int inode_sem_r;
 	int inode_sem_w;
 	int result;
diff -puN fs/reiser4/debug.h~reiser4-remove-typedefs fs/reiser4/debug.h
--- a/fs/reiser4/debug.h~reiser4-remove-typedefs
+++ a/fs/reiser4/debug.h
@@ -88,7 +88,7 @@ extern void call_on_each_assert(void);
 #if REISER4_DEBUG
 /* per-thread information about lock acquired by this thread. Used by lock
  * ordering checking in spin_macros.h */
-typedef struct reiser4_lock_counters_info {
+typedef struct reiser4_lock_cnt_info {
 	int rw_locked_tree;
 	int read_locked_tree;
 	int write_locked_tree;
@@ -121,9 +121,9 @@ typedef struct reiser4_lock_counters_inf
 	int d_refs;
 	int x_refs;
 	int t_refs;
-} reiser4_lock_counters_info;
+} reiser4_lock_cnt_info;
 
-extern reiser4_lock_counters_info *reiser4_lock_counters(void);
+extern struct reiser4_lock_cnt_info *reiser4_lock_counters(void);
 #define IN_CONTEXT(a, b) (is_in_reiser4_context() ? (a) : (b))
 
 /* increment lock-counter @counter, if present */
@@ -149,10 +149,10 @@ extern reiser4_lock_counters_info *reise
 
 /* no-op versions on the above */
 
-typedef struct reiser4_lock_counters_info {
-} reiser4_lock_counters_info;
+typedef struct reiser4_lock_cnt_info {
+} reiser4_lock_cnt_info;
 
-#define reiser4_lock_counters() ((reiser4_lock_counters_info *)NULL)
+#define reiser4_lock_counters() ((reiser4_lock_cnt_info *)NULL)
 #define LOCK_CNT_INC(counter) noop
 #define LOCK_CNT_DEC(counter) noop
 #define LOCK_CNT_NIL(counter) (1)
diff -puN fs/reiser4/flush.h~reiser4-remove-typedefs fs/reiser4/flush.h
--- a/fs/reiser4/flush.h~reiser4-remove-typedefs
+++ a/fs/reiser4/flush.h
@@ -56,19 +56,19 @@ struct flush_scan {
 	reiser4_block_nr preceder_blk;
 };
 
-typedef struct convert_item_info {
+struct convert_item_info {
 	dc_item_stat d_cur;	/* disk cluster state of the current item */
 	dc_item_stat d_next;	/* disk cluster state of the next slum item */
 	struct inode *inode;
 	flow_t flow;
-} convert_item_info_t;
+};
 
-typedef struct convert_info {
+struct convert_info {
 	int count;		/* for squalloc terminating */
-	reiser4_cluster_t clust;	/* transform cluster */
 	item_plugin *iplug;	/* current item plugin */
-	convert_item_info_t *itm;	/* current item info */
-} convert_info_t;
+	struct convert_item_info *itm;	/* current item info */
+	struct cluster_handle clust;	/* transform cluster */
+};
 
 typedef enum flush_position_state {
 	POS_INVALID,		/* Invalid or stopped pos, do not continue slum
@@ -108,7 +108,7 @@ struct flush_position {
 
 	znode *prev_twig;	/* previous parent pointer value, used to catch
 				 * processing of new twig node */
-	convert_info_t *sq;	/* convert info */
+	struct convert_info *sq;	/* convert info */
 
 	unsigned long pos_in_unit;	/* for extents only. Position
 					   within an extent unit of first
@@ -133,26 +133,27 @@ static inline item_plugin *item_convert_
 	return pos->sq->iplug;
 }
 
-static inline convert_info_t *convert_data(flush_pos_t * pos)
+static inline struct convert_info *convert_data(flush_pos_t * pos)
 {
 	return pos->sq;
 }
 
-static inline convert_item_info_t *item_convert_data(flush_pos_t * pos)
+static inline struct convert_item_info *item_convert_data(flush_pos_t * pos)
 {
 	assert("edward-955", convert_data(pos));
 	return pos->sq->itm;
 }
 
-static inline tfm_cluster_t *tfm_cluster_sq(flush_pos_t * pos)
+static inline struct tfm_cluster * tfm_cluster_sq(flush_pos_t * pos)
 {
 	return &pos->sq->clust.tc;
 }
 
-static inline tfm_stream_t *tfm_stream_sq(flush_pos_t * pos, tfm_stream_id id)
+static inline struct tfm_stream * tfm_stream_sq(flush_pos_t * pos,
+						tfm_stream_id id)
 {
 	assert("edward-854", pos->sq != NULL);
-	return tfm_stream(tfm_cluster_sq(pos), id);
+	return get_tfm_stream(tfm_cluster_sq(pos), id);
 }
 
 static inline int chaining_data_present(flush_pos_t * pos)
diff -puN fs/reiser4/forward.h~reiser4-remove-typedefs fs/reiser4/forward.h
--- a/fs/reiser4/forward.h~reiser4-remove-typedefs
+++ a/fs/reiser4/forward.h
@@ -15,8 +15,6 @@ typedef struct znode znode;
 typedef struct flow flow_t;
 typedef struct coord coord_t;
 typedef struct tree_access_pointer tap_t;
-typedef struct item_coord item_coord;
-typedef struct shift_params shift_params;
 typedef struct reiser4_object_create_data reiser4_object_create_data;
 typedef union reiser4_plugin reiser4_plugin;
 typedef __u16 reiser4_plugin_id;
@@ -59,8 +57,6 @@ typedef struct hint hint_t;
 
 typedef struct ktxnmgrd_context ktxnmgrd_context;
 
-typedef struct reiser4_xattr_plugin reiser4_xattr_plugin;
-
 struct inode;
 struct page;
 struct file;
diff -puN fs/reiser4/fsdata.c~reiser4-remove-typedefs fs/reiser4/fsdata.c
--- a/fs/reiser4/fsdata.c~reiser4-remove-typedefs
+++ a/fs/reiser4/fsdata.c
@@ -100,13 +100,14 @@ void reiser4_done_d_cursor(void)
 #define D_CURSOR_TABLE_SIZE (256)
 
 static inline unsigned long
-d_cursor_hash(d_cursor_hash_table *table, const d_cursor_key *key)
+d_cursor_hash(d_cursor_hash_table *table, const struct d_cursor_key *key)
 {
 	assert("nikita-3555", IS_POW(D_CURSOR_TABLE_SIZE));
 	return (key->oid + key->cid) & (D_CURSOR_TABLE_SIZE - 1);
 }
 
-static inline int d_cursor_eq(const d_cursor_key *k1, const d_cursor_key *k2)
+static inline int d_cursor_eq(const struct d_cursor_key *k1,
+			      const struct d_cursor_key *k2)
 {
 	return k1->cid == k2->cid && k1->oid == k2->oid;
 }
@@ -119,7 +120,8 @@ static inline int d_cursor_eq(const d_cu
 #define KFREE(ptr, size) kfree(ptr)
 TYPE_SAFE_HASH_DEFINE(d_cursor,
 		      dir_cursor,
-		      d_cursor_key, key, hash, d_cursor_hash, d_cursor_eq);
+		      struct d_cursor_key,
+		      key, hash, d_cursor_hash, d_cursor_eq);
 #undef KFREE
 #undef KMALLOC
 
@@ -132,7 +134,7 @@ TYPE_SAFE_HASH_DEFINE(d_cursor,
  */
 int reiser4_init_super_d_info(struct super_block *super)
 {
-	d_cursor_info *p;
+	struct d_cursor_info *p;
 
 	p = &get_super_private(super)->d_info;
 
@@ -148,7 +150,7 @@ int reiser4_init_super_d_info(struct sup
  */
 void reiser4_done_super_d_info(struct super_block *super)
 {
-	d_cursor_info *d_info;
+	struct d_cursor_info *d_info;
 	dir_cursor *cursor, *next;
 
 	d_info = &get_super_private(super)->d_info;
@@ -233,7 +235,7 @@ enum cursor_action {
 /*
  * return d_cursor data for the file system @inode is in.
  */
-static inline d_cursor_info *d_info(struct inode *inode)
+static inline struct d_cursor_info *d_info(struct inode *inode)
 {
 	return &get_super_private(inode->i_sb)->d_info;
 }
@@ -241,7 +243,8 @@ static inline d_cursor_info *d_info(stru
 /*
  * lookup d_cursor in the per-super-block radix tree.
  */
-static inline dir_cursor *lookup(d_cursor_info * info, unsigned long index)
+static inline dir_cursor *lookup(struct d_cursor_info * info,
+				 unsigned long index)
 {
 	return (dir_cursor *) radix_tree_lookup(&info->tree, index);
 }
@@ -327,7 +330,7 @@ static int insert_cursor(dir_cursor *cur
 	if (fsdata != NULL) {
 		result = radix_tree_preload(reiser4_ctx_gfp_mask_get());
 		if (result == 0) {
-			d_cursor_info *info;
+			struct d_cursor_info *info;
 			oid_t oid;
 
 			info = d_info(inode);
@@ -381,7 +384,7 @@ static void process_cursors(struct inode
 	dir_cursor *start;
 	struct list_head *head;
 	reiser4_context *ctx;
-	d_cursor_info *info;
+	struct d_cursor_info *info;
 
 	/* this can be called by
 	 *
@@ -547,7 +550,7 @@ int reiser4_attach_fsdata(struct file *f
 			result = RETERR(-ENOMEM);
 	} else {
 		/* try to find existing cursor */
-		d_cursor_key key;
+		struct d_cursor_key key;
 
 		key.cid = pos >> CID_SHIFT;
 		key.oid = get_inode_oid(inode);
@@ -606,11 +609,11 @@ static struct kmem_cache *dentry_fsdata_
 int reiser4_init_dentry_fsdata(void)
 {
 	dentry_fsdata_cache = kmem_cache_create("dentry_fsdata",
-						sizeof(reiser4_dentry_fsdata),
-						0,
-						SLAB_HWCACHE_ALIGN |
-						SLAB_RECLAIM_ACCOUNT, NULL,
-						NULL);
+					   sizeof(struct reiser4_dentry_fsdata),
+					   0,
+					   SLAB_HWCACHE_ALIGN |
+					   SLAB_RECLAIM_ACCOUNT, NULL,
+					   NULL);
 	if (dentry_fsdata_cache == NULL)
 		return RETERR(-ENOMEM);
 	return 0;
@@ -633,7 +636,7 @@ void reiser4_done_dentry_fsdata(void)
  * Allocates if necessary and returns per-dentry data that we attach to each
  * dentry.
  */
-reiser4_dentry_fsdata *reiser4_get_dentry_fsdata(struct dentry *dentry)
+struct reiser4_dentry_fsdata *reiser4_get_dentry_fsdata(struct dentry *dentry)
 {
 	assert("nikita-1365", dentry != NULL);
 
@@ -642,7 +645,8 @@ reiser4_dentry_fsdata *reiser4_get_dentr
 						    reiser4_ctx_gfp_mask_get());
 		if (dentry->d_fsdata == NULL)
 			return ERR_PTR(RETERR(-ENOMEM));
-		memset(dentry->d_fsdata, 0, sizeof(reiser4_dentry_fsdata));
+		memset(dentry->d_fsdata, 0,
+		       sizeof(struct reiser4_dentry_fsdata));
 	}
 	return dentry->d_fsdata;
 }
diff -puN fs/reiser4/fsdata.h~reiser4-remove-typedefs fs/reiser4/fsdata.h
--- a/fs/reiser4/fsdata.h~reiser4-remove-typedefs
+++ a/fs/reiser4/fsdata.h
@@ -29,31 +29,31 @@
  */
 
 /* logical position within directory */
-typedef struct {
+struct dir_pos {
 	/* key of directory entry (actually, part of a key sufficient to
 	   identify directory entry)  */
 	de_id dir_entry_key;
 	/* ordinal number of directory entry among all entries with the same
 	   key. (Starting from 0.) */
 	unsigned pos;
-} dir_pos;
+};
 
-typedef struct {
+struct readdir_pos {
 	/* f_pos corresponding to this readdir position */
 	__u64 fpos;
 	/* logical position within directory */
-	dir_pos position;
+	struct dir_pos position;
 	/* logical number of directory entry within
 	   directory  */
 	__u64 entry_no;
-} readdir_pos;
+};
 
 /*
  * this is used to speed up lookups for directory entry: on initial call to
  * ->lookup() seal and coord of directory entry (if found, that is) are stored
  * in struct dentry and reused later to avoid tree traversals.
  */
-typedef struct de_location {
+struct de_location {
 	/* seal covering directory entry */
 	seal_t entry_seal;
 	/* coord of directory entry */
@@ -61,7 +61,7 @@ typedef struct de_location {
 	/* ordinal number of directory entry among all entries with the same
 	   key. (Starting from 0.) */
 	int pos;
-} de_location;
+};
 
 /**
  * reiser4_dentry_fsdata - reiser4-specific data attached to dentries
@@ -71,20 +71,20 @@ typedef struct de_location {
  * Currently it only contains cached location (hint) of directory entry, but
  * it is expected that other information will be accumulated here.
  */
-typedef struct reiser4_dentry_fsdata {
+struct reiser4_dentry_fsdata {
 	/*
 	 * here will go fields filled by ->lookup() to speedup next
 	 * create/unlink, like blocknr of znode with stat-data, or key of
 	 * stat-data.
 	 */
-	de_location dec;
+	struct de_location dec;
 	int stateless;		/* created through reiser4_decode_fh, needs special
 				 * treatment in readdir. */
-} reiser4_dentry_fsdata;
+};
 
 extern int reiser4_init_dentry_fsdata(void);
 extern void reiser4_done_dentry_fsdata(void);
-extern reiser4_dentry_fsdata *reiser4_get_dentry_fsdata(struct dentry *);
+extern struct reiser4_dentry_fsdata *reiser4_get_dentry_fsdata(struct dentry *);
 extern void reiser4_free_dentry_fsdata(struct dentry *dentry);
 
 /**
@@ -109,7 +109,7 @@ typedef struct reiser4_file_fsdata {
 		 * position in directory. It is updated each time directory is
 		 * modified
 		 */
-		readdir_pos readdir;
+		struct readdir_pos readdir;
 		/* head of this list is reiser4_inode->lists.readdir_list */
 		struct list_head linkage;
 	} dir;
@@ -131,10 +131,10 @@ extern void reiser4_free_file_fsdata(str
  * used to address problem reiser4 has with readdir accesses via NFS. See
  * plugin/file_ops_readdir.c for more details.
  */
-typedef struct {
+struct d_cursor_key{
 	__u16 cid;
 	__u64 oid;
-} d_cursor_key;
+};
 
 /*
  * define structures d_cursor_hash_table d_cursor_hash_link which are used to
@@ -143,8 +143,6 @@ typedef struct {
 typedef struct dir_cursor dir_cursor;
 TYPE_SAFE_HASH_DECLARE(d_cursor, dir_cursor);
 
-typedef struct d_cursor_info d_cursor_info;
-
 struct dir_cursor {
 	int ref;
 	reiser4_file_fsdata *fsdata;
@@ -157,8 +155,8 @@ struct dir_cursor {
 	 * cursors if there are more than one cursor of the same objectid
 	 */
 	struct list_head list;
-	d_cursor_key key;
-	d_cursor_info *info;
+	struct d_cursor_key key;
+	struct d_cursor_info *info;
 	/* list of unused cursors */
 	struct list_head alist;
 };
diff -puN fs/reiser4/init_super.c~reiser4-remove-typedefs fs/reiser4/init_super.c
--- a/fs/reiser4/init_super.c~reiser4-remove-typedefs
+++ a/fs/reiser4/init_super.c
@@ -85,13 +85,15 @@ typedef enum {
 	OPT_ONEOF,
 } opt_type_t;
 
-typedef struct opt_bitmask_bit {
+#if 0
+struct opt_bitmask_bit {
 	const char *bit_name;
 	int bit_nr;
-} opt_bitmask_bit;
+};
+#endif
 
 /* description of option parseable by parse_option() */
-typedef struct opt_desc {
+struct opt_desc {
 	/* option name.
 
 	   parsed portion of string has a form "name=value".
@@ -124,10 +126,10 @@ typedef struct opt_desc {
 		struct {
 			void *addr;
 			int nr_bits;
-			opt_bitmask_bit *bits;
+			//struct opt_bitmask_bit *bits;
 		} bitmask;
 	} u;
-} opt_desc_t;
+};
 
 /**
  * parse_option - parse one option
@@ -141,7 +143,7 @@ typedef struct opt_desc {
  * +-- opt_string
  * Figures out option type and handles option correspondingly.
  */
-static int parse_option(char *opt_string, opt_desc_t *opt)
+static int parse_option(char *opt_string, struct opt_desc *opt)
 {
 	char *val_start;
 	int result;
@@ -226,7 +228,7 @@ static int parse_option(char *opt_string
  *
  * Parses comma separated list of reiser4 mount options.
  */
-static int parse_options(char *opt_string, opt_desc_t *opts, int nr_opts)
+static int parse_options(char *opt_string, struct opt_desc *opts, int nr_opts)
 {
 	int result;
 
@@ -302,7 +304,7 @@ static int parse_options(char *opt_strin
 int reiser4_init_super_data(struct super_block *super, char *opt_string)
 {
 	int result;
-	opt_desc_t *opts, *p;
+	struct opt_desc *opts, *p;
 	reiser4_super_info_data *sbinfo = get_super_private(super);
 
 	/* initialize super, export, dentry operations */
@@ -343,7 +345,7 @@ int reiser4_init_super_data(struct super
 	sbinfo->ra_params.flags = 0;
 
 	/* allocate memory for structure describing reiser4 mount options */
-	opts = kmalloc(sizeof(opt_desc_t) * MAX_NR_OPTIONS,
+	opts = kmalloc(sizeof(struct opt_desc) * MAX_NR_OPTIONS,
 		       reiser4_ctx_gfp_mask_get());
 	if (opts == NULL)
 		return RETERR(-ENOMEM);
@@ -361,9 +363,9 @@ int reiser4_init_super_data(struct super
 
 #define PUSH_OPT(...)				\
 do {						\
-	 opt_desc_t o = __VA_ARGS__;		\
-	 OPT_ARRAY_CHECK;			\
-	 *p ++ = o;				\
+	struct opt_desc o = __VA_ARGS__;	\
+	OPT_ARRAY_CHECK;			\
+	*p ++ = o;				\
 } while (0)
 
 #define PUSH_SB_FIELD_OPT(field, format) PUSH_OPT(SB_FIELD_OPT(field, format))
diff -puN fs/reiser4/inode.h~reiser4-remove-typedefs fs/reiser4/inode.h
--- a/fs/reiser4/inode.h~reiser4-remove-typedefs
+++ a/fs/reiser4/inode.h
@@ -131,9 +131,9 @@ struct reiser4_inode {
 	unsigned long flags;
 	union {
 		/* fields specific to unix_file plugin */
-		unix_file_info_t unix_file_info;
-		/* fields specific to cryptcompress plugin */
-		cryptcompress_info_t cryptcompress_info;
+		struct unix_file_info unix_file_info;
+		/* fields specific to cryptcompress file plugin */
+		struct cryptcompress_info cryptcompress_info;
 	} file_plugin_data;
 
 	/* this semaphore is to serialize readers and writers of @pset->file
@@ -159,26 +159,26 @@ void loading_init_once(reiser4_inode *);
 void loading_alloc(reiser4_inode *);
 void loading_destroy(reiser4_inode *);
 
-typedef struct reiser4_inode_object {
+struct reiser4_inode_object {
 	/* private part */
 	reiser4_inode p;
 	/* generic fields not specific to reiser4, but used by VFS */
 	struct inode vfs_inode;
-} reiser4_inode_object;
+};
 
 /* return pointer to the reiser4 specific portion of @inode */
 static inline reiser4_inode *reiser4_inode_data(const struct inode *inode
 						/* inode queried */ )
 {
 	assert("nikita-254", inode != NULL);
-	return &container_of(inode, reiser4_inode_object, vfs_inode)->p;
+	return &container_of(inode, struct reiser4_inode_object, vfs_inode)->p;
 }
 
 static inline struct inode *inode_by_reiser4_inode(const reiser4_inode *
 						   r4_inode /* inode queried */
 						   )
 {
-	return &container_of(r4_inode, reiser4_inode_object, p)->vfs_inode;
+	return &container_of(r4_inode, struct reiser4_inode_object, p)->vfs_inode;
 }
 
 /*
@@ -251,10 +251,10 @@ static inline void set_inode_ordering(co
 #endif
 
 /* return inode in which @uf_info is embedded */
-static inline struct inode *unix_file_info_to_inode(const unix_file_info_t *
-						    uf_info)
+static inline struct inode *
+unix_file_info_to_inode(const struct unix_file_info * uf_info)
 {
-	return &container_of(uf_info, reiser4_inode_object,
+	return &container_of(uf_info, struct reiser4_inode_object,
 			     p.file_plugin_data.unix_file_info)->vfs_inode;
 }
 
diff -puN fs/reiser4/jnode.c~reiser4-remove-typedefs fs/reiser4/jnode.c
--- a/fs/reiser4/jnode.c~reiser4-remove-typedefs
+++ a/fs/reiser4/jnode.c
@@ -142,7 +142,8 @@ static inline int jnode_is_parsed(jnode 
 /* hash table support */
 
 /* compare two jnode keys for equality. Used by hash-table macros */
-static inline int jnode_key_eq(const jnode_key_t * k1, const jnode_key_t * k2)
+static inline int jnode_key_eq(const struct jnode_key * k1,
+			       const struct jnode_key * k2)
 {
 	assert("nikita-2350", k1 != NULL);
 	assert("nikita-2351", k2 != NULL);
@@ -151,8 +152,8 @@ static inline int jnode_key_eq(const jno
 }
 
 /* Hash jnode by its key (inode plus offset). Used by hash-table macros */
-static inline __u32
-jnode_key_hashfn(j_hash_table * table, const jnode_key_t * key)
+static inline __u32 jnode_key_hashfn(j_hash_table * table,
+				     const struct jnode_key * key)
 {
 	assert("nikita-2352", key != NULL);
 	assert("nikita-3346", IS_POW(table->_buckets));
@@ -164,8 +165,8 @@ jnode_key_hashfn(j_hash_table * table, c
 /* The hash table definition */
 #define KMALLOC(size) reiser4_vmalloc(size)
 #define KFREE(ptr, size) vfree(ptr)
-TYPE_SAFE_HASH_DEFINE(j, jnode, jnode_key_t, key.j, link.j, jnode_key_hashfn,
-		      jnode_key_eq);
+TYPE_SAFE_HASH_DEFINE(j, jnode, struct jnode_key, key.j, link.j,
+		      jnode_key_hashfn, jnode_key_eq);
 #undef KFREE
 #undef KMALLOC
 
@@ -370,7 +371,7 @@ static jnode *jnew_unformatted(void)
 /* look for jnode with given mapping and offset within hash table */
 jnode *jlookup(reiser4_tree * tree, oid_t objectid, unsigned long index)
 {
-	jnode_key_t jkey;
+	struct jnode_key jkey;
 	jnode *node;
 
 	assert("nikita-2353", tree != NULL);
diff -puN fs/reiser4/jnode.h~reiser4-remove-typedefs fs/reiser4/jnode.h
--- a/fs/reiser4/jnode.h~reiser4-remove-typedefs
+++ a/fs/reiser4/jnode.h
@@ -32,11 +32,11 @@ TYPE_SAFE_HASH_DECLARE(j, jnode);
 /* declare hash table of znodes */
 TYPE_SAFE_HASH_DECLARE(z, znode);
 
-typedef struct {
+struct jnode_key {
 	__u64 objectid;
 	unsigned long index;
 	struct address_space *mapping;
-} jnode_key_t;
+};
 
 /*
    Jnode is the "base class" of other nodes in reiser4. It is also happens to
@@ -126,7 +126,7 @@ struct jnode {
 		/* znodes are hashed by block number */
 		reiser4_block_nr z;
 		/* unformatted nodes are hashed by mapping plus offset */
-		jnode_key_t j;
+		struct jnode_key j;
 	} key;
 
 	/* THIRD CACHE LINE */
diff -puN fs/reiser4/lock.c~reiser4-remove-typedefs fs/reiser4/lock.c
--- a/fs/reiser4/lock.c~reiser4-remove-typedefs
+++ a/fs/reiser4/lock.c
@@ -313,7 +313,7 @@ static inline void unlink_object(lock_ha
 /* Actually locks an object knowing that we are able to do this */
 static void lock_object(lock_stack * owner)
 {
-	lock_request *request;
+	struct lock_request *request;
 	znode *node;
 
 	request = &owner->request;
diff -puN fs/reiser4/lock.h~reiser4-remove-typedefs fs/reiser4/lock.h
--- a/fs/reiser4/lock.h~reiser4-remove-typedefs
+++ a/fs/reiser4/lock.h
@@ -95,7 +95,7 @@ struct lock_handle {
 	struct list_head owners_link;
 };
 
-typedef struct lock_request {
+struct lock_request {
 	/* A pointer to uninitialized link object */
 	lock_handle *handle;
 	/* A pointer to the object we want to lock */
@@ -104,7 +104,7 @@ typedef struct lock_request {
 	znode_lock_mode mode;
 	/* how dispatch_lock_requests() returns lock request result code */
 	int ret_code;
-} lock_request;
+};
 
 /* A lock stack structure for accumulating locks owned by a process */
 struct lock_stack {
@@ -130,7 +130,7 @@ struct lock_stack {
 	   This is only accessed by the current thread and thus requires no
 	   locking.
 	 */
-	lock_request request;
+	struct lock_request request;
 	/* the following two fields are the lock stack's
 	 * synchronization object to use with the standard linux/wait.h
 	 * interface. See reiser4_go_to_sleep and __reiser4_wake_up for
diff -puN fs/reiser4/plugin/cluster.h~reiser4-remove-typedefs fs/reiser4/plugin/cluster.h
--- a/fs/reiser4/plugin/cluster.h~reiser4-remove-typedefs
+++ a/fs/reiser4/plugin/cluster.h
@@ -155,8 +155,8 @@ static inline unsigned cnt_to_clcnt(loff
 	return off_to_cloff(cnt, inode);
 }
 
-static inline unsigned
-fsize_to_count(reiser4_cluster_t * clust, struct inode *inode)
+static inline unsigned fsize_to_count(struct cluster_handle * clust,
+				      struct inode * inode)
 {
 	assert("edward-288", clust != NULL);
 	assert("edward-289", inode != NULL);
@@ -164,34 +164,36 @@ fsize_to_count(reiser4_cluster_t * clust
 	return cnt_to_clcnt(inode->i_size, clust->index, inode);
 }
 
-static inline int
-cluster_is_complete(reiser4_cluster_t * clust, struct inode * inode)
+static inline int cluster_is_complete(struct cluster_handle * clust,
+				      struct inode * inode)
 {
 	return clust->tc.lsize == inode_cluster_size(inode);
 }
 
-static inline void reiser4_slide_init(reiser4_slide_t * win)
+static inline void reiser4_slide_init(struct reiser4_slide * win)
 {
 	assert("edward-1084", win != NULL);
 	memset(win, 0, sizeof *win);
 }
 
 static inline tfm_action
-cluster_get_tfm_act(tfm_cluster_t * tc)
+cluster_get_tfm_act(struct tfm_cluster * tc)
 {
 	assert("edward-1356", tc != NULL);
 	return tc->act;
 }
 
 static inline void
-cluster_set_tfm_act(tfm_cluster_t * tc, tfm_action act)
+cluster_set_tfm_act(struct tfm_cluster * tc, tfm_action act)
 {
 	assert("edward-1356", tc != NULL);
 	tc->act = act;
 }
 
-static inline void
-cluster_init_act (reiser4_cluster_t * clust, tfm_action act, reiser4_slide_t * window){
+static inline void cluster_init_act(struct cluster_handle * clust,
+				    tfm_action act,
+				    struct reiser4_slide * window)
+{
 	assert("edward-84", clust != NULL);
 	memset(clust, 0, sizeof *clust);
 	cluster_set_tfm_act(&clust->tc, act);
@@ -199,14 +201,14 @@ cluster_init_act (reiser4_cluster_t * cl
 	clust->win = window;
 }
 
-static inline void
-cluster_init_read(reiser4_cluster_t * clust, reiser4_slide_t * window)
+static inline void cluster_init_read(struct cluster_handle * clust,
+				     struct reiser4_slide * window)
 {
 	cluster_init_act (clust, TFMA_READ, window);
 }
 
-static inline void
-cluster_init_write(reiser4_cluster_t * clust, reiser4_slide_t * window)
+static inline void cluster_init_write(struct cluster_handle * clust,
+				      struct reiser4_slide * window)
 {
 	cluster_init_act (clust, TFMA_WRITE, window);
 }
@@ -264,34 +266,34 @@ static inline void coord_set_between_clu
 #endif
 }
 
-int reiser4_inflate_cluster(reiser4_cluster_t *, struct inode *);
-int find_disk_cluster(reiser4_cluster_t *, struct inode *, int read,
+int reiser4_inflate_cluster(struct cluster_handle *, struct inode *);
+int find_disk_cluster(struct cluster_handle *, struct inode *, int read,
 		      znode_lock_mode mode);
-int flush_cluster_pages(reiser4_cluster_t *, jnode *, struct inode *);
-int reiser4_deflate_cluster(reiser4_cluster_t *, struct inode *);
+int flush_cluster_pages(struct cluster_handle *, jnode *, struct inode *);
+int reiser4_deflate_cluster(struct cluster_handle *, struct inode *);
 void truncate_page_cluster_cryptcompress(struct inode *inode, cloff_t start,
 					 int even_cows);
-void invalidate_hint_cluster(reiser4_cluster_t * clust);
-void put_hint_cluster(reiser4_cluster_t * clust, struct inode *inode,
+void invalidate_hint_cluster(struct cluster_handle * clust);
+void put_hint_cluster(struct cluster_handle * clust, struct inode *inode,
 		      znode_lock_mode mode);
-int get_disk_cluster_locked(reiser4_cluster_t * clust, struct inode *inode,
+int get_disk_cluster_locked(struct cluster_handle * clust, struct inode * inode,
 			    znode_lock_mode lock_mode);
-void reset_cluster_params(reiser4_cluster_t * clust);
-int set_cluster_by_page(reiser4_cluster_t * clust, struct page * page,
+void reset_cluster_params(struct cluster_handle * clust);
+int set_cluster_by_page(struct cluster_handle * clust, struct page * page,
 			int count);
-int prepare_page_cluster(struct inode *inode, reiser4_cluster_t * clust,
+int prepare_page_cluster(struct inode *inode, struct cluster_handle * clust,
 			 int capture);
-void reiser4_release_cluster_pages(reiser4_cluster_t *);
-void put_cluster_handle(reiser4_cluster_t * clust);
-int grab_tfm_stream(struct inode *inode, tfm_cluster_t * tc, tfm_stream_id id);
-int tfm_cluster_is_uptodate(tfm_cluster_t * tc);
-void tfm_cluster_set_uptodate(tfm_cluster_t * tc);
-void tfm_cluster_clr_uptodate(tfm_cluster_t * tc);
+void reiser4_release_cluster_pages(struct cluster_handle *);
+void put_cluster_handle(struct cluster_handle * clust);
+int grab_tfm_stream(struct inode *inode, struct tfm_cluster * tc, tfm_stream_id id);
+int tfm_cluster_is_uptodate(struct tfm_cluster * tc);
+void tfm_cluster_set_uptodate(struct tfm_cluster * tc);
+void tfm_cluster_clr_uptodate(struct tfm_cluster * tc);
 
 /* move cluster handle to the target position
    specified by the page of index @pgidx
 */
-static inline void move_cluster_forward(reiser4_cluster_t * clust,
+static inline void move_cluster_forward(struct cluster_handle * clust,
 					struct inode *inode,
 					pgoff_t pgidx)
 {
@@ -311,8 +313,8 @@ static inline void move_cluster_forward(
 	clust->index_valid = 1;
 }
 
-static inline int
-alloc_clust_pages(reiser4_cluster_t * clust, struct inode *inode)
+static inline int alloc_clust_pages(struct cluster_handle * clust,
+				    struct inode *inode)
 {
 	assert("edward-791", clust != NULL);
 	assert("edward-792", inode != NULL);
@@ -324,7 +326,7 @@ alloc_clust_pages(reiser4_cluster_t * cl
 	return 0;
 }
 
-static inline void free_clust_pages(reiser4_cluster_t * clust)
+static inline void free_clust_pages(struct cluster_handle * clust)
 {
 	kfree(clust->pages);
 }
diff -puN fs/reiser4/plugin/compress/compress.h~reiser4-remove-typedefs fs/reiser4/plugin/compress/compress.h
--- a/fs/reiser4/plugin/compress/compress.h~reiser4-remove-typedefs
+++ a/fs/reiser4/plugin/compress/compress.h
@@ -4,22 +4,27 @@
 #include <linux/types.h>
 #include <linux/string.h>
 
+/* transform direction */
 typedef enum {
-	TFMA_READ,
-	TFMA_WRITE,
+	TFMA_READ,   /* decrypt, decompress */
+	TFMA_WRITE,  /* encrypt, compress */
 	TFMA_LAST
 } tfm_action;
 
-/* builtin compression plugins */
-
+/* supported compression algorithms */
 typedef enum {
 	LZO1_COMPRESSION_ID,
 	GZIP1_COMPRESSION_ID,
 	LAST_COMPRESSION_ID,
 } reiser4_compression_id;
 
+/* the same as pgoff, but units are page clusters */
 typedef unsigned long cloff_t;
+
+/* working data of a (de)compression algorithm */
 typedef void *coa_t;
+
+/* table for all supported (de)compression algorithms */
 typedef coa_t coa_set[LAST_COMPRESSION_ID][TFMA_LAST];
 
 __u32 reiser4_adler32(char *data, __u32 len);
diff -puN fs/reiser4/plugin/compress/compress_mode.c~reiser4-remove-typedefs fs/reiser4/plugin/compress/compress_mode.c
--- a/fs/reiser4/plugin/compress/compress_mode.c~reiser4-remove-typedefs
+++ a/fs/reiser4/plugin/compress/compress_mode.c
@@ -27,7 +27,7 @@ static int discard_hook_ultim(struct ino
 
 static int discard_hook_lattd(struct inode *inode, cloff_t index)
 {
-	cryptcompress_info_t * info = cryptcompress_inode_data(inode);
+	struct cryptcompress_info * info = cryptcompress_inode_data(inode);
 
 	assert("edward-1462",
 	       get_lattice_factor(info) >= MIN_LATTICE_FACTOR &&
diff -puN fs/reiser4/plugin/crypto/cipher.h~reiser4-remove-typedefs fs/reiser4/plugin/crypto/cipher.h
--- a/fs/reiser4/plugin/crypto/cipher.h~reiser4-remove-typedefs
+++ a/fs/reiser4/plugin/crypto/cipher.h
@@ -9,12 +9,12 @@
 #include <linux/crypto.h>
 
 /* key info imported from user space */
-typedef struct crypto_data {
+struct reiser4_crypto_data {
 	int keysize;    /* uninstantiated key size */
 	__u8 * key;     /* uninstantiated key */
 	int keyid_size; /* size of passphrase */
 	__u8 * keyid;   /* passphrase */
-} crypto_data_t;
+};
 
 /* This object contains all needed infrastructure to implement
    cipher transform. This is operated (allocating, inheriting,
@@ -23,7 +23,7 @@ typedef struct crypto_data {
    This info can be allocated in two cases:
    1. importing a key from user space.
    2. reading inode from disk */
-typedef struct crypto_stat {
+struct reiser4_crypto_info {
 	struct inode * host;
 	struct crypto_hash      * digest;
 	struct crypto_blkcipher * cipher;
@@ -39,7 +39,7 @@ typedef struct crypto_stat {
 				      to be stored in disk stat-data */
 	int keyload_count;         /* number of the objects which has this
 				      crypto-stat attached */
-} crypto_stat_t;
+};
 
 #endif /* __FS_REISER4_CRYPT_H__ */
 
diff -puN fs/reiser4/plugin/dir_plugin_common.c~reiser4-remove-typedefs fs/reiser4/plugin/dir_plugin_common.c
--- a/fs/reiser4/plugin/dir_plugin_common.c~reiser4-remove-typedefs
+++ a/fs/reiser4/plugin/dir_plugin_common.c
@@ -129,7 +129,7 @@ int reiser4_add_entry_common(struct inod
 	int result;
 	coord_t *coord;
 	lock_handle lh;
-	reiser4_dentry_fsdata *fsdata;
+	struct reiser4_dentry_fsdata *fsdata;
 	reiser4_block_nr reserve;
 
 	assert("nikita-1114", object != NULL);
@@ -231,7 +231,7 @@ int reiser4_rem_entry_common(struct inod
 	int result;
 	coord_t *coord;
 	lock_handle lh;
-	reiser4_dentry_fsdata *fsdata;
+	struct reiser4_dentry_fsdata *fsdata;
 	__u64 tograb;
 
 	assert("nikita-1124", dir != NULL);
@@ -482,7 +482,7 @@ int reiser4_lookup_name(struct inode *pa
 	const char *name;
 	int len;
 	reiser4_dir_entry_desc entry;
-	reiser4_dentry_fsdata *fsdata;
+	struct reiser4_dentry_fsdata *fsdata;
 
 	assert("nikita-1247", parent != NULL);
 	assert("nikita-1248", dentry != NULL);
@@ -654,7 +654,7 @@ check_entry(const struct inode *dir, coo
 /*
  * argument package used by entry_actor to scan entries with identical keys.
  */
-typedef struct entry_actor_args {
+struct entry_actor_args {
 	/* name we are looking for */
 	const char *name;
 	/* key of directory entry. entry_actor() scans through sequence of
@@ -678,7 +678,7 @@ typedef struct entry_actor_args {
 	lock_handle last_lh;
 	/* inode of directory */
 	const struct inode *inode;
-} entry_actor_args;
+};
 
 /* Function called by reiser4_find_entry() to look for given name
    in the directory. */
@@ -688,7 +688,7 @@ static int entry_actor(reiser4_tree * tr
 		       void *entry_actor_arg /* argument to scan */ )
 {
 	reiser4_key unit_key;
-	entry_actor_args *args;
+	struct entry_actor_args *args;
 
 	assert("nikita-1131", tree != NULL);
 	assert("nikita-1132", coord != NULL);
@@ -757,8 +757,8 @@ int reiser4_find_entry(struct inode *dir
 	coord_t *coord;
 	int result;
 	__u32 flags;
-	de_location *dec;
-	reiser4_dentry_fsdata *fsdata;
+	struct de_location *dec;
+	struct reiser4_dentry_fsdata *fsdata;
 
 	assert("nikita-1130", lh != NULL);
 	assert("nikita-1128", dir != NULL);
@@ -803,7 +803,7 @@ int reiser4_find_entry(struct inode *dir
 				       FIND_EXACT, LEAF_LEVEL, LEAF_LEVEL,
 				       flags, NULL /*ra_info */ );
 	if (result == CBK_COORD_FOUND) {
-		entry_actor_args arg;
+		struct entry_actor_args arg;
 
 		/* fast path: no hash collisions */
 		result = check_entry(dir, coord, name);
diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-remove-typedefs fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-remove-typedefs
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -21,7 +21,7 @@
 #include <linux/random.h>
 
 /* get cryptcompress specific portion of inode */
-cryptcompress_info_t *cryptcompress_inode_data(const struct inode *inode)
+struct cryptcompress_info *cryptcompress_inode_data(const struct inode *inode)
 {
 	return &reiser4_inode_data(inode)->file_plugin_data.cryptcompress_info;
 }
@@ -31,7 +31,7 @@ void init_inode_data_cryptcompress(struc
 				   reiser4_object_create_data * crd,
 				   int create)
 {
-	cryptcompress_info_t *data;
+	struct cryptcompress_info *data;
 
 	data = cryptcompress_inode_data(inode);
 	assert("edward-685", data != NULL);
@@ -58,22 +58,23 @@ int cryptcompress_inode_ok(struct inode 
    which is called when opening/creating a cryptcompress file */
 
 /* get/set cipher key info */
-crypto_stat_t * inode_crypto_stat (struct inode * inode)
+struct reiser4_crypto_info * inode_crypto_info (struct inode * inode)
 {
 	assert("edward-90", inode != NULL);
 	assert("edward-91", reiser4_inode_data(inode) != NULL);
 	return cryptcompress_inode_data(inode)->crypt;
 }
 
-static void set_inode_crypto_stat (struct inode * inode, crypto_stat_t * stat)
+static void set_inode_crypto_info (struct inode * inode,
+				   struct reiser4_crypto_info * info)
 {
-	cryptcompress_inode_data(inode)->crypt = stat;
+	cryptcompress_inode_data(inode)->crypt = info;
 }
 
 /* allocate a cipher key info */
-crypto_stat_t * reiser4_alloc_crypto_stat (struct inode * inode)
+struct reiser4_crypto_info * reiser4_alloc_crypto_info (struct inode * inode)
 {
-	crypto_stat_t * info;
+	struct reiser4_crypto_info * info;
 	int fipsize;
 
 	info = kmalloc(sizeof(*info), reiser4_ctx_gfp_mask_get());
@@ -93,7 +94,7 @@ crypto_stat_t * reiser4_alloc_crypto_sta
 #if 0
 /* allocate/free low-level info for cipher and digest
    transforms */
-static int alloc_crypto_tfms(crypto_stat_t * info)
+static int alloc_crypto_tfms(struct reiser4_crypto_info * info)
 {
 	struct crypto_blkcipher * ctfm = NULL;
 	struct crypto_hash      * dtfm = NULL;
@@ -131,7 +132,7 @@ static int alloc_crypto_tfms(crypto_stat
 #endif
 
 static void
-free_crypto_tfms(crypto_stat_t * info)
+free_crypto_tfms(struct reiser4_crypto_info * info)
 {
 	assert("edward-1366", info != NULL);
 	if (!info_get_cipher(info)) {
@@ -147,7 +148,8 @@ free_crypto_tfms(crypto_stat_t * info)
 
 #if 0
 /* create a key fingerprint for disk stat-data */
-static int create_keyid (crypto_stat_t * info, crypto_data_t * data)
+static int create_keyid (struct reiser4_crypto_info * info,
+			 struct reiser4_crypto_data * data)
 {
 	int ret = -ENOMEM;
 	size_t blk, pad;
@@ -209,7 +211,7 @@ static int create_keyid (crypto_stat_t *
 }
 #endif
 
-static void destroy_keyid(crypto_stat_t * info)
+static void destroy_keyid(struct reiser4_crypto_info * info)
 {
 	assert("edward-1370", info != NULL);
 	assert("edward-1371", info->keyid != NULL);
@@ -217,9 +219,9 @@ static void destroy_keyid(crypto_stat_t 
 	return;
 }
 
-static void __free_crypto_stat (struct inode * inode)
+static void __free_crypto_info (struct inode * inode)
 {
-	crypto_stat_t * info = inode_crypto_stat(inode);
+	struct reiser4_crypto_info * info = inode_crypto_info(inode);
 	assert("edward-1372", info != NULL);
 
 	free_crypto_tfms(info);
@@ -228,7 +230,7 @@ static void __free_crypto_stat (struct i
 }
 
 #if 0
-static void instantiate_crypto_stat(crypto_stat_t * info)
+static void instantiate_crypto_info(struct reiser4_crypto_info * info)
 {
 	assert("edward-1373", info != NULL);
 	assert("edward-1374", info->inst == 0);
@@ -236,13 +238,13 @@ static void instantiate_crypto_stat(cryp
 }
 #endif
 
-static void uninstantiate_crypto_stat(crypto_stat_t * info)
+static void uninstantiate_crypto_info(struct reiser4_crypto_info * info)
 {
 	assert("edward-1375", info != NULL);
 	info->inst = 0;
 }
 
-static int crypto_stat_instantiated(crypto_stat_t * info)
+static int is_crypto_info_instantiated(struct reiser4_crypto_info * info)
 {
 	return info->inst;
 }
@@ -250,14 +252,14 @@ static int crypto_stat_instantiated(cryp
 static int inode_has_cipher_key(struct inode * inode)
 {
 	assert("edward-1376", inode != NULL);
-	return inode_crypto_stat(inode) &&
-		crypto_stat_instantiated(inode_crypto_stat(inode));
+	return inode_crypto_info(inode) &&
+		is_crypto_info_instantiated(inode_crypto_info(inode));
 }
 
-static void free_crypto_stat (struct inode * inode)
+static void free_crypto_info (struct inode * inode)
 {
-	uninstantiate_crypto_stat(inode_crypto_stat(inode));
-	__free_crypto_stat(inode);
+	uninstantiate_crypto_info(inode_crypto_info(inode));
+	__free_crypto_info(inode);
 }
 
 static int need_cipher(struct inode * inode)
@@ -266,18 +268,15 @@ static int need_cipher(struct inode * in
 		cipher_plugin_by_id(NONE_CIPHER_ID);
 }
 
-/* Create a crypto-stat and attach result to the @object.
-   If success is returned, then low-level cipher info contains
-   an instantiated key */
+/* Parse @data which contains a (uninstantiated) cipher key imported
+   from user space, create a low-level cipher info and attach it to
+   the @object. If success, then info contains an instantiated key */
 #if 0
-crypto_stat_t *
-create_crypto_stat(struct inode * object,
-		   crypto_data_t * data /* this contains a (uninstantiated)
-					   cipher key imported from user
-					   space */)
+struct reiser4_crypto_info * create_crypto_info(struct inode * object,
+				  struct reiser4_crypto_data * data)
 {
 	int ret;
-	crypto_stat_t * info;
+	struct reiser4_crypto_info * info;
 
 	assert("edward-1377", data != NULL);
 	assert("edward-1378", need_cipher(object));
@@ -286,7 +285,7 @@ create_crypto_stat(struct inode * object
 	    file_plugin_by_id(DIRECTORY_FILE_PLUGIN_ID))
 		return ERR_PTR(-EINVAL);
 
-	info = reiser4_alloc_crypto_stat(object);
+	info = reiser4_alloc_crypto_info(object);
 	if (IS_ERR(info))
 		return info;
 	ret = alloc_crypto_tfms(info);
@@ -306,47 +305,48 @@ create_crypto_stat(struct inode * object
 	ret = create_keyid(info, data);
 	if (ret)
 		goto err;
-	instantiate_crypto_stat(info);
+	instantiate_crypto_info(info);
 	return info;
  err:
-	__free_crypto_stat(object);
+	__free_crypto_info(object);
  	return ERR_PTR(ret);
 }
 #endif
 
 /* increment/decrement a load counter when
    attaching/detaching the crypto-stat to any object */
-static void load_crypto_stat(crypto_stat_t * info)
+static void load_crypto_info(struct reiser4_crypto_info * info)
 {
 	assert("edward-1380", info != NULL);
 	inc_keyload_count(info);
 }
 
-static void unload_crypto_stat(struct inode * inode)
+static void unload_crypto_info(struct inode * inode)
 {
-	crypto_stat_t * info = inode_crypto_stat(inode);
+	struct reiser4_crypto_info * info = inode_crypto_info(inode);
 	assert("edward-1381", info->keyload_count > 0);
 
-	dec_keyload_count(inode_crypto_stat(inode));
+	dec_keyload_count(inode_crypto_info(inode));
 	if (info->keyload_count == 0)
 		/* final release */
-		free_crypto_stat(inode);
+		free_crypto_info(inode);
 }
 
 /* attach/detach an existing crypto-stat */
-void reiser4_attach_crypto_stat(struct inode * inode, crypto_stat_t * info)
+void reiser4_attach_crypto_info(struct inode * inode,
+				struct reiser4_crypto_info * info)
 {
 	assert("edward-1382", inode != NULL);
 	assert("edward-1383", info != NULL);
-	assert("edward-1384", inode_crypto_stat(inode) == NULL);
+	assert("edward-1384", inode_crypto_info(inode) == NULL);
 
-	set_inode_crypto_stat(inode, info);
-	load_crypto_stat(info);
+	set_inode_crypto_info(inode, info);
+	load_crypto_info(info);
 }
 
 /* returns true, if crypto stat can be attached to the @host */
 #if REISER4_DEBUG
-static int host_allows_crypto_stat(struct inode * host)
+static int host_allows_crypto_info(struct inode * host)
 {
 	int ret;
 	file_plugin * fplug = inode_file_plugin(host);
@@ -362,20 +362,21 @@ static int host_allows_crypto_stat(struc
 }
 #endif  /*  REISER4_DEBUG  */
 
-static void reiser4_detach_crypto_stat(struct inode * inode)
+static void reiser4_detach_crypto_info(struct inode * inode)
 {
 	assert("edward-1385", inode != NULL);
-	assert("edward-1386", host_allows_crypto_stat(inode));
+	assert("edward-1386", host_allows_crypto_info(inode));
 
-	if (inode_crypto_stat(inode))
-		unload_crypto_stat(inode);
-	set_inode_crypto_stat(inode, NULL);
+	if (inode_crypto_info(inode))
+		unload_crypto_info(inode);
+	set_inode_crypto_info(inode, NULL);
 }
 
 #if 0
 
 /* compare fingerprints of @child and @parent */
-static int keyid_eq(crypto_stat_t * child, crypto_stat_t * parent)
+static int keyid_eq(struct reiser4_crypto_info * child,
+		    struct reiser4_crypto_info * parent)
 {
 	return !memcmp(child->keyid, parent->keyid, info_digest_plugin(parent)->fipsize);
 }
@@ -386,15 +387,15 @@ int can_inherit_crypto_cryptcompress(str
 	if (!need_cipher(child))
 		return 0;
 	/* the child is created */
-	if (!inode_crypto_stat(child))
+	if (!inode_crypto_info(child))
 		return 1;
 	/* the child is looked up */
-	if (!inode_crypto_stat(parent))
+	if (!inode_crypto_info(parent))
 		return 0;
 	return (inode_cipher_plugin(child) == inode_cipher_plugin(parent) &&
 		inode_digest_plugin(child) == inode_digest_plugin(parent) &&
-		inode_crypto_stat(child)->keysize == inode_crypto_stat(parent)->keysize &&
-		keyid_eq(inode_crypto_stat(child), inode_crypto_stat(parent)));
+		inode_crypto_info(child)->keysize == inode_crypto_info(parent)->keysize &&
+		keyid_eq(inode_crypto_info(child), inode_crypto_info(parent)));
 }
 #endif
 
@@ -402,7 +403,7 @@ int can_inherit_crypto_cryptcompress(str
 static int inode_set_crypto(struct inode * object)
 {
 	reiser4_inode * info;
-	if (!inode_crypto_stat(object)) {
+	if (!inode_crypto_info(object)) {
 		if (need_cipher(object))
 			return RETERR(-EINVAL);
 		/* the file is not to be encrypted */
@@ -439,7 +440,7 @@ static int inode_check_cluster(struct in
 void destroy_inode_cryptcompress(struct inode * inode)
 {
 	assert("edward-23", cryptcompress_inode_data(inode)->pgcount == 0);
-	reiser4_detach_crypto_stat(inode);
+	reiser4_detach_crypto_info(inode);
 	return;
 }
 
@@ -488,7 +489,7 @@ create_cryptcompress(struct inode *objec
 	if (!result)
 		return 0;
  error:
-	reiser4_detach_crypto_stat(object);
+	reiser4_detach_crypto_info(object);
 	return result;
 }
 
@@ -527,9 +528,9 @@ static unsigned int
 cipher_blocksize(struct inode * inode)
 {
 	assert("edward-758", need_cipher(inode));
-	assert("edward-1400", inode_crypto_stat(inode) != NULL);
+	assert("edward-1400", inode_crypto_info(inode) != NULL);
 	return crypto_blkcipher_blocksize
-		(info_get_cipher(inode_crypto_stat(inode)));
+		(info_get_cipher(inode_crypto_info(inode)));
 }
 
 /* returns offset translated by scale factor of the crypto-algorithm */
@@ -556,15 +557,16 @@ size_t inode_scaled_cluster_size(struct 
 	return inode_scaled_offset(inode, inode_cluster_size(inode));
 }
 
-static int new_cluster(reiser4_cluster_t * clust, struct inode *inode)
+static int new_cluster(struct cluster_handle * clust, struct inode *inode)
 {
 	return (clust_to_off(clust->index, inode) >= inode->i_size);
 }
 
 /* set number of cluster pages */
-static void set_cluster_nrpages(reiser4_cluster_t * clust, struct inode *inode)
+static void set_cluster_nrpages(struct cluster_handle * clust,
+				struct inode *inode)
 {
-	reiser4_slide_t *win;
+	struct reiser4_slide * win;
 
 	assert("edward-180", clust != NULL);
 	assert("edward-1040", inode != NULL);
@@ -609,7 +611,7 @@ key_by_inode_cryptcompress(struct inode 
 
 	key_by_inode_and_offset_common(inode, 0, key);
 	set_key_offset(key,
-		       (__u64) (!inode_crypto_stat(inode) ? clust_off :
+		       (__u64) (!inode_crypto_info(inode) ? clust_off :
 				inode_scaled_offset(inode, clust_off)));
 	return 0;
 }
@@ -667,7 +669,7 @@ cryptcompress_hint_validate(hint_t * hin
 }
 
 /* reserve disk space when writing a logical cluster */
-static int reserve4cluster(struct inode *inode, reiser4_cluster_t *clust)
+static int reserve4cluster(struct inode *inode, struct cluster_handle *clust)
 {
 	int result = 0;
 
@@ -701,13 +703,13 @@ static int reserve4cluster(struct inode 
 }
 
 /* free reserved disk space if writing a logical cluster fails */
-static void
-free_reserved4cluster(struct inode *inode, reiser4_cluster_t * clust, int count)
+static void free_reserved4cluster(struct inode *inode,
+				  struct cluster_handle *ch, int count)
 {
-	assert("edward-967", clust->reserved == 1);
+	assert("edward-967", ch->reserved == 1);
 
 	cluster_reserved2free(count);
-	clust->reserved = 0;
+	ch->reserved = 0;
 }
 
 /* The core search procedure of the cryptcompress plugin.
@@ -805,11 +807,10 @@ static int find_cluster_item(hint_t * hi
    create/cut some overhead. If this returns true, then @oh
    contains the size of this overhead.
  */
-static int
-need_cut_or_align(struct inode * inode, reiser4_cluster_t * clust,
-		  rw_op rw, int * oh)
+static int need_cut_or_align(struct inode * inode,
+			     struct cluster_handle * ch, rw_op rw, int * oh)
 {
-	tfm_cluster_t * tc = &clust->tc;
+	struct tfm_cluster * tc = &ch->tc;
 	switch (rw) {
 	case WRITE_OP: /* estimate align */
 		*oh = tc->len % cipher_blocksize(inode);
@@ -817,7 +818,7 @@ need_cut_or_align(struct inode * inode, 
 			return 1;
 		break;
 	case READ_OP:  /* estimate cut */
-		*oh = *(tfm_output_data(clust) + tc->len - 1);
+		*oh = *(tfm_output_data(ch) + tc->len - 1);
 		break;
 	default:
 		impossible("edward-1401", "bad option");
@@ -826,28 +827,28 @@ need_cut_or_align(struct inode * inode, 
 }
 
 /* create/cut an overhead of transformed/plain stream */
-static void
-align_or_cut_overhead(struct inode * inode, reiser4_cluster_t * clust, rw_op rw)
+static void align_or_cut_overhead(struct inode * inode,
+				  struct cluster_handle * ch, rw_op rw)
 {
 	int oh;
 	cipher_plugin * cplug = inode_cipher_plugin(inode);
 
 	assert("edward-1402", need_cipher(inode));
 
-	if (!need_cut_or_align(inode, clust, rw, &oh))
+	if (!need_cut_or_align(inode, ch, rw, &oh))
 		return;
 	switch (rw) {
 	case WRITE_OP: /* do align */
-		clust->tc.len +=
-			cplug->align_stream(tfm_input_data(clust) +
-					    clust->tc.len, clust->tc.len,
+		ch->tc.len +=
+			cplug->align_stream(tfm_input_data(ch) +
+					    ch->tc.len, ch->tc.len,
 					    cipher_blocksize(inode));
-		*(tfm_input_data(clust) + clust->tc.len - 1) =
+		*(tfm_input_data(ch) + ch->tc.len - 1) =
 			cipher_blocksize(inode) - oh;
 		break;
 	case READ_OP: /* do cut */
 		assert("edward-1403", oh <= cipher_blocksize(inode));
-		clust->tc.len -= oh;
+		ch->tc.len -= oh;
 		break;
 	default:
 		impossible("edward-1404", "bad option");
@@ -881,7 +882,7 @@ static unsigned deflate_overrun(struct i
    If this returns false, then compressor won't be called for
    the cluster of index @index.
 */
-static int should_compress(tfm_cluster_t * tc, cloff_t index,
+static int should_compress(struct tfm_cluster * tc, cloff_t index,
 			   struct inode *inode)
 {
 	compression_plugin *cplug = inode_compression_plugin(inode);
@@ -903,19 +904,17 @@ static int should_compress(tfm_cluster_t
 
 /* Evaluating results of compression transform.
    Returns true, if we need to accept this results */
-static int
-save_compressed(int size_before, int size_after, struct inode * inode)
+static int save_compressed(int size_before, int size_after, struct inode *inode)
 {
 	return (size_after + deflate_overhead(inode) +
 		max_cipher_overhead(inode) < size_before);
 }
 
 /* Guess result of the evaluation above */
-static int
-need_inflate(reiser4_cluster_t * clust, struct inode *inode,
-	     int encrypted /* is cluster encrypted */ )
+static int need_inflate(struct cluster_handle * ch, struct inode * inode,
+			int encrypted /* is cluster encrypted */ )
 {
-	tfm_cluster_t *tc = &clust->tc;
+	struct tfm_cluster * tc = &ch->tc;
 
 	assert("edward-142", tc != 0);
 	assert("edward-143", inode != NULL);
@@ -944,7 +943,7 @@ need_inflate(reiser4_cluster_t * clust, 
 		                           1 <= overhead <= cipher_blksize
 */
 /* Append a checksum at the end of a transformed stream */
-static void dc_set_checksum(compression_plugin * cplug, tfm_cluster_t * tc)
+static void dc_set_checksum(compression_plugin * cplug, struct tfm_cluster * tc)
 {
 	__u32 checksum;
 
@@ -960,7 +959,7 @@ static void dc_set_checksum(compression_
 
 /* Check a disk cluster checksum.
    Returns 0 if checksum is correct, otherwise returns 1 */
-static int dc_check_checksum(compression_plugin * cplug, tfm_cluster_t * tc)
+static int dc_check_checksum(compression_plugin * cplug, struct tfm_cluster * tc)
 {
 	assert("edward-1312", tc != NULL);
 	assert("edward-1313", tc->len > (int)DC_CHECKSUM_SIZE);
@@ -987,7 +986,7 @@ static int dc_check_checksum(compression
 }
 
 /* get input/output stream for some transform action */
-int grab_tfm_stream(struct inode * inode, tfm_cluster_t * tc,
+int grab_tfm_stream(struct inode * inode, struct tfm_cluster * tc,
 		    tfm_stream_id id)
 {
 	size_t size = inode_scaled_cluster_size(inode);
@@ -998,9 +997,9 @@ int grab_tfm_stream(struct inode * inode
 	if (cluster_get_tfm_act(tc) == TFMA_WRITE)
 		size += deflate_overrun(inode, inode_cluster_size(inode));
 
-	if (!tfm_stream(tc, id) && id == INPUT_STREAM)
+	if (!get_tfm_stream(tc, id) && id == INPUT_STREAM)
 		alternate_streams(tc);
-	if (!tfm_stream(tc, id))
+	if (!get_tfm_stream(tc, id))
 		return alloc_tfm_stream(tc, size, id);
 
 	assert("edward-902", tfm_stream_is_set(tc, id));
@@ -1011,12 +1010,12 @@ int grab_tfm_stream(struct inode * inode
 }
 
 /* Common deflate manager */
-int reiser4_deflate_cluster(reiser4_cluster_t * clust, struct inode * inode)
+int reiser4_deflate_cluster(struct cluster_handle * clust, struct inode * inode)
 {
 	int result = 0;
 	int compressed = 0;
 	int encrypted = 0;
-	tfm_cluster_t * tc = &clust->tc;
+	struct tfm_cluster * tc = &clust->tc;
 	compression_plugin * coplug;
 
 	assert("edward-401", inode != NULL);
@@ -1096,7 +1095,7 @@ int reiser4_deflate_cluster(reiser4_clus
 		struct scatterlist dst;
 
 		ciplug = inode_cipher_plugin(inode);
-		desc.tfm = info_get_cipher(inode_crypto_stat(inode));
+		desc.tfm = info_get_cipher(inode_crypto_info(inode));
 		desc.flags = 0;
 		if (compressed)
 			alternate_streams(tc);
@@ -1129,11 +1128,11 @@ int reiser4_deflate_cluster(reiser4_clus
 }
 
 /* Common inflate manager. */
-int reiser4_inflate_cluster(reiser4_cluster_t * clust, struct inode * inode)
+int reiser4_inflate_cluster(struct cluster_handle * clust, struct inode * inode)
 {
 	int result = 0;
 	int transformed = 0;
-	tfm_cluster_t * tc = &clust->tc;
+	struct tfm_cluster * tc = &clust->tc;
 	compression_plugin * coplug;
 
 	assert("edward-905", inode != NULL);
@@ -1162,7 +1161,7 @@ int reiser4_inflate_cluster(reiser4_clus
 		struct scatterlist dst;
 
 		ciplug = inode_cipher_plugin(inode);
-		desc.tfm = info_get_cipher(inode_crypto_stat(inode));
+		desc.tfm = info_get_cipher(inode_crypto_info(inode));
 		desc.flags = 0;
 		result = grab_tfm_stream(inode, tc, OUTPUT_STREAM);
 		if (result)
@@ -1215,7 +1214,7 @@ int reiser4_inflate_cluster(reiser4_clus
 int readpage_cryptcompress(struct file *file, struct page *page)
 {
 	reiser4_context *ctx;
-	reiser4_cluster_t clust;
+	struct cluster_handle clust;
 	item_plugin *iplug;
 	int result;
 
@@ -1257,7 +1256,7 @@ int readpage_cryptcompress(struct file *
 }
 
 /* how much pages will be captured */
-static int cluster_nrpages_to_capture(reiser4_cluster_t * clust)
+static int cluster_nrpages_to_capture(struct cluster_handle * clust)
 {
 	switch (clust->op) {
 	case PCL_APPEND:
@@ -1271,7 +1270,7 @@ static int cluster_nrpages_to_capture(re
 	}
 }
 
-static void set_cluster_pages_dirty(reiser4_cluster_t * clust)
+static void set_cluster_pages_dirty(struct cluster_handle * clust)
 {
 	int i;
 	struct page *pg;
@@ -1289,7 +1288,7 @@ static void set_cluster_pages_dirty(reis
 	}
 }
 
-static void clear_cluster_pages_dirty(reiser4_cluster_t * clust)
+static void clear_cluster_pages_dirty(struct cluster_handle * clust)
 {
 	int i;
 	assert("edward-1275", clust != NULL);
@@ -1319,10 +1318,11 @@ static void clear_cluster_pages_dirty(re
 }
 
 /* update i_size by window */
-static void inode_set_new_size(reiser4_cluster_t * clust, struct inode *inode)
+static void inode_set_new_size(struct cluster_handle * clust,
+			       struct inode * inode)
 {
 	loff_t size;
-	reiser4_slide_t *win;
+	struct reiser4_slide * win;
 
 	assert("edward-1181", clust != NULL);
 	assert("edward-1182", inode != NULL);
@@ -1357,9 +1357,9 @@ static void inode_set_new_size(reiser4_c
    . Clean up old references (if any).
    . Put pages (grabbed in this thread) which will be truncated
 */
-static void
-make_cluster_jnode_dirty_locked(reiser4_cluster_t * clust, jnode * node,
-				loff_t * old_isize, struct inode *inode)
+static void make_cluster_jnode_dirty_locked(struct cluster_handle * clust,
+					    jnode * node, loff_t * old_isize,
+					    struct inode * inode)
 {
 	int i;
 	int old_nrpages;
@@ -1418,7 +1418,8 @@ make_cluster_jnode_dirty_locked(reiser4_
 /* This function spawns a transaction and
    is called by any thread as a final step in page cluster modification.
 */
-static int try_capture_cluster(reiser4_cluster_t * clust, struct inode *inode)
+static int try_capture_cluster(struct cluster_handle * clust,
+			       struct inode *inode)
 {
 	int result = 0;
 	loff_t old_size;
@@ -1455,8 +1456,8 @@ static int try_capture_cluster(reiser4_c
    page of this cluster, so we have an extra-reference that will exist with
    this jnode, other references will be cleaned up in flush time.
 */
-static int
-grab_cluster_pages_jnode(struct inode *inode, reiser4_cluster_t * clust)
+static int grab_cluster_pages_jnode(struct inode * inode,
+				    struct cluster_handle * clust)
 {
 	int i;
 	int result = 0;
@@ -1510,7 +1511,7 @@ grab_cluster_pages_jnode(struct inode *i
 }
 
 /* Collect unlocked cluster pages only for read (not to modify) */
-int grab_cluster_pages(struct inode *inode, reiser4_cluster_t * clust)
+int grab_cluster_pages(struct inode *inode, struct cluster_handle * clust)
 {
 	int i;
 	int result = 0;
@@ -1571,7 +1572,7 @@ int jnode_of_cluster(const jnode * node,
 #endif  /*  0  */
 
 /* put cluster pages */
-void reiser4_release_cluster_pages(reiser4_cluster_t * clust)
+void reiser4_release_cluster_pages(struct cluster_handle * clust)
 {
 	int i;
 
@@ -1585,7 +1586,8 @@ void reiser4_release_cluster_pages(reise
 }
 
 /* this is called when something is failed */
-static void reiser4_release_cluster_pages_and_jnode(reiser4_cluster_t * clust)
+static void
+reiser4_release_cluster_pages_and_jnode(struct cluster_handle * clust)
 {
 	jnode *node;
 
@@ -1602,7 +1604,7 @@ static void reiser4_release_cluster_page
 }
 
 #if REISER4_DEBUG
-static int window_ok(reiser4_slide_t * win, struct inode *inode)
+static int window_ok(struct reiser4_slide * win, struct inode *inode)
 {
 	assert("edward-1115", win != NULL);
 	assert("edward-1116", ergo(win->delta, win->stat == HOLE_WINDOW));
@@ -1611,7 +1613,7 @@ static int window_ok(reiser4_slide_t * w
 	    (win->off + win->count + win->delta <= inode_cluster_size(inode));
 }
 
-static int cluster_ok(reiser4_cluster_t * clust, struct inode *inode)
+static int cluster_ok(struct cluster_handle * clust, struct inode *inode)
 {
 	assert("edward-279", clust != NULL);
 
@@ -1622,7 +1624,7 @@ static int cluster_ok(reiser4_cluster_t 
 #endif
 
 /* guess next window stat */
-static inline window_stat next_window_stat(reiser4_slide_t * win)
+static inline window_stat next_window_stat(struct reiser4_slide * win)
 {
 	assert("edward-1130", win != NULL);
 	return ((win->stat == HOLE_WINDOW && win->delta == 0) ?
@@ -1630,11 +1632,10 @@ static inline window_stat next_window_st
 }
 
 /* guess next cluster index and window params */
-static void
-update_cluster(struct inode *inode, reiser4_cluster_t * clust, loff_t file_off,
-	       loff_t to_file)
+static void update_cluster(struct inode * inode, struct cluster_handle * clust,
+			   loff_t file_off, loff_t to_file)
 {
-	reiser4_slide_t *win;
+	struct reiser4_slide * win;
 
 	assert("edward-185", clust != NULL);
 	assert("edward-438", clust->pages != NULL);
@@ -1732,14 +1733,13 @@ static void forget_cluster_pages(struct 
 /* Check out last modifications we are about to commit,
    and prepare input stream for transform operations.
 */
-int
-flush_cluster_pages(reiser4_cluster_t * clust, jnode * node,
-		    struct inode *inode)
+int flush_cluster_pages(struct cluster_handle * clust, jnode * node,
+			struct inode *inode)
 {
 	int result = 0;
 	int i;
 	int nr_pages = 0;
-	tfm_cluster_t *tc = &clust->tc;
+	struct tfm_cluster *tc = &clust->tc;
 #if REISER4_DEBUG
 	int node_pgcount;
 #endif
@@ -1852,7 +1852,7 @@ static void set_hint_cluster(struct inod
 	hint->mode = mode;
 }
 
-void invalidate_hint_cluster(reiser4_cluster_t * clust)
+void invalidate_hint_cluster(struct cluster_handle * clust)
 {
 	assert("edward-1291", clust != NULL);
 	assert("edward-1292", clust->hint != NULL);
@@ -1861,8 +1861,8 @@ void invalidate_hint_cluster(reiser4_clu
 	hint_clr_valid(clust->hint);
 }
 
-void put_hint_cluster(reiser4_cluster_t * clust, struct inode *inode,
-		 znode_lock_mode mode)
+void put_hint_cluster(struct cluster_handle * clust, struct inode *inode,
+		      znode_lock_mode mode)
 {
 	assert("edward-1286", clust != NULL);
 	assert("edward-1287", clust->hint != NULL);
@@ -1871,9 +1871,9 @@ void put_hint_cluster(reiser4_cluster_t 
 	invalidate_hint_cluster(clust);
 }
 
-static int
-balance_dirty_page_cluster(reiser4_cluster_t * clust, struct inode *inode,
-			   loff_t off, loff_t to_file)
+static int balance_dirty_page_cluster(struct cluster_handle * clust,
+				      struct inode *inode, loff_t off,
+				      loff_t to_file)
 {
 	int result;
 
@@ -1892,15 +1892,15 @@ balance_dirty_page_cluster(reiser4_clust
 	return 0;
 }
 
-/* set zeroes to the cluster, update it, and maybe, try to capture its pages */
-static int
-write_hole(struct inode *inode, reiser4_cluster_t * clust, loff_t file_off,
-	   loff_t to_file)
+/* set zeroes to the page cluster, proceed it, and maybe, try to capture
+   its pages */
+static int write_hole(struct inode *inode, struct cluster_handle * clust,
+		      loff_t file_off, loff_t to_file)
 {
 	int result = 0;
 	unsigned cl_off, cl_count = 0;
 	unsigned to_pg, pg_off;
-	reiser4_slide_t *win;
+	struct reiser4_slide * win;
 
 	assert("edward-190", clust != NULL);
 	assert("edward-1069", clust->win != NULL);
@@ -1957,7 +1957,7 @@ write_hole(struct inode *inode, reiser4_
 }
 
 /*
-  The main disk search procedure for cryptcompress plugins, which
+  The main disk search procedure for cryptcompress plugin, which
   . scans all items of disk cluster with the lock mode @mode
   . maybe reads each one (if @read)
   . maybe makes its znode dirty (if write lock mode was specified)
@@ -1965,7 +1965,7 @@ write_hole(struct inode *inode, reiser4_
   NOTE-EDWARD: Callers should handle the case when disk cluster
   is incomplete (-EIO)
 */
-int find_disk_cluster(reiser4_cluster_t * clust,
+int find_disk_cluster(struct cluster_handle * clust,
 		      struct inode *inode, int read, znode_lock_mode mode)
 {
 	flow_t f;
@@ -1975,7 +1975,7 @@ int find_disk_cluster(reiser4_cluster_t 
 	ra_info_t ra_info;
 	file_plugin *fplug;
 	item_plugin *iplug;
-	tfm_cluster_t *tc;
+	struct tfm_cluster *tc;
 	int was_grabbed;
 
 	assert("edward-138", clust != NULL);
@@ -2098,9 +2098,8 @@ int find_disk_cluster(reiser4_cluster_t 
 	return result;
 }
 
-int
-get_disk_cluster_locked(reiser4_cluster_t * clust, struct inode *inode,
-			znode_lock_mode lock_mode)
+int get_disk_cluster_locked(struct cluster_handle * clust, struct inode *inode,
+			    znode_lock_mode lock_mode)
 {
 	reiser4_key key;
 	ra_info_t ra_info;
@@ -2133,13 +2132,13 @@ get_disk_cluster_locked(reiser4_cluster_
    . find and set disk cluster state
    . make disk cluster dirty if its state is not FAKE_DISK_CLUSTER.
 */
-static int
-read_some_cluster_pages(struct inode *inode, reiser4_cluster_t * clust)
+static int read_some_cluster_pages(struct inode * inode,
+				   struct cluster_handle * clust)
 {
 	int i;
 	int result = 0;
 	item_plugin *iplug;
-	reiser4_slide_t *win = clust->win;
+	struct reiser4_slide * win = clust->win;
 	znode_lock_mode mode = ZNODE_WRITE_LOCK;
 
 	iplug = item_plugin_by_id(CTAIL_ID);
@@ -2251,8 +2250,8 @@ read_some_cluster_pages(struct inode *in
 	return result;
 }
 
-static int
-should_create_unprepped_cluster(reiser4_cluster_t * clust, struct inode *inode)
+static int should_create_unprepped_cluster(struct cluster_handle * clust,
+					   struct inode * inode)
 {
 	assert("edward-737", clust != NULL);
 
@@ -2273,9 +2272,8 @@ should_create_unprepped_cluster(reiser4_
 	}
 }
 
-static int
-cryptcompress_make_unprepped_cluster(reiser4_cluster_t * clust,
-				     struct inode *inode)
+static int cryptcompress_make_unprepped_cluster(struct cluster_handle * clust,
+						struct inode *inode)
 {
 	int result;
 
@@ -2336,9 +2334,8 @@ static int jnode_truncate_ok(struct inod
 
 /* Collect unlocked cluster pages and jnode (the last is in the
    case when the page cluster will be modified and captured) */
-int
-prepare_page_cluster(struct inode *inode, reiser4_cluster_t * clust,
-		     int capture)
+int prepare_page_cluster(struct inode * inode, struct cluster_handle * clust,
+			 int capture)
 {
 	assert("edward-177", inode != NULL);
 	assert("edward-741", cryptcompress_inode_ok(inode));
@@ -2428,7 +2425,7 @@ void truncate_page_cluster_cryptcompress
 	return;
 }
 
-/* Prepare cluster handle before(after) modifications
+/* Prepare cluster handle @clust before(after) modifications
    which are supposed to be committed.
 
    . grab cluster pages;
@@ -2439,14 +2436,13 @@ void truncate_page_cluster_cryptcompress
      (i.e. is not represenred by any items)
 */
 
-static int
-prepare_cluster(struct inode *inode,
-		loff_t file_off /* write position in the file */ ,
-		loff_t to_file,	/* bytes of users data to write to the file */
-		reiser4_cluster_t * clust, page_cluster_op op)
+static int prepare_cluster(struct inode *inode,
+			   loff_t file_off, /* write position in the file */
+			   loff_t to_file, /* bytes of users data to write to the file */
+			   struct cluster_handle * clust, page_cluster_op op)
 {
 	int result = 0;
-	reiser4_slide_t *win = clust->win;
+	struct reiser4_slide * win = clust->win;
 
 	reset_cluster_params(clust);
 	cluster_set_tfm_act(&clust->tc, TFMA_READ);
@@ -2498,9 +2494,9 @@ prepare_cluster(struct inode *inode,
 }
 
 /* set window by two offsets */
-static void
-set_window(reiser4_cluster_t * clust, reiser4_slide_t * win,
-	   struct inode *inode, loff_t o1, loff_t o2)
+static void set_window(struct cluster_handle * clust,
+		       struct reiser4_slide * win, struct inode *inode,
+		       loff_t o1, loff_t o2)
 {
 	assert("edward-295", clust != NULL);
 	assert("edward-296", inode != NULL);
@@ -2516,9 +2512,10 @@ set_window(reiser4_cluster_t * clust, re
 	clust->win = win;
 }
 
-static int
-set_cluster_by_window(struct inode *inode, reiser4_cluster_t * clust,
-		      reiser4_slide_t * win, flow_t * f, loff_t file_off)
+static int set_cluster_by_window(struct inode *inode,
+				 struct cluster_handle * clust,
+				 struct reiser4_slide * win, flow_t * f,
+				 loff_t file_off)
 {
 	int result;
 
@@ -2549,25 +2546,26 @@ set_cluster_by_window(struct inode *inod
 	return 0;
 }
 
-int set_cluster_by_page(reiser4_cluster_t * clust, struct page * page,
+int set_cluster_by_page(struct cluster_handle * clust, struct page * page,
 			int count)
 {
 	int result = 0;
-	int (*setting_actor)(reiser4_cluster_t * clust, int count);
+	int (*setting_actor)(struct cluster_handle * clust, int count);
 
 	assert("edward-1358", clust != NULL);
 	assert("edward-1359", page != NULL);
 	assert("edward-1360", page->mapping != NULL);
 	assert("edward-1361", page->mapping->host != NULL);
 
-	setting_actor  = (clust->pages ? reset_cluster_pgset : alloc_cluster_pgset);
+	setting_actor =
+		(clust->pages ? reset_cluster_pgset : alloc_cluster_pgset);
 	result = setting_actor(clust, count);
 	clust->index = pg_to_clust(page->index, page->mapping->host);
 	return result;
 }
 
 /* reset all the params that not get updated */
-void reset_cluster_params(reiser4_cluster_t * clust)
+void reset_cluster_params(struct cluster_handle * clust)
 {
 	assert("edward-197", clust != NULL);
 
@@ -2593,8 +2591,8 @@ write_cryptcompress_flow(struct file *fi
 	int result = 0;
 	size_t to_write = 0;
 	loff_t file_off;
-	reiser4_slide_t win;
-	reiser4_cluster_t clust;
+	struct reiser4_slide win;
+	struct cluster_handle clust;
 
 	assert("edward-161", reiser4_schedulable());
 	assert("edward-748", cryptcompress_inode_ok(inode));
@@ -2759,7 +2757,7 @@ ssize_t write_cryptcompress(struct file 
 	struct inode *inode;
 	reiser4_context *ctx;
   	loff_t pos = *off;
-  	cryptcompress_info_t *info;
+  	struct cryptcompress_info *info;
 
   	assert("edward-1449", *conv == 0);
 
@@ -2845,7 +2843,7 @@ ssize_t read_cryptcompress(struct file *
 	ssize_t result;
 	struct inode *inode;
 	reiser4_context *ctx;
-	cryptcompress_info_t *info;
+	struct cryptcompress_info *info;
 	reiser4_block_nr needed;
 
 	inode = file->f_dentry->d_inode;
@@ -3106,8 +3104,8 @@ cryptcompress_append_hole(struct inode *
 	lock_handle *lh;
 	loff_t hole_size;
 	int nr_zeroes;
-	reiser4_slide_t win;
-	reiser4_cluster_t clust;
+	struct reiser4_slide win;
+	struct cluster_handle clust;
 
 	assert("edward-1133", inode->i_size < new_size);
 	assert("edward-1134", reiser4_schedulable());
@@ -3219,9 +3217,8 @@ update_cryptcompress_size(struct inode *
    2) set zeroes and capture last partially truncated page cluster if the last
       one exists, otherwise truncate via prune fake cluster (just decrease i_size)
 */
-static int
-prune_cryptcompress(struct inode *inode, loff_t new_size, int update_sd,
-		    cloff_t aidx)
+static int prune_cryptcompress(struct inode *inode, loff_t new_size,
+			       int update_sd, cloff_t aidx)
 {
 	int result = 0;
 	unsigned nr_zeroes;
@@ -3231,8 +3228,8 @@ prune_cryptcompress(struct inode *inode,
 
 	hint_t *hint;
 	lock_handle *lh;
-	reiser4_slide_t win;
-	reiser4_cluster_t clust;
+	struct reiser4_slide win;
+	struct cluster_handle clust;
 
 	assert("edward-1140", inode->i_size >= new_size);
 	assert("edward-1141", reiser4_schedulable());
@@ -3398,7 +3395,7 @@ static int cryptcompress_truncate(struct
 }
 
 static void clear_moved_tag_cluster(struct address_space * mapping,
-				    reiser4_cluster_t * clust)
+				    struct cluster_handle * clust)
 {
 	int i;
 	void * ret;
@@ -3415,8 +3412,8 @@ static void clear_moved_tag_cluster(stru
 
 /* Capture an anonymous pager cluster. (Page cluser is
    anonymous if it contains at least one anonymous page */
-static int
-capture_page_cluster(reiser4_cluster_t * clust, struct inode *inode)
+static int capture_page_cluster(struct cluster_handle * clust,
+				struct inode * inode)
 {
 	int result;
 
@@ -3448,17 +3445,16 @@ capture_page_cluster(reiser4_cluster_t *
 
 #define MAX_CLUSTERS_TO_CAPTURE(inode)    (1024 >> cluster_nrpages_shift(inode))
 
-/* read lock should be acquired */
-static int
-capture_anonymous_clusters(struct address_space *mapping, pgoff_t * index,
-			   int to_capture)
+/* Capture anonymous page clusters */
+static int capture_anonymous_clusters(struct address_space * mapping,
+				      pgoff_t * index, int to_capture)
 {
 	int result = 0;
 	int found;
 	struct page *page = NULL;
 	hint_t *hint;
 	lock_handle *lh;
-	reiser4_cluster_t clust;
+	struct cluster_handle clust;
 
 	assert("edward-1127", mapping != NULL);
 	assert("edward-1128", mapping->host != NULL);
@@ -3533,7 +3529,7 @@ writepages_cryptcompress(struct address_
 	int to_capture;
 	pgoff_t nrpages;
 	pgoff_t index = 0;
-	cryptcompress_info_t *info;
+	struct cryptcompress_info *info;
 	struct inode *inode;
 
 	inode = mapping->host;
@@ -3690,7 +3686,7 @@ sendfile_cryptcompress(struct file *file
 	reiser4_context *ctx;
 	ssize_t result;
 	struct inode *inode;
-	cryptcompress_info_t *info;
+	struct cryptcompress_info *info;
 
 	inode = file->f_dentry->d_inode;
 	ctx = reiser4_init_context(inode->i_sb);
diff -puN fs/reiser4/plugin/file/cryptcompress.h~reiser4-remove-typedefs fs/reiser4/plugin/file/cryptcompress.h
--- a/fs/reiser4/plugin/file/cryptcompress.h~reiser4-remove-typedefs
+++ a/fs/reiser4/plugin/file/cryptcompress.h
@@ -46,10 +46,10 @@ static inline int cluster_shift_ok(int s
 }
 #endif
 
-typedef struct tfm_stream {
+struct tfm_stream {
 	__u8 *data;
 	size_t size;
-} tfm_stream_t;
+};
 
 typedef enum {
 	INPUT_STREAM,
@@ -57,28 +57,28 @@ typedef enum {
 	LAST_STREAM
 } tfm_stream_id;
 
-typedef tfm_stream_t *tfm_unit[LAST_STREAM];
+typedef struct tfm_stream * tfm_unit[LAST_STREAM];
 
-static inline __u8 *ts_data(tfm_stream_t * stm)
+static inline __u8 *ts_data(struct tfm_stream * stm)
 {
 	assert("edward-928", stm != NULL);
 	return stm->data;
 }
 
-static inline size_t ts_size(tfm_stream_t * stm)
+static inline size_t ts_size(struct tfm_stream * stm)
 {
 	assert("edward-929", stm != NULL);
 	return stm->size;
 }
 
-static inline void set_ts_size(tfm_stream_t * stm, size_t size)
+static inline void set_ts_size(struct tfm_stream * stm, size_t size)
 {
 	assert("edward-930", stm != NULL);
 
 	stm->size = size;
 }
 
-static inline int alloc_ts(tfm_stream_t ** stm)
+static inline int alloc_ts(struct tfm_stream ** stm)
 {
 	assert("edward-931", stm);
 	assert("edward-932", *stm == NULL);
@@ -90,7 +90,7 @@ static inline int alloc_ts(tfm_stream_t 
 	return 0;
 }
 
-static inline void free_ts(tfm_stream_t * stm)
+static inline void free_ts(struct tfm_stream * stm)
 {
 	assert("edward-933", !ts_data(stm));
 	assert("edward-934", !ts_size(stm));
@@ -98,7 +98,7 @@ static inline void free_ts(tfm_stream_t 
 	kfree(stm);
 }
 
-static inline int alloc_ts_data(tfm_stream_t * stm, size_t size)
+static inline int alloc_ts_data(struct tfm_stream * stm, size_t size)
 {
 	assert("edward-935", !ts_data(stm));
 	assert("edward-936", !ts_size(stm));
@@ -111,7 +111,7 @@ static inline int alloc_ts_data(tfm_stre
 	return 0;
 }
 
-static inline void free_ts_data(tfm_stream_t * stm)
+static inline void free_ts_data(struct tfm_stream * stm)
 {
 	assert("edward-938", equi(ts_data(stm), ts_size(stm)));
 
@@ -139,28 +139,28 @@ typedef enum {
    page cluster into the input one. After transform we split output stream into
    a set of items (disk cluster).
 */
-typedef struct tfm_cluster {
+struct tfm_cluster {
 	coa_set coa;
 	tfm_unit tun;
 	tfm_action act;
 	int uptodate;
 	int lsize;        /* size of the logical cluster */
 	int len;          /* length of the transform stream */
-} tfm_cluster_t;
+};
 
-static inline coa_t get_coa(tfm_cluster_t * tc, reiser4_compression_id id, tfm_action act)
+static inline coa_t get_coa(struct tfm_cluster * tc, reiser4_compression_id id,
+			    tfm_action act)
 {
 	return tc->coa[id][act];
 }
 
-static inline void
-set_coa(tfm_cluster_t * tc, reiser4_compression_id id, tfm_action act, coa_t coa)
+static inline void set_coa(struct tfm_cluster * tc, reiser4_compression_id id,
+			   tfm_action act, coa_t coa)
 {
 	tc->coa[id][act] = coa;
 }
 
-static inline int
-alloc_coa(tfm_cluster_t * tc, compression_plugin * cplug)
+static inline int alloc_coa(struct tfm_cluster * tc, compression_plugin * cplug)
 {
 	coa_t coa;
 
@@ -172,13 +172,13 @@ alloc_coa(tfm_cluster_t * tc, compressio
 }
 
 static inline int
-grab_coa(tfm_cluster_t * tc, compression_plugin * cplug)
+grab_coa(struct tfm_cluster * tc, compression_plugin * cplug)
 {
 	return (cplug->alloc && !get_coa(tc, cplug->h.id, tc->act) ?
 		alloc_coa(tc, cplug) : 0);
 }
 
-static inline void free_coa_set(tfm_cluster_t * tc)
+static inline void free_coa_set(struct tfm_cluster * tc)
 {
 	tfm_action j;
 	reiser4_compression_id i;
@@ -198,64 +198,65 @@ static inline void free_coa_set(tfm_clus
 	return;
 }
 
-static inline tfm_stream_t *tfm_stream(tfm_cluster_t * tc, tfm_stream_id id)
+static inline struct tfm_stream * get_tfm_stream(struct tfm_cluster * tc,
+						 tfm_stream_id id)
 {
 	return tc->tun[id];
 }
 
-static inline void
-set_tfm_stream(tfm_cluster_t * tc, tfm_stream_id id, tfm_stream_t * ts)
+static inline void set_tfm_stream(struct tfm_cluster * tc,
+				  tfm_stream_id id, struct tfm_stream * ts)
 {
 	tc->tun[id] = ts;
 }
 
-static inline __u8 *tfm_stream_data(tfm_cluster_t * tc, tfm_stream_id id)
+static inline __u8 *tfm_stream_data(struct tfm_cluster * tc, tfm_stream_id id)
 {
-	return ts_data(tfm_stream(tc, id));
+	return ts_data(get_tfm_stream(tc, id));
 }
 
-static inline void
-set_tfm_stream_data(tfm_cluster_t * tc, tfm_stream_id id, __u8 * data)
+static inline void set_tfm_stream_data(struct tfm_cluster * tc,
+				       tfm_stream_id id, __u8 * data)
 {
-	tfm_stream(tc, id)->data = data;
+	get_tfm_stream(tc, id)->data = data;
 }
 
-static inline size_t tfm_stream_size(tfm_cluster_t * tc, tfm_stream_id id)
+static inline size_t tfm_stream_size(struct tfm_cluster * tc, tfm_stream_id id)
 {
-	return ts_size(tfm_stream(tc, id));
+	return ts_size(get_tfm_stream(tc, id));
 }
 
 static inline void
-set_tfm_stream_size(tfm_cluster_t * tc, tfm_stream_id id, size_t size)
+set_tfm_stream_size(struct tfm_cluster * tc, tfm_stream_id id, size_t size)
 {
-	tfm_stream(tc, id)->size = size;
+	get_tfm_stream(tc, id)->size = size;
 }
 
 static inline int
-alloc_tfm_stream(tfm_cluster_t * tc, size_t size, tfm_stream_id id)
+alloc_tfm_stream(struct tfm_cluster * tc, size_t size, tfm_stream_id id)
 {
 	assert("edward-939", tc != NULL);
-	assert("edward-940", !tfm_stream(tc, id));
+	assert("edward-940", !get_tfm_stream(tc, id));
 
-	tc->tun[id] = kmalloc(sizeof(tfm_stream_t), reiser4_ctx_gfp_mask_get());
+	tc->tun[id] = kzalloc(sizeof(struct tfm_stream),
+			      reiser4_ctx_gfp_mask_get());
 	if (!tc->tun[id])
 		return -ENOMEM;
-	memset(tfm_stream(tc, id), 0, sizeof(tfm_stream_t));
-	return alloc_ts_data(tfm_stream(tc, id), size);
+	return alloc_ts_data(get_tfm_stream(tc, id), size);
 }
 
 static inline int
-realloc_tfm_stream(tfm_cluster_t * tc, size_t size, tfm_stream_id id)
+realloc_tfm_stream(struct tfm_cluster * tc, size_t size, tfm_stream_id id)
 {
 	assert("edward-941", tfm_stream_size(tc, id) < size);
-	free_ts_data(tfm_stream(tc, id));
-	return alloc_ts_data(tfm_stream(tc, id), size);
+	free_ts_data(get_tfm_stream(tc, id));
+	return alloc_ts_data(get_tfm_stream(tc, id), size);
 }
 
-static inline void free_tfm_stream(tfm_cluster_t * tc, tfm_stream_id id)
+static inline void free_tfm_stream(struct tfm_cluster * tc, tfm_stream_id id)
 {
-	free_ts_data(tfm_stream(tc, id));
-	free_ts(tfm_stream(tc, id));
+	free_ts_data(get_tfm_stream(tc, id));
+	free_ts(get_tfm_stream(tc, id));
 	set_tfm_stream(tc, id, 0);
 }
 
@@ -264,31 +265,31 @@ static inline unsigned coa_overrun(compr
 	return (cplug->overrun != NULL ? cplug->overrun(ilen) : 0);
 }
 
-static inline void free_tfm_unit(tfm_cluster_t * tc)
+static inline void free_tfm_unit(struct tfm_cluster * tc)
 {
 	tfm_stream_id id;
 	for (id = 0; id < LAST_STREAM; id++) {
-		if (!tfm_stream(tc, id))
+		if (!get_tfm_stream(tc, id))
 			continue;
 		free_tfm_stream(tc, id);
 	}
 }
 
-static inline void put_tfm_cluster(tfm_cluster_t * tc)
+static inline void put_tfm_cluster(struct tfm_cluster * tc)
 {
 	assert("edward-942", tc != NULL);
 	free_coa_set(tc);
 	free_tfm_unit(tc);
 }
 
-static inline int tfm_cluster_is_uptodate(tfm_cluster_t * tc)
+static inline int tfm_cluster_is_uptodate(struct tfm_cluster * tc)
 {
 	assert("edward-943", tc != NULL);
 	assert("edward-944", tc->uptodate == 0 || tc->uptodate == 1);
 	return (tc->uptodate == 1);
 }
 
-static inline void tfm_cluster_set_uptodate(tfm_cluster_t * tc)
+static inline void tfm_cluster_set_uptodate(struct tfm_cluster * tc)
 {
 	assert("edward-945", tc != NULL);
 	assert("edward-946", tc->uptodate == 0 || tc->uptodate == 1);
@@ -296,7 +297,7 @@ static inline void tfm_cluster_set_uptod
 	return;
 }
 
-static inline void tfm_cluster_clr_uptodate(tfm_cluster_t * tc)
+static inline void tfm_cluster_clr_uptodate(struct tfm_cluster * tc)
 {
 	assert("edward-947", tc != NULL);
 	assert("edward-948", tc->uptodate == 0 || tc->uptodate == 1);
@@ -304,13 +305,13 @@ static inline void tfm_cluster_clr_uptod
 	return;
 }
 
-static inline int tfm_stream_is_set(tfm_cluster_t * tc, tfm_stream_id id)
+static inline int tfm_stream_is_set(struct tfm_cluster * tc, tfm_stream_id id)
 {
-	return (tfm_stream(tc, id) &&
+	return (get_tfm_stream(tc, id) &&
 		tfm_stream_data(tc, id) && tfm_stream_size(tc, id));
 }
 
-static inline int tfm_cluster_is_set(tfm_cluster_t * tc)
+static inline int tfm_cluster_is_set(struct tfm_cluster * tc)
 {
 	int i;
 	for (i = 0; i < LAST_STREAM; i++)
@@ -319,11 +320,11 @@ static inline int tfm_cluster_is_set(tfm
 	return 1;
 }
 
-static inline void alternate_streams(tfm_cluster_t * tc)
+static inline void alternate_streams(struct tfm_cluster * tc)
 {
-	tfm_stream_t *tmp = tfm_stream(tc, INPUT_STREAM);
+	struct tfm_stream *tmp = get_tfm_stream(tc, INPUT_STREAM);
 
-	set_tfm_stream(tc, INPUT_STREAM, tfm_stream(tc, OUTPUT_STREAM));
+	set_tfm_stream(tc, INPUT_STREAM, get_tfm_stream(tc, OUTPUT_STREAM));
 	set_tfm_stream(tc, OUTPUT_STREAM, tmp);
 }
 
@@ -339,12 +340,12 @@ typedef enum {
    bytes to write, etc.. to the following configuration needed to estimate
    number of pages to read before write, etc...
 */
-typedef struct reiser4_slide {
+struct reiser4_slide {
 	unsigned off;		/* offset we start to write/truncate from */
 	unsigned count;		/* number of bytes (zeroes) to write/truncate */
 	unsigned delta;		/* number of bytes to append to the hole */
 	window_stat stat;	/* a kind of data to write to the window */
-} reiser4_slide_t;
+};
 
 /* The following is a set of possible disk cluster states */
 typedef enum {
@@ -362,8 +363,8 @@ typedef enum {
    reiser4 cluster manager fills the following structure incapsulating pointers
    to all the clusters for the same index including the sliding window above
 */
-typedef struct reiser4_cluster {
-	tfm_cluster_t tc;	/* transform cluster */
+struct cluster_handle {
+	struct tfm_cluster tc;	/* transform info */
 	int nr_pages;		/* number of pages */
 	struct page **pages;	/* page cluster */
 	page_cluster_op op;	/* page cluster operation */
@@ -372,7 +373,7 @@ typedef struct reiser4_cluster {
 	disk_cluster_stat dstat;	/* state of the current disk cluster */
 	cloff_t index;		/* offset in the units of cluster size */
 	int index_valid;        /* to validate the index above, if needed */
-	reiser4_slide_t *win;	/* sliding window of cluster size */
+	struct reiser4_slide *win;	/* sliding window of cluster size */
 	int reserved;		/* this indicates that space for disk
 				   cluster modification is reserved */
 #if REISER4_DEBUG
@@ -381,26 +382,28 @@ typedef struct reiser4_cluster {
 	int reserved_unprepped;
 #endif
 
-} reiser4_cluster_t;
+};
 
-static inline __u8 * tfm_input_data (reiser4_cluster_t * clust)
+static inline __u8 * tfm_input_data (struct cluster_handle * clust)
 {
 	return tfm_stream_data(&clust->tc, INPUT_STREAM);
 }
 
-static inline __u8 * tfm_output_data (reiser4_cluster_t * clust)
+static inline __u8 * tfm_output_data (struct cluster_handle * clust)
 {
 	return tfm_stream_data(&clust->tc, OUTPUT_STREAM);
 }
 
-static inline int reset_cluster_pgset(reiser4_cluster_t * clust, int nrpages)
+static inline int reset_cluster_pgset(struct cluster_handle * clust,
+				      int nrpages)
 {
 	assert("edward-1057", clust->pages != NULL);
 	memset(clust->pages, 0, sizeof(*clust->pages) * nrpages);
 	return 0;
 }
 
-static inline int alloc_cluster_pgset(reiser4_cluster_t * clust, int nrpages)
+static inline int alloc_cluster_pgset(struct cluster_handle * clust,
+				      int nrpages)
 {
 	assert("edward-949", clust != NULL);
 	assert("edward-1362", clust->pages == NULL);
@@ -415,14 +418,14 @@ static inline int alloc_cluster_pgset(re
 	return 0;
 }
 
-static inline void free_cluster_pgset(reiser4_cluster_t * clust)
+static inline void free_cluster_pgset(struct cluster_handle * clust)
 {
 	assert("edward-951", clust->pages != NULL);
 	kfree(clust->pages);
 	clust->pages = NULL;
 }
 
-static inline void put_cluster_handle(reiser4_cluster_t * clust)
+static inline void put_cluster_handle(struct cluster_handle * clust)
 {
 	assert("edward-435", clust != NULL);
 
@@ -432,13 +435,13 @@ static inline void put_cluster_handle(re
 	memset(clust, 0, sizeof *clust);
 }
 
-static inline void inc_keyload_count(crypto_stat_t * data)
+static inline void inc_keyload_count(struct reiser4_crypto_info * data)
 {
  	assert("edward-1410", data != NULL);
  	data->keyload_count++;
 }
 
-static inline void dec_keyload_count(crypto_stat_t * data)
+static inline void dec_keyload_count(struct reiser4_crypto_info * data)
 {
  	assert("edward-1411", data != NULL);
  	assert("edward-1412", data->keyload_count > 0);
@@ -446,8 +449,8 @@ static inline void dec_keyload_count(cry
 }
 
 /* cryptcompress specific part of reiser4_inode */
-typedef struct cryptcompress_info {
-	crypto_stat_t *crypt;
+struct cryptcompress_info {
+	struct reiser4_crypto_info *crypt;
 	/* the following 2 fields are controlled by compression mode plugin */
 	int compress_toggle; /* current status of compressibility */
 	int lattice_factor;  /* factor of dynamic lattice. FIXME: Have a
@@ -455,86 +458,87 @@ typedef struct cryptcompress_info {
 #if REISER4_DEBUG
 	int pgcount;              /* number of captured pages */
 #endif
-} cryptcompress_info_t;
+};
 
-static inline void set_compression_toggle (cryptcompress_info_t * info, int val)
+static inline void set_compression_toggle (struct cryptcompress_info * info, int val)
 {
 	info->compress_toggle = val;
 }
 
-static inline int get_compression_toggle (cryptcompress_info_t * info)
+static inline int get_compression_toggle (struct cryptcompress_info * info)
 {
 	return info->compress_toggle;
 }
 
-static inline int compression_is_on(cryptcompress_info_t * info)
+static inline int compression_is_on(struct cryptcompress_info * info)
 {
 	return get_compression_toggle(info) == 1;
 }
 
-static inline void turn_on_compression(cryptcompress_info_t * info)
+static inline void turn_on_compression(struct cryptcompress_info * info)
 {
 	set_compression_toggle(info, 1);
 }
 
-static inline void turn_off_compression(cryptcompress_info_t * info)
+static inline void turn_off_compression(struct cryptcompress_info * info)
 {
 	set_compression_toggle(info, 0);
 }
 
-static inline void set_lattice_factor(cryptcompress_info_t * info, int val)
+static inline void set_lattice_factor(struct cryptcompress_info * info, int val)
 {
 	info->lattice_factor = val;
 }
 
-static inline int get_lattice_factor(cryptcompress_info_t * info)
+static inline int get_lattice_factor(struct cryptcompress_info * info)
 {
 	return info->lattice_factor;
 }
 
-cryptcompress_info_t *cryptcompress_inode_data(const struct inode *);
+struct cryptcompress_info *cryptcompress_inode_data(const struct inode *);
 int equal_to_rdk(znode *, const reiser4_key *);
 int goto_right_neighbor(coord_t *, lock_handle *);
 int cryptcompress_inode_ok(struct inode *inode);
 int coord_is_unprepped_ctail(const coord_t * coord);
-extern int ctail_read_disk_cluster (reiser4_cluster_t *, struct inode *,
+extern int ctail_read_disk_cluster (struct cluster_handle *, struct inode *,
 				    znode_lock_mode mode);
-extern int do_readpage_ctail(struct inode *, reiser4_cluster_t *,
+extern int do_readpage_ctail(struct inode *, struct cluster_handle *,
 			     struct page * page, znode_lock_mode mode);
-extern int ctail_insert_unprepped_cluster(reiser4_cluster_t * clust,
+extern int ctail_insert_unprepped_cluster(struct cluster_handle * clust,
 					  struct inode * inode);
 extern int readpages_cryptcompress(struct file*, struct address_space*,
 				   struct list_head*, unsigned);
 int bind_cryptcompress(struct inode *child, struct inode *parent);
 void destroy_inode_cryptcompress(struct inode * inode);
-int grab_cluster_pages(struct inode *inode, reiser4_cluster_t * clust);
+int grab_cluster_pages(struct inode *inode, struct cluster_handle * clust);
 int write_conversion_hook(struct file *file, struct inode * inode, loff_t pos,
- 			  reiser4_cluster_t * clust, int * progress);
-crypto_stat_t * inode_crypto_stat (struct inode * inode);
-void inherit_crypto_stat_common(struct inode * parent, struct inode * object,
+ 			  struct cluster_handle * clust, int * progress);
+struct reiser4_crypto_info * inode_crypto_info(struct inode * inode);
+void inherit_crypto_info_common(struct inode * parent, struct inode * object,
 				int (*can_inherit)(struct inode * child,
 						   struct inode * parent));
-void reiser4_attach_crypto_stat(struct inode * inode, crypto_stat_t * info);
-void change_crypto_stat(struct inode * inode, crypto_stat_t * new);
-crypto_stat_t * reiser4_alloc_crypto_stat (struct inode * inode);
+void reiser4_attach_crypto_info(struct inode * inode,
+				struct reiser4_crypto_info * info);
+void change_crypto_info(struct inode * inode, struct reiser4_crypto_info * new);
+struct reiser4_crypto_info * reiser4_alloc_crypto_info (struct inode * inode);
 
-static inline struct crypto_blkcipher * info_get_cipher(crypto_stat_t * info)
+static inline struct crypto_blkcipher * info_get_cipher(struct reiser4_crypto_info * info)
 {
 	return info->cipher;
 }
 
-static inline void info_set_cipher(crypto_stat_t * info,
+static inline void info_set_cipher(struct reiser4_crypto_info * info,
 				   struct crypto_blkcipher * tfm)
 {
 	info->cipher = tfm;
 }
 
-static inline struct crypto_hash * info_get_digest(crypto_stat_t * info)
+static inline struct crypto_hash * info_get_digest(struct reiser4_crypto_info * info)
 {
 	return info->digest;
 }
 
-static inline void info_set_digest(crypto_stat_t * info,
+static inline void info_set_digest(struct reiser4_crypto_info * info,
 				   struct crypto_hash * tfm)
 {
 	info->digest = tfm;
diff -puN fs/reiser4/plugin/file/file.c~reiser4-remove-typedefs fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-remove-typedefs
+++ a/fs/reiser4/plugin/file/file.c
@@ -24,7 +24,7 @@
 
 
 static int unpack(struct file *file, struct inode *inode, int forever);
-static void drop_access(unix_file_info_t *);
+static void drop_access(struct unix_file_info *);
 static int hint_validate(hint_t * hint, const reiser4_key * key, int check_key,
 			 znode_lock_mode lock_mode);
 
@@ -32,7 +32,7 @@ static int hint_validate(hint_t * hint, 
  * converted (It may happen that another process is doing tail
  * conversion. If so, wait until it completes)
  */
-static inline void get_exclusive_access_careful(unix_file_info_t * uf_info,
+static inline void get_exclusive_access_careful(struct unix_file_info * uf_info,
 						struct inode *inode)
 {
         do {
@@ -45,7 +45,7 @@ static inline void get_exclusive_access_
 }
 
 /* get unix file plugin specific portion of inode */
-unix_file_info_t *unix_file_inode_data(const struct inode *inode)
+struct unix_file_info *unix_file_inode_data(const struct inode *inode)
 {
 	return &reiser4_inode_data(inode)->file_plugin_data.unix_file_info;
 }
@@ -184,7 +184,7 @@ int goto_right_neighbor(coord_t *coord, 
  * This is to be used by find_file_item and in find_file_state to
  * determine real state of file
  */
-static void set_file_state(unix_file_info_t *uf_info, int cbk_result,
+static void set_file_state(struct unix_file_info *uf_info, int cbk_result,
 			   tree_level level)
 {
 	if (cbk_errored(cbk_result))
@@ -308,7 +308,7 @@ void hint_init_zero(hint_t * hint)
 	hint->ext_coord.lh = &hint->lh;
 }
 
-static int find_file_state(struct inode *inode, unix_file_info_t *uf_info)
+static int find_file_state(struct inode *inode, struct unix_file_info *uf_info)
 {
 	int result;
 	reiser4_key key;
@@ -449,7 +449,7 @@ static int shorten_file(struct inode *in
 	struct page *page;
 	int padd_from;
 	unsigned long index;
-	unix_file_info_t *uf_info;
+	struct unix_file_info *uf_info;
 
 	/*
 	 * all items of ordinary reiser4 file are grouped together. That is why
@@ -554,7 +554,7 @@ static int shorten_file(struct inode *in
  * Calls formatting plugin to see whether file of size @new_size has to be
  * stored in unformatted nodes or in tail items. 0 is returned for later case.
  */
-static int should_have_notail(const unix_file_info_t *uf_info, loff_t new_size)
+static int should_have_notail(const struct unix_file_info *uf_info, loff_t new_size)
 {
 	if (!uf_info->tplug)
 		return 1;
@@ -580,7 +580,7 @@ static int truncate_file_body(struct ino
 		/* expanding truncate */
 		struct dentry dentry;
 		struct file file;
-		unix_file_info_t *uf_info;
+		struct unix_file_info *uf_info;
 
 		dentry.d_inode = inode;
 		file.f_dentry = &dentry;
@@ -1175,7 +1175,7 @@ static int sync_page_list(struct inode *
 static int commit_file_atoms(struct inode *inode)
 {
 	int result;
-	unix_file_info_t *uf_info;
+	struct unix_file_info *uf_info;
 
 	uf_info = unix_file_inode_data(inode);
 
@@ -1251,7 +1251,7 @@ int writepages_unix_file(struct address_
 		     struct writeback_control *wbc)
 {
 	int result;
-	unix_file_info_t *uf_info;
+	struct unix_file_info *uf_info;
 	pgoff_t pindex, jindex, nr_pages;
 	long to_capture;
 	struct inode *inode;
@@ -1796,7 +1796,7 @@ ssize_t read_unix_file(struct file *file
 	reiser4_context *ctx;
 	ssize_t result;
 	struct inode *inode;
-	unix_file_info_t *uf_info;
+	struct unix_file_info *uf_info;
 
 	if (unlikely(read_amount == 0))
 		return 0;
@@ -1844,7 +1844,7 @@ static ssize_t read_unix_file_container_
 	int result;
 	struct inode *inode;
 	hint_t *hint;
-	unix_file_info_t *uf_info;
+	struct unix_file_info *uf_info;
 	size_t count, read, left;
 	loff_t size;
 
@@ -1935,7 +1935,7 @@ int mmap_unix_file(struct file *file, st
 	reiser4_context *ctx;
 	int result;
 	struct inode *inode;
-	unix_file_info_t *uf_info;
+	struct unix_file_info *uf_info;
 	reiser4_block_nr needed;
 
 	inode = file->f_dentry->d_inode;
@@ -2047,7 +2047,7 @@ int open_unix_file(struct inode *inode, 
 {
 	int result;
 	reiser4_context *ctx;
-	unix_file_info_t *uf_info;
+	struct unix_file_info *uf_info;
 
 	if (IS_RDONLY(inode))
 		return 0;
@@ -2106,7 +2106,7 @@ int open_unix_file(struct inode *inode, 
 #define EA_OBTAINED 1
 #define NEA_OBTAINED 2
 
-static void drop_access(unix_file_info_t *uf_info)
+static void drop_access(struct unix_file_info *uf_info)
 {
 	if (uf_info->exclusive_use)
 		drop_exclusive_access(uf_info);
@@ -2133,7 +2133,7 @@ ssize_t write_unix_file(struct file *fil
 	int result;
 	reiser4_context *ctx;
 	struct inode *inode;
-	unix_file_info_t *uf_info;
+	struct unix_file_info *uf_info;
 	ssize_t written;
 	int try_free_space;
 	int to_write = PAGE_CACHE_SIZE * WRITE_GRANULARITY;
@@ -2350,7 +2350,7 @@ ssize_t write_unix_file(struct file *fil
 int release_unix_file(struct inode *inode, struct file *file)
 {
 	reiser4_context *ctx;
-	unix_file_info_t *uf_info;
+	struct unix_file_info *uf_info;
 	int result;
 	int in_reiser4;
 
@@ -2431,7 +2431,7 @@ static void set_file_notail(struct inode
 static int unpack(struct file *filp, struct inode *inode, int forever)
 {
 	int result = 0;
-	unix_file_info_t *uf_info;
+	struct unix_file_info *uf_info;
 
 	uf_info = unix_file_inode_data(inode);
 	assert("vs-1628", ea_obtained(uf_info));
@@ -2664,7 +2664,7 @@ int setattr_unix_file(struct dentry *den
 
 	if (attr->ia_valid & ATTR_SIZE) {
 		reiser4_context *ctx;
-		unix_file_info_t *uf_info;
+		struct unix_file_info *uf_info;
 
 		/* truncate does reservation itself and requires exclusive
 		   access obtained */
@@ -2689,7 +2689,7 @@ void
 init_inode_data_unix_file(struct inode *inode,
 			  reiser4_object_create_data * crd, int create)
 {
-	unix_file_info_t *data;
+	struct unix_file_info *data;
 
 	data = unix_file_inode_data(inode);
 	data->container = create ? UF_CONTAINER_EMPTY : UF_CONTAINER_UNKNOWN;
@@ -2712,7 +2712,7 @@ init_inode_data_unix_file(struct inode *
  */
 int delete_object_unix_file(struct inode *inode)
 {
-	unix_file_info_t *uf_info;
+	struct unix_file_info *uf_info;
 	int result;
 
 	if (reiser4_inode_get_flag(inode, REISER4_NO_SD))
@@ -2750,7 +2750,7 @@ sendfile_unix_file(struct file *file, lo
 	reiser4_context *ctx;
 	ssize_t result;
 	struct inode *inode;
-	unix_file_info_t *uf_info;
+	struct unix_file_info *uf_info;
 
 	inode = file->f_dentry->d_inode;
 	ctx = reiser4_init_context(inode->i_sb);
@@ -2783,7 +2783,7 @@ prepare_write_unix_file(struct file *fil
 			unsigned from, unsigned to)
 {
 	reiser4_context *ctx;
-	unix_file_info_t *uf_info;
+	struct unix_file_info *uf_info;
 	int ret;
 
 	ctx = reiser4_init_context(file->f_dentry->d_inode->i_sb);
diff -puN fs/reiser4/plugin/file/file.h~reiser4-remove-typedefs fs/reiser4/plugin/file/file.h
--- a/fs/reiser4/plugin/file/file.h~reiser4-remove-typedefs
+++ a/fs/reiser4/plugin/file/file.h
@@ -68,7 +68,7 @@ struct formatting_plugin;
 struct inode;
 
 /* unix file plugin specific part of reiser4 inode */
-typedef struct unix_file_info {
+struct unix_file_info {
 	/*
 	 * this read-write lock protects file containerization change. Accesses
 	 * which do not change file containerization (see file_container_t)
@@ -93,14 +93,14 @@ typedef struct unix_file_info {
 	atomic_t nr_neas;
 	void *last_reader;
 #endif
-} unix_file_info_t;
+};
 
 struct unix_file_info *unix_file_inode_data(const struct inode *inode);
-void get_exclusive_access(unix_file_info_t *);
-void drop_exclusive_access(unix_file_info_t *);
-void get_nonexclusive_access(unix_file_info_t *);
-void drop_nonexclusive_access(unix_file_info_t *);
-int try_to_get_nonexclusive_access(unix_file_info_t *);
+void get_exclusive_access(struct unix_file_info *);
+void drop_exclusive_access(struct unix_file_info *);
+void get_nonexclusive_access(struct unix_file_info *);
+void drop_nonexclusive_access(struct unix_file_info *);
+int try_to_get_nonexclusive_access(struct unix_file_info *);
 int find_file_item(hint_t *, const reiser4_key *, znode_lock_mode,
 		   struct inode *);
 int find_file_item_nohint(coord_t *, lock_handle *,
@@ -119,9 +119,9 @@ struct uf_coord {
 	lock_handle *lh;
 	int valid;
 	union {
-		extent_coord_extension_t extent;
-		tail_coord_extension_t tail;
-		ctail_coord_extension_t ctail;
+		struct extent_coord_extension extent;
+		struct tail_coord_extension tail;
+		struct ctail_coord_extension ctail;
 	} extension;
 };
 
@@ -173,7 +173,7 @@ int cut_file_items(struct inode *, loff_
 #if REISER4_DEBUG
 
 /* return 1 is exclusive access is obtained, 0 - otherwise */
-static inline int ea_obtained(unix_file_info_t * uf_info)
+static inline int ea_obtained(struct unix_file_info * uf_info)
 {
 	int ret;
 
@@ -242,8 +242,8 @@ extern reiser4_plugin_ops cryptcompress_
 
 #define WRITE_GRANULARITY 32
 
-int tail2extent(unix_file_info_t *);
-int extent2tail(unix_file_info_t *);
+int tail2extent(struct unix_file_info *);
+int extent2tail(struct unix_file_info *);
 
 int goto_right_neighbor(coord_t *, lock_handle *);
 int find_or_create_extent(struct page *);
diff -puN fs/reiser4/plugin/file/file_conversion.c~reiser4-remove-typedefs fs/reiser4/plugin/file/file_conversion.c
--- a/fs/reiser4/plugin/file/file_conversion.c~reiser4-remove-typedefs
+++ a/fs/reiser4/plugin/file/file_conversion.c
@@ -120,7 +120,7 @@ static int __cryptcompress2unixfile(stru
 {
 	int result;
 	reiser4_inode *info;
-	unix_file_info_t * uf;
+	struct unix_file_info * uf;
 	info = reiser4_inode_data(inode);
 
 	result = aset_set_unsafe(&info->pset,
@@ -202,7 +202,7 @@ static int disable_conversion(struct ino
 
 static int check_position(struct inode * inode,
 			  loff_t pos /* initial position in the file */,
-			  reiser4_cluster_t * clust,
+			  struct cluster_handle * clust,
 			  int * check_compress)
 {
 	assert("edward-1505", conversion_enabled(inode));
@@ -220,7 +220,7 @@ static int check_position(struct inode *
 }
 
 static void start_check_compressibility(struct inode * inode,
-					reiser4_cluster_t * clust,
+					struct cluster_handle * clust,
 					hint_t * hint)
 {
 	assert("edward-1507", clust->index == 1);
@@ -238,7 +238,7 @@ static void start_check_compressibility(
 }
 
 static void finish_check_compressibility(struct inode * inode,
-					 reiser4_cluster_t * clust,
+					 struct cluster_handle * clust,
 					 hint_t * hint)
 {
 	reiser4_unset_hint(clust->hint);
@@ -269,7 +269,7 @@ static int prepped_dclust_ok(hint_t * hi
    Read first logical cluster (of index #0) and estimate its compressibility.
    Save estimation result in @compressible */
 static int read_check_compressibility(struct inode * inode,
-				      reiser4_cluster_t * clust,
+				      struct cluster_handle * clust,
 				      int * compressible)
 {
 	int i;
@@ -307,7 +307,7 @@ static int read_check_compressibility(st
 		dst_len = dclust_get_extension_dsize(&tmp_hint);
 	}
 	else {
-		tfm_cluster_t * tc = &clust->tc;
+		struct tfm_cluster * tc = &clust->tc;
 		compression_plugin * cplug = inode_compression_plugin(inode);
 		result = grab_tfm_stream(inode, tc, INPUT_STREAM);
 		if (result)
@@ -418,13 +418,13 @@ static int complete_file_conversion(stru
 
 
 /* do conversion */
-static int cryptcompress2unixfile(struct file *file, struct inode * inode,
-				  reiser4_cluster_t * clust)
+static int cryptcompress2unixfile(struct file * file, struct inode * inode,
+				  struct cluster_handle * clust)
 {
 	int i;
 	int result = 0;
-	cryptcompress_info_t *cr_info;
-	unix_file_info_t *uf_info;
+	struct cryptcompress_info *cr_info;
+	struct unix_file_info *uf_info;
 
 	assert("edward-1516", clust->pages[0]->index == 0);
 	assert("edward-1517", clust->hint != NULL);
@@ -474,8 +474,8 @@ static int cryptcompress2unixfile(struct
 }
 
 /* Check, then perform or disable conversion if needed */
-int write_conversion_hook(struct file *file, struct inode * inode, loff_t pos,
-			  reiser4_cluster_t * clust, int * progress)
+int write_conversion_hook(struct file * file, struct inode * inode, loff_t pos,
+			  struct cluster_handle * clust, int * progress)
 {
 	int result;
 	int check_compress = 0;
diff -puN fs/reiser4/plugin/file/invert.c~reiser4-remove-typedefs /dev/null
--- a/fs/reiser4/plugin/file/invert.c
+++ /dev/null
@@ -1,493 +0,0 @@
-/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
-
-/* Suppose you want to conveniently read and write a large variety of small files conveniently within a single emacs
-   buffer, without having a separate buffer for each 8 byte or so file.  Inverts are the way to do that.  An invert
-   provides you with the contents of a set of subfiles plus its own contents.  It is a file which inherits other files
-   when you read it, and allows you to write to it and through it to the files that it inherits from.  In order for it
-   to know which subfiles each part of your write should go into, there must be delimiters indicating that.  It tries to
-   make that easy for you by providing those delimiters in what you read from it.
-
-  When you read it, an invert performs an inverted assignment.  Instead of taking an assignment command and writing a
-  bunch of files, it takes a bunch of files and composes an assignment command for you to read from it that if executed
-  would create those files.  But which files?  Well, that must be specified in the body of the invert using a special
-  syntax, and that specification is called the invert of the assignment.
-
-  When written to, an invert performs the assignment command that is written
-  to it, and modifies its own body to contain the invert of that
-  assignment.
-
-  In other words, writing to an invert file what you have read from it
-  is the identity operation.
-
-  Malformed assignments cause write errors.  Partial writes are not
-  supported in v4.0, but will be.
-
-  Example:
-
-    If an invert contains:
-
-    /filenameA/<>+"(some text stored in the invert)+/filenameB/<>
-
-======================
-Each element in this definition should be an invert, and all files
-should be called recursively - too.  This is bad. If one of the
-included files in not a regular or invert file, then we can't read
-main file.
-
-I think to make it is possible easier:
-
-internal structure of invert file should be like symlink file. But
-read and write method should be explitely indicated in i/o operation..
-
-By default we read and write (if probably) as symlink and if we
-specify ..invert at reading time that too we can specify it at write time.
-
-example:
-/my_invert_file/..invert<- ( (/filenameA<-"(The contents of filenameA))+"(some text stored in the invert)+(/filenameB<-"(The contents of filenameB) ) )
-will create  /my_invert_file as invert, and will creat /filenameA and /filenameB with specified body.
-
-read of /my_invert_file/..invert will be
-/filenameA<-"(The contents of filenameA)+"(some text stored in the invert)+/filenameB<-"(The contents of filenameB)
-
-but read of /my_invert_file/ will be
-The contents of filenameAsome text stored in the invertThe contents of filenameB
-
-we also can creat this file as
-/my_invert_file/<-/filenameA+"(some text stored in the invert)+/filenameB
-will create  /my_invert_file , and use existing files /filenameA and /filenameB.
-
-and when we will read it will be as previously invert file.
-
-This is correct?
-
- vv
-DEMIDOV-FIXME-HANS:
-
-Maybe you are right, but then you must disable writes to /my_invert_file/ and only allow writes to /my_invert_file/..invert
-
-Do you agree?  Discuss it on reiserfs-list....
-
--Hans
-=======================
-
-  Then a read will return:
-
-    /filenameA<-"(The contents of filenameA)+"(some text stored in the invert)+/filenameB<-"(The contents of filenameB)
-
-    and a write of the line above to the invert will set the contents of
-    the invert and filenameA and filenameB to their original values.
-
-  Note that the contents of an invert have no influence on the effect
-  of a write unless the write is a partial write (and a write of a
-  shorter file without using truncate first is a partial write).
-
-  truncate() has no effect on filenameA and filenameB, it merely
-  resets the value of the invert.
-
-  Writes to subfiles via the invert are implemented by preceding them
-  with truncates.
-
-  Parse failures cause write failures.
-
-  Questions to ponder: should the invert be acted on prior to file
-  close when writing to an open filedescriptor?
-
- Example:
-
- If an invert contains:
-
-   "(This text and a pair of quotes are all that is here.)
-
-Then a read will return:
-
-   "(This text and a pair of quotes are all that is here.)
-
-*/
-
-/* OPEN method places a struct file in memory associated with invert body
-  and returns something like file descriptor to the user for the future access
-  to the invert file.
-  During opening we parse the body of invert and get a list of the 'entryes'
-  (that describes all its subfiles) and place pointer on the first struct in
-  reiserfs-specific part of invert inode (arbitrary decision).
-
-  Each subfile is described by the struct inv_entry that has a pointer @sd on
-  in-core based stat-data and  a pointer on struct file @f (if we find that the
-  subfile uses more then one unformated node (arbitrary decision), we load
-  struct file in memory, otherwise we load base stat-data (and maybe 1-2 bytes
-  of some other information we need)
-
-  Since READ and WRITE methods for inverts were formulated in assignment
-  language, they don't contain arguments 'size' and 'offset' that make sense
-  only in ordinary read/write methods.
-
-  READ method is a combination of two methods:
-  1) ordinary read method (with offset=0, lenght = @f->...->i_size) for entries
-  with @f != 0, this method uses pointer on struct file as an argument
-  2) read method for inode-less files with @sd != 0, this method uses
-  in-core based stat-data instead struct file as an argument.
-  in the first case we don't use pagecache, just copy data that we got after
-  cbk() into userspace.
-
-  WRITE method for invert files is more complex.
-  Besides declared WRITE-interface in assignment languageb above we need
-  to have an opportunity to edit unwrapped body of invert file with some
-  text editor, it means we need GENERIC WRITE METHOD for invert file:
-
-  my_invert_file/..invert <- "string"
-
-  this method parses "string" and looks for correct subfile signatures, also
-  the parsing process splits this "string" on the set of flows in  accordance
-  with the set of subfiles specified by this signarure.
-  The found list of signatures #S is compared with the opened one #I of invert
-  file. If it doesn't have this one (#I==0, it will be so for instance if we
-  have just create this invert file) the write method assignes found signature
-  (#I=#S;) to the invert file. Then if #I==#S, generic write method splits
-  itself to the some write methods for ordinary or light-weight, or call itself
-  recursively for invert files with corresponding flows.
-  I am not sure, but the list of signatures looks like what mr.Demidov means
-  by 'delimiters'.
-
-  The cases when #S<#I (#I<#S) (in the sense of set-theory) are also available
-  and cause delete (create new) subfiles (arbitrary decision - it may looks
-  too complex, but this interface will be the completest). The order of entries
-  of list #S (#I) and inherited order on #I (#S) must coincide.
-  The other parsing results give malformed signature that aborts READ method
-  and releases all resources.
-
-  Format of subfile (entry) signature:
-
-  "START_MAGIC"<>(TYPE="...",LOOKUP_ARG="...")SUBFILE_BODY"END_MAGIC"
-
-  Legend:
-
-    START_MAGIC - keyword indicates the start of subfile signature;
-
-    <> indicates the start of 'subfile metadata', that is the pair
-  (TYPE="...",LOOKUP_ARG="...") in parenthesis separated by comma.
-
-    TYPE - the string "type" indicates the start of one of the three words:
-  - ORDINARY_FILE,
-  - LIGHT_WEIGHT_FILE,
-  - INVERT_FILE;
-
-    LOOKUP_ARG - lookup argument depends on previous type:
-  */
-
- /************************************************************/
- /*       TYPE        *          LOOKUP ARGUMENT             */
- /************************************************************/
- /* LIGH_WEIGHT_FILE  *           stat-data key              */
- /************************************************************/
- /*   ORDINARY_FILE   *             filename                 */
- /************************************************************/
- /*   INVERT_FILE     *             filename                 */
- /************************************************************/
-
- /* where:
-  *stat-data key - the string contains stat data key of this subfile, it will be
-  passed to fast-access lookup method for light-weight files;
-  *filename - pathname of this subfile, iyt well be passed to VFS lookup methods
-  for ordinary and invert files;
-
-  SUBFILE_BODY - data of this subfile (it will go to the flow)
-  END_MAGIC - the keyword indicates the end of subfile signature.
-
-  The other simbols inside the signature interpreted as 'unformatted content',
-  which is available with VFS's read_link() (arbitraruy decision).
-
-  NOTE: Parse method for a body of invert file uses mentioned signatures _without_
-  subfile bodies.
-
-  Now the only unclear thing is WRITE in regular light-weight subfile A that we
-  can describe only in  assignment language:
-
-  A <- "some_string"
-
-  I guess we don't want to change stat-data and body items of file A
-  if this file exist, and size(A) != size("some_string") because this operation is
-  expencive, so we only do the partial write if size(A) > size("some_string")
-  and do truncate of the "some_string", and then do A <- "truncated string", if
-  size(A) < size("some_string"). This decision is also arbitrary..
-  */
-
-/* here is infrastructure for formated flows */
-
-#define SUBFILE_HEADER_MAGIC 0x19196605
-#define FLOW_HEADER_MAGIC 0x01194304
-
-#include "../plugin.h"
-#include "../../debug.h"
-#include "../../forward.h"
-#include "../object.h"
-#include "../item/item.h"
-#include "../item/static_stat.h"
-#include "../../dformat.h"
-#include "../znode.h"
-#include "../inode.h"
-
-#include <linux/types.h>
-#include <linux/fs.h>		/* for struct file  */
-#include <linux/list.h>		/* for struct list_head */
-
-typedef enum {
-	LIGHT_WEIGHT_FILE,
-	ORDINARY_FILE,
-	INVERT_FILE
-} inv_entry_type;
-
-typedef struct flow_header {
-	d32 fl_magic;
-	d16 fl_nr;		/* number of subfiles in the flow */
-};
-
-typedef struct subfile_header {
-	d32 sh_magic;		/* subfile magic */
-	d16 sh_type;		/* type of subfile: light-weight, ordinary, invert */
-	d16 sh_arg_len;		/* lenght of lookup argument (filename, key) */
-	d32 sh_body_len;	/* lenght of subfile body */
-};
-
-/* functions to get/set fields of flow header */
-
-static void fl_set_magic(flow_header * fh, __u32 value)
-{
-	cputod32(value, &fh->fh_magic);
-}
-
-static __u32 fl_get_magic(flow_header * fh)
-{
-	return d32tocpu(&fh->fh_magic);
-}
-static void fl_set_number(flow_header * fh, __u16 value)
-{
-	cputod16(value, &fh->fh_nr);
-}
-static unsigned fl_get_number(flow_header * fh)
-{
-	return d16tocpu(&fh->fh_nr);
-}
-
-/* functions to get/set fields of subfile header */
-
-static void sh_set_magic(subfile_header * sh, __u32 value)
-{
-	cputod32(value, &sh->sh_magic);
-}
-
-static __u32 sh_get_magic(subfile_header * sh)
-{
-	return d32tocpu(&sh->sh_magic);
-}
-static void sh_set_type(subfile_header * sh, __u16 value)
-{
-	cputod16(value, &sh->sh_magic);
-}
-static unsigned sh_get_type(subfile_header * sh)
-{
-	return d16tocpu(&sh->sh_magic);
-}
-static void sh_set_arg_len(subfile_header * sh, __u16 value)
-{
-	cputod16(value, &sh->sh_arg_len);
-}
-static unsigned sh_get_arg_len(subfile_header * sh)
-{
-	return d16tocpu(&sh->sh_arg_len);
-}
-static void sh_set_body_len(subfile_header * sh, __u32 value)
-{
-	cputod32(value, &sh->sh_body_len);
-}
-
-static __u32 sh_get_body_len(subfile_header * sh)
-{
-	return d32tocpu(&sh->sh_body_len);
-}
-
-/* in-core minimal stat-data, light-weight analog of inode */
-
-struct incore_sd_base {
-	umode_t isd_mode;
-	nlink_t isd_nlink;
-	loff_t isd_size;
-	char *isd_data;		/* 'subflow' to write */
-};
-
-/* open invert create a list of invert entries,
-   every entry is represented by structure inv_entry */
-
-struct inv_entry {
-	struct list_head *ie_list;
-	struct file *ie_file;	/* this is NULL if the file doesn't
-				   have unformated nodes */
-	struct incore_sd_base *ie_sd;	/* inode-less analog of struct file */
-};
-
-/* allocate and init invert entry */
-
-static struct inv_entry *allocate_inv_entry(void)
-{
-	struct inv_entry *inv_entry;
-
-	inv_entry = reiser4_kmalloc(sizeof(struct inv_entry), GFP_KERNEL);
-	if (!inv_entry)
-		return ERR_PTR(RETERR(-ENOMEM));
-	inv_entry->ie_file = NULL;
-	inv_entry->ie_sd = NULL;
-	INIT_LIST_HEAD(&inv_entry->ie_list);
-	return inv_entry;
-}
-
-static int put_inv_entry(struct inv_entry *ientry)
-{
-	int result = 0;
-
-	assert("edward-96", ientry != NULL);
-	assert("edward-97", ientry->ie_list != NULL);
-
-	list_del(ientry->ie_list);
-	if (ientry->ie_sd != NULL) {
-		kfree(ientry->ie_sd);
-		kfree(ientry);
-	}
-	if (ientry->ie_file != NULL)
-		result = filp_close(ientry->file, NULL);
-	return result;
-}
-
-static int allocate_incore_sd_base(struct inv_entry *inv_entry)
-{
-	struct incore_sd_base *isd_base assert("edward-98", inv_entry != NULL);
-	assert("edward-99", inv_entry->ie_inode = NULL);
-	assert("edward-100", inv_entry->ie_sd = NULL);
-
-	isd_base = reiser4_kmalloc(sizeof(struct incore_sd_base), GFP_KERNEL);
-	if (!isd_base)
-		return RETERR(-ENOMEM);
-	inv_entry->ie_sd = isd_base;
-	return 0;
-}
-
-/* this can be installed as ->init_inv_entry () method of
-   item_plugins[ STATIC_STAT_DATA_IT ] (fs/reiser4/plugin/item/item.c).
-   Copies data from on-disk stat-data format into light-weight analog of inode .
-   Doesn't hanlde stat-data extensions. */
-
-static void sd_base_load(struct inv_entry *inv_entry, char *sd)
-{
-	reiser4_stat_data_base *sd_base;
-
-	assert("edward-101", inv_entry != NULL);
-	assert("edward-101", inv_entry->ie_sd != NULL);
-	assert("edward-102", sd != NULL);
-
-	sd_base = (reiser4_stat_data_base *) sd;
-	inv_entry->incore_sd_base->isd_mode = d16tocpu(&sd_base->mode);
-	inv_entry->incore_sd_base->isd_nlink = d32tocpu(&sd_base->nlink);
-	inv_entry->incore_sd_base->isd_size = d64tocpu(&sd_base->size);
-	inv_entry->incore_sd_base->isd_data = NULL;
-}
-
-/* initialise incore stat-data */
-
-static void init_incore_sd_base(struct inv_entry *inv_entry, coord_t * coord)
-{
-	reiser4_plugin *plugin = item_plugin_by_coord(coord);
-	void *body = item_body_by_coord(coord);
-
-	assert("edward-103", inv_entry != NULL);
-	assert("edward-104", plugin != NULL);
-	assert("edward-105", body != NULL);
-
-	sd_base_load(inv_entry, body);
-}
-
-/* takes a key or filename and allocates new invert_entry,
-   init and adds it into the list,
-   we use lookup_sd_by_key() for light-weight files and VFS lookup by filename */
-
-int get_inv_entry(struct inode *invert_inode,	/* inode of invert's body */
-		  inv_entry_type type,	/* LIGHT-WEIGHT or ORDINARY */
-		  const reiser4_key * key,	/* key of invert entry stat-data */
-		  char *filename,	/* filename of the file to be opened */
-		  int flags, int mode)
-{
-	int result;
-	struct inv_entry *ientry;
-
-	assert("edward-107", invert_inode != NULL);
-
-	ientry = allocate_inv_entry();
-	if (IS_ERR(ientry))
-		return (PTR_ERR(ientry));
-
-	if (type == LIGHT_WEIGHT_FILE) {
-		coord_t coord;
-		lock_handle lh;
-
-		assert("edward-108", key != NULL);
-
-		init_coord(&coord);
-		init_lh(&lh);
-		result =
-			lookup_sd_by_key(reiser4_tree_by_inode(invert_inode),
-					 ZNODE_READ_LOCK, &coord, &lh, key);
-		if (result == 0)
-			init_incore_sd_base(ientry, coord);
-
-		done_lh(&lh);
-		done_coord(&coord);
-		return (result);
-	} else {
-		struct file *file = filp_open(filename, flags, mode);
-		/* FIXME_EDWARD here we need to check if we
-		   did't follow to any mount point */
-
-		assert("edward-108", filename != NULL);
-
-		if (IS_ERR(file))
-			return (PTR_ERR(file));
-		ientry->ie_file = file;
-		return 0;
-	}
-}
-
-/* takes inode of invert, reads the body of this invert, parses it,
-   opens all invert entries and return pointer on the first inv_entry */
-
-struct inv_entry *open_invert(struct file *invert_file)
-{
-
-}
-
-ssize_t subfile_read(struct *invert_entry, flow * f)
-{
-
-}
-
-ssize_t subfile_write(struct *invert_entry, flow * f)
-{
-
-}
-
-ssize_t invert_read(struct *file, flow * f)
-{
-
-}
-
-ssize_t invert_write(struct *file, flow * f)
-{
-
-}
-
-/* Make Linus happy.
-   Local variables:
-   c-indentation-style: "K&R"
-   mode-name: "LC"
-   c-basic-offset: 8
-   tab-width: 8
-   fill-column: 120
-   scroll-step: 1
-   End:
-*/
diff -puN fs/reiser4/plugin/file/tail_conversion.c~reiser4-remove-typedefs fs/reiser4/plugin/file/tail_conversion.c
--- a/fs/reiser4/plugin/file/tail_conversion.c~reiser4-remove-typedefs
+++ a/fs/reiser4/plugin/file/tail_conversion.c
@@ -13,7 +13,7 @@
    tail2extent and extent2tail */
 
 /* exclusive access to a file is acquired when file state changes: tail2extent, empty2tail, extent2tail, etc */
-void get_exclusive_access(unix_file_info_t * uf_info)
+void get_exclusive_access(struct unix_file_info * uf_info)
 {
 	assert("nikita-3028", reiser4_schedulable());
 	assert("nikita-3047", LOCK_CNT_NIL(inode_sem_w));
@@ -33,7 +33,7 @@ void get_exclusive_access(unix_file_info
 	ON_DEBUG(uf_info->ea_owner = current);
 }
 
-void drop_exclusive_access(unix_file_info_t * uf_info)
+void drop_exclusive_access(struct unix_file_info * uf_info)
 {
 	assert("vs-1714", uf_info->ea_owner == current);
 	assert("vs-1715", atomic_read(&uf_info->nr_neas) == 0);
@@ -53,7 +53,7 @@ void drop_exclusive_access(unix_file_inf
  * This is called when nonexclisive access is obtained on file. All it does is
  * for debugging purposes.
  */
-static void nea_grabbed(unix_file_info_t *uf_info)
+static void nea_grabbed(struct unix_file_info *uf_info)
 {
 #if REISER4_DEBUG
 	LOCK_CNT_INC(inode_sem_r);
@@ -69,7 +69,7 @@ static void nea_grabbed(unix_file_info_t
  *
  * Nonexclusive access is obtained on a file before read, write, readpage.
  */
-void get_nonexclusive_access(unix_file_info_t *uf_info)
+void get_nonexclusive_access(struct unix_file_info *uf_info)
 {
 	assert("nikita-3029", reiser4_schedulable());
 	assert("nikita-3361", get_current_context()->trans->atom == NULL);
@@ -84,7 +84,7 @@ void get_nonexclusive_access(unix_file_i
  *
  * Non-blocking version of nonexclusive access obtaining.
  */
-int try_to_get_nonexclusive_access(unix_file_info_t *uf_info)
+int try_to_get_nonexclusive_access(struct unix_file_info *uf_info)
 {
 	int result;
 
@@ -94,7 +94,7 @@ int try_to_get_nonexclusive_access(unix_
 	return result;
 }
 
-void drop_nonexclusive_access(unix_file_info_t * uf_info)
+void drop_nonexclusive_access(struct unix_file_info * uf_info)
 {
 	assert("vs-1718", uf_info->ea_owner == NULL);
 	assert("vs-1719", atomic_read(&uf_info->nr_neas) > 0);
@@ -252,7 +252,7 @@ static int find_start(struct inode *inod
 	int result;
 	lock_handle lh;
 	coord_t coord;
-	unix_file_info_t *ufo;
+	struct unix_file_info *ufo;
 	int found;
 	reiser4_key key;
 
@@ -294,7 +294,7 @@ static int find_start(struct inode *inod
  *
  *
  */
-int tail2extent(unix_file_info_t *uf_info)
+int tail2extent(struct unix_file_info *uf_info)
 {
 	int result;
 	reiser4_key key;	/* key of next byte to be moved to page */
@@ -546,7 +546,7 @@ static int reserve_extent2tail_iteration
 
 /* for every page of file: read page, cut part of extent pointing to this page,
    put data of page tree by tail item */
-int extent2tail(unix_file_info_t *uf_info)
+int extent2tail(struct unix_file_info *uf_info)
 {
 	int result;
 	struct inode *inode;
diff -puN fs/reiser4/plugin/file_ops_readdir.c~reiser4-remove-typedefs fs/reiser4/plugin/file_ops_readdir.c
--- a/fs/reiser4/plugin/file_ops_readdir.c~reiser4-remove-typedefs
+++ a/fs/reiser4/plugin/file_ops_readdir.c
@@ -13,7 +13,7 @@ static int is_valid_dir_coord(struct ino
 }
 
 /* compare two logical positions within the same directory */
-static cmp_t dir_pos_cmp(const dir_pos * p1, const dir_pos * p2)
+static cmp_t dir_pos_cmp(const struct dir_pos * p1, const struct dir_pos * p2)
 {
 	cmp_t result;
 
@@ -34,10 +34,10 @@ static cmp_t dir_pos_cmp(const dir_pos *
 /* see comment before reiser4_readdir_common() for overview of why "adjustment" is
  * necessary. */
 static void
-adjust_dir_pos(struct file *dir,
-	       readdir_pos * readdir_spot, const dir_pos * mod_point, int adj)
+adjust_dir_pos(struct file *dir, struct readdir_pos * readdir_spot,
+	       const struct dir_pos * mod_point, int adj)
 {
-	dir_pos *pos;
+	struct dir_pos *pos;
 
 	/*
 	 * new directory entry was added (adj == +1) or removed (adj == -1) at
@@ -101,7 +101,7 @@ void reiser4_adjust_dir_file(struct inod
 			     int offset, int adj)
 {
 	reiser4_file_fsdata *scan;
-	dir_pos mod_point;
+	struct dir_pos mod_point;
 
 	assert("nikita-2536", dir != NULL);
 	assert("nikita-2538", de != NULL);
@@ -127,7 +127,7 @@ void reiser4_adjust_dir_file(struct inod
 /*
  * traverse tree to start/continue readdir from the readdir position @pos.
  */
-static int dir_go_to(struct file *dir, readdir_pos * pos, tap_t * tap)
+static int dir_go_to(struct file *dir, struct readdir_pos * pos, tap_t * tap)
 {
 	reiser4_key key;
 	int result;
@@ -161,7 +161,7 @@ static int dir_go_to(struct file *dir, r
  * handling of non-unique keys: calculate at what ordinal position within
  * sequence of directory items with identical keys @pos is.
  */
-static int set_pos(struct inode *inode, readdir_pos * pos, tap_t * tap)
+static int set_pos(struct inode *inode, struct readdir_pos * pos, tap_t * tap)
 {
 	int result;
 	coord_t coord;
@@ -212,7 +212,7 @@ static int set_pos(struct inode *inode, 
 /*
  * "rewind" directory to @offset, i.e., set @pos and @tap correspondingly.
  */
-static int dir_rewind(struct file *dir, readdir_pos * pos, tap_t * tap)
+static int dir_rewind(struct file *dir, struct readdir_pos * pos, tap_t * tap)
 {
 	__u64 destination;
 	__s64 shift;
@@ -295,8 +295,8 @@ static int dir_rewind(struct file *dir, 
  * unlocked.
  */
 static int
-feed_entry(struct file *f,
-	   readdir_pos * pos, tap_t * tap, filldir_t filldir, void *dirent)
+feed_entry(struct file *f, struct readdir_pos * pos, tap_t * tap,
+	   filldir_t filldir, void *dirent)
 {
 	item_plugin *iplug;
 	char *name;
@@ -368,7 +368,7 @@ feed_entry(struct file *f,
 	return result;
 }
 
-static void move_entry(readdir_pos * pos, coord_t * coord)
+static void move_entry(struct readdir_pos * pos, coord_t * coord)
 {
 	reiser4_key de_key;
 	de_id *did;
@@ -432,7 +432,8 @@ static void move_entry(readdir_pos * pos
 /*
  * prepare for readdir.
  */
-static int dir_readdir_init(struct file *f, tap_t * tap, readdir_pos ** pos)
+static int dir_readdir_init(struct file *f, tap_t * tap,
+			    struct readdir_pos ** pos)
 {
 	struct inode *inode;
 	reiser4_file_fsdata *fsdata;
@@ -493,7 +494,7 @@ loff_t reiser4_llseek_dir_common(struct 
 		coord_t coord;
 		lock_handle lh;
 		tap_t tap;
-		readdir_pos *pos;
+		struct readdir_pos *pos;
 
 		coord_init_zero(&coord);
 		init_lh(&lh);
@@ -566,7 +567,7 @@ int reiser4_readdir_common(struct file *
 	coord_t coord;
 	lock_handle lh;
 	tap_t tap;
-	readdir_pos *pos;
+	struct readdir_pos *pos;
 
 	assert("nikita-1359", f != NULL);
 	inode = f->f_dentry->d_inode;
diff -puN fs/reiser4/plugin/inode_ops_rename.c~reiser4-remove-typedefs fs/reiser4/plugin/inode_ops_rename.c
--- a/fs/reiser4/plugin/inode_ops_rename.c~reiser4-remove-typedefs
+++ a/fs/reiser4/plugin/inode_ops_rename.c
@@ -379,14 +379,14 @@ int reiser4_rename_common(struct inode *
 	struct inode *new_inode;
 	coord_t *new_coord;
 
-	reiser4_dentry_fsdata *new_fsdata;
+	struct reiser4_dentry_fsdata *new_fsdata;
 	dir_plugin *dplug;
 	file_plugin *fplug;
 
 	reiser4_dir_entry_desc *old_entry, *new_entry, *dotdot_entry;
 	lock_handle *new_lh, *dotdot_lh;
 	struct dentry *dotdot_name;
-	reiser4_dentry_fsdata *dataonstack;
+	struct reiser4_dentry_fsdata *dataonstack;
 
 	ctx = reiser4_init_context(old_dir->i_sb);
 	if (IS_ERR(ctx))
@@ -408,7 +408,7 @@ int reiser4_rename_common(struct inode *
 	new_lh = (lock_handle *)(old_entry + 3);
 	dotdot_lh = new_lh + 1;
 	dotdot_name = (struct dentry *)(new_lh + 2);
-	dataonstack = (reiser4_dentry_fsdata *)(dotdot_name + 1);
+	dataonstack = (struct reiser4_dentry_fsdata *)(dotdot_name + 1);
 
 	assert("nikita-2318", old_dir != NULL);
 	assert("nikita-2319", new_dir != NULL);
@@ -707,7 +707,7 @@ int reiser4_rename_common(struct inode *
 	reiser4_dir_entry_desc old_entry;
 	reiser4_dir_entry_desc new_entry;
 	coord_t *new_coord;
-	reiser4_dentry_fsdata *new_fsdata;
+	struct reiser4_dentry_fsdata *new_fsdata;
 	lock_handle new_lh;
 	dir_plugin *dplug;
 	file_plugin *fplug;
@@ -854,8 +854,8 @@ int reiser4_rename_common(struct inode *
 			lock_handle dotdot_lh;
 			struct dentry dotdot_name;
 			reiser4_dir_entry_desc dotdot_entry;
-			reiser4_dentry_fsdata dataonstack;
-			reiser4_dentry_fsdata *fsdata;
+			struct reiser4_dentry_fsdata dataonstack;
+			struct reiser4_dentry_fsdata *fsdata;
 
 			memset(&dataonstack, 0, sizeof dataonstack);
 			memset(&dotdot_entry, 0, sizeof dotdot_entry);
diff -puN fs/reiser4/plugin/item/cde.c~reiser4-remove-typedefs fs/reiser4/plugin/item/cde.c
--- a/fs/reiser4/plugin/item/cde.c~reiser4-remove-typedefs
+++ a/fs/reiser4/plugin/item/cde.c
@@ -285,7 +285,7 @@ static int expand_item(const coord_t * c
 
 /* insert new @entry into item */
 static int expand(const coord_t * coord /* coord of item */ ,
-		  cde_entry * entry /* entry to insert */ ,
+		  struct cde_entry * entry /* entry to insert */ ,
 		  int len /* length of @entry data */ ,
 		  int *pos /* position to insert */ ,
 		  reiser4_dir_entry_desc * dir_entry	/* parameters for new
@@ -309,7 +309,7 @@ static int expand(const coord_t * coord 
 
 /* paste body of @entry into item */
 static int paste_entry(const coord_t * coord /* coord of item */ ,
-		       cde_entry * entry /* new entry */ ,
+		       struct cde_entry * entry /* new entry */ ,
 		       int pos /* position to insert */ ,
 		       reiser4_dir_entry_desc * dir_entry	/* parameters for
 								 * new entry */ )
@@ -345,11 +345,11 @@ static int paste_entry(const coord_t * c
 int estimate_cde(const coord_t * coord /* coord of item */ ,
 		 const reiser4_item_data * data /* parameters for new item */ )
 {
-	cde_entry_data *e;
+	struct cde_entry_data *e;
 	int result;
 	int i;
 
-	e = (cde_entry_data *) data->data;
+	e = (struct cde_entry_data *) data->data;
 
 	assert("nikita-1288", e != NULL);
 	assert("nikita-1289", e->num_of_entries >= 0);
@@ -568,12 +568,12 @@ int paste_cde(coord_t * coord /* coord o
 					 * inserted */ ,
 	      carry_plugin_info * info UNUSED_ARG /* todo carry queue */ )
 {
-	cde_entry_data *e;
+	struct cde_entry_data *e;
 	int result;
 	int i;
 
 	CHECKME(coord);
-	e = (cde_entry_data *) data->data;
+	e = (struct cde_entry_data *) data->data;
 
 	result = 0;
 	for (i = 0; i < e->num_of_entries; ++i) {
@@ -908,8 +908,8 @@ int add_entry_cde(struct inode *dir /* d
 							 * directory entry */ )
 {
 	reiser4_item_data data;
-	cde_entry entry;
-	cde_entry_data edata;
+	struct cde_entry entry;
+	struct cde_entry_data edata;
 	int result;
 
 	assert("nikita-1656", coord->node == lh->node);
diff -puN fs/reiser4/plugin/item/cde.h~reiser4-remove-typedefs fs/reiser4/plugin/item/cde.h
--- a/fs/reiser4/plugin/item/cde.h~reiser4-remove-typedefs
+++ a/fs/reiser4/plugin/item/cde.h
@@ -22,16 +22,16 @@ typedef struct cde_item_format {
 	cde_unit_header entry[0];
 } cde_item_format;
 
-typedef struct cde_entry {
+struct cde_entry {
 	const struct inode *dir;
 	const struct inode *obj;
 	const struct qstr *name;
-} cde_entry;
+};
 
-typedef struct cde_entry_data {
+struct cde_entry_data {
 	int num_of_entries;
-	cde_entry *entry;
-} cde_entry_data;
+	struct cde_entry *entry;
+};
 
 /* plugin->item.b.* */
 reiser4_key *max_key_inside_cde(const coord_t * coord, reiser4_key * result);
diff -puN fs/reiser4/plugin/item/ctail.c~reiser4-remove-typedefs fs/reiser4/plugin/item/ctail.c
--- a/fs/reiser4/plugin/item/ctail.c~reiser4-remove-typedefs
+++ a/fs/reiser4/plugin/item/ctail.c
@@ -542,7 +542,7 @@ int read_ctail(struct file *file UNUSED_
 
 /* Reads a disk cluster consists of ctail items,
    attaches a transform stream with plain text */
-int ctail_read_disk_cluster(reiser4_cluster_t * clust, struct inode *inode,
+int ctail_read_disk_cluster(struct cluster_handle * clust, struct inode * inode,
 			    znode_lock_mode mode)
 {
 	int result;
@@ -581,14 +581,14 @@ int ctail_read_disk_cluster(reiser4_clus
 }
 
 /* read one locked page */
-int do_readpage_ctail(struct inode * inode, reiser4_cluster_t * clust,
+int do_readpage_ctail(struct inode * inode, struct cluster_handle * clust,
 		      struct page *page, znode_lock_mode mode)
 {
 	int ret;
 	unsigned cloff;
 	char *data;
 	size_t pgcnt;
-	tfm_cluster_t *tc = &clust->tc;
+	struct tfm_cluster * tc = &clust->tc;
 
 	assert("edward-212", PageLocked(page));
 
@@ -656,8 +656,8 @@ int do_readpage_ctail(struct inode * ino
 int readpage_ctail(void *vp, struct page *page)
 {
 	int result;
-	hint_t *hint;
-	reiser4_cluster_t *clust = vp;
+	hint_t * hint;
+	struct cluster_handle * clust = vp;
 
 	assert("edward-114", clust != NULL);
 	assert("edward-115", PageLocked(page));
@@ -698,8 +698,8 @@ int readpage_ctail(void *vp, struct page
 }
 
 /* Helper function for ->readpages() */
-static int
-ctail_read_page_cluster(reiser4_cluster_t * clust, struct inode *inode)
+static int ctail_read_page_cluster(struct cluster_handle * clust,
+				   struct inode *inode)
 {
 	int i;
 	int result;
@@ -734,7 +734,7 @@ ctail_read_page_cluster(reiser4_cluster_
 static int ctail_readpages_filler(void * data, struct page * page)
 {
 	int ret = 0;
-	reiser4_cluster_t * clust = data;
+	struct cluster_handle * clust = data;
 	struct inode * inode = clust->file->f_dentry->d_inode;
 
 	if (PageUptodate(page)) {
@@ -764,7 +764,7 @@ int readpages_ctail(struct file *file, s
 {
 	int ret = 0;
 	hint_t *hint;
-	reiser4_cluster_t clust;
+	struct cluster_handle clust;
 	struct inode *inode = mapping->host;
 
 	assert("edward-1521", inode == file->f_dentry->d_inode);
@@ -813,14 +813,13 @@ reiser4_key *append_key_ctail(const coor
 	assert("edward-1242", cluster_shift_ok(cluster_shift_by_coord(coord)));
 
 	item_key_by_coord(coord, key);
-	set_key_offset(key,
-		       ((__u64) (clust_by_coord(coord, NULL)) +
-			1) << cluster_shift_by_coord(coord));
+	set_key_offset(key, ((__u64) (clust_by_coord(coord, NULL)) + 1)
+		       << cluster_shift_by_coord(coord));
 	return key;
 }
 
-static int
-insert_unprepped_ctail(reiser4_cluster_t * clust, struct inode *inode)
+static int insert_unprepped_ctail(struct cluster_handle * clust,
+				  struct inode *inode)
 {
 	int result;
 	char buf[UCTAIL_NR_UNITS];
@@ -974,8 +973,8 @@ static int cut_ctail(coord_t * coord)
 	return cut_node_content(coord, &stop, NULL, NULL, NULL);
 }
 
-int
-ctail_insert_unprepped_cluster(reiser4_cluster_t * clust, struct inode *inode)
+int ctail_insert_unprepped_cluster(struct cluster_handle * clust,
+				   struct inode * inode)
 {
 	int result;
 	assert("edward-1244", inode != NULL);
@@ -1012,7 +1011,7 @@ ctail_insert_unprepped_cluster(reiser4_c
 static int do_convert_ctail(flush_pos_t * pos, cryptcompress_write_mode_t mode)
 {
 	int result = 0;
-	convert_item_info_t *info;
+	struct convert_item_info * info;
 
 	assert("edward-468", pos != NULL);
 	assert("edward-469", pos->sq != NULL);
@@ -1110,7 +1109,7 @@ static int should_attach_convert_idata(f
 
 /* plugin->init_convert_data() */
 static int
-init_convert_data_ctail(convert_item_info_t * idata, struct inode *inode)
+init_convert_data_ctail(struct convert_item_info * idata, struct inode *inode)
 {
 	assert("edward-813", idata != NULL);
 	assert("edward-814", inode != NULL);
@@ -1122,7 +1121,7 @@ init_convert_data_ctail(convert_item_inf
 	return 0;
 }
 
-static int alloc_item_convert_data(convert_info_t * sq)
+static int alloc_item_convert_data(struct convert_info * sq)
 {
 	assert("edward-816", sq != NULL);
 	assert("edward-817", sq->itm == NULL);
@@ -1133,7 +1132,7 @@ static int alloc_item_convert_data(conve
 	return 0;
 }
 
-static void free_item_convert_data(convert_info_t * sq)
+static void free_item_convert_data(struct convert_info * sq)
 {
 	assert("edward-818", sq != NULL);
 	assert("edward-819", sq->itm != NULL);
@@ -1159,7 +1158,7 @@ static int alloc_convert_data(flush_pos_
 
 void free_convert_data(flush_pos_t * pos)
 {
-	convert_info_t *sq;
+	struct convert_info *sq;
 
 	assert("edward-823", pos != NULL);
 	assert("edward-824", pos->sq != NULL);
@@ -1175,7 +1174,7 @@ void free_convert_data(flush_pos_t * pos
 
 static int init_item_convert_data(flush_pos_t * pos, struct inode *inode)
 {
-	convert_info_t *sq;
+	struct convert_info *sq;
 
 	assert("edward-825", pos != NULL);
 	assert("edward-826", pos->sq != NULL);
@@ -1195,8 +1194,8 @@ static int init_item_convert_data(flush_
 static int attach_convert_idata(flush_pos_t * pos, struct inode *inode)
 {
 	int ret = 0;
-	convert_item_info_t *info;
-	reiser4_cluster_t *clust;
+	struct convert_item_info *info;
+	struct cluster_handle *clust;
 	file_plugin *fplug = inode_file_plugin(inode);
 	compression_plugin *cplug = inode_compression_plugin(inode);
 
@@ -1263,9 +1262,9 @@ static int attach_convert_idata(flush_po
 }
 
 /* clear up disk cluster info */
-static void detach_convert_idata(convert_info_t * sq)
+static void detach_convert_idata(struct convert_info * sq)
 {
-	convert_item_info_t *info;
+	struct convert_item_info *info;
 
 	assert("edward-253", sq != NULL);
 	assert("edward-840", sq->itm != NULL);
@@ -1408,7 +1407,7 @@ static int next_item_dc_stat(flush_pos_t
 }
 
 static int
-assign_convert_mode(convert_item_info_t * idata,
+assign_convert_mode(struct convert_item_info * idata,
 		    cryptcompress_write_mode_t * mode)
 {
 	int result = 0;
@@ -1492,7 +1491,7 @@ int convert_ctail(flush_pos_t * pos)
 	} else {
 		/* use old convert info */
 
-		convert_item_info_t *idata;
+		struct convert_item_info *idata;
 
 		idata = item_convert_data(pos);
 
diff -puN fs/reiser4/plugin/item/ctail.h~reiser4-remove-typedefs fs/reiser4/plugin/item/ctail.h
--- a/fs/reiser4/plugin/item/ctail.h~reiser4-remove-typedefs
+++ a/fs/reiser4/plugin/item/ctail.h
@@ -1,18 +1,23 @@
 /* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
 
+/* Ctail items are fragments (or bodies) of special tipe to provide
+   optimal storage of encrypted and(or) compressed files. */
+
+
 #if !defined( __FS_REISER4_CTAIL_H__ )
 #define __FS_REISER4_CTAIL_H__
 
 /* Disk format of ctail item */
 typedef struct ctail_item_format {
-	/* packed shift; size of (prepped) disk cluster
-	   is calculated as (1 << cluster_shift) */
+	/* packed shift;
+	   if its value is different from UCTAIL_SHIFT (see below), then
+	   size of disk cluster is calculated as (1 << cluster_shift) */
 	d8 cluster_shift;
 	/* ctail body */
 	d8 body[0];
 } __attribute__ ((packed)) ctail_item_format;
 
-/* Unprepped disk cluster is represented by a single ctail item
+/* "Unprepped" disk cluster is represented by a single ctail item
    with the following "magic" attributes: */
 /* "magic" cluster_shift */
 #define UCTAIL_SHIFT 0xff
@@ -31,13 +36,13 @@ typedef enum {
 
 /* ctail-specific extension.
    In particular this describes parameters of disk cluster an item belongs to */
-typedef struct {
+struct ctail_coord_extension {
 	int shift; /* this contains cluster_shift extracted from
 		      ctail_item_format (above), or UCTAIL_SHIFT
 		      (the last one is the "magic" of unprepped disk clusters)*/
 	int dsize; /* size of a prepped disk cluster */
 	int ncount; /* count of nodes occupied by a disk cluster */
-} ctail_coord_extension_t;
+};
 
 struct cut_list;
 
diff -puN fs/reiser4/plugin/item/extent.h~reiser4-remove-typedefs fs/reiser4/plugin/item/extent.h
--- a/fs/reiser4/plugin/item/extent.h~reiser4-remove-typedefs
+++ a/fs/reiser4/plugin/item/extent.h
@@ -9,14 +9,14 @@ typedef struct {
 	reiser4_dblock_nr width;
 } reiser4_extent;
 
-typedef struct extent_stat {
+struct extent_stat {
 	int unallocated_units;
 	int unallocated_blocks;
 	int allocated_units;
 	int allocated_blocks;
 	int hole_units;
 	int hole_blocks;
-} extent_stat;
+};
 
 /* extents in an extent item can be either holes, or unallocated or allocated
    extents */
@@ -30,7 +30,7 @@ typedef enum {
 #define UNALLOCATED_EXTENT_START 1
 #define UNALLOCATED_EXTENT_START2 2
 
-typedef struct {
+struct extent_coord_extension {
 	reiser4_block_nr pos_in_unit;
 	reiser4_block_nr width;	/* width of current unit */
 	pos_in_node_t nr_units;	/* number of units */
@@ -39,7 +39,7 @@ typedef struct {
 #if REISER4_DEBUG
 	reiser4_extent extent;
 #endif
-} extent_coord_extension_t;
+};
 
 /* macros to set/get fields of on-disk extent */
 static inline reiser4_block_nr extent_get_start(const reiser4_extent * ext)
diff -puN fs/reiser4/plugin/item/extent_file_ops.c~reiser4-remove-typedefs fs/reiser4/plugin/item/extent_file_ops.c
--- a/fs/reiser4/plugin/item/extent_file_ops.c~reiser4-remove-typedefs
+++ a/fs/reiser4/plugin/item/extent_file_ops.c
@@ -29,7 +29,7 @@ static void check_uf_coord(const uf_coor
 {
 #if REISER4_DEBUG
 	const coord_t *coord;
-	const extent_coord_extension_t *ext_coord;
+	const struct extent_coord_extension *ext_coord;
 	reiser4_extent *ext;
 
 	coord = &uf_coord->coord;
@@ -234,7 +234,7 @@ static int append_last_extent(uf_coord_t
 	reiser4_extent new_ext;
 	reiser4_item_data idata;
 	coord_t *coord;
-	extent_coord_extension_t *ext_coord;
+	struct extent_coord_extension *ext_coord;
 	reiser4_extent *ext;
 	reiser4_block_nr block;
 	jnode *node;
@@ -379,7 +379,7 @@ static int insert_first_extent(uf_coord_
 	reiser4_extent new_ext;
 	reiser4_item_data idata;
 	reiser4_block_nr block;
-	unix_file_info_t *uf_info;
+	struct unix_file_info *uf_info;
 	jnode *node;
 
 	/* first extent insertion starts at leaf level */
@@ -469,7 +469,7 @@ static int plug_hole(uf_coord_t *uf_coor
 	reiser4_extent *ext;
 	reiser4_block_nr width, pos_in_unit;
 	coord_t *coord;
-	extent_coord_extension_t *ext_coord;
+	struct extent_coord_extension *ext_coord;
 	int return_inserted_position;
 
  	check_uf_coord(uf_coord, key);
@@ -605,7 +605,7 @@ static int overwrite_one_block(uf_coord_
 			       jnode *node, int *hole_plugged)
 {
 	int result;
-	extent_coord_extension_t *ext_coord;
+	struct extent_coord_extension *ext_coord;
 	reiser4_extent *ext;
 	reiser4_block_nr block;
 	int how;
@@ -651,7 +651,7 @@ static int overwrite_one_block(uf_coord_
  */
 static int move_coord(uf_coord_t *uf_coord)
 {
-	extent_coord_extension_t *ext_coord;
+	struct extent_coord_extension *ext_coord;
 
 	if (uf_coord->valid == 0)
 		return 1;
@@ -1173,7 +1173,7 @@ int reiser4_read_extent(struct file *fil
 	loff_t file_off;
 	uf_coord_t *uf_coord;
 	coord_t *coord;
-	extent_coord_extension_t *ext_coord;
+	struct extent_coord_extension *ext_coord;
 	unsigned long nr_pages;
 	char *kaddr;
 
@@ -1368,7 +1368,7 @@ reiser4_key *append_key_extent(const coo
 void init_coord_extension_extent(uf_coord_t * uf_coord, loff_t lookuped)
 {
 	coord_t *coord;
-	extent_coord_extension_t *ext_coord;
+	struct extent_coord_extension *ext_coord;
 	reiser4_key key;
 	loff_t offset;
 
diff -puN fs/reiser4/plugin/item/item.h~reiser4-remove-typedefs fs/reiser4/plugin/item/item.h
--- a/fs/reiser4/plugin/item/item.h~reiser4-remove-typedefs
+++ a/fs/reiser4/plugin/item/item.h
@@ -34,7 +34,7 @@ typedef enum {
 /* this is the part of each item plugin that all items are expected to
    support or at least explicitly fail to support by setting the
    pointer to null. */
-typedef struct {
+struct balance_ops {
 	/* operations called by balancing
 
 	   It is interesting to consider that some of these item
@@ -189,9 +189,9 @@ typedef struct {
 	int (*check) (const coord_t *, const char **error);
 #endif
 
-} balance_ops;
+};
 
-typedef struct {
+struct flush_ops {
 	/* return the right or left child of @coord, only if it is in memory */
 	int (*utmost_child) (const coord_t *, sideof side, jnode ** child);
 
@@ -207,10 +207,10 @@ typedef struct {
 	int (*convert) (flush_pos_t * pos);
 	/* backward mapping from jnode offset to a key.  */
 	int (*key_by_offset) (struct inode *, loff_t, reiser4_key *);
-} flush_ops;
+};
 
 /* operations specific to the directory item */
-typedef struct {
+struct dir_entry_iops {
 	/* extract stat-data key from directory entry at @coord and place it
 	   into @key. */
 	int (*extract_key) (const coord_t *, reiser4_key * key);
@@ -229,10 +229,10 @@ typedef struct {
 			  coord_t *, lock_handle *,
 			  reiser4_dir_entry_desc * entry);
 	int (*max_name_len) (const struct inode * dir);
-} dir_entry_ops;
+};
 
 /* operations specific to items regular (unix) file metadata are built of */
-typedef struct {
+struct file_iops{
 	int (*write) (struct file *, const char __user *, size_t, loff_t *pos);
 	int (*read) (struct file *, flow_t *, hint_t *);
 	int (*readpage) (void *, struct page *);
@@ -251,17 +251,17 @@ typedef struct {
 	reiser4_key *(*append_key) (const coord_t *, reiser4_key *);
 
 	void (*init_coord_extension) (uf_coord_t *, loff_t);
-} file_ops;
+};
 
 /* operations specific to items of stat data type */
-typedef struct {
+struct sd_iops {
 	int (*init_inode) (struct inode * inode, char *sd, int len);
 	int (*save_len) (struct inode * inode);
 	int (*save) (struct inode * inode, char **area);
-} sd_ops;
+};
 
 /* operations specific to internal item */
-typedef struct {
+struct internal_iops{
 	/* all tree traversal want to know from internal item is where
 	   to go next. */
 	void (*down_link) (const coord_t * coord,
@@ -269,25 +269,22 @@ typedef struct {
 	/* check that given internal item contains given pointer. */
 	int (*has_pointer_to) (const coord_t * coord,
 			       const reiser4_block_nr * block);
-} internal_item_ops;
+};
 
 struct item_plugin {
 	/* generic fields */
 	plugin_header h;
-
 	/* methods common for all item types */
-	balance_ops b;
-	/* methods used during flush */
-	flush_ops f;
+	struct balance_ops b; /* balance operations */
+ 	struct flush_ops f;   /* flush operates with items via this methods */
 
 	/* methods specific to particular type of item */
 	union {
-		dir_entry_ops dir;
-		file_ops file;
-		sd_ops sd;
-		internal_item_ops internal;
+		struct dir_entry_iops dir;
+		struct      file_iops file;
+		struct        sd_iops sd;
+		struct  internal_iops internal;
 	} s;
-
 };
 
 #define is_solid_item(iplug) ((iplug)->b.nr_units == nr_units_single_unit)
diff -puN fs/reiser4/plugin/item/static_stat.c~reiser4-remove-typedefs fs/reiser4/plugin/item/static_stat.c
--- a/fs/reiser4/plugin/item/static_stat.c~reiser4-remove-typedefs
+++ a/fs/reiser4/plugin/item/static_stat.c
@@ -870,21 +870,21 @@ static int save_hset_sd(struct inode *in
 }
 
 /* helper function for crypto_sd_present(), crypto_sd_save.
-   Allocates memory for crypto stat, keyid and attaches it to the inode */
-static int extract_crypto_stat (struct inode * inode,
+   Extract crypto info from stat-data and attach it to inode */
+static int extract_crypto_info (struct inode * inode,
 				reiser4_crypto_stat * sd)
 {
-	crypto_stat_t * info;
-	assert("edward-11", !inode_crypto_stat(inode));
+	struct reiser4_crypto_info * info;
+	assert("edward-11", !inode_crypto_info(inode));
 	assert("edward-1413",
 	       !reiser4_inode_get_flag(inode, REISER4_CRYPTO_STAT_LOADED));
 	/* create and attach a crypto-stat without secret key loaded */
-	info = reiser4_alloc_crypto_stat(inode);
+	info = reiser4_alloc_crypto_info(inode);
 	if (IS_ERR(info))
 		return PTR_ERR(info);
 	info->keysize = le16_to_cpu(get_unaligned(&sd->keysize));
 	memcpy(info->keyid, sd->keyid, inode_digest_plugin(inode)->fipsize);
-	reiser4_attach_crypto_stat(inode, info);
+	reiser4_attach_crypto_info(inode, info);
 	reiser4_inode_set_flag(inode, REISER4_CRYPTO_STAT_LOADED);
 	return 0;
 }
@@ -912,7 +912,7 @@ static int present_crypto_sd(struct inod
 	assert("edward-75", sizeof(*sd) + dplug->fipsize <= *len);
 
 	sd = (reiser4_crypto_stat *) * area;
-	result = extract_crypto_stat(inode, sd);
+	result = extract_crypto_info(inode, sd);
 	move_on(len, area, sizeof(*sd) + dplug->fipsize);
 
 	return result;
@@ -928,7 +928,7 @@ static int save_crypto_sd(struct inode *
 {
 	int result = 0;
 	reiser4_crypto_stat *sd;
-	crypto_stat_t * info = inode_crypto_stat(inode);
+	struct reiser4_crypto_info * info = inode_crypto_info(inode);
 	digest_plugin *dplug = inode_digest_plugin(inode);
 
 	assert("edward-12", dplug != NULL);
diff -puN fs/reiser4/plugin/item/tail.c~reiser4-remove-typedefs fs/reiser4/plugin/item/tail.c
--- a/fs/reiser4/plugin/item/tail.c~reiser4-remove-typedefs
+++ a/fs/reiser4/plugin/item/tail.c
@@ -478,7 +478,7 @@ static ssize_t insert_first_tail(struct 
 {
 	int result;
 	loff_t to_write;
-	unix_file_info_t *uf_info;
+	struct unix_file_info *uf_info;
 
 	if (get_key_offset(&flow->key) != 0) {
 		/*
diff -puN fs/reiser4/plugin/item/tail.h~reiser4-remove-typedefs fs/reiser4/plugin/item/tail.h
--- a/fs/reiser4/plugin/item/tail.h~reiser4-remove-typedefs
+++ a/fs/reiser4/plugin/item/tail.h
@@ -3,9 +3,9 @@
 #if !defined( __REISER4_TAIL_H__ )
 #define __REISER4_TAIL_H__
 
-typedef struct {
+struct tail_coord_extension {
 	int not_used;
-} tail_coord_extension_t;
+};
 
 struct cut_list;
 
diff -puN fs/reiser4/plugin/plugin.c~reiser4-remove-typedefs fs/reiser4/plugin/plugin.c
--- a/fs/reiser4/plugin/plugin.c~reiser4-remove-typedefs
+++ a/fs/reiser4/plugin/plugin.c
@@ -11,14 +11,8 @@
 
    Plugins are classified into several disjoint "types". Plugins
    belonging to the particular plugin type are termed "instances" of
-   this type. Currently the following types are present:
-
-    . object plugin
-    . hash plugin
-    . tail plugin
-    . perm plugin
-    . item plugin
-    . node layout plugin
+   this type. Existing types are listed by enum reiser4_plugin_type
+   (see plugin/plugin_header.h)
 
 NIKITA-FIXME-HANS: update this list, and review this entire comment for currency
 
@@ -35,8 +29,6 @@ NIKITA-FIXME-HANS: update this list, and
    Tail plugins (or, more precisely, tail policy plugins) determine
    when last part of the file should be stored in a formatted item.
 
-   Perm plugins control permissions granted for a process accessing a file.
-
    Scope and lookup:
 
    label such that pair ( type_label, plugin_label ) is unique.  This
@@ -49,20 +41,15 @@ NIKITA-FIXME-HANS: update this list, and
    store the offset into the plugin array for that plugin type as the
    plugin id in the stat data of the filesystem object.
 
-   plugin_labels have meaning for the user interface that assigns
-   plugins to files, and may someday have meaning for dynamic loading of
-   plugins and for copying of plugins from one fs instance to
-   another by utilities like cp and tar.
-
    Internal kernel plugin type identifier (index in plugins[] array) is
    of type reiser4_plugin_type. Set of available plugin types is
    currently static, but dynamic loading doesn't seem to pose
    insurmountable problems.
 
    Within each type plugins are addressed by the identifiers of type
-   reiser4_plugin_id (indices in
-   reiser4_plugin_type_data.builtin[]). Such identifiers are only
-   required to be unique within one type, not globally.
+   reiser4_plugin_id (indices in reiser4_plugin_type_data.builtin[]).
+   Such identifiers are only required to be unique within one type,
+   not globally.
 
    Thus, plugin in memory is uniquely identified by the pair (type_id,
    id).
@@ -83,9 +70,7 @@ NIKITA-FIXME-HANS: update this list, and
 
    With each subject the plugin possibly stores some state. For example,
    the state of a directory plugin (instance of object plugin type) is pointer
-   to hash plugin (if directories always use hashing that is). State of
-   audit plugin is file descriptor (struct file) of log file or some
-   magic value to do logging through printk().
+   to hash plugin (if directories always use hashing that is).
 
    Interface:
 
@@ -97,7 +82,7 @@ NIKITA-FIXME-HANS: update this list, and
    .desc fields of reiser4_plugin_header respectively. It's possible to
    locate plugin by the pair of labels.
 
-   Features:
+   Features (not implemented):
 
     . user-level plugin manipulations:
       + reiser4("filename/..file_plugin<='audit'");
@@ -107,7 +92,9 @@ NIKITA-FIXME-HANS: update this list, and
       Utilities are not of primary priority. Possibly they will be not
       working on v4.0
 
-NIKITA-FIXME-HANS: this should be a mkreiserfs option not a mount option, do you agree?  I don't think that specifying it at mount time, and then changing it with each mount, is a good model for usage.
+   NIKITA-FIXME-HANS: this should be a mkreiserfs option not a mount
+   option, do you agree?  I don't think that specifying it at mount time,
+   and then changing it with each mount, is a good model for usage.
 
     . mount option "plug" to set-up plugins of root-directory.
       "plug=foo:bar" will set "bar" as default plugin of type "foo".
@@ -135,7 +122,7 @@ NIKITA-FIXME-HANS: this should be a mkre
 
     . perm:acl
 
-    d audi---audit plugin intercepting and possibly logging all
+    . audi---audit plugin intercepting and possibly logging all
       accesses to object. Requires to put stub functions in file_operations
       in stead of generic_file_*.
 
@@ -160,10 +147,10 @@ Each file is associated
    but not for directories, how such plugins would be inherited?
     . always store them with directories also
 
-NIKTIA-FIXME-HANS: Do the line above.  It is not exclusive of doing the line below which is also useful.
+NIKTIA-FIXME-HANS: Do the line above.  It is not exclusive of doing
+the line below which is also useful.
 
     . use inheritance hierarchy, independent of file-system namespace
-
 */
 
 #include "../debug.h"
@@ -181,15 +168,9 @@ NIKTIA-FIXME-HANS: Do the line above.  I
 
 #include <linux/fs.h>		/* for struct super_block  */
 
-/* public interface */
-
-/* initialise plugin sub-system. Just call this once on reiser4 startup. */
-int init_plugins(void);
-int setup_plugins(struct super_block *super, reiser4_plugin ** area);
-int locate_plugin(struct inode *inode, plugin_locator * loc);
-
-/**
- * init_plugins - initialize plugins
+/*
+ * init_plugins - initialize plugin sub-system.
+ * Just call this once on reiser4 startup.
  *
  * Initializes plugin sub-system. It is part of reiser4 module
  * initialization. For each plugin of each type init method is called and each
@@ -200,7 +181,7 @@ int init_plugins(void)
 	reiser4_plugin_type type_id;
 
 	for (type_id = 0; type_id < REISER4_PLUGIN_TYPES; ++type_id) {
-		reiser4_plugin_type_data *ptype;
+		struct reiser4_plugin_type_data *ptype;
 		int i;
 
 		ptype = &plugins[type_id];
@@ -418,7 +399,7 @@ int force_plugin_pset(struct inode *self
 	return result;
 }
 
-reiser4_plugin_type_data plugins[REISER4_PLUGIN_TYPES] = {
+struct reiser4_plugin_type_data plugins[REISER4_PLUGIN_TYPES] = {
 	/* C90 initializers */
 	[REISER4_FILE_PLUGIN_TYPE] = {
 		.type_id = REISER4_FILE_PLUGIN_TYPE,
diff -puN fs/reiser4/plugin/plugin.h~reiser4-remove-typedefs fs/reiser4/plugin/plugin.h
--- a/fs/reiser4/plugin/plugin.h~reiser4-remove-typedefs
+++ a/fs/reiser4/plugin/plugin.h
@@ -694,7 +694,6 @@ struct reiser4_plugin_ops {
 
 /* stores plugin reference in reiser4-specific part of inode */
 extern int set_object_plugin(struct inode *inode, reiser4_plugin_id id);
-extern int setup_plugins(struct super_block *super, reiser4_plugin ** area);
 extern int init_plugins(void);
 
 /* builtin plugins */
@@ -753,13 +752,6 @@ typedef enum {
 	LAST_TAIL_FORMATTING_ID
 } reiser4_formatting_id;
 
-/* compression/clustering specific data */
-typedef struct compression_data {
-	reiser4_compression_id coa;	/* id of the compression algorithm */
-} compression_data_t;
-
-typedef __u8 cluster_data_t;	/* cluster info */
-
 /* data type used to pack parameters that we pass to vfs object creation
    function create_object() */
 struct reiser4_object_create_data {
@@ -775,9 +767,7 @@ struct reiser4_object_create_data {
 	/* add here something for non-standard objects you invent, like
 	   query for interpolation file etc. */
 
- 	crypto_stat_t * crypto;
-	compression_data_t *compression;
-	cluster_data_t *cluster;
+ 	struct reiser4_crypto_info * crypto;
 
 	struct inode *parent;
 	struct dentry *dentry;
@@ -805,17 +795,6 @@ struct reiser4_dir_entry_desc {
 #define MAX_PLUGIN_TYPE_LABEL_LEN  32
 #define MAX_PLUGIN_PLUG_LABEL_LEN  32
 
-/* used for interface with user-land: table-driven parsing in
-    reiser4(). */
-typedef struct plugin_locator {
-	reiser4_plugin_type type_id;
-	reiser4_plugin_id id;
-	char type_label[MAX_PLUGIN_TYPE_LABEL_LEN];
-	char plug_label[MAX_PLUGIN_PLUG_LABEL_LEN];
-} plugin_locator;
-
-extern int locate_plugin(struct inode *inode, plugin_locator * loc);
-
 #define PLUGIN_BY_ID(TYPE,ID,FIELD)					\
 static inline TYPE *TYPE ## _by_id( reiser4_plugin_id id )		\
 {									\
diff -puN fs/reiser4/plugin/plugin_header.h~reiser4-remove-typedefs fs/reiser4/plugin/plugin_header.h
--- a/fs/reiser4/plugin/plugin_header.h~reiser4-remove-typedefs
+++ a/fs/reiser4/plugin/plugin_header.h
@@ -10,32 +10,42 @@
 #include "../debug.h"
 #include "../dformat.h"
 
+/* Every plugin type can be considered as a class of virtual objects
+   {(type, i) | i = 0, 1, ...}, which has one the following categories
+   of virtualization:
+   A - no virtualization;
+   F - per-file virtualization;
+   S - per-superblock virtualization;
+   FIXME-EDWARD: Define every such category */
+
+/* Supported plugin types: (id, (virtualization category), short description) */
 typedef enum {
-	REISER4_FILE_PLUGIN_TYPE,
-	REISER4_DIR_PLUGIN_TYPE,
-	REISER4_ITEM_PLUGIN_TYPE,
-	REISER4_NODE_PLUGIN_TYPE,
-	REISER4_HASH_PLUGIN_TYPE,
-	REISER4_FIBRATION_PLUGIN_TYPE,
-	REISER4_FORMATTING_PLUGIN_TYPE,
-	REISER4_PERM_PLUGIN_TYPE,
-	REISER4_SD_EXT_PLUGIN_TYPE,
-	REISER4_FORMAT_PLUGIN_TYPE,
-	REISER4_JNODE_PLUGIN_TYPE,
-	REISER4_CIPHER_PLUGIN_TYPE,
-	REISER4_DIGEST_PLUGIN_TYPE,
-	REISER4_COMPRESSION_PLUGIN_TYPE,
-	REISER4_COMPRESSION_MODE_PLUGIN_TYPE,
-	REISER4_CLUSTER_PLUGIN_TYPE,
+	REISER4_FILE_PLUGIN_TYPE,             /* (F) service VFS enry-points */
+	REISER4_DIR_PLUGIN_TYPE,              /* (F) service VFS enry-points */
+	REISER4_ITEM_PLUGIN_TYPE,             /* (F) manage items */
+	REISER4_NODE_PLUGIN_TYPE,             /* (S) manage formatted nodes */
+	REISER4_HASH_PLUGIN_TYPE,             /* (F) compute hash */
+	REISER4_FIBRATION_PLUGIN_TYPE,        /* (F) directory fibrations */
+	REISER4_FORMATTING_PLUGIN_TYPE,       /* (F) tail-packing policy */
+	REISER4_PERM_PLUGIN_TYPE,             /*       stub (vacancy)     */
+	REISER4_SD_EXT_PLUGIN_TYPE,           /* (A) stat-data extensions */
+	REISER4_FORMAT_PLUGIN_TYPE,           /* (S) specify disk format */
+	REISER4_JNODE_PLUGIN_TYPE,            /* (A) in-memory node headers */
+	REISER4_CIPHER_PLUGIN_TYPE,           /* (F) cipher transform algs */
+	REISER4_DIGEST_PLUGIN_TYPE,           /* (F) digest transform algs */
+	REISER4_COMPRESSION_PLUGIN_TYPE,      /* (F) compression tfm algs */
+ 	REISER4_COMPRESSION_MODE_PLUGIN_TYPE, /* (F) compression heuristic */
+	REISER4_CLUSTER_PLUGIN_TYPE,          /* (F) size of logical cluster */
 	REISER4_PLUGIN_TYPES
 } reiser4_plugin_type;
 
+/* Supported plugin groups */
 typedef enum {
 	REISER4_DIRECTORY_FILE,
 	REISER4_REGULAR_FILE,
 	REISER4_SYMLINK_FILE,
 	REISER4_SPECIAL_FILE,
-} reiser4_plugin_group;
+} file_plugin_group;
 
 struct reiser4_plugin_ops;
 /* generic plugin operations, supported by each
@@ -66,7 +76,7 @@ typedef struct plugin_header {
 /* PRIVATE INTERFACES */
 /* NIKITA-FIXME-HANS: what is this for and why does it duplicate what is in plugin_header? */
 /* plugin type representation. */
-typedef struct reiser4_plugin_type_data {
+struct reiser4_plugin_type_data {
 	/* internal plugin type identifier. Should coincide with
 	   index of this item in plugins[] array. */
 	reiser4_plugin_type type_id;
@@ -83,14 +93,15 @@ typedef struct reiser4_plugin_type_data 
 	void *builtin;
 	struct list_head plugins_list;
 	size_t size;
-} reiser4_plugin_type_data;
+};
 
-extern reiser4_plugin_type_data plugins[REISER4_PLUGIN_TYPES];
+extern struct reiser4_plugin_type_data plugins[REISER4_PLUGIN_TYPES];
 
 int is_plugin_type_valid(reiser4_plugin_type type);
 int is_plugin_id_valid(reiser4_plugin_type type, reiser4_plugin_id id);
 
-static inline reiser4_plugin *plugin_at(reiser4_plugin_type_data * ptype, int i)
+static inline reiser4_plugin *plugin_at(struct reiser4_plugin_type_data * ptype,
+					int i)
 {
 	char *builtin;
 
diff -puN fs/reiser4/plugin/security/perm.c~reiser4-remove-typedefs fs/reiser4/plugin/security/perm.c
--- a/fs/reiser4/plugin/security/perm.c~reiser4-remove-typedefs
+++ a/fs/reiser4/plugin/security/perm.c
@@ -1,8 +1,8 @@
 /* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
 
 /*
- * this file contains implementation of permission plugins. Currently, only
- * RWX_PERM_ID is implemented
+ * This file contains implementation of permission plugins.
+ * See the comments in perm.h
  */
 
 #include "../plugin.h"
@@ -18,18 +18,7 @@ perm_plugin perm_plugins[LAST_PERM_ID] =
 			.label = "null",
 			.desc = "stub permission plugin",
 			.linkage = {NULL, NULL}
-		},
-		.read_ok = NULL,
-		.write_ok = NULL,
-		.lookup_ok = NULL,
-		.create_ok = NULL,
-		.link_ok = NULL,
-		.unlink_ok = NULL,
-		.delete_ok = NULL,
-		.mask_ok = NULL,
-		.setattr_ok = NULL,
-		.getattr_ok = NULL,
-		.rename_ok = NULL,
+		}
 	}
 };
 
diff -puN fs/reiser4/plugin/security/perm.h~reiser4-remove-typedefs fs/reiser4/plugin/security/perm.h
--- a/fs/reiser4/plugin/security/perm.h~reiser4-remove-typedefs
+++ a/fs/reiser4/plugin/security/perm.h
@@ -9,61 +9,17 @@
 #include "../plugin_header.h"
 
 #include <linux/types.h>
-#include <linux/fs.h>		/* for struct file  */
-#include <linux/dcache.h>	/* for struct dentry */
 
-/* interface for perm plugin.
-
-   Perm plugin method can be implemented through:
-
-    1. consulting ->i_mode bits in stat data
-
-    2. obtaining acl from the tree and inspecting it
-
-    3. asking some kernel module or user-level program to authorize access.
-
-   This allows for integration with things like capabilities, SELinux-style
-   secutiry contexts, etc.
-
-*/
-/* NIKITA-FIXME-HANS: define what this is targeted for.  It does not seem to be intended for use with sys_reiser4.  Explain. */
+/* Definition of permission plugin */
+/* NIKITA-FIXME-HANS: define what this is targeted for.
+   It does not seem to be intended for use with sys_reiser4.  Explain. */
+
+/* NOTE-EDWARD: This seems to be intended for deprecated sys_reiser4.
+   Consider it like a temporary "seam" and reserved pset member.
+   If you have something usefull to add, then rename this plugin and add here */
 typedef struct perm_plugin {
 	/* generic plugin fields */
 	plugin_header h;
-
-	/* check permissions for read/write */
-	int (*read_ok) (struct file *file, const char __user *buf,
-			size_t size, loff_t *off);
-	int (*write_ok) (struct file *file, const char __user *buf,
-			 size_t size, loff_t *off);
-
-	/* check permissions for lookup */
-	int (*lookup_ok) (struct inode * parent, struct dentry * dentry);
-
-	/* check permissions for create */
-	int (*create_ok) (struct inode * parent, struct dentry * dentry,
-			  reiser4_object_create_data * data);
-
-	/* check permissions for linking @where to @existing */
-	int (*link_ok) (struct dentry * existing, struct inode * parent,
-			struct dentry * where);
-
-	/* check permissions for unlinking @victim from @parent */
-	int (*unlink_ok) (struct inode * parent, struct dentry * victim);
-
-	/* check permissions for deletion of @object whose last reference is
-	   by @parent */
-	int (*delete_ok) (struct inode * parent, struct dentry * victim);
-	int (*mask_ok) (struct inode * inode, int mask);
-	/* check whether attribute change is acceptable */
-	int (*setattr_ok) (struct dentry * dentry, struct iattr * attr);
-
-	/* check whether stat(2) is allowed */
-	int (*getattr_ok) (struct vfsmount * mnt UNUSED_ARG,
-			   struct dentry * dentry, struct kstat * stat);
-	/* check whether rename(2) is allowed */
-	int (*rename_ok) (struct inode * old_dir, struct dentry * old,
-			  struct inode * new_dir, struct dentry * new);
 } perm_plugin;
 
 typedef enum { NULL_PERM_ID, LAST_PERM_ID } reiser4_perm_id;
diff -puN fs/reiser4/pool.c~reiser4-remove-typedefs fs/reiser4/pool.c
--- a/fs/reiser4/pool.c~reiser4-remove-typedefs
+++ a/fs/reiser4/pool.c
@@ -50,9 +50,8 @@
 #include <linux/types.h>
 #include <linux/err.h>
 
-/* initialize new pool object */
-static void reiser4_init_pool_obj(reiser4_pool_header * h	/* pool object to
-								 * initialize */ )
+/* initialize new pool object @h */
+static void reiser4_init_pool_obj(struct reiser4_pool_header * h)
 {
 	INIT_LIST_HEAD(&h->usage_linkage);
 	INIT_LIST_HEAD(&h->level_linkage);
@@ -60,12 +59,12 @@ static void reiser4_init_pool_obj(reiser
 }
 
 /* initialize new pool */
-void reiser4_init_pool(reiser4_pool * pool /* pool to initialize */ ,
+void reiser4_init_pool(struct reiser4_pool * pool /* pool to initialize */ ,
 		       size_t obj_size /* size of objects in @pool */ ,
 		       int num_of_objs /* number of preallocated objects */ ,
 		       char *data /* area for preallocated objects */ )
 {
-	reiser4_pool_header *h;
+	struct reiser4_pool_header *h;
 	int i;
 
 	assert("nikita-955", pool != NULL);
@@ -81,7 +80,7 @@ void reiser4_init_pool(reiser4_pool * po
 	INIT_LIST_HEAD(&pool->extra);
 	memset(data, 0, obj_size * num_of_objs);
 	for (i = 0; i < num_of_objs; ++i) {
-		h = (reiser4_pool_header *) (data + i * obj_size);
+		h = (struct reiser4_pool_header *) (data + i * obj_size);
 		reiser4_init_pool_obj(h);
 		/* add pool header to the end of pool's free list */
 		list_add_tail(&h->usage_linkage, &pool->free);
@@ -94,20 +93,19 @@ void reiser4_init_pool(reiser4_pool * po
    allocated objects.
 
 */
-void reiser4_done_pool(reiser4_pool * pool UNUSED_ARG /* pool to destroy */ )
+void reiser4_done_pool(struct reiser4_pool * pool UNUSED_ARG)
 {
 }
 
-/* allocate carry object from pool
+/* allocate carry object from @pool
 
    First, try to get preallocated object. If this fails, resort to dynamic
    allocation.
 
 */
-static void *reiser4_pool_alloc(reiser4_pool * pool	/* pool to allocate object
-							 * from */ )
+static void *reiser4_pool_alloc(struct reiser4_pool * pool)
 {
-	reiser4_pool_header *result;
+	struct reiser4_pool_header *result;
 
 	assert("nikita-959", pool != NULL);
 
@@ -117,7 +115,8 @@ static void *reiser4_pool_alloc(reiser4_
 		linkage = pool->free.next;
 		list_del(linkage);
 		INIT_LIST_HEAD(linkage);
-		result = list_entry(linkage, reiser4_pool_header, usage_linkage);
+		result = list_entry(linkage, struct reiser4_pool_header,
+				    usage_linkage);
 		BUG_ON(!list_empty(&result->level_linkage) ||
 		       !list_empty(&result->extra_linkage));
 	} else {
@@ -139,8 +138,8 @@ static void *reiser4_pool_alloc(reiser4_
 }
 
 /* return object back to the pool */
-void reiser4_pool_free(reiser4_pool * pool, reiser4_pool_header * h	/* pool to return object back
-									 * into */ )
+void reiser4_pool_free(struct reiser4_pool * pool,
+		       struct reiser4_pool_header * h)
 {
 	assert("nikita-961", h != NULL);
 	assert("nikita-962", pool != NULL);
@@ -179,18 +178,16 @@ void reiser4_pool_free(reiser4_pool * po
    supplied with at least node whose left delimiting key is to be updated
    (that is "right" node).
 
+   @pool - from which to allocate new object;
+   @list - where to add object;
+   @reference - after (or before) which existing object to add
 */
-reiser4_pool_header *reiser4_add_obj(reiser4_pool * pool /* pool from which to
-							  * allocate new object
-							  */,
-				     struct list_head *list /* list where to add
-							     * object */,
-				     pool_ordering order /* where to add */,
-				     reiser4_pool_header * reference
-				     /* after (or before) which existing object
-					to add */)
+struct reiser4_pool_header *reiser4_add_obj(struct reiser4_pool * pool,
+					 struct list_head *list,
+					 pool_ordering order,
+					 struct reiser4_pool_header * reference)
 {
-	reiser4_pool_header *result;
+	struct reiser4_pool_header *result;
 
 	assert("nikita-972", pool != NULL);
 
diff -puN fs/reiser4/pool.h~reiser4-remove-typedefs fs/reiser4/pool.h
--- a/fs/reiser4/pool.h~reiser4-remove-typedefs
+++ a/fs/reiser4/pool.h
@@ -7,21 +7,21 @@
 
 #include <linux/types.h>
 
-typedef struct reiser4_pool {
+struct reiser4_pool {
 	size_t obj_size;
 	int objs;
 	char *data;
 	struct list_head free;
 	struct list_head used;
 	struct list_head extra;
-} reiser4_pool;
+};
 
-typedef struct reiser4_pool_header {
+struct reiser4_pool_header {
 	/* object is either on free or "used" lists */
 	struct list_head usage_linkage;
 	struct list_head level_linkage;
 	struct list_head extra_linkage;
-} reiser4_pool_header;
+};
 
 typedef enum {
 	POOLO_BEFORE,
@@ -32,14 +32,15 @@ typedef enum {
 
 /* pool manipulation functions */
 
-extern void reiser4_init_pool(reiser4_pool * pool, size_t obj_size,
+extern void reiser4_init_pool(struct reiser4_pool * pool, size_t obj_size,
 			      int num_of_objs, char *data);
-extern void reiser4_done_pool(reiser4_pool * pool);
-extern void reiser4_pool_free(reiser4_pool * pool, reiser4_pool_header * h);
-reiser4_pool_header *reiser4_add_obj(reiser4_pool * pool,
-				     struct list_head * list,
-				     pool_ordering order,
-				     reiser4_pool_header * reference);
+extern void reiser4_done_pool(struct reiser4_pool * pool);
+extern void reiser4_pool_free(struct reiser4_pool * pool,
+			      struct reiser4_pool_header * h);
+struct reiser4_pool_header *reiser4_add_obj(struct reiser4_pool * pool,
+					 struct list_head * list,
+					 pool_ordering order,
+					 struct reiser4_pool_header *reference);
 
 /* __REISER4_POOL_H__ */
 #endif
diff -puN fs/reiser4/readahead.c~reiser4-remove-typedefs fs/reiser4/readahead.c
--- a/fs/reiser4/readahead.c~reiser4-remove-typedefs
+++ a/fs/reiser4/readahead.c
@@ -47,7 +47,7 @@ static int low_on_memory(void)
 /* start read for @node and for a few of its right neighbors */
 void formatted_readahead(znode * node, ra_info_t * info)
 {
-	ra_params_t *ra_params;
+	struct formatted_ra_params *ra_params;
 	znode *cur;
 	int i;
 	int grn_flags;
diff -puN fs/reiser4/readahead.h~reiser4-remove-typedefs fs/reiser4/readahead.h
--- a/fs/reiser4/readahead.h~reiser4-remove-typedefs
+++ a/fs/reiser4/readahead.h
@@ -6,14 +6,17 @@
 #include "key.h"
 
 typedef enum {
-	RA_ADJACENT_ONLY = 1,	/* only requests nodes which are adjacent. Default is NO (not only adjacent) */
+	RA_ADJACENT_ONLY = 1,	/* only requests nodes which are adjacent.
+				   Default is NO (not only adjacent) */
 } ra_global_flags;
 
-/* reiser4 super block has a field of this type. It controls readahead during tree traversals */
-typedef struct formatted_read_ahead_params {
-	unsigned long max;	/* request not more than this amount of nodes. Default is totalram_pages / 4 */
+/* reiser4 super block has a field of this type.
+   It controls readahead during tree traversals */
+struct formatted_ra_params {
+	unsigned long max;	/* request not more than this amount of nodes.
+				   Default is totalram_pages / 4 */
 	int flags;
-} ra_params_t;
+};
 
 typedef struct {
 	reiser4_key key_to_stop;
diff -puN fs/reiser4/safe_link.c~reiser4-remove-typedefs fs/reiser4/safe_link.c
--- a/fs/reiser4/safe_link.c~reiser4-remove-typedefs
+++ a/fs/reiser4/safe_link.c
@@ -194,19 +194,20 @@ int safe_link_del(reiser4_tree * tree, o
  * in-memory structure to keep information extracted from safe-link. This is
  * used to iterate over all safe-links.
  */
-typedef struct {
+struct safe_link_context {
 	reiser4_tree *tree;	/* internal tree */
 	reiser4_key key;	/* safe-link key */
 	reiser4_key sdkey;	/* key of object stat-data */
 	reiser4_safe_link_t link;	/* safe-link type */
 	oid_t oid;		/* object oid */
 	__u64 size;		/* final size for truncate */
-} safe_link_context;
+};
 
 /*
  * start iterating over all safe-links.
  */
-static void safe_link_iter_begin(reiser4_tree * tree, safe_link_context * ctx)
+static void safe_link_iter_begin(reiser4_tree * tree,
+				 struct safe_link_context * ctx)
 {
 	ctx->tree = tree;
 	reiser4_key_init(&ctx->key);
@@ -218,7 +219,7 @@ static void safe_link_iter_begin(reiser4
 /*
  * return next safe-link.
  */
-static int safe_link_iter_next(safe_link_context * ctx)
+static int safe_link_iter_next(struct safe_link_context * ctx)
 {
 	int result;
 	safelink_t sl;
@@ -237,7 +238,7 @@ static int safe_link_iter_next(safe_link
 /*
  * check are there any more safe-links left in the tree.
  */
-static int safe_link_iter_finished(safe_link_context * ctx)
+static int safe_link_iter_finished(struct safe_link_context * ctx)
 {
 	return get_key_locality(&ctx->key) != safe_link_locality(ctx->tree);
 }
@@ -245,7 +246,7 @@ static int safe_link_iter_finished(safe_
 /*
  * finish safe-link iteration.
  */
-static void safe_link_iter_end(safe_link_context * ctx)
+static void safe_link_iter_end(struct safe_link_context * ctx)
 {
 	/* nothing special */
 }
@@ -316,7 +317,7 @@ static int process_safelink(struct super
  */
 int process_safelinks(struct super_block *super)
 {
-	safe_link_context ctx;
+	struct safe_link_context ctx;
 	int result;
 
 	if (rofs_super(super))
diff -puN fs/reiser4/super.h~reiser4-remove-typedefs fs/reiser4/super.h
--- a/fs/reiser4/super.h~reiser4-remove-typedefs
+++ a/fs/reiser4/super.h
@@ -18,12 +18,12 @@
 /*
  * Flush algorithms parameters.
  */
-typedef struct {
+struct flush_params {
 	unsigned relocate_threshold;
 	unsigned relocate_distance;
 	unsigned written_threshold;
 	unsigned scan_maxnodes;
-} flush_params;
+};
 
 typedef enum {
 	/*
@@ -57,11 +57,11 @@ typedef enum {
 /*
  * VFS related operation vectors.
  */
-typedef struct object_ops {
+struct object_ops {
 	struct super_operations super;
 	struct dentry_operations dentry;
 	struct export_operations export;
-} object_ops;
+};
 
 /* reiser4-specific part of super block
 
@@ -223,7 +223,7 @@ struct reiser4_super_info_data {
 	unsigned long optimal_io_size;
 
 	/* parameters for the flush algorithm */
-	flush_params flush;
+	struct flush_params flush;
 
 	/* pointers to jnodes for journal header and footer */
 	jnode *journal_header;
@@ -243,7 +243,7 @@ struct reiser4_super_info_data {
 	/* committed number of files (oid allocator state variable ) */
 	__u64 nr_files_committed;
 
-	ra_params_t ra_params;
+	struct formatted_ra_params ra_params;
 
 	/*
 	 * A mutex for serializing cut tree operation if out-of-free-space:
@@ -261,13 +261,13 @@ struct reiser4_super_info_data {
 	int onerror;
 
 	/* operations for objects on this file system */
-	object_ops ops;
+	struct object_ops ops;
 
 	/*
 	 * structure to maintain d_cursors. See plugin/file_ops_readdir.c for
 	 * more details
 	 */
-	d_cursor_info d_info;
+	struct d_cursor_info d_info;
 
 #ifdef CONFIG_REISER4_BADBLOCKS
 	/* Alternative master superblock offset (in bytes) */
@@ -331,7 +331,7 @@ static inline reiser4_super_info_data *g
 	return get_super_private(reiser4_get_current_sb());
 }
 
-static inline ra_params_t *get_current_super_ra_params(void)
+static inline struct formatted_ra_params *get_current_super_ra_params(void)
 {
 	return &(get_current_super_private()->ra_params);
 }
@@ -370,7 +370,7 @@ static inline int rofs_jnode(jnode * nod
 
 extern __u64 reiser4_current_block_count(void);
 
-extern void build_object_ops(struct super_block *super, object_ops * ops);
+extern void build_object_ops(struct super_block *super, struct object_ops * ops);
 
 #define REISER4_SUPER_MAGIC 0x52345362	/* (*(__u32 *)"R4Sb"); */
 
diff -puN fs/reiser4/super_ops.c~reiser4-remove-typedefs fs/reiser4/super_ops.c
--- a/fs/reiser4/super_ops.c~reiser4-remove-typedefs
+++ a/fs/reiser4/super_ops.c
@@ -29,7 +29,7 @@ static struct dentry *reiser4_debugfs_ro
  */
 static void init_once(void *obj, struct kmem_cache *cache, unsigned long flags)
 {
-	reiser4_inode_object *info;
+	struct reiser4_inode_object *info;
 
 	info = obj;
 
@@ -60,7 +60,7 @@ static void init_once(void *obj, struct 
 static int init_inodes(void)
 {
 	inode_cache = kmem_cache_create("reiser4_inode",
-					sizeof(reiser4_inode_object),
+					sizeof(struct reiser4_inode_object),
 					0,
 					SLAB_HWCACHE_ALIGN |
 					SLAB_RECLAIM_ACCOUNT, init_once, NULL);
@@ -87,7 +87,7 @@ static void done_inodes(void)
  */
 static struct inode *reiser4_alloc_inode(struct super_block *super)
 {
-	reiser4_inode_object *obj;
+	struct reiser4_inode_object *obj;
 
 	assert("nikita-1696", super != NULL);
 	obj = kmem_cache_alloc(inode_cache, reiser4_ctx_gfp_mask_get());
@@ -155,7 +155,7 @@ static void reiser4_destroy_inode(struct
 	loading_destroy(info);
 
 	kmem_cache_free(inode_cache,
-			container_of(info, reiser4_inode_object, p));
+			container_of(info, struct reiser4_inode_object, p));
 }
 
 /**
diff -puN fs/reiser4/txnmgr.h~reiser4-remove-typedefs fs/reiser4/txnmgr.h
--- a/fs/reiser4/txnmgr.h~reiser4-remove-typedefs
+++ a/fs/reiser4/txnmgr.h
@@ -323,11 +323,6 @@ ON_DEBUG(void
 	 count_jnode(txn_atom *, jnode *, atom_list old_list,
 		     atom_list new_list, int check_lists));
 
-typedef struct protected_jnodes {
-	struct list_head inatom; /* link to atom's list these structures */
-	struct list_head nodes; /* head of list of protected nodes */
-} protected_jnodes;
-
 /* A transaction handle: the client obtains and commits this handle which is assigned by
    the system to a txn_atom. */
 struct txn_handle {
@@ -691,8 +686,6 @@ extern int atom_fq_parts_are_clean(txn_a
 extern void add_fq_to_bio(flush_queue_t *, struct bio *);
 extern flush_queue_t *get_fq_for_current_atom(void);
 
-void protected_jnodes_init(protected_jnodes * list);
-void protected_jnodes_done(protected_jnodes * list);
 void reiser4_invalidate_list(struct list_head * head);
 
 # endif				/* __REISER4_TXNMGR_H__ */
diff -puN fs/reiser4/znode.h~reiser4-remove-typedefs fs/reiser4/znode.h
--- a/fs/reiser4/znode.h~reiser4-remove-typedefs
+++ a/fs/reiser4/znode.h
@@ -402,7 +402,7 @@ extern void copy_load_count(load_count *
 
 #if REISER4_DEBUG
 #define STORE_COUNTERS						\
-	reiser4_lock_counters_info __entry_counters =		\
+	reiser4_lock_cnt_info __entry_counters =		\
 		*reiser4_lock_counters()
 #define CHECK_COUNTERS						        \
 ON_DEBUG_CONTEXT(						        \
_

Patches currently in -mm which might be from edward@namesys.com are

reiser4.patch
reiser4-remove-typedefs.patch
reiser4-fix-write_extent.patch
reiser4-make-sync_inodes-non-void.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
reiser4-fix-for-new-aops-patches.patch
git-block-vs-reiser4.patch
