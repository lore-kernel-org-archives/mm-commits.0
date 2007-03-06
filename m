From: akpm@linux-foundation.org
Subject: - fs-reiser4-possible-cleanups.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:59:31 -0800
Message-ID: <200703060159.l261xVw0008609@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46734 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965693AbXCFCCv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:02:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, reiser@namesys.com, vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     fs/reiser4/: possible cleanups
has been removed from the -mm tree.  Its filename was
     fs-reiser4-possible-cleanups.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: fs/reiser4/: possible cleanups
From: Adrian Bunk <bunk@stusta.de>

This patch contains the following possible cleanups:
- make needlessly global code static
- proper prototype for the following function:
  - plugin/file/file.c: init_uf_coord()
- "extern inline" -> "static inline"
- #if 0/comment out the following unused functions:
  - plugin/file/cryptcompress.c: jnode_of_cluster()
  - plugin/plugin.c: force_plugin()
  - plugin/plugin_set.c: plugin_set_compression()
- remove the following unused variable:
  - plugin/file/file.c: xversion

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Cc: Hans Reiser <reiser@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/block_alloc.c                 |   10 +++++-----
 fs/reiser4/flush_queue.c                 |    2 +-
 fs/reiser4/jnode.c                       |    7 ++++---
 fs/reiser4/jnode.h                       |    4 ----
 fs/reiser4/plugin/cluster.h              |    1 -
 fs/reiser4/plugin/file/cryptcompress.c   |    6 ++++--
 fs/reiser4/plugin/file/cryptcompress.h   |    2 --
 fs/reiser4/plugin/file/file.c            |    4 +---
 fs/reiser4/plugin/file/file.h            |    4 ++--
 fs/reiser4/plugin/item/extent_file_ops.c |    2 --
 fs/reiser4/plugin/plugin.c               |    2 ++
 fs/reiser4/plugin/plugin.h               |    1 -
 fs/reiser4/plugin/plugin_set.c           |    2 +-
 fs/reiser4/plugin/plugin_set.h           |    1 -
 fs/reiser4/super.h                       |    1 -
 fs/reiser4/super_ops.c                   |    4 ++--
 fs/reiser4/txnmgr.h                      |    1 -
 17 files changed, 22 insertions(+), 32 deletions(-)

diff -puN fs/reiser4/block_alloc.c~fs-reiser4-possible-cleanups fs/reiser4/block_alloc.c
--- a/fs/reiser4/block_alloc.c~fs-reiser4-possible-cleanups
+++ a/fs/reiser4/block_alloc.c
@@ -554,8 +554,8 @@ reiser4_block_nr fake_blocknr_unformatte
 
 /* adjust sb block counters, if real (on-disk) block allocation immediately
    follows grabbing of free disk space. */
-void grabbed2used(reiser4_context *ctx, reiser4_super_info_data *sbinfo,
-		  __u64 count)
+static void grabbed2used(reiser4_context *ctx, reiser4_super_info_data *sbinfo,
+			 __u64 count)
 {
 	sub_from_ctx_grabbed(ctx, count);
 
@@ -570,8 +570,8 @@ void grabbed2used(reiser4_context *ctx, 
 }
 
 /* adjust sb block counters when @count unallocated blocks get mapped to disk */
-void fake_allocated2used(reiser4_super_info_data *sbinfo, __u64 count,
-			 reiser4_ba_flags_t flags)
+static void fake_allocated2used(reiser4_super_info_data *sbinfo, __u64 count,
+				reiser4_ba_flags_t flags)
 {
 	spin_lock_reiser4_super(sbinfo);
 
@@ -583,7 +583,7 @@ void fake_allocated2used(reiser4_super_i
 	spin_unlock_reiser4_super(sbinfo);
 }
 
-void flush_reserved2used(txn_atom * atom, __u64 count)
+static void flush_reserved2used(txn_atom * atom, __u64 count)
 {
 	reiser4_super_info_data *sbinfo;
 
diff -puN fs/reiser4/flush_queue.c~fs-reiser4-possible-cleanups fs/reiser4/flush_queue.c
--- a/fs/reiser4/flush_queue.c~fs-reiser4-possible-cleanups
+++ a/fs/reiser4/flush_queue.c
@@ -191,7 +191,7 @@ static void done_fq(flush_queue_t * fq)
 }
 
 /* */
-void mark_jnode_queued(flush_queue_t * fq, jnode * node)
+static void mark_jnode_queued(flush_queue_t * fq, jnode * node)
 {
 	JF_SET(node, JNODE_FLUSH_QUEUED);
 	count_enqueued_node(fq);
diff -puN fs/reiser4/jnode.c~fs-reiser4-possible-cleanups fs/reiser4/jnode.c
--- a/fs/reiser4/jnode.c~fs-reiser4-possible-cleanups
+++ a/fs/reiser4/jnode.c
@@ -537,8 +537,9 @@ void unhash_unformatted_jnode(jnode * no
  * allocate new jnode, insert it, and also insert into radix tree for the
  * given inode/mapping.
  */
-jnode *find_get_jnode(reiser4_tree * tree, struct address_space *mapping,
-		      oid_t oid, unsigned long index)
+static jnode *find_get_jnode(reiser4_tree * tree,
+			     struct address_space *mapping,
+			     oid_t oid, unsigned long index)
 {
 	jnode *result;
 	jnode *shadow;
@@ -786,7 +787,7 @@ static inline int jparse(jnode * node)
 
 /* Lock a page attached to jnode, create and attach page to jnode if it had no
  * one. */
-struct page *jnode_get_page_locked(jnode * node, gfp_t gfp_flags)
+static struct page *jnode_get_page_locked(jnode * node, gfp_t gfp_flags)
 {
 	struct page *page;
 
diff -puN fs/reiser4/jnode.h~fs-reiser4-possible-cleanups fs/reiser4/jnode.h
--- a/fs/reiser4/jnode.h~fs-reiser4-possible-cleanups
+++ a/fs/reiser4/jnode.h
@@ -349,12 +349,8 @@ extern jnode *jfind(struct address_space
 extern jnode *jnode_by_page(struct page *pg) NONNULL;
 extern jnode *jnode_of_page(struct page *pg) NONNULL;
 void jnode_attach_page(jnode * node, struct page *pg);
-jnode *find_get_jnode(reiser4_tree * tree,
-		      struct address_space *mapping, oid_t oid,
-		      unsigned long index);
 
 void unhash_unformatted_jnode(jnode *);
-struct page *jnode_get_page_locked(jnode *, gfp_t gfp_flags);
 extern jnode *page_next_jnode(jnode * node) NONNULL;
 extern void jnode_init(jnode * node, reiser4_tree * tree, jnode_type) NONNULL;
 extern void jnode_make_dirty(jnode * node) NONNULL;
diff -puN fs/reiser4/plugin/cluster.h~fs-reiser4-possible-cleanups fs/reiser4/plugin/cluster.h
--- a/fs/reiser4/plugin/cluster.h~fs-reiser4-possible-cleanups
+++ a/fs/reiser4/plugin/cluster.h
@@ -240,7 +240,6 @@ static inline void coord_set_between_clu
 
 int inflate_cluster(reiser4_cluster_t *, struct inode *);
 int find_cluster(reiser4_cluster_t *, struct inode *, int read, int write);
-void forget_cluster_pages(struct page **page, int nrpages);
 int flush_cluster_pages(reiser4_cluster_t *, jnode *, struct inode *);
 int deflate_cluster(reiser4_cluster_t *, struct inode *);
 void truncate_page_cluster(struct inode *inode, cloff_t start);
diff -puN fs/reiser4/plugin/file/cryptcompress.c~fs-reiser4-possible-cleanups fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~fs-reiser4-possible-cleanups
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -380,7 +380,7 @@ static int host_allows_crypto_stat(struc
 }
 #endif  /*  REISER4_DEBUG  */
 
-void detach_crypto_stat(struct inode * inode)
+static void detach_crypto_stat(struct inode * inode)
 {
 	assert("edward-1385", inode != NULL);
 	assert("edward-1386", host_allows_crypto_stat(inode));
@@ -1574,6 +1574,7 @@ static int grab_cluster_pages(struct ino
    understand that pages of cryptcompress files are not
    flushable.
 */
+#if 0
 int jnode_of_cluster(const jnode * node, struct page * page)
 {
 	assert("edward-1339", node != NULL);
@@ -1597,6 +1598,7 @@ int jnode_of_cluster(const jnode * node,
 	}
 	return 0;
 }
+#endif  /*  0  */
 
 /* put cluster pages */
 void release_cluster_pages(reiser4_cluster_t * clust)
@@ -1751,7 +1753,7 @@ static void uncapture_cluster_jnode(jnod
 	jput(node);
 }
 
-void forget_cluster_pages(struct page **pages, int nr)
+static void forget_cluster_pages(struct page **pages, int nr)
 {
 	int i;
 	for (i = 0; i < nr; i++) {
diff -puN fs/reiser4/plugin/file/cryptcompress.h~fs-reiser4-possible-cleanups fs/reiser4/plugin/file/cryptcompress.h
--- a/fs/reiser4/plugin/file/cryptcompress.h~fs-reiser4-possible-cleanups
+++ a/fs/reiser4/plugin/file/cryptcompress.h
@@ -459,7 +459,6 @@ int load_file_hint(struct file *, hint_t
 void save_file_hint(struct file *, const hint_t *);
 void hint_init_zero(hint_t *);
 int crc_inode_ok(struct inode *inode);
-int jnode_of_cluster(const jnode * node, struct page * page);
 extern int ctail_read_disk_cluster (reiser4_cluster_t *, struct inode *, int);
 extern int do_readpage_ctail(struct inode *, reiser4_cluster_t *,
 			     struct page * page);
@@ -472,7 +471,6 @@ void inherit_crypto_stat_common(struct i
 				int (*can_inherit)(struct inode * child,
 						   struct inode * parent));
 void attach_crypto_stat(struct inode * inode, crypto_stat_t * info);
-void detach_crypto_stat(struct inode * inode);
 void change_crypto_stat(struct inode * inode, crypto_stat_t * new);
 crypto_stat_t * alloc_crypto_stat (struct inode * inode);
 
diff -puN fs/reiser4/plugin/file/file.c~fs-reiser4-possible-cleanups fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~fs-reiser4-possible-cleanups
+++ a/fs/reiser4/plugin/file/file.c
@@ -103,7 +103,7 @@ void init_uf_coord(uf_coord_t *uf_coord,
 	uf_coord->valid = 0;
 }
 
-void validate_extended_coord(uf_coord_t *uf_coord, loff_t offset)
+static void validate_extended_coord(uf_coord_t *uf_coord, loff_t offset)
 {
 	assert("vs-1333", uf_coord->valid == 0);
 
@@ -760,8 +760,6 @@ hint_validate(hint_t * hint, const reise
 			     hint->ext_coord.lh, lock_mode, ZNODE_LOCK_LOPRI);
 }
 
-int xversion;
-
 /**
  * find_or_create_extent -
  * @page:
diff -puN fs/reiser4/plugin/file/file.h~fs-reiser4-possible-cleanups fs/reiser4/plugin/file/file.h
--- a/fs/reiser4/plugin/file/file.h~fs-reiser4-possible-cleanups
+++ a/fs/reiser4/plugin/file/file.h
@@ -114,7 +114,6 @@ int find_file_item_nohint(coord_t *, loc
 			  const reiser4_key *, znode_lock_mode,
 			  struct inode *);
 
-void validate_extended_coord(uf_coord_t *, loff_t offset);
 int load_file_hint(struct file *, hint_t *);
 void save_file_hint(struct file *, const hint_t *);
 
@@ -235,8 +234,9 @@ int goto_right_neighbor(coord_t *, lock_
 int find_or_create_extent(struct page *);
 int equal_to_ldk(znode *, const reiser4_key *);
 
+void init_uf_coord(uf_coord_t *uf_coord, lock_handle *lh);
 
-extern inline int cbk_errored(int cbk_result)
+static inline int cbk_errored(int cbk_result)
 {
 	return (cbk_result != CBK_COORD_NOTFOUND
 		&& cbk_result != CBK_COORD_FOUND);
diff -puN fs/reiser4/plugin/item/extent_file_ops.c~fs-reiser4-possible-cleanups fs/reiser4/plugin/item/extent_file_ops.c
--- a/fs/reiser4/plugin/item/extent_file_ops.c~fs-reiser4-possible-cleanups
+++ a/fs/reiser4/plugin/item/extent_file_ops.c
@@ -734,8 +734,6 @@ static int overwrite_extent(uf_coord_t *
 	return count;
 }
 
-void init_uf_coord(uf_coord_t *uf_coord, lock_handle *lh);
-
 /**
  * update_extent
  * @file:
diff -puN fs/reiser4/plugin/plugin.c~fs-reiser4-possible-cleanups fs/reiser4/plugin/plugin.c
--- a/fs/reiser4/plugin/plugin.c~fs-reiser4-possible-cleanups
+++ a/fs/reiser4/plugin/plugin.c
@@ -348,6 +348,7 @@ grab_plugin_from(struct inode *self, pse
 	return result;
 }
 
+#if 0
 int force_plugin(struct inode *self, pset_member memb, reiser4_plugin * plug)
 {
 	reiser4_inode *info;
@@ -362,6 +363,7 @@ int force_plugin(struct inode *self, pse
 		update_plugin_mask(info, memb);
 	return result;
 }
+#endif  /*  0  */
 
 reiser4_plugin_type_data plugins[REISER4_PLUGIN_TYPES] = {
 	/* C90 initializers */
diff -puN fs/reiser4/plugin/plugin.h~fs-reiser4-possible-cleanups fs/reiser4/plugin/plugin.h
--- a/fs/reiser4/plugin/plugin.h~fs-reiser4-possible-cleanups
+++ a/fs/reiser4/plugin/plugin.h
@@ -886,7 +886,6 @@ typedef enum {
 int grab_plugin(struct inode *self, struct inode *ancestor, pset_member memb);
 int grab_plugin_from(struct inode *self, pset_member memb,
 		     reiser4_plugin * plug);
-int force_plugin(struct inode *self, pset_member memb, reiser4_plugin * plug);
 
 /* defined in fs/reiser4/plugin/object.c */
 extern file_plugin file_plugins[LAST_FILE_PLUGIN_ID];
diff -puN fs/reiser4/plugin/plugin_set.c~fs-reiser4-possible-cleanups fs/reiser4/plugin/plugin_set.c
--- a/fs/reiser4/plugin/plugin_set.c~fs-reiser4-possible-cleanups
+++ a/fs/reiser4/plugin/plugin_set.c
@@ -322,7 +322,7 @@ DEFINE_PLUGIN_SET(file_plugin, file)
     DEFINE_PLUGIN_SET(item_plugin, sd)
     /* DEFINE_PLUGIN_SET(cipher_plugin, cipher) */
     /* DEFINE_PLUGIN_SET(digest_plugin, digest) */
-    DEFINE_PLUGIN_SET(compression_plugin, compression)
+    /* DEFINE_PLUGIN_SET(compression_plugin, compression) */
     /* DEFINE_PLUGIN_SET(compression_mode_plugin, compression_mode) */
     DEFINE_PLUGIN_SET(cluster_plugin, cluster)
     /* DEFINE_PLUGIN_SET(regular_plugin, regular_entry) */
diff -puN fs/reiser4/plugin/plugin_set.h~fs-reiser4-possible-cleanups fs/reiser4/plugin/plugin_set.h
--- a/fs/reiser4/plugin/plugin_set.h~fs-reiser4-possible-cleanups
+++ a/fs/reiser4/plugin/plugin_set.h
@@ -57,7 +57,6 @@ extern int plugin_set_formatting(plugin_
 extern int plugin_set_hash(plugin_set ** set, hash_plugin * plug);
 extern int plugin_set_fibration(plugin_set ** set, fibration_plugin * plug);
 extern int plugin_set_sd(plugin_set ** set, item_plugin * plug);
-extern int plugin_set_compression(plugin_set ** set, compression_plugin * plug);
 extern int plugin_set_cluster(plugin_set ** set, cluster_plugin * plug);
 
 extern int init_plugin_set(void);
diff -puN fs/reiser4/super.h~fs-reiser4-possible-cleanups fs/reiser4/super.h
--- a/fs/reiser4/super.h~fs-reiser4-possible-cleanups
+++ a/fs/reiser4/super.h
@@ -452,7 +452,6 @@ extern void destroy_reiser4_cache(kmem_c
 extern struct super_operations reiser4_super_operations;
 extern struct export_operations reiser4_export_operations;
 extern struct dentry_operations reiser4_dentry_operations;
-extern struct dentry *reiser4_debugfs_root;
 
 /* __REISER4_SUPER_H__ */
 #endif
diff -puN fs/reiser4/super_ops.c~fs-reiser4-possible-cleanups fs/reiser4/super_ops.c
--- a/fs/reiser4/super_ops.c~fs-reiser4-possible-cleanups
+++ a/fs/reiser4/super_ops.c
@@ -16,6 +16,8 @@
 /* slab cache for inodes */
 static kmem_cache_t *inode_cache;
 
+static struct dentry *reiser4_debugfs_root = NULL;
+
 /**
  * init_once - constructor for reiser4 inodes
  * @obj: inode to be initialized
@@ -590,8 +592,6 @@ void destroy_reiser4_cache(kmem_cache_t 
 	*cachep = NULL;
 }
 
-struct dentry *reiser4_debugfs_root = NULL;
-
 /**
  * init_reiser4 - reiser4 initialization entry point
  *
diff -puN fs/reiser4/txnmgr.h~fs-reiser4-possible-cleanups fs/reiser4/txnmgr.h
--- a/fs/reiser4/txnmgr.h~fs-reiser4-possible-cleanups
+++ a/fs/reiser4/txnmgr.h
@@ -661,7 +661,6 @@ extern void fq_put_nolock(flush_queue_t 
 extern void fq_put(flush_queue_t *);
 extern void fuse_fq(txn_atom * to, txn_atom * from);
 extern void queue_jnode(flush_queue_t *, jnode *);
-extern void mark_jnode_queued(flush_queue_t *, jnode *);
 
 extern int write_fq(flush_queue_t *, long *, int);
 extern int current_atom_finish_all_fq(void);
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
remove-fs-jffs2-ioctlc.patch
git-ubi.patch
drivers-net-vioc-possible-cleanups.patch
net-uninline-skb_put-fix.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
lguest-kconfig-and-headers-fix.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
