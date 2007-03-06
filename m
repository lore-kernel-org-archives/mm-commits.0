From: akpm@linux-foundation.org
Subject: - reiser4-rename-generic_sounding_globalspatch.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:59:52 -0800
Message-ID: <200703060159.l261xqLQ008655@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46587 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965582AbXCFCAM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:00:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward@namesys.com, reiser@namesys.com, vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: rename generic sounding globals
has been removed from the -mm tree.  Its filename was
     reiser4-rename-generic_sounding_globalspatch.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: rename generic sounding globals
From: Edward Shishkin <edward@namesys.com>

Cc: Hans Reiser <reiser@namesys.com>
Cc: Vladimir Saveliev <vs@namesys.com>
Signed-off-by: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/as_ops.c                           |   36 +-
 fs/reiser4/block_alloc.c                      |   71 ++---
 fs/reiser4/block_alloc.h                      |   14 -
 fs/reiser4/blocknrset.c                       |    2 
 fs/reiser4/carry.c                            |  139 +++++----
 fs/reiser4/carry.h                            |   20 -
 fs/reiser4/carry_ops.c                        |  112 ++++----
 fs/reiser4/context.c                          |   33 +-
 fs/reiser4/context.h                          |   10 
 fs/reiser4/debug.c                            |   52 +--
 fs/reiser4/debug.h                            |   73 ++---
 fs/reiser4/entd.c                             |   16 -
 fs/reiser4/entd.h                             |    8 
 fs/reiser4/eottl.c                            |    6 
 fs/reiser4/export_ops.c                       |    6 
 fs/reiser4/flush.c                            |  102 +++----
 fs/reiser4/flush.h                            |   14 -
 fs/reiser4/flush_queue.c                      |   46 +--
 fs/reiser4/fsdata.c                           |   72 ++---
 fs/reiser4/fsdata.h                           |   33 +-
 fs/reiser4/init_super.c                       |   30 +-
 fs/reiser4/inode.c                            |   33 +-
 fs/reiser4/inode.h                            |   22 -
 fs/reiser4/jnode.c                            |   30 +-
 fs/reiser4/jnode.h                            |   14 -
 fs/reiser4/kassign.c                          |   14 -
 fs/reiser4/kassign.h                          |    2 
 fs/reiser4/key.c                              |   12 
 fs/reiser4/key.h                              |    8 
 fs/reiser4/ktxnmgrd.c                         |   10 
 fs/reiser4/ktxnmgrd.h                         |    4 
 fs/reiser4/lock.c                             |   58 ++--
 fs/reiser4/lock.h                             |    8 
 fs/reiser4/page_cache.c                       |   29 +-
 fs/reiser4/page_cache.h                       |   12 
 fs/reiser4/plugin/cluster.h                   |   10 
 fs/reiser4/plugin/dir_plugin_common.c         |  158 +++++------
 fs/reiser4/plugin/disk_format/disk_format40.c |   33 +-
 fs/reiser4/plugin/file/cryptcompress.c        |  203 +++++++-------
 fs/reiser4/plugin/file/cryptcompress.h        |    8 
 fs/reiser4/plugin/file/file.c                 |  224 ++++++++--------
 fs/reiser4/plugin/file/file.h                 |   10 
 fs/reiser4/plugin/file/invert.c               |    4 
 fs/reiser4/plugin/file/symlink.c              |   41 +-
 fs/reiser4/plugin/file/tail_conversion.c      |   68 ++--
 fs/reiser4/plugin/file_ops.c                  |   19 -
 fs/reiser4/plugin/file_ops_readdir.c          |   92 +++---
 fs/reiser4/plugin/file_plugin_common.c        |  119 ++++----
 fs/reiser4/plugin/inode_ops.c                 |  104 +++----
 fs/reiser4/plugin/inode_ops_rename.c          |   50 ++-
 fs/reiser4/plugin/item/blackbox.c             |    2 
 fs/reiser4/plugin/item/cde.c                  |   19 -
 fs/reiser4/plugin/item/cde.h                  |    2 
 fs/reiser4/plugin/item/ctail.c                |   53 ++-
 fs/reiser4/plugin/item/extent.c               |   17 -
 fs/reiser4/plugin/item/extent.h               |   32 +-
 fs/reiser4/plugin/item/extent_file_ops.c      |  156 ++++++-----
 fs/reiser4/plugin/item/extent_flush_ops.c     |   75 +++--
 fs/reiser4/plugin/item/extent_item_ops.c      |   41 +-
 fs/reiser4/plugin/item/internal.c             |    7 
 fs/reiser4/plugin/item/internal.h             |    6 
 fs/reiser4/plugin/item/item.c                 |   20 -
 fs/reiser4/plugin/item/item.h                 |    6 
 fs/reiser4/plugin/item/sde.c                  |    4 
 fs/reiser4/plugin/item/static_stat.c          |   34 +-
 fs/reiser4/plugin/item/tail.c                 |   45 +--
 fs/reiser4/plugin/item/tail.h                 |    6 
 fs/reiser4/plugin/node/node.c                 |    2 
 fs/reiser4/plugin/node/node40.c               |   45 +--
 fs/reiser4/plugin/object.c                    |  148 +++++-----
 fs/reiser4/plugin/object.h                    |   74 ++---
 fs/reiser4/plugin/plugin.c                    |   39 +-
 fs/reiser4/plugin/plugin_header.h             |   16 -
 fs/reiser4/plugin/plugin_set.c                |    5 
 fs/reiser4/plugin/space/bitmap.c              |   40 +-
 fs/reiser4/plugin/space/bitmap.h              |   34 +-
 fs/reiser4/plugin/space/space_allocator.h     |   18 -
 fs/reiser4/pool.c                             |   21 -
 fs/reiser4/pool.h                             |    7 
 fs/reiser4/readahead.c                        |   14 -
 fs/reiser4/readahead.h                        |    2 
 fs/reiser4/safe_link.c                        |   20 -
 fs/reiser4/seal.c                             |   47 +--
 fs/reiser4/seal.h                             |    8 
 fs/reiser4/search.c                           |   76 ++---
 fs/reiser4/status_flags.c                     |    4 
 fs/reiser4/super.c                            |   18 -
 fs/reiser4/super.h                            |   30 +-
 fs/reiser4/super_ops.c                        |   83 +++--
 fs/reiser4/tap.c                              |   30 +-
 fs/reiser4/tap.h                              |   25 -
 fs/reiser4/tree.c                             |  133 ++++-----
 fs/reiser4/tree.h                             |   51 +--
 fs/reiser4/tree_mod.c                         |   49 +--
 fs/reiser4/tree_mod.h                         |    6 
 fs/reiser4/tree_walk.c                        |    5 
 fs/reiser4/txnmgr.c                           |  185 ++++++-------
 fs/reiser4/txnmgr.h                           |   61 ++--
 fs/reiser4/vfs_ops.c                          |    8 
 fs/reiser4/vfs_ops.h                          |    2 
 fs/reiser4/wander.c                           |   80 ++---
 fs/reiser4/wander.h                           |    4 
 fs/reiser4/writeout.h                         |    2 
 fs/reiser4/znode.c                            |   17 -
 fs/reiser4/znode.h                            |   21 -
 105 files changed, 2203 insertions(+), 2046 deletions(-)

diff -puN fs/reiser4/as_ops.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/as_ops.c
--- a/fs/reiser4/as_ops.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/as_ops.c
@@ -51,7 +51,7 @@
  * @page: page to be dirtied
  *
  * Operation of struct address_space_operations. This implementation is used by
- * unix and crc file plugins.
+ * unix and cryptcompress file plugins.
  *
  * This is called when reiser4 page gets dirtied outside of reiser4, for
  * example, when dirty bit is moved from pte to physical page.
@@ -66,11 +66,11 @@ int reiser4_set_page_dirty(struct page *
 	/* this page can be unformatted only */
 	assert("vs-1734", (page->mapping &&
 			   page->mapping->host &&
-			   get_super_fake(page->mapping->host->i_sb) !=
+			   reiser4_get_super_fake(page->mapping->host->i_sb) !=
 			   page->mapping->host
-			   && get_cc_fake(page->mapping->host->i_sb) !=
+			   && reiser4_get_cc_fake(page->mapping->host->i_sb) !=
 			   page->mapping->host
-			   && get_bitmap_fake(page->mapping->host->i_sb) !=
+			   && reiser4_get_bitmap_fake(page->mapping->host->i_sb) !=
 			   page->mapping->host));
 
 	if (!TestSetPageDirty(page)) {
@@ -109,7 +109,7 @@ static int filler(void *vp, struct page 
  * @nr_pages: number of pages no the list
  *
  * Operation of struct address_space_operations. This implementation is used by
- * unix and crc file plugins.
+ * unix and cryptcompress file plugins.
  *
  * Calls read_cache_pages or readpages hook if it is set.
  */
@@ -120,7 +120,7 @@ reiser4_readpages(struct file *file, str
 	reiser4_context *ctx;
 	reiser4_file_fsdata *fsdata;
 
-	ctx = init_context(mapping->host->i_sb);
+	ctx = reiser4_init_context(mapping->host->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
@@ -191,9 +191,9 @@ void reiser4_invalidatepage(struct page 
 	 *
 	 * After many troubles with vmtruncate() based truncate (including
 	 * races with flush, tail conversion, etc.) it was re-written in the
-	 * top-to-bottom style: items are killed in cut_tree_object() and
-	 * pages belonging to extent are invalidated in kill_hook_extent(). So
-	 * probably now additional call to capture is not needed here.
+	 * top-to-bottom style: items are killed in reiser4_cut_tree_object()
+	 * and pages belonging to extent are invalidated in kill_hook_extent().
+	 * So probably now additional call to capture is not needed here.
 	 */
 
 	assert("nikita-3137", PageLocked(page));
@@ -207,11 +207,11 @@ void reiser4_invalidatepage(struct page 
 	 * during mount) it is simpler to let ->invalidatepage to be called on
 	 * them. Check for this, and do nothing.
 	 */
-	if (get_super_fake(inode->i_sb) == inode)
+	if (reiser4_get_super_fake(inode->i_sb) == inode)
 		return;
-	if (get_cc_fake(inode->i_sb) == inode)
+	if (reiser4_get_cc_fake(inode->i_sb) == inode)
 		return;
-	if (get_bitmap_fake(inode->i_sb) == inode)
+	if (reiser4_get_bitmap_fake(inode->i_sb) == inode)
 		return;
 	assert("vs-1426", PagePrivate(page));
 	assert("vs-1427",
@@ -220,7 +220,7 @@ void reiser4_invalidatepage(struct page 
 	assert("", ergo(inode_file_plugin(inode) !=
 			file_plugin_by_id(CRC_FILE_PLUGIN_ID), offset == 0));
 
-	ctx = init_context(inode->i_sb);
+	ctx = reiser4_init_context(inode->i_sb);
 	if (IS_ERR(ctx))
 		return;
 
@@ -232,7 +232,7 @@ void reiser4_invalidatepage(struct page 
 		jref(node);
 		JF_SET(node, JNODE_HEARD_BANSHEE);
 		page_clear_jnode(page, node);
-		uncapture_jnode(node);
+		reiser4_uncapture_jnode(node);
 		unhash_unformatted_jnode(node);
 		jput(node);
 		reiser4_exit_context(ctx);
@@ -251,7 +251,7 @@ void reiser4_invalidatepage(struct page 
 		JF_SET(node, JNODE_HEARD_BANSHEE);
 		/* page cannot be detached from jnode concurrently, because it
 		 * is locked */
-		uncapture_page(page);
+		reiser4_uncapture_page(page);
 
 		/* this detaches page from jnode, so that jdelete will not try
 		 * to lock page which is already locked */
@@ -288,7 +288,7 @@ int jnode_is_releasable(jnode * node /* 
 	 * clean, not it atom yet, and still having fake block number. For
 	 * example, node just created in jinit_new().
 	 */
-	if (blocknr_is_fake(jnode_get_block(node)))
+	if (reiser4_blocknr_is_fake(jnode_get_block(node)))
 		return 0;
 
 	/*
@@ -336,7 +336,7 @@ int reiser4_releasepage(struct page *pag
 	assert("nikita-2257", PagePrivate(page));
 	assert("nikita-2259", PageLocked(page));
 	assert("nikita-2892", !PageWriteback(page));
-	assert("nikita-3019", schedulable());
+	assert("nikita-3019", reiser4_schedulable());
 
 	/* NOTE-NIKITA: this can be called in the context of reiser4 call. It
 	   is not clear what to do in this case. A lot of deadlocks seems be
@@ -373,7 +373,7 @@ int reiser4_releasepage(struct page *pag
 	} else {
 		spin_unlock(&(node->load));
 		spin_unlock_jnode(node);
-		assert("nikita-3020", schedulable());
+		assert("nikita-3020", reiser4_schedulable());
 		return 0;
 	}
 }
diff -puN fs/reiser4/block_alloc.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/block_alloc.c
--- a/fs/reiser4/block_alloc.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/block_alloc.c
@@ -119,20 +119,20 @@
    impossible to overload this counter during one transaction life. */
 
 /* Initialize a blocknr hint. */
-void blocknr_hint_init(reiser4_blocknr_hint * hint)
+void reiser4_blocknr_hint_init(reiser4_blocknr_hint * hint)
 {
 	memset(hint, 0, sizeof(reiser4_blocknr_hint));
 }
 
 /* Release any resources of a blocknr hint. */
-void blocknr_hint_done(reiser4_blocknr_hint * hint UNUSED_ARG)
+void reiser4_blocknr_hint_done(reiser4_blocknr_hint * hint UNUSED_ARG)
 {
 	/* No resources should be freed in current blocknr_hint implementation. */
 }
 
 /* see above for explanation of fake block number.  */
 /* Audited by: green(2002.06.11) */
-int blocknr_is_fake(const reiser4_block_nr * da)
+int reiser4_blocknr_is_fake(const reiser4_block_nr * da)
 {
 	/* The reason for not simply returning result of '&' operation is that
 	   while return value is (possibly 32bit) int,  the reiser4_block_nr is
@@ -218,13 +218,13 @@ static void sub_from_atom_flush_reserved
 /* super block has 6 counters: free, used, grabbed, fake allocated
    (formatted and unformatted) and flush reserved. Their sum must be
    number of blocks on a device. This function checks this */
-int check_block_counters(const struct super_block *super)
+int reiser4_check_block_counters(const struct super_block *super)
 {
 	__u64 sum;
 
 	sum = reiser4_grabbed_blocks(super) + reiser4_free_blocks(super) +
 	    reiser4_data_blocks(super) + reiser4_fake_allocated(super) +
-	    reiser4_fake_allocated_unformatted(super) + flush_reserved(super) +
+	    reiser4_fake_allocated_unformatted(super) + reiser4_flush_reserved(super) +
 	    reiser4_clustered_blocks(super);
 	if (reiser4_block_count(super) != sum) {
 		printk("super block counters: "
@@ -237,7 +237,7 @@ int check_block_counters(const struct su
 		       (unsigned long long)reiser4_fake_allocated(super),
 		       (unsigned long long)
 		       reiser4_fake_allocated_unformatted(super),
-		       (unsigned long long)flush_reserved(super),
+		       (unsigned long long)reiser4_flush_reserved(super),
 		       (unsigned long long)reiser4_clustered_blocks(super),
 		       (unsigned long long)sum,
 		       (unsigned long long)reiser4_block_count(super));
@@ -295,7 +295,7 @@ reiser4_grab(reiser4_context * ctx, __u6
 		ctx->grabbed_initially = count;
 #endif
 
-	assert("nikita-2986", check_block_counters(ctx->super));
+	assert("nikita-2986", reiser4_check_block_counters(ctx->super));
 
 	/* disable grab space in current context */
 	ctx->grab_enabled = 0;
@@ -426,7 +426,7 @@ static void grabbed2fake_allocated_forma
 	sbinfo = grabbed2fake_allocated_head(1);
 	sbinfo->blocks_fake_allocated++;
 
-	assert("vs-922", check_block_counters(reiser4_get_current_sb()));
+	assert("vs-922", reiser4_check_block_counters(reiser4_get_current_sb()));
 
 	spin_unlock_reiser4_super(sbinfo);
 }
@@ -443,7 +443,7 @@ static void grabbed2fake_allocated_unfor
 	sbinfo = grabbed2fake_allocated_head(count);
 	sbinfo->blocks_fake_allocated_unformatted += count;
 
-	assert("vs-9221", check_block_counters(reiser4_get_current_sb()));
+	assert("vs-9221", reiser4_check_block_counters(reiser4_get_current_sb()));
 
 	spin_unlock_reiser4_super(sbinfo);
 }
@@ -462,7 +462,7 @@ void grabbed2cluster_reserved(int count)
 	sub_from_sb_grabbed(sbinfo, count);
 	sbinfo->blocks_clustered += count;
 
-	assert("edward-504", check_block_counters(ctx->super));
+	assert("edward-504", reiser4_check_block_counters(ctx->super));
 
 	spin_unlock_reiser4_super(sbinfo);
 }
@@ -480,7 +480,7 @@ void cluster_reserved2grabbed(int count)
 	sub_from_cluster_reserved(sbinfo, count);
 	sbinfo->blocks_grabbed += count;
 
-	assert("edward-505", check_block_counters(ctx->super));
+	assert("edward-505", reiser4_check_block_counters(ctx->super));
 
 	spin_unlock_reiser4_super(sbinfo);
 	add_to_ctx_grabbed(ctx, count);
@@ -500,7 +500,7 @@ void cluster_reserved2free(int count)
 	sub_from_cluster_reserved(sbinfo, count);
 	sbinfo->blocks_free += count;
 
-	assert("edward-502", check_block_counters(ctx->super));
+	assert("edward-502", reiser4_check_block_counters(ctx->super));
 
 	spin_unlock_reiser4_super(sbinfo);
 }
@@ -564,7 +564,7 @@ static void grabbed2used(reiser4_context
 	sub_from_sb_grabbed(sbinfo, count);
 	sbinfo->blocks_used += count;
 
-	assert("nikita-2679", check_block_counters(ctx->super));
+	assert("nikita-2679", reiser4_check_block_counters(ctx->super));
 
 	spin_unlock_reiser4_super(sbinfo);
 }
@@ -578,7 +578,8 @@ static void fake_allocated2used(reiser4_
 	sub_from_sb_fake_allocated(sbinfo, count, flags);
 	sbinfo->blocks_used += count;
 
-	assert("nikita-2680", check_block_counters(reiser4_get_current_sb()));
+	assert("nikita-2680",
+	       reiser4_check_block_counters(reiser4_get_current_sb()));
 
 	spin_unlock_reiser4_super(sbinfo);
 }
@@ -598,7 +599,8 @@ static void flush_reserved2used(txn_atom
 	sub_from_sb_flush_reserved(sbinfo, count);
 	sbinfo->blocks_used += count;
 
-	assert("zam-789", check_block_counters(reiser4_get_current_sb()));
+	assert("zam-789",
+	       reiser4_check_block_counters(reiser4_get_current_sb()));
 
 	spin_unlock_reiser4_super(sbinfo);
 }
@@ -610,7 +612,7 @@ update_blocknr_hint_default(const struct
 {
 	reiser4_super_info_data *sbinfo = get_super_private(s);
 
-	assert("nikita-3342", !blocknr_is_fake(block));
+	assert("nikita-3342", !reiser4_blocknr_is_fake(block));
 
 	spin_lock_reiser4_super(sbinfo);
 	if (*block < sbinfo->block_count) {
@@ -682,8 +684,8 @@ reiser4_alloc_blocks(reiser4_blocknr_hin
 	}
 
 	ret =
-	    sa_alloc_blocks(get_space_allocator(ctx->super), hint, (int)needed,
-			    blk, len);
+	    sa_alloc_blocks(reiser4_get_space_allocator(ctx->super),
+			    hint, (int)needed, blk, len);
 
 	if (!ret) {
 		assert("zam-680", *blk < reiser4_block_count(ctx->super));
@@ -743,7 +745,8 @@ used2fake_allocated(reiser4_super_info_d
 
 	sub_from_sb_used(sbinfo, count);
 
-	assert("nikita-2681", check_block_counters(reiser4_get_current_sb()));
+	assert("nikita-2681",
+	       reiser4_check_block_counters(reiser4_get_current_sb()));
 
 	spin_unlock_reiser4_super(sbinfo);
 }
@@ -763,7 +766,8 @@ used2flush_reserved(reiser4_super_info_d
 	/*add_to_sb_flush_reserved(sbinfo, count); */
 	sub_from_sb_used(sbinfo, count);
 
-	assert("nikita-2681", check_block_counters(reiser4_get_current_sb()));
+	assert("nikita-2681",
+	       reiser4_check_block_counters(reiser4_get_current_sb()));
 
 	spin_unlock_reiser4_super(sbinfo);
 }
@@ -777,12 +781,12 @@ fake_allocated2grabbed(reiser4_context *
 
 	spin_lock_reiser4_super(sbinfo);
 
-	assert("nikita-2682", check_block_counters(ctx->super));
+	assert("nikita-2682", reiser4_check_block_counters(ctx->super));
 
 	sbinfo->blocks_grabbed += count;
 	sub_from_sb_fake_allocated(sbinfo, count, flags & BA_FORMATTED);
 
-	assert("nikita-2683", check_block_counters(ctx->super));
+	assert("nikita-2683", reiser4_check_block_counters(ctx->super));
 
 	spin_unlock_reiser4_super(sbinfo);
 }
@@ -830,7 +834,7 @@ void grabbed2free(reiser4_context *ctx, 
 
 	sub_from_sb_grabbed(sbinfo, count);
 	sbinfo->blocks_free += count;
-	assert("nikita-2684", check_block_counters(ctx->super));
+	assert("nikita-2684", reiser4_check_block_counters(ctx->super));
 
 	spin_unlock_reiser4_super(sbinfo);
 }
@@ -854,7 +858,7 @@ void grabbed2flush_reserved_nolock(txn_a
 	sbinfo->blocks_flush_reserved += count;
 	sub_from_sb_grabbed(sbinfo, count);
 
-	assert("vpf-292", check_block_counters(ctx->super));
+	assert("vpf-292", reiser4_check_block_counters(ctx->super));
 
 	spin_unlock_reiser4_super(sbinfo);
 }
@@ -888,7 +892,7 @@ void flush_reserved2grabbed(txn_atom * a
 	sbinfo->blocks_grabbed += count;
 	sub_from_sb_flush_reserved(sbinfo, count);
 
-	assert("vpf-292", check_block_counters(ctx->super));
+	assert("vpf-292", reiser4_check_block_counters(ctx->super));
 
 	spin_unlock_reiser4_super(sbinfo);
 }
@@ -920,7 +924,7 @@ used2grabbed(reiser4_context * ctx, reis
 	sbinfo->blocks_grabbed += count;
 	sub_from_sb_used(sbinfo, count);
 
-	assert("nikita-2685", check_block_counters(ctx->super));
+	assert("nikita-2685", reiser4_check_block_counters(ctx->super));
 
 	spin_unlock_reiser4_super(sbinfo);
 }
@@ -933,7 +937,8 @@ static void used2free(reiser4_super_info
 	sbinfo->blocks_free += count;
 	sub_from_sb_used(sbinfo, count);
 
-	assert("nikita-2685", check_block_counters(reiser4_get_current_sb()));
+	assert("nikita-2685",
+	       reiser4_check_block_counters(reiser4_get_current_sb()));
 
 	spin_unlock_reiser4_super(sbinfo);
 }
@@ -986,7 +991,7 @@ reiser4_dealloc_blocks(const reiser4_blo
 	if (REISER4_DEBUG) {
 		assert("zam-431", *len != 0);
 		assert("zam-432", *start != 0);
-		assert("zam-558", !blocknr_is_fake(start));
+		assert("zam-558", !reiser4_blocknr_is_fake(start));
 
 		spin_lock_reiser4_super(sbinfo);
 		assert("zam-562", *start < sbinfo->block_count);
@@ -1019,8 +1024,8 @@ reiser4_dealloc_blocks(const reiser4_blo
 
 	} else {
 		assert("zam-425", get_current_super_private() != NULL);
-		sa_dealloc_blocks(get_space_allocator(ctx->super), *start,
-				  *len);
+		sa_dealloc_blocks(reiser4_get_space_allocator(ctx->super),
+				  *start, *len);
 
 		if (flags & BA_PERMANENT) {
 			/* These blocks were counted as allocated, we have to revert it
@@ -1063,7 +1068,7 @@ reiser4_dealloc_blocks(const reiser4_blo
 }
 
 /* wrappers for block allocator plugin methods */
-int pre_commit_hook(void)
+int reiser4_pre_commit_hook(void)
 {
 	assert("zam-502", get_current_super_private() != NULL);
 	sa_pre_commit_hook();
@@ -1104,7 +1109,7 @@ apply_dset(txn_atom * atom UNUSED_ARG, c
 	return 0;
 }
 
-void post_commit_hook(void)
+void reiser4_post_commit_hook(void)
 {
 	txn_atom *atom;
 
@@ -1120,7 +1125,7 @@ void post_commit_hook(void)
 	sa_post_commit_hook();
 }
 
-void post_write_back_hook(void)
+void reiser4_post_write_back_hook(void)
 {
 	assert("zam-504", get_current_super_private() != NULL);
 
diff -puN fs/reiser4/block_alloc.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/block_alloc.h
--- a/fs/reiser4/block_alloc.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/block_alloc.h
@@ -82,8 +82,8 @@ enum reiser4_ba_flags {
 
 typedef enum reiser4_ba_flags reiser4_ba_flags_t;
 
-extern void blocknr_hint_init(reiser4_blocknr_hint * hint);
-extern void blocknr_hint_done(reiser4_blocknr_hint * hint);
+extern void reiser4_blocknr_hint_init(reiser4_blocknr_hint * hint);
+extern void reiser4_blocknr_hint_done(reiser4_blocknr_hint * hint);
 extern void update_blocknr_hint_default(const struct super_block *,
 					const reiser4_block_nr *);
 extern void get_blocknr_hint_default(reiser4_block_nr *);
@@ -140,13 +140,13 @@ extern void reiser4_release_reserved(str
 
 extern void flush_reserved2grabbed(txn_atom * atom, __u64 count);
 
-extern int blocknr_is_fake(const reiser4_block_nr * da);
+extern int reiser4_blocknr_is_fake(const reiser4_block_nr * da);
 
 extern void grabbed2cluster_reserved(int count);
 extern void cluster_reserved2grabbed(int count);
 extern void cluster_reserved2free(int count);
 
-extern int check_block_counters(const struct super_block *);
+extern int reiser4_check_block_counters(const struct super_block *);
 
 #if REISER4_DEBUG
 
@@ -158,9 +158,9 @@ extern void reiser4_check_block(const re
 
 #endif
 
-extern int pre_commit_hook(void);
-extern void post_commit_hook(void);
-extern void post_write_back_hook(void);
+extern int reiser4_pre_commit_hook(void);
+extern void reiser4_post_commit_hook(void);
+extern void reiser4_post_write_back_hook(void);
 
 #endif				/* __FS_REISER4_BLOCK_ALLOC_H__ */
 
diff -puN fs/reiser4/blocknrset.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/blocknrset.c
--- a/fs/reiser4/blocknrset.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/blocknrset.c
@@ -81,7 +81,7 @@ static blocknr_set_entry *bse_alloc(void
 	blocknr_set_entry *e;
 
 	if ((e = (blocknr_set_entry *) kmalloc(sizeof(blocknr_set_entry),
-					       get_gfp_mask())) == NULL)
+					   reiser4_ctx_gfp_mask_get())) == NULL)
 		return NULL;
 
 	bse_init(e);
diff -puN fs/reiser4/carry.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/carry.c
--- a/fs/reiser4/carry.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/carry.c
@@ -61,7 +61,7 @@ I feel uneasy about this pool.  It adds 
        //   COP_UPDATE    --- update delimiting key in least
        //                     common ancestor of two
 
-       op = post_carry( &lowest_level, operation, node, 0 );
+       op = reiser4_post_carry( &lowest_level, operation, node, 0 );
        if( IS_ERR( op ) || ( op == NULL ) ) {
            handle error
        } else {
@@ -80,7 +80,7 @@ I feel uneasy about this pool.  It adds 
 
        ....
 
-       // note, that last argument to post_carry() is non-null
+       // note, that last argument to reiser4_post_carry() is non-null
        // here, because @op is to be applied to the parent of @node, rather
        // than to the @node itself as in the previous case.
 
@@ -117,8 +117,8 @@ I feel uneasy about this pool.  It adds 
     2. whole balancing logic is implemented here, in particular, insertion
     logic is coded in make_space().
 
-    3. special cases like insertion (add_tree_root()) or deletion
-    (kill_tree_root()) of tree root and morphing of paste into insert
+    3. special cases like insertion (reiser4_add_tree_root()) or deletion
+    (reiser4_kill_tree_root()) of tree root and morphing of paste into insert
     (insert_paste()) have to be handled.
 
     4. there is non-trivial interdependency between allocation of new nodes
@@ -190,9 +190,11 @@ static int carry_level_invariant(carry_l
    For usage, see comment at the top of fs/reiser4/carry.c
 
 */
-int carry(carry_level * doing /* set of carry operations to be performed */ ,
-	  carry_level * done	/* set of nodes, already performed at the
-				 * previous level. NULL in most cases */ )
+int reiser4_carry(carry_level * doing /* set of carry operations to be
+				       * performed */ ,
+		  carry_level * done  /* set of nodes, already performed
+				       *  at the previous level.
+				       * NULL in most cases */)
 {
 	int result = 0;
 	/* queue of new requests */
@@ -266,7 +268,7 @@ int carry(carry_level * doing /* set of 
 		init_carry_level(todo, doing->pool);
 
 		/* give other threads chance to run */
-		preempt_point();
+		reiser4_preempt_point();
 	}
 	done_carry_level(done);
 
@@ -357,7 +359,7 @@ static int carry_on_level(carry_level * 
 		for_all_nodes(doing, scan, tmp_scan) {
 			znode *node;
 
-			node = carry_real(scan);
+			node = reiser4_carry_real(scan);
 			assert("nikita-2547", node != NULL);
 			if (node_is_empty(node)) {
 				result =
@@ -385,14 +387,14 @@ static int carry_on_level(carry_level * 
    caller to guarantee proper ordering of node queue.
 
 */
-carry_op *post_carry(carry_level * level	/* queue where new operation is to
-						 * be posted at */ ,
-		     carry_opcode op /* opcode of operation */ ,
-		     znode * node	/* node on which this operation
-					 * will operate */ ,
-		     int apply_to_parent_p	/* whether operation will operate
-						 * directly on @node or on it
-						 * parent. */ )
+carry_op * reiser4_post_carry(carry_level * level /* queue where new operation
+						   * is to be posted at */ ,
+			      carry_opcode op /* opcode of operation */ ,
+			      znode * node	/* node on which this operation
+						 * will operate */ ,
+			      int apply_to_parent_p /* whether operation will
+						     * operate directly on @node
+						     * or on it parent. */)
 {
 	carry_op *result;
 	carry_node *child;
@@ -403,7 +405,7 @@ carry_op *post_carry(carry_level * level
 	result = add_op(level, POOLO_LAST, NULL);
 	if (IS_ERR(result))
 		return result;
-	child = add_carry(level, POOLO_LAST, NULL);
+	child = reiser4_add_carry(level, POOLO_LAST, NULL);
 	if (IS_ERR(child)) {
 		reiser4_pool_free(&level->pool->op_pool, &result->header);
 		return (carry_op *) child;
@@ -438,7 +440,7 @@ carry_pool *init_carry_pool(int size)
 	carry_pool *pool;
 
 	assert("", size >= sizeof(carry_pool) + 3 * sizeof(carry_level));
-	pool = kmalloc(size, get_gfp_mask());
+	pool = kmalloc(size, reiser4_ctx_gfp_mask_get());
 	if (pool == NULL)
 		return ERR_PTR(RETERR(-ENOMEM));
 
@@ -466,15 +468,17 @@ void done_carry_pool(carry_pool * pool /
    automatically. To control ordering use @order and @reference parameters.
 
 */
-carry_node *add_carry_skip(carry_level * level	/* &carry_level to add node
-						 * to */ ,
-			   pool_ordering order	/* where to insert: at the
-						 * beginning of @level,
-						 * before @reference, after
-						 * @reference, at the end
-						 * of @level */ ,
-			   carry_node * reference	/* reference node for
-							 * insertion */ )
+carry_node *reiser4_add_carry_skip(carry_level * level	/* &carry_level to add
+							 * node to */ ,
+				   pool_ordering order	/* where to insert:
+							 * at the beginning of
+							 * @level,
+							 * before @reference,
+							 * after @reference,
+							 * at the end of @level
+							 */ ,
+				   carry_node * reference/* reference node for
+							  * insertion */)
 {
 	ON_DEBUG(carry_node * orig_ref = reference);
 
@@ -497,11 +501,12 @@ carry_node *add_carry_skip(carry_level *
 	}
 	assert("nikita-2209",
 	       ergo(orig_ref != NULL,
-		    carry_real(reference) == carry_real(orig_ref)));
-	return add_carry(level, order, reference);
+		    reiser4_carry_real(reference) ==
+		    reiser4_carry_real(orig_ref)));
+	return reiser4_add_carry(level, order, reference);
 }
 
-carry_node *add_carry(carry_level * level	/* &carry_level to add node
+carry_node *reiser4_add_carry(carry_level * level	/* &carry_level to add node
 						 * to */ ,
 		      pool_ordering order	/* where to insert: at the
 						 * beginning of @level, before
@@ -513,8 +518,9 @@ carry_node *add_carry(carry_level * leve
 	carry_node *result;
 
 	result =
-	    (carry_node *) add_obj(&level->pool->node_pool, &level->nodes,
-				   order, &reference->header);
+	    (carry_node *) reiser4_add_obj(&level->pool->node_pool,
+					   &level->nodes,
+					   order, &reference->header);
 	if (!IS_ERR(result) && (result != NULL))
 		++level->nodes_num;
 	return result;
@@ -537,8 +543,8 @@ static carry_op *add_op(carry_level * le
 	carry_op *result;
 
 	result =
-	    (carry_op *) add_obj(&level->pool->op_pool, &level->ops, order,
-				 &reference->header);
+	    (carry_op *) reiser4_add_obj(&level->pool->op_pool, &level->ops,
+					 order, &reference->header);
 	if (!IS_ERR(result) && (result != NULL))
 		++level->ops_num;
 	return result;
@@ -563,16 +569,16 @@ static carry_node *find_begetting_brothe
 	assert("nikita-1614", node != NULL);
 	assert("nikita-1615", kin != NULL);
 	assert("nikita-1616", LOCK_CNT_GTZ(rw_locked_tree));
-	assert("nikita-1619", ergo(carry_real(node) != NULL,
-				   ZF_ISSET(carry_real(node), JNODE_ORPHAN)));
-
+	assert("nikita-1619", ergo(reiser4_carry_real(node) != NULL,
+				   ZF_ISSET(reiser4_carry_real(node),
+					    JNODE_ORPHAN)));
 	for (scan = node;;
 	     scan = list_entry(scan->header.level_linkage.prev, carry_node,
 			       header.level_linkage)) {
 		assert("nikita-1617", &kin->nodes != &scan->header.level_linkage);
 		if ((scan->node != node->node) &&
 		    !ZF_ISSET(scan->node, JNODE_ORPHAN)) {
-			assert("nikita-1618", carry_real(scan) != NULL);
+			assert("nikita-1618", reiser4_carry_real(scan) != NULL);
 			break;
 		}
 	}
@@ -606,13 +612,13 @@ carry_node *find_carry_node(carry_level 
 	assert("nikita-2203", node != NULL);
 
 	for_all_nodes(level, scan, tmp_scan) {
-		if (carry_real(scan) == node)
+		if (reiser4_carry_real(scan) == node)
 			return scan;
 	}
 	return NULL;
 }
 
-znode *carry_real(const carry_node * node)
+znode *reiser4_carry_real(const carry_node * node)
 {
 	assert("nikita-3061", node != NULL);
 
@@ -651,12 +657,12 @@ static carry_node *add_carry_atplace(car
 	reference = insert_carry_node(doing, todo, node);
 	assert("nikita-2997", reference != NULL);
 
-	return add_carry(todo, POOLO_BEFORE, reference);
+	return reiser4_add_carry(todo, POOLO_BEFORE, reference);
 }
 
-/* like post_carry(), but designed to be called from node plugin methods.
-   This function is different from post_carry() in that it finds proper place
-   to insert node in the queue. */
+/* like reiser4_post_carry(), but designed to be called from node plugin methods.
+   This function is different from reiser4_post_carry() in that it finds proper
+   place to insert node in the queue. */
 carry_op *node_post_carry(carry_plugin_info * info	/* carry parameters
 							 * passed down to node
 							 * plugin */ ,
@@ -674,7 +680,8 @@ carry_op *node_post_carry(carry_plugin_i
 	assert("nikita-2208", info->todo != NULL);
 
 	if (info->doing == NULL)
-		return post_carry(info->todo, op, node, apply_to_parent_p);
+		return reiser4_post_carry(info->todo, op, node,
+					  apply_to_parent_p);
 
 	result = add_op(info->todo, POOLO_LAST, NULL);
 	if (IS_ERR(result))
@@ -792,8 +799,8 @@ static void unlock_carry_level(carry_lev
 		spot = NULL;
 		/* update delimiting keys */
 		for_all_nodes(level, node, tmp_node) {
-			if (carry_real(node) != spot) {
-				spot = carry_real(node);
+			if (reiser4_carry_real(node) != spot) {
+				spot = reiser4_carry_real(node);
 				sync_dkeys(spot);
 			}
 		}
@@ -806,9 +813,10 @@ static void unlock_carry_level(carry_lev
 	for_all_nodes_back(level, node, tmp_node) {
 		/* all allocated nodes should be already linked to their
 		   parents at this moment. */
-		assert("nikita-1631", ergo(!failure, !ZF_ISSET(carry_real(node),
-							       JNODE_ORPHAN)));
-		ON_DEBUG(check_dkeys(carry_real(node)));
+		assert("nikita-1631",
+		       ergo(!failure, !ZF_ISSET(reiser4_carry_real(node),
+						JNODE_ORPHAN)));
+		ON_DEBUG(check_dkeys(reiser4_carry_real(node)));
 		unlock_carry_node(level, node, failure);
 	}
 	level->new_root = NULL;
@@ -849,7 +857,7 @@ static void done_carry_level(carry_level
 int lock_carry_node_tail(carry_node * node /* node to complete locking of */ )
 {
 	assert("nikita-1052", node != NULL);
-	assert("nikita-1187", carry_real(node) != NULL);
+	assert("nikita-1187", reiser4_carry_real(node) != NULL);
 	assert("nikita-1188", !node->unlock);
 
 	node->unlock = 1;
@@ -861,7 +869,7 @@ int lock_carry_node_tail(carry_node * no
 
 	   Corresponding zrelse() is in unlock_carry_node()
 	 */
-	return zload(carry_real(node));
+	return zload(reiser4_carry_real(node));
 }
 
 /* lock carry node
@@ -997,7 +1005,7 @@ unlock_carry_node(carry_level * level,
 
 	assert("nikita-884", node != NULL);
 
-	real_node = carry_real(node);
+	real_node = reiser4_carry_real(node);
 	/* pair to zload() in lock_carry_node_tail() */
 	zrelse(real_node);
 	if (node->unlock && (real_node != NULL)) {
@@ -1080,7 +1088,7 @@ static void fatal_carry_error(carry_leve
 
    This function itself only manages changes in carry structures and delegates
    all hard work (allocation of znode for new root, changes of parent and
-   sibling pointers to the add_tree_root().
+   sibling pointers to the reiser4_add_tree_root().
 
    Locking: old tree root is locked by carry at this point. Fake znode is also
    locked.
@@ -1106,7 +1114,7 @@ static int add_new_root(carry_level * le
 	   tree root right now.
 	 */
 	if (level->new_root == NULL)
-		level->new_root = add_tree_root(node->node, fake);
+		level->new_root = reiser4_add_tree_root(node->node, fake);
 	if (!IS_ERR(level->new_root)) {
 		assert("nikita-1210", znode_is_root(level->new_root));
 		node->deallocate = 1;
@@ -1128,7 +1136,7 @@ static int add_new_root(carry_level * le
    Allocate new znode, add it into carry queue and post into @todo queue
    request to add pointer to new node into its parent.
 
-   This is carry related routing that calls new_node() to allocate new
+   This is carry related routing that calls reiser4_new_node() to allocate new
    node.
 */
 carry_node *add_new_znode(znode * brother	/* existing left neighbor of new
@@ -1161,14 +1169,15 @@ carry_node *add_new_znode(znode * brothe
 
 	 */
 
-	fresh = add_carry_skip(doing, ref ? POOLO_AFTER : POOLO_LAST, ref);
+	fresh =	reiser4_add_carry_skip(doing,
+				       ref ? POOLO_AFTER : POOLO_LAST, ref);
 	if (IS_ERR(fresh))
 		return fresh;
 
 	fresh->deallocate = 1;
 	fresh->free = 1;
 
-	new_znode = new_node(brother, znode_get_level(brother));
+	new_znode = reiser4_new_node(brother, znode_get_level(brother));
 	if (IS_ERR(new_znode))
 		/* @fresh will be deallocated automatically by error
 		   handling code in the caller. */
@@ -1180,14 +1189,15 @@ carry_node *add_new_znode(znode * brothe
 	ZF_SET(new_znode, JNODE_ORPHAN);
 	fresh->node = new_znode;
 
-	while (ZF_ISSET(carry_real(ref), JNODE_ORPHAN)) {
+	while (ZF_ISSET(reiser4_carry_real(ref), JNODE_ORPHAN)) {
 		ref = carry_node_prev(ref);
 		assert("nikita-1606", !carry_node_end(doing, ref));
 	}
 
 	info.todo = todo;
 	info.doing = doing;
-	add_pointer = node_post_carry(&info, COP_INSERT, carry_real(ref), 1);
+	add_pointer = node_post_carry(&info, COP_INSERT,
+				      reiser4_carry_real(ref), 1);
 	if (IS_ERR(add_pointer)) {
 		/* no need to deallocate @new_znode here: it will be
 		   deallocated during carry error handling. */
@@ -1238,8 +1248,8 @@ static int carry_level_invariant(carry_l
 				right = node->node;
 				left = carry_node_prev(node)->node;
 			} else {
-				right = carry_real(node);
-				left = carry_real(carry_node_prev(node));
+				right = reiser4_carry_real(node);
+				left = reiser4_carry_real(carry_node_prev(node));
 			}
 			if (right == NULL || left == NULL)
 				continue;
@@ -1319,7 +1329,8 @@ static void print_op(const char *prefix 
 	case COP_PASTE:
 		print_coord("\tcoord",
 			    op->u.insert.d ? op->u.insert.d->coord : NULL, 0);
-		print_key("\tkey", op->u.insert.d ? op->u.insert.d->key : NULL);
+		reiser4_print_key("\tkey",
+				  op->u.insert.d ? op->u.insert.d->key : NULL);
 		print_carry("\tchild", op->u.insert.child);
 		break;
 	case COP_DELETE:
diff -puN fs/reiser4/carry.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/carry.h
--- a/fs/reiser4/carry.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/carry.h
@@ -312,8 +312,8 @@ struct carry_level {
 	int nodes_num;
 	/* new root created on this level, if any */
 	znode *new_root;
-	/* This is set by caller (insert_by_key(), resize_item(), etc.) when
-	   they want ->tracked to automagically wander to the node where
+	/* This is set by caller (insert_by_key(), rreiser4_esize_item(), etc.)
+	   when they want ->tracked to automagically wander to the node where
 	   insertion point moved after insert or paste.
 	 */
 	carry_track_type track_type;
@@ -329,12 +329,12 @@ struct carry_plugin_info {
 	carry_level *todo;
 };
 
-int carry(carry_level * doing, carry_level * done);
+int reiser4_carry(carry_level * doing, carry_level * done);
 
-carry_node *add_carry(carry_level * level, pool_ordering order,
-		      carry_node * reference);
-carry_node *add_carry_skip(carry_level * level, pool_ordering order,
-			   carry_node * reference);
+carry_node *reiser4_add_carry(carry_level * level, pool_ordering order,
+			      carry_node * reference);
+carry_node *reiser4_add_carry_skip(carry_level * level, pool_ordering order,
+				   carry_node * reference);
 
 extern carry_node *insert_carry_node(carry_level * doing,
 				     carry_level * todo, const znode * node);
@@ -344,8 +344,8 @@ extern void done_carry_pool(carry_pool *
 
 extern void init_carry_level(carry_level * level, carry_pool * pool);
 
-extern carry_op *post_carry(carry_level * level, carry_opcode op, znode * node,
-			    int apply_to_parent);
+extern carry_op *reiser4_post_carry(carry_level * level, carry_opcode op,
+				    znode * node, int apply_to_parent);
 extern carry_op *node_post_carry(carry_plugin_info * info, carry_opcode op,
 				 znode * node, int apply_to_parent_p);
 
@@ -354,7 +354,7 @@ carry_node *add_new_znode(znode * brothe
 
 carry_node *find_carry_node(carry_level * level, const znode * node);
 
-extern znode *carry_real(const carry_node * node);
+extern znode *reiser4_carry_real(const carry_node * node);
 
 /* helper macros to iterate over carry queues */
 
diff -puN fs/reiser4/carry_ops.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/carry_ops.c
--- a/fs/reiser4/carry_ops.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/carry_ops.c
@@ -51,10 +51,11 @@ static carry_node *find_left_neighbor(ca
 	tree = current_tree;
 	read_lock_tree(tree);
 	/* first, check whether left neighbor is already in a @doing queue */
-	if (carry_real(node)->left != NULL) {
+	if (reiser4_carry_real(node)->left != NULL) {
 		/* NOTE: there is locking subtlety here. Look into
 		 * find_right_neighbor() for more info */
-		if (find_carry_node(doing, carry_real(node)->left) != NULL) {
+		if (find_carry_node(doing,
+				    reiser4_carry_real(node)->left) != NULL) {
 			read_unlock_tree(tree);
 			left = node;
 			do {
@@ -62,13 +63,14 @@ static carry_node *find_left_neighbor(ca
 						  carry_node, header.level_linkage);
 				assert("nikita-3408", !carry_node_end(doing,
 								      left));
-			} while (carry_real(left) == carry_real(node));
+			} while (reiser4_carry_real(left) ==
+				 reiser4_carry_real(node));
 			return left;
 		}
 	}
 	read_unlock_tree(tree);
 
-	left = add_carry_skip(doing, POOLO_BEFORE, node);
+	left = reiser4_add_carry_skip(doing, POOLO_BEFORE, node);
 	if (IS_ERR(left))
 		return left;
 
@@ -80,7 +82,8 @@ static carry_node *find_left_neighbor(ca
 		flags |= GN_NO_ALLOC;
 
 	/* then, feeling lucky, peek left neighbor in the cache. */
-	result = reiser4_get_left_neighbor(&left->lock_handle, carry_real(node),
+	result = reiser4_get_left_neighbor(&left->lock_handle,
+					   reiser4_carry_real(node),
 					   ZNODE_WRITE_LOCK, flags);
 	if (result == 0) {
 		/* ok, node found and locked. */
@@ -133,7 +136,7 @@ static carry_node *find_right_neighbor(c
 	tree = current_tree;
 	read_lock_tree(tree);
 	/* first, check whether right neighbor is already in a @doing queue */
-	if (carry_real(node)->right != NULL) {
+	if (reiser4_carry_real(node)->right != NULL) {
 		/*
 		 * Tree lock is taken here anyway, because, even if _outcome_
 		 * of (find_carry_node() != NULL) doesn't depends on
@@ -154,7 +157,8 @@ static carry_node *find_right_neighbor(c
 		 * couldn't change, because node cannot be inserted between
 		 * locked neighbors.
 		 */
-		if (find_carry_node(doing, carry_real(node)->right) != NULL) {
+		if (find_carry_node(doing,
+				    reiser4_carry_real(node)->right) != NULL) {
 			read_unlock_tree(tree);
 			/*
 			 * What we are doing here (this is also applicable to
@@ -190,7 +194,8 @@ static carry_node *find_right_neighbor(c
 						   carry_node, header.level_linkage);
 				assert("nikita-3408", !carry_node_end(doing,
 								      right));
-			} while (carry_real(right) == carry_real(node));
+			} while (reiser4_carry_real(right) ==
+				 reiser4_carry_real(node));
 			return right;
 		}
 	}
@@ -202,11 +207,12 @@ static carry_node *find_right_neighbor(c
 
 	/* then, try to lock right neighbor */
 	init_lh(&lh);
-	result = reiser4_get_right_neighbor(&lh, carry_real(node),
+	result = reiser4_get_right_neighbor(&lh,
+					    reiser4_carry_real(node),
 					    ZNODE_WRITE_LOCK, flags);
 	if (result == 0) {
 		/* ok, node found and locked. */
-		right = add_carry_skip(doing, POOLO_AFTER, node);
+		right = reiser4_add_carry_skip(doing, POOLO_AFTER, node);
 		if (!IS_ERR(right)) {
 			right->node = lh.node;
 			move_lh(&right->lock_handle, &lh);
@@ -301,11 +307,11 @@ static int find_new_child_coord(carry_op
 	assert("nikita-941", op != NULL);
 	assert("nikita-942", op->op == COP_INSERT);
 
-	node = carry_real(op->node);
+	node = reiser4_carry_real(op->node);
 	assert("nikita-943", node != NULL);
 	assert("nikita-944", node_plugin_by_node(node) != NULL);
 
-	child = carry_real(op->u.insert.child);
+	child = reiser4_carry_real(op->u.insert.child);
 	result =
 	    find_new_child_ptr(node, child, op->u.insert.brother,
 			       op->u.insert.d->coord);
@@ -348,12 +354,13 @@ static znode *sync_op(carry_op * op, car
 	insertion_node = op->u.insert.d->coord->node;
 	/* if insertion point was actually moved into new node,
 	   update carry node pointer in operation. */
-	if (insertion_node != carry_real(op->node)) {
+	if (insertion_node != reiser4_carry_real(op->node)) {
 		op->node = target;
-		assert("nikita-2540", carry_real(target) == insertion_node);
+		assert("nikita-2540",
+		       reiser4_carry_real(target) == insertion_node);
 	}
 	assert("nikita-2541",
-	       carry_real(op->node) == op->u.insert.d->coord->node);
+	       reiser4_carry_real(op->node) == op->u.insert.d->coord->node);
 	return insertion_node;
 }
 
@@ -416,7 +423,7 @@ static int make_space(carry_op * op /* c
 	       op->op == COP_INSERT ||
 	       op->op == COP_PASTE || op->op == COP_EXTENT);
 	assert("nikita-1607",
-	       carry_real(op->node) == op->u.insert.d->coord->node);
+	       reiser4_carry_real(op->node) == op->u.insert.d->coord->node);
 
 	flags = op->u.insert.flags;
 
@@ -469,7 +476,8 @@ static int make_space(carry_op * op /* c
 			/* shift everything possible on the left of and
 			   including insertion coord into the left neighbor */
 			result = carry_shift_data(LEFT_SIDE, coord,
-						  carry_real(left), doing, todo,
+						  reiser4_carry_real(left),
+						  doing, todo,
 						  flags & COPI_GO_LEFT);
 
 			/* reget node from coord: shift_left() might move
@@ -501,7 +509,7 @@ static int make_space(carry_op * op /* c
 			   excluding insertion coord into the right neighbor
 			 */
 			result = carry_shift_data(RIGHT_SIDE, coord,
-						  carry_real(right),
+						  reiser4_carry_real(right),
 						  doing, todo,
 						  flags & COPI_GO_RIGHT);
 			/* reget node from coord: shift_right() might move
@@ -546,7 +554,7 @@ static int make_space(carry_op * op /* c
 
 		/* Try to shift into new node. */
 		result = lock_carry_node(doing, fresh);
-		zput(carry_real(fresh));
+		zput(reiser4_carry_real(fresh));
 		if (result != 0) {
 			warning("nikita-947",
 				"Cannot lock new node: %i", result);
@@ -569,7 +577,8 @@ static int make_space(carry_op * op /* c
 		    (blk_alloc > 0) ||
 		    coord_is_after_rightmost(op->u.insert.d->coord);
 
-		result = carry_shift_data(RIGHT_SIDE, coord, carry_real(fresh),
+		result = carry_shift_data(RIGHT_SIDE, coord,
+					  reiser4_carry_real(fresh),
 					  doing, todo, gointo);
 		/* if insertion point was actually moved into new node,
 		   update carry node pointer in operation. */
@@ -601,7 +610,7 @@ static int make_space(carry_op * op /* c
 		result = -E_NODE_FULL;
 	}
 	assert("nikita-1622", ergo(result == 0,
-				   carry_real(op->node) == coord->node));
+				  reiser4_carry_real(op->node) == coord->node));
 	assert("nikita-2616", coord == op->u.insert.d->coord);
 	if (result == 0)
 		result = make_space_tail(op, doing, orig_node);
@@ -688,7 +697,7 @@ static int insert_paste_common(carry_op 
 		/* NOTE-NIKITA Lookup bias is fixed to FIND_EXACT. Complain
 		   if you need something else. */
 		op->u.insert.d->coord = coord;
-		node = carry_real(op->node);
+		node = reiser4_carry_real(op->node);
 		intra_node = node_plugin_by_node(node)->lookup
 		    (node, op->u.insert.d->key, FIND_EXACT,
 		     op->u.insert.d->coord);
@@ -708,9 +717,9 @@ static int insert_paste_common(carry_op 
 		op->u.insert.d = cdata;
 		op->u.insert.d->coord = coord;
 		op->u.insert.d->data = data;
-		op->u.insert.d->coord->node = carry_real(op->node);
+		op->u.insert.d->coord->node = reiser4_carry_real(op->node);
 		result = find_new_child_coord(op);
-		child = carry_real(op->u.insert.child);
+		child = reiser4_carry_real(op->u.insert.child);
 		if (result != NS_NOT_FOUND) {
 			warning("nikita-993",
 				"Cannot find a place for child pointer: %i",
@@ -741,7 +750,8 @@ static int insert_paste_common(carry_op 
 		   moved into another node. Handle this by creating new carry
 		   node for insertion point if necessary.
 		 */
-		if (carry_real(op->node) != op->u.insert.d->coord->node) {
+		if (reiser4_carry_real(op->node) !=
+		    op->u.insert.d->coord->node) {
 			pool_ordering direction;
 			znode *z1;
 			znode *z2;
@@ -753,7 +763,7 @@ static int insert_paste_common(carry_op 
 			 * moved. Do this by comparing delimiting keys.
 			 */
 			z1 = op->u.insert.d->coord->node;
-			z2 = carry_real(op->node);
+			z2 = reiser4_carry_real(op->node);
 			if (keyle(leftmost_key_in_node(z1, &k1),
 				  leftmost_key_in_node(z2, &k2)))
 				/* insertion point moved to the left */
@@ -762,7 +772,8 @@ static int insert_paste_common(carry_op 
 				/* insertion point moved to the right */
 				direction = POOLO_AFTER;
 
-			op->node = add_carry_skip(doing, direction, op->node);
+			op->node = reiser4_add_carry_skip(doing,
+							  direction, op->node);
 			if (IS_ERR(op->node))
 				return PTR_ERR(op->node);
 			op->node->node = op->u.insert.d->coord->node;
@@ -784,7 +795,7 @@ static int insert_paste_common(carry_op 
 		op->u.insert.d->data->arg = op->u.insert.brother;
 	} else {
 		assert("vs-243", op->u.insert.d->coord != NULL);
-		op->u.insert.d->coord->node = carry_real(op->node);
+		op->u.insert.d->coord->node = reiser4_carry_real(op->node);
 	}
 
 	/* find free space. */
@@ -942,9 +953,10 @@ make_space_by_shift_left(carry_op * op, 
 	orig = flow_insert_point(op)->node;
 	/* try to shift content of node @orig from its head upto insert point
 	   including insertion point into the left neighbor */
-	carry_shift_data(LEFT_SIDE, flow_insert_point(op), carry_real(left), doing, todo, 1	/* including insert
-												 * point */ );
-	if (carry_real(left) != flow_insert_point(op)->node) {
+	carry_shift_data(LEFT_SIDE, flow_insert_point(op),
+			 reiser4_carry_real(left), doing, todo,
+			 1 /* including insert point */);
+	if (reiser4_carry_real(left) != flow_insert_point(op)->node) {
 		/* insertion point did not move */
 		return 1;
 	}
@@ -983,10 +995,9 @@ make_space_by_shift_right(carry_op * op,
 	if (right) {
 		/* shift everything possible on the right of but excluding
 		   insertion coord into the right neighbor */
-		carry_shift_data(RIGHT_SIDE, flow_insert_point(op), carry_real(right), doing, todo, 0	/* not
-													 * including
-													 * insert
-													 * point */ );
+		carry_shift_data(RIGHT_SIDE, flow_insert_point(op),
+				 reiser4_carry_real(right), doing, todo,
+				 0 /* not including insert point */);
 	} else {
 		/* right neighbor either does not exist or is unformatted
 		   node */
@@ -1023,17 +1034,15 @@ make_space_by_new_nodes(carry_op * op, c
 		return PTR_ERR(new);
 	}
 	result = lock_carry_node(doing, new);
-	zput(carry_real(new));
+	zput(reiser4_carry_real(new));
 	if (unlikely(result)) {
 		return result;
 	}
 	op->u.insert_flow.new_nodes++;
 	if (!coord_is_after_rightmost(flow_insert_point(op))) {
-		carry_shift_data(RIGHT_SIDE, flow_insert_point(op), carry_real(new), doing, todo, 0	/* not
-													 * including
-													 * insert
-													 * point */ );
-
+		carry_shift_data(RIGHT_SIDE, flow_insert_point(op),
+				 reiser4_carry_real(new), doing, todo,
+				 0 /* not including insert point */);
 		assert("vs-901",
 		       coord_is_after_rightmost(flow_insert_point(op)));
 
@@ -1049,7 +1058,7 @@ make_space_by_new_nodes(carry_op * op, c
 			return PTR_ERR(new);
 		}
 		result = lock_carry_node(doing, new);
-		zput(carry_real(new));
+		zput(reiser4_carry_real(new));
 		if (unlikely(result)) {
 			return result;
 		}
@@ -1057,7 +1066,8 @@ make_space_by_new_nodes(carry_op * op, c
 	}
 
 	/* move insertion point to new node */
-	coord_init_before_first_item(flow_insert_point(op), carry_real(new));
+	coord_init_before_first_item(flow_insert_point(op),
+				     reiser4_carry_real(new));
 	op->node = new;
 	return 0;
 }
@@ -1226,9 +1236,9 @@ static int carry_delete(carry_op * op /*
 	coord_init_zero(&coord);
 	coord_init_zero(&coord2);
 
-	parent = carry_real(op->node);
+	parent = reiser4_carry_real(op->node);
 	child = op->u.delete.child ?
-	    carry_real(op->u.delete.child) : op->node->node;
+		reiser4_carry_real(op->u.delete.child) : op->node->node;
 	tree = znode_get_tree(child);
 	read_lock_tree(tree);
 
@@ -1258,8 +1268,8 @@ static int carry_delete(carry_op * op /*
 	    node_num_items(parent) == 1) {
 		/* Delimiting key manipulations. */
 		write_lock_dk(tree);
-		znode_set_ld_key(child, znode_set_ld_key(parent, min_key()));
-		znode_set_rd_key(child, znode_set_rd_key(parent, max_key()));
+		znode_set_ld_key(child, znode_set_ld_key(parent, reiser4_min_key()));
+		znode_set_rd_key(child, znode_set_rd_key(parent, reiser4_max_key()));
 		ZF_SET(child, JNODE_DKSET);
 		write_unlock_dk(tree);
 
@@ -1308,7 +1318,7 @@ static int carry_delete(carry_op * op /*
 	    /* don't kill roots at and lower than twig level */
 	    znode_get_level(parent) > REISER4_MIN_TREE_HEIGHT &&
 	    node_num_items(parent) == 1) {
-		result = kill_tree_root(coord.node);
+		result = reiser4_kill_tree_root(coord.node);
 	}
 
 	return result < 0 ? : 0;
@@ -1334,7 +1344,7 @@ static int carry_cut(carry_op * op /* op
 	info.doing = doing;
 	info.todo = todo;
 
-	nplug = node_plugin_by_node(carry_real(op->node));
+	nplug = node_plugin_by_node(reiser4_carry_real(op->node));
 	if (op->u.cut_or_kill.is_cut)
 		result = nplug->cut(op->u.cut_or_kill.u.cut, &info);
 	else
@@ -1760,7 +1770,7 @@ static int carry_update(carry_op * op /*
 	if (lchild != NULL) {
 		assert("nikita-1001", lchild->parent);
 		assert("nikita-1003", !lchild->left);
-		left = carry_real(lchild);
+		left = reiser4_carry_real(lchild);
 	} else
 		left = NULL;
 
@@ -1900,7 +1910,7 @@ static carry_node *find_dir_carry(carry_
 		if (carry_node_end(level, neighbor))
 			/* list head is reached */
 			return NULL;
-		if (carry_real(neighbor) != carry_real(node))
+		if (reiser4_carry_real(neighbor) != reiser4_carry_real(node))
 			return neighbor;
 	}
 }
diff -puN fs/reiser4/context.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/context.c
--- a/fs/reiser4/context.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/context.c
@@ -19,8 +19,9 @@
  *
  * In such situations "child" context acts like dummy: all activity is
  * actually performed in the top level context, and get_current_context()
- * always returns top level context. Of course, init_context()/done_context()
- * have to be properly nested any way.
+ * always returns top level context.
+ * Of course, reiser4_init_context()/reiser4_done_context() have to be properly
+ * nested any way.
  *
  * Note that there is an important difference between reiser4 uses
  * ->fs_context and the way other file systems use it. Other file systems
@@ -41,7 +42,8 @@
 #include <linux/hardirq.h>
 
 
-static void _init_context(reiser4_context * context, struct super_block *super)
+static void _reiser4_init_context(reiser4_context * context,
+				  struct super_block *super)
 {
 	memset(context, 0, sizeof(*context));
 
@@ -54,7 +56,7 @@ static void _init_context(reiser4_contex
 
 	init_lock_stack(&context->stack);
 
-	txn_begin(context);
+	reiser4_txn_begin(context);
 
 	/* initialize head of tap list */
 	INIT_LIST_HEAD(&context->taps);
@@ -69,8 +71,7 @@ static void _init_context(reiser4_contex
    This function should be called at the beginning of reiser4 part of
    syscall.
 */
-reiser4_context *init_context(struct super_block *super	/* super block we are going to
-							 * work with */ )
+reiser4_context * reiser4_init_context(struct super_block * super)
 {
 	reiser4_context *context;
 
@@ -89,7 +90,7 @@ reiser4_context *init_context(struct sup
 	if (context == NULL)
 		return ERR_PTR(RETERR(-ENOMEM));
 
-	_init_context(context, super);
+	_reiser4_init_context(context, super);
 	return context;
 }
 
@@ -102,7 +103,7 @@ void init_stack_context(reiser4_context 
 	assert("nikita-3358", super->s_op == NULL || is_reiser4_super(super));
 	assert("vs-12", !is_in_reiser4_context());
 
-	_init_context(context, super);
+	_reiser4_init_context(context, super);
 	context->on_stack = 1;
 	return;
 }
@@ -165,7 +166,7 @@ static void balance_dirty_pages_at(reise
    thread released all locks and closed transcrash etc.
 
 */
-static void done_context(reiser4_context * context /* context being released */ )
+static void reiser4_done_context(reiser4_context * context /* context being released */ )
 {
 	assert("nikita-860", context != NULL);
 	assert("nikita-859", context->magic == context_magic);
@@ -177,8 +178,8 @@ static void done_context(reiser4_context
 	if (context->nr_children == 0) {
 		assert("jmacd-673", context->trans == NULL);
 		assert("jmacd-1002", lock_stack_isclean(&context->stack));
-		assert("nikita-1936", no_counters_are_held());
-		assert("nikita-2626", list_empty_careful(taps_list()));
+		assert("nikita-1936", reiser4_no_counters_are_held());
+		assert("nikita-2626", list_empty_careful(reiser4_taps_list()));
 		assert("zam-1004", ergo(get_super_private(context->super),
 					get_super_private(context->super)->delete_sema_owner !=
 					current));
@@ -222,11 +223,11 @@ static void done_context(reiser4_context
  */
 void reiser4_exit_context(reiser4_context * context)
 {
-	assert("nikita-3021", schedulable());
+	assert("nikita-3021", reiser4_schedulable());
 
 	if (context->nr_children == 0) {
 		if (!context->nobalance) {
-			txn_restart(context);
+			reiser4_txn_restart(context);
 			balance_dirty_pages_at(context);
 		}
 
@@ -248,12 +249,12 @@ void reiser4_exit_context(reiser4_contex
 				spin_unlock_atom(atom);
 			}
 		}
-		txn_end(context);
+		reiser4_txn_end(context);
 	}
-	done_context(context);
+	reiser4_done_context(context);
 }
 
-void set_gfp_mask(void)
+void reiser4_ctx_gfp_mask_set(void)
 {
 	reiser4_context *ctx;
 
diff -puN fs/reiser4/context.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/context.h
--- a/fs/reiser4/context.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/context.h
@@ -60,7 +60,7 @@ struct reiser4_context {
 	 * ->i_mutex */
 	unsigned int nobalance:1;
 
-	/* this bit is used on done_context to decide whether context is
+	/* this bit is used on reiser4_done_context to decide whether context is
 	   kmalloc-ed and has to be kfree-ed */
 	unsigned int on_stack:1;
 
@@ -77,7 +77,7 @@ struct reiser4_context {
 #if REISER4_DEBUG
 	/* debugging information about reiser4 locks held by the current
 	 * thread */
-	lock_counters_info locks;
+	reiser4_lock_counters_info locks;
 	struct task_struct *task;	/* so we can easily find owner of the stack */
 
 	/*
@@ -107,7 +107,7 @@ extern void print_contexts(void);
 #define current_blocksize reiser4_get_current_sb()->s_blocksize
 #define current_blocksize_bits reiser4_get_current_sb()->s_blocksize_bits
 
-extern reiser4_context *init_context(struct super_block *);
+extern reiser4_context *reiser4_init_context(struct super_block *);
 extern void init_stack_context(reiser4_context *, struct super_block *);
 extern void reiser4_exit_context(reiser4_context *);
 
@@ -146,7 +146,7 @@ static inline reiser4_context *get_curre
 	return get_context(current);
 }
 
-static inline gfp_t get_gfp_mask(void)
+static inline gfp_t reiser4_ctx_gfp_mask_get(void)
 {
 	reiser4_context *ctx;
 
@@ -154,7 +154,7 @@ static inline gfp_t get_gfp_mask(void)
 	return (ctx == NULL) ? GFP_KERNEL : ctx->gfp_mask;
 }
 
-void set_gfp_mask(void);
+void reiser4_ctx_gfp_mask_set(void);
 
 /*
  * true if current thread is in the write-out mode. Thread enters write-out
diff -puN fs/reiser4/debug.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/debug.c
--- a/fs/reiser4/debug.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/debug.c
@@ -9,15 +9,17 @@
  *
  *     panicking: reiser4_do_panic(), reiser4_print_prefix().
  *
- *     locking: schedulable(), lock_counters(), print_lock_counters(),
- *     no_counters_are_held(), commit_check_locks()
+ *     locking:
+ *     reiser4_schedulable(), reiser4_lock_counters(), print_lock_counters(),
+ *     reiser4_no_counters_are_held(), reiser4_commit_check_locks()
  *
- *     error code monitoring (see comment before RETERR macro): return_err(),
- *     report_err().
+ *     error code monitoring (see comment before RETERR macro):
+ *     reiser4_return_err(), reiser4_report_err().
  *
  *     stack back-tracing: fill_backtrace()
  *
- *     miscellaneous: preempt_point(), call_on_each_assert(), debugtrap().
+ *     miscellaneous: reiser4_preempt_point(), call_on_each_assert(),
+ *     reiser4_debugtrap().
  *
  */
 
@@ -39,9 +41,9 @@
 #include <linux/hardirq.h>
 
 #if REISER4_DEBUG
-static void report_err(void);
+static void reiser4_report_err(void);
 #else
-#define report_err() noop
+#define reiser4_report_err() noop
 #endif
 
 /*
@@ -110,14 +112,14 @@ reiser4_print_prefix(const char *level, 
 	printk("%sreiser4[%.16s(%i)]: %s (%s:%i)[%s]:\n",
 	       level, comm, pid, function, file, lineno, mid);
 	if (reperr)
-		report_err();
+		reiser4_report_err();
 }
 
 /* Preemption point: this should be called periodically during long running
    operations (carry, allocate, and squeeze are best examples) */
-int preempt_point(void)
+int reiser4_preempt_point(void)
 {
-	assert("nikita-3008", schedulable());
+	assert("nikita-3008", reiser4_schedulable());
 	cond_resched();
 	return signal_pending(current);
 }
@@ -128,7 +130,7 @@ int preempt_point(void)
    constraints and various assertions.
 
 */
-lock_counters_info *lock_counters(void)
+reiser4_lock_counters_info *reiser4_lock_counters(void)
 {
 	reiser4_context *ctx = get_current_context();
 	assert("jmacd-1123", ctx != NULL);
@@ -139,7 +141,7 @@ lock_counters_info *lock_counters(void)
  * print human readable information about locks held by the reiser4 context.
  */
 static void print_lock_counters(const char *prefix,
-				const lock_counters_info * info)
+				const reiser4_lock_counters_info * info)
 {
 	printk("%s: jnode: %i, tree: %i (r:%i,w:%i), dk: %i (r:%i,w:%i)\n"
 	       "jload: %i, "
@@ -173,11 +175,11 @@ static void print_lock_counters(const ch
 }
 
 /* check that no spinlocks are held */
-int schedulable(void)
+int reiser4_schedulable(void)
 {
 	if (get_current_context_check() != NULL) {
 		if (!LOCK_CNT_NIL(spin_locked)) {
-			print_lock_counters("in atomic", lock_counters());
+			print_lock_counters("in atomic", reiser4_lock_counters());
 			return 0;
 		}
 	}
@@ -187,11 +189,11 @@ int schedulable(void)
 /*
  * return true, iff no locks are held.
  */
-int no_counters_are_held(void)
+int reiser4_no_counters_are_held(void)
 {
-	lock_counters_info *counters;
+	reiser4_lock_counters_info *counters;
 
-	counters = lock_counters();
+	counters = reiser4_lock_counters();
 	return
 	    (counters->spin_locked_zlock == 0) &&
 	    (counters->spin_locked_jnode == 0) &&
@@ -216,9 +218,9 @@ int no_counters_are_held(void)
  * return true, iff transaction commit can be done under locks held by the
  * current thread.
  */
-int commit_check_locks(void)
+int reiser4_commit_check_locks(void)
 {
-	lock_counters_info *counters;
+	reiser4_lock_counters_info *counters;
 	int inode_sem_r;
 	int inode_sem_w;
 	int result;
@@ -228,12 +230,12 @@ int commit_check_locks(void)
 	 * held during commit.
 	 */
 
-	counters = lock_counters();
+	counters = reiser4_lock_counters();
 	inode_sem_r = counters->inode_sem_r;
 	inode_sem_w = counters->inode_sem_w;
 
 	counters->inode_sem_r = counters->inode_sem_w = 0;
-	result = no_counters_are_held();
+	result = reiser4_no_counters_are_held();
 	counters->inode_sem_r = inode_sem_r;
 	counters->inode_sem_w = inode_sem_w;
 	return result;
@@ -243,7 +245,7 @@ int commit_check_locks(void)
  * fill "error site" in the current reiser4 context. See comment before RETERR
  * macro for more details.
  */
-void return_err(int code, const char *file, int line)
+void reiser4_return_err(int code, const char *file, int line)
 {
 	if (code < 0 && is_in_reiser4_context()) {
 		reiser4_context *ctx = get_current_context();
@@ -257,9 +259,9 @@ void return_err(int code, const char *fi
 }
 
 /*
- * report error information recorder by return_err().
+ * report error information recorder by reiser4_return_err().
  */
-static void report_err(void)
+static void reiser4_report_err(void)
 {
 	reiser4_context *ctx = get_current_context_check();
 
@@ -279,7 +281,7 @@ static void report_err(void)
  * this functions just drops into kernel debugger. It is a convenient place to
  * put breakpoint in.
  */
-void debugtrap(void)
+void reiser4_debugtrap(void)
 {
 	/* do nothing. Put break point here. */
 #if defined(CONFIG_KGDB) && !defined(CONFIG_REISER4_FS_MODULE)
diff -puN fs/reiser4/debug.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/debug.h
--- a/fs/reiser4/debug.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/debug.h
@@ -70,7 +70,7 @@
 
 #define ON_DEBUG( exp ) exp
 
-extern int schedulable(void);
+extern int reiser4_schedulable(void);
 extern void call_on_each_assert(void);
 
 #else
@@ -80,7 +80,7 @@ extern void call_on_each_assert(void);
 #define assert( label, cond ) noop
 #define check_me( label, expr )	( ( void ) ( expr ) )
 #define ON_DEBUG( exp )
-#define schedulable() might_sleep()
+#define reiser4_schedulable() might_sleep()
 
 /* REISER4_DEBUG */
 #endif
@@ -88,7 +88,7 @@ extern void call_on_each_assert(void);
 #if REISER4_DEBUG
 /* per-thread information about lock acquired by this thread. Used by lock
  * ordering checking in spin_macros.h */
-typedef struct lock_counters_info {
+typedef struct reiser4_lock_counters_info {
 	int rw_locked_tree;
 	int read_locked_tree;
 	int write_locked_tree;
@@ -121,33 +121,38 @@ typedef struct lock_counters_info {
 	int d_refs;
 	int x_refs;
 	int t_refs;
-} lock_counters_info;
+} reiser4_lock_counters_info;
 
-extern lock_counters_info *lock_counters(void);
+extern reiser4_lock_counters_info *reiser4_lock_counters(void);
 #define IN_CONTEXT(a, b) (is_in_reiser4_context() ? (a) : (b))
 
 /* increment lock-counter @counter, if present */
-#define LOCK_CNT_INC(counter) IN_CONTEXT(++(lock_counters()->counter), 0)
+#define LOCK_CNT_INC(counter)					\
+	IN_CONTEXT(++(reiser4_lock_counters()->counter), 0)
 
 /* decrement lock-counter @counter, if present */
-#define LOCK_CNT_DEC(counter) IN_CONTEXT(--(lock_counters()->counter), 0)
+#define LOCK_CNT_DEC(counter)					\
+	IN_CONTEXT(--(reiser4_lock_counters()->counter), 0)
 
 /* check that lock-counter is zero. This is for use in assertions */
-#define LOCK_CNT_NIL(counter) IN_CONTEXT(lock_counters()->counter == 0, 1)
+#define LOCK_CNT_NIL(counter)					\
+	IN_CONTEXT(reiser4_lock_counters()->counter == 0, 1)
 
 /* check that lock-counter is greater than zero. This is for use in
  * assertions */
-#define LOCK_CNT_GTZ(counter) IN_CONTEXT(lock_counters()->counter > 0, 1)
-#define LOCK_CNT_LT(counter,n) IN_CONTEXT(lock_counters()->counter < n, 1)
+#define LOCK_CNT_GTZ(counter)					\
+	IN_CONTEXT(reiser4_lock_counters()->counter > 0, 1)
+#define LOCK_CNT_LT(counter,n)					\
+	IN_CONTEXT(reiser4_lock_counters()->counter < n, 1)
 
 #else				/* REISER4_DEBUG */
 
 /* no-op versions on the above */
 
-typedef struct lock_counters_info {
-} lock_counters_info;
+typedef struct reiser4_lock_counters_info {
+} reiser4_lock_counters_info;
 
-#define lock_counters() ((lock_counters_info *)NULL)
+#define reiser4_lock_counters() ((reiser4_lock_counters_info *)NULL)
 #define LOCK_CNT_INC(counter) noop
 #define LOCK_CNT_DEC(counter) noop
 #define LOCK_CNT_NIL(counter) (1)
@@ -222,16 +227,16 @@ extern void reiser4_print_prefix(const c
 				 const char *function,
 				 const char *file, int lineno);
 
-extern int preempt_point(void);
+extern int reiser4_preempt_point(void);
 extern void reiser4_print_stats(void);
 
 
 #if REISER4_DEBUG
-extern int no_counters_are_held(void);
-extern int commit_check_locks(void);
+extern int reiser4_no_counters_are_held(void);
+extern int reiser4_commit_check_locks(void);
 #else
-#define no_counters_are_held() (1)
-#define commit_check_locks() (1)
+#define reiser4_no_counters_are_held() (1)
+#define reiser4_commit_check_locks() (1)
 #endif
 
 /* true if @i is power-of-two. Useful for rate-limited warnings, etc. */
@@ -247,16 +252,16 @@ extern int commit_check_locks(void);
 
 #if KERNEL_DEBUGGER
 
-extern void debugtrap(void);
+extern void reiser4_debugtrap(void);
 
 /*
  * Check condition @cond and drop into kernel debugger (kgdb) if it's true. If
  * kgdb is not compiled in, do nothing.
  */
-#define DEBUGON(cond)				\
-({						\
-	if (unlikely(cond))			\
-		debugtrap();			\
+#define DEBUGON(cond)					\
+({	               					\
+	if (unlikely(cond))				\
+		reiser4_debugtrap();			\
 })
 #else
 #define DEBUGON(cond) noop
@@ -285,9 +290,9 @@ extern void debugtrap(void);
  *
  * RETERR() macro fills a backtrace in reiser4_context. This back-trace is
  * printed in error and warning messages. Moreover, it's possible to put a
- * conditional breakpoint in return_err (low-level function called by RETERR()
- * to do the actual work) to break into debugger immediately when particular
- * error happens.
+ * conditional breakpoint in reiser4_return_err (low-level function called
+ * by RETERR() to do the actual work) to break into debugger immediately
+ * when particular error happens.
  *
  */
 
@@ -302,18 +307,18 @@ typedef struct err_site {
 	int line;		/* source file line, filled by __LINE__ */
 } err_site;
 
-extern void return_err(int code, const char *file, int line);
+extern void reiser4_return_err(int code, const char *file, int line);
 
 /*
  * fill &get_current_context()->err_site with error information.
  */
-#define RETERR(code) 				\
-({						\
-	typeof(code) __code;			\
-						\
-	__code = (code);			\
-	return_err(__code, __FILE__, __LINE__);	\
-	__code;					\
+#define RETERR(code)					\
+({						        \
+	typeof(code) __code;				\
+							\
+	__code = (code);				\
+	reiser4_return_err(__code, __FILE__, __LINE__);	\
+	__code;						\
 })
 
 #else
diff -puN fs/reiser4/entd.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/entd.c
--- a/fs/reiser4/entd.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/entd.c
@@ -38,13 +38,13 @@ static int entd(void *arg);
 	         "ent:%s%s", super->s_id, (state))
 
 /**
- * init_entd - initialize entd context and start kernel daemon
+ * reiser4_init_entd - initialize entd context and start kernel daemon
  * @super: super block to start ent thread for
  *
  * Creates entd contexts, starts kernel thread and waits until it
  * initializes.
  */
-int init_entd(struct super_block *super)
+int reiser4_init_entd(struct super_block *super)
 {
 	entd_context *ctx;
 
@@ -177,13 +177,13 @@ static int entd(void *arg)
 }
 
 /**
- * done_entd - stop entd kernel thread
+ * reiser4_done_entd - stop entd kernel thread
  * @super: super block to stop ent thread for
  *
  * It is called on umount. Sends stop signal to entd and wait until it handles
  * it.
  */
-void done_entd(struct super_block *super)
+void reiser4_done_entd(struct super_block *super)
 {
 	entd_context *ent;
 
@@ -196,7 +196,7 @@ void done_entd(struct super_block *super
 
 /* called at the beginning of jnode_flush to register flusher thread with ent
  * daemon */
-void enter_flush(struct super_block *super)
+void reiser4_enter_flush(struct super_block *super)
 {
 	entd_context *ent;
 
@@ -214,7 +214,7 @@ void enter_flush(struct super_block *sup
 }
 
 /* called at the end of jnode_flush */
-void leave_flush(struct super_block *super)
+void reiser4_leave_flush(struct super_block *super)
 {
 	entd_context *ent;
 	int wake_up_ent;
@@ -257,7 +257,7 @@ static void entd_flush(struct super_bloc
 		generic_sync_sb_inodes(super, rq->wbc);
 	}
 	rq->wbc->nr_to_write = ENTD_CAPTURE_APAGE_BURST;
-	writeout(super, rq->wbc);
+	reiser4_writeout(super, rq->wbc);
 
 	context_set_commit_async(&ctx);
 	reiser4_exit_context(&ctx);
@@ -290,7 +290,7 @@ int write_page_by_ent(struct page *page,
 	 * page. Re-dirty page before unlocking so that if ent thread fails to
 	 * write it - it will remain dirty
 	 */
-	set_page_dirty_internal(page);
+	reiser4_set_page_dirty_internal(page);
 
 	/*
 	 * pin inode in memory, unlock page, entd_flush will iput. We can not
diff -puN fs/reiser4/entd.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/entd.h
--- a/fs/reiser4/entd.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/entd.h
@@ -65,11 +65,11 @@ typedef struct entd_context {
 #endif
 } entd_context;
 
-extern int  init_entd(struct super_block *);
-extern void done_entd(struct super_block *);
+extern int  reiser4_init_entd(struct super_block *);
+extern void reiser4_done_entd(struct super_block *);
 
-extern void enter_flush(struct super_block *);
-extern void leave_flush(struct super_block *);
+extern void reiser4_enter_flush(struct super_block *);
+extern void reiser4_leave_flush(struct super_block *);
 
 extern int write_page_by_ent(struct page *, struct writeback_control *);
 extern int wbq_available(void);
diff -puN fs/reiser4/eottl.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/eottl.c
--- a/fs/reiser4/eottl.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/eottl.c
@@ -267,7 +267,7 @@ add_empty_leaf(coord_t *insert_coord, lo
 
 	assert("vs-49827", znode_contains_key_lock(insert_coord->node, key));
 	tree = znode_get_tree(insert_coord->node);
-	node = new_node(insert_coord->node, LEAF_LEVEL);
+	node = reiser4_new_node(insert_coord->node, LEAF_LEVEL);
 	if (IS_ERR(node))
 		return PTR_ERR(node);
 
@@ -295,7 +295,7 @@ add_empty_leaf(coord_t *insert_coord, lo
 	item = (reiser4_item_data *) (todo + 3);
 	cdata = (carry_insert_data *) (item + 1);
 
-	op = post_carry(todo, COP_INSERT, insert_coord->node, 0);
+	op = reiser4_post_carry(todo, COP_INSERT, insert_coord->node, 0);
 	if (!IS_ERR(op)) {
 		cdata->coord = insert_coord;
 		cdata->key = key;
@@ -309,7 +309,7 @@ add_empty_leaf(coord_t *insert_coord, lo
 		todo->track_type = CARRY_TRACK_CHANGE;
 		todo->tracked = lh;
 
-		result = carry(todo, NULL);
+		result = reiser4_carry(todo, NULL);
 		if (result == 0) {
 			/*
 			 * pin node in memory. This is necessary for
diff -puN fs/reiser4/export_ops.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/export_ops.c
--- a/fs/reiser4/export_ops.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/export_ops.c
@@ -39,7 +39,7 @@ static char *decode_inode(struct super_b
 
 	/* identifier of object plugin is stored in the first two bytes,
 	 * followed by... */
-	fplug = file_plugin_by_disk_id(get_tree(s), (d16 *) addr);
+	fplug = file_plugin_by_disk_id(reiser4_get_tree(s), (d16 *) addr);
 	if (fplug != NULL) {
 		addr += sizeof(d16);
 		obj->plugin = fplug;
@@ -74,7 +74,7 @@ static struct dentry *reiser4_decode_fh(
 	char *addr;
 	int with_parent;
 
-	ctx = init_context(super);
+	ctx = reiser4_init_context(super);
 	if (IS_ERR(ctx))
 		return (struct dentry *)ctx;
 
@@ -205,7 +205,7 @@ reiser4_encode_fh(struct dentry *dentry,
 		need += delta;
 	}
 
-	ctx = init_context(dentry->d_inode->i_sb);
+	ctx = reiser4_init_context(dentry->d_inode->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
diff -puN fs/reiser4/flush.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/flush.c
--- a/fs/reiser4/flush.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/flush.c
@@ -452,7 +452,7 @@ static int check_write_congestion(void)
 	struct backing_dev_info *bdi;
 
 	sb = reiser4_get_current_sb();
-	bdi = get_super_fake(sb)->i_mapping->backing_dev_info;
+	bdi = reiser4_get_super_fake(sb)->i_mapping->backing_dev_info;
 	return bdi_write_congested(bdi);
 }
 
@@ -470,7 +470,7 @@ static int write_prepped_nodes(flush_pos
 	if (check_write_congestion())
 		return 0;
 
-	ret = write_fq(pos->fq, pos->nr_written,
+	ret = reiser4_write_fq(pos->fq, pos->nr_written,
 		       WRITEOUT_SINGLE_STREAM | WRITEOUT_FOR_PAGE_RECLAIM);
 	return ret;
 }
@@ -508,7 +508,7 @@ static int delete_empty_node(znode * nod
 	assert("zam-1020", node_is_empty(node));
 	assert("zam-1023", znode_is_wlocked(node));
 
-	return delete_node(node, &smallest_removed, NULL, 1);
+	return reiser4_delete_node(node, &smallest_removed, NULL, 1);
 }
 
 /* Prepare flush position for alloc_pos_and_ancestors() and squalloc() */
@@ -659,7 +659,7 @@ jnode_flush(jnode * node, long nr_to_wri
 	jnode *leftmost_in_slum = NULL;
 
 	assert("jmacd-76619", lock_stack_isclean(get_current_lock_stack()));
-	assert("nikita-3022", schedulable());
+	assert("nikita-3022", reiser4_schedulable());
 
 	/* lock ordering: delete_sema and flush_sema are unordered */
 	assert("nikita-3185",
@@ -667,7 +667,8 @@ jnode_flush(jnode * node, long nr_to_wri
 
 	/* allocate right_scan, left_scan and flush_pos */
 	right_scan =
-	    kmalloc(2 * sizeof(*right_scan) + sizeof(*flush_pos), get_gfp_mask());
+	    kmalloc(2 * sizeof(*right_scan) + sizeof(*flush_pos),
+		    reiser4_ctx_gfp_mask_get());
 	if (right_scan == NULL)
 		return RETERR(-ENOMEM);
 	left_scan = right_scan + 1;
@@ -684,7 +685,7 @@ jnode_flush(jnode * node, long nr_to_wri
 	atomic_inc(&flush_cnt);
 #endif
 
-	enter_flush(sb);
+	reiser4_enter_flush(sb);
 
 	/* Initialize a flush position. */
 	pos_init(flush_pos);
@@ -875,7 +876,7 @@ jnode_flush(jnode * node, long nr_to_wri
 
 	ON_DEBUG(atomic_dec(&flush_cnt));
 
-	leave_flush(sb);
+	reiser4_leave_flush(sb);
 
 	if (!reiser4_is_set(sb, REISER4_MTFLUSH))
 		up(&sbinfo->flush_sema);
@@ -991,7 +992,7 @@ flush_current_atom(int flags, long nr_to
 
 	nr_to_write = LONG_MAX;
 	while (1) {
-		ret = fq_by_atom(*atom, &fq);
+		ret = reiser4_fq_by_atom(*atom, &fq);
 		if (ret != -E_REPEAT)
 			break;
 		*atom = get_current_atom_locked();
@@ -1004,10 +1005,10 @@ flush_current_atom(int flags, long nr_to
 	/* parallel flushers limit */
 	if (sinfo->tmgr.atom_max_flushers != 0) {
 		while ((*atom)->nr_flushers >= sinfo->tmgr.atom_max_flushers) {
-			/* An atom_send_event() call is inside fq_put_nolock() which is
-			   called when flush is finished and nr_flushers is
-			   decremented. */
-			atom_wait_event(*atom);
+			/* An reiser4_atom_send_event() call is inside
+			   reiser4_fq_put_nolock() which is called when flush is
+			   finished and nr_flushers is decremented. */
+			reiser4_atom_wait_event(*atom);
 			*atom = get_current_atom_locked();
 		}
 	}
@@ -1023,8 +1024,8 @@ flush_current_atom(int flags, long nr_to
 	if (node == NULL) {
 		if (nr_queued == 0) {
 			(*atom)->nr_flushers--;
-			fq_put_nolock(fq);
-			atom_send_event(*atom);
+			reiser4_fq_put_nolock(fq);
+			reiser4_atom_send_event(*atom);
 			/* current atom remains locked */
 			writeout_mode_disable();
 			return 0;
@@ -1041,13 +1042,13 @@ flush_current_atom(int flags, long nr_to
 	}
 
 	ret =
-	    write_fq(fq, nr_submitted,
+	    reiser4_write_fq(fq, nr_submitted,
 		     WRITEOUT_SINGLE_STREAM | WRITEOUT_FOR_PAGE_RECLAIM);
 
 	*atom = get_current_atom_locked();
 	(*atom)->nr_flushers--;
-	fq_put_nolock(fq);
-	atom_send_event(*atom);
+	reiser4_fq_put_nolock(fq);
+	reiser4_atom_send_event(*atom);
 	spin_unlock_atom(*atom);
 
 	writeout_mode_disable();
@@ -1073,8 +1074,8 @@ reverse_relocate_if_close_enough(const r
 	reiser4_block_nr dist;
 
 	assert("jmacd-7710", *pblk != 0 && *nblk != 0);
-	assert("jmacd-7711", !blocknr_is_fake(pblk));
-	assert("jmacd-7712", !blocknr_is_fake(nblk));
+	assert("jmacd-7711", !reiser4_blocknr_is_fake(pblk));
+	assert("jmacd-7712", !reiser4_blocknr_is_fake(nblk));
 
 	/* Distance is the absolute value. */
 	dist = (*pblk > *nblk) ? (*pblk - *nblk) : (*nblk - *pblk);
@@ -1136,7 +1137,7 @@ reverse_relocate_test(jnode * node, cons
 
 	nblk = *jnode_get_block(node);
 
-	if (blocknr_is_fake(&nblk))
+	if (reiser4_blocknr_is_fake(&nblk))
 		/* child is unallocated, mark parent dirty */
 		return 1;
 
@@ -1485,13 +1486,13 @@ static int squeeze_right_twig(znode * le
 		ON_DEBUG(vp = shift_check_prepare(left, coord.node));
 
 		/* stop_key is used to find what was copied and what to cut */
-		stop_key = *min_key();
+		stop_key = *reiser4_min_key();
 		ret = squalloc_extent(left, &coord, pos, &stop_key);
 		if (ret != SQUEEZE_CONTINUE) {
 			ON_DEBUG(kfree(vp));
 			break;
 		}
-		assert("vs-1465", !keyeq(&stop_key, min_key()));
+		assert("vs-1465", !keyeq(&stop_key, reiser4_min_key()));
 
 		/* Helper function to do the cutting. */
 		set_key_offset(&stop_key, get_key_offset(&stop_key) - 1);
@@ -2087,7 +2088,7 @@ static int handle_pos_on_twig(flush_pos_
 
 	while (pos_valid(pos) && coord_is_existing_unit(&pos->coord)
 	       && item_is_extent(&pos->coord)) {
-		ret = alloc_extent(pos);
+		ret = reiser4_alloc_extent(pos);
 		if (ret) {
 			break;
 		}
@@ -2475,7 +2476,7 @@ static int squeeze_right_non_twig(znode 
 		grabbed = get_current_context()->grabbed_blocks;
 		ret = reiser4_grab_space_force(tree->height, BA_RESERVED);
 		assert("nikita-3003", ret == 0);	/* reserved space is exhausted. Ask Hans. */
-		ret = carry(todo, NULL /* previous level */ );
+		ret = reiser4_carry(todo, NULL /* previous level */ );
 		grabbed2free_mark(grabbed);
 	} else {
 		/* Shifting impossible, we return appropriate result code */
@@ -2586,7 +2587,7 @@ static int shift_one_internal_unit(znode
 		ret = reiser4_grab_space_force(tree->height, BA_RESERVED);
 		assert("nikita-3003", ret == 0);	/* reserved space is exhausted. Ask Hans. */
 
-		ret = carry(todo, NULL /* previous level */ );
+		ret = reiser4_carry(todo, NULL /* previous level */ );
 		grabbed2free_mark(grabbed);
 	}
 
@@ -2641,8 +2642,8 @@ allocate_znode_loaded(znode * node,
 		reiser4_block_nr dist;
 		reiser4_block_nr nblk = *znode_get_block(node);
 
-		assert("jmacd-6172", !blocknr_is_fake(&nblk));
-		assert("jmacd-6173", !blocknr_is_fake(&pos->preceder.blk));
+		assert("jmacd-6172", !reiser4_blocknr_is_fake(&nblk));
+		assert("jmacd-6173", !reiser4_blocknr_is_fake(&pos->preceder.blk));
 		assert("jmacd-6174", pos->preceder.blk != 0);
 
 		if (pos->preceder.blk == nblk - 1) {
@@ -2695,7 +2696,7 @@ allocate_znode_loaded(znode * node,
 	check_preceder(pos->preceder.blk);
 	pos->alloc_cnt += 1;
 
-	assert("jmacd-4277", !blocknr_is_fake(&pos->preceder.blk));
+	assert("jmacd-4277", !reiser4_blocknr_is_fake(&pos->preceder.blk));
 
 	return 0;
 }
@@ -2740,7 +2741,7 @@ allocate_znode_update(znode * node, cons
 		return ret;
 
 	if (ZF_ISSET(node, JNODE_CREATED)) {
-		assert("zam-816", blocknr_is_fake(znode_get_block(node)));
+		assert("zam-816", reiser4_blocknr_is_fake(znode_get_block(node)));
 		pos->preceder.block_stage = BLOCK_UNALLOCATED;
 	} else {
 		pos->preceder.block_stage = BLOCK_GRABBED;
@@ -3058,7 +3059,7 @@ static void scan_done(flush_scan * scan)
 }
 
 /* Returns true if flush scanning is finished. */
-int scan_finished(flush_scan * scan)
+int reiser4_scan_finished(flush_scan * scan)
 {
 	return scan->stop || (scan->direction == RIGHT_SIDE &&
 			      scan->count >= scan->max_count);
@@ -3066,7 +3067,7 @@ int scan_finished(flush_scan * scan)
 
 /* Return true if the scan should continue to the @tonode.  True if the node meets the
    same_slum_check condition.  If not, deref the "left" node and stop the scan. */
-int scan_goto(flush_scan * scan, jnode * tonode)
+int reiser4_scan_goto(flush_scan * scan, jnode * tonode)
 {
 	int go = same_slum_check(scan->node, tonode, 1, 0);
 
@@ -3094,7 +3095,7 @@ scan_set_current(flush_scan * scan, jnod
 	scan->node = node;
 	scan->count += add_count;
 
-	/* This next stmt is somewhat inefficient.  The scan_extent_coord code could
+	/* This next stmt is somewhat inefficient.  The reiser4_scan_extent() code could
 	   delay this update step until it finishes and update the parent_coord only once.
 	   It did that before, but there was a bug and this was the easiest way to make it
 	   correct. */
@@ -3108,7 +3109,7 @@ scan_set_current(flush_scan * scan, jnod
 }
 
 /* Return true if scanning in the leftward direction. */
-int scanning_left(flush_scan * scan)
+int reiser4_scanning_left(flush_scan * scan)
 {
 	return scan->direction == LEFT_SIDE;
 }
@@ -3221,7 +3222,7 @@ static int scan_common(flush_scan * scan
 	}
 	/* This loop expects to start at a formatted position and performs chaining of
 	   formatted regions */
-	while (!scan_finished(scan)) {
+	while (!reiser4_scan_finished(scan)) {
 
 		ret = scan_formatted(scan);
 		if (ret != 0) {
@@ -3258,7 +3259,7 @@ static int scan_unformatted(flush_scan *
 		 * there is already lock held by this thread,
 		 * jnode_lock_parent_coord() should use try-lock.
 		 */
-		try = scanning_left(scan)
+		try = reiser4_scanning_left(scan)
 		    && !lock_stack_isclean(get_current_lock_stack());
 		/* Need the node locked to get the parent lock, We have to
 		   take write lock since there is at least one call path
@@ -3266,7 +3267,8 @@ static int scan_unformatted(flush_scan *
 		ret =
 		    longterm_lock_znode(&lock, JZNODE(scan->node),
 					ZNODE_WRITE_LOCK,
-					scanning_left(scan) ? ZNODE_LOCK_LOPRI :
+					reiser4_scanning_left(scan) ?
+					ZNODE_LOCK_LOPRI :
 					ZNODE_LOCK_HIPRI);
 		if (ret != 0)
 			/* EINVAL or E_DEADLOCK here mean... try again!  At this point we've
@@ -3328,7 +3330,7 @@ static int scan_formatted(flush_scan * s
 	int ret;
 	znode *neighbor = NULL;
 
-	assert("jmacd-1401", !scan_finished(scan));
+	assert("jmacd-1401", !reiser4_scan_finished(scan));
 
 	do {
 		znode *node = JZNODE(scan->node);
@@ -3346,7 +3348,8 @@ static int scan_formatted(flush_scan * s
 		   left sibling while the tree lock is released, but the flush-scan count
 		   does not need to be precise.  Thus, we release the tree lock as soon as
 		   we get the neighboring node. */
-		neighbor = scanning_left(scan) ? node->left : node->right;
+		neighbor =
+			reiser4_scanning_left(scan) ? node->left : node->right;
 		if (neighbor != NULL) {
 			zref(neighbor);
 		}
@@ -3361,7 +3364,7 @@ static int scan_formatted(flush_scan * s
 
 		/* Check the condition for going left, break if it is not met.  This also
 		   releases (jputs) the neighbor if false. */
-		if (!scan_goto(scan, ZJNODE(neighbor))) {
+		if (!reiser4_scan_goto(scan, ZJNODE(neighbor))) {
 			break;
 		}
 
@@ -3371,13 +3374,13 @@ static int scan_formatted(flush_scan * s
 			return ret;
 		}
 
-	} while (!scan_finished(scan));
+	} while (!reiser4_scan_finished(scan));
 
 	/* If neighbor is NULL then we reached the end of a formatted region, or else the
 	   sibling is out of memory, now check for an extent to the left (as long as
 	   LEAF_LEVEL). */
 	if (neighbor != NULL || jnode_get_level(scan->node) != LEAF_LEVEL
-	    || scan_finished(scan)) {
+	    || reiser4_scan_finished(scan)) {
 		scan->stop = 1;
 		return 0;
 	}
@@ -3412,7 +3415,7 @@ static int scan_by_coord(flush_scan * sc
 	/* set initial item id */
 	iplug = item_plugin_by_coord(&scan->parent_coord);
 
-	for (; !scan_finished(scan); scan_this_coord = 1) {
+	for (; !reiser4_scan_finished(scan); scan_this_coord = 1) {
 		if (scan_this_coord) {
 			/* Here we expect that unit is scannable. it would not be so due
 			 * to race with extent->tail conversion.  */
@@ -3427,7 +3430,7 @@ static int scan_by_coord(flush_scan * sc
 			if (ret != 0)
 				goto exit;
 
-			if (scan_finished(scan)) {
+			if (reiser4_scan_finished(scan)) {
 				checkchild(scan);
 				break;
 			}
@@ -3508,7 +3511,7 @@ static int scan_by_coord(flush_scan * sc
 		       || jnode_is_znode(child));
 
 		/* See if it is dirty, part of the same atom. */
-		if (!scan_goto(scan, child)) {
+		if (!reiser4_scan_goto(scan, child)) {
 			checkchild(scan);
 			break;
 		}
@@ -3531,7 +3534,8 @@ static int scan_by_coord(flush_scan * sc
 		}
 	}
 
-	assert("jmacd-6233", scan_finished(scan) || jnode_is_znode(scan->node));
+	assert("jmacd-6233",
+	       reiser4_scan_finished(scan) || jnode_is_znode(scan->node));
       exit:
 	checkchild(scan);
       race:			/* skip the above check  */
@@ -3557,7 +3561,7 @@ static void pos_init(flush_pos_t * pos)
 	init_lh(&pos->lock);
 	init_load_count(&pos->load);
 
-	blocknr_hint_init(&pos->preceder);
+	reiser4_blocknr_hint_init(&pos->preceder);
 }
 
 /* The flush loop inside squalloc periodically checks pos_valid to
@@ -3581,7 +3585,7 @@ static int pos_valid(flush_pos_t * pos)
 static void pos_done(flush_pos_t * pos)
 {
 	pos_stop(pos);
-	blocknr_hint_done(&pos->preceder);
+	reiser4_blocknr_hint_done(&pos->preceder);
 	if (convert_data(pos))
 		free_convert_data(pos);
 }
@@ -3604,12 +3608,12 @@ static int pos_stop(flush_pos_t * pos)
 }
 
 /* Return the flush_position's block allocator hint. */
-reiser4_blocknr_hint *pos_hint(flush_pos_t * pos)
+reiser4_blocknr_hint *reiser4_pos_hint(flush_pos_t * pos)
 {
 	return &pos->preceder;
 }
 
-flush_queue_t *pos_fq(flush_pos_t * pos)
+flush_queue_t * reiser4_pos_fq(flush_pos_t * pos)
 {
 	return pos->fq;
 }
diff -puN fs/reiser4/flush.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/flush.h
--- a/fs/reiser4/flush.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/flush.h
@@ -236,19 +236,19 @@ void free_convert_data(flush_pos_t * pos
 /* used in extent.c */
 int scan_set_current(flush_scan * scan, jnode * node, unsigned add_size,
 		     const coord_t * parent);
-int scan_finished(flush_scan * scan);
-int scanning_left(flush_scan * scan);
-int scan_goto(flush_scan * scan, jnode * tonode);
+int reiser4_scan_finished(flush_scan * scan);
+int reiser4_scanning_left(flush_scan * scan);
+int reiser4_scan_goto(flush_scan * scan, jnode * tonode);
 txn_atom *atom_locked_by_fq(flush_queue_t * fq);
-int alloc_extent(flush_pos_t *flush_pos);
+int reiser4_alloc_extent(flush_pos_t *flush_pos);
 squeeze_result squalloc_extent(znode *left, const coord_t *, flush_pos_t *,
 			       reiser4_key *stop_key);
-extern int init_fqs(void);
-extern void done_fqs(void);
+extern int reiser4_init_fqs(void);
+extern void reiser4_done_fqs(void);
 
 #if REISER4_DEBUG
 
-extern void check_fq(const txn_atom *atom);
+extern void reiser4_check_fq(const txn_atom *atom);
 extern atomic_t flush_cnt;
 
 #define check_preceder(blk) \
diff -puN fs/reiser4/flush_queue.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/flush_queue.c
--- a/fs/reiser4/flush_queue.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/flush_queue.c
@@ -111,12 +111,12 @@ static kmem_cache_t *fq_slab;
 
 
 /**
- * init_fqs - create flush queue cache
+ * reiser4_init_fqs - create flush queue cache
  *
  * Initializes slab cache of flush queues. It is part of reiser4 module
  * initialization.
  */
-int init_fqs(void)
+int reiser4_init_fqs(void)
 {
 	fq_slab = kmem_cache_create("fq",
 				    sizeof(flush_queue_t),
@@ -127,11 +127,11 @@ int init_fqs(void)
 }
 
 /**
- * done_fqs - delete flush queue cache
+ * reiser4_done_fqs - delete flush queue cache
  *
  * This is called on reiser4 module unloading or system shutdown.
  */
-void done_fqs(void)
+void reiser4_done_fqs(void)
 {
 	destroy_reiser4_cache(&fq_slab);
 }
@@ -233,12 +233,12 @@ static int wait_io(flush_queue_t * fq, i
 
 		spin_unlock_atom(fq->atom);
 
-		assert("nikita-3013", schedulable());
+		assert("nikita-3013", reiser4_schedulable());
 
 		super = reiser4_get_current_sb();
 
 		/* FIXME: this is instead of blk_run_queues() */
-		blk_run_address_space(get_super_fake(super)->i_mapping);
+		blk_run_address_space(reiser4_get_super_fake(super)->i_mapping);
 
 		if (!(super->s_flags & MS_RDONLY))
 			down(&fq->io_sem);
@@ -270,7 +270,7 @@ static int finish_fq(flush_queue_t * fq,
 	detach_fq(fq);
 	done_fq(fq);
 
-	atom_send_event(atom);
+	reiser4_atom_send_event(atom);
 
 	return 0;
 }
@@ -299,7 +299,7 @@ static int finish_all_fq(txn_atom * atom
 				reiser4_handle_error();
 
 			if (ret) {
-				fq_put(fq);
+				reiser4_fq_put(fq);
 				return ret;
 			}
 
@@ -326,7 +326,7 @@ int current_atom_finish_all_fq(void)
 			ret = finish_all_fq(atom, &nr_io_errors);
 			if (ret != -EBUSY)
 				break;
-			atom_wait_event(atom);
+			reiser4_atom_wait_event(atom);
 		}
 	} while (ret == -E_REPEAT);
 
@@ -361,7 +361,7 @@ scan_fq_and_update_atom_ref(struct list_
 }
 
 /* support for atom fusion operation */
-void fuse_fq(txn_atom *to, txn_atom *from)
+void reiser4_fuse_fq(txn_atom *to, txn_atom *from)
 {
 	flush_queue_t *fq;
 
@@ -498,7 +498,7 @@ static void release_prepped_list(flush_q
 	}
 
 	if (--atom->nr_running_queues == 0)
-		atom_send_event(atom);
+		reiser4_atom_send_event(atom);
 
 	spin_unlock_atom(atom);
 }
@@ -508,7 +508,7 @@ static void release_prepped_list(flush_q
    @fq: flush queue object which contains jnodes we can (and will) write.
    @return: number of submitted blocks (>=0) if success, otherwise -- an error
             code (<0). */
-int write_fq(flush_queue_t * fq, long *nr_submitted, int flags)
+int reiser4_write_fq(flush_queue_t * fq, long *nr_submitted, int flags)
 {
 	int ret;
 	txn_atom *atom;
@@ -520,7 +520,7 @@ int write_fq(flush_queue_t * fq, long *n
 		if (atom->nr_running_queues == 0
 		    || !(flags & WRITEOUT_SINGLE_STREAM))
 			break;
-		atom_wait_event(atom);
+		reiser4_atom_wait_event(atom);
 	}
 
 	atom->nr_running_queues++;
@@ -588,13 +588,13 @@ static int fq_by_atom_gfp(txn_atom *atom
 	return RETERR(-E_REPEAT);
 }
 
-int fq_by_atom(txn_atom * atom, flush_queue_t ** new_fq)
+int reiser4_fq_by_atom(txn_atom * atom, flush_queue_t ** new_fq)
 {
-	return fq_by_atom_gfp(atom, new_fq, get_gfp_mask());
+	return fq_by_atom_gfp(atom, new_fq, reiser4_ctx_gfp_mask_get());
 }
 
-/* A wrapper around fq_by_atom for getting a flush queue object for current
- * atom, if success fq->atom remains locked. */
+/* A wrapper around reiser4_fq_by_atom for getting a flush queue
+   object for current atom, if success fq->atom remains locked. */
 flush_queue_t *get_fq_for_current_atom(void)
 {
 	flush_queue_t *fq = NULL;
@@ -603,7 +603,7 @@ flush_queue_t *get_fq_for_current_atom(v
 
 	do {
 		atom = get_current_atom_locked();
-		ret = fq_by_atom(atom, &fq);
+		ret = reiser4_fq_by_atom(atom, &fq);
 	} while (ret == -E_REPEAT);
 
 	if (ret)
@@ -612,7 +612,7 @@ flush_queue_t *get_fq_for_current_atom(v
 }
 
 /* Releasing flush queue object after exclusive use */
-void fq_put_nolock(flush_queue_t *fq)
+void reiser4_fq_put_nolock(flush_queue_t *fq)
 {
 	assert("zam-747", fq->atom != NULL);
 	assert("zam-902", list_empty_careful(ATOM_FQ_LIST(fq)));
@@ -621,7 +621,7 @@ void fq_put_nolock(flush_queue_t *fq)
 	ON_DEBUG(fq->owner = NULL);
 }
 
-void fq_put(flush_queue_t * fq)
+void reiser4_fq_put(flush_queue_t * fq)
 {
 	txn_atom *atom;
 
@@ -630,8 +630,8 @@ void fq_put(flush_queue_t * fq)
 
 	assert("zam-746", atom != NULL);
 
-	fq_put_nolock(fq);
-	atom_send_event(atom);
+	reiser4_fq_put_nolock(fq);
+	reiser4_atom_send_event(atom);
 
 	spin_unlock(&(fq->guard));
 	spin_unlock_atom(atom);
@@ -647,7 +647,7 @@ void init_atom_fq_parts(txn_atom *atom)
 
 #if REISER4_DEBUG
 
-void check_fq(const txn_atom *atom)
+void reiser4_check_fq(const txn_atom *atom)
 {
 	/* check number of nodes on all atom's flush queues */
 	flush_queue_t *fq;
diff -puN fs/reiser4/fsdata.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/fsdata.c
--- a/fs/reiser4/fsdata.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/fsdata.c
@@ -54,12 +54,12 @@ static int d_cursor_shrink(int nr, gfp_t
 }
 
 /**
- * init_d_cursor - create d_cursor cache
+ * reiser4_init_d_cursor - create d_cursor cache
  *
  * Initializes slab cache of d_cursors. It is part of reiser4 module
  * initialization.
  */
-int init_d_cursor(void)
+int reiser4_init_d_cursor(void)
 {
 	d_cursor_cache = kmem_cache_create("d_cursor", sizeof(dir_cursor), 0,
 					   SLAB_HWCACHE_ALIGN, NULL, NULL);
@@ -84,11 +84,11 @@ int init_d_cursor(void)
 }
 
 /**
- * done_d_cursor - delete d_cursor cache and d_cursor shrinker
+ * reiser4_done_d_cursor - delete d_cursor cache and d_cursor shrinker
  *
  * This is called on reiser4 module unloading or system shutdown.
  */
-void done_d_cursor(void)
+void reiser4_done_d_cursor(void)
 {
 	BUG_ON(d_cursor_shrinker == NULL);
 	remove_shrinker(d_cursor_shrinker);
@@ -115,7 +115,7 @@ static inline int d_cursor_eq(const d_cu
  * define functions to manipulate reiser4 super block's hash table of
  * dir_cursors
  */
-#define KMALLOC(size) kmalloc((size), get_gfp_mask())
+#define KMALLOC(size) kmalloc((size), reiser4_ctx_gfp_mask_get())
 #define KFREE(ptr, size) kfree(ptr)
 TYPE_SAFE_HASH_DEFINE(d_cursor,
 		      dir_cursor,
@@ -124,29 +124,29 @@ TYPE_SAFE_HASH_DEFINE(d_cursor,
 #undef KMALLOC
 
 /**
- * init_super_d_info - initialize per-super-block d_cursor resources
+ * reiser4_init_super_d_info - initialize per-super-block d_cursor resources
  * @super: super block to initialize
  *
  * Initializes per-super-block d_cursor's hash table and radix tree. It is part
  * of mount.
  */
-int init_super_d_info(struct super_block *super)
+int reiser4_init_super_d_info(struct super_block *super)
 {
 	d_cursor_info *p;
 
 	p = &get_super_private(super)->d_info;
 
-	INIT_RADIX_TREE(&p->tree, get_gfp_mask());
+	INIT_RADIX_TREE(&p->tree, reiser4_ctx_gfp_mask_get());
 	return d_cursor_hash_init(&p->table, D_CURSOR_TABLE_SIZE);
 }
 
 /**
- * done_super_d_info - release per-super-block d_cursor resources
+ * reiser4_done_super_d_info - release per-super-block d_cursor resources
  * @super: super block being umounted
  *
  * It is called on umount. Kills all directory cursors attached to suoer block.
  */
-void done_super_d_info(struct super_block *super)
+void reiser4_done_super_d_info(struct super_block *super)
 {
 	d_cursor_info *d_info;
 	dir_cursor *cursor, *next;
@@ -325,7 +325,7 @@ static int insert_cursor(dir_cursor *cur
 	 * cursor. */
 	fsdata = create_fsdata(NULL);
 	if (fsdata != NULL) {
-		result = radix_tree_preload(get_gfp_mask());
+		result = radix_tree_preload(reiser4_ctx_gfp_mask_get());
 		if (result == 0) {
 			d_cursor_info *info;
 			oid_t oid;
@@ -389,7 +389,7 @@ static void process_cursors(struct inode
 	 *
 	 * without reiser4_context
 	 */
-	ctx = init_context(inode->i_sb);
+	ctx = reiser4_init_context(inode->i_sb);
 	if (IS_ERR(ctx)) {
 		warning("vs-23", "failed to init context");
 		return;
@@ -448,38 +448,38 @@ static void process_cursors(struct inode
 }
 
 /**
- * dispose_cursors - removes cursors from inode's list
+ * reiser4_dispose_cursors - removes cursors from inode's list
  * @inode: inode to dispose cursors of
  *
  * For each of cursors corresponding to @inode - removes reiser4_file_fsdata
  * attached to cursor from inode's readdir list. This is called when inode is
  * removed from the memory by memory pressure.
  */
-void dispose_cursors(struct inode *inode)
+void reiser4_dispose_cursors(struct inode *inode)
 {
 	process_cursors(inode, CURSOR_DISPOSE);
 }
 
 /**
- * load_cursors - attach cursors to inode
+ * reiser4_load_cursors - attach cursors to inode
  * @inode: inode to load cursors to
  *
  * For each of cursors corresponding to @inode - attaches reiser4_file_fsdata
  * attached to cursor to inode's readdir list. This is done when inode is
  * loaded into memory.
  */
-void load_cursors(struct inode *inode)
+void reiser4_load_cursors(struct inode *inode)
 {
 	process_cursors(inode, CURSOR_LOAD);
 }
 
 /**
- * kill_cursors - kill all inode cursors
+ * reiser4_kill_cursors - kill all inode cursors
  * @inode: inode to kill cursors of
  *
  * Frees all cursors for this inode. This is called when inode is destroyed.
  */
-void kill_cursors(struct inode *inode)
+void reiser4_kill_cursors(struct inode *inode)
 {
 	process_cursors(inode, CURSOR_KILL);
 }
@@ -498,14 +498,14 @@ static int file_is_stateless(struct file
 }
 
 /**
- * get_dir_fpos -
+ * reiser4_get_dir_fpos -
  * @dir:
  *
  * Calculates ->fpos from user-supplied cookie. Normally it is dir->f_pos, but
  * in the case of stateless directory operation (readdir-over-nfs), client id
  * was encoded in the high bits of cookie and should me masked off.
  */
-loff_t get_dir_fpos(struct file *dir)
+loff_t reiser4_get_dir_fpos(struct file *dir)
 {
 	if (file_is_stateless(dir))
 		return dir->f_pos & CID_MASK;
@@ -514,13 +514,13 @@ loff_t get_dir_fpos(struct file *dir)
 }
 
 /**
- * try_to_attach_fsdata - ???
+ * reiser4_attach_fsdata - try to attach fsdata
  * @file:
  * @inode:
  *
  * Finds or creates cursor for readdir-over-nfs.
  */
-int try_to_attach_fsdata(struct file *file, struct inode *inode)
+int reiser4_attach_fsdata(struct file *file, struct inode *inode)
 {
 	loff_t pos;
 	int result;
@@ -539,7 +539,8 @@ int try_to_attach_fsdata(struct file *fi
 		 * first call to readdir (or rewind to the beginning of
 		 * directory)
 		 */
-		cursor = kmem_cache_alloc(d_cursor_cache, get_gfp_mask());
+		cursor = kmem_cache_alloc(d_cursor_cache,
+					  reiser4_ctx_gfp_mask_get());
 		if (cursor != NULL)
 			result = insert_cursor(cursor, file, inode);
 		else
@@ -575,12 +576,12 @@ int try_to_attach_fsdata(struct file *fi
 }
 
 /**
- * detach_fsdata - ???
+ * reiser4_detach_fsdata - ???
  * @file:
  *
  * detach fsdata, if necessary
  */
-void detach_fsdata(struct file *file)
+void reiser4_detach_fsdata(struct file *file)
 {
 	struct inode *inode;
 
@@ -597,12 +598,12 @@ void detach_fsdata(struct file *file)
 static kmem_cache_t *dentry_fsdata_cache;
 
 /**
- * init_dentry_fsdata - create cache of dentry_fsdata
+ * reiser4_init_dentry_fsdata - create cache of dentry_fsdata
  *
  * Initializes slab cache of structures attached to denty->d_fsdata. It is
  * part of reiser4 module initialization.
  */
-int init_dentry_fsdata(void)
+int reiser4_init_dentry_fsdata(void)
 {
 	dentry_fsdata_cache = kmem_cache_create("dentry_fsdata",
 						sizeof(reiser4_dentry_fsdata),
@@ -616,11 +617,11 @@ int init_dentry_fsdata(void)
 }
 
 /**
- * done_dentry_fsdata - delete cache of dentry_fsdata
+ * reiser4_done_dentry_fsdata - delete cache of dentry_fsdata
  *
  * This is called on reiser4 module unloading or system shutdown.
  */
-void done_dentry_fsdata(void)
+void reiser4_done_dentry_fsdata(void)
 {
 	destroy_reiser4_cache(&dentry_fsdata_cache);
 }
@@ -638,7 +639,7 @@ reiser4_dentry_fsdata *reiser4_get_dentr
 
 	if (dentry->d_fsdata == NULL) {
 		dentry->d_fsdata = kmem_cache_alloc(dentry_fsdata_cache,
-						    get_gfp_mask());
+						    reiser4_ctx_gfp_mask_get());
 		if (dentry->d_fsdata == NULL)
 			return ERR_PTR(RETERR(-ENOMEM));
 		memset(dentry->d_fsdata, 0, sizeof(reiser4_dentry_fsdata));
@@ -665,12 +666,12 @@ void reiser4_free_dentry_fsdata(struct d
 static kmem_cache_t *file_fsdata_cache;
 
 /**
- * init_file_fsdata - create cache of reiser4_file_fsdata
+ * reiser4_init_file_fsdata - create cache of reiser4_file_fsdata
  *
  * Initializes slab cache of structures attached to file->private_data. It is
  * part of reiser4 module initialization.
  */
-int init_file_fsdata(void)
+int reiser4_init_file_fsdata(void)
 {
 	file_fsdata_cache = kmem_cache_create("file_fsdata",
 					      sizeof(reiser4_file_fsdata),
@@ -683,11 +684,11 @@ int init_file_fsdata(void)
 }
 
 /**
- * done_file_fsdata - delete cache of reiser4_file_fsdata
+ * reiser4_done_file_fsdata - delete cache of reiser4_file_fsdata
  *
  * This is called on reiser4 module unloading or system shutdown.
  */
-void done_file_fsdata(void)
+void reiser4_done_file_fsdata(void)
 {
 	destroy_reiser4_cache(&file_fsdata_cache);
 }
@@ -702,7 +703,8 @@ static reiser4_file_fsdata *create_fsdat
 {
 	reiser4_file_fsdata *fsdata;
 
-	fsdata = kmem_cache_alloc(file_fsdata_cache, get_gfp_mask());
+	fsdata = kmem_cache_alloc(file_fsdata_cache,
+				  reiser4_ctx_gfp_mask_get());
 	if (fsdata != NULL) {
 		memset(fsdata, 0, sizeof *fsdata);
 		fsdata->ra1.max_window_size = VM_MAX_READAHEAD * 1024;
diff -puN fs/reiser4/fsdata.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/fsdata.h
--- a/fs/reiser4/fsdata.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/fsdata.h
@@ -82,8 +82,8 @@ typedef struct reiser4_dentry_fsdata {
 				 * treatment in readdir. */
 } reiser4_dentry_fsdata;
 
-extern int init_dentry_fsdata(void);
-extern void done_dentry_fsdata(void);
+extern int reiser4_init_dentry_fsdata(void);
+extern void reiser4_done_dentry_fsdata(void);
 extern reiser4_dentry_fsdata *reiser4_get_dentry_fsdata(struct dentry *);
 extern void reiser4_free_dentry_fsdata(struct dentry *dentry);
 
@@ -123,7 +123,7 @@ typedef struct reiser4_file_fsdata {
 		/* this is called by reiser4_readpages if set */
 		void (*readpages) (struct address_space *,
 				   struct list_head * pages, void *data);
-		/* reiser4_readpaextended coord. It is set by read_extent before
+		/* This is set by reiser4_read_extent before
 		   calling page_cache_readahead */
 		void *data;
 	} ra2;
@@ -131,8 +131,8 @@ typedef struct reiser4_file_fsdata {
 
 } reiser4_file_fsdata;
 
-extern int init_file_fsdata(void);
-extern void done_file_fsdata(void);
+extern int reiser4_init_file_fsdata(void);
+extern void reiser4_done_file_fsdata(void);
 extern reiser4_file_fsdata *reiser4_get_file_fsdata(struct file *);
 extern void reiser4_free_file_fsdata(struct file *);
 
@@ -174,23 +174,24 @@ struct dir_cursor {
 	struct list_head alist;
 };
 
-extern int init_d_cursor(void);
-extern void done_d_cursor(void);
+extern int reiser4_init_d_cursor(void);
+extern void reiser4_done_d_cursor(void);
 
-extern int init_super_d_info(struct super_block *);
-extern void done_super_d_info(struct super_block *);
+extern int reiser4_init_super_d_info(struct super_block *);
+extern void reiser4_done_super_d_info(struct super_block *);
 
-extern loff_t get_dir_fpos(struct file *);
-extern int try_to_attach_fsdata(struct file *, struct inode *);
-extern void detach_fsdata(struct file *);
+extern loff_t reiser4_get_dir_fpos(struct file *);
+extern int reiser4_attach_fsdata(struct file *, struct inode *);
+extern void reiser4_detach_fsdata(struct file *);
 
 
 /* these are needed for "stateless" readdir. See plugin/file_ops_readdir.c for
    more details */
-void dispose_cursors(struct inode *inode);
-void load_cursors(struct inode *inode);
-void kill_cursors(struct inode *inode);
-void adjust_dir_file(struct inode *dir, const struct dentry *de, int offset, int adj);
+void reiser4_dispose_cursors(struct inode *inode);
+void reiser4_load_cursors(struct inode *inode);
+void reiser4_kill_cursors(struct inode *inode);
+void reiser4_adjust_dir_file(struct inode *dir, const struct dentry *de,
+			     int offset, int adj);
 
 /*
  * this structure is embedded to reise4_super_info_data. It maintains d_cursors
diff -puN fs/reiser4/init_super.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/init_super.c
--- a/fs/reiser4/init_super.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/init_super.c
@@ -14,11 +14,12 @@
  * Allocates and initialize reiser4_super_info_data, attaches it to
  * super->s_fs_info, initializes structures maintaining d_cursor-s.
  */
-int init_fs_info(struct super_block *super)
+int reiser4_init_fs_info(struct super_block *super)
 {
 	reiser4_super_info_data *sbinfo;
 
-	sbinfo = kmalloc(sizeof(reiser4_super_info_data), get_gfp_mask());
+	sbinfo = kmalloc(sizeof(reiser4_super_info_data),
+			 reiser4_ctx_gfp_mask_get());
 	if (!sbinfo)
 		return RETERR(-ENOMEM);
 
@@ -34,29 +35,29 @@ int init_fs_info(struct super_block *sup
 	spin_lock_init(&(sbinfo->guard));
 
 	/*  initialize per-super-block d_cursor resources */
-	init_super_d_info(super);
+	reiser4_init_super_d_info(super);
 
 	return 0;
 }
 
 /**
- * done_fs_info - free reiser4 specific super block
+ * reiser4_done_fs_info - free reiser4 specific super block
  * @super: super block of filesystem
  *
  * Performs some sanity checks, releases structures maintaining d_cursor-s,
  * frees reiser4_super_info_data.
  */
-void done_fs_info(struct super_block *super)
+void reiser4_done_fs_info(struct super_block *super)
 {
 	assert("zam-990", super->s_fs_info != NULL);
 
 	/* release per-super-block d_cursor resources */
-	done_super_d_info(super);
+	reiser4_done_super_d_info(super);
 
 	/* make sure that there are not jnodes already */
 	assert("", list_empty(&get_super_private(super)->all_jnodes));
 	assert("", get_current_context()->trans->atom == NULL);
-	check_block_counters(super);
+	reiser4_check_block_counters(super);
 	kfree(super->s_fs_info);
 	super->s_fs_info = NULL;
 }
@@ -293,14 +294,14 @@ static int parse_options(char *opt_strin
 #define MAX_NR_OPTIONS (30)
 
 /**
- * init_super_data - initialize reiser4 private super block
+ * reiser4_init_super_data - initialize reiser4 private super block
  * @super: super block to initialize
  * @opt_string: list of reiser4 mount options
  *
  * Sets various reiser4 parameters to default values. Parses mount options and
  * overwrites default settings.
  */
-int init_super_data(struct super_block *super, char *opt_string)
+int reiser4_init_super_data(struct super_block *super, char *opt_string)
 {
 	int result;
 	opt_desc_t *opts, *p;
@@ -344,7 +345,8 @@ int init_super_data(struct super_block *
 	sbinfo->ra_params.flags = 0;
 
 	/* allocate memory for structure describing reiser4 mount options */
-	opts = kmalloc(sizeof(opt_desc_t) * MAX_NR_OPTIONS, get_gfp_mask());
+	opts = kmalloc(sizeof(opt_desc_t) * MAX_NR_OPTIONS,
+		       reiser4_ctx_gfp_mask_get());
 	if (opts == NULL)
 		return RETERR(-ENOMEM);
 
@@ -518,14 +520,14 @@ do {						\
 }
 
 /**
- * init_read_super - read reiser4 master super block
+ * reiser4_init_read_super - read reiser4 master super block
  * @super: super block to fill
  * @silent: if 0 - print warnings
  *
  * Reads reiser4 master super block either from predefined location or from
  * location specified by altsuper mount option, initializes disk format plugin.
  */
-int init_read_super(struct super_block *super, int silent)
+int reiser4_init_read_super(struct super_block *super, int silent)
 {
 	struct buffer_head *super_bh;
 	struct reiser4_master_sb *master_sb;
@@ -674,13 +676,13 @@ static reiser4_plugin *get_default_plugi
 }
 
 /**
- * init_root_inode - obtain inode of root directory
+ * reiser4_init_root_inode - obtain inode of root directory
  * @super: super block of filesystem
  *
  * Obtains inode of root directory (reading it from disk), initializes plugin
  * set it was not initialized.
  */
-int init_root_inode(struct super_block *super)
+int reiser4_init_root_inode(struct super_block *super)
 {
 	reiser4_super_info_data *sbinfo = get_super_private(super);
 	struct inode *inode;
diff -puN fs/reiser4/inode.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/inode.c
--- a/fs/reiser4/inode.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/inode.c
@@ -23,11 +23,11 @@
 
 /* return reiser4 internal tree which inode belongs to */
 /* Audited by: green(2002.06.17) */
-reiser4_tree *tree_by_inode(const struct inode *inode /* inode queried */ )
+reiser4_tree *reiser4_tree_by_inode(const struct inode *inode /* inode queried */ )
 {
 	assert("nikita-256", inode != NULL);
 	assert("nikita-257", inode->i_sb != NULL);
-	return get_tree(inode->i_sb);
+	return reiser4_get_tree(inode->i_sb);
 }
 
 /* return reiser4-specific inode flags */
@@ -38,21 +38,22 @@ static inline unsigned long *inode_flags
 }
 
 /* set reiser4-specific flag @f in @inode */
-void inode_set_flag(struct inode *inode, reiser4_file_plugin_flags f)
+void reiser4_inode_set_flag(struct inode *inode, reiser4_file_plugin_flags f)
 {
 	assert("nikita-2248", inode != NULL);
 	set_bit((int)f, inode_flags(inode));
 }
 
 /* clear reiser4-specific flag @f in @inode */
-void inode_clr_flag(struct inode *inode, reiser4_file_plugin_flags f)
+void reiser4_inode_clr_flag(struct inode *inode, reiser4_file_plugin_flags f)
 {
 	assert("nikita-2250", inode != NULL);
 	clear_bit((int)f, inode_flags(inode));
 }
 
 /* true if reiser4-specific flag @f is set in @inode */
-int inode_get_flag(const struct inode *inode, reiser4_file_plugin_flags f)
+int reiser4_inode_get_flag(const struct inode *inode,
+			   reiser4_file_plugin_flags f)
 {
 	assert("nikita-2251", inode != NULL);
 	return test_bit((int)f, inode_flags(inode));
@@ -283,7 +284,7 @@ static int read_inode(struct inode *inod
 		if (result == 0) {
 			/* initialize stat-data seal */
 			spin_lock_inode(inode);
-			seal_init(&info->sd_seal, &coord, key);
+			reiser4_seal_init(&info->sd_seal, &coord, key);
 			info->sd_coord = coord;
 			spin_unlock_inode(inode);
 
@@ -295,7 +296,7 @@ static int read_inode(struct inode *inod
 									  0);
 			/* load detached directory cursors for stateless
 			 * directory readers (NFS). */
-			load_cursors(inode);
+			reiser4_load_cursors(inode);
 
 			/* Check the opened inode for consistency. */
 			result =
@@ -432,7 +433,7 @@ struct inode *reiser4_iget(struct super_
 		return ERR_PTR(RETERR(-ENOMEM));
 	if (is_bad_inode(inode)) {
 		warning("nikita-304", "Bad inode found");
-		print_key("key", key);
+		reiser4_print_key("key", key);
 		iput(inode);
 		return ERR_PTR(RETERR(-EIO));
 	}
@@ -476,8 +477,8 @@ struct inode *reiser4_iget(struct super_
 		build_sd_key(inode, &found_key);
 		if (!keyeq(&found_key, key)) {
 			warning("nikita-305", "Wrong key in sd");
-			print_key("sought for", key);
-			print_key("found", &found_key);
+			reiser4_print_key("sought for", key);
+			reiser4_print_key("found", &found_key);
 		}
 		if (inode->i_nlink == 0) {
 			warning("nikita-3559", "Unlinked inode found: %llu\n",
@@ -494,7 +495,7 @@ void reiser4_iget_complete(struct inode 
 	assert("zam-988", is_reiser4_inode(inode));
 
 	if (!is_inode_loaded(inode)) {
-		inode_set_flag(inode, REISER4_LOADED);
+		reiser4_inode_set_flag(inode, REISER4_LOADED);
 		loading_up(reiser4_inode_data(inode));
 	}
 }
@@ -504,7 +505,7 @@ void reiser4_make_bad_inode(struct inode
 	assert("nikita-1934", inode != NULL);
 
 	/* clear LOADED bit */
-	inode_clr_flag(inode, REISER4_LOADED);
+	reiser4_inode_clr_flag(inode, REISER4_LOADED);
 	make_bad_inode(inode);
 	return;
 }
@@ -608,7 +609,7 @@ void inode_set_extension(struct inode *i
 	state->extmask |= 1 << ext;
 	/* force re-calculation of stat-data length on next call to
 	   update_sd(). */
-	inode_clr_flag(inode, REISER4_SDLEN_KNOWN);
+	reiser4_inode_clr_flag(inode, REISER4_SDLEN_KNOWN);
 }
 
 void
@@ -624,7 +625,7 @@ void inode_check_scale_nolock(struct ino
 {
 	assert("edward-1287", inode != NULL);
 	if (!dscale_fit(old, new))
-		inode_clr_flag(inode, REISER4_SDLEN_KNOWN);
+		reiser4_inode_clr_flag(inode, REISER4_SDLEN_KNOWN);
 	return;
 }
 
@@ -677,7 +678,7 @@ znode *inode_get_vroot(struct inode *ino
 	blk = reiser4_inode_data(inode)->vroot;
 	spin_unlock_inode(inode);
 	if (!disk_addr_eq(&UBER_TREE_ADDR, &blk))
-		result = zlook(tree_by_inode(inode), &blk);
+		result = zlook(reiser4_tree_by_inode(inode), &blk);
 	else
 		result = NULL;
 	return result;
@@ -692,7 +693,7 @@ void inode_set_vroot(struct inode *inode
 
 #if REISER4_DEBUG
 
-void inode_invariant(const struct inode *inode)
+void reiser4_inode_invariant(const struct inode *inode)
 {
 	assert("nikita-3077", spin_inode_is_locked(inode));
 }
diff -puN fs/reiser4/inode.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/inode.h
--- a/fs/reiser4/inode.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/inode.h
@@ -252,13 +252,13 @@ static inline struct inode *unix_file_in
 extern ino_t oid_to_ino(oid_t oid) __attribute__ ((const));
 extern ino_t oid_to_uino(oid_t oid) __attribute__ ((const));
 
-extern reiser4_tree *tree_by_inode(const struct inode *inode);
+extern reiser4_tree *reiser4_tree_by_inode(const struct inode *inode);
 
 #if REISER4_DEBUG
-extern void inode_invariant(const struct inode *inode);
+extern void reiser4_inode_invariant(const struct inode *inode);
 extern int inode_has_no_jnodes(reiser4_inode *);
 #else
-#define inode_invariant(inode) noop
+#define reiser4_inode_invariant(inode) noop
 #endif
 
 static inline int spin_inode_is_locked(const struct inode *inode)
@@ -286,7 +286,7 @@ static inline void spin_lock_inode(struc
 	LOCK_CNT_INC(spin_locked_inode);
 	LOCK_CNT_INC(spin_locked);
 
-	inode_invariant(inode);
+	reiser4_inode_invariant(inode);
 }
 
 /**
@@ -302,7 +302,7 @@ static inline void spin_unlock_inode(str
 	assert("nikita-1375", LOCK_CNT_GTZ(spin_locked_inode));
 	assert("nikita-1376", LOCK_CNT_GTZ(spin_locked));
 
-	inode_invariant(inode);
+	reiser4_inode_invariant(inode);
 
 	LOCK_CNT_DEC(spin_locked_inode);
 	LOCK_CNT_DEC(spin_locked);
@@ -322,17 +322,17 @@ extern int setup_inode_ops(struct inode 
 extern struct inode *reiser4_iget(struct super_block *super,
 				  const reiser4_key * key, int silent);
 extern void reiser4_iget_complete(struct inode *inode);
-extern void inode_set_flag(struct inode *inode, reiser4_file_plugin_flags f);
-extern void inode_clr_flag(struct inode *inode, reiser4_file_plugin_flags f);
-extern int inode_get_flag(const struct inode *inode,
-			  reiser4_file_plugin_flags f);
+extern void reiser4_inode_set_flag(struct inode *inode, reiser4_file_plugin_flags f);
+extern void reiser4_inode_clr_flag(struct inode *inode, reiser4_file_plugin_flags f);
+extern int reiser4_inode_get_flag(const struct inode *inode,
+				  reiser4_file_plugin_flags f);
 
 /*  has inode been initialized? */
 static inline int
 is_inode_loaded(const struct inode *inode /* inode queried */ )
 {
 	assert("nikita-1120", inode != NULL);
-	return inode_get_flag(inode, REISER4_LOADED);
+	return reiser4_inode_get_flag(inode, REISER4_LOADED);
 }
 
 extern file_plugin *inode_file_plugin(const struct inode *inode);
@@ -390,7 +390,7 @@ extern void inode_check_scale_nolock(str
 	-- __i->field;						\
 })
 
-/* See comment before readdir_common() for description. */
+/* See comment before reiser4_readdir_common() for description. */
 static inline struct list_head *get_readdir_list(const struct inode *inode)
 {
 	return &reiser4_inode_data(inode)->lists.readdir_list;
diff -puN fs/reiser4/jnode.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/jnode.c
--- a/fs/reiser4/jnode.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/jnode.c
@@ -291,7 +291,7 @@ jnode *jnode_by_page(struct page *pg)
 /* exported functions to allocate/free jnode objects outside this file */
 jnode *jalloc(void)
 {
-	jnode *jal = kmem_cache_alloc(_jnode_slab, get_gfp_mask());
+	jnode *jal = kmem_cache_alloc(_jnode_slab, reiser4_ctx_gfp_mask_get());
 	return jal;
 }
 
@@ -410,7 +410,7 @@ jnode *jfind(struct address_space * mapp
 	jnode *node;
 
 	assert("vs-1694", mapping->host != NULL);
-	tree = tree_by_inode(mapping->host);
+	tree = reiser4_tree_by_inode(mapping->host);
 
 	read_lock_tree(tree);
 	node = jfind_nolock(mapping, index);
@@ -522,7 +522,7 @@ static void unhash_unformatted_node_nolo
 
 /* remove jnode from hash table and from inode's tree of jnodes. This is used in
    reiser4_invalidatepage and in kill_hook_extent -> truncate_inode_jnodes ->
-   uncapture_jnode */
+   reiser4_uncapture_jnode */
 void unhash_unformatted_jnode(jnode * node)
 {
 	assert("vs-1445", jnode_is_unformatted(node));
@@ -550,7 +550,7 @@ static jnode *find_get_jnode(reiser4_tre
 	if (unlikely(result == NULL))
 		return ERR_PTR(RETERR(-ENOMEM));
 
-	preload = radix_tree_preload(get_gfp_mask());
+	preload = radix_tree_preload(reiser4_ctx_gfp_mask_get());
 	if (preload != 0)
 		return ERR_PTR(preload);
 
@@ -603,7 +603,7 @@ static jnode *do_jget(reiser4_tree * tre
 	if (likely(result != NULL))
 		return jref(result);
 
-	tree = tree_by_page(pg);
+	tree = reiser4_tree_by_page(pg);
 
 	/* check hash-table first */
 	result = jfind(pg->mapping, pg->index);
@@ -635,7 +635,7 @@ jnode *jnode_of_page(struct page * pg)
 	assert("umka-176", pg != NULL);
 	assert("nikita-2394", PageLocked(pg));
 
-	result = do_jget(tree_by_page(pg), pg);
+	result = do_jget(reiser4_tree_by_page(pg), pg);
 
 	if (REISER4_DEBUG && !IS_ERR(result)) {
 		assert("nikita-3210", result == jprivate(pg));
@@ -830,7 +830,7 @@ static int jnode_start_read(jnode * node
 		unlock_page(page);
 		return 0;
 	}
-	return page_io(page, node, READ, get_gfp_mask());
+	return reiser4_page_io(page, node, READ, reiser4_ctx_gfp_mask_get());
 }
 
 #if REISER4_DEBUG
@@ -873,7 +873,7 @@ int jload_gfp(jnode * node /* node to lo
 	int result = 0;
 	int parsed;
 
-	assert("nikita-3010", schedulable());
+	assert("nikita-3010", reiser4_schedulable());
 
 	prefetchw(&node->pg);
 
@@ -947,7 +947,7 @@ int jstartio(jnode * node)
 {
 	struct page *page;
 
-	page = jnode_get_page_locked(node, get_gfp_mask());
+	page = jnode_get_page_locked(node, reiser4_ctx_gfp_mask_get());
 	if (IS_ERR(page))
 		return PTR_ERR(page);
 
@@ -1184,7 +1184,7 @@ static inline void remove_jnode(jnode * 
 static struct address_space *mapping_znode(const jnode * node)
 {
 	/* all znodes belong to fake inode */
-	return get_super_fake(jnode_get_tree(node)->super)->i_mapping;
+	return reiser4_get_super_fake(jnode_get_tree(node)->super)->i_mapping;
 }
 
 /* ->index() method for znodes */
@@ -1340,7 +1340,7 @@ static jnode *clone_formatted(jnode * no
 	znode *clone;
 
 	assert("vs-1430", jnode_is_znode(node));
-	clone = zalloc(get_gfp_mask());
+	clone = zalloc(reiser4_ctx_gfp_mask_get());
 	if (clone == NULL)
 		return ERR_PTR(RETERR(-ENOMEM));
 	zinit(clone, NULL, current_tree);
@@ -1650,7 +1650,7 @@ static int jdelete(jnode * node /* jnode
 		jnode_free(node, jtype);
 		/* @node is no longer valid pointer */
 		if (page != NULL)
-			drop_page(page);
+			reiser4_drop_page(page);
 	} else {
 		/* busy check failed: reference was acquired by concurrent
 		 * thread. */
@@ -1706,7 +1706,7 @@ static int jdrop_in_tree(jnode * node, r
 		write_unlock_tree(tree);
 		jnode_free(node, jtype);
 		if (page != NULL) {
-			drop_page(page);
+			reiser4_drop_page(page);
 		}
 	} else {
 		/* busy check failed: reference was acquired by concurrent
@@ -1731,7 +1731,7 @@ void jdrop(jnode * node)
    functionality (these j-nodes are not in any hash table) just for reading
    from and writing to disk. */
 
-jnode *alloc_io_head(const reiser4_block_nr * block)
+jnode *reiser4_alloc_io_head(const reiser4_block_nr * block)
 {
 	jnode *jal = jalloc();
 
@@ -1745,7 +1745,7 @@ jnode *alloc_io_head(const reiser4_block
 	return jal;
 }
 
-void drop_io_head(jnode * node)
+void reiser4_drop_io_head(jnode * node)
 {
 	assert("zam-648", jnode_get_type(node) == JNODE_IO_HEAD);
 
diff -puN fs/reiser4/jnode.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/jnode.h
--- a/fs/reiser4/jnode.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/jnode.h
@@ -398,8 +398,8 @@ static inline const reiser4_block_nr *jn
 }
 
 /* Jnode flush interface. */
-extern reiser4_blocknr_hint *pos_hint(flush_pos_t * pos);
-extern flush_queue_t *pos_fq(flush_pos_t * pos);
+extern reiser4_blocknr_hint *reiser4_pos_hint(flush_pos_t * pos);
+extern flush_queue_t *reiser4_pos_fq(flush_pos_t * pos);
 
 /* FIXME-VS: these are used in plugin/item/extent.c */
 
@@ -504,7 +504,7 @@ extern int jload_gfp(jnode *, gfp_t, int
 
 static inline int jload(jnode *node)
 {
-	return jload_gfp(node, get_gfp_mask(), 1);
+	return jload_gfp(node, reiser4_ctx_gfp_mask_get(), 1);
 }
 
 extern int jinit_new(jnode *, gfp_t) NONNULL;
@@ -515,8 +515,8 @@ extern int jwait_io(jnode *, int rw) NON
 
 void jload_prefetch(jnode *);
 
-extern jnode *alloc_io_head(const reiser4_block_nr * block) NONNULL;
-extern void drop_io_head(jnode * node) NONNULL;
+extern jnode *reiser4_alloc_io_head(const reiser4_block_nr * block) NONNULL;
+extern void reiser4_drop_io_head(jnode * node) NONNULL;
 
 static inline reiser4_tree *jnode_get_tree(const jnode * node)
 {
@@ -658,7 +658,7 @@ static inline void jput(jnode * node)
 {
 	assert("jmacd-509", node != NULL);
 	assert("jmacd-510", atomic_read(&node->x_count) > 0);
-	assert("zam-926", schedulable());
+	assert("zam-926", reiser4_schedulable());
 	LOCK_CNT_DEC(x_refs);
 
 	rcu_read_lock();
@@ -669,7 +669,7 @@ static inline void jput(jnode * node)
 		jput_final(node);
 	} else
 		rcu_read_unlock();
-	assert("nikita-3473", schedulable());
+	assert("nikita-3473", reiser4_schedulable());
 }
 
 extern void jrelse(jnode * node);
diff -puN fs/reiser4/kassign.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/kassign.c
--- a/fs/reiser4/kassign.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/kassign.c
@@ -217,7 +217,7 @@ int is_longname_key(const reiser4_key * 
 
 	assert("nikita-2863", key != NULL);
 	if (get_key_type(key) != KEY_FILE_NAME_MINOR)
-		print_key("oops", key);
+		reiser4_print_key("oops", key);
 	assert("nikita-2864", get_key_type(key) == KEY_FILE_NAME_MINOR);
 
 	if (REISER4_LARGE_KEY)
@@ -262,7 +262,7 @@ static __u64 pack_string(const char *nam
 
 /* opposite to pack_string(). Takes value produced by pack_string(), restores
  * string encoded in it and stores result in @buf */
-char *unpack_string(__u64 value, char *buf)
+char * reiser4_unpack_string(__u64 value, char *buf)
 {
 	do {
 		*buf = value >> (64 - 8);
@@ -283,11 +283,13 @@ char *extract_name_from_key(const reiser
 
 	c = buf;
 	if (REISER4_LARGE_KEY) {
-		c = unpack_string(get_key_ordering(key) & ~fibration_mask, c);
-		c = unpack_string(get_key_fulloid(key), c);
+		c = reiser4_unpack_string(get_key_ordering(key) &
+					  ~fibration_mask, c);
+		c = reiser4_unpack_string(get_key_fulloid(key), c);
 	} else
-		c = unpack_string(get_key_fulloid(key) & ~fibration_mask, c);
-	unpack_string(get_key_offset(key), c);
+		c = reiser4_unpack_string(get_key_fulloid(key) &
+					  ~fibration_mask, c);
+	reiser4_unpack_string(get_key_offset(key), c);
 	return buf;
 }
 
diff -puN fs/reiser4/kassign.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/kassign.h
--- a/fs/reiser4/kassign.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/kassign.h
@@ -92,7 +92,7 @@ extern reiser4_key *build_sd_key(const s
 extern int is_longname_key(const reiser4_key * key);
 extern int is_longname(const char *name, int len);
 extern char *extract_name_from_key(const reiser4_key * key, char *buf);
-extern char *unpack_string(__u64 value, char *buf);
+extern char *reiser4_unpack_string(__u64 value, char *buf);
 extern void complete_entry_key(const struct inode *dir, const char *name,
 			       int len, reiser4_key *result);
 
diff -puN fs/reiser4/key.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/key.c
--- a/fs/reiser4/key.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/key.c
@@ -39,13 +39,13 @@ void reiser4_key_init(reiser4_key * key 
 }
 
 /* minimal possible key in the tree. Return pointer to the static storage. */
-const reiser4_key *min_key(void)
+const reiser4_key *reiser4_min_key(void)
 {
 	return &MINIMAL_KEY;
 }
 
 /* maximum possible key in the tree. Return pointer to the static storage. */
-const reiser4_key *max_key(void)
+const reiser4_key *reiser4_max_key(void)
 {
 	return &MAXIMAL_KEY;
 }
@@ -71,7 +71,7 @@ static const char *type_name(unsigned in
 }
 
 /* debugging aid: print human readable information about key */
-void print_key(const char *prefix /* prefix to print */ ,
+void reiser4_print_key(const char *prefix /* prefix to print */ ,
 	       const reiser4_key * key /* key to print */ )
 {
 	/* turn bold on */
@@ -101,8 +101,8 @@ void print_key(const char *prefix /* pre
 			char *c;
 
 			c = buf;
-			c = unpack_string(get_key_ordering(key), c);
-			unpack_string(get_key_fulloid(key), c);
+			c = reiser4_unpack_string(get_key_ordering(key), c);
+			reiser4_unpack_string(get_key_fulloid(key), c);
 			printk("[%s", buf);
 			if (is_longname_key(key))
 				/*
@@ -113,7 +113,7 @@ void print_key(const char *prefix /* pre
 				/*
 				 * whole name is stored in the key.
 				 */
-				unpack_string(get_key_offset(key), buf);
+				reiser4_unpack_string(get_key_offset(key), buf);
 				printk("%s]\n", buf);
 			}
 		} else {
diff -puN fs/reiser4/key.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/key.h
--- a/fs/reiser4/key.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/key.h
@@ -226,8 +226,8 @@ typedef enum { LESS_THAN = -1,	/* if fir
 void reiser4_key_init(reiser4_key * key);
 
 /* minimal possible key in the tree. Return pointer to the static storage. */
-extern const reiser4_key *min_key(void);
-extern const reiser4_key *max_key(void);
+extern const reiser4_key *reiser4_min_key(void);
+extern const reiser4_key *reiser4_max_key(void);
 
 /* helper macro for keycmp() */
 #define KEY_DIFF(k1, k2, field)							\
@@ -365,9 +365,9 @@ static inline void prefetchkey(reiser4_k
 #define KEY_BUF_LEN (80)
 
 #if REISER4_DEBUG
-extern void print_key(const char *prefix, const reiser4_key * key);
+extern void reiser4_print_key(const char *prefix, const reiser4_key * key);
 #else
-#define print_key(p,k) noop
+#define reiser4_print_key(p,k) noop
 #endif
 
 /* __FS_REISERFS_KEY_H__ */
diff -puN fs/reiser4/ktxnmgrd.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/ktxnmgrd.c
--- a/fs/reiser4/ktxnmgrd.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/ktxnmgrd.c
@@ -115,13 +115,13 @@ static int ktxnmgrd(void *arg)
 #undef set_comm
 
 /**
- * init_ktxnmgrd - initialize ktxnmgrd context and start kernel daemon
+ * reiser4_init_ktxnmgrd - initialize ktxnmgrd context and start kernel daemon
  * @super: pointer to super block
  *
  * Allocates and initializes ktxnmgrd_context, attaches it to transaction
  * manager. Starts kernel txnmgr daemon. This is called on mount.
  */
-int init_ktxnmgrd(struct super_block *super)
+int reiser4_init_ktxnmgrd(struct super_block *super)
 {
 	txn_mgr *mgr;
 	ktxnmgrd_context *ctx;
@@ -130,7 +130,7 @@ int init_ktxnmgrd(struct super_block *su
 
 	assert("zam-1014", mgr->daemon == NULL);
 
-	ctx = kmalloc(sizeof(ktxnmgrd_context), get_gfp_mask());
+	ctx = kmalloc(sizeof(ktxnmgrd_context), reiser4_ctx_gfp_mask_get());
 	if (ctx == NULL)
 		return RETERR(-ENOMEM);
 
@@ -187,12 +187,12 @@ static int scan_mgr(struct super_block *
 }
 
 /**
- * done_ktxnmgrd - stop kernel thread and frees ktxnmgrd context
+ * reiser4_done_ktxnmgrd - stop kernel thread and frees ktxnmgrd context
  * @mgr:
  *
  * This is called on umount. Stops ktxnmgrd and free t
  */
-void done_ktxnmgrd(struct super_block *super)
+void reiser4_done_ktxnmgrd(struct super_block *super)
 {
 	txn_mgr *mgr;
 
diff -puN fs/reiser4/ktxnmgrd.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/ktxnmgrd.h
--- a/fs/reiser4/ktxnmgrd.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/ktxnmgrd.h
@@ -32,8 +32,8 @@ struct ktxnmgrd_context {
 	unsigned int rescan:1;
 };
 
-extern int init_ktxnmgrd(struct super_block *);
-extern void done_ktxnmgrd(struct super_block *);
+extern int reiser4_init_ktxnmgrd(struct super_block *);
+extern void reiser4_done_ktxnmgrd(struct super_block *);
 
 extern void ktxnmgrd_kick(txn_mgr * mgr);
 extern int is_current_ktxnmgrd(void);
diff -puN fs/reiser4/lock.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/lock.c
--- a/fs/reiser4/lock.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/lock.c
@@ -205,17 +205,17 @@
 
 /* Znode lock and capturing intertwining. */
 /* In current implementation we capture formatted nodes before locking
-   them. Take a look on longterm lock znode, try_capture() request precedes
-   locking requests.  The longterm_lock_znode function unconditionally captures
-   znode before even checking of locking conditions.
+   them. Take a look on longterm lock znode, reiser4_try_capture() request
+   precedes locking requests.  The longterm_lock_znode function unconditionally
+   captures znode before even checking of locking conditions.
 
    Another variant is to capture znode after locking it.  It was not tested, but
    at least one deadlock condition is supposed to be there.  One thread has
-   locked a znode (Node-1) and calls try_capture() for it.  Try_capture() sleeps
-   because znode's atom has CAPTURE_WAIT state.  Second thread is a flushing
-   thread, its current atom is the atom Node-1 belongs to. Second thread wants
-   to lock Node-1 and sleeps because Node-1 is locked by the first thread.  The
-   described situation is a deadlock. */
+   locked a znode (Node-1) and calls reiser4_try_capture() for it.
+   reiser4_try_capture() sleeps because znode's atom has CAPTURE_WAIT state.
+   Second thread is a flushing thread, its current atom is the atom Node-1
+   belongs to. Second thread wants to lock Node-1 and sleeps because Node-1
+   is locked by the first thread.  The described situation is a deadlock. */
 
 #include "debug.h"
 #include "txnmgr.h"
@@ -276,7 +276,7 @@ link_object(lock_handle * handle, lock_s
 	/* add lock handle to the end of lock_stack's list of locks */
 	list_add_tail(&handle->locks_link, &owner->locks);
 	ON_DEBUG(owner->nr_locks++);
-	set_gfp_mask();
+	reiser4_ctx_gfp_mask_set();
 
 	/* add lock handle to the head of znode's list of owners */
 	list_add(&handle->owners_link, &node->lock.owners);
@@ -295,7 +295,7 @@ static inline void unlink_object(lock_ha
 	/* remove lock handle from lock_stack's list of locks */
 	list_del(&handle->locks_link);
 	ON_DEBUG(handle->owner->nr_locks--);
-	set_gfp_mask();
+	reiser4_ctx_gfp_mask_set();
 	assert("reiser4-6",
 	       ergo(list_empty_careful(&handle->owner->locks),
 		    handle->owner->nr_locks == 0));
@@ -717,7 +717,7 @@ static int longterm_lock_tryfast(lock_st
 	node = owner->request.node;
 	lock = &node->lock;
 
-	assert("nikita-3340", schedulable());
+	assert("nikita-3340", reiser4_schedulable());
 	assert("nikita-3341", request_is_deadlock_safe(node,
 						       ZNODE_READ_LOCK,
 						       ZNODE_LOCK_LOPRI));
@@ -727,7 +727,7 @@ static int longterm_lock_tryfast(lock_st
 
 	if (likely(result != -EINVAL)) {
 		spin_lock_znode(node);
-		result = try_capture(ZJNODE(node), ZNODE_READ_LOCK, 0);
+		result = reiser4_try_capture(ZJNODE(node), ZNODE_READ_LOCK, 0);
 		spin_unlock_znode(node);
 		spin_lock_zlock(lock);
 		if (unlikely(result != 0)) {
@@ -771,7 +771,7 @@ int longterm_lock_znode(
 	/* Check that the lock handle is initialized and isn't already being
 	 * used. */
 	assert("jmacd-808", handle->owner == NULL);
-	assert("nikita-3026", schedulable());
+	assert("nikita-3026", reiser4_schedulable());
 	assert("nikita-3219", request_is_deadlock_safe(node, mode, request));
 	assert("zam-1056", atomic_read(&ZJNODE(node)->x_count) > 0);
 	/* long term locks are not allowed in the VM contexts (->writepage(),
@@ -855,7 +855,7 @@ int longterm_lock_znode(
 		 * 1. read of aligned word is atomic with respect to writes to
 		 * this word
 		 *
-		 * 2. false negatives are handled in try_capture().
+		 * 2. false negatives are handled in reiser4_try_capture().
 		 *
 		 * 3. false positives are impossible.
 		 *
@@ -883,8 +883,8 @@ int longterm_lock_znode(
 		 *
 		 * Suppose node->atom == NULL, that is, node was un-captured
 		 * between T1, and T3. But un-capturing of formatted node is
-		 * always preceded by the call to invalidate_lock(), which
-		 * marks znode as JNODE_IS_DYING under zlock spin
+		 * always preceded by the call to reiser4_invalidate_lock(),
+		 * which marks znode as JNODE_IS_DYING under zlock spin
 		 * lock. Contradiction, because can_lock_object() above checks
 		 * for JNODE_IS_DYING. Hence, node->atom != NULL at T3.
 		 *
@@ -907,13 +907,13 @@ int longterm_lock_znode(
 			/*
 			 * unlock zlock spin lock here. It is possible for
 			 * longterm_unlock_znode() to sneak in here, but there
-			 * is no harm: invalidate_lock() will mark znode as
-			 * JNODE_IS_DYING and this will be noted by
+			 * is no harm: reiser4_invalidate_lock() will mark znode
+			 * as JNODE_IS_DYING and this will be noted by
 			 * can_lock_object() below.
 			 */
 			spin_unlock_zlock(lock);
 			spin_lock_znode(node);
-			ret = try_capture(ZJNODE(node), mode, cap_flags);
+			ret = reiser4_try_capture(ZJNODE(node), mode, cap_flags);
 			spin_unlock_znode(node);
 			spin_lock_zlock(lock);
 			if (unlikely(ret != 0)) {
@@ -943,7 +943,7 @@ int longterm_lock_znode(
 		/* By having semaphore initialization here we cannot lose
 		   wakeup signal even if it comes after `nr_signaled' field
 		   check. */
-		ret = prepare_to_sleep(owner);
+		ret = reiser4_prepare_to_sleep(owner);
 		if (unlikely(ret != 0)) {
 			break;
 		}
@@ -968,7 +968,7 @@ int longterm_lock_znode(
 		   a znode ... */
 		spin_unlock_zlock(lock);
 		/* ... and sleep */
-		go_to_sleep(owner);
+		reiser4_go_to_sleep(owner);
 		if (owner->request.mode == ZNODE_NO_LOCK)
 			goto request_is_done;
 		spin_lock_zlock(lock);
@@ -989,10 +989,10 @@ int longterm_lock_znode(
 
 /* lock object invalidation means changing of lock object state to `INVALID'
    and waiting for all other processes to cancel theirs lock requests. */
-void invalidate_lock(lock_handle * handle	/* path to lock
-						 * owner and lock
-						 * object is being
-						 * invalidated. */ )
+void reiser4_invalidate_lock(lock_handle * handle	/* path to lock
+							 * owner and lock
+							 * object is being
+							 * invalidated. */ )
 {
 	znode *node = handle->node;
 	lock_stack *owner = handle->owner;
@@ -1093,7 +1093,7 @@ void copy_lh(lock_handle * new, lock_han
 }
 
 /* after getting -E_DEADLOCK we unlock znodes until this function returns false */
-int check_deadlock(void)
+int reiser4_check_deadlock(void)
 {
 	lock_stack *owner = get_current_lock_stack();
 	return atomic_read(&owner->nr_signaled) != 0;
@@ -1101,7 +1101,7 @@ int check_deadlock(void)
 
 /* Before going to sleep we re-check "release lock" requests which might come from threads with hi-pri lock
    priorities. */
-int prepare_to_sleep(lock_stack * owner)
+int reiser4_prepare_to_sleep(lock_stack * owner)
 {
 	assert("nikita-1847", owner == get_current_lock_stack());
 	/* NOTE(Zam): We cannot reset the lock semaphore here because it may
@@ -1144,10 +1144,10 @@ void __reiser4_wake_up(lock_stack * owne
 }
 
 /* Puts a thread to sleep */
-void go_to_sleep(lock_stack * owner)
+void reiser4_go_to_sleep(lock_stack * owner)
 {
 	/* Well, we might sleep here, so holding of any spinlocks is no-no */
-	assert("nikita-3027", schedulable());
+	assert("nikita-3027", reiser4_schedulable());
 	/* return down_interruptible(&owner->sema); */
 	down(&owner->sema);
 }
diff -puN fs/reiser4/lock.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/lock.h
--- a/fs/reiser4/lock.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/lock.h
@@ -175,7 +175,7 @@ extern int longterm_lock_znode(lock_hand
 
 extern void longterm_unlock_znode(lock_handle * handle);
 
-extern int check_deadlock(void);
+extern int reiser4_check_deadlock(void);
 
 extern lock_stack *get_current_lock_stack(void);
 
@@ -203,8 +203,8 @@ static inline  void done_lh(lock_handle 
 extern void move_lh(lock_handle * new, lock_handle * old);
 extern void copy_lh(lock_handle * new, lock_handle * old);
 
-extern int prepare_to_sleep(lock_stack * owner);
-extern void go_to_sleep(lock_stack * owner);
+extern int reiser4_prepare_to_sleep(lock_stack * owner);
+extern void reiser4_go_to_sleep(lock_stack * owner);
 extern void __reiser4_wake_up(lock_stack * owner);
 
 extern int lock_stack_isclean(lock_stack * owner);
@@ -212,7 +212,7 @@ extern int lock_stack_isclean(lock_stack
 /* zlock object state check macros: only used in assertions.  Both forms imply that the
    lock is held by the current thread. */
 extern int znode_is_write_locked(const znode *);
-extern void invalidate_lock(lock_handle *);
+extern void reiser4_invalidate_lock(lock_handle *);
 
 /* lock ordering is: first take zlock spin lock, then lock stack spin lock */
 #define spin_ordering_pred_stack(stack)			\
diff -puN fs/reiser4/page_cache.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/page_cache.c
--- a/fs/reiser4/page_cache.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/page_cache.c
@@ -204,13 +204,13 @@ init_fake_inode(struct super_block *supe
 }
 
 /**
- * init_formatted_fake - iget inodes for formatted nodes and bitmaps
+ * reiser4_init_formatted_fake - iget inodes for formatted nodes and bitmaps
  * @super: super block to init fake inode for
  *
  * Initializes fake inode to which formatted nodes are bound in the page cache
  * and inode for bitmaps.
  */
-int init_formatted_fake(struct super_block *super)
+int reiser4_init_formatted_fake(struct super_block *super)
 {
 	struct inode *fake;
 	struct inode *bitmap;
@@ -248,13 +248,13 @@ int init_formatted_fake(struct super_blo
 }
 
 /**
- * done_formatted_fake - release inode used by formatted nodes and bitmaps
+ * reiser4_done_formatted_fake - release inode used by formatted nodes and bitmaps
  * @super: super block to init fake inode for
  *
  * Releases inodes which were used as address spaces of bitmap and formatted
  * nodes.
  */
-void done_formatted_fake(struct super_block *super)
+void reiser4_done_formatted_fake(struct super_block *super)
 {
 	reiser4_super_info_data *sinfo;
 
@@ -289,7 +289,7 @@ void reiser4_wait_page_writeback(struct 
 }
 
 /* return tree @page is in */
-reiser4_tree *tree_by_page(const struct page *page /* page to query */ )
+reiser4_tree *reiser4_tree_by_page(const struct page *page /* page to query */ )
 {
 	assert("nikita-2461", page != NULL);
 	return &get_super_private(page->mapping->host->i_sb)->tree;
@@ -356,11 +356,12 @@ static int formatted_readpage(struct fil
 			      struct page *page /* page to read */ )
 {
 	assert("nikita-2412", PagePrivate(page) && jprivate(page));
-	return page_io(page, jprivate(page), READ, get_gfp_mask());
+	return reiser4_page_io(page, jprivate(page), READ,
+			       reiser4_ctx_gfp_mask_get());
 }
 
 /**
- * page_io - submit single-page bio request
+ * reiser4_page_io - submit single-page bio request
  * @page: page to perform io for
  * @node: jnode of page
  * @rw: read or write
@@ -368,7 +369,7 @@ static int formatted_readpage(struct fil
  *
  * Submits single page read or write.
  */
-int page_io(struct page *page, jnode *node, int rw, gfp_t gfp)
+int reiser4_page_io(struct page *page, jnode *node, int rw, gfp_t gfp)
 {
 	struct bio *bio;
 	int result;
@@ -430,7 +431,7 @@ static struct bio *page_bio(struct page 
 		spin_unlock_jnode(node);
 
 		assert("nikita-2275", blocknr != (reiser4_block_nr) 0);
-		assert("nikita-2276", !blocknr_is_fake(&blocknr));
+		assert("nikita-2276", !reiser4_blocknr_is_fake(&blocknr));
 
 		bio->bi_bdev = super->s_bdev;
 		/* fill bio->bi_sector before calling bio_add_page(), because
@@ -454,7 +455,7 @@ static struct bio *page_bio(struct page 
 }
 
 /* this function is internally called by jnode_make_dirty() */
-int set_page_dirty_internal(struct page *page)
+int reiser4_set_page_dirty_internal(struct page *page)
 {
 	struct address_space *mapping;
 
@@ -469,7 +470,7 @@ int set_page_dirty_internal(struct page 
 	}
 
 	/* znode must be dirty ? */
-	if (mapping->host == get_super_fake(mapping->host->i_sb))
+	if (mapping->host == reiser4_get_super_fake(mapping->host->i_sb))
 		assert("", JF_ISSET(jprivate(page), JNODE_DIRTY));
 	return 0;
 }
@@ -580,7 +581,7 @@ static struct address_space_operations f
 
 /* called just before page is released (no longer used by reiser4). Callers:
    jdelete() and extent2tail(). */
-void drop_page(struct page *page)
+void reiser4_drop_page(struct page *page)
 {
 	assert("nikita-2181", PageLocked(page));
 	clear_page_dirty_for_io(page);
@@ -614,7 +615,7 @@ static void invalidate_unformatted(jnode
 		page_cache_release(page);
 	} else {
 		JF_SET(node, JNODE_HEARD_BANSHEE);
-		uncapture_jnode(node);
+		reiser4_uncapture_jnode(node);
 		unhash_unformatted_jnode(node);
 	}
 }
@@ -634,7 +635,7 @@ truncate_jnodes_range(struct inode *inod
 	truncated_jnodes = 0;
 
 	info = reiser4_inode_data(inode);
-	tree = tree_by_inode(inode);
+	tree = reiser4_tree_by_inode(inode);
 
 	index = from;
 	end = from + count;
diff -puN fs/reiser4/page_cache.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/page_cache.h
--- a/fs/reiser4/page_cache.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/page_cache.h
@@ -13,12 +13,12 @@
 #include <linux/pagemap.h>	/* for lock_page()  */
 
 
-extern int init_formatted_fake(struct super_block *);
-extern void done_formatted_fake(struct super_block *);
+extern int reiser4_init_formatted_fake(struct super_block *);
+extern void reiser4_done_formatted_fake(struct super_block *);
 
-extern reiser4_tree *tree_by_page(const struct page *);
+extern reiser4_tree *reiser4_tree_by_page(const struct page *);
 
-extern int set_page_dirty_internal(struct page *);
+extern int reiser4_set_page_dirty_internal(struct page *);
 
 #define reiser4_submit_bio(rw, bio) submit_bio((rw), (bio))
 
@@ -32,8 +32,8 @@ static inline void lock_and_wait_page_wr
 
 #define jprivate(page) ((jnode *)page_private(page))
 
-extern int page_io(struct page *, jnode *, int rw, gfp_t);
-extern void drop_page(struct page *);
+extern int reiser4_page_io(struct page *, jnode *, int rw, gfp_t);
+extern void reiser4_drop_page(struct page *);
 extern void reiser4_invalidate_pages(struct address_space *, pgoff_t from,
 				     unsigned long count, int even_cows);
 extern void capture_reiser4_inodes(struct super_block *,
diff -puN fs/reiser4/plugin/cluster.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/cluster.h
--- a/fs/reiser4/plugin/cluster.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/cluster.h
@@ -238,10 +238,10 @@ static inline void coord_set_between_clu
 #endif
 }
 
-int inflate_cluster(reiser4_cluster_t *, struct inode *);
-int find_cluster(reiser4_cluster_t *, struct inode *, int read, int write);
+int reiser4_inflate_cluster(reiser4_cluster_t *, struct inode *);
+int find_disk_cluster(reiser4_cluster_t *, struct inode *, int read, int write);
 int flush_cluster_pages(reiser4_cluster_t *, jnode *, struct inode *);
-int deflate_cluster(reiser4_cluster_t *, struct inode *);
+int reiser4_deflate_cluster(reiser4_cluster_t *, struct inode *);
 void truncate_page_cluster(struct inode *inode, cloff_t start);
 void invalidate_hint_cluster(reiser4_cluster_t * clust);
 void put_hint_cluster(reiser4_cluster_t * clust, struct inode *inode,
@@ -253,7 +253,7 @@ int set_cluster_by_page(reiser4_cluster_
 			int count);
 int prepare_page_cluster(struct inode *inode, reiser4_cluster_t * clust,
 			 int capture);
-void release_cluster_pages(reiser4_cluster_t *);
+void reiser4_release_cluster_pages(reiser4_cluster_t *);
 void put_cluster_handle(reiser4_cluster_t * clust);
 int grab_tfm_stream(struct inode *inode, tfm_cluster_t * tc, tfm_stream_id id);
 int tfm_cluster_is_uptodate(tfm_cluster_t * tc);
@@ -276,7 +276,7 @@ move_cluster_forward(reiser4_cluster_t *
 	       used by find_cluster_item() even if seal/node versions
 	       will coincide */
 	    pg_to_clust(pgidx, inode) != clust->index + 1) {
-		unset_hint(clust->hint);
+		reiser4_unset_hint(clust->hint);
 		invalidate_hint_cluster(clust);
 	}
 	*progress = 1;
diff -puN fs/reiser4/plugin/dir_plugin_common.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/dir_plugin_common.c
--- a/fs/reiser4/plugin/dir_plugin_common.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/dir_plugin_common.c
@@ -7,9 +7,9 @@
 
 #include "../inode.h"
 
-int find_entry(struct inode *dir, struct dentry *name,
+int reiser4_find_entry(struct inode *dir, struct dentry *name,
 	       lock_handle *, znode_lock_mode, reiser4_dir_entry_desc *);
-int lookup_name(struct inode *parent, struct dentry *dentry, reiser4_key * key);
+int reiser4_lookup_name(struct inode *parent, struct dentry *dentry, reiser4_key * key);
 void check_light_weight(struct inode *inode, struct inode *parent);
 
 /* this is common implementation of get_parent method of dir plugin
@@ -35,7 +35,7 @@ struct dentry *get_parent_common(struct 
 	dotdot.d_name.len = 2;
 	dotdot.d_op = &get_super_private(s)->ops.dentry;
 
-	result = lookup_name(child, &dotdot, &key);
+	result = reiser4_lookup_name(child, &dotdot, &key);
 	if (result != 0)
 		return ERR_PTR(result);
 
@@ -88,7 +88,7 @@ int is_name_acceptable_common(const stru
 
 /* this is common implementation of build_readdir_key method of dir
    plugin
-   see readdir_common for more details
+   see reiser4_readdir_common for more details
 */
 int build_readdir_key_common(struct file *dir /* directory being read */ ,
 			     reiser4_key * result /* where to store key */ )
@@ -112,19 +112,19 @@ int build_readdir_key_common(struct file
 
 }
 
-void adjust_dir_file(struct inode *, const struct dentry *, int offset,
-		     int adj);
+void reiser4_adjust_dir_file(struct inode *, const struct dentry *, int offset,
+			     int adj);
 
 /* this is common implementation of add_entry method of dir plugin
 */
-int add_entry_common(struct inode *object,	/* directory to add new name
-						 * in */
-		     struct dentry *where,	/* new name */
-		     reiser4_object_create_data * data UNUSED_ARG,	/* parameters
-									 * of new
-									 * object */
-		     reiser4_dir_entry_desc * entry	/* parameters of new
-							 * directory entry */ )
+int reiser4_add_entry_common(struct inode *object, /* directory to add new name
+						    * in */
+			     struct dentry *where,	/* new name */
+			     reiser4_object_create_data * data, /* parameters of
+								*  new object */
+			     reiser4_dir_entry_desc * entry /* parameters of
+							     * new directory
+							     * entry */)
 {
 	int result;
 	coord_t *coord;
@@ -148,20 +148,22 @@ int add_entry_common(struct inode *objec
 	coord_clear_iplug(coord);
 
 	/* check for this entry in a directory. This is plugin method. */
-	result = find_entry(object, where, &lh, ZNODE_WRITE_LOCK, entry);
+	result = reiser4_find_entry(object, where, &lh, ZNODE_WRITE_LOCK,
+				    entry);
 	if (likely(result == -ENOENT)) {
 		/* add new entry. Just pass control to the directory
 		   item plugin. */
 		assert("nikita-1709", inode_dir_item_plugin(object));
 		assert("nikita-2230", coord->node == lh.node);
-		seal_done(&fsdata->dec.entry_seal);
+		reiser4_seal_done(&fsdata->dec.entry_seal);
 		result =
 		    inode_dir_item_plugin(object)->s.dir.add_entry(object,
 								   coord, &lh,
 								   where,
 								   entry);
 		if (result == 0) {
-			adjust_dir_file(object, where, fsdata->dec.pos + 1, +1);
+			reiser4_adjust_dir_file(object, where,
+						fsdata->dec.pos + 1, +1);
 			INODE_INC_FIELD(object, i_size);
 		}
 	} else if (result == 0) {
@@ -215,16 +217,16 @@ rem_entry(struct inode *dir, struct dent
 }
 
 /**
- * rem_entry_common - remove entry from a directory
+ * reiser4_rem_entry_common - remove entry from a directory
  * @dir: directory to remove entry from
  * @where: name that is being removed
  * @entry: description of entry being removed
  *
  * This is common implementation of rem_entry method of dir plugin.
  */
-int rem_entry_common(struct inode *dir,
-		     struct dentry *dentry,
-		     reiser4_dir_entry_desc *entry)
+int reiser4_rem_entry_common(struct inode *dir,
+			     struct dentry *dentry,
+			     reiser4_dir_entry_desc *entry)
 {
 	int result;
 	coord_t *coord;
@@ -243,7 +245,7 @@ int rem_entry_common(struct inode *dir,
 	init_lh(&lh);
 
 	/* check for this entry in a directory. This is plugin method. */
-	result = find_entry(dir, dentry, &lh, ZNODE_WRITE_LOCK, entry);
+	result = reiser4_find_entry(dir, dentry, &lh, ZNODE_WRITE_LOCK, entry);
 	fsdata = reiser4_get_dentry_fsdata(dentry);
 	if (IS_ERR(fsdata)) {
 		done_lh(&lh);
@@ -261,8 +263,8 @@ int rem_entry_common(struct inode *dir,
 		/* remove entry. Just pass control to the directory item
 		   plugin. */
 		assert("vs-542", inode_dir_item_plugin(dir));
-		seal_done(&fsdata->dec.entry_seal);
-		adjust_dir_file(dir, dentry, fsdata->dec.pos, -1);
+		reiser4_seal_done(&fsdata->dec.entry_seal);
+		reiser4_adjust_dir_file(dir, dentry, fsdata->dec.pos, -1);
 		result =
 		    WITH_COORD(coord,
 			       rem_entry(dir, dentry, entry, coord, &lh));
@@ -293,14 +295,14 @@ static int create_dot_dotdot(struct inod
 /* this is common implementation of init method of dir plugin
    create "." and ".." entries
 */
-int init_common(struct inode *object,	/* new directory */
-		struct inode *parent,	/* parent directory */
-		reiser4_object_create_data * data UNUSED_ARG	/* info passed
-								 * to us, this
-								 * is filled by
-								 * reiser4()
-								 * syscall in
-								 * particular */ )
+int reiser4_dir_init_common(struct inode *object,	/* new directory */
+			    struct inode *parent,	/* parent directory */
+			    reiser4_object_create_data * data /* info passed
+							       * to us, this
+							       * is filled by
+							       * reiser4()
+							       * syscall in
+							       * particular */)
 {
 	reiser4_block_nr reserve;
 
@@ -321,7 +323,7 @@ int init_common(struct inode *object,	/*
 /* this is common implementation of done method of dir plugin
    remove "." entry
 */
-int done_common(struct inode *object /* object being deleted */ )
+int reiser4_dir_done_common(struct inode *object /* object being deleted */ )
 {
 	int result;
 	reiser4_block_nr reserve;
@@ -330,14 +332,14 @@ int done_common(struct inode *object /* 
 
 	assert("nikita-1449", object != NULL);
 
-	if (inode_get_flag(object, REISER4_NO_SD))
+	if (reiser4_inode_get_flag(object, REISER4_NO_SD))
 		return 0;
 
 	/* of course, this can be rewritten to sweep everything in one
-	   cut_tree(). */
+	   reiser4_cut_tree(). */
 	memset(&entry, 0, sizeof entry);
 
-	/* FIXME: this done method is called from delete_directory_common which
+	/* FIXME: this done method is called from reiser4_delete_dir_common which
 	 * reserved space already */
 	reserve = inode_dir_plugin(object)->estimate.rem_entry(object);
 	if (reiser4_grab_space(reserve, BA_CAN_COMMIT | BA_RESERVED))
@@ -347,7 +349,7 @@ int done_common(struct inode *object /* 
 	entry.obj = goodby_dots.d_inode = object;
 	goodby_dots.d_name.name = ".";
 	goodby_dots.d_name.len = 1;
-	result = rem_entry_common(object, &goodby_dots, &entry);
+	result = reiser4_rem_entry_common(object, &goodby_dots, &entry);
 	reiser4_free_dentry_fsdata(&goodby_dots);
 	if (unlikely(result != 0 && result != -ENOMEM && result != -ENOENT))
 		/* only worth a warning
@@ -362,8 +364,8 @@ int done_common(struct inode *object /* 
 
 /* this is common implementation of attach method of dir plugin
 */
-int
-attach_common(struct inode *child UNUSED_ARG, struct inode *parent UNUSED_ARG)
+int reiser4_attach_common(struct inode *child UNUSED_ARG,
+			  struct inode *parent UNUSED_ARG)
 {
 	assert("nikita-2647", child != NULL);
 	assert("nikita-2648", parent != NULL);
@@ -374,14 +376,14 @@ attach_common(struct inode *child UNUSED
 /* this is common implementation of detach method of dir plugin
    remove "..", decrease nlink on parent
 */
-int detach_common(struct inode *object, struct inode *parent)
+int reiser4_detach_common(struct inode *object, struct inode *parent)
 {
 	int result;
 	struct dentry goodby_dots;
 	reiser4_dir_entry_desc entry;
 
 	assert("nikita-2885", object != NULL);
-	assert("nikita-2886", !inode_get_flag(object, REISER4_NO_SD));
+	assert("nikita-2886", !reiser4_inode_get_flag(object, REISER4_NO_SD));
 
 	memset(&entry, 0, sizeof entry);
 
@@ -392,7 +394,7 @@ int detach_common(struct inode *object, 
 	entry.obj = goodby_dots.d_inode = parent;
 	goodby_dots.d_name.name = "..";
 	goodby_dots.d_name.len = 2;
-	result = rem_entry_common(object, &goodby_dots, &entry);
+	result = reiser4_rem_entry_common(object, &goodby_dots, &entry);
 	reiser4_free_dentry_fsdata(&goodby_dots);
 	if (result == 0) {
 		/* the dot should be the only entry remaining at this time... */
@@ -423,7 +425,7 @@ int detach_common(struct inode *object, 
 */
 reiser4_block_nr estimate_add_entry_common(const struct inode * inode)
 {
-	return estimate_one_insert_into_item(tree_by_inode(inode));
+	return estimate_one_insert_into_item(reiser4_tree_by_inode(inode));
 }
 
 /* this is common implementation of estimate.rem_entry method of dir
@@ -431,7 +433,7 @@ reiser4_block_nr estimate_add_entry_comm
 */
 reiser4_block_nr estimate_rem_entry_common(const struct inode * inode)
 {
-	return estimate_one_item_removal(tree_by_inode(inode));
+	return estimate_one_item_removal(reiser4_tree_by_inode(inode));
 }
 
 /* this is common implementation of estimate.unlink method of dir
@@ -458,18 +460,18 @@ dir_estimate_unlink_common(const struct 
  */
 void check_light_weight(struct inode *inode, struct inode *parent)
 {
-	if (inode_get_flag(inode, REISER4_LIGHT_WEIGHT)) {
+	if (reiser4_inode_get_flag(inode, REISER4_LIGHT_WEIGHT)) {
 		inode->i_uid = parent->i_uid;
 		inode->i_gid = parent->i_gid;
 		/* clear light-weight flag. If inode would be read by any
 		   other name, [ug]id wouldn't change. */
-		inode_clr_flag(inode, REISER4_LIGHT_WEIGHT);
+		reiser4_inode_clr_flag(inode, REISER4_LIGHT_WEIGHT);
 	}
 }
 
 /* looks for name specified in @dentry in directory @parent and if name is
    found - key of object found entry points to is stored in @entry->key */
-int lookup_name(struct inode *parent,	/* inode of directory to lookup for
+int reiser4_lookup_name(struct inode *parent,	/* inode of directory to lookup for
 					 * name in */
 		struct dentry *dentry,	/* name to look for */
 		reiser4_key * key /* place to store key */ )
@@ -504,7 +506,8 @@ int lookup_name(struct inode *parent,	/*
 	init_lh(&lh);
 
 	/* find entry in a directory. This is plugin method. */
-	result = find_entry(parent, dentry, &lh, ZNODE_READ_LOCK, &entry);
+	result = reiser4_find_entry(parent, dentry, &lh, ZNODE_READ_LOCK,
+				    &entry);
 	if (result == 0) {
 		/* entry was found, extract object key from it. */
 		result =
@@ -517,7 +520,7 @@ int lookup_name(struct inode *parent,	/*
 
 }
 
-/* helper for init_common(): estimate number of blocks to reserve */
+/* helper for reiser4_dir_init_common(): estimate number of blocks to reserve */
 static reiser4_block_nr
 estimate_init(struct inode *parent, struct inode *object)
 {
@@ -538,10 +541,10 @@ estimate_init(struct inode *parent, stru
 	return 0;
 }
 
-/* helper function for init_common(). Create "." and ".." */
-static int create_dot_dotdot(struct inode *object	/* object to create dot and
-							 * dotdot for */ ,
-			     struct inode *parent /* parent of @object */ )
+/* helper function for reiser4_dir_init_common(). Create "." and ".." */
+static int create_dot_dotdot(struct inode *object /* object to create dot and
+						   * dotdot for */ ,
+			     struct inode *parent /* parent of @object */)
 {
 	int result;
 	struct dentry dots_entry;
@@ -571,7 +574,7 @@ static int create_dot_dotdot(struct inod
 	entry.obj = dots_entry.d_inode = object;
 	dots_entry.d_name.name = ".";
 	dots_entry.d_name.len = 1;
-	result = add_entry_common(object, &dots_entry, NULL, &entry);
+	result = reiser4_add_entry_common(object, &dots_entry, NULL, &entry);
 	reiser4_free_dentry_fsdata(&dots_entry);
 
 	if (result == 0) {
@@ -580,7 +583,7 @@ static int create_dot_dotdot(struct inod
 			entry.obj = dots_entry.d_inode = parent;
 			dots_entry.d_name.name = "..";
 			dots_entry.d_name.len = 2;
-			result = add_entry_common(object,
+			result = reiser4_add_entry_common(object,
 						  &dots_entry, NULL, &entry);
 			reiser4_free_dentry_fsdata(&dots_entry);
 			/* if creation of ".." failed, iput() will delete
@@ -592,7 +595,7 @@ static int create_dot_dotdot(struct inod
 					 * if we failed to bump i_nlink, try
 					 * to remove ".."
 					 */
-					detach_common(object, parent);
+					reiser4_detach_common(object, parent);
 			}
 		}
 	}
@@ -677,7 +680,8 @@ typedef struct entry_actor_args {
 	const struct inode *inode;
 } entry_actor_args;
 
-/* Function called by find_entry() to look for given name in the directory. */
+/* Function called by reiser4_find_entry() to look for given name
+   in the directory. */
 static int entry_actor(reiser4_tree * tree UNUSED_ARG /* tree being scanned */ ,
 		       coord_t * coord /* current coord */ ,
 		       lock_handle * lh /* current lock handle */ ,
@@ -735,18 +739,18 @@ static int entry_actor(reiser4_tree * tr
 /* Look for given @name within directory @dir.
 
    This is called during lookup, creation and removal of directory
-   entries and on rename_common
+   entries and on reiser4_rename_common
 
    First calculate key that directory entry for @name would have. Search
    for this key in the tree. If such key is found, scan all items with
    the same key, checking name in each directory entry along the way.
 */
-int find_entry(struct inode *dir,	/* directory to scan */
-	       struct dentry *de,	/* name to search for */
-	       lock_handle * lh,	/* resulting lock handle */
-	       znode_lock_mode mode,	/* required lock mode */
-	       reiser4_dir_entry_desc * entry	/* parameters of found directory
-						 * entry */ )
+int reiser4_find_entry(struct inode *dir,	/* directory to scan */
+		       struct dentry *de,	/* name to search for */
+		       lock_handle * lh,	/* resulting lock handle */
+		       znode_lock_mode mode,	/* required lock mode */
+		       reiser4_dir_entry_desc * entry	/* parameters of found
+							   directory entry */)
 {
 	const struct qstr *name;
 	seal_t *seal;
@@ -779,10 +783,10 @@ int find_entry(struct inode *dir,	/* dir
 	/* compose key of directory entry for @name */
 	inode_dir_plugin(dir)->build_entry_key(dir, name, &entry->key);
 
-	if (seal_is_set(seal)) {
+	if (reiser4_seal_is_set(seal)) {
 		/* check seal */
-		result = seal_validate(seal, coord, &entry->key,
-				       lh, mode, ZNODE_LOCK_LOPRI);
+		result = reiser4_seal_validate(seal, coord, &entry->key,
+					       lh, mode, ZNODE_LOCK_LOPRI);
 		if (result == 0) {
 			/* key was found. Check that it is really item we are
 			   looking for. */
@@ -795,16 +799,16 @@ int find_entry(struct inode *dir,	/* dir
 	/*
 	 * find place in the tree where directory item should be located.
 	 */
-	result = object_lookup(dir, &entry->key, coord, lh, mode,
-			       FIND_EXACT, LEAF_LEVEL, LEAF_LEVEL, flags,
-			       NULL /*ra_info */ );
+	result = reiser4_object_lookup(dir, &entry->key, coord, lh, mode,
+				       FIND_EXACT, LEAF_LEVEL, LEAF_LEVEL,
+				       flags, NULL /*ra_info */ );
 	if (result == CBK_COORD_FOUND) {
 		entry_actor_args arg;
 
 		/* fast path: no hash collisions */
 		result = check_entry(dir, coord, name);
 		if (result == 0) {
-			seal_init(seal, coord, &entry->key);
+			reiser4_seal_init(seal, coord, &entry->key);
 			dec->pos = 0;
 		} else if (result > 0) {
 			/* Iterate through all units with the same keys. */
@@ -821,8 +825,10 @@ int find_entry(struct inode *dir,	/* dir
 			coord_init_zero(&arg.last_coord);
 			init_lh(&arg.last_lh);
 
-			result = iterate_tree(tree_by_inode(dir), coord, lh,
-					      entry_actor, &arg, mode, 1);
+			result = reiser4_iterate_tree
+				(reiser4_tree_by_inode(dir),
+				 coord, lh,
+				 entry_actor, &arg, mode, 1);
 			/* if end of the tree or extent was reached during
 			   scanning. */
 			if (arg.not_found || (result == -E_NO_NEIGHBOR)) {
@@ -842,7 +848,7 @@ int find_entry(struct inode *dir,	/* dir
 
 			done_lh(&arg.last_lh);
 			if (result == 0)
-				seal_init(seal, coord, &entry->key);
+				reiser4_seal_init(seal, coord, &entry->key);
 
 			if (result == 0 || result == -ENOENT) {
 				assert("nikita-2580", arg.non_uniq > 0);
@@ -854,11 +860,13 @@ int find_entry(struct inode *dir,	/* dir
 	return result;
 }
 
-/* Local variables:
+/*
+   Local variables:
    c-indentation-style: "K&R"
    mode-name: "LC"
    c-basic-offset: 8
    tab-width: 8
    fill-column: 120
+   scroll-step: 1
    End:
 */
diff -puN fs/reiser4/plugin/disk_format/disk_format40.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/disk_format/disk_format40.c
--- a/fs/reiser4/plugin/disk_format/disk_format40.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/disk_format/disk_format40.c
@@ -144,12 +144,12 @@ static int get_super_jnode(struct super_
 	jnode *sb_jnode;
 	int ret;
 
-	sb_jnode = alloc_io_head(&get_sb_info(s)->loc.super);
+	sb_jnode = reiser4_alloc_io_head(&get_sb_info(s)->loc.super);
 
 	ret = jload(sb_jnode);
 
 	if (ret) {
-		drop_io_head(sb_jnode);
+		reiser4_drop_io_head(sb_jnode);
 		return ret;
 	}
 
@@ -167,7 +167,7 @@ static void done_super_jnode(struct supe
 
 	if (sb_jnode) {
 		unpin_jnode_data(sb_jnode);
-		drop_io_head(sb_jnode);
+		reiser4_drop_io_head(sb_jnode);
 	}
 }
 
@@ -192,7 +192,8 @@ static format40_disk_super_block *copy_s
 {
 	format40_disk_super_block *sb_copy;
 
-	sb_copy = kmalloc(sizeof(format40_disk_super_block), get_gfp_mask());
+	sb_copy = kmalloc(sizeof(format40_disk_super_block),
+			  reiser4_ctx_gfp_mask_get());
 	if (sb_copy == NULL)
 		return ERR_PTR(RETERR(-ENOMEM));
 	memcpy(sb_copy, ((format40_disk_super_block *) super_bh->b_data),
@@ -246,7 +247,7 @@ static int try_init_format40(struct supe
 	*stage = FIND_A_SUPER;
 
 	/* map jnodes for journal control blocks (header, footer) to disk  */
-	result = init_journal_info(super);
+	result = reiser4_init_journal_info(super);
 	if (result)
 		return result;
 	*stage = INIT_JOURNAL_INFO;
@@ -312,7 +313,7 @@ static int try_init_format40(struct supe
 	sbinfo = get_super_private(super);
 	assert("", sbinfo->tree.super == super);
 	/* init reiser4_tree for the filesystem */
-	result = init_tree(&sbinfo->tree, &root_block, height, nplug);
+	result = reiser4_init_tree(&sbinfo->tree, &root_block, height, nplug);
 	if (result) {
 		kfree(sb_copy);
 		return result;
@@ -368,7 +369,8 @@ static int try_init_format40(struct supe
 #endif
 
 	/* init disk space allocator */
-	result = sa_init_allocator(get_space_allocator(super), super, NULL);
+	result = sa_init_allocator(reiser4_get_space_allocator(super),
+				   super, NULL);
 	if (result)
 		return result;
 	*stage = INIT_SA;
@@ -393,10 +395,10 @@ int init_format_format40(struct super_bl
 	case INIT_JNODE:
 		done_super_jnode(s);
 	case INIT_SA:
-		sa_destroy_allocator(get_space_allocator(s), s);
+		sa_destroy_allocator(reiser4_get_space_allocator(s), s);
 	case JOURNAL_RECOVER:
 	case INIT_TREE:
-		done_tree(&get_super_private(s)->tree);
+		reiser4_done_tree(&get_super_private(s)->tree);
 	case INIT_OID:
 	case KEY_CHECK:
 	case READ_SUPER:
@@ -404,7 +406,7 @@ int init_format_format40(struct super_bl
 	case INIT_STATUS:
 		reiser4_status_finish();
 	case INIT_JOURNAL_INFO:
-		done_journal_info(s);
+		reiser4_done_journal_info(s);
 	case FIND_A_SUPER:
 	case CONSULT_DISKMAP:
 	case NONE_DONE:
@@ -465,9 +467,10 @@ int release_format40(struct super_block 
 	assert("zam-579", sbinfo != NULL);
 
 	if (!rofs_super(s)) {
-		ret = capture_super_block(s);
+		ret = reiser4_capture_super_block(s);
 		if (ret != 0)
-			warning("vs-898", "capture_super_block failed: %d",
+			warning("vs-898",
+				"reiser4_capture_super_block failed: %d",
 				ret);
 
 		ret = txnmgr_force_commit_all(s, 1);
@@ -478,13 +481,13 @@ int release_format40(struct super_block 
 	}
 
 	sa_destroy_allocator(&sbinfo->space_allocator, s);
-	done_journal_info(s);
+	reiser4_done_journal_info(s);
 	done_super_jnode(s);
 
 	rcu_barrier();
-	done_tree(&sbinfo->tree);
+	reiser4_done_tree(&sbinfo->tree);
 	/* call finish_rcu(), because some znode were "released" in
-	 * done_tree(). */
+	 * reiser4_done_tree(). */
 	rcu_barrier();
 
 	return 0;
diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -45,7 +45,7 @@ init_inode_data_cryptcompress(struct ino
 }
 
 #if REISER4_DEBUG
-int crc_inode_ok(struct inode *inode)
+int cryptcompress_inode_ok(struct inode *inode)
 {
 	if (cluster_shift_ok(inode_cluster_shift(inode)))
 		return 1;
@@ -89,7 +89,7 @@ static void set_inode_crypto_stat (struc
 }
 
 /* allocate a cipher key info */
-crypto_stat_t * alloc_crypto_stat (struct inode * inode)
+crypto_stat_t * reiser4_alloc_crypto_stat (struct inode * inode)
 {
 	crypto_stat_t * info;
 	int fipsize;
@@ -299,7 +299,7 @@ create_crypto_stat(struct inode * object
 	    file_plugin_by_id(DIRECTORY_FILE_PLUGIN_ID))
 		return ERR_PTR(-EINVAL);
 
-	info = alloc_crypto_stat(object);
+	info = reiser4_alloc_crypto_stat(object);
 	if (IS_ERR(info))
 		return info;
 	ret = alloc_crypto_tfms(reiser4_inode_data(object)->pset, info);
@@ -352,7 +352,7 @@ static void unload_crypto_stat(struct in
 }
 
 /* attach/detach an existing crypto-stat */
-void attach_crypto_stat(struct inode * inode, crypto_stat_t * info)
+void reiser4_attach_crypto_stat(struct inode * inode, crypto_stat_t * info)
 {
 	assert("edward-1382", inode != NULL);
 	assert("edward-1383", info != NULL);
@@ -380,7 +380,7 @@ static int host_allows_crypto_stat(struc
 }
 #endif  /*  REISER4_DEBUG  */
 
-static void detach_crypto_stat(struct inode * inode)
+static void reiser4_detach_crypto_stat(struct inode * inode)
 {
 	assert("edward-1385", inode != NULL);
 	assert("edward-1386", host_allows_crypto_stat(inode));
@@ -399,7 +399,7 @@ static int keyid_eq(crypto_stat_t * chil
 }
 
 /* check if a crypto-stat (which is bound to @parent) can be inherited */
-int can_inherit_crypto_crc(struct inode *child, struct inode *parent)
+int can_inherit_crypto_cryptcompress(struct inode *child, struct inode *parent)
 {
 	if (!need_cipher(child))
 		return 0;
@@ -484,7 +484,7 @@ static int inode_set_cluster(struct inod
 void destroy_inode_cryptcompress(struct inode * inode)
 {
 	assert("edward-23", cryptcompress_inode_data(inode)->pgcount == 0);
-	detach_crypto_stat(inode);
+	reiser4_detach_crypto_stat(inode);
 	return;
 }
 
@@ -505,7 +505,7 @@ create_cryptcompress(struct inode *objec
 	assert("edward-23", object != NULL);
 	assert("edward-24", parent != NULL);
 	assert("edward-30", data != NULL);
-	assert("edward-26", inode_get_flag(object, REISER4_NO_SD));
+	assert("edward-26", reiser4_inode_get_flag(object, REISER4_NO_SD));
 	assert("edward-27", data->id == CRC_FILE_PLUGIN_ID);
 
 	info = reiser4_inode_data(object);
@@ -537,7 +537,7 @@ create_cryptcompress(struct inode *objec
 	if (!result)
 		return 0;
  error:
-	detach_crypto_stat(object);
+	reiser4_detach_crypto_stat(object);
 	return result;
 }
 
@@ -582,8 +582,8 @@ static loff_t inode_scaled_offset (struc
 	assert("edward-97", inode != NULL);
 
 	if (!need_cipher(inode) ||
-	    src_off == get_key_offset(min_key()) ||
-	    src_off == get_key_offset(max_key()))
+	    src_off == get_key_offset(reiser4_min_key()) ||
+	    src_off == get_key_offset(reiser4_max_key()))
 		return src_off;
 
 	return inode_cipher_plugin(inode)->scale(inode,
@@ -642,12 +642,12 @@ key_by_inode_cryptcompress(struct inode 
 	loff_t clust_off;
 
 	assert("edward-64", inode != 0);
-	//      assert("edward-112", ergo(off != get_key_offset(max_key()), !off_to_cloff(off, inode)));
+	//      assert("edward-112", ergo(off != get_key_offset(reiser4_max_key()), !off_to_cloff(off, inode)));
 	/* don't come here with other offsets */
 
 	clust_off =
 	    (off ==
-	     get_key_offset(max_key())? get_key_offset(max_key()) :
+	     get_key_offset(reiser4_max_key())? get_key_offset(reiser4_max_key()) :
 	     off_to_clust_to_off(off, inode));
 
 	key_by_inode_and_offset_common(inode, 0, key);
@@ -686,8 +686,8 @@ flow_by_inode_cryptcompress(struct inode
 }
 
 static int
-crc_hint_validate(hint_t * hint, const reiser4_key * key,
-		  znode_lock_mode lock_mode)
+cryptcompress_hint_validate(hint_t * hint, const reiser4_key * key,
+			    znode_lock_mode lock_mode)
 {
 	coord_t *coord;
 
@@ -705,10 +705,11 @@ crc_hint_validate(hint_t * hint, const r
 		/* hint is set for different key */
 		return RETERR(-E_REPEAT);
 
-	assert("edward-707", schedulable());
+	assert("edward-707", reiser4_schedulable());
 
-	return seal_validate(&hint->seal, &hint->ext_coord.coord,
-			     key, &hint->lh, lock_mode, ZNODE_LOCK_LOPRI);
+	return reiser4_seal_validate(&hint->seal, &hint->ext_coord.coord,
+				     key, &hint->lh, lock_mode,
+				     ZNODE_LOCK_LOPRI);
 }
 
 /* reserve disk space when writing a logical cluster */
@@ -716,7 +717,7 @@ static int reserve4cluster(struct inode 
 {
 	int result = 0;
 
-	assert("edward-965", schedulable());
+	assert("edward-965", reiser4_schedulable());
 	assert("edward-439", inode != NULL);
 	assert("edward-440", clust != NULL);
 	assert("edward-441", clust->pages != NULL);
@@ -773,7 +774,7 @@ static int find_cluster_item(hint_t * hi
 	assert("edward-152", hint != NULL);
 
 	if (hint->ext_coord.valid == 0) {
-		result = crc_hint_validate(hint, key, lock_mode);
+		result = cryptcompress_hint_validate(hint, key, lock_mode);
 		if (result == -E_REPEAT)
 			goto traverse_tree;
 		else if (result) {
@@ -826,9 +827,9 @@ static int find_cluster_item(hint_t * hi
 
       traverse_tree:
 	assert("edward-713", hint->lh.owner == NULL);
-	assert("edward-714", schedulable());
+	assert("edward-714", reiser4_schedulable());
 
-	unset_hint(hint);
+	reiser4_unset_hint(hint);
 	coord_init_zero(coord);
 	result = coord_by_key(current_tree, key, coord, &hint->lh,
 			      lock_mode, bias, LEAF_LEVEL, LEAF_LEVEL,
@@ -1050,7 +1051,7 @@ int grab_tfm_stream(struct inode * inode
 }
 
 /* Common deflate manager */
-int deflate_cluster(reiser4_cluster_t * clust, struct inode * inode)
+int reiser4_deflate_cluster(reiser4_cluster_t * clust, struct inode * inode)
 {
 	int result = 0;
 	int compressed = 0;
@@ -1167,7 +1168,7 @@ int deflate_cluster(reiser4_cluster_t * 
 }
 
 /* Common inflate manager. */
-int inflate_cluster(reiser4_cluster_t * clust, struct inode * inode)
+int reiser4_inflate_cluster(reiser4_cluster_t * clust, struct inode * inode)
 {
 	int result = 0;
 	int transformed = 0;
@@ -1252,7 +1253,7 @@ int readpage_cryptcompress(struct file *
 	assert("vs-976", !PageUptodate(page));
 	assert("edward-89", page->mapping && page->mapping->host);
 
-	ctx = init_context(page->mapping->host->i_sb);
+	ctx = reiser4_init_context(page->mapping->host->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 	result = check_cryptcompress(page->mapping->host);
@@ -1316,7 +1317,7 @@ static void set_cluster_pages_dirty(reis
 		assert("edward-968", pg != NULL);
 		lock_page(pg);
 		assert("edward-1065", PageUptodate(pg));
-		set_page_dirty_internal(pg);
+		reiser4_set_page_dirty_internal(pg);
 		unlock_page(pg);
 		mark_page_accessed(pg);
 	}
@@ -1471,7 +1472,7 @@ static int try_capture_cluster(reiser4_c
 	if (clust->win)
 		inode_set_new_size(clust, inode);
 
-	result = try_capture(node, ZNODE_WRITE_LOCK, 0);
+	result = reiser4_try_capture(node, ZNODE_WRITE_LOCK, 0);
 	if (result)
 		goto exit;
 	make_cluster_jnode_dirty_locked(clust, node, &old_size, inode);
@@ -1601,7 +1602,7 @@ int jnode_of_cluster(const jnode * node,
 #endif  /*  0  */
 
 /* put cluster pages */
-void release_cluster_pages(reiser4_cluster_t * clust)
+void reiser4_release_cluster_pages(reiser4_cluster_t * clust)
 {
 	int i;
 
@@ -1615,7 +1616,7 @@ void release_cluster_pages(reiser4_clust
 }
 
 /* this is called when something is failed */
-static void release_cluster_pages_and_jnode(reiser4_cluster_t * clust)
+static void reiser4_release_cluster_pages_and_jnode(reiser4_cluster_t * clust)
 {
 	jnode *node;
 
@@ -1627,7 +1628,7 @@ static void release_cluster_pages_and_jn
 
 	assert("edward-447", node != NULL);
 
-	release_cluster_pages(clust);
+	reiser4_release_cluster_pages(clust);
 	jput(node);
 }
 
@@ -1716,7 +1717,7 @@ static int update_sd_cryptcompress(struc
 {
 	int result = 0;
 
-	assert("edward-978", schedulable());
+	assert("edward-978", reiser4_schedulable());
 	assert("edward-1265", get_current_context()->grabbed_blocks == 0);
 
 	result = reiser4_grab_space_force(	/* one for stat data update */
@@ -1748,7 +1749,7 @@ static void uncapture_cluster_jnode(jnod
 		return;
 	}
 
-	uncapture_block(node);
+	reiser4_uncapture_block(node);
 	spin_unlock_atom(atom);
 	jput(node);
 }
@@ -1779,8 +1780,8 @@ flush_cluster_pages(reiser4_cluster_t * 
 	assert("edward-236", inode != NULL);
 	assert("edward-237", clust != NULL);
 	assert("edward-240", !clust->win);
-	assert("edward-241", schedulable());
-	assert("edward-718", crc_inode_ok(inode));
+	assert("edward-241", reiser4_schedulable());
+	assert("edward-718", cryptcompress_inode_ok(inode));
 
 	result = grab_tfm_stream(inode, tc, INPUT_STREAM);
 	if (result) {
@@ -1803,7 +1804,7 @@ flush_cluster_pages(reiser4_cluster_t * 
 	cluster_reserved2grabbed(estimate_update_cluster(inode));
 	uncapture_cluster_jnode(node);
 
-	assert("edward-1224", schedulable());
+	assert("edward-1224", reiser4_schedulable());
 	/* Check out cluster pages to commit */
 	nr_pages =
 	      find_get_pages(inode->i_mapping, clust_to_pg(clust->index, inode),
@@ -1830,12 +1831,12 @@ flush_cluster_pages(reiser4_cluster_t * 
 		unlock_page(clust->pages[i]);
 	}
 	clear_cluster_pages_dirty(clust);
-      	release_cluster_pages(clust);
+      	reiser4_release_cluster_pages(clust);
 #if REISER4_DEBUG
 	cryptcompress_inode_data(inode)->pgcount -= clust->nr_pages;
 #endif
 	/* put pages that were found here */
-	release_cluster_pages(clust);
+	reiser4_release_cluster_pages(clust);
 	return result;
 }
 
@@ -1844,7 +1845,7 @@ static void set_hint_cluster(struct inod
 			     cloff_t index, znode_lock_mode mode)
 {
 	reiser4_key key;
-	assert("edward-722", crc_inode_ok(inode));
+	assert("edward-722", cryptcompress_inode_ok(inode));
 	assert("edward-723",
 	       inode_file_plugin(inode) ==
 	       file_plugin_by_id(CRC_FILE_PLUGIN_ID));
@@ -1853,7 +1854,7 @@ static void set_hint_cluster(struct inod
 					       clust_to_off(index, inode),
 					       &key);
 
-	seal_init(&hint->seal, &hint->ext_coord.coord, &key);
+	reiser4_seal_init(&hint->seal, &hint->ext_coord.coord, &key);
 	hint->offset = get_key_offset(&key);
 	hint->mode = mode;
 }
@@ -1884,7 +1885,7 @@ balance_dirty_page_cluster(reiser4_clust
 	int result;
 
 	assert("edward-724", inode != NULL);
-	assert("edward-725", crc_inode_ok(inode));
+	assert("edward-725", cryptcompress_inode_ok(inode));
 	assert("edward-1272", get_current_context()->grabbed_blocks == 0);
 
 	/* set next window params */
@@ -1915,7 +1916,7 @@ write_hole(struct inode *inode, reiser4_
 	assert("edward-190", clust != NULL);
 	assert("edward-1069", clust->win != NULL);
 	assert("edward-191", inode != NULL);
-	assert("edward-727", crc_inode_ok(inode));
+	assert("edward-727", cryptcompress_inode_ok(inode));
 	assert("edward-1171", clust->dstat != INVAL_DISK_CLUSTER);
 	assert("edward-1154",
 	       ergo(clust->dstat != FAKE_DISK_CLUSTER, clust->reserved == 1));
@@ -1978,9 +1979,8 @@ write_hole(struct inode *inode, reiser4_
   NOTE-EDWARD: Callers should handle the case when disk cluster
   is incomplete (-EIO)
 */
-int
-find_cluster(reiser4_cluster_t * clust,
-	     struct inode *inode, int read, int write)
+int find_disk_cluster(reiser4_cluster_t * clust,
+		      struct inode *inode, int read, int write)
 {
 	flow_t f;
 	hint_t *hint;
@@ -1995,9 +1995,9 @@ find_cluster(reiser4_cluster_t * clust,
 	assert("edward-138", clust != NULL);
 	assert("edward-728", clust->hint != NULL);
 	assert("edward-225", read || write);
-	assert("edward-226", schedulable());
+	assert("edward-226", reiser4_schedulable());
 	assert("edward-137", inode != NULL);
-	assert("edward-729", crc_inode_ok(inode));
+	assert("edward-729", cryptcompress_inode_ok(inode));
 
 	hint = clust->hint;
 	cl_idx = clust->index;
@@ -2026,7 +2026,7 @@ find_cluster(reiser4_cluster_t * clust,
 	}
 
 	ra_info.key_to_stop = f.key;
-	set_key_offset(&ra_info.key_to_stop, get_key_offset(max_key()));
+	set_key_offset(&ra_info.key_to_stop, get_key_offset(reiser4_max_key()));
 
 	while (f.length) {
 		result = find_cluster_item(hint,
@@ -2110,7 +2110,7 @@ get_disk_cluster_locked(reiser4_cluster_
 	reiser4_key key;
 	ra_info_t ra_info;
 
-	assert("edward-730", schedulable());
+	assert("edward-730", reiser4_schedulable());
 	assert("edward-731", clust != NULL);
 	assert("edward-732", inode != NULL);
 
@@ -2126,7 +2126,7 @@ get_disk_cluster_locked(reiser4_cluster_
 	key_by_inode_cryptcompress(inode, clust_to_off(clust->index, inode),
 				   &key);
 	ra_info.key_to_stop = key;
-	set_key_offset(&ra_info.key_to_stop, get_key_offset(max_key()));
+	set_key_offset(&ra_info.key_to_stop, get_key_offset(reiser4_max_key()));
 
 	return find_cluster_item(clust->hint, &key, lock_mode, NULL, FIND_EXACT,
 				 CBK_FOR_INSERT);
@@ -2163,7 +2163,7 @@ read_some_cluster_pages(struct inode *in
 		/*
 		   new page cluster is about to be written, nothing to read,
 		 */
-		assert("edward-734", schedulable());
+		assert("edward-734", reiser4_schedulable());
 		assert("edward-735", clust->hint->lh.owner == NULL);
 
 		if (clust->nr_pages) {
@@ -2258,8 +2258,8 @@ read_some_cluster_pages(struct inode *in
 		/* disk cluster unclaimed, but we need to make its znodes dirty
 		   to make flush update convert its content */
 		result =
-		    find_cluster(clust, inode, 0 /* do not read */ ,
-				 1 /* write */ );
+			find_disk_cluster(clust, inode, 0 /* do not read */ ,
+					  1 /* write */ );
 		assert("edward-994", !result);
 	}
  out:
@@ -2290,14 +2290,15 @@ should_create_unprepped_cluster(reiser4_
 }
 
 static int
-crc_make_unprepped_cluster(reiser4_cluster_t * clust, struct inode *inode)
+cryptcompress_make_unprepped_cluster(reiser4_cluster_t * clust,
+				     struct inode *inode)
 {
 	int result;
 
-	assert("edward-1123", schedulable());
+	assert("edward-1123", reiser4_schedulable());
 	assert("edward-737", clust != NULL);
 	assert("edward-738", inode != NULL);
-	assert("edward-739", crc_inode_ok(inode));
+	assert("edward-739", cryptcompress_inode_ok(inode));
 	assert("edward-1053", clust->hint != NULL);
 	assert("edward-1266", get_current_context()->grabbed_blocks == 0);
 
@@ -2321,7 +2322,7 @@ crc_make_unprepped_cluster(reiser4_clust
 	if (result)
 		return result;
 
-	assert("edward-743", crc_inode_ok(inode));
+	assert("edward-743", cryptcompress_inode_ok(inode));
 	assert("edward-1269", get_current_context()->grabbed_blocks == 0);
 	assert("edward-744", znode_is_write_locked(clust->hint->lh.node));
 
@@ -2352,7 +2353,7 @@ prepare_page_cluster(struct inode *inode
 		     int capture)
 {
 	assert("edward-177", inode != NULL);
-	assert("edward-741", crc_inode_ok(inode));
+	assert("edward-741", cryptcompress_inode_ok(inode));
 	assert("edward-740", clust->pages != NULL);
 
 	set_cluster_nrpages(clust, inode);
@@ -2478,7 +2479,7 @@ prepare_cluster(struct inode *inode,
 	}
 	assert("edward-1124", clust->dstat != INVAL_DISK_CLUSTER);
 
-	result = crc_make_unprepped_cluster(clust, inode);
+	result = cryptcompress_make_unprepped_cluster(clust, inode);
 	if (result)
 		goto err2;
 	if (win && win->stat == HOLE_WINDOW) {
@@ -2491,7 +2492,7 @@ prepare_cluster(struct inode *inode,
 	free_reserved4cluster(inode, clust,
 			      estimate_update_cluster(inode));
       err1:
-	release_cluster_pages_and_jnode(clust);
+	reiser4_release_cluster_pages_and_jnode(clust);
 	assert("edward-1125", result == -ENOSPC);
 	return result;
 }
@@ -2594,8 +2595,8 @@ write_cryptcompress_flow(struct file *fi
 	reiser4_slide_t win;
 	reiser4_cluster_t clust;
 
-	assert("edward-161", schedulable());
-	assert("edward-748", crc_inode_ok(inode));
+	assert("edward-161", reiser4_schedulable());
+	assert("edward-748", cryptcompress_inode_ok(inode));
 	assert("edward-159", current_blocksize == PAGE_CACHE_SIZE);
 	assert("edward-1274", get_current_context()->grabbed_blocks == 0);
 
@@ -2640,7 +2641,7 @@ write_cryptcompress_flow(struct file *fi
 		char *src;
 		unsigned page_off, page_count;
 
-		assert("edward-750", schedulable());
+		assert("edward-750", reiser4_schedulable());
 
 		result =
 		    prepare_cluster(inode, file_off, f.length, &clust,
@@ -2648,7 +2649,7 @@ write_cryptcompress_flow(struct file *fi
 		if (result)
 			goto out;
 
-		assert("edward-751", crc_inode_ok(inode));
+		assert("edward-751", cryptcompress_inode_ok(inode));
 		assert("edward-204", win.stat == DATA_WINDOW);
 		assert("edward-1288", clust.hint->ext_coord.valid);
 		assert("edward-752",
@@ -2684,7 +2685,7 @@ write_cryptcompress_flow(struct file *fi
 			unlock_page(clust.pages[i]);
 			page_off = 0;
 		}
-		assert("edward-753", crc_inode_ok(inode));
+		assert("edward-753", cryptcompress_inode_ok(inode));
 
 		set_cluster_pages_dirty(&clust);
 
@@ -2711,7 +2712,7 @@ write_cryptcompress_flow(struct file *fi
 		reset_cluster_params(&clust);
 		continue;
 	      err2:
-		release_cluster_pages_and_jnode(&clust);
+		reiser4_release_cluster_pages_and_jnode(&clust);
 	      err1:
 		if (clust.reserved)
 			free_reserved4cluster(inode,
@@ -2735,11 +2736,9 @@ write_cryptcompress_flow(struct file *fi
 	return result;
 }
 
-static ssize_t write_crc_file(struct file *file,	/* file to write to */
-			      struct inode *inode,	/* inode */
-			      const char __user *buf,	/* address of user-space buffer */
-			      size_t count,	/* number of bytes to write */
-			      loff_t * off /* position to write which */ )
+static ssize_t write_cryptcompress_file(struct file *file, struct inode *inode,
+					const char __user * buf, size_t count,
+					loff_t * off)
 {
 
 	int result;
@@ -2747,7 +2746,7 @@ static ssize_t write_crc_file(struct fil
 	ssize_t written;
 	cryptcompress_info_t *info = cryptcompress_inode_data(inode);
 
-	assert("edward-196", crc_inode_ok(inode));
+	assert("edward-196", cryptcompress_inode_ok(inode));
 
 	result = generic_write_checks(file, off, &count, 0);
 	if (unlikely(result != 0))
@@ -2768,7 +2767,7 @@ static ssize_t write_crc_file(struct fil
 
 	if (written < 0) {
 		if (written == -EEXIST)
-			printk("write_crc_file returns EEXIST!\n");
+			printk("write_cryptcompress_file returns EEXIST!\n");
 		return written;
 	}
 	/* update position in a file */
@@ -2796,13 +2795,13 @@ ssize_t write_cryptcompress(struct file 
 
 	inode = file->f_dentry->d_inode;
 
-	ctx = init_context(inode->i_sb);
+	ctx = reiser4_init_context(inode->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
 	mutex_lock(&inode->i_mutex);
 
-	result = write_crc_file(file, inode, buf, count, off);
+	result = write_cryptcompress_file(file, inode, buf, count, off);
 
 	mutex_unlock(&inode->i_mutex);
 
@@ -2811,9 +2810,9 @@ ssize_t write_cryptcompress(struct file 
 	return result;
 }
 
-static void
-readpages_crc(struct address_space *mapping, struct list_head *pages,
-	      void *data)
+static void readpages_cryptcompress(struct address_space *mapping,
+				    struct list_head *pages,
+				    void *data)
 {
 	file_plugin *fplug;
 	item_plugin *iplug;
@@ -2860,9 +2859,9 @@ ssize_t read_cryptcompress(struct file *
 	reiser4_block_nr needed;
 
 	inode = file->f_dentry->d_inode;
-	assert("edward-1194", !inode_get_flag(inode, REISER4_NO_SD));
+	assert("edward-1194", !reiser4_inode_get_flag(inode, REISER4_NO_SD));
 
-	ctx = init_context(inode->i_sb);
+	ctx = reiser4_init_context(inode->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
@@ -2870,7 +2869,7 @@ ssize_t read_cryptcompress(struct file *
 	needed = cryptcompress_estimate_read(inode);
 
 	/* FIXME-EDWARD:
-	   Grab space for sd_update so find_cluster will be happy */
+	   Grab space for sd_update so find_disk_cluster will be happy */
 	result = reiser4_grab_space(needed, BA_CAN_COMMIT);
 	if (result != 0) {
 		reiser4_exit_context(ctx);
@@ -2878,7 +2877,7 @@ ssize_t read_cryptcompress(struct file *
 	}
 	fsdata = reiser4_get_file_fsdata(file);
 	fsdata->ra2.data = file;
-	fsdata->ra2.readpages = readpages_crc;
+	fsdata->ra2.readpages = readpages_cryptcompress;
 
 	down_read(&info->lock);
 	LOCK_CNT_INC(inode_sem_r);
@@ -2916,7 +2915,7 @@ find_real_disk_cluster(struct inode *ino
 	item_plugin *iplug;
 
 	assert("edward-1131", inode != NULL);
-	assert("edward-95", crc_inode_ok(inode));
+	assert("edward-95", cryptcompress_inode_ok(inode));
 
 	hint = kmalloc(sizeof(*hint), GFP_KERNEL);
 	if (hint == NULL)
@@ -2927,7 +2926,7 @@ find_real_disk_cluster(struct inode *ino
 	bias = (index ? FIND_EXACT : FIND_MAX_NOT_MORE_THAN);
 	offset =
 	    (index ? clust_to_off(index, inode) -
-	     1 : get_key_offset(max_key()));
+	     1 : get_key_offset(reiser4_max_key()));
 
 	key_by_inode_cryptcompress(inode, offset, &key);
 
@@ -3027,7 +3026,7 @@ cut_tree_worker_cryptcompress(tap_t * ta
 		if (result != 0 && result != -E_NO_NEIGHBOR)
 			break;
 		/* FIXME-EDWARD: Check can we delete the node as a whole. */
-		result = tap_load(tap);
+		result = reiser4_tap_load(tap);
 		if (result)
 			return result;
 
@@ -3068,7 +3067,7 @@ cut_tree_worker_cryptcompress(tap_t * ta
 		}
 
 		/* cut data from one node */
-		*smallest_removed = *min_key();
+		*smallest_removed = *reiser4_min_key();
 		result = kill_node_content(&left_coord,
 					   tap->coord,
 					   from_key,
@@ -3079,7 +3078,7 @@ cut_tree_worker_cryptcompress(tap_t * ta
 #if REISER4_DEBUG
 		/*node_check(node, ~0U); */
 #endif
-		tap_relse(tap);
+		reiser4_tap_relse(tap);
 
 		if (result)
 			break;
@@ -3095,7 +3094,7 @@ cut_tree_worker_cryptcompress(tap_t * ta
 		if (next_node_lock.node == NULL)
 			break;
 
-		result = tap_move(tap, &next_node_lock);
+		result = reiser4_tap_move(tap, &next_node_lock);
 		done_lh(&next_node_lock);
 		if (result)
 			break;
@@ -3128,8 +3127,8 @@ cryptcompress_append_hole(struct inode *
 	reiser4_cluster_t clust;
 
 	assert("edward-1133", inode->i_size < new_size);
-	assert("edward-1134", schedulable());
-	assert("edward-1135", crc_inode_ok(inode));
+	assert("edward-1134", reiser4_schedulable());
+	assert("edward-1135", cryptcompress_inode_ok(inode));
 	assert("edward-1136", current_blocksize == PAGE_CACHE_SIZE);
 	assert("edward-1333", off_to_cloff(inode->i_size, inode) != 0);
 
@@ -3229,7 +3228,7 @@ static int
 update_cryptcompress_size(struct inode *inode, reiser4_key * key, int update_sd)
 {
 	return (get_key_offset(key) & ((loff_t) (inode_cluster_size(inode)) - 1)
-		? 0 : update_file_size(inode, key, update_sd));
+		? 0 : reiser4_update_file_size(inode, key, update_sd));
 }
 
 /* prune cryptcompress file in two steps (exclusive access should be acquired!)
@@ -3253,8 +3252,8 @@ prune_cryptcompress(struct inode *inode,
 	reiser4_cluster_t clust;
 
 	assert("edward-1140", inode->i_size >= new_size);
-	assert("edward-1141", schedulable());
-	assert("edward-1142", crc_inode_ok(inode));
+	assert("edward-1141", reiser4_schedulable());
+	assert("edward-1142", cryptcompress_inode_ok(inode));
 	assert("edward-1143", current_blocksize == PAGE_CACHE_SIZE);
 
 	hint = kmalloc(sizeof(*hint), GFP_KERNEL);
@@ -3454,7 +3453,7 @@ capture_page_cluster(reiser4_cluster_t *
 				   PAGECACHE_TAG_REISER4_MOVED);
 		read_unlock_irq(&inode->i_mapping->tree_lock);
 
-		release_cluster_pages_and_jnode(clust);
+		reiser4_release_cluster_pages_and_jnode(clust);
 	}
 	return result;
 }
@@ -3533,7 +3532,7 @@ capture_anonymous_clusters(struct addres
 /* Check mapping for existence of not captured dirty pages.
    This returns !0 if either page tree contains pages tagged
    PAGECACHE_TAG_REISER4_MOVED */
-static int crc_inode_has_anon_pages(struct inode *inode)
+static int cryptcompress_inode_has_anon_pages(struct inode *inode)
 {
 	return mapping_tagged(inode->i_mapping, PAGECACHE_TAG_REISER4_MOVED);
 }
@@ -3552,7 +3551,7 @@ writepages_cryptcompress(struct address_
 	struct inode *inode;
 
 	inode = mapping->host;
-	if (!crc_inode_has_anon_pages(inode)) {
+	if (!cryptcompress_inode_has_anon_pages(inode)) {
 		result = 0;
 		goto end;
 	}
@@ -3581,7 +3580,7 @@ writepages_cryptcompress(struct address_
 		} else
 			down_read(&info->lock);
 
-		ctx = init_context(inode->i_sb);
+		ctx = reiser4_init_context(inode->i_sb);
 		if (IS_ERR(ctx)) {
 			result = PTR_ERR(ctx);
 			break;
@@ -3614,7 +3613,7 @@ writepages_cryptcompress(struct address_
 		if (get_current_context()->nr_captured >= CAPTURE_APAGE_BURST) {
 			/* there are already pages to flush, flush them out, do
 			   not delay until end of reiser4_sync_inodes */
-			writeout(inode->i_sb, wbc);
+			reiser4_writeout(inode->i_sb, wbc);
 			get_current_context()->nr_captured = 0;
 		}
 	}
@@ -3650,7 +3649,7 @@ int delete_cryptcompress(struct inode *i
 		}
 	}
 	/* and remove stat data */
-	return delete_object_common(inode);
+	return reiser4_delete_object_common(inode);
 }
 
 /* plugin->u.file.setattr method
@@ -3692,7 +3691,7 @@ int setattr_cryptcompress(struct dentry 
 			cryptcompress_info_t *info =
 			    cryptcompress_inode_data(inode);
 
-			ctx = init_context(dentry->d_inode->i_sb);
+			ctx = reiser4_init_context(dentry->d_inode->i_sb);
 			if (IS_ERR(ctx))
 				return PTR_ERR(ctx);
 
@@ -3721,7 +3720,7 @@ int setattr_cryptcompress(struct dentry 
 		} else
 			result = 0;
 	} else
-		result = setattr_common(dentry, attr);
+		result = reiser4_setattr_common(dentry, attr);
 	return result;
 }
 
@@ -3736,7 +3735,7 @@ sendfile_cryptcompress(struct file *file
 	cryptcompress_info_t *info;
 
 	inode = file->f_dentry->d_inode;
-	ctx = init_context(inode->i_sb);
+	ctx = reiser4_init_context(inode->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 	/*
@@ -3763,7 +3762,7 @@ sendfile_cryptcompress(struct file *file
  */
 int release_cryptcompress(struct inode *inode, struct file *file)
 {
-	reiser4_context *ctx = init_context(inode->i_sb);
+	reiser4_context *ctx = reiser4_init_context(inode->i_sb);
 
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
diff -puN fs/reiser4/plugin/file/cryptcompress.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/file/cryptcompress.h
--- a/fs/reiser4/plugin/file/cryptcompress.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/file/cryptcompress.h
@@ -112,7 +112,7 @@ typedef enum {
 	CRC_APPEND_ITEM = 1,
 	CRC_OVERWRITE_ITEM = 2,
 	CRC_CUT_ITEM = 3
-} crc_write_mode_t;
+} cryptcompress_write_mode_t;
 
 typedef enum {
 	PCL_UNKNOWN = 0,	/* invalid option */
@@ -458,7 +458,7 @@ int goto_right_neighbor(coord_t *, lock_
 int load_file_hint(struct file *, hint_t *);
 void save_file_hint(struct file *, const hint_t *);
 void hint_init_zero(hint_t *);
-int crc_inode_ok(struct inode *inode);
+int cryptcompress_inode_ok(struct inode *inode);
 extern int ctail_read_disk_cluster (reiser4_cluster_t *, struct inode *, int);
 extern int do_readpage_ctail(struct inode *, reiser4_cluster_t *,
 			     struct page * page);
@@ -470,9 +470,9 @@ crypto_stat_t * inode_crypto_stat (struc
 void inherit_crypto_stat_common(struct inode * parent, struct inode * object,
 				int (*can_inherit)(struct inode * child,
 						   struct inode * parent));
-void attach_crypto_stat(struct inode * inode, crypto_stat_t * info);
+void reiser4_attach_crypto_stat(struct inode * inode, crypto_stat_t * info);
 void change_crypto_stat(struct inode * inode, crypto_stat_t * new);
-crypto_stat_t * alloc_crypto_stat (struct inode * inode);
+crypto_stat_t * reiser4_alloc_crypto_stat (struct inode * inode);
 
 
 static inline reiser4_tfma_t *
diff -puN fs/reiser4/plugin/file/file.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/file/file.c
@@ -179,8 +179,9 @@ static void set_file_state(unix_file_inf
 		 * container is unknown, therefore conversion can not be in
 		 * progress
 		 */
-		assert("", !inode_get_flag(unix_file_info_to_inode(uf_info),
-					   REISER4_PART_IN_CONV));
+		assert("",
+		       !reiser4_inode_get_flag(unix_file_info_to_inode(uf_info),
+					       REISER4_PART_IN_CONV));
 		if (cbk_result == CBK_COORD_NOTFOUND)
 			uf_info->container = UF_CONTAINER_EMPTY;
 		else if (level == LEAF_LEVEL)
@@ -192,8 +193,8 @@ static void set_file_state(unix_file_inf
 		 * file state is known, check whether it is set correctly if
 		 * file is not being tail converted
 		 */
-		if (!inode_get_flag(unix_file_info_to_inode(uf_info),
-				    REISER4_PART_IN_CONV)) {
+		if (!reiser4_inode_get_flag(unix_file_info_to_inode(uf_info),
+					    REISER4_PART_IN_CONV)) {
 			assert("vs-1162",
 			       ergo(level == LEAF_LEVEL &&
 				    cbk_result == CBK_COORD_FOUND,
@@ -210,12 +211,12 @@ int find_file_item_nohint(coord_t *coord
 			  const reiser4_key *key, znode_lock_mode lock_mode,
 			  struct inode *inode)
 {
-	return object_lookup(inode, key, coord, lh, lock_mode,
-			     FIND_MAX_NOT_MORE_THAN,
-			     TWIG_LEVEL, LEAF_LEVEL,
-			     (lock_mode == ZNODE_READ_LOCK) ? CBK_UNIQUE :
-			     (CBK_UNIQUE | CBK_FOR_INSERT),
-			     NULL /* ra_info */ );
+	return reiser4_object_lookup(inode, key, coord, lh, lock_mode,
+				     FIND_MAX_NOT_MORE_THAN,
+				     TWIG_LEVEL, LEAF_LEVEL,
+				     (lock_mode == ZNODE_READ_LOCK) ? CBK_UNIQUE :
+				     (CBK_UNIQUE | CBK_FOR_INSERT),
+				     NULL /* ra_info */ );
 }
 
 /**
@@ -237,7 +238,7 @@ int find_file_item(hint_t *hint, const r
 	coord_t *coord;
 	lock_handle *lh;
 
-	assert("nikita-3030", schedulable());
+	assert("nikita-3030", reiser4_schedulable());
 	assert("vs-1707", hint != NULL);
 	assert("vs-47", inode != NULL);
 
@@ -310,7 +311,7 @@ static int find_file_state(struct inode 
 		result = 0;
 	assert("vs-1074",
 	       ergo(result == 0, uf_info->container != UF_CONTAINER_UNKNOWN));
-	txn_restart_current();
+	reiser4_txn_restart_current();
 	return result;
 }
 
@@ -341,7 +342,8 @@ static int reserve_cut_iteration(reiser4
 				     BA_CAN_COMMIT);
 }
 
-int update_file_size(struct inode *inode, reiser4_key * key, int update_sd)
+int reiser4_update_file_size(struct inode *inode, reiser4_key * key,
+			     int update_sd)
 {
 	int result = 0;
 
@@ -372,16 +374,16 @@ cut_file_items(struct inode *inode, loff
 
 	fplug->key_by_inode(inode, new_size, &from_key);
 	to_key = from_key;
-	set_key_offset(&to_key, cur_size - 1 /*get_key_offset(max_key()) */ );
+	set_key_offset(&to_key, cur_size - 1 /*get_key_offset(reiser4_max_key()) */ );
 	/* this loop normally runs just once */
 	while (1) {
-		result = reserve_cut_iteration(tree_by_inode(inode));
+		result = reserve_cut_iteration(reiser4_tree_by_inode(inode));
 		if (result)
 			break;
 
-		result = cut_tree_object(current_tree, &from_key, &to_key,
-					 &smallest_removed, inode, 1,
-					 &progress);
+		result = reiser4_cut_tree_object(current_tree, &from_key, &to_key,
+						 &smallest_removed, inode, 1,
+						 &progress);
 		if (result == -E_REPEAT) {
 			/* -E_REPEAT is a signal to interrupt a long file truncation process */
 			if (progress) {
@@ -395,10 +397,10 @@ cut_file_items(struct inode *inode, loff
 			/* the below does up(sbinfo->delete_sema). Do not get folled */
 			reiser4_release_reserved(inode->i_sb);
 
-			/* cut_tree_object() was interrupted probably because
+			/* reiser4_cut_tree_object() was interrupted probably because
 			 * current atom requires commit, we have to release
 			 * transaction handle to allow atom commit. */
-			txn_restart_current();
+			reiser4_txn_restart_current();
 			continue;
 		}
 		if (result
@@ -438,11 +440,12 @@ static int shorten_file(struct inode *in
 
 	/*
 	 * all items of ordinary reiser4 file are grouped together. That is why
-	 * we can use cut_tree. Plan B files (for instance) can not be
+	 * we can use reiser4_cut_tree. Plan B files (for instance) can not be
 	 * truncated that simply
 	 */
 	result = cut_file_items(inode, new_size, 1 /*update_sd */ ,
-				get_key_offset(max_key()), update_file_size);
+				get_key_offset(reiser4_max_key()),
+				reiser4_update_file_size);
 	if (result)
 		return result;
 
@@ -468,7 +471,7 @@ static int shorten_file(struct inode *in
 		/* file is truncated to page boundary */
 		return 0;
 
-	result = reserve_partial_page(tree_by_inode(inode));
+	result = reserve_partial_page(reiser4_tree_by_inode(inode));
 	if (result) {
 		reiser4_release_reserved(inode->i_sb);
 		return result;
@@ -591,7 +594,8 @@ static int truncate_file_body(struct ino
 				 * - wait until it completes
 				 */
 				while (1) {
-					if (inode_get_flag(inode, REISER4_PART_IN_CONV)) {
+					if (reiser4_inode_get_flag(inode,
+								   REISER4_PART_IN_CONV)) {
 						drop_exclusive_access(uf_info);
 						schedule();
 						get_exclusive_access(uf_info);
@@ -606,17 +610,20 @@ static int truncate_file_body(struct ino
 						return result;
 				}
 			}
-			result = write_extent(&file, NULL, 0, &new_size);
+			result = reiser4_write_extent(&file, NULL, 0,
+						      &new_size);
 			if (result)
 				return result;
 			uf_info->container = UF_CONTAINER_EXTENTS;
 		} else {
 			if (uf_info->container ==  UF_CONTAINER_EXTENTS) {
-				result = write_extent(&file, NULL, 0, &new_size);
+				result = reiser4_write_extent(&file, NULL, 0,
+							      &new_size);
 				if (result)
 					return result;
 			} else {
-				result = write_tail(&file, NULL, 0, &new_size);
+				result = reiser4_write_tail(&file, NULL, 0,
+							    &new_size);
 				if (result)
 					return result;
 				uf_info->container = UF_CONTAINER_TAILS;
@@ -656,7 +663,7 @@ int load_file_hint(struct file *file, hi
 			return PTR_ERR(fsdata);
 
 		spin_lock_inode(file->f_dentry->d_inode);
-		if (seal_is_set(&fsdata->reg.hint.seal)) {
+		if (reiser4_seal_is_set(&fsdata->reg.hint.seal)) {
 			*hint = fsdata->reg.hint;
 			init_lh(&hint->lh);
 			hint->ext_coord.lh = &hint->lh;
@@ -692,7 +699,7 @@ void save_file_hint(struct file *file, c
 
 	assert("edward-1337", hint != NULL);
 
-	if (!file || !seal_is_set(&hint->seal))
+	if (!file || !reiser4_seal_is_set(&hint->seal))
 		return;
 	fsdata = reiser4_get_file_fsdata(file);
 	assert("vs-965", !IS_ERR(fsdata));
@@ -705,21 +712,23 @@ void save_file_hint(struct file *file, c
 	return;
 }
 
-void unset_hint(hint_t * hint)
+void reiser4_unset_hint(hint_t * hint)
 {
 	assert("vs-1315", hint);
 	hint->ext_coord.valid = 0;
-	seal_done(&hint->seal);
+	reiser4_seal_done(&hint->seal);
 	done_lh(&hint->lh);
 }
 
-/* coord must be set properly. So, that set_hint has nothing to do */
-void set_hint(hint_t * hint, const reiser4_key * key, znode_lock_mode mode)
+/* coord must be set properly. So, that reiser4_set_hint
+   has nothing to do */
+void reiser4_set_hint(hint_t * hint, const reiser4_key * key,
+		      znode_lock_mode mode)
 {
 	ON_DEBUG(coord_t * coord = &hint->ext_coord.coord);
 	assert("vs-1207", WITH_DATA(coord->node, check_coord(coord, key)));
 
-	seal_init(&hint->seal, &hint->ext_coord.coord, key);
+	reiser4_seal_init(&hint->seal, &hint->ext_coord.coord, key);
 	hint->offset = get_key_offset(key);
 	hint->mode = mode;
 	done_lh(&hint->lh);
@@ -727,7 +736,7 @@ void set_hint(hint_t * hint, const reise
 
 int hint_is_set(const hint_t * hint)
 {
-	return seal_is_set(&hint->seal);
+	return reiser4_seal_is_set(&hint->seal);
 }
 
 #if REISER4_DEBUG
@@ -756,8 +765,9 @@ hint_validate(hint_t * hint, const reise
 		return RETERR(-E_REPEAT);
 
 	assert("vs-31", hint->ext_coord.lh == &hint->lh);
-	return seal_validate(&hint->seal, &hint->ext_coord.coord, key,
-			     hint->ext_coord.lh, lock_mode, ZNODE_LOCK_LOPRI);
+	return reiser4_seal_validate(&hint->seal, &hint->ext_coord.coord, key,
+				     hint->ext_coord.lh, lock_mode,
+				     ZNODE_LOCK_LOPRI);
 }
 
 /**
@@ -790,20 +800,20 @@ int find_or_create_extent(struct page *p
 
 	if (node->blocknr == 0) {
 		plugged_hole = 0;
-		result = update_extent(inode, node,
-				       (loff_t)page->index << PAGE_CACHE_SHIFT,
-				       &plugged_hole);
+		result = reiser4_update_extent(inode, node,
+					(loff_t)page->index << PAGE_CACHE_SHIFT,
+					       &plugged_hole);
 		if (result) {
  			JF_CLR(node, JNODE_WRITE_PREPARED);
 			jput(node);
-			warning("", "update_extent failed: %d", result);
+			warning("", "reiser4_update_extent failed: %d", result);
 			return result;
 		}
 		if (plugged_hole)
 			reiser4_update_sd(inode);
 	} else {
 		spin_lock_jnode(node);
-		result = try_capture(node, ZNODE_WRITE_LOCK, 0);
+		result = reiser4_try_capture(node, ZNODE_WRITE_LOCK, 0);
 		BUG_ON(result != 0);
 		jnode_make_dirty_locked(node);
 		spin_unlock_jnode(node);
@@ -865,11 +875,9 @@ static int capture_page_and_create_exten
 	   and stat data's update (number of blocks changes on extent
 	   creation) */
 	grab_space_enable();
-	result =
-	    reiser4_grab_space(2 *
-			       estimate_one_insert_into_item(tree_by_inode
-							     (inode)),
-			       BA_CAN_COMMIT);
+	result = reiser4_grab_space(2 * estimate_one_insert_into_item
+				    (reiser4_tree_by_inode(inode)),
+				    BA_CAN_COMMIT);
 	if (likely(!result))
 		result = find_or_create_extent(page);
 
@@ -895,7 +903,7 @@ commit_write_unix_file(struct file *file
 	SetPageUptodate(page);
 
 	inode = page->mapping->host;
-	ctx = init_context(page->mapping->host->i_sb);
+	ctx = reiser4_init_context(page->mapping->host->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 	page_cache_get(page);
@@ -1014,7 +1022,7 @@ capture_anonymous_pages(struct address_s
 	for (i = 0; i < pagevec_count(&pvec); i++) {
 		/*
 		 * tag PAGECACHE_TAG_REISER4_MOVED will be cleared by
-		 * set_page_dirty_internal which is called when jnode is
+		 * reiser4_set_page_dirty_internal which is called when jnode is
 		 * captured
 		 */
 		result = capture_anonymous_page(pvec.pages[i]);
@@ -1101,7 +1109,7 @@ static int sync_page(struct page *page)
 		} else
 			atom = NULL;
 		unlock_page(page);
-		result = sync_atom(atom);
+		result = reiser4_sync_atom(atom);
 	} while (result == -E_REPEAT);
 	/*
 	 * ZAM-FIXME-HANS: document the logic of this loop, is it just to
@@ -1177,7 +1185,7 @@ static int commit_file_atoms(struct inod
 	switch (uf_info->container) {
 	case UF_CONTAINER_EXTENTS:
 		/* find_file_state might open join an atom */
-		txn_restart_current();
+		reiser4_txn_restart_current();
 		result =
 		    /*
 		     * when we are called by
@@ -1217,7 +1225,7 @@ static int commit_file_atoms(struct inod
 	 * commit current transaction: there can be captured nodes from
 	 * find_file_state() and finish_conversion().
 	 */
-	txn_restart_current();
+	reiser4_txn_restart_current();
 	return result;
 }
 
@@ -1258,7 +1266,7 @@ int writepages_unix_file(struct address_
 		else
 			to_capture = CAPTURE_APAGE_BURST;
 
-		ctx = init_context(inode->i_sb);
+		ctx = reiser4_init_context(inode->i_sb);
 		if (IS_ERR(ctx)) {
 			result = PTR_ERR(ctx);
 			break;
@@ -1269,7 +1277,7 @@ int writepages_unix_file(struct address_
 		assert("", LOCK_CNT_NIL(inode_sem_w));
 		assert("", LOCK_CNT_NIL(inode_sem_r));
 
-		txn_restart_current();
+		reiser4_txn_restart_current();
 
 		/* we have to get nonexclusive access to the file */
 		if (get_current_context()->entd) {
@@ -1358,7 +1366,7 @@ int writepages_unix_file(struct address_
 			 * there are already pages to flush, flush them out, do
 			 * not delay until end of reiser4_sync_inodes
 			 */
-			writeout(inode->i_sb, wbc);
+			reiser4_writeout(inode->i_sb, wbc);
 			get_current_context()->nr_captured = 0;
 		}
 	}
@@ -1383,7 +1391,7 @@ int sync_unix_file(struct file *file, st
 	txn_atom *atom;
 	reiser4_block_nr reserve;
 
-	ctx = init_context(dentry->d_inode->i_sb);
+	ctx = reiser4_init_context(dentry->d_inode->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
@@ -1432,13 +1440,13 @@ int readpage_unix_file_nolock(struct fil
 	}
 
 	inode = page->mapping->host;
-	ctx = init_context(inode->i_sb);
+	ctx = reiser4_init_context(inode->i_sb);
 	if (IS_ERR(ctx)) {
 		unlock_page(page);
 		return PTR_ERR(ctx);
 	}
 
-	hint = kmalloc(sizeof(*hint), get_gfp_mask());
+	hint = kmalloc(sizeof(*hint), reiser4_ctx_gfp_mask_get());
 	if (hint == NULL) {
 		unlock_page(page);
 		reiser4_exit_context(ctx);
@@ -1474,7 +1482,7 @@ int readpage_unix_file_nolock(struct fil
 		done_lh(lh);
 		kfree(hint);
 		unlock_page(page);
-		txn_restart(ctx);
+		reiser4_txn_restart(ctx);
 		reiser4_exit_context(ctx);
 		return -EINVAL;
 	}
@@ -1487,7 +1495,7 @@ int readpage_unix_file_nolock(struct fil
 		done_lh(lh);
 		kfree(hint);
 		unlock_page(page);
-		txn_restart(ctx);
+		reiser4_txn_restart(ctx);
 		reiser4_exit_context(ctx);
 		return result;
 	}
@@ -1500,7 +1508,7 @@ int readpage_unix_file_nolock(struct fil
 		done_lh(lh);
 		kfree(hint);
 		unlock_page(page);
-		txn_restart(ctx);
+		reiser4_txn_restart(ctx);
 		reiser4_exit_context(ctx);
 		return 0;
 	}
@@ -1511,7 +1519,7 @@ int readpage_unix_file_nolock(struct fil
 		done_lh(lh);
 		kfree(hint);
 		unlock_page(page);
-		txn_restart(ctx);
+		reiser4_txn_restart(ctx);
 		reiser4_exit_context(ctx);
 		return result;
 	}
@@ -1530,7 +1538,7 @@ int readpage_unix_file_nolock(struct fil
 		done_lh(lh);
 		kfree(hint);
 		unlock_page(page);
-		txn_restart(ctx);
+		reiser4_txn_restart(ctx);
 		reiser4_exit_context(ctx);
 		return RETERR(-EIO);
 	}
@@ -1548,11 +1556,11 @@ int readpage_unix_file_nolock(struct fil
 	if (!result) {
 		set_key_offset(&key,
 			       (loff_t) (page->index + 1) << PAGE_CACHE_SHIFT);
-		/* FIXME should call set_hint() */
-		unset_hint(hint);
+		/* FIXME should call reiser4_set_hint() */
+		reiser4_unset_hint(hint);
 	} else {
 		unlock_page(page);
-		unset_hint(hint);
+		reiser4_unset_hint(hint);
 	}
 	assert("vs-979",
 	       ergo(result == 0, (PageLocked(page) || PageUptodate(page))));
@@ -1569,7 +1577,7 @@ int readpage_unix_file_nolock(struct fil
 	 * not be done when atom is not NULL because reiser4_writepage can not
 	 * kick entd and have to eflush
 	 */
-	txn_restart(ctx);
+	reiser4_txn_restart(ctx);
 	reiser4_exit_context(ctx);
 	return result;
 }
@@ -1694,13 +1702,13 @@ ssize_t read_unix_file(struct file *file
 	assert("umka-072", file != NULL);
 	assert("umka-074", off != NULL);
 	inode = file->f_dentry->d_inode;
-	assert("vs-972", !inode_get_flag(inode, REISER4_NO_SD));
+	assert("vs-972", !reiser4_inode_get_flag(inode, REISER4_NO_SD));
 
-	ctx = init_context(inode->i_sb);
+	ctx = reiser4_init_context(inode->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
-	hint = kmalloc(sizeof(*hint), get_gfp_mask());
+	hint = kmalloc(sizeof(*hint), reiser4_ctx_gfp_mask_get());
 	if (hint == NULL) {
 		context_set_commit_async(ctx);
 		reiser4_exit_context(ctx);
@@ -1719,7 +1727,7 @@ ssize_t read_unix_file(struct file *file
 	count = 0;
 	uf_info = unix_file_inode_data(inode);
 	while (left > 0) {
-		txn_restart_current();
+		reiser4_txn_restart_current();
 
 		get_nonexclusive_access(uf_info);
 
@@ -1816,7 +1824,7 @@ int mmap_unix_file(struct file *file, st
 	reiser4_block_nr needed;
 
 	inode = file->f_dentry->d_inode;
-	ctx = init_context(inode->i_sb);
+	ctx = reiser4_init_context(inode->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
@@ -1873,7 +1881,7 @@ int mmap_unix_file(struct file *file, st
 	result = generic_file_mmap(file, vma);
 	if (result == 0) {
 		/* mark file as having mapping. */
-		inode_set_flag(inode, REISER4_HAS_MMAP);
+		reiser4_inode_set_flag(inode, REISER4_HAS_MMAP);
 	}
 
 	drop_exclusive_access(uf_info);
@@ -1934,10 +1942,10 @@ int open_unix_file(struct inode *inode, 
 	if (IS_RDONLY(inode))
 		return 0;
 
-	if (!inode_get_flag(inode, REISER4_PART_MIXED))
+	if (!reiser4_inode_get_flag(inode, REISER4_PART_MIXED))
 		return 0;
 
-	ctx = init_context(inode->i_sb);
+	ctx = reiser4_init_context(inode->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
@@ -1949,7 +1957,7 @@ int open_unix_file(struct inode *inode, 
 	 * until it completes
 	 */
 	while (1) {
-		if (inode_get_flag(inode, REISER4_PART_IN_CONV)) {
+		if (reiser4_inode_get_flag(inode, REISER4_PART_IN_CONV)) {
 			drop_exclusive_access(uf_info);
 			schedule();
 			get_exclusive_access(uf_info);
@@ -1958,7 +1966,7 @@ int open_unix_file(struct inode *inode, 
 		break;
 	}
 
-	if (!inode_get_flag(inode, REISER4_PART_MIXED)) {
+	if (!reiser4_inode_get_flag(inode, REISER4_PART_MIXED)) {
 		/*
 		 * other process completed the conversion
 		 */
@@ -1989,8 +1997,9 @@ int open_unix_file(struct inode *inode, 
 		result = -EIO;
 
 	assert("vs-1712",
-	       ergo(result == 0, (!inode_get_flag(inode, REISER4_PART_MIXED) &&
-				  !inode_get_flag(inode, REISER4_PART_IN_CONV))));
+	       ergo(result == 0,
+		    (!reiser4_inode_get_flag(inode, REISER4_PART_MIXED) &&
+		     !reiser4_inode_get_flag(inode, REISER4_PART_IN_CONV))));
 	drop_exclusive_access(uf_info);
 	reiser4_exit_context(ctx);
 	return result;
@@ -2038,14 +2047,14 @@ ssize_t write_unix_file(struct file *fil
 	loff_t new_size;
 
 	inode = file->f_dentry->d_inode;
-	ctx = init_context(inode->i_sb);
+	ctx = reiser4_init_context(inode->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
 	mutex_lock(&inode->i_mutex);
 
-	assert("vs-947", !inode_get_flag(inode, REISER4_NO_SD));
-	assert("vs-9471", (!inode_get_flag(inode, REISER4_PART_MIXED)));
+	assert("vs-947", !reiser4_inode_get_flag(inode, REISER4_NO_SD));
+	assert("vs-9471", (!reiser4_inode_get_flag(inode, REISER4_PART_MIXED)));
 
 	/* check amount of bytes to write and writing position */
 	result = generic_write_checks(file, pos, &count, 0);
@@ -2110,13 +2119,13 @@ ssize_t write_unix_file(struct file *fil
 		/* either EA or NEA is obtained. Choose item write method */
 		if (uf_info->container == UF_CONTAINER_EXTENTS) {
 			/* file is built of extent items */
-			write_op = write_extent;
+			write_op = reiser4_write_extent;
 		} else if (uf_info->container == UF_CONTAINER_EMPTY) {
 			/* file is empty */
 			if (should_have_notail(uf_info, new_size))
-				write_op = write_extent;
+				write_op = reiser4_write_extent;
 			else
-				write_op = write_tail;
+				write_op = reiser4_write_tail;
 		} else {
 			/* file is built of tail items */
 			if (should_have_notail(uf_info, new_size)) {
@@ -2131,7 +2140,8 @@ ssize_t write_unix_file(struct file *fil
 					 * process - wait until it completes
 					 */
 					while (1) {
-						if (inode_get_flag(inode, REISER4_PART_IN_CONV)) {
+						if (reiser4_inode_get_flag(inode,
+									   REISER4_PART_IN_CONV)) {
 							drop_exclusive_access(uf_info);
 							schedule();
 							get_exclusive_access(uf_info);
@@ -2149,7 +2159,7 @@ ssize_t write_unix_file(struct file *fil
 				ea = NEITHER_OBTAINED;
 				continue;
 			}
-			write_op = write_tail;
+			write_op = reiser4_write_tail;
 		}
 
 		written = write_op(file, buf, to_write, pos);
@@ -2167,13 +2177,14 @@ ssize_t write_unix_file(struct file *fil
 		/* something is written. */
 		if (uf_info->container == UF_CONTAINER_EMPTY) {
 			assert("", ea == EA_OBTAINED);
-			uf_info->container = (write_op == write_extent) ?
+			uf_info->container =
+				(write_op == reiser4_write_extent) ?
 				UF_CONTAINER_EXTENTS : UF_CONTAINER_TAILS;
 		} else {
 			assert("", ergo(uf_info->container == UF_CONTAINER_EXTENTS,
-					write_op == write_extent));
+					write_op == reiser4_write_extent));
 			assert("", ergo(uf_info->container == UF_CONTAINER_TAILS,
-					write_op == write_tail));
+					write_op == reiser4_write_tail));
 		}
 		if (*pos + written > inode->i_size)
 			INODE_SET_FIELD(inode, i_size, *pos + written);
@@ -2189,7 +2200,7 @@ ssize_t write_unix_file(struct file *fil
 		}
 		drop_access(uf_info);
 		ea = NEITHER_OBTAINED;
-		txn_restart(ctx);
+		reiser4_txn_restart(ctx);
 		current->journal_info = NULL;
 		/*
 		 * tell VM how many pages were dirtied. Maybe number of pages
@@ -2207,7 +2218,7 @@ ssize_t write_unix_file(struct file *fil
 	mutex_unlock(&inode->i_mutex);
 
 	if (result == 0 && ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
-		txn_restart_current();
+		reiser4_txn_restart_current();
 		grab_space_enable();
 		result = sync_unix_file(file, file->f_dentry,
 					0 /* data and stat data */ );
@@ -2246,7 +2257,7 @@ int release_unix_file(struct inode *inod
 
 	in_reiser4 = is_in_reiser4_context();
 
-	ctx = init_context(inode->i_sb);
+	ctx = reiser4_init_context(inode->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
@@ -2294,7 +2305,7 @@ int release_unix_file(struct inode *inod
 		   #15 0xc01131e5 in do_page_fault ()
 		   #16 0xc0104935 in error_code ()
 		   #17 0xc025c0c6 in __copy_to_user_ll ()
-		   #18 0xc01d496f in read_tail ()
+		   #18 0xc01d496f in reiser4_read_tail ()
 		   #19 0xc01e4def in read_unix_file ()
 		   #20 0xc01c3504 in reiser4_read ()
 		   #21 0xc014bd4f in vfs_read ()
@@ -2341,7 +2352,8 @@ static int unpack(struct file *filp, str
 		 * completes
 		 */
 		while (1) {
-			if (inode_get_flag(inode, REISER4_PART_IN_CONV)) {
+			if (reiser4_inode_get_flag(inode,
+						   REISER4_PART_IN_CONV)) {
 				drop_exclusive_access(uf_info);
 				schedule();
 				get_exclusive_access(uf_info);
@@ -2380,7 +2392,7 @@ ioctl_unix_file(struct inode *inode, str
 	reiser4_context *ctx;
 	int result;
 
-	ctx = init_context(inode->i_sb);
+	ctx = reiser4_init_context(inode->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
@@ -2415,7 +2427,7 @@ sector_t bmap_unix_file(struct address_s
 
 	inode = mapping->host;
 
-	ctx = init_context(inode->i_sb);
+	ctx = reiser4_init_context(inode->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 	key_by_inode_and_offset_common(inode,
@@ -2488,7 +2500,7 @@ int flow_by_inode_unix_file(struct inode
    plugin->u.file.create_blank_sd = NULL */
 /* plugin->u.file.delete */
 /*
-   plugin->u.file.add_link = add_link_common
+   plugin->u.file.add_link = reiser4_add_link_common
    plugin->u.file.rem_link = NULL */
 
 /* plugin->u.file.owns_item
@@ -2521,7 +2533,7 @@ static int setattr_truncate(struct inode
 	inode_check_scale(inode, inode->i_size, attr->ia_size);
 
 	old_size = inode->i_size;
-	tree = tree_by_inode(inode);
+	tree = reiser4_tree_by_inode(inode);
 
 	result = safe_link_grab(tree, BA_CAN_COMMIT);
 	if (result == 0)
@@ -2560,7 +2572,7 @@ int setattr_unix_file(struct dentry *den
 
 		/* truncate does reservation itself and requires exclusive
 		   access obtained */
-		ctx = init_context(dentry->d_inode->i_sb);
+		ctx = reiser4_init_context(dentry->d_inode->i_sb);
 		if (IS_ERR(ctx))
 			return PTR_ERR(ctx);
 
@@ -2573,7 +2585,7 @@ int setattr_unix_file(struct dentry *den
 		context_set_commit_async(ctx);
 		reiser4_exit_context(ctx);
 	} else
-		result = setattr_common(dentry, attr);
+		result = reiser4_setattr_common(dentry, attr);
 
 	return result;
 }
@@ -2610,7 +2622,7 @@ int delete_object_unix_file(struct inode
 	unix_file_info_t *uf_info;
 	int result;
 
-	if (inode_get_flag(inode, REISER4_NO_SD))
+	if (reiser4_inode_get_flag(inode, REISER4_NO_SD))
 		return 0;
 
 	/* truncate file bogy first */
@@ -2624,7 +2636,7 @@ int delete_object_unix_file(struct inode
 			get_inode_oid(inode), result);
 
 	/* remove stat data and safe link */
-	return delete_object_common(inode);
+	return reiser4_delete_object_common(inode);
 }
 
 /**
@@ -2648,7 +2660,7 @@ sendfile_unix_file(struct file *file, lo
 	unix_file_info_t *uf_info;
 
 	inode = file->f_dentry->d_inode;
-	ctx = init_context(inode->i_sb);
+	ctx = reiser4_init_context(inode->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
@@ -2661,7 +2673,7 @@ sendfile_unix_file(struct file *file, lo
 	if (result)
 		goto error;
 	mutex_lock(&inode->i_mutex);
-	inode_set_flag(inode, REISER4_HAS_MMAP);
+	reiser4_inode_set_flag(inode, REISER4_HAS_MMAP);
 	mutex_unlock(&inode->i_mutex);
 
 	uf_info = unix_file_inode_data(inode);
@@ -2681,7 +2693,7 @@ prepare_write_unix_file(struct file *fil
 	unix_file_info_t *uf_info;
 	int ret;
 
-	ctx = init_context(file->f_dentry->d_inode->i_sb);
+	ctx = reiser4_init_context(file->f_dentry->d_inode->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
diff -puN fs/reiser4/plugin/file/file.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/file/file.h
--- a/fs/reiser4/plugin/file/file.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/file/file.h
@@ -152,14 +152,14 @@ struct hint {
 	lock_handle lh;
 };
 
-void set_hint(hint_t *, const reiser4_key *, znode_lock_mode);
+void reiser4_set_hint(hint_t *, const reiser4_key *, znode_lock_mode);
 int hint_is_set(const hint_t *);
-void unset_hint(hint_t *);
+void reiser4_unset_hint(hint_t *);
 int hint_validate(hint_t *, const reiser4_key *, int check_key,
 		  znode_lock_mode);
 void hint_init_zero(hint_t *);
 
-int update_file_size(struct inode *, reiser4_key *, int update_sd);
+int reiser4_update_file_size(struct inode *, reiser4_key *, int update_sd);
 int cut_file_items(struct inode *, loff_t new_size, int update_sd,
 		   loff_t cur_size, int (*update_actor) (struct inode *,
 							 reiser4_key *, int));
@@ -181,8 +181,8 @@ static inline int ea_obtained(unix_file_
 #endif
 
 /* declarations of functions implementing SYMLINK_FILE_PLUGIN_ID file plugin */
-int create_symlink(struct inode *symlink, struct inode *dir,
-		   reiser4_object_create_data *);
+int reiser4_create_symlink(struct inode *symlink, struct inode *dir,
+			   reiser4_object_create_data *);
 void destroy_inode_symlink(struct inode *);
 
 /* declarations of functions implementing CRC_FILE_PLUGIN_ID file plugin */
diff -puN fs/reiser4/plugin/file/invert.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/file/invert.c
--- a/fs/reiser4/plugin/file/invert.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/file/invert.c
@@ -431,8 +431,8 @@ int get_inv_entry(struct inode *invert_i
 		init_coord(&coord);
 		init_lh(&lh);
 		result =
-		    lookup_sd_by_key(tree_by_inode(invert_inode),
-				     ZNODE_READ_LOCK, &coord, &lh, key);
+			lookup_sd_by_key(reiser4_tree_by_inode(invert_inode),
+					 ZNODE_READ_LOCK, &coord, &lh, key);
 		if (result == 0)
 			init_incore_sd_base(ientry, coord);
 
diff -puN fs/reiser4/plugin/file/symlink.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/file/symlink.c
--- a/fs/reiser4/plugin/file/symlink.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/file/symlink.c
@@ -13,25 +13,25 @@
  */
 
 /**
- * create_symlink - create_object of file plugin for SYMLINK_FILE_PLUGIN_ID
+ * reiser4_create_symlink - create_object of file plugin for SYMLINK_FILE_PLUGIN_ID
  * @symlink: inode of symlink object
  * @dir: inode of parent directory
  * @info:  parameters of new object
  *
  * Inserts stat data with symlink extension where into the tree.
  */
-int create_symlink(struct inode *symlink,
-		   struct inode *dir UNUSED_ARG,
-		   reiser4_object_create_data *data	/* info passed to us,
-							 * this is filled by
-							 * reiser4() syscall
-							 * in particular */ )
+int reiser4_create_symlink(struct inode *symlink,
+			   struct inode *dir UNUSED_ARG,
+			   reiser4_object_create_data *data /* info passed to us
+							     * this is filled by
+							     * reiser4() syscall
+							     * in particular */)
 {
 	int result;
 
 	assert("nikita-680", symlink != NULL);
 	assert("nikita-681", S_ISLNK(symlink->i_mode));
-	assert("nikita-685", inode_get_flag(symlink, REISER4_NO_SD));
+	assert("nikita-685", reiser4_inode_get_flag(symlink, REISER4_NO_SD));
 	assert("nikita-682", dir != NULL);
 	assert("nikita-684", data != NULL);
 	assert("nikita-686", data->id == SYMLINK_FILE_PLUGIN_ID);
@@ -56,7 +56,8 @@ int create_symlink(struct inode *symlink
 		INODE_SET_FIELD(symlink, i_size, 0);
 	} else {
 		assert("vs-849", symlink->i_private
-		       && inode_get_flag(symlink, REISER4_GENERIC_PTR_USED));
+		       && reiser4_inode_get_flag(symlink,
+						 REISER4_GENERIC_PTR_USED));
 		assert("vs-850",
 		       !memcmp((char *)symlink->i_private, data->name,
 			       (size_t) symlink->i_size + 1));
@@ -73,20 +74,22 @@ void destroy_inode_symlink(struct inode 
 	       inode_file_plugin(inode) ==
 	       file_plugin_by_id(SYMLINK_FILE_PLUGIN_ID));
 	assert("edward-800", !is_bad_inode(inode) && is_inode_loaded(inode));
-	assert("edward-801", inode_get_flag(inode, REISER4_GENERIC_PTR_USED));
+	assert("edward-801", reiser4_inode_get_flag(inode,
+						    REISER4_GENERIC_PTR_USED));
 	assert("vs-839", S_ISLNK(inode->i_mode));
 
 	kfree(inode->i_private);
 	inode->i_private = NULL;
-	inode_clr_flag(inode, REISER4_GENERIC_PTR_USED);
+	reiser4_inode_clr_flag(inode, REISER4_GENERIC_PTR_USED);
 }
 
-/* Local variables:
-   c-indentation-style: "K&R"
-   mode-name: "LC"
-   c-basic-offset: 8
-   tab-width: 8
-   fill-column: 120
-   scroll-step: 1
-   End:
+/*
+  Local variables:
+  c-indentation-style: "K&R"
+  mode-name: "LC"
+  c-basic-offset: 8
+  tab-width: 8
+  fill-column: 80
+  scroll-step: 1
+  End:
 */
diff -puN fs/reiser4/plugin/file/tail_conversion.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/file/tail_conversion.c
--- a/fs/reiser4/plugin/file/tail_conversion.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/file/tail_conversion.c
@@ -15,7 +15,7 @@
 /* exclusive access to a file is acquired when file state changes: tail2extent, empty2tail, extent2tail, etc */
 void get_exclusive_access(unix_file_info_t * uf_info)
 {
-	assert("nikita-3028", schedulable());
+	assert("nikita-3028", reiser4_schedulable());
 	assert("nikita-3047", LOCK_CNT_NIL(inode_sem_w));
 	assert("nikita-3048", LOCK_CNT_NIL(inode_sem_r));
 	/*
@@ -24,7 +24,7 @@ void get_exclusive_access(unix_file_info
 	 * thread that captured some block (hence preventing atom from being
 	 * committed) and waits on rw-semaphore.
 	 */
-	txn_restart_current();
+	reiser4_txn_restart_current();
 	LOCK_CNT_INC(inode_sem_w);
 	down_write(&uf_info->latch);
 	uf_info->exclusive_use = 1;
@@ -43,7 +43,7 @@ void drop_exclusive_access(unix_file_inf
 	assert("nikita-3049", LOCK_CNT_NIL(inode_sem_r));
 	assert("nikita-3049", LOCK_CNT_GTZ(inode_sem_w));
 	LOCK_CNT_DEC(inode_sem_w);
-	txn_restart_current();
+	reiser4_txn_restart_current();
 }
 
 /**
@@ -71,7 +71,7 @@ static void nea_grabbed(unix_file_info_t
  */
 void get_nonexclusive_access(unix_file_info_t *uf_info)
 {
-	assert("nikita-3029", schedulable());
+	assert("nikita-3029", reiser4_schedulable());
 	assert("nikita-3361", get_current_context()->trans->atom == NULL);
 
 	down_read(&uf_info->latch);
@@ -103,7 +103,7 @@ void drop_nonexclusive_access(unix_file_
 	up_read(&uf_info->latch);
 
 	LOCK_CNT_DEC(inode_sem_r);
-	txn_restart_current();
+	reiser4_txn_restart_current();
 }
 
 /* part of tail2extent. Cut all items covering @count bytes starting from
@@ -123,7 +123,8 @@ static int cut_formatting_items(struct i
 	set_key_offset(&to, (__u64) (offset + count - 1));
 
 	/* cut everything between those keys */
-	return cut_tree(tree_by_inode(inode), &from, &to, inode, 0);
+	return reiser4_cut_tree(reiser4_tree_by_inode(inode), &from, &to,
+				inode, 0);
 }
 
 static void release_all_pages(struct page **pages, unsigned nr_pages)
@@ -192,7 +193,7 @@ static int reserve_tail2extent_iteration
 	reiser4_block_nr unformatted_nodes;
 	reiser4_tree *tree;
 
-	tree = tree_by_inode(inode);
+	tree = reiser4_tree_by_inode(inode);
 
 	/* number of unformatted nodes which will be created */
 	unformatted_nodes = TAIL2EXTENT_PAGE_NUM;
@@ -231,7 +232,7 @@ static int complete_conversion(struct in
 	    reiser4_grab_space(inode_file_plugin(inode)->estimate.update(inode),
 			       BA_CAN_COMMIT);
 	if (result == 0) {
-		inode_clr_flag(inode, REISER4_PART_MIXED);
+		reiser4_inode_clr_flag(inode, REISER4_PART_MIXED);
 		result = reiser4_update_sd(inode);
 	}
 	if (result)
@@ -318,12 +319,12 @@ int tail2extent(unix_file_info_t *uf_inf
 	inode = unix_file_info_to_inode(uf_info);
 	assert("nikita-3412", !IS_RDONLY(inode));
 	assert("vs-1649", uf_info->container != UF_CONTAINER_EXTENTS);
-	assert("", !inode_get_flag(inode, REISER4_PART_IN_CONV));
+	assert("", !reiser4_inode_get_flag(inode, REISER4_PART_IN_CONV));
 
 	offset = 0;
 	first_iteration = 1;
 	result = 0;
-	if (inode_get_flag(inode, REISER4_PART_MIXED)) {
+	if (reiser4_inode_get_flag(inode, REISER4_PART_MIXED)) {
 		/*
 		 * file is marked on disk as there was a conversion which did
 		 * not complete due to either crash or some error. Find which
@@ -341,7 +342,7 @@ int tail2extent(unix_file_info_t *uf_inf
 		first_iteration = 0;
 	}
 
-	inode_set_flag(inode, REISER4_PART_IN_CONV);
+	reiser4_inode_set_flag(inode, REISER4_PART_IN_CONV);
 
 	/* get key of first byte of a file */
 	inode_file_plugin(inode)->key_by_inode(inode, offset, &key);
@@ -353,7 +354,7 @@ int tail2extent(unix_file_info_t *uf_inf
 		if (result != 0)
 			goto out;
 		if (first_iteration) {
-			inode_set_flag(inode, REISER4_PART_MIXED);
+			reiser4_inode_set_flag(inode, REISER4_PART_MIXED);
 			reiser4_update_sd(inode);
 			first_iteration = 0;
 		}
@@ -361,7 +362,7 @@ int tail2extent(unix_file_info_t *uf_inf
 		for (i = 0; i < sizeof_array(pages) && done == 0; i++) {
 			assert("vs-598",
 			       (get_key_offset(&key) & ~PAGE_CACHE_MASK) == 0);
-			page = alloc_page(get_gfp_mask());
+			page = alloc_page(reiser4_ctx_gfp_mask_get());
 			if (!page) {
 				result = RETERR(-ENOMEM);
 				goto error;
@@ -489,15 +490,17 @@ int tail2extent(unix_file_info_t *uf_inf
 			 * nobody is allowed to complete conversion but a
 			 * process which started it
 			 */
-			assert("", inode_get_flag(inode, REISER4_PART_MIXED));
+			assert("", reiser4_inode_get_flag(inode,
+							  REISER4_PART_MIXED));
 		}
 	}
 
-	inode_clr_flag(inode, REISER4_PART_IN_CONV);
+	reiser4_inode_clr_flag(inode, REISER4_PART_IN_CONV);
 
 	if (result == 0) {
 		/* file is converted to extent items */
-		assert("vs-1697", inode_get_flag(inode, REISER4_PART_MIXED));
+		assert("vs-1697", reiser4_inode_get_flag(inode,
+							 REISER4_PART_MIXED));
 
 		uf_info->container = UF_CONTAINER_EXTENTS;
 		complete_conversion(inode);
@@ -521,7 +524,7 @@ static int reserve_extent2tail_iteration
 {
 	reiser4_tree *tree;
 
-	tree = tree_by_inode(inode);
+	tree = reiser4_tree_by_inode(inode);
 	/*
 	 * reserve blocks for (in this order):
 	 *
@@ -564,10 +567,10 @@ int extent2tail(unix_file_info_t *uf_inf
 	inode = unix_file_info_to_inode(uf_info);
 	assert("nikita-3412", !IS_RDONLY(inode));
 	assert("vs-1649", uf_info->container != UF_CONTAINER_TAILS);
-	assert("", !inode_get_flag(inode, REISER4_PART_IN_CONV));
+	assert("", !reiser4_inode_get_flag(inode, REISER4_PART_IN_CONV));
 
 	offset = 0;
-	if (inode_get_flag(inode, REISER4_PART_MIXED)) {
+	if (reiser4_inode_get_flag(inode, REISER4_PART_MIXED)) {
 		/*
 		 * file is marked on disk as there was a conversion which did
 		 * not complete due to either crash or some error. Find which
@@ -584,7 +587,7 @@ int extent2tail(unix_file_info_t *uf_inf
 			return result;
 	}
 
-	inode_set_flag(inode, REISER4_PART_IN_CONV);
+	reiser4_inode_set_flag(inode, REISER4_PART_IN_CONV);
 
 	/* number of pages in the file */
 	num_pages =
@@ -602,7 +605,7 @@ int extent2tail(unix_file_info_t *uf_inf
 		if (result != 0)
 			break;
 		if (i == 0 && offset == 0) {
-			inode_set_flag(inode, REISER4_PART_MIXED);
+			reiser4_inode_set_flag(inode, REISER4_PART_MIXED);
 			reiser4_update_sd(inode);
 		}
 
@@ -626,12 +629,13 @@ int extent2tail(unix_file_info_t *uf_inf
 		set_key_offset(&from, start_byte);
 		set_key_offset(&to, start_byte + PAGE_CACHE_SIZE - 1);
 		/*
-		 * cut_tree_object() returns -E_REPEAT to allow atom
+		 * reiser4_cut_tree_object() returns -E_REPEAT to allow atom
 		 * commits during over-long truncates. But
 		 * extent->tail conversion should be performed in one
 		 * transaction.
 		 */
-		result = cut_tree(tree_by_inode(inode), &from, &to, inode, 0);
+		result = reiser4_cut_tree(reiser4_tree_by_inode(inode), &from,
+					  &to, inode, 0);
 
 		if (result) {
 			page_cache_release(page);
@@ -655,13 +659,14 @@ int extent2tail(unix_file_info_t *uf_inf
 			file.f_pos = start_byte;
 			file.private_data = NULL;
 			pos = start_byte;
-			result = write_tail(&file, (char __user *)kmap(page),
-					    count, &pos);
+			result = reiser4_write_tail(&file,
+						    (char __user *)kmap(page),
+						    count, &pos);
 			reiser4_free_file_fsdata(&file);
 			if (result <= 0) {
-				warning("", "write_tail failed");
+				warning("", "reiser4_write_tail failed");
 				page_cache_release(page);
-				inode_clr_flag(inode, REISER4_PART_IN_CONV);
+				reiser4_inode_clr_flag(inode, REISER4_PART_IN_CONV);
 				return result;
 			}
 			count -= result;
@@ -676,7 +681,7 @@ int extent2tail(unix_file_info_t *uf_inf
 		/* waiting for writeback completion with page lock held is
 		 * perfectly valid. */
 		wait_on_page_writeback(page);
-		drop_page(page);
+		reiser4_drop_page(page);
 		/* release reference taken by read_cache_page() above */
 		page_cache_release(page);
 
@@ -688,14 +693,15 @@ int extent2tail(unix_file_info_t *uf_inf
 		 * nobody is allowed to complete conversion but a process which
 		 * started it
 		 */
-		assert("", inode_get_flag(inode, REISER4_PART_MIXED));
+		assert("", reiser4_inode_get_flag(inode, REISER4_PART_MIXED));
 	}
 
-	inode_clr_flag(inode, REISER4_PART_IN_CONV);
+	reiser4_inode_clr_flag(inode, REISER4_PART_IN_CONV);
 
 	if (i == num_pages) {
 		/* file is converted to formatted items */
-		assert("vs-1698", inode_get_flag(inode, REISER4_PART_MIXED));
+		assert("vs-1698", reiser4_inode_get_flag(inode,
+							 REISER4_PART_MIXED));
 		assert("vs-1260",
 		       inode_has_no_jnodes(reiser4_inode_data(inode)));
 
diff -puN fs/reiser4/plugin/file_ops.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/file_ops.c
--- a/fs/reiser4/plugin/file_ops.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/file_ops.c
@@ -13,26 +13,26 @@
 /* implementation of vfs's llseek method of struct file_operations for
    typical directory can be found in readdir_common.c
 */
-loff_t llseek_common_dir(struct file *, loff_t, int origin);
+loff_t reiser4_llseek_dir_common(struct file *, loff_t, int origin);
 
 /* implementation of vfs's readdir method of struct file_operations for
    typical directory can be found in readdir_common.c
 */
-int readdir_common(struct file *, void *dirent, filldir_t);
+int reiser4_readdir_common(struct file *, void *dirent, filldir_t);
 
 /**
- * release_dir_common - release of struct file_operations
+ * reiser4_release_dir_common - release of struct file_operations
  * @inode: inode of released file
  * @file: file to release
  *
  * Implementation of release method of struct file_operations for typical
  * directory. All it does is freeing of reiser4 specific file data.
 */
-int release_dir_common(struct inode *inode, struct file *file)
+int reiser4_release_dir_common(struct inode *inode, struct file *file)
 {
 	reiser4_context *ctx;
 
-	ctx = init_context(inode->i_sb);
+	ctx = reiser4_init_context(inode->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 	reiser4_free_file_fsdata(file);
@@ -43,12 +43,12 @@ int release_dir_common(struct inode *ino
 /* this is common implementation of vfs's fsync method of struct
    file_operations
 */
-int sync_common(struct file *file, struct dentry *dentry, int datasync)
+int reiser4_sync_common(struct file *file, struct dentry *dentry, int datasync)
 {
 	reiser4_context *ctx;
 	int result;
 
-	ctx = init_context(dentry->d_inode->i_sb);
+	ctx = reiser4_init_context(dentry->d_inode->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 	result = txnmgr_force_commit_all(dentry->d_inode->i_sb, 0);
@@ -72,7 +72,7 @@ sendfile_common(struct file *file, loff_
 	reiser4_context *ctx;
 	ssize_t result;
 
-	ctx = init_context(file->f_dentry->d_inode->i_sb);
+	ctx = reiser4_init_context(file->f_dentry->d_inode->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 	result = generic_file_sendfile(file, ppos, count, actor, target);
@@ -93,7 +93,7 @@ prepare_write_common(struct file *file, 
 	reiser4_context *ctx;
 	int result;
 
-	ctx = init_context(page->mapping->host->i_sb);
+	ctx = reiser4_init_context(page->mapping->host->i_sb);
 	result = do_prepare_write(file, page, from, to);
 
 	/* don't commit transaction under inode semaphore */
@@ -163,5 +163,6 @@ do_prepare_write(struct file *file, stru
  * c-basic-offset: 8
  * tab-width: 8
  * fill-column: 79
+ * scroll-step: 1
  * End:
  */
diff -puN fs/reiser4/plugin/file_ops_readdir.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/file_ops_readdir.c
--- a/fs/reiser4/plugin/file_ops_readdir.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/file_ops_readdir.c
@@ -32,7 +32,7 @@ static cmp_t dir_pos_cmp(const dir_pos *
 }
 
 
-/* see comment before readdir_common() for overview of why "adjustment" is
+/* see comment before reiser4_readdir_common() for overview of why "adjustment" is
  * necessary. */
 static void
 adjust_dir_pos(struct file *dir,
@@ -60,7 +60,7 @@ adjust_dir_pos(struct file *dir,
 		 * changes */
 		readdir_spot->entry_no += adj;
 		assert("nikita-2577",
-		       ergo(dir != NULL, get_dir_fpos(dir) + adj >= 0));
+		       ergo(dir != NULL, reiser4_get_dir_fpos(dir) + adj >= 0));
 		if (de_id_cmp(&pos->dir_entry_key,
 			      &mod_point->dir_entry_key) == EQUAL_TO) {
 			assert("nikita-2575", mod_point->pos < pos->pos);
@@ -98,8 +98,8 @@ adjust_dir_pos(struct file *dir,
 /* scan all file-descriptors for this directory and adjust their
    positions respectively. Should be used by implementations of
    add_entry and rem_entry of dir plugin */
-void
-adjust_dir_file(struct inode *dir, const struct dentry *de, int offset, int adj)
+void reiser4_adjust_dir_file(struct inode *dir, const struct dentry *de,
+			     int offset, int adj)
 {
 	reiser4_file_fsdata *scan;
 	dir_pos mod_point;
@@ -140,13 +140,14 @@ static int dir_go_to(struct file *dir, r
 	result = inode_dir_plugin(inode)->build_readdir_key(dir, &key);
 	if (result != 0)
 		return result;
-	result = object_lookup(inode,
-			       &key,
-			       tap->coord,
-			       tap->lh,
-			       tap->mode,
-			       FIND_EXACT,
-			       LEAF_LEVEL, LEAF_LEVEL, 0, &tap->ra_info);
+	result = reiser4_object_lookup(inode,
+				       &key,
+				       tap->coord,
+				       tap->lh,
+				       tap->mode,
+				       FIND_EXACT,
+				       LEAF_LEVEL, LEAF_LEVEL,
+				       0, &tap->ra_info);
 	if (result == CBK_COORD_FOUND)
 		result = rewind_right(tap, (int)pos->position.pos);
 	else {
@@ -172,9 +173,9 @@ static int set_pos(struct inode *inode, 
 
 	coord_init_zero(&coord);
 	init_lh(&lh);
-	tap_init(&scan, &coord, &lh, ZNODE_READ_LOCK);
-	tap_copy(&scan, tap);
-	tap_load(&scan);
+	reiser4_tap_init(&scan, &coord, &lh, ZNODE_READ_LOCK);
+	reiser4_tap_copy(&scan, tap);
+	reiser4_tap_load(&scan);
 	pos->position.pos = 0;
 
 	did = &pos->position.dir_entry_key;
@@ -204,8 +205,8 @@ static int set_pos(struct inode *inode, 
 		}
 	} else
 		result = RETERR(-ENOENT);
-	tap_relse(&scan);
-	tap_done(&scan);
+	reiser4_tap_relse(&scan);
+	reiser4_tap_done(&scan);
 	return result;
 }
 
@@ -225,7 +226,7 @@ static int dir_rewind(struct file *dir, 
 	assert("nikita-2551", tap->coord != NULL);
 	assert("nikita-2552", tap->lh != NULL);
 
-	dirpos = get_dir_fpos(dir);
+	dirpos = reiser4_get_dir_fpos(dir);
 	shift = dirpos - pos->fpos;
 	/* this is logical directory entry within @dir which we are rewinding
 	 * to */
@@ -258,7 +259,7 @@ static int dir_rewind(struct file *dir, 
 				if (result == 0) {
 					result = rewind_left(tap, shift);
 					if (result == -E_DEADLOCK) {
-						tap_done(tap);
+						reiser4_tap_done(tap);
 						continue;
 					}
 				}
@@ -325,7 +326,8 @@ feed_entry(struct file *f,
 	   deadlock which may happen if filldir causes page fault. So, copy
 	   name to intermediate buffer */
 	if (strlen(name) + 1 > sizeof(name_buf)) {
-		local_name = kmalloc(strlen(name) + 1, get_gfp_mask());
+		local_name = kmalloc(strlen(name) + 1,
+				     reiser4_ctx_gfp_mask_get());
 		if (local_name == NULL)
 			return RETERR(-ENOMEM);
 	} else
@@ -335,7 +337,7 @@ feed_entry(struct file *f,
 	file_type = iplug->s.dir.extract_file_type(coord);
 
 	unit_key_by_coord(coord, &entry_key);
-	seal_init(&seal, coord, &entry_key);
+	reiser4_seal_init(&seal, coord, &entry_key);
 
 	longterm_unlock_znode(tap->lh);
 
@@ -349,7 +351,7 @@ feed_entry(struct file *f,
 	 */
 	assert("nikita-3436", lock_stack_isclean(get_current_lock_stack()));
 
-	txn_restart_current();
+	reiser4_txn_restart_current();
 	result = filldir(dirent, name, (int)strlen(name),
 			 /* offset of this entry */
 			 f->f_pos,
@@ -361,8 +363,9 @@ feed_entry(struct file *f,
 		/* ->filldir() is satisfied. (no space in buffer, IOW) */
 		result = 1;
 	else
-		result = seal_validate(&seal, coord, &entry_key,
-				       tap->lh, tap->mode, ZNODE_LOCK_HIPRI);
+		result = reiser4_seal_validate(&seal, coord, &entry_key,
+					       tap->lh, tap->mode,
+					       ZNODE_LOCK_HIPRI);
 	return result;
 }
 
@@ -394,8 +397,8 @@ static void move_entry(readdir_pos * pos
  *
  * readdir support in reiser4 relies on ability to update readdir_pos embedded
  * into reiser4_file_fsdata on each directory modification (name insertion and
- * removal), see readdir_common() function below. This obviously doesn't work
- * when reiser4 is accessed over NFS, because NFS doesn't keep any state
+ * removal), see reiser4_readdir_common() function below. This obviously doesn't
+ * work when reiser4 is accessed over NFS, because NFS doesn't keep any state
  * across client READDIR requests for the same directory.
  *
  * To address this we maintain a "pool" of detached reiser4_file_fsdata
@@ -445,7 +448,7 @@ static int dir_readdir_init(struct file 
 		return RETERR(-ENOTDIR);
 
 	/* try to find detached readdir state */
-	result = try_to_attach_fsdata(f, inode);
+	result = reiser4_attach_fsdata(f, inode);
 	if (result != 0)
 		return result;
 
@@ -469,9 +472,9 @@ static int dir_readdir_init(struct file 
 
 /* this is implementation of vfs's llseek method of struct file_operations for
    typical directory
-   See comment before readdir_common() for explanation.
+   See comment before reiser4_readdir_common() for explanation.
 */
-loff_t llseek_common_dir(struct file * file, loff_t off, int origin)
+loff_t reiser4_llseek_dir_common(struct file * file, loff_t off, int origin)
 {
 	reiser4_context *ctx;
 	loff_t result;
@@ -479,7 +482,7 @@ loff_t llseek_common_dir(struct file * f
 
 	inode = file->f_dentry->d_inode;
 
-	ctx = init_context(inode->i_sb);
+	ctx = reiser4_init_context(inode->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
@@ -496,15 +499,15 @@ loff_t llseek_common_dir(struct file * f
 
 		coord_init_zero(&coord);
 		init_lh(&lh);
-		tap_init(&tap, &coord, &lh, ZNODE_READ_LOCK);
+		reiser4_tap_init(&tap, &coord, &lh, ZNODE_READ_LOCK);
 
 		ff = dir_readdir_init(file, &tap, &pos);
-		detach_fsdata(file);
+		reiser4_detach_fsdata(file);
 		if (ff != 0)
 			result = (loff_t) ff;
-		tap_done(&tap);
+		reiser4_tap_done(&tap);
 	}
-	detach_fsdata(file);
+	reiser4_detach_fsdata(file);
 	mutex_unlock(&inode->i_mutex);
 
 	reiser4_exit_context(ctx);
@@ -554,9 +557,10 @@ loff_t llseek_common_dir(struct file * f
    entry all file descriptors for directory inode are scanned and their
    readdir_pos are updated accordingly (adjust_dir_pos()).
 */
-int readdir_common(struct file *f /* directory file being read */ ,
-		   void *dirent /* opaque data passed to us by VFS */ ,
-		   filldir_t filld /* filler function passed to us by VFS */ )
+int reiser4_readdir_common(struct file *f /* directory file being read */,
+			   void *dirent /* opaque data passed to us by VFS */,
+			   filldir_t filld /* filler function passed to us
+					    * by VFS */)
 {
 	reiser4_context *ctx;
 	int result;
@@ -573,20 +577,20 @@ int readdir_common(struct file *f /* dir
 	if (!S_ISDIR(inode->i_mode))
 		return RETERR(-ENOTDIR);
 
-	ctx = init_context(inode->i_sb);
+	ctx = reiser4_init_context(inode->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
 	coord_init_zero(&coord);
 	init_lh(&lh);
-	tap_init(&tap, &coord, &lh, ZNODE_READ_LOCK);
+	reiser4_tap_init(&tap, &coord, &lh, ZNODE_READ_LOCK);
 
 	reiser4_readdir_readahead_init(inode, &tap);
 
       repeat:
 	result = dir_readdir_init(f, &tap, &pos);
 	if (result == 0) {
-		result = tap_load(&tap);
+		result = reiser4_tap_load(&tap);
 		/* scan entries one by one feeding them to @filld */
 		while (result == 0) {
 			coord_t *coord;
@@ -614,21 +618,21 @@ int readdir_common(struct file *f /* dir
 			} else if (result == -E_REPEAT) {
 				/* feed_entry() had to restart. */
 				++f->f_pos;
-				tap_relse(&tap);
+				reiser4_tap_relse(&tap);
 				goto repeat;
 			} else
 				warning("vs-1617",
-					"readdir_common: unexpected error %d",
+					"reiser4_readdir_common: unexpected error %d",
 					result);
 		}
-		tap_relse(&tap);
+		reiser4_tap_relse(&tap);
 
 		if (result >= 0)
 			f->f_version = inode->i_version;
 	} else if (result == -E_NO_NEIGHBOR || result == -ENOENT)
 		result = 0;
-	tap_done(&tap);
-	detach_fsdata(f);
+	reiser4_tap_done(&tap);
+	reiser4_detach_fsdata(f);
 
 	/* try to update directory's atime */
 	if (reiser4_grab_space_force(inode_file_plugin(inode)->estimate.update(inode),
diff -puN fs/reiser4/plugin/file_plugin_common.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/file_plugin_common.c
--- a/fs/reiser4/plugin/file_plugin_common.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/file_plugin_common.c
@@ -23,7 +23,7 @@ int write_sd_by_inode_common(struct inod
 
 	assert("nikita-730", inode != NULL);
 
-	if (inode_get_flag(inode, REISER4_NO_SD))
+	if (reiser4_inode_get_flag(inode, REISER4_NO_SD))
 		/* object doesn't have stat-data yet */
 		result = insert_new_sd(inode);
 	else
@@ -78,7 +78,7 @@ int set_plug_in_inode_common(struct inod
 		object->i_gid = current->fsgid;
 
 	/* this object doesn't have stat-data yet */
-	inode_set_flag(object, REISER4_NO_SD);
+	reiser4_inode_set_flag(object, REISER4_NO_SD);
 #if 0
 	/* this is now called after all inode plugins are initialized:
 	   do_create_vfs_child after adjust_to_parent */
@@ -86,7 +86,7 @@ int set_plug_in_inode_common(struct inod
 	setup_inode_ops(object, data);
 #endif
 	object->i_nlink = 0;
-	seal_init(&reiser4_inode_data(object)->sd_seal, NULL, NULL);
+	reiser4_seal_init(&reiser4_inode_data(object)->sd_seal, NULL, NULL);
 	mask = (1 << UNIX_STAT) | (1 << LIGHT_WEIGHT_STAT);
 	if (!reiser4_is_set(object->i_sb, REISER4_32_BIT_TIMES))
 		mask |= (1 << LARGE_TIMES_STAT);
@@ -165,15 +165,14 @@ int adjust_to_parent_cryptcompress(struc
 
 /* this is common implementation of create_object method of file plugin
  */
-int
-create_object_common(struct inode *object, struct inode *parent UNUSED_ARG,
-		     reiser4_object_create_data * data UNUSED_ARG)
+int reiser4_create_object_common(struct inode *object, struct inode *parent,
+				 reiser4_object_create_data * data)
 {
 	reiser4_block_nr reserve;
 	assert("nikita-744", object != NULL);
 	assert("nikita-745", parent != NULL);
 	assert("nikita-747", data != NULL);
-	assert("nikita-748", inode_get_flag(object, REISER4_NO_SD));
+	assert("nikita-748", reiser4_inode_get_flag(object, REISER4_NO_SD));
 
 	reserve = estimate_create_common(object);
 	if (reiser4_grab_space(reserve, BA_CAN_COMMIT))
@@ -184,14 +183,14 @@ create_object_common(struct inode *objec
 static int common_object_delete_no_reserve(struct inode *inode);
 
 /**
- * delete_object_common - delete_object of file_plugin
+ * reiser4_delete_object_common - delete_object of file_plugin
  * @inode: inode to be deleted
  *
  * This is common implementation of delete_object method of file_plugin. It
  * applies to object its deletion consists of removing two items - stat data
  * and safe-link.
  */
-int delete_object_common(struct inode *inode)
+int reiser4_delete_object_common(struct inode *inode)
 {
 	int result;
 
@@ -202,12 +201,13 @@ int delete_object_common(struct inode *i
 	assert("nikita-3421", inode->i_nlink == 0);
 
 
-	if (!inode_get_flag(inode, REISER4_NO_SD)) {
+	if (!reiser4_inode_get_flag(inode, REISER4_NO_SD)) {
 		reiser4_block_nr reserve;
 
 		/* grab space which is needed to remove 2 items from the tree:
 		   stat data and safe-link */
-		reserve = 2 * estimate_one_item_removal(tree_by_inode(inode));
+		reserve = 2 *
+		  estimate_one_item_removal(reiser4_tree_by_inode(inode));
 		if (reiser4_grab_space_force(reserve,
 					     BA_RESERVED | BA_CAN_COMMIT))
 			return RETERR(-ENOSPC);
@@ -218,14 +218,14 @@ int delete_object_common(struct inode *i
 }
 
 /**
- * delete_directory_common - delete_object of file_plugin
+ * reiser4_delete_dir_common - delete_object of file_plugin
  * @inode: inode to be deleted
  *
  * This is common implementation of delete_object method of file_plugin for
  * typical directory. It calls done method of dir_plugin to remove "." and
  * removes stat data and safe-link.
  */
-int delete_directory_common(struct inode *inode)
+int reiser4_delete_dir_common(struct inode *inode)
 {
 	int result;
 	dir_plugin *dplug;
@@ -237,11 +237,11 @@ int delete_directory_common(struct inode
 	assert("vs-1101", dplug && dplug->done);
 
 	/* kill cursors which might be attached to inode */
-	kill_cursors(inode);
+	reiser4_kill_cursors(inode);
 
 	/* grab space enough for removing two items */
 	if (reiser4_grab_space
-	    (2 * estimate_one_item_removal(tree_by_inode(inode)),
+	    (2 * estimate_one_item_removal(reiser4_tree_by_inode(inode)),
 	     BA_RESERVED | BA_CAN_COMMIT))
 		return RETERR(-ENOSPC);
 
@@ -253,7 +253,7 @@ int delete_directory_common(struct inode
 
 /* this is common implementation of add_link method of file plugin
  */
-int add_link_common(struct inode *object, struct inode *parent UNUSED_ARG)
+int reiser4_add_link_common(struct inode *object, struct inode *parent)
 {
 	/*
 	 * increment ->i_nlink and update ->i_ctime
@@ -266,7 +266,7 @@ int add_link_common(struct inode *object
 
 /* this is common implementation of rem_link method of file plugin
  */
-int rem_link_common(struct inode *object, struct inode *parent UNUSED_ARG)
+int reiser4_rem_link_common(struct inode *object, struct inode *parent)
 {
 	assert("nikita-2021", object != NULL);
 	assert("nikita-2163", object->i_nlink > 0);
@@ -357,7 +357,7 @@ int can_rem_link_common_dir(const struct
 /* this is common implementation of detach method of file plugin for typical
    directory
 */
-int detach_common_dir(struct inode *child, struct inode *parent)
+int reiser4_detach_common_dir(struct inode *child, struct inode *parent)
 {
 	dir_plugin *dplug;
 
@@ -370,7 +370,7 @@ int detach_common_dir(struct inode *chil
 /* this is common implementation of bind method of file plugin for typical
    directory
 */
-int bind_common_dir(struct inode *child, struct inode *parent)
+int reiser4_bind_common_dir(struct inode *child, struct inode *parent)
 {
 	dir_plugin *dplug;
 
@@ -407,7 +407,7 @@ int safelink_common(struct inode *object
 */
 reiser4_block_nr estimate_create_common(const struct inode * object)
 {
-	return estimate_one_insert_item(tree_by_inode(object));
+	return estimate_one_insert_item(reiser4_tree_by_inode(object));
 }
 
 /* this is common implementation of estimate.create method of file plugin for
@@ -417,7 +417,7 @@ reiser4_block_nr estimate_create_common(
 */
 reiser4_block_nr estimate_create_common_dir(const struct inode * object)
 {
-	return 2 * estimate_one_insert_item(tree_by_inode(object));
+	return 2 * estimate_one_insert_item(reiser4_tree_by_inode(object));
 }
 
 /* this is common implementation of estimate.update method of file plugin
@@ -426,7 +426,7 @@ reiser4_block_nr estimate_create_common_
 */
 reiser4_block_nr estimate_update_common(const struct inode * inode)
 {
-	return estimate_one_insert_into_item(tree_by_inode(inode));
+	return estimate_one_insert_into_item(reiser4_tree_by_inode(inode));
 }
 
 /* this is common implementation of estimate.unlink method of file plugin
@@ -511,7 +511,7 @@ static void key_warning(const reiser4_ke
 	if (code != -ENOMEM) {
 		warning("nikita-717", "Error for inode %llu (%i)",
 			(unsigned long long)get_key_objectid(key), code);
-		print_key("for key", key);
+		reiser4_print_key("for key", key);
 	}
 }
 
@@ -543,7 +543,7 @@ static void check_sd_coord(coord_t * coo
 	    (znode_get_level(coord->node) != LEAF_LEVEL) ||
 	    !item_is_statdata(coord)) {
 		warning("nikita-1901", "Conspicuous seal");
-		print_key("key", key);
+		reiser4_print_key("key", key);
 		print_coord("coord", coord, 1);
 		impossible("nikita-2877", "no way");
 	}
@@ -569,7 +569,7 @@ static int insert_new_sd(struct inode *i
 	oid_t oid;
 
 	assert("nikita-723", inode != NULL);
-	assert("nikita-3406", inode_get_flag(inode, REISER4_NO_SD));
+	assert("nikita-3406", reiser4_inode_get_flag(inode, REISER4_NO_SD));
 
 	ref = reiser4_inode_data(inode);
 	spin_lock_inode(inode);
@@ -590,7 +590,7 @@ static int insert_new_sd(struct inode *i
 /* could be optimized for case where there is only one node format in
  * use in the filesystem, probably there are lots of such
  * places we could optimize for only one node layout.... -Hans */
-	if (data.length > tree_by_inode(inode)->nplug->max_item_size()) {
+	if (data.length > reiser4_tree_by_inode(inode)->nplug->max_item_size()){
 		/* This is silly check, but we don't know actual node where
 		   insertion will go into. */
 		return RETERR(-ENAMETOOLONG);
@@ -605,7 +605,7 @@ static int insert_new_sd(struct inode *i
 	coord_init_zero(&coord);
 	init_lh(&lh);
 
-	result = insert_by_key(tree_by_inode(inode),
+	result = insert_by_key(reiser4_tree_by_inode(inode),
 			       build_sd_key(inode, &key), &data, &coord, &lh,
 			       /* stat data lives on a leaf level */
 			       LEAF_LEVEL, CBK_UNIQUE);
@@ -642,10 +642,10 @@ static int insert_new_sd(struct inode *i
 			znode_make_dirty(coord.node);
 			if (result == 0) {
 				/* object has stat-data now */
-				inode_clr_flag(inode, REISER4_NO_SD);
-				inode_set_flag(inode, REISER4_SDLEN_KNOWN);
+				reiser4_inode_clr_flag(inode, REISER4_NO_SD);
+				reiser4_inode_set_flag(inode, REISER4_SDLEN_KNOWN);
 				/* initialise stat-data seal */
-				seal_init(&ref->sd_seal, &coord, &key);
+				reiser4_seal_init(&ref->sd_seal, &coord, &key);
 				ref->sd_coord = coord;
 				check_inode_seal(inode, &coord, &key);
 			} else if (result != -ENOMEM)
@@ -694,7 +694,7 @@ int lookup_sd(struct inode *inode /* ino
 	 * it only covers _body_ of the file, and stat data don't belong
 	 * there.
 	 */
-	result = coord_by_key(tree_by_inode(inode),
+	result = coord_by_key(reiser4_tree_by_inode(inode),
 			      key,
 			      coord,
 			      lh,
@@ -726,12 +726,13 @@ locate_inode_sd(struct inode *inode,
 	spin_unlock_inode(inode);
 
 	build_sd_key(inode, key);
-	if (seal_is_set(&seal)) {
+	if (reiser4_seal_is_set(&seal)) {
 		/* first, try to use seal */
-		result = seal_validate(&seal,
-				       coord,
-				       key,
-				       lh, ZNODE_WRITE_LOCK, ZNODE_LOCK_LOPRI);
+		result = reiser4_seal_validate(&seal,
+					       coord,
+					       key,
+					       lh, ZNODE_WRITE_LOCK,
+					       ZNODE_LOCK_LOPRI);
 		if (result == 0)
 			check_sd_coord(coord, key);
 	} else
@@ -774,12 +775,12 @@ update_sd_at(struct inode *inode, coord_
 
 	/* data.length is how much space to add to (or remove
 	   from if negative) sd */
-	if (!inode_get_flag(inode, REISER4_SDLEN_KNOWN)) {
+	if (!reiser4_inode_get_flag(inode, REISER4_SDLEN_KNOWN)) {
 		/* recalculate stat-data length */
 		data.length =
 		    data.iplug->s.sd.save_len(inode) -
 		    item_length_by_coord(coord);
-		inode_set_flag(inode, REISER4_SDLEN_KNOWN);
+		reiser4_inode_set_flag(inode, REISER4_SDLEN_KNOWN);
 	} else
 		data.length = 0;
 	spin_unlock_inode(inode);
@@ -793,15 +794,16 @@ update_sd_at(struct inode *inode, coord_
 		/* insertion code requires that insertion point (coord) was
 		 * between units. */
 		coord->between = AFTER_UNIT;
-		result = resize_item(coord,
-				     &data, key, lh, COPI_DONT_SHIFT_LEFT);
+		result = reiser4_resize_item(coord, &data, key, lh,
+					     COPI_DONT_SHIFT_LEFT);
 		if (result != 0) {
 			key_warning(key, inode, result);
 			zrelse(loaded);
 			return result;
 		}
 		if (loaded != coord->node) {
-			/* resize_item moved coord to another node. Zload it */
+		  /* reiser4_resize_item moved coord to another node.
+		     Zload it */
 			zrelse(loaded);
 			coord_clear_iplug(coord);
 			result = zload(coord->node);
@@ -823,7 +825,7 @@ update_sd_at(struct inode *inode, coord_
 	 * was changed and new extensions were pasted into item.
 	 */
 	coord->between = AT_UNIT;
-	seal_init(&state->sd_seal, coord, key);
+	reiser4_seal_init(&state->sd_seal, coord, key);
 	state->sd_coord = *coord;
 	spin_unlock_inode(inode);
 	check_inode_seal(inode, coord, key);
@@ -843,7 +845,7 @@ static int update_sd(struct inode *inode
 	assert("nikita-726", inode != NULL);
 
 	/* no stat-data, nothing to update?! */
-	assert("nikita-3482", !inode_get_flag(inode, REISER4_NO_SD));
+	assert("nikita-3482", !reiser4_inode_get_flag(inode, REISER4_NO_SD));
 
 	init_lh(&lh);
 
@@ -855,8 +857,8 @@ static int update_sd(struct inode *inode
 	return result;
 }
 
-/* helper for delete_object_common and delete_directory_common. Remove object
-   stat data. Space for that must be reserved by caller before
+/* helper for reiser4_delete_object_common and reiser4_delete_dir_common.
+   Remove object stat data. Space for that must be reserved by caller before
 */
 static int
 common_object_delete_no_reserve(struct inode *inode /* object to remove */ )
@@ -865,7 +867,7 @@ common_object_delete_no_reserve(struct i
 
 	assert("nikita-1477", inode != NULL);
 
-	if (!inode_get_flag(inode, REISER4_NO_SD)) {
+	if (!reiser4_inode_get_flag(inode, REISER4_NO_SD)) {
 		reiser4_key sd_key;
 
 		DQUOT_FREE_INODE(inode);
@@ -873,14 +875,15 @@ common_object_delete_no_reserve(struct i
 
 		build_sd_key(inode, &sd_key);
 		result =
-		    cut_tree(tree_by_inode(inode), &sd_key, &sd_key, NULL, 0);
+		    reiser4_cut_tree(reiser4_tree_by_inode(inode),
+				     &sd_key, &sd_key, NULL, 0);
 		if (result == 0) {
-			inode_set_flag(inode, REISER4_NO_SD);
+			reiser4_inode_set_flag(inode, REISER4_NO_SD);
 			result = oid_release(inode->i_sb, get_inode_oid(inode));
 			if (result == 0) {
 				oid_count_released();
 
-				result = safe_link_del(tree_by_inode(inode),
+				result = safe_link_del(reiser4_tree_by_inode(inode),
 						       get_inode_oid(inode),
 						       SAFE_UNLINK);
 			}
@@ -900,7 +903,7 @@ static int process_truncate(struct inode
 	struct dentry dentry;
 
 	assert("vs-21", is_in_reiser4_context());
-	ctx = init_context(inode->i_sb);
+	ctx = reiser4_init_context(inode->i_sb);
 	assert("vs-22", !IS_ERR(ctx));
 
 	attr.ia_size = size;
@@ -919,11 +922,13 @@ static int process_truncate(struct inode
 	return result;
 }
 
-/* Local variables:
-   c-indentation-style: "K&R"
-   mode-name: "LC"
-   c-basic-offset: 8
-   tab-width: 8
-   fill-column: 120
-   End:
+/*
+  Local variables:
+  c-indentation-style: "K&R"
+  mode-name: "LC"
+  c-basic-offset: 8
+  tab-width: 8
+  fill-column: 80
+  scroll-step: 1
+  End:
 */
diff -puN fs/reiser4/plugin/inode_ops.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/inode_ops.c
--- a/fs/reiser4/plugin/inode_ops.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/inode_ops.c
@@ -18,7 +18,7 @@ static int create_vfs_object(struct inod
 		      reiser4_object_create_data *data);
 
 /**
- * create_common - create of inode operations
+ * reiser4_create_common - create of inode operations
  * @parent: inode of parent directory
  * @dentry: dentry of new object to create
  * @mode: the permissions to use
@@ -28,8 +28,8 @@ static int create_vfs_object(struct inod
  * inode_operations.
  * Creates regular file using file plugin from parent directory plugin set.
  */
-int create_common(struct inode *parent, struct dentry *dentry,
-		  int mode, struct nameidata *nameidata)
+int reiser4_create_common(struct inode *parent, struct dentry *dentry,
+			  int mode, struct nameidata *nameidata)
 {
 	reiser4_object_create_data data;
 
@@ -39,11 +39,11 @@ int create_common(struct inode *parent, 
 	return create_vfs_object(parent, dentry, &data);
 }
 
-int lookup_name(struct inode *dir, struct dentry *, reiser4_key *);
+int reiser4_lookup_name(struct inode *dir, struct dentry *, reiser4_key *);
 void check_light_weight(struct inode *inode, struct inode *parent);
 
 /**
- * lookup_common - lookup of inode operations
+ * reiser4_lookup_common - lookup of inode operations
  * @parent: inode of directory to lookup into
  * @dentry: name to look for
  * @nameidata:
@@ -51,8 +51,9 @@ void check_light_weight(struct inode *in
  * This is common implementation of vfs's lookup method of struct
  * inode_operations.
  */
-struct dentry *lookup_common(struct inode *parent, struct dentry *dentry,
-			     struct nameidata *nameidata)
+struct dentry *reiser4_lookup_common(struct inode *parent,
+				     struct dentry *dentry,
+				     struct nameidata *nameidata)
 {
 	reiser4_context *ctx;
 	int result;
@@ -60,14 +61,14 @@ struct dentry *lookup_common(struct inod
 	struct inode *inode;
 	reiser4_dir_entry_desc entry;
 
-	ctx = init_context(parent->i_sb);
+	ctx = reiser4_init_context(parent->i_sb);
 	if (IS_ERR(ctx))
 		return (struct dentry *)ctx;
 
 	/* set up operations on dentry. */
 	dentry->d_op = &get_super_private(parent->i_sb)->ops.dentry;
 
-	result = lookup_name(parent, dentry, &entry.key);
+	result = reiser4_lookup_name(parent, dentry, &entry.key);
 	if (result) {
 		context_set_commit_async(ctx);
 		reiser4_exit_context(ctx);
@@ -104,7 +105,7 @@ static reiser4_block_nr common_estimate_
 int reiser4_update_dir(struct inode *);
 
 /**
- * link_common - link of inode operations
+ * reiser4_link_common - link of inode operations
  * @existing: dentry of object which is to get new name
  * @parent: directory where new name is to be created
  * @newname: new name
@@ -112,8 +113,8 @@ int reiser4_update_dir(struct inode *);
  * This is common implementation of vfs's link method of struct
  * inode_operations.
  */
-int link_common(struct dentry *existing, struct inode *parent,
-		struct dentry *newname)
+int reiser4_link_common(struct dentry *existing, struct inode *parent,
+			struct dentry *newname)
 {
 	reiser4_context *ctx;
 	int result;
@@ -123,7 +124,7 @@ int link_common(struct dentry *existing,
 	reiser4_object_create_data data;
 	reiser4_block_nr reserve;
 
-	ctx = init_context(parent->i_sb);
+	ctx = reiser4_init_context(parent->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
@@ -135,7 +136,7 @@ int link_common(struct dentry *existing,
 	assert("nikita-1434", object != NULL);
 
 	/* check for race with create_object() */
-	if (inode_get_flag(object, REISER4_IMMUTABLE)) {
+	if (reiser4_inode_get_flag(object, REISER4_IMMUTABLE)) {
 		context_set_commit_async(ctx);
 		reiser4_exit_context(ctx);
 		return RETERR(-E_REPEAT);
@@ -171,7 +172,7 @@ int link_common(struct dentry *existing,
 	 * reiser4_unlink() viz. creation of safe-link.
 	 */
 	if (unlikely(object->i_nlink == 0)) {
-		result = safe_link_del(tree_by_inode(object),
+		result = safe_link_del(reiser4_tree_by_inode(object),
 				       get_inode_oid(object), SAFE_UNLINK);
 		if (result != 0) {
 			context_set_commit_async(ctx);
@@ -218,21 +219,21 @@ int link_common(struct dentry *existing,
 static int unlink_check_and_grab(struct inode *parent, struct dentry *victim);
 
 /**
- * unlink_common - unlink of inode operations
+ * reiser4_unlink_common - unlink of inode operations
  * @parent: inode of directory to remove name from
  * @victim: name to be removed
  *
  * This is common implementation of vfs's unlink method of struct
  * inode_operations.
  */
-int unlink_common(struct inode *parent, struct dentry *victim)
+int reiser4_unlink_common(struct inode *parent, struct dentry *victim)
 {
 	reiser4_context *ctx;
 	int result;
 	struct inode *object;
 	file_plugin *fplug;
 
-	ctx = init_context(parent->i_sb);
+	ctx = reiser4_init_context(parent->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
@@ -313,7 +314,7 @@ int unlink_common(struct inode *parent, 
 }
 
 /**
- * symlink_common - symlink of inode operations
+ * reiser4_symlink_common - symlink of inode operations
  * @parent: inode of parent directory
  * @dentry: dentry of object to be created
  * @linkname: string symlink is to contain
@@ -322,8 +323,8 @@ int unlink_common(struct inode *parent, 
  * inode_operations.
  * Creates object using file plugin SYMLINK_FILE_PLUGIN_ID.
  */
-int symlink_common(struct inode *parent, struct dentry *dentry,
-		   const char *linkname)
+int reiser4_symlink_common(struct inode *parent, struct dentry *dentry,
+			   const char *linkname)
 {
 	reiser4_object_create_data data;
 
@@ -335,7 +336,7 @@ int symlink_common(struct inode *parent,
 }
 
 /**
- * mkdir_common - mkdir of inode operations
+ * reiser4_mkdir_common - mkdir of inode operations
  * @parent: inode of parent directory
  * @dentry: dentry of object to be created
  * @mode: the permissions to use
@@ -344,7 +345,7 @@ int symlink_common(struct inode *parent,
  * inode_operations.
  * Creates object using file plugin DIRECTORY_FILE_PLUGIN_ID.
  */
-int mkdir_common(struct inode *parent, struct dentry *dentry, int mode)
+int reiser4_mkdir_common(struct inode *parent, struct dentry *dentry, int mode)
 {
 	reiser4_object_create_data data;
 
@@ -355,7 +356,7 @@ int mkdir_common(struct inode *parent, s
 }
 
 /**
- * mknod_common - mknod of inode operations
+ * reiser4_mknod_common - mknod of inode operations
  * @parent: inode of parent directory
  * @dentry: dentry of object to be created
  * @mode: the permissions to use and file type
@@ -365,8 +366,8 @@ int mkdir_common(struct inode *parent, s
  * inode_operations.
  * Creates object using file plugin SPECIAL_FILE_PLUGIN_ID.
  */
-int mknod_common(struct inode *parent, struct dentry *dentry,
-		 int mode, dev_t rdev)
+int reiser4_mknod_common(struct inode *parent, struct dentry *dentry,
+			 int mode, dev_t rdev)
 {
 	reiser4_object_create_data data;
 
@@ -383,7 +384,7 @@ int mknod_common(struct inode *parent, s
  */
 
 /**
- * follow_link_common - follow_link of inode operations
+ * reiser4_follow_link_common - follow_link of inode operations
  * @dentry: dentry of symlink
  * @data:
  *
@@ -391,27 +392,28 @@ int mknod_common(struct inode *parent, s
  * inode_operations.
  * Assumes that inode's i_private points to the content of symbolic link.
  */
-void *follow_link_common(struct dentry *dentry, struct nameidata *nd)
+void *reiser4_follow_link_common(struct dentry *dentry, struct nameidata *nd)
 {
 	assert("vs-851", S_ISLNK(dentry->d_inode->i_mode));
 
 	if (!dentry->d_inode->i_private
-	    || !inode_get_flag(dentry->d_inode, REISER4_GENERIC_PTR_USED))
+	    || !reiser4_inode_get_flag(dentry->d_inode,
+				       REISER4_GENERIC_PTR_USED))
 		return ERR_PTR(RETERR(-EINVAL));
 	nd_set_link(nd, dentry->d_inode->i_private);
 	return NULL;
 }
 
 /**
- * permission_common - permission of inode operations
+ * reiser4_permission_common - permission of inode operations
  * @inode: inode to check permissions for
  * @mask: mode bits to check permissions for
  * @nameidata:
  *
  * Uses generic function to check for rwx permissions.
  */
-int permission_common(struct inode *inode, int mask,
-		      struct nameidata *nameidata)
+int reiser4_permission_common(struct inode *inode, int mask,
+			      struct nameidata *nameidata)
 {
 	return generic_permission(inode, mask, NULL);
 }
@@ -421,7 +423,7 @@ static int setattr_reserve(reiser4_tree 
 /* this is common implementation of vfs's setattr method of struct
    inode_operations
 */
-int setattr_common(struct dentry *dentry, struct iattr *attr)
+int reiser4_setattr_common(struct dentry *dentry, struct iattr *attr)
 {
 	reiser4_context *ctx;
 	struct inode *inode;
@@ -432,7 +434,7 @@ int setattr_common(struct dentry *dentry
 	if (result)
 		return result;
 
-	ctx = init_context(inode->i_sb);
+	ctx = reiser4_init_context(inode->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
@@ -441,7 +443,7 @@ int setattr_common(struct dentry *dentry
 	/*
 	 * grab disk space and call standard inode_setattr().
 	 */
-	result = setattr_reserve(tree_by_inode(inode));
+	result = setattr_reserve(reiser4_tree_by_inode(inode));
 	if (!result) {
 		if ((attr->ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid)
 		    || (attr->ia_valid & ATTR_GID
@@ -466,9 +468,8 @@ int setattr_common(struct dentry *dentry
 /* this is common implementation of vfs's getattr method of struct
    inode_operations
 */
-int
-getattr_common(struct vfsmount *mnt UNUSED_ARG, struct dentry *dentry,
-	       struct kstat *stat)
+int reiser4_getattr_common(struct vfsmount *mnt UNUSED_ARG,
+			   struct dentry *dentry, struct kstat *stat)
 {
 	struct inode *obj;
 
@@ -664,19 +665,19 @@ static int do_create_vfs_child(reiser4_o
 	   crash. This all only matters if it's possible to access file
 	   without name, for example, by inode number
 	 */
-	inode_set_flag(object, REISER4_IMMUTABLE);
+	reiser4_inode_set_flag(object, REISER4_IMMUTABLE);
 
 	/* create empty object, this includes allocation of new objectid. For
 	   directories this implies creation of dot and dotdot  */
-	assert("nikita-2265", inode_get_flag(object, REISER4_NO_SD));
+	assert("nikita-2265", reiser4_inode_get_flag(object, REISER4_NO_SD));
 
 	/* mark inode as `loaded'. From this point onward
 	   reiser4_delete_inode() will try to remove its stat-data. */
-	inode_set_flag(object, REISER4_LOADED);
+	reiser4_inode_set_flag(object, REISER4_LOADED);
 
 	result = obj_plug->create_object(object, parent, data);
 	if (result != 0) {
-		inode_clr_flag(object, REISER4_IMMUTABLE);
+		reiser4_inode_clr_flag(object, REISER4_IMMUTABLE);
 		if (result != -ENAMETOOLONG && result != -ENOMEM)
 			warning("nikita-2219",
 				"Failed to create sd for %llu",
@@ -689,7 +690,8 @@ static int do_create_vfs_child(reiser4_o
 	if (obj_dir != NULL)
 		result = obj_dir->init(object, parent, data);
 	if (result == 0) {
-		assert("nikita-434", !inode_get_flag(object, REISER4_NO_SD));
+		assert("nikita-434", !reiser4_inode_get_flag(object,
+							     REISER4_NO_SD));
 		/* insert inode into VFS hash table */
 		insert_inode_hash(object);
 		/* create entry */
@@ -733,7 +735,7 @@ static int do_create_vfs_child(reiser4_o
 	}
 
 	/* file has name now, clear immutable flag */
-	inode_clr_flag(object, REISER4_IMMUTABLE);
+	reiser4_inode_clr_flag(object, REISER4_IMMUTABLE);
 
 	/* on error, iput() will call ->delete_inode(). We should keep track
 	   of the existence of stat-data for this inode and avoid attempt to
@@ -754,7 +756,7 @@ create_vfs_object(struct inode *parent,
 	int result;
 	struct inode *child;
 
-	ctx = init_context(parent->i_sb);
+	ctx = reiser4_init_context(parent->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 	context_set_commit_async(ctx);
@@ -802,7 +804,7 @@ static reiser4_block_nr common_estimate_
 	/* update_dir(parent) */
 	res += inode_file_plugin(parent)->estimate.update(parent);
 	/* safe-link */
-	res += estimate_one_item_removal(tree_by_inode(object));
+	res += estimate_one_item_removal(reiser4_tree_by_inode(object));
 
 	return res;
 }
@@ -834,12 +836,12 @@ static reiser4_block_nr estimate_unlink(
 	/* fplug->unlink */
 	res += fplug->estimate.unlink(object, parent);
 	/* safe-link */
-	res += estimate_one_insert_item(tree_by_inode(object));
+	res += estimate_one_insert_item(reiser4_tree_by_inode(object));
 
 	return res;
 }
 
-/* helper for unlink_common. Estimate and grab space for unlink. */
+/* helper for reiser4_unlink_common. Estimate and grab space for unlink. */
 static int unlink_check_and_grab(struct inode *parent, struct dentry *victim)
 {
 	file_plugin *fplug;
@@ -851,10 +853,10 @@ static int unlink_check_and_grab(struct 
 	fplug = inode_file_plugin(child);
 
 	/* check for race with create_object() */
-	if (inode_get_flag(child, REISER4_IMMUTABLE))
+	if (reiser4_inode_get_flag(child, REISER4_IMMUTABLE))
 		return RETERR(-E_REPEAT);
 	/* object being deleted should have stat data */
-	assert("vs-949", !inode_get_flag(child, REISER4_NO_SD));
+	assert("vs-949", !reiser4_inode_get_flag(child, REISER4_NO_SD));
 
 	/* ask object plugin */
 	if (fplug->can_rem_link != NULL && !fplug->can_rem_link(child))
@@ -867,7 +869,7 @@ static int unlink_check_and_grab(struct 
 	return reiser4_grab_reserved(child->i_sb, result, BA_CAN_COMMIT);
 }
 
-/* helper for setattr_common */
+/* helper for reiser4_setattr_common */
 static int setattr_reserve(reiser4_tree * tree)
 {
 	assert("vs-1096", is_grab_enabled(get_current_context()));
diff -puN fs/reiser4/plugin/inode_ops_rename.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/inode_ops_rename.c
--- a/fs/reiser4/plugin/inode_ops_rename.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/inode_ops_rename.c
@@ -269,7 +269,7 @@ static int can_rename(struct inode *old_
 	return 0;
 }
 
-int find_entry(struct inode *, struct dentry *, lock_handle *,
+int reiser4_find_entry(struct inode *, struct dentry *, lock_handle *,
 	       znode_lock_mode, reiser4_dir_entry_desc *);
 int reiser4_update_dir(struct inode *);
 
@@ -284,10 +284,12 @@ int reiser4_update_dir(struct inode *);
    entry. This should be re-considered when more than one different
    directory plugin will be implemented.
 */
-int rename_common(struct inode *old_dir /* directory where @old is located */ ,
-		  struct dentry *old_name /* old name */ ,
-		  struct inode *new_dir /* directory where @new is located */ ,
-		  struct dentry *new_name /* new name */ )
+int reiser4_rename_common(struct inode *old_dir /* directory where @old
+						 * is located */ ,
+			  struct dentry *old_name /* old name */ ,
+			  struct inode *new_dir /* directory where @new
+						 * is located */ ,
+			  struct dentry *new_name /* new name */ )
 {
 	/* From `The Open Group Base Specifications Issue 6'
 
@@ -384,7 +386,7 @@ int rename_common(struct inode *old_dir 
 	struct dentry *dotdot_name;
 	reiser4_dentry_fsdata *dataonstack;
 
-	ctx = init_context(old_dir->i_sb);
+	ctx = reiser4_init_context(old_dir->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
@@ -464,8 +466,8 @@ int rename_common(struct inode *old_dir 
 	init_lh(new_lh);
 
 	/* find entry for @new_name */
-	result = find_entry(new_dir,
-			    new_name, new_lh, ZNODE_WRITE_LOCK, new_entry);
+	result = reiser4_find_entry(new_dir, new_name, new_lh, ZNODE_WRITE_LOCK,
+				    new_entry);
 
 	if (IS_CBKERR(result)) {
 		done_lh(new_lh);
@@ -475,7 +477,7 @@ int rename_common(struct inode *old_dir 
 		return result;
 	}
 
-	seal_done(&new_fsdata->dec.entry_seal);
+	reiser4_seal_done(&new_fsdata->dec.entry_seal);
 
 	/* add or replace name for @old_inode as @new_name */
 	if (new_inode != NULL) {
@@ -574,8 +576,9 @@ int rename_common(struct inode *old_dir 
 			dotdot_coord = &dataonstack->dec.entry_coord;
 			coord_clear_iplug(dotdot_coord);
 
-			result = find_entry(old_inode, dotdot_name, dotdot_lh,
-					    ZNODE_WRITE_LOCK, dotdot_entry);
+			result = reiser4_find_entry(old_inode, dotdot_name,
+						    dotdot_lh, ZNODE_WRITE_LOCK,
+						    dotdot_entry);
 			if (result == 0) {
 				/* replace_name() decreases i_nlink on
 				 * @old_dir */
@@ -609,10 +612,12 @@ int rename_common(struct inode *old_dir 
 }
 
 #if 0
-int rename_common(struct inode *old_dir /* directory where @old is located */ ,
-		  struct dentry *old_name /* old name */ ,
-		  struct inode *new_dir /* directory where @new is located */ ,
-		  struct dentry *new_name /* new name */ )
+int reiser4_rename_common(struct inode *old_dir /* directory where @old
+						 * is located */ ,
+			  struct dentry *old_name /* old name */ ,
+			  struct inode *new_dir /* directory where @new
+						 * is located */ ,
+			  struct dentry *new_name /* new name */ )
 {
 	/* From `The Open Group Base Specifications Issue 6'
 
@@ -705,7 +710,7 @@ int rename_common(struct inode *old_dir 
 	dir_plugin *dplug;
 	file_plugin *fplug;
 
-	ctx = init_context(old_dir->i_sb);
+	ctx = reiser4_init_context(old_dir->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
@@ -753,15 +758,15 @@ int rename_common(struct inode *old_dir 
 	init_lh(&new_lh);
 
 	/* find entry for @new_name */
-	result = find_entry(new_dir,
-			    new_name, &new_lh, ZNODE_WRITE_LOCK, &new_entry);
+	result = reiser4_find_entry(new_dir, new_name, &new_lh,
+				    ZNODE_WRITE_LOCK, &new_entry);
 
 	if (IS_CBKERR(result)) {
 		done_lh(&new_lh);
 		goto exit;
 	}
 
-	seal_done(&new_fsdata->dec.entry_seal);
+	reiser4_seal_done(&new_fsdata->dec.entry_seal);
 
 	/* add or replace name for @old_inode as @new_name */
 	if (new_inode != NULL) {
@@ -868,8 +873,11 @@ int rename_common(struct inode *old_dir 
 			dotdot_coord = &fsdata->dec.entry_coord;
 			coord_clear_iplug(dotdot_coord);
 
-			result = find_entry(old_inode, &dotdot_name, &dotdot_lh,
-					    ZNODE_WRITE_LOCK, &dotdot_entry);
+			result = reiser4_find_entry(old_inode,
+						    &dotdot_name,
+						    &dotdot_lh,
+						    ZNODE_WRITE_LOCK,
+						    &dotdot_entry);
 			if (result == 0) {
 				/* replace_name() decreases i_nlink on
 				 * @old_dir */
diff -puN fs/reiser4/plugin/item/blackbox.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/item/blackbox.c
--- a/fs/reiser4/plugin/item/blackbox.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/item/blackbox.c
@@ -128,7 +128,7 @@ update_black_box(reiser4_tree * tree,
 
 int kill_black_box(reiser4_tree * tree, const reiser4_key * key)
 {
-	return cut_tree(tree, key, key, NULL, 1);
+	return reiser4_cut_tree(tree, key, key, NULL, 1);
 }
 
 /* Make Linus happy.
diff -puN fs/reiser4/plugin/item/cde.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/item/cde.c
--- a/fs/reiser4/plugin/item/cde.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/item/cde.c
@@ -426,9 +426,9 @@ reiser4_key *max_key_inside_cde(const co
 	assert("nikita-1342", coord != NULL);
 
 	item_key_by_coord(coord, result);
-	set_key_ordering(result, get_key_ordering(max_key()));
-	set_key_fulloid(result, get_key_fulloid(max_key()));
-	set_key_offset(result, get_key_offset(max_key()));
+	set_key_ordering(result, get_key_ordering(reiser4_max_key()));
+	set_key_fulloid(result, get_key_fulloid(reiser4_max_key()));
+	set_key_offset(result, get_key_offset(reiser4_max_key()));
 	return result;
 }
 
@@ -459,8 +459,8 @@ int can_contain_key_cde(const coord_t * 
    possible check of the consistency of the item that the inventor can
    construct
 */
-int check_cde(const coord_t * coord /* coord of item to check */ ,
-	      const char **error /* where to store error message */ )
+int reiser4_check_cde(const coord_t * coord /* coord of item to check */,
+		      const char **error /* where to store error message */)
 {
 	int i;
 	int result;
@@ -938,7 +938,8 @@ int add_entry_cde(struct inode *dir /* d
 	if (result)
 		result = insert_by_coord(coord, &data, &dir_entry->key, lh, 0);
 	else
-		result = resize_item(coord, &data, &dir_entry->key, lh, 0);
+		result = reiser4_resize_item(coord, &data, &dir_entry->key,
+					     lh, 0);
 	return result;
 }
 
@@ -991,9 +992,9 @@ int rem_entry_cde(struct inode *dir /* d
 int max_name_len_cde(const struct inode *dir /* directory */ )
 {
 	return
-	    tree_by_inode(dir)->nplug->max_item_size() -
-	    sizeof(directory_entry_format) - sizeof(cde_item_format) -
-	    sizeof(cde_unit_header) - 2;
+		reiser4_tree_by_inode(dir)->nplug->max_item_size() -
+		sizeof(directory_entry_format) - sizeof(cde_item_format) -
+		sizeof(cde_unit_header) - 2;
 }
 
 /* Make Linus happy.
diff -puN fs/reiser4/plugin/item/cde.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/item/cde.h
--- a/fs/reiser4/plugin/item/cde.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/item/cde.h
@@ -59,7 +59,7 @@ int kill_units_cde(coord_t * coord, pos_
 		   struct carry_kill_data *, reiser4_key * smallest_removed,
 		   reiser4_key * new_first);
 void print_cde(const char *prefix, coord_t * coord);
-int check_cde(const coord_t * coord, const char **error);
+int reiser4_check_cde(const coord_t * coord, const char **error);
 
 /* plugin->u.item.s.dir.* */
 int extract_key_cde(const coord_t * coord, reiser4_key * key);
diff -puN fs/reiser4/plugin/item/ctail.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/item/ctail.c
--- a/fs/reiser4/plugin/item/ctail.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/item/ctail.c
@@ -515,7 +515,7 @@ int read_ctail(struct file *file UNUSED_
 	/* read only whole ctails */
 	assert("edward-135", nr_units_ctail(coord) <= f->length);
 
-	assert("edward-136", schedulable());
+	assert("edward-136", reiser4_schedulable());
 	assert("edward-886", ctail_ok(coord));
 
 	if (f->data)
@@ -537,14 +537,14 @@ int ctail_read_disk_cluster(reiser4_clus
 	int result;
 	assert("edward-671", clust->hint != NULL);
 	assert("edward-140", clust->dstat == INVAL_DISK_CLUSTER);
-	assert("edward-672", crc_inode_ok(inode));
+	assert("edward-672", cryptcompress_inode_ok(inode));
 
 	/* set input stream */
 	result = grab_tfm_stream(inode, &clust->tc, INPUT_STREAM);
 	if (result)
 		return result;
 
-	result = find_cluster(clust, inode, 1 /* read */ , write);
+	result = find_disk_cluster(clust, inode, 1 /* read */ , write);
 	assert("edward-1340", !result);
 	if (result)
 		return result;
@@ -564,7 +564,7 @@ int ctail_read_disk_cluster(reiser4_clus
 	result = grab_coa(&clust->tc, inode_compression_plugin(inode));
 	if (result)
 		return result;
-	result = inflate_cluster(clust, inode);
+	result = reiser4_inflate_cluster(clust, inode);
 	if (result)
 		return result;
 	tfm_cluster_set_uptodate(&clust->tc);
@@ -718,7 +718,7 @@ ctail_read_page_cluster(reiser4_cluster_
 	}
 	tfm_cluster_clr_uptodate(&clust->tc);
       out:
-	release_cluster_pages(clust);
+	reiser4_release_cluster_pages(clust);
 	return result;
 }
 
@@ -870,8 +870,8 @@ insert_unprepped_ctail(reiser4_cluster_t
 }
 
 static int
-insert_crc_flow(coord_t * coord, lock_handle * lh, flow_t * f,
-		struct inode *inode)
+insert_cryptcompress_flow(coord_t * coord, lock_handle * lh, flow_t * f,
+			  struct inode *inode)
 {
 	int result;
 	carry_pool *pool;
@@ -898,8 +898,8 @@ insert_crc_flow(coord_t * coord, lock_ha
 		coord->unit_pos = 0;
 		coord->between = AFTER_ITEM;
 	}
-	op = post_carry(lowest_level, COP_INSERT_FLOW, coord->node,
-			0 /* operate directly on coord -> node */ );
+	op = reiser4_post_carry(lowest_level, COP_INSERT_FLOW, coord->node,
+				0 /* operate directly on coord -> node */);
 	if (IS_ERR(op) || (op == NULL)) {
 		done_carry_pool(pool);
 		return RETERR(op ? PTR_ERR(op) : -EIO);
@@ -920,16 +920,16 @@ insert_crc_flow(coord_t * coord, lock_ha
 	lowest_level->track_type = CARRY_TRACK_CHANGE;
 	lowest_level->tracked = lh;
 
-	result = carry(lowest_level, NULL);
+	result = reiser4_carry(lowest_level, NULL);
 	done_carry_pool(pool);
 
 	return result;
 }
 
 /* Implementation of CRC_APPEND_ITEM mode of ctail conversion */
-static int
-insert_crc_flow_in_place(coord_t * coord, lock_handle * lh, flow_t * f,
-			 struct inode *inode)
+static int insert_cryptcompress_flow_in_place(coord_t * coord,
+					      lock_handle * lh, flow_t * f,
+					      struct inode *inode)
 {
 	int ret;
 	coord_t pos;
@@ -947,7 +947,7 @@ insert_crc_flow_in_place(coord_t * coord
 	init_lh(&lock);
 	copy_lh(&lock, lh);
 
-	ret = insert_crc_flow(&pos, &lock, f, inode);
+	ret = insert_cryptcompress_flow(&pos, &lock, f, inode);
 	done_lh(&lock);
 	assert("edward-1347", znode_is_write_locked(lh->node));
 	assert("edward-1228", !ret);
@@ -965,7 +965,7 @@ static int overwrite_ctail(coord_t * coo
 	assert("edward-272", coord_is_existing_unit(coord));
 	assert("edward-273", coord->unit_pos == 0);
 	assert("edward-274", znode_is_write_locked(coord->node));
-	assert("edward-275", schedulable());
+	assert("edward-275", reiser4_schedulable());
 	assert("edward-467", item_id_by_coord(coord) == CTAIL_ID);
 	assert("edward-1243", ctail_ok(coord));
 
@@ -1025,7 +1025,7 @@ ctail_insert_unprepped_cluster(reiser4_c
 	all_grabbed2free();
 
 	assert("edward-1251", !result);
-	assert("edward-1252", crc_inode_ok(inode));
+	assert("edward-1252", cryptcompress_inode_ok(inode));
 	assert("edward-1253", znode_is_write_locked(clust->hint->lh.node));
 	assert("edward-1254",
 	       reiser4_clustered_blocks(reiser4_get_current_sb()));
@@ -1035,7 +1035,7 @@ ctail_insert_unprepped_cluster(reiser4_c
 	return result;
 }
 
-static int do_convert_ctail(flush_pos_t * pos, crc_write_mode_t mode)
+static int do_convert_ctail(flush_pos_t * pos, cryptcompress_write_mode_t mode)
 {
 	int result = 0;
 	convert_item_info_t *info;
@@ -1053,8 +1053,10 @@ static int do_convert_ctail(flush_pos_t 
 		assert("edward-1256",
 		       cluster_shift_ok(cluster_shift_by_coord(&pos->coord)));
 		result =
-		    insert_crc_flow_in_place(&pos->coord, &pos->lock,
-					     &info->flow, info->inode);
+		    insert_cryptcompress_flow_in_place(&pos->coord,
+						       &pos->lock,
+						       &info->flow,
+						       info->inode);
 		break;
 	case CRC_OVERWRITE_ITEM:
 		assert("edward-1230", info->flow.length != 0);
@@ -1087,7 +1089,7 @@ int scan_ctail(flush_scan * scan)
 	page = jnode_page(node);
 	inode = page->mapping->host;
 
-	if (!scanning_left(scan))
+	if (!reiser4_scanning_left(scan))
 		return result;
 	if (!ZF_ISSET(scan->parent_lock.node, JNODE_DIRTY))
 		znode_make_dirty(scan->parent_lock.node);
@@ -1227,7 +1229,7 @@ static int attach_convert_idata(flush_po
 	assert("edward-248", pos != NULL);
 	assert("edward-249", pos->child != NULL);
 	assert("edward-251", inode != NULL);
-	assert("edward-682", crc_inode_ok(inode));
+	assert("edward-682", cryptcompress_inode_ok(inode));
 	assert("edward-252", fplug == file_plugin_by_id(CRC_FILE_PLUGIN_ID));
 	assert("edward-473",
 	       item_plugin_by_coord(&pos->coord) ==
@@ -1265,7 +1267,7 @@ static int attach_convert_idata(flush_po
 	if (ret)
 		goto err;
 
-	deflate_cluster(clust, inode);
+	reiser4_deflate_cluster(clust, inode);
 	inc_item_convert_count(pos);
 
 	/* make flow by transformed stream */
@@ -1277,7 +1279,7 @@ static int attach_convert_idata(flush_po
 			     WRITE_OP, &info->flow);
 	jput(pos->child);
 
-	assert("edward-683", crc_inode_ok(inode));
+	assert("edward-683", cryptcompress_inode_ok(inode));
 	return 0;
       err:
 	jput(pos->child);
@@ -1431,7 +1433,8 @@ static int next_item_dc_stat(flush_pos_t
 }
 
 static int
-assign_convert_mode(convert_item_info_t * idata, crc_write_mode_t * mode)
+assign_convert_mode(convert_item_info_t * idata,
+		    cryptcompress_write_mode_t * mode)
 {
 	int result = 0;
 
@@ -1473,7 +1476,7 @@ int convert_ctail(flush_pos_t * pos)
 {
 	int result;
 	int nr_items;
-	crc_write_mode_t mode = CRC_OVERWRITE_ITEM;
+	cryptcompress_write_mode_t mode = CRC_OVERWRITE_ITEM;
 
 	assert("edward-1020", pos != NULL);
 	assert("edward-1213", coord_num_items(&pos->coord) != 0);
diff -puN fs/reiser4/plugin/item/extent.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/item/extent.c
--- a/fs/reiser4/plugin/item/extent.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/item/extent.c
@@ -24,7 +24,7 @@ reiser4_item_data *init_new_extent(reise
 }
 
 /* how many bytes are addressed by @nr first extents of the extent item */
-reiser4_block_nr extent_size(const coord_t * coord, pos_in_node_t nr)
+reiser4_block_nr reiser4_extent_size(const coord_t * coord, pos_in_node_t nr)
 {
 	pos_in_node_t i;
 	reiser4_block_nr blocks;
@@ -62,8 +62,8 @@ int extent_is_unallocated(const coord_t 
 }
 
 /* set extent's start and width */
-void
-set_extent(reiser4_extent * ext, reiser4_block_nr start, reiser4_block_nr width)
+void reiser4_set_extent(reiser4_extent * ext, reiser4_block_nr start,
+			reiser4_block_nr width)
 {
 	extent_set_start(ext, start);
 	extent_set_width(ext, width);
@@ -71,7 +71,7 @@ set_extent(reiser4_extent * ext, reiser4
 
 
 /**
- * replace_extent - replace extent and paste 1 or 2 after it
+ * reiser4_replace_extent - replace extent and paste 1 or 2 after it
  * @un_extent: coordinate of extent to be overwritten
  * @lh: need better comment
  * @key: need better comment
@@ -85,7 +85,8 @@ set_extent(reiser4_extent * ext, reiser4
  * first of newly inserted units, if it is 0 - @un_extent and @lh are returned
  * set to extent which was overwritten.
  */
-int replace_extent(struct replace_handle *h, int return_inserted_position)
+int reiser4_replace_extent(struct replace_handle *h,
+			   int return_inserted_position)
 {
 	int result;
 	znode *orig_znode;
@@ -104,8 +105,8 @@ int replace_extent(struct replace_handle
 	coord_dup(&h->coord_after, h->coord);
 	init_lh(&h->lh_after);
 	copy_lh(&h->lh_after, h->lh);
-	tap_init(&h->watch, &h->coord_after, &h->lh_after, ZNODE_WRITE_LOCK);
-	tap_monitor(&h->watch);
+	reiser4_tap_init(&h->watch, &h->coord_after, &h->lh_after, ZNODE_WRITE_LOCK);
+	reiser4_tap_monitor(&h->watch);
 
 	ON_DEBUG(h->orig_ext = *extent_by_coord(h->coord));
 	orig_znode = h->coord->node;
@@ -173,7 +174,7 @@ int replace_extent(struct replace_handle
 			}
 		}
 	}
-	tap_done(&h->watch);
+	reiser4_tap_done(&h->watch);
 
 	return result;
 }
diff -puN fs/reiser4/plugin/item/extent.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/item/extent.h
--- a/fs/reiser4/plugin/item/extent.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/item/extent.h
@@ -128,13 +128,15 @@ int utmost_child_extent(const coord_t * 
 int utmost_child_real_block_extent(const coord_t * coord, sideof side,
 				   reiser4_block_nr * block);
 void item_stat_extent(const coord_t * coord, void *vp);
-int check_extent(const coord_t * coord, const char **error);
+int reiser4_check_extent(const coord_t * coord, const char **error);
 
 /* plugin->u.item.s.file.* */
-ssize_t write_extent(struct file *, const char __user *, size_t, loff_t *);
-int read_extent(struct file *, flow_t *, hint_t *);
-int readpage_extent(void *, struct page *);
-void readpages_extent(void *, struct address_space *, struct list_head *pages);
+ssize_t reiser4_write_extent(struct file *, const char __user *,
+			     size_t, loff_t *);
+int reiser4_read_extent(struct file *, flow_t *, hint_t *);
+int reiser4_readpage_extent(void *, struct page *);
+void reiser4_readpages_extent(void *, struct address_space *,
+			      struct list_head *pages);
 reiser4_key *append_key_extent(const coord_t *, reiser4_key *);
 void init_coord_extension_extent(uf_coord_t *, loff_t offset);
 int get_block_address_extent(const coord_t *, sector_t block,
@@ -151,23 +153,24 @@ __u64 extent_unit_index(const coord_t * 
 __u64 extent_unit_width(const coord_t * item);	/* Number of blocks in this unit. */
 
 /* plugin->u.item.f. */
-int scan_extent(flush_scan * scan);
+int reiser4_scan_extent(flush_scan * scan);
 extern int key_by_offset_extent(struct inode *, loff_t, reiser4_key *);
 
 reiser4_item_data *init_new_extent(reiser4_item_data * data, void *ext_unit,
 				   int nr_extents);
-reiser4_block_nr extent_size(const coord_t * coord, pos_in_node_t nr);
+reiser4_block_nr reiser4_extent_size(const coord_t * coord, pos_in_node_t nr);
 extent_state state_of_extent(reiser4_extent * ext);
-void set_extent(reiser4_extent *, reiser4_block_nr start,
-		reiser4_block_nr width);
-int update_extent(struct inode *, jnode *, loff_t pos, int *plugged_hole);
+void reiser4_set_extent(reiser4_extent *, reiser4_block_nr start,
+			reiser4_block_nr width);
+int reiser4_update_extent(struct inode *, jnode *, loff_t pos,
+			  int *plugged_hole);
 
 #include "../../coord.h"
 #include "../../lock.h"
 #include "../../tap.h"
 
 struct replace_handle {
-	/* these are to be set before calling replace_extent */
+	/* these are to be set before calling reiser4_replace_extent */
 	coord_t *coord;
 	lock_handle *lh;
 	reiser4_key key;
@@ -177,7 +180,7 @@ struct replace_handle {
 	int nr_new_extents;
 	unsigned flags;
 
-	/* these are used by replace_extent */
+	/* these are used by reiser4_replace_extent */
 	reiser4_item_data item;
 	coord_t coord_after;
 	lock_handle lh_after;
@@ -190,7 +193,7 @@ struct replace_handle {
 };
 
 /* this structure is kmalloced before calling make_extent to avoid excessive
-   stack consumption on plug_hole->replace_extent */
+   stack consumption on plug_hole->reiser4_replace_extent */
 struct make_extent_handle {
 	uf_coord_t *uf_coord;
 	reiser4_block_nr blocknr;
@@ -203,7 +206,8 @@ struct make_extent_handle {
 	} u;
 };
 
-int replace_extent(struct replace_handle *, int return_inserted_position);
+int reiser4_replace_extent(struct replace_handle *,
+			   int return_inserted_position);
 lock_handle *znode_lh(znode *);
 
 /* the reiser4 repacker support */
diff -puN fs/reiser4/plugin/item/extent_file_ops.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/item/extent_file_ops.c
--- a/fs/reiser4/plugin/item/extent_file_ops.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/item/extent_file_ops.c
@@ -168,8 +168,8 @@ static int append_hole(coord_t *coord, l
 		 * @hole_width blocks. Note that we do not worry about
 		 * overflowing - extent width is 64 bits
 		 */
-		set_extent(ext, HOLE_EXTENT_START,
-			   extent_get_width(ext) + hole_width);
+		reiser4_set_extent(ext, HOLE_EXTENT_START,
+				   extent_get_width(ext) + hole_width);
 		znode_make_dirty(coord->node);
 		return 0;
 	}
@@ -178,7 +178,7 @@ static int append_hole(coord_t *coord, l
 	assert("vs-713", (state_of_extent(ext) == ALLOCATED_EXTENT ||
 			  state_of_extent(ext) == UNALLOCATED_EXTENT));
 
-	set_extent(&new_ext, HOLE_EXTENT_START, hole_width);
+	reiser4_set_extent(&new_ext, HOLE_EXTENT_START, hole_width);
 	init_new_extent(&idata, &new_ext, 1);
 	return insert_into_item(coord, lh, &append_key, &idata, 0);
 }
@@ -272,8 +272,8 @@ static int append_last_extent(uf_coord_t
 		 * last extent unit of the file is unallocated one. Increase
 		 * its width by @count
 		 */
-		set_extent(ext, UNALLOCATED_EXTENT_START,
-			   extent_get_width(ext) + count);
+		reiser4_set_extent(ext, UNALLOCATED_EXTENT_START,
+				   extent_get_width(ext) + count);
 		znode_make_dirty(coord->node);
 
 		/* update coord extension */
@@ -289,7 +289,7 @@ static int append_last_extent(uf_coord_t
 		 * last extent unit of the file is either hole or allocated
 		 * one. Append one unallocated extent of width @count
 		 */
-		set_extent(&new_ext, UNALLOCATED_EXTENT_START, count);
+		reiser4_set_extent(&new_ext, UNALLOCATED_EXTENT_START, count);
 		init_new_extent(&idata, &new_ext, 1);
 		result = insert_into_item(coord, uf_coord->lh, key, &idata, 0);
 		uf_coord->valid = 0;
@@ -317,7 +317,7 @@ static int append_last_extent(uf_coord_t
 		spin_lock_jnode(node);
 		JF_SET(node, JNODE_CREATED);
 		jnode_set_block(node, &block);
- 		result = try_capture(node, ZNODE_WRITE_LOCK, 0);
+ 		result = reiser4_try_capture(node, ZNODE_WRITE_LOCK, 0);
 		BUG_ON(result != 0);
 		jnode_make_dirty_locked(node);
 		spin_unlock_jnode(node);
@@ -352,7 +352,7 @@ static int insert_first_hole(coord_t *co
 	assert("vs-710", hole_width > 0);
 
 	/* compose body of hole extent and insert item into tree */
-	set_extent(&new_ext, HOLE_EXTENT_START, hole_width);
+	reiser4_set_extent(&new_ext, HOLE_EXTENT_START, hole_width);
 	init_new_extent(&idata, &new_ext, 1);
 	return insert_extent_by_coord(coord, &idata, &item_key, lh);
 }
@@ -397,9 +397,10 @@ static int insert_first_extent(uf_coord_
 		 * file or performing tail conversion
 		 */
 		assert("", (uf_info->container == UF_CONTAINER_EMPTY ||
-			    (inode_get_flag(inode, REISER4_PART_MIXED) &&
-			     inode_get_flag(inode, REISER4_PART_IN_CONV))));
-
+			    (reiser4_inode_get_flag(inode,
+						    REISER4_PART_MIXED) &&
+			     reiser4_inode_get_flag(inode,
+						    REISER4_PART_IN_CONV))));
 		/* if file was empty - update its state */
 		if (result == 0 && uf_info->container == UF_CONTAINER_EMPTY)
 			uf_info->container = UF_CONTAINER_EXTENTS;
@@ -416,7 +417,7 @@ static int insert_first_extent(uf_coord_
 	 * prepare for tree modification: compose body of item and item data
 	 * structure needed for insertion
 	 */
-	set_extent(&new_ext, UNALLOCATED_EXTENT_START, count);
+	reiser4_set_extent(&new_ext, UNALLOCATED_EXTENT_START, count);
 	init_new_extent(&idata, &new_ext, 1);
 
 	/* insert extent item into the tree */
@@ -439,7 +440,7 @@ static int insert_first_extent(uf_coord_
 		spin_lock_jnode(node);
 		JF_SET(node, JNODE_CREATED);
 		jnode_set_block(node, &block);
- 		result = try_capture(node, ZNODE_WRITE_LOCK, 0);
+ 		result = reiser4_try_capture(node, ZNODE_WRITE_LOCK, 0);
 		BUG_ON(result != 0);
 		jnode_make_dirty_locked(node);
 		spin_unlock_jnode(node);
@@ -487,7 +488,7 @@ static int plug_hole(uf_coord_t *uf_coor
 
 	*how = 0;
 	if (width == 1) {
-		set_extent(ext, UNALLOCATED_EXTENT_START, 1);
+		reiser4_set_extent(ext, UNALLOCATED_EXTENT_START, 1);
 		znode_make_dirty(coord->node);
 		/* update uf_coord */
 		ON_DEBUG(ext_coord->extent = *ext);
@@ -520,13 +521,14 @@ static int plug_hole(uf_coord_t *uf_coor
 			}
 		}
 		/* extent for replace */
-		set_extent(&rh.overwrite, UNALLOCATED_EXTENT_START, 1);
+		reiser4_set_extent(&rh.overwrite, UNALLOCATED_EXTENT_START, 1);
 		/* extent to be inserted */
-		set_extent(&rh.new_extents[0], HOLE_EXTENT_START, width - 1);
+		reiser4_set_extent(&rh.new_extents[0], HOLE_EXTENT_START,
+				   width - 1);
 		rh.nr_new_extents = 1;
 
-		/* have replace_extent to return with @coord and @uf_coord->lh
-		   set to unit which was replaced */
+		/* have reiser4_replace_extent to return with @coord and
+		   @uf_coord->lh set to unit which was replaced */
 		return_inserted_position = 0;
 		*how = 3;
 	} else if (pos_in_unit == width - 1) {
@@ -556,26 +558,29 @@ static int plug_hole(uf_coord_t *uf_coor
 			}
 		}
 		/* extent for replace */
-		set_extent(&rh.overwrite, HOLE_EXTENT_START, width - 1);
+		reiser4_set_extent(&rh.overwrite, HOLE_EXTENT_START, width - 1);
 		/* extent to be inserted */
-		set_extent(&rh.new_extents[0], UNALLOCATED_EXTENT_START, 1);
+		reiser4_set_extent(&rh.new_extents[0], UNALLOCATED_EXTENT_START,
+				   1);
 		rh.nr_new_extents = 1;
 
-		/* have replace_extent to return with @coord and @uf_coord->lh
-		   set to unit which was inserted */
+		/* have reiser4_replace_extent to return with @coord and
+		   @uf_coord->lh set to unit which was inserted */
 		return_inserted_position = 1;
 		*how = 5;
 	} else {
 		/* extent for replace */
-		set_extent(&rh.overwrite, HOLE_EXTENT_START, pos_in_unit);
+		reiser4_set_extent(&rh.overwrite, HOLE_EXTENT_START,
+				   pos_in_unit);
 		/* extents to be inserted */
-		set_extent(&rh.new_extents[0], UNALLOCATED_EXTENT_START, 1);
-		set_extent(&rh.new_extents[1], HOLE_EXTENT_START,
-			   width - pos_in_unit - 1);
+		reiser4_set_extent(&rh.new_extents[0], UNALLOCATED_EXTENT_START,
+				   1);
+		reiser4_set_extent(&rh.new_extents[1], HOLE_EXTENT_START,
+				   width - pos_in_unit - 1);
 		rh.nr_new_extents = 2;
 
-		/* have replace_extent to return with @coord and @uf_coord->lh
-		   set to first of units which were inserted */
+		/* have reiser4_replace_extent to return with @coord and
+		   @uf_coord->lh set to first of units which were inserted */
 		return_inserted_position = 1;
 		*how = 6;
 	}
@@ -584,7 +589,7 @@ static int plug_hole(uf_coord_t *uf_coor
 		       extent_get_width(&rh.overwrite) * current_blocksize);
 
 	uf_coord->valid = 0;
-	return replace_extent(&rh, return_inserted_position);
+	return reiser4_replace_extent(&rh, return_inserted_position);
 }
 
 /**
@@ -709,7 +714,7 @@ static int overwrite_extent(uf_coord_t *
 		 * them dirty
 		 */
 		spin_lock_jnode(node);
-		result = try_capture(node, ZNODE_WRITE_LOCK, 0);
+		result = reiser4_try_capture(node, ZNODE_WRITE_LOCK, 0);
 		BUG_ON(result != 0);
 		jnode_make_dirty_locked(node);
 		spin_unlock_jnode(node);
@@ -735,14 +740,14 @@ static int overwrite_extent(uf_coord_t *
 }
 
 /**
- * update_extent
+ * reiser4_update_extent
  * @file:
  * @jnodes:
  * @count:
  * @off:
  *
  */
-int update_extent(struct inode *inode, jnode *node, loff_t pos,
+int reiser4_update_extent(struct inode *inode, jnode *node, loff_t pos,
 		  int *plugged_hole)
 {
 	int result;
@@ -752,7 +757,7 @@ int update_extent(struct inode *inode, j
 	lock_handle lh;
 	reiser4_key key;
 
-	assert("", lock_counters()->d_refs == 0);
+	assert("", reiser4_lock_counters()->d_refs == 0);
 
 	key_by_inode_and_offset_common(inode, pos, &key);
 
@@ -761,7 +766,7 @@ int update_extent(struct inode *inode, j
 	result = find_file_item_nohint(coord, &lh, &key,
 				       ZNODE_WRITE_LOCK, inode);
 	if (IS_CBKERR(result)) {
-		assert("", lock_counters()->d_refs == 0);
+		assert("", reiser4_lock_counters()->d_refs == 0);
 		return result;
 	}
 
@@ -799,7 +804,7 @@ int update_extent(struct inode *inode, j
 	assert("", result == 1 || result < 0);
 	zrelse(loaded);
 	done_lh(&lh);
-	assert("", lock_counters()->d_refs == 0);
+	assert("", reiser4_lock_counters()->d_refs == 0);
 	return (result == 1) ? 0 : result;
 }
 
@@ -830,12 +835,12 @@ static int update_extents(struct file *f
 		pos = (loff_t)index_jnode(jnodes[0]) << PAGE_CACHE_SHIFT;
 	key_by_inode_and_offset_common(inode, pos, &key);
 
-	assert("", lock_counters()->d_refs == 0);
+	assert("", reiser4_lock_counters()->d_refs == 0);
 
 	do {
 		result = find_file_item(&hint, &key, ZNODE_WRITE_LOCK, inode);
 		if (IS_CBKERR(result)) {
-			assert("", lock_counters()->d_refs == 0);
+			assert("", reiser4_lock_counters()->d_refs == 0);
 			return result;
 		}
 
@@ -887,14 +892,14 @@ static int update_extents(struct file *f
 
 		/* seal and unlock znode */
 		if (hint.ext_coord.valid)
-			set_hint(&hint, &key, ZNODE_WRITE_LOCK);
+			reiser4_set_hint(&hint, &key, ZNODE_WRITE_LOCK);
 		else
-			unset_hint(&hint);
+			reiser4_unset_hint(&hint);
 
 	} while (count > 0);
 
 	save_file_hint(file, &hint);
-	assert("", lock_counters()->d_refs == 0);
+	assert("", reiser4_lock_counters()->d_refs == 0);
 	return result;
 }
 
@@ -925,7 +930,7 @@ static int write_extent_reserve_space(st
 
 	 * 3. stat data update
 	 */
-	tree = tree_by_inode(inode);
+	tree = reiser4_tree_by_inode(inode);
 	count = estimate_one_insert_item(tree) +
 		WRITE_GRANULARITY * (1 + estimate_one_insert_into_item(tree)) +
 		estimate_one_insert_item(tree);
@@ -934,15 +939,15 @@ static int write_extent_reserve_space(st
 }
 
 /**
- * write_extent - write method of extent item plugin
+ * reiser4_write_extent - write method of extent item plugin
  * @file: file to write to
  * @buf: address of user-space buffer
  * @write_amount: number of bytes to write
  * @off: position in file to write to
  *
  */
-ssize_t write_extent(struct file *file, const char __user *buf, size_t count,
-		     loff_t *pos)
+ssize_t reiser4_write_extent(struct file *file, const char __user *buf,
+			     size_t count, loff_t *pos)
 {
 	int have_to_update_extent;
 	int nr_pages;
@@ -976,7 +981,8 @@ ssize_t write_extent(struct file *file, 
 
 	/* get pages and jnodes */
 	for (i = 0; i < nr_pages; i ++) {
-		page = find_or_create_page(inode->i_mapping, index + i, get_gfp_mask());
+		page = find_or_create_page(inode->i_mapping, index + i,
+					   reiser4_ctx_gfp_mask_get());
 		if (page == NULL) {
 			while(i --) {
 				unlock_page(jnode_page(jnodes[i]));
@@ -1046,17 +1052,25 @@ ssize_t write_extent(struct file *file, 
 			kunmap_atomic(kaddr, KM_USER0);
 		}
 
-		written = filemap_copy_from_user(page, page_off, buf, to_page);
+		written = filemap_copy_from_user_atomic(page, page_off,
+							buf, to_page);
 		if (written != to_page) {
-			unlock_page(page);
-			page_cache_release(page);
-			nr_pages = i;
-			jput(jnodes[i]);
-			result = RETERR(-EFAULT);
-			break;
+			/* Do it the slow way */
+			written = filemap_copy_from_user_nonatomic(page,
+								   page_off,
+								   buf,
+								   to_page);
+			if (written != to_page) {
+				unlock_page(page);
+				page_cache_release(page);
+				nr_pages = i;
+				jput(jnodes[i]);
+				result = RETERR(-EFAULT);
+				break;
+			}
 		}
 		flush_dcache_page(page);
-		set_page_dirty_internal(page);
+		reiser4_set_page_dirty_internal(page);
 		unlock_page(page);
 		mark_page_accessed(page);
 		SetPageUptodate(page);
@@ -1076,7 +1090,8 @@ ssize_t write_extent(struct file *file, 
 	} else {
 		for (i = 0; i < nr_pages; i ++) {
 			spin_lock_jnode(jnodes[i]);
-			result = try_capture(jnodes[i], ZNODE_WRITE_LOCK, 0);
+			result = reiser4_try_capture(jnodes[i],
+						     ZNODE_WRITE_LOCK, 0);
 			BUG_ON(result != 0);
 			jnode_make_dirty_locked(jnodes[i]);
 			spin_unlock_jnode(jnodes[i]);
@@ -1174,7 +1189,7 @@ do_readpage_extent(reiser4_extent * ext,
 	}
 
 	BUG_ON(j == 0);
-	page_io(page, j, READ, get_gfp_mask());
+	reiser4_page_io(page, j, READ, reiser4_ctx_gfp_mask_get());
 	jput(j);
 	return 0;
 }
@@ -1312,20 +1327,20 @@ static int extent_readpage_filler(void *
 				      FIND_EXACT, TWIG_LEVEL,
 				      TWIG_LEVEL, CBK_UNIQUE, NULL);
 		if (result != CBK_COORD_FOUND) {
-			unset_hint(hint);
+			reiser4_unset_hint(hint);
 			return result;
 		}
 		ext_coord->valid = 0;
 	}
 
 	if (zload(ext_coord->coord.node)) {
-		unset_hint(hint);
+		reiser4_unset_hint(hint);
 		return RETERR(-EIO);
 	}
 	if (!item_is_extent(&ext_coord->coord)) {
 		/* tail conversion is running in parallel */
 		zrelse(ext_coord->coord.node);
-		unset_hint(hint);
+		reiser4_unset_hint(hint);
 		return RETERR(-EIO);
 	}
 
@@ -1347,9 +1362,9 @@ static int extent_readpage_filler(void *
 	}
 	if (!result && move_coord_forward(ext_coord) == 0) {
 		set_key_offset(&key, offset + PAGE_CACHE_SIZE);
-		set_hint(hint, &key, ZNODE_READ_LOCK);
+		reiser4_set_hint(hint, &key, ZNODE_READ_LOCK);
 	} else
-		unset_hint(hint);
+		reiser4_unset_hint(hint);
 	zrelse(ext_coord->coord.node);
 	return result;
 }
@@ -1409,7 +1424,7 @@ static int filler(void *vp, struct page 
 }
 
 /* Implements plugin->u.item.s.file.read operation for extent items. */
-int read_extent(struct file *file, flow_t *flow, hint_t *hint)
+int reiser4_read_extent(struct file *file, flow_t *flow, hint_t *hint)
 {
 	int result;
 	struct page *page;
@@ -1459,13 +1474,13 @@ int read_extent(struct file *file, flow_
 	/* we start having twig node read locked. However, we do not want to
 	   keep that lock all the time readahead works. So, set a sel and
 	   release twig node. */
-	set_hint(hint, &flow->key, ZNODE_READ_LOCK);
+	reiser4_set_hint(hint, &flow->key, ZNODE_READ_LOCK);
 	/* &hint->lh is done-ed */
 
 	ra = file->f_ra;
 	prev_page = ra.prev_page;
 	do {
-		txn_restart_current();
+		reiser4_txn_restart_current();
 		if (next_page == cur_page)
 			next_page =
 			    call_page_cache_readahead(mapping, file, hint,
@@ -1514,7 +1529,7 @@ int read_extent(struct file *file, flow_
 		if (mapping_writably_mapped(mapping))
 			flush_dcache_page(page);
 
-		assert("nikita-3034", schedulable());
+		assert("nikita-3034", reiser4_schedulable());
 
 		/* number of bytes which are to be read from the page */
 		if (count > flow->length)
@@ -1556,9 +1571,8 @@ int read_extent(struct file *file, flow_
 /*
   plugin->u.item.s.file.readpages
 */
-void
-readpages_extent(void *vp, struct address_space *mapping,
-		 struct list_head *pages)
+void reiser4_readpages_extent(void *vp, struct address_space *mapping,
+			      struct list_head *pages)
 {
 	assert("vs-1739", 0);
 	if (vp)
@@ -1574,7 +1588,7 @@ readpages_extent(void *vp, struct addres
    At the beginning: coord->node is read locked, zloaded, page is
    locked, coord is set to existing unit inside of extent item (it is not necessary that coord matches to page->index)
 */
-int readpage_extent(void *vp, struct page *page)
+int reiser4_readpage_extent(void *vp, struct page *page)
 {
 	uf_coord_t *uf_coord = vp;
 	ON_DEBUG(coord_t * coord = &uf_coord->coord);
@@ -1644,9 +1658,9 @@ reiser4_key *append_key_extent(const coo
 {
 	item_key_by_coord(coord, key);
 	set_key_offset(key,
-		       get_key_offset(key) + extent_size(coord,
-							 nr_units_extent
-							 (coord)));
+		       get_key_offset(key) + reiser4_extent_size(coord,
+								 nr_units_extent
+								 (coord)));
 
 	assert("vs-610", get_key_offset(key)
 	       && (get_key_offset(key) & (current_blocksize - 1)) == 0);
diff -puN fs/reiser4/plugin/item/extent_flush_ops.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/item/extent_flush_ops.c
--- a/fs/reiser4/plugin/item/extent_flush_ops.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/item/extent_flush_ops.c
@@ -124,10 +124,10 @@ utmost_child_real_block_extent(const coo
    any case, the code below asserts this case for unallocated extents.  Unallocated
    extents are thus optimized because we can skip to the endpoint when scanning.
 
-   It returns control to scan_extent, handles these terminating conditions, e.g., by
-   loading the next twig.
+   It returns control to reiser4_scan_extent, handles these terminating conditions,
+   e.g., by loading the next twig.
 */
-int scan_extent(flush_scan * scan)
+int reiser4_scan_extent(flush_scan * scan)
 {
 	coord_t coord;
 	jnode *neighbor;
@@ -146,7 +146,7 @@ int scan_extent(flush_scan * scan)
 
 	coord_dup(&coord, &scan->parent_coord);
 
-	assert("jmacd-1404", !scan_finished(scan));
+	assert("jmacd-1404", !reiser4_scan_finished(scan));
 	assert("jmacd-1405", jnode_get_level(scan->node) == LEAF_LEVEL);
 	assert("jmacd-1406", jnode_is_unformatted(scan->node));
 
@@ -174,7 +174,7 @@ int scan_extent(flush_scan * scan)
 	   (scan_max) and the number of nodes that would be passed if the scan goes the
 	   entire way (scan_dist).  Incr is an integer reflecting the incremental
 	   direction of scan_index. */
-	if (scanning_left(scan)) {
+	if (reiser4_scanning_left(scan)) {
 		scan_max = unit_index;
 		scan_dist = scan_index - unit_index;
 		incr = -1;
@@ -195,8 +195,8 @@ int scan_extent(flush_scan * scan)
 				goto stop_same_parent;
 
 			if (scan->node != neighbor
-			    && !scan_goto(scan, neighbor)) {
-				/* @neighbor was jput() by scan_goto(). */
+			    && !reiser4_scan_goto(scan, neighbor)) {
+				/* @neighbor was jput() by reiser4_scan_goto */
 				goto stop_same_parent;
 			}
 
@@ -221,7 +221,8 @@ int scan_extent(flush_scan * scan)
 			goto exit;
 		}
 
-		assert("zam-1043", blocknr_is_fake(jnode_get_block(neighbor)));
+		assert("zam-1043",
+		       reiser4_blocknr_is_fake(jnode_get_block(neighbor)));
 
 		ret = scan_set_current(scan, neighbor, scan_dist, &coord);
 		if (ret != 0) {
@@ -235,7 +236,8 @@ int scan_extent(flush_scan * scan)
 
 		scan_index =
 		    extent_unit_index(&coord) +
-		    (scanning_left(scan) ? extent_unit_width(&coord) - 1 : 0);
+		    (reiser4_scanning_left(scan) ?
+		     extent_unit_width(&coord) - 1 : 0);
 		goto repeat;
 	}
 
@@ -245,7 +247,8 @@ int scan_extent(flush_scan * scan)
 		/* If we are scanning left and we stop in the middle of an allocated
 		   extent, we know the preceder immediately.. */
 		/* middle of extent is (scan_index - unit_index) != 0. */
-		if (scanning_left(scan) && (scan_index - unit_index) != 0) {
+		if (reiser4_scanning_left(scan) &&
+		    (scan_index - unit_index) != 0) {
 			/* FIXME(B): Someone should step-through and verify that this preceder
 			   calculation is indeed correct. */
 			/* @unit_start is starting block (number) of extent
@@ -363,7 +366,7 @@ static int split_allocated_extent(coord_
 	assert("vs-1410", state_of_extent(ext) == ALLOCATED_EXTENT);
 	assert("vs-1411", extent_get_width(ext) > pos_in_unit);
 
-	h = kmalloc(sizeof(*h), get_gfp_mask());
+	h = kmalloc(sizeof(*h), reiser4_ctx_gfp_mask_get());
 	if (h == NULL)
 		return RETERR(-ENOMEM);
 	h->coord = coord;
@@ -373,17 +376,19 @@ static int split_allocated_extent(coord_
 	set_key_offset(h->pkey,
 		       (get_key_offset(h->pkey) +
 			pos_in_unit * current_blocksize));
-	set_extent(&h->overwrite, extent_get_start(ext), pos_in_unit);
-	set_extent(&h->new_extents[0], extent_get_start(ext) + pos_in_unit,
-		   extent_get_width(ext) - pos_in_unit);
+	reiser4_set_extent(&h->overwrite, extent_get_start(ext),
+			   pos_in_unit);
+	reiser4_set_extent(&h->new_extents[0],
+			   extent_get_start(ext) + pos_in_unit,
+			   extent_get_width(ext) - pos_in_unit);
 	h->nr_new_extents = 1;
 	h->flags = COPI_DONT_SHIFT_LEFT;
 	h->paste_key = h->key;
 
 	/* reserve space for extent unit paste, @grabbed is reserved before */
 	grabbed = reserve_replace();
-	result = replace_extent(h, 0 /* leave @coord set to overwritten
-					extent */);
+	result = reiser4_replace_extent(h, 0 /* leave @coord set to overwritten
+						extent */);
 	/* restore reserved */
 	free_replace_reserved(grabbed);
 	kfree(h);
@@ -480,7 +485,7 @@ static int conv_extent(coord_t *coord, r
 		return 0;
 	}
 
-	h = kmalloc(sizeof(*h), get_gfp_mask());
+	h = kmalloc(sizeof(*h), reiser4_ctx_gfp_mask_get());
 	if (h == NULL)
 		return RETERR(-ENOMEM);
 	h->coord = coord;
@@ -492,17 +497,19 @@ static int conv_extent(coord_t *coord, r
 	h->overwrite = *replace;
 
 	/* replace @ext with @replace and padding extent */
-	set_extent(&h->new_extents[0],
-		   (state == ALLOCATED_EXTENT) ? (start + new_width) : UNALLOCATED_EXTENT_START,
-		   width - new_width);
+	reiser4_set_extent(&h->new_extents[0],
+			   (state == ALLOCATED_EXTENT) ?
+			   (start + new_width) :
+			   UNALLOCATED_EXTENT_START,
+			   width - new_width);
 	h->nr_new_extents = 1;
 	h->flags = COPI_DONT_SHIFT_LEFT;
 	h->paste_key = h->key;
 
 	/* reserve space for extent unit paste, @grabbed is reserved before */
 	grabbed = reserve_replace();
-	result = replace_extent(h, 0 /* leave @coord set to overwritten
-					extent */);
+	result = reiser4_replace_extent(h, 0 /* leave @coord set to overwritten
+						extent */);
 
 	/* restore reserved */
 	free_replace_reserved(grabbed);
@@ -610,7 +617,7 @@ static void mark_jnodes_overwrite(flush_
 
 	tree = current_tree;
 
-	atom = atom_locked_by_fq(pos_fq(flush_pos));
+	atom = atom_locked_by_fq(reiser4_pos_fq(flush_pos));
 	assert("vs-1478", atom);
 
 	for (i = flush_pos->pos_in_unit; i < width; i++, index++) {
@@ -654,7 +661,7 @@ static int allocated_extent_slum_size(fl
 	txn_atom *atom;
 	int nr;
 
-	atom = atom_locked_by_fq(pos_fq(flush_pos));
+	atom = atom_locked_by_fq(reiser4_pos_fq(flush_pos));
 	assert("vs-1468", atom);
 
 	nr = 0;
@@ -701,7 +708,7 @@ static int allocated_extent_slum_size(fl
  * within the extent. Slum gets to relocate set if flush_pos->leaf_relocate is
  * set to 1 and to overwrite set otherwise
  */
-int alloc_extent(flush_pos_t *flush_pos)
+int reiser4_alloc_extent(flush_pos_t *flush_pos)
 {
 	coord_t *coord;
 	reiser4_extent *ext;
@@ -778,11 +785,13 @@ int alloc_extent(flush_pos_t *flush_pos)
 		 */
 		if (coord->unit_pos &&
 		    (state_of_extent(ext - 1) == ALLOCATED_EXTENT))
-			pos_hint(flush_pos)->blk = extent_get_start(ext - 1) +
+			reiser4_pos_hint(flush_pos)->blk =
+				extent_get_start(ext - 1) +
 				extent_get_width(ext - 1);
 
 		/* allocate new block numbers for protected nodes */
-		extent_allocate_blocks(pos_hint(flush_pos), protected,
+		extent_allocate_blocks(reiser4_pos_hint(flush_pos),
+				       protected,
 				       &first_allocated, &allocated,
 				       block_stage);
 
@@ -799,7 +808,7 @@ int alloc_extent(flush_pos_t *flush_pos)
 
 
 		/* prepare extent which will replace current one */
-		set_extent(&replace_ext, first_allocated, allocated);
+		reiser4_set_extent(&replace_ext, first_allocated, allocated);
 
 		/* adjust extent item */
 		result = conv_extent(coord, &replace_ext);
@@ -937,16 +946,18 @@ squeeze_result squalloc_extent(znode *le
 		 */
 		if (coord->unit_pos &&
 		    (state_of_extent(ext - 1) == ALLOCATED_EXTENT))
-			pos_hint(flush_pos)->blk = extent_get_start(ext - 1) +
+			reiser4_pos_hint(flush_pos)->blk =
+				extent_get_start(ext - 1) +
 				extent_get_width(ext - 1);
 
 		/* allocate new block numbers for protected nodes */
-		extent_allocate_blocks(pos_hint(flush_pos), protected,
+		extent_allocate_blocks(reiser4_pos_hint(flush_pos),
+				       protected,
 				       &first_allocated, &allocated,
 				       block_stage);
 
 		/* prepare extent which will be copied to left */
-		set_extent(&copy_extent, first_allocated, allocated);
+		reiser4_set_extent(&copy_extent, first_allocated, allocated);
 
 		result = put_unit_to_end(left, &key, &copy_extent);
 		if (result == -E_NODE_FULL) {
@@ -986,7 +997,7 @@ squeeze_result squalloc_extent(znode *le
 		 * overwrite: try to copy unit as it is to left neighbor and
 		 * make all first not flushprepped nodes overwrite nodes
 		 */
-		set_extent(&copy_extent, start, width);
+		reiser4_set_extent(&copy_extent, start, width);
 		result = put_unit_to_end(left, &key, &copy_extent);
 		if (result == -E_NODE_FULL)
 			return SQUEEZE_TARGET_FULL;
diff -puN fs/reiser4/plugin/item/extent_item_ops.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/item/extent_item_ops.c
--- a/fs/reiser4/plugin/item/extent_item_ops.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/item/extent_item_ops.c
@@ -12,7 +12,7 @@
 reiser4_key *max_key_inside_extent(const coord_t * coord, reiser4_key * key)
 {
 	item_key_by_coord(coord, key);
-	set_key_offset(key, get_key_offset(max_key()));
+	set_key_offset(key, get_key_offset(reiser4_max_key()));
 	return key;
 }
 
@@ -56,7 +56,8 @@ int mergeable_extent(const coord_t * p1,
 	    get_key_ordering(&key1) != get_key_ordering(&key2) ||
 	    get_key_type(&key1) != get_key_type(&key2))
 		return 0;
-	if (get_key_offset(&key1) + extent_size(p1, nr_units_extent(p1)) !=
+	if (get_key_offset(&key1) +
+	    reiser4_extent_size(p1, nr_units_extent(p1)) !=
 	    get_key_offset(&key2))
 		return 0;
 	return 1;
@@ -447,7 +448,7 @@ kill_hook_extent(const coord_t * coord, 
 	ext = extent_item(coord) + from;
 	offset =
 	    (get_key_offset(min_item_key) +
-	     extent_size(coord, from)) >> PAGE_CACHE_SHIFT;
+	     reiser4_extent_size(coord, from)) >> PAGE_CACHE_SHIFT;
 
 	assert("vs-1551", from_off >= offset);
 	assert("vs-1552", from_off - offset <= extent_get_width(ext));
@@ -571,10 +572,12 @@ kill_units_extent(coord_t * coord, pos_i
 	if (result == ITEM_TAIL_KILLED) {
 		assert("vs-1553",
 		       get_key_offset(pfrom_key) >=
-		       get_key_offset(&item_key) + extent_size(coord, from));
+		       get_key_offset(&item_key) +
+		       reiser4_extent_size(coord, from));
 		off =
-		    get_key_offset(pfrom_key) - (get_key_offset(&item_key) +
-						 extent_size(coord, from));
+		    get_key_offset(pfrom_key) -
+			(get_key_offset(&item_key) +
+			 reiser4_extent_size(coord, from));
 		if (off) {
 			/* unit @from is to be cut partially. Its width decreases */
 			ext = extent_item(coord) + from;
@@ -594,9 +597,11 @@ kill_units_extent(coord_t * coord, pos_i
 							 1)) == 0);
 		assert("",
 		       get_key_offset(pto_key) + 1 >
-		       get_key_offset(&item_key) + extent_size(coord, to));
+		       get_key_offset(&item_key) +
+		       reiser4_extent_size(coord, to));
 		max_to_offset =
-		    get_key_offset(&item_key) + extent_size(coord, to + 1) - 1;
+		    get_key_offset(&item_key) +
+			reiser4_extent_size(coord, to + 1) - 1;
 		assert("", get_key_offset(pto_key) <= max_to_offset);
 
 		rest =
@@ -709,10 +714,10 @@ cut_units_extent(coord_t * coord, pos_in
 
 	assert("vs-1553",
 	       get_key_offset(pfrom_key) >=
-	       get_key_offset(&item_key) + extent_size(coord, from));
+	       get_key_offset(&item_key) + reiser4_extent_size(coord, from));
 	off =
 	    get_key_offset(pfrom_key) - (get_key_offset(&item_key) +
-					 extent_size(coord, from));
+					 reiser4_extent_size(coord, from));
 	if (off) {
 		/* tail of unit @from is to be cut partially. Its width decreases */
 		assert("vs-1582", new_first == NULL);
@@ -723,10 +728,12 @@ cut_units_extent(coord_t * coord, pos_in
 
 	assert("vs-1554",
 	       get_key_offset(pto_key) <=
-	       get_key_offset(&item_key) + extent_size(coord, to + 1) - 1);
+	       get_key_offset(&item_key) +
+	       reiser4_extent_size(coord, to + 1) - 1);
 	off =
-	    (get_key_offset(&item_key) + extent_size(coord, to + 1) - 1) -
-	    get_key_offset(pto_key);
+		(get_key_offset(&item_key) +
+		 reiser4_extent_size(coord, to + 1) - 1) -
+		get_key_offset(pto_key);
 	if (off) {
 		/* @to_key is smaller than max key of unit @to. Unit @to will not be removed. It gets start increased
 		   and width decreased. */
@@ -752,7 +759,7 @@ reiser4_key *unit_key_extent(const coord
 	item_key_by_coord(coord, key);
 	set_key_offset(key,
 		       (get_key_offset(key) +
-			extent_size(coord, coord->unit_pos)));
+			reiser4_extent_size(coord, coord->unit_pos)));
 
 	return key;
 }
@@ -765,7 +772,7 @@ reiser4_key *max_unit_key_extent(const c
 	item_key_by_coord(coord, key);
 	set_key_offset(key,
 		       (get_key_offset(key) +
-			extent_size(coord, coord->unit_pos + 1) - 1));
+			reiser4_extent_size(coord, coord->unit_pos + 1) - 1));
 	return key;
 }
 
@@ -779,8 +786,8 @@ reiser4_key *max_unit_key_extent(const c
    possible check of the consistency of the item that the inventor can
    construct
 */
-int check_extent(const coord_t * coord /* coord of item to check */ ,
-		 const char **error /* where to store error message */ )
+int reiser4_check_extent(const coord_t * coord /* coord of item to check */,
+			 const char **error /* where to store error message */)
 {
 	reiser4_extent *ext, *first;
 	unsigned i, j;
diff -puN fs/reiser4/plugin/item/internal.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/item/internal.c
--- a/fs/reiser4/plugin/item/internal.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/item/internal.c
@@ -62,7 +62,8 @@ static internal_item_layout *internal_at
 	return (internal_item_layout *) item_body_by_coord(coord);
 }
 
-void update_internal(const coord_t * coord, const reiser4_block_nr * blocknr)
+void reiser4_update_internal(const coord_t * coord,
+			     const reiser4_block_nr * blocknr)
 {
 	internal_item_layout *item = internal_at(coord);
 	assert("nikita-2959", reiser4_blocknr_is_sane(blocknr));
@@ -114,7 +115,7 @@ utmost_child_real_block_internal(const c
 	*block = pointer_at(coord);
 	assert("nikita-2961", reiser4_blocknr_is_sane(block));
 
-	if (blocknr_is_fake(block)) {
+	if (reiser4_blocknr_is_fake(block)) {
 		*block = 0;
 	}
 
@@ -246,7 +247,7 @@ int create_hook_internal(const coord_t *
 	 * item to little endian byte order.
 	 */
 	child_ptr = get_unaligned((__u64 *)item_body_by_coord(item));
-	update_internal(item, &child_ptr);
+	reiser4_update_internal(item, &child_ptr);
 
 	child = znode_at(item, item->node);
 	if (child != NULL && !IS_ERR(child)) {
diff -puN fs/reiser4/plugin/item/internal.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/item/internal.h
--- a/fs/reiser4/plugin/item/internal.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/item/internal.h
@@ -31,15 +31,15 @@ extern int kill_hook_internal(const coor
 			      pos_in_node_t count, struct carry_kill_data *);
 extern int shift_hook_internal(const coord_t * item, unsigned from,
 			       unsigned count, znode * old_node);
-extern void print_internal(const char *prefix, coord_t * coord);
+extern void reiser4_print_internal(const char *prefix, coord_t * coord);
 
 extern int utmost_child_internal(const coord_t * coord, sideof side,
 				 jnode ** child);
 int utmost_child_real_block_internal(const coord_t * coord, sideof side,
 				     reiser4_block_nr * block);
 
-extern void update_internal(const coord_t * coord,
-			    const reiser4_block_nr * blocknr);
+extern void reiser4_update_internal(const coord_t * coord,
+				    const reiser4_block_nr * blocknr);
 /* FIXME: reiserfs has check_internal */
 extern int check__internal(const coord_t * coord, const char **error);
 
diff -puN fs/reiser4/plugin/item/item.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/item/item.c
--- a/fs/reiser4/plugin/item/item.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/item/item.c
@@ -442,7 +442,7 @@ item_plugin item_plugins[LAST_ITEM_ID] =
 			.estimate = estimate_cde,
 			.item_data_by_flow = NULL,
 #if REISER4_DEBUG
-			.check = check_cde
+			.check = reiser4_check_cde
 #endif
 		},
 		.f = {
@@ -502,7 +502,7 @@ item_plugin item_plugins[LAST_ITEM_ID] =
 			.utmost_child = utmost_child_internal,
 			.utmost_child_real_block =
 			utmost_child_real_block_internal,
-			.update = update_internal,
+			.update = reiser4_update_internal,
 			.scan = NULL,
 			.convert = NULL
 		},
@@ -544,7 +544,7 @@ item_plugin item_plugins[LAST_ITEM_ID] =
 			.estimate = NULL,
 			.item_data_by_flow = NULL,
 #if REISER4_DEBUG
-			.check = check_extent
+			.check = reiser4_check_extent
 #endif
 		},
 		.f = {
@@ -552,17 +552,17 @@ item_plugin item_plugins[LAST_ITEM_ID] =
 			.utmost_child_real_block =
 			utmost_child_real_block_extent,
 			.update = NULL,
-			.scan = scan_extent,
+			.scan = reiser4_scan_extent,
 			.convert = NULL,
 			.key_by_offset = key_by_offset_extent
 		},
 		.s = {
 			.file = {
-				.write = write_extent,
-				.read = read_extent,
-				.readpage = readpage_extent,
+				.write = reiser4_write_extent,
+				.read = reiser4_read_extent,
+				.readpage = reiser4_readpage_extent,
 				.get_block = get_block_address_extent,
-				.readpages = readpages_extent,
+				.readpages = reiser4_readpages_extent,
 				.append_key = append_key_extent,
 				.init_coord_extension =
 				init_coord_extension_extent
@@ -612,8 +612,8 @@ item_plugin item_plugins[LAST_ITEM_ID] =
 		},
 		.s = {
 			.file = {
-				.write = write_tail,
-				.read = read_tail,
+				.write = reiser4_write_tail,
+				.read = reiser4_read_tail,
 				.readpage = readpage_tail,
 				.get_block = NULL,
 				.readpages = NULL,
diff -puN fs/reiser4/plugin/item/item.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/item/item.h
--- a/fs/reiser4/plugin/item/item.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/item/item.h
@@ -56,7 +56,7 @@ typedef struct {
 	   For items that occupy exactly one key (like stat-data)
 	   this method should return this key. For items that can
 	   grow indefinitely (extent, directory item) this should
-	   return max_key().
+	   return reiser4_max_key().
 
 	   For example extent with the key
 
@@ -91,8 +91,8 @@ typedef struct {
 	   item */
 	int (*init) (coord_t * target, coord_t * from,
 		     reiser4_item_data * data);
-	/* method called (e.g., by resize_item()) to place new data into
-	   item when it grows */
+	/* method called (e.g., by reiser4_resize_item()) to place new data
+	   into item when it grows */
 	int (*paste) (coord_t *, reiser4_item_data *, carry_plugin_info *);
 	/* return true if paste into @coord is allowed to skip
 	   carry. That is, if such paste would require any changes
diff -puN fs/reiser4/plugin/item/sde.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/item/sde.c
--- a/fs/reiser4/plugin/item/sde.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/item/sde.c
@@ -175,8 +175,8 @@ int rem_entry_de(struct inode *dir /* di
 
 int max_name_len_de(const struct inode *dir)
 {
-	return tree_by_inode(dir)->nplug->max_item_size() -
-	    sizeof(directory_entry_format) - 2;
+	return reiser4_tree_by_inode(dir)->nplug->max_item_size() -
+		sizeof(directory_entry_format) - 2;
 }
 
 /* Make Linus happy.
diff -puN fs/reiser4/plugin/item/static_stat.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/item/static_stat.c
--- a/fs/reiser4/plugin/item/static_stat.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/item/static_stat.c
@@ -85,7 +85,7 @@ int init_inode_static_sd(struct inode *i
 	state = reiser4_inode_data(inode);
 	mask = le16_to_cpu(get_unaligned(&sd_base->extmask));
 	bigmask = mask;
-	inode_set_flag(inode, REISER4_SDLEN_KNOWN);
+	reiser4_inode_set_flag(inode, REISER4_SDLEN_KNOWN);
 
 	move_on(&len, &sd, sizeof *sd_base);
 	for (bit = 0, chunk = 0;
@@ -274,7 +274,7 @@ static int present_lw_sd(struct inode *i
 		if ((inode->i_mode & S_IFMT) == (S_IFREG | S_IFIFO)) {
 			inode->i_mode &= ~S_IFIFO;
 			warning("", "partially converted file is encountered");
-			inode_set_flag(inode, REISER4_PART_MIXED);
+			reiser4_inode_set_flag(inode, REISER4_PART_MIXED);
 		}
 		move_on(len, area, sizeof *sd_lw);
 		return 0;
@@ -300,7 +300,8 @@ static int save_lw_sd(struct inode *inod
 
 	sd = (reiser4_light_weight_stat *) * area;
 
-	delta = (inode_get_flag(inode, REISER4_PART_MIXED) ? S_IFIFO : 0);
+	delta = (reiser4_inode_get_flag(inode,
+					REISER4_PART_MIXED) ? S_IFIFO : 0);
 	put_unaligned(cpu_to_le16(inode->i_mode | delta), &sd->mode);
 	put_unaligned(cpu_to_le32(inode->i_nlink), &sd->nlink);
 	put_unaligned(cpu_to_le64((__u64) inode->i_size), &sd->size);
@@ -346,7 +347,7 @@ static int absent_unix_sd(struct inode *
 	inode_set_bytes(inode, inode->i_size);
 	/* mark inode as lightweight, so that caller (reiser4_lookup) will
 	   complete initialisation by copying [ug]id from a parent. */
-	inode_set_flag(inode, REISER4_LIGHT_WEIGHT);
+	reiser4_inode_set_flag(inode, REISER4_LIGHT_WEIGHT);
 	return 0;
 }
 
@@ -434,17 +435,18 @@ static int
 symlink_target_to_inode(struct inode *inode, const char *target, int len)
 {
 	assert("vs-845", inode->i_private == NULL);
-	assert("vs-846", !inode_get_flag(inode, REISER4_GENERIC_PTR_USED));
-
+	assert("vs-846", !reiser4_inode_get_flag(inode,
+						 REISER4_GENERIC_PTR_USED));
 	/* FIXME-VS: this is prone to deadlock. Not more than other similar
 	   places, though */
-	inode->i_private = kmalloc((size_t) len + 1, get_gfp_mask());
+	inode->i_private = kmalloc((size_t) len + 1,
+				   reiser4_ctx_gfp_mask_get());
 	if (!inode->i_private)
 		return RETERR(-ENOMEM);
 
 	memcpy((char *)(inode->i_private), target, (size_t) len);
 	((char *)(inode->i_private))[len] = 0;
-	inode_set_flag(inode, REISER4_GENERIC_PTR_USED);
+	reiser4_inode_set_flag(inode, REISER4_GENERIC_PTR_USED);
 	return 0;
 }
 
@@ -495,7 +497,7 @@ static int save_symlink_sd(struct inode 
 
 	result = 0;
 	sd = (reiser4_symlink_stat *) * area;
-	if (!inode_get_flag(inode, REISER4_GENERIC_PTR_USED)) {
+	if (!reiser4_inode_get_flag(inode, REISER4_GENERIC_PTR_USED)) {
 		const char *target;
 
 		target = (const char *)(inode->i_private);
@@ -604,7 +606,7 @@ static int present_plugin_sd(struct inod
 				(unsigned long long)get_inode_oid(inode));
 			return RETERR(-EINVAL);
 		}
-		plugin = plugin_by_disk_id(tree_by_inode(inode),
+		plugin = plugin_by_disk_id(reiser4_tree_by_inode(inode),
 					   type, &slot->id);
 		if (plugin == NULL)
 			return unknown_plugin(le16_to_cpu(get_unaligned(&slot->id)), inode);
@@ -824,15 +826,15 @@ static int extract_crypto_stat (struct i
 	crypto_stat_t * info;
 	assert("edward-11", !inode_crypto_stat(inode));
 	assert("edward-1413",
-	       !inode_get_flag(inode, REISER4_CRYPTO_STAT_LOADED));
+	       !reiser4_inode_get_flag(inode, REISER4_CRYPTO_STAT_LOADED));
 	/* create and attach a crypto-stat without secret key loaded */
-	info = alloc_crypto_stat(inode);
+	info = reiser4_alloc_crypto_stat(inode);
 	if (IS_ERR(info))
 		return PTR_ERR(info);
 	info->keysize = le16_to_cpu(get_unaligned(&sd->keysize));
 	memcpy(info->keyid, sd->keyid, inode_digest_plugin(inode)->fipsize);
-	attach_crypto_stat(inode, info);
-	inode_set_flag(inode, REISER4_CRYPTO_STAT_LOADED);
+	reiser4_attach_crypto_stat(inode, info);
+	reiser4_inode_set_flag(inode, REISER4_CRYPTO_STAT_LOADED);
 	return 0;
 }
 
@@ -886,13 +888,13 @@ static int save_crypto_sd(struct inode *
 	assert("edward-1415", info->keysize != 0);
 	assert("edward-76", reiser4_inode_data(inode) != NULL);
 
-	if (!inode_get_flag(inode, REISER4_CRYPTO_STAT_LOADED)) {
+	if (!reiser4_inode_get_flag(inode, REISER4_CRYPTO_STAT_LOADED)) {
 		/* file is just created */
 		sd = (reiser4_crypto_stat *) *area;
 		/* copy everything but private key to the disk stat-data */
 		put_unaligned(cpu_to_le16(info->keysize), &sd->keysize);
 		memcpy(sd->keyid, info->keyid, (size_t) dplug->fipsize);
-		inode_set_flag(inode, REISER4_CRYPTO_STAT_LOADED);
+		reiser4_inode_set_flag(inode, REISER4_CRYPTO_STAT_LOADED);
 	}
 	*area += (sizeof(*sd) + dplug->fipsize);
 	return result;
diff -puN fs/reiser4/plugin/item/tail.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/item/tail.c
--- a/fs/reiser4/plugin/item/tail.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/item/tail.c
@@ -15,7 +15,7 @@
 reiser4_key *max_key_inside_tail(const coord_t *coord, reiser4_key *key)
 {
 	item_key_by_coord(coord, key);
-	set_key_offset(key, get_key_offset(max_key()));
+	set_key_offset(key, get_key_offset(reiser4_max_key()));
 	return key;
 }
 
@@ -139,7 +139,7 @@ paste_tail(coord_t *coord, reiser4_item_
 	if (data->data) {
 		assert("vs-554", data->user == 0 || data->user == 1);
 		if (data->user) {
-			assert("nikita-3035", schedulable());
+			assert("nikita-3035", reiser4_schedulable());
 			/* copy from user space */
 			if (__copy_from_user(item + coord->unit_pos,
 					     (const char __user *)data->data,
@@ -320,9 +320,9 @@ static int do_readpage_tail(uf_coord_t *
 	inode = page->mapping->host;
 	coord_dup(&coord, &uf_coord->coord);
 
-	tap_init(&tap, &coord, &lh, ZNODE_READ_LOCK);
+	reiser4_tap_init(&tap, &coord, &lh, ZNODE_READ_LOCK);
 
-	if ((result = tap_load(&tap)))
+	if ((result = reiser4_tap_load(&tap)))
 		goto out_tap_done;
 
 	/* lookup until page is filled up. */
@@ -401,9 +401,9 @@ static int do_readpage_tail(uf_coord_t *
  out_unlock_page:
 	unlock_page(page);
  out_tap_relse:
-	tap_relse(&tap);
+	reiser4_tap_relse(&tap);
  out_tap_done:
-	tap_done(&tap);
+	reiser4_tap_done(&tap);
 	return result;
 }
 
@@ -453,7 +453,7 @@ static int overwrite_tail(flow_t *flow, 
 	assert("vs-946", flow->data);
 	assert("vs-947", coord_is_existing_unit(coord));
 	assert("vs-948", znode_is_write_locked(coord->node));
-	assert("nikita-3036", schedulable());
+	assert("nikita-3036", reiser4_schedulable());
 
 	count = item_length_by_coord(coord) - coord->unit_pos;
 	if (count > flow->length)
@@ -500,7 +500,7 @@ static ssize_t insert_first_tail(struct 
 		 */
 		if (DQUOT_ALLOC_SPACE_NODIRTY(inode, flow->length))
 			return RETERR(-EDQUOT);
-		result = insert_flow(coord, lh, flow);
+		result = reiser4_insert_flow(coord, lh, flow);
 		if (flow->length)
 			DQUOT_FREE_SPACE_NODIRTY(inode, flow->length);
 
@@ -511,9 +511,10 @@ static ssize_t insert_first_tail(struct 
 		 * file or performing tail conversion
 		 */
 		assert("", (uf_info->container == UF_CONTAINER_EMPTY ||
-			    (inode_get_flag(inode, REISER4_PART_MIXED) &&
-			     inode_get_flag(inode, REISER4_PART_IN_CONV))));
-
+			    (reiser4_inode_get_flag(inode,
+						    REISER4_PART_MIXED) &&
+			     reiser4_inode_get_flag(inode,
+						    REISER4_PART_IN_CONV))));
 		/* if file was empty - update its state */
 		if (result == 0 && uf_info->container == UF_CONTAINER_EMPTY)
 			uf_info->container = UF_CONTAINER_TAILS;
@@ -525,7 +526,7 @@ static ssize_t insert_first_tail(struct 
 		return RETERR(-EDQUOT);
 
 	to_write = flow->length;
-	result = insert_flow(coord, lh, flow);
+	result = reiser4_insert_flow(coord, lh, flow);
 	if (flow->length)
 		DQUOT_FREE_SPACE_NODIRTY(inode, flow->length);
 	return (to_write - flow->length) ? (to_write - flow->length) : result;
@@ -558,7 +559,7 @@ static ssize_t append_tail(struct inode 
 		 */
 		if (DQUOT_ALLOC_SPACE_NODIRTY(inode, flow->length))
 			return RETERR(-EDQUOT);
-		result = insert_flow(coord, lh, flow);
+		result = reiser4_insert_flow(coord, lh, flow);
 		if (flow->length)
 			DQUOT_FREE_SPACE_NODIRTY(inode, flow->length);
 		return result;
@@ -569,7 +570,7 @@ static ssize_t append_tail(struct inode 
 		return RETERR(-EDQUOT);
 
 	to_write = flow->length;
-	result = insert_flow(coord, lh, flow);
+	result = reiser4_insert_flow(coord, lh, flow);
 	if (flow->length)
 		DQUOT_FREE_SPACE_NODIRTY(inode, flow->length);
 	return (to_write - flow->length) ? (to_write - flow->length) : result;
@@ -599,7 +600,7 @@ static int write_extent_reserve_space(st
 	 *
 	 * 3. stat data update
 	 */
-	tree = tree_by_inode(inode);
+	tree = reiser4_tree_by_inode(inode);
 	count = estimate_one_insert_item(tree) +
 		estimate_insert_flow(tree->height) +
 		estimate_one_insert_item(tree);
@@ -629,7 +630,7 @@ static loff_t faultin_user_pages(const c
 }
 
 /**
- * write_extent - write method of tail item plugin
+ * reiser4_write_extent - write method of tail item plugin
  * @file: file to write to
  * @buf: address of user-space buffer
  * @count: number of bytes to write
@@ -637,8 +638,8 @@ static loff_t faultin_user_pages(const c
  *
  * Returns number of written bytes or error code.
  */
-ssize_t write_tail(struct file *file, const char __user *buf, size_t count,
-		   loff_t *pos)
+ssize_t reiser4_write_tail(struct file *file, const char __user *buf,
+			   size_t count, loff_t *pos)
 {
 	struct inode *inode;
 	struct hint hint;
@@ -692,9 +693,9 @@ ssize_t write_tail(struct file *file, co
 	/* seal and unlock znode */
 	hint.ext_coord.valid = 0;
 	if (hint.ext_coord.valid)
-		set_hint(&hint, &flow.key, ZNODE_WRITE_LOCK);
+		reiser4_set_hint(&hint, &flow.key, ZNODE_WRITE_LOCK);
 	else
-		unset_hint(&hint);
+		reiser4_unset_hint(&hint);
 
 	save_file_hint(file, &hint);
 	return result;
@@ -718,7 +719,7 @@ coord_matches_key_tail(const coord_t * c
 #endif
 
 /* plugin->u.item.s.file.read */
-int read_tail(struct file *file UNUSED_ARG, flow_t *f, hint_t *hint)
+int reiser4_read_tail(struct file *file UNUSED_ARG, flow_t *f, hint_t *hint)
 {
 	unsigned count;
 	int item_length;
@@ -734,7 +735,7 @@ int read_tail(struct file *file UNUSED_A
 	assert("vs-1117", znode_is_rlocked(coord->node));
 	assert("vs-1118", znode_is_loaded(coord->node));
 
-	assert("nikita-3037", schedulable());
+	assert("nikita-3037", reiser4_schedulable());
 	assert("vs-1357", coord_matches_key_tail(coord, &f->key));
 
 	/* calculate number of bytes to read off the item */
diff -puN fs/reiser4/plugin/item/tail.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/item/tail.h
--- a/fs/reiser4/plugin/item/tail.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/item/tail.h
@@ -33,9 +33,9 @@ int kill_units_tail(coord_t *, pos_in_no
 reiser4_key *unit_key_tail(const coord_t *, reiser4_key *);
 
 /* plugin->u.item.s.* */
-ssize_t write_tail(struct file *file, const char __user *buf, size_t count,
-		   loff_t *pos);
-int read_tail(struct file *, flow_t *, hint_t *);
+ssize_t reiser4_write_tail(struct file *file, const char __user *buf,
+			   size_t count, loff_t *pos);
+int reiser4_read_tail(struct file *, flow_t *, hint_t *);
 int readpage_tail(void *vp, struct page *page);
 reiser4_key *append_key_tail(const coord_t *, reiser4_key *);
 void init_coord_extension_tail(uf_coord_t *, loff_t offset);
diff -puN fs/reiser4/plugin/node/node.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/node/node.c
--- a/fs/reiser4/plugin/node/node.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/node/node.c
@@ -74,7 +74,7 @@ reiser4_key *leftmost_key_in_node(const 
 		coord_init_first_unit(&first_item, (znode *) node);
 		item_key_by_coord(&first_item, key);
 	} else
-		*key = *max_key();
+		*key = *reiser4_max_key();
 	return key;
 }
 
diff -puN fs/reiser4/plugin/node/node40.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/node/node40.c
--- a/fs/reiser4/plugin/node/node40.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/node/node40.c
@@ -389,8 +389,8 @@ node_search_result lookup_node40(znode *
 			/* screw up */
 			warning("nikita-587", "Key less than %i key in a node",
 				left);
-			print_key("key", key);
-			print_key("min", &bstop->key);
+			reiser4_print_key("key", key);
+			reiser4_print_key("min", &bstop->key);
 			print_coord_content("coord", coord);
 			return RETERR(-EIO);
 		} else {
@@ -404,7 +404,7 @@ node_search_result lookup_node40(znode *
 	if (unlikely(iplug == NULL)) {
 		warning("nikita-588", "Unknown plugin %i",
 			le16_to_cpu(get_unaligned(&bstop->plugin_id)));
-		print_key("key", key);
+		reiser4_print_key("key", key);
 		print_coord_content("coord", coord);
 		return RETERR(-EIO);
 	}
@@ -493,7 +493,7 @@ int check_node40(const znode * node /* n
 	if (flags & REISER4_NODE_DKEYS)
 		prev = *znode_get_ld_key((znode *) node);
 	else
-		prev = *min_key();
+		prev = *reiser4_min_key();
 
 	old_offset = 0;
 	coord_init_zero(&coord);
@@ -848,7 +848,7 @@ create_item_node40(coord_t *target, cons
 			   from userspace was valid and data bytes were
 			   available? How will we return -EFAULT of some kind
 			   without this check? */
-			assert("nikita-3038", schedulable());
+			assert("nikita-3038", reiser4_schedulable());
 			/* copy data from user space */
 			__copy_from_user(zdata(target->node) + offset,
 					 (const char __user *)data->data,
@@ -2065,7 +2065,7 @@ prepare_for_update(znode * left, znode *
 		else
 			reference = op->node;
 		assert("nikita-2992", reference != NULL);
-		cn = add_carry(info->todo, POOLO_BEFORE, reference);
+		cn = reiser4_add_carry(info->todo, POOLO_BEFORE, reference);
 		if (IS_ERR(cn))
 			return PTR_ERR(cn);
 		cn->parent = 1;
@@ -2484,7 +2484,8 @@ void *shift_check_prepare(const znode * 
 	    node40_num_of_items_internal(left) +
 	    node40_num_of_items_internal(right) - (mergeable ? 1 : 0);
 	data =
-		kmalloc(sizeof(struct shift_check) * nr_items, get_gfp_mask());
+		kmalloc(sizeof(struct shift_check) * nr_items,
+			reiser4_ctx_gfp_mask_get());
 	if (data != NULL) {
 		coord_t coord;
 		pos_in_node_t item_pos;
@@ -2508,8 +2509,8 @@ void *shift_check_prepare(const znode * 
 				break;
 			case EXTENT_POINTER_ID:
 				data[i].u.bytes =
-				    extent_size(&coord,
-						coord_num_units(&coord));
+					reiser4_extent_size(&coord,
+						       coord_num_units(&coord));
 				break;
 			case COMPOUND_DIR_ID:
 				data[i].u.entries = coord_num_units(&coord);
@@ -2538,7 +2539,7 @@ void *shift_check_prepare(const znode * 
 				break;
 			case EXTENT_POINTER_ID:
 				data[i - 1].u.bytes +=
-				    extent_size(&coord,
+				    reiser4_extent_size(&coord,
 						coord_num_units(&coord));
 				break;
 			case COMPOUND_DIR_ID:
@@ -2568,7 +2569,7 @@ void *shift_check_prepare(const znode * 
 				break;
 			case EXTENT_POINTER_ID:
 				data[i].u.bytes =
-				    extent_size(&coord,
+				    reiser4_extent_size(&coord,
 						coord_num_units(&coord));
 				break;
 			case COMPOUND_DIR_ID:
@@ -2640,9 +2641,10 @@ void shift_check(void *vp, const znode *
 				break;
 			case EXTENT_POINTER_ID:
 				assert("vs-1593",
-				       data[i].u.bytes == extent_size(&coord,
-								      coord_num_units
-								      (&coord)));
+				       data[i].u.bytes ==
+				       reiser4_extent_size(&coord,
+							   coord_num_units
+							   (&coord)));
 				break;
 			case COMPOUND_DIR_ID:
 				assert("vs-1594",
@@ -2662,7 +2664,7 @@ void shift_check(void *vp, const znode *
 				break;
 			case EXTENT_POINTER_ID:
 				last_bytes =
-				    extent_size(&coord,
+				    reiser4_extent_size(&coord,
 						coord_num_units(&coord));
 				break;
 			case COMPOUND_DIR_ID:
@@ -2694,9 +2696,9 @@ void shift_check(void *vp, const znode *
 		case EXTENT_POINTER_ID:
 			assert("vs-1597",
 			       data[i - 1].u.bytes ==
-			       last_bytes + extent_size(&coord,
-							coord_num_units
-							(&coord)));
+			       last_bytes + reiser4_extent_size(&coord,
+								coord_num_units
+								(&coord)));
 			break;
 
 		case COMPOUND_DIR_ID:
@@ -2728,9 +2730,10 @@ void shift_check(void *vp, const znode *
 			break;
 		case EXTENT_POINTER_ID:
 			assert("vs-1601",
-			       data[i].u.bytes == extent_size(&coord,
-							      coord_num_units
-							      (&coord)));
+			       data[i].u.bytes ==
+			       reiser4_extent_size(&coord,
+						   coord_num_units
+						   (&coord)));
 			break;
 		case COMPOUND_DIR_ID:
 			assert("vs-1602",
diff -puN fs/reiser4/plugin/object.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/object.c
--- a/fs/reiser4/plugin/object.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/object.c
@@ -93,9 +93,9 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 			.linkage = {NULL, NULL},
 		},
 		.inode_ops = {
-			.permission = permission_common,
+			.permission = reiser4_permission_common,
 			.setattr = setattr_unix_file,
-			.getattr = getattr_common
+			.getattr = reiser4_getattr_common
 		},
 		.file_ops = {
 			.llseek = generic_file_llseek,
@@ -126,10 +126,10 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 		.key_by_inode = key_by_inode_and_offset_common,
 		.set_plug_in_inode = set_plug_in_inode_common,
 		.adjust_to_parent = adjust_to_parent_common,
-		.create_object = create_object_common,	/* this is not inode_operations's create */
+		.create_object = reiser4_create_object_common,
 		.delete_object = delete_object_unix_file,
-		.add_link = add_link_common,
-		.rem_link = rem_link_common,
+		.add_link = reiser4_add_link_common,
+		.rem_link = reiser4_rem_link_common,
 		.owns_item = owns_item_unix_file,
 		.can_add_link = can_add_link_common,
 		.detach = dummyop,
@@ -168,15 +168,15 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 		.key_by_inode = bugop,
 		.set_plug_in_inode = set_plug_in_inode_common,
 		.adjust_to_parent = adjust_to_parent_common_dir,
-		.create_object = create_object_common,
-		.delete_object = delete_directory_common,
-		.add_link = add_link_common,
+		.create_object = reiser4_create_object_common,
+		.delete_object = reiser4_delete_dir_common,
+		.add_link = reiser4_add_link_common,
 		.rem_link = rem_link_common_dir,
 		.owns_item = owns_item_common_dir,
 		.can_add_link = can_add_link_common,
 		.can_rem_link = can_rem_link_common_dir,
-		.detach = detach_common_dir,
-		.bind = bind_common_dir,
+		.detach = reiser4_detach_common_dir,
+		.bind = reiser4_bind_common_dir,
 		.safelink = safelink_common,
 		.estimate = {
 			.create = estimate_create_common_dir,
@@ -204,10 +204,10 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 		},
 		.inode_ops = {
 			.readlink = generic_readlink,
-			.follow_link = follow_link_common,
-			.permission = permission_common,
-			.setattr = setattr_common,
-			.getattr = getattr_common
+			.follow_link = reiser4_follow_link_common,
+			.permission = reiser4_permission_common,
+			.setattr = reiser4_setattr_common,
+			.getattr = reiser4_getattr_common
 		},
 		/* inode->i_fop of symlink is initialized by NULL in setup_inode_ops */
 		.file_ops = {.owner = NULL},
@@ -216,10 +216,10 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 		.write_sd_by_inode = write_sd_by_inode_common,
 		.set_plug_in_inode = set_plug_in_inode_common,
 		.adjust_to_parent = adjust_to_parent_common,
-		.create_object = create_symlink,
-		.delete_object = delete_object_common,
-		.add_link = add_link_common,
-		.rem_link = rem_link_common,
+		.create_object = reiser4_create_symlink,
+		.delete_object = reiser4_delete_object_common,
+		.add_link = reiser4_add_link_common,
+		.rem_link = reiser4_rem_link_common,
 		.can_add_link = can_add_link_common,
 		.detach = dummyop,
 		.bind = dummyop,
@@ -251,9 +251,9 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 			.linkage = {NULL, NULL}
 		},
 		.inode_ops = {
-			.permission = permission_common,
-			.setattr = setattr_common,
-			.getattr = getattr_common
+			.permission = reiser4_permission_common,
+			.setattr = reiser4_setattr_common,
+			.getattr = reiser4_getattr_common
 		},
 		/* file_ops of special files (sockets, block, char, fifo) are
 		   initialized by init_special_inode. */
@@ -263,10 +263,10 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 		.write_sd_by_inode = write_sd_by_inode_common,
 		.set_plug_in_inode = set_plug_in_inode_common,
 		.adjust_to_parent = adjust_to_parent_common,
-		.create_object = create_object_common,
-		.delete_object = delete_object_common,
-		.add_link = add_link_common,
-		.rem_link = rem_link_common,
+		.create_object = reiser4_create_object_common,
+		.delete_object = reiser4_delete_object_common,
+		.add_link = reiser4_add_link_common,
+		.rem_link = reiser4_rem_link_common,
 		.owns_item = owns_item_common,
 		.can_add_link = can_add_link_common,
 		.detach = dummyop,
@@ -297,9 +297,9 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 			.linkage = {NULL, NULL}
 		},
 		.inode_ops = {
-			.permission = permission_common,
+			.permission = reiser4_permission_common,
 			.setattr = setattr_cryptcompress,
-			.getattr = getattr_common
+			.getattr = reiser4_getattr_common
 		},
 		.file_ops = {
 			.llseek = generic_file_llseek,
@@ -308,7 +308,7 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 			.aio_read = generic_file_aio_read,
 			.mmap = mmap_cryptcompress,
 			.release = release_cryptcompress,
-			.fsync = sync_common,
+			.fsync = reiser4_sync_common,
 			.sendfile = sendfile_cryptcompress
 		},
 		.as_ops = {
@@ -330,8 +330,8 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 		.create_object = create_cryptcompress,
 		.open_object = open_cryptcompress,
 		.delete_object = delete_cryptcompress,
-		.add_link = add_link_common,
-		.rem_link = rem_link_common,
+		.add_link = reiser4_add_link_common,
+		.rem_link = reiser4_rem_link_common,
 		.owns_item = owns_item_common,
 		.can_add_link = can_add_link_common,
 		.detach = dummyop,
@@ -381,25 +381,25 @@ dir_plugin dir_plugins[LAST_DIR_ID] = {
 			.linkage = {NULL, NULL}
 		},
 		.inode_ops = {
-			.create = create_common,
-			.lookup = lookup_common,
-			.link = link_common,
-			.unlink = unlink_common,
-			.symlink = symlink_common,
-			.mkdir = mkdir_common,
-			.rmdir = unlink_common,
-			.mknod = mknod_common,
-			.rename = rename_common,
-			.permission = permission_common,
-			.setattr = setattr_common,
-			.getattr = getattr_common
+			.create = reiser4_create_common,
+			.lookup = reiser4_lookup_common,
+			.link = reiser4_link_common,
+			.unlink = reiser4_unlink_common,
+			.symlink = reiser4_symlink_common,
+			.mkdir = reiser4_mkdir_common,
+			.rmdir = reiser4_unlink_common,
+			.mknod = reiser4_mknod_common,
+			.rename = reiser4_rename_common,
+			.permission = reiser4_permission_common,
+			.setattr = reiser4_setattr_common,
+			.getattr = reiser4_getattr_common
 		},
 		.file_ops = {
-			.llseek = llseek_common_dir,
+			.llseek = reiser4_llseek_dir_common,
 			.read = generic_read_dir,
-			.readdir = readdir_common,
-			.release = release_dir_common,
-			.fsync = sync_common
+			.readdir = reiser4_readdir_common,
+			.release = reiser4_release_dir_common,
+			.fsync = reiser4_sync_common
 		},
 		.as_ops = {
 			.writepage = bugop,
@@ -417,12 +417,12 @@ dir_plugin dir_plugins[LAST_DIR_ID] = {
 		.is_name_acceptable = is_name_acceptable_common,
 		.build_entry_key = build_entry_key_hashed,
 		.build_readdir_key = build_readdir_key_common,
-		.add_entry = add_entry_common,
-		.rem_entry = rem_entry_common,
-		.init = init_common,
-		.done = done_common,
-		.attach = attach_common,
-		.detach = detach_common,
+		.add_entry = reiser4_add_entry_common,
+		.rem_entry = reiser4_rem_entry_common,
+		.init = reiser4_dir_init_common,
+		.done = reiser4_dir_done_common,
+		.attach = reiser4_attach_common,
+		.detach = reiser4_detach_common,
 		.estimate = {
 			.add_entry = estimate_add_entry_common,
 			.rem_entry = estimate_rem_entry_common,
@@ -441,25 +441,25 @@ dir_plugin dir_plugins[LAST_DIR_ID] = {
 			.linkage = {NULL, NULL}
 		},
 		.inode_ops = {
-			.create = create_common,
-			.lookup = lookup_common,
-			.link = link_common,
-			.unlink = unlink_common,
-			.symlink = symlink_common,
-			.mkdir = mkdir_common,
-			.rmdir = unlink_common,
-			.mknod = mknod_common,
-			.rename = rename_common,
-			.permission = permission_common,
-			.setattr = setattr_common,
-			.getattr = getattr_common
+			.create = reiser4_create_common,
+			.lookup = reiser4_lookup_common,
+			.link = reiser4_link_common,
+			.unlink = reiser4_unlink_common,
+			.symlink = reiser4_symlink_common,
+			.mkdir = reiser4_mkdir_common,
+			.rmdir = reiser4_unlink_common,
+			.mknod = reiser4_mknod_common,
+			.rename = reiser4_rename_common,
+			.permission = reiser4_permission_common,
+			.setattr = reiser4_setattr_common,
+			.getattr = reiser4_getattr_common
 		},
 		.file_ops = {
-			.llseek = llseek_common_dir,
+			.llseek = reiser4_llseek_dir_common,
 			.read =	generic_read_dir,
-			.readdir = readdir_common,
-			.release = release_dir_common,
-			.fsync = sync_common
+			.readdir = reiser4_readdir_common,
+			.release = reiser4_release_dir_common,
+			.fsync = reiser4_sync_common
 		},
 		.as_ops = {
 			.writepage = bugop,
@@ -477,12 +477,12 @@ dir_plugin dir_plugins[LAST_DIR_ID] = {
 		.is_name_acceptable = is_name_acceptable_common,
 		.build_entry_key = build_entry_key_seekable,
 		.build_readdir_key = build_readdir_key_common,
-		.add_entry = add_entry_common,
-		.rem_entry = rem_entry_common,
-		.init = init_common,
-		.done = done_common,
-		.attach = attach_common,
-		.detach = detach_common,
+		.add_entry = reiser4_add_entry_common,
+		.rem_entry = reiser4_rem_entry_common,
+		.init = reiser4_dir_init_common,
+		.done = reiser4_dir_done_common,
+		.attach = reiser4_attach_common,
+		.detach = reiser4_detach_common,
 		.estimate = {
 			.add_entry = estimate_add_entry_common,
 			.rem_entry = estimate_rem_entry_common,
diff -puN fs/reiser4/plugin/object.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/object.h
--- a/fs/reiser4/plugin/object.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/object.h
@@ -9,31 +9,33 @@
 #include "../type_safe_hash.h"
 
 /* common implementations of inode operations */
-int create_common(struct inode *parent, struct dentry *dentry,
-		  int mode, struct nameidata *);
-struct dentry *lookup_common(struct inode *parent, struct dentry *dentry,
-			     struct nameidata *nameidata);
-int link_common(struct dentry *existing, struct inode *parent,
-		struct dentry *newname);
-int unlink_common(struct inode *parent, struct dentry *victim);
-int mkdir_common(struct inode *parent, struct dentry *dentry, int mode);
-int symlink_common(struct inode *parent, struct dentry *dentry,
+int reiser4_create_common(struct inode *parent, struct dentry *dentry,
+			  int mode, struct nameidata *);
+struct dentry * reiser4_lookup_common(struct inode *parent,
+				      struct dentry *dentry,
+				      struct nameidata *nameidata);
+int reiser4_link_common(struct dentry *existing, struct inode *parent,
+			struct dentry *newname);
+int reiser4_unlink_common(struct inode *parent, struct dentry *victim);
+int reiser4_mkdir_common(struct inode *parent, struct dentry *dentry, int mode);
+int reiser4_symlink_common(struct inode *parent, struct dentry *dentry,
 		   const char *linkname);
-int mknod_common(struct inode *parent, struct dentry *dentry,
+int reiser4_mknod_common(struct inode *parent, struct dentry *dentry,
 		 int mode, dev_t rdev);
-int rename_common(struct inode *old_dir, struct dentry *old_name,
-		  struct inode *new_dir, struct dentry *new_name);
-void *follow_link_common(struct dentry *, struct nameidata *data);
-int permission_common(struct inode *, int mask,	/* mode bits to check permissions for */
-		      struct nameidata *nameidata);
-int setattr_common(struct dentry *, struct iattr *);
-int getattr_common(struct vfsmount *mnt, struct dentry *, struct kstat *);
+int reiser4_rename_common(struct inode *old_dir, struct dentry *old_name,
+			  struct inode *new_dir, struct dentry *new_name);
+void *reiser4_follow_link_common(struct dentry *, struct nameidata *data);
+int reiser4_permission_common(struct inode *, int mask,
+			      struct nameidata *nameidata);
+int reiser4_setattr_common(struct dentry *, struct iattr *);
+int reiser4_getattr_common(struct vfsmount *mnt, struct dentry *,
+			   struct kstat *);
 
 /* common implementations of file operations */
-loff_t llseek_common_dir(struct file *, loff_t off, int origin);
-int readdir_common(struct file *, void *dirent, filldir_t);
-int release_dir_common(struct inode *, struct file *);
-int sync_common(struct file *, struct dentry *, int datasync);
+loff_t reiser4_llseek_dir_common(struct file *, loff_t off, int origin);
+int reiser4_readdir_common(struct file *, void *dirent, filldir_t);
+int reiser4_release_dir_common(struct inode *, struct file *);
+int reiser4_sync_common(struct file *, struct dentry *, int datasync);
 
 /* common implementations of address space operations */
 int prepare_write_common(struct file *, struct page *, unsigned from,
@@ -50,20 +52,20 @@ int adjust_to_parent_common_dir(struct i
 				struct inode *root);
 int adjust_to_parent_cryptcompress(struct inode *object, struct inode *parent,
 				   struct inode *root);
-int create_object_common(struct inode *object, struct inode *parent,
-			 reiser4_object_create_data *);
-int delete_object_common(struct inode *);
-int delete_directory_common(struct inode *);
-int add_link_common(struct inode *object, struct inode *parent);
-int rem_link_common(struct inode *object, struct inode *parent);
+int reiser4_create_object_common(struct inode *object, struct inode *parent,
+				 reiser4_object_create_data *);
+int reiser4_delete_object_common(struct inode *);
+int reiser4_delete_dir_common(struct inode *);
+int reiser4_add_link_common(struct inode *object, struct inode *parent);
+int reiser4_rem_link_common(struct inode *object, struct inode *parent);
 int rem_link_common_dir(struct inode *object, struct inode *parent);
 int owns_item_common(const struct inode *, const coord_t *);
 int owns_item_common_dir(const struct inode *, const coord_t *);
 int can_add_link_common(const struct inode *);
 int can_rem_link_common_dir(const struct inode *);
-int detach_common_dir(struct inode *child, struct inode *parent);
+int reiser4_detach_common_dir(struct inode *child, struct inode *parent);
 int open_cryptcompress(struct inode * inode, struct file * file);
-int bind_common_dir(struct inode *child, struct inode *parent);
+int reiser4_bind_common_dir(struct inode *child, struct inode *parent);
 int safelink_common(struct inode *, reiser4_safe_link_t, __u64 value);
 reiser4_block_nr estimate_create_common(const struct inode *);
 reiser4_block_nr estimate_create_common_dir(const struct inode *);
@@ -84,15 +86,15 @@ int is_name_acceptable_common(const stru
 void build_entry_key_common(const struct inode *,
 			    const struct qstr *qname, reiser4_key *);
 int build_readdir_key_common(struct file *dir, reiser4_key *);
-int add_entry_common(struct inode *object, struct dentry *where,
+int reiser4_add_entry_common(struct inode *object, struct dentry *where,
 		     reiser4_object_create_data *, reiser4_dir_entry_desc *);
-int rem_entry_common(struct inode *object, struct dentry *where,
+int reiser4_rem_entry_common(struct inode *object, struct dentry *where,
 		     reiser4_dir_entry_desc *);
-int init_common(struct inode *object, struct inode *parent,
-		reiser4_object_create_data *);
-int done_common(struct inode *);
-int attach_common(struct inode *child, struct inode *parent);
-int detach_common(struct inode *object, struct inode *parent);
+int reiser4_dir_init_common(struct inode *object, struct inode *parent,
+			    reiser4_object_create_data *);
+int reiser4_dir_done_common(struct inode *);
+int reiser4_attach_common(struct inode *child, struct inode *parent);
+int reiser4_detach_common(struct inode *object, struct inode *parent);
 reiser4_block_nr estimate_add_entry_common(const struct inode *);
 reiser4_block_nr estimate_rem_entry_common(const struct inode *);
 reiser4_block_nr dir_estimate_unlink_common(const struct inode *,
diff -puN fs/reiser4/plugin/plugin.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/plugin.c
--- a/fs/reiser4/plugin/plugin.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/plugin.c
@@ -236,22 +236,21 @@ int init_plugins(void)
 }
 
 /* true if plugin type id is valid */
-int is_type_id_valid(reiser4_plugin_type type_id /* plugin type id */ )
+int is_plugin_type_valid(reiser4_plugin_type type)
 {
-	/* "type_id" is unsigned, so no comparison with 0 is
+	/* "type" is unsigned, so no comparison with 0 is
 	   necessary */
-	return (type_id < REISER4_PLUGIN_TYPES);
+	return (type < REISER4_PLUGIN_TYPES);
 }
 
 /* true if plugin id is valid */
-int is_plugin_id_valid(reiser4_plugin_type type_id /* plugin type id */ ,
-		       reiser4_plugin_id id /* plugin id */ )
+int is_plugin_id_valid(reiser4_plugin_type type, reiser4_plugin_id id)
 {
-	assert("nikita-1653", is_type_id_valid(type_id));
-	return id < plugins[type_id].builtin_num;
+	assert("nikita-1653", is_plugin_type_valid(type));
+	return id < plugins[type].builtin_num;
 }
 
-/* return plugin by its @type_id and @id.
+/* return plugin by its @type and @id.
 
    Both arguments are checked for validness: this is supposed to be called
    from user-level.
@@ -261,22 +260,21 @@ user space, and passed to the filesystem
 comment really confused me on the first reading....
 
 */
-reiser4_plugin *plugin_by_unsafe_id(reiser4_plugin_type type_id	/* plugin
-								 * type id,
-								 * unchecked */ ,
+reiser4_plugin *plugin_by_unsafe_id(reiser4_plugin_type type /* plugin type
+								 * unchecked */,
 				    reiser4_plugin_id id	/* plugin id,
-								 * unchecked */ )
+								 * unchecked */)
 {
-	if (is_type_id_valid(type_id)) {
-		if (is_plugin_id_valid(type_id, id))
-			return plugin_at(&plugins[type_id], id);
+	if (is_plugin_type_valid(type)) {
+		if (is_plugin_id_valid(type, id))
+			return plugin_at(&plugins[type], id);
 		else
 			/* id out of bounds */
 			warning("nikita-2913",
-				"Invalid plugin id: [%i:%i]", type_id, id);
+				"Invalid plugin id: [%i:%i]", type, id);
 	} else
 		/* type_id out of bounds */
-		warning("nikita-2914", "Invalid type_id: %i", type_id);
+		warning("nikita-2914", "Invalid type_id: %i", type);
 	return NULL;
 }
 
@@ -298,11 +296,10 @@ int save_plugin_id(reiser4_plugin *plugi
 }
 
 /* list of all plugins of given type */
-struct list_head *get_plugin_list(reiser4_plugin_type type_id	/* plugin type
-								 * id */ )
+struct list_head *get_plugin_list(reiser4_plugin_type type)
 {
-	assert("nikita-1056", is_type_id_valid(type_id));
-	return &plugins[type_id].plugins_list;
+	assert("nikita-1056", is_plugin_type_valid(type));
+	return &plugins[type].plugins_list;
 }
 
 int grab_plugin(struct inode *self, struct inode *ancestor, pset_member memb)
diff -puN fs/reiser4/plugin/plugin_header.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/plugin_header.h
--- a/fs/reiser4/plugin/plugin_header.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/plugin_header.h
@@ -77,8 +77,8 @@ typedef struct reiser4_plugin_type_data 
 
 extern reiser4_plugin_type_data plugins[REISER4_PLUGIN_TYPES];
 
-int is_type_id_valid(reiser4_plugin_type type_id);
-int is_plugin_id_valid(reiser4_plugin_type type_id, reiser4_plugin_id id);
+int is_plugin_type_valid(reiser4_plugin_type type);
+int is_plugin_id_valid(reiser4_plugin_type type, reiser4_plugin_id id);
 
 static inline reiser4_plugin *plugin_at(reiser4_plugin_type_data * ptype, int i)
 {
@@ -89,14 +89,12 @@ static inline reiser4_plugin *plugin_at(
 }
 
 /* return plugin by its @type_id and @id */
-static inline reiser4_plugin *plugin_by_id(reiser4_plugin_type type_id
-					   /* plugin type id */ ,
-					   reiser4_plugin_id id /* plugin id */
-					   )
+static inline reiser4_plugin *plugin_by_id(reiser4_plugin_type type,
+					   reiser4_plugin_id id)
 {
-	assert("nikita-1651", is_type_id_valid(type_id));
-	assert("nikita-1652", is_plugin_id_valid(type_id, id));
-	return plugin_at(&plugins[type_id], id);
+	assert("nikita-1651", is_plugin_type_valid(type));
+	assert("nikita-1652", is_plugin_id_valid(type, id));
+	return plugin_at(&plugins[type], id);
 }
 
 extern reiser4_plugin *plugin_by_unsafe_id(reiser4_plugin_type type_id,
diff -puN fs/reiser4/plugin/plugin_set.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/plugin_set.c
--- a/fs/reiser4/plugin/plugin_set.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/plugin_set.c
@@ -121,7 +121,7 @@ pshash(ps_hash_table * table, const unsi
 }
 
 /* The hash table definition */
-#define KMALLOC(size) kmalloc((size), get_gfp_mask())
+#define KMALLOC(size) kmalloc((size), reiser4_ctx_gfp_mask_get())
 #define KFREE(ptr, size) kfree(ptr)
 TYPE_SAFE_HASH_DEFINE(ps, plugin_set, unsigned long, hashval, link, pshash,
 		      pseq);
@@ -186,7 +186,8 @@ static int plugin_set_field(plugin_set *
 	twin = ps_hash_find(&ps_table, &replica.hashval);
 	if (unlikely(twin == NULL)) {
 		rcu_read_unlock();
-		psal = kmem_cache_alloc(plugin_set_slab, get_gfp_mask());
+		psal = kmem_cache_alloc(plugin_set_slab,
+					reiser4_ctx_gfp_mask_get());
 		if (psal == NULL)
 			return RETERR(-ENOMEM);
 		*psal = replica;
diff -puN fs/reiser4/plugin/space/bitmap.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/space/bitmap.c
--- a/fs/reiser4/plugin/space/bitmap.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/space/bitmap.c
@@ -617,7 +617,7 @@ check_block_range(const reiser4_block_nr
 
 	assert("zam-455", start != NULL);
 	assert("zam-437", *start != 0);
-	assert("zam-541", !blocknr_is_fake(start));
+	assert("zam-541", !reiser4_blocknr_is_fake(start));
 	assert("zam-441", *start < reiser4_block_count(sb));
 
 	if (len != NULL) {
@@ -818,7 +818,7 @@ static int load_and_lock_bnode(struct bi
 	jnode *cjnode;
 	jnode *wjnode;
 
-	assert("nikita-3040", schedulable());
+	assert("nikita-3040", reiser4_schedulable());
 
 /* ZAM-FIXME-HANS: since bitmaps are never unloaded, this does not
  * need to be atomic, right? Just leave a comment that if bitmaps were
@@ -1180,10 +1180,9 @@ static int alloc_blocks_backward(reiser4
 }
 
 /* plugin->u.space_allocator.alloc_blocks() */
-int
-alloc_blocks_bitmap(reiser4_space_allocator * allocator UNUSED_ARG,
-		    reiser4_blocknr_hint * hint, int needed,
-		    reiser4_block_nr * start, reiser4_block_nr * len)
+int reiser4_alloc_blocks_bitmap(reiser4_space_allocator * allocator,
+				reiser4_blocknr_hint * hint, int needed,
+				reiser4_block_nr * start, reiser4_block_nr * len)
 {
 	if (hint->backward)
 		return alloc_blocks_backward(hint, needed, start, len);
@@ -1195,9 +1194,8 @@ alloc_blocks_bitmap(reiser4_space_alloca
    nodes deletion is deferred until transaction commit.  However, deallocation
    of temporary objects like wandered blocks and transaction commit records
    requires immediate node deletion from WORKING BITMAP.*/
-void
-dealloc_blocks_bitmap(reiser4_space_allocator * allocator UNUSED_ARG,
-		      reiser4_block_nr start, reiser4_block_nr len)
+void reiser4_dealloc_blocks_bitmap(reiser4_space_allocator * allocator,
+				   reiser4_block_nr start, reiser4_block_nr len)
 {
 	struct super_block *super = reiser4_get_current_sb();
 
@@ -1230,9 +1228,8 @@ dealloc_blocks_bitmap(reiser4_space_allo
 }
 
 /* plugin->u.space_allocator.check_blocks(). */
-void
-check_blocks_bitmap(const reiser4_block_nr * start,
-		    const reiser4_block_nr * len, int desired)
+void reiser4_check_blocks_bitmap(const reiser4_block_nr * start,
+				 const reiser4_block_nr * len, int desired)
 {
 #if REISER4_DEBUG
 	struct super_block *super = reiser4_get_current_sb();
@@ -1367,7 +1364,7 @@ apply_dset_to_commit_bmap(txn_atom * ato
    only one transaction can be committed a time, therefore it is safe to access
    some global variables without any locking */
 
-int pre_commit_hook_bitmap(void)
+int reiser4_pre_commit_hook_bitmap(void)
 {
 	struct super_block *super = reiser4_get_current_sb();
 	txn_atom *atom;
@@ -1398,7 +1395,7 @@ int pre_commit_hook_bitmap(void)
 
 				assert("zam-559", !JF_ISSET(node, JNODE_OVRWR));
 				assert("zam-460",
-				       !blocknr_is_fake(&node->blocknr));
+				       !reiser4_blocknr_is_fake(&node->blocknr));
 
 				parse_blocknr(&node->blocknr, &bmap, &offset);
 				bn = get_bnode(super, bmap);
@@ -1459,15 +1456,14 @@ int pre_commit_hook_bitmap(void)
 
 /* plugin->u.space_allocator.init_allocator
     constructor of reiser4_space_allocator object. It is called on fs mount */
-int
-init_allocator_bitmap(reiser4_space_allocator * allocator,
-		      struct super_block *super, void *arg UNUSED_ARG)
+int reiser4_init_allocator_bitmap(reiser4_space_allocator * allocator,
+				  struct super_block *super, void *arg)
 {
 	struct bitmap_allocator_data *data = NULL;
 	bmap_nr_t bitmap_blocks_nr;
 	bmap_nr_t i;
 
-	assert("nikita-3039", schedulable());
+	assert("nikita-3039", reiser4_schedulable());
 
 	/* getting memory for bitmap allocator private data holder */
 	data =
@@ -1517,7 +1513,8 @@ init_allocator_bitmap(reiser4_space_allo
 			bnode = data->bitmap + i;
 			ret = load_and_lock_bnode(bnode);
 			if (ret) {
-				destroy_allocator_bitmap(allocator, super);
+				reiser4_destroy_allocator_bitmap(allocator,
+								 super);
 				return ret;
 			}
 			release_and_unlock_bnode(bnode);
@@ -1534,9 +1531,8 @@ init_allocator_bitmap(reiser4_space_allo
 
 /* plugin->u.space_allocator.destroy_allocator
    destructor. It is called on fs unmount */
-int
-destroy_allocator_bitmap(reiser4_space_allocator * allocator,
-			 struct super_block *super)
+int reiser4_destroy_allocator_bitmap(reiser4_space_allocator * allocator,
+				     struct super_block *super)
 {
 	bmap_nr_t bitmap_blocks_nr;
 	bmap_nr_t i;
diff -puN fs/reiser4/plugin/space/bitmap.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/space/bitmap.h
--- a/fs/reiser4/plugin/space/bitmap.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/space/bitmap.h
@@ -11,24 +11,24 @@
 /* EDWARD-FIXME-HANS: write something as informative as the below for every .h file lacking it. */
 /* declarations of functions implementing methods of space allocator plugin for
    bitmap based allocator. The functions themselves are in bitmap.c */
-extern int init_allocator_bitmap(reiser4_space_allocator *,
-				 struct super_block *, void *);
-extern int destroy_allocator_bitmap(reiser4_space_allocator *,
-				    struct super_block *);
-extern int alloc_blocks_bitmap(reiser4_space_allocator *,
-			       reiser4_blocknr_hint *, int needed,
-			       reiser4_block_nr * start,
-			       reiser4_block_nr * len);
-extern void check_blocks_bitmap(const reiser4_block_nr *,
-				const reiser4_block_nr *, int);
+extern int reiser4_init_allocator_bitmap(reiser4_space_allocator *,
+					 struct super_block *, void *);
+extern int reiser4_destroy_allocator_bitmap(reiser4_space_allocator *,
+					    struct super_block *);
+extern int reiser4_alloc_blocks_bitmap(reiser4_space_allocator *,
+				       reiser4_blocknr_hint *, int needed,
+				       reiser4_block_nr * start,
+				       reiser4_block_nr * len);
+extern void reiser4_check_blocks_bitmap(const reiser4_block_nr *,
+					const reiser4_block_nr *, int);
+extern void reiser4_dealloc_blocks_bitmap(reiser4_space_allocator *,
+					  reiser4_block_nr,
+					  reiser4_block_nr);
+extern int reiser4_pre_commit_hook_bitmap(void);
 
-extern void dealloc_blocks_bitmap(reiser4_space_allocator *, reiser4_block_nr,
-				  reiser4_block_nr);
-extern int pre_commit_hook_bitmap(void);
-
-#define post_commit_hook_bitmap() do{}while(0)
-#define post_write_back_hook_bitmap() do{}while(0)
-#define print_info_bitmap(pref, al) do{}while(0)
+#define reiser4_post_commit_hook_bitmap() do{}while(0)
+#define reiser4_post_write_back_hook_bitmap() do{}while(0)
+#define reiser4_print_info_bitmap(pref, al) do{}while(0)
 
 typedef __u64 bmap_nr_t;
 typedef __u32 bmap_off_t;
diff -puN fs/reiser4/plugin/space/space_allocator.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/plugin/space/space_allocator.h
--- a/fs/reiser4/plugin/space/space_allocator.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/plugin/space/space_allocator.h
@@ -11,47 +11,47 @@
 															\
 static inline int sa_init_allocator (reiser4_space_allocator * al, struct super_block *s, void * opaque)		\
 {															\
-	return init_allocator_##allocator (al, s, opaque);								\
+	return reiser4_init_allocator_##allocator (al, s, opaque);	                                                \
 }															\
 															\
 static inline void sa_destroy_allocator (reiser4_space_allocator *al, struct super_block *s)				\
 {															\
-	destroy_allocator_##allocator (al, s);										\
+	reiser4_destroy_allocator_##allocator (al, s);									\
 }															\
 															\
 static inline int sa_alloc_blocks (reiser4_space_allocator *al, reiser4_blocknr_hint * hint, 				\
 				   int needed, reiser4_block_nr * start, reiser4_block_nr * len)			\
 {															\
-	return alloc_blocks_##allocator (al, hint, needed, start, len);							\
+	return reiser4_alloc_blocks_##allocator (al, hint, needed, start, len);						\
 }															\
 static inline void sa_dealloc_blocks (reiser4_space_allocator * al, reiser4_block_nr start, reiser4_block_nr len)	\
 {															\
-	dealloc_blocks_##allocator (al, start, len); 									\
+	reiser4_dealloc_blocks_##allocator (al, start, len);								\
 }															\
 															\
 static inline void sa_check_blocks (const reiser4_block_nr * start, const reiser4_block_nr * end, int desired) 		\
 {															\
-	check_blocks_##allocator (start, end, desired);								        \
+	reiser4_check_blocks_##allocator (start, end, desired);							        \
 }															\
 															\
 static inline void sa_pre_commit_hook (void)										\
 { 															\
-	pre_commit_hook_##allocator ();											\
+	reiser4_pre_commit_hook_##allocator ();										\
 }															\
 															\
 static inline void sa_post_commit_hook (void) 										\
 { 															\
-	post_commit_hook_##allocator ();										\
+	reiser4_post_commit_hook_##allocator ();									\
 }															\
 															\
 static inline void sa_post_write_back_hook (void) 									\
 { 															\
-	post_write_back_hook_##allocator();										\
+	reiser4_post_write_back_hook_##allocator();									\
 }															\
 															\
 static inline void sa_print_info(const char * prefix, reiser4_space_allocator * al)					\
 {															\
-	print_info_##allocator (prefix, al);                                                                            \
+	reiser4_print_info_##allocator (prefix, al);                                                                    \
 }
 
 DEF_SPACE_ALLOCATOR(bitmap)
diff -puN fs/reiser4/pool.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/pool.c
--- a/fs/reiser4/pool.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/pool.c
@@ -124,7 +124,7 @@ static void *reiser4_pool_alloc(reiser4_
 	} else {
 		/* pool is empty. Extra allocations don't deserve dedicated
 		   slab to be served from, as they are expected to be rare. */
-		result = kmalloc(pool->obj_size, get_gfp_mask());
+		result = kmalloc(pool->obj_size, reiser4_ctx_gfp_mask_get());
 		if (result != 0) {
 			reiser4_init_pool_obj(result);
 			list_add(&result->extra_linkage, &pool->extra);
@@ -181,16 +181,15 @@ void reiser4_pool_free(reiser4_pool * po
    (that is "right" node).
 
 */
-reiser4_pool_header *add_obj(reiser4_pool * pool	/* pool from which to
-							 * allocate new object */ ,
-			     struct list_head *list,	/* list where to add
-							 * object */
-			     pool_ordering order /* where to add */ ,
-			     reiser4_pool_header * reference	/* after (or
-								 * before) which
-								 * existing
-								 * object to
-								 * add */ )
+reiser4_pool_header *reiser4_add_obj(reiser4_pool * pool /* pool from which to
+							  * allocate new object
+							  */,
+				     struct list_head *list /* list where to add
+							     * object */,
+				     pool_ordering order /* where to add */,
+				     reiser4_pool_header * reference
+				     /* after (or before) which existing object
+					to add */)
 {
 	reiser4_pool_header *result;
 
diff -puN fs/reiser4/pool.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/pool.h
--- a/fs/reiser4/pool.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/pool.h
@@ -36,9 +36,10 @@ extern void reiser4_init_pool(reiser4_po
 			      int num_of_objs, char *data);
 extern void reiser4_done_pool(reiser4_pool * pool);
 extern void reiser4_pool_free(reiser4_pool * pool, reiser4_pool_header * h);
-reiser4_pool_header *add_obj(reiser4_pool * pool, struct list_head * list,
-			     pool_ordering order,
-			     reiser4_pool_header * reference);
+reiser4_pool_header *reiser4_add_obj(reiser4_pool * pool,
+				     struct list_head * list,
+				     pool_ordering order,
+				     reiser4_pool_header * reference);
 
 /* __REISER4_POOL_H__ */
 #endif
diff -puN fs/reiser4/readahead.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/readahead.c
--- a/fs/reiser4/readahead.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/readahead.c
@@ -11,9 +11,9 @@
 
 #include <linux/swap.h>		/* for totalram_pages */
 
-void init_ra_info(ra_info_t * rai)
+void reiser4_init_ra_info(ra_info_t * rai)
 {
-	rai->key_to_stop = *min_key();
+	rai->key_to_stop = *reiser4_min_key();
 }
 
 /* global formatted node readahead parameter. It can be set by mount option -o readahead:NUM:1 */
@@ -54,7 +54,7 @@ void formatted_readahead(znode * node, r
 	lock_handle next_lh;
 
 	/* do nothing if node block number has not been assigned to node (which means it is still in cache). */
-	if (blocknr_is_fake(znode_get_block(node)))
+	if (reiser4_blocknr_is_fake(znode_get_block(node)))
 		return;
 
 	ra_params = get_current_super_ra_params();
@@ -88,7 +88,7 @@ void formatted_readahead(znode * node, r
 			break;
 
 		nextblk = znode_get_block(next_lh.node);
-		if (blocknr_is_fake(nextblk) ||
+		if (reiser4_blocknr_is_fake(nextblk) ||
 		    (ra_adjacent_only(ra_params->flags)
 		     && *nextblk != *znode_get_block(cur) + 1)) {
 			break;
@@ -122,9 +122,9 @@ void reiser4_readdir_readahead_init(stru
 	 * stat data of all files of the directory */
 	set_key_locality(stop_key, get_inode_oid(dir));
 	set_key_type(stop_key, KEY_SD_MINOR);
-	set_key_ordering(stop_key, get_key_ordering(max_key()));
-	set_key_objectid(stop_key, get_key_objectid(max_key()));
-	set_key_offset(stop_key, get_key_offset(max_key()));
+	set_key_ordering(stop_key, get_key_ordering(reiser4_max_key()));
+	set_key_objectid(stop_key, get_key_objectid(reiser4_max_key()));
+	set_key_offset(stop_key, get_key_offset(reiser4_max_key()));
 }
 
 /*
diff -puN fs/reiser4/readahead.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/readahead.h
--- a/fs/reiser4/readahead.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/readahead.h
@@ -20,7 +20,7 @@ typedef struct {
 } ra_info_t;
 
 void formatted_readahead(znode *, ra_info_t *);
-void init_ra_info(ra_info_t * rai);
+void reiser4_init_ra_info(ra_info_t * rai);
 
 struct reiser4_file_ra_state {
 	loff_t start;		/* Current window */
diff -puN fs/reiser4/safe_link.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/safe_link.c
--- a/fs/reiser4/safe_link.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/safe_link.c
@@ -170,7 +170,7 @@ int safe_link_add(struct inode *inode, r
 		length += sizeof(sl.size);
 		put_unaligned(cpu_to_le64(inode->i_size), &sl.size);
 	}
-	tree = tree_by_inode(inode);
+	tree = reiser4_tree_by_inode(inode);
 	build_link_key(tree, get_inode_oid(inode), link, &key);
 
 	result = store_black_box(tree, &key, &sl, length);
@@ -211,8 +211,8 @@ static void safe_link_iter_begin(reiser4
 	ctx->tree = tree;
 	reiser4_key_init(&ctx->key);
 	set_key_locality(&ctx->key, safe_link_locality(tree));
-	set_key_objectid(&ctx->key, get_key_objectid(max_key()));
-	set_key_offset(&ctx->key, get_key_offset(max_key()));
+	set_key_objectid(&ctx->key, get_key_objectid(reiser4_max_key()));
+	set_key_offset(&ctx->key, get_key_offset(reiser4_max_key()));
 }
 
 /*
@@ -272,17 +272,17 @@ static int process_safelink(struct super
 		assert("nikita-3428", fplug != NULL);
 		assert("", oid == get_inode_oid(inode));
 		if (fplug->safelink != NULL) {
-			/* txn_restart_current is not necessary because
+			/* reiser4_txn_restart_current is not necessary because
 			 * mounting is signle thread. However, without it
 			 * deadlock detection code will complain (see
 			 * nikita-3361). */
-			txn_restart_current();
+			reiser4_txn_restart_current();
 			result = fplug->safelink(inode, link, size);
 		} else {
 			warning("nikita-3430",
 				"Cannot handle safelink for %lli",
 				(unsigned long long)oid);
-			print_key("key", sdkey);
+			reiser4_print_key("key", sdkey);
 			result = 0;
 		}
 		if (result != 0) {
@@ -293,18 +293,18 @@ static int process_safelink(struct super
 		reiser4_iget_complete(inode);
 		iput(inode);
 		if (result == 0) {
-			result = safe_link_grab(get_tree(super), BA_CAN_COMMIT);
+			result = safe_link_grab(reiser4_get_tree(super), BA_CAN_COMMIT);
 			if (result == 0)
 				result =
-				    safe_link_del(get_tree(super), oid, link);
-			safe_link_release(get_tree(super));
+				    safe_link_del(reiser4_get_tree(super), oid, link);
+			safe_link_release(reiser4_get_tree(super));
 			/*
 			 * restart transaction: if there was large number of
 			 * safe-links, their processing may fail to fit into
 			 * single transaction.
 			 */
 			if (result == 0)
-				txn_restart_current();
+				reiser4_txn_restart_current();
 		}
 	} else
 		result = PTR_ERR(inode);
diff -puN fs/reiser4/seal.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/seal.c
--- a/fs/reiser4/seal.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/seal.c
@@ -6,9 +6,9 @@
    even a reference) to znode. In stead, each znode contains a version number,
    increased on each znode modification. This version number is copied into a
    seal when seal is created. Later, one can "validate" seal by calling
-   seal_validate(). If znode is in cache and its version number is still the
-   same, seal is "pristine" and coord associated with it can be re-used
-   immediately.
+   reiser4_seal_validate(). If znode is in cache and its version number is
+   still the same, seal is "pristine" and coord associated with it can be
+   re-used immediately.
 
    If, on the other hand, znode is out of cache, or it is obviously different
    one from the znode seal was initially attached to (for example, it is on
@@ -48,10 +48,11 @@ static int seal_matches(const seal_t * s
 
 /* initialise seal. This can be called several times on the same seal. @coord
    and @key can be NULL.  */
-void seal_init(seal_t * seal /* seal to initialise */ ,
-	       const coord_t * coord /* coord @seal will be attached to */ ,
-	       const reiser4_key * key UNUSED_ARG	/* key @seal will be
-							 * attached to */ )
+void reiser4_seal_init(seal_t * seal /* seal to initialise */ ,
+		       const coord_t * coord /* coord @seal will be
+					      *	attached to */ ,
+		       const reiser4_key * key UNUSED_ARG /* key @seal will be
+							   * attached to */ )
 {
 	assert("nikita-1886", seal != NULL);
 	memset(seal, 0, sizeof *seal);
@@ -74,22 +75,22 @@ void seal_init(seal_t * seal /* seal to 
 }
 
 /* finish with seal */
-void seal_done(seal_t * seal /* seal to clear */ )
+void reiser4_seal_done(seal_t * seal /* seal to clear */ )
 {
 	assert("nikita-1887", seal != NULL);
 	seal->version = 0;
 }
 
 /* true if seal was initialised */
-int seal_is_set(const seal_t * seal /* seal to query */ )
+int reiser4_seal_is_set(const seal_t * seal /* seal to query */ )
 {
 	assert("nikita-1890", seal != NULL);
 	return seal->version != 0;
 }
 
 #if REISER4_DEBUG
-/* helper function for seal_validate(). It checks that item at @coord has
- * expected key. This is to detect cases where node was modified but wasn't
+/* helper function for reiser4_seal_validate(). It checks that item at @coord
+ * has expected key. This is to detect cases where node was modified but wasn't
  * marked dirty. */
 static inline int check_seal_match(const coord_t * coord /* coord to check */ ,
 				   const reiser4_key * k /* expected key */ )
@@ -107,12 +108,12 @@ static inline int check_seal_match(const
 }
 #endif
 
-/* this is used by seal_validate. It accepts return value of
+/* this is used by reiser4_seal_validate. It accepts return value of
  * longterm_lock_znode and returns 1 if it can be interpreted as seal
  * validation failure. For instance, when longterm_lock_znode returns -EINVAL,
- * seal_validate returns -E_REPEAT and caller will call tre search. We cannot
- * do this in longterm_lock_znode(), because sometimes we want to distinguish
- * between -EINVAL and -E_REPEAT. */
+ * reiser4_seal_validate returns -E_REPEAT and caller will call tre search.
+ * We cannot do this in longterm_lock_znode(), because sometimes we want to
+ * distinguish between -EINVAL and -E_REPEAT. */
 static int should_repeat(int return_code)
 {
 	return return_code == -EINVAL;
@@ -124,24 +125,24 @@ static int should_repeat(int return_code
 
    If seal was burned, or broken irreparably, return -E_REPEAT.
 
-   NOTE-NIKITA currently seal_validate() returns -E_REPEAT if key we are
+   NOTE-NIKITA currently reiser4_seal_validate() returns -E_REPEAT if key we are
    looking for is in range of keys covered by the sealed node, but item wasn't
    found by node ->lookup() method. Alternative is to return -ENOENT in this
    case, but this would complicate callers logic.
 
 */
-int seal_validate(seal_t * seal /* seal to validate */ ,
-		  coord_t * coord /* coord to validate against */ ,
-		  const reiser4_key * key /* key to validate against */ ,
-		  lock_handle * lh /* resulting lock handle */ ,
-		  znode_lock_mode mode /* lock node */ ,
-		  znode_lock_request request /* locking priority */ )
+int reiser4_seal_validate(seal_t * seal /* seal to validate */,
+			  coord_t * coord /* coord to validate against */,
+			  const reiser4_key * key /* key to validate against */,
+			  lock_handle * lh /* resulting lock handle */,
+			  znode_lock_mode mode /* lock node */,
+			  znode_lock_request request /* locking priority */)
 {
 	znode *node;
 	int result;
 
 	assert("nikita-1889", seal != NULL);
-	assert("nikita-1881", seal_is_set(seal));
+	assert("nikita-1881", reiser4_seal_is_set(seal));
 	assert("nikita-1882", key != NULL);
 	assert("nikita-1883", coord != NULL);
 	assert("nikita-1884", lh != NULL);
diff -puN fs/reiser4/seal.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/seal.h
--- a/fs/reiser4/seal.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/seal.h
@@ -28,10 +28,10 @@ typedef struct seal_s {
 #endif
 } seal_t;
 
-extern void seal_init(seal_t *, const coord_t *, const reiser4_key *);
-extern void seal_done(seal_t *);
-extern int seal_is_set(const seal_t *);
-extern int seal_validate(seal_t *, coord_t *,
+extern void reiser4_seal_init(seal_t *, const coord_t *, const reiser4_key *);
+extern void reiser4_seal_done(seal_t *);
+extern int reiser4_seal_is_set(const seal_t *);
+extern int reiser4_seal_validate(seal_t *, coord_t *,
 			 const reiser4_key *, lock_handle *,
 			 znode_lock_mode mode, znode_lock_request request);
 
diff -puN fs/reiser4/search.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/search.c
--- a/fs/reiser4/search.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/search.c
@@ -295,7 +295,7 @@ lookup_result coord_by_key(reiser4_tree 
 	init_lh(lh);
 	init_lh(&parent_lh);
 
-	assert("nikita-3023", schedulable());
+	assert("nikita-3023", reiser4_schedulable());
 
 	assert("nikita-353", tree != NULL);
 	assert("nikita-354", key != NULL);
@@ -322,15 +322,15 @@ lookup_result coord_by_key(reiser4_tree 
 
 /* like coord_by_key(), but starts traversal from vroot of @object rather than
  * from tree root. */
-lookup_result
-object_lookup(struct inode * object,
-	      const reiser4_key * key,
-	      coord_t * coord,
-	      lock_handle * lh,
-	      znode_lock_mode lock_mode,
-	      lookup_bias bias,
-	      tree_level lock_level,
-	      tree_level stop_level, __u32 flags, ra_info_t * info)
+lookup_result reiser4_object_lookup(struct inode * object,
+				    const reiser4_key * key,
+				    coord_t * coord,
+				    lock_handle * lh,
+				    znode_lock_mode lock_mode,
+				    lookup_bias bias,
+				    tree_level lock_level,
+				    tree_level stop_level, __u32 flags,
+				    ra_info_t * info)
 {
 	cbk_handle handle;
 	lock_handle parent_lh;
@@ -339,7 +339,7 @@ object_lookup(struct inode * object,
 	init_lh(lh);
 	init_lh(&parent_lh);
 
-	assert("nikita-3023", schedulable());
+	assert("nikita-3023", reiser4_schedulable());
 
 	assert("nikita-354", key != NULL);
 	assert("nikita-355", coord != NULL);
@@ -350,7 +350,7 @@ object_lookup(struct inode * object,
 	assert("nikita-2104", lock_stack_isclean(get_current_lock_stack()));
 
 	cbk_pack(&handle,
-		 object != NULL ? tree_by_inode(object) : current_tree,
+		 object != NULL ? reiser4_tree_by_inode(object) : current_tree,
 		 key,
 		 coord,
 		 lh,
@@ -364,7 +364,8 @@ object_lookup(struct inode * object,
 	return result;
 }
 
-/* lookup by cbk_handle. Common part of coord_by_key() and object_lookup(). */
+/* lookup by cbk_handle. Common part of coord_by_key() and
+   reiser4_object_lookup(). */
 static lookup_result coord_by_handle(cbk_handle * handle)
 {
 	/*
@@ -388,19 +389,19 @@ static lookup_result coord_by_handle(cbk
 
    Error code, or last actor return value is returned.
 
-   This is used by plugin/dir/hashe_dir.c:find_entry() to move through
+   This is used by plugin/dir/hashe_dir.c:reiser4_find_entry() to move through
    sequence of entries with identical keys and alikes.
 */
-int iterate_tree(reiser4_tree * tree /* tree to scan */ ,
-		 coord_t * coord /* coord to start from */ ,
-		 lock_handle * lh	/* lock handle to start with and to
-					 * update along the way */ ,
-		 tree_iterate_actor_t actor	/* function to call on each
-						 * item/unit */ ,
-		 void *arg /* argument to pass to @actor */ ,
-		 znode_lock_mode mode /* lock mode on scanned nodes */ ,
-		 int through_units_p	/* call @actor on each item or on each
-					 * unit */ )
+int reiser4_iterate_tree(reiser4_tree * tree /* tree to scan */ ,
+			 coord_t * coord /* coord to start from */ ,
+			 lock_handle * lh /* lock handle to start with and to
+					   * update along the way */ ,
+			 tree_iterate_actor_t actor /* function to call on each
+						     * item/unit */ ,
+			 void *arg /* argument to pass to @actor */ ,
+			 znode_lock_mode mode /* lock mode on scanned nodes */ ,
+			 int through_units_p /* call @actor on each item or on
+					      *	each unit */ )
 {
 	int result;
 
@@ -647,12 +648,12 @@ static lookup_result traverse_tree(cbk_h
 	/* loop for restarts */
       restart:
 
-	assert("nikita-3024", schedulable());
+	assert("nikita-3024", reiser4_schedulable());
 
 	h->result = CBK_COORD_FOUND;
 	/* connect_znode() needs it */
-	h->ld_key = *min_key();
-	h->rd_key = *max_key();
+	h->ld_key = *reiser4_min_key();
+	h->rd_key = *reiser4_max_key();
 	h->flags |= CBK_DKSET;
 	h->error = NULL;
 
@@ -686,7 +687,7 @@ static lookup_result traverse_tree(cbk_h
 			     IS_POW(iterations))) {
 			warning("nikita-1481", "Too many iterations: %i",
 				iterations);
-			print_key("key", h->key);
+			reiser4_print_key("key", h->key);
 			++iterations;
 		} else if (unlikely(iterations > REISER4_MAX_CBK_ITERATIONS)) {
 			h->error =
@@ -708,7 +709,7 @@ static lookup_result traverse_tree(cbk_h
 			/* deadlock avoidance is normal case. */
 			if (h->result != -E_DEADLOCK)
 				++iterations;
-			preempt_point();
+			reiser4_preempt_point();
 			goto restart;
 		}
 	}
@@ -720,7 +721,7 @@ static lookup_result traverse_tree(cbk_h
 			h->error, h->level, h->lock_level, h->stop_level,
 			lock_mode_name(h->lock_mode), bias_name(h->bias));
 		reiser4_print_address("block", &h->block);
-		print_key("key", h->key);
+		reiser4_print_key("key", h->key);
 		print_coord_content("coord", h->coord);
 	}
 	/* `unlikely' error case */
@@ -835,11 +836,12 @@ static level_lookup_result cbk_level_loo
 	reiser4_key key;
 	znode *active;
 
-	assert("nikita-3025", schedulable());
+	assert("nikita-3025", reiser4_schedulable());
 
 	/* acquire reference to @active node */
 	active =
-	    zget(h->tree, &h->block, h->parent_lh->node, h->level, get_gfp_mask());
+	    zget(h->tree, &h->block, h->parent_lh->node, h->level,
+		 reiser4_ctx_gfp_mask_get());
 
 	if (IS_ERR(active)) {
 		h->result = PTR_ERR(active);
@@ -957,8 +959,8 @@ static level_lookup_result cbk_level_loo
 	if (ldkeyset && !node_is_empty(active) &&
 	    !keyeq(leftmost_key_in_node(active, &key), &ldkey)) {
 		warning("vs-3533", "Keys are inconsistent. Fsck?");
-		print_key("inparent", &ldkey);
-		print_key("inchild", &key);
+		reiser4_print_key("inparent", &ldkey);
+		reiser4_print_key("inchild", &key);
 		h->result = RETERR(-EIO);
 		zrelse(active);
 		return LOOKUP_DONE;
@@ -1187,7 +1189,7 @@ static int cbk_cache_scan_slots(cbk_hand
 		 * are rechecked under dk lock below.
 		 */
 		if (znode_get_level(node) == level &&
-		    /* min_key < key < max_key */
+		    /* reiser4_min_key < key < reiser4_max_key */
 		    znode_contains_key_strict(node, key, isunique)) {
 			zref(node);
 			result = 0;
@@ -1495,7 +1497,7 @@ void print_coord_content(const char *pre
 		       item_body_by_coord(p), item_length_by_coord(p));
 	if (znode_is_loaded(p->node)) {
 		item_key_by_coord(p, &key);
-		print_key(prefix, &key);
+		reiser4_print_key(prefix, &key);
 	}
 }
 
@@ -1515,7 +1517,7 @@ char *sprint_address(const reiser4_block
 
 	if (block == NULL)
 		sprintf(address, "null");
-	else if (blocknr_is_fake(block))
+	else if (reiser4_blocknr_is_fake(block))
 		sprintf(address, "%llx", (unsigned long long)(*block));
 	else
 		sprintf(address, "%llu", (unsigned long long)(*block));
diff -puN fs/reiser4/status_flags.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/status_flags.c
--- a/fs/reiser4/status_flags.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/status_flags.c
@@ -64,7 +64,7 @@ int reiser4_status_init(reiser4_block_nr
 	}
 	lock_page(page);
 	submit_bio(READ, bio);
-	blk_run_address_space(get_super_fake(sb)->i_mapping);
+	blk_run_address_space(reiser4_get_super_fake(sb)->i_mapping);
 	wait_on_page_locked(page);
 	if (!PageUptodate(page)) {
 		warning("green-2007",
@@ -159,7 +159,7 @@ int reiser4_status_write(__u64 status, _
 	lock_page(get_super_private(sb)->status_page);	// Safe as nobody should touch our page.
 	/* We can block now, but we have no other choice anyway */
 	submit_bio(WRITE, bio);
-	blk_run_address_space(get_super_fake(sb)->i_mapping);
+	blk_run_address_space(reiser4_get_super_fake(sb)->i_mapping);
 	return 0;		// We do not wait for io to finish.
 }
 
diff -puN fs/reiser4/super.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/super.c
--- a/fs/reiser4/super.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/super.c
@@ -30,8 +30,7 @@ reiser4_super_info_data *get_super_priva
 }
 
 /* Return reiser4 fstype: value that is returned in ->f_type field by statfs() */
-long statfs_type(const struct super_block *super UNUSED_ARG	/* super block
-								 * queried */ )
+long reiser4_statfs_type(const struct super_block *super UNUSED_ARG)
 {
 	assert("nikita-448", super != NULL);
 	assert("nikita-449", is_reiser4_super(super));
@@ -158,7 +157,7 @@ __u64 reiser4_grabbed_blocks(const struc
 	return get_super_private(super)->blocks_grabbed;
 }
 
-__u64 flush_reserved(const struct super_block * super)
+__u64 reiser4_flush_reserved(const struct super_block * super)
 {
 	assert("vpf-285", super != NULL);
 	assert("vpf-286", is_reiser4_super(super));
@@ -194,7 +193,8 @@ __u64 reiser4_clustered_blocks(const str
 }
 
 /* space allocator used by this file system */
-reiser4_space_allocator *get_space_allocator(const struct super_block * super)
+reiser4_space_allocator * reiser4_get_space_allocator(const struct super_block
+						      *super)
 {
 	assert("nikita-1965", super != NULL);
 	assert("nikita-1966", is_reiser4_super(super));
@@ -202,7 +202,7 @@ reiser4_space_allocator *get_space_alloc
 }
 
 /* return fake inode used to bind formatted nodes in the page cache */
-struct inode *get_super_fake(const struct super_block *super	/* super block
+struct inode *reiser4_get_super_fake(const struct super_block *super	/* super block
 								   queried */ )
 {
 	assert("nikita-1757", super != NULL);
@@ -210,7 +210,7 @@ struct inode *get_super_fake(const struc
 }
 
 /* return fake inode used to bind copied on capture nodes in the page cache */
-struct inode *get_cc_fake(const struct super_block *super	/* super block
+struct inode *reiser4_get_cc_fake(const struct super_block *super	/* super block
 								   queried */ )
 {
 	assert("nikita-1757", super != NULL);
@@ -218,14 +218,14 @@ struct inode *get_cc_fake(const struct s
 }
 
 /* return fake inode used to bind bitmaps and journlal heads */
-struct inode *get_bitmap_fake(const struct super_block *super)
+struct inode *reiser4_get_bitmap_fake(const struct super_block *super)
 {
 	assert("nikita-17571", super != NULL);
 	return get_super_private(super)->bitmap;
 }
 
 /* tree used by this file system */
-reiser4_tree *get_tree(const struct super_block * super	/* super block
+reiser4_tree *reiser4_get_tree(const struct super_block * super	/* super block
 							 * queried */ )
 {
 	assert("nikita-460", super != NULL);
@@ -287,7 +287,7 @@ reiser4_blocknr_is_sane_for(const struct
 	assert("nikita-2957", super != NULL);
 	assert("nikita-2958", blk != NULL);
 
-	if (blocknr_is_fake(blk))
+	if (reiser4_blocknr_is_fake(blk))
 		return 1;
 
 	sbinfo = get_super_private(super);
diff -puN fs/reiser4/super.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/super.h
--- a/fs/reiser4/super.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/super.h
@@ -386,9 +386,9 @@ static inline void spin_unlock_reiser4_s
 	spin_unlock(&(sbinfo->guard));
 }
 
-extern __u64 flush_reserved(const struct super_block *);
+extern __u64 reiser4_flush_reserved(const struct super_block *);
 extern int reiser4_is_set(const struct super_block *super, reiser4_fs_flag f);
-extern long statfs_type(const struct super_block *super);
+extern long reiser4_statfs_type(const struct super_block *super);
 extern __u64 reiser4_block_count(const struct super_block *super);
 extern void reiser4_set_block_count(const struct super_block *super, __u64 nr);
 extern __u64 reiser4_data_blocks(const struct super_block *super);
@@ -407,14 +407,14 @@ extern __u64 reiser4_clustered_blocks(co
 extern long reiser4_reserved_blocks(const struct super_block *super, uid_t uid,
 				    gid_t gid);
 
-extern reiser4_space_allocator *get_space_allocator(const struct super_block
-						    *super);
-extern reiser4_oid_allocator *get_oid_allocator(const struct super_block
-						*super);
-extern struct inode *get_super_fake(const struct super_block *super);
-extern struct inode *get_cc_fake(const struct super_block *super);
-extern struct inode *get_bitmap_fake(const struct super_block *super);
-extern reiser4_tree *get_tree(const struct super_block *super);
+extern reiser4_space_allocator *
+reiser4_get_space_allocator(const struct super_block *super);
+extern reiser4_oid_allocator *
+reiser4_get_oid_allocator(const struct super_block *super);
+extern struct inode *reiser4_get_super_fake(const struct super_block *super);
+extern struct inode *reiser4_get_cc_fake(const struct super_block *super);
+extern struct inode *reiser4_get_bitmap_fake(const struct super_block *super);
+extern reiser4_tree *reiser4_get_tree(const struct super_block *super);
 extern int is_reiser4_super(const struct super_block *super);
 
 extern int reiser4_blocknr_is_sane(const reiser4_block_nr * blk);
@@ -424,11 +424,11 @@ extern int reiser4_fill_super(struct sup
 extern int reiser4_done_super(struct super_block *s);
 
 /* step of fill super */
-extern int init_fs_info(struct super_block *);
-extern void done_fs_info(struct super_block *);
-extern int init_super_data(struct super_block *, char *opt_string);
-extern int init_read_super(struct super_block *, int silent);
-extern int init_root_inode(struct super_block *);
+extern int reiser4_init_fs_info(struct super_block *);
+extern void reiser4_done_fs_info(struct super_block *);
+extern int reiser4_init_super_data(struct super_block *, char *opt_string);
+extern int reiser4_init_read_super(struct super_block *, int silent);
+extern int reiser4_init_root_inode(struct super_block *);
 
 
 /* Maximal possible object id. */
diff -puN fs/reiser4/super_ops.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/super_ops.c
--- a/fs/reiser4/super_ops.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/super_ops.c
@@ -105,7 +105,7 @@ static struct inode *reiser4_alloc_inode
 #if !REISER4_INO_IS_OID
 		info->oid_hi = 0;
 #endif
-		seal_init(&info->sd_seal, NULL, NULL);
+		reiser4_seal_init(&info->sd_seal, NULL, NULL);
 		coord_init_invalid(&info->sd_coord, NULL);
 		info->flags = 0;
 		spin_lock_init(&info->guard);
@@ -136,7 +136,7 @@ static void reiser4_destroy_inode(struct
 		if (fplug->destroy_inode != NULL)
 			fplug->destroy_inode(inode);
 	}
-	dispose_cursors(inode);
+	reiser4_dispose_cursors(inode);
 	if (info->pset)
 		plugin_set_put(info->pset);
 
@@ -190,7 +190,7 @@ static void reiser4_delete_inode(struct 
 	reiser4_context *ctx;
 	file_plugin *fplug;
 
-	ctx = init_context(inode->i_sb);
+	ctx = reiser4_init_context(inode->i_sb);
 	if (IS_ERR(ctx)) {
 		warning("vs-15", "failed to init context");
 		return;
@@ -226,7 +226,7 @@ static void reiser4_put_super(struct sup
 	debugfs_remove(sbinfo->tmgr.debugfs_id_count);
 	debugfs_remove(sbinfo->debugfs_root);
 
-	ctx = init_context(super);
+	ctx = reiser4_init_context(super);
 	if (IS_ERR(ctx)) {
 		warning("vs-17", "failed to init context");
 		return;
@@ -236,14 +236,14 @@ static void reiser4_put_super(struct sup
 	if (get_super_private(super)->df_plug->release)
 		get_super_private(super)->df_plug->release(super);
 
-	done_formatted_fake(super);
+	reiser4_done_formatted_fake(super);
 
 	/* stop daemons: ktxnmgr and entd */
-	done_entd(super);
-	done_ktxnmgrd(super);
-	done_txnmgr(&sbinfo->tmgr);
+	reiser4_done_entd(super);
+	reiser4_done_ktxnmgrd(super);
+	reiser4_done_txnmgr(&sbinfo->tmgr);
 
-	done_fs_info(super);
+	reiser4_done_fs_info(super);
 	reiser4_exit_context(ctx);
 }
 
@@ -260,16 +260,17 @@ static void reiser4_write_super(struct s
 
 	assert("vs-1700", !rofs_super(super));
 
-	ctx = init_context(super);
+	ctx = reiser4_init_context(super);
 	if (IS_ERR(ctx)) {
 		warning("vs-16", "failed to init context");
 		return;
 	}
 
-	ret = capture_super_block(super);
+	ret = reiser4_capture_super_block(super);
 	if (ret != 0)
 		warning("vs-1701",
-			"capture_super_block failed in write_super: %d", ret);
+			"reiser4_capture_super_block failed in write_super: %d",
+			ret);
 	ret = txnmgr_force_commit_all(super, 0);
 	if (ret != 0)
 		warning("jmacd-77113",
@@ -300,11 +301,11 @@ static int reiser4_statfs(struct dentry 
 	assert("nikita-408", super != NULL);
 	assert("nikita-409", statfs != NULL);
 
-	ctx = init_context(super);
+	ctx = reiser4_init_context(super);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
-	statfs->f_type = statfs_type(super);
+	statfs->f_type = reiser4_statfs_type(super);
 	statfs->f_bsize = super->s_blocksize;
 
 	/*
@@ -400,7 +401,7 @@ static void reiser4_sync_inodes(struct s
 	to_write = wbc->nr_to_write;
 	assert("vs-49", wbc->older_than_this == NULL);
 
-	ctx = init_context(super);
+	ctx = reiser4_init_context(super);
 	if (IS_ERR(ctx)) {
 		warning("vs-13", "failed to init context");
 		return;
@@ -414,7 +415,7 @@ static void reiser4_sync_inodes(struct s
 
 	/* flush goes here */
 	wbc->nr_to_write = to_write;
-	writeout(super, wbc);
+	reiser4_writeout(super, wbc);
 
 	/* avoid recursive calls to ->sync_inodes */
 	context_set_commit_async(ctx);
@@ -480,31 +481,31 @@ static int fill_super(struct super_block
 	init_stack_context(&ctx, super);
 
 	/* allocate reiser4 specific super block */
-	if ((result = init_fs_info(super)) != 0)
+	if ((result = reiser4_init_fs_info(super)) != 0)
 		goto failed_init_sinfo;
 
 	sbinfo = get_super_private(super);
 	/* initialize various reiser4 parameters, parse mount options */
-	if ((result = init_super_data(super, data)) != 0)
+	if ((result = reiser4_init_super_data(super, data)) != 0)
 		goto failed_init_super_data;
 
 	/* read reiser4 master super block, initialize disk format plugin */
-	if ((result = init_read_super(super, silent)) != 0)
+	if ((result = reiser4_init_read_super(super, silent)) != 0)
 		goto failed_init_read_super;
 
 	/* initialize transaction manager */
-	init_txnmgr(&sbinfo->tmgr);
+	reiser4_init_txnmgr(&sbinfo->tmgr);
 
 	/* initialize ktxnmgrd context and start kernel thread ktxnmrgd */
-	if ((result = init_ktxnmgrd(super)) != 0)
+	if ((result = reiser4_init_ktxnmgrd(super)) != 0)
 		goto failed_init_ktxnmgrd;
 
 	/* initialize entd context and start kernel thread entd */
-	if ((result = init_entd(super)) != 0)
+	if ((result = reiser4_init_entd(super)) != 0)
 		goto failed_init_entd;
 
 	/* initialize address spaces for formatted nodes and bitmaps */
-	if ((result = init_formatted_fake(super)) != 0)
+	if ((result = reiser4_init_formatted_fake(super)) != 0)
 		goto failed_init_formatted_fake;
 
 	/* initialize disk format plugin */
@@ -520,7 +521,7 @@ static int fill_super(struct super_block
 	sbinfo->nr_files_committed = oids_used(super);
 
 	/* get inode of root directory */
-	if ((result = init_root_inode(super)) != 0)
+	if ((result = reiser4_init_root_inode(super)) != 0)
 		goto failed_init_root_inode;
 
 	process_safelinks(super);
@@ -544,16 +545,16 @@ static int fill_super(struct super_block
 	if (sbinfo->df_plug->release)
 		sbinfo->df_plug->release(super);
  failed_init_disk_format:
-	done_formatted_fake(super);
+	reiser4_done_formatted_fake(super);
  failed_init_formatted_fake:
-	done_entd(super);
+	reiser4_done_entd(super);
  failed_init_entd:
-	done_ktxnmgrd(super);
+	reiser4_done_ktxnmgrd(super);
  failed_init_ktxnmgrd:
-	done_txnmgr(&sbinfo->tmgr);
+	reiser4_done_txnmgr(&sbinfo->tmgr);
  failed_init_read_super:
  failed_init_super_data:
-	done_fs_info(super);
+	reiser4_done_fs_info(super);
  failed_init_sinfo:
 	reiser4_exit_context(&ctx);
 	return result;
@@ -630,22 +631,22 @@ static int __init init_reiser4(void)
 		goto failed_init_jnodes;
 
 	/* initialize cache of flush queues */
-	if ((result = init_fqs()) != 0)
+	if ((result = reiser4_init_fqs()) != 0)
 		goto failed_init_fqs;
 
 	/* initialize cache of structures attached to dentry->d_fsdata */
-	if ((result = init_dentry_fsdata()) != 0)
+	if ((result = reiser4_init_dentry_fsdata()) != 0)
 		goto failed_init_dentry_fsdata;
 
 	/* initialize cache of structures attached to file->private_data */
-	if ((result = init_file_fsdata()) != 0)
+	if ((result = reiser4_init_file_fsdata()) != 0)
 		goto failed_init_file_fsdata;
 
 	/*
 	 * initialize cache of d_cursors. See plugin/file_ops_readdir.c for
 	 * more details
 	 */
-	if ((result = init_d_cursor()) != 0)
+	if ((result = reiser4_init_d_cursor()) != 0)
 		goto failed_init_d_cursor;
 
 	if ((result = register_filesystem(&reiser4_fs_type)) == 0) {
@@ -653,13 +654,13 @@ static int __init init_reiser4(void)
 		return 0;
 	}
 
-	done_d_cursor();
+	reiser4_done_d_cursor();
  failed_init_d_cursor:
-	done_file_fsdata();
+	reiser4_done_file_fsdata();
  failed_init_file_fsdata:
-	done_dentry_fsdata();
+	reiser4_done_dentry_fsdata();
  failed_init_dentry_fsdata:
-	done_fqs();
+	reiser4_done_fqs();
  failed_init_fqs:
 	done_jnodes();
  failed_init_jnodes:
@@ -688,10 +689,10 @@ static void __exit done_reiser4(void)
 	debugfs_remove(reiser4_debugfs_root);
 	result = unregister_filesystem(&reiser4_fs_type);
 	BUG_ON(result != 0);
-	done_d_cursor();
-	done_file_fsdata();
-	done_dentry_fsdata();
-	done_fqs();
+	reiser4_done_d_cursor();
+	reiser4_done_file_fsdata();
+	reiser4_done_dentry_fsdata();
+	reiser4_done_fqs();
 	done_jnodes();
 	done_txnmgr_static();
 	done_plugin_set();
diff -puN fs/reiser4/tap.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/tap.c
--- a/fs/reiser4/tap.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/tap.c
@@ -30,7 +30,7 @@ static void tap_check(const tap_t * tap)
 #endif
 
 /** load node tap is pointing to, if not loaded already */
-int tap_load(tap_t * tap)
+int reiser4_tap_load(tap_t * tap)
 {
 	tap_check(tap);
 	if (tap->loaded == 0) {
@@ -47,7 +47,7 @@ int tap_load(tap_t * tap)
 }
 
 /** release node tap is pointing to. Dual to tap_load() */
-void tap_relse(tap_t * tap)
+void reiser4_tap_relse(tap_t * tap)
 {
 	tap_check(tap);
 	if (tap->loaded > 0) {
@@ -63,29 +63,29 @@ void tap_relse(tap_t * tap)
  * init tap to consist of @coord and @lh. Locks on nodes will be acquired with
  * @mode
  */
-void
-tap_init(tap_t * tap, coord_t * coord, lock_handle * lh, znode_lock_mode mode)
+void reiser4_tap_init(tap_t * tap, coord_t * coord, lock_handle * lh,
+		      znode_lock_mode mode)
 {
 	tap->coord = coord;
 	tap->lh = lh;
 	tap->mode = mode;
 	tap->loaded = 0;
 	INIT_LIST_HEAD(&tap->linkage);
-	init_ra_info(&tap->ra_info);
+	reiser4_init_ra_info(&tap->ra_info);
 }
 
 /** add @tap to the per-thread list of all taps */
-void tap_monitor(tap_t * tap)
+void reiser4_tap_monitor(tap_t * tap)
 {
 	assert("nikita-2623", tap != NULL);
 	tap_check(tap);
-	list_add(&tap->linkage, taps_list());
+	list_add(&tap->linkage, reiser4_taps_list());
 	tap_check(tap);
 }
 
 /* duplicate @src into @dst. Copy lock handle. @dst is not initially
  * loaded. */
-void tap_copy(tap_t * dst, tap_t * src)
+void reiser4_tap_copy(tap_t * dst, tap_t * src)
 {
 	assert("nikita-3193", src != NULL);
 	assert("nikita-3194", dst != NULL);
@@ -100,7 +100,7 @@ void tap_copy(tap_t * dst, tap_t * src)
 }
 
 /** finish with @tap */
-void tap_done(tap_t * tap)
+void reiser4_tap_done(tap_t * tap)
 {
 	assert("nikita-2565", tap != NULL);
 	tap_check(tap);
@@ -116,7 +116,7 @@ void tap_done(tap_t * tap)
  * move @tap to the new node, locked with @target. Load @target, if @tap was
  * already loaded.
  */
-int tap_move(tap_t * tap, lock_handle * target)
+int reiser4_tap_move(tap_t * tap, lock_handle * target)
 {
 	int result = 0;
 
@@ -161,7 +161,7 @@ static int tap_to(tap_t * tap, znode * t
 		result = longterm_lock_znode(&here, target,
 					     tap->mode, ZNODE_LOCK_HIPRI);
 		if (result == 0) {
-			result = tap_move(tap, &here);
+			result = reiser4_tap_move(tap, &here);
 			done_lh(&here);
 		}
 	}
@@ -186,7 +186,7 @@ int tap_to_coord(tap_t * tap, coord_t * 
 }
 
 /** return list of all taps */
-struct list_head *taps_list(void)
+struct list_head *reiser4_taps_list(void)
 {
 	return &get_current_context()->taps;
 }
@@ -234,7 +234,7 @@ int go_dir_el(tap_t * tap, sideof dir, i
 			    get_dir_neighbor(&dup, coord->node, (int)tap->mode,
 					     GN_CAN_USE_UPPER_LEVELS);
 			if (result == 0) {
-				result = tap_move(tap, &dup);
+				result = reiser4_tap_move(tap, &dup);
 				if (result == 0)
 					coord_init(tap->coord, dup.node);
 				done_lh(&dup);
@@ -280,7 +280,7 @@ static int rewind_to(tap_t * tap, go_act
 	assert("nikita-2562", tap->coord->node == tap->lh->node);
 
 	tap_check(tap);
-	result = tap_load(tap);
+	result = reiser4_tap_load(tap);
 	if (result != 0)
 		return result;
 
@@ -290,7 +290,7 @@ static int rewind_to(tap_t * tap, go_act
 		if (result != 0)
 			break;
 	}
-	tap_relse(tap);
+	reiser4_tap_relse(tap);
 	tap_check(tap);
 	return result;
 }
diff -puN fs/reiser4/tap.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/tap.h
--- a/fs/reiser4/tap.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/tap.h
@@ -22,7 +22,8 @@ struct tree_access_pointer {
 	lock_handle *lh;
 	/* mode of lock acquired by this tap */
 	znode_lock_mode mode;
-	/* incremented by tap_load(). Decremented by tap_relse(). */
+	/* incremented by reiser4_tap_load().
+	   Decremented by reiser4_tap_relse(). */
 	int loaded;
 	/* list of taps */
 	struct list_head linkage;
@@ -32,14 +33,14 @@ struct tree_access_pointer {
 
 typedef int (*go_actor_t) (tap_t * tap);
 
-extern int tap_load(tap_t * tap);
-extern void tap_relse(tap_t * tap);
-extern void tap_init(tap_t * tap, coord_t * coord, lock_handle * lh,
+extern int reiser4_tap_load(tap_t * tap);
+extern void reiser4_tap_relse(tap_t * tap);
+extern void reiser4_tap_init(tap_t * tap, coord_t * coord, lock_handle * lh,
 		     znode_lock_mode mode);
-extern void tap_monitor(tap_t * tap);
-extern void tap_copy(tap_t * dst, tap_t * src);
-extern void tap_done(tap_t * tap);
-extern int tap_move(tap_t * tap, lock_handle * target);
+extern void reiser4_tap_monitor(tap_t * tap);
+extern void reiser4_tap_copy(tap_t * dst, tap_t * src);
+extern void reiser4_tap_done(tap_t * tap);
+extern int reiser4_tap_move(tap_t * tap, lock_handle * target);
 extern int tap_to_coord(tap_t * tap, coord_t * target);
 
 extern int go_dir_el(tap_t * tap, sideof dir, int units_p);
@@ -48,11 +49,11 @@ extern int go_prev_unit(tap_t * tap);
 extern int rewind_right(tap_t * tap, int shift);
 extern int rewind_left(tap_t * tap, int shift);
 
-extern struct list_head *taps_list(void);
+extern struct list_head *reiser4_taps_list(void);
 
-#define for_all_taps(tap)						\
-	for (tap = list_entry(taps_list()->next, tap_t, linkage);	\
-	     taps_list() != &tap->linkage;				\
+#define for_all_taps(tap)						       \
+	for (tap = list_entry(reiser4_taps_list()->next, tap_t, linkage);      \
+	     reiser4_taps_list() != &tap->linkage;			       \
 	     tap = list_entry(tap->linkage.next, tap_t, linkage))
 
 /* __REISER4_TAP_H__ */
diff -puN fs/reiser4/tree.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/tree.c
--- a/fs/reiser4/tree.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/tree.c
@@ -47,7 +47,7 @@
  * ->max_key_inside() can be larger that any key actually located in the item,
  * intervals
  *
- * [ min_key( item ), ->max_key_inside( item ) ]
+ * [ reiser4_min_key( item ), ->max_key_inside( item ) ]
  *
  * are still disjoint for all items within the _same_ node.
  *
@@ -280,7 +280,7 @@ static insert_result insert_with_carry_b
 	lowest_level = (carry_level *) (pool + 1);
 	init_carry_level(lowest_level, pool);
 
-	op = post_carry(lowest_level, cop, coord->node, 0);
+	op = reiser4_post_carry(lowest_level, cop, coord->node, 0);
 	if (IS_ERR(op) || (op == NULL)) {
 		done_carry_pool(pool);
 		return RETERR(op ? PTR_ERR(op) : -EIO);
@@ -301,7 +301,7 @@ static insert_result insert_with_carry_b
 		lowest_level->tracked = lh;
 	}
 
-	result = carry(lowest_level, NULL);
+	result = reiser4_carry(lowest_level, NULL);
 	done_carry_pool(pool);
 
 	return result;
@@ -340,7 +340,7 @@ static int paste_with_carry(coord_t * co
 	lowest_level = (carry_level *) (pool + 1);
 	init_carry_level(lowest_level, pool);
 
-	op = post_carry(lowest_level, COP_PASTE, coord->node, 0);
+	op = reiser4_post_carry(lowest_level, COP_PASTE, coord->node, 0);
 	if (IS_ERR(op) || (op == NULL)) {
 		done_carry_pool(pool);
 		return RETERR(op ? PTR_ERR(op) : -EIO);
@@ -359,7 +359,7 @@ static int paste_with_carry(coord_t * co
 		lowest_level->tracked = lh;
 	}
 
-	result = carry(lowest_level, NULL);
+	result = reiser4_carry(lowest_level, NULL);
 	done_carry_pool(pool);
 
 	return result;
@@ -536,12 +536,12 @@ int insert_into_item(coord_t * coord /* 
 }
 
 /* this either appends or truncates item @coord */
-int resize_item(coord_t * coord /* coord of item being resized */ ,
-		reiser4_item_data * data /* parameters of resize */ ,
-		reiser4_key * key /* key of new unit */ ,
-		lock_handle * lh	/* lock handle of node
-					 * being modified */ ,
-		cop_insert_flag flags /* carry flags */ )
+int reiser4_resize_item(coord_t * coord /* coord of item being resized */ ,
+			reiser4_item_data * data /* parameters of resize */ ,
+			reiser4_key * key /* key of new unit */ ,
+			lock_handle * lh	/* lock handle of node
+						 * being modified */ ,
+			cop_insert_flag flags /* carry flags */ )
 {
 	int result;
 	znode *node;
@@ -567,7 +567,7 @@ int resize_item(coord_t * coord /* coord
 }
 
 /* insert flow @f */
-int insert_flow(coord_t * coord, lock_handle * lh, flow_t * f)
+int reiser4_insert_flow(coord_t * coord, lock_handle * lh, flow_t * f)
 {
 	int result;
 	carry_pool *pool;
@@ -583,7 +583,7 @@ int insert_flow(coord_t * coord, lock_ha
 	lowest_level = (carry_level *) (pool + 1);
 	init_carry_level(lowest_level, pool);
 
-	op = post_carry(lowest_level, COP_INSERT_FLOW, coord->node,
+	op = reiser4_post_carry(lowest_level, COP_INSERT_FLOW, coord->node,
 			0 /* operate directly on coord -> node */ );
 	if (IS_ERR(op) || (op == NULL)) {
 		done_carry_pool(pool);
@@ -609,7 +609,7 @@ int insert_flow(coord_t * coord, lock_ha
 	lowest_level->track_type = CARRY_TRACK_CHANGE;
 	lowest_level->tracked = lh;
 
-	result = carry(lowest_level, NULL);
+	result = reiser4_carry(lowest_level, NULL);
 	done_carry_pool(pool);
 
 	return result;
@@ -654,7 +654,8 @@ znode *child_znode(const coord_t * paren
 		else
 			child =
 			    zget(tree, &addr, parent,
-				 znode_get_level(parent) - 1, get_gfp_mask());
+				 znode_get_level(parent) - 1,
+				 reiser4_ctx_gfp_mask_get());
 		if ((child != NULL) && !IS_ERR(child) && setup_dkeys_p)
 			set_child_delimiting_keys(parent, parent_coord, child);
 	} else {
@@ -671,7 +672,7 @@ static void uncapture_znode(znode * node
 
 	assert("zam-1001", ZF_ISSET(node, JNODE_HEARD_BANSHEE));
 
-	if (!blocknr_is_fake(znode_get_block(node))) {
+	if (!reiser4_blocknr_is_fake(znode_get_block(node))) {
 		int ret;
 
 		/* An already allocated block goes right to the atom's delete set. */
@@ -707,21 +708,21 @@ static void uncapture_znode(znode * node
 	 * uncapture page from transaction. There is a possibility of a race
 	 * with ->releasepage(): reiser4_releasepage() detaches page from this
 	 * jnode and we have nothing to uncapture. To avoid this, get
-	 * reference of node->pg under jnode spin lock. uncapture_page() will
-	 * deal with released page itself.
+	 * reference of node->pg under jnode spin lock. reiser4_uncapture_page()
+	 * will deal with released page itself.
 	 */
 	spin_lock_znode(node);
 	page = znode_page(node);
 	if (likely(page != NULL)) {
 		/*
-		 * uncapture_page() can only be called when we are sure that
-		 * znode is pinned in memory, which we are, because
+		 * reiser4_uncapture_page() can only be called when we are sure
+		 * that znode is pinned in memory, which we are, because
 		 * forget_znode() is only called from longterm_unlock_znode().
 		 */
 		page_cache_get(page);
 		spin_unlock_znode(node);
 		lock_page(page);
-		uncapture_page(page);
+		reiser4_uncapture_page(page);
 		unlock_page(page);
 		page_cache_release(page);
 	} else {
@@ -737,11 +738,11 @@ static void uncapture_znode(znode * node
 				break;
 
 			spin_unlock_znode(node);
-			atom_wait_event(atom);
+			reiser4_atom_wait_event(atom);
 			spin_lock_znode(node);
 		}
 
-		uncapture_block(ZJNODE(node));
+		reiser4_uncapture_block(ZJNODE(node));
 		spin_unlock_atom(atom);
 		zput(node);
 	}
@@ -785,7 +786,7 @@ void forget_znode(lock_handle * handle)
 	 * invalidation does not allow other threads to waste cpu time is a busy
 	 * loop, trying to lock dying object.  The exception is in the flush
 	 * code when we take node directly from atom's capture list.*/
-	invalidate_lock(handle);
+	reiser4_invalidate_lock(handle);
 	uncapture_znode(node);
 }
 
@@ -1242,7 +1243,7 @@ prepare_twig_kill(carry_kill_data * kdat
 
 /* this is used to remove part of node content between coordinates @from and @to. Units to which @from and @to are set
    are to be cut completely */
-/* for try_to_merge_with_left, delete_copied, delete_node */
+/* for try_to_merge_with_left, delete_copied, reiser4_delete_node */
 int cut_node_content(coord_t * from, coord_t * to, const reiser4_key * from_key,	/* first key to be removed */
 		     const reiser4_key * to_key,	/* last key to be removed */
 		     reiser4_key *
@@ -1264,7 +1265,7 @@ int cut_node_content(coord_t * from, coo
 	lowest_level = (carry_level *) (pool + 1);
 	init_carry_level(lowest_level, pool);
 
-	op = post_carry(lowest_level, COP_CUT, from->node, 0);
+	op = reiser4_post_carry(lowest_level, COP_CUT, from->node, 0);
 	assert("vs-1509", op != 0);
 	if (IS_ERR(op)) {
 		done_carry_pool(pool);
@@ -1281,7 +1282,7 @@ int cut_node_content(coord_t * from, coo
 	op->u.cut_or_kill.is_cut = 1;
 	op->u.cut_or_kill.u.cut = cut_data;
 
-	result = carry(lowest_level, NULL);
+	result = reiser4_carry(lowest_level, NULL);
 	done_carry_pool(pool);
 
 	return result;
@@ -1364,7 +1365,7 @@ int kill_node_content(coord_t * from,	/*
 		}
 	}
 
-	op = post_carry(lowest_level, COP_CUT, from->node, 0);
+	op = reiser4_post_carry(lowest_level, COP_CUT, from->node, 0);
 	if (IS_ERR(op) || (op == NULL)) {
 		done_children(kdata);
 		done_carry_pool(pool);
@@ -1374,7 +1375,7 @@ int kill_node_content(coord_t * from,	/*
 	op->u.cut_or_kill.is_cut = 0;
 	op->u.cut_or_kill.u.kill = kdata;
 
-	result = carry(lowest_level, NULL);
+	result = reiser4_carry(lowest_level, NULL);
 
 	done_children(kdata);
 	done_carry_pool(pool);
@@ -1384,7 +1385,7 @@ int kill_node_content(coord_t * from,	/*
 void
 fake_kill_hook_tail(struct inode *inode, loff_t start, loff_t end, int truncate)
 {
-	if (inode_get_flag(inode, REISER4_HAS_MMAP)) {
+	if (reiser4_inode_get_flag(inode, REISER4_HAS_MMAP)) {
 		pgoff_t start_pg, end_pg;
 
 		start_pg = start >> PAGE_CACHE_SHIFT;
@@ -1425,8 +1426,8 @@ fake_kill_hook_tail(struct inode *inode,
  * cut_worker() iteration.  This is needed for proper accounting of
  * "i_blocks" and "i_bytes" fields of the @object.
  */
-int delete_node(znode * node, reiser4_key * smallest_removed,
-		struct inode *object, int truncate)
+int reiser4_delete_node(znode * node, reiser4_key * smallest_removed,
+			struct inode *object, int truncate)
 {
 	lock_handle parent_lock;
 	coord_t cut_from;
@@ -1545,8 +1546,8 @@ static int can_delete(const reiser4_key 
  * @progress: return true if a progress in file items deletions was made,
  *            @smallest_removed value is actual in that case.
  *
- * @return: 0 if success, error code otherwise, -E_REPEAT means that long cut_tree
- * operation was interrupted for allowing atom commit .
+ * @return: 0 if success, error code otherwise, -E_REPEAT means that long
+ * reiser4_cut_tree operation was interrupted for allowing atom commit.
  */
 int
 cut_tree_worker_common(tap_t * tap, const reiser4_key * from_key,
@@ -1580,10 +1581,10 @@ cut_tree_worker_common(tap_t * tap, cons
 		/* Check can we delete the node as a whole. */
 		if (*progress && znode_get_level(node) == LEAF_LEVEL &&
 		    can_delete(from_key, node)) {
-			result = delete_node(node, smallest_removed, object,
-					     truncate);
+			result = reiser4_delete_node(node, smallest_removed,
+						     object, truncate);
 		} else {
-			result = tap_load(tap);
+			result = reiser4_tap_load(tap);
 			if (result)
 				return result;
 
@@ -1637,13 +1638,13 @@ cut_tree_worker_common(tap_t * tap, cons
 			}
 
 			/* cut data from one node */
-			// *smallest_removed = *min_key();
+			// *smallest_removed = *reiser4_min_key();
 			result =
 			    kill_node_content(&left_coord, tap->coord, from_key,
 					      to_key, smallest_removed,
 					      next_node_lock.node, object,
 					      truncate);
-			tap_relse(tap);
+			reiser4_tap_relse(tap);
 		}
 		if (result)
 			break;
@@ -1659,13 +1660,13 @@ cut_tree_worker_common(tap_t * tap, cons
 		if (next_node_lock.node == NULL)
 			break;
 
-		result = tap_move(tap, &next_node_lock);
+		result = reiser4_tap_move(tap, &next_node_lock);
 		done_lh(&next_node_lock);
 		if (result)
 			break;
 
-		/* Break long cut_tree operation (deletion of a large file) if
-		 * atom requires commit. */
+		/* Break long reiser4_cut_tree operation (deletion of a large
+		   file) if atom requires commit. */
 		if (*progress > CUT_TREE_MIN_ITERATIONS
 		    && current_atom_should_commit()) {
 			result = -E_REPEAT;
@@ -1673,7 +1674,7 @@ cut_tree_worker_common(tap_t * tap, cons
 		}
 	}
 	done_lh(&next_node_lock);
-	// assert("vs-301", !keyeq(&smallest_removed, min_key()));
+	// assert("vs-301", !keyeq(&smallest_removed, reiser4_min_key()));
 	return result;
 }
 
@@ -1720,10 +1721,10 @@ cut_tree_worker_common(tap_t * tap, cons
  * operation was interrupted for allowing atom commit .
  */
 
-int
-cut_tree_object(reiser4_tree * tree, const reiser4_key * from_key,
-		const reiser4_key * to_key, reiser4_key * smallest_removed_p,
-		struct inode *object, int truncate, int *progress)
+int reiser4_cut_tree_object(reiser4_tree * tree, const reiser4_key * from_key,
+			    const reiser4_key * to_key,
+			    reiser4_key * smallest_removed_p,
+			    struct inode *object, int truncate, int *progress)
 {
 	lock_handle lock;
 	int result;
@@ -1747,10 +1748,11 @@ cut_tree_object(reiser4_tree * tree, con
 
 	do {
 		/* Find rightmost item to cut away from the tree. */
-		result = object_lookup(object, to_key, &right_coord, &lock,
-				       ZNODE_WRITE_LOCK, FIND_MAX_NOT_MORE_THAN,
-				       TWIG_LEVEL, LEAF_LEVEL, CBK_UNIQUE,
-				       NULL /*ra_info */ );
+		result = reiser4_object_lookup(object, to_key, &right_coord,
+					       &lock, ZNODE_WRITE_LOCK,
+					       FIND_MAX_NOT_MORE_THAN,
+					       TWIG_LEVEL, LEAF_LEVEL,
+					       CBK_UNIQUE, NULL /*ra_info */);
 		if (result != CBK_COORD_FOUND)
 			break;
 		if (object == NULL
@@ -1759,13 +1761,13 @@ cut_tree_object(reiser4_tree * tree, con
 		else
 			cut_tree_worker =
 			    inode_file_plugin(object)->cut_tree_worker;
-		tap_init(&tap, &right_coord, &lock, ZNODE_WRITE_LOCK);
+		reiser4_tap_init(&tap, &right_coord, &lock, ZNODE_WRITE_LOCK);
 		result =
 		    cut_tree_worker(&tap, from_key, to_key, smallest_removed_p,
 				    object, truncate, progress);
-		tap_done(&tap);
+		reiser4_tap_done(&tap);
 
-		preempt_point();
+		reiser4_preempt_point();
 
 	} while (0);
 
@@ -1791,27 +1793,25 @@ cut_tree_object(reiser4_tree * tree, con
 	return result;
 }
 
-/* repeat cut_tree_object until everything is deleted. unlike cut_file_items, it
- * does not end current transaction if -E_REPEAT is returned by
- * cut_tree_object. */
-int
-cut_tree(reiser4_tree * tree, const reiser4_key * from, const reiser4_key * to,
-	 struct inode *inode, int truncate)
+/* repeat reiser4_cut_tree_object until everything is deleted.
+ * unlike cut_file_items, it does not end current transaction if -E_REPEAT
+ * is returned by cut_tree_object. */
+int reiser4_cut_tree(reiser4_tree * tree, const reiser4_key * from,
+		     const reiser4_key * to, struct inode *inode, int truncate)
 {
 	int result;
 	int progress;
 
 	do {
-		result =
-		    cut_tree_object(tree, from, to, NULL, inode, truncate,
-				    &progress);
+		result = reiser4_cut_tree_object(tree, from, to, NULL,
+						 inode, truncate, &progress);
 	} while (result == -E_REPEAT);
 
 	return result;
 }
 
 /* finishing reiser4 initialization */
-int init_tree(reiser4_tree * tree	/* pointer to structure being
+int reiser4_init_tree(reiser4_tree * tree	/* pointer to structure being
 					 * initialized */ ,
 	      const reiser4_block_nr * root_block	/* address of a root block
 							 * on a disk */ ,
@@ -1839,7 +1839,8 @@ int init_tree(reiser4_tree * tree	/* poi
 	if (result == 0)
 		result = jnodes_tree_init(tree);
 	if (result == 0) {
-		tree->uber = zget(tree, &UBER_TREE_ADDR, NULL, 0, get_gfp_mask());
+		tree->uber = zget(tree, &UBER_TREE_ADDR, NULL, 0,
+				  reiser4_ctx_gfp_mask_get());
 		if (IS_ERR(tree->uber)) {
 			result = PTR_ERR(tree->uber);
 			tree->uber = NULL;
@@ -1849,7 +1850,7 @@ int init_tree(reiser4_tree * tree	/* poi
 }
 
 /* release resources associated with @tree */
-void done_tree(reiser4_tree * tree /* tree to release */ )
+void reiser4_done_tree(reiser4_tree * tree /* tree to release */ )
 {
 	if (tree == NULL)
 		return;
diff -puN fs/reiser4/tree.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/tree.h
--- a/fs/reiser4/tree.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/tree.h
@@ -160,10 +160,10 @@ struct reiser4_tree {
 	} carry;
 };
 
-extern int init_tree(reiser4_tree * tree,
-		     const reiser4_block_nr * root_block, tree_level height,
-		     node_plugin * default_plugin);
-extern void done_tree(reiser4_tree * tree);
+extern int reiser4_init_tree(reiser4_tree * tree,
+			     const reiser4_block_nr * root_block,
+			     tree_level height, node_plugin * default_plugin);
+extern void reiser4_done_tree(reiser4_tree * tree);
 
 /* cbk flags: options for coord_by_key() */
 typedef enum {
@@ -205,9 +205,10 @@ typedef enum {
 
 typedef int (*tree_iterate_actor_t) (reiser4_tree * tree, coord_t * coord,
 				     lock_handle * lh, void *arg);
-extern int iterate_tree(reiser4_tree * tree, coord_t * coord, lock_handle * lh,
-			tree_iterate_actor_t actor, void *arg,
-			znode_lock_mode mode, int through_units_p);
+extern int reiser4_iterate_tree(reiser4_tree * tree, coord_t * coord,
+				lock_handle * lh,
+				tree_iterate_actor_t actor, void *arg,
+				znode_lock_mode mode, int through_units_p);
 extern int get_uber_znode(reiser4_tree * tree, znode_lock_mode mode,
 			  znode_lock_request pri, lock_handle * lh);
 
@@ -292,15 +293,15 @@ lookup_result coord_by_key(reiser4_tree 
 			   tree_level lock_level, tree_level stop_level,
 			   __u32 flags, ra_info_t *);
 
-lookup_result object_lookup(struct inode *object,
-			    const reiser4_key * key,
-			    coord_t * coord,
-			    lock_handle * lh,
-			    znode_lock_mode lock_mode,
-			    lookup_bias bias,
-			    tree_level lock_level,
-			    tree_level stop_level,
-			    __u32 flags, ra_info_t * info);
+lookup_result reiser4_object_lookup(struct inode *object,
+				    const reiser4_key * key,
+				    coord_t * coord,
+				    lock_handle * lh,
+				    znode_lock_mode lock_mode,
+				    lookup_bias bias,
+				    tree_level lock_level,
+				    tree_level stop_level,
+				    __u32 flags, ra_info_t * info);
 
 insert_result insert_by_key(reiser4_tree * tree, const reiser4_key * key,
 			    reiser4_item_data * data, coord_t * coord,
@@ -321,11 +322,11 @@ int kill_node_content(coord_t * from, co
 		      znode * locked_left_neighbor, struct inode *inode,
 		      int truncate);
 
-int resize_item(coord_t * coord, reiser4_item_data * data,
-		reiser4_key * key, lock_handle * lh, cop_insert_flag);
+int reiser4_resize_item(coord_t * coord, reiser4_item_data * data,
+			reiser4_key * key, lock_handle * lh, cop_insert_flag);
 int insert_into_item(coord_t * coord, lock_handle * lh, const reiser4_key * key,
 		     reiser4_item_data * data, unsigned);
-int insert_flow(coord_t * coord, lock_handle * lh, flow_t * f);
+int reiser4_insert_flow(coord_t * coord, lock_handle * lh, flow_t * f);
 int find_new_child_ptr(znode * parent, znode * child, znode * left,
 		       coord_t * result);
 
@@ -337,13 +338,13 @@ void fake_kill_hook_tail(struct inode *,
 extern int cut_tree_worker_common(tap_t *, const reiser4_key *,
 				  const reiser4_key *, reiser4_key *,
 				  struct inode *, int, int *);
-extern int cut_tree_object(reiser4_tree *, const reiser4_key *,
-			   const reiser4_key *, reiser4_key *, struct inode *,
-			   int, int *);
-extern int cut_tree(reiser4_tree * tree, const reiser4_key * from,
-		    const reiser4_key * to, struct inode *, int);
+extern int reiser4_cut_tree_object(reiser4_tree *, const reiser4_key *,
+				   const reiser4_key *, reiser4_key *,
+				   struct inode *, int, int *);
+extern int reiser4_cut_tree(reiser4_tree * tree, const reiser4_key * from,
+			    const reiser4_key * to, struct inode *, int);
 
-extern int delete_node(znode * node, reiser4_key *, struct inode *, int);
+extern int reiser4_delete_node(znode *, reiser4_key *, struct inode *, int);
 extern int check_tree_pointer(const coord_t * pointer, const znode * child);
 extern int find_new_child_ptr(znode * parent, znode * child UNUSED_ARG,
 			      znode * left, coord_t * result);
diff -puN fs/reiser4/tree_mod.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/tree_mod.c
--- a/fs/reiser4/tree_mod.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/tree_mod.c
@@ -37,9 +37,10 @@ static int add_child_ptr(znode * parent,
 		warning( __VA_ARGS__ )
 
 /* allocate new node on the @level and immediately on the right of @brother. */
-znode *new_node(znode * brother /* existing left neighbor of new node */ ,
-		tree_level level	/* tree level at which new node is to
-					 * be allocated */ )
+znode * reiser4_new_node(znode * brother /* existing left neighbor
+					  *  of new node */,
+			 tree_level level /* tree level at which new node is to
+					   * be allocated */)
 {
 	znode *result;
 	int retcode;
@@ -52,7 +53,7 @@ znode *new_node(znode * brother /* exist
 	if (retcode == 0) {
 		result =
 		    zget(znode_get_tree(brother), &blocknr, NULL, level,
-			 get_gfp_mask());
+			 reiser4_ctx_gfp_mask_get());
 		if (IS_ERR(result)) {
 			ewarning(PTR_ERR(result), "nikita-929",
 				 "Cannot allocate znode for carry: %li",
@@ -72,7 +73,7 @@ znode *new_node(znode * brother /* exist
 		result->nplug = znode_get_tree(brother)->nplug;
 		assert("nikita-933", result->nplug != NULL);
 
-		retcode = zinit_new(result, get_gfp_mask());
+		retcode = zinit_new(result, reiser4_ctx_gfp_mask_get());
 		if (retcode == 0) {
 			ZF_SET(result, JNODE_CREATED);
 			zrelse(result);
@@ -99,7 +100,7 @@ znode *new_node(znode * brother /* exist
    This helper function is called by add_new_root().
 
 */
-znode *add_tree_root(znode * old_root /* existing tree root */ ,
+znode *reiser4_add_tree_root(znode * old_root /* existing tree root */ ,
 		     znode * fake /* "fake" znode */ )
 {
 	reiser4_tree *tree = znode_get_tree(old_root);
@@ -137,7 +138,7 @@ znode *add_tree_root(znode * old_root /*
 		   flush can be going here.
 		 */
 		assert("nikita-1448", znode_is_root(old_root));
-		new_root = new_node(fake, tree->height + 1);
+		new_root = reiser4_new_node(fake, tree->height + 1);
 		if (!IS_ERR(new_root) && (result = zload(new_root)) == 0) {
 			lock_handle rlh;
 
@@ -176,8 +177,8 @@ znode *add_tree_root(znode * old_root /*
 				       WITH_DATA(new_root,
 						 node_is_empty(new_root)));
 				write_lock_dk(tree);
-				znode_set_ld_key(new_root, min_key());
-				znode_set_rd_key(new_root, max_key());
+				znode_set_ld_key(new_root, reiser4_min_key());
+				znode_set_rd_key(new_root, reiser4_max_key());
 				write_unlock_dk(tree);
 				if (REISER4_DEBUG) {
 					ZF_CLR(old_root, JNODE_LEFT_CONNECTED);
@@ -262,13 +263,14 @@ static int add_child_ptr(znode * parent,
 }
 
 /* actually remove tree root */
-static int kill_root(reiser4_tree * tree	/* tree from which root is being
-						 * removed */ ,
-		     znode * old_root /* root node that is being removed */ ,
-		     znode * new_root	/* new root---sole child of *
-					 * @old_root */ ,
-		     const reiser4_block_nr * new_root_blk	/* disk address of
-								 * @new_root */ )
+static int reiser4_kill_root(reiser4_tree * tree /* tree from which root is
+						  * being removed */,
+			     znode * old_root /* root node that is being
+					       * removed */ ,
+			     znode * new_root	/* new root---sole child of
+						 * @old_root */,
+		     const reiser4_block_nr * new_root_blk /* disk address of
+							    * @new_root */)
 {
 	znode *uber;
 	int result;
@@ -334,16 +336,17 @@ static int kill_root(reiser4_tree * tree
    at the entry.
 
    To remove tree root we need to take lock on special "fake" znode that
-   protects changes of tree height. See comments in add_tree_root() for more
-   on this.
+   protects changes of tree height. See comments in reiser4_add_tree_root() for
+   more on this.
 
    Also parent pointers have to be updated in
    old and new root. To simplify code, function is split into two parts: outer
-   kill_tree_root() collects all necessary arguments and calls kill_root()
-   to do the actual job.
+   reiser4_kill_tree_root() collects all necessary arguments and calls
+   reiser4_kill_root() to do the actual job.
 
 */
-int kill_tree_root(znode * old_root /* tree root that we are removing */ )
+int reiser4_kill_tree_root(znode * old_root /* tree root that we are
+					       removing*/)
 {
 	int result;
 	coord_t down_link;
@@ -362,8 +365,8 @@ int kill_tree_root(znode * old_root /* t
 	new_root = child_znode(&down_link, old_root, 0, 1);
 	if (!IS_ERR(new_root)) {
 		result =
-		    kill_root(tree, old_root, new_root,
-			      znode_get_block(new_root));
+			reiser4_kill_root(tree, old_root, new_root,
+					  znode_get_block(new_root));
 		zput(new_root);
 	} else
 		result = PTR_ERR(new_root);
diff -puN fs/reiser4/tree_mod.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/tree_mod.h
--- a/fs/reiser4/tree_mod.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/tree_mod.h
@@ -9,9 +9,9 @@
 
 #include "forward.h"
 
-znode *new_node(znode * brother, tree_level level);
-znode *add_tree_root(znode * old_root, znode * fake);
-int kill_tree_root(znode * old_root);
+znode *reiser4_new_node(znode * brother, tree_level level);
+znode *reiser4_add_tree_root(znode * old_root, znode * fake);
+int reiser4_kill_tree_root(znode * old_root);
 void build_child_ptr_data(znode * child, reiser4_item_data * data);
 
 /* __REISER4_TREE_MOD_H__ */
diff -puN fs/reiser4/tree_walk.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/tree_walk.c
--- a/fs/reiser4/tree_walk.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/tree_walk.c
@@ -423,7 +423,8 @@ renew_sibling_link(coord_t * coord, lock
 			neighbor = zlook(tree, &da);
 		} else {
 			neighbor =
-			    zget(tree, &da, side_parent, level, get_gfp_mask());
+			    zget(tree, &da, side_parent, level,
+				 reiser4_ctx_gfp_mask_get());
 		}
 
 		if (IS_ERR(neighbor)) {
@@ -766,7 +767,7 @@ reiser4_get_neighbor(lock_handle * neigh
 			/* there was lock request from hi-pri locker. if
 			   it is possible we unlock last parent node and
 			   re-lock it again. */
-			for (; check_deadlock(); h--) {
+			for (; reiser4_check_deadlock(); h--) {
 				done_lh(&path[h]);
 				if (h == 0)
 					goto fail;
diff -puN fs/reiser4/txnmgr.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/txnmgr.c
--- a/fs/reiser4/txnmgr.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/txnmgr.c
@@ -40,7 +40,7 @@ year old --- define all technical terms 
 
 /* Thoughts on the external transaction interface:
 
-   In the current code, a TRANSCRASH handle is created implicitly by init_context() (which
+   In the current code, a TRANSCRASH handle is created implicitly by reiser4_init_context() (which
    creates state that lasts for the duration of a system call and is called at the start
    of ReiserFS methods implementing VFS operations), and closed by reiser4_exit_context(),
    occupying the scope of a single system call.  We wish to give certain applications an
@@ -178,7 +178,8 @@ year old --- define all technical terms 
  *     Steps (2) and (3) take place under long term lock on the twig node.
  *
  *     When file is accessed through mmap(2) page is always created during
- *     page fault. After this (in reiser4_readpage()->readpage_extent()):
+ *     page fault.
+ *     After this (in reiser4_readpage()->reiser4_readpage_extent()):
  *
  *         1. if access is made to non-hole page new jnode is created, (if
  *         necessary)
@@ -262,7 +263,7 @@ static int capture_fuse_wait(txn_handle 
 
 static void capture_fuse_into(txn_atom * small, txn_atom * large);
 
-void invalidate_list(struct list_head *);
+void reiser4_invalidate_list(struct list_head *);
 
 /* GENERIC STRUCTURES */
 
@@ -329,7 +330,7 @@ void done_txnmgr_static(void)
  *
  * This is called on mount. Makes necessary initializations.
  */
-void init_txnmgr(txn_mgr *mgr)
+void reiser4_init_txnmgr(txn_mgr *mgr)
 {
 	assert("umka-169", mgr != NULL);
 
@@ -341,12 +342,12 @@ void init_txnmgr(txn_mgr *mgr)
 }
 
 /**
- * done_txnmgr - stop transaction manager
+ * reiser4_done_txnmgr - stop transaction manager
  * @mgr: pointer to transaction manager embedded in reiser4 super block
  *
  * This is called on umount. Does sanity checks.
  */
-void done_txnmgr(txn_mgr *mgr)
+void reiser4_done_txnmgr(txn_mgr *mgr)
 {
 	assert("umka-170", mgr != NULL);
 	assert("umka-1701", list_empty_careful(&mgr->atoms_list));
@@ -361,7 +362,7 @@ static void txnh_init(txn_handle * txnh,
 
 	txnh->mode = mode;
 	txnh->atom = NULL;
-	set_gfp_mask();
+	reiser4_ctx_gfp_mask_set();
 	txnh->flags = 0;
 	spin_lock_init(&txnh->hlock);
 	INIT_LIST_HEAD(&txnh->txnh_link);
@@ -443,7 +444,7 @@ static int atom_isclean(txn_atom * atom)
    trans_in_ctx, which means that transaction handles are stack-allocated.  Eventually
    this will be extended to allow transaction handles to span several contexts. */
 /* Audited by: umka (2002.06.13) */
-void txn_begin(reiser4_context * context)
+void reiser4_txn_begin(reiser4_context * context)
 {
 	assert("jmacd-544", context->trans == NULL);
 
@@ -458,13 +459,13 @@ void txn_begin(reiser4_context * context
 }
 
 /* Finish a transaction handle context. */
-int txn_end(reiser4_context * context)
+int reiser4_txn_end(reiser4_context * context)
 {
 	long ret = 0;
 	txn_handle *txnh;
 
 	assert("umka-283", context != NULL);
-	assert("nikita-3012", schedulable());
+	assert("nikita-3012", reiser4_schedulable());
 	assert("vs-24", context == get_current_context());
 	assert("nikita-2967", lock_stack_isclean(get_current_lock_stack()));
 
@@ -478,16 +479,16 @@ int txn_end(reiser4_context * context)
 	return ret;
 }
 
-void txn_restart(reiser4_context * context)
+void reiser4_txn_restart(reiser4_context * context)
 {
-	txn_end(context);
-	preempt_point();
-	txn_begin(context);
+	reiser4_txn_end(context);
+	reiser4_preempt_point();
+	reiser4_txn_begin(context);
 }
 
-void txn_restart_current(void)
+void reiser4_txn_restart_current(void)
 {
-	txn_restart(get_current_context());
+	reiser4_txn_restart(get_current_context());
 }
 
 /* TXN_ATOM */
@@ -699,7 +700,8 @@ static int atom_begin_and_assign_to_txnh
 	}
 
 	if (*atom_alloc == NULL) {
-		(*atom_alloc) = kmem_cache_alloc(_atom_slab, get_gfp_mask());
+		(*atom_alloc) = kmem_cache_alloc(_atom_slab,
+						 reiser4_ctx_gfp_mask_get());
 
 		if (*atom_alloc == NULL)
 			return RETERR(-ENOMEM);
@@ -714,7 +716,7 @@ static int atom_begin_and_assign_to_txnh
 	/* Check whether new atom still needed */
 	if (txnh->atom != NULL) {
 		/* NOTE-NIKITA probably it is rather better to free
-		 * atom_alloc here than thread it up to try_capture(). */
+		 * atom_alloc here than thread it up to reiser4_try_capture() */
 
 		spin_unlock_txnh(txnh);
 		spin_unlock_txnmgr(mgr);
@@ -940,8 +942,8 @@ static int submit_wb_list(void)
 	dispatch_wb_list(fq->atom, fq);
 	spin_unlock_atom(fq->atom);
 
-	ret = write_fq(fq, NULL, 1);
-	fq_put(fq);
+	ret = reiser4_write_fq(fq, NULL, 1);
+	reiser4_fq_put(fq);
 
 	return ret;
 }
@@ -1016,13 +1018,13 @@ static int commit_current_atom(long *nr_
 		/* if atom's dirty list contains one znode which is
 		   HEARD_BANSHEE and is locked we have to allow lock owner to
 		   continue and uncapture that znode */
-		preempt_point();
+		reiser4_preempt_point();
 
 		*atom = get_current_atom_locked();
 		if (flushiters > TOOMANYFLUSHES && IS_POW(flushiters)) {
 			warning("nikita-3176",
 				"Flushing like mad: %i", flushiters);
-			info_atom("atom", *atom);
+			reiser4_info_atom("atom", *atom);
 			DEBUGON(flushiters > (1 << 20));
 		}
 	}
@@ -1043,7 +1045,7 @@ static int commit_current_atom(long *nr_
 	/* Up to this point we have been flushing and after flush is called we
 	   return -E_REPEAT.  Now we can commit.  We cannot return -E_REPEAT
 	   at this point, commit should be successful. */
-	atom_set_stage(*atom, ASTAGE_PRE_COMMIT);
+	reiser4_atom_set_stage(*atom, ASTAGE_PRE_COMMIT);
 	ON_DEBUG(((*atom)->committer = current));
 	spin_unlock_atom(*atom);
 
@@ -1063,19 +1065,19 @@ static int commit_current_atom(long *nr_
 
 	/* The atom->ovrwr_nodes list is processed under commit semaphore held
 	   because of bitmap nodes which are captured by special way in
-	   bitmap_pre_commit_hook(), that way does not include
+	   reiser4_pre_commit_hook_bitmap(), that way does not include
 	   capture_fuse_wait() as a capturing of other nodes does -- the commit
 	   semaphore is used for transaction isolation instead. */
-	invalidate_list(ATOM_OVRWR_LIST(*atom));
+	reiser4_invalidate_list(ATOM_OVRWR_LIST(*atom));
 	up(&sbinfo->tmgr.commit_semaphore);
 
-	invalidate_list(ATOM_CLEAN_LIST(*atom));
-	invalidate_list(ATOM_WB_LIST(*atom));
+	reiser4_invalidate_list(ATOM_CLEAN_LIST(*atom));
+	reiser4_invalidate_list(ATOM_WB_LIST(*atom));
 	assert("zam-927", list_empty(&(*atom)->inodes));
 
 	spin_lock_atom(*atom);
  done:
-	atom_set_stage(*atom, ASTAGE_DONE);
+	reiser4_atom_set_stage(*atom, ASTAGE_DONE);
 	ON_DEBUG((*atom)->committer = NULL);
 
 	/* Atom's state changes, so wake up everybody waiting for this
@@ -1127,7 +1129,7 @@ int force_commit_atom(txn_handle *txnh)
 	spin_unlock_atom(atom);
 
 	/* commit is here */
-	txn_restart_current();
+	reiser4_txn_restart_current();
 	return 0;
 }
 
@@ -1144,9 +1146,9 @@ int txnmgr_force_commit_all(struct super
 	reiser4_context *ctx = get_current_context();
 
 	assert("nikita-2965", lock_stack_isclean(get_current_lock_stack()));
-	assert("nikita-3058", commit_check_locks());
+	assert("nikita-3058", reiser4_commit_check_locks());
 
-	txn_restart_current();
+	reiser4_txn_restart_current();
 
 	mgr = &get_super_private(super)->tmgr;
 
@@ -1176,7 +1178,7 @@ int txnmgr_force_commit_all(struct super
 						return ret;
 				} else
 					/* wait atom commit */
-					atom_wait_event(atom);
+					reiser4_atom_wait_event(atom);
 
 				goto again;
 			}
@@ -1273,7 +1275,7 @@ int commit_some_atoms(txn_mgr * mgr)
 	   has to rescan atoms */
 	mgr->daemon->rescan = 1;
 	spin_unlock(&mgr->daemon->guard);
-	txn_restart_current();
+	reiser4_txn_restart_current();
 	return 0;
 }
 
@@ -1404,7 +1406,7 @@ flush_some_atom(jnode * start, long *nr_
 					 * makes a progress in flushing or
 					 * committing the atom
 					 */
-					atom_wait_event(atom);
+					reiser4_atom_wait_event(atom);
 					goto repeat;
 				}
 				spin_unlock_atom(atom);
@@ -1436,7 +1438,7 @@ flush_some_atom(jnode * start, long *nr_
 			    !(atom->flags & ATOM_CANCEL_FUSION)) {
 				ret = txn_try_to_fuse_small_atom(tmgr, atom);
 				if (ret == -E_REPEAT) {
-					preempt_point();
+					reiser4_preempt_point();
 					goto repeat;
 				}
 			}
@@ -1454,7 +1456,7 @@ flush_some_atom(jnode * start, long *nr_
 		if (*nr_submitted == 0) {
 			/* let others who hampers flushing (hold longterm locks,
 			   for instance) to free the way for flush */
-			preempt_point();
+			reiser4_preempt_point();
 			goto repeat;
 		}
 		ret = 0;
@@ -1463,20 +1465,20 @@ flush_some_atom(jnode * start, long *nr_
 	if (*nr_submitted > wbc->nr_to_write)
 		warning("", "asked for %ld, written %ld\n", wbc->nr_to_write, *nr_submitted);
 */
-	txn_restart(ctx);
+	reiser4_txn_restart(ctx);
 
 	return ret;
 }
 
 /* Remove processed nodes from atom's clean list (thereby remove them from transaction). */
-void invalidate_list(struct list_head *head)
+void reiser4_invalidate_list(struct list_head *head)
 {
 	while (!list_empty(head)) {
 		jnode *node;
 
 		node = list_entry(head->next, jnode, capture_link);
 		spin_lock_jnode(node);
-		uncapture_block(node);
+		reiser4_uncapture_block(node);
 		jput(node);
 	}
 }
@@ -1491,7 +1493,7 @@ static void init_wlinks(txn_wait_links *
 }
 
 /* Add atom to the atom's waitfor list and wait for somebody to wake us up; */
-void atom_wait_event(txn_atom * atom)
+void reiser4_atom_wait_event(txn_atom * atom)
 {
 	txn_wait_links _wlinks;
 
@@ -1505,15 +1507,15 @@ void atom_wait_event(txn_atom * atom)
 	atomic_inc(&atom->refcount);
 	spin_unlock_atom(atom);
 
-	prepare_to_sleep(_wlinks._lock_stack);
-	go_to_sleep(_wlinks._lock_stack);
+	reiser4_prepare_to_sleep(_wlinks._lock_stack);
+	reiser4_go_to_sleep(_wlinks._lock_stack);
 
 	spin_lock_atom(atom);
 	list_del(&_wlinks._fwaitfor_link);
 	atom_dec_and_unlock(atom);
 }
 
-void atom_set_stage(txn_atom * atom, txn_stage stage)
+void reiser4_atom_set_stage(txn_atom * atom, txn_stage stage)
 {
 	assert("nikita-3535", atom != NULL);
 	assert_spin_locked(&(atom->alock));
@@ -1522,12 +1524,12 @@ void atom_set_stage(txn_atom * atom, txn
 	assert("nikita-3537", stage >= atom->stage);
 	if (atom->stage != stage) {
 		atom->stage = stage;
-		atom_send_event(atom);
+		reiser4_atom_send_event(atom);
 	}
 }
 
 /* wake all threads which wait for an event */
-void atom_send_event(txn_atom * atom)
+void reiser4_atom_send_event(txn_atom * atom)
 {
 	assert_spin_locked(&(atom->alock));
 	wakeup_atom_waitfor_list(atom);
@@ -1602,7 +1604,8 @@ static int try_commit_txnh(commit_data *
 			 * increase monotonically), hence this check.
 			 */
 			if (cd->atom->stage < ASTAGE_CAPTURE_WAIT)
-				atom_set_stage(cd->atom, ASTAGE_CAPTURE_WAIT);
+				reiser4_atom_set_stage(cd->atom,
+						       ASTAGE_CAPTURE_WAIT);
 			cd->atom->flags |= ATOM_FORCE_COMMIT;
 		}
 		if (cd->txnh->flags & TXNH_DONT_COMMIT) {
@@ -1621,14 +1624,14 @@ static int try_commit_txnh(commit_data *
 			cd->wake_ktxnmgrd_up =
 			    cd->atom->txnh_count == 1 &&
 			    cd->atom->nr_waiters == 0;
-			atom_send_event(cd->atom);
+			reiser4_atom_send_event(cd->atom);
 			result = 0;
 		} else if (!atom_can_be_committed(cd->atom)) {
 			if (should_wait_commit(cd->txnh)) {
 				/* sync(): wait for commit */
 				cd->atom->nr_waiters++;
 				cd->wait = 1;
-				atom_wait_event(cd->atom);
+				reiser4_atom_wait_event(cd->atom);
 				result = RETERR(-E_REPEAT);
 			} else {
 				result = 0;
@@ -1655,7 +1658,7 @@ static int try_commit_txnh(commit_data *
 			/* We change   atom state  to   ASTAGE_CAPTURE_WAIT to
 			   prevent atom fusion and count  ourself as an active
 			   flusher */
-			atom_set_stage(cd->atom, ASTAGE_CAPTURE_WAIT);
+			reiser4_atom_set_stage(cd->atom, ASTAGE_CAPTURE_WAIT);
 			cd->atom->flags |= ATOM_FORCE_COMMIT;
 
 			result =
@@ -1694,7 +1697,7 @@ static int commit_txnh(txn_handle * txnh
 	/* calls try_commit_txnh() until either atom commits, or error
 	 * happens */
 	while (try_commit_txnh(&cd) != 0)
-		preempt_point();
+		reiser4_preempt_point();
 
 	spin_lock_txnh(txnh);
 
@@ -1750,8 +1753,8 @@ static int commit_txnh(txn_handle * txnh
    This function acquires and releases the handle's spinlock.  This function is called
    under the jnode lock and if the return value is 0, it returns with the jnode lock still
    held.  If the return is -E_REPEAT or some other error condition, the jnode lock is
-   released.  The external interface (try_capture) manages re-aquiring the jnode lock
-   in the failure case.
+   released.  The external interface (reiser4_try_capture) manages re-aquiring the jnode
+   lock in the failure case.
 */
 static int try_capture_block(
 	txn_handle * txnh, jnode * node, txn_capture mode,
@@ -1760,7 +1763,7 @@ static int try_capture_block(
 	txn_atom *block_atom;
 	txn_atom *txnh_atom;
 
-	/* Should not call capture for READ_NONCOM requests, handled in try_capture. */
+	/* Should not call capture for READ_NONCOM requests, handled in reiser4_try_capture. */
 	assert("jmacd-567", CAPTURE_TYPE(mode) != TXN_CAPTURE_READ_NONCOM);
 
 	/* FIXME-ZAM-HANS: FIXME_LATER_JMACD Should assert that atom->tree ==
@@ -1768,7 +1771,7 @@ static int try_capture_block(
 	assert("umka-194", txnh != NULL);
 	assert("umka-195", node != NULL);
 
-	/* The jnode is already locked!  Being called from try_capture(). */
+	/* The jnode is already locked!  Being called from reiser4_try_capture(). */
 	assert_spin_locked(&(node->guard));
 	block_atom = node->atom;
 
@@ -1931,8 +1934,8 @@ build_capture_mode(jnode * node, znode_l
             cannot be processed immediately as it was requested in flags,
 	    < 0 - other errors.
 */
-int try_capture(jnode *node, znode_lock_mode lock_mode,
-		txn_capture flags)
+int reiser4_try_capture(jnode *node, znode_lock_mode lock_mode,
+			txn_capture flags)
 {
 	txn_atom *atom_alloc = NULL;
 	txn_capture cap_mode;
@@ -2145,7 +2148,7 @@ int try_capture_page_to_invalidate(struc
 	spin_lock_jnode(node);
 	unlock_page(pg);
 
-	ret = try_capture(node, ZNODE_WRITE_LOCK, 0);
+	ret = reiser4_try_capture(node, ZNODE_WRITE_LOCK, 0);
 	spin_unlock_jnode(node);
 	jput(node);
 	lock_page(pg);
@@ -2162,7 +2165,7 @@ move the loop to inside the function.
 
 VS-FIXME-HANS: can this code be at all streamlined?  In particular, can you lock and unlock the jnode fewer times?
   */
-void uncapture_page(struct page *pg)
+void reiser4_uncapture_page(struct page *pg)
 {
 	jnode *node;
 	txn_atom *atom;
@@ -2188,26 +2191,26 @@ void uncapture_page(struct page *pg)
 
 	/* We can remove jnode from transaction even if it is on flush queue
 	 * prepped list, we only need to be sure that flush queue is not being
-	 * written by write_fq().  write_fq() does not use atom spin lock for
-	 * protection of the prepped nodes list, instead write_fq() increments
-	 * atom's nr_running_queues counters for the time when prepped list is
-	 * not protected by spin lock.  Here we check this counter if we want
-	 * to remove jnode from flush queue and, if the counter is not zero,
-	 * wait all write_fq() for this atom to complete. This is not
-	 * significant overhead. */
+	 * written by reiser4_write_fq().  reiser4_write_fq() does not use atom
+	 * spin lock for protection of the prepped nodes list, instead
+	 * write_fq() increments atom's nr_running_queues counters for the time
+	 * when prepped list is not protected by spin lock.  Here we check this
+	 * counter if we want to remove jnode from flush queue and, if the
+	 * counter is not zero, wait all reiser4_write_fq() for this atom to
+	 * complete. This is not significant overhead. */
 	while (JF_ISSET(node, JNODE_FLUSH_QUEUED) && atom->nr_running_queues) {
 		spin_unlock_jnode(node);
 		/*
 		 * at this moment we want to wait for "atom event", viz. wait
 		 * until @node can be removed from flush queue. But
-		 * atom_wait_event() cannot be called with page locked, because
-		 * it deadlocks with jnode_extent_write(). Unlock page, after
-		 * making sure (through page_cache_get()) that it cannot be
-		 * released from memory.
+		 * reiser4_atom_wait_event() cannot be called with page locked,
+		 * because it deadlocks with jnode_extent_write(). Unlock page,
+		 * after making sure (through page_cache_get()) that it cannot
+		 * be released from memory.
 		 */
 		page_cache_get(pg);
 		unlock_page(pg);
-		atom_wait_event(atom);
+		reiser4_atom_wait_event(atom);
 		lock_page(pg);
 		/*
 		 * page may has been detached by ->writepage()->releasepage().
@@ -2222,14 +2225,14 @@ void uncapture_page(struct page *pg)
 			return;
 		}
 	}
-	uncapture_block(node);
+	reiser4_uncapture_block(node);
 	spin_unlock_atom(atom);
 	jput(node);
 }
 
 /* this is used in extent's kill hook to uncapture and unhash jnodes attached to
  * inode's tree of jnodes */
-void uncapture_jnode(jnode * node)
+void reiser4_uncapture_jnode(jnode * node)
 {
 	txn_atom *atom;
 
@@ -2243,7 +2246,7 @@ void uncapture_jnode(jnode * node)
 		return;
 	}
 
-	uncapture_block(node);
+	reiser4_uncapture_block(node);
 	spin_unlock_atom(atom);
 	jput(node);
 }
@@ -2263,7 +2266,7 @@ static void capture_assign_txnh_nolock(t
 
 	atomic_inc(&atom->refcount);
 	txnh->atom = atom;
-	set_gfp_mask();
+	reiser4_ctx_gfp_mask_set();
 	list_add_tail(&txnh->txnh_link, &atom->txnh_list);
 	atom->txnh_count += 1;
 }
@@ -2312,7 +2315,7 @@ static void do_jnode_make_dirty(jnode * 
 	if (!JF_ISSET(node, JNODE_CREATED) && !JF_ISSET(node, JNODE_RELOC)
 	    && !JF_ISSET(node, JNODE_OVRWR) && jnode_is_leaf(node)
 	    && !jnode_is_cluster_page(node)) {
-		assert("vs-1093", !blocknr_is_fake(&node->blocknr));
+		assert("vs-1093", !reiser4_blocknr_is_fake(&node->blocknr));
 		assert("vs-1506", *jnode_get_block(node) != 0);
 		grabbed2flush_reserved_nolock(atom, (__u64) 1);
 		JF_SET(node, JNODE_FLUSH_RESERVED);
@@ -2400,7 +2403,7 @@ void znode_make_dirty(znode * z)
 		spin_unlock_jnode(node);
 		/* reiser4 file write code calls set_page_dirty for
 		 * unformatted nodes, for formatted nodes we do it here. */
-		set_page_dirty_internal(page);
+		reiser4_set_page_dirty_internal(page);
 		page_cache_release(page);
 		/* bump version counter in znode */
 		z->version = znode_build_version(jnode_get_tree(node));
@@ -2413,7 +2416,7 @@ void znode_make_dirty(znode * z)
 	assert("jmacd-9777", node->atom != NULL);
 }
 
-int sync_atom(txn_atom * atom)
+int reiser4_sync_atom(txn_atom * atom)
 {
 	int result;
 	txn_handle *txnh;
@@ -2428,7 +2431,7 @@ int sync_atom(txn_atom * atom)
 			result = force_commit_atom(txnh);
 		} else if (atom->stage < ASTAGE_POST_COMMIT) {
 			/* wait atom commit */
-			atom_wait_event(atom);
+			reiser4_atom_wait_event(atom);
 			/* try once more */
 			result = RETERR(-E_REPEAT);
 		} else
@@ -2507,7 +2510,7 @@ count_jnode(txn_atom * atom, jnode * nod
 		count = 0;
 
 		/* flush queue list */
-		/*check_fq(atom); */
+		/* reiser4_check_fq(atom); */
 
 		/* dirty list */
 		count = 0;
@@ -2570,7 +2573,7 @@ void jnode_make_wander_nolock(jnode * no
 	assert("nikita-2432", !JF_ISSET(node, JNODE_RELOC));
 	assert("nikita-3153", JF_ISSET(node, JNODE_DIRTY));
 	assert("zam-897", !JF_ISSET(node, JNODE_FLUSH_QUEUED));
-	assert("nikita-3367", !blocknr_is_fake(jnode_get_block(node)));
+	assert("nikita-3367", !reiser4_blocknr_is_fake(jnode_get_block(node)));
 
 	atom = node->atom;
 
@@ -2607,7 +2610,7 @@ static void jnode_make_reloc_nolock(flus
 	assert("zam-917", !JF_ISSET(node, JNODE_RELOC));
 	assert("zam-918", !JF_ISSET(node, JNODE_OVRWR));
 	assert("zam-920", !JF_ISSET(node, JNODE_FLUSH_QUEUED));
-	assert("nikita-3367", !blocknr_is_fake(jnode_get_block(node)));
+	assert("nikita-3367", !reiser4_blocknr_is_fake(jnode_get_block(node)));
 	jnode_set_reloc(node);
 }
 
@@ -2640,14 +2643,14 @@ void unformatted_make_reloc(jnode *node,
 	queue_jnode(fq, node);
 }
 
-int capture_super_block(struct super_block *s)
+int reiser4_capture_super_block(struct super_block *s)
 {
 	int result;
 	znode *uber;
 	lock_handle lh;
 
 	init_lh(&lh);
-	result = get_uber_znode(get_tree(s),
+	result = get_uber_znode(reiser4_get_tree(s),
 				ZNODE_WRITE_LOCK, ZNODE_LOCK_LOPRI, &lh);
 	if (result)
 		return result;
@@ -2763,9 +2766,9 @@ static int capture_fuse_wait(txn_handle 
 	/* Go to sleep. */
 	spin_unlock_txnh(txnh);
 
-	ret = prepare_to_sleep(wlinks._lock_stack);
+	ret = reiser4_prepare_to_sleep(wlinks._lock_stack);
 	if (ret == 0) {
-		go_to_sleep(wlinks._lock_stack);
+		reiser4_go_to_sleep(wlinks._lock_stack);
 		ret = RETERR(-E_REPEAT);
 	}
 
@@ -2953,7 +2956,7 @@ static void capture_fuse_into(txn_atom *
 	small->nr_waiters = 0;
 
 	/* splice flush queues */
-	fuse_fq(large, small);
+	reiser4_fuse_fq(large, small);
 
 	/* update counter of jnode on every atom' list */
 	ON_DEBUG(large->dirty += small->dirty;
@@ -3014,11 +3017,11 @@ static void capture_fuse_into(txn_atom *
 
 	if (large->stage < small->stage) {
 		/* Large only needs to notify if it has changed state. */
-		atom_set_stage(large, small->stage);
+		reiser4_atom_set_stage(large, small->stage);
 		wakeup_atom_waiting_list(large);
 	}
 
-	atom_set_stage(small, ASTAGE_INVALID);
+	reiser4_atom_set_stage(small, ASTAGE_INVALID);
 
 	/* Notify any waiters--small needs to unload its wait lists.  Waiters
 	   actually remove themselves from the list before returning from the
@@ -3038,8 +3041,8 @@ static void capture_fuse_into(txn_atom *
 
    NOTE: this function does not release a (journal) reference to jnode
    due to locking optimizations, you should call jput() somewhere after
-   calling uncapture_block(). */
-void uncapture_block(jnode * node)
+   calling reiser4_uncapture_block(). */
+void reiser4_uncapture_block(jnode * node)
 {
 	txn_atom *atom;
 
@@ -3094,7 +3097,7 @@ void insert_into_atom_ovrwr_list(txn_ato
 
 #if REISER4_DEBUG
 
-void info_atom(const char *prefix, const txn_atom * atom)
+void reiser4_info_atom(const char *prefix, const txn_atom * atom)
 {
 	if (atom == NULL) {
 		printk("%s: no atom\n", prefix);
diff -puN fs/reiser4/txnmgr.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/txnmgr.h
--- a/fs/reiser4/txnmgr.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/txnmgr.h
@@ -19,7 +19,7 @@
 
 /* TYPE DECLARATIONS */
 
-/* This enumeration describes the possible types of a capture request (try_capture).
+/* This enumeration describes the possible types of a capture request (reiser4_try_capture).
    A capture request dynamically assigns a block to the calling thread's transaction
    handle. */
 typedef enum {
@@ -53,11 +53,12 @@ typedef enum {
 	   indicate modification will occur. */
 	TXN_CAPTURE_WTYPES = (TXN_CAPTURE_READ_MODIFY | TXN_CAPTURE_WRITE),
 
-	/* An option to try_capture, NONBLOCKING indicates that the caller would
+	/* An option to reiser4_try_capture, NONBLOCKING indicates that the caller would
 	   prefer not to sleep waiting for an aging atom to commit. */
 	TXN_CAPTURE_NONBLOCKING = (1 << 4),
 
-	/* An option to try_capture to prevent atom fusion, just simple capturing is allowed */
+	/* An option to reiser4_try_capture to prevent atom fusion, just simple
+	   capturing is allowed */
 	TXN_CAPTURE_DONT_FUSE = (1 << 5)
 
 	/* This macro selects only the exclusive capture request types, stripping out any
@@ -304,7 +305,7 @@ struct txn_atom {
 	/* number of threads which do jnode_flush() over this atom */
 	int nr_flushers;
 	/* number of flush queues which are IN_USE and jnodes from fq->prepped
-	   are submitted to disk by the write_fq() routine. */
+	   are submitted to disk by the reiser4_write_fq() routine. */
 	int nr_running_queues;
 	/* A counter of grabbed unformatted nodes, see a description of the
 	 * reiser4 space reservation scheme at block_alloc.c */
@@ -393,16 +394,16 @@ struct txn_mgr {
 extern int init_txnmgr_static(void);
 extern void done_txnmgr_static(void);
 
-extern void init_txnmgr(txn_mgr *);
-extern void done_txnmgr(txn_mgr *);
+extern void reiser4_init_txnmgr(txn_mgr *);
+extern void reiser4_done_txnmgr(txn_mgr *);
 
-extern int txn_reserve(int reserved);
+extern int reiser4_txn_reserve(int reserved);
 
-extern void txn_begin(reiser4_context * context);
-extern int txn_end(reiser4_context * context);
+extern void reiser4_txn_begin(reiser4_context * context);
+extern int reiser4_txn_end(reiser4_context * context);
 
-extern void txn_restart(reiser4_context * context);
-extern void txn_restart_current(void);
+extern void reiser4_txn_restart(reiser4_context * context);
+extern void reiser4_txn_restart_current(void);
 
 extern int txnmgr_force_commit_all(struct super_block *, int);
 extern int current_atom_should_commit(void);
@@ -415,21 +416,21 @@ extern int flush_current_atom(int, long,
 
 extern int flush_some_atom(jnode *, long *, const struct writeback_control *, int);
 
-extern void atom_set_stage(txn_atom * atom, txn_stage stage);
+extern void reiser4_atom_set_stage(txn_atom * atom, txn_stage stage);
 
 extern int same_slum_check(jnode * base, jnode * check, int alloc_check,
 			   int alloc_value);
 extern void atom_dec_and_unlock(txn_atom * atom);
 
-extern int try_capture(jnode * node, znode_lock_mode mode, txn_capture flags);
+extern int reiser4_try_capture(jnode * node, znode_lock_mode mode, txn_capture flags);
 extern int try_capture_page_to_invalidate(struct page *pg);
 
-extern void uncapture_page(struct page *pg);
-extern void uncapture_block(jnode *);
-extern void uncapture_jnode(jnode *);
+extern void reiser4_uncapture_page(struct page *pg);
+extern void reiser4_uncapture_block(jnode *);
+extern void reiser4_uncapture_jnode(jnode *);
 
-extern int capture_inode(struct inode *);
-extern int uncapture_inode(struct inode *);
+extern int reiser4_capture_inode(struct inode *);
+extern int reiser4_uncapture_inode(struct inode *);
 
 extern txn_atom *get_current_atom_locked_nocheck(void);
 
@@ -465,11 +466,11 @@ static inline txn_atom *get_current_atom
 
 extern txn_atom *jnode_get_atom(jnode *);
 
-extern void atom_wait_event(txn_atom *);
-extern void atom_send_event(txn_atom *);
+extern void reiser4_atom_wait_event(txn_atom *);
+extern void reiser4_atom_send_event(txn_atom *);
 
 extern void insert_into_atom_ovrwr_list(txn_atom * atom, jnode * node);
-extern int capture_super_block(struct super_block *s);
+extern int reiser4_capture_super_block(struct super_block *s);
 int capture_bulk(jnode **, int count);
 
 /* See the comment on the function blocknrset.c:blocknr_set_add for the
@@ -656,13 +657,13 @@ struct flush_queue {
 #endif
 };
 
-extern int fq_by_atom(txn_atom *, flush_queue_t **);
-extern void fq_put_nolock(flush_queue_t *);
-extern void fq_put(flush_queue_t *);
-extern void fuse_fq(txn_atom * to, txn_atom * from);
+extern int reiser4_fq_by_atom(txn_atom *, flush_queue_t **);
+extern void reiser4_fq_put_nolock(flush_queue_t *);
+extern void reiser4_fq_put(flush_queue_t *);
+extern void reiser4_fuse_fq(txn_atom * to, txn_atom * from);
 extern void queue_jnode(flush_queue_t *, jnode *);
 
-extern int write_fq(flush_queue_t *, long *, int);
+extern int reiser4_write_fq(flush_queue_t *, long *, int);
 extern int current_atom_finish_all_fq(void);
 extern void init_atom_fq_parts(txn_atom *);
 
@@ -671,7 +672,7 @@ extern reiser4_block_nr txnmgr_count_del
 extern void znode_make_dirty(znode * node);
 extern void jnode_make_dirty_locked(jnode * node);
 
-extern int sync_atom(txn_atom * atom);
+extern int reiser4_sync_atom(txn_atom * atom);
 
 #if REISER4_DEBUG
 extern int atom_fq_parts_are_clean(txn_atom *);
@@ -682,12 +683,12 @@ extern flush_queue_t *get_fq_for_current
 
 void protected_jnodes_init(protected_jnodes * list);
 void protected_jnodes_done(protected_jnodes * list);
-void invalidate_list(struct list_head * head);
+void reiser4_invalidate_list(struct list_head * head);
 
 #if REISER4_DEBUG
-void info_atom(const char *prefix, const txn_atom * atom);
+void reiser4_info_atom(const char *prefix, const txn_atom * atom);
 #else
-#define info_atom(p,a) noop
+#define reiser4_info_atom(p,a) noop
 #endif
 
 # endif				/* __REISER4_TXNMGR_H__ */
diff -puN fs/reiser4/vfs_ops.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/vfs_ops.c
--- a/fs/reiser4/vfs_ops.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/vfs_ops.c
@@ -144,7 +144,7 @@ static void reiser4_d_release(struct den
  * Called by reiser4_sync_inodes(), during speculative write-back (through
  * pdflush, or balance_dirty_pages()).
  */
-void writeout(struct super_block *sb, struct writeback_control *wbc)
+void reiser4_writeout(struct super_block *sb, struct writeback_control *wbc)
 {
 	long written = 0;
 	int repeats = 0;
@@ -163,8 +163,8 @@ void writeout(struct super_block *sb, st
 		return;
 	}
 
-	BUG_ON(get_super_fake(sb) == NULL);
-	mapping = get_super_fake(sb)->i_mapping;
+	BUG_ON(reiser4_get_super_fake(sb) == NULL);
+	mapping = reiser4_get_super_fake(sb)->i_mapping;
 	do {
 		long nr_submitted = 0;
 		jnode *node = NULL;
@@ -208,7 +208,7 @@ void writeout(struct super_block *sb, st
 
 void reiser4_throttle_write(struct inode *inode)
 {
-	txn_restart_current();
+	reiser4_txn_restart_current();
 	balance_dirty_pages_ratelimited(inode->i_mapping);
 }
 
diff -puN fs/reiser4/vfs_ops.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/vfs_ops.h
--- a/fs/reiser4/vfs_ops.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/vfs_ops.h
@@ -37,7 +37,7 @@ extern void reiser4_throttle_write(struc
 extern int jnode_is_releasable(jnode *);
 
 #define CAPTURE_APAGE_BURST (1024l)
-void writeout(struct super_block *, struct writeback_control *);
+void reiser4_writeout(struct super_block *, struct writeback_control *);
 
 
 extern void reiser4_handle_error(void);
diff -puN fs/reiser4/wander.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/wander.c
--- a/fs/reiser4/wander.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/wander.c
@@ -493,7 +493,7 @@ static void dealloc_tx_list(struct commi
 				      BA_FORMATTED);
 
 		unpin_jnode_data(cur);
-		drop_io_head(cur);
+		reiser4_drop_io_head(cur);
 	}
 }
 
@@ -507,7 +507,7 @@ dealloc_wmap_actor(txn_atom * atom UNUSE
 
 	assert("zam-499", b != NULL);
 	assert("zam-500", *b != 0);
-	assert("zam-501", !blocknr_is_fake(b));
+	assert("zam-501", !reiser4_blocknr_is_fake(b));
 
 	reiser4_dealloc_block(b, BLOCK_NOT_COUNTED, BA_FORMATTED);
 	return 0;
@@ -536,7 +536,7 @@ get_more_wandered_blocks(int count, reis
 	   ZAM-FIXME-HANS: yes, what happened to our discussion of using a fixed
 	   reserved allocation area so as to get the best qualities of fixed
 	   journals? */
-	blocknr_hint_init(&hint);
+	reiser4_blocknr_hint_init(&hint);
 	hint.block_stage = BLOCK_GRABBED;
 
 	ret = reiser4_alloc_blocks(&hint, start, &wide_len,
@@ -634,18 +634,18 @@ static int get_overwrite_set(struct comm
 				spin_unlock_jnode(sj);
 
 				/* jload it as the rest of overwrite set */
-				jload_gfp(sj, get_gfp_mask(), 0);
+				jload_gfp(sj, reiser4_ctx_gfp_mask_get(), 0);
 
 				ch->overwrite_set_size++;
 			}
 			spin_lock_jnode(cur);
-			uncapture_block(cur);
+			reiser4_uncapture_block(cur);
 			jput(cur);
 
 		} else {
 			int ret;
 			ch->overwrite_set_size++;
-			ret = jload_gfp(cur, get_gfp_mask(), 0);
+			ret = jload_gfp(cur, reiser4_ctx_gfp_mask_get(), 0);
 			if (ret)
 				reiser4_panic("zam-783",
 					      "cannot load e-flushed jnode back (ret = %d)\n",
@@ -913,7 +913,7 @@ add_region_to_wmap(jnode * cur, int len,
 		do {
 			atom = get_current_atom_locked();
 			assert("zam-536",
-			       !blocknr_is_fake(jnode_get_block(cur)));
+			       !reiser4_blocknr_is_fake(jnode_get_block(cur)));
 			ret =
 			    blocknr_set_add_pair(atom, &atom->wandered_map,
 						 &new_bsep,
@@ -1009,7 +1009,7 @@ static int alloc_tx(struct commit_handle
 	while (allocated < (unsigned)ch->tx_size) {
 		len = (ch->tx_size - allocated);
 
-		blocknr_hint_init(&hint);
+		reiser4_blocknr_hint_init(&hint);
 
 		hint.block_stage = BLOCK_GRABBED;
 
@@ -1021,7 +1021,7 @@ static int alloc_tx(struct commit_handle
 		ret = reiser4_alloc_blocks(&hint, &first, &len,
 					   BA_FORMATTED | BA_RESERVED |
 					   BA_USE_DEFAULT_SEARCH_START);
-		blocknr_hint_done(&hint);
+		reiser4_blocknr_hint_done(&hint);
 
 		if (ret)
 			return ret;
@@ -1030,14 +1030,14 @@ static int alloc_tx(struct commit_handle
 
 		/* create jnodes for all wander records */
 		while (len--) {
-			cur = alloc_io_head(&first);
+			cur = reiser4_alloc_io_head(&first);
 
 			if (cur == NULL) {
 				ret = RETERR(-ENOMEM);
 				goto free_not_assigned;
 			}
 
-			ret = jinit_new(cur, get_gfp_mask());
+			ret = jinit_new(cur, reiser4_ctx_gfp_mask_get());
 
 			if (ret != 0) {
 				jfree(cur);
@@ -1126,7 +1126,7 @@ static int commit_tx(struct commit_handl
 			break;
 	} while (0);
 
-	fq_put(fq);
+	reiser4_fq_put(fq);
 	if (ret)
 		return ret;
  repeat_wo_barrier:
@@ -1157,14 +1157,14 @@ static int write_tx_back(struct commit_h
 	int ret;
 	int barrier;
 
-	post_commit_hook();
+	reiser4_post_commit_hook();
 	fq = get_fq_for_current_atom();
 	if (IS_ERR(fq))
 		return  PTR_ERR(fq);
 	spin_unlock_atom(fq->atom);
 	ret = write_jnode_list(
 		ch->overwrite_set, fq, NULL, WRITEOUT_FOR_PAGE_RECLAIM);
-	fq_put(fq);
+	reiser4_fq_put(fq);
 	if (ret)
 		return ret;
  repeat_wo_barrier:
@@ -1187,7 +1187,7 @@ static int write_tx_back(struct commit_h
 	}
 	if (ret)
 		return ret;
-	post_write_back_hook();
+	reiser4_post_write_back_hook();
 	return 0;
 }
 
@@ -1207,7 +1207,7 @@ int reiser4_write_logs(long *nr_submitte
 	writeout_mode_enable();
 
 	/* block allocator may add j-nodes to the clean_list */
-	ret = pre_commit_hook();
+	ret = reiser4_pre_commit_hook();
 	if (ret)
 		return ret;
 
@@ -1221,14 +1221,14 @@ int reiser4_write_logs(long *nr_submitte
 	 * uncaptured after commit_semaphore is taken, because any atom that
 	 * captures these nodes is guaranteed to commit after current one.
 	 *
-	 * This can only be done after pre_commit_hook(), because it is where
+	 * This can only be done after reiser4_pre_commit_hook(), because it is where
 	 * early flushed jnodes with CREATED bit are transferred to the
 	 * overwrite list. */
-	invalidate_list(ATOM_CLEAN_LIST(atom));
+	reiser4_invalidate_list(ATOM_CLEAN_LIST(atom));
 	spin_lock_atom(atom);
 	/* There might be waiters for the relocate nodes which we have
 	 * released, wake them up. */
-	atom_send_event(atom);
+	reiser4_atom_send_event(atom);
 	spin_unlock_atom(atom);
 
 	if (REISER4_DEBUG) {
@@ -1271,11 +1271,11 @@ int reiser4_write_logs(long *nr_submitte
 		goto up_and_ret;
 
 	spin_lock_atom(atom);
-	atom_set_stage(atom, ASTAGE_POST_COMMIT);
+	reiser4_atom_set_stage(atom, ASTAGE_POST_COMMIT);
 	spin_unlock_atom(atom);
 
 	ret = write_tx_back(&ch);
-	post_write_back_hook();
+	reiser4_post_write_back_hook();
 
       up_and_ret:
 	if (ret) {
@@ -1416,20 +1416,20 @@ static int replay_transaction(const stru
 			goto free_ow_set;
 		}
 
-		log = alloc_io_head(&log_rec_block);
+		log = reiser4_alloc_io_head(&log_rec_block);
 		if (log == NULL)
 			return RETERR(-ENOMEM);
 
 		ret = jload(log);
 		if (ret < 0) {
-			drop_io_head(log);
+			reiser4_drop_io_head(log);
 			return ret;
 		}
 
 		ret = check_wander_record(log);
 		if (ret) {
 			jrelse(log);
-			drop_io_head(log);
+			reiser4_drop_io_head(log);
 			return ret;
 		}
 
@@ -1447,26 +1447,26 @@ static int replay_transaction(const stru
 			if (block == 0)
 				break;
 
-			node = alloc_io_head(&block);
+			node = reiser4_alloc_io_head(&block);
 			if (node == NULL) {
 				ret = RETERR(-ENOMEM);
 				/*
 				 * FIXME-VS:???
 				 */
 				jrelse(log);
-				drop_io_head(log);
+				reiser4_drop_io_head(log);
 				goto free_ow_set;
 			}
 
 			ret = jload(node);
 
 			if (ret < 0) {
-				drop_io_head(node);
+				reiser4_drop_io_head(node);
 				/*
 				 * FIXME-VS:???
 				 */
 				jrelse(log);
-				drop_io_head(log);
+				reiser4_drop_io_head(log);
 				goto free_ow_set;
 			}
 
@@ -1482,7 +1482,7 @@ static int replay_transaction(const stru
 		}
 
 		jrelse(log);
-		drop_io_head(log);
+		reiser4_drop_io_head(log);
 
 		--nr_wander_records;
 	}
@@ -1512,7 +1512,7 @@ static int replay_transaction(const stru
 		jnode *cur = list_entry(ch.overwrite_set->next, jnode, capture_link);
 		list_del_init(&cur->capture_link);
 		jrelse(cur);
-		drop_io_head(cur);
+		reiser4_drop_io_head(cur);
 	}
 
 	list_del_init(&tx_head->capture_link);
@@ -1562,20 +1562,20 @@ static int replay_oldest_transaction(str
 
 	/* searching for oldest not flushed transaction */
 	while (1) {
-		tx_head = alloc_io_head(&prev_tx);
+		tx_head = reiser4_alloc_io_head(&prev_tx);
 		if (!tx_head)
 			return RETERR(-ENOMEM);
 
 		ret = jload(tx_head);
 		if (ret < 0) {
-			drop_io_head(tx_head);
+			reiser4_drop_io_head(tx_head);
 			return ret;
 		}
 
 		ret = check_tx_head(tx_head);
 		if (ret) {
 			jrelse(tx_head);
-			drop_io_head(tx_head);
+			reiser4_drop_io_head(tx_head);
 			return ret;
 		}
 
@@ -1587,7 +1587,7 @@ static int replay_oldest_transaction(str
 			break;
 
 		jrelse(tx_head);
-		drop_io_head(tx_head);
+		reiser4_drop_io_head(tx_head);
 	}
 
 	total = le32_to_cpu(get_unaligned(&T->total));
@@ -1601,7 +1601,7 @@ static int replay_oldest_transaction(str
 			       jnode_get_block(tx_head), total - 1);
 
 	unpin_jnode_data(tx_head);
-	drop_io_head(tx_head);
+	reiser4_drop_io_head(tx_head);
 
 	if (ret)
 		return ret;
@@ -1721,14 +1721,14 @@ load_journal_control_block(jnode ** node
 {
 	int ret;
 
-	*node = alloc_io_head(block);
+	*node = reiser4_alloc_io_head(block);
 	if (!(*node))
 		return RETERR(-ENOMEM);
 
 	ret = jload(*node);
 
 	if (ret) {
-		drop_io_head(*node);
+		reiser4_drop_io_head(*node);
 		*node = NULL;
 		return ret;
 	}
@@ -1744,13 +1744,13 @@ static void unload_journal_control_block
 {
 	if (*node) {
 		unpin_jnode_data(*node);
-		drop_io_head(*node);
+		reiser4_drop_io_head(*node);
 		*node = NULL;
 	}
 }
 
 /* release journal control blocks */
-void done_journal_info(struct super_block *s)
+void reiser4_done_journal_info(struct super_block *s)
 {
 	reiser4_super_info_data *sbinfo = get_super_private(s);
 
@@ -1762,7 +1762,7 @@ void done_journal_info(struct super_bloc
 }
 
 /* load journal control blocks */
-int init_journal_info(struct super_block *s)
+int reiser4_init_journal_info(struct super_block *s)
 {
 	reiser4_super_info_data *sbinfo = get_super_private(s);
 	journal_location *loc;
diff -puN fs/reiser4/wander.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/wander.h
--- a/fs/reiser4/wander.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/wander.h
@@ -116,8 +116,8 @@ extern int reiser4_write_logs(long *);
 extern int reiser4_journal_replay(struct super_block *);
 extern int reiser4_journal_recover_sb_data(struct super_block *);
 
-extern int init_journal_info(struct super_block *);
-extern void done_journal_info(struct super_block *);
+extern int reiser4_init_journal_info(struct super_block *);
+extern void reiser4_done_journal_info(struct super_block *);
 
 extern int write_jnode_list(struct list_head *, flush_queue_t *, long *, int);
 
diff -puN fs/reiser4/writeout.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/writeout.h
--- a/fs/reiser4/writeout.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/writeout.h
@@ -6,7 +6,7 @@
 #define WRITEOUT_FOR_PAGE_RECLAIM  (0x2)
 #define WRITEOUT_BARRIER (0x4)
 
-extern int get_writeout_flags(void);
+extern int reiser4_get_writeout_flags(void);
 
 #endif				/* __FS_REISER4_WRITEOUT_H__ */
 
diff -puN fs/reiser4/znode.c~reiser4-rename-generic_sounding_globalspatch fs/reiser4/znode.c
--- a/fs/reiser4/znode.c~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/znode.c
@@ -90,7 +90,7 @@
    When we irrevocably commit ourselves to decision to remove node from the
    tree, JNODE_HEARD_BANSHEE bit is set in zjnode.state of corresponding
    znode. This is done either in ->kill_hook() of internal item or in
-   kill_root() function when tree root is removed.
+   reiser4_kill_root() function when tree root is removed.
 
    At this moment znode still has:
 
@@ -108,9 +108,9 @@
    parent node due to its nonexistence or proper parent node locking and
    nobody uses parent pointers from children due to absence of them. Second we
    invalidate all pending lock requests which still are on znode's lock
-   request queue, this is done by invalidate_lock(). Another JNODE_IS_DYING
-   znode status bit is used to invalidate pending lock requests. Once it set
-   all requesters are forced to return -EINVAL from
+   request queue, this is done by reiser4_invalidate_lock(). Another
+   JNODE_IS_DYING znode status bit is used to invalidate pending lock requests.
+   Once it set all requesters are forced to return -EINVAL from
    longterm_lock_znode(). Future locking attempts are not possible because all
    ways to get references to that znode are removed already. Last, node is
    uncaptured from transaction.
@@ -535,7 +535,7 @@ znode *zget(reiser4_tree * tree,
 		write_unlock_tree(tree);
 	}
 #if REISER4_DEBUG
-	if (!blocknr_is_fake(blocknr) && *blocknr != 0)
+	if (!reiser4_blocknr_is_fake(blocknr) && *blocknr != 0)
 		reiser4_check_block(blocknr, 1);
 #endif
 	/* Check for invalid tree level, return -EIO */
@@ -623,7 +623,7 @@ int zload_ra(znode * node /* znode to lo
 	assert("nikita-1377", znode_invariant(node));
 	assert("jmacd-7771", !znode_above_root(node));
 	assert("nikita-2125", atomic_read(&ZJNODE(node)->x_count) > 0);
-	assert("nikita-3016", schedulable());
+	assert("nikita-3016", reiser4_schedulable());
 
 	if (info)
 		formatted_readahead(node, info);
@@ -695,7 +695,7 @@ reiser4_key *znode_set_rd_key(znode * no
 	       znode_is_any_locked(node) ||
 	       znode_get_level(node) != LEAF_LEVEL ||
 	       keyge(key, &node->rd_key) ||
-	       keyeq(&node->rd_key, min_key()) ||
+	       keyeq(&node->rd_key, reiser4_min_key()) ||
 	       ZF_ISSET(node, JNODE_HEARD_BANSHEE));
 
 	node->rd_key = *key;
@@ -711,7 +711,8 @@ reiser4_key *znode_set_ld_key(znode * no
 	assert_rw_write_locked(&(znode_get_tree(node)->dk_lock));
 	assert("nikita-3070", LOCK_CNT_GTZ(write_locked_dk));
 	assert("nikita-2943",
-	       znode_is_any_locked(node) || keyeq(&node->ld_key, min_key()));
+	       znode_is_any_locked(node) || keyeq(&node->ld_key,
+						  reiser4_min_key()));
 
 	node->ld_key = *key;
 	ON_DEBUG(node->ld_key_version = atomic_inc_return(&delim_key_version));
diff -puN fs/reiser4/znode.h~reiser4-rename-generic_sounding_globalspatch fs/reiser4/znode.h
--- a/fs/reiser4/znode.h~reiser4-rename-generic_sounding_globalspatch
+++ a/fs/reiser4/znode.h
@@ -403,16 +403,17 @@ extern void copy_load_count(load_count *
 
 #if REISER4_DEBUG
 #define STORE_COUNTERS						\
-	lock_counters_info __entry_counters = *lock_counters()
-#define CHECK_COUNTERS						\
-ON_DEBUG_CONTEXT(						\
-({								\
-	__entry_counters.x_refs = lock_counters() -> x_refs;	\
-	__entry_counters.t_refs = lock_counters() -> t_refs;	\
-	__entry_counters.d_refs = lock_counters() -> d_refs;	\
-	assert("nikita-2159",					\
-	       !memcmp(&__entry_counters, lock_counters(),	\
-		       sizeof __entry_counters));		\
+	reiser4_lock_counters_info __entry_counters =		\
+		*reiser4_lock_counters()
+#define CHECK_COUNTERS						        \
+ON_DEBUG_CONTEXT(						        \
+({							        	\
+	__entry_counters.x_refs = reiser4_lock_counters() -> x_refs;	\
+	__entry_counters.t_refs = reiser4_lock_counters() -> t_refs;	\
+	__entry_counters.d_refs = reiser4_lock_counters() -> d_refs;	\
+	assert("nikita-2159",					        \
+	       !memcmp(&__entry_counters, reiser4_lock_counters(),	\
+		       sizeof __entry_counters));		        \
 }) )
 
 #else
_

Patches currently in -mm which might be from edward@namesys.com are

reiser4.patch
reiser4-rename-generic_sounding_globalspatch.patch
reiser4-use-generic-file-read-fix-readpages-unix-file.patch
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
