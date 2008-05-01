From: akpm@linux-foundation.org
Subject: - reiser4-code-cleanups.patch removed from -mm tree
Date: Thu, 01 May 2008 02:24:31 -0700
Message-ID: <200805010924.m419OV2e030133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755242AbYEAJYj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:24:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward.shishkin@gmail.com, cfiend@talent.edu.pl, dusanc@gmail.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: code cleanups
has been removed from the -mm tree.  Its filename was
     reiser4-code-cleanups.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: code cleanups
From: Edward Shishkin <edward.shishkin@gmail.com>

Coding style fixups.

Signed-off-by: Dushan Tcholich <dusanc@gmail.com>
Signed-off-by: Bartosz Szreder <cfiend@talent.edu.pl>
Acked-by: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/as_ops.c                    |    7 
 fs/reiser4/block_alloc.c               |   69 
 fs/reiser4/block_alloc.h               |   20 
 fs/reiser4/blocknrset.c                |   21 
 fs/reiser4/carry.c                     |  163 +-
 fs/reiser4/carry.h                     |  101 -
 fs/reiser4/carry_ops.c                 |  125 -
 fs/reiser4/carry_ops.h                 |    7 
 fs/reiser4/context.c                   |    7 
 fs/reiser4/coord.c                     |  261 +--
 fs/reiser4/coord.h                     |  240 +--
 fs/reiser4/debug.c                     |    2 
 fs/reiser4/debug.h                     |   75 
 fs/reiser4/dformat.h                   |    7 
 fs/reiser4/dscale.c                    |    4 
 fs/reiser4/dscale.h                    |    4 
 fs/reiser4/entd.c                      |    6 
 fs/reiser4/eottl.c                     |   13 
 fs/reiser4/estimate.c                  |   57 
 fs/reiser4/flush.c                     | 1744 ++++++++++++-----------
 fs/reiser4/flush.h                     |  122 -
 fs/reiser4/flush_queue.c               |   46 
 fs/reiser4/forward.h                   |   28 
 fs/reiser4/fsdata.c                    |    4 
 fs/reiser4/fsdata.h                    |    6 
 fs/reiser4/init_super.c                |   14 
 fs/reiser4/inode.c                     |   62 
 fs/reiser4/inode.h                     |   24 
 fs/reiser4/ioctl.h                     |    4 
 fs/reiser4/jnode.c                     |   41 
 fs/reiser4/jnode.h                     |   26 
 fs/reiser4/kassign.c                   |   42 
 fs/reiser4/kassign.h                   |    2 
 fs/reiser4/key.c                       |   13 
 fs/reiser4/key.h                       |  126 -
 fs/reiser4/ktxnmgrd.c                  |   13 
 fs/reiser4/lock.c                      |   71 
 fs/reiser4/lock.h                      |   15 
 fs/reiser4/oid.c                       |    4 
 fs/reiser4/page_cache.c                |   30 
 fs/reiser4/page_cache.h                |    4 
 fs/reiser4/plugin/cluster.c            |    5 
 fs/reiser4/plugin/cluster.h            |   99 -
 fs/reiser4/plugin/dir_plugin_common.c  |   53 
 fs/reiser4/plugin/fibration.h          |    4 
 fs/reiser4/plugin/file_ops_readdir.c   |   30 
 fs/reiser4/plugin/file_plugin_common.c |   84 -
 fs/reiser4/plugin/hash.c               |   25 
 fs/reiser4/plugin/inode_ops.c          |   44 
 fs/reiser4/plugin/inode_ops_rename.c   |   65 
 fs/reiser4/plugin/object.c             |    6 
 fs/reiser4/plugin/object.h             |   10 
 fs/reiser4/plugin/plugin.c             |   11 
 fs/reiser4/plugin/plugin.h             |  155 +-
 fs/reiser4/plugin/plugin_header.h      |   12 
 fs/reiser4/plugin/plugin_set.c         |    5 
 fs/reiser4/plugin/plugin_set.h         |    5 
 fs/reiser4/plugin/tail_policy.c        |   10 
 fs/reiser4/pool.c                      |   18 
 fs/reiser4/pool.h                      |   15 
 fs/reiser4/readahead.c                 |   24 
 fs/reiser4/readahead.h                 |    9 
 fs/reiser4/reiser4.h                   |   15 
 fs/reiser4/safe_link.c                 |   14 
 fs/reiser4/safe_link.h                 |    2 
 fs/reiser4/seal.c                      |   28 
 fs/reiser4/seal.h                      |    2 
 fs/reiser4/search.c                    |  117 -
 fs/reiser4/status_flags.c              |   32 
 fs/reiser4/status_flags.h              |   14 
 fs/reiser4/super.c                     |   46 
 fs/reiser4/super.h                     |   10 
 fs/reiser4/super_ops.c                 |    7 
 fs/reiser4/tap.c                       |   43 
 fs/reiser4/tap.h                       |   32 
 fs/reiser4/tree.c                      |   60 
 fs/reiser4/wander.c                    |    8 
 77 files changed, 2475 insertions(+), 2274 deletions(-)

diff -puN fs/reiser4/as_ops.c~reiser4-code-cleanups fs/reiser4/as_ops.c
--- a/fs/reiser4/as_ops.c~reiser4-code-cleanups
+++ a/fs/reiser4/as_ops.c
@@ -169,7 +169,7 @@ void reiser4_invalidatepage(struct page 
 
 	node = jprivate(page);
 	spin_lock_jnode(node);
-	if (!(node->state & ((1 << JNODE_DIRTY) | (1<< JNODE_FLUSH_QUEUED) |
+	if (!(node->state & ((1 << JNODE_DIRTY) | (1 << JNODE_FLUSH_QUEUED) |
 			  (1 << JNODE_WRITEBACK) | (1 << JNODE_OVRWR)))) {
 		/* there is not need to capture */
 		jref(node);
@@ -211,7 +211,7 @@ void reiser4_invalidatepage(struct page 
 
 /* help function called from reiser4_releasepage(). It returns true if jnode
  * can be detached from its page and page released. */
-int jnode_is_releasable(jnode * node /* node to check */ )
+int jnode_is_releasable(jnode * node/* node to check */)
 {
 	assert("nikita-2781", node != NULL);
 	assert_spin_locked(&(node->guard));
@@ -219,9 +219,8 @@ int jnode_is_releasable(jnode * node /* 
 
 	/* is some thread is currently using jnode page, later cannot be
 	 * detached */
-	if (atomic_read(&node->d_count) != 0) {
+	if (atomic_read(&node->d_count) != 0)
 		return 0;
-	}
 
 	assert("vs-1214", !jnode_is_loaded(node));
 
diff -puN fs/reiser4/block_alloc.c~reiser4-code-cleanups fs/reiser4/block_alloc.c
--- a/fs/reiser4/block_alloc.c~reiser4-code-cleanups
+++ a/fs/reiser4/block_alloc.c
@@ -1,4 +1,5 @@
-/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
+/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
+reiser4/README */
 
 #include "debug.h"
 #include "dformat.h"
@@ -31,21 +32,21 @@
    used -- already allocated blocks,
 
    grabbed -- initially reserved for performing an fs operation, those blocks
-          are taken from free blocks, then grabbed disk space leaks from grabbed
-          blocks counter to other counters like "fake allocated", "flush
-          reserved", "used", the rest of not used grabbed space is returned to
-          free space at the end of fs operation;
+	 are taken from free blocks, then grabbed disk space leaks from grabbed
+	 blocks counter to other counters like "fake allocated", "flush
+	 reserved", "used", the rest of not used grabbed space is returned to
+	 free space at the end of fs operation;
 
    fake allocated -- counts all nodes without real disk block numbers assigned,
-                     we have separate accounting for formatted and unformatted
-                     nodes (for easier debugging);
+		    we have separate accounting for formatted and unformatted
+		    nodes (for easier debugging);
 
    flush reserved -- disk space needed for flushing and committing an atom.
-                     Each dirty already allocated block could be written as a
-                     part of atom's overwrite set or as a part of atom's
-                     relocate set.  In both case one additional block is needed,
-                     it is used as a wandered block if we do overwrite or as a
-		     new location for a relocated block.
+		    Each dirty already allocated block could be written as a
+		    part of atom's overwrite set or as a part of atom's
+		    relocate set.  In both case one additional block is needed,
+		    it is used as a wandered block if we do overwrite or as a
+		    new location for a relocated block.
 
    In addition, blocks in some states are counted on per-thread and per-atom
    basis.  A reiser4 context has a counter of blocks grabbed by this transaction
@@ -68,8 +69,9 @@
    2) one block for either allocating a new node, or dirtying of right or left
       clean neighbor, only one case may happen.
 
-   VS-FIXME-HANS: why can only one case happen? I would expect to see dirtying of left neighbor, right neighbor, current
-   node, and creation of new node.  have I forgotten something?  email me.
+   VS-FIXME-HANS: why can only one case happen? I would expect to see dirtying
+   of left neighbor, right neighbor, current node, and creation of new node.
+   Have I forgotten something?  email me.
 
    These grabbed blocks are counted in both reiser4 context "grabbed blocks"
    counter and in the fs-wide one (both ctx->grabbed_blocks and
@@ -127,7 +129,7 @@ void reiser4_blocknr_hint_init(reiser4_b
 /* Release any resources of a blocknr hint. */
 void reiser4_blocknr_hint_done(reiser4_blocknr_hint * hint UNUSED_ARG)
 {
-	/* No resources should be freed in current blocknr_hint implementation. */
+/* No resources should be freed in current blocknr_hint implementation. */
 }
 
 /* see above for explanation of fake block number.  */
@@ -255,7 +257,7 @@ int reiser4_check_block_counters(const s
    @count           -- number of blocks we reserve;
 
    @return          -- 0 if success,  -ENOSPC, if all
-                       free blocks are preserved or already allocated.
+			free blocks are preserved or already allocated.
 */
 
 static int
@@ -300,7 +302,7 @@ reiser4_grab(reiser4_context * ctx, __u6
 	/* disable grab space in current context */
 	ctx->grab_enabled = 0;
 
-      unlock_and_ret:
+unlock_and_ret:
 	spin_unlock_reiser4_super(sbinfo);
 
 	return ret;
@@ -315,14 +317,14 @@ int reiser4_grab_space(__u64 count, reis
 				   lock_stack_isclean(get_current_lock_stack
 						      ())));
 	ctx = get_current_context();
-	if (!(flags & BA_FORCE) && !is_grab_enabled(ctx)) {
+	if (!(flags & BA_FORCE) && !is_grab_enabled(ctx))
 		return 0;
-	}
 
 	ret = reiser4_grab(ctx, count, flags);
 	if (ret == -ENOSPC) {
 
-		/* Trying to commit the all transactions if BA_CAN_COMMIT flag present */
+		/* Trying to commit the all transactions if BA_CAN_COMMIT flag
+		   present */
 		if (flags & BA_CAN_COMMIT) {
 			txnmgr_force_commit_all(ctx->super, 0);
 			ctx->grab_enabled = 1;
@@ -664,12 +666,12 @@ reiser4_alloc_blocks(reiser4_blocknr_hin
 
 	/* For write-optimized data we use default search start value, which is
 	 * close to last write location. */
-	if (flags & BA_USE_DEFAULT_SEARCH_START) {
+	if (flags & BA_USE_DEFAULT_SEARCH_START)
 		get_blocknr_hint_default(&hint->blk);
-	}
 
-	/* VITALY: allocator should grab this for internal/tx-lists/similar only. */
-/* VS-FIXME-HANS: why is this comment above addressed to vitaly (from vitaly)? */
+	/* VITALY: allocator should grab this for internal/tx-lists/similar
+	   only. */
+/* VS-FIXME-HANS: why is this comment above addressed to vitaly (from vitaly)?*/
 	if (hint->block_stage == BLOCK_NOT_COUNTED) {
 		ret = reiser4_grab_space_force(*len, flags);
 		if (ret != 0)
@@ -765,7 +767,8 @@ used2flush_reserved(reiser4_super_info_d
 	spin_unlock_reiser4_super(sbinfo);
 }
 
-/* disk space, virtually used by fake block numbers is counted as "grabbed" again. */
+/* disk space, virtually used by fake block numbers is counted as "grabbed"
+   again. */
 static void
 fake_allocated2grabbed(reiser4_context * ctx, reiser4_super_info_data * sbinfo,
 		       __u64 count, reiser4_ba_flags_t flags)
@@ -960,10 +963,11 @@ void reiser4_check_block(const reiser4_b
    plugin allocation or store deleted block numbers in atom's delete_set data
    structure depend on @defer parameter. */
 
-/* if BA_DEFER bit is not turned on, @target_stage means the stage of blocks which
-   will be deleted from WORKING bitmap. They might be just unmapped from disk, or
-   freed but disk space is still grabbed by current thread, or these blocks must
-   not be counted in any reiser4 sb block counters, see block_stage_t comment */
+/* if BA_DEFER bit is not turned on, @target_stage means the stage of blocks
+   which will be deleted from WORKING bitmap. They might be just unmapped from
+   disk, or freed but disk space is still grabbed by current thread, or these
+   blocks must not be counted in any reiser4 sb block counters,
+   see block_stage_t comment */
 
 /* BA_FORMATTED bit is only used when BA_DEFER in not present: it is used to
    distinguish blocks allocated for unformatted and formatted nodes */
@@ -1021,8 +1025,8 @@ reiser4_dealloc_blocks(const reiser4_blo
 				  *start, *len);
 
 		if (flags & BA_PERMANENT) {
-			/* These blocks were counted as allocated, we have to revert it
-			 * back if allocation is discarded. */
+			/* These blocks were counted as allocated, we have to
+			 * revert it back if allocation is discarded. */
 			txn_atom *atom = get_current_atom_locked();
 			atom->nr_blocks_allocated -= *len;
 			spin_unlock_atom(atom);
@@ -1031,7 +1035,8 @@ reiser4_dealloc_blocks(const reiser4_blo
 		switch (target_stage) {
 		case BLOCK_NOT_COUNTED:
 			assert("vs-960", flags & BA_FORMATTED);
-			/* VITALY: This is what was grabbed for internal/tx-lists/similar only */
+			/* VITALY: This is what was grabbed for
+			   internal/tx-lists/similar only */
 			used2free(sbinfo, *len);
 			break;
 
diff -puN fs/reiser4/block_alloc.h~reiser4-code-cleanups fs/reiser4/block_alloc.h
--- a/fs/reiser4/block_alloc.h~reiser4-code-cleanups
+++ a/fs/reiser4/block_alloc.h
@@ -1,6 +1,6 @@
 /* Copyright 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
 
-#if !defined (__FS_REISER4_BLOCK_ALLOC_H__)
+#if !defined(__FS_REISER4_BLOCK_ALLOC_H__)
 #define __FS_REISER4_BLOCK_ALLOC_H__
 
 #include "dformat.h"
@@ -9,9 +9,11 @@
 #include <linux/types.h>	/* for __u??  */
 #include <linux/fs.h>
 
-/* Mask when is applied to given block number shows is that block number is a fake one */
+/* Mask when is applied to given block number shows is that block number is a
+   fake one */
 #define REISER4_FAKE_BLOCKNR_BIT_MASK   0x8000000000000000ULL
-/* Mask which isolates a type of object this fake block number was assigned to */
+/* Mask which isolates a type of object this fake block number was assigned
+   to */
 #define REISER4_BLOCKNR_STATUS_BIT_MASK 0xC000000000000000ULL
 
 /*result after applying the REISER4_BLOCKNR_STATUS_BIT_MASK should be compared
@@ -35,9 +37,9 @@ typedef enum {
 
 /* a hint for block allocator */
 struct reiser4_blocknr_hint {
-	/* FIXME: I think we want to add a longterm lock on the bitmap block here.  This
-	   is to prevent jnode_flush() calls from interleaving allocations on the same
-	   bitmap, once a hint is established. */
+	/* FIXME: I think we want to add a longterm lock on the bitmap block
+	   here. This is to prevent jnode_flush() calls from interleaving
+	   allocations on the same bitmap, once a hint is established. */
 
 	/* search start hint */
 	reiser4_block_nr blk;
@@ -69,8 +71,8 @@ enum reiser4_ba_flags {
 	/* defer actual block freeing until transaction commit */
 	BA_DEFER = (1 << 3),
 
-	/* allocate blocks for permanent fs objects (formatted or unformatted), not
-	   wandered of log blocks */
+	/* allocate blocks for permanent fs objects (formatted or unformatted),
+	    not wandered of log blocks */
 	BA_PERMANENT = (1 << 4),
 
 	/* grab space even it was disabled */
@@ -97,7 +99,7 @@ reiser4_block_nr fake_blocknr_unformatte
 
 int reiser4_grab_space(__u64 count, reiser4_ba_flags_t flags);
 void all_grabbed2free(void);
-void grabbed2free(reiser4_context *, reiser4_super_info_data *, __u64 count);
+void grabbed2free(reiser4_context * , reiser4_super_info_data * , __u64 count);
 void fake_allocated2free(__u64 count, reiser4_ba_flags_t flags);
 void grabbed2flush_reserved_nolock(txn_atom * atom, __u64 count);
 void grabbed2flush_reserved(__u64 count);
diff -puN fs/reiser4/blocknrset.c~reiser4-code-cleanups fs/reiser4/blocknrset.c
--- a/fs/reiser4/blocknrset.c~reiser4-code-cleanups
+++ a/fs/reiser4/blocknrset.c
@@ -1,4 +1,5 @@
-/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
+/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
+reiser4/README */
 
 /* This file contains code for various block number sets used by the atom to
    track the deleted set and wandered block mappings. */
@@ -37,9 +38,9 @@
 /* The number of blocks that can fit the blocknr data area. */
 #define BLOCKNR_SET_ENTRIES_NUMBER		\
        ((BLOCKNR_SET_ENTRY_SIZE -		\
-         2 * sizeof (unsigned) -		\
-         sizeof(struct list_head)) /		\
-        sizeof(reiser4_block_nr))
+	2 * sizeof(unsigned) -			\
+	sizeof(struct list_head)) /		\
+	sizeof(reiser4_block_nr))
 
 /* An entry of the blocknr_set */
 struct blocknr_set_entry {
@@ -180,7 +181,8 @@ static int blocknr_set_add(txn_atom *ato
 		bse_put_pair(bse, a, b);
 	}
 
-	/* If new_bsep is non-NULL then there was an allocation race, free this copy. */
+	/* If new_bsep is non-NULL then there was an allocation race, free this
+	   copy. */
 	if (*new_bsep != NULL) {
 		bse_free(*new_bsep);
 		*new_bsep = NULL;
@@ -197,7 +199,7 @@ static int blocknr_set_add(txn_atom *ato
    properly freed. */
 int
 blocknr_set_add_extent(txn_atom * atom,
-		       struct list_head * bset,
+		       struct list_head *bset,
 		       blocknr_set_entry ** new_bsep,
 		       const reiser4_block_nr * start,
 		       const reiser4_block_nr * len)
@@ -215,7 +217,7 @@ blocknr_set_add_extent(txn_atom * atom,
    properly freed. */
 int
 blocknr_set_add_pair(txn_atom * atom,
-		     struct list_head * bset,
+		     struct list_head *bset,
 		     blocknr_set_entry ** new_bsep, const reiser4_block_nr * a,
 		     const reiser4_block_nr * b)
 {
@@ -251,7 +253,7 @@ void blocknr_set_destroy(struct list_hea
    actual processing of this set. Testing this kind of stuff right here is
    also complicated by the fact that these sets are not sorted and going
    through whole set on each element addition is going to be CPU-heavy task */
-void blocknr_set_merge(struct list_head * from, struct list_head * into)
+void blocknr_set_merge(struct list_head *from, struct list_head *into)
 {
 	blocknr_set_entry *bse_into = NULL;
 
@@ -261,7 +263,8 @@ void blocknr_set_merge(struct list_head 
 	/* If @into is not empty, try merging partial-entries. */
 	if (!list_empty(into)) {
 
-		/* Neither set is empty, pop the front to members and try to combine them. */
+		/* Neither set is empty, pop the front to members and try to
+		   combine them. */
 		blocknr_set_entry *bse_from;
 		unsigned into_avail;
 
diff -puN fs/reiser4/carry.c~reiser4-code-cleanups fs/reiser4/carry.c
--- a/fs/reiser4/carry.c~reiser4-code-cleanups
+++ a/fs/reiser4/carry.c
@@ -1,4 +1,5 @@
-/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
+/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
+   reiser4/README */
 /* Functions to "carry" tree modification(s) upward. */
 /* Tree is modified one level at a time. As we modify a level we accumulate a
    set of changes that need to be propagated to the next level.  We manage
@@ -44,7 +45,8 @@
        // Most carry processes will only take objects from here, without
        // dynamic allocation.
 
-I feel uneasy about this pool.  It adds to code complexity, I understand why it exists, but.... -Hans
+I feel uneasy about this pool.  It adds to code complexity, I understand why it
+exists, but.... -Hans
 
        carry_pool  pool;
        carry_level lowest_level;
@@ -63,28 +65,28 @@ I feel uneasy about this pool.  It adds 
 
        op = reiser4_post_carry( &lowest_level, operation, node, 0 );
        if( IS_ERR( op ) || ( op == NULL ) ) {
-           handle error
+		handle error
        } else {
-           // fill in remaining fields in @op, according to carry.h:carry_op
-           result = carry( &lowest_level, NULL );
+	// fill in remaining fields in @op, according to carry.h:carry_op
+		result = carry(&lowest_level, NULL);
        }
-       done_carry_pool( &pool );
+       done_carry_pool(&pool);
     }
 
    When you are implementing node plugin method that participates in carry
    (shifting, insertion, deletion, etc.), do the following:
 
-   int foo_node_method( znode *node, ..., carry_level *todo )
+   int foo_node_method(znode * node, ..., carry_level * todo)
    {
        carry_op   *op;
 
        ....
 
-       // note, that last argument to reiser4_post_carry() is non-null
-       // here, because @op is to be applied to the parent of @node, rather
-       // than to the @node itself as in the previous case.
+	// note, that last argument to reiser4_post_carry() is non-null
+	// here, because @op is to be applied to the parent of @node, rather
+	// than to the @node itself as in the previous case.
 
-       op = node_post_carry( todo, operation, node, 1 );
+       op = node_post_carry(todo, operation, node, 1);
        // fill in remaining fields in @op, according to carry.h:carry_op
 
        ....
@@ -308,7 +310,7 @@ static int carry_on_level(carry_level * 
 
 	/* @doing->nodes are locked. */
 
-	/* This function can be split into two phases: analysis and modification.
+	/* This function can be split into two phases: analysis and modification
 
 	   Analysis calculates precisely what items should be moved between
 	   nodes. This information is gathered in some structures attached to
@@ -451,7 +453,7 @@ carry_pool *init_carry_pool(int size)
 }
 
 /* finish with queue pools */
-void done_carry_pool(carry_pool * pool /* pool to destroy */ )
+void done_carry_pool(carry_pool * pool/* pool to destroy */)
 {
 	reiser4_done_pool(&pool->op_pool);
 	reiser4_done_pool(&pool->node_pool);
@@ -505,14 +507,17 @@ carry_node *reiser4_add_carry_skip(carry
 	return reiser4_add_carry(level, order, reference);
 }
 
-carry_node *reiser4_add_carry(carry_level * level	/* &carry_level to add node
-						 * to */ ,
-		      pool_ordering order	/* where to insert: at the
-						 * beginning of @level, before
-						 * @reference, after @reference,
-						 * at the end of @level */ ,
-		      carry_node * reference	/* reference node for
-						 * insertion */ )
+carry_node *reiser4_add_carry(carry_level * level,   /* carry_level to add
+							node to */
+			      pool_ordering order,   /* where to insert:
+						      * at the beginning of
+						      * @level;
+						      * before @reference;
+						      * after @reference;
+						      * at the end of @level
+						      */
+			      carry_node * reference /* reference node for
+						      * insertion */)
 {
 	carry_node *result;
 
@@ -525,19 +530,20 @@ carry_node *reiser4_add_carry(carry_leve
 	return result;
 }
 
-/* add new carry operation to the @level.
-
-   Returns pointer to the new carry operations allocated from pool. It's up to
-   callers to maintain proper order in the @level. To control ordering use
-   @order and @reference parameters.
-
-*/
-static carry_op *add_op(carry_level * level /* &carry_level to add node to */ ,
-			pool_ordering order	/* where to insert: at the beginning of
-						 * @level, before @reference, after
-						 * @reference, at the end of @level */ ,
-			carry_op *
-			reference /* reference node for insertion */ )
+/**
+ * add new carry operation to the @level.
+ *
+ * Returns pointer to the new carry operations allocated from pool. It's up to
+ * callers to maintain proper order in the @level. To control ordering use
+ * @order and @reference parameters.
+ */
+static carry_op *add_op(carry_level * level, /* &carry_level to add node to */
+			pool_ordering order, /* where to insert:
+					      * at the beginning of @level;
+					      * before @reference;
+					      * after @reference;
+					      * at the end of @level */
+			carry_op * reference /* reference node for insertion */)
 {
 	carry_op *result;
 
@@ -549,19 +555,19 @@ static carry_op *add_op(carry_level * le
 	return result;
 }
 
-/* Return node on the right of which @node was created.
-
-   Each node is created on the right of some existing node (or it is new root,
-   which is special case not handled here).
-
-   @node is new node created on some level, but not yet inserted into its
-   parent, it has corresponding bit (JNODE_ORPHAN) set in zstate.
-
-*/
-static carry_node *find_begetting_brother(carry_node * node	/* node to start search
-								 * from */ ,
-					  carry_level * kin UNUSED_ARG	/* level to
-									 * scan */ )
+/**
+ * Return node on the right of which @node was created.
+ *
+ * Each node is created on the right of some existing node (or it is new root,
+ * which is special case not handled here).
+ *
+ * @node is new node created on some level, but not yet inserted into its
+ * parent, it has corresponding bit (JNODE_ORPHAN) set in zstate.
+ */
+static carry_node *find_begetting_brother(carry_node * node,/* node to start
+								search from */
+					  carry_level * kin UNUSED_ARG
+					                    /* level to scan */)
 {
 	carry_node *scan;
 
@@ -659,9 +665,9 @@ static carry_node *add_carry_atplace(car
 	return reiser4_add_carry(todo, POOLO_BEFORE, reference);
 }
 
-/* like reiser4_post_carry(), but designed to be called from node plugin methods.
-   This function is different from reiser4_post_carry() in that it finds proper
-   place to insert node in the queue. */
+/* like reiser4_post_carry(), but designed to be called from node plugin
+   methods. This function is different from reiser4_post_carry() in that it
+   finds proper place to insert node in the queue. */
 carry_op *node_post_carry(carry_plugin_info * info	/* carry parameters
 							 * passed down to node
 							 * plugin */ ,
@@ -700,7 +706,7 @@ carry_op *node_post_carry(carry_plugin_i
 }
 
 /* lock all carry nodes in @level */
-static int lock_carry_level(carry_level * level /* level to lock */ )
+static int lock_carry_level(carry_level * level/* level to lock */)
 {
 	int result;
 	carry_node *node;
@@ -733,7 +739,7 @@ static int lock_carry_level(carry_level 
 ON_DEBUG(extern atomic_t delim_key_version;
     )
 
-static void sync_dkeys(znode * spot /* node to update */ )
+static void sync_dkeys(znode * spot/* node to update */)
 {
 	reiser4_key pivot;
 	reiser4_tree *tree;
@@ -824,7 +830,7 @@ static void unlock_carry_level(carry_lev
 /* finish with @level
 
    Unlock nodes and release all allocated resources */
-static void done_carry_level(carry_level * level /* level to finish */ )
+static void done_carry_level(carry_level * level/* level to finish */)
 {
 	carry_node *node;
 	carry_node *tmp_node;
@@ -853,7 +859,7 @@ static void done_carry_level(carry_level
    fills ->real_node from this lock handle.
 
 */
-int lock_carry_node_tail(carry_node * node /* node to complete locking of */ )
+int lock_carry_node_tail(carry_node * node/* node to complete locking of */)
 {
 	assert("nikita-1052", node != NULL);
 	assert("nikita-1187", reiser4_carry_real(node) != NULL);
@@ -889,7 +895,7 @@ int lock_carry_node_tail(carry_node * no
 
 */
 int lock_carry_node(carry_level * level /* level @node is in */ ,
-		    carry_node * node /* node to lock */ )
+		    carry_node * node/* node to lock */)
 {
 	int result;
 	znode *reference_point;
@@ -1066,8 +1072,9 @@ followed by remount, but this can wait f
    2. once isolated transactions will be implemented it will be possible to
    roll back offending transaction.
 
-2. is additional code complexity of inconsistent value (it implies that a broken tree should be kept in operation), so we must think about
-it more before deciding if it should be done.  -Hans
+2. is additional code complexity of inconsistent value (it implies that a
+broken tree should be kept in operation), so we must think about it more
+before deciding if it should be done.  -Hans
 
 */
 static void fatal_carry_error(carry_level * doing UNUSED_ARG	/* carry level
@@ -1075,7 +1082,7 @@ static void fatal_carry_error(carry_leve
 								 * unrecoverable
 								 * error
 								 * occurred */ ,
-			      int ecode /* error code */ )
+			      int ecode/* error code */)
 {
 	assert("nikita-1230", doing != NULL);
 	assert("nikita-1231", ecode < 0);
@@ -1083,21 +1090,21 @@ static void fatal_carry_error(carry_leve
 	reiser4_panic("nikita-1232", "Carry failed: %i", ecode);
 }
 
-/* add new root to the tree
-
-   This function itself only manages changes in carry structures and delegates
-   all hard work (allocation of znode for new root, changes of parent and
-   sibling pointers to the reiser4_add_tree_root().
-
-   Locking: old tree root is locked by carry at this point. Fake znode is also
-   locked.
-
-*/
-static int add_new_root(carry_level * level	/* carry level in context of which
-						 * operation is performed */ ,
-			carry_node * node /* carry node for existing root */ ,
-			znode * fake	/* "fake" znode already locked by
-					 * us */ )
+/**
+ * Add new root to the tree
+ *
+ * This function itself only manages changes in carry structures and delegates
+ * all hard work (allocation of znode for new root, changes of parent and
+ * sibling pointers to the reiser4_add_tree_root().
+ *
+ * Locking: old tree root is locked by carry at this point. Fake znode is also
+ * locked.
+ */
+static int add_new_root(carry_level * level,/* carry level in context of which
+					     * operation is performed */
+			carry_node * node,  /* carry node for existing root */
+			znode * fake	    /* "fake" znode already locked by
+					     * us */)
 {
 	int result;
 
@@ -1266,13 +1273,13 @@ static int carry_level_invariant(carry_l
 #endif
 
 /* get symbolic name for boolean */
-static const char *tf(int boolean /* truth value */ )
+static const char *tf(int boolean/* truth value */)
 {
 	return boolean ? "t" : "f";
 }
 
 /* symbolic name for carry operation */
-static const char *carry_op_name(carry_opcode op /* carry opcode */ )
+static const char *carry_op_name(carry_opcode op/* carry opcode */)
 {
 	switch (op) {
 	case COP_INSERT:
@@ -1301,7 +1308,7 @@ static const char *carry_op_name(carry_o
 
 /* dump information about carry node */
 static void print_carry(const char *prefix /* prefix to print */ ,
-			carry_node * node /* node to print */ )
+			carry_node * node/* node to print */)
 {
 	if (node == NULL) {
 		printk("%s: null\n", prefix);
@@ -1315,7 +1322,7 @@ static void print_carry(const char *pref
 
 /* dump information about carry operation */
 static void print_op(const char *prefix /* prefix to print */ ,
-		     carry_op * op /* operation to print */ )
+		     carry_op * op/* operation to print */)
 {
 	if (op == NULL) {
 		printk("%s: null\n", prefix);
@@ -1359,7 +1366,7 @@ static void print_op(const char *prefix 
 
 /* dump information about all nodes and operations in a @level */
 static void print_level(const char *prefix /* prefix to print */ ,
-			carry_level * level /* level to print */ )
+			carry_level * level/* level to print */)
 {
 	carry_node *node;
 	carry_node *tmp_node;
diff -puN fs/reiser4/carry.h~reiser4-code-cleanups fs/reiser4/carry.h
--- a/fs/reiser4/carry.h~reiser4-code-cleanups
+++ a/fs/reiser4/carry.h
@@ -1,9 +1,10 @@
-/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
+/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
+   reiser4/README */
 
 /* Functions and data types to "carry" tree modification(s) upward.
    See fs/reiser4/carry.c for details. */
 
-#if !defined( __FS_REISER4_CARRY_H__ )
+#if !defined(__FS_REISER4_CARRY_H__)
 #define __FS_REISER4_CARRY_H__
 
 #include "forward.h"
@@ -138,12 +139,13 @@ typedef struct carry_insert_data {
 	/* position where new item is to be inserted */
 	coord_t *coord;
 	/* new item description */
-	reiser4_item_data *data;
+	reiser4_item_data * data;
 	/* key of new item */
-	const reiser4_key *key;
+	const reiser4_key * key;
 } carry_insert_data;
 
-/* cut and kill are similar, so carry_cut_data and carry_kill_data share the below structure of parameters */
+/* cut and kill are similar, so carry_cut_data and carry_kill_data share the
+   below structure of parameters */
 struct cut_kill_params {
 	/* coord where cut starts (inclusive) */
 	coord_t *from;
@@ -153,9 +155,9 @@ struct cut_kill_params {
 	/* starting key. This is necessary when item and unit pos don't
 	 * uniquely identify what portion or tree to remove. For example, this
 	 * indicates what portion of extent unit will be affected. */
-	const reiser4_key *from_key;
+	const reiser4_key * from_key;
 	/* exclusive stop key */
-	const reiser4_key *to_key;
+	const reiser4_key * to_key;
 	/* if this is not NULL, smallest actually removed key is stored
 	 * here. */
 	reiser4_key *smallest_removed;
@@ -186,7 +188,8 @@ struct carry_kill_data {
 	 * 2. said neighbors have to be locked. */
 	lock_handle *left;
 	lock_handle *right;
-	/* flags modifying behavior of kill. Currently, it may have DELETE_RETAIN_EMPTY set. */
+	/* flags modifying behavior of kill. Currently, it may have
+	   DELETE_RETAIN_EMPTY set. */
 	unsigned flags;
 	char *buf;
 };
@@ -358,74 +361,74 @@ extern znode *reiser4_carry_real(const c
 
 /* helper macros to iterate over carry queues */
 
-#define carry_node_next( node )					\
+#define carry_node_next(node)						\
 	list_entry((node)->header.level_linkage.next, carry_node,	\
 		   header.level_linkage)
 
-#define carry_node_prev( node )					\
+#define carry_node_prev(node)						\
 	list_entry((node)->header.level_linkage.prev, carry_node,	\
 		   header.level_linkage)
 
-#define carry_node_front( level )						\
+#define carry_node_front(level)						\
 	list_entry((level)->nodes.next, carry_node, header.level_linkage)
 
-#define carry_node_back( level )						\
+#define carry_node_back(level)						\
 	list_entry((level)->nodes.prev, carry_node, header.level_linkage)
 
-#define carry_node_end( level, node )				\
+#define carry_node_end(level, node)				\
 	(&(level)->nodes == &(node)->header.level_linkage)
 
 /* macro to iterate over all operations in a @level */
-#define for_all_ops( level /* carry level (of type carry_level *) */,			\
-		     op    /* pointer to carry operation, modified by loop (of 		\
-			    * type carry_op *) */,					\
-		     tmp   /* pointer to carry operation (of type carry_op *), 		\
-			    * used to make iterator stable in the face of 		\
-			    * deletions from the level */ )				\
-for (op = list_entry(level->ops.next, carry_op, header.level_linkage),			\
+#define for_all_ops(level /* carry level (of type carry_level *) */,	       \
+		    op    /* pointer to carry operation, modified by loop (of  \
+			   * type carry_op *) */,			       \
+		    tmp   /* pointer to carry operation (of type carry_op *),  \
+			   * used to make iterator stable in the face of       \
+			   * deletions from the level */ )		       \
+for (op = list_entry(level->ops.next, carry_op, header.level_linkage),	       \
      tmp = list_entry(op->header.level_linkage.next, carry_op, header.level_linkage); 	\
-     &op->header.level_linkage != &level->ops;						\
-     op = tmp,										\
+     &op->header.level_linkage != &level->ops;				       \
+     op = tmp,								       \
      tmp = list_entry(op->header.level_linkage.next, carry_op, header.level_linkage))
 
 #if 0
-for( op = ( carry_op * ) pool_level_list_front( &level -> ops ),		\
-     tmp = ( carry_op * ) pool_level_list_next( &op -> header ) ;		\
-     ! pool_level_list_end( &level -> ops, &op -> header ) ;			\
-     op = tmp, tmp = ( carry_op * ) pool_level_list_next( &op -> header ) )
+for (op = (carry_op *) pool_level_list_front(&level->ops),	       \
+     tmp = (carry_op *) pool_level_list_next(&op->header) ;	       \
+     !pool_level_list_end(&level->ops, &op->header) ;		       \
+     op = tmp, tmp = (carry_op *) pool_level_list_next(&op->header))
 #endif
 
-/* macro to iterate over all nodes in a @level */						\
-#define for_all_nodes( level /* carry level (of type carry_level *) */,				\
-		       node  /* pointer to carry node, modified by loop (of 			\
-			      * type carry_node *) */,						\
-		       tmp   /* pointer to carry node (of type carry_node *), 			\
-			      * used to make iterator stable in the face of * 			\
-			      * deletions from the level */ )					\
-for (node = list_entry(level->nodes.next, carry_node, header.level_linkage),			\
-     tmp = list_entry(node->header.level_linkage.next, carry_node, header.level_linkage); 	\
-     &node->header.level_linkage != &level->nodes;						\
-     node = tmp, 										\
+/* macro to iterate over all nodes in a @level */			       \
+#define for_all_nodes(level /* carry level (of type carry_level *) */,	       \
+		      node  /* pointer to carry node, modified by loop (of     \
+			      * type carry_node *) */,			       \
+		      tmp   /* pointer to carry node (of type carry_node *),   \
+			      * used to make iterator stable in the face of *  \
+			      * deletions from the level */ )		       \
+for (node = list_entry(level->nodes.next, carry_node, header.level_linkage),   \
+     tmp = list_entry(node->header.level_linkage.next, carry_node, header.level_linkage); \
+     &node->header.level_linkage != &level->nodes;			       \
+     node = tmp, 							       \
      tmp = list_entry(node->header.level_linkage.next, carry_node, header.level_linkage))
 
 #if 0
-for( node = carry_node_front( level ),						\
-     tmp = carry_node_next( node ) ; ! carry_node_end( level, node ) ;		\
-     node = tmp, tmp = carry_node_next( node ) )
+for (node = carry_node_front(level),					\
+     tmp = carry_node_next(node) ; !carry_node_end(level, node) ;	\
+     node = tmp, tmp = carry_node_next(node))
 #endif
 
 /* macro to iterate over all nodes in a @level in reverse order
 
    This is used, because nodes are unlocked in reversed order of locking */
-#define for_all_nodes_back( level /* carry level (of type carry_level *) */,	\
-		            node  /* pointer to carry node, modified by loop	\
-				   * (of type carry_node *) */,			\
-		            tmp   /* pointer to carry node (of type carry_node	\
-				   * *), used to make iterator stable in the	\
-				   * face of deletions from the level */ )	\
-for( node = carry_node_back( level ),		\
-     tmp = carry_node_prev( node ) ; ! carry_node_end( level, node ) ;		\
-     node = tmp, tmp = carry_node_prev( node ) )
+#define for_all_nodes_back(level /* carry level (of type carry_level *) */,    \
+			   node  /* pointer to carry node, modified by loop    \
+				   * (of type carry_node *) */,		       \
+			   tmp   /* pointer to carry node (of type carry_node  \
+				   * *), used to make iterator stable in the   \
+				   * face of deletions from the level */ )     \
+for (node = carry_node_back(level),		\
+     tmp = carry_node_prev(node) ; !carry_node_end(level, node) ;	\
+     node = tmp, tmp = carry_node_prev(node))
 
 /* __FS_REISER4_CARRY_H__ */
 #endif
diff -puN fs/reiser4/carry_ops.c~reiser4-code-cleanups fs/reiser4/carry_ops.c
--- a/fs/reiser4/carry_ops.c~reiser4-code-cleanups
+++ a/fs/reiser4/carry_ops.c
@@ -1,4 +1,5 @@
-/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
+/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
+   reiser4/README */
 
 /* implementation of carry operations */
 
@@ -23,7 +24,7 @@
 #include <linux/types.h>
 #include <linux/err.h>
 
-static int carry_shift_data(sideof side, coord_t * insert_coord, znode * node,
+static int carry_shift_data(sideof side, coord_t *insert_coord, znode * node,
 			    carry_level * doing, carry_level * todo,
 			    unsigned int including_insert_coord_p);
 
@@ -38,7 +39,7 @@ extern int lock_carry_node_tail(carry_no
 */
 static carry_node *find_left_neighbor(carry_op * op	/* node to find left
 							 * neighbor of */ ,
-				      carry_level * doing /* level to scan */ )
+				      carry_level * doing/* level to scan */)
 {
 	int result;
 	carry_node *node;
@@ -120,7 +121,7 @@ static carry_node *find_left_neighbor(ca
 */
 static carry_node *find_right_neighbor(carry_op * op	/* node to find right
 							 * neighbor of */ ,
-				       carry_level * doing /* level to scan */ )
+				       carry_level * doing/* level to scan */)
 {
 	int result;
 	carry_node *node;
@@ -259,12 +260,12 @@ static unsigned int space_needed_for_op(
    @coord. */
 unsigned int space_needed(const znode * node	/* node data are inserted or
 						 * pasted in */ ,
-			  const coord_t * coord	/* coord where data are
+			  const coord_t *coord	/* coord where data are
 						 * inserted or pasted
 						 * at */ ,
-			  const reiser4_item_data * data	/* data to insert or
-								 * paste */ ,
-			  int insertion /* non-0 is inserting, 0---paste */ )
+			  const reiser4_item_data * data /* data to insert or
+							  * paste */ ,
+			  int insertion/* non-0 is inserting, 0---paste */)
 {
 	int result;
 	item_plugin *iplug;
@@ -288,9 +289,8 @@ unsigned int space_needed(const znode * 
 
 		nplug = node->nplug;
 		/* and add node overhead */
-		if (nplug->item_overhead != NULL) {
+		if (nplug->item_overhead != NULL)
 			result += nplug->item_overhead(node, NULL);
-		}
 	}
 	return result;
 }
@@ -322,7 +322,7 @@ static int find_new_child_coord(carry_op
 
 /* additional amount of free space in @node required to complete @op */
 static int free_space_shortage(znode * node /* node to check */ ,
-			       carry_op * op /* operation being performed */ )
+			       carry_op * op/* operation being performed */)
 {
 	assert("nikita-1061", node != NULL);
 	assert("nikita-1062", op != NULL);
@@ -406,7 +406,7 @@ make_space_tail(carry_op * op, carry_lev
 */
 static int make_space(carry_op * op /* carry operation, insert or paste */ ,
 		      carry_level * doing /* current carry queue */ ,
-		      carry_level * todo /* carry queue on the parent level */ )
+		      carry_level * todo/* carry queue on the parent level */)
 {
 	znode *node;
 	int result;
@@ -530,8 +530,8 @@ static int make_space(carry_op * op /* c
 		carry_node *fresh;	/* new node we are allocating */
 		coord_t coord_shadow;	/* remembered insertion point before
 					 * shifting data into new node */
-		carry_node *node_shadow;	/* remembered insertion node before
-						 * shifting */
+		carry_node *node_shadow;	/* remembered insertion node
+						 * before shifting */
 		unsigned int gointo;	/* whether insertion point should move
 					 * into newly allocated node */
 
@@ -682,7 +682,7 @@ static int insert_paste_common(carry_op 
 			       carry_level * todo /* next carry level */ ,
 			       carry_insert_data * cdata	/* pointer to
 								 * cdata */ ,
-			       coord_t * coord /* insertion/paste coord */ ,
+			       coord_t *coord /* insertion/paste coord */ ,
 			       reiser4_item_data * data	/* data to be
 							 * inserted/pasted */ )
 {
@@ -880,9 +880,9 @@ static int carry_insert(carry_op * op /*
  * by slicing into multiple items.
  */
 
-#define flow_insert_point(op) ( ( op ) -> u.insert_flow.insert_point )
-#define flow_insert_flow(op) ( ( op ) -> u.insert_flow.flow )
-#define flow_insert_data(op) ( ( op ) -> u.insert_flow.data )
+#define flow_insert_point(op) ((op)->u.insert_flow.insert_point)
+#define flow_insert_flow(op) ((op)->u.insert_flow.flow)
+#define flow_insert_data(op) ((op)->u.insert_flow.data)
 
 static size_t item_data_overhead(carry_op * op)
 {
@@ -925,7 +925,8 @@ static int what_can_fit_into_node(carry_
 	if (free <= overhead)
 		return 0;
 	free -= overhead;
-	/* FIXME: flow->length is loff_t only to not get overflowed in case of expandign truncate */
+	/* FIXME: flow->length is loff_t only to not get overflowed in case of
+	   expandign truncate */
 	if (free < op->u.insert_flow.flow->length)
 		return free;
 	return (int)op->u.insert_flow.flow->length;
@@ -973,7 +974,7 @@ make_space_by_shift_left(carry_op * op, 
 	   including insertion point into the left neighbor */
 	carry_shift_data(LEFT_SIDE, flow_insert_point(op),
 			 reiser4_carry_real(left), doing, todo,
-			 1 /* including insert point */);
+			 1/* including insert point */);
 	if (reiser4_carry_real(left) != flow_insert_point(op)->node) {
 		/* insertion point did not move */
 		return 1;
@@ -1015,7 +1016,7 @@ make_space_by_shift_right(carry_op * op,
 		   insertion coord into the right neighbor */
 		carry_shift_data(RIGHT_SIDE, flow_insert_point(op),
 				 reiser4_carry_real(right), doing, todo,
-				 0 /* not including insert point */);
+				 0/* not including insert point */);
 	} else {
 		/* right neighbor either does not exist or is unformatted
 		   node */
@@ -1048,38 +1049,33 @@ make_space_by_new_nodes(carry_op * op, c
 		return RETERR(-E_NODE_FULL);
 	/* add new node after insert point node */
 	new = add_new_znode(node, op->node, doing, todo);
-	if (unlikely(IS_ERR(new))) {
+	if (unlikely(IS_ERR(new)))
 		return PTR_ERR(new);
-	}
 	result = lock_carry_node(doing, new);
 	zput(reiser4_carry_real(new));
-	if (unlikely(result)) {
+	if (unlikely(result))
 		return result;
-	}
 	op->u.insert_flow.new_nodes++;
 	if (!coord_is_after_rightmost(flow_insert_point(op))) {
 		carry_shift_data(RIGHT_SIDE, flow_insert_point(op),
 				 reiser4_carry_real(new), doing, todo,
-				 0 /* not including insert point */);
+				 0/* not including insert point */);
 		assert("vs-901",
 		       coord_is_after_rightmost(flow_insert_point(op)));
 
-		if (enough_space_for_min_flow_fraction(op)) {
+		if (enough_space_for_min_flow_fraction(op))
 			return 0;
-		}
 		if (op->u.insert_flow.new_nodes == CARRY_FLOW_NEW_NODES_LIMIT)
 			return RETERR(-E_NODE_FULL);
 
 		/* add one more new node */
 		new = add_new_znode(node, op->node, doing, todo);
-		if (unlikely(IS_ERR(new))) {
+		if (unlikely(IS_ERR(new)))
 			return PTR_ERR(new);
-		}
 		result = lock_carry_node(doing, new);
 		zput(reiser4_carry_real(new));
-		if (unlikely(result)) {
+		if (unlikely(result))
 			return result;
-		}
 		op->u.insert_flow.new_nodes++;
 	}
 
@@ -1164,7 +1160,8 @@ carry_insert_flow(carry_op * op, carry_l
 		flow_insert_data(op)->length = what_can_fit_into_node(op);
 
 		if (can_paste(insert_point, &f->key, flow_insert_data(op))) {
-			/* insert point is set to item of file we are writing to and we have to append to it */
+			/* insert point is set to item of file we are writing to
+			   and we have to append to it */
 			assert("vs-903", insert_point->between == AFTER_UNIT);
 			nplug->change_item_size(insert_point,
 						flow_insert_data(op)->length);
@@ -1231,7 +1228,7 @@ carry_insert_flow(carry_op * op, carry_l
 static int carry_delete(carry_op * op /* operation to be performed */ ,
 			carry_level * doing UNUSED_ARG	/* current carry
 							 * level */ ,
-			carry_level * todo /* next carry level */ )
+			carry_level * todo/* next carry level */)
 {
 	int result;
 	coord_t coord;
@@ -1335,9 +1332,8 @@ static int carry_delete(carry_op * op /*
 	if (znode_is_root(parent) &&
 	    /* don't kill roots at and lower than twig level */
 	    znode_get_level(parent) > REISER4_MIN_TREE_HEIGHT &&
-	    node_num_items(parent) == 1) {
+	    node_num_items(parent) == 1)
 		result = reiser4_kill_tree_root(coord.node);
-	}
 
 	return result < 0 ? : 0;
 }
@@ -1349,7 +1345,7 @@ static int carry_delete(carry_op * op /*
 */
 static int carry_cut(carry_op * op /* operation to be performed */ ,
 		     carry_level * doing /* current carry level */ ,
-		     carry_level * todo /* next carry level */ )
+		     carry_level * todo/* next carry level */)
 {
 	int result;
 	carry_plugin_info info;
@@ -1375,7 +1371,7 @@ static int carry_cut(carry_op * op /* op
 /* helper function for carry_paste(): returns true if @op can be continued as
    paste  */
 static int
-can_paste(coord_t * icoord, const reiser4_key * key,
+can_paste(coord_t *icoord, const reiser4_key * key,
 	  const reiser4_item_data * data)
 {
 	coord_t circa;
@@ -1400,9 +1396,9 @@ can_paste(coord_t * icoord, const reiser
 
 	/* check whether we can paste to the item @icoord is "at" when we
 	   ignore ->between field */
-	if (old_iplug == new_iplug && item_can_contain_key(&circa, key, data)) {
+	if (old_iplug == new_iplug && item_can_contain_key(&circa, key, data))
 		result = 1;
-	} else if (icoord->between == BEFORE_UNIT
+	else if (icoord->between == BEFORE_UNIT
 		   || icoord->between == BEFORE_ITEM) {
 		/* otherwise, try to glue to the item at the left, if any */
 		coord_dup(&circa, icoord);
@@ -1470,7 +1466,7 @@ can_paste(coord_t * icoord, const reiser
 static int carry_paste(carry_op * op /* operation to be performed */ ,
 		       carry_level * doing UNUSED_ARG	/* current carry
 							 * level */ ,
-		       carry_level * todo /* next carry level */ )
+		       carry_level * todo/* next carry level */)
 {
 	znode *node;
 	carry_insert_data cdata;
@@ -1756,7 +1752,7 @@ static int update_delimiting_key(znode *
 */
 static int carry_update(carry_op * op /* operation to be performed */ ,
 			carry_level * doing /* current carry level */ ,
-			carry_level * todo /* next carry level */ )
+			carry_level * todo/* next carry level */)
 {
 	int result;
 	carry_node *missing UNUSED_ARG;
@@ -1818,16 +1814,15 @@ static int carry_update(carry_op * op /*
 
 /* move items from @node during carry */
 static int carry_shift_data(sideof side /* in what direction to move data */ ,
-			    coord_t * insert_coord	/* coord where new item
-							 * is to be inserted */ ,
+			    coord_t *insert_coord	/* coord where new item
+							 * is to be inserted */,
 			    znode * node /* node which data are moved from */ ,
 			    carry_level * doing /* active carry queue */ ,
 			    carry_level * todo	/* carry queue where new
 						 * operations are to be put
 						 * in */ ,
-			    unsigned int including_insert_coord_p	/* true if
-									 * @insertion_coord
-									 * can be moved */ )
+			    unsigned int including_insert_coord_p
+				/* true if @insertion_coord can be moved */ )
 {
 	int result;
 	znode *source;
@@ -1877,7 +1872,7 @@ static carry_node *pool_level_list_prev(
 */
 carry_node *find_left_carry(carry_node * node	/* node to find left neighbor
 						 * of */ ,
-			    carry_level * level /* level to scan */ )
+			    carry_level * level/* level to scan */)
 {
 	return find_dir_carry(node, level,
 			      (carry_iterator) pool_level_list_prev);
@@ -1897,7 +1892,7 @@ static carry_node *pool_level_list_next(
 */
 carry_node *find_right_carry(carry_node * node	/* node to find right neighbor
 						 * of */ ,
-			     carry_level * level /* level to scan */ )
+			     carry_level * level/* level to scan */)
 {
 	return find_dir_carry(node, level,
 			      (carry_iterator) pool_level_list_next);
@@ -1908,12 +1903,12 @@ carry_node *find_right_carry(carry_node 
 
    Helper function used by find_{left|right}_carry().
 */
-static carry_node *find_dir_carry(carry_node * node	/* node to start scanning
-							 * from */ ,
+static carry_node *find_dir_carry(carry_node * node	/* node to start
+							 * scanning from */ ,
 				  carry_level * level /* level to scan */ ,
 				  carry_iterator iterator	/* operation to
-								 * move to the next
-								 * node */ )
+								 * move to the
+								 * next node */)
 {
 	carry_node *neighbor;
 
@@ -2019,9 +2014,11 @@ static int carry_estimate_bitmaps(void)
 	if (reiser4_is_set(reiser4_get_current_sb(), REISER4_DONT_LOAD_BITMAP)) {
 		int bytes;
 
-		bytes = capped_height() * (0 +	/* bnode should be added, but its is private to
-						 * bitmap.c, skip for now. */
-					   2 * sizeof(jnode));	/* working and commit jnodes */
+		bytes = capped_height() * (0 +	/* bnode should be added, but
+						 * its is private to bitmap.c,
+						 * skip for now. */
+					   2 * sizeof(jnode));
+						/* working and commit jnodes */
 		return bytes_to_pages(bytes) + 2;	/* and their contents */
 	} else
 		/* bitmaps were pre-loaded during mount */
@@ -2031,32 +2028,36 @@ static int carry_estimate_bitmaps(void)
 /* worst case item insertion memory requirements */
 static int carry_estimate_insert(carry_op * op, carry_level * level)
 {
-	return carry_estimate_bitmaps() + carry_estimate_znodes() + 1 +	/* new atom */
+	return carry_estimate_bitmaps() + carry_estimate_znodes() + 1 +
+								/* new atom */
 	    capped_height() +	/* new block on each level */
-	    1 +			/* and possibly extra new block at the leaf level */
+	    1 +		/* and possibly extra new block at the leaf level */
 	    3;			/* loading of leaves into memory */
 }
 
 /* worst case item deletion memory requirements */
 static int carry_estimate_delete(carry_op * op, carry_level * level)
 {
-	return carry_estimate_bitmaps() + carry_estimate_znodes() + 1 +	/* new atom */
+	return carry_estimate_bitmaps() + carry_estimate_znodes() + 1 +
+								/* new atom */
 	    3;			/* loading of leaves into memory */
 }
 
 /* worst case tree cut memory requirements */
 static int carry_estimate_cut(carry_op * op, carry_level * level)
 {
-	return carry_estimate_bitmaps() + carry_estimate_znodes() + 1 +	/* new atom */
+	return carry_estimate_bitmaps() + carry_estimate_znodes() + 1 +
+								/* new atom */
 	    3;			/* loading of leaves into memory */
 }
 
 /* worst case memory requirements of pasting into item */
 static int carry_estimate_paste(carry_op * op, carry_level * level)
 {
-	return carry_estimate_bitmaps() + carry_estimate_znodes() + 1 +	/* new atom */
+	return carry_estimate_bitmaps() + carry_estimate_znodes() + 1 +
+								/* new atom */
 	    capped_height() +	/* new block on each level */
-	    1 +			/* and possibly extra new block at the leaf level */
+	    1 +		/* and possibly extra new block at the leaf level */
 	    3;			/* loading of leaves into memory */
 }
 
diff -puN fs/reiser4/carry_ops.h~reiser4-code-cleanups fs/reiser4/carry_ops.h
--- a/fs/reiser4/carry_ops.h~reiser4-code-cleanups
+++ a/fs/reiser4/carry_ops.h
@@ -1,8 +1,9 @@
-/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
+/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
+   reiser4/README */
 
 /* implementation of carry operations. See carry_ops.c for details. */
 
-#if !defined( __CARRY_OPS_H__ )
+#if !defined(__CARRY_OPS_H__)
 #define __CARRY_OPS_H__
 
 #include "forward.h"
@@ -22,7 +23,7 @@ typedef struct carry_op_handler {
    thing. */
 extern carry_op_handler op_dispatch_table[COP_LAST_OP];
 
-unsigned int space_needed(const znode * node, const coord_t * coord,
+unsigned int space_needed(const znode * node, const coord_t *coord,
 			  const reiser4_item_data * data, int inserting);
 extern carry_node *find_left_carry(carry_node * node, carry_level * level);
 extern carry_node *find_right_carry(carry_node * node, carry_level * level);
diff -puN fs/reiser4/context.c~reiser4-code-cleanups fs/reiser4/context.c
--- a/fs/reiser4/context.c~reiser4-code-cleanups
+++ a/fs/reiser4/context.c
@@ -70,7 +70,7 @@ static void _reiser4_init_context(reiser
    This function should be called at the beginning of reiser4 part of
    syscall.
 */
-reiser4_context * reiser4_init_context(struct super_block * super)
+reiser4_context * reiser4_init_context(struct super_block *super)
 {
 	reiser4_context *context;
 
@@ -165,7 +165,8 @@ static void balance_dirty_pages_at(reise
    thread released all locks and closed transcrash etc.
 
 */
-static void reiser4_done_context(reiser4_context * context /* context being released */ )
+static void reiser4_done_context(reiser4_context * context)
+				/* context being released */
 {
 	assert("nikita-860", context != NULL);
 	assert("nikita-859", context->magic == context_magic);
@@ -266,7 +267,7 @@ void reiser4_ctx_gfp_mask_set(void)
 		ctx->gfp_mask = GFP_NOFS;
 }
 
-void reiser4_ctx_gfp_mask_force (gfp_t mask)
+void reiser4_ctx_gfp_mask_force(gfp_t mask)
 {
 	reiser4_context *ctx;
 	ctx = get_current_context();
diff -puN fs/reiser4/coord.c~reiser4-code-cleanups fs/reiser4/coord.c
--- a/fs/reiser4/coord.c~reiser4-code-cleanups
+++ a/fs/reiser4/coord.c
@@ -1,4 +1,5 @@
-/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
+/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
+   reiser4/README */
 
 #include "forward.h"
 #include "debug.h"
@@ -10,7 +11,7 @@
 
 /* Internal constructor. */
 static inline void
-coord_init_values(coord_t * coord, const znode * node, pos_in_node_t item_pos,
+coord_init_values(coord_t *coord, const znode * node, pos_in_node_t item_pos,
 		  pos_in_node_t unit_pos, between_enum between)
 {
 	coord->node = (znode *) node;
@@ -20,12 +21,13 @@ coord_init_values(coord_t * coord, const
 	ON_DEBUG(coord->plug_v = 0);
 	ON_DEBUG(coord->body_v = 0);
 
-	/*ON_TRACE (TRACE_COORDS, "init coord %p node %p: %u %u %s\n", coord, node, item_pos, unit_pos, coord_tween_tostring (between)); */
+	/*ON_TRACE (TRACE_COORDS, "init coord %p node %p: %u %u %s\n", coord,
+ node, item_pos, unit_pos, coord_tween_tostring (between)); */
 }
 
 /* after shifting of node content, coord previously set properly may become
    invalid, try to "normalize" it. */
-void coord_normalize(coord_t * coord)
+void coord_normalize(coord_t *coord)
 {
 	znode *node;
 
@@ -34,12 +36,12 @@ void coord_normalize(coord_t * coord)
 
 	coord_clear_iplug(coord);
 
-	if (node_is_empty(node)) {
+	if (node_is_empty(node))
 		coord_init_first_unit(coord, node);
-	} else if ((coord->between == AFTER_ITEM)
-		   || (coord->between == AFTER_UNIT)) {
+	 else if ((coord->between == AFTER_ITEM)
+		   || (coord->between == AFTER_UNIT))
 		return;
-	} else if (coord->item_pos == coord_num_items(coord)
+	 else if (coord->item_pos == coord_num_items(coord)
 		   && coord->between == BEFORE_ITEM) {
 		coord_dec_item_pos(coord);
 		coord->between = AFTER_ITEM;
@@ -56,7 +58,7 @@ void coord_normalize(coord_t * coord)
 }
 
 /* Copy a coordinate. */
-void coord_dup(coord_t * coord, const coord_t * old_coord)
+void coord_dup(coord_t *coord, const coord_t *old_coord)
 {
 	assert("jmacd-9800", coord_check(old_coord));
 	coord_dup_nocheck(coord, old_coord);
@@ -64,7 +66,7 @@ void coord_dup(coord_t * coord, const co
 
 /* Copy a coordinate without check. Useful when old_coord->node is not
    loaded. As in cbk_tree_lookup -> connect_znode -> connect_one_side */
-void coord_dup_nocheck(coord_t * coord, const coord_t * old_coord)
+void coord_dup_nocheck(coord_t *coord, const coord_t *old_coord)
 {
 	coord->node = old_coord->node;
 	coord_set_item_pos(coord, old_coord->item_pos);
@@ -76,19 +78,19 @@ void coord_dup_nocheck(coord_t * coord, 
 }
 
 /* Initialize an invalid coordinate. */
-void coord_init_invalid(coord_t * coord, const znode * node)
+void coord_init_invalid(coord_t *coord, const znode * node)
 {
 	coord_init_values(coord, node, 0, 0, INVALID_COORD);
 }
 
-void coord_init_first_unit_nocheck(coord_t * coord, const znode * node)
+void coord_init_first_unit_nocheck(coord_t *coord, const znode * node)
 {
 	coord_init_values(coord, node, 0, 0, AT_UNIT);
 }
 
-/* Initialize a coordinate to point at the first unit of the first item.  If the node is
-   empty, it is positioned at the EMPTY_NODE. */
-void coord_init_first_unit(coord_t * coord, const znode * node)
+/* Initialize a coordinate to point at the first unit of the first item. If the
+   node is empty, it is positioned at the EMPTY_NODE. */
+void coord_init_first_unit(coord_t *coord, const znode * node)
 {
 	int is_empty = node_is_empty(node);
 
@@ -97,9 +99,9 @@ void coord_init_first_unit(coord_t * coo
 	assert("jmacd-9801", coord_check(coord));
 }
 
-/* Initialize a coordinate to point at the last unit of the last item.  If the node is
-   empty, it is positioned at the EMPTY_NODE. */
-void coord_init_last_unit(coord_t * coord, const znode * node)
+/* Initialize a coordinate to point at the last unit of the last item.  If the
+   node is empty, it is positioned at the EMPTY_NODE. */
+void coord_init_last_unit(coord_t *coord, const znode * node)
 {
 	int is_empty = node_is_empty(node);
 
@@ -111,9 +113,9 @@ void coord_init_last_unit(coord_t * coor
 	assert("jmacd-9802", coord_check(coord));
 }
 
-/* Initialize a coordinate to before the first item.  If the node is empty, it is
+/* Initialize a coordinate to before the first item. If the node is empty, it is
    positioned at the EMPTY_NODE. */
-void coord_init_before_first_item(coord_t * coord, const znode * node)
+void coord_init_before_first_item(coord_t *coord, const znode * node)
 {
 	int is_empty = node_is_empty(node);
 
@@ -123,9 +125,9 @@ void coord_init_before_first_item(coord_
 	assert("jmacd-9803", coord_check(coord));
 }
 
-/* Initialize a coordinate to after the last item.  If the node is empty, it is positioned
-   at the EMPTY_NODE. */
-void coord_init_after_last_item(coord_t * coord, const znode * node)
+/* Initialize a coordinate to after the last item. If the node is empty, it is
+   positioned at the EMPTY_NODE. */
+void coord_init_after_last_item(coord_t *coord, const znode * node)
 {
 	int is_empty = node_is_empty(node);
 
@@ -138,21 +140,23 @@ void coord_init_after_last_item(coord_t 
 
 /* Initialize a coordinate to after last unit in the item. Coord must be set
    already to existing item */
-void coord_init_after_item_end(coord_t * coord)
+void coord_init_after_item_end(coord_t *coord)
 {
 	coord->between = AFTER_UNIT;
 	coord->unit_pos = coord_last_unit_pos(coord);
 }
 
-/* Initialize a coordinate to before the item. Coord must be set already to existing item */
-void coord_init_before_item(coord_t * coord)
+/* Initialize a coordinate to before the item. Coord must be set already to
+   existing item */
+void coord_init_before_item(coord_t *coord)
 {
 	coord->unit_pos = 0;
 	coord->between = BEFORE_ITEM;
 }
 
-/* Initialize a coordinate to after the item. Coord must be set already to existing item */
-void coord_init_after_item(coord_t * coord)
+/* Initialize a coordinate to after the item. Coord must be set already to
+   existing item */
+void coord_init_after_item(coord_t *coord)
 {
 	coord->unit_pos = 0;
 	coord->between = AFTER_ITEM;
@@ -160,13 +164,14 @@ void coord_init_after_item(coord_t * coo
 
 /* Initialize a coordinate by 0s. Used in places where init_coord was used and
    it was not clear how actually */
-void coord_init_zero(coord_t * coord)
+void coord_init_zero(coord_t *coord)
 {
 	memset(coord, 0, sizeof(*coord));
 }
 
-/* Return the number of units at the present item.  Asserts coord_is_existing_item(). */
-unsigned coord_num_units(const coord_t * coord)
+/* Return the number of units at the present item.
+   Asserts coord_is_existing_item(). */
+unsigned coord_num_units(const coord_t *coord)
 {
 	assert("jmacd-9806", coord_is_existing_item(coord));
 
@@ -175,15 +180,15 @@ unsigned coord_num_units(const coord_t *
 
 /* Returns true if the coord was initializewd by coord_init_invalid (). */
 /* Audited by: green(2002.06.15) */
-int coord_is_invalid(const coord_t * coord)
+int coord_is_invalid(const coord_t *coord)
 {
 	return coord->between == INVALID_COORD;
 }
 
-/* Returns true if the coordinate is positioned at an existing item, not before or after
-   an item.  It may be placed at, before, or after any unit within the item, whether
-   existing or not. */
-int coord_is_existing_item(const coord_t * coord)
+/* Returns true if the coordinate is positioned at an existing item, not before
+   or after an item.  It may be placed at, before, or after any unit within the
+   item, whether existing or not. */
+int coord_is_existing_item(const coord_t *coord)
 {
 	switch (coord->between) {
 	case EMPTY_NODE:
@@ -202,10 +207,10 @@ int coord_is_existing_item(const coord_t
 	return 0;
 }
 
-/* Returns true if the coordinate is positioned at an existing unit, not before or after a
-   unit. */
+/* Returns true if the coordinate is positioned at an existing unit, not before
+   or after a unit. */
 /* Audited by: green(2002.06.15) */
-int coord_is_existing_unit(const coord_t * coord)
+int coord_is_existing_unit(const coord_t *coord)
 {
 	switch (coord->between) {
 	case EMPTY_NODE:
@@ -225,10 +230,11 @@ int coord_is_existing_unit(const coord_t
 	return 0;
 }
 
-/* Returns true if the coordinate is positioned at the first unit of the first item.  Not
-   true for empty nodes nor coordinates positioned before the first item. */
+/* Returns true if the coordinate is positioned at the first unit of the first
+   item. Not true for empty nodes nor coordinates positioned before the first
+   item. */
 /* Audited by: green(2002.06.15) */
-int coord_is_leftmost_unit(const coord_t * coord)
+int coord_is_leftmost_unit(const coord_t *coord)
 {
 	return (coord->between == AT_UNIT && coord->item_pos == 0
 		&& coord->unit_pos == 0);
@@ -236,11 +242,10 @@ int coord_is_leftmost_unit(const coord_t
 
 #if REISER4_DEBUG
 /* For assertions only, checks for a valid coordinate. */
-int coord_check(const coord_t * coord)
+int coord_check(const coord_t *coord)
 {
-	if (coord->node == NULL) {
+	if (coord->node == NULL)
 		return 0;
-	}
 	if (znode_above_root(coord->node))
 		return 1;
 
@@ -249,9 +254,8 @@ int coord_check(const coord_t * coord)
 	case INVALID_COORD:
 		return 0;
 	case EMPTY_NODE:
-		if (!node_is_empty(coord->node)) {
+		if (!node_is_empty(coord->node))
 			return 0;
-		}
 		return coord->item_pos == 0 && coord->unit_pos == 0;
 
 	case BEFORE_UNIT:
@@ -264,15 +268,13 @@ int coord_check(const coord_t * coord)
 	case AFTER_ITEM:
 	case BEFORE_ITEM:
 		/* before/after item should not set unit_pos. */
-		if (coord->unit_pos != 0) {
+		if (coord->unit_pos != 0)
 			return 0;
-		}
 		break;
 	}
 
-	if (coord->item_pos >= node_num_items(coord->node)) {
+	if (coord->item_pos >= node_num_items(coord->node))
 		return 0;
-	}
 
 	/* FIXME-VS: we are going to check unit_pos. This makes no sense when
 	   between is set either AFTER_ITEM or BEFORE_ITEM */
@@ -281,21 +283,19 @@ int coord_check(const coord_t * coord)
 
 	if (coord_is_iplug_set(coord) &&
 	    coord->unit_pos >
-	    item_plugin_by_coord(coord)->b.nr_units(coord) - 1) {
+	    item_plugin_by_coord(coord)->b.nr_units(coord) - 1)
 		return 0;
-	}
 	return 1;
 }
 #endif
 
-/* Adjust coordinate boundaries based on the number of items prior to coord_next/prev.
-   Returns 1 if the new position is does not exist. */
-static int coord_adjust_items(coord_t * coord, unsigned items, int is_next)
+/* Adjust coordinate boundaries based on the number of items prior to
+   coord_next/prev. Returns 1 if the new position is does not exist. */
+static int coord_adjust_items(coord_t *coord, unsigned items, int is_next)
 {
 	/* If the node is invalid, leave it. */
-	if (coord->between == INVALID_COORD) {
+	if (coord->between == INVALID_COORD)
 		return 1;
-	}
 
 	/* If the node is empty, set it appropriately. */
 	if (items == 0) {
@@ -326,15 +326,14 @@ static int coord_adjust_items(coord_t * 
 }
 
 /* Advances the coordinate by one unit to the right.  If empty, no change.  If
-   coord_is_rightmost_unit, advances to AFTER THE LAST ITEM.  Returns 0 if new position is an
-   existing unit. */
-int coord_next_unit(coord_t * coord)
+   coord_is_rightmost_unit, advances to AFTER THE LAST ITEM.  Returns 0 if new
+   position is an existing unit. */
+int coord_next_unit(coord_t *coord)
 {
 	unsigned items = coord_num_items(coord);
 
-	if (coord_adjust_items(coord, items, 1) == 1) {
+	if (coord_adjust_items(coord, items, 1) == 1)
 		return 1;
-	}
 
 	switch (coord->between) {
 	case BEFORE_UNIT:
@@ -344,25 +343,24 @@ int coord_next_unit(coord_t * coord)
 
 	case AFTER_UNIT:
 	case AT_UNIT:
-		/* If it was at or after a unit and there are more units in this item,
-		   advance to the next one. */
+		/* If it was at or after a unit and there are more units in this
+		   item, advance to the next one. */
 		if (coord->unit_pos < coord_last_unit_pos(coord)) {
 			coord->unit_pos += 1;
 			coord->between = AT_UNIT;
 			return 0;
 		}
 
-		/* Otherwise, it is crossing an item boundary and treated as if it was
-		   after the current item. */
+		/* Otherwise, it is crossing an item boundary and treated as if
+		   it was after the current item. */
 		coord->between = AFTER_ITEM;
 		coord->unit_pos = 0;
 		/* FALLTHROUGH */
 
 	case AFTER_ITEM:
 		/* Check for end-of-node. */
-		if (coord->item_pos == items - 1) {
+		if (coord->item_pos == items - 1)
 			return 1;
-		}
 
 		coord_inc_item_pos(coord);
 		coord->unit_pos = 0;
@@ -386,15 +384,14 @@ int coord_next_unit(coord_t * coord)
 }
 
 /* Advances the coordinate by one item to the right.  If empty, no change.  If
-   coord_is_rightmost_unit, advances to AFTER THE LAST ITEM.  Returns 0 if new position is
-   an existing item. */
-int coord_next_item(coord_t * coord)
+   coord_is_rightmost_unit, advances to AFTER THE LAST ITEM.  Returns 0 if new
+   position is an existing item. */
+int coord_next_item(coord_t *coord)
 {
 	unsigned items = coord_num_items(coord);
 
-	if (coord_adjust_items(coord, items, 1) == 1) {
+	if (coord_adjust_items(coord, items, 1) == 1)
 		return 1;
-	}
 
 	switch (coord->between) {
 	case AFTER_UNIT:
@@ -431,15 +428,14 @@ int coord_next_item(coord_t * coord)
 }
 
 /* Advances the coordinate by one unit to the left.  If empty, no change.  If
-   coord_is_leftmost_unit, advances to BEFORE THE FIRST ITEM.  Returns 0 if new position
-   is an existing unit. */
-int coord_prev_unit(coord_t * coord)
+   coord_is_leftmost_unit, advances to BEFORE THE FIRST ITEM.  Returns 0 if new
+   position is an existing unit. */
+int coord_prev_unit(coord_t *coord)
 {
 	unsigned items = coord_num_items(coord);
 
-	if (coord_adjust_items(coord, items, 0) == 1) {
+	if (coord_adjust_items(coord, items, 0) == 1)
 		return 1;
-	}
 
 	switch (coord->between) {
 	case AT_UNIT:
@@ -468,9 +464,8 @@ int coord_prev_unit(coord_t * coord)
 		return 0;
 
 	case BEFORE_ITEM:
-		if (coord->item_pos == 0) {
+		if (coord->item_pos == 0)
 			return 1;
-		}
 
 		coord_dec_item_pos(coord);
 		/* FALLTHROUGH */
@@ -490,15 +485,14 @@ int coord_prev_unit(coord_t * coord)
 }
 
 /* Advances the coordinate by one item to the left.  If empty, no change.  If
-   coord_is_leftmost_unit, advances to BEFORE THE FIRST ITEM.  Returns 0 if new position
-   is an existing item. */
-int coord_prev_item(coord_t * coord)
+   coord_is_leftmost_unit, advances to BEFORE THE FIRST ITEM.  Returns 0 if new
+   position is an existing item. */
+int coord_prev_item(coord_t *coord)
 {
 	unsigned items = coord_num_items(coord);
 
-	if (coord_adjust_items(coord, items, 0) == 1) {
+	if (coord_adjust_items(coord, items, 0) == 1)
 		return 1;
-	}
 
 	switch (coord->between) {
 	case AT_UNIT:
@@ -531,8 +525,9 @@ int coord_prev_item(coord_t * coord)
 	return 0;
 }
 
-/* Calls either coord_init_first_unit or coord_init_last_unit depending on sideof argument. */
-void coord_init_sideof_unit(coord_t * coord, const znode * node, sideof dir)
+/* Calls either coord_init_first_unit or coord_init_last_unit depending on
+   sideof argument. */
+void coord_init_sideof_unit(coord_t *coord, const znode * node, sideof dir)
 {
 	assert("jmacd-9821", dir == LEFT_SIDE || dir == RIGHT_SIDE);
 	if (dir == LEFT_SIDE) {
@@ -542,10 +537,10 @@ void coord_init_sideof_unit(coord_t * co
 	}
 }
 
-/* Calls either coord_is_before_leftmost or coord_is_after_rightmost depending on sideof
-   argument. */
+/* Calls either coord_is_before_leftmost or coord_is_after_rightmost depending
+   on sideof argument. */
 /* Audited by: green(2002.06.15) */
-int coord_is_after_sideof_unit(coord_t * coord, sideof dir)
+int coord_is_after_sideof_unit(coord_t *coord, sideof dir)
 {
 	assert("jmacd-9822", dir == LEFT_SIDE || dir == RIGHT_SIDE);
 	if (dir == LEFT_SIDE) {
@@ -555,9 +550,10 @@ int coord_is_after_sideof_unit(coord_t *
 	}
 }
 
-/* Calls either coord_next_unit or coord_prev_unit depending on sideof argument. */
+/* Calls either coord_next_unit or coord_prev_unit depending on sideof argument.
+ */
 /* Audited by: green(2002.06.15) */
-int coord_sideof_unit(coord_t * coord, sideof dir)
+int coord_sideof_unit(coord_t *coord, sideof dir)
 {
 	assert("jmacd-9823", dir == LEFT_SIDE || dir == RIGHT_SIDE);
 	if (dir == LEFT_SIDE) {
@@ -568,7 +564,7 @@ int coord_sideof_unit(coord_t * coord, s
 }
 
 #if REISER4_DEBUG
-int coords_equal(const coord_t * c1, const coord_t * c2)
+int coords_equal(const coord_t *c1, const coord_t *c2)
 {
 	assert("nikita-2840", c1 != NULL);
 	assert("nikita-2841", c2 != NULL);
@@ -580,26 +576,25 @@ int coords_equal(const coord_t * c1, con
 }
 #endif  /*  REISER4_DEBUG  */
 
-/* If coord_is_after_rightmost return NCOORD_ON_THE_RIGHT, if coord_is_after_leftmost
-   return NCOORD_ON_THE_LEFT, otherwise return NCOORD_INSIDE. */
+/* If coord_is_after_rightmost return NCOORD_ON_THE_RIGHT, if
+   coord_is_after_leftmost return NCOORD_ON_THE_LEFT, otherwise return
+   NCOORD_INSIDE. */
 /* Audited by: green(2002.06.15) */
-coord_wrt_node coord_wrt(const coord_t * coord)
+coord_wrt_node coord_wrt(const coord_t *coord)
 {
-	if (coord_is_before_leftmost(coord)) {
+	if (coord_is_before_leftmost(coord))
 		return COORD_ON_THE_LEFT;
-	}
 
-	if (coord_is_after_rightmost(coord)) {
+	if (coord_is_after_rightmost(coord))
 		return COORD_ON_THE_RIGHT;
-	}
 
 	return COORD_INSIDE;
 }
 
-/* Returns true if the coordinate is positioned after the last item or after the last unit
-   of the last item or it is an empty node. */
+/* Returns true if the coordinate is positioned after the last item or after the
+   last unit of the last item or it is an empty node. */
 /* Audited by: green(2002.06.15) */
-int coord_is_after_rightmost(const coord_t * coord)
+int coord_is_after_rightmost(const coord_t *coord)
 {
 	assert("jmacd-7313", coord_check(coord));
 
@@ -625,9 +620,9 @@ int coord_is_after_rightmost(const coord
 	return 0;
 }
 
-/* Returns true if the coordinate is positioned before the first item or it is an empty
-   node. */
-int coord_is_before_leftmost(const coord_t * coord)
+/* Returns true if the coordinate is positioned before the first item or it is
+   an empty node. */
+int coord_is_before_leftmost(const coord_t *coord)
 {
 	/* FIXME-VS: coord_check requires node to be loaded whereas it is not
 	   necessary to check if coord is set before leftmost
@@ -651,10 +646,11 @@ int coord_is_before_leftmost(const coord
 	return 0;
 }
 
-/* Returns true if the coordinate is positioned after a item, before a item, after the
-   last unit of an item, before the first unit of an item, or at an empty node. */
+/* Returns true if the coordinate is positioned after a item, before a item,
+   after the last unit of an item, before the first unit of an item, or at an
+   empty node. */
 /* Audited by: green(2002.06.15) */
-int coord_is_between_items(const coord_t * coord)
+int coord_is_between_items(const coord_t *coord)
 {
 	assert("jmacd-7313", coord_check(coord));
 
@@ -680,9 +676,9 @@ int coord_is_between_items(const coord_t
 }
 
 #if REISER4_DEBUG
-/* Returns true if the coordinates are positioned at adjacent units, regardless of
-   before-after or item boundaries. */
-int coord_are_neighbors(coord_t * c1, coord_t * c2)
+/* Returns true if the coordinates are positioned at adjacent units, regardless
+   of before-after or item boundaries. */
+int coord_are_neighbors(coord_t *c1, coord_t *c2)
 {
 	coord_t *left;
 	coord_t *right;
@@ -720,10 +716,11 @@ int coord_are_neighbors(coord_t * c1, co
 }
 #endif  /*  REISER4_DEBUG  */
 
-/* Assuming two coordinates are positioned in the same node, return COORD_CMP_ON_RIGHT,
-   COORD_CMP_ON_LEFT, or COORD_CMP_SAME depending on c1's position relative to c2.  */
+/* Assuming two coordinates are positioned in the same node, return
+   COORD_CMP_ON_RIGHT, COORD_CMP_ON_LEFT, or COORD_CMP_SAME depending on c1's
+   position relative to c2.  */
 /* Audited by: green(2002.06.15) */
-coord_cmp coord_compare(coord_t * c1, coord_t * c2)
+coord_cmp coord_compare(coord_t *c1, coord_t *c2)
 {
 	assert("vs-209", c1->node == c2->node);
 	assert("vs-194", coord_is_existing_unit(c1)
@@ -740,15 +737,14 @@ coord_cmp coord_compare(coord_t * c1, co
 	return COORD_CMP_SAME;
 }
 
-/* If the coordinate is between items, shifts it to the right.  Returns 0 on success and
-   non-zero if there is no position to the right. */
-int coord_set_to_right(coord_t * coord)
+/* If the coordinate is between items, shifts it to the right.  Returns 0 on
+   success and non-zero if there is no position to the right. */
+int coord_set_to_right(coord_t *coord)
 {
 	unsigned items = coord_num_items(coord);
 
-	if (coord_adjust_items(coord, items, 1) == 1) {
+	if (coord_adjust_items(coord, items, 1) == 1)
 		return 1;
-	}
 
 	switch (coord->between) {
 	case AT_UNIT:
@@ -779,9 +775,8 @@ int coord_set_to_right(coord_t * coord)
 		}
 
 	case AFTER_ITEM:
-		if (coord->item_pos == items - 1) {
+		if (coord->item_pos == items - 1)
 			return 1;
-		}
 
 		coord_inc_item_pos(coord);
 		coord->unit_pos = 0;
@@ -799,15 +794,14 @@ int coord_set_to_right(coord_t * coord)
 	return 0;
 }
 
-/* If the coordinate is between items, shifts it to the left.  Returns 0 on success and
-   non-zero if there is no position to the left. */
-int coord_set_to_left(coord_t * coord)
+/* If the coordinate is between items, shifts it to the left.  Returns 0 on
+   success and non-zero if there is no position to the left. */
+int coord_set_to_left(coord_t *coord)
 {
 	unsigned items = coord_num_items(coord);
 
-	if (coord_adjust_items(coord, items, 0) == 1) {
+	if (coord_adjust_items(coord, items, 0) == 1)
 		return 1;
-	}
 
 	switch (coord->between) {
 	case AT_UNIT:
@@ -841,9 +835,8 @@ int coord_set_to_left(coord_t * coord)
 		}
 
 	case BEFORE_ITEM:
-		if (coord->item_pos == 0) {
+		if (coord->item_pos == 0)
 			return 1;
-		}
 
 		coord_dec_item_pos(coord);
 		coord->unit_pos = coord_last_unit_pos(coord);
@@ -888,7 +881,7 @@ static const char *coord_tween_tostring(
 	}
 }
 
-void print_coord(const char *mes, const coord_t * coord, int node)
+void print_coord(const char *mes, const coord_t *coord, int node)
 {
 	if (coord == NULL) {
 		printk("%s: null\n", mes);
@@ -900,7 +893,7 @@ void print_coord(const char *mes, const 
 }
 
 int
-item_utmost_child_real_block(const coord_t * coord, sideof side,
+item_utmost_child_real_block(const coord_t *coord, sideof side,
 			     reiser4_block_nr * blk)
 {
 	return item_plugin_by_coord(coord)->f.utmost_child_real_block(coord,
@@ -908,14 +901,14 @@ item_utmost_child_real_block(const coord
 								      blk);
 }
 
-int item_utmost_child(const coord_t * coord, sideof side, jnode ** child)
+int item_utmost_child(const coord_t *coord, sideof side, jnode ** child)
 {
 	return item_plugin_by_coord(coord)->f.utmost_child(coord, side, child);
 }
 
 /* @count bytes of flow @f got written, update correspondingly f->length,
    f->data and f->key */
-void move_flow_forward(flow_t * f, unsigned count)
+void move_flow_forward(flow_t *f, unsigned count)
 {
 	if (f->data)
 		f->data += count;
diff -puN fs/reiser4/coord.h~reiser4-code-cleanups fs/reiser4/coord.h
--- a/fs/reiser4/coord.h~reiser4-code-cleanups
+++ a/fs/reiser4/coord.h
@@ -1,8 +1,9 @@
-/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
+/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
+   reiser4/README */
 
 /* Coords */
 
-#if !defined( __REISER4_COORD_H__ )
+#if !defined(__REISER4_COORD_H__)
 #define __REISER4_COORD_H__
 
 #include "forward.h"
@@ -13,7 +14,7 @@
 /* insertions happen between coords in the tree, so we need some means
    of specifying the sense of betweenness. */
 typedef enum {
-	BEFORE_UNIT,		/* Note: we/init_coord depends on this value being zero. */
+	BEFORE_UNIT, /* Note: we/init_coord depends on this value being zero. */
 	AT_UNIT,
 	AFTER_UNIT,
 	BEFORE_ITEM,
@@ -67,48 +68,48 @@ struct coord {
 #define INVALID_PLUGID  ((char)((1 << 8) - 1))
 #define INVALID_OFFSET -1
 
-static inline void coord_clear_iplug(coord_t * coord)
+static inline void coord_clear_iplug(coord_t *coord)
 {
 	assert("nikita-2835", coord != NULL);
 	coord->iplugid = INVALID_PLUGID;
 	coord->offset = INVALID_OFFSET;
 }
 
-static inline int coord_is_iplug_set(const coord_t * coord)
+static inline int coord_is_iplug_set(const coord_t *coord)
 {
 	assert("nikita-2836", coord != NULL);
 	return coord->iplugid != INVALID_PLUGID;
 }
 
-static inline void coord_set_item_pos(coord_t * coord, pos_in_node_t pos)
+static inline void coord_set_item_pos(coord_t *coord, pos_in_node_t pos)
 {
 	assert("nikita-2478", coord != NULL);
 	coord->item_pos = pos;
 	coord_clear_iplug(coord);
 }
 
-static inline void coord_dec_item_pos(coord_t * coord)
+static inline void coord_dec_item_pos(coord_t *coord)
 {
 	assert("nikita-2480", coord != NULL);
 	--coord->item_pos;
 	coord_clear_iplug(coord);
 }
 
-static inline void coord_inc_item_pos(coord_t * coord)
+static inline void coord_inc_item_pos(coord_t *coord)
 {
 	assert("nikita-2481", coord != NULL);
 	++coord->item_pos;
 	coord_clear_iplug(coord);
 }
 
-static inline void coord_add_item_pos(coord_t * coord, int delta)
+static inline void coord_add_item_pos(coord_t *coord, int delta)
 {
 	assert("nikita-2482", coord != NULL);
 	coord->item_pos += delta;
 	coord_clear_iplug(coord);
 }
 
-static inline void coord_invalid_item_pos(coord_t * coord)
+static inline void coord_invalid_item_pos(coord_t *coord)
 {
 	assert("nikita-2832", coord != NULL);
 	coord->item_pos = (unsigned short)~0;
@@ -134,182 +135,191 @@ static inline sideof sideof_reverse(side
 /* COORD INITIALIZERS */
 
 /* Initialize an invalid coordinate. */
-extern void coord_init_invalid(coord_t * coord, const znode * node);
+extern void coord_init_invalid(coord_t *coord, const znode * node);
 
-extern void coord_init_first_unit_nocheck(coord_t * coord, const znode * node);
+extern void coord_init_first_unit_nocheck(coord_t *coord, const znode * node);
 
-/* Initialize a coordinate to point at the first unit of the first item.  If the node is
-   empty, it is positioned at the EMPTY_NODE. */
-extern void coord_init_first_unit(coord_t * coord, const znode * node);
+/* Initialize a coordinate to point at the first unit of the first item. If the
+   node is empty, it is positioned at the EMPTY_NODE. */
+extern void coord_init_first_unit(coord_t *coord, const znode * node);
 
-/* Initialize a coordinate to point at the last unit of the last item.  If the node is
-   empty, it is positioned at the EMPTY_NODE. */
-extern void coord_init_last_unit(coord_t * coord, const znode * node);
+/* Initialize a coordinate to point at the last unit of the last item. If the
+   node is empty, it is positioned at the EMPTY_NODE. */
+extern void coord_init_last_unit(coord_t *coord, const znode * node);
 
-/* Initialize a coordinate to before the first item.  If the node is empty, it is
+/* Initialize a coordinate to before the first item. If the node is empty, it is
    positioned at the EMPTY_NODE. */
-extern void coord_init_before_first_item(coord_t * coord, const znode * node);
+extern void coord_init_before_first_item(coord_t *coord, const znode * node);
 
-/* Initialize a coordinate to after the last item.  If the node is empty, it is positioned
-   at the EMPTY_NODE. */
-extern void coord_init_after_last_item(coord_t * coord, const znode * node);
+/* Initialize a coordinate to after the last item. If the node is empty, it is
+   positioned at the EMPTY_NODE. */
+extern void coord_init_after_last_item(coord_t *coord, const znode * node);
 
 /* Initialize a coordinate to after last unit in the item. Coord must be set
    already to existing item */
-void coord_init_after_item_end(coord_t * coord);
+void coord_init_after_item_end(coord_t *coord);
 
-/* Initialize a coordinate to before the item. Coord must be set already to existing item */
+/* Initialize a coordinate to before the item. Coord must be set already to
+   existing item */
 void coord_init_before_item(coord_t *);
-/* Initialize a coordinate to after the item. Coord must be set already to existing item */
+/* Initialize a coordinate to after the item. Coord must be set already to
+   existing item */
 void coord_init_after_item(coord_t *);
 
-/* Calls either coord_init_first_unit or coord_init_last_unit depending on sideof argument. */
-extern void coord_init_sideof_unit(coord_t * coord, const znode * node,
+/* Calls either coord_init_first_unit or coord_init_last_unit depending on
+   sideof argument. */
+extern void coord_init_sideof_unit(coord_t *coord, const znode * node,
 				   sideof dir);
 
 /* Initialize a coordinate by 0s. Used in places where init_coord was used and
    it was not clear how actually
    FIXME-VS: added by vs (2002, june, 8) */
-extern void coord_init_zero(coord_t * coord);
+extern void coord_init_zero(coord_t *coord);
 
 /* COORD METHODS */
 
 /* after shifting of node content, coord previously set properly may become
    invalid, try to "normalize" it. */
-void coord_normalize(coord_t * coord);
+void coord_normalize(coord_t *coord);
 
 /* Copy a coordinate. */
-extern void coord_dup(coord_t * coord, const coord_t * old_coord);
+extern void coord_dup(coord_t *coord, const coord_t *old_coord);
 
 /* Copy a coordinate without check. */
-void coord_dup_nocheck(coord_t * coord, const coord_t * old_coord);
+void coord_dup_nocheck(coord_t *coord, const coord_t *old_coord);
 
-unsigned coord_num_units(const coord_t * coord);
+unsigned coord_num_units(const coord_t *coord);
 
 /* Return the last valid unit number at the present item (i.e.,
    coord_num_units() - 1). */
-static inline unsigned coord_last_unit_pos(const coord_t * coord)
+static inline unsigned coord_last_unit_pos(const coord_t *coord)
 {
 	return coord_num_units(coord) - 1;
 }
 
 #if REISER4_DEBUG
 /* For assertions only, checks for a valid coordinate. */
-extern int coord_check(const coord_t * coord);
+extern int coord_check(const coord_t *coord);
 
 extern unsigned long znode_times_locked(const znode * z);
 
-static inline void coord_update_v(coord_t * coord)
+static inline void coord_update_v(coord_t *coord)
 {
 	coord->plug_v = coord->body_v = znode_times_locked(coord->node);
 }
 #endif
 
-extern int coords_equal(const coord_t * c1, const coord_t * c2);
-
-extern void print_coord(const char *mes, const coord_t * coord, int print_node);
+extern int coords_equal(const coord_t *c1, const coord_t *c2);
 
-/* If coord_is_after_rightmost return NCOORD_ON_THE_RIGHT, if coord_is_after_leftmost
-   return NCOORD_ON_THE_LEFT, otherwise return NCOORD_INSIDE. */
-extern coord_wrt_node coord_wrt(const coord_t * coord);
+extern void print_coord(const char *mes, const coord_t *coord, int print_node);
 
-/* Returns true if the coordinates are positioned at adjacent units, regardless of
-   before-after or item boundaries. */
-extern int coord_are_neighbors(coord_t * c1, coord_t * c2);
-
-/* Assuming two coordinates are positioned in the same node, return NCOORD_CMP_ON_RIGHT,
-   NCOORD_CMP_ON_LEFT, or NCOORD_CMP_SAME depending on c1's position relative to c2.  */
-extern coord_cmp coord_compare(coord_t * c1, coord_t * c2);
+/* If coord_is_after_rightmost return NCOORD_ON_THE_RIGHT, if
+   coord_is_after_leftmost return NCOORD_ON_THE_LEFT, otherwise return
+   NCOORD_INSIDE. */
+extern coord_wrt_node coord_wrt(const coord_t *coord);
+
+/* Returns true if the coordinates are positioned at adjacent units, regardless
+   of before-after or item boundaries. */
+extern int coord_are_neighbors(coord_t *c1, coord_t *c2);
+
+/* Assuming two coordinates are positioned in the same node, return
+   NCOORD_CMP_ON_RIGHT, NCOORD_CMP_ON_LEFT, or NCOORD_CMP_SAME depending on c1's
+   position relative to c2.  */
+extern coord_cmp coord_compare(coord_t *c1, coord_t *c2);
 
 /* COORD PREDICATES */
 
 /* Returns true if the coord was initializewd by coord_init_invalid (). */
-extern int coord_is_invalid(const coord_t * coord);
+extern int coord_is_invalid(const coord_t *coord);
 
-/* Returns true if the coordinate is positioned at an existing item, not before or after
-   an item.  It may be placed at, before, or after any unit within the item, whether
-   existing or not.  If this is true you can call methods of the item plugin.  */
-extern int coord_is_existing_item(const coord_t * coord);
-
-/* Returns true if the coordinate is positioned after a item, before a item, after the
-   last unit of an item, before the first unit of an item, or at an empty node. */
-extern int coord_is_between_items(const coord_t * coord);
-
-/* Returns true if the coordinate is positioned at an existing unit, not before or after a
-   unit. */
-extern int coord_is_existing_unit(const coord_t * coord);
+/* Returns true if the coordinate is positioned at an existing item, not before
+   or after an item. It may be placed at, before, or after any unit within the
+   item, whether existing or not. If this is true you can call methods of the
+   item plugin.  */
+extern int coord_is_existing_item(const coord_t *coord);
+
+/* Returns true if the coordinate is positioned after a item, before a item,
+   after the last unit of an item, before the first unit of an item, or at an
+   empty node. */
+extern int coord_is_between_items(const coord_t *coord);
+
+/* Returns true if the coordinate is positioned at an existing unit, not before
+   or after a unit. */
+extern int coord_is_existing_unit(const coord_t *coord);
 
 /* Returns true if the coordinate is positioned at an empty node. */
-extern int coord_is_empty(const coord_t * coord);
-
-/* Returns true if the coordinate is positioned at the first unit of the first item.  Not
-   true for empty nodes nor coordinates positioned before the first item. */
-extern int coord_is_leftmost_unit(const coord_t * coord);
+extern int coord_is_empty(const coord_t *coord);
 
-/* Returns true if the coordinate is positioned after the last item or after the last unit
-   of the last item or it is an empty node. */
-extern int coord_is_after_rightmost(const coord_t * coord);
-
-/* Returns true if the coordinate is positioned before the first item or it is an empty
-   node. */
-extern int coord_is_before_leftmost(const coord_t * coord);
-
-/* Calls either coord_is_before_leftmost or coord_is_after_rightmost depending on sideof
-   argument. */
-extern int coord_is_after_sideof_unit(coord_t * coord, sideof dir);
+/* Returns true if the coordinate is positioned at the first unit of the first
+   item. Not true for empty nodes nor coordinates positioned before the first
+   item. */
+extern int coord_is_leftmost_unit(const coord_t *coord);
+
+/* Returns true if the coordinate is positioned after the last item or after the
+   last unit of the last item or it is an empty node. */
+extern int coord_is_after_rightmost(const coord_t *coord);
+
+/* Returns true if the coordinate is positioned before the first item or it is
+    an empty node. */
+extern int coord_is_before_leftmost(const coord_t *coord);
+
+/* Calls either coord_is_before_leftmost or coord_is_after_rightmost depending
+   on sideof argument. */
+extern int coord_is_after_sideof_unit(coord_t *coord, sideof dir);
 
 /* COORD MODIFIERS */
 
 /* Advances the coordinate by one unit to the right.  If empty, no change.  If
-   coord_is_rightmost_unit, advances to AFTER THE LAST ITEM.  Returns 0 if new position is
-   an existing unit. */
-extern int coord_next_unit(coord_t * coord);
+   coord_is_rightmost_unit, advances to AFTER THE LAST ITEM.  Returns 0 if new
+   position is an existing unit. */
+extern int coord_next_unit(coord_t *coord);
 
 /* Advances the coordinate by one item to the right.  If empty, no change.  If
-   coord_is_rightmost_unit, advances to AFTER THE LAST ITEM.  Returns 0 if new position is
-   an existing item. */
-extern int coord_next_item(coord_t * coord);
+   coord_is_rightmost_unit, advances to AFTER THE LAST ITEM.  Returns 0 if new
+   position is an existing item. */
+extern int coord_next_item(coord_t *coord);
 
 /* Advances the coordinate by one unit to the left.  If empty, no change.  If
-   coord_is_leftmost_unit, advances to BEFORE THE FIRST ITEM.  Returns 0 if new position
-   is an existing unit. */
-extern int coord_prev_unit(coord_t * coord);
-
-/* Advances the coordinate by one item to the left.  If empty, no change.  If
-   coord_is_leftmost_unit, advances to BEFORE THE FIRST ITEM.  Returns 0 if new position
-   is an existing item. */
-extern int coord_prev_item(coord_t * coord);
-
-/* If the coordinate is between items, shifts it to the right.  Returns 0 on success and
-   non-zero if there is no position to the right. */
-extern int coord_set_to_right(coord_t * coord);
-
-/* If the coordinate is between items, shifts it to the left.  Returns 0 on success and
-   non-zero if there is no position to the left. */
-extern int coord_set_to_left(coord_t * coord);
-
-/* If the coordinate is at an existing unit, set to after that unit.  Returns 0 on success
-   and non-zero if the unit did not exist. */
-extern int coord_set_after_unit(coord_t * coord);
+   coord_is_leftmost_unit, advances to BEFORE THE FIRST ITEM.  Returns 0 if new
+   position is an existing unit. */
+extern int coord_prev_unit(coord_t *coord);
+
+/* Advances the coordinate by one item to the left.  If empty, no change. If
+   coord_is_leftmost_unit, advances to BEFORE THE FIRST ITEM. Returns 0 if new
+   position is an existing item. */
+extern int coord_prev_item(coord_t *coord);
+
+/* If the coordinate is between items, shifts it to the right.  Returns 0 on
+   success and non-zero if there is no position to the right. */
+extern int coord_set_to_right(coord_t *coord);
+
+/* If the coordinate is between items, shifts it to the left.  Returns 0 on
+   success and non-zero if there is no position to the left. */
+extern int coord_set_to_left(coord_t *coord);
+
+/* If the coordinate is at an existing unit, set to after that unit.  Returns 0
+   on success and non-zero if the unit did not exist. */
+extern int coord_set_after_unit(coord_t *coord);
 
-/* Calls either coord_next_unit or coord_prev_unit depending on sideof argument. */
-extern int coord_sideof_unit(coord_t * coord, sideof dir);
+/* Calls either coord_next_unit or coord_prev_unit depending on sideof
+   argument. */
+extern int coord_sideof_unit(coord_t *coord, sideof dir);
 
 /* iterate over all units in @node */
-#define for_all_units( coord, node )					\
-	for( coord_init_before_first_item( ( coord ), ( node ) ) ; 	\
-	     coord_next_unit( coord ) == 0 ; )
+#define for_all_units(coord, node)					\
+	for (coord_init_before_first_item((coord), (node)) ;		\
+	     coord_next_unit(coord) == 0 ;)
 
 /* iterate over all items in @node */
-#define for_all_items( coord, node )					\
-	for( coord_init_before_first_item( ( coord ), ( node ) ) ; 	\
-	     coord_next_item( coord ) == 0 ; )
+#define for_all_items(coord, node)					\
+	for (coord_init_before_first_item((coord), (node)) ;		\
+	     coord_next_item(coord) == 0 ;)
 
 /* COORD/ITEM METHODS */
 
-extern int item_utmost_child_real_block(const coord_t * coord, sideof side,
+extern int item_utmost_child_real_block(const coord_t *coord, sideof side,
 					reiser4_block_nr * blk);
-extern int item_utmost_child(const coord_t * coord, sideof side,
+extern int item_utmost_child(const coord_t *coord, sideof side,
 			     jnode ** child);
 
 /* a flow is a sequence of bytes being written to or read from the tree.  The
@@ -324,7 +334,7 @@ struct flow {
 	rw_op op;		/* NIKITA-FIXME-HANS: comment is where?  */
 };
 
-void move_flow_forward(flow_t * f, unsigned count);
+void move_flow_forward(flow_t *f, unsigned count);
 
 /* &reiser4_item_data - description of data to be inserted or pasted
 
diff -puN fs/reiser4/debug.c~reiser4-code-cleanups fs/reiser4/debug.c
--- a/fs/reiser4/debug.c~reiser4-code-cleanups
+++ a/fs/reiser4/debug.c
@@ -60,7 +60,7 @@ static DEFINE_SPINLOCK(panic_guard);
 
 /* Your best friend. Call it on each occasion.  This is called by
     fs/reiser4/debug.h:reiser4_panic(). */
-void reiser4_do_panic(const char *format /* format string */ , ... /* rest */ )
+void reiser4_do_panic(const char *format/* format string */ , ... /* rest */)
 {
 	static int in_panic = 0;
 	va_list args;
diff -puN fs/reiser4/debug.h~reiser4-code-cleanups fs/reiser4/debug.h
--- a/fs/reiser4/debug.h~reiser4-code-cleanups
+++ a/fs/reiser4/debug.h
@@ -1,8 +1,9 @@
-/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
+/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
+   reiser4/README */
 
 /* Declarations of debug macros. */
 
-#if !defined( __FS_REISER4_DEBUG_H__ )
+#if !defined(__FS_REISER4_DEBUG_H__)
 #define __FS_REISER4_DEBUG_H__
 
 #include "forward.h"
@@ -37,9 +38,9 @@
     in 3.x journal.c. If cassertion fails you get compiler error,
     so no "maintainer-id".
 */
-#define cassert(cond) ({ switch(-1) { case (cond): case 0: break; } })
+#define cassert(cond) ({ switch (-1) { case (cond): case 0: break; } })
 
-#define noop   do {;} while(0)
+#define noop   do {; } while (0)
 
 #if REISER4_DEBUG
 /* version of info that only actually prints anything when _d_ebugging
@@ -48,38 +49,38 @@
 /* macro to catch logical errors. Put it into `default' clause of
     switch() statement. */
 #define impossible(label, format, ...) 			\
-         reiser4_panic(label, "impossible: " format , ## __VA_ARGS__)
+	reiser4_panic(label, "impossible: " format , ## __VA_ARGS__)
 /* assert assures that @cond is true. If it is not, reiser4_panic() is
    called. Use this for checking logical consistency and _never_ call
    this to check correctness of external data: disk blocks and user-input . */
-#define assert(label, cond)							\
-({										\
-	/* call_on_each_assert(); */						\
-	if (cond) {								\
-		/* put negated check to avoid using !(cond) that would lose	\
-		 * warnings for things like assert(a = b); */			\
-		;								\
-	} else {								\
-		DEBUGON(1);							\
-		reiser4_panic(label, "assertion failed: %s", #cond);		\
-	}									\
+#define assert(label, cond)						\
+({									\
+	/* call_on_each_assert(); */					\
+	if (cond) {							\
+		/* put negated check to avoid using !(cond) that would lose \
+		 * warnings for things like assert(a = b); */		\
+		;							\
+	} else {							\
+		DEBUGON(1);						\
+		reiser4_panic(label, "assertion failed: %s", #cond);	\
+	}								\
 })
 
 /* like assertion, but @expr is evaluated even if REISER4_DEBUG is off. */
-#define check_me( label, expr )	assert( label, ( expr ) )
+#define check_me(label, expr)	assert(label, (expr))
 
-#define ON_DEBUG( exp ) exp
+#define ON_DEBUG(exp) exp
 
 extern int reiser4_schedulable(void);
 extern void call_on_each_assert(void);
 
 #else
 
-#define dinfo( format, args... ) noop
-#define impossible( label, format, args... ) noop
-#define assert( label, cond ) noop
-#define check_me( label, expr )	( ( void ) ( expr ) )
-#define ON_DEBUG( exp )
+#define dinfo(format, args...) noop
+#define impossible(label, format, args...) noop
+#define assert(label, cond) noop
+#define check_me(label, expr)	((void) (expr))
+#define ON_DEBUG(exp)
 #define reiser4_schedulable() might_sleep()
 
 /* REISER4_DEBUG */
@@ -157,7 +158,7 @@ typedef struct reiser4_lock_cnt_info {
 #define LOCK_CNT_DEC(counter) noop
 #define LOCK_CNT_NIL(counter) (1)
 #define LOCK_CNT_GTZ(counter) (1)
-#define LOCK_CNT_LT(counter,n) (1)
+#define LOCK_CNT_LT(counter, n) (1)
 
 #endif				/* REISER4_DEBUG */
 
@@ -190,35 +191,35 @@ extern int is_in_reiser4_context(void);
  * evaluate expression @e only if with reiser4 context
  */
 #define ON_CONTEXT(e)	do {			\
-	if(is_in_reiser4_context()) {		\
+	if (is_in_reiser4_context()) {		\
 		e;				\
-	} } while(0)
+	} } while (0)
 
 /*
  * evaluate expression @e only when within reiser4_context and debugging is
  * on.
  */
-#define ON_DEBUG_CONTEXT( e ) ON_DEBUG( ON_CONTEXT( e ) )
+#define ON_DEBUG_CONTEXT(e) ON_DEBUG(ON_CONTEXT(e))
 
 /*
  * complain about unexpected function result and crash. Used in "default"
  * branches of switch statements and alike to assert that invalid results are
  * not silently ignored.
  */
-#define wrong_return_value( label, function )				\
-	impossible( label, "wrong return value from " function )
+#define wrong_return_value(label, function)				\
+	impossible(label, "wrong return value from " function)
 
 /* Issue different types of reiser4 messages to the console */
-#define warning( label, format, ... )					\
-	DCALL( KERN_WARNING, 						\
-	       printk, 1, label, "WARNING: " format , ## __VA_ARGS__ )
-#define notice( label, format, ... )					\
-	DCALL( KERN_NOTICE, 						\
-	       printk, 1, label, "NOTICE: " format , ## __VA_ARGS__ )
+#define warning(label, format, ...)					\
+	DCALL(KERN_WARNING, 						\
+	       printk, 1, label, "WARNING: " format , ## __VA_ARGS__)
+#define notice(label, format, ...)					\
+	DCALL(KERN_NOTICE, 						\
+	       printk, 1, label, "NOTICE: " format , ## __VA_ARGS__)
 
 /* mark not yet implemented functionality */
-#define not_yet( label, format, ... )				\
-	reiser4_panic( label, "NOT YET IMPLEMENTED: " format , ## __VA_ARGS__ )
+#define not_yet(label, format, ...)				\
+	reiser4_panic(label, "NOT YET IMPLEMENTED: " format , ## __VA_ARGS__)
 
 extern void reiser4_do_panic(const char *format, ...)
     __attribute__ ((noreturn, format(printf, 1, 2)));
diff -puN fs/reiser4/dformat.h~reiser4-code-cleanups fs/reiser4/dformat.h
--- a/fs/reiser4/dformat.h~reiser4-code-cleanups
+++ a/fs/reiser4/dformat.h
@@ -1,4 +1,5 @@
-/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
+/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
+   reiser4/README */
 
 /* Formats of on-disk data and conversion functions. */
 
@@ -10,7 +11,7 @@
    To declare fields of on-disk structures, use d8, d16, d32 and d64.
    d??tocpu() and cputod??() to convert. */
 
-#if !defined( __FS_REISER4_DFORMAT_H__ )
+#if !defined(__FS_REISER4_DFORMAT_H__)
 #define __FS_REISER4_DFORMAT_H__
 
 #include <asm/byteorder.h>
@@ -37,7 +38,7 @@ typedef __le64 reiser4_dblock_nr;
  *
  * Returns true if if disk addresses are the same
  */
-static inline int disk_addr_eq(const reiser4_block_nr *b1,
+static inline int disk_addr_eq(const reiser4_block_nr * b1,
 			       const reiser4_block_nr * b2)
 {
 	assert("nikita-1033", b1 != NULL);
diff -puN fs/reiser4/dscale.c~reiser4-code-cleanups fs/reiser4/dscale.c
--- a/fs/reiser4/dscale.c~reiser4-code-cleanups
+++ a/fs/reiser4/dscale.c
@@ -49,7 +49,7 @@ static int gettag(const unsigned char *a
 }
 
 /* clear tag from value. Clear tag embedded into @value. */
-static void cleartag(__u64 * value, int tag)
+static void cleartag(__u64 *value, int tag)
 {
 	/*
 	 * W-w-what ?!
@@ -94,7 +94,7 @@ static int dscale_range(__u64 value)
 
 /* restore value stored at @adderss by dscale_write() and return number of
  * bytes consumed */
-int dscale_read(unsigned char *address, __u64 * value)
+int dscale_read(unsigned char *address, __u64 *value)
 {
 	int tag;
 
diff -puN fs/reiser4/dscale.h~reiser4-code-cleanups fs/reiser4/dscale.h
--- a/fs/reiser4/dscale.h~reiser4-code-cleanups
+++ a/fs/reiser4/dscale.h
@@ -3,12 +3,12 @@
 
 /* Scalable on-disk integers. See dscale.h for details. */
 
-#if !defined( __FS_REISER4_DSCALE_H__ )
+#if !defined(__FS_REISER4_DSCALE_H__)
 #define __FS_REISER4_DSCALE_H__
 
 #include "dformat.h"
 
-extern int dscale_read(unsigned char *address, __u64 * value);
+extern int dscale_read(unsigned char *address, __u64 *value);
 extern int dscale_write(unsigned char *address, __u64 value);
 extern int dscale_bytes_to_read(unsigned char *address);
 extern int dscale_bytes_to_write(__u64 value);
diff -puN fs/reiser4/entd.c~reiser4-code-cleanups fs/reiser4/entd.c
--- a/fs/reiser4/entd.c~reiser4-code-cleanups
+++ a/fs/reiser4/entd.c
@@ -35,7 +35,7 @@ static int entd(void *arg);
  */
 #define entd_set_comm(state)					\
 	snprintf(current->comm, sizeof(current->comm),	\
-	         "ent:%s%s", super->s_id, (state))
+		"ent:%s%s", super->s_id, (state))
 
 /**
  * reiser4_init_entd - initialize entd context and start kernel daemon
@@ -82,7 +82,7 @@ static struct wbq *__get_wbq(entd_contex
 	if (list_empty(&ent->todo_list))
 		return NULL;
 
-	ent->nr_todo_reqs --;
+	ent->nr_todo_reqs--;
 	wbq = list_entry(ent->todo_list.next, struct wbq, link);
 	list_del_init(&wbq->link);
 	return wbq;
@@ -131,7 +131,7 @@ static int entd(void *arg)
 			while (!list_empty(&ent->done_list)) {
 				rq = list_entry(ent->done_list.next, struct wbq, link);
 				list_del_init(&rq->link);
-				ent->nr_done_reqs --;
+				ent->nr_done_reqs--;
 				spin_unlock(&ent->guard);
 				assert("", rq->written == 1);
 				put_wbq(rq);
diff -puN fs/reiser4/eottl.c~reiser4-code-cleanups fs/reiser4/eottl.c
--- a/fs/reiser4/eottl.c~reiser4-code-cleanups
+++ a/fs/reiser4/eottl.c
@@ -1,4 +1,5 @@
-/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
+/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
+   reiser4/README */
 
 #include "forward.h"
 #include "debug.h"
@@ -118,8 +119,8 @@
  * is returned if search restart has to be done.
  */
 static int
-is_next_item_internal(coord_t *coord, const reiser4_key *key,
-		      lock_handle *lh)
+is_next_item_internal(coord_t *coord, const reiser4_key * key,
+		      lock_handle * lh)
 {
 	coord_t next;
 	lock_handle rn;
@@ -377,8 +378,8 @@ add_empty_leaf(coord_t *insert_coord, lo
  *
  * Handles search on twig level. If this function completes search itself then
  * it returns 1. If search has to go one level down then 0 is returned. If
- * error happens then LOOKUP_DONE is returned via @outcome and error code is saved
- * in @h->result.
+ * error happens then LOOKUP_DONE is returned via @outcome and error code is
+ * saved in @h->result.
  */
 int handle_eottl(cbk_handle *h, int *outcome)
 {
@@ -399,7 +400,7 @@ int handle_eottl(cbk_handle *h, int *out
 	 * set to extent item or after extent item
 	 */
 	assert("vs-356", h->level == TWIG_LEVEL);
-	assert("vs-357", ( {
+	assert("vs-357", ({
 			  coord_t lcoord;
 			  coord_dup(&lcoord, coord);
 			  check_me("vs-733", coord_set_to_left(&lcoord) == 0);
diff -puN fs/reiser4/estimate.c~reiser4-code-cleanups fs/reiser4/estimate.c
--- a/fs/reiser4/estimate.c~reiser4-code-cleanups
+++ a/fs/reiser4/estimate.c
@@ -1,4 +1,5 @@
-/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
+/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
+   reiser4/README */
 
 #include "debug.h"
 #include "dformat.h"
@@ -8,14 +9,18 @@
 #include "plugin/cluster.h"
 #include "plugin/item/ctail.h"
 
-/* this returns how many nodes might get dirty and added nodes if @children nodes are dirtied
+/* This returns how many nodes might get dirty and added nodes if @children
+   nodes are dirtied
 
-   Amount of internals which will get dirty or get allocated we estimate as 5% of the childs + 1 balancing. 1 balancing
-   is 2 neighbours, 2 new blocks and the current block on the leaf level, 2 neighbour nodes + the current (or 1
-   neighbour and 1 new and the current) on twig level, 2 neighbour nodes on upper levels and 1 for a new root. So 5 for
-   leaf level, 3 for twig level, 2 on upper + 1 for root.
+   Amount of internals which will get dirty or get allocated we estimate as 5%
+   of the childs + 1 balancing. 1 balancing is 2 neighbours, 2 new blocks and
+   the current block on the leaf level, 2 neighbour nodes + the current (or 1
+   neighbour and 1 new and the current) on twig level, 2 neighbour nodes on
+   upper levels and 1 for a new root. So 5 for leaf level, 3 for twig level,
+   2 on upper + 1 for root.
 
-   Do not calculate the current node of the lowest level here - this is overhead only.
+   Do not calculate the current node of the lowest level here - this is overhead
+   only.
 
    children is almost always 1 here. Exception is flow insertion
 */
@@ -26,13 +31,15 @@ max_balance_overhead(reiser4_block_nr ch
 
 	ten_percent = ((103 * childen) >> 10);
 
-	/* If we have too many balancings at the time, tree height can raise on more
-	   then 1. Assume that if tree_height is 5, it can raise on 1 only. */
+	/* If we have too many balancings at the time, tree height can raise on
+	   more then 1. Assume that if tree_height is 5, it can raise on 1 only.
+	*/
 	return ((tree_height < 5 ? 5 : tree_height) * 2 + (4 + ten_percent));
 }
 
-/* this returns maximal possible number of nodes which can be modified plus number of new nodes which can be required to
-   perform insertion of one item into the tree */
+/* this returns maximal possible number of nodes which can be modified plus
+   number of new nodes which can be required to perform insertion of one item
+   into the tree */
 /* it is only called when tree height changes, or gets initialized */
 reiser4_block_nr calc_estimate_one_insert(tree_level height)
 {
@@ -44,8 +51,9 @@ reiser4_block_nr estimate_one_insert_ite
 	return tree->estimate_one_insert;
 }
 
-/* this returns maximal possible number of nodes which can be modified plus number of new nodes which can be required to
-   perform insertion of one unit into an item in the tree */
+/* this returns maximal possible number of nodes which can be modified plus
+   number of new nodes which can be required to perform insertion of one unit
+   into an item in the tree */
 reiser4_block_nr estimate_one_insert_into_item(reiser4_tree * tree)
 {
 	/* estimate insert into item just like item insertion */
@@ -54,14 +62,15 @@ reiser4_block_nr estimate_one_insert_int
 
 reiser4_block_nr estimate_one_item_removal(reiser4_tree * tree)
 {
-	/* on item removal reiser4 does not try to pack nodes more complact, so, only one node may be dirtied on leaf
-	   level */
+	/* on item removal reiser4 does not try to pack nodes more complact, so,
+	   only one node may be dirtied on leaf level */
 	return tree->estimate_one_insert;
 }
 
-/* on leaf level insert_flow may add CARRY_FLOW_NEW_NODES_LIMIT new nodes and dirty 3 existing nodes (insert point and
-   both its neighbors). Max_balance_overhead should estimate number of blocks which may change/get added on internal
-   levels */
+/* on leaf level insert_flow may add CARRY_FLOW_NEW_NODES_LIMIT new nodes and
+   dirty 3 existing nodes (insert point and both its neighbors).
+   Max_balance_overhead should estimate number of blocks which may change/get
+   added on internal levels */
 reiser4_block_nr estimate_insert_flow(tree_level height)
 {
 	return 3 + CARRY_FLOW_NEW_NODES_LIMIT + max_balance_overhead(3 +
@@ -70,7 +79,7 @@ reiser4_block_nr estimate_insert_flow(tr
 }
 
 /* returnes max number of nodes can be occupied by disk cluster */
-static reiser4_block_nr estimate_cluster(struct inode * inode, int unprepped)
+static reiser4_block_nr estimate_cluster(struct inode *inode, int unprepped)
 {
 	int per_cluster;
 	per_cluster = (unprepped ? 1 : cluster_nrpages(inode));
@@ -81,14 +90,14 @@ static reiser4_block_nr estimate_cluster
 
 /* how many nodes might get dirty and added
    during insertion of a disk cluster */
-reiser4_block_nr estimate_insert_cluster(struct inode * inode)
+reiser4_block_nr estimate_insert_cluster(struct inode *inode)
 {
 	return estimate_cluster(inode, 1); /* 24 */
 }
 
 /* how many nodes might get dirty and added
    during update of a (prepped or unprepped) disk cluster */
-reiser4_block_nr estimate_update_cluster(struct inode * inode)
+reiser4_block_nr estimate_update_cluster(struct inode *inode)
 {
 	return estimate_cluster(inode, 0); /* 44, for 64K-cluster */
 }
@@ -98,12 +107,12 @@ reiser4_block_nr estimate_update_cluster
    can occupy more nodes).
    Q: Why we don't use precise estimation?
    A: 1.Because precise estimation is fairly bad: 65536 nodes
-        for 64K logical cluster, it means 256M of dead space on
+	for 64K logical cluster, it means 256M of dead space on
 	a partition
       2.It is a very rare case when disk cluster occupies more
-        nodes then this estimation returns.
+	nodes then this estimation returns.
 */
-reiser4_block_nr estimate_dirty_cluster(struct inode * inode)
+reiser4_block_nr estimate_dirty_cluster(struct inode *inode)
 {
 	return cluster_nrpages(inode) + 4;
 }
diff -puN fs/reiser4/flush.c~reiser4-code-cleanups fs/reiser4/flush.c
--- a/fs/reiser4/flush.c~reiser4-code-cleanups
+++ a/fs/reiser4/flush.c
@@ -1,4 +1,5 @@
-/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
+/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
+   reiser4/README */
 
 /* The design document for this file is at http://www.namesys.com/v4/v4.html. */
 
@@ -36,336 +37,362 @@
 
 /* IMPLEMENTATION NOTES */
 
-/* PARENT-FIRST: Some terminology: A parent-first traversal is a way of assigning a total
-   order to the nodes of the tree in which the parent is placed before its children, which
-   are ordered (recursively) in left-to-right order.  When we speak of a "parent-first preceder", it
-   describes the node that "came before in forward parent-first order".  When we speak of a
-   "parent-first follower", it describes the node that "comes next in parent-first
-   order" (alternatively the node that "came before in reverse parent-first order").
+/* PARENT-FIRST: Some terminology: A parent-first traversal is a way of
+   assigning a total order to the nodes of the tree in which the parent is
+   placed before its children, which are ordered (recursively) in left-to-right
+   order. When we speak of a "parent-first preceder", it describes the node that
+   "came before in forward parent-first order". When we speak of a "parent-first
+   follower", it describes the node that "comes next in parent-first order"
+   (alternatively the node that "came before in reverse parent-first order").
 
-   The following pseudo-code prints the nodes of a tree in forward parent-first order:
+   The following pseudo-code prints the nodes of a tree in forward parent-first
+   order:
 
    void parent_first (node)
    {
      print_node (node);
      if (node->level > leaf) {
        for (i = 0; i < num_children; i += 1) {
-         parent_first (node->child[i]);
+	 parent_first (node->child[i]);
        }
      }
    }
 */
 
-/* JUST WHAT ARE WE TRYING TO OPTIMIZE, HERE?  The idea is to optimize block allocation so
-   that a left-to-right scan of the tree's data (i.e., the leaves in left-to-right order)
-   can be accomplished with sequential reads, which results in reading nodes in their
-   parent-first order.  This is a read-optimization aspect of the flush algorithm, and
-   there is also a write-optimization aspect, which is that we wish to make large
-   sequential writes to the disk by allocating or reallocating blocks so that they can be
-   written in sequence.  Sometimes the read-optimization and write-optimization goals
-   conflict with each other, as we discuss in more detail below.
+/* JUST WHAT ARE WE TRYING TO OPTIMIZE, HERE?  The idea is to optimize block
+   allocation so that a left-to-right scan of the tree's data (i.e., the leaves
+   in left-to-right order) can be accomplished with sequential reads, which
+   results in reading nodes in their parent-first order. This is a
+   read-optimization aspect of the flush algorithm, and there is also a
+   write-optimization aspect, which is that we wish to make large sequential
+   writes to the disk by allocating or reallocating blocks so that they can be
+   written in sequence. Sometimes the read-optimization and write-optimization
+   goals conflict with each other, as we discuss in more detail below.
 */
 
-/* STATE BITS: The flush code revolves around the state of the jnodes it covers.  Here are
-   the relevant jnode->state bits and their relevence to flush:
+/* STATE BITS: The flush code revolves around the state of the jnodes it covers.
+   Here are the relevant jnode->state bits and their relevence to flush:
 
-     JNODE_DIRTY: If a node is dirty, it must be flushed.  But in order to be written it
-     must be allocated first.  In order to be considered allocated, the jnode must have
-     exactly one of { JNODE_OVRWR, JNODE_RELOC } set.  These two bits are exclusive, and
-     all dirtied jnodes eventually have one of these bits set during each transaction.
-
-     JNODE_CREATED: The node was freshly created in its transaction and has no previous
-     block address, so it is unconditionally assigned to be relocated, although this is
-     mainly for code-convenience.  It is not being 'relocated' from anything, but in
-     almost every regard it is treated as part of the relocate set.  The JNODE_CREATED bit
-     remains set even after JNODE_RELOC is set, so the actual relocate can be
-     distinguished from the created-and-allocated set easily: relocate-set members
-     (belonging to the preserve-set) have (JNODE_RELOC) set and created-set members which
-     have no previous location to preserve have (JNODE_RELOC | JNODE_CREATED) set.
-
-     JNODE_OVRWR: The node belongs to atom's overwrite set. The flush algorithm made the
-     decision to maintain the pre-existing location for this node and it will be written
-     to the wandered-log.
-
-     JNODE_RELOC: The flush algorithm made the decision to relocate this block (if it was
-     not created, see note above).  A block with JNODE_RELOC set is eligible for
-     early-flushing and may be submitted during flush_empty_queues.  When the JNODE_RELOC
-     bit is set on a znode, the parent node's internal item is modified and the znode is
-     rehashed.
-
-     JNODE_SQUEEZABLE: Before shifting everything left, the flush algorithm scans the node
-     and calls plugin->f.squeeze() method for its items. By this technology we update disk
-     clusters of cryptcompress objects. Also if leftmost point that was found by flush scan
-     has this flag (races with write(), rare case) the flush algorythm makes the decision
-     to pass it to squalloc() in spite of its flushprepped status for squeezing, not for
+     JNODE_DIRTY: If a node is dirty, it must be flushed. But in order to be
+     written it must be allocated first. In order to be considered allocated,
+     the jnode must have exactly one of { JNODE_OVRWR, JNODE_RELOC } set. These
+     two bits are exclusive, and all dirtied jnodes eventually have one of these
+     bits set during each transaction.
+
+     JNODE_CREATED: The node was freshly created in its transaction and has no
+     previous block address, so it is unconditionally assigned to be relocated,
+     although this is mainly for code-convenience. It is not being 'relocated'
+     from anything, but in almost every regard it is treated as part of the
+     relocate set. The JNODE_CREATED bit remains set even after JNODE_RELOC is
+     set, so the actual relocate can be distinguished from the
+     created-and-allocated set easily: relocate-set members (belonging to the
+     preserve-set) have (JNODE_RELOC) set and created-set members which have no
+     previous location to preserve have (JNODE_RELOC | JNODE_CREATED) set.
+
+     JNODE_OVRWR: The node belongs to atom's overwrite set. The flush algorithm
+     made the decision to maintain the pre-existing location for this node and
+     it will be written to the wandered-log.
+
+     JNODE_RELOC: The flush algorithm made the decision to relocate this block
+     (if it was not created, see note above). A block with JNODE_RELOC set is
+     eligible for early-flushing and may be submitted during flush_empty_queues.
+     When the JNODE_RELOC bit is set on a znode, the parent node's internal item
+     is modified and the znode is rehashed.
+
+     JNODE_SQUEEZABLE: Before shifting everything left, the flush algorithm
+     scans the node and calls plugin->f.squeeze() method for its items. By this
+     technology we update disk clusters of cryptcompress objects. Also if
+     leftmost point that was found by flush scan has this flag (races with
+     write(), rare case) the flush algorythm makes the decision to pass it to
+     squalloc() in spite of its flushprepped status for squeezing, not for
      repeated allocation.
 
-     JNODE_FLUSH_QUEUED: This bit is set when a call to flush enters the jnode into its
-     flush queue.  This means the jnode is not on any clean or dirty list, instead it is
-     moved to one of the flush queue (see flush_queue.h) object private list. This
-     prevents multiple concurrent flushes from attempting to start flushing from the
-     same node.
+     JNODE_FLUSH_QUEUED: This bit is set when a call to flush enters the jnode
+     into its flush queue. This means the jnode is not on any clean or dirty
+     list, instead it is moved to one of the flush queue (see flush_queue.h)
+     object private list. This prevents multiple concurrent flushes from
+     attempting to start flushing from the same node.
 
      (DEAD STATE BIT) JNODE_FLUSH_BUSY: This bit was set during the bottom-up
-     squeeze-and-allocate on a node while its children are actively being squeezed and
-     allocated.  This flag was created to avoid submitting a write request for a node
-     while its children are still being allocated and squeezed. Then flush queue was
-     re-implemented to allow unlimited number of nodes be queued. This flag support was
-     commented out in source code because we decided that there was no reason to submit
-     queued nodes before jnode_flush() finishes.  However, current code calls fq_write()
-     during a slum traversal and may submit "busy nodes" to disk. Probably we can
+     squeeze-and-allocate on a node while its children are actively being
+     squeezed and allocated. This flag was created to avoid submitting a write
+     request for a node while its children are still being allocated and
+     squeezed. Then flush queue was re-implemented to allow unlimited number of
+     nodes be queued. This flag support was commented out in source code because
+     we decided that there was no reason to submit queued nodes before
+     jnode_flush() finishes.  However, current code calls fq_write() during a
+     slum traversal and may submit "busy nodes" to disk. Probably we can
      re-enable the JNODE_FLUSH_BUSY bit support in future.
 
    With these state bits, we describe a test used frequently in the code below,
-   jnode_is_flushprepped() (and the spin-lock-taking jnode_check_flushprepped()).  The
-   test for "flushprepped" returns true if any of the following are true:
+   jnode_is_flushprepped()(and the spin-lock-taking jnode_check_flushprepped()).
+   The test for "flushprepped" returns true if any of the following are true:
 
      - The node is not dirty
      - The node has JNODE_RELOC set
      - The node has JNODE_OVRWR set
 
-   If either the node is not dirty or it has already been processed by flush (and assigned
-   JNODE_OVRWR or JNODE_RELOC), then it is prepped.  If jnode_is_flushprepped() returns
-   true then flush has work to do on that node.
+   If either the node is not dirty or it has already been processed by flush
+   (and assigned JNODE_OVRWR or JNODE_RELOC), then it is prepped. If
+   jnode_is_flushprepped() returns true then flush has work to do on that node.
 */
 
 /* FLUSH_PREP_ONCE_PER_TRANSACTION: Within a single transaction a node is never
-   flushprepped twice (unless an explicit call to flush_unprep is made as described in
-   detail below).  For example a node is dirtied, allocated, and then early-flushed to
-   disk and set clean.  Before the transaction commits, the page is dirtied again and, due
-   to memory pressure, the node is flushed again.  The flush algorithm will not relocate
-   the node to a new disk location, it will simply write it to the same, previously
-   relocated position again.
+   flushprepped twice (unless an explicit call to flush_unprep is made as
+   described in detail below). For example a node is dirtied, allocated, and
+   then early-flushed to disk and set clean. Before the transaction commits, the
+   page is dirtied again and, due to memory pressure, the node is flushed again.
+   The flush algorithm will not relocate the node to a new disk location, it
+   will simply write it to the same, previously relocated position again.
 */
 
-/* THE BOTTOM-UP VS. TOP-DOWN ISSUE: This code implements a bottom-up algorithm where we
-   start at a leaf node and allocate in parent-first order by iterating to the right.  At
-   each step of the iteration, we check for the right neighbor.  Before advancing to the
-   right neighbor, we check if the current position and the right neighbor share the same
-   parent.  If they do not share the same parent, the parent is allocated before the right
-   neighbor.
-
-   This process goes recursively up the tree and squeeze nodes level by level as long as
-   the right neighbor and the current position have different parents, then it allocates
-   the right-neighbors-with-different-parents on the way back down.  This process is
-   described in more detail in flush_squalloc_changed_ancestor and the recursive function
-   squalloc_one_changed_ancestor.  But the purpose here is not to discuss the
-   specifics of the bottom-up approach as it is to contrast the bottom-up and top-down
-   approaches.
-
-   The top-down algorithm was implemented earlier (April-May 2002).  In the top-down
-   approach, we find a starting point by scanning left along each level past dirty nodes,
-   then going up and repeating the process until the left node and the parent node are
-   clean.  We then perform a parent-first traversal from the starting point, which makes
-   allocating in parent-first order trivial.  After one subtree has been allocated in this
-   manner, we move to the right, try moving upward, then repeat the parent-first
-   traversal.
-
-   Both approaches have problems that need to be addressed.  Both are approximately the
-   same amount of code, but the bottom-up approach has advantages in the order it acquires
-   locks which, at the very least, make it the better approach.  At first glance each one
-   makes the other one look simpler, so it is important to remember a few of the problems
-   with each one.
-
-   Main problem with the top-down approach: When you encounter a clean child during the
-   parent-first traversal, what do you do?  You would like to avoid searching through a
-   large tree of nodes just to find a few dirty leaves at the bottom, and there is not an
-   obvious solution.  One of the advantages of the top-down approach is that during the
-   parent-first traversal you check every child of a parent to see if it is dirty.  In
-   this way, the top-down approach easily handles the main problem of the bottom-up
-   approach: unallocated children.
-
-   The unallocated children problem is that before writing a node to disk we must make
-   sure that all of its children are allocated.  Otherwise, the writing the node means
-   extra I/O because the node will have to be written again when the child is finally
-   allocated.
-
-   WE HAVE NOT YET ELIMINATED THE UNALLOCATED CHILDREN PROBLEM.  Except for bugs, this
-   should not cause any file system corruption, it only degrades I/O performance because a
-   node may be written when it is sure to be written at least one more time in the same
-   transaction when the remaining children are allocated.  What follows is a description
-   of how we will solve the problem.
+/* THE BOTTOM-UP VS. TOP-DOWN ISSUE: This code implements a bottom-up algorithm
+   where we start at a leaf node and allocate in parent-first order by iterating
+   to the right. At each step of the iteration, we check for the right neighbor.
+   Before advancing to the right neighbor, we check if the current position and
+   the right neighbor share the same parent. If they do not share the same
+   parent, the parent is allocated before the right neighbor.
+
+   This process goes recursively up the tree and squeeze nodes level by level as
+   long as the right neighbor and the current position have different parents,
+   then it allocates the right-neighbors-with-different-parents on the way back
+   down. This process is described in more detail in
+   flush_squalloc_changed_ancestor and the recursive function
+   squalloc_one_changed_ancestor. But the purpose here is not to discuss the
+   specifics of the bottom-up approach as it is to contrast the bottom-up and
+   top-down approaches.
+
+   The top-down algorithm was implemented earlier (April-May 2002). In the
+   top-down approach, we find a starting point by scanning left along each level
+   past dirty nodes, then going up and repeating the process until the left node
+   and the parent node are clean. We then perform a parent-first traversal from
+   the starting point, which makes allocating in parent-first order trivial.
+   After one subtree has been allocated in this manner, we move to the right,
+   try moving upward, then repeat the parent-first traversal.
+
+   Both approaches have problems that need to be addressed. Both are
+   approximately the same amount of code, but the bottom-up approach has
+   advantages in the order it acquires locks which, at the very least, make it
+   the better approach. At first glance each one makes the other one look
+   simpler, so it is important to remember a few of the problems with each one.
+
+   Main problem with the top-down approach: When you encounter a clean child
+   during the parent-first traversal, what do you do? You would like to avoid
+   searching through a large tree of nodes just to find a few dirty leaves at
+   the bottom, and there is not an obvious solution. One of the advantages of
+   the top-down approach is that during the parent-first traversal you check
+   every child of a parent to see if it is dirty. In this way, the top-down
+   approach easily handles the main problem of the bottom-up approach:
+   unallocated children.
+
+   The unallocated children problem is that before writing a node to disk we
+   must make sure that all of its children are allocated. Otherwise, the writing
+   the node means extra I/O because the node will have to be written again when
+   the child is finally allocated.
+
+   WE HAVE NOT YET ELIMINATED THE UNALLOCATED CHILDREN PROBLEM. Except for bugs,
+   this should not cause any file system corruption, it only degrades I/O
+   performance because a node may be written when it is sure to be written at
+   least one more time in the same transaction when the remaining children are
+   allocated. What follows is a description of how we will solve the problem.
 */
 
-/* HANDLING UNALLOCATED CHILDREN: During flush we may allocate a parent node then,
-   proceeding in parent first order, allocate some of its left-children, then encounter a
-   clean child in the middle of the parent.  We do not allocate the clean child, but there
-   may remain unallocated (dirty) children to the right of the clean child.  If we were to
-   stop flushing at this moment and write everything to disk, the parent might still
-   contain unallocated children.
-
-   We could try to allocate all the descendents of every node that we allocate, but this
-   is not necessary.  Doing so could result in allocating the entire tree: if the root
-   node is allocated then every unallocated node would have to be allocated before
-   flushing.  Actually, we do not have to write a node just because we allocate it.  It is
-   possible to allocate but not write a node during flush, when it still has unallocated
-   children.  However, this approach is probably not optimal for the following reason.
-
-   The flush algorithm is designed to allocate nodes in parent-first order in an attempt
-   to optimize reads that occur in the same order.  Thus we are read-optimizing for a
-   left-to-right scan through all the leaves in the system, and we are hoping to
-   write-optimize at the same time because those nodes will be written together in batch.
-   What happens, however, if we assign a block number to a node in its read-optimized
-   order but then avoid writing it because it has unallocated children?  In that
-   situation, we lose out on the write-optimization aspect because a node will have to be
-   written again to the its location on the device, later, which likely means seeking back
-   to that location.
+/* HANDLING UNALLOCATED CHILDREN: During flush we may allocate a parent node,
+   then proceeding in parent first order, allocate some of its left-children,
+   then encounter a clean child in the middle of the parent. We do not allocate
+   the clean child, but there may remain unallocated (dirty) children to the
+   right of the clean child. If we were to stop flushing at this moment and
+   write everything to disk, the parent might still contain unallocated
+   children.
+
+   We could try to allocate all the descendents of every node that we allocate,
+   but this is not necessary. Doing so could result in allocating the entire
+   tree: if the root node is allocated then every unallocated node would have to
+   be allocated before flushing. Actually, we do not have to write a node just
+   because we allocate it. It is possible to allocate but not write a node
+   during flush, when it still has unallocated children. However, this approach
+   is probably not optimal for the following reason.
+
+   The flush algorithm is designed to allocate nodes in parent-first order in an
+   attempt to optimize reads that occur in the same order. Thus we are
+   read-optimizing for a left-to-right scan through all the leaves in the
+   system, and we are hoping to write-optimize at the same time because those
+   nodes will be written together in batch. What happens, however, if we assign
+   a block number to a node in its read-optimized order but then avoid writing
+   it because it has unallocated children? In that situation, we lose out on the
+   write-optimization aspect because a node will have to be written again to the
+   its location on the device, later, which likely means seeking back to that
+   location.
 
    So there are tradeoffs. We can choose either:
 
    A. Allocate all unallocated children to preserve both write-optimization and
-   read-optimization, but this is not always desirable because it may mean having to
-   allocate and flush very many nodes at once.
+   read-optimization, but this is not always desirable because it may mean
+   having to allocate and flush very many nodes at once.
 
-   B. Defer writing nodes with unallocated children, keep their read-optimized locations,
-   but sacrifice write-optimization because those nodes will be written again.
-
-   C. Defer writing nodes with unallocated children, but do not keep their read-optimized
-   locations.  Instead, choose to write-optimize them later, when they are written.  To
-   facilitate this, we "undo" the read-optimized allocation that was given to the node so
-   that later it can be write-optimized, thus "unpreparing" the flush decision.  This is a
-   case where we disturb the FLUSH_PREP_ONCE_PER_TRANSACTION rule described above.  By a
-   call to flush_unprep() we will: if the node was wandered, unset the JNODE_OVRWR bit;
-   if the node was relocated, unset the JNODE_RELOC bit, non-deferred-deallocate its block
-   location, and set the JNODE_CREATED bit, effectively setting the node back to an
-   unallocated state.
-
-   We will take the following approach in v4.0: for twig nodes we will always finish
-   allocating unallocated children (A).  For nodes with (level > TWIG) we will defer
-   writing and choose write-optimization (C).
-
-   To summarize, there are several parts to a solution that avoids the problem with
-   unallocated children:
-
-   FIXME-ZAM: Still no one approach is implemented to eliminate the "UNALLOCATED CHILDREN"
-   problem because there was an experiment which was done showed that we have 1-2 nodes
-   with unallocated children for thousands of written nodes.  The experiment was simple
-   like coping / deletion of linux kernel sources.  However the problem can arise in more
-   complex tests.  I think we have jnode_io_hook to insert a check for unallocated
-   children and see what kind of problem we have.
-
-   1. When flush reaches a stopping point (e.g., a clean node), it should continue calling
-   squeeze-and-allocate on any remaining unallocated children.  FIXME: Difficulty to
-   implement: should be simple -- amounts to adding a while loop to jnode_flush, see
-   comments in that function.
-
-   2. When flush reaches flush_empty_queue(), some of the (level > TWIG) nodes may still
-   have unallocated children.  If the twig level has unallocated children it is an
-   assertion failure.  If a higher-level node has unallocated children, then it should be
-   explicitly de-allocated by a call to flush_unprep().  FIXME: Difficulty to implement:
-   should be simple.
-
-   3. (CPU-Optimization) Checking whether a node has unallocated children may consume more
-   CPU cycles than we would like, and it is possible (but medium complexity) to optimize
-   this somewhat in the case where large sub-trees are flushed.  The following observation
-   helps: if both the left- and right-neighbor of a node are processed by the flush
-   algorithm then the node itself is guaranteed to have all of its children allocated.
-   However, the cost of this check may not be so expensive after all: it is not needed for
-   leaves and flush can guarantee this property for twigs.  That leaves only (level >
-   TWIG) nodes that have to be checked, so this optimization only helps if at least three
-   (level > TWIG) nodes are flushed in one pass, and the savings will be very small unless
-   there are many more (level > TWIG) nodes.  But if there are many (level > TWIG) nodes
-   then the number of blocks being written will be very large, so the savings may be
-   insignificant.  That said, the idea is to maintain both the left and right edges of
-   nodes that are processed in flush.  When flush_empty_queue() is called, a relatively
-   simple test will tell whether the (level > TWIG) node is on the edge.  If it is on the
-   edge, the slow check is necessary, but if it is in the interior then it can be assumed
-   to have all of its children allocated.  FIXME: medium complexity to implement, but
-   simple to verify given that we must have a slow check anyway.
-
-   4. (Optional) This part is optional, not for v4.0--flush should work independently of
-   whether this option is used or not.  Called RAPID_SCAN, the idea is to amend the
-   left-scan operation to take unallocated children into account.  Normally, the left-scan
-   operation goes left as long as adjacent nodes are dirty up until some large maximum
-   value (FLUSH_SCAN_MAXNODES) at which point it stops and begins flushing.  But scan-left
-   may stop at a position where there are unallocated children to the left with the same
-   parent.  When RAPID_SCAN is enabled, the ordinary scan-left operation stops after
-   FLUSH_RELOCATE_THRESHOLD, which is much smaller than FLUSH_SCAN_MAXNODES, then procedes
-   with a rapid scan.  The rapid scan skips all the interior children of a node--if the
-   leftmost child of a twig is dirty, check its left neighbor (the rightmost child of the
-   twig to the left).  If the left neighbor of the leftmost child is also dirty, then
-   continue the scan at the left twig and repeat.  This option will cause flush to
-   allocate more twigs in a single pass, but it also has the potential to write many more
-   nodes than would otherwise be written without the RAPID_SCAN option.  RAPID_SCAN
-   was partially implemented, code removed August 12, 2002 by JMACD.
+   B. Defer writing nodes with unallocated children, keep their read-optimized
+   locations, but sacrifice write-optimization because those nodes will be
+   written again.
+
+   C. Defer writing nodes with unallocated children, but do not keep their
+   read-optimized locations. Instead, choose to write-optimize them later, when
+   they are written. To facilitate this, we "undo" the read-optimized allocation
+   that was given to the node so that later it can be write-optimized, thus
+   "unpreparing" the flush decision. This is a case where we disturb the
+   FLUSH_PREP_ONCE_PER_TRANSACTION rule described above. By a call to
+   flush_unprep() we will: if the node was wandered, unset the JNODE_OVRWR bit;
+   if the node was relocated, unset the JNODE_RELOC bit, non-deferred-deallocate
+   its block location, and set the JNODE_CREATED bit, effectively setting the
+   node back to an unallocated state.
+
+   We will take the following approach in v4.0: for twig nodes we will always
+   finish allocating unallocated children (A).  For nodes with (level > TWIG)
+   we will defer writing and choose write-optimization (C).
+
+   To summarize, there are several parts to a solution that avoids the problem
+   with unallocated children:
+
+   FIXME-ZAM: Still no one approach is implemented to eliminate the
+   "UNALLOCATED CHILDREN" problem because there was an experiment which was done
+   showed that we have 1-2 nodes with unallocated children for thousands of
+   written nodes. The experiment was simple like coping/deletion of linux kernel
+   sources. However the problem can arise in more complex tests. I think we have
+   jnode_io_hook to insert a check for unallocated children and see what kind of
+   problem we have.
+
+   1. When flush reaches a stopping point (e.g. a clean node) it should continue
+   calling squeeze-and-allocate on any remaining unallocated children.
+   FIXME: Difficulty to implement: should be simple -- amounts to adding a while
+   loop to jnode_flush, see comments in that function.
+
+   2. When flush reaches flush_empty_queue(), some of the (level > TWIG) nodes
+   may still have unallocated children. If the twig level has unallocated
+   children it is an assertion failure. If a higher-level node has unallocated
+   children, then it should be explicitly de-allocated by a call to
+   flush_unprep().
+   FIXME: Difficulty to implement: should be simple.
+
+   3. (CPU-Optimization) Checking whether a node has unallocated children may
+   consume more CPU cycles than we would like, and it is possible (but medium
+   complexity) to optimize this somewhat in the case where large sub-trees are
+   flushed. The following observation helps: if both the left- and
+   right-neighbor of a node are processed by the flush algorithm then the node
+   itself is guaranteed to have all of its children allocated. However, the cost
+   of this check may not be so expensive after all: it is not needed for leaves
+   and flush can guarantee this property for twigs. That leaves only (level >
+   TWIG) nodes that have to be checked, so this optimization only helps if at
+   least three (level > TWIG) nodes are flushed in one pass, and the savings
+   will be very small unless there are many more (level > TWIG) nodes. But if
+   there are many (level > TWIG) nodes then the number of blocks being written
+   will be very large, so the savings may be insignificant. That said, the idea
+   is to maintain both the left and right edges of nodes that are processed in
+   flush.  When flush_empty_queue() is called, a relatively simple test will
+   tell whether the (level > TWIG) node is on the edge. If it is on the edge,
+   the slow check is necessary, but if it is in the interior then it can be
+   assumed to have all of its children allocated. FIXME: medium complexity to
+   implement, but simple to verify given that we must have a slow check anyway.
+
+   4. (Optional) This part is optional, not for v4.0--flush should work
+   independently of whether this option is used or not. Called RAPID_SCAN, the
+   idea is to amend the left-scan operation to take unallocated children into
+   account. Normally, the left-scan operation goes left as long as adjacent
+   nodes are dirty up until some large maximum value (FLUSH_SCAN_MAXNODES) at
+   which point it stops and begins flushing. But scan-left may stop at a
+   position where there are unallocated children to the left with the same
+   parent. When RAPID_SCAN is enabled, the ordinary scan-left operation stops
+   after FLUSH_RELOCATE_THRESHOLD, which is much smaller than
+   FLUSH_SCAN_MAXNODES, then procedes with a rapid scan. The rapid scan skips
+   all the interior children of a node--if the leftmost child of a twig is
+   dirty, check its left neighbor (the rightmost child of the twig to the left).
+   If the left neighbor of the leftmost child is also dirty, then continue the
+   scan at the left twig and repeat.  This option will cause flush to allocate
+   more twigs in a single pass, but it also has the potential to write many more
+   nodes than would otherwise be written without the RAPID_SCAN option.
+   RAPID_SCAN was partially implemented, code removed August 12, 2002 by JMACD.
 */
 
-/* FLUSH CALLED ON NON-LEAF LEVEL.  Most of our design considerations assume that the
-   starting point for flush is a leaf node, but actually the flush code cares very little
-   about whether or not this is true.  It is possible that all the leaf nodes are flushed
-   and dirty parent nodes still remain, in which case jnode_flush() is called on a
-   non-leaf argument.  Flush doesn't care--it treats the argument node as if it were a
-   leaf, even when it is not.  This is a simple approach, and there may be a more optimal
-   policy but until a problem with this approach is discovered, simplest is probably best.
-
-   NOTE: In this case, the ordering produced by flush is parent-first only if you ignore
-   the leaves.  This is done as a matter of simplicity and there is only one (shaky)
-   justification.  When an atom commits, it flushes all leaf level nodes first, followed
-   by twigs, and so on.  With flushing done in this order, if flush is eventually called
-   on a non-leaf node it means that (somehow) we reached a point where all leaves are
-   clean and only internal nodes need to be flushed.  If that it the case, then it means
-   there were no leaves that were the parent-first preceder/follower of the parent.  This
-   is expected to be a rare case, which is why we do nothing special about it.  However,
-   memory pressure may pass an internal node to flush when there are still dirty leaf
-   nodes that need to be flushed, which could prove our original assumptions
-   "inoperative".  If this needs to be fixed, then scan_left/right should have
-   special checks for the non-leaf levels.  For example, instead of passing from a node to
-   the left neighbor, it should pass from the node to the left neighbor's rightmost
-   descendent (if dirty).
+/* FLUSH CALLED ON NON-LEAF LEVEL. Most of our design considerations assume that
+   the starting point for flush is a leaf node, but actually the flush code
+   cares very little about whether or not this is true.  It is possible that all
+   the leaf nodes are flushed and dirty parent nodes still remain, in which case
+   jnode_flush() is called on a non-leaf argument. Flush doesn't care--it treats
+   the argument node as if it were a leaf, even when it is not. This is a simple
+   approach, and there may be a more optimal policy but until a problem with
+   this approach is discovered, simplest is probably best.
+
+   NOTE: In this case, the ordering produced by flush is parent-first only if
+   you ignore the leaves. This is done as a matter of simplicity and there is
+   only one (shaky) justification. When an atom commits, it flushes all leaf
+   level nodes first, followed by twigs, and so on. With flushing done in this
+   order, if flush is eventually called on a non-leaf node it means that
+   (somehow) we reached a point where all leaves are clean and only internal
+   nodes need to be flushed. If that it the case, then it means there were no
+   leaves that were the parent-first preceder/follower of the parent. This is
+   expected to be a rare case, which is why we do nothing special about it.
+   However, memory pressure may pass an internal node to flush when there are
+   still dirty leaf nodes that need to be flushed, which could prove our
+   original assumptions "inoperative". If this needs to be fixed, then
+   scan_left/right should have special checks for the non-leaf levels. For
+   example, instead of passing from a node to the left neighbor, it should pass
+   from the node to the left neighbor's rightmost descendent (if dirty).
 
 */
 
-/* UNIMPLEMENTED AS YET: REPACKING AND RESIZING.  We walk the tree in 4MB-16MB chunks, dirtying everything and putting
-   it into a transaction.  We tell the allocator to allocate the blocks as far as possible towards one end of the
-   logical device--the left (starting) end of the device if we are walking from left to right, the right end of the
-   device if we are walking from right to left.  We then make passes in alternating directions, and as we do this the
-   device becomes sorted such that tree order and block number order fully correlate.
+/* UNIMPLEMENTED AS YET: REPACKING AND RESIZING. We walk the tree in 4MB-16MB
+   chunks, dirtying everything and putting it into a transaction. We tell the
+   allocator to allocate the blocks as far as possible towards one end of the
+   logical device--the left (starting) end of the device if we are walking from
+   left to right, the right end of the device if we are walking from right to
+   left.  We then make passes in alternating directions, and as we do this the
+   device becomes sorted such that tree order and block number order fully
+   correlate.
 
-   Resizing is done by shifting everything either all the way to the left or all the way
-   to the right, and then reporting the last block.
+   Resizing is done by shifting everything either all the way to the left or all
+   the way to the right, and then reporting the last block.
 */
 
-/* RELOCATE DECISIONS: The code makes a decision to relocate in several places.  This
-   descibes the policy from the highest level:
+/* RELOCATE DECISIONS: The code makes a decision to relocate in several places.
+   This descibes the policy from the highest level:
 
-   The FLUSH_RELOCATE_THRESHOLD parameter: If we count this many consecutive nodes on the
-   leaf level during flush-scan (right, left), then we unconditionally decide to relocate
-   leaf nodes.
+   The FLUSH_RELOCATE_THRESHOLD parameter: If we count this many consecutive
+   nodes on the leaf level during flush-scan (right, left), then we
+   unconditionally decide to relocate leaf nodes.
 
    Otherwise, there are two contexts in which we make a decision to relocate:
 
    1. The REVERSE PARENT-FIRST context: Implemented in reverse_relocate_test().
-   During the initial stages of flush, after scan-right completes, we want to ask the
-   question: should we relocate this leaf node and thus dirty the parent node.  Then if
-   the node is a leftmost child its parent is its own parent-first preceder, thus we repeat
-   the question at the next level up, and so on.  In these cases we are moving in the
-   reverse-parent first direction.
-
-   There is another case which is considered the reverse direction, which comes at the end
-   of a twig in reverse_relocate_end_of_twig().  As we finish processing a twig we may
-   reach a point where there is a clean twig to the right with a dirty leftmost child.  In
-   this case, we may wish to relocate the child by testing if it should be relocated
-   relative to its parent.
-
-   2. The FORWARD PARENT-FIRST context: Testing for forward relocation is done in
-   allocate_znode.  What distinguishes the forward parent-first case from the
-   reverse-parent first case is that the preceder has already been allocated in the
-   forward case, whereas in the reverse case we don't know what the preceder is until we
-   finish "going in reverse".  That simplifies the forward case considerably, and there we
-   actually use the block allocator to determine whether, e.g., a block closer to the
-   preceder is available.
+   During the initial stages of flush, after scan-right completes, we want to
+   ask the question: should we relocate this leaf node and thus dirty the parent
+   node. Then if the node is a leftmost child its parent is its own parent-first
+   preceder, thus we repeat the question at the next level up, and so on. In
+   these cases we are moving in the reverse-parent first direction.
+
+   There is another case which is considered the reverse direction, which comes
+   at the end of a twig in reverse_relocate_end_of_twig(). As we finish
+   processing a twig we may reach a point where there is a clean twig to the
+   right with a dirty leftmost child. In this case, we may wish to relocate the
+   child by testing if it should be relocated relative to its parent.
+
+   2. The FORWARD PARENT-FIRST context: Testing for forward relocation is done
+   in allocate_znode. What distinguishes the forward parent-first case from the
+   reverse-parent first case is that the preceder has already been allocated in
+   the forward case, whereas in the reverse case we don't know what the preceder
+   is until we finish "going in reverse". That simplifies the forward case
+   considerably, and there we actually use the block allocator to determine
+   whether, e.g., a block closer to the preceder is available.
 */
 
-/* SQUEEZE_LEFT_EDGE: Unimplemented idea for future consideration.  The idea is, once we
-   finish scan-left and find a starting point, if the parent's left neighbor is dirty then
-   squeeze the parent's left neighbor and the parent.  This may change the
-   flush-starting-node's parent.  Repeat until the child's parent is stable.  If the child
-   is a leftmost child, repeat this left-edge squeezing operation at the next level up.
-   Note that we cannot allocate extents during this or they will be out of parent-first
-   order.  There is also some difficult coordinate maintenence issues.  We can't do a tree
-   search to find coordinates again (because we hold locks), we have to determine them
-   from the two nodes being squeezed.  Looks difficult, but has potential to increase
-   space utilization. */
+/* SQUEEZE_LEFT_EDGE: Unimplemented idea for future consideration. The idea is,
+   once we finish scan-left and find a starting point, if the parent's left
+   neighbor is dirty then squeeze the parent's left neighbor and the parent.
+   This may change the flush-starting-node's parent. Repeat until the child's
+   parent is stable. If the child is a leftmost child, repeat this left-edge
+   squeezing operation at the next level up. Note that we cannot allocate
+   extents during this or they will be out of parent-first order. There is also
+   some difficult coordinate maintenence issues.  We can't do a tree search to
+   find coordinates again (because we hold locks), we have to determine them
+   from the two nodes being squeezed. Looks difficult, but has potential to
+   increase space utilization. */
 
 /* Flush-scan helper functions. */
 static void scan_init(flush_scan * scan);
@@ -381,12 +408,13 @@ static int scan_unformatted(flush_scan *
 static int scan_by_coord(flush_scan * scan);
 
 /* Initial flush-point ancestor allocation. */
-static int alloc_pos_and_ancestors(flush_pos_t * pos);
-static int alloc_one_ancestor(const coord_t * coord, flush_pos_t * pos);
-static int set_preceder(const coord_t * coord_in, flush_pos_t * pos);
-
-/* Main flush algorithm.  Note on abbreviation: "squeeze and allocate" == "squalloc". */
-static int squalloc(flush_pos_t * pos);
+static int alloc_pos_and_ancestors(flush_pos_t *pos);
+static int alloc_one_ancestor(const coord_t *coord, flush_pos_t *pos);
+static int set_preceder(const coord_t *coord_in, flush_pos_t *pos);
+
+/* Main flush algorithm.
+   Note on abbreviation: "squeeze and allocate" == "squalloc". */
+static int squalloc(flush_pos_t *pos);
 
 /* Flush squeeze implementation. */
 static int squeeze_right_non_twig(znode * left, znode * right);
@@ -395,27 +423,27 @@ static int shift_one_internal_unit(znode
 /* Flush reverse parent-first relocation routines. */
 static int reverse_relocate_if_close_enough(const reiser4_block_nr * pblk,
 					    const reiser4_block_nr * nblk);
-static int reverse_relocate_test(jnode * node, const coord_t * parent_coord,
-				 flush_pos_t * pos);
+static int reverse_relocate_test(jnode * node, const coord_t *parent_coord,
+				 flush_pos_t *pos);
 static int reverse_relocate_check_dirty_parent(jnode * node,
-					       const coord_t * parent_coord,
-					       flush_pos_t * pos);
+					       const coord_t *parent_coord,
+					       flush_pos_t *pos);
 
 /* Flush allocate write-queueing functions: */
-static int allocate_znode(znode * node, const coord_t * parent_coord,
-			  flush_pos_t * pos);
-static int allocate_znode_update(znode * node, const coord_t * parent_coord,
-				 flush_pos_t * pos);
+static int allocate_znode(znode * node, const coord_t *parent_coord,
+			  flush_pos_t *pos);
+static int allocate_znode_update(znode * node, const coord_t *parent_coord,
+				 flush_pos_t *pos);
 static int lock_parent_and_allocate_znode(znode *, flush_pos_t *);
 
 /* Flush helper functions: */
 static int jnode_lock_parent_coord(jnode * node,
-				   coord_t * coord,
+				   coord_t *coord,
 				   lock_handle * parent_lh,
 				   load_count * parent_zh,
 				   znode_lock_mode mode, int try);
 static int neighbor_in_slum(znode * node, lock_handle * right_lock, sideof side,
-			    znode_lock_mode mode, int check_dirty, int expected);
+			   znode_lock_mode mode, int check_dirty, int expected);
 static int znode_same_parents(znode * a, znode * b);
 
 static int znode_check_flushprepped(znode * node)
@@ -424,24 +452,24 @@ static int znode_check_flushprepped(znod
 }
 
 /* Flush position functions */
-static void pos_init(flush_pos_t * pos);
-static int pos_valid(flush_pos_t * pos);
-static void pos_done(flush_pos_t * pos);
-static int pos_stop(flush_pos_t * pos);
+static void pos_init(flush_pos_t *pos);
+static int pos_valid(flush_pos_t *pos);
+static void pos_done(flush_pos_t *pos);
+static int pos_stop(flush_pos_t *pos);
 
 /* check that @org is first jnode extent unit, if extent is unallocated,
  * because all jnodes of unallocated extent are dirty and of the same atom. */
 #define checkchild(scan)						\
 assert("nikita-3435",							\
        ergo(scan->direction == LEFT_SIDE &&				\
-            (scan->parent_coord.node->level == TWIG_LEVEL) &&           \
+	    (scan->parent_coord.node->level == TWIG_LEVEL) &&           \
 	    jnode_is_unformatted(scan->node) &&				\
 	    extent_is_unallocated(&scan->parent_coord),			\
 	    extent_unit_index(&scan->parent_coord) == index_jnode(scan->node)))
 
-/* This flush_cnt variable is used to track the number of concurrent flush operations,
-   useful for debugging.  It is initialized in txnmgr.c out of laziness (because flush has
-   no static initializer function...) */
+/* This flush_cnt variable is used to track the number of concurrent flush
+   operations, useful for debugging. It is initialized in txnmgr.c out of
+   laziness (because flush has no static initializer function...) */
 ON_DEBUG(atomic_t flush_cnt;
     )
 
@@ -457,7 +485,7 @@ static int check_write_congestion(void)
 }
 
 /* conditionally write flush queue */
-static int write_prepped_nodes(flush_pos_t * pos)
+static int write_prepped_nodes(flush_pos_t *pos)
 {
 	int ret;
 
@@ -477,8 +505,8 @@ static int write_prepped_nodes(flush_pos
 
 /* Proper release all flush pos. resources then move flush position to new
    locked node */
-static void move_flush_pos(flush_pos_t * pos, lock_handle * new_lock,
-			   load_count * new_load, const coord_t * new_coord)
+static void move_flush_pos(flush_pos_t *pos, lock_handle * new_lock,
+			   load_count * new_load, const coord_t *new_coord)
 {
 	assert("zam-857", new_lock->node == new_load->node);
 
@@ -512,7 +540,7 @@ static int delete_empty_node(znode * nod
 }
 
 /* Prepare flush position for alloc_pos_and_ancestors() and squalloc() */
-static int prepare_flush_pos(flush_pos_t * pos, jnode * org)
+static int prepare_flush_pos(flush_pos_t *pos, jnode * org)
 {
 	int ret;
 	load_count load;
@@ -542,8 +570,8 @@ static int prepare_flush_pos(flush_pos_t
 		if (ret)
 			goto done;
 		if (!item_is_extent(&parent_coord)) {
-			/* file was converted to tail, org became HB, we found internal
-			   item */
+			/* file was converted to tail, org became HB, we found
+			   internal item */
 			ret = -EAGAIN;
 			goto done;
 		}
@@ -553,101 +581,112 @@ static int prepare_flush_pos(flush_pos_t
 		pos->child = jref(org);
 		if (extent_is_unallocated(&parent_coord)
 		    && extent_unit_index(&parent_coord) != index_jnode(org)) {
-			/* @org is not first child of its parent unit. This may happen
-			   because longerm lock of its parent node was released between
-			   scan_left and scan_right. For now work around this having flush to repeat */
+			/* @org is not first child of its parent unit. This may
+			   happen because longerm lock of its parent node was
+			   released between scan_left and scan_right. For now
+			   work around this having flush to repeat */
 			ret = -EAGAIN;
 		}
 	}
 
-      done:
+done:
 	done_load_count(&load);
 	done_lh(&lock);
 	return ret;
 }
 
 /* TODO LIST (no particular order): */
-/* I have labelled most of the legitimate FIXME comments in this file with letters to
-   indicate which issue they relate to.  There are a few miscellaneous FIXMEs with
-   specific names mentioned instead that need to be inspected/resolved. */
+/* I have labelled most of the legitimate FIXME comments in this file with
+   letters to indicate which issue they relate to. There are a few miscellaneous
+   FIXMEs with specific names mentioned instead that need to be
+   inspected/resolved. */
 /* B. There is an issue described in reverse_relocate_test having to do with an
-   imprecise is_preceder? check having to do with partially-dirty extents.  The code that
-   sets preceder hints and computes the preceder is basically untested.  Careful testing
-   needs to be done that preceder calculations are done correctly, since if it doesn't
-   affect correctness we will not catch this stuff during regular testing. */
-/* C. EINVAL, E_DEADLOCK, E_NO_NEIGHBOR, ENOENT handling.  It is unclear which of these are
-   considered expected but unlikely conditions.  Flush currently returns 0 (i.e., success
-   but no progress, i.e., restart) whenever it receives any of these in jnode_flush().
-   Many of the calls that may produce one of these return values (i.e.,
-   longterm_lock_znode, reiser4_get_parent, reiser4_get_neighbor, ...) check some of these
-   values themselves and, for instance, stop flushing instead of resulting in a restart.
-   If any of these results are true error conditions then flush will go into a busy-loop,
-   as we noticed during testing when a corrupt tree caused find_child_ptr to return
-   ENOENT.  It needs careful thought and testing of corner conditions.
+   imprecise is_preceder? check having to do with partially-dirty extents. The
+   code that sets preceder hints and computes the preceder is basically
+   untested. Careful testing needs to be done that preceder calculations are
+   done correctly, since if it doesn't affect correctness we will not catch this
+   stuff during regular testing. */
+/* C. EINVAL, E_DEADLOCK, E_NO_NEIGHBOR, ENOENT handling. It is unclear which of
+   these are considered expected but unlikely conditions. Flush currently
+   returns 0 (i.e., success but no progress, i.e., restart) whenever it receives
+   any of these in jnode_flush(). Many of the calls that may produce one of
+   these return values (i.e., longterm_lock_znode, reiser4_get_parent,
+   reiser4_get_neighbor, ...) check some of these values themselves and, for
+   instance, stop flushing instead of resulting in a restart. If any of these
+   results are true error conditions then flush will go into a busy-loop, as we
+   noticed during testing when a corrupt tree caused find_child_ptr to return
+   ENOENT. It needs careful thought and testing of corner conditions.
 */
-/* D. Atomicity of flush_prep against deletion and flush concurrency.  Suppose a created
-   block is assigned a block number then early-flushed to disk.  It is dirtied again and
-   flush is called again.  Concurrently, that block is deleted, and the de-allocation of
-   its block number does not need to be deferred, since it is not part of the preserve set
-   (i.e., it didn't exist before the transaction).  I think there may be a race condition
-   where flush writes the dirty, created block after the non-deferred deallocated block
-   number is re-allocated, making it possible to write deleted data on top of non-deleted
-   data.  Its just a theory, but it needs to be thought out. */
+/* D. Atomicity of flush_prep against deletion and flush concurrency. Suppose a
+   created block is assigned a block number then early-flushed to disk. It is
+   dirtied again and flush is called again. Concurrently, that block is deleted,
+   and the de-allocation of its block number does not need to be deferred, since
+   it is not part of the preserve set (i.e., it didn't exist before the
+   transaction). I think there may be a race condition where flush writes the
+   dirty, created block after the non-deferred deallocated block number is
+   re-allocated, making it possible to write deleted data on top of non-deleted
+   data. Its just a theory, but it needs to be thought out. */
 /* F. bio_alloc() failure is not handled gracefully. */
 /* G. Unallocated children. */
-/* H. Add a WANDERED_LIST to the atom to clarify the placement of wandered blocks. */
+/* H. Add a WANDERED_LIST to the atom to clarify the placement of wandered
+   blocks. */
 /* I. Rename flush-scan to scan-point, (flush-pos to flush-point?) */
 
 /* JNODE_FLUSH: MAIN ENTRY POINT */
-/* This is the main entry point for flushing a jnode and its dirty neighborhood (dirty
-   neighborhood is named "slum").  Jnode_flush() is called if reiser4 has to write dirty
-   blocks to disk, it happens when Linux VM decides to reduce number of dirty pages or as
-   a part of transaction commit.
-
-   Our objective here is to prep and flush the slum the jnode belongs to. We want to
-   squish the slum together, and allocate the nodes in it as we squish because allocation
-   of children affects squishing of parents.
-
-   The "argument" @node tells flush where to start.  From there, flush finds the left edge
-   of the slum, and calls squalloc (in which nodes are squeezed and allocated).  To find a
-   "better place" to start squalloc first we perform a flush_scan.
-
-   Flush-scanning may be performed in both left and right directions, but for different
-   purposes.  When scanning to the left, we are searching for a node that precedes a
-   sequence of parent-first-ordered nodes which we will then flush in parent-first order.
-   During flush-scanning, we also take the opportunity to count the number of consecutive
-   leaf nodes.  If this number is past some threshold (FLUSH_RELOCATE_THRESHOLD), then we
-   make a decision to reallocate leaf nodes (thus favoring write-optimization).
-
-   Since the flush argument node can be anywhere in a sequence of dirty leaves, there may
-   also be dirty nodes to the right of the argument.  If the scan-left operation does not
-   count at least FLUSH_RELOCATE_THRESHOLD nodes then we follow it with a right-scan
-   operation to see whether there is, in fact, enough nodes to meet the relocate
-   threshold.  Each right- and left-scan operation uses a single flush_scan object.
-
-   After left-scan and possibly right-scan, we prepare a flush_position object with the
-   starting flush point or parent coordinate, which was determined using scan-left.
-
-   Next we call the main flush routine, squalloc, which iterates along the
-   leaf level, squeezing and allocating nodes (and placing them into the flush queue).
+/* This is the main entry point for flushing a jnode and its dirty neighborhood
+   (dirty neighborhood is named "slum"). Jnode_flush() is called if reiser4 has
+   to write dirty blocks to disk, it happens when Linux VM decides to reduce
+   number of dirty pages or as a part of transaction commit.
+
+   Our objective here is to prep and flush the slum the jnode belongs to. We
+   want to squish the slum together, and allocate the nodes in it as we squish
+   because allocation of children affects squishing of parents.
+
+   The "argument" @node tells flush where to start. From there, flush finds the
+   left edge of the slum, and calls squalloc (in which nodes are squeezed and
+   allocated). To find a "better place" to start squalloc first we perform a
+   flush_scan.
+
+   Flush-scanning may be performed in both left and right directions, but for
+   different purposes. When scanning to the left, we are searching for a node
+   that precedes a sequence of parent-first-ordered nodes which we will then
+   flush in parent-first order. During flush-scanning, we also take the
+   opportunity to count the number of consecutive leaf nodes. If this number is
+   past some threshold (FLUSH_RELOCATE_THRESHOLD), then we make a decision to
+   reallocate leaf nodes (thus favoring write-optimization).
+
+   Since the flush argument node can be anywhere in a sequence of dirty leaves,
+   there may also be dirty nodes to the right of the argument. If the scan-left
+   operation does not count at least FLUSH_RELOCATE_THRESHOLD nodes then we
+   follow it with a right-scan operation to see whether there is, in fact,
+   enough nodes to meet the relocate threshold. Each right- and left-scan
+   operation uses a single flush_scan object.
+
+   After left-scan and possibly right-scan, we prepare a flush_position object
+   with the starting flush point or parent coordinate, which was determined
+   using scan-left.
+
+   Next we call the main flush routine, squalloc, which iterates along the leaf
+   level, squeezing and allocating nodes (and placing them into the flush
+   queue).
 
    After squalloc returns we take extra steps to ensure that all the children
    of the final twig node are allocated--this involves repeating squalloc
    until we finish at a twig with no unallocated children.
 
-   Finally, we call flush_empty_queue to submit write-requests to disk.  If we encounter
-   any above-twig nodes during flush_empty_queue that still have unallocated children, we
-   flush_unprep them.
-
-   Flush treats several "failure" cases as non-failures, essentially causing them to start
-   over.  E_DEADLOCK is one example.  FIXME:(C) EINVAL, E_NO_NEIGHBOR, ENOENT: these should
-   probably be handled properly rather than restarting, but there are a bunch of cases to
-   audit.
+   Finally, we call flush_empty_queue to submit write-requests to disk. If we
+   encounter any above-twig nodes during flush_empty_queue that still have
+   unallocated children, we flush_unprep them.
+
+   Flush treats several "failure" cases as non-failures, essentially causing
+   them to start over. E_DEADLOCK is one example.
+   FIXME:(C) EINVAL, E_NO_NEIGHBOR, ENOENT: these should probably be handled
+   properly rather than restarting, but there are a bunch of cases to audit.
 */
 
 static int
 jnode_flush(jnode * node, long nr_to_write, long *nr_written,
-	    flush_queue_t * fq, int flags)
+	    flush_queue_t *fq, int flags)
 {
 	long ret = 0;
 	flush_scan *right_scan;
@@ -694,9 +733,9 @@ jnode_flush(jnode * node, long nr_to_wri
 	scan_init(right_scan);
 	scan_init(left_scan);
 
-	/* First scan left and remember the leftmost scan position.  If the leftmost
-	   position is unformatted we remember its parent_coord.  We scan until counting
-	   FLUSH_SCAN_MAXNODES.
+	/* First scan left and remember the leftmost scan position. If the
+	   leftmost position is unformatted we remember its parent_coord. We
+	   scan until counting FLUSH_SCAN_MAXNODES.
 
 	   If starting @node is unformatted, at the beginning of left scan its
 	   parent (twig level node, containing extent item) will be long term
@@ -714,11 +753,12 @@ jnode_flush(jnode * node, long nr_to_wri
 	leftmost_in_slum = jref(left_scan->node);
 	scan_done(left_scan);
 
-	/* Then possibly go right to decide if we will use a policy of relocating leaves.
-	   This is only done if we did not scan past (and count) enough nodes during the
-	   leftward scan.  If we do scan right, we only care to go far enough to establish
-	   that at least FLUSH_RELOCATE_THRESHOLD number of nodes are being flushed.  The
-	   scan limit is the difference between left_scan.count and the threshold. */
+	/* Then possibly go right to decide if we will use a policy of
+	   relocating leaves. This is only done if we did not scan past (and
+	   count) enough nodes during the leftward scan. If we do scan right,
+	   we only care to go far enough to establish that at least
+	   FLUSH_RELOCATE_THRESHOLD number of nodes are being flushed. The scan
+	   limit is the difference between left_scan.count and the threshold. */
 
 	todo = sbinfo->flush.relocate_threshold - left_scan->count;
 	/* scan right is inherently deadlock prone, because we are
@@ -730,7 +770,8 @@ jnode_flush(jnode * node, long nr_to_wri
 			goto failed;
 	}
 
-	/* Only the right-scan count is needed, release any rightward locks right away. */
+	/* Only the right-scan count is needed, release any rightward locks
+	   right away. */
 	scan_done(right_scan);
 
 	/* ... and the answer is: we should relocate leaf nodes if at least
@@ -739,22 +780,25 @@ jnode_flush(jnode * node, long nr_to_wri
 	    (left_scan->count + right_scan->count >=
 	     sbinfo->flush.relocate_threshold);
 
-	/* Funny business here.  We set the 'point' in the flush_position at prior to
-	   starting squalloc regardless of whether the first point is
-	   formatted or unformatted.  Without this there would be an invariant, in the
-	   rest of the code, that if the flush_position is unformatted then
-	   flush_position->point is NULL and flush_position->parent_{lock,coord} is set,
-	   and if the flush_position is formatted then flush_position->point is non-NULL
-	   and no parent info is set.
-
-	   This seems lazy, but it makes the initial calls to reverse_relocate_test
-	   (which ask "is it the pos->point the leftmost child of its parent") much easier
-	   because we know the first child already.  Nothing is broken by this, but the
-	   reasoning is subtle.  Holding an extra reference on a jnode during flush can
-	   cause us to see nodes with HEARD_BANSHEE during squalloc, because nodes are not
-	   removed from sibling lists until they have zero reference count.  Flush would
-	   never observe a HEARD_BANSHEE node on the left-edge of flush, nodes are only
-	   deleted to the right.  So if nothing is broken, why fix it?
+	/* Funny business here.  We set the 'point' in the flush_position at
+	   prior to starting squalloc regardless of whether the first point is
+	   formatted or unformatted. Without this there would be an invariant,
+	   in the rest of the code, that if the flush_position is unformatted
+	   then flush_position->point is NULL and
+	   flush_position->parent_{lock,coord} is set, and if the flush_position
+	   is formatted then flush_position->point is non-NULL and no parent
+	   info is set.
+
+	   This seems lazy, but it makes the initial calls to
+	   reverse_relocate_test (which ask "is it the pos->point the leftmost
+	   child of its parent") much easier because we know the first child
+	   already.  Nothing is broken by this, but the reasoning is subtle.
+	   Holding an extra reference on a jnode during flush can cause us to
+	   see nodes with HEARD_BANSHEE during squalloc, because nodes are not
+	   removed from sibling lists until they have zero reference count.
+	   Flush would never observe a HEARD_BANSHEE node on the left-edge of
+	   flush, nodes are only deleted to the right. So if nothing is broken,
+	   why fix it?
 
 	   NOTE-NIKITA actually, flush can meet HEARD_BANSHEE node at any
 	   point and in any moment, because of the concurrent file system
@@ -789,7 +833,8 @@ jnode_flush(jnode * node, long nr_to_wri
 		goto failed;
 	}
 
-	/* Set pos->preceder and (re)allocate pos and its ancestors if it is needed  */
+	/* Set pos->preceder and (re)allocate pos and its ancestors if it is
+	   needed  */
 	ret = alloc_pos_and_ancestors(flush_pos);
 	if (ret)
 		goto failed;
@@ -800,55 +845,59 @@ jnode_flush(jnode * node, long nr_to_wri
 	if (ret)
 		goto failed;
 
-	/* FIXME_NFQUCMPD: Here, handle the twig-special case for unallocated children.
-	   First, the pos_stop() and pos_valid() routines should be modified
-	   so that pos_stop() sets a flush_position->stop flag to 1 without
-	   releasing the current position immediately--instead release it in
-	   pos_done().  This is a better implementation than the current one anyway.
-
-	   It is not clear that all fields of the flush_position should not be released,
-	   but at the very least the parent_lock, parent_coord, and parent_load should
-	   remain held because they are hold the last twig when pos_stop() is
-	   called.
-
-	   When we reach this point in the code, if the parent_coord is set to after the
-	   last item then we know that flush reached the end of a twig (and according to
-	   the new flush queueing design, we will return now).  If parent_coord is not
-	   past the last item, we should check if the current twig has any unallocated
-	   children to the right (we are not concerned with unallocated children to the
-	   left--in that case the twig itself should not have been allocated).  If the
-	   twig has unallocated children to the right, set the parent_coord to that
+	/* FIXME_NFQUCMPD: Here, handle the twig-special case for unallocated
+	   children. First, the pos_stop() and pos_valid() routines should be
+	   modified so that pos_stop() sets a flush_position->stop flag to 1
+	   without releasing the current position immediately--instead release
+	   it in pos_done(). This is a better implementation than the current
+	   one anyway.
+
+	   It is not clear that all fields of the flush_position should not be
+	   released, but at the very least the parent_lock, parent_coord, and
+	   parent_load should remain held because they are hold the last twig
+	   when pos_stop() is called.
+
+	   When we reach this point in the code, if the parent_coord is set to
+	   after the last item then we know that flush reached the end of a twig
+	   (and according to the new flush queueing design, we will return now).
+	   If parent_coord is not past the last item, we should check if the
+	   current twig has any unallocated children to the right (we are not
+	   concerned with unallocated children to the left--in that case the
+	   twig itself should not have been allocated). If the twig has
+	   unallocated children to the right, set the parent_coord to that
 	   position and then repeat the call to squalloc.
 
-	   Testing for unallocated children may be defined in two ways: if any internal
-	   item has a fake block number, it is unallocated; if any extent item is
-	   unallocated then all of its children are unallocated.  But there is a more
-	   aggressive approach: if there are any dirty children of the twig to the right
-	   of the current position, we may wish to relocate those nodes now.  Checking for
-	   potential relocation is more expensive as it requires knowing whether there are
-	   any dirty children that are not unallocated.  The extent_needs_allocation
-	   should be used after setting the correct preceder.
-
-	   When we reach the end of a twig at this point in the code, if the flush can
-	   continue (when the queue is ready) it will need some information on the future
-	   starting point.  That should be stored away in the flush_handle using a seal, I
-	   believe.  Holding a jref() on the future starting point may break other code
-	   that deletes that node.
+	   Testing for unallocated children may be defined in two ways: if any
+	   internal item has a fake block number, it is unallocated; if any
+	   extent item is unallocated then all of its children are unallocated.
+	   But there is a more aggressive approach: if there are any dirty
+	   children of the twig to the right of the current position, we may
+	   wish to relocate those nodes now. Checking for potential relocation
+	   is more expensive as it requires knowing whether there are any dirty
+	   children that are not unallocated. The extent_needs_allocation should
+	   be used after setting the correct preceder.
+
+	   When we reach the end of a twig at this point in the code, if the
+	   flush can continue (when the queue is ready) it will need some
+	   information on the future starting point. That should be stored away
+	   in the flush_handle using a seal, I believe. Holding a jref() on the
+	   future starting point may break other code that deletes that node.
 	 */
 
-	/* FIXME_NFQUCMPD: Also, we don't want to do any flushing when flush is called
-	   above the twig level.  If the VM calls flush above the twig level, do nothing
-	   and return (but figure out why this happens).  The txnmgr should be modified to
-	   only flush its leaf-level dirty list.  This will do all the necessary squeeze
-	   and allocate steps but leave unallocated branches and possibly unallocated
-	   twigs (when the twig's leftmost child is not dirty).  After flushing the leaf
-	   level, the remaining unallocated nodes should be given write-optimized
-	   locations.  (Possibly, the remaining unallocated twigs should be allocated just
-	   before their leftmost child.)
+	/* FIXME_NFQUCMPD: Also, we don't want to do any flushing when flush is
+	   called above the twig level.  If the VM calls flush above the twig
+	   level, do nothing and return (but figure out why this happens). The
+	   txnmgr should be modified to only flush its leaf-level dirty list.
+	   This will do all the necessary squeeze and allocate steps but leave
+	   unallocated branches and possibly unallocated twigs (when the twig's
+	   leftmost child is not dirty). After flushing the leaf level, the
+	   remaining unallocated nodes should be given write-optimized
+	   locations. (Possibly, the remaining unallocated twigs should be
+	   allocated just before their leftmost child.)
 	 */
 
 	/* Any failure reaches this point. */
-      failed:
+failed:
 
 	switch (ret) {
 	case -E_REPEAT:
@@ -856,9 +905,11 @@ jnode_flush(jnode * node, long nr_to_wri
 	case -E_DEADLOCK:
 	case -E_NO_NEIGHBOR:
 	case -ENOENT:
-		/* FIXME(C): Except for E_DEADLOCK, these should probably be handled properly
-		   in each case.  They already are handled in many cases. */
-		/* Something bad happened, but difficult to avoid...  Try again! */
+		/* FIXME(C): Except for E_DEADLOCK, these should probably be
+		   handled properly in each case. They already are handled in
+		   many cases. */
+		/* Something bad happened, but difficult to avoid... Try again!
+		*/
 		ret = 0;
 	}
 
@@ -889,7 +940,7 @@ jnode_flush(jnode * node, long nr_to_wri
  * turn rapid flush mode off.
  */
 
-static int rapid_flush(flush_pos_t * pos)
+static int rapid_flush(flush_pos_t *pos)
 {
 	if (!wbq_available())
 		return 0;
@@ -903,7 +954,7 @@ static int rapid_flush(flush_pos_t * pos
 
 #endif				/* REISER4_USE_RAPID_FLUSH */
 
-static jnode *find_flush_start_jnode(jnode *start, txn_atom *atom,
+static jnode *find_flush_start_jnode(jnode *start, txn_atom * atom,
 				     flush_queue_t *fq, int *nr_queued,
 				     int flags)
 {
@@ -919,13 +970,14 @@ static jnode *find_flush_start_jnode(jno
 		spin_unlock_jnode(start);
 	}
 	/*
-	 * In this loop we process all already prepped (RELOC or OVRWR) and dirtied again
-	 * nodes. The atom spin lock is not released until all dirty nodes processed or
-	 * not prepped node found in the atom dirty lists.
+	 * In this loop we process all already prepped (RELOC or OVRWR) and
+	 * dirtied again nodes. The atom spin lock is not released until all
+	 * dirty nodes processed or not prepped node found in the atom dirty
+	 * lists.
 	 */
 	while ((node = find_first_dirty_jnode(atom, flags))) {
 		spin_lock_jnode(node);
-	enter:
+enter:
 		assert("zam-881", JF_ISSET(node, JNODE_DIRTY));
 		assert("zam-898", !JF_ISSET(node, JNODE_OVRWR));
 
@@ -934,8 +986,9 @@ static jnode *find_flush_start_jnode(jno
 			list_move_tail(&node->capture_link, ATOM_WB_LIST(atom));
 
 			/*
-			 * jnode is not necessarily on dirty list: if it was dirtied when
-			 * it was on flush queue - it does not get moved to dirty list
+			 * jnode is not necessarily on dirty list: if it was
+			 * dirtied when it was on flush queue - it does not get
+			 * moved to dirty list
 			 */
 			ON_DEBUG(count_jnode(atom, node, NODE_LIST(node),
 					     WB_LIST, 1));
@@ -943,15 +996,17 @@ static jnode *find_flush_start_jnode(jno
 		} else if (jnode_is_znode(node)
 			   && znode_above_root(JZNODE(node))) {
 			/*
-			 * A special case for znode-above-root.  The above-root (fake)
-			 * znode is captured and dirtied when the tree height changes or
-			 * when the root node is relocated.  This causes atoms to fuse so
-			 * that changes at the root are serialized.  However, this node is
-			 * never flushed.  This special case used to be in lock.c to
-			 * prevent the above-root node from ever being captured, but now
-			 * that it is captured we simply prevent it from flushing.  The
-			 * log-writer code relies on this to properly log superblock
-			 * modifications of the tree height.
+			 * A special case for znode-above-root. The above-root
+			 * (fake) znode is captured and dirtied when the tree
+			 * height changes or when the root node is relocated.
+			 * This causes atoms to fuse so that changes at the root
+			 * are serialized.  However, this node is never flushed.
+			 * This special case used to be in lock.c to prevent the
+			 * above-root node from ever being captured, but now
+			 * that it is captured we simply prevent it from
+			 * flushing. The log-writer code relies on this to
+			 * properly log superblock modifications of the tree
+			 * height.
 			 */
 			jnode_make_wander_nolock(node);
 		} else if (JF_ISSET(node, JNODE_RELOC)) {
@@ -965,9 +1020,9 @@ static jnode *find_flush_start_jnode(jno
 	return node;
 }
 
-/* Flush some nodes of current atom, usually slum, return -E_REPEAT if there are more nodes
- * to flush, return 0 if atom's dirty lists empty and keep current atom locked, return
- * other errors as they are. */
+/* Flush some nodes of current atom, usually slum, return -E_REPEAT if there are
+ * more nodes to flush, return 0 if atom's dirty lists empty and keep current
+ * atom locked, return other errors as they are. */
 int
 flush_current_atom(int flags, long nr_to_write, long *nr_submitted,
 		   txn_atom ** atom, jnode *start)
@@ -1053,12 +1108,13 @@ flush_current_atom(int flags, long nr_to
 
 /* REVERSE PARENT-FIRST RELOCATION POLICIES */
 
-/* This implements the is-it-close-enough-to-its-preceder? test for relocation in the
-   reverse parent-first relocate context.  Here all we know is the preceder and the block
-   number.  Since we are going in reverse, the preceder may still be relocated as well, so
-   we can't ask the block allocator "is there a closer block available to relocate?" here.
-   In the _forward_ parent-first relocate context (not here) we actually call the block
-   allocator to try and find a closer location. */
+/* This implements the is-it-close-enough-to-its-preceder? test for relocation
+   in the reverse parent-first relocate context. Here all we know is the
+   preceder and the block number. Since we are going in reverse, the preceder
+   may still be relocated as well, so we can't ask the block allocator "is there
+   a closer block available to relocate?" here. In the _forward_ parent-first
+   relocate context (not here) we actually call the block allocator to try and
+   find a closer location. */
 static int
 reverse_relocate_if_close_enough(const reiser4_block_nr * pblk,
 				 const reiser4_block_nr * nblk)
@@ -1072,24 +1128,23 @@ reverse_relocate_if_close_enough(const r
 	/* Distance is the absolute value. */
 	dist = (*pblk > *nblk) ? (*pblk - *nblk) : (*nblk - *pblk);
 
-	/* If the block is less than FLUSH_RELOCATE_DISTANCE blocks away from its preceder
-	   block, do not relocate. */
-	if (dist <= get_current_super_private()->flush.relocate_distance) {
+	/* If the block is less than FLUSH_RELOCATE_DISTANCE blocks away from
+	   its preceder block, do not relocate. */
+	if (dist <= get_current_super_private()->flush.relocate_distance)
 		return 0;
-	}
 
 	return 1;
 }
 
-/* This function is a predicate that tests for relocation.  Always called in the
-   reverse-parent-first context, when we are asking whether the current node should be
-   relocated in order to expand the flush by dirtying the parent level (and thus
-   proceeding to flush that level).  When traversing in the forward parent-first direction
-   (not here), relocation decisions are handled in two places: allocate_znode() and
-   extent_needs_allocation(). */
+/* This function is a predicate that tests for relocation. Always called in the
+   reverse-parent-first context, when we are asking whether the current node
+   should be relocated in order to expand the flush by dirtying the parent level
+   (and thus proceeding to flush that level). When traversing in the forward
+   parent-first direction (not here), relocation decisions are handled in two
+   places: allocate_znode() and extent_needs_allocation(). */
 static int
-reverse_relocate_test(jnode * node, const coord_t * parent_coord,
-		      flush_pos_t * pos)
+reverse_relocate_test(jnode * node, const coord_t *parent_coord,
+		      flush_pos_t *pos)
 {
 	reiser4_block_nr pblk = 0;
 	reiser4_block_nr nblk = 0;
@@ -1105,15 +1160,15 @@ reverse_relocate_test(jnode * node, cons
 	 */
 
 	/* New nodes are treated as if they are being relocated. */
-	if (JF_ISSET (node, JNODE_CREATED) ||
-	    (pos->leaf_relocate && jnode_get_level(node) == LEAF_LEVEL)) {
+	if (JF_ISSET(node, JNODE_CREATED) ||
+	    (pos->leaf_relocate && jnode_get_level(node) == LEAF_LEVEL))
 		return 1;
-	}
 
-	/* Find the preceder.  FIXME(B): When the child is an unformatted, previously
-	   existing node, the coord may be leftmost even though the child is not the
-	   parent-first preceder of the parent.  If the first dirty node appears somewhere
-	   in the middle of the first extent unit, this preceder calculation is wrong.
+	/* Find the preceder. FIXME(B): When the child is an unformatted,
+	   previously existing node, the coord may be leftmost even though the
+	   child is not the parent-first preceder of the parent. If the first
+	   dirty node appears somewhere in the middle of the first extent unit,
+	   this preceder calculation is wrong.
 	   Needs more logic in here. */
 	if (coord_is_leftmost_unit(parent_coord)) {
 		pblk = *znode_get_block(parent_coord->node);
@@ -1122,10 +1177,10 @@ reverse_relocate_test(jnode * node, cons
 	}
 	check_preceder(pblk);
 
-	/* If (pblk == 0) then the preceder isn't allocated or isn't known: relocate. */
-	if (pblk == 0) {
+	/* If (pblk == 0) then the preceder isn't allocated or isn't known:
+	   relocate. */
+	if (pblk == 0)
 		return 1;
-	}
 
 	nblk = *jnode_get_block(node);
 
@@ -1139,20 +1194,20 @@ reverse_relocate_test(jnode * node, cons
 /* This function calls reverse_relocate_test to make a reverse-parent-first
    relocation decision and then, if yes, it marks the parent dirty. */
 static int
-reverse_relocate_check_dirty_parent(jnode * node, const coord_t * parent_coord,
-				    flush_pos_t * pos)
+reverse_relocate_check_dirty_parent(jnode * node, const coord_t *parent_coord,
+				    flush_pos_t *pos)
 {
 	int ret;
 
 	if (!JF_ISSET(ZJNODE(parent_coord->node), JNODE_DIRTY)) {
 
 		ret = reverse_relocate_test(node, parent_coord, pos);
-		if (ret < 0) {
+		if (ret < 0)
 			return ret;
-		}
 
 		/* FIXME-ZAM
-		   if parent is already relocated - we do not want to grab space, right? */
+		  if parent is already relocated - we do not want to grab space,
+		  right? */
 		if (ret == 1) {
 			int grabbed;
 
@@ -1172,11 +1227,11 @@ reverse_relocate_check_dirty_parent(jnod
 	return 0;
 }
 
-/* INITIAL ALLOCATE ANCESTORS STEP (REVERSE PARENT-FIRST ALLOCATION BEFORE FORWARD
-   PARENT-FIRST LOOP BEGINS) */
+/* INITIAL ALLOCATE ANCESTORS STEP (REVERSE PARENT-FIRST ALLOCATION BEFORE
+   FORWARD PARENT-FIRST LOOP BEGINS) */
 
 /* Get the leftmost child for given coord. */
-static int get_leftmost_child_of_unit(const coord_t * coord, jnode ** child)
+static int get_leftmost_child_of_unit(const coord_t *coord, jnode ** child)
 {
 	int ret;
 
@@ -1191,16 +1246,17 @@ static int get_leftmost_child_of_unit(co
 	return 0;
 }
 
-/* This step occurs after the left- and right-scans are completed, before starting the
-   forward parent-first traversal.  Here we attempt to allocate ancestors of the starting
-   flush point, which means continuing in the reverse parent-first direction to the
-   parent, grandparent, and so on (as long as the child is a leftmost child).  This
-   routine calls a recursive process, alloc_one_ancestor, which does the real work,
-   except there is special-case handling here for the first ancestor, which may be a twig.
-   At each level (here and alloc_one_ancestor), we check for relocation and then, if
-   the child is a leftmost child, repeat at the next level.  On the way back down (the
+/* This step occurs after the left- and right-scans are completed, before
+   starting the forward parent-first traversal. Here we attempt to allocate
+   ancestors of the starting flush point, which means continuing in the reverse
+   parent-first direction to the parent, grandparent, and so on (as long as the
+   child is a leftmost child). This routine calls a recursive process,
+   alloc_one_ancestor, which does the real work, except there is special-case
+   handling here for the first ancestor, which may be a twig. At each level
+   (here and alloc_one_ancestor), we check for relocation and then, if the child
+   is a leftmost child, repeat at the next level. On the way back down (the
    recursion), we allocate the ancestors in parent-first order. */
-static int alloc_pos_and_ancestors(flush_pos_t * pos)
+static int alloc_pos_and_ancestors(flush_pos_t *pos)
 {
 	int ret = 0;
 	lock_handle plock;
@@ -1268,35 +1324,36 @@ static int alloc_pos_and_ancestors(flush
 
 		ret = allocate_znode(pos->lock.node, &pcoord, pos);
 	}
-      exit:
+exit:
 	done_load_count(&pload);
 	done_lh(&plock);
 	return ret;
 }
 
-/* This is the recursive step described in alloc_pos_and_ancestors, above.  Ignoring the
-   call to set_preceder, which is the next function described, this checks if the
-   child is a leftmost child and returns if it is not.  If the child is a leftmost child
-   it checks for relocation, possibly dirtying the parent.  Then it performs the recursive
-   step. */
-static int alloc_one_ancestor(const coord_t * coord, flush_pos_t * pos)
+/* This is the recursive step described in alloc_pos_and_ancestors, above.
+   Ignoring the call to set_preceder, which is the next function described, this
+   checks if the child is a leftmost child and returns if it is not. If the
+   child is a leftmost child it checks for relocation, possibly dirtying the
+   parent. Then it performs the recursive step. */
+static int alloc_one_ancestor(const coord_t *coord, flush_pos_t *pos)
 {
 	int ret = 0;
 	lock_handle alock;
 	load_count aload;
 	coord_t acoord;
 
-	/* As we ascend at the left-edge of the region to flush, take this opportunity at
-	   the twig level to find our parent-first preceder unless we have already set
-	   it. */
+	/* As we ascend at the left-edge of the region to flush, take this
+	   opportunity at the twig level to find our parent-first preceder
+	   unless we have already set it. */
 	if (pos->preceder.blk == 0) {
 		ret = set_preceder(coord, pos);
 		if (ret != 0)
 			return ret;
 	}
 
-	/* If the ancestor is clean or already allocated, or if the child is not a
-	   leftmost child, stop going up, even leaving coord->node not flushprepped. */
+	/* If the ancestor is clean or already allocated, or if the child is not
+	   a leftmost child, stop going up, even leaving coord->node not
+	   flushprepped. */
 	if (znode_check_flushprepped(coord->node)
 	    || !coord_is_leftmost_unit(coord))
 		return 0;
@@ -1305,8 +1362,8 @@ static int alloc_one_ancestor(const coor
 	init_load_count(&aload);
 	coord_init_invalid(&acoord, NULL);
 
-	/* Only ascend to the next level if it is a leftmost child, but write-lock the
-	   parent in case we will relocate the child. */
+	/* Only ascend to the next level if it is a leftmost child, but
+	   write-lock the parent in case we will relocate the child. */
 	if (!znode_is_root(coord->node)) {
 
 		ret =
@@ -1321,9 +1378,8 @@ static int alloc_one_ancestor(const coor
 		ret =
 		    reverse_relocate_check_dirty_parent(ZJNODE(coord->node),
 							&acoord, pos);
-		if (ret != 0) {
+		if (ret != 0)
 			goto exit;
-		}
 
 		/* Recursive call. */
 		if (!znode_check_flushprepped(acoord.node)) {
@@ -1333,32 +1389,34 @@ static int alloc_one_ancestor(const coor
 		}
 	}
 
-	/* Note: we call allocate with the parent write-locked (except at the root) in
-	   case we relocate the child, in which case it will modify the parent during this
-	   call. */
+	/* Note: we call allocate with the parent write-locked (except at the
+	   root) in case we relocate the child, in which case it will modify the
+	   parent during this call. */
 	ret = allocate_znode(coord->node, &acoord, pos);
 
-      exit:
+exit:
 	done_load_count(&aload);
 	done_lh(&alock);
 	return ret;
 }
 
-/* During the reverse parent-first alloc_pos_and_ancestors process described above there is
-   a call to this function at the twig level.  During alloc_pos_and_ancestors we may ask:
-   should this node be relocated (in reverse parent-first context)?  We repeat this
-   process as long as the child is the leftmost child, eventually reaching an ancestor of
-   the flush point that is not a leftmost child.  The preceder of that ancestors, which is
-   not a leftmost child, is actually on the leaf level.  The preceder of that block is the
-   left-neighbor of the flush point.  The preceder of that block is the rightmost child of
-   the twig on the left.  So, when alloc_pos_and_ancestors passes upward through the twig
-   level, it stops momentarily to remember the block of the rightmost child of the twig on
-   the left and sets it to the flush_position's preceder_hint.
+/* During the reverse parent-first alloc_pos_and_ancestors process described
+   above there is a call to this function at the twig level. During
+   alloc_pos_and_ancestors we may ask: should this node be relocated (in reverse
+   parent-first context)?  We repeat this process as long as the child is the
+   leftmost child, eventually reaching an ancestor of the flush point that is
+   not a leftmost child. The preceder of that ancestors, which is not a leftmost
+   child, is actually on the leaf level. The preceder of that block is the
+   left-neighbor of the flush point. The preceder of that block is the rightmost
+   child of the twig on the left. So, when alloc_pos_and_ancestors passes upward
+   through the twig level, it stops momentarily to remember the block of the
+   rightmost child of the twig on the left and sets it to the flush_position's
+   preceder_hint.
 
-   There is one other place where we may set the flush_position's preceder hint, which is
-   during scan-left.
+   There is one other place where we may set the flush_position's preceder hint,
+   which is during scan-left.
 */
-static int set_preceder(const coord_t * coord_in, flush_pos_t * pos)
+static int set_preceder(const coord_t *coord_in, flush_pos_t *pos)
 {
 	int ret;
 	coord_t coord;
@@ -1370,9 +1428,9 @@ static int set_preceder(const coord_t * 
 	init_lh(&left_lock);
 	init_load_count(&left_load);
 
-	/* FIXME(B): Same FIXME as in "Find the preceder" in reverse_relocate_test.
-	   coord_is_leftmost_unit is not the right test if the unformatted child is in the
-	   middle of the first extent unit. */
+	/* FIXME(B): Same FIXME as in "Find the preceder" in
+	   reverse_relocate_test. coord_is_leftmost_unit is not the right test
+	   if the unformatted child is in the middle of the first extent unit.*/
 	if (!coord_is_leftmost_unit(&coord)) {
 		coord_prev_unit(&coord);
 	} else {
@@ -1380,14 +1438,13 @@ static int set_preceder(const coord_t * 
 		    reiser4_get_left_neighbor(&left_lock, coord.node,
 					      ZNODE_READ_LOCK, GN_SAME_ATOM);
 		if (ret) {
-			/* If we fail for any reason it doesn't matter because the
-			   preceder is only a hint.  We are low-priority at this point, so
-			   this must be the case. */
+			/* If we fail for any reason it doesn't matter because
+			   the preceder is only a hint. We are low-priority at
+			   this point, so this must be the case. */
 			if (ret == -E_REPEAT || ret == -E_NO_NEIGHBOR ||
 			    ret == -ENOENT || ret == -EINVAL
-			    || ret == -E_DEADLOCK) {
+			    || ret == -E_DEADLOCK)
 				ret = 0;
-			}
 			goto exit;
 		}
 
@@ -1401,7 +1458,7 @@ static int set_preceder(const coord_t * 
 	ret =
 	    item_utmost_child_real_block(&coord, RIGHT_SIDE,
 					 &pos->preceder.blk);
-      exit:
+exit:
 	check_preceder(pos->preceder.blk);
 	done_load_count(&left_load);
 	done_lh(&left_lock);
@@ -1410,8 +1467,9 @@ static int set_preceder(const coord_t * 
 
 /* MAIN SQUEEZE AND ALLOCATE LOOP (THREE BIG FUNCTIONS) */
 
-/* This procedure implements the outer loop of the flush algorithm.  To put this in
-   context, here is the general list of steps taken by the flush routine as a whole:
+/* This procedure implements the outer loop of the flush algorithm. To put this
+   in context, here is the general list of steps taken by the flush routine as a
+   whole:
 
    1. Scan-left
    2. Scan-right (maybe)
@@ -1423,28 +1481,29 @@ static int set_preceder(const coord_t * 
 
    This procedure implements the loop in steps 4 through 6 in the above listing.
 
-   Step 4: if the current flush position is an extent item (position on the twig level),
-   it allocates the extent (allocate_extent_item_in_place) then shifts to the next
-   coordinate.  If the next coordinate's leftmost child needs flushprep, we will continue.
-   If the next coordinate is an internal item, we descend back to the leaf level,
-   otherwise we repeat a step #4 (labeled ALLOC_EXTENTS below).  If the "next coordinate"
-   brings us past the end of the twig level, then we call
-   reverse_relocate_end_of_twig to possibly dirty the next (right) twig, prior to
-   step #5 which moves to the right.
-
-   Step 5: calls squalloc_changed_ancestors, which initiates a recursive call up the
-   tree to allocate any ancestors of the next-right flush position that are not also
-   ancestors of the current position.  Those ancestors (in top-down order) are the next in
-   parent-first order.  We squeeze adjacent nodes on the way up until the right node and
-   current node share the same parent, then allocate on the way back down.  Finally, this
-   step sets the flush position to the next-right node.  Then repeat steps 4 and 5.
+   Step 4: if the current flush position is an extent item (position on the twig
+   level), it allocates the extent (allocate_extent_item_in_place) then shifts
+   to the next coordinate. If the next coordinate's leftmost child needs
+   flushprep, we will continue. If the next coordinate is an internal item, we
+   descend back to the leaf level, otherwise we repeat a step #4 (labeled
+   ALLOC_EXTENTS below). If the "next coordinate" brings us past the end of the
+   twig level, then we call reverse_relocate_end_of_twig to possibly dirty the
+   next (right) twig, prior to step #5 which moves to the right.
+
+   Step 5: calls squalloc_changed_ancestors, which initiates a recursive call up
+   the tree to allocate any ancestors of the next-right flush position that are
+   not also ancestors of the current position. Those ancestors (in top-down
+   order) are the next in parent-first order. We squeeze adjacent nodes on the
+   way up until the right node and current node share the same parent, then
+   allocate on the way back down. Finally, this step sets the flush position to
+   the next-right node.  Then repeat steps 4 and 5.
 */
 
 /* SQUEEZE CODE */
 
 /* squalloc_right_twig helper function, cut a range of extent items from
    cut node to->node from the beginning up to coord @to. */
-static int squalloc_right_twig_cut(coord_t * to, reiser4_key * to_key,
+static int squalloc_right_twig_cut(coord_t *to, reiser4_key * to_key,
 				   znode * left)
 {
 	coord_t from;
@@ -1461,7 +1520,7 @@ static int squalloc_right_twig_cut(coord
    SQUEEZE_SOURCE_EMPTY when no more can be shifted.  If the next item is an
    internal item it calls shift_one_internal_unit and may then return
    SUBTREE_MOVED. */
-static int squeeze_right_twig(znode * left, znode * right, flush_pos_t * pos)
+static int squeeze_right_twig(znode * left, znode * right, flush_pos_t *pos)
 {
 	int ret = SUBTREE_MOVED;
 	coord_t coord;		/* used to iterate over items */
@@ -1497,9 +1556,8 @@ static int squeeze_right_twig(znode * le
 	if (node_is_empty(coord.node))
 		ret = SQUEEZE_SOURCE_EMPTY;
 
-	if (ret == SQUEEZE_TARGET_FULL) {
+	if (ret == SQUEEZE_TARGET_FULL)
 		goto out;
-	}
 
 	if (node_is_empty(right)) {
 		/* The whole right node was copied into @left. */
@@ -1510,18 +1568,18 @@ static int squeeze_right_twig(znode * le
 	coord_init_first_unit(&coord, right);
 
 	if (!item_is_internal(&coord)) {
-		/* we do not want to squeeze anything else to left neighbor because "slum"
-		   is over */
+		/* we do not want to squeeze anything else to left neighbor
+		   because "slum" is over */
 		ret = SQUEEZE_TARGET_FULL;
 		goto out;
 	}
 	assert("jmacd-433", item_is_internal(&coord));
 
-	/* Shift an internal unit.  The child must be allocated before shifting any more
-	   extents, so we stop here. */
+	/* Shift an internal unit.  The child must be allocated before shifting
+	   any more extents, so we stop here. */
 	ret = shift_one_internal_unit(left, right);
 
-      out:
+out:
 	assert("jmacd-8612", ret < 0 || ret == SQUEEZE_TARGET_FULL
 	       || ret == SUBTREE_MOVED || ret == SQUEEZE_SOURCE_EMPTY);
 
@@ -1540,7 +1598,7 @@ static int squeeze_right_twig(znode * le
 }
 
 #if REISER4_DEBUG
-static void item_convert_invariant(flush_pos_t * pos)
+static void item_convert_invariant(flush_pos_t *pos)
 {
 	assert("edward-1225", coord_is_existing_item(&pos->coord));
 	if (chaining_data_present(pos)) {
@@ -1562,7 +1620,7 @@ static void item_convert_invariant(flush
    item its flush ->convert() method (if any). This method may
    resize/kill the item so the tree will be changed.
 */
-static int convert_node(flush_pos_t * pos, znode * node)
+static int convert_node(flush_pos_t *pos, znode * node)
 {
 	int ret = 0;
 	item_plugin *iplug;
@@ -1602,11 +1660,11 @@ static int convert_node(flush_pos_t * po
 				break;
 			if (should_chain_next_node(pos)) {
 				/* go to next node */
-				move_chaining_data(pos, 0 /* to next node */ );
+				move_chaining_data(pos, 0/* to next node */);
 				break;
 			}
 			/* repeat this node */
-			move_chaining_data(pos, 1 /* this node */ );
+			move_chaining_data(pos, 1/* this node */);
 			continue;
 		}
 		/* Node is not over.
@@ -1622,12 +1680,12 @@ static int convert_node(flush_pos_t * po
 			ret = coord_prev_item(&pos->coord);
 			assert("edward-1003", !ret);
 
-			move_chaining_data(pos, 1 /* this node */ );
+			move_chaining_data(pos, 1/* this node */);
 		}
 	}
 	JF_CLR(ZJNODE(node), JNODE_CONVERTIBLE);
 	znode_make_dirty(node);
-      exit:
+exit:
 	assert("edward-1004", !ret);
 	return ret;
 }
@@ -1652,7 +1710,7 @@ static int convert_node(flush_pos_t * po
    is returned.
 */
 
-static int squeeze_right_neighbor(flush_pos_t * pos, znode * left,
+static int squeeze_right_neighbor(flush_pos_t *pos, znode * left,
 				  znode * right)
 {
 	int ret;
@@ -1672,8 +1730,8 @@ static int squeeze_right_neighbor(flush_
 		break;
 
 	default:
-		/* All other levels can use shift_everything until we implement per-item
-		   flush plugins. */
+		/* All other levels can use shift_everything until we implement
+		   per-item flush plugins. */
 		ret = squeeze_right_non_twig(left, right);
 		break;
 	}
@@ -1685,7 +1743,7 @@ static int squeeze_right_neighbor(flush_
 	return ret;
 }
 
-static int squeeze_right_twig_and_advance_coord(flush_pos_t * pos,
+static int squeeze_right_twig_and_advance_coord(flush_pos_t *pos,
 						znode * right)
 {
 	int ret;
@@ -1707,7 +1765,7 @@ static int squalloc_upper_levels(flush_p
 
 /* do a fast check for "same parents" condition before calling
  * squalloc_upper_levels() */
-static inline int check_parents_and_squalloc_upper_levels(flush_pos_t * pos,
+static inline int check_parents_and_squalloc_upper_levels(flush_pos_t *pos,
 							  znode * left,
 							  znode * right)
 {
@@ -1722,7 +1780,7 @@ static inline int check_parents_and_squa
    share at least the parent of the @right is after the @left but before the
    @right in parent-first order, we have to (re)allocate it before the @right
    gets (re)allocated. */
-static int squalloc_upper_levels(flush_pos_t * pos, znode * left, znode * right)
+static int squalloc_upper_levels(flush_pos_t *pos, znode * left, znode * right)
 {
 	int ret;
 
@@ -1751,17 +1809,18 @@ static int squalloc_upper_levels(flush_p
 		goto out;
 
 	if (znode_check_flushprepped(right_parent_lock.node)) {
-		/* Keep parent-first order.  In the order, the right parent node stands
-		   before the @right node.  If it is already allocated, we set the
-		   preceder (next block search start point) to its block number, @right
-		   node should be allocated after it.
-
-		   However, preceder is set only if the right parent is on twig level.
-		   The explanation is the following: new branch nodes are allocated over
-		   already allocated children while the tree grows, it is difficult to
-		   keep tree ordered, we assume that only leaves and twings are correctly
-		   allocated.  So, only twigs are used as a preceder for allocating of the
-		   rest of the slum. */
+		/* Keep parent-first order.  In the order, the right parent node
+		   stands before the @right node.  If it is already allocated,
+		   we set the preceder (next block search start point) to its
+		   block number, @right node should be allocated after it.
+
+		   However, preceder is set only if the right parent is on twig
+		   level. The explanation is the following: new branch nodes are
+		   allocated over already allocated children while the tree
+		   grows, it is difficult to keep tree ordered, we assume that
+		   only leaves and twings are correctly allocated. So, only
+		   twigs are used as a preceder for allocating of the rest of
+		   the slum. */
 		if (znode_get_level(right_parent_lock.node) == TWIG_LEVEL) {
 			pos->preceder.blk =
 			    *znode_get_block(right_parent_lock.node);
@@ -1800,7 +1859,7 @@ static int squalloc_upper_levels(flush_p
 	/* allocate znode when going down */
 	ret = lock_parent_and_allocate_znode(right_parent_lock.node, pos);
 
-      out:
+out:
 	done_load_count(&left_parent_load);
 	done_load_count(&right_parent_load);
 
@@ -1812,7 +1871,7 @@ static int squalloc_upper_levels(flush_p
 
 /* Check the leftmost child "flushprepped" status, also returns true if child
  * node was not found in cache.  */
-static int leftmost_child_of_unit_check_flushprepped(const coord_t * coord)
+static int leftmost_child_of_unit_check_flushprepped(const coord_t *coord)
 {
 	int ret;
 	int prepped;
@@ -1838,7 +1897,7 @@ static int leftmost_child_of_unit_check_
 }
 
 /* (re)allocate znode with automated getting parent node */
-static int lock_parent_and_allocate_znode(znode * node, flush_pos_t * pos)
+static int lock_parent_and_allocate_znode(znode * node, flush_pos_t *pos)
 {
 	int ret;
 	lock_handle parent_lock;
@@ -1864,7 +1923,7 @@ static int lock_parent_and_allocate_znod
 
 	ret = allocate_znode(node, &pcoord, pos);
 
-      out:
+out:
 	done_load_count(&parent_load);
 	done_lh(&parent_lock);
 	return ret;
@@ -1872,7 +1931,7 @@ static int lock_parent_and_allocate_znod
 
 /* Process nodes on leaf level until unformatted node or rightmost node in the
  * slum reached.  */
-static int handle_pos_on_formatted(flush_pos_t * pos)
+static int handle_pos_on_formatted(flush_pos_t *pos)
 {
 	int ret;
 	lock_handle right_lock;
@@ -1900,10 +1959,10 @@ static int handle_pos_on_formatted(flush
 			break;
 		}
 
-		/* we don't prep(allocate) nodes for flushing twice.  This can be suboptimal, or it
-		 * can be optimal.  For now we choose to live with the risk that it will
-		 * be suboptimal because it would be quite complex to code it to be
-		 * smarter. */
+		/* we don't prep(allocate) nodes for flushing twice. This can be
+		 * suboptimal, or it can be optimal. For now we choose to live
+		 * with the risk that it will be suboptimal because it would be
+		 * quite complex to code it to be smarter. */
 		if (znode_check_flushprepped(right_lock.node)
 		    && !znode_convertible(right_lock.node)) {
 			assert("edward-1005", !should_convert_next_node(pos));
@@ -1936,7 +1995,7 @@ static int handle_pos_on_formatted(flush
 		if (znode_check_flushprepped(right_lock.node)) {
 			if (should_convert_next_node(pos)) {
 				/* in spite of flushprepped status of the node,
-				   its right slum neighbor should be converted */
+				   its right slum neighbor should be converted*/
 				assert("edward-953", convert_data(pos));
 				assert("edward-954", item_convert_data(pos));
 
@@ -1986,15 +2045,15 @@ static int handle_pos_on_formatted(flush
 	done_load_count(&right_load);
 	done_lh(&right_lock);
 
-	/* This function indicates via pos whether to stop or go to twig or continue on current
-	 * level. */
+	/* This function indicates via pos whether to stop or go to twig or
+	 * continue on current level. */
 	return ret;
 
 }
 
 /* Process nodes on leaf level until unformatted node or rightmost node in the
  * slum reached.  */
-static int handle_pos_on_leaf(flush_pos_t * pos)
+static int handle_pos_on_leaf(flush_pos_t *pos)
 {
 	int ret;
 
@@ -2012,14 +2071,14 @@ static int handle_pos_on_leaf(flush_pos_
 }
 
 /* Process slum on level > 1 */
-static int handle_pos_on_internal(flush_pos_t * pos)
+static int handle_pos_on_internal(flush_pos_t *pos)
 {
 	assert("zam-850", pos->state == POS_ON_INTERNAL);
 	return handle_pos_on_formatted(pos);
 }
 
 /* check whether squalloc should stop before processing given extent */
-static int squalloc_extent_should_stop(flush_pos_t * pos)
+static int squalloc_extent_should_stop(flush_pos_t *pos)
 {
 	assert("zam-869", item_is_extent(&pos->coord));
 
@@ -2056,7 +2115,7 @@ static int squalloc_extent_should_stop(f
  * unformatted nodes.  By having a lock on twig level and use extent code
  * routines to process unformatted nodes we swim around an irregular part of
  * reiser4 tree. */
-static int handle_pos_on_twig(flush_pos_t * pos)
+static int handle_pos_on_twig(flush_pos_t *pos)
 {
 	int ret;
 
@@ -2079,9 +2138,8 @@ static int handle_pos_on_twig(flush_pos_
 	while (pos_valid(pos) && coord_is_existing_unit(&pos->coord)
 	       && item_is_extent(&pos->coord)) {
 		ret = reiser4_alloc_extent(pos);
-		if (ret) {
+		if (ret)
 			break;
-		}
 		coord_next_unit(&pos->coord);
 	}
 
@@ -2104,7 +2162,7 @@ static int handle_pos_on_twig(flush_pos_
 /* When we about to return flush position from twig to leaf level we can process
  * the right twig node or move position to the leaf.  This processes right twig
  * if it is possible and jump to leaf level if not. */
-static int handle_pos_end_of_twig(flush_pos_t * pos)
+static int handle_pos_end_of_twig(flush_pos_t *pos)
 {
 	int ret;
 	lock_handle right_lock;
@@ -2135,12 +2193,13 @@ static int handle_pos_end_of_twig(flush_
 	if (JF_ISSET(ZJNODE(right_lock.node), JNODE_DIRTY)) {
 		/* If right twig node is dirty we always attempt to squeeze it
 		 * content to the left... */
-	      became_dirty:
+became_dirty:
 		ret =
 		    squeeze_right_twig_and_advance_coord(pos, right_lock.node);
 		if (ret <= 0) {
 			/* pos->coord is on internal item, go to leaf level, or
-			 * we have an error which will be caught in squalloc() */
+			 * we have an error which will be caught in squalloc()
+			 */
 			pos->state = POS_TO_LEAF;
 			goto out;
 		}
@@ -2206,7 +2265,7 @@ static int handle_pos_end_of_twig(flush_
 	pos->state = item_is_extent(&at_right) ? POS_ON_EPOINT : POS_TO_LEAF;
 	move_flush_pos(pos, &right_lock, &right_load, &at_right);
 
-      out:
+out:
 	done_load_count(&right_load);
 	done_lh(&right_lock);
 
@@ -2218,7 +2277,7 @@ static int handle_pos_end_of_twig(flush_
 
 /* Move the pos->lock to leaf node pointed by pos->coord, check should we
  * continue there. */
-static int handle_pos_to_leaf(flush_pos_t * pos)
+static int handle_pos_to_leaf(flush_pos_t *pos)
 {
 	int ret;
 	lock_handle child_lock;
@@ -2266,7 +2325,7 @@ static int handle_pos_to_leaf(flush_pos_
 		ret = delete_empty_node(JZNODE(child));
 		pos->state = POS_INVALID;
 	}
-      out:
+out:
 	done_load_count(&child_load);
 	done_lh(&child_lock);
 	jput(child);
@@ -2276,7 +2335,7 @@ static int handle_pos_to_leaf(flush_pos_
 
 /* move pos from leaf to twig, and move lock from leaf to twig. */
 /* Move pos->lock to upper (twig) level */
-static int handle_pos_to_twig(flush_pos_t * pos)
+static int handle_pos_to_twig(flush_pos_t *pos)
 {
 	int ret;
 
@@ -2319,7 +2378,7 @@ static int handle_pos_to_twig(flush_pos_
 
 	move_flush_pos(pos, &parent_lock, &parent_load, &pcoord);
 
-      out:
+out:
 	done_load_count(&parent_load);
 	done_lh(&parent_lock);
 
@@ -2330,29 +2389,31 @@ typedef int (*pos_state_handle_t) (flush
 static pos_state_handle_t flush_pos_handlers[] = {
 	/* process formatted nodes on leaf level, keep lock on a leaf node */
 	[POS_ON_LEAF] = handle_pos_on_leaf,
-	/* process unformatted nodes, keep lock on twig node, pos->coord points to extent currently
-	 * being processed */
+	/* process unformatted nodes, keep lock on twig node, pos->coord points
+	 * to extent currently being processed */
 	[POS_ON_EPOINT] = handle_pos_on_twig,
-	/* move a lock from leaf node to its parent for further processing of unformatted nodes */
+	/* move a lock from leaf node to its parent for further processing of
+	   unformatted nodes */
 	[POS_TO_TWIG] = handle_pos_to_twig,
-	/* move a lock from twig to leaf level when a processing of unformatted nodes finishes,
-	 * pos->coord points to the leaf node we jump to */
+	/* move a lock from twig to leaf level when a processing of unformatted
+	 * nodes finishes, pos->coord points to the leaf node we jump to */
 	[POS_TO_LEAF] = handle_pos_to_leaf,
-	/* after processing last extent in the twig node, attempting to shift items from the twigs
-	 * right neighbor and process them while shifting */
+	/* after processing last extent in the twig node, attempting to shift
+	 * items from the twigs right neighbor and process them while shifting*/
 	[POS_END_OF_TWIG] = handle_pos_end_of_twig,
-	/* process formatted nodes on internal level, keep lock on an internal node */
+	/* process formatted nodes on internal level, keep lock on an internal
+	   node */
 	[POS_ON_INTERNAL] = handle_pos_on_internal
 };
 
-/* Advance flush position horizontally, prepare for flushing ((re)allocate, squeeze,
- * encrypt) nodes and their ancestors in "parent-first" order */
-static int squalloc(flush_pos_t * pos)
+/* Advance flush position horizontally, prepare for flushing ((re)allocate,
+ * squeeze, encrypt) nodes and their ancestors in "parent-first" order */
+static int squalloc(flush_pos_t *pos)
 {
 	int ret = 0;
 
-	/* maybe needs to be made a case statement with handle_pos_on_leaf as first case, for
-	 * greater CPU efficiency? Measure and see.... -Hans */
+	/* maybe needs to be made a case statement with handle_pos_on_leaf as
+	 * first case, for greater CPU efficiency? Measure and see.... -Hans */
 	while (pos_valid(pos)) {
 		ret = flush_pos_handlers[pos->state] (pos);
 		if (ret < 0)
@@ -2363,8 +2424,9 @@ static int squalloc(flush_pos_t * pos)
 			break;
 	}
 
-	/* any positive value or -E_NO_NEIGHBOR are legal return codes for handle_pos*
-	   routines, -E_NO_NEIGHBOR means that slum edge was reached */
+	/* any positive value or -E_NO_NEIGHBOR are legal return codes for
+	   handle_pos* routines, -E_NO_NEIGHBOR means that slum edge was
+	   reached */
 	if (ret > 0 || ret == -E_NO_NEIGHBOR)
 		ret = 0;
 
@@ -2382,16 +2444,18 @@ static void update_ldkey(znode * node)
 	znode_set_ld_key(node, leftmost_key_in_node(node, &ldkey));
 }
 
-/* this is to be called after calling of shift node's method to shift data from @right to
-   @left. It sets left delimiting keys of @left and @right to keys of first items of @left
-   and @right correspondingly and sets right delimiting key of @left to first key of @right */
+/* this is to be called after calling of shift node's method to shift data from
+   @right to @left. It sets left delimiting keys of @left and @right to keys of
+   first items of @left and @right correspondingly and sets right delimiting key
+   of @left to first key of @right */
 static void update_znode_dkeys(znode * left, znode * right)
 {
 	assert_rw_write_locked(&(znode_get_tree(right)->dk_lock));
 	assert("vs-1629", (znode_is_write_locked(left) &&
 			   znode_is_write_locked(right)));
 
-	/* we need to update left delimiting of left if it was empty before shift */
+	/* we need to update left delimiting of left if it was empty before
+	   shift */
 	update_ldkey(left);
 	update_ldkey(right);
 	if (node_is_empty(right))
@@ -2417,7 +2481,8 @@ shift_everything_left(znode * right, zno
 	return nplug->shift(&from, left, SHIFT_LEFT,
 			    1 /* delete @right if it becomes empty */ ,
 			    1
-			    /* move coord @from to node @left if everything will be shifted */
+			    /* move coord @from to node @left if everything will
+			       be shifted */
 			    ,
 			    &info);
 }
@@ -2461,12 +2526,13 @@ static int squeeze_right_non_twig(znode 
 		update_znode_dkeys(left, right);
 		write_unlock_dk(tree);
 
-		/* Carry is called to update delimiting key and, maybe, to remove empty
-		   node. */
+		/* Carry is called to update delimiting key and, maybe, to
+		   remove empty node. */
 		grabbed = get_current_context()->grabbed_blocks;
 		ret = reiser4_grab_space_force(tree->height, BA_RESERVED);
-		assert("nikita-3003", ret == 0);	/* reserved space is exhausted. Ask Hans. */
-		ret = reiser4_carry(todo, NULL /* previous level */ );
+		assert("nikita-3003", ret == 0);	/* reserved space is
+							exhausted. Ask Hans. */
+		ret = reiser4_carry(todo, NULL/* previous level */);
 		grabbed2free_mark(grabbed);
 	} else {
 		/* Shifting impossible, we return appropriate result code */
@@ -2549,10 +2615,12 @@ static int shift_one_internal_unit(znode
 
 	ret = node_plugin_by_node(left)->shift(coord, left, SHIFT_LEFT,
 					       1
-					       /* delete @right if it becomes empty */
+					       /* delete @right if it becomes
+						  empty */
 					       ,
 					       0
-					       /* do not move coord @coord to node @left */
+					       /* do not move coord @coord to
+						  node @left */
 					       ,
 					       info);
 
@@ -2575,9 +2643,10 @@ static int shift_one_internal_unit(znode
 		/* reserve space for delimiting keys after shifting */
 		grabbed = get_current_context()->grabbed_blocks;
 		ret = reiser4_grab_space_force(tree->height, BA_RESERVED);
-		assert("nikita-3003", ret == 0);	/* reserved space is exhausted. Ask Hans. */
+		assert("nikita-3003", ret == 0);	/* reserved space is
+							exhausted. Ask Hans. */
 
-		ret = reiser4_carry(todo, NULL /* previous level */ );
+		ret = reiser4_carry(todo, NULL/* previous level */);
 		grabbed2free_mark(grabbed);
 	}
 
@@ -2592,17 +2661,18 @@ static int shift_one_internal_unit(znode
 	return moved ? SUBTREE_MOVED : SQUEEZE_TARGET_FULL;
 }
 
-/* Make the final relocate/wander decision during forward parent-first squalloc for a
-   znode.  For unformatted nodes this is done in plugin/item/extent.c:extent_needs_allocation(). */
+/* Make the final relocate/wander decision during forward parent-first squalloc
+   for a znode. For unformatted nodes this is done in
+   plugin/item/extent.c:extent_needs_allocation(). */
 static int
 allocate_znode_loaded(znode * node,
-		      const coord_t * parent_coord, flush_pos_t * pos)
+		      const coord_t *parent_coord, flush_pos_t *pos)
 {
 	int ret;
 	reiser4_super_info_data *sbinfo = get_current_super_private();
 	/* FIXME(D): We have the node write-locked and should have checked for !
-	   allocated() somewhere before reaching this point, but there can be a race, so
-	   this assertion is bogus. */
+	   allocated() somewhere before reaching this point, but there can be a
+	   race, so this assertion is bogus. */
 	assert("jmacd-7987", !jnode_check_flushprepped(ZJNODE(node)));
 	assert("jmacd-7988", znode_is_write_locked(node));
 	assert("jmacd-7989", coord_is_invalid(parent_coord)
@@ -2612,12 +2682,12 @@ allocate_znode_loaded(znode * node,
 	    znode_is_root(node) ||
 	    /* We have enough nodes to relocate no matter what. */
 	    (pos->leaf_relocate != 0 && znode_get_level(node) == LEAF_LEVEL)) {
-		/* No need to decide with new nodes, they are treated the same as
-		   relocate. If the root node is dirty, relocate. */
+		/* No need to decide with new nodes, they are treated the same
+		   as relocate. If the root node is dirty, relocate. */
 		if (pos->preceder.blk == 0) {
-			/* preceder is unknown and we have decided to relocate node --
-			   using of default value for search start is better than search
-			   from block #0. */
+			/* preceder is unknown and we have decided to relocate
+			   node -- using of default value for search start is
+			   better than search from block #0. */
 			get_blocknr_hint_default(&pos->preceder.blk);
 			check_preceder(pos->preceder.blk);
 		}
@@ -2647,7 +2717,8 @@ allocate_znode_loaded(znode * node,
 						   nblk) : (nblk -
 							    pos->preceder.blk);
 
-			/* See if we can find a closer block (forward direction only). */
+			/* See if we can find a closer block
+			   (forward direction only). */
 			pos->preceder.max_dist =
 			    min((reiser4_block_nr) sbinfo->flush.
 				relocate_distance, dist);
@@ -2667,15 +2738,17 @@ allocate_znode_loaded(znode * node,
 				/* The present allocation is good enough. */
 				jnode_make_wander(ZJNODE(node));
 			} else {
-				/* Otherwise, try to relocate to the best position. */
-			      best_reloc:
+				/* Otherwise, try to relocate to the best
+				   position. */
+best_reloc:
 				ret =
 				    allocate_znode_update(node, parent_coord,
 							  pos);
 				if (ret != 0)
 					return ret;
 
-				/* set JNODE_RELOC bit _after_ node gets allocated */
+				/* set JNODE_RELOC bit _after_ node gets
+				   allocated */
 				znode_make_reloc(node, pos->fq);
 			}
 		}
@@ -2692,7 +2765,7 @@ allocate_znode_loaded(znode * node,
 }
 
 static int
-allocate_znode(znode * node, const coord_t * parent_coord, flush_pos_t * pos)
+allocate_znode(znode * node, const coord_t *parent_coord, flush_pos_t *pos)
 {
 	/*
 	 * perform znode allocation with znode pinned in memory to avoid races
@@ -2702,13 +2775,13 @@ allocate_znode(znode * node, const coord
 	return WITH_DATA(node, allocate_znode_loaded(node, parent_coord, pos));
 }
 
-/* A subroutine of allocate_znode, this is called first to see if there is a close
-   position to relocate to.  It may return ENOSPC if there is no close position.  If there
-   is no close position it may not relocate.  This takes care of updating the parent node
-   with the relocated block address. */
+/* A subroutine of allocate_znode, this is called first to see if there is a
+   close position to relocate to. It may return ENOSPC if there is no close
+   position. If there is no close position it may not relocate. This takes care
+   of updating the parent node with the relocated block address. */
 static int
-allocate_znode_update(znode * node, const coord_t * parent_coord,
-		      flush_pos_t * pos)
+allocate_znode_update(znode * node, const coord_t *parent_coord,
+		      flush_pos_t *pos)
 {
 	int ret;
 	reiser4_block_nr blk;
@@ -2736,9 +2809,10 @@ allocate_znode_update(znode * node, cons
 	} else {
 		pos->preceder.block_stage = BLOCK_GRABBED;
 
-		/* The disk space for relocating the @node is already reserved in "flush reserved"
-		 * counter if @node is leaf, otherwise we grab space using BA_RESERVED (means grab
-		 * space from whole disk not from only 95%). */
+		/* The disk space for relocating the @node is already reserved
+		 * in "flush reserved" counter if @node is leaf, otherwise we
+		 * grab space using BA_RESERVED (means grab space from whole
+		 * disk not from only 95%). */
 		if (znode_get_level(node) == LEAF_LEVEL) {
 			/*
 			 * earlier (during do_jnode_make_dirty()) we decided
@@ -2764,7 +2838,8 @@ allocate_znode_update(znode * node, cons
 		}
 	}
 
-	/* We may do not use 5% of reserved disk space here and flush will not pack tightly. */
+	/* We may do not use 5% of reserved disk space here and flush will not
+	   pack tightly. */
 	ret = reiser4_alloc_block(&pos->preceder, &blk,
 				  BA_FORMATTED | BA_PERMANENT);
 	if (ret)
@@ -2811,7 +2886,7 @@ allocate_znode_update(znode * node, cons
 	}
 
 	ret = znode_rehash(node, &blk);
-      exit:
+exit:
 	if (ret) {
 		/* Get flush reserved block back if something fails, because
 		 * callers assume that on error block wasn't relocated and its
@@ -2838,11 +2913,11 @@ allocate_znode_update(znode * node, cons
    znode is returned but the coord is not set.  This function may cause atom
    fusion, but it is only used for read locks (at this point) and therefore
    fusion only occurs when the parent is already dirty. */
-/* Hans adds this note: remember to ask how expensive this operation is vs. storing parent
-   pointer in jnodes. */
+/* Hans adds this note: remember to ask how expensive this operation is vs.
+   storing parent pointer in jnodes. */
 static int
 jnode_lock_parent_coord(jnode * node,
-			coord_t * coord,
+			coord_t *coord,
 			lock_handle * parent_lh,
 			load_count * parent_zh,
 			znode_lock_mode parent_mode, int try)
@@ -2892,7 +2967,7 @@ jnode_lock_parent_coord(jnode * node,
 
 		ret = coord_by_key(jnode_get_tree(node), &key, coord, parent_lh,
 				   parent_mode, bias, stop_level, stop_level,
-				   CBK_UNIQUE, NULL /*ra_info */ );
+				   CBK_UNIQUE, NULL/*ra_info */);
 		switch (ret) {
 		case CBK_COORD_NOTFOUND:
 			assert("edward-1038",
@@ -2967,15 +3042,18 @@ jnode_lock_parent_coord(jnode * node,
 	return 0;
 }
 
-/* Get the (locked) next neighbor of a znode which is dirty and a member of the same atom.
-   If there is no next neighbor or the neighbor is not in memory or if there is a
-   neighbor but it is not dirty or not in the same atom, -E_NO_NEIGHBOR is returned.
-   In some cases the slum may include nodes which are not dirty, if so @check_dirty should be 0 */
+/* Get the (locked) next neighbor of a znode which is dirty and a member of the
+   same atom. If there is no next neighbor or the neighbor is not in memory or
+   if there is a neighbor but it is not dirty or not in the same atom,
+   -E_NO_NEIGHBOR is returned. In some cases the slum may include nodes which
+   are not dirty, if so @check_dirty should be 0 */
 static int neighbor_in_slum(znode * node,	/* starting point */
 			    lock_handle * lock,	/* lock on starting point */
-			    sideof side,	/* left or right direction we seek the next node in */
-			    znode_lock_mode mode,	/* kind of lock we want */
-			    int check_dirty, /* true if the neighbor should be dirty */
+			    sideof side,	/* left or right direction we
+						   seek the next node in */
+			    znode_lock_mode mode, /* kind of lock we want */
+			    int check_dirty, 	/* true if the neighbor should
+						   be dirty */
 			    int use_upper_levels /* get neighbor by going though
 						    upper levels */)
 {
@@ -2992,9 +3070,8 @@ static int neighbor_in_slum(znode * node
 	if (ret) {
 		/* May return -ENOENT or -E_NO_NEIGHBOR. */
 		/* FIXME(C): check EINVAL, E_DEADLOCK */
-		if (ret == -ENOENT) {
+		if (ret == -ENOENT)
 			ret = RETERR(-E_NO_NEIGHBOR);
-		}
 		return ret;
 	}
 	if (!check_dirty)
@@ -3007,8 +3084,8 @@ static int neighbor_in_slum(znode * node
 	return RETERR(-E_NO_NEIGHBOR);
 }
 
-/* Return true if two znodes have the same parent.  This is called with both nodes
-   write-locked (for squeezing) so no tree lock is needed. */
+/* Return true if two znodes have the same parent.  This is called with both
+   nodes write-locked (for squeezing) so no tree lock is needed. */
 static int znode_same_parents(znode * a, znode * b)
 {
 	int result;
@@ -3016,8 +3093,8 @@ static int znode_same_parents(znode * a,
 	assert("jmacd-7011", znode_is_write_locked(a));
 	assert("jmacd-7012", znode_is_write_locked(b));
 
-	/* We lock the whole tree for this check.... I really don't like whole tree
-	 * locks... -Hans */
+	/* We lock the whole tree for this check.... I really don't like whole
+	 * tree locks... -Hans */
 	read_lock_tree(znode_get_tree(a));
 	result = (znode_parent(a) == znode_parent(b));
 	read_unlock_tree(znode_get_tree(a));
@@ -3037,7 +3114,8 @@ static void scan_init(flush_scan * scan)
 	coord_init_invalid(&scan->parent_coord, NULL);
 }
 
-/* Release any resources held by the flush scan, e.g., release locks, free memory, etc. */
+/* Release any resources held by the flush scan, e.g. release locks,
+   free memory, etc. */
 static void scan_done(flush_scan * scan)
 {
 	done_load_count(&scan->node_load);
@@ -3057,8 +3135,9 @@ int reiser4_scan_finished(flush_scan * s
 			      scan->count >= scan->max_count);
 }
 
-/* Return true if the scan should continue to the @tonode.  True if the node meets the
-   same_slum_check condition.  If not, deref the "left" node and stop the scan. */
+/* Return true if the scan should continue to the @tonode. True if the node
+   meets the same_slum_check condition. If not, deref the "left" node and stop
+   the scan. */
 int reiser4_scan_goto(flush_scan * scan, jnode * tonode)
 {
 	int go = same_slum_check(scan->node, tonode, 1, 0);
@@ -3071,32 +3150,30 @@ int reiser4_scan_goto(flush_scan * scan,
 	return go;
 }
 
-/* Set the current scan->node, refcount it, increment count by the @add_count (number to
-   count, e.g., skipped unallocated nodes), deref previous current, and copy the current
-   parent coordinate. */
+/* Set the current scan->node, refcount it, increment count by the @add_count
+   (number to count, e.g., skipped unallocated nodes), deref previous current,
+   and copy the current parent coordinate. */
 int
 scan_set_current(flush_scan * scan, jnode * node, unsigned add_count,
-		 const coord_t * parent)
+		 const coord_t *parent)
 {
 	/* Release the old references, take the new reference. */
 	done_load_count(&scan->node_load);
 
-	if (scan->node != NULL) {
+	if (scan->node != NULL)
 		jput(scan->node);
-	}
 	scan->node = node;
 	scan->count += add_count;
 
-	/* This next stmt is somewhat inefficient.  The reiser4_scan_extent() code could
-	   delay this update step until it finishes and update the parent_coord only once.
-	   It did that before, but there was a bug and this was the easiest way to make it
-	   correct. */
-	if (parent != NULL) {
+	/* This next stmt is somewhat inefficient.  The reiser4_scan_extent()
+	   code could delay this update step until it finishes and update the
+	   parent_coord only once. It did that before, but there was a bug and
+	   this was the easiest way to make it correct. */
+	if (parent != NULL)
 		coord_dup(&scan->parent_coord, parent);
-	}
 
-	/* Failure may happen at the incr_load_count call, but the caller can assume the reference
-	   is safely taken. */
+	/* Failure may happen at the incr_load_count call, but the caller can
+	   assume the reference is safely taken. */
 	return incr_load_count_jnode(&scan->node_load, node);
 }
 
@@ -3106,37 +3183,41 @@ int reiser4_scanning_left(flush_scan * s
 	return scan->direction == LEFT_SIDE;
 }
 
-/* Performs leftward scanning starting from either kind of node.  Counts the starting
-   node.  The right-scan object is passed in for the left-scan in order to copy the parent
-   of an unformatted starting position.  This way we avoid searching for the unformatted
-   node's parent when scanning in each direction.  If we search for the parent once it is
-   set in both scan objects.  The limit parameter tells flush-scan when to stop.
-
-   Rapid scanning is used only during scan_left, where we are interested in finding the
-   'leftpoint' where we begin flushing.  We are interested in stopping at the left child
-   of a twig that does not have a dirty left neighbor.  THIS IS A SPECIAL CASE.  The
-   problem is finding a way to flush only those nodes without unallocated children, and it
-   is difficult to solve in the bottom-up flushing algorithm we are currently using.  The
-   problem can be solved by scanning left at every level as we go upward, but this would
-   basically bring us back to using a top-down allocation strategy, which we already tried
-   (see BK history from May 2002), and has a different set of problems.  The top-down
-   strategy makes avoiding unallocated children easier, but makes it difficult to
-   propertly flush dirty children with clean parents that would otherwise stop the
-   top-down flush, only later to dirty the parent once the children are flushed.  So we
-   solve the problem in the bottom-up algorithm with a special case for twigs and leaves
-   only.
-
-   The first step in solving the problem is this rapid leftward scan.  After we determine
-   that there are at least enough nodes counted to qualify for FLUSH_RELOCATE_THRESHOLD we
-   are no longer interested in the exact count, we are only interested in finding a the
-   best place to start the flush.  We could choose one of two possibilities:
-
-   1. Stop at the leftmost child (of a twig) that does not have a dirty left neighbor.
-   This requires checking one leaf per rapid-scan twig
-
-   2. Stop at the leftmost child (of a twig) where there are no dirty children of the twig
-   to the left.  This requires checking possibly all of the in-memory children of each
-   twig during the rapid scan.
+/* Performs leftward scanning starting from either kind of node. Counts the
+   starting node. The right-scan object is passed in for the left-scan in order
+   to copy the parent of an unformatted starting position. This way we avoid
+   searching for the unformatted node's parent when scanning in each direction.
+   If we search for the parent once it is set in both scan objects. The limit
+   parameter tells flush-scan when to stop.
+
+   Rapid scanning is used only during scan_left, where we are interested in
+   finding the 'leftpoint' where we begin flushing. We are interested in
+   stopping at the left child of a twig that does not have a dirty left
+   neighbour. THIS IS A SPECIAL CASE. The problem is finding a way to flush only
+   those nodes without unallocated children, and it is difficult to solve in the
+   bottom-up flushing algorithm we are currently using. The problem can be
+   solved by scanning left at every level as we go upward, but this would
+   basically bring us back to using a top-down allocation strategy, which we
+   already tried (see BK history from May 2002), and has a different set of
+   problems. The top-down strategy makes avoiding unallocated children easier,
+   but makes it difficult to propertly flush dirty children with clean parents
+   that would otherwise stop the top-down flush, only later to dirty the parent
+   once the children are flushed. So we solve the problem in the bottom-up
+   algorithm with a special case for twigs and leaves only.
+
+   The first step in solving the problem is this rapid leftward scan.  After we
+   determine that there are at least enough nodes counted to qualify for
+   FLUSH_RELOCATE_THRESHOLD we are no longer interested in the exact count, we
+   are only interested in finding the best place to start the flush.
+
+   We could choose one of two possibilities:
+
+   1. Stop at the leftmost child (of a twig) that does not have a dirty left
+   neighbor. This requires checking one leaf per rapid-scan twig
+
+   2. Stop at the leftmost child (of a twig) where there are no dirty children
+   of the twig to the left. This requires checking possibly all of the in-memory
+   children of each twig during the rapid scan.
 
    For now we implement the first policy.
 */
@@ -3149,35 +3230,35 @@ scan_left(flush_scan * scan, flush_scan 
 	scan->direction = LEFT_SIDE;
 
 	ret = scan_set_current(scan, jref(node), 1, NULL);
-	if (ret != 0) {
+	if (ret != 0)
 		return ret;
-	}
 
 	ret = scan_common(scan, right);
-	if (ret != 0) {
+	if (ret != 0)
 		return ret;
-	}
 
-	/* Before rapid scanning, we need a lock on scan->node so that we can get its
-	   parent, only if formatted. */
+	/* Before rapid scanning, we need a lock on scan->node so that we can
+	   get its parent, only if formatted. */
 	if (jnode_is_znode(scan->node)) {
 		ret = longterm_lock_znode(&scan->node_lock, JZNODE(scan->node),
 					  ZNODE_WRITE_LOCK, ZNODE_LOCK_LOPRI);
 	}
 
-	/* Rapid_scan would go here (with limit set to FLUSH_RELOCATE_THRESHOLD). */
+	/* Rapid_scan would go here (with limit set to FLUSH_RELOCATE_THRESHOLD)
+	*/
 	return ret;
 }
 
-/* Performs rightward scanning... Does not count the starting node.  The limit parameter
-   is described in scan_left.  If the starting node is unformatted then the
-   parent_coord was already set during scan_left.  The rapid_after parameter is not used
-   during right-scanning.
+/* Performs rightward scanning... Does not count the starting node. The limit
+   parameter is described in scan_left. If the starting node is unformatted then
+   the parent_coord was already set during scan_left. The rapid_after parameter
+   is not used during right-scanning.
 
    scan_right is only called if the scan_left operation does not count at least
-   FLUSH_RELOCATE_THRESHOLD nodes for flushing.  Otherwise, the limit parameter is set to
-   the difference between scan-left's count and FLUSH_RELOCATE_THRESHOLD, meaning
-   scan-right counts as high as FLUSH_RELOCATE_THRESHOLD and then stops. */
+   FLUSH_RELOCATE_THRESHOLD nodes for flushing.  Otherwise, the limit parameter
+   is set to the difference between scan-left's count and
+   FLUSH_RELOCATE_THRESHOLD, meaning scan-right counts as high as
+   FLUSH_RELOCATE_THRESHOLD and then stops. */
 static int scan_right(flush_scan * scan, jnode * node, unsigned limit)
 {
 	int ret;
@@ -3186,9 +3267,8 @@ static int scan_right(flush_scan * scan,
 	scan->direction = RIGHT_SIDE;
 
 	ret = scan_set_current(scan, jref(node), 0, NULL);
-	if (ret != 0) {
+	if (ret != 0)
 		return ret;
-	}
 
 	return scan_common(scan, NULL);
 }
@@ -3202,24 +3282,24 @@ static int scan_common(flush_scan * scan
 	assert("edward-54", jnode_is_unformatted(scan->node)
 	       || jnode_is_znode(scan->node));
 
-	/* Special case for starting at an unformatted node.  Optimization: we only want
-	   to search for the parent (which requires a tree traversal) once.  Obviously, we
-	   shouldn't have to call it once for the left scan and once for the right scan.
-	   For this reason, if we search for the parent during scan-left we then duplicate
-	   the coord/lock/load into the scan-right object. */
+	/* Special case for starting at an unformatted node. Optimization: we
+	   only want to search for the parent (which requires a tree traversal)
+	   once. Obviously, we shouldn't have to call it once for the left scan
+	   and once for the right scan. For this reason, if we search for the
+	   parent during scan-left we then duplicate the coord/lock/load into
+	   the scan-right object. */
 	if (jnode_is_unformatted(scan->node)) {
 		ret = scan_unformatted(scan, other);
 		if (ret != 0)
 			return ret;
 	}
-	/* This loop expects to start at a formatted position and performs chaining of
-	   formatted regions */
+	/* This loop expects to start at a formatted position and performs
+	   chaining of formatted regions */
 	while (!reiser4_scan_finished(scan)) {
 
 		ret = scan_formatted(scan);
-		if (ret != 0) {
+		if (ret != 0)
 			return ret;
-		}
 	}
 
 	return 0;
@@ -3263,8 +3343,9 @@ static int scan_unformatted(flush_scan *
 					ZNODE_LOCK_LOPRI :
 					ZNODE_LOCK_HIPRI);
 		if (ret != 0)
-			/* EINVAL or E_DEADLOCK here mean... try again!  At this point we've
-			   scanned too far and can't back out, just start over. */
+			/* EINVAL or E_DEADLOCK here mean... try again!  At this
+			   point we've scanned too far and can't back out, just
+			   start over. */
 			return ret;
 
 		ret = jnode_lock_parent_coord(scan->node,
@@ -3305,12 +3386,12 @@ static int scan_unformatted(flush_scan *
 		copy_lh(&other->parent_lock, &scan->parent_lock);
 		copy_load_count(&other->parent_load, &scan->parent_load);
 	}
-      scan:
+scan:
 	return scan_by_coord(scan);
 }
 
-/* Performs left- or rightward scanning starting from a formatted node. Follow left
-   pointers under tree lock as long as:
+/* Performs left- or rightward scanning starting from a formatted node. Follow
+   left pointers under tree lock as long as:
 
    - node->left/right is non-NULL
    - node->left/right is connected, dirty
@@ -3336,41 +3417,38 @@ static int scan_formatted(flush_scan * s
 		/* Lock the tree, check-for and reference the next sibling. */
 		read_lock_tree(znode_get_tree(node));
 
-		/* It may be that a node is inserted or removed between a node and its
-		   left sibling while the tree lock is released, but the flush-scan count
-		   does not need to be precise.  Thus, we release the tree lock as soon as
-		   we get the neighboring node. */
+		/* It may be that a node is inserted or removed between a node
+		   and its left sibling while the tree lock is released, but the
+		   flush-scan count does not need to be precise. Thus, we
+		   release the tree lock as soon as we get the neighboring node.
+		*/
 		neighbor =
 			reiser4_scanning_left(scan) ? node->left : node->right;
-		if (neighbor != NULL) {
+		if (neighbor != NULL)
 			zref(neighbor);
-		}
 
 		read_unlock_tree(znode_get_tree(node));
 
-		/* If neighbor is NULL at the leaf level, need to check for an unformatted
-		   sibling using the parent--break in any case. */
-		if (neighbor == NULL) {
+		/* If neighbor is NULL at the leaf level, need to check for an
+		   unformatted sibling using the parent--break in any case. */
+		if (neighbor == NULL)
 			break;
-		}
 
-		/* Check the condition for going left, break if it is not met.  This also
-		   releases (jputs) the neighbor if false. */
-		if (!reiser4_scan_goto(scan, ZJNODE(neighbor))) {
+		/* Check the condition for going left, break if it is not met.
+		   This also releases (jputs) the neighbor if false. */
+		if (!reiser4_scan_goto(scan, ZJNODE(neighbor)))
 			break;
-		}
 
 		/* Advance the flush_scan state to the left, repeat. */
 		ret = scan_set_current(scan, ZJNODE(neighbor), 1, NULL);
-		if (ret != 0) {
+		if (ret != 0)
 			return ret;
-		}
 
 	} while (!reiser4_scan_finished(scan));
 
-	/* If neighbor is NULL then we reached the end of a formatted region, or else the
-	   sibling is out of memory, now check for an extent to the left (as long as
-	   LEAF_LEVEL). */
+	/* If neighbor is NULL then we reached the end of a formatted region, or
+	   else the sibling is out of memory, now check for an extent to the
+	   left (as long as LEAF_LEVEL). */
 	if (neighbor != NULL || jnode_get_level(scan->node) != LEAF_LEVEL
 	    || reiser4_scan_finished(scan)) {
 		scan->stop = 1;
@@ -3384,12 +3462,13 @@ static int scan_formatted(flush_scan * s
 }
 
 /* NOTE-EDWARD:
-   This scans adjacent items of the same type and calls scan flush plugin for each one.
-   Performs left(right)ward scanning starting from a (possibly) unformatted node.  If we start
-   from unformatted node, then we continue only if the next neighbor is also unformatted.
-   When called from scan_formatted, we skip first iteration (to make sure that
-   right(left)most item of the left(right) neighbor on the parent level is of the same
-   type and set appropriate coord). */
+   This scans adjacent items of the same type and calls scan flush plugin for
+   each one. Performs left(right)ward scanning starting from a (possibly)
+   unformatted node. If we start from unformatted node, then we continue only if
+   the next neighbor is also unformatted. When called from scan_formatted, we
+   skip first iteration (to make sure that right(left)most item of the
+   left(right) neighbor on the parent level is of the same type and set
+   appropriate coord). */
 static int scan_by_coord(flush_scan * scan)
 {
 	int ret = 0;
@@ -3409,8 +3488,8 @@ static int scan_by_coord(flush_scan * sc
 
 	for (; !reiser4_scan_finished(scan); scan_this_coord = 1) {
 		if (scan_this_coord) {
-			/* Here we expect that unit is scannable. it would not be so due
-			 * to race with extent->tail conversion.  */
+			/* Here we expect that unit is scannable. it would not
+			 * be so due to race with extent->tail conversion.  */
 			if (iplug->f.scan == NULL) {
 				scan->stop = 1;
 				ret = -E_REPEAT;
@@ -3430,8 +3509,8 @@ static int scan_by_coord(flush_scan * sc
 			/* the same race against truncate as above is possible
 			 * here, it seems */
 
-			/* NOTE-JMACD: In this case, apply the same end-of-node logic but don't scan
-			   the first coordinate. */
+			/* NOTE-JMACD: In this case, apply the same end-of-node
+			   logic but don't scan the first coordinate. */
 			assert("jmacd-1231",
 			       item_is_internal(&scan->parent_coord));
 		}
@@ -3449,15 +3528,15 @@ static int scan_by_coord(flush_scan * sc
 			break;
 		}
 
-		/* Either way, the invariant is that scan->parent_coord is set to the
-		   parent of scan->node. Now get the next unit. */
+		/* Either way, the invariant is that scan->parent_coord is set
+		   to the parent of scan->node. Now get the next unit. */
 		coord_dup(&next_coord, &scan->parent_coord);
 		coord_sideof_unit(&next_coord, scan->direction);
 
 		/* If off-the-end of the twig, try the next twig. */
 		if (coord_is_after_sideof_unit(&next_coord, scan->direction)) {
-			/* We take the write lock because we may start flushing from this
-			 * coordinate. */
+			/* We take the write lock because we may start flushing
+			 * from this coordinate. */
 			ret = neighbor_in_slum(next_coord.node,
 					       &next_lock,
 					       scan->direction,
@@ -3471,14 +3550,12 @@ static int scan_by_coord(flush_scan * sc
 				break;
 			}
 
-			if (ret != 0) {
+			if (ret != 0)
 				goto exit;
-			}
 
 			ret = incr_load_count_znode(&next_load, next_lock.node);
-			if (ret != 0) {
+			if (ret != 0)
 				goto exit;
-			}
 
 			coord_init_sideof_unit(&next_coord, next_lock.node,
 					       sideof_reverse(scan->direction));
@@ -3516,8 +3593,8 @@ static int scan_by_coord(flush_scan * sc
 		if (ret != 0)
 			goto exit;
 
-		/* Now continue.  If formatted we release the parent lock and return, then
-		   proceed. */
+		/* Now continue.  If formatted we release the parent lock and
+		   return, then proceed. */
 		if (jnode_is_znode(child))
 			break;
 
@@ -3531,9 +3608,9 @@ static int scan_by_coord(flush_scan * sc
 
 	assert("jmacd-6233",
 	       reiser4_scan_finished(scan) || jnode_is_znode(scan->node));
-      exit:
+exit:
 	checkchild(scan);
-      race:			/* skip the above check  */
+race:			/* skip the above check  */
 	if (jnode_is_znode(scan->node)) {
 		done_lh(&scan->parent_lock);
 		done_load_count(&scan->parent_load);
@@ -3547,7 +3624,7 @@ static int scan_by_coord(flush_scan * sc
 /* FLUSH POS HELPERS */
 
 /* Initialize the fields of a flush_position. */
-static void pos_init(flush_pos_t * pos)
+static void pos_init(flush_pos_t *pos)
 {
 	memset(pos, 0, sizeof *pos);
 
@@ -3559,25 +3636,26 @@ static void pos_init(flush_pos_t * pos)
 	reiser4_blocknr_hint_init(&pos->preceder);
 }
 
-/* The flush loop inside squalloc periodically checks pos_valid to
-   determine when "enough flushing" has been performed.  This will return true until one
+/* The flush loop inside squalloc periodically checks pos_valid to determine
+   when "enough flushing" has been performed. This will return true until one
    of the following conditions is met:
 
-   1. the number of flush-queued nodes has reached the kernel-supplied "int *nr_to_flush"
-   parameter, meaning we have flushed as many blocks as the kernel requested.  When
-   flushing to commit, this parameter is NULL.
+   1. the number of flush-queued nodes has reached the kernel-supplied
+   "int *nr_to_flush" parameter, meaning we have flushed as many blocks as the
+   kernel requested. When flushing to commit, this parameter is NULL.
 
-   2. pos_stop() is called because squalloc discovers that the "next" node in the
-   flush order is either non-existant, not dirty, or not in the same atom.
+   2. pos_stop() is called because squalloc discovers that the "next" node in
+   the flush order is either non-existant, not dirty, or not in the same atom.
 */
 
-static int pos_valid(flush_pos_t * pos)
+static int pos_valid(flush_pos_t *pos)
 {
 	return pos->state != POS_INVALID;
 }
 
-/* Release any resources of a flush_position.  Called when jnode_flush finishes. */
-static void pos_done(flush_pos_t * pos)
+/* Release any resources of a flush_position. Called when jnode_flush
+   finishes. */
+static void pos_done(flush_pos_t *pos)
 {
 	pos_stop(pos);
 	reiser4_blocknr_hint_done(&pos->preceder);
@@ -3587,7 +3665,7 @@ static void pos_done(flush_pos_t * pos)
 
 /* Reset the point and parent.  Called during flush subroutines to terminate the
    squalloc loop. */
-static int pos_stop(flush_pos_t * pos)
+static int pos_stop(flush_pos_t *pos)
 {
 	pos->state = POS_INVALID;
 	done_lh(&pos->lock);
@@ -3603,12 +3681,12 @@ static int pos_stop(flush_pos_t * pos)
 }
 
 /* Return the flush_position's block allocator hint. */
-reiser4_blocknr_hint *reiser4_pos_hint(flush_pos_t * pos)
+reiser4_blocknr_hint *reiser4_pos_hint(flush_pos_t *pos)
 {
 	return &pos->preceder;
 }
 
-flush_queue_t * reiser4_pos_fq(flush_pos_t * pos)
+flush_queue_t *reiser4_pos_fq(flush_pos_t *pos)
 {
 	return pos->fq;
 }
diff -puN fs/reiser4/flush.h~reiser4-code-cleanups fs/reiser4/flush.h
--- a/fs/reiser4/flush.h~reiser4-code-cleanups
+++ a/fs/reiser4/flush.h
@@ -7,41 +7,45 @@
 
 #include "plugin/cluster.h"
 
-/* The flush_scan data structure maintains the state of an in-progress flush-scan on a
-   single level of the tree.  A flush-scan is used for counting the number of adjacent
-   nodes to flush, which is used to determine whether we should relocate, and it is also
-   used to find a starting point for flush.  A flush-scan object can scan in both right
-   and left directions via the scan_left() and scan_right() interfaces.  The
-   right- and left-variations are similar but perform different functions.  When scanning
-   left we (optionally perform rapid scanning and then) longterm-lock the endpoint node.
-   When scanning right we are simply counting the number of adjacent, dirty nodes. */
+/* The flush_scan data structure maintains the state of an in-progress
+   flush-scan on a single level of the tree. A flush-scan is used for counting
+   the number of adjacent nodes to flush, which is used to determine whether we
+   should relocate, and it is also used to find a starting point for flush. A
+   flush-scan object can scan in both right and left directions via the
+   scan_left() and scan_right() interfaces. The right- and left-variations are
+   similar but perform different functions. When scanning left we (optionally
+   perform rapid scanning and then) longterm-lock the endpoint node. When
+   scanning right we are simply counting the number of adjacent, dirty nodes. */
 struct flush_scan {
 
 	/* The current number of nodes scanned on this level. */
 	unsigned count;
 
-	/* There may be a maximum number of nodes for a scan on any single level.  When
-	   going leftward, max_count is determined by FLUSH_SCAN_MAXNODES (see reiser4.h) */
+	/* There may be a maximum number of nodes for a scan on any single
+	   level. When going leftward, max_count is determined by
+	   FLUSH_SCAN_MAXNODES (see reiser4.h) */
 	unsigned max_count;
 
-	/* Direction: Set to one of the sideof enumeration: { LEFT_SIDE, RIGHT_SIDE }. */
+	/* Direction: Set to one of the sideof enumeration:
+	   { LEFT_SIDE, RIGHT_SIDE }. */
 	sideof direction;
 
-	/* Initially @stop is set to false then set true once some condition stops the
-	   search (e.g., we found a clean node before reaching max_count or we found a
-	   node belonging to another atom). */
+	/* Initially @stop is set to false then set true once some condition
+	   stops the search (e.g., we found a clean node before reaching
+	   max_count or we found a node belonging to another atom). */
 	int stop;
 
-	/* The current scan position.  If @node is non-NULL then its reference count has
-	   been incremented to reflect this reference. */
+	/* The current scan position.  If @node is non-NULL then its reference
+	   count has been incremented to reflect this reference. */
 	jnode *node;
 
 	/* A handle for zload/zrelse of current scan position node. */
 	load_count node_load;
 
-	/* During left-scan, if the final position (a.k.a. endpoint node) is formatted the
-	   node is locked using this lock handle.  The endpoint needs to be locked for
-	   transfer to the flush_position object after scanning finishes. */
+	/* During left-scan, if the final position (a.k.a. endpoint node) is
+	   formatted the node is locked using this lock handle. The endpoint
+	   needs to be locked for transfer to the flush_position object after
+	   scanning finishes. */
 	lock_handle node_lock;
 
 	/* When the position is unformatted, its parent, coordinate, and parent
@@ -50,9 +54,10 @@ struct flush_scan {
 	coord_t parent_coord;
 	load_count parent_load;
 
-	/* The block allocator preceder hint.  Sometimes flush_scan determines what the
-	   preceder is and if so it sets it here, after which it is copied into the
-	   flush_position.  Otherwise, the preceder is computed later. */
+	/* The block allocator preceder hint.  Sometimes flush_scan determines
+	   what the preceder is and if so it sets it here, after which it is
+	   copied into the flush_position. Otherwise, the preceder is computed
+	   later. */
 	reiser4_block_nr preceder_blk;
 };
 
@@ -73,35 +78,39 @@ struct convert_info {
 typedef enum flush_position_state {
 	POS_INVALID,		/* Invalid or stopped pos, do not continue slum
 				 * processing */
-	POS_ON_LEAF,		/* pos points to already prepped, locked formatted node at
-				 * leaf level */
-	POS_ON_EPOINT,		/* pos keeps a lock on twig level, "coord" field is used
-				 * to traverse unformatted nodes */
+	POS_ON_LEAF,		/* pos points to already prepped, locked
+				 * formatted node at leaf level */
+	POS_ON_EPOINT,		/* pos keeps a lock on twig level, "coord" field
+				 * is used to traverse unformatted nodes */
 	POS_TO_LEAF,		/* pos is being moved to leaf level */
 	POS_TO_TWIG,		/* pos is being moved to twig level */
-	POS_END_OF_TWIG,	/* special case of POS_ON_TWIG, when coord is after
-				 * rightmost unit of the current twig */
-	POS_ON_INTERNAL		/* same as POS_ON_LEAF, but points to internal node */
+	POS_END_OF_TWIG,	/* special case of POS_ON_TWIG, when coord is
+				 * after rightmost unit of the current twig */
+	POS_ON_INTERNAL		/* same as POS_ON_LEAF, but points to internal
+				 * node */
 } flushpos_state_t;
 
-/* An encapsulation of the current flush point and all the parameters that are passed
-   through the entire squeeze-and-allocate stage of the flush routine.  A single
-   flush_position object is constructed after left- and right-scanning finishes. */
+/* An encapsulation of the current flush point and all the parameters that are
+   passed through the entire squeeze-and-allocate stage of the flush routine.
+   A single flush_position object is constructed after left- and right-scanning
+   finishes. */
 struct flush_position {
 	flushpos_state_t state;
 
 	coord_t coord;		/* coord to traverse unformatted nodes */
 	lock_handle lock;	/* current lock we hold */
-	load_count load;	/* load status for current locked formatted node  */
-
+	load_count load;	/* load status for current locked formatted node
+				*/
 	jnode *child;		/* for passing a reference to unformatted child
 				 * across pos state changes */
 
 	reiser4_blocknr_hint preceder;	/* The flush 'hint' state. */
 	int leaf_relocate;	/* True if enough leaf-level nodes were
 				 * found to suggest a relocate policy. */
-	int alloc_cnt;		/* The number of nodes allocated during squeeze and allococate. */
-	int prep_or_free_cnt;	/* The number of nodes prepared for write (allocate) or squeezed and freed. */
+	int alloc_cnt;		/* The number of nodes allocated during squeeze
+				   and allococate. */
+	int prep_or_free_cnt;	/* The number of nodes prepared for write
+				   (allocate) or squeezed and freed. */
 	flush_queue_t *fq;
 	long *nr_written;	/* number of nodes submitted to disk */
 	int flags;		/* a copy of jnode_flush flags argument */
@@ -113,50 +122,51 @@ struct flush_position {
 	unsigned long pos_in_unit;	/* for extents only. Position
 					   within an extent unit of first
 					   jnode of slum */
-	long nr_to_write;	/* number of unformatted nodes to handle on flush */
+	long nr_to_write;	/* number of unformatted nodes to handle on
+				   flush */
 };
 
-static inline int item_convert_count(flush_pos_t * pos)
+static inline int item_convert_count(flush_pos_t *pos)
 {
 	return pos->sq->count;
 }
-static inline void inc_item_convert_count(flush_pos_t * pos)
+static inline void inc_item_convert_count(flush_pos_t *pos)
 {
 	pos->sq->count++;
 }
-static inline void set_item_convert_count(flush_pos_t * pos, int count)
+static inline void set_item_convert_count(flush_pos_t *pos, int count)
 {
 	pos->sq->count = count;
 }
-static inline item_plugin *item_convert_plug(flush_pos_t * pos)
+static inline item_plugin *item_convert_plug(flush_pos_t *pos)
 {
 	return pos->sq->iplug;
 }
 
-static inline struct convert_info *convert_data(flush_pos_t * pos)
+static inline struct convert_info *convert_data(flush_pos_t *pos)
 {
 	return pos->sq;
 }
 
-static inline struct convert_item_info *item_convert_data(flush_pos_t * pos)
+static inline struct convert_item_info *item_convert_data(flush_pos_t *pos)
 {
 	assert("edward-955", convert_data(pos));
 	return pos->sq->itm;
 }
 
-static inline struct tfm_cluster * tfm_cluster_sq(flush_pos_t * pos)
+static inline struct tfm_cluster *tfm_cluster_sq(flush_pos_t *pos)
 {
 	return &pos->sq->clust.tc;
 }
 
-static inline struct tfm_stream * tfm_stream_sq(flush_pos_t * pos,
+static inline struct tfm_stream *tfm_stream_sq(flush_pos_t *pos,
 						tfm_stream_id id)
 {
 	assert("edward-854", pos->sq != NULL);
 	return get_tfm_stream(tfm_cluster_sq(pos), id);
 }
 
-static inline int chaining_data_present(flush_pos_t * pos)
+static inline int chaining_data_present(flush_pos_t *pos)
 {
 	return convert_data(pos) && item_convert_data(pos);
 }
@@ -164,7 +174,7 @@ static inline int chaining_data_present(
 /* Returns true if next node contains next item of the disk cluster
    so item convert data should be moved to the right slum neighbor.
 */
-static inline int should_chain_next_node(flush_pos_t * pos)
+static inline int should_chain_next_node(flush_pos_t *pos)
 {
 	int result = 0;
 
@@ -184,7 +194,7 @@ static inline int should_chain_next_node
 
 /* update item state in a disk cluster to assign conversion mode */
 static inline void
-move_chaining_data(flush_pos_t * pos, int this_node /* where is next item */ )
+move_chaining_data(flush_pos_t *pos, int this_node/* where is next item */)
 {
 
 	assert("edward-1010", chaining_data_present(pos));
@@ -213,20 +223,20 @@ move_chaining_data(flush_pos_t * pos, in
 	}
 }
 
-static inline int should_convert_node(flush_pos_t * pos, znode * node)
+static inline int should_convert_node(flush_pos_t *pos, znode * node)
 {
 	return znode_convertible(node);
 }
 
 /* true if there is attached convert item info */
-static inline int should_convert_next_node(flush_pos_t * pos)
+static inline int should_convert_next_node(flush_pos_t *pos)
 {
 	return convert_data(pos) && item_convert_data(pos);
 }
 
 #define SQUALLOC_THRESHOLD 256
 
-static inline int should_terminate_squalloc(flush_pos_t * pos)
+static inline int should_terminate_squalloc(flush_pos_t *pos)
 {
 	return convert_data(pos) &&
 	    !item_convert_data(pos) &&
@@ -236,7 +246,7 @@ static inline int should_terminate_squal
 #if 1
 #define check_convert_info(pos)						\
 do {							        	\
-	if (unlikely(should_convert_next_node(pos))){			\
+	if (unlikely(should_convert_next_node(pos))) {			\
 		warning("edward-1006", "unprocessed chained data");	\
 		printk("d_cur = %d, d_next = %d, flow.len = %llu\n",	\
 		       item_convert_data(pos)->d_cur,			\
@@ -248,14 +258,14 @@ do {							        	\
 #define check_convert_info(pos)
 #endif /* REISER4_DEBUG */
 
-void free_convert_data(flush_pos_t * pos);
+void free_convert_data(flush_pos_t *pos);
 /* used in extent.c */
 int scan_set_current(flush_scan * scan, jnode * node, unsigned add_size,
-		     const coord_t * parent);
+		     const coord_t *parent);
 int reiser4_scan_finished(flush_scan * scan);
 int reiser4_scanning_left(flush_scan * scan);
 int reiser4_scan_goto(flush_scan * scan, jnode * tonode);
-txn_atom *atom_locked_by_fq(flush_queue_t * fq);
+txn_atom *atom_locked_by_fq(flush_queue_t *fq);
 int reiser4_alloc_extent(flush_pos_t *flush_pos);
 squeeze_result squalloc_extent(znode *left, const coord_t *, flush_pos_t *,
 			       reiser4_key *stop_key);
@@ -269,7 +279,7 @@ extern atomic_t flush_cnt;
 
 #define check_preceder(blk) \
 assert("nikita-2588", blk < reiser4_block_count(reiser4_get_current_sb()));
-extern void check_pos(flush_pos_t * pos);
+extern void check_pos(flush_pos_t *pos);
 #else
 #define check_preceder(b) noop
 #define check_pos(pos) noop
diff -puN fs/reiser4/flush_queue.c~reiser4-code-cleanups fs/reiser4/flush_queue.c
--- a/fs/reiser4/flush_queue.c~reiser4-code-cleanups
+++ a/fs/reiser4/flush_queue.c
@@ -1,4 +1,5 @@
-/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
+/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
+   reiser4/README */
 
 #include "debug.h"
 #include "super.h"
@@ -50,7 +51,7 @@
 #define mark_fq_ready(fq)      do { (fq)->state &= ~FQ_IN_USE;   } while (0)
 
 /* get lock on atom from locked flush queue object */
-static txn_atom *atom_locked_by_fq_nolock(flush_queue_t * fq)
+static txn_atom *atom_locked_by_fq_nolock(flush_queue_t *fq)
 {
 	/* This code is similar to jnode_get_atom(), look at it for the
 	 * explanation. */
@@ -84,7 +85,7 @@ static txn_atom *atom_locked_by_fq_noloc
 	return atom;
 }
 
-txn_atom *atom_locked_by_fq(flush_queue_t * fq)
+txn_atom *atom_locked_by_fq(flush_queue_t *fq)
 {
 	txn_atom *atom;
 
@@ -94,7 +95,7 @@ txn_atom *atom_locked_by_fq(flush_queue_
 	return atom;
 }
 
-static void init_fq(flush_queue_t * fq)
+static void init_fq(flush_queue_t *fq)
 {
 	memset(fq, 0, sizeof *fq);
 
@@ -148,12 +149,12 @@ static flush_queue_t *create_fq(gfp_t gf
 }
 
 /* adjust atom's and flush queue's counters of queued nodes */
-static void count_enqueued_node(flush_queue_t * fq)
+static void count_enqueued_node(flush_queue_t *fq)
 {
 	ON_DEBUG(fq->atom->num_queued++);
 }
 
-static void count_dequeued_node(flush_queue_t * fq)
+static void count_dequeued_node(flush_queue_t *fq)
 {
 	assert("zam-993", fq->atom->num_queued > 0);
 	ON_DEBUG(fq->atom->num_queued--);
@@ -168,7 +169,7 @@ static void attach_fq(txn_atom *atom, fl
 	ON_DEBUG(atom->nr_flush_queues++);
 }
 
-static void detach_fq(flush_queue_t * fq)
+static void detach_fq(flush_queue_t *fq)
 {
 	assert_spin_locked(&(fq->atom->alock));
 
@@ -181,7 +182,7 @@ static void detach_fq(flush_queue_t * fq
 }
 
 /* destroy flush queue object */
-static void done_fq(flush_queue_t * fq)
+static void done_fq(flush_queue_t *fq)
 {
 	assert("zam-763", list_empty_careful(ATOM_FQ_LIST(fq)));
 	assert("zam-766", atomic_read(&fq->nr_submitted) == 0);
@@ -190,7 +191,7 @@ static void done_fq(flush_queue_t * fq)
 }
 
 /* */
-static void mark_jnode_queued(flush_queue_t * fq, jnode * node)
+static void mark_jnode_queued(flush_queue_t *fq, jnode * node)
 {
 	JF_SET(node, JNODE_FLUSH_QUEUED);
 	count_enqueued_node(fq);
@@ -198,7 +199,7 @@ static void mark_jnode_queued(flush_queu
 
 /* Putting jnode into the flush queue. Both atom and jnode should be
    spin-locked. */
-void queue_jnode(flush_queue_t * fq, jnode * node)
+void queue_jnode(flush_queue_t *fq, jnode * node)
 {
 	assert_spin_locked(&(node->guard));
 	assert("zam-713", node->atom != NULL);
@@ -220,7 +221,7 @@ void queue_jnode(flush_queue_t * fq, jno
 }
 
 /* repeatable process for waiting io completion on a flush queue object */
-static int wait_io(flush_queue_t * fq, int *nr_io_errors)
+static int wait_io(flush_queue_t *fq, int *nr_io_errors)
 {
 	assert("zam-738", fq->atom != NULL);
 	assert_spin_locked(&(fq->atom->alock));
@@ -240,7 +241,8 @@ static int wait_io(flush_queue_t * fq, i
 		blk_run_address_space(reiser4_get_super_fake(super)->i_mapping);
 
 		if (!(super->s_flags & MS_RDONLY))
-			wait_event(fq->wait, atomic_read(&fq->nr_submitted) == 0);
+			wait_event(fq->wait,
+				   atomic_read(&fq->nr_submitted) == 0);
 
 		/* Ask the caller to re-acquire the locks and call this
 		   function again. Note: this technique is commonly used in
@@ -253,7 +255,7 @@ static int wait_io(flush_queue_t * fq, i
 }
 
 /* wait on I/O completion, re-submit dirty nodes to write */
-static int finish_fq(flush_queue_t * fq, int *nr_io_errors)
+static int finish_fq(flush_queue_t *fq, int *nr_io_errors)
 {
 	int ret;
 	txn_atom *atom = fq->atom;
@@ -446,7 +448,7 @@ end_io_handler(struct bio *bio, int err)
 
 /* Count I/O requests which will be submitted by @bio in given flush queues
    @fq */
-void add_fq_to_bio(flush_queue_t * fq, struct bio *bio)
+void add_fq_to_bio(flush_queue_t *fq, struct bio *bio)
 {
 	bio->bi_private = fq;
 	bio->bi_end_io = end_io_handler;
@@ -456,7 +458,7 @@ void add_fq_to_bio(flush_queue_t * fq, s
 }
 
 /* Move all queued nodes out from @fq->prepped list. */
-static void release_prepped_list(flush_queue_t * fq)
+static void release_prepped_list(flush_queue_t *fq)
 {
 	txn_atom *atom;
 
@@ -478,11 +480,13 @@ static void release_prepped_list(flush_q
 
 		if (JF_ISSET(cur, JNODE_DIRTY)) {
 			list_add_tail(&cur->capture_link,
-				      ATOM_DIRTY_LIST(atom, jnode_get_level(cur)));
+				      ATOM_DIRTY_LIST(atom,
+						      jnode_get_level(cur)));
 			ON_DEBUG(count_jnode(atom, cur, FQ_LIST,
 					     DIRTY_LIST, 1));
 		} else {
-			list_add_tail(&cur->capture_link, ATOM_CLEAN_LIST(atom));
+			list_add_tail(&cur->capture_link,
+				      ATOM_CLEAN_LIST(atom));
 			ON_DEBUG(count_jnode(atom, cur, FQ_LIST,
 					     CLEAN_LIST, 1));
 		}
@@ -500,8 +504,8 @@ static void release_prepped_list(flush_q
 
    @fq: flush queue object which contains jnodes we can (and will) write.
    @return: number of submitted blocks (>=0) if success, otherwise -- an error
-            code (<0). */
-int reiser4_write_fq(flush_queue_t * fq, long *nr_submitted, int flags)
+	    code (<0). */
+int reiser4_write_fq(flush_queue_t *fq, long *nr_submitted, int flags)
 {
 	int ret;
 	txn_atom *atom;
@@ -581,7 +585,7 @@ static int fq_by_atom_gfp(txn_atom *atom
 	return RETERR(-E_REPEAT);
 }
 
-int reiser4_fq_by_atom(txn_atom * atom, flush_queue_t ** new_fq)
+int reiser4_fq_by_atom(txn_atom * atom, flush_queue_t **new_fq)
 {
 	return fq_by_atom_gfp(atom, new_fq, reiser4_ctx_gfp_mask_get());
 }
@@ -614,7 +618,7 @@ void reiser4_fq_put_nolock(flush_queue_t
 	ON_DEBUG(fq->owner = NULL);
 }
 
-void reiser4_fq_put(flush_queue_t * fq)
+void reiser4_fq_put(flush_queue_t *fq)
 {
 	txn_atom *atom;
 
diff -puN fs/reiser4/forward.h~reiser4-code-cleanups fs/reiser4/forward.h
--- a/fs/reiser4/forward.h~reiser4-code-cleanups
+++ a/fs/reiser4/forward.h
@@ -1,8 +1,9 @@
-/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
+/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
+   reiser4/README */
 
 /* Forward declarations. Thank you Kernighan. */
 
-#if !defined( __REISER4_FORWARD_H__ )
+#if !defined(__REISER4_FORWARD_H__)
 #define __REISER4_FORWARD_H__
 
 #include <asm/errno.h>
@@ -73,8 +74,10 @@ typedef enum {
 typedef enum {
 	FILE_NAME_FOUND = 0,
 	FILE_NAME_NOTFOUND = -ENOENT,
-	FILE_IO_ERROR = -EIO,	/* FIXME: it seems silly to have special OOM, IO_ERROR return codes for each search. */
-	FILE_OOM = -ENOMEM	/* FIXME: it seems silly to have special OOM, IO_ERROR return codes for each search. */
+	FILE_IO_ERROR = -EIO,	/* FIXME: it seems silly to have special OOM,
+				   IO_ERROR return codes for each search. */
+	FILE_OOM = -ENOMEM	/* FIXME: it seems silly to have special OOM,
+				   IO_ERROR return codes for each search. */
 } file_lookup_result;
 
 /* behaviors of lookup. If coord we are looking for is actually in a tree,
@@ -131,9 +134,10 @@ typedef enum {
 	ZNODE_LOCK_LOPRI = 0,
 	ZNODE_LOCK_HIPRI = (1 << 0),
 
-	/* By setting the ZNODE_LOCK_NONBLOCK flag in a lock request the call to longterm_lock_znode will not sleep
-	   waiting for the lock to become available.  If the lock is unavailable, reiser4_znode_lock will immediately
-	   return the value -E_REPEAT. */
+	/* By setting the ZNODE_LOCK_NONBLOCK flag in a lock request the call to
+	   longterm_lock_znode will not sleep waiting for the lock to become
+	   available.  If the lock is unavailable, reiser4_znode_lock will
+	   immediately return the value -E_REPEAT. */
 	ZNODE_LOCK_NONBLOCK = (1 << 1),
 	/* An option for longterm_lock_znode which prevents atom fusion */
 	ZNODE_LOCK_DONT_FUSE = (1 << 2)
@@ -152,9 +156,9 @@ typedef enum {
 	RIGHT_SIDE
 } sideof;
 
-#define round_up( value, order )						\
-	( ( typeof( value ) )( ( ( long ) ( value ) + ( order ) - 1U ) &	\
-			     ~( ( order ) - 1 ) ) )
+#define round_up(value, order)						\
+	((typeof(value))(((long) (value) + (order) - 1U) &	\
+			     ~((order) - 1)))
 
 /* values returned by squalloc_right_neighbor and its auxiliary functions */
 typedef enum {
@@ -182,8 +186,8 @@ typedef enum {
 	LAST_ITEM_ID = 0x9
 } item_id;
 
-/* Flags passed to jnode_flush() to allow it to distinguish default settings based on
-   whether commit() was called or VM memory pressure was applied. */
+/* Flags passed to jnode_flush() to allow it to distinguish default settings
+   based on whether commit() was called or VM memory pressure was applied. */
 typedef enum {
 	/* submit flush queue to disk at jnode_flush completion */
 	JNODE_FLUSH_WRITE_BLOCKS = 1,
diff -puN fs/reiser4/fsdata.c~reiser4-code-cleanups fs/reiser4/fsdata.c
--- a/fs/reiser4/fsdata.c~reiser4-code-cleanups
+++ a/fs/reiser4/fsdata.c
@@ -96,7 +96,7 @@ void reiser4_done_d_cursor(void)
 #define D_CURSOR_TABLE_SIZE (256)
 
 static inline unsigned long
-d_cursor_hash(d_cursor_hash_table *table, const struct d_cursor_key *key)
+d_cursor_hash(d_cursor_hash_table * table, const struct d_cursor_key *key)
 {
 	assert("nikita-3555", IS_POW(D_CURSOR_TABLE_SIZE));
 	return (key->oid + key->cid) & (D_CURSOR_TABLE_SIZE - 1);
@@ -239,7 +239,7 @@ static inline struct d_cursor_info *d_in
 /*
  * lookup d_cursor in the per-super-block radix tree.
  */
-static inline dir_cursor *lookup(struct d_cursor_info * info,
+static inline dir_cursor *lookup(struct d_cursor_info *info,
 				 unsigned long index)
 {
 	return (dir_cursor *) radix_tree_lookup(&info->tree, index);
diff -puN fs/reiser4/fsdata.h~reiser4-code-cleanups fs/reiser4/fsdata.h
--- a/fs/reiser4/fsdata.h~reiser4-code-cleanups
+++ a/fs/reiser4/fsdata.h
@@ -1,7 +1,7 @@
 /* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
  * reiser4/README */
 
-#if !defined( __REISER4_FSDATA_H__ )
+#if !defined(__REISER4_FSDATA_H__)
 #define __REISER4_FSDATA_H__
 
 #include "debug.h"
@@ -78,8 +78,8 @@ struct reiser4_dentry_fsdata {
 	 * stat-data.
 	 */
 	struct de_location dec;
-	int stateless;		/* created through reiser4_decode_fh, needs special
-				 * treatment in readdir. */
+	int stateless;		/* created through reiser4_decode_fh, needs
+				 * special treatment in readdir. */
 };
 
 extern int reiser4_init_dentry_fsdata(void);
diff -puN fs/reiser4/init_super.c~reiser4-code-cleanups fs/reiser4/init_super.c
--- a/fs/reiser4/init_super.c~reiser4-code-cleanups
+++ a/fs/reiser4/init_super.c
@@ -125,7 +125,7 @@ struct opt_desc {
 		struct {
 			void *addr;
 			int nr_bits;
-			//struct opt_bitmask_bit *bits;
+			/* struct opt_bitmask_bit *bits; */
 		} bitmask;
 	} u;
 };
@@ -260,15 +260,15 @@ static int parse_options(char *opt_strin
 	return result;
 }
 
-#define NUM_OPT( label, fmt, addr )				\
+#define NUM_OPT(label, fmt, addr)				\
 		{						\
-			.name = ( label ),			\
+			.name = (label),			\
 			.type = OPT_FORMAT,			\
 			.u = {					\
 				.f = {				\
-					.format  = ( fmt ),	\
+					.format  = (fmt),	\
 					.nr_args = 1,		\
-					.arg1 = ( addr ),	\
+					.arg1 = (addr),		\
 					.arg2 = NULL,		\
 					.arg3 = NULL,		\
 					.arg4 = NULL		\
@@ -276,7 +276,7 @@ static int parse_options(char *opt_strin
 			}					\
 		}
 
-#define SB_FIELD_OPT( field, fmt ) NUM_OPT( #field, fmt, &sbinfo -> field )
+#define SB_FIELD_OPT(field, fmt) NUM_OPT(#field, fmt, &sbinfo->field)
 
 #define BIT_OPT(label, bitnr)					\
 	{							\
@@ -354,7 +354,7 @@ int reiser4_init_super_data(struct super
 
 #if REISER4_DEBUG
 #  define OPT_ARRAY_CHECK if ((p) > (opts) + MAX_NR_OPTIONS) {		\
-		warning ("zam-1046", "opt array is overloaded"); break;	\
+		warning("zam-1046", "opt array is overloaded"); break;	\
 	}
 #else
 #   define OPT_ARRAY_CHECK noop
diff -puN fs/reiser4/inode.c~reiser4-code-cleanups fs/reiser4/inode.c
--- a/fs/reiser4/inode.c~reiser4-code-cleanups
+++ a/fs/reiser4/inode.c
@@ -1,4 +1,5 @@
-/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
+/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
+   reiser4/README */
 
 /* Inode specific operations. */
 
@@ -23,7 +24,7 @@
 
 /* return reiser4 internal tree which inode belongs to */
 /* Audited by: green(2002.06.17) */
-reiser4_tree *reiser4_tree_by_inode(const struct inode *inode /* inode queried */ )
+reiser4_tree *reiser4_tree_by_inode(const struct inode *inode/* inode queried*/)
 {
 	assert("nikita-256", inode != NULL);
 	assert("nikita-257", inode->i_sb != NULL);
@@ -78,7 +79,7 @@ ino_t oid_to_uino(oid_t oid)
 	   is impossible. Work-around is to somehow hash oid into user visible
 	   inode number.
 	 */
-	oid_t max_ino = (ino_t) ~ 0;
+	oid_t max_ino = (ino_t) ~0;
 
 	if (REISER4_INO_IS_OID || (oid <= max_ino))
 		return oid;
@@ -92,7 +93,7 @@ ino_t oid_to_uino(oid_t oid)
 }
 
 /* check that "inode" is on reiser4 file-system */
-int is_reiser4_inode(const struct inode *inode /* inode queried */ )
+int is_reiser4_inode(const struct inode *inode/* inode queried */)
 {
 	return inode != NULL && is_reiser4_super(inode->i_sb);
 }
@@ -100,7 +101,7 @@ int is_reiser4_inode(const struct inode 
 /* Maximal length of a name that can be stored in directory @inode.
 
    This is used in check during file creation and lookup. */
-int reiser4_max_filename_len(const struct inode *inode /* inode queried */ )
+int reiser4_max_filename_len(const struct inode *inode/* inode queried */)
 {
 	assert("nikita-287", is_reiser4_inode(inode));
 	assert("nikita-1710", inode_dir_item_plugin(inode));
@@ -112,7 +113,7 @@ int reiser4_max_filename_len(const struc
 
 #if REISER4_USE_COLLISION_LIMIT
 /* Maximal number of hash collisions for this directory. */
-int max_hash_collisions(const struct inode *dir /* inode queried */ )
+int max_hash_collisions(const struct inode *dir/* inode queried */)
 {
 	assert("nikita-1711", dir != NULL);
 	return reiser4_inode_data(dir)->plugin.max_collisions;
@@ -152,8 +153,8 @@ int setup_inode_ops(struct inode *inode 
 			inode->i_blocks = 0;
 			assert("vs-42", fplug->h.id == SPECIAL_FILE_PLUGIN_ID);
 			inode->i_op = file_plugins[fplug->h.id].inode_ops;
-			/* initialize inode->i_fop and inode->i_rdev for block and char
-			   devices */
+			/* initialize inode->i_fop and inode->i_rdev for block
+			   and char devices */
 			init_special_inode(inode, inode->i_mode, rdev);
 			/* all address space operations are null */
 			inode->i_mapping->a_ops =
@@ -197,7 +198,7 @@ int setup_inode_ops(struct inode *inode 
 /* Initialize inode from disk data. Called with inode locked.
    Return inode locked. */
 static int init_inode(struct inode *inode /* inode to intialise */ ,
-		      coord_t * coord /* coord of stat data */ )
+		      coord_t *coord/* coord of stat data */)
 {
 	int result;
 	item_plugin *iplug;
@@ -299,8 +300,8 @@ static int read_inode(struct inode *inod
 
 /* initialise new reiser4 inode being inserted into hash table. */
 static int init_locked_inode(struct inode *inode /* new inode */ ,
-			     void *opaque	/* key of stat data passed to the
-						 * iget5_locked as cookie */ )
+			     void *opaque	/* key of stat data passed to
+						* the iget5_locked as cookie */)
 {
 	reiser4_key *key;
 
@@ -312,7 +313,8 @@ static int init_locked_inode(struct inod
 	return 0;
 }
 
-/* reiser4_inode_find_actor() - "find actor" supplied by reiser4 to iget5_locked().
+/* reiser4_inode_find_actor() - "find actor" supplied by reiser4 to
+   iget5_locked().
 
    This function is called by iget5_locked() to distinguish reiser4 inodes
    having the same inode numbers. Such inodes can only exist due to some error
@@ -320,11 +322,11 @@ static int init_locked_inode(struct inod
    (objectids) are distinguished by their packing locality.
 
 */
-static int reiser4_inode_find_actor(struct inode *inode	/* inode from hash table to
-							 * check */ ,
-				    void *opaque	/* "cookie" passed to
-							 * iget5_locked(). This is stat data
-							 * key */ )
+static int reiser4_inode_find_actor(struct inode *inode	/* inode from hash table
+							 * to check */ ,
+				    void *opaque        /* "cookie" passed to
+						         * iget5_locked(). This
+							 * is stat-data key */)
 {
 	reiser4_key *key;
 
@@ -487,43 +489,43 @@ void reiser4_make_bad_inode(struct inode
 	return;
 }
 
-file_plugin *inode_file_plugin(const struct inode * inode)
+file_plugin *inode_file_plugin(const struct inode *inode)
 {
 	assert("nikita-1997", inode != NULL);
 	return reiser4_inode_data(inode)->pset->file;
 }
 
-dir_plugin *inode_dir_plugin(const struct inode * inode)
+dir_plugin *inode_dir_plugin(const struct inode *inode)
 {
 	assert("nikita-1998", inode != NULL);
 	return reiser4_inode_data(inode)->pset->dir;
 }
 
-formatting_plugin *inode_formatting_plugin(const struct inode * inode)
+formatting_plugin *inode_formatting_plugin(const struct inode *inode)
 {
 	assert("nikita-2000", inode != NULL);
 	return reiser4_inode_data(inode)->pset->formatting;
 }
 
-hash_plugin *inode_hash_plugin(const struct inode * inode)
+hash_plugin *inode_hash_plugin(const struct inode *inode)
 {
 	assert("nikita-2001", inode != NULL);
 	return reiser4_inode_data(inode)->pset->hash;
 }
 
-fibration_plugin *inode_fibration_plugin(const struct inode * inode)
+fibration_plugin *inode_fibration_plugin(const struct inode *inode)
 {
 	assert("nikita-2001", inode != NULL);
 	return reiser4_inode_data(inode)->pset->fibration;
 }
 
-cipher_plugin *inode_cipher_plugin(const struct inode * inode)
+cipher_plugin *inode_cipher_plugin(const struct inode *inode)
 {
 	assert("edward-36", inode != NULL);
 	return reiser4_inode_data(inode)->pset->cipher;
 }
 
-compression_plugin *inode_compression_plugin(const struct inode * inode)
+compression_plugin *inode_compression_plugin(const struct inode *inode)
 {
 	assert("edward-37", inode != NULL);
 	return reiser4_inode_data(inode)->pset->compression;
@@ -536,37 +538,37 @@ compression_mode_plugin *inode_compressi
 	return reiser4_inode_data(inode)->pset->compression_mode;
 }
 
-cluster_plugin *inode_cluster_plugin(const struct inode * inode)
+cluster_plugin *inode_cluster_plugin(const struct inode *inode)
 {
 	assert("edward-1328", inode != NULL);
 	return reiser4_inode_data(inode)->pset->cluster;
 }
 
-file_plugin *inode_create_plugin(const struct inode * inode)
+file_plugin *inode_create_plugin(const struct inode *inode)
 {
 	assert("edward-1329", inode != NULL);
 	return reiser4_inode_data(inode)->pset->create;
 }
 
-digest_plugin *inode_digest_plugin(const struct inode * inode)
+digest_plugin *inode_digest_plugin(const struct inode *inode)
 {
 	assert("edward-86", inode != NULL);
 	return reiser4_inode_data(inode)->pset->digest;
 }
 
-item_plugin *inode_sd_plugin(const struct inode * inode)
+item_plugin *inode_sd_plugin(const struct inode *inode)
 {
 	assert("vs-534", inode != NULL);
 	return reiser4_inode_data(inode)->pset->sd;
 }
 
-item_plugin *inode_dir_item_plugin(const struct inode * inode)
+item_plugin *inode_dir_item_plugin(const struct inode *inode)
 {
 	assert("vs-534", inode != NULL);
 	return reiser4_inode_data(inode)->pset->dir_item;
 }
 
-file_plugin *child_create_plugin(const struct inode * inode)
+file_plugin *child_create_plugin(const struct inode *inode)
 {
 	assert("edward-1329", inode != NULL);
 	return reiser4_inode_data(inode)->hset->create;
diff -puN fs/reiser4/inode.h~reiser4-code-cleanups fs/reiser4/inode.h
--- a/fs/reiser4/inode.h~reiser4-code-cleanups
+++ a/fs/reiser4/inode.h
@@ -1,8 +1,9 @@
-/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
+/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
+   reiser4/README */
 
 /* Inode functions. */
 
-#if !defined( __REISER4_INODE_H__ )
+#if !defined(__REISER4_INODE_H__)
 #define __REISER4_INODE_H__
 
 #include "forward.h"
@@ -139,7 +140,7 @@ struct reiser4_inode {
 	/* this semaphore is to serialize readers and writers of @pset->file
 	 * when file plugin conversion is enabled
 	 */
- 	struct rw_semaphore conv_sem;
+	struct rw_semaphore conv_sem;
 
 	/* tree of jnodes. Phantom jnodes (ones not attched to any atom) are
 	   tagged in that tree by EFLUSH_TAG_ANONYMOUS */
@@ -178,7 +179,8 @@ static inline struct inode *inode_by_rei
 						   r4_inode /* inode queried */
 						   )
 {
-	return &container_of(r4_inode, struct reiser4_inode_object, p)->vfs_inode;
+	return &container_of(r4_inode, struct reiser4_inode_object,
+			     p)->vfs_inode;
 }
 
 /*
@@ -252,7 +254,7 @@ static inline void set_inode_ordering(co
 
 /* return inode in which @uf_info is embedded */
 static inline struct inode *
-unix_file_info_to_inode(const struct unix_file_info * uf_info)
+unix_file_info_to_inode(const struct unix_file_info *uf_info)
 {
 	return &container_of(uf_info, struct reiser4_inode_object,
 			     p.file_plugin_data.unix_file_info)->vfs_inode;
@@ -330,14 +332,16 @@ extern int setup_inode_ops(struct inode 
 extern struct inode *reiser4_iget(struct super_block *super,
 				  const reiser4_key * key, int silent);
 extern void reiser4_iget_complete(struct inode *inode);
-extern void reiser4_inode_set_flag(struct inode *inode, reiser4_file_plugin_flags f);
-extern void reiser4_inode_clr_flag(struct inode *inode, reiser4_file_plugin_flags f);
+extern void reiser4_inode_set_flag(struct inode *inode,
+				   reiser4_file_plugin_flags f);
+extern void reiser4_inode_clr_flag(struct inode *inode,
+				   reiser4_file_plugin_flags f);
 extern int reiser4_inode_get_flag(const struct inode *inode,
 				  reiser4_file_plugin_flags f);
 
 /*  has inode been initialized? */
 static inline int
-is_inode_loaded(const struct inode *inode /* inode queried */ )
+is_inode_loaded(const struct inode *inode/* inode queried */)
 {
 	assert("nikita-1120", inode != NULL);
 	return reiser4_inode_get_flag(inode, REISER4_LOADED);
@@ -364,7 +368,7 @@ extern void reiser4_make_bad_inode(struc
 extern void inode_set_extension(struct inode *inode, sd_ext_bits ext);
 extern void inode_clr_extension(struct inode *inode, sd_ext_bits ext);
 extern void inode_check_scale(struct inode *inode, __u64 old, __u64 new);
-extern void inode_check_scale_nolock(struct inode * inode, __u64 old, __u64 new);
+extern void inode_check_scale_nolock(struct inode *inode, __u64 old, __u64 new);
 
 #define INODE_SET_SIZE(i, value)			\
 ({							\
@@ -424,7 +428,7 @@ static inline struct radix_tree_root *jn
 }
 
 static inline struct radix_tree_root *jnode_tree_by_reiser4_inode(reiser4_inode
-								  * r4_inode)
+								  *r4_inode)
 {
 	return &r4_inode->jnodes_tree;
 }
diff -puN fs/reiser4/ioctl.h~reiser4-code-cleanups fs/reiser4/ioctl.h
--- a/fs/reiser4/ioctl.h~reiser4-code-cleanups
+++ a/fs/reiser4/ioctl.h
@@ -1,7 +1,7 @@
 /* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
  * reiser4/README */
 
-#if !defined( __REISER4_IOCTL_H__ )
+#if !defined(__REISER4_IOCTL_H__)
 #define __REISER4_IOCTL_H__
 
 #include <linux/fs.h>
@@ -24,7 +24,7 @@
  * and its stat-data will be updated so that it will never be converted back
  * into tails again.
  */
-#define REISER4_IOC_UNPACK _IOW(0xCD,1,long)
+#define REISER4_IOC_UNPACK _IOW(0xCD, 1, long)
 
 /* __REISER4_IOCTL_H__ */
 #endif
diff -puN fs/reiser4/jnode.c~reiser4-code-cleanups fs/reiser4/jnode.c
--- a/fs/reiser4/jnode.c~reiser4-code-cleanups
+++ a/fs/reiser4/jnode.c
@@ -142,8 +142,8 @@ static inline int jnode_is_parsed(jnode 
 /* hash table support */
 
 /* compare two jnode keys for equality. Used by hash-table macros */
-static inline int jnode_key_eq(const struct jnode_key * k1,
-			       const struct jnode_key * k2)
+static inline int jnode_key_eq(const struct jnode_key *k1,
+			       const struct jnode_key *k2)
 {
 	assert("nikita-2350", k1 != NULL);
 	assert("nikita-2351", k2 != NULL);
@@ -153,7 +153,7 @@ static inline int jnode_key_eq(const str
 
 /* Hash jnode by its key (inode plus offset). Used by hash-table macros */
 static inline __u32 jnode_key_hashfn(j_hash_table * table,
-				     const struct jnode_key * key)
+				     const struct jnode_key *key)
 {
 	assert("nikita-2352", key != NULL);
 	assert("nikita-3346", IS_POW(table->_buckets));
@@ -171,14 +171,14 @@ TYPE_SAFE_HASH_DEFINE(j, jnode, struct j
 #undef KMALLOC
 
 /* call this to initialise jnode hash table */
-int jnodes_tree_init(reiser4_tree * tree /* tree to initialise jnodes for */ )
+int jnodes_tree_init(reiser4_tree * tree/* tree to initialise jnodes for */)
 {
 	assert("nikita-2359", tree != NULL);
 	return j_hash_init(&tree->jhash_table, 16384);
 }
 
 /* call this to destroy jnode hash table. This is called during umount. */
-int jnodes_tree_done(reiser4_tree * tree /* tree to destroy jnodes for */ )
+int jnodes_tree_done(reiser4_tree * tree/* tree to destroy jnodes for */)
 {
 	j_hash_table *jtable;
 	jnode *node;
@@ -404,7 +404,7 @@ static jnode *jfind_nolock(struct addres
 	return radix_tree_lookup(jnode_tree_by_inode(mapping->host), index);
 }
 
-jnode *jfind(struct address_space * mapping, unsigned long index)
+jnode *jfind(struct address_space *mapping, unsigned long index)
 {
 	reiser4_tree *tree;
 	jnode *node;
@@ -557,7 +557,8 @@ static jnode *find_get_jnode(reiser4_tre
 	write_lock_tree(tree);
 	shadow = jfind_nolock(mapping, index);
 	if (likely(shadow == NULL)) {
-		/* add new jnode to hash table and inode's radix tree of jnodes */
+		/* add new jnode to hash table and inode's radix tree of
+		 * jnodes */
 		jref(result);
 		hash_unformatted_jnode(result, mapping, index);
 	} else {
@@ -630,7 +631,7 @@ static jnode *do_jget(reiser4_tree * tre
 /*
  * return jnode for @pg, creating it if necessary.
  */
-jnode *jnode_of_page(struct page * pg)
+jnode *jnode_of_page(struct page *pg)
 {
 	jnode *result;
 
@@ -739,9 +740,8 @@ static struct page *jnode_lock_page(jnod
 
 		spin_lock_jnode(node);
 		page = jnode_page(node);
-		if (page == NULL) {
+		if (page == NULL)
 			break;
-		}
 
 		/* no need to page_cache_get( page ) here, because page cannot
 		   be evicted from memory without detaching it from jnode and
@@ -871,7 +871,7 @@ void jload_prefetch(jnode * node)
 /* load jnode's data into memory */
 int jload_gfp(jnode * node /* node to load */ ,
 	      gfp_t gfp_flags /* allocation flags */ ,
-	      int do_kmap /* true if page should be kmapped */ )
+	      int do_kmap/* true if page should be kmapped */)
 {
 	struct page *page;
 	int result = 0;
@@ -940,7 +940,7 @@ int jload_gfp(jnode * node /* node to lo
 
 	return 0;
 
-      failed:
+failed:
 	jrelse_tail(node);
 	return result;
 
@@ -993,13 +993,13 @@ int jinit_new(jnode * node, gfp_t gfp_fl
 
 	return 0;
 
-      failed:
+failed:
 	jrelse(node);
 	return result;
 }
 
 /* release a reference to jnode acquired by jload(), decrement ->d_count */
-void jrelse_tail(jnode * node /* jnode to release references to */ )
+void jrelse_tail(jnode * node/* jnode to release references to */)
 {
 	assert("nikita-489", atomic_read(&node->d_count) > 0);
 	atomic_dec(&node->d_count);
@@ -1011,7 +1011,7 @@ void jrelse_tail(jnode * node /* jnode t
 
 /* drop reference to node data. When last reference is dropped, data are
    unloaded. */
-void jrelse(jnode * node /* jnode to release references to */ )
+void jrelse(jnode * node/* jnode to release references to */)
 {
 	struct page *page;
 
@@ -1614,7 +1614,7 @@ static int jnode_try_drop(jnode * node)
 }
 
 /* jdelete() -- Delete jnode from the tree and file system */
-static int jdelete(jnode * node /* jnode to finish with */ )
+static int jdelete(jnode * node/* jnode to finish with */)
 {
 	struct page *page;
 	int result;
@@ -1707,9 +1707,8 @@ static int jdrop_in_tree(jnode * node, r
 		jnode_remove(node, jtype, tree);
 		write_unlock_tree(tree);
 		jnode_free(node, jtype);
-		if (page != NULL) {
+		if (page != NULL)
 			reiser4_drop_page(page);
-		}
 	} else {
 		/* busy check failed: reference was acquired by concurrent
 		 * thread. */
@@ -1837,12 +1836,12 @@ static const char *jnode_type_name(jnode
 	}
 }
 
-#define jnode_state_name( node, flag )			\
-	( JF_ISSET( ( node ), ( flag ) ) ? ((#flag "|")+6) : "" )
+#define jnode_state_name(node, flag)			\
+	(JF_ISSET((node), (flag)) ? ((#flag "|")+6) : "")
 
 /* debugging aid: output human readable information about @node */
 static void info_jnode(const char *prefix /* prefix to print */ ,
-		       const jnode * node /* node to print */ )
+		       const jnode * node/* node to print */)
 {
 	assert("umka-068", prefix != NULL);
 
diff -puN fs/reiser4/jnode.h~reiser4-code-cleanups fs/reiser4/jnode.h
--- a/fs/reiser4/jnode.h~reiser4-code-cleanups
+++ a/fs/reiser4/jnode.h
@@ -165,7 +165,8 @@ struct jnode {
 
 	/* the real blocknr (where io is going to/from) */
 	/*   80 */ reiser4_block_nr blocknr;
-	/* Parent item type, unformatted and CRC need it for offset => key conversion.  */
+	/* Parent item type, unformatted and CRC need it for
+	 * offset => key conversion.  */
 	/* NOTE: this parent_item_id looks like jnode type. */
 	/*   88 */ reiser4_plugin_id parent_item_id;
 	/*   92 */
@@ -355,7 +356,7 @@ extern void jnode_make_dirty(jnode * nod
 extern void jnode_make_clean(jnode * node) NONNULL;
 extern void jnode_make_wander_nolock(jnode * node) NONNULL;
 extern void jnode_make_wander(jnode *) NONNULL;
-extern void znode_make_reloc(znode *, flush_queue_t *) NONNULL;
+extern void znode_make_reloc(znode * , flush_queue_t *) NONNULL;
 extern void unformatted_make_reloc(jnode *, flush_queue_t *) NONNULL;
 extern struct address_space *jnode_get_mapping(const jnode * node) NONNULL;
 
@@ -396,8 +397,8 @@ static inline const reiser4_block_nr *jn
 }
 
 /* Jnode flush interface. */
-extern reiser4_blocknr_hint *reiser4_pos_hint(flush_pos_t * pos);
-extern flush_queue_t *reiser4_pos_fq(flush_pos_t * pos);
+extern reiser4_blocknr_hint *reiser4_pos_hint(flush_pos_t *pos);
+extern flush_queue_t *reiser4_pos_fq(flush_pos_t *pos);
 
 /* FIXME-VS: these are used in plugin/item/extent.c */
 
@@ -411,13 +412,13 @@ extern flush_queue_t *reiser4_pos_fq(flu
 
 /* Macros to convert from jnode to znode, znode to jnode.  These are macros
    because C doesn't allow overloading of const prototypes. */
-#define ZJNODE(x) (& (x) -> zjnode)
+#define ZJNODE(x) (&(x)->zjnode)
 #define JZNODE(x)						\
 ({								\
-	typeof (x) __tmp_x;					\
+	typeof(x) __tmp_x;					\
 								\
 	__tmp_x = (x);						\
-	assert ("jmacd-1300", jnode_is_znode (__tmp_x));	\
+	assert("jmacd-1300", jnode_is_znode(__tmp_x));		\
 	(znode*) __tmp_x;					\
 })
 
@@ -438,7 +439,7 @@ extern void jnode_list_remove(jnode * no
 int znode_is_root(const znode * node) NONNULL;
 
 /* bump reference counter on @node */
-static inline void add_x_ref(jnode * node /* node to increase x_count of */ )
+static inline void add_x_ref(jnode * node/* node to increase x_count of */)
 {
 	assert("nikita-1911", node != NULL);
 
@@ -573,7 +574,8 @@ static inline int jnode_check_flushprepp
 {
 	int result;
 
-	/* It must be clean or relocated or wandered.  New allocations are set to relocate. */
+	/* It must be clean or relocated or wandered.  New allocations are set
+	 * to relocate. */
 	spin_lock_jnode(node);
 	result = jnode_is_flushprepped(node);
 	spin_unlock_jnode(node);
@@ -633,7 +635,7 @@ static inline void jput(jnode * node);
 extern void jput_final(jnode * node);
 
 /* bump data counter on @node */
-static inline void add_d_ref(jnode * node /* node to increase d_count of */ )
+static inline void add_d_ref(jnode * node/* node to increase d_count of */)
 {
 	assert("nikita-1962", node != NULL);
 
@@ -660,9 +662,9 @@ static inline void jput(jnode * node)
 	/*
 	 * we don't need any kind of lock here--jput_final() uses RCU.
 	 */
-	if (unlikely(atomic_dec_and_test(&node->x_count))) {
+	if (unlikely(atomic_dec_and_test(&node->x_count)))
 		jput_final(node);
-	} else
+	else
 		rcu_read_unlock();
 	assert("nikita-3473", reiser4_schedulable());
 }
diff -puN fs/reiser4/kassign.c~reiser4-code-cleanups fs/reiser4/kassign.c
--- a/fs/reiser4/kassign.c~reiser4-code-cleanups
+++ a/fs/reiser4/kassign.c
@@ -38,12 +38,12 @@
  *
  * DIRECTORY ITEMS
  *
- *  |       60     | 4 | 7 |1|   56        |        64        |        64       |
- *  +--------------+---+---+-+-------------+------------------+-----------------+
- *  |    dirid     | 0 | F |H|  prefix-1   |    prefix-2      |  prefix-3/hash  |
- *  +--------------+---+---+-+-------------+------------------+-----------------+
- *  |                  |                   |                  |                 |
- *  |    8 bytes       |      8 bytes      |     8 bytes      |     8 bytes     |
+ * |       60     | 4 | 7 |1|   56        |        64        |        64       |
+ * +--------------+---+---+-+-------------+------------------+-----------------+
+ * |    dirid     | 0 | F |H|  prefix-1   |    prefix-2      |  prefix-3/hash  |
+ * +--------------+---+---+-+-------------+------------------+-----------------+
+ * |                  |                   |                  |                 |
+ * |    8 bytes       |      8 bytes      |     8 bytes      |     8 bytes     |
  *
  * dirid         objectid of directory this item is for
  *
@@ -262,7 +262,7 @@ static __u64 pack_string(const char *nam
 
 /* opposite to pack_string(). Takes value produced by pack_string(), restores
  * string encoded in it and stores result in @buf */
-char * reiser4_unpack_string(__u64 value, char *buf)
+char *reiser4_unpack_string(__u64 value, char *buf)
 {
 	do {
 		*buf = value >> (64 - 8);
@@ -343,10 +343,11 @@ void complete_entry_key(const struct ino
 				/* [15-23] characters to offset */
 				offset = pack_string(name + 15, 0);
 			} else {
-				/* note in a key the fact that offset contains hash. */
+				/* note in a key the fact that offset contains
+				 * hash */
 				ordering |= longname_mark;
 
-				/* offset is the hash of the file name's tail. */
+				/* offset is the hash of the file name's tail */
 				offset = inode_hash_plugin(dir)->hash(name + 15,
 								      len - 15);
 			}
@@ -417,7 +418,7 @@ void complete_entry_key(const struct ino
 }
 
 /* true, if @key is the key of "." */
-int is_dot_key(const reiser4_key * key /* key to check */ )
+int is_dot_key(const reiser4_key * key/* key to check */)
 {
 	assert("nikita-1717", key != NULL);
 	assert("nikita-1718", get_key_type(key) == KEY_FILE_NAME_MINOR);
@@ -432,7 +433,7 @@ int is_dot_key(const reiser4_key * key /
    method in the future. For now, let it be here.
 
 */
-reiser4_key *build_sd_key(const struct inode * target /* inode of an object */ ,
+reiser4_key *build_sd_key(const struct inode *target /* inode of an object */ ,
 			  reiser4_key * result	/* resulting key of @target
 						   stat-data */ )
 {
@@ -455,7 +456,7 @@ reiser4_key *build_sd_key(const struct i
    See &obj_key_id
 */
 int build_obj_key_id(const reiser4_key * key /* key to encode */ ,
-		     obj_key_id * id /* id where key is encoded in */ )
+		     obj_key_id * id/* id where key is encoded in */)
 {
 	assert("nikita-1151", key != NULL);
 	assert("nikita-1152", id != NULL);
@@ -468,7 +469,7 @@ int build_obj_key_id(const reiser4_key *
 
    This is like build_obj_key_id() above, but takes inode as parameter. */
 int build_inode_key_id(const struct inode *obj /* object to build key of */ ,
-		       obj_key_id * id /* result */ )
+		       obj_key_id * id/* result */)
 {
 	reiser4_key sdkey;
 
@@ -487,7 +488,7 @@ int build_inode_key_id(const struct inod
 */
 int extract_key_from_id(const obj_key_id * id	/* object key id to extract key
 						 * from */ ,
-			reiser4_key * key /* result */ )
+			reiser4_key * key/* result */)
 {
 	assert("nikita-1153", id != NULL);
 	assert("nikita-1154", key != NULL);
@@ -520,7 +521,7 @@ int build_de_id(const struct inode *dir 
 		const struct qstr *name	/* name to be given to @obj by
 					 * directory entry being
 					 * constructed */ ,
-		de_id * id /* short key of directory entry */ )
+		de_id * id/* short key of directory entry */)
 {
 	reiser4_key key;
 
@@ -542,7 +543,7 @@ int build_de_id(const struct inode *dir 
 */
 int build_de_id_by_key(const reiser4_key * entry_key	/* full key of directory
 							 * entry */ ,
-		       de_id * id /* short key of directory entry */ )
+		       de_id * id/* short key of directory entry */)
 {
 	memcpy(id, ((__u64 *) entry_key) + 1, sizeof *id);
 	return 0;
@@ -557,7 +558,7 @@ int build_de_id_by_key(const reiser4_key
 int extract_key_from_de_id(const oid_t locality	/* locality of directory
 						 * entry */ ,
 			   const de_id * id /* directory entry id */ ,
-			   reiser4_key * key /* result */ )
+			   reiser4_key * key/* result */)
 {
 	/* no need to initialise key here: all fields are overwritten */
 	memcpy(((__u64 *) key) + 1, id, sizeof *id);
@@ -568,7 +569,7 @@ int extract_key_from_de_id(const oid_t l
 
 /* compare two &de_id's */
 cmp_t de_id_cmp(const de_id * id1 /* first &de_id to compare */ ,
-		const de_id * id2 /* second &de_id to compare */ )
+		const de_id * id2/* second &de_id to compare */)
 {
 	/* NOTE-NIKITA ugly implementation */
 	reiser4_key k1;
@@ -581,7 +582,7 @@ cmp_t de_id_cmp(const de_id * id1 /* fir
 
 /* compare &de_id with key */
 cmp_t de_id_key_cmp(const de_id * id /* directory entry id to compare */ ,
-		    const reiser4_key * key /* key to compare */ )
+		    const reiser4_key * key/* key to compare */)
 {
 	cmp_t result;
 	reiser4_key *k1;
@@ -590,9 +591,8 @@ cmp_t de_id_key_cmp(const de_id * id /* 
 	result = KEY_DIFF_EL(k1, key, 1);
 	if (result == EQUAL_TO) {
 		result = KEY_DIFF_EL(k1, key, 2);
-		if (REISER4_LARGE_KEY && result == EQUAL_TO) {
+		if (REISER4_LARGE_KEY && result == EQUAL_TO)
 			result = KEY_DIFF_EL(k1, key, 3);
-		}
 	}
 	return result;
 }
diff -puN fs/reiser4/kassign.h~reiser4-code-cleanups fs/reiser4/kassign.h
--- a/fs/reiser4/kassign.h~reiser4-code-cleanups
+++ a/fs/reiser4/kassign.h
@@ -3,7 +3,7 @@
 
 /* Key assignment policy interface. See kassign.c for details. */
 
-#if !defined( __KASSIGN_H__ )
+#if !defined(__KASSIGN_H__)
 #define __KASSIGN_H__
 
 #include "forward.h"
diff -puN fs/reiser4/key.c~reiser4-code-cleanups fs/reiser4/key.c
--- a/fs/reiser4/key.c~reiser4-code-cleanups
+++ a/fs/reiser4/key.c
@@ -1,4 +1,5 @@
-/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
+/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
+ * reiser4/README */
 
 /* Key manipulations. */
 
@@ -32,27 +33,27 @@ static const reiser4_key MAXIMAL_KEY = {
 };
 
 /* Initialize key. */
-void reiser4_key_init(reiser4_key * key /* key to init */ )
+void reiser4_key_init(reiser4_key * key/* key to init */)
 {
 	assert("nikita-1169", key != NULL);
 	memset(key, 0, sizeof *key);
 }
 
 /* minimal possible key in the tree. Return pointer to the static storage. */
-const reiser4_key *reiser4_min_key(void)
+const reiser4_key * reiser4_min_key(void)
 {
 	return &MINIMAL_KEY;
 }
 
 /* maximum possible key in the tree. Return pointer to the static storage. */
-const reiser4_key *reiser4_max_key(void)
+const reiser4_key * reiser4_max_key(void)
 {
 	return &MAXIMAL_KEY;
 }
 
 #if REISER4_DEBUG
 /* debugging aid: print symbolic name of key type */
-static const char *type_name(unsigned int key_type /* key type */ )
+static const char *type_name(unsigned int key_type/* key type */)
 {
 	switch (key_type) {
 	case KEY_FILE_NAME_MINOR:
@@ -72,7 +73,7 @@ static const char *type_name(unsigned in
 
 /* debugging aid: print human readable information about key */
 void reiser4_print_key(const char *prefix /* prefix to print */ ,
-	       const reiser4_key * key /* key to print */ )
+	       const reiser4_key * key/* key to print */)
 {
 	/* turn bold on */
 	/* printf ("\033[1m"); */
diff -puN fs/reiser4/key.h~reiser4-code-cleanups fs/reiser4/key.h
--- a/fs/reiser4/key.h~reiser4-code-cleanups
+++ a/fs/reiser4/key.h
@@ -1,8 +1,9 @@
-/* Copyright 2000, 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
+/* Copyright 2000, 2001, 2002, 2003 by Hans Reiser, licensing governed by
+ * reiser4/README */
 
 /* Declarations of key-related data-structures and operations on keys. */
 
-#if !defined( __REISER4_KEY_H__ )
+#if !defined(__REISER4_KEY_H__)
 #define __REISER4_KEY_H__
 
 #include "dformat.h"
@@ -15,13 +16,15 @@
 
 /* No access to any of these fields shall be done except via a
    wrapping macro/function, and that wrapping macro/function shall
-   convert to little endian order.  Compare keys will consider cpu byte order. */
+   convert to little endian order. Compare keys will consider cpu byte order. */
 
-/* A storage layer implementation difference between a regular unix file body and its attributes is in the typedef below
-   which causes all of the attributes of a file to be near in key to all of the other attributes for all of the files
-   within that directory, and not near to the file itself.  It is interesting to consider whether this is the wrong
-   approach, and whether there should be no difference at all. For current usage patterns this choice is probably the
-   right one.  */
+/* A storage layer implementation difference between a regular unix file body
+   and its attributes is in the typedef below which causes all of the attributes
+   of a file to be near in key to all of the other attributes for all of the
+   files within that directory, and not near to the file itself. It is
+   interesting to consider whether this is the wrong approach, and whether there
+   should be no difference at all. For current usage patterns this choice is
+   probably the right one.  */
 
 /* possible values for minor packing locality (4 bits required) */
 typedef enum {
@@ -37,16 +40,21 @@ typedef enum {
 	KEY_BODY_MINOR = 4,
 } key_minor_locality;
 
-/* everything stored in the tree has a unique key, which means that the tree is (logically) fully ordered by key.
-   Physical order is determined by dynamic heuristics that attempt to reflect key order when allocating available space,
-   and by the repacker.  It is stylistically better to put aggregation information into the key.  Thus, if you want to
-   segregate extents from tails, it is better to give them distinct minor packing localities rather than changing
-   block_alloc.c to check the node type when deciding where to allocate the node.
-
-   The need to randomly displace new directories and large files disturbs this symmetry unfortunately.  However, it
-   should be noted that this is a need that is not clearly established given the existence of a repacker.  Also, in our
-   current implementation tails have a different minor packing locality from extents, and no files have both extents and
-   tails, so maybe symmetry can be had without performance cost after all.  Symmetry is what we ship for now....
+/* Everything stored in the tree has a unique key, which means that the tree is
+   (logically) fully ordered by key. Physical order is determined by dynamic
+   heuristics that attempt to reflect key order when allocating available space,
+   and by the repacker. It is stylistically better to put aggregation
+   information into the key. Thus, if you want to segregate extents from tails,
+   it is better to give them distinct minor packing localities rather than
+   changing block_alloc.c to check the node type when deciding where to allocate
+   the node.
+
+   The need to randomly displace new directories and large files disturbs this
+   symmetry unfortunately. However, it should be noted that this is a need that
+   is not clearly established given the existence of a repacker. Also, in our
+   current implementation tails have a different minor packing locality from
+   extents, and no files have both extents and tails, so maybe symmetry can be
+   had without performance cost after all. Symmetry is what we ship for now....
 */
 
 /* Arbitrary major packing localities can be assigned to objects using
@@ -130,7 +138,8 @@ union reiser4_key {
 /* ordering is whole second element */
 #define KEY_ORDERING_MASK 0xffffffffffffffffull
 
-/* how many bits key element should be shifted to left to get particular field */
+/* how many bits key element should be shifted to left to get particular field
+ */
 typedef enum {
 	KEY_LOCALITY_SHIFT = 4,
 	KEY_TYPE_SHIFT = 0,
@@ -158,21 +167,21 @@ set_key_el(reiser4_key * key, reiser4_ke
 }
 
 /* macro to define getter and setter functions for field F with type T */
-#define DEFINE_KEY_FIELD( L, U, T )					\
-static inline T get_key_ ## L ( const reiser4_key *key )		\
+#define DEFINE_KEY_FIELD(L, U, T)					\
+static inline T get_key_ ## L(const reiser4_key *key)		        \
 {									\
-	assert( "nikita-750", key != NULL );				\
-	return ( T ) ( get_key_el( key, KEY_ ## U ## _INDEX ) &		\
-		 KEY_ ## U ## _MASK ) >> KEY_ ## U ## _SHIFT;		\
+	assert("nikita-750", key != NULL);				\
+	return (T) (get_key_el(key, KEY_ ## U ## _INDEX) &		\
+		 KEY_ ## U ## _MASK) >> KEY_ ## U ## _SHIFT;		\
 }									\
 									\
-static inline void set_key_ ## L ( reiser4_key *key, T loc )		\
+static inline void set_key_ ## L(reiser4_key * key, T loc)		\
 {									\
 	__u64 el;							\
 									\
-	assert( "nikita-752", key != NULL );				\
+	assert("nikita-752", key != NULL);				\
 									\
-	el = get_key_el( key, KEY_ ## U ## _INDEX );			\
+	el = get_key_el(key, KEY_ ## U ## _INDEX);			\
 	/* clear field bits in the key */				\
 	el &= ~KEY_ ## U ## _MASK;					\
 	/* actually it should be					\
@@ -183,10 +192,10 @@ static inline void set_key_ ## L ( reise
 	   into field. Clearing extra bits is one operation, but this	\
 	   function is time-critical.					\
 	   But check this in assertion. */				\
-	assert( "nikita-759", ( ( loc << KEY_ ## U ## _SHIFT ) &	\
-		~KEY_ ## U ## _MASK ) == 0 );				\
-	el |= ( loc << KEY_ ## U ## _SHIFT );				\
-	set_key_el( key, KEY_ ## U ## _INDEX, el );			\
+	assert("nikita-759", ((loc << KEY_ ## U ## _SHIFT) &		\
+		~KEY_ ## U ## _MASK) == 0);				\
+	el |= (loc << KEY_ ## U ## _SHIFT);				\
+	set_key_el(key, KEY_ ## U ## _INDEX, el);			\
 }
 
 typedef __u64 oid_t;
@@ -230,34 +239,34 @@ extern const reiser4_key *reiser4_min_ke
 extern const reiser4_key *reiser4_max_key(void);
 
 /* helper macro for keycmp() */
-#define KEY_DIFF(k1, k2, field)							\
-({										\
-	typeof (get_key_ ## field (k1)) f1;                              	\
-	typeof (get_key_ ## field (k2)) f2;					\
-										\
-	f1 = get_key_ ## field (k1);						\
-	f2 = get_key_ ## field (k2);						\
-										\
-	(f1 < f2) ? LESS_THAN : ((f1 == f2) ? EQUAL_TO : GREATER_THAN);		\
+#define KEY_DIFF(k1, k2, field)						\
+({									\
+	typeof(get_key_ ## field(k1)) f1;				\
+	typeof(get_key_ ## field(k2)) f2;				\
+									\
+	f1 = get_key_ ## field(k1);					\
+	f2 = get_key_ ## field(k2);					\
+									\
+	(f1 < f2) ? LESS_THAN : ((f1 == f2) ? EQUAL_TO : GREATER_THAN);	\
 })
 
 /* helper macro for keycmp() */
-#define KEY_DIFF_EL(k1, k2, off)						\
-({										\
-	__u64 e1;								\
-	__u64 e2;								\
-										\
-	e1 = get_key_el(k1, off);						\
-	e2 = get_key_el(k2, off);						\
-										\
-	(e1 < e2) ? LESS_THAN : ((e1 == e2) ? EQUAL_TO : GREATER_THAN);		\
+#define KEY_DIFF_EL(k1, k2, off)					\
+({									\
+	__u64 e1;							\
+	__u64 e2;							\
+									\
+	e1 = get_key_el(k1, off);					\
+	e2 = get_key_el(k2, off);					\
+									\
+	(e1 < e2) ? LESS_THAN : ((e1 == e2) ? EQUAL_TO : GREATER_THAN);	\
 })
 
 /* compare `k1' and `k2'.  This function is a heart of "key allocation
     policy". All you need to implement new policy is to add yet another
     clause here. */
 static inline cmp_t keycmp(const reiser4_key * k1 /* first key to compare */ ,
-			   const reiser4_key * k2 /* second key to compare */ )
+			   const reiser4_key * k2/* second key to compare */)
 {
 	cmp_t result;
 
@@ -287,9 +296,8 @@ static inline cmp_t keycmp(const reiser4
 			/* compare offset */
 			if (result == EQUAL_TO) {
 				result = KEY_DIFF_EL(k1, k2, 2);
-				if (REISER4_LARGE_KEY && result == EQUAL_TO) {
+				if (REISER4_LARGE_KEY && result == EQUAL_TO)
 					result = KEY_DIFF_EL(k1, k2, 3);
-				}
 			}
 		}
 	} else if (REISER4_3_5_KEY_ALLOCATION) {
@@ -309,7 +317,7 @@ static inline cmp_t keycmp(const reiser4
 
 /* true if @k1 equals @k2 */
 static inline int keyeq(const reiser4_key * k1 /* first key to compare */ ,
-			const reiser4_key * k2 /* second key to compare */ )
+			const reiser4_key * k2/* second key to compare */)
 {
 	assert("nikita-1879", k1 != NULL);
 	assert("nikita-1880", k2 != NULL);
@@ -318,7 +326,7 @@ static inline int keyeq(const reiser4_ke
 
 /* true if @k1 is less than @k2 */
 static inline int keylt(const reiser4_key * k1 /* first key to compare */ ,
-			const reiser4_key * k2 /* second key to compare */ )
+			const reiser4_key * k2/* second key to compare */)
 {
 	assert("nikita-1952", k1 != NULL);
 	assert("nikita-1953", k2 != NULL);
@@ -327,7 +335,7 @@ static inline int keylt(const reiser4_ke
 
 /* true if @k1 is less than or equal to @k2 */
 static inline int keyle(const reiser4_key * k1 /* first key to compare */ ,
-			const reiser4_key * k2 /* second key to compare */ )
+			const reiser4_key * k2/* second key to compare */)
 {
 	assert("nikita-1954", k1 != NULL);
 	assert("nikita-1955", k2 != NULL);
@@ -336,7 +344,7 @@ static inline int keyle(const reiser4_ke
 
 /* true if @k1 is greater than @k2 */
 static inline int keygt(const reiser4_key * k1 /* first key to compare */ ,
-			const reiser4_key * k2 /* second key to compare */ )
+			const reiser4_key * k2/* second key to compare */)
 {
 	assert("nikita-1959", k1 != NULL);
 	assert("nikita-1960", k2 != NULL);
@@ -345,7 +353,7 @@ static inline int keygt(const reiser4_ke
 
 /* true if @k1 is greater than or equal to @k2 */
 static inline int keyge(const reiser4_key * k1 /* first key to compare */ ,
-			const reiser4_key * k2 /* second key to compare */ )
+			const reiser4_key * k2/* second key to compare */)
 {
 	assert("nikita-1956", k1 != NULL);
 	assert("nikita-1957", k2 != NULL);	/* October  4: sputnik launched
@@ -360,14 +368,14 @@ static inline void prefetchkey(reiser4_k
 }
 
 /* (%Lx:%x:%Lx:%Lx:%Lx:%Lx) =
-           1 + 16 + 1 + 1 + 1 + 1 + 1 + 16 + 1 + 16 + 1 + 16 + 1 */
+	1 + 16 + 1 + 1 + 1 + 1 + 1 + 16 + 1 + 16 + 1 + 16 + 1 */
 /* size of a buffer suitable to hold human readable key representation */
 #define KEY_BUF_LEN (80)
 
 #if REISER4_DEBUG
 extern void reiser4_print_key(const char *prefix, const reiser4_key * key);
 #else
-#define reiser4_print_key(p,k) noop
+#define reiser4_print_key(p, k) noop
 #endif
 
 /* __FS_REISERFS_KEY_H__ */
diff -puN fs/reiser4/ktxnmgrd.c~reiser4-code-cleanups fs/reiser4/ktxnmgrd.c
--- a/fs/reiser4/ktxnmgrd.c~reiser4-code-cleanups
+++ a/fs/reiser4/ktxnmgrd.c
@@ -44,9 +44,9 @@ static int scan_mgr(struct super_block *
  * state. This serves no useful purpose whatsoever, but also costs nothing. May
  * be it will make lonely system administrator feeling less alone at 3 A.M.
  */
-#define set_comm( state ) 						\
-	snprintf( current -> comm, sizeof( current -> comm ),	\
-		  "%s:%s:%s", __FUNCTION__, (super)->s_id, ( state ) )
+#define set_comm(state) 						\
+	snprintf(current->comm, sizeof(current->comm),			\
+		  "%s:%s:%s", __FUNCTION__, (super)->s_id, (state))
 
 /**
  * ktxnmgrd - kernel txnmgr daemon
@@ -78,10 +78,11 @@ static int ktxnmgrd(void *arg)
 		{
 			DEFINE_WAIT(__wait);
 
-			prepare_to_wait(&ctx->wait, &__wait, TASK_INTERRUPTIBLE);
-			if (kthread_should_stop()) {
+			prepare_to_wait(&ctx->wait, &__wait,
+					TASK_INTERRUPTIBLE);
+			if (kthread_should_stop())
 				done = 1;
-			} else
+			else
 				schedule_timeout(ctx->timeout);
 			finish_wait(&ctx->wait, &__wait);
 		}
diff -puN fs/reiser4/lock.c~reiser4-code-cleanups fs/reiser4/lock.c
--- a/fs/reiser4/lock.c~reiser4-code-cleanups
+++ a/fs/reiser4/lock.c
@@ -228,7 +228,7 @@
 #include <linux/spinlock.h>
 
 #if REISER4_DEBUG
-static int request_is_deadlock_safe(znode *, znode_lock_mode,
+static int request_is_deadlock_safe(znode * , znode_lock_mode,
 				    znode_lock_request);
 #endif
 
@@ -331,9 +331,8 @@ static void lock_object(lock_stack * own
 
 	link_object(request->handle, owner, node);
 
-	if (owner->curpri) {
+	if (owner->curpri)
 		node->lock.nr_hipri_owners++;
-	}
 }
 
 /* Check for recursive write locking */
@@ -369,9 +368,8 @@ int znode_is_any_locked(const znode * no
 	lock_stack *stack;
 	int ret;
 
-	if (!znode_is_locked(node)) {
+	if (!znode_is_locked(node))
 		return 0;
-	}
 
 	stack = get_current_lock_stack();
 
@@ -401,9 +399,8 @@ int znode_is_write_locked(const znode * 
 
 	assert("jmacd-8765", node != NULL);
 
-	if (!znode_is_wlocked(node)) {
+	if (!znode_is_wlocked(node))
 		return 0;
-	}
 
 	stack = get_current_lock_stack();
 
@@ -440,7 +437,7 @@ static int check_livelock_condition(znod
 	zlock * lock = &node->lock;
 
 	return mode == ZNODE_READ_LOCK &&
-		lock -> nr_readers >= 0 && lock->nr_hipri_write_requests > 0;
+		lock->nr_readers >= 0 && lock->nr_hipri_write_requests > 0;
 }
 
 /* checks lock/request compatibility */
@@ -459,7 +456,8 @@ static int can_lock_object(lock_stack * 
 	   priority owners. */
 	if (unlikely(!owner->curpri && check_deadlock_condition(node)))
 		return RETERR(-E_REPEAT);
-	if (unlikely(owner->curpri && check_livelock_condition(node, owner->request.mode)))
+	if (unlikely(owner->curpri &&
+		     check_livelock_condition(node, owner->request.mode)))
 		return RETERR(-E_REPEAT);
 	if (unlikely(!is_lock_compatible(node, owner->request.mode)))
 		return RETERR(-E_REPEAT);
@@ -481,7 +479,8 @@ static void set_high_priority(lock_stack
 		 *
 		 * (Interrupts also are not involved.)
 		 */
-		lock_handle *item = list_entry(owner->locks.next, lock_handle, locks_link);
+		lock_handle *item = list_entry(owner->locks.next, lock_handle,
+					       locks_link);
 		while (&owner->locks != &item->locks_link) {
 			znode *node = item->node;
 
@@ -495,7 +494,8 @@ static void set_high_priority(lock_stack
 			item->signaled = 0;
 			spin_unlock_zlock(&node->lock);
 
-			item = list_entry(item->locks_link.next, lock_handle, locks_link);
+			item = list_entry(item->locks_link.next, lock_handle,
+					  locks_link);
 		}
 		owner->curpri = 1;
 		atomic_set(&owner->nr_signaled, 0);
@@ -512,7 +512,8 @@ static void set_low_priority(lock_stack 
 		   actually current thread, and check whether we are reaching
 		   deadlock possibility anywhere.
 		 */
-		lock_handle *handle = list_entry(owner->locks.next, lock_handle, locks_link);
+		lock_handle *handle = list_entry(owner->locks.next, lock_handle,
+						 locks_link);
 		while (&owner->locks != &handle->locks_link) {
 			znode *node = handle->node;
 			spin_lock_zlock(&node->lock);
@@ -532,7 +533,8 @@ static void set_low_priority(lock_stack 
 				atomic_inc(&owner->nr_signaled);
 			}
 			spin_unlock_zlock(&node->lock);
-			handle = list_entry(handle->locks_link.next, lock_handle, locks_link);
+			handle = list_entry(handle->locks_link.next,
+					    lock_handle, locks_link);
 		}
 		owner->curpri = 0;
 	}
@@ -546,7 +548,7 @@ static void remove_lock_request(lock_sta
 		assert("nikita-1838", lock->nr_hipri_requests > 0);
 		lock->nr_hipri_requests--;
 		if (requestor->request.mode == ZNODE_WRITE_LOCK)
-			lock->nr_hipri_write_requests --;
+			lock->nr_hipri_write_requests--;
 	}
 	list_del(&requestor->requestors_link);
 }
@@ -557,7 +559,8 @@ static void invalidate_all_lock_requests
 
 	assert_spin_locked(&(node->lock.guard));
 
-	list_for_each_entry_safe(requestor, tmp, &node->lock.requestors, requestors_link) {
+	list_for_each_entry_safe(requestor, tmp, &node->lock.requestors,
+				 requestors_link) {
 		remove_lock_request(requestor);
 		requestor->request.ret_code = -EINVAL;
 		reiser4_wake_up(requestor);
@@ -571,7 +574,8 @@ static void dispatch_lock_requests(znode
 
 	assert_spin_locked(&(node->lock.guard));
 
-	list_for_each_entry_safe(requestor, tmp, &node->lock.requestors, requestors_link) {
+	list_for_each_entry_safe(requestor, tmp, &node->lock.requestors,
+				 requestors_link) {
 		if (znode_is_write_locked(node))
 			break;
 		if (!can_lock_object(requestor)) {
@@ -745,14 +749,15 @@ static int longterm_lock_tryfast(lock_st
 
 /* locks given lock object */
 int longterm_lock_znode(
-			       /* local link object (allocated by lock owner thread, usually on its own
-			        * stack) */
+			       /* local link object (allocated by lock owner
+				* thread, usually on its own stack) */
 			       lock_handle * handle,
 			       /* znode we want to lock. */
 			       znode * node,
 			       /* {ZNODE_READ_LOCK, ZNODE_WRITE_LOCK}; */
 			       znode_lock_mode mode,
-			       /* {0, -EINVAL, -E_DEADLOCK}, see return codes description. */
+			       /* {0, -EINVAL, -E_DEADLOCK}, see return codes
+				  description. */
 			       znode_lock_request request) {
 	int ret;
 	int hipri = (request & ZNODE_LOCK_HIPRI) != 0;
@@ -779,7 +784,7 @@ int longterm_lock_znode(
 	 * bug caused by d_splice_alias() only working for directories.
 	 */
 	assert("nikita-3547", 1 || ((current->flags & PF_MEMALLOC) == 0));
-	assert ("zam-1055", mode != ZNODE_NO_LOCK);
+	assert("zam-1055", mode != ZNODE_NO_LOCK);
 
 	cap_flags = 0;
 	if (request & ZNODE_LOCK_NONBLOCK) {
@@ -911,7 +916,8 @@ int longterm_lock_znode(
 			 */
 			spin_unlock_zlock(lock);
 			spin_lock_znode(node);
-			ret = reiser4_try_capture(ZJNODE(node), mode, cap_flags);
+			ret = reiser4_try_capture(ZJNODE(node), mode,
+						  cap_flags);
 			spin_unlock_znode(node);
 			spin_lock_zlock(lock);
 			if (unlikely(ret != 0)) {
@@ -947,7 +953,7 @@ int longterm_lock_znode(
 			   node */
 			lock->nr_hipri_requests++;
 			if (mode == ZNODE_WRITE_LOCK)
-				lock->nr_hipri_write_requests ++;
+				lock->nr_hipri_write_requests++;
 			/* If there are no high priority owners for a node,
 			   then immediately wake up low priority owners, so
 			   they can detect possible deadlock */
@@ -966,7 +972,7 @@ int longterm_lock_znode(
 		spin_lock_zlock(lock);
 		if (owner->request.mode == ZNODE_NO_LOCK) {
 			spin_unlock_zlock(lock);
-		request_is_done:
+request_is_done:
 			if (owner->request.ret_code == 0) {
 				LOCK_CNT_INC(long_term_locked_znode);
 				zref(node);
@@ -1031,8 +1037,8 @@ void reiser4_init_lock(zlock * lock	/* p
 	INIT_LIST_HEAD(&lock->owners);
 }
 
-/* Transfer a lock handle (presumably so that variables can be moved between stack and
-   heap locations). */
+/* Transfer a lock handle (presumably so that variables can be moved between
+   stack and heap locations). */
 static void
 move_lh_internal(lock_handle * new, lock_handle * old, int unlink_old)
 {
@@ -1058,12 +1064,10 @@ move_lh_internal(lock_handle * new, lock
 		} else {
 			node->lock.nr_readers -= 1;
 		}
-		if (signaled) {
+		if (signaled)
 			atomic_inc(&owner->nr_signaled);
-		}
-		if (owner->curpri) {
+		if (owner->curpri)
 			node->lock.nr_hipri_owners += 1;
-		}
 		LOCK_CNT_INC(long_term_locked_znode);
 
 		zref(node);
@@ -1084,15 +1088,16 @@ void copy_lh(lock_handle * new, lock_han
 	move_lh_internal(new, old, /*unlink_old */ 0);
 }
 
-/* after getting -E_DEADLOCK we unlock znodes until this function returns false */
+/* after getting -E_DEADLOCK we unlock znodes until this function returns false
+ */
 int reiser4_check_deadlock(void)
 {
 	lock_stack *owner = get_current_lock_stack();
 	return atomic_read(&owner->nr_signaled) != 0;
 }
 
-/* Before going to sleep we re-check "release lock" requests which might come from threads with hi-pri lock
-   priorities. */
+/* Before going to sleep we re-check "release lock" requests which might come
+   from threads with hi-pri lock priorities. */
 int reiser4_prepare_to_sleep(lock_stack * owner)
 {
 	assert("nikita-1847", owner == get_current_lock_stack());
@@ -1207,7 +1212,7 @@ request_is_deadlock_safe(znode * node, z
 
 /* return pointer to static storage with name of lock_mode. For
     debugging */
-const char *lock_mode_name(znode_lock_mode lock /* lock mode to get name of */ )
+const char *lock_mode_name(znode_lock_mode lock/* lock mode to get name of */)
 {
 	if (lock == ZNODE_READ_LOCK)
 		return "read";
diff -puN fs/reiser4/lock.h~reiser4-code-cleanups fs/reiser4/lock.h
--- a/fs/reiser4/lock.h~reiser4-code-cleanups
+++ a/fs/reiser4/lock.h
@@ -1,4 +1,5 @@
-/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
+/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
+ * reiser4/README */
 
 /* Long term locking data structures. See lock.c for details. */
 
@@ -67,10 +68,10 @@ static inline void spin_unlock_zlock(zlo
 #define lock_is_rlocked(lock)         ((lock)->nr_readers > 0)
 #define lock_is_wlocked(lock)         ((lock)->nr_readers < 0)
 #define lock_is_wlocked_once(lock)    ((lock)->nr_readers == -1)
-#define lock_can_be_rlocked(lock)     ((lock)->nr_readers >=0)
+#define lock_can_be_rlocked(lock)     ((lock)->nr_readers >= 0)
 #define lock_mode_compatible(lock, mode)				\
-             (((mode) == ZNODE_WRITE_LOCK && !lock_is_locked(lock)) ||	\
-              ((mode) == ZNODE_READ_LOCK && lock_can_be_rlocked(lock)))
+	      (((mode) == ZNODE_WRITE_LOCK && !lock_is_locked(lock)) ||	\
+	      ((mode) == ZNODE_READ_LOCK && lock_can_be_rlocked(lock)))
 
 /* Since we have R/W znode locks we need additional bidirectional `link'
    objects to implement n<->m relationship between lock owners and lock
@@ -187,8 +188,8 @@ extern void __reiser4_wake_up(lock_stack
 
 extern int lock_stack_isclean(lock_stack * owner);
 
-/* zlock object state check macros: only used in assertions.  Both forms imply that the
-   lock is held by the current thread. */
+/* zlock object state check macros: only used in assertions. Both forms imply
+   that the lock is held by the current thread. */
 extern int znode_is_write_locked(const znode *);
 extern void reiser4_invalidate_lock(lock_handle *);
 
@@ -198,7 +199,7 @@ extern void reiser4_invalidate_lock(lock
 	 LOCK_CNT_NIL(spin_locked_txnmgr) &&		\
 	 LOCK_CNT_NIL(spin_locked_inode) &&		\
 	 LOCK_CNT_NIL(rw_locked_cbk_cache) &&		\
-	 LOCK_CNT_NIL(spin_locked_super_eflush) )
+	 LOCK_CNT_NIL(spin_locked_super_eflush))
 
 static inline void spin_lock_stack(lock_stack *stack)
 {
diff -puN fs/reiser4/oid.c~reiser4-code-cleanups fs/reiser4/oid.c
--- a/fs/reiser4/oid.c~reiser4-code-cleanups
+++ a/fs/reiser4/oid.c
@@ -29,7 +29,7 @@ int oid_init_allocator(struct super_bloc
  * allocate oid and return it. ABSOLUTE_MAX_OID is returned when allocator
  * runs out of oids.
  */
-oid_t oid_allocate(struct super_block * super)
+oid_t oid_allocate(struct super_block *super)
 {
 	reiser4_super_info_data *sbinfo;
 	oid_t oid;
@@ -66,7 +66,7 @@ int oid_release(struct super_block *supe
  * without actually allocating it. This is used by disk format plugin to save
  * oid allocator state on the disk.
  */
-oid_t oid_next(const struct super_block * super)
+oid_t oid_next(const struct super_block *super)
 {
 	reiser4_super_info_data *sbinfo;
 	oid_t oid;
diff -puN fs/reiser4/page_cache.c~reiser4-code-cleanups fs/reiser4/page_cache.c
--- a/fs/reiser4/page_cache.c~reiser4-code-cleanups
+++ a/fs/reiser4/page_cache.c
@@ -140,11 +140,11 @@
       first time following happens (in call to ->read_node() or
       ->allocate_node()):
 
-        1. new page is added to the page cache.
+	1. new page is added to the page cache.
 
-        2. this page is attached to znode and its ->count is increased.
+	2. this page is attached to znode and its ->count is increased.
 
-        3. page is kmapped.
+	3. page is kmapped.
 
       3. if more calls to zload() follow (without corresponding zrelses), page
       counter is left intact and in its stead ->d_count is increased in znode.
@@ -158,14 +158,14 @@
       6. if node is removed from the tree (empty node with JNODE_HEARD_BANSHEE
       bit set) following will happen (also see comment at the top of znode.c):
 
-        1. when last lock is released, node will be uncaptured from
-        transaction. This released reference that transaction manager acquired
-        at the step 5.
-
-        2. when last reference is released, zput() detects that node is
-        actually deleted and calls ->delete_node()
-        operation. page_cache_delete_node() implementation detaches jnode from
-        page and releases page.
+	1. when last lock is released, node will be uncaptured from
+	transaction. This released reference that transaction manager acquired
+	at the step 5.
+
+	2. when last reference is released, zput() detects that node is
+	actually deleted and calls ->delete_node()
+	operation. page_cache_delete_node() implementation detaches jnode from
+	page and releases page.
 
       7. otherwise (node wasn't removed from the tree), last reference to
       znode will be released after transaction manager committed transaction
@@ -204,7 +204,7 @@
 #include <linux/writeback.h>
 #include <linux/blkdev.h>
 
-static struct bio *page_bio(struct page *, jnode *, int rw, gfp_t gfp);
+static struct bio *page_bio(struct page *, jnode * , int rw, gfp_t gfp);
 
 static struct address_space_operations formatted_fake_as_ops;
 
@@ -309,7 +309,7 @@ void reiser4_wait_page_writeback(struct 
 }
 
 /* return tree @page is in */
-reiser4_tree *reiser4_tree_by_page(const struct page *page /* page to query */ )
+reiser4_tree *reiser4_tree_by_page(const struct page *page/* page to query */)
 {
 	assert("nikita-2461", page != NULL);
 	return &get_super_private(page->mapping->host->i_sb)->tree;
@@ -357,7 +357,7 @@ end_bio_single_page_write(struct bio *bi
 
 /* ->readpage() method for formatted nodes */
 static int formatted_readpage(struct file *f UNUSED_ARG,
-			      struct page *page /* page to read */ )
+			      struct page *page/* page to read */)
 {
 	assert("nikita-2412", PagePrivate(page) && jprivate(page));
 	return reiser4_page_io(page, jprivate(page), READ,
@@ -515,7 +515,7 @@ int reiser4_writepage(struct page *page,
 	s = page->mapping->host->i_sb;
 	ctx = get_current_context_check();
 
-	//assert("", can_hit_entd(ctx, s));
+	/* assert("", can_hit_entd(ctx, s)); */
 	return write_page_by_ent(page, wbc);
 }
 
diff -puN fs/reiser4/page_cache.h~reiser4-code-cleanups fs/reiser4/page_cache.h
--- a/fs/reiser4/page_cache.h~reiser4-code-cleanups
+++ a/fs/reiser4/page_cache.h
@@ -2,7 +2,7 @@
  * reiser4/README */
 /* Memory pressure hooks. Fake inodes handling. See page_cache.c. */
 
-#if !defined( __REISER4_PAGE_CACHE_H__ )
+#if !defined(__REISER4_PAGE_CACHE_H__)
 #define __REISER4_PAGE_CACHE_H__
 
 #include "forward.h"
@@ -38,7 +38,7 @@ extern void reiser4_invalidate_pages(str
 				     unsigned long count, int even_cows);
 extern void capture_reiser4_inodes(struct super_block *,
 				   struct writeback_control *);
-static inline void * reiser4_vmalloc (unsigned long size)
+static inline void *reiser4_vmalloc(unsigned long size)
 {
 	return __vmalloc(size,
 			 reiser4_ctx_gfp_mask_get() | __GFP_HIGHMEM,
diff -puN fs/reiser4/plugin/cluster.c~reiser4-code-cleanups fs/reiser4/plugin/cluster.c
--- a/fs/reiser4/plugin/cluster.c~reiser4-code-cleanups
+++ a/fs/reiser4/plugin/cluster.c
@@ -1,4 +1,5 @@
-/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
+/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
+ * reiser4/README */
 
 /* Contains reiser4 cluster plugins (see
    http://www.namesys.com/cryptcompress_design.html
@@ -17,7 +18,7 @@ static int change_cluster(struct inode *
 	assert("edward-1326", is_reiser4_inode(inode));
 	assert("edward-1327", plugin->h.type_id == REISER4_CLUSTER_PLUGIN_TYPE);
 
-	/* Can't change the cluster plugin for already existent regular files. */
+	/* Can't change the cluster plugin for already existent regular files */
 	if (!plugin_of_group(inode_file_plugin(inode), REISER4_DIRECTORY_FILE))
 		return RETERR(-EINVAL);
 
diff -puN fs/reiser4/plugin/cluster.h~reiser4-code-cleanups fs/reiser4/plugin/cluster.h
--- a/fs/reiser4/plugin/cluster.h~reiser4-code-cleanups
+++ a/fs/reiser4/plugin/cluster.h
@@ -3,7 +3,7 @@
 /* This file contains size/offset translators, modulators
    and other helper functions. */
 
-#if !defined( __FS_REISER4_CLUSTER_H__ )
+#if !defined(__FS_REISER4_CLUSTER_H__)
 #define __FS_REISER4_CLUSTER_H__
 
 #include "../inode.h"
@@ -89,7 +89,7 @@ static inline unsigned off_to_cloff(loff
 	return off & ((loff_t) (inode_cluster_size(inode)) - 1);
 }
 
-static inline  pgoff_t offset_in_clust(struct page * page)
+static inline  pgoff_t offset_in_clust(struct page *page)
 {
 	assert("edward-1488", page != NULL);
 	assert("edward-1489", page->mapping != NULL);
@@ -97,12 +97,12 @@ static inline  pgoff_t offset_in_clust(s
 	return page_index(page) & ((cluster_nrpages(page->mapping->host)) - 1);
 }
 
-static inline int first_page_in_cluster(struct page * page)
+static inline int first_page_in_cluster(struct page *page)
 {
 	return offset_in_clust(page) == 0;
 }
 
-static inline int last_page_in_cluster(struct page * page)
+static inline int last_page_in_cluster(struct page *page)
 {
 	return offset_in_clust(page) ==
 		cluster_nrpages(page->mapping->host) - 1;
@@ -177,13 +177,13 @@ static inline unsigned __mbp(loff_t size
 }
 
 /* number of file's bytes in the nominated logical cluster */
-static inline unsigned lbytes(cloff_t index, struct inode * inode)
+static inline unsigned lbytes(cloff_t index, struct inode *inode)
 {
 	return __mbb(i_size_read(inode), index, inode_cluster_shift(inode));
 }
 
 /* number of file's bytes in the nominated page */
-static inline unsigned pbytes(pgoff_t index, struct inode * inode)
+static inline unsigned pbytes(pgoff_t index, struct inode *inode)
 {
 	return __mbp(i_size_read(inode), index);
 }
@@ -201,14 +201,14 @@ static inline pgoff_t win_count_to_nrpag
 }
 
 /* return true, if logical cluster is not occupied by the file */
-static inline int new_logical_cluster(struct cluster_handle * clust,
+static inline int new_logical_cluster(struct cluster_handle *clust,
 				      struct inode *inode)
 {
 	return clust_to_off(clust->index, inode) >= i_size_read(inode);
 }
 
 /* return true, if pages @p1 and @p2 are of the same page cluster */
-static inline int same_page_cluster(struct page * p1, struct page * p2)
+static inline int same_page_cluster(struct page *p1, struct page *p2)
 {
 	assert("edward-1490", p1 != NULL);
 	assert("edward-1491", p2 != NULL);
@@ -219,35 +219,35 @@ static inline int same_page_cluster(stru
 		pg_to_clust(page_index(p2), p2->mapping->host));
 }
 
-static inline int cluster_is_complete(struct cluster_handle * clust,
-				      struct inode * inode)
+static inline int cluster_is_complete(struct cluster_handle *clust,
+				      struct inode *inode)
 {
 	return clust->tc.lsize == inode_cluster_size(inode);
 }
 
-static inline void reiser4_slide_init(struct reiser4_slide * win)
+static inline void reiser4_slide_init(struct reiser4_slide *win)
 {
 	assert("edward-1084", win != NULL);
 	memset(win, 0, sizeof *win);
 }
 
 static inline tfm_action
-cluster_get_tfm_act(struct tfm_cluster * tc)
+cluster_get_tfm_act(struct tfm_cluster *tc)
 {
 	assert("edward-1356", tc != NULL);
 	return tc->act;
 }
 
 static inline void
-cluster_set_tfm_act(struct tfm_cluster * tc, tfm_action act)
+cluster_set_tfm_act(struct tfm_cluster *tc, tfm_action act)
 {
 	assert("edward-1356", tc != NULL);
 	tc->act = act;
 }
 
-static inline void cluster_init_act(struct cluster_handle * clust,
+static inline void cluster_init_act(struct cluster_handle *clust,
 				    tfm_action act,
-				    struct reiser4_slide * window)
+				    struct reiser4_slide *window)
 {
 	assert("edward-84", clust != NULL);
 	memset(clust, 0, sizeof *clust);
@@ -256,20 +256,20 @@ static inline void cluster_init_act(stru
 	clust->win = window;
 }
 
-static inline void cluster_init_read(struct cluster_handle * clust,
-				     struct reiser4_slide * window)
+static inline void cluster_init_read(struct cluster_handle *clust,
+				     struct reiser4_slide *window)
 {
-	cluster_init_act (clust, TFMA_READ, window);
+	cluster_init_act(clust, TFMA_READ, window);
 }
 
-static inline void cluster_init_write(struct cluster_handle * clust,
-				      struct reiser4_slide * window)
+static inline void cluster_init_write(struct cluster_handle *clust,
+				      struct reiser4_slide *window)
 {
-	cluster_init_act (clust, TFMA_WRITE, window);
+	cluster_init_act(clust, TFMA_WRITE, window);
 }
 
 /* true if @p1 and @p2 are items of the same disk cluster */
-static inline int same_disk_cluster(const coord_t * p1, const coord_t * p2)
+static inline int same_disk_cluster(const coord_t *p1, const coord_t *p2)
 {
 	/* drop this if you have other items to aggregate */
 	assert("edward-1494", item_id_by_coord(p1) == CTAIL_ID);
@@ -277,44 +277,44 @@ static inline int same_disk_cluster(cons
 	return item_plugin_by_coord(p1)->b.mergeable(p1, p2);
 }
 
-static inline int dclust_get_extension_dsize(hint_t * hint)
+static inline int dclust_get_extension_dsize(hint_t *hint)
 {
 	return hint->ext_coord.extension.ctail.dsize;
 }
 
-static inline void dclust_set_extension_dsize(hint_t * hint, int dsize)
+static inline void dclust_set_extension_dsize(hint_t *hint, int dsize)
 {
 	hint->ext_coord.extension.ctail.dsize = dsize;
 }
 
-static inline int dclust_get_extension_shift(hint_t * hint)
+static inline int dclust_get_extension_shift(hint_t *hint)
 {
 	return hint->ext_coord.extension.ctail.shift;
 }
 
-static inline int dclust_get_extension_ncount(hint_t * hint)
+static inline int dclust_get_extension_ncount(hint_t *hint)
 {
 	return hint->ext_coord.extension.ctail.ncount;
 }
 
-static inline void dclust_inc_extension_ncount(hint_t * hint)
+static inline void dclust_inc_extension_ncount(hint_t *hint)
 {
-	hint->ext_coord.extension.ctail.ncount ++;
+	hint->ext_coord.extension.ctail.ncount++;
 }
 
-static inline void dclust_init_extension(hint_t * hint)
+static inline void dclust_init_extension(hint_t *hint)
 {
 	memset(&hint->ext_coord.extension.ctail, 0,
 	       sizeof(hint->ext_coord.extension.ctail));
 }
 
-static inline int hint_is_unprepped_dclust(hint_t * hint)
+static inline int hint_is_unprepped_dclust(hint_t *hint)
 {
 	assert("edward-1451", hint_is_valid(hint));
 	return dclust_get_extension_shift(hint) == (int)UCTAIL_SHIFT;
 }
 
-static inline void coord_set_between_clusters(coord_t * coord)
+static inline void coord_set_between_clusters(coord_t *coord)
 {
 #if REISER4_DEBUG
 	int result;
@@ -333,31 +333,32 @@ static inline void coord_set_between_clu
 int reiser4_inflate_cluster(struct cluster_handle *, struct inode *);
 int find_disk_cluster(struct cluster_handle *, struct inode *, int read,
 		      znode_lock_mode mode);
-int checkout_logical_cluster(struct cluster_handle *, jnode *, struct inode *);
+int checkout_logical_cluster(struct cluster_handle *, jnode * , struct inode *);
 int reiser4_deflate_cluster(struct cluster_handle *, struct inode *);
 void truncate_complete_page_cluster(struct inode *inode, cloff_t start,
 					 int even_cows);
-void invalidate_hint_cluster(struct cluster_handle * clust);
-int get_disk_cluster_locked(struct cluster_handle * clust, struct inode * inode,
+void invalidate_hint_cluster(struct cluster_handle *clust);
+int get_disk_cluster_locked(struct cluster_handle *clust, struct inode *inode,
 			    znode_lock_mode lock_mode);
-void reset_cluster_params(struct cluster_handle * clust);
-int set_cluster_by_page(struct cluster_handle * clust, struct page * page,
+void reset_cluster_params(struct cluster_handle *clust);
+int set_cluster_by_page(struct cluster_handle *clust, struct page *page,
 			int count);
-int prepare_page_cluster(struct inode *inode, struct cluster_handle * clust,
+int prepare_page_cluster(struct inode *inode, struct cluster_handle *clust,
 			 rw_op rw);
-void __put_page_cluster(int from, int count,
-			struct page ** pages, struct inode  * inode);
-void put_page_cluster(struct cluster_handle * clust,
-		      struct inode  * inode, rw_op rw);
-void put_cluster_handle(struct cluster_handle * clust);
-int grab_tfm_stream(struct inode *inode, struct tfm_cluster * tc, tfm_stream_id id);
-int tfm_cluster_is_uptodate(struct tfm_cluster * tc);
-void tfm_cluster_set_uptodate(struct tfm_cluster * tc);
-void tfm_cluster_clr_uptodate(struct tfm_cluster * tc);
+void __put_page_cluster(int from, int count, struct page **pages,
+			struct inode *inode);
+void put_page_cluster(struct cluster_handle *clust,
+		      struct inode *inode, rw_op rw);
+void put_cluster_handle(struct cluster_handle *clust);
+int grab_tfm_stream(struct inode *inode, struct tfm_cluster *tc,
+		    tfm_stream_id id);
+int tfm_cluster_is_uptodate(struct tfm_cluster *tc);
+void tfm_cluster_set_uptodate(struct tfm_cluster *tc);
+void tfm_cluster_clr_uptodate(struct tfm_cluster *tc);
 
 /* move cluster handle to the target position
    specified by the page of index @pgidx */
-static inline void move_cluster_forward(struct cluster_handle * clust,
+static inline void move_cluster_forward(struct cluster_handle *clust,
 					struct inode *inode,
 					pgoff_t pgidx)
 {
@@ -377,7 +378,7 @@ static inline void move_cluster_forward(
 	clust->index_valid = 1;
 }
 
-static inline int alloc_clust_pages(struct cluster_handle * clust,
+static inline int alloc_clust_pages(struct cluster_handle *clust,
 				    struct inode *inode)
 {
 	assert("edward-791", clust != NULL);
@@ -390,7 +391,7 @@ static inline int alloc_clust_pages(stru
 	return 0;
 }
 
-static inline void free_clust_pages(struct cluster_handle * clust)
+static inline void free_clust_pages(struct cluster_handle *clust)
 {
 	kfree(clust->pages);
 }
diff -puN fs/reiser4/plugin/dir_plugin_common.c~reiser4-code-cleanups fs/reiser4/plugin/dir_plugin_common.c
--- a/fs/reiser4/plugin/dir_plugin_common.c~reiser4-code-cleanups
+++ a/fs/reiser4/plugin/dir_plugin_common.c
@@ -8,8 +8,9 @@
 #include "../inode.h"
 
 int reiser4_find_entry(struct inode *dir, struct dentry *name,
-	       lock_handle *, znode_lock_mode, reiser4_dir_entry_desc *);
-int reiser4_lookup_name(struct inode *parent, struct dentry *dentry, reiser4_key * key);
+	       lock_handle * , znode_lock_mode, reiser4_dir_entry_desc *);
+int reiser4_lookup_name(struct inode *parent, struct dentry *dentry,
+			reiser4_key * key);
 void check_light_weight(struct inode *inode, struct inode *parent);
 
 /* this is common implementation of get_parent method of dir plugin
@@ -70,9 +71,9 @@ struct dentry *get_parent_common(struct 
 /* this is common implementation of is_name_acceptable method of dir
    plugin
  */
-int is_name_acceptable_common(const struct inode *inode,	/* directory to check */
-			      const char *name UNUSED_ARG,	/* name to check */
-			      int len /* @name's length */ )
+int is_name_acceptable_common(const struct inode *inode, /* directory to check*/
+			      const char *name UNUSED_ARG, /* name to check */
+			      int len/* @name's length */)
 {
 	assert("nikita-733", inode != NULL);
 	assert("nikita-734", name != NULL);
@@ -91,7 +92,7 @@ int is_name_acceptable_common(const stru
    see reiser4_readdir_common for more details
 */
 int build_readdir_key_common(struct file *dir /* directory being read */ ,
-			     reiser4_key * result /* where to store key */ )
+			     reiser4_key * result/* where to store key */)
 {
 	reiser4_file_fsdata *fdata;
 	struct inode *inode;
@@ -188,7 +189,7 @@ int reiser4_add_entry_common(struct inod
  */
 static int
 rem_entry(struct inode *dir, struct dentry *dentry,
-	  reiser4_dir_entry_desc * entry, coord_t * coord, lock_handle * lh)
+	  reiser4_dir_entry_desc * entry, coord_t *coord, lock_handle * lh)
 {
 	item_plugin *iplug;
 	struct inode *child;
@@ -226,7 +227,7 @@ rem_entry(struct inode *dir, struct dent
  */
 int reiser4_rem_entry_common(struct inode *dir,
 			     struct dentry *dentry,
-			     reiser4_dir_entry_desc *entry)
+			     reiser4_dir_entry_desc * entry)
 {
 	int result;
 	coord_t *coord;
@@ -323,7 +324,7 @@ int reiser4_dir_init_common(struct inode
 /* this is common implementation of done method of dir plugin
    remove "." entry
 */
-int reiser4_dir_done_common(struct inode *object /* object being deleted */ )
+int reiser4_dir_done_common(struct inode *object/* object being deleted */)
 {
 	int result;
 	reiser4_block_nr reserve;
@@ -339,8 +340,8 @@ int reiser4_dir_done_common(struct inode
 	   reiser4_cut_tree(). */
 	memset(&entry, 0, sizeof entry);
 
-	/* FIXME: this done method is called from reiser4_delete_dir_common which
-	 * reserved space already */
+	/* FIXME: this done method is called from reiser4_delete_dir_common
+	 * which reserved space already */
 	reserve = inode_dir_plugin(object)->estimate.rem_entry(object);
 	if (reiser4_grab_space(reserve, BA_CAN_COMMIT | BA_RESERVED))
 		return RETERR(-ENOSPC);
@@ -423,7 +424,7 @@ int reiser4_detach_common(struct inode *
    estimation of adding entry which supposes that entry is inserting a
    unit into item
 */
-reiser4_block_nr estimate_add_entry_common(const struct inode * inode)
+reiser4_block_nr estimate_add_entry_common(const struct inode *inode)
 {
 	return estimate_one_insert_into_item(reiser4_tree_by_inode(inode));
 }
@@ -431,7 +432,7 @@ reiser4_block_nr estimate_add_entry_comm
 /* this is common implementation of estimate.rem_entry method of dir
    plugin
 */
-reiser4_block_nr estimate_rem_entry_common(const struct inode * inode)
+reiser4_block_nr estimate_rem_entry_common(const struct inode *inode)
 {
 	return estimate_one_item_removal(reiser4_tree_by_inode(inode));
 }
@@ -440,8 +441,8 @@ reiser4_block_nr estimate_rem_entry_comm
    plugin
 */
 reiser4_block_nr
-dir_estimate_unlink_common(const struct inode * parent,
-			   const struct inode * object)
+dir_estimate_unlink_common(const struct inode *parent,
+			   const struct inode *object)
 {
 	reiser4_block_nr res;
 
@@ -471,10 +472,10 @@ void check_light_weight(struct inode *in
 
 /* looks for name specified in @dentry in directory @parent and if name is
    found - key of object found entry points to is stored in @entry->key */
-int reiser4_lookup_name(struct inode *parent,	/* inode of directory to lookup for
-					 * name in */
+int reiser4_lookup_name(struct inode *parent,	/* inode of directory to lookup
+					 * for name in */
 		struct dentry *dentry,	/* name to look for */
-		reiser4_key * key /* place to store key */ )
+		reiser4_key * key/* place to store key */)
 {
 	int result;
 	coord_t *coord;
@@ -542,9 +543,9 @@ estimate_init(struct inode *parent, stru
 }
 
 /* helper function for reiser4_dir_init_common(). Create "." and ".." */
-static int create_dot_dotdot(struct inode *object /* object to create dot and
-						   * dotdot for */ ,
-			     struct inode *parent /* parent of @object */)
+static int create_dot_dotdot(struct inode *object/* object to create dot and
+						  * dotdot for */ ,
+			     struct inode *parent/* parent of @object */)
 {
 	int result;
 	struct dentry dots_entry;
@@ -617,7 +618,7 @@ static int create_dot_dotdot(struct inod
  * @name.
  */
 static int
-check_item(const struct inode *dir, const coord_t * coord, const char *name)
+check_item(const struct inode *dir, const coord_t *coord, const char *name)
 {
 	item_plugin *iplug;
 	char buf[DE_NAME_BUF_LEN];
@@ -646,7 +647,7 @@ check_item(const struct inode *dir, cons
 }
 
 static int
-check_entry(const struct inode *dir, coord_t * coord, const struct qstr *name)
+check_entry(const struct inode *dir, coord_t *coord, const struct qstr *name)
 {
 	return WITH_COORD(coord, check_item(dir, coord, name->name));
 }
@@ -683,9 +684,9 @@ struct entry_actor_args {
 /* Function called by reiser4_find_entry() to look for given name
    in the directory. */
 static int entry_actor(reiser4_tree * tree UNUSED_ARG /* tree being scanned */ ,
-		       coord_t * coord /* current coord */ ,
+		       coord_t *coord /* current coord */ ,
 		       lock_handle * lh /* current lock handle */ ,
-		       void *entry_actor_arg /* argument to scan */ )
+		       void *entry_actor_arg/* argument to scan */)
 {
 	reiser4_key unit_key;
 	struct entry_actor_args *args;
@@ -801,7 +802,7 @@ int reiser4_find_entry(struct inode *dir
 	 */
 	result = reiser4_object_lookup(dir, &entry->key, coord, lh, mode,
 				       FIND_EXACT, LEAF_LEVEL, LEAF_LEVEL,
-				       flags, NULL /*ra_info */ );
+				       flags, NULL/*ra_info */);
 	if (result == CBK_COORD_FOUND) {
 		struct entry_actor_args arg;
 
diff -puN fs/reiser4/plugin/fibration.h~reiser4-code-cleanups fs/reiser4/plugin/fibration.h
--- a/fs/reiser4/plugin/fibration.h~reiser4-code-cleanups
+++ a/fs/reiser4/plugin/fibration.h
@@ -3,7 +3,7 @@
 /* Fibration plugin used by hashed directory plugin to segment content
  * of directory. See fs/reiser4/plugin/fibration.c for more on this. */
 
-#if !defined( __FS_REISER4_PLUGIN_FIBRATION_H__ )
+#if !defined(__FS_REISER4_PLUGIN_FIBRATION_H__)
 #define __FS_REISER4_PLUGIN_FIBRATION_H__
 
 #include "plugin_header.h"
@@ -12,7 +12,7 @@ typedef struct fibration_plugin {
 	/* generic fields */
 	plugin_header h;
 
-	 __u64(*fibre) (const struct inode * dir, const char *name, int len);
+	 __u64(*fibre) (const struct inode *dir, const char *name, int len);
 } fibration_plugin;
 
 typedef enum {
diff -puN fs/reiser4/plugin/file_ops_readdir.c~reiser4-code-cleanups fs/reiser4/plugin/file_ops_readdir.c
--- a/fs/reiser4/plugin/file_ops_readdir.c~reiser4-code-cleanups
+++ a/fs/reiser4/plugin/file_ops_readdir.c
@@ -5,7 +5,7 @@
 
 /* return true, iff @coord points to the valid directory item that is part of
  * @inode directory. */
-static int is_valid_dir_coord(struct inode *inode, coord_t * coord)
+static int is_valid_dir_coord(struct inode *inode, coord_t *coord)
 {
 	return plugin_of_group(item_plugin_by_coord(coord),
 			       DIR_ENTRY_ITEM_TYPE) &&
@@ -13,7 +13,7 @@ static int is_valid_dir_coord(struct ino
 }
 
 /* compare two logical positions within the same directory */
-static cmp_t dir_pos_cmp(const struct dir_pos * p1, const struct dir_pos * p2)
+static cmp_t dir_pos_cmp(const struct dir_pos *p1, const struct dir_pos *p2)
 {
 	cmp_t result;
 
@@ -31,11 +31,11 @@ static cmp_t dir_pos_cmp(const struct di
 	return result;
 }
 
-/* see comment before reiser4_readdir_common() for overview of why "adjustment" is
- * necessary. */
+/* see comment before reiser4_readdir_common() for overview of why "adjustment"
+ * is necessary. */
 static void
-adjust_dir_pos(struct file *dir, struct readdir_pos * readdir_spot,
-	       const struct dir_pos * mod_point, int adj)
+adjust_dir_pos(struct file *dir, struct readdir_pos *readdir_spot,
+	       const struct dir_pos *mod_point, int adj)
 {
 	struct dir_pos *pos;
 
@@ -127,7 +127,7 @@ void reiser4_adjust_dir_file(struct inod
 /*
  * traverse tree to start/continue readdir from the readdir position @pos.
  */
-static int dir_go_to(struct file *dir, struct readdir_pos * pos, tap_t * tap)
+static int dir_go_to(struct file *dir, struct readdir_pos *pos, tap_t *tap)
 {
 	reiser4_key key;
 	int result;
@@ -161,7 +161,7 @@ static int dir_go_to(struct file *dir, s
  * handling of non-unique keys: calculate at what ordinal position within
  * sequence of directory items with identical keys @pos is.
  */
-static int set_pos(struct inode *inode, struct readdir_pos * pos, tap_t * tap)
+static int set_pos(struct inode *inode, struct readdir_pos *pos, tap_t *tap)
 {
 	int result;
 	coord_t coord;
@@ -212,7 +212,7 @@ static int set_pos(struct inode *inode, 
 /*
  * "rewind" directory to @offset, i.e., set @pos and @tap correspondingly.
  */
-static int dir_rewind(struct file *dir, struct readdir_pos * pos, tap_t * tap)
+static int dir_rewind(struct file *dir, struct readdir_pos *pos, tap_t *tap)
 {
 	__u64 destination;
 	__s64 shift;
@@ -295,7 +295,7 @@ static int dir_rewind(struct file *dir, 
  * unlocked.
  */
 static int
-feed_entry(struct file *f, struct readdir_pos * pos, tap_t * tap,
+feed_entry(struct file *f, struct readdir_pos *pos, tap_t *tap,
 	   filldir_t filldir, void *dirent)
 {
 	item_plugin *iplug;
@@ -368,7 +368,7 @@ feed_entry(struct file *f, struct readdi
 	return result;
 }
 
-static void move_entry(struct readdir_pos * pos, coord_t * coord)
+static void move_entry(struct readdir_pos *pos, coord_t *coord)
 {
 	reiser4_key de_key;
 	de_id *did;
@@ -432,8 +432,8 @@ static void move_entry(struct readdir_po
 /*
  * prepare for readdir.
  */
-static int dir_readdir_init(struct file *f, tap_t * tap,
-			    struct readdir_pos ** pos)
+static int dir_readdir_init(struct file *f, tap_t *tap,
+			    struct readdir_pos **pos)
 {
 	struct inode *inode;
 	reiser4_file_fsdata *fsdata;
@@ -473,7 +473,7 @@ static int dir_readdir_init(struct file 
    typical directory
    See comment before reiser4_readdir_common() for explanation.
 */
-loff_t reiser4_llseek_dir_common(struct file * file, loff_t off, int origin)
+loff_t reiser4_llseek_dir_common(struct file *file, loff_t off, int origin)
 {
 	reiser4_context *ctx;
 	loff_t result;
@@ -586,7 +586,7 @@ int reiser4_readdir_common(struct file *
 
 	reiser4_readdir_readahead_init(inode, &tap);
 
-      repeat:
+repeat:
 	result = dir_readdir_init(f, &tap, &pos);
 	if (result == 0) {
 		result = reiser4_tap_load(&tap);
diff -puN fs/reiser4/plugin/file_plugin_common.c~reiser4-code-cleanups fs/reiser4/plugin/file_plugin_common.c
--- a/fs/reiser4/plugin/file_plugin_common.c~reiser4-code-cleanups
+++ a/fs/reiser4/plugin/file_plugin_common.c
@@ -17,7 +17,7 @@ static int update_sd(struct inode *inode
 /* this is common implementation of write_sd_by_inode method of file plugin
    either insert stat data or update it
  */
-int write_sd_by_inode_common(struct inode *inode /* object to save */ )
+int write_sd_by_inode_common(struct inode *inode/* object to save */)
 {
 	int result;
 
@@ -100,7 +100,7 @@ int set_plug_in_inode_common(struct inod
  */
 int adjust_to_parent_common(struct inode *object /* new object */ ,
 			    struct inode *parent /* parent directory */ ,
-			    struct inode *root /* root directory */ )
+			    struct inode *root/* root directory */)
 {
 	assert("nikita-2165", object != NULL);
 	if (parent == NULL)
@@ -123,7 +123,7 @@ int adjust_to_parent_common(struct inode
  */
 int adjust_to_parent_common_dir(struct inode *object /* new object */ ,
 				struct inode *parent /* parent directory */ ,
-				struct inode *root /* root directory */ )
+				struct inode *root/* root directory */)
 {
 	int result = 0;
 	pset_member memb;
@@ -146,21 +146,21 @@ int adjust_to_parent_common_dir(struct i
 
 int adjust_to_parent_cryptcompress(struct inode *object /* new object */ ,
 				   struct inode *parent /* parent directory */,
-				   struct inode *root /* root directory */)
+				   struct inode *root/* root directory */)
 {
- 	int result;
- 	result = adjust_to_parent_common(object, parent, root);
- 	if (result)
- 		return result;
- 	assert("edward-1416", parent != NULL);
-
- 	grab_plugin_pset(object, parent, PSET_CLUSTER);
- 	grab_plugin_pset(object, parent, PSET_CIPHER);
- 	grab_plugin_pset(object, parent, PSET_DIGEST);
- 	grab_plugin_pset(object, parent, PSET_COMPRESSION);
- 	grab_plugin_pset(object, parent, PSET_COMPRESSION_MODE);
+	int result;
+	result = adjust_to_parent_common(object, parent, root);
+	if (result)
+		return result;
+	assert("edward-1416", parent != NULL);
 
- 	return 0;
+	grab_plugin_pset(object, parent, PSET_CLUSTER);
+	grab_plugin_pset(object, parent, PSET_CIPHER);
+	grab_plugin_pset(object, parent, PSET_DIGEST);
+	grab_plugin_pset(object, parent, PSET_COMPRESSION);
+	grab_plugin_pset(object, parent, PSET_COMPRESSION_MODE);
+
+	return 0;
 }
 
 /* this is common implementation of create_object method of file plugin
@@ -301,7 +301,7 @@ int rem_link_common_dir(struct inode *ob
    compare objectids of keys in inode and coord */
 int owns_item_common(const struct inode *inode,	/* object to check
 						 * against */
-		     const coord_t * coord /* coord to check */ )
+		     const coord_t *coord/* coord to check */)
 {
 	reiser4_key item_key;
 	reiser4_key file_key;
@@ -317,8 +317,8 @@ int owns_item_common(const struct inode 
 /* this is common implementation of owns_item method of file plugin
    for typical directory
 */
-int owns_item_common_dir(const struct inode *inode,	/* object to check against */
-			 const coord_t * coord /* coord of item to check */ )
+int owns_item_common_dir(const struct inode *inode,/* object to check against */
+			 const coord_t *coord/* coord of item to check */)
 {
 	reiser4_key item_key;
 
@@ -335,7 +335,7 @@ int owns_item_common_dir(const struct in
 /* this is common implementation of can_add_link method of file plugin
    checks whether yet another hard links to this object can be added
 */
-int can_add_link_common(const struct inode *object /* object to check */ )
+int can_add_link_common(const struct inode *object/* object to check */)
 {
 	assert("nikita-732", object != NULL);
 
@@ -404,7 +404,7 @@ int safelink_common(struct inode *object
    can be used when object creation involves insertion of one item (usually stat
    data) into tree
 */
-reiser4_block_nr estimate_create_common(const struct inode * object)
+reiser4_block_nr estimate_create_common(const struct inode *object)
 {
 	return estimate_one_insert_item(reiser4_tree_by_inode(object));
 }
@@ -414,7 +414,7 @@ reiser4_block_nr estimate_create_common(
    can be used when directory creation involves insertion of two items (usually
    stat data and item containing "." and "..") into tree
 */
-reiser4_block_nr estimate_create_common_dir(const struct inode * object)
+reiser4_block_nr estimate_create_common_dir(const struct inode *object)
 {
 	return 2 * estimate_one_insert_item(reiser4_tree_by_inode(object));
 }
@@ -423,7 +423,7 @@ reiser4_block_nr estimate_create_common_
    can be used when stat data update does not do more than inserting a unit
    into a stat data item which is probably true for most cases
 */
-reiser4_block_nr estimate_update_common(const struct inode * inode)
+reiser4_block_nr estimate_update_common(const struct inode *inode)
 {
 	return estimate_one_insert_into_item(reiser4_tree_by_inode(inode));
 }
@@ -431,8 +431,8 @@ reiser4_block_nr estimate_update_common(
 /* this is common implementation of estimate.unlink method of file plugin
  */
 reiser4_block_nr
-estimate_unlink_common(const struct inode * object UNUSED_ARG,
-		       const struct inode * parent UNUSED_ARG)
+estimate_unlink_common(const struct inode *object UNUSED_ARG,
+		       const struct inode *parent UNUSED_ARG)
 {
 	return 0;
 }
@@ -441,8 +441,8 @@ estimate_unlink_common(const struct inod
    typical directory
 */
 reiser4_block_nr
-estimate_unlink_common_dir(const struct inode * object,
-			   const struct inode * parent)
+estimate_unlink_common_dir(const struct inode *object,
+			   const struct inode *parent)
 {
 	dir_plugin *dplug;
 
@@ -505,7 +505,7 @@ void wire_done_common(reiser4_object_on_
 /* helper function to print errors */
 static void key_warning(const reiser4_key * key /* key to print */ ,
 			const struct inode *inode,
-			int code /* error code to print */ )
+			int code/* error code to print */)
 {
 	assert("nikita-716", key != NULL);
 
@@ -520,7 +520,7 @@ static void key_warning(const reiser4_ke
 #if REISER4_DEBUG
 static void
 check_inode_seal(const struct inode *inode,
-		 const coord_t * coord, const reiser4_key * key)
+		 const coord_t *coord, const reiser4_key * key)
 {
 	reiser4_key unit_key;
 
@@ -530,7 +530,7 @@ check_inode_seal(const struct inode *ino
 	assert("nikita-2753", get_inode_oid(inode) == get_key_objectid(key));
 }
 
-static void check_sd_coord(coord_t * coord, const reiser4_key * key)
+static void check_sd_coord(coord_t *coord, const reiser4_key * key)
 {
 	reiser4_key ukey;
 
@@ -558,7 +558,7 @@ static void check_sd_coord(coord_t * coo
 
 /* insert new stat-data into tree. Called with inode state
     locked. Return inode state locked. */
-static int insert_new_sd(struct inode *inode /* inode to create sd for */ )
+static int insert_new_sd(struct inode *inode/* inode to create sd for */)
 {
 	int result;
 	reiser4_key key;
@@ -591,13 +591,14 @@ static int insert_new_sd(struct inode *i
 /* could be optimized for case where there is only one node format in
  * use in the filesystem, probably there are lots of such
  * places we could optimize for only one node layout.... -Hans */
-	if (data.length > reiser4_tree_by_inode(inode)->nplug->max_item_size()){
+	if (data.length > reiser4_tree_by_inode(inode)->nplug->max_item_size()) {
 		/* This is silly check, but we don't know actual node where
 		   insertion will go into. */
 		return RETERR(-ENAMETOOLONG);
 	}
 	oid = oid_allocate(inode->i_sb);
-/* NIKITA-FIXME-HANS: what is your opinion on whether this error check should be encapsulated into oid_allocate? */
+/* NIKITA-FIXME-HANS: what is your opinion on whether this error check should be
+ * encapsulated into oid_allocate? */
 	if (oid == ABSOLUTE_MAX_OID)
 		return RETERR(-EOVERFLOW);
 
@@ -644,7 +645,8 @@ static int insert_new_sd(struct inode *i
 			if (result == 0) {
 				/* object has stat-data now */
 				reiser4_inode_clr_flag(inode, REISER4_NO_SD);
-				reiser4_inode_set_flag(inode, REISER4_SDLEN_KNOWN);
+				reiser4_inode_set_flag(inode,
+						       REISER4_SDLEN_KNOWN);
 				/* initialise stat-data seal */
 				reiser4_seal_init(&ref->sd_seal, &coord, &key);
 				ref->sd_coord = coord;
@@ -672,7 +674,7 @@ static int insert_new_sd(struct inode *i
 /* find sd of inode in a tree, deal with errors */
 int lookup_sd(struct inode *inode /* inode to look sd for */ ,
 	      znode_lock_mode lock_mode /* lock mode */ ,
-	      coord_t * coord /* resulting coord */ ,
+	      coord_t *coord /* resulting coord */ ,
 	      lock_handle * lh /* resulting lock handle */ ,
 	      const reiser4_key * key /* resulting key */ ,
 	      int silent)
@@ -711,7 +713,7 @@ int lookup_sd(struct inode *inode /* ino
 
 static int
 locate_inode_sd(struct inode *inode,
-		reiser4_key * key, coord_t * coord, lock_handle * lh)
+		reiser4_key * key, coord_t *coord, lock_handle * lh)
 {
 	reiser4_inode *state;
 	seal_t seal;
@@ -759,8 +761,8 @@ static int all_but_offset_key_eq(const r
 #include "../tree_walk.h"
 
 /* make some checks before and after stat-data resize operation */
-static int check_sd_resize(struct inode * inode, coord_t * coord,
-			   int length, int progress /* 1 means after resize */)
+static int check_sd_resize(struct inode *inode, coord_t *coord,
+			   int length, int progress/* 1 means after resize */)
 {
 	int ret = 0;
 	lock_handle left_lock;
@@ -806,7 +808,7 @@ static int check_sd_resize(struct inode 
 
 /* update stat-data at @coord */
 static int
-update_sd_at(struct inode *inode, coord_t * coord, reiser4_key * key,
+update_sd_at(struct inode *inode, coord_t *coord, reiser4_key * key,
 	     lock_handle * lh)
 {
 	int result;
@@ -910,7 +912,7 @@ update_sd_at(struct inode *inode, coord_
 
 /* Update existing stat-data in a tree. Called with inode state locked. Return
    inode state locked. */
-static int update_sd(struct inode *inode /* inode to update sd for */ )
+static int update_sd(struct inode *inode/* inode to update sd for */)
 {
 	int result;
 	reiser4_key key;
@@ -936,7 +938,7 @@ static int update_sd(struct inode *inode
    Remove object stat data. Space for that must be reserved by caller before
 */
 static int
-common_object_delete_no_reserve(struct inode *inode /* object to remove */ )
+common_object_delete_no_reserve(struct inode *inode/* object to remove */)
 {
 	int result;
 
diff -puN fs/reiser4/plugin/hash.c~reiser4-code-cleanups fs/reiser4/plugin/hash.c
--- a/fs/reiser4/plugin/hash.c~reiser4-code-cleanups
+++ a/fs/reiser4/plugin/hash.c
@@ -13,7 +13,7 @@
 
 /* old rupasov (yura) hash */
 static __u64 hash_rupasov(const unsigned char *name /* name to hash */ ,
-			  int len /* @name's length */ )
+			  int len/* @name's length */)
 {
 	int i;
 	int j;
@@ -58,7 +58,7 @@ static __u64 hash_rupasov(const unsigned
 
 /* r5 hash */
 static __u64 hash_r5(const unsigned char *name /* name to hash */ ,
-		     int len UNUSED_ARG /* @name's length */ )
+		     int len UNUSED_ARG/* @name's length */)
 {
 	__u64 a = 0;
 
@@ -87,7 +87,7 @@ static __u64 hash_r5(const unsigned char
    This code was blindly upgraded to __u64 by s/__u32/__u64/g.
 */
 static __u64 hash_tea(const unsigned char *name /* name to hash */ ,
-		      int len /* @name's length */ )
+		      int len/* @name's length */)
 {
 	__u64 k[] = { 0x9464a485u, 0x542e1a94u, 0x3e846bffu, 0xb75bcfc3u };
 
@@ -113,16 +113,15 @@ static __u64 hash_tea(const unsigned cha
 		b0 = h0;						\
 		b1 = h1;						\
 									\
-		do							\
-		{							\
+		do {							\
 			sum += DELTA;					\
 			b0 += ((b1 << 4)+a) ^ (b1+sum) ^ ((b1 >> 5)+b);	\
 			b1 += ((b0 << 4)+c) ^ (b0+sum) ^ ((b0 >> 5)+d);	\
-		} while(--n);						\
+		} while (--n);						\
 									\
 		h0 += b0;						\
 		h1 += b1;						\
-	} while(0)
+	} while (0)
 
 	pad = (__u64) len | ((__u64) len << 8);
 	pad |= pad << 16;
@@ -144,7 +143,7 @@ static __u64 hash_tea(const unsigned cha
 	}
 
 	if (len >= 12) {
-		//assert(len < 16);
+		/* assert(len < 16); */
 		if (len >= 16)
 			*(int *)0 = 0;
 
@@ -161,7 +160,7 @@ static __u64 hash_tea(const unsigned cha
 			d |= name[i];
 		}
 	} else if (len >= 8) {
-		//assert(len < 12);
+		/* assert(len < 12); */
 		if (len >= 12)
 			*(int *)0 = 0;
 		a = (__u64) name[0] | (__u64) name[1] << 8 | (__u64) name[2] <<
@@ -175,7 +174,7 @@ static __u64 hash_tea(const unsigned cha
 			c |= name[i];
 		}
 	} else if (len >= 4) {
-		//assert(len < 8);
+		/* assert(len < 8); */
 		if (len >= 8)
 			*(int *)0 = 0;
 		a = (__u64) name[0] | (__u64) name[1] << 8 | (__u64) name[2] <<
@@ -187,7 +186,7 @@ static __u64 hash_tea(const unsigned cha
 			b |= name[i];
 		}
 	} else {
-		//assert(len < 4);
+		/* assert(len < 4); */
 		if (len >= 4)
 			*(int *)0 = 0;
 		a = b = c = d = pad;
@@ -220,7 +219,7 @@ static __u64 hash_tea(const unsigned cha
 
 */
 static __u64 hash_fnv1(const unsigned char *name /* name to hash */ ,
-		       int len UNUSED_ARG /* @name's length */ )
+		       int len UNUSED_ARG/* @name's length */)
 {
 	unsigned long long a = 0xcbf29ce484222325ull;
 	const unsigned long long fnv_64_prime = 0x100000001b3ull;
@@ -242,7 +241,7 @@ static __u64 hash_fnv1(const unsigned ch
 /* degenerate hash function used to simplify testing of non-unique key
    handling */
 static __u64 hash_deg(const unsigned char *name UNUSED_ARG /* name to hash */ ,
-		      int len UNUSED_ARG /* @name's length */ )
+		      int len UNUSED_ARG/* @name's length */)
 {
 	return 0xc0c0c0c010101010ull;
 }
diff -puN fs/reiser4/plugin/inode_ops.c~reiser4-code-cleanups fs/reiser4/plugin/inode_ops.c
--- a/fs/reiser4/plugin/inode_ops.c~reiser4-code-cleanups
+++ a/fs/reiser4/plugin/inode_ops.c
@@ -511,9 +511,10 @@ int reiser4_getattr_common(struct vfsmou
    method of file plugin, adding directory entry to parent and update parent
    directory's stat data.
 */
-static reiser4_block_nr estimate_create_vfs_object(struct inode *parent,	/* parent object */
+static reiser4_block_nr estimate_create_vfs_object(struct inode *parent,
+						   /* parent object */
 						   struct inode *object
-						   /* object */ )
+						   /* object */)
 {
 	assert("vpf-309", parent != NULL);
 	assert("vpf-307", object != NULL);
@@ -540,8 +541,9 @@ static reiser4_block_nr estimate_create_
    . instantiate dentry
 
 */
-static int do_create_vfs_child(reiser4_object_create_data * data,	/* parameters of new
-									   object */
+static int do_create_vfs_child(reiser4_object_create_data * data,/* parameters
+								    of new
+								    object */
 			       struct inode **retobj)
 {
 	int result;
@@ -646,7 +648,7 @@ static int do_create_vfs_child(reiser4_o
 	/* call file plugin's method to initialize plugin specific part of
 	 * inode */
 	if (obj_plug->init_inode_data)
-		obj_plug->init_inode_data(object, data, 1 /*create */ );
+		obj_plug->init_inode_data(object, data, 1/*create */);
 
 	/* obtain directory plugin (if any) for new object. */
 	obj_dir = inode_dir_plugin(object);
@@ -786,13 +788,18 @@ create_vfs_object(struct inode *parent,
 	return result;
 }
 
-/* helper for link_common. Estimate disk space necessary to add a link
-   from @parent to @object
-*/
-static reiser4_block_nr common_estimate_link(struct inode *parent,	/* parent directory */
-					     struct inode *object
-					     /* object to which new link is being cerated */
-					     )
+/**
+ * helper for link_common. Estimate disk space necessary to add a link
+ * from @parent to @object
+ */
+static reiser4_block_nr common_estimate_link(struct inode *parent /* parent
+								   * directory
+								   */,
+					     struct inode *object /* object to
+								   * which new
+								   * link is
+								   * being
+								   * created */)
 {
 	reiser4_block_nr res = 0;
 	file_plugin *fplug;
@@ -803,7 +810,8 @@ static reiser4_block_nr common_estimate_
 
 	fplug = inode_file_plugin(object);
 	dplug = inode_dir_plugin(parent);
-	/* VS-FIXME-HANS: why do we do fplug->estimate.update(object) twice instead of multiplying by 2? */
+	/* VS-FIXME-HANS: why do we do fplug->estimate.update(object) twice
+	 * instead of multiplying by 2? */
 	/* reiser4_add_nlink(object) */
 	res += fplug->estimate.update(object);
 	/* add_entry(parent) */
@@ -821,10 +829,12 @@ static reiser4_block_nr common_estimate_
 /* Estimate disk space necessary to remove a link between @parent and
    @object.
 */
-static reiser4_block_nr estimate_unlink(struct inode *parent,	/* parent directory */
-					struct inode *object
-					/* object to which new link is being cerated */
-					)
+static reiser4_block_nr estimate_unlink(struct inode *parent /* parent
+							      * directory */,
+					struct inode *object /* object to which
+							      * new link is
+							      * being created
+							      */)
 {
 	reiser4_block_nr res = 0;
 	file_plugin *fplug;
diff -puN fs/reiser4/plugin/inode_ops_rename.c~reiser4-code-cleanups fs/reiser4/plugin/inode_ops_rename.c
--- a/fs/reiser4/plugin/inode_ops_rename.c~reiser4-code-cleanups
+++ a/fs/reiser4/plugin/inode_ops_rename.c
@@ -13,11 +13,11 @@ static int replace_name(struct inode *to
 						 * to be re-targeted at */
 			struct inode *from_dir,	/* directory where @from_coord
 						 * lives */
-			struct inode *from_inode,	/* inode @from_coord
-							 * originally point to */
-			coord_t * from_coord,	/* where directory entry is in
+			struct inode *from_inode, /* inode @from_coord
+						   * originally point to */
+			coord_t *from_coord,	/* where directory entry is in
 						 * the tree */
-			lock_handle * from_lh /* lock handle on @from_coord */ )
+			lock_handle * from_lh/* lock handle on @from_coord */)
 {
 	item_plugin *from_item;
 	int result;
@@ -30,8 +30,7 @@ static int replace_name(struct inode *to
 		return result;
 	from_item = item_plugin_by_coord(from_coord);
 	if (plugin_of_group(item_plugin_by_coord(from_coord),
-			    DIR_ENTRY_ITEM_TYPE))
-	{
+			    DIR_ENTRY_ITEM_TYPE)) {
 		reiser4_key to_key;
 
 		build_sd_key(to_inode, &to_key);
@@ -97,9 +96,10 @@ static int add_name(struct inode *inode,
 						 * re-targeted at */
 		    struct inode *dir,	/* directory where @coord lives */
 		    struct dentry *name,	/* new name */
-		    coord_t * coord,	/* where directory entry is in the tree */
+		    coord_t *coord,	/* where directory entry is in the tree
+					 */
 		    lock_handle * lh,	/* lock handle on @coord */
-		    int is_dir /* true, if @inode is directory */ )
+		    int is_dir/* true, if @inode is directory */)
 {
 	int result;
 	reiser4_dir_entry_desc entry;
@@ -142,14 +142,18 @@ static int add_name(struct inode *inode,
 	return result;
 }
 
-static reiser4_block_nr estimate_rename(struct inode *old_dir,	/* directory where @old is located */
-					struct dentry *old_name,	/* old name */
-					struct inode *new_dir,	/* directory where @new is located */
-					struct dentry *new_name /* new name */ )
+static reiser4_block_nr estimate_rename(struct inode *old_dir,  /* directory
+								 * where @old is
+								 * located */
+					struct dentry *old_name,/* old name */
+					struct inode *new_dir,  /* directory
+								 * where @new is
+								 * located */
+					struct dentry *new_name /* new name */)
 {
 	reiser4_block_nr res1, res2;
-	dir_plugin *p_parent_old, *p_parent_new;
-	file_plugin *p_child_old, *p_child_new;
+	dir_plugin * p_parent_old, *p_parent_new;
+	file_plugin * p_child_old, *p_child_new;
 
 	assert("vpf-311", old_dir != NULL);
 	assert("vpf-312", new_dir != NULL);
@@ -169,7 +173,8 @@ static reiser4_block_nr estimate_rename(
 
 	/* replace_name */
 	{
-		/* reiser4_add_nlink(p_child_old) and reiser4_del_nlink(p_child_old) */
+		/* reiser4_add_nlink(p_child_old) and
+		 * reiser4_del_nlink(p_child_old) */
 		res1 += 2 * p_child_old->estimate.update(old_name->d_inode);
 		/* update key */
 		res1 += 1;
@@ -180,7 +185,8 @@ static reiser4_block_nr estimate_rename(
 
 	/* else add_name */
 	{
-		/* reiser4_add_nlink(p_parent_new) and reiser4_del_nlink(p_parent_new) */
+		/* reiser4_add_nlink(p_parent_new) and
+		 * reiser4_del_nlink(p_parent_new) */
 		res2 +=
 		    2 * inode_file_plugin(new_dir)->estimate.update(new_dir);
 		/* reiser4_add_nlink(p_parent_old) */
@@ -227,11 +233,18 @@ static reiser4_block_nr estimate_rename(
 	return res1;
 }
 
-static int hashed_rename_estimate_and_grab(struct inode *old_dir,	/* directory where @old is located */
-					   struct dentry *old_name,	/* old name */
-					   struct inode *new_dir,	/* directory where @new is located */
-					   struct dentry *new_name
-					   /* new name */ )
+static int hashed_rename_estimate_and_grab(struct inode *old_dir,  /* directory
+								    * where @old
+								    * is located
+								    */
+					   struct dentry *old_name,/* old name
+								    */
+					   struct inode *new_dir,  /* directory
+								    * where @new
+								    * is located
+								    */
+					   struct dentry *new_name /* new name
+								    */)
 {
 	reiser4_block_nr reserve;
 
@@ -271,7 +284,7 @@ static int can_rename(struct inode *old_
 	return 0;
 }
 
-int reiser4_find_entry(struct inode *, struct dentry *, lock_handle *,
+int reiser4_find_entry(struct inode *, struct dentry *, lock_handle * ,
 	       znode_lock_mode, reiser4_dir_entry_desc *);
 int reiser4_update_dir(struct inode *);
 
@@ -291,7 +304,7 @@ int reiser4_rename_common(struct inode *
 			  struct dentry *old_name /* old name */ ,
 			  struct inode *new_dir /* directory where @new
 						 * is located */ ,
-			  struct dentry *new_name /* new name */ )
+			  struct dentry *new_name/* new name */)
 {
 	/* From `The Open Group Base Specifications Issue 6'
 
@@ -384,7 +397,7 @@ int reiser4_rename_common(struct inode *
 	file_plugin *fplug;
 
 	reiser4_dir_entry_desc *old_entry, *new_entry, *dotdot_entry;
-	lock_handle *new_lh, *dotdot_lh;
+	lock_handle * new_lh, *dotdot_lh;
 	struct dentry *dotdot_name;
 	struct reiser4_dentry_fsdata *dataonstack;
 
@@ -617,7 +630,7 @@ int reiser4_rename_common(struct inode *
 			  struct dentry *old_name /* old name */ ,
 			  struct inode *new_dir /* directory where @new
 						 * is located */ ,
-			  struct dentry *new_name /* new name */ )
+			  struct dentry *new_name/* new name */)
 {
 	/* From `The Open Group Base Specifications Issue 6'
 
@@ -904,7 +917,7 @@ int reiser4_rename_common(struct inode *
 				result = safe_link_add(new_inode, SAFE_UNLINK);
 		}
 	}
-      exit:
+exit:
 	context_set_commit_async(ctx);
 	reiser4_exit_context(ctx);
 	return result;
diff -puN fs/reiser4/plugin/object.c~reiser4-code-cleanups fs/reiser4/plugin/object.c
--- a/fs/reiser4/plugin/object.c~reiser4-code-cleanups
+++ a/fs/reiser4/plugin/object.c
@@ -299,11 +299,11 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 			.pops = &file_plugin_ops,
 			.label = "symlink",
 			.desc = "symbolic link",
-			.linkage = {NULL,NULL}
+			.linkage = {NULL, NULL}
 		},
 		.inode_ops = &symlink_file_i_ops,
-		/* inode->i_fop of symlink is initialized
-		   by NULL in setup_inode_ops */
+		/* inode->i_fop of symlink is initialized by NULL in
+		 * setup_inode_ops */
 		.file_ops = &null_f_ops,
 		.as_ops = &null_a_ops,
 
diff -puN fs/reiser4/plugin/object.h~reiser4-code-cleanups fs/reiser4/plugin/object.h
--- a/fs/reiser4/plugin/object.h~reiser4-code-cleanups
+++ a/fs/reiser4/plugin/object.h
@@ -3,7 +3,7 @@
 
 /* Declaration of object plugin functions. */
 
-#if !defined( __FS_REISER4_PLUGIN_OBJECT_H__ )
+#if !defined(__FS_REISER4_PLUGIN_OBJECT_H__)
 #define __FS_REISER4_PLUGIN_OBJECT_H__
 
 #include "../type_safe_hash.h"
@@ -11,7 +11,7 @@
 /* common implementations of inode operations */
 int reiser4_create_common(struct inode *parent, struct dentry *dentry,
 			  int mode, struct nameidata *);
-struct dentry * reiser4_lookup_common(struct inode *parent,
+struct dentry *reiser4_lookup_common(struct inode *parent,
 				      struct dentry *dentry,
 				      struct nameidata *nameidata);
 int reiser4_link_common(struct dentry *existing, struct inode *parent,
@@ -86,7 +86,7 @@ void build_entry_key_common(const struct
 			    const struct qstr *qname, reiser4_key *);
 int build_readdir_key_common(struct file *dir, reiser4_key *);
 int reiser4_add_entry_common(struct inode *object, struct dentry *where,
-		     reiser4_object_create_data *, reiser4_dir_entry_desc *);
+		     reiser4_object_create_data * , reiser4_dir_entry_desc *);
 int reiser4_rem_entry_common(struct inode *object, struct dentry *where,
 		     reiser4_dir_entry_desc *);
 int reiser4_dir_init_common(struct inode *object, struct inode *parent,
@@ -104,8 +104,8 @@ reiser4_block_nr dir_estimate_unlink_com
 int do_prepare_write(struct file *, struct page *, unsigned from, unsigned to);
 
 /* merely useful functions */
-int lookup_sd(struct inode *, znode_lock_mode, coord_t *, lock_handle *,
-	      const reiser4_key *, int silent);
+int lookup_sd(struct inode *, znode_lock_mode, coord_t *, lock_handle * ,
+	      const reiser4_key * , int silent);
 
 /* __FS_REISER4_PLUGIN_OBJECT_H__ */
 #endif
diff -puN fs/reiser4/plugin/plugin.c~reiser4-code-cleanups fs/reiser4/plugin/plugin.c
--- a/fs/reiser4/plugin/plugin.c~reiser4-code-cleanups
+++ a/fs/reiser4/plugin/plugin.c
@@ -189,7 +189,8 @@ int init_plugins(void)
 		assert("nikita-3509", ptype->type_id == type_id);
 
 		INIT_LIST_HEAD(&ptype->plugins_list);
-/* NIKITA-FIXME-HANS: change builtin_num to some other name lacking the term builtin. */
+/* NIKITA-FIXME-HANS: change builtin_num to some other name lacking the term
+ * builtin. */
 		for (i = 0; i < ptype->builtin_num; ++i) {
 			reiser4_plugin *plugin;
 
@@ -266,7 +267,7 @@ reiser4_plugin *plugin_by_unsafe_id(reis
  * Puts id of @plugin in little endian format to address @area.
  */
 int save_plugin_id(reiser4_plugin *plugin /* plugin to convert */ ,
-		   d16 *area /* where to store result */ )
+		   d16 * area/* where to store result */)
 {
 	assert("nikita-1261", plugin != NULL);
 	assert("nikita-1262", area != NULL);
@@ -326,8 +327,7 @@ int grab_plugin_pset(struct inode *self,
 		parent = reiser4_inode_data(ancestor);
 		plug = aset_get(parent->hset, memb) ? :
 			aset_get(parent->pset, memb);
-	}
-	else
+	} else
 		plug = get_default_plugin(memb);
 
 	result = set_plugin(&info->pset, memb, plug);
@@ -374,7 +374,8 @@ int finish_pset(struct inode *inode)
 	return result;
 }
 
-int force_plugin_pset(struct inode *self, pset_member memb, reiser4_plugin * plug)
+int force_plugin_pset(struct inode *self, pset_member memb,
+		      reiser4_plugin * plug)
 {
 	reiser4_inode *info;
 	int result = 0;
diff -puN fs/reiser4/plugin/plugin.h~reiser4-code-cleanups fs/reiser4/plugin/plugin.h
--- a/fs/reiser4/plugin/plugin.h~reiser4-code-cleanups
+++ a/fs/reiser4/plugin/plugin.h
@@ -1,9 +1,10 @@
-/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
+/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
+ * reiser4/README */
 
 /* Basic plugin data-types.
    see fs/reiser4/plugin/plugin.c for details */
 
-#if !defined( __FS_REISER4_PLUGIN_TYPES_H__ )
+#if !defined(__FS_REISER4_PLUGIN_TYPES_H__)
 #define __FS_REISER4_PLUGIN_TYPES_H__
 
 #include "../forward.h"
@@ -159,8 +160,9 @@ typedef struct reiser4_object_on_wire re
  /* enumeration of fields within plugin_set */
 typedef enum {
 	PSET_FILE,
-	PSET_DIR,		/* PSET_FILE and PSET_DIR should be first elements:
-				 * inode.c:read_inode() depends on this. */
+	PSET_DIR,		/* PSET_FILE and PSET_DIR should be first
+				 * elements: inode.c:read_inode() depends on
+				 * this. */
 	PSET_PERM,
 	PSET_FORMATTING,
 	PSET_HASH,
@@ -225,7 +227,7 @@ typedef struct file_plugin {
 	 * private file_ops
 	 */
 	/* do whatever is necessary to do when object is opened */
-	int (*open) (struct inode * inode, struct file * file);
+	int (*open) (struct inode *inode, struct file *file);
 	ssize_t (*read) (struct file *, char __user *buf, size_t read_amount,
 			loff_t *off);
 	/* write as much as possible bytes from nominated @write_amount
@@ -292,7 +294,8 @@ typedef struct file_plugin {
 	 */
 	int (*key_by_inode) (struct inode *, loff_t off, reiser4_key *);
 
-	/* NIKITA-FIXME-HANS: this comment is not as clear to others as you think.... */
+	/* NIKITA-FIXME-HANS: this comment is not as clear to others as you
+	 * think.... */
 	/*
 	 * set the plugin for a file.  Called during file creation in creat()
 	 * but not reiser4() unless an inode already exists for the file.
@@ -345,15 +348,15 @@ typedef struct file_plugin {
 
 	/* not empty for DIRECTORY_FILE_PLUGIN_ID only currently. It calls
 	   detach of directory plugin to remove ".." */
-	int (*detach) (struct inode * child, struct inode * parent);
+	int (*detach) (struct inode *child, struct inode *parent);
 
 	/* called when @child was just looked up in the @parent. It is not
 	   empty for DIRECTORY_FILE_PLUGIN_ID only where it calls attach of
 	   directory plugin */
-	int (*bind) (struct inode * child, struct inode * parent);
+	int (*bind) (struct inode *child, struct inode *parent);
 
 	/* process safe-link during mount */
-	int (*safelink) (struct inode * object, reiser4_safe_link_t link,
+	int (*safelink) (struct inode *object, reiser4_safe_link_t link,
 			 __u64 value);
 
 	/* The couple of estimate methods for all file operations */
@@ -370,7 +373,7 @@ typedef struct file_plugin {
 	 * (read_inode) and when file is created (common_create_child) so that
 	 * file plugin could initialize its inode data
 	 */
-	void (*init_inode_data) (struct inode *, reiser4_object_create_data *,
+	void (*init_inode_data) (struct inode *, reiser4_object_create_data * ,
 				 int);
 
 	/*
@@ -382,8 +385,8 @@ typedef struct file_plugin {
 	 * @to_key: the end of the deleted key range,
 	 * @smallest_removed: the smallest removed key,
 	 *
-	 * @return: 0 if success, error code otherwise, -E_REPEAT means that long cut_tree
-	 * operation was interrupted for allowing atom commit .
+	 * @return: 0 if success, error code otherwise, -E_REPEAT means that
+	 * long cut_tree operation was interrupted for allowing atom commit .
 	 */
 	int (*cut_tree_worker) (tap_t *, const reiser4_key * from_key,
 				const reiser4_key * to_key,
@@ -399,14 +402,14 @@ typedef struct file_plugin {
 	 */
 	struct {
 		/* store object's identity at @area */
-		char *(*write) (struct inode * inode, char *area);
+		char *(*write) (struct inode *inode, char *area);
 		/* parse object from wire to the @obj */
 		char *(*read) (char *area, reiser4_object_on_wire * obj);
 		/* given object identity in @obj, find or create its dentry */
-		struct dentry *(*get) (struct super_block * s,
+		struct dentry *(*get) (struct super_block *s,
 				       reiser4_object_on_wire * obj);
 		/* how many bytes ->wire.write() consumes */
-		int (*size) (struct inode * inode);
+		int (*size) (struct inode *inode);
 		/* finish with object identify */
 		void (*done) (reiser4_object_on_wire * obj);
 	} wire;
@@ -446,44 +449,44 @@ typedef struct dir_plugin {
 	 * they should be a separate type of plugin.
 	 */
 
-	struct dentry *(*get_parent) (struct inode * childdir);
+	struct dentry *(*get_parent) (struct inode *childdir);
 
 	/*
 	 * check whether "name" is acceptable name to be inserted into this
 	 * object. Optionally implemented by directory-like objects.  Can check
 	 * for maximal length, reserved symbols etc
 	 */
-	int (*is_name_acceptable) (const struct inode * inode, const char *name,
+	int (*is_name_acceptable) (const struct inode *inode, const char *name,
 				   int len);
 
-	void (*build_entry_key) (const struct inode * dir	/* directory where
-								 * entry is (or will
-								 * be) in.*/ ,
-				 const struct qstr * name	/* name of file
-								 * referenced by this
-								 * entry */ ,
+	void (*build_entry_key) (const struct inode *dir /* directory where
+							  * entry is (or will
+							  * be) in.*/ ,
+				 const struct qstr *name /* name of file
+							  * referenced by this
+							  * entry */ ,
 				 reiser4_key * result	/* resulting key of
 							 * directory entry */ );
-	int (*build_readdir_key) (struct file * dir, reiser4_key * result);
-	int (*add_entry) (struct inode * object, struct dentry * where,
+	int (*build_readdir_key) (struct file *dir, reiser4_key * result);
+	int (*add_entry) (struct inode *object, struct dentry *where,
 			  reiser4_object_create_data * data,
 			  reiser4_dir_entry_desc * entry);
-	int (*rem_entry) (struct inode * object, struct dentry * where,
+	int (*rem_entry) (struct inode *object, struct dentry *where,
 			  reiser4_dir_entry_desc * entry);
 
 	/*
 	 * initialize directory structure for newly created object. For normal
 	 * unix directories, insert dot and dotdot.
 	 */
-	int (*init) (struct inode * object, struct inode * parent,
+	int (*init) (struct inode *object, struct inode *parent,
 		     reiser4_object_create_data * data);
 
 	/* destroy directory */
-	int (*done) (struct inode * child);
+	int (*done) (struct inode *child);
 
 	/* called when @subdir was just looked up in the @dir */
-	int (*attach) (struct inode * subdir, struct inode * dir);
-	int (*detach) (struct inode * subdir, struct inode * dir);
+	int (*attach) (struct inode *subdir, struct inode *dir);
+	int (*detach) (struct inode *subdir, struct inode *dir);
 
 	struct {
 		reiser4_block_nr(*add_entry) (const struct inode *);
@@ -500,7 +503,7 @@ typedef struct formatting_plugin {
 	plugin_header h;
 	/* returns non-zero iff file's tail has to be stored
 	   in a direct item. */
-	int (*have_tail) (const struct inode * inode, loff_t size);
+	int (*have_tail) (const struct inode *inode, loff_t size);
 } formatting_plugin;
 
 typedef struct hash_plugin {
@@ -514,25 +517,25 @@ typedef struct cipher_plugin {
 	/* generic fields */
 	plugin_header h;
 	struct crypto_blkcipher * (*alloc) (void);
-	void (*free) (struct crypto_blkcipher * tfm);
+	void (*free) (struct crypto_blkcipher *tfm);
 	/* Offset translator. For each offset this returns (k * offset), where
 	   k (k >= 1) is an expansion factor of the cipher algorithm.
 	   For all symmetric algorithms k == 1. For asymmetric algorithms (which
 	   inflate data) offset translation guarantees that all disk cluster's
 	   units will have keys smaller then next cluster's one.
 	 */
-	 loff_t(*scale) (struct inode * inode, size_t blocksize, loff_t src);
+	 loff_t(*scale) (struct inode *inode, size_t blocksize, loff_t src);
 	/* Cipher algorithms can accept data only by chunks of cipher block
 	   size. This method is to align any flow up to cipher block size when
 	   we pass it to cipher algorithm. To align means to append padding of
 	   special format specific to the cipher algorithm */
-	int (*align_stream) (__u8 * tail, int clust_size, int blocksize);
+	int (*align_stream) (__u8 *tail, int clust_size, int blocksize);
 	/* low-level key manager (check, install, etc..) */
-	int (*setkey) (struct crypto_tfm * tfm, const __u8 * key,
+	int (*setkey) (struct crypto_tfm *tfm, const __u8 *key,
 		       unsigned int keylen);
 	/* main text processing procedures */
-	void (*encrypt) (__u32 * expkey, __u8 * dst, const __u8 * src);
-	void (*decrypt) (__u32 * expkey, __u8 * dst, const __u8 * src);
+	void (*encrypt) (__u32 *expkey, __u8 *dst, const __u8 *src);
+	void (*decrypt) (__u32 *expkey, __u8 *dst, const __u8 *src);
 } cipher_plugin;
 
 typedef struct digest_plugin {
@@ -541,7 +544,7 @@ typedef struct digest_plugin {
 	/* fingerprint size in bytes */
 	int fipsize;
 	struct crypto_hash * (*alloc) (void);
-	void (*free) (struct crypto_hash * tfm);
+	void (*free) (struct crypto_hash *tfm);
 } digest_plugin;
 
 typedef struct compression_plugin {
@@ -557,10 +560,10 @@ typedef struct compression_plugin {
 	int (*min_size_deflate) (void);
 	 __u32(*checksum) (char *data, __u32 length);
 	/* main transform procedures */
-	void (*compress) (coa_t coa, __u8 * src_first, unsigned src_len,
-			  __u8 * dst_first, unsigned *dst_len);
-	void (*decompress) (coa_t coa, __u8 * src_first, unsigned src_len,
-			    __u8 * dst_first, unsigned *dst_len);
+	void (*compress) (coa_t coa, __u8 *src_first, unsigned src_len,
+			  __u8 *dst_first, unsigned *dst_len);
+	void (*decompress) (coa_t coa, __u8 *src_first, unsigned src_len,
+			    __u8 *dst_first, unsigned *dst_len);
 } compression_plugin;
 
 typedef struct compression_mode_plugin {
@@ -568,11 +571,11 @@ typedef struct compression_mode_plugin {
 	plugin_header h;
 	/* this is called when estimating compressibility
 	   of a logical cluster by its content */
-	int (*should_deflate) (struct inode * inode, cloff_t index);
+	int (*should_deflate) (struct inode *inode, cloff_t index);
 	/* this is called when results of compression should be saved */
-	int (*accept_hook) (struct inode * inode, cloff_t index);
+	int (*accept_hook) (struct inode *inode, cloff_t index);
 	/* this is called when results of compression should be discarded */
-	int (*discard_hook) (struct inode * inode, cloff_t index);
+	int (*discard_hook) (struct inode *inode, cloff_t index);
 } compression_mode_plugin;
 
 typedef struct cluster_plugin {
@@ -584,10 +587,10 @@ typedef struct cluster_plugin {
 typedef struct sd_ext_plugin {
 	/* generic fields */
 	plugin_header h;
-	int (*present) (struct inode * inode, char **area, int *len);
-	int (*absent) (struct inode * inode);
-	int (*save_len) (struct inode * inode);
-	int (*save) (struct inode * inode, char **area);
+	int (*present) (struct inode *inode, char **area, int *len);
+	int (*absent) (struct inode *inode);
+	int (*save_len) (struct inode *inode);
+	int (*save) (struct inode *inode, char **area);
 	/* alignment requirement for this stat-data part */
 	int alignment;
 } sd_ext_plugin;
@@ -628,11 +631,11 @@ typedef struct disk_format_plugin {
 	int (*init_format) (struct super_block *, void *data);
 
 	/* key of root directory stat data */
-	const reiser4_key *(*root_dir_key) (const struct super_block *);
+	const reiser4_key * (*root_dir_key) (const struct super_block *);
 
 	int (*release) (struct super_block *);
-	jnode *(*log_super) (struct super_block *);
-	int (*check_open) (const struct inode * object);
+	jnode * (*log_super) (struct super_block *);
+	int (*check_open) (const struct inode *object);
 	int (*version_update) (struct super_block *);
 } disk_format_plugin;
 
@@ -643,7 +646,7 @@ struct jnode_plugin {
 	int (*parse) (jnode * node);
 	struct address_space *(*mapping) (const jnode * node);
 	unsigned long (*index) (const jnode * node);
-	jnode *(*clone) (jnode * node);
+	jnode * (*clone) (jnode * node);
 };
 
 /* plugin instance.                                                         */
@@ -707,24 +710,24 @@ struct reiser4_plugin_ops {
 	/* called when plugin is unloaded */
 	int (*done) (reiser4_plugin * plugin);
 	/* load given plugin from disk */
-	int (*load) (struct inode * inode,
+	int (*load) (struct inode *inode,
 		     reiser4_plugin * plugin, char **area, int *len);
 	/* how many space is required to store this plugin's state
 	   in stat-data */
-	int (*save_len) (struct inode * inode, reiser4_plugin * plugin);
+	int (*save_len) (struct inode *inode, reiser4_plugin * plugin);
 	/* save persistent plugin-data to disk */
-	int (*save) (struct inode * inode, reiser4_plugin * plugin,
+	int (*save) (struct inode *inode, reiser4_plugin * plugin,
 		     char **area);
 	/* alignment requirement for on-disk state of this plugin
 	   in number of bytes */
 	int alignment;
 	/* install itself into given inode. This can return error
 	   (e.g., you cannot change hash of non-empty directory). */
-	int (*change) (struct inode * inode, reiser4_plugin * plugin,
+	int (*change) (struct inode *inode, reiser4_plugin * plugin,
 		       pset_member memb);
 	/* install itself into given inode. This can return error
 	   (e.g., you cannot change hash of non-empty directory). */
-	int (*inherit) (struct inode * inode, struct inode * parent,
+	int (*inherit) (struct inode *inode, struct inode *parent,
 			reiser4_plugin * plugin);
 };
 
@@ -805,7 +808,7 @@ struct reiser4_object_create_data {
 	/* add here something for non-standard objects you invent, like
 	   query for interpolation file etc. */
 
- 	struct reiser4_crypto_info * crypto;
+	struct reiser4_crypto_info *crypto;
 
 	struct inode *parent;
 	struct dentry *dentry;
@@ -833,29 +836,29 @@ struct reiser4_dir_entry_desc {
 #define MAX_PLUGIN_TYPE_LABEL_LEN  32
 #define MAX_PLUGIN_PLUG_LABEL_LEN  32
 
-#define PLUGIN_BY_ID(TYPE,ID,FIELD)					\
-static inline TYPE *TYPE ## _by_id( reiser4_plugin_id id )		\
+#define PLUGIN_BY_ID(TYPE, ID, FIELD)					\
+static inline TYPE *TYPE ## _by_id(reiser4_plugin_id id)		\
 {									\
-	reiser4_plugin *plugin = plugin_by_id ( ID, id );		\
-	return plugin ? & plugin -> FIELD : NULL;			\
+	reiser4_plugin *plugin = plugin_by_id(ID, id);			\
+	return plugin ? &plugin->FIELD : NULL;				\
 }									\
-static inline TYPE *TYPE ## _by_disk_id( reiser4_tree *tree, d16 *id )	\
+static inline TYPE *TYPE ## _by_disk_id(reiser4_tree * tree, d16 *id)	\
 {									\
-	reiser4_plugin *plugin = plugin_by_disk_id ( tree, ID, id );	\
-	return plugin ? & plugin -> FIELD : NULL;			\
+	reiser4_plugin *plugin = plugin_by_disk_id(tree, ID, id);	\
+	return plugin ? &plugin->FIELD : NULL;				\
 }									\
-static inline TYPE *TYPE ## _by_unsafe_id( reiser4_plugin_id id )	\
+static inline TYPE *TYPE ## _by_unsafe_id(reiser4_plugin_id id)	        \
 {									\
-	reiser4_plugin *plugin = plugin_by_unsafe_id ( ID, id );	\
-	return plugin ? & plugin -> FIELD : NULL;			\
+	reiser4_plugin *plugin = plugin_by_unsafe_id(ID, id);		\
+	return plugin ? &plugin->FIELD : NULL;				\
 }									\
-static inline reiser4_plugin* TYPE ## _to_plugin( TYPE* plugin )	\
+static inline reiser4_plugin* TYPE ## _to_plugin(TYPE* plugin)	        \
 {									\
-	return ( reiser4_plugin * ) plugin;				\
+	return (reiser4_plugin *) plugin;				\
 }									\
-static inline reiser4_plugin_id TYPE ## _id( TYPE* plugin )		\
+static inline reiser4_plugin_id TYPE ## _id(TYPE* plugin)		\
 {									\
-	return TYPE ## _to_plugin (plugin) -> h.id;			\
+	return TYPE ## _to_plugin(plugin)->h.id;			\
 }									\
 typedef struct { int foo; } TYPE ## _plugin_dummy
 
@@ -887,8 +890,10 @@ for (plugin = list_entry(get_plugin_list
      plugin = list_entry(plugin->h.linkage.next, reiser4_plugin, h.linkage))
 
 
-extern int grab_plugin_pset(struct inode *self, struct inode *ancestor, pset_member memb);
-extern int force_plugin_pset(struct inode *self, pset_member memb, reiser4_plugin *plug);
+extern int grab_plugin_pset(struct inode *self, struct inode *ancestor,
+			    pset_member memb);
+extern int force_plugin_pset(struct inode *self, pset_member memb,
+			     reiser4_plugin *plug);
 extern int finish_pset(struct inode *inode);
 
 /* defined in fs/reiser4/plugin/object.c */
diff -puN fs/reiser4/plugin/plugin_header.h~reiser4-code-cleanups fs/reiser4/plugin/plugin_header.h
--- a/fs/reiser4/plugin/plugin_header.h~reiser4-code-cleanups
+++ a/fs/reiser4/plugin/plugin_header.h
@@ -2,7 +2,7 @@
 
 /* plugin header. Data structures required by all plugin types. */
 
-#if !defined( __PLUGIN_HEADER_H__ )
+#if !defined(__PLUGIN_HEADER_H__)
 #define __PLUGIN_HEADER_H__
 
 /* plugin data-types and constants */
@@ -34,7 +34,7 @@ typedef enum {
 	REISER4_CIPHER_PLUGIN_TYPE,           /* (F) cipher transform algs */
 	REISER4_DIGEST_PLUGIN_TYPE,           /* (F) digest transform algs */
 	REISER4_COMPRESSION_PLUGIN_TYPE,      /* (F) compression tfm algs */
- 	REISER4_COMPRESSION_MODE_PLUGIN_TYPE, /* (F) compression heuristic */
+	REISER4_COMPRESSION_MODE_PLUGIN_TYPE, /* (F) compression heuristic */
 	REISER4_CLUSTER_PLUGIN_TYPE,          /* (F) size of logical cluster */
 	REISER4_PLUGIN_TYPES
 } reiser4_plugin_type;
@@ -62,7 +62,8 @@ typedef struct plugin_header {
 	reiser4_plugin_groups groups;
 	/* plugin operations */
 	reiser4_plugin_ops *pops;
-/* NIKITA-FIXME-HANS: usage of and access to label and desc is not commented and defined. */
+/* NIKITA-FIXME-HANS: usage of and access to label and desc is not commented and
+ * defined. */
 	/* short label of this plugin */
 	const char *label;
 	/* descriptive string.. */
@@ -74,7 +75,8 @@ typedef struct plugin_header {
 #define plugin_of_group(plug, group) (plug->h.groups & (1 << group))
 
 /* PRIVATE INTERFACES */
-/* NIKITA-FIXME-HANS: what is this for and why does it duplicate what is in plugin_header? */
+/* NIKITA-FIXME-HANS: what is this for and why does it duplicate what is in
+ * plugin_header? */
 /* plugin type representation. */
 struct reiser4_plugin_type_data {
 	/* internal plugin type identifier. Should coincide with
@@ -100,7 +102,7 @@ extern struct reiser4_plugin_type_data p
 int is_plugin_type_valid(reiser4_plugin_type type);
 int is_plugin_id_valid(reiser4_plugin_type type, reiser4_plugin_id id);
 
-static inline reiser4_plugin *plugin_at(struct reiser4_plugin_type_data * ptype,
+static inline reiser4_plugin *plugin_at(struct reiser4_plugin_type_data *ptype,
 					int i)
 {
 	char *builtin;
diff -puN fs/reiser4/plugin/plugin_set.c~reiser4-code-cleanups fs/reiser4/plugin/plugin_set.c
--- a/fs/reiser4/plugin/plugin_set.c~reiser4-code-cleanups
+++ a/fs/reiser4/plugin/plugin_set.c
@@ -92,7 +92,7 @@ static inline int pseq(const unsigned lo
 
 #define HASH_FIELD(hash, set, field)		\
 ({						\
-        (hash) += (unsigned long)(set)->field >> 2;	\
+	(hash) += (unsigned long)(set)->field >> 2;	\
 })
 
 static inline unsigned long calculate_hash(const plugin_set * set)
@@ -324,7 +324,8 @@ reiser4_plugin *PREFIX##_get(plugin_set 
 
 DEFINE_PSET_OPS(aset);
 
-int set_plugin(plugin_set ** set, pset_member memb, reiser4_plugin * plugin) {
+int set_plugin(plugin_set ** set, pset_member memb, reiser4_plugin * plugin)
+{
 	return plugin_set_field(set,
 		(unsigned long)plugin, pset_descr[memb].offset);
 }
diff -puN fs/reiser4/plugin/plugin_set.h~reiser4-code-cleanups fs/reiser4/plugin/plugin_set.h
--- a/fs/reiser4/plugin/plugin_set.h~reiser4-code-cleanups
+++ a/fs/reiser4/plugin/plugin_set.h
@@ -1,9 +1,10 @@
-/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
+/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
+ * reiser4/README */
 
 /* Reiser4 plugin set definition.
    See fs/reiser4/plugin/plugin_set.c for details */
 
-#if !defined( __PLUGIN_SET_H__ )
+#if !defined(__PLUGIN_SET_H__)
 #define __PLUGIN_SET_H__
 
 #include "../type_safe_hash.h"
diff -puN fs/reiser4/plugin/tail_policy.c~reiser4-code-cleanups fs/reiser4/plugin/tail_policy.c
--- a/fs/reiser4/plugin/tail_policy.c~reiser4-code-cleanups
+++ a/fs/reiser4/plugin/tail_policy.c
@@ -35,7 +35,7 @@
 /* Audited by: green(2002.06.12) */
 static int have_formatting_never(const struct inode *inode UNUSED_ARG
 		      /* inode to operate on */ ,
-		      loff_t size UNUSED_ARG /* new object size */ )
+		      loff_t size UNUSED_ARG/* new object size */)
 {
 	return 0;
 }
@@ -45,17 +45,17 @@ static int have_formatting_never(const s
 static int
 have_formatting_always(const struct inode *inode UNUSED_ARG
 		       /* inode to operate on */ ,
-		       loff_t size UNUSED_ARG /* new object size */ )
+		       loff_t size UNUSED_ARG/* new object size */)
 {
 	return 1;
 }
 
-/* This function makes test if we should store file denoted @inode as tails only or
-   as extents only. */
+/* This function makes test if we should store file denoted @inode as tails only
+   or as extents only. */
 static int
 have_formatting_default(const struct inode *inode UNUSED_ARG
 			/* inode to operate on */ ,
-			loff_t size /* new object size */ )
+			loff_t size/* new object size */)
 {
 	assert("umka-1253", inode != NULL);
 
diff -puN fs/reiser4/pool.c~reiser4-code-cleanups fs/reiser4/pool.c
--- a/fs/reiser4/pool.c~reiser4-code-cleanups
+++ a/fs/reiser4/pool.c
@@ -51,7 +51,7 @@
 #include <linux/err.h>
 
 /* initialize new pool object @h */
-static void reiser4_init_pool_obj(struct reiser4_pool_header * h)
+static void reiser4_init_pool_obj(struct reiser4_pool_header *h)
 {
 	INIT_LIST_HEAD(&h->usage_linkage);
 	INIT_LIST_HEAD(&h->level_linkage);
@@ -59,10 +59,10 @@ static void reiser4_init_pool_obj(struct
 }
 
 /* initialize new pool */
-void reiser4_init_pool(struct reiser4_pool * pool /* pool to initialize */ ,
+void reiser4_init_pool(struct reiser4_pool *pool /* pool to initialize */ ,
 		       size_t obj_size /* size of objects in @pool */ ,
 		       int num_of_objs /* number of preallocated objects */ ,
-		       char *data /* area for preallocated objects */ )
+		       char *data/* area for preallocated objects */)
 {
 	struct reiser4_pool_header *h;
 	int i;
@@ -93,7 +93,7 @@ void reiser4_init_pool(struct reiser4_po
    allocated objects.
 
 */
-void reiser4_done_pool(struct reiser4_pool * pool UNUSED_ARG)
+void reiser4_done_pool(struct reiser4_pool *pool UNUSED_ARG)
 {
 }
 
@@ -103,7 +103,7 @@ void reiser4_done_pool(struct reiser4_po
    allocation.
 
 */
-static void *reiser4_pool_alloc(struct reiser4_pool * pool)
+static void *reiser4_pool_alloc(struct reiser4_pool *pool)
 {
 	struct reiser4_pool_header *result;
 
@@ -138,8 +138,8 @@ static void *reiser4_pool_alloc(struct r
 }
 
 /* return object back to the pool */
-void reiser4_pool_free(struct reiser4_pool * pool,
-		       struct reiser4_pool_header * h)
+void reiser4_pool_free(struct reiser4_pool *pool,
+		       struct reiser4_pool_header *h)
 {
 	assert("nikita-961", h != NULL);
 	assert("nikita-962", pool != NULL);
@@ -182,10 +182,10 @@ void reiser4_pool_free(struct reiser4_po
    @list - where to add object;
    @reference - after (or before) which existing object to add
 */
-struct reiser4_pool_header *reiser4_add_obj(struct reiser4_pool * pool,
+struct reiser4_pool_header *reiser4_add_obj(struct reiser4_pool *pool,
 					 struct list_head *list,
 					 pool_ordering order,
-					 struct reiser4_pool_header * reference)
+					 struct reiser4_pool_header *reference)
 {
 	struct reiser4_pool_header *result;
 
diff -puN fs/reiser4/pool.h~reiser4-code-cleanups fs/reiser4/pool.h
--- a/fs/reiser4/pool.h~reiser4-code-cleanups
+++ a/fs/reiser4/pool.h
@@ -1,4 +1,5 @@
-/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
+/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
+ * reiser4/README */
 
 /* Fast pool allocation */
 
@@ -32,13 +33,13 @@ typedef enum {
 
 /* pool manipulation functions */
 
-extern void reiser4_init_pool(struct reiser4_pool * pool, size_t obj_size,
+extern void reiser4_init_pool(struct reiser4_pool *pool, size_t obj_size,
 			      int num_of_objs, char *data);
-extern void reiser4_done_pool(struct reiser4_pool * pool);
-extern void reiser4_pool_free(struct reiser4_pool * pool,
-			      struct reiser4_pool_header * h);
-struct reiser4_pool_header *reiser4_add_obj(struct reiser4_pool * pool,
-					 struct list_head * list,
+extern void reiser4_done_pool(struct reiser4_pool *pool);
+extern void reiser4_pool_free(struct reiser4_pool *pool,
+			      struct reiser4_pool_header *h);
+struct reiser4_pool_header *reiser4_add_obj(struct reiser4_pool *pool,
+					 struct list_head *list,
 					 pool_ordering order,
 					 struct reiser4_pool_header *reference);
 
diff -puN fs/reiser4/readahead.c~reiser4-code-cleanups fs/reiser4/readahead.c
--- a/fs/reiser4/readahead.c~reiser4-code-cleanups
+++ a/fs/reiser4/readahead.c
@@ -11,20 +11,22 @@
 
 #include <linux/swap.h>		/* for totalram_pages */
 
-void reiser4_init_ra_info(ra_info_t * rai)
+void reiser4_init_ra_info(ra_info_t *rai)
 {
 	rai->key_to_stop = *reiser4_min_key();
 }
 
-/* global formatted node readahead parameter. It can be set by mount option -o readahead:NUM:1 */
+/* global formatted node readahead parameter. It can be set by mount option
+ * -o readahead:NUM:1 */
 static inline int ra_adjacent_only(int flags)
 {
 	return flags & RA_ADJACENT_ONLY;
 }
 
-/* this is used by formatted_readahead to decide whether read for right neighbor of node is to be issued. It returns 1
-   if right neighbor's first key is less or equal to readahead's stop key */
-static int should_readahead_neighbor(znode * node, ra_info_t * info)
+/* this is used by formatted_readahead to decide whether read for right neighbor
+ * of node is to be issued. It returns 1 if right neighbor's first key is less
+ * or equal to readahead's stop key */
+static int should_readahead_neighbor(znode * node, ra_info_t *info)
 {
 	int result;
 
@@ -45,7 +47,7 @@ static int low_on_memory(void)
 }
 
 /* start read for @node and for a few of its right neighbors */
-void formatted_readahead(znode * node, ra_info_t * info)
+void formatted_readahead(znode * node, ra_info_t *info)
 {
 	struct formatted_ra_params *ra_params;
 	znode *cur;
@@ -53,7 +55,8 @@ void formatted_readahead(znode * node, r
 	int grn_flags;
 	lock_handle next_lh;
 
-	/* do nothing if node block number has not been assigned to node (which means it is still in cache). */
+	/* do nothing if node block number has not been assigned to node (which
+	 * means it is still in cache). */
 	if (reiser4_blocknr_is_fake(znode_get_block(node)))
 		return;
 
@@ -78,7 +81,7 @@ void formatted_readahead(znode * node, r
 	cur = zref(node);
 	init_lh(&next_lh);
 	while (i < ra_params->max) {
-		const reiser4_block_nr *nextblk;
+		const reiser4_block_nr * nextblk;
 
 		if (!should_readahead_neighbor(cur, info))
 			break;
@@ -90,9 +93,8 @@ void formatted_readahead(znode * node, r
 		nextblk = znode_get_block(next_lh.node);
 		if (reiser4_blocknr_is_fake(nextblk) ||
 		    (ra_adjacent_only(ra_params->flags)
-		     && *nextblk != *znode_get_block(cur) + 1)) {
+		     && *nextblk != *znode_get_block(cur) + 1))
 			break;
-		}
 
 		zput(cur);
 		cur = zref(next_lh.node);
@@ -110,7 +112,7 @@ void formatted_readahead(znode * node, r
 	done_lh(&next_lh);
 }
 
-void reiser4_readdir_readahead_init(struct inode *dir, tap_t * tap)
+void reiser4_readdir_readahead_init(struct inode *dir, tap_t *tap)
 {
 	reiser4_key *stop_key;
 
diff -puN fs/reiser4/readahead.h~reiser4-code-cleanups fs/reiser4/readahead.h
--- a/fs/reiser4/readahead.h~reiser4-code-cleanups
+++ a/fs/reiser4/readahead.h
@@ -1,4 +1,5 @@
-/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
+/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
+ * reiser4/README */
 
 #ifndef __READAHEAD_H__
 #define __READAHEAD_H__
@@ -22,8 +23,8 @@ typedef struct {
 	reiser4_key key_to_stop;
 } ra_info_t;
 
-void formatted_readahead(znode *, ra_info_t *);
-void reiser4_init_ra_info(ra_info_t * rai);
+void formatted_readahead(znode * , ra_info_t *);
+void reiser4_init_ra_info(ra_info_t *rai);
 
 struct reiser4_file_ra_state {
 	loff_t start;		/* Current window */
@@ -35,7 +36,7 @@ struct reiser4_file_ra_state {
 	loff_t slow_start;	/* enlarging r/a size algorithm. */
 };
 
-extern void reiser4_readdir_readahead_init(struct inode *dir, tap_t * tap);
+extern void reiser4_readdir_readahead_init(struct inode *dir, tap_t *tap);
 
 /* __READAHEAD_H__ */
 #endif
diff -puN fs/reiser4/reiser4.h~reiser4-code-cleanups fs/reiser4/reiser4.h
--- a/fs/reiser4/reiser4.h~reiser4-code-cleanups
+++ a/fs/reiser4/reiser4.h
@@ -3,7 +3,7 @@
 
 /* definitions of common constants used by reiser4 */
 
-#if !defined( __REISER4_H__ )
+#if !defined(__REISER4_H__)
 #define __REISER4_H__
 
 #include <asm/param.h>		/* for HZ */
@@ -171,11 +171,12 @@ extern const int REISER4_MAGIC_OFFSET;	/
 */
 #define REISER4_USE_COLLISION_LIMIT    (0)
 
-/* If flush finds more than FLUSH_RELOCATE_THRESHOLD adjacent dirty leaf-level blocks it
-   will force them to be relocated. */
+/* If flush finds more than FLUSH_RELOCATE_THRESHOLD adjacent dirty leaf-level
+   blocks it will force them to be relocated. */
 #define FLUSH_RELOCATE_THRESHOLD 64
-/* If flush finds can find a block allocation closer than at most FLUSH_RELOCATE_DISTANCE
-   from the preceder it will relocate to that position. */
+/* If flush finds can find a block allocation closer than at most
+   FLUSH_RELOCATE_DISTANCE from the preceder it will relocate to that position.
+ */
 #define FLUSH_RELOCATE_DISTANCE  64
 
 /* If we have written this much or more blocks before encountering busy jnode
@@ -222,9 +223,9 @@ extern const int REISER4_MAGIC_OFFSET;	/
 #define REISER4_I reiser4_inode_data
 
 /* implication */
-#define ergo( antecedent, consequent ) ( !( antecedent ) || ( consequent ) )
+#define ergo(antecedent, consequent) (!(antecedent) || (consequent))
 /* logical equivalence */
-#define equi( p1, p2 ) ( ergo( ( p1 ), ( p2 ) ) && ergo( ( p2 ), ( p1 ) ) )
+#define equi(p1, p2) (ergo((p1), (p2)) && ergo((p2), (p1)))
 
 #define sizeof_array(x) ((int) (sizeof(x) / sizeof(x[0])))
 
diff -puN fs/reiser4/safe_link.c~reiser4-code-cleanups fs/reiser4/safe_link.c
--- a/fs/reiser4/safe_link.c~reiser4-code-cleanups
+++ a/fs/reiser4/safe_link.c
@@ -207,7 +207,7 @@ struct safe_link_context {
  * start iterating over all safe-links.
  */
 static void safe_link_iter_begin(reiser4_tree * tree,
-				 struct safe_link_context * ctx)
+				 struct safe_link_context *ctx)
 {
 	ctx->tree = tree;
 	reiser4_key_init(&ctx->key);
@@ -219,7 +219,7 @@ static void safe_link_iter_begin(reiser4
 /*
  * return next safe-link.
  */
-static int safe_link_iter_next(struct safe_link_context * ctx)
+static int safe_link_iter_next(struct safe_link_context *ctx)
 {
 	int result;
 	safelink_t sl;
@@ -238,7 +238,7 @@ static int safe_link_iter_next(struct sa
 /*
  * check are there any more safe-links left in the tree.
  */
-static int safe_link_iter_finished(struct safe_link_context * ctx)
+static int safe_link_iter_finished(struct safe_link_context *ctx)
 {
 	return get_key_locality(&ctx->key) != safe_link_locality(ctx->tree);
 }
@@ -246,7 +246,7 @@ static int safe_link_iter_finished(struc
 /*
  * finish safe-link iteration.
  */
-static void safe_link_iter_end(struct safe_link_context * ctx)
+static void safe_link_iter_end(struct safe_link_context *ctx)
 {
 	/* nothing special */
 }
@@ -294,10 +294,12 @@ static int process_safelink(struct super
 		reiser4_iget_complete(inode);
 		iput(inode);
 		if (result == 0) {
-			result = safe_link_grab(reiser4_get_tree(super), BA_CAN_COMMIT);
+			result = safe_link_grab(reiser4_get_tree(super),
+						BA_CAN_COMMIT);
 			if (result == 0)
 				result =
-				    safe_link_del(reiser4_get_tree(super), oid, link);
+				    safe_link_del(reiser4_get_tree(super), oid,
+						  link);
 			safe_link_release(reiser4_get_tree(super));
 			/*
 			 * restart transaction: if there was large number of
diff -puN fs/reiser4/safe_link.h~reiser4-code-cleanups fs/reiser4/safe_link.h
--- a/fs/reiser4/safe_link.h~reiser4-code-cleanups
+++ a/fs/reiser4/safe_link.h
@@ -3,7 +3,7 @@
 
 /* Safe-links. See safe_link.c for details. */
 
-#if !defined( __FS_SAFE_LINK_H__ )
+#if !defined(__FS_SAFE_LINK_H__)
 #define __FS_SAFE_LINK_H__
 
 #include "tree.h"
diff -puN fs/reiser4/seal.c~reiser4-code-cleanups fs/reiser4/seal.c
--- a/fs/reiser4/seal.c~reiser4-code-cleanups
+++ a/fs/reiser4/seal.c
@@ -43,13 +43,13 @@
 #include "znode.h"
 #include "super.h"
 
-static znode *seal_node(const seal_t * seal);
-static int seal_matches(const seal_t * seal, znode * node);
+static znode *seal_node(const seal_t *seal);
+static int seal_matches(const seal_t *seal, znode * node);
 
 /* initialise seal. This can be called several times on the same seal. @coord
    and @key can be NULL.  */
-void reiser4_seal_init(seal_t * seal /* seal to initialise */ ,
-		       const coord_t * coord /* coord @seal will be
+void reiser4_seal_init(seal_t *seal /* seal to initialise */ ,
+		       const coord_t *coord /* coord @seal will be
 					      *	attached to */ ,
 		       const reiser4_key * key UNUSED_ARG /* key @seal will be
 							   * attached to */ )
@@ -75,14 +75,14 @@ void reiser4_seal_init(seal_t * seal /* 
 }
 
 /* finish with seal */
-void reiser4_seal_done(seal_t * seal /* seal to clear */ )
+void reiser4_seal_done(seal_t *seal/* seal to clear */)
 {
 	assert("nikita-1887", seal != NULL);
 	seal->version = 0;
 }
 
 /* true if seal was initialised */
-int reiser4_seal_is_set(const seal_t * seal /* seal to query */ )
+int reiser4_seal_is_set(const seal_t *seal/* seal to query */)
 {
 	assert("nikita-1890", seal != NULL);
 	return seal->version != 0;
@@ -92,8 +92,8 @@ int reiser4_seal_is_set(const seal_t * s
 /* helper function for reiser4_seal_validate(). It checks that item at @coord
  * has expected key. This is to detect cases where node was modified but wasn't
  * marked dirty. */
-static inline int check_seal_match(const coord_t * coord /* coord to check */ ,
-				   const reiser4_key * k /* expected key */ )
+static inline int check_seal_match(const coord_t *coord /* coord to check */ ,
+				   const reiser4_key * k/* expected key */)
 {
 	reiser4_key ukey;
 
@@ -131,12 +131,12 @@ static int should_repeat(int return_code
    case, but this would complicate callers logic.
 
 */
-int reiser4_seal_validate(seal_t * seal /* seal to validate */,
-			  coord_t * coord /* coord to validate against */,
+int reiser4_seal_validate(seal_t *seal /* seal to validate */,
+			  coord_t *coord /* coord to validate against */,
 			  const reiser4_key * key /* key to validate against */,
 			  lock_handle * lh /* resulting lock handle */,
 			  znode_lock_mode mode /* lock node */,
-			  znode_lock_request request /* locking priority */)
+			  znode_lock_request request/* locking priority */)
 {
 	znode *node;
 	int result;
@@ -185,15 +185,15 @@ int reiser4_seal_validate(seal_t * seal 
 /* helpers functions */
 
 /* obtain reference to znode seal points to, if in cache */
-static znode *seal_node(const seal_t * seal /* seal to query */ )
+static znode *seal_node(const seal_t *seal/* seal to query */)
 {
 	assert("nikita-1891", seal != NULL);
 	return zlook(current_tree, &seal->block);
 }
 
 /* true if @seal version and @node version coincide */
-static int seal_matches(const seal_t * seal /* seal to check */ ,
-			znode * node /* node to check */ )
+static int seal_matches(const seal_t *seal /* seal to check */ ,
+			znode * node/* node to check */)
 {
 	int result;
 
diff -puN fs/reiser4/seal.h~reiser4-code-cleanups fs/reiser4/seal.h
--- a/fs/reiser4/seal.h~reiser4-code-cleanups
+++ a/fs/reiser4/seal.h
@@ -32,7 +32,7 @@ extern void reiser4_seal_init(seal_t *, 
 extern void reiser4_seal_done(seal_t *);
 extern int reiser4_seal_is_set(const seal_t *);
 extern int reiser4_seal_validate(seal_t *, coord_t *,
-			 const reiser4_key *, lock_handle *,
+			 const reiser4_key *, lock_handle * ,
 			 znode_lock_mode mode, znode_lock_request request);
 
 /* __SEAL_H__ */
diff -puN fs/reiser4/search.c~reiser4-code-cleanups fs/reiser4/search.c
--- a/fs/reiser4/search.c~reiser4-code-cleanups
+++ a/fs/reiser4/search.c
@@ -48,7 +48,7 @@ static void cbk_cache_init_slot(cbk_cach
 }
 
 /* Initialize coord cache */
-int cbk_cache_init(cbk_cache *cache /* cache to init */ )
+int cbk_cache_init(cbk_cache * cache/* cache to init */)
 {
 	int i;
 
@@ -70,7 +70,7 @@ int cbk_cache_init(cbk_cache *cache /* c
 }
 
 /* free cbk cache data */
-void cbk_cache_done(cbk_cache * cache /* cache to release */ )
+void cbk_cache_done(cbk_cache * cache/* cache to release */)
 {
 	assert("nikita-2493", cache != NULL);
 	if (cache->slot != NULL) {
@@ -80,14 +80,14 @@ void cbk_cache_done(cbk_cache * cache /*
 }
 
 /* macro to iterate over all cbk cache slots */
-#define for_all_slots(cache, slot)						\
-	for ((slot) = list_entry((cache)->lru.next, cbk_cache_slot, lru);	\
-	     &(cache)->lru != &(slot)->lru;					\
+#define for_all_slots(cache, slot)					  \
+	for ((slot) = list_entry((cache)->lru.next, cbk_cache_slot, lru); \
+	     &(cache)->lru != &(slot)->lru;				  \
 	     (slot) = list_entry(slot->lru.next, cbk_cache_slot, lru))
 
 #if REISER4_DEBUG
 /* this function assures that [cbk-cache-invariant] invariant holds */
-static int cbk_cache_invariant(const cbk_cache *cache)
+static int cbk_cache_invariant(const cbk_cache * cache)
 {
 	cbk_cache_slot *slot;
 	int result;
@@ -112,7 +112,8 @@ static int cbk_cache_invariant(const cbk
 			/* all cached nodes are different */
 			scan = slot;
 			while (result) {
-				scan = list_entry(scan->lru.next, cbk_cache_slot, lru);
+				scan = list_entry(scan->lru.next,
+						  cbk_cache_slot, lru);
 				if (&cache->lru == &scan->lru)
 					break;
 				if (slot->node == scan->node)
@@ -130,7 +131,7 @@ static int cbk_cache_invariant(const cbk
 
 /* Remove references, if any, to @node from coord cache */
 void cbk_cache_invalidate(const znode * node /* node to remove from cache */ ,
-			  reiser4_tree * tree /* tree to remove node from */ )
+			  reiser4_tree * tree/* tree to remove node from */)
 {
 	cbk_cache_slot *slot;
 	cbk_cache *cache;
@@ -156,9 +157,10 @@ void cbk_cache_invalidate(const znode * 
 
 /* add to the cbk-cache in the "tree" information about "node". This
     can actually be update of existing slot in a cache. */
-static void cbk_cache_add(const znode *node /* node to add to the cache */ )
+static void cbk_cache_add(const znode * node/* node to add to the cache */)
 {
 	cbk_cache *cache;
+
 	cbk_cache_slot *slot;
 	int i;
 
@@ -213,14 +215,14 @@ static level_lookup_result search_to_lef
 static cbk_handle *cbk_pack(cbk_handle * handle,
 			    reiser4_tree * tree,
 			    const reiser4_key * key,
-			    coord_t * coord,
+			    coord_t *coord,
 			    lock_handle * active_lh,
 			    lock_handle * parent_lh,
 			    znode_lock_mode lock_mode,
 			    lookup_bias bias,
 			    tree_level lock_level,
 			    tree_level stop_level,
-			    __u32 flags, ra_info_t * info)
+			    __u32 flags, ra_info_t *info)
 {
 	memset(handle, 0, sizeof *handle);
 
@@ -256,7 +258,7 @@ lookup_result coord_by_key(reiser4_tree 
 						 * part of file-system
 						 * super-block */ ,
 			   const reiser4_key * key /* key to look for */ ,
-			   coord_t * coord	/* where to store found
+			   coord_t *coord	/* where to store found
 						 * position in a tree. Fields
 						 * in "coord" are only valid if
 						 * coord_by_key() returned
@@ -273,19 +275,20 @@ lookup_result coord_by_key(reiser4_tree 
 			   lookup_bias bias	/* what to return if coord
 						 * with exactly the @key is
 						 * not in the tree */ ,
-			   tree_level lock_level	/* tree level where to start
-							 * taking @lock type of
-							 * locks */ ,
-			   tree_level stop_level	/* tree level to stop. Pass
-							 * LEAF_LEVEL or TWIG_LEVEL
-							 * here Item being looked
-							 * for has to be between
-							 * @lock_level and
-							 * @stop_level, inclusive */ ,
+			   tree_level lock_level/* tree level where to start
+						 * taking @lock type of
+						 * locks */ ,
+			   tree_level stop_level/* tree level to stop. Pass
+						 * LEAF_LEVEL or TWIG_LEVEL
+						 * here Item being looked
+						 * for has to be between
+						 * @lock_level and
+						 * @stop_level, inclusive */ ,
 			   __u32 flags /* search flags */ ,
 			   ra_info_t *
 			   info
-			   /* information about desired tree traversal readahead */
+			   /* information about desired tree traversal
+			    * readahead */
 			   )
 {
 	cbk_handle handle;
@@ -322,15 +325,15 @@ lookup_result coord_by_key(reiser4_tree 
 
 /* like coord_by_key(), but starts traversal from vroot of @object rather than
  * from tree root. */
-lookup_result reiser4_object_lookup(struct inode * object,
+lookup_result reiser4_object_lookup(struct inode *object,
 				    const reiser4_key * key,
-				    coord_t * coord,
+				    coord_t *coord,
 				    lock_handle * lh,
 				    znode_lock_mode lock_mode,
 				    lookup_bias bias,
 				    tree_level lock_level,
 				    tree_level stop_level, __u32 flags,
-				    ra_info_t * info)
+				    ra_info_t *info)
 {
 	cbk_handle handle;
 	lock_handle parent_lh;
@@ -393,7 +396,7 @@ static lookup_result coord_by_handle(cbk
    sequence of entries with identical keys and alikes.
 */
 int reiser4_iterate_tree(reiser4_tree * tree /* tree to scan */ ,
-			 coord_t * coord /* coord to start from */ ,
+			 coord_t *coord /* coord to start from */ ,
 			 lock_handle * lh /* lock handle to start with and to
 					   * update along the way */ ,
 			 tree_iterate_actor_t actor /* function to call on each
@@ -625,7 +628,7 @@ static int prepare_object_lookup(cbk_han
 
 /* main function that handles common parts of tree traversal: starting
     (fake znode handling), restarts, error handling, completion */
-static lookup_result traverse_tree(cbk_handle * h /* search handle */ )
+static lookup_result traverse_tree(cbk_handle * h/* search handle */)
 {
 	int done;
 	int iterations;
@@ -646,7 +649,7 @@ static lookup_result traverse_tree(cbk_h
 	vroot_used = 0;
 
 	/* loop for restarts */
-      restart:
+restart:
 
 	assert("nikita-3024", reiser4_schedulable());
 
@@ -660,9 +663,9 @@ static lookup_result traverse_tree(cbk_h
 	if (!vroot_used && h->object != NULL) {
 		vroot_used = 1;
 		done = prepare_object_lookup(h);
-		if (done == LOOKUP_REST) {
+		if (done == LOOKUP_REST)
 			goto restart;
-		} else if (done == LOOKUP_DONE)
+		else if (done == LOOKUP_DONE)
 			return h->result;
 	}
 	if (h->parent_lh->node == NULL) {
@@ -747,10 +750,10 @@ static lookup_result traverse_tree(cbk_h
 */
 static void find_child_delimiting_keys(znode * parent	/* parent znode, passed
 							 * locked */ ,
-				       const coord_t * parent_coord	/* coord where
-									 * pointer to
-									 * child is
-									 * stored */ ,
+				       const coord_t *parent_coord
+							/* coord where pointer
+							 * to child is stored
+							 */ ,
 				       reiser4_key * ld	/* where to store left
 							 * delimiting key */ ,
 				       reiser4_key * rd	/* where to store right
@@ -793,7 +796,7 @@ static void find_child_delimiting_keys(z
  * @child child node
  */
 int
-set_child_delimiting_keys(znode * parent, const coord_t * coord, znode * child)
+set_child_delimiting_keys(znode * parent, const coord_t *coord, znode * child)
 {
 	reiser4_tree *tree;
 
@@ -827,7 +830,7 @@ set_child_delimiting_keys(znode * parent
 
    See comments in a code.
 */
-static level_lookup_result cbk_level_lookup(cbk_handle * h /* search handle */ )
+static level_lookup_result cbk_level_lookup(cbk_handle * h/* search handle */)
 {
 	int ret;
 	int setdk;
@@ -944,9 +947,8 @@ static level_lookup_result cbk_level_loo
 		return LOOKUP_REST;
 
 	h->result = zload_ra(active, h->ra_info);
-	if (h->result) {
+	if (h->result)
 		return LOOKUP_DONE;
-	}
 
 	/* sanity checks */
 	if (sanity_check(h)) {
@@ -976,7 +978,7 @@ static level_lookup_result cbk_level_loo
 
 	return ret;
 
-      fail_or_restart:
+fail_or_restart:
 	if (h->result == -E_DEADLOCK)
 		return LOOKUP_REST;
 	return LOOKUP_DONE;
@@ -1038,7 +1040,7 @@ static int key_is_ld(znode * node, const
 /* Process one node during tree traversal.
 
    This is called by cbk_level_lookup(). */
-static level_lookup_result cbk_node_lookup(cbk_handle * h /* search handle */ )
+static level_lookup_result cbk_node_lookup(cbk_handle * h/* search handle */)
 {
 	/* node plugin of @active */
 	node_plugin *nplug;
@@ -1078,9 +1080,9 @@ static level_lookup_result cbk_node_look
 		if (result == NS_FOUND) {
 			/* success of tree lookup */
 			if (!(h->flags & CBK_UNIQUE)
-			    && key_is_ld(active, h->key)) {
+			    && key_is_ld(active, h->key))
 				return search_to_left(h);
-			} else
+			else
 				h->result = CBK_COORD_FOUND;
 		} else {
 			h->result = CBK_COORD_NOTFOUND;
@@ -1115,7 +1117,7 @@ static level_lookup_result cbk_node_look
 }
 
 /* scan cbk_cache slots looking for a match for @h */
-static int cbk_cache_scan_slots(cbk_handle * h /* cbk handle */ )
+static int cbk_cache_scan_slots(cbk_handle * h/* cbk handle */)
 {
 	level_lookup_result llr;
 	znode *node;
@@ -1244,7 +1246,7 @@ static int cbk_cache_scan_slots(cbk_hand
 			result = 0;
 
 			write_lock(&(cache->guard));
-			if (slot->node == h->active_lh->node /*node */ ) {
+			if (slot->node == h->active_lh->node) {
 				/* if this node is still in cbk cache---move
 				   its slot to the head of the LRU list. */
 				list_move(&slot->lru, &cache->lru);
@@ -1283,7 +1285,7 @@ static int cbk_cache_scan_slots(cbk_hand
    of coord_by_key.
 
 */
-static int cbk_cache_search(cbk_handle * h /* cbk handle */ )
+static int cbk_cache_search(cbk_handle * h/* cbk handle */)
 {
 	int result = 0;
 	tree_level level;
@@ -1380,7 +1382,7 @@ static void update_stale_dk(reiser4_tree
  * duplicate keys), it sis cheaper to scan to the left on the stop level once.
  *
  */
-static level_lookup_result search_to_left(cbk_handle * h /* search handle */ )
+static level_lookup_result search_to_left(cbk_handle * h/* search handle */)
 {
 	level_lookup_result result;
 	coord_t *coord;
@@ -1441,7 +1443,7 @@ static level_lookup_result search_to_lef
 				h->flags |= CBK_DKSET;
 
 				h->block = *znode_get_block(neighbor);
-				/* clear coord -> node so that cbk_level_lookup()
+				/* clear coord->node so that cbk_level_lookup()
 				   wouldn't overwrite parent hint in neighbor.
 
 				   Parent hint was set up by
@@ -1464,7 +1466,7 @@ static level_lookup_result search_to_lef
 }
 
 /* debugging aid: return symbolic name of search bias */
-static const char *bias_name(lookup_bias bias /* bias to get name of */ )
+static const char *bias_name(lookup_bias bias/* bias to get name of */)
 {
 	if (bias == FIND_EXACT)
 		return "exact";
@@ -1483,7 +1485,7 @@ static const char *bias_name(lookup_bias
 #if REISER4_DEBUG
 /* debugging aid: print human readable information about @p */
 void print_coord_content(const char *prefix /* prefix to print */ ,
-			 coord_t * p /* coord to print */ )
+			 coord_t *p/* coord to print */)
 {
 	reiser4_key key;
 
@@ -1503,7 +1505,7 @@ void print_coord_content(const char *pre
 
 /* debugging aid: print human readable information about @block */
 void reiser4_print_address(const char *prefix /* prefix to print */ ,
-		   const reiser4_block_nr * block /* block number to print */ )
+		   const reiser4_block_nr * block/* block number to print */)
 {
 	printk("%s: %s\n", prefix, sprint_address(block));
 }
@@ -1511,7 +1513,7 @@ void reiser4_print_address(const char *p
 
 /* return string containing human readable representation of @block */
 char *sprint_address(const reiser4_block_nr *
-		     block /* block number to print */ )
+		     block/* block number to print */)
 {
 	static char address[30];
 
@@ -1525,17 +1527,16 @@ char *sprint_address(const reiser4_block
 }
 
 /* release parent node during traversal */
-static void put_parent(cbk_handle * h /* search handle */ )
+static void put_parent(cbk_handle * h/* search handle */)
 {
 	assert("nikita-383", h != NULL);
-	if (h->parent_lh->node != NULL) {
+	if (h->parent_lh->node != NULL)
 		longterm_unlock_znode(h->parent_lh);
-	}
 }
 
 /* helper function used by coord_by_key(): release reference to parent znode
    stored in handle before processing its child. */
-static void hput(cbk_handle * h /* search handle */ )
+static void hput(cbk_handle * h/* search handle */)
 {
 	assert("nikita-385", h != NULL);
 	done_lh(h->parent_lh);
@@ -1544,7 +1545,7 @@ static void hput(cbk_handle * h /* searc
 
 /* Helper function used by cbk(): update delimiting keys of child node (stored
    in h->active_lh->node) using key taken from parent on the parent level. */
-static int setup_delimiting_keys(cbk_handle * h /* search handle */ )
+static int setup_delimiting_keys(cbk_handle * h/* search handle */)
 {
 	znode *active;
 	reiser4_tree *tree;
@@ -1573,7 +1574,7 @@ static int setup_delimiting_keys(cbk_han
  * pointers */
 static int
 block_nr_is_correct(reiser4_block_nr * block /* block number to check */ ,
-		    reiser4_tree * tree /* tree to check against */ )
+		    reiser4_tree * tree/* tree to check against */)
 {
 	assert("nikita-757", block != NULL);
 	assert("nikita-758", tree != NULL);
@@ -1583,7 +1584,7 @@ block_nr_is_correct(reiser4_block_nr * b
 }
 
 /* check consistency of fields */
-static int sanity_check(cbk_handle * h /* search handle */ )
+static int sanity_check(cbk_handle * h/* search handle */)
 {
 	assert("nikita-384", h != NULL);
 
diff -puN fs/reiser4/status_flags.c~reiser4-code-cleanups fs/reiser4/status_flags.c
--- a/fs/reiser4/status_flags.c~reiser4-code-cleanups
+++ a/fs/reiser4/status_flags.c
@@ -1,7 +1,8 @@
 /* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
  * reiser4/README */
 
-/* Functions that deal with reiser4 status block, query status and update it, if needed */
+/* Functions that deal with reiser4 status block, query status and update it,
+ * if needed */
 
 #include <linux/bio.h>
 #include <linux/highmem.h>
@@ -12,8 +13,8 @@
 #include "status_flags.h"
 #include "super.h"
 
-/* This is our end I/O handler that marks page uptodate if IO was successful. It also
-   unconditionally unlocks the page, so we can see that io was done.
+/* This is our end I/O handler that marks page uptodate if IO was successful.
+   It also unconditionally unlocks the page, so we can see that io was done.
    We do not free bio, because we hope to reuse that. */
 static void reiser4_status_endio(struct bio *bio, int err)
 {
@@ -87,18 +88,19 @@ int reiser4_status_init(reiser4_block_nr
 /* Query the status of fs. Returns if the FS can be safely mounted.
    Also if "status" and "extended" parameters are given, it will fill
    actual parts of status from disk there. */
-int reiser4_status_query(u64 * status, u64 * extended)
+int reiser4_status_query(u64 *status, u64 *extended)
 {
 	struct super_block *sb = reiser4_get_current_sb();
 	struct reiser4_status *statuspage;
 	int retval;
 
-	if (!get_super_private(sb)->status_page) {	// No status page?
+	if (!get_super_private(sb)->status_page)
+	        /* No status page? */
 		return REISER4_STATUS_MOUNT_UNKNOWN;
-	}
 	statuspage = (struct reiser4_status *)
 	    kmap_atomic(get_super_private(sb)->status_page, KM_USER0);
-	switch ((long)le64_to_cpu(get_unaligned(&statuspage->status))) {	// FIXME: this cast is a hack for 32 bit arches to work.
+	switch ((long)le64_to_cpu(get_unaligned(&statuspage->status))) {
+	/* FIXME: this cast is a hack for 32 bit arches to work. */
 	case REISER4_STATUS_OK:
 		retval = REISER4_STATUS_MOUNT_OK;
 		break;
@@ -124,17 +126,17 @@ int reiser4_status_query(u64 * status, u
 	return retval;
 }
 
-/* This function should be called when something bad happens (e.g. from reiser4_panic).
-   It fills the status structure and tries to push it to disk. */
+/* This function should be called when something bad happens (e.g. from
+   reiser4_panic). It fills the status structure and tries to push it to disk.*/
 int reiser4_status_write(__u64 status, __u64 extended_status, char *message)
 {
 	struct super_block *sb = reiser4_get_current_sb();
 	struct reiser4_status *statuspage;
 	struct bio *bio = get_super_private(sb)->status_bio;
 
-	if (!get_super_private(sb)->status_page) {	// No status page?
+	if (!get_super_private(sb)->status_page)
+	        /* No status page? */
 		return -1;
-	}
 	statuspage = (struct reiser4_status *)
 	    kmap_atomic(get_super_private(sb)->status_page, KM_USER0);
 
@@ -150,14 +152,16 @@ int reiser4_status_write(__u64 status, _
 	bio->bi_vcnt = 1;
 	bio->bi_size = sb->s_blocksize;
 	bio->bi_end_io = reiser4_status_endio;
-	lock_page(get_super_private(sb)->status_page);	// Safe as nobody should touch our page.
+	lock_page(get_super_private(sb)->status_page);	/* Safe as nobody should
+							 * touch our page. */
 	/* We can block now, but we have no other choice anyway */
 	submit_bio(WRITE, bio);
 	blk_run_address_space(reiser4_get_super_fake(sb)->i_mapping);
-	return 0;		// We do not wait for io to finish.
+	return 0;		/* We do not wait for io to finish. */
 }
 
-/* Frees the page with status and bio structure. Should be called by disk format at umount time */
+/* Frees the page with status and bio structure. Should be called by disk format
+ * at umount time */
 int reiser4_status_finish(void)
 {
 	struct super_block *sb = reiser4_get_current_sb();
diff -puN fs/reiser4/status_flags.h~reiser4-code-cleanups fs/reiser4/status_flags.h
--- a/fs/reiser4/status_flags.h~reiser4-code-cleanups
+++ a/fs/reiser4/status_flags.h
@@ -5,7 +5,7 @@
    The status that helps us to find out if the filesystem is valid or if it
    contains some critical, or not so critical errors */
 
-#if !defined( __REISER4_STATUS_FLAGS_H__ )
+#if !defined(__REISER4_STATUS_FLAGS_H__)
 #define __REISER4_STATUS_FLAGS_H__
 
 #include "dformat.h"
@@ -29,14 +29,18 @@
 struct reiser4_status {
 	char magic[16];
 	d64 status;		/* Current FS state */
-	d64 extended_status;	/* Any additional info that might have sense in addition to "status". E.g.
-				   last sector where io error happened if status is "io error encountered" */
+	d64 extended_status;	/* Any additional info that might have sense in
+				 * addition to "status". E.g. last sector where
+				 * io error happened if status is
+				 * "io error encountered" */
 	d64 stacktrace[10];	/* Last ten functional calls made (addresses) */
-	char texterror[REISER4_TEXTERROR_LEN];	/* Any error message if appropriate, otherwise filled with zeroes */
+	char texterror[REISER4_TEXTERROR_LEN];	/* Any error message if
+						 * appropriate, otherwise filled
+						 * with zeroes */
 };
 
 int reiser4_status_init(reiser4_block_nr block);
-int reiser4_status_query(u64 * status, u64 * extended);
+int reiser4_status_query(u64 *status, u64 *extended);
 int reiser4_status_write(u64 status, u64 extended_status, char *message);
 int reiser4_status_finish(void);
 
diff -puN fs/reiser4/super.c~reiser4-code-cleanups fs/reiser4/super.c
--- a/fs/reiser4/super.c~reiser4-code-cleanups
+++ a/fs/reiser4/super.c
@@ -22,13 +22,13 @@ static __u64 reserved_for_uid(const stru
 static __u64 reserved_for_root(const struct super_block *super);
 
 /* Return reiser4-specific part of super block */
-reiser4_super_info_data *get_super_private_nocheck(const struct super_block *super	/* super block
-											 * queried */ )
+reiser4_super_info_data *get_super_private_nocheck(const struct super_block *super)
 {
 	return (reiser4_super_info_data *) super->s_fs_info;
 }
 
-/* Return reiser4 fstype: value that is returned in ->f_type field by statfs() */
+/* Return reiser4 fstype: value that is returned in ->f_type field by statfs()
+ */
 long reiser4_statfs_type(const struct super_block *super UNUSED_ARG)
 {
 	assert("nikita-448", super != NULL);
@@ -132,7 +132,7 @@ __u64 reiser4_free_committed_blocks(cons
 long reiser4_reserved_blocks(const struct super_block *super	/* super block
 								   queried */ ,
 			     uid_t uid /* user id */ ,
-			     gid_t gid /* group id */ )
+			     gid_t gid/* group id */)
 {
 	long reserved;
 
@@ -150,7 +150,7 @@ long reiser4_reserved_blocks(const struc
 }
 
 /* get/set value of/to grabbed blocks counter */
-__u64 reiser4_grabbed_blocks(const struct super_block * super)
+__u64 reiser4_grabbed_blocks(const struct super_block *super)
 {
 	assert("zam-512", super != NULL);
 	assert("zam-513", is_reiser4_super(super));
@@ -158,7 +158,7 @@ __u64 reiser4_grabbed_blocks(const struc
 	return get_super_private(super)->blocks_grabbed;
 }
 
-__u64 reiser4_flush_reserved(const struct super_block * super)
+__u64 reiser4_flush_reserved(const struct super_block *super)
 {
 	assert("vpf-285", super != NULL);
 	assert("vpf-286", is_reiser4_super(super));
@@ -167,7 +167,7 @@ __u64 reiser4_flush_reserved(const struc
 }
 
 /* get/set value of/to counter of fake allocated formatted blocks */
-__u64 reiser4_fake_allocated(const struct super_block * super)
+__u64 reiser4_fake_allocated(const struct super_block *super)
 {
 	assert("zam-516", super != NULL);
 	assert("zam-517", is_reiser4_super(super));
@@ -176,7 +176,7 @@ __u64 reiser4_fake_allocated(const struc
 }
 
 /* get/set value of/to counter of fake allocated unformatted blocks */
-__u64 reiser4_fake_allocated_unformatted(const struct super_block * super)
+__u64 reiser4_fake_allocated_unformatted(const struct super_block *super)
 {
 	assert("zam-516", super != NULL);
 	assert("zam-517", is_reiser4_super(super));
@@ -185,7 +185,7 @@ __u64 reiser4_fake_allocated_unformatted
 }
 
 /* get/set value of/to counter of clustered blocks */
-__u64 reiser4_clustered_blocks(const struct super_block * super)
+__u64 reiser4_clustered_blocks(const struct super_block *super)
 {
 	assert("edward-601", super != NULL);
 	assert("edward-602", is_reiser4_super(super));
@@ -203,16 +203,14 @@ reiser4_space_allocator * reiser4_get_sp
 }
 
 /* return fake inode used to bind formatted nodes in the page cache */
-struct inode *reiser4_get_super_fake(const struct super_block *super	/* super block
-								   queried */ )
+struct inode *reiser4_get_super_fake(const struct super_block *super)
 {
 	assert("nikita-1757", super != NULL);
 	return get_super_private(super)->fake;
 }
 
 /* return fake inode used to bind copied on capture nodes in the page cache */
-struct inode *reiser4_get_cc_fake(const struct super_block *super	/* super block
-								   queried */ )
+struct inode *reiser4_get_cc_fake(const struct super_block *super)
 {
 	assert("nikita-1757", super != NULL);
 	return get_super_private(super)->cc;
@@ -226,8 +224,7 @@ struct inode *reiser4_get_bitmap_fake(co
 }
 
 /* tree used by this file system */
-reiser4_tree *reiser4_get_tree(const struct super_block * super	/* super block
-							 * queried */ )
+reiser4_tree *reiser4_get_tree(const struct super_block *super)
 {
 	assert("nikita-460", super != NULL);
 	assert("nikita-461", is_reiser4_super(super));
@@ -236,8 +233,7 @@ reiser4_tree *reiser4_get_tree(const str
 
 /* Check that @super is (looks like) reiser4 super block. This is mainly for
    use in assertions. */
-int is_reiser4_super(const struct super_block *super	/* super block
-							 * queried */ )
+int is_reiser4_super(const struct super_block *super)
 {
 	return
 	    super != NULL &&
@@ -251,27 +247,21 @@ int reiser4_is_set(const struct super_bl
 }
 
 /* amount of blocks reserved for given group in file system */
-static __u64 reserved_for_gid(const struct super_block *super UNUSED_ARG	/* super
-										 * block
-										 * queried */ ,
-			      gid_t gid UNUSED_ARG /* group id */ )
+static __u64 reserved_for_gid(const struct super_block *super UNUSED_ARG,
+			      gid_t gid UNUSED_ARG/* group id */)
 {
 	return 0;
 }
 
 /* amount of blocks reserved for given user in file system */
-static __u64 reserved_for_uid(const struct super_block *super UNUSED_ARG	/* super
-										   block
-										   queried */ ,
-			      uid_t uid UNUSED_ARG /* user id */ )
+static __u64 reserved_for_uid(const struct super_block *super UNUSED_ARG,
+			      uid_t uid UNUSED_ARG/* user id */)
 {
 	return 0;
 }
 
 /* amount of blocks reserved for super user in file system */
-static __u64 reserved_for_root(const struct super_block *super UNUSED_ARG	/* super
-										   block
-										   queried */ )
+static __u64 reserved_for_root(const struct super_block *super UNUSED_ARG)
 {
 	return 0;
 }
diff -puN fs/reiser4/super.h~reiser4-code-cleanups fs/reiser4/super.h
--- a/fs/reiser4/super.h~reiser4-code-cleanups
+++ a/fs/reiser4/super.h
@@ -3,7 +3,7 @@
 
 /* Super-block functions. See super.c for details. */
 
-#if !defined( __REISER4_SUPER_H__ )
+#if !defined(__REISER4_SUPER_H__)
 #define __REISER4_SUPER_H__
 
 #include <linux/exportfs.h>
@@ -299,11 +299,11 @@ struct reiser4_super_info_data {
 };
 
 extern reiser4_super_info_data *get_super_private_nocheck(const struct
-							  super_block *super);
+							  super_block * super);
 
 /* Return reiser4-specific part of super block */
 static inline reiser4_super_info_data *get_super_private(const struct
-							 super_block *super)
+							 super_block * super)
 {
 	assert("nikita-447", super != NULL);
 
@@ -370,7 +370,7 @@ static inline int rofs_jnode(jnode * nod
 
 extern __u64 reiser4_current_block_count(void);
 
-extern void build_object_ops(struct super_block *super, struct object_ops * ops);
+extern void build_object_ops(struct super_block *super, struct object_ops *ops);
 
 #define REISER4_SUPER_MAGIC 0x52345362	/* (*(__u32 *)"R4Sb"); */
 
@@ -433,7 +433,7 @@ extern reiser4_plugin *get_default_plugi
 /* Maximal possible object id. */
 #define  ABSOLUTE_MAX_OID ((oid_t)~0)
 
-#define OIDS_RESERVED  ( 1 << 16 )
+#define OIDS_RESERVED  (1 << 16)
 int oid_init_allocator(struct super_block *, oid_t nr_files, oid_t next);
 oid_t oid_allocate(struct super_block *);
 int oid_release(struct super_block *, oid_t);
diff -puN fs/reiser4/super_ops.c~reiser4-code-cleanups fs/reiser4/super_ops.c
--- a/fs/reiser4/super_ops.c~reiser4-code-cleanups
+++ a/fs/reiser4/super_ops.c
@@ -54,7 +54,7 @@ static void init_once(struct kmem_cache 
 /**
  * init_inodes - create znode cache
  *
- * Initializes slab cache of inodes. It is part of reiser4 module initialization.
+ * Initializes slab cache of inodes. It is part of reiser4 module initialization
  */
 static int init_inodes(void)
 {
@@ -510,7 +510,8 @@ static int fill_super(struct super_block
 		goto failed_init_formatted_fake;
 
 	/* initialize disk format plugin */
-	if ((result = get_super_private(super)->df_plug->init_format(super, data)) != 0 )
+	if ((result = get_super_private(super)->df_plug->init_format(super,
+								    data)) != 0)
 		goto failed_init_disk_format;
 
 	/*
@@ -525,7 +526,7 @@ static int fill_super(struct super_block
 	if ((result = reiser4_init_root_inode(super)) != 0)
 		goto failed_init_root_inode;
 
-	if ((result = get_super_private(super)->df_plug->version_update(super)) != 0 )
+	if ((result = get_super_private(super)->df_plug->version_update(super)) != 0)
 		goto failed_update_format_version;
 
 	process_safelinks(super);
diff -puN fs/reiser4/tap.c~reiser4-code-cleanups fs/reiser4/tap.c
--- a/fs/reiser4/tap.c~reiser4-code-cleanups
+++ a/fs/reiser4/tap.c
@@ -23,14 +23,14 @@
 #include "tree_walk.h"
 
 #if REISER4_DEBUG
-static int tap_invariant(const tap_t * tap);
-static void tap_check(const tap_t * tap);
+static int tap_invariant(const tap_t *tap);
+static void tap_check(const tap_t *tap);
 #else
 #define tap_check(tap) noop
 #endif
 
 /** load node tap is pointing to, if not loaded already */
-int reiser4_tap_load(tap_t * tap)
+int reiser4_tap_load(tap_t *tap)
 {
 	tap_check(tap);
 	if (tap->loaded == 0) {
@@ -47,14 +47,13 @@ int reiser4_tap_load(tap_t * tap)
 }
 
 /** release node tap is pointing to. Dual to tap_load() */
-void reiser4_tap_relse(tap_t * tap)
+void reiser4_tap_relse(tap_t *tap)
 {
 	tap_check(tap);
 	if (tap->loaded > 0) {
 		--tap->loaded;
-		if (tap->loaded == 0) {
+		if (tap->loaded == 0)
 			zrelse(tap->coord->node);
-		}
 	}
 	tap_check(tap);
 }
@@ -63,7 +62,7 @@ void reiser4_tap_relse(tap_t * tap)
  * init tap to consist of @coord and @lh. Locks on nodes will be acquired with
  * @mode
  */
-void reiser4_tap_init(tap_t * tap, coord_t * coord, lock_handle * lh,
+void reiser4_tap_init(tap_t *tap, coord_t *coord, lock_handle * lh,
 		      znode_lock_mode mode)
 {
 	tap->coord = coord;
@@ -75,7 +74,7 @@ void reiser4_tap_init(tap_t * tap, coord
 }
 
 /** add @tap to the per-thread list of all taps */
-void reiser4_tap_monitor(tap_t * tap)
+void reiser4_tap_monitor(tap_t *tap)
 {
 	assert("nikita-2623", tap != NULL);
 	tap_check(tap);
@@ -85,7 +84,7 @@ void reiser4_tap_monitor(tap_t * tap)
 
 /* duplicate @src into @dst. Copy lock handle. @dst is not initially
  * loaded. */
-void reiser4_tap_copy(tap_t * dst, tap_t * src)
+void reiser4_tap_copy(tap_t *dst, tap_t *src)
 {
 	assert("nikita-3193", src != NULL);
 	assert("nikita-3194", dst != NULL);
@@ -100,7 +99,7 @@ void reiser4_tap_copy(tap_t * dst, tap_t
 }
 
 /** finish with @tap */
-void reiser4_tap_done(tap_t * tap)
+void reiser4_tap_done(tap_t *tap)
 {
 	assert("nikita-2565", tap != NULL);
 	tap_check(tap);
@@ -116,7 +115,7 @@ void reiser4_tap_done(tap_t * tap)
  * move @tap to the new node, locked with @target. Load @target, if @tap was
  * already loaded.
  */
-int reiser4_tap_move(tap_t * tap, lock_handle * target)
+int reiser4_tap_move(tap_t *tap, lock_handle * target)
 {
 	int result = 0;
 
@@ -145,7 +144,7 @@ int reiser4_tap_move(tap_t * tap, lock_h
  * move @tap to @target. Acquire lock on @target, if @tap was already
  * loaded.
  */
-static int tap_to(tap_t * tap, znode * target)
+static int tap_to(tap_t *tap, znode * target)
 {
 	int result;
 
@@ -173,7 +172,7 @@ static int tap_to(tap_t * tap, znode * t
  * move @tap to given @target, loading and locking @target->node if
  * necessary
  */
-int tap_to_coord(tap_t * tap, coord_t * target)
+int tap_to_coord(tap_t *tap, coord_t *target)
 {
 	int result;
 
@@ -192,7 +191,7 @@ struct list_head *reiser4_taps_list(void
 }
 
 /** helper function for go_{next,prev}_{item,unit,node}() */
-int go_dir_el(tap_t * tap, sideof dir, int units_p)
+int go_dir_el(tap_t *tap, sideof dir, int units_p)
 {
 	coord_t dup;
 	coord_t *coord;
@@ -254,7 +253,7 @@ int go_dir_el(tap_t * tap, sideof dir, i
  * move @tap to the next unit, transparently crossing item and node
  * boundaries
  */
-int go_next_unit(tap_t * tap)
+int go_next_unit(tap_t *tap)
 {
 	return go_dir_el(tap, RIGHT_SIDE, 1);
 }
@@ -263,7 +262,7 @@ int go_next_unit(tap_t * tap)
  * move @tap to the previous unit, transparently crossing item and node
  * boundaries
  */
-int go_prev_unit(tap_t * tap)
+int go_prev_unit(tap_t *tap)
 {
 	return go_dir_el(tap, LEFT_SIDE, 1);
 }
@@ -272,7 +271,7 @@ int go_prev_unit(tap_t * tap)
  * @shift times apply @actor to the @tap. This is used to move @tap by
  * @shift units (or items, or nodes) in either direction.
  */
-static int rewind_to(tap_t * tap, go_actor_t actor, int shift)
+static int rewind_to(tap_t *tap, go_actor_t actor, int shift)
 {
 	int result;
 
@@ -296,20 +295,20 @@ static int rewind_to(tap_t * tap, go_act
 }
 
 /** move @tap @shift units rightward */
-int rewind_right(tap_t * tap, int shift)
+int rewind_right(tap_t *tap, int shift)
 {
 	return rewind_to(tap, go_next_unit, shift);
 }
 
 /** move @tap @shift units leftward */
-int rewind_left(tap_t * tap, int shift)
+int rewind_left(tap_t *tap, int shift)
 {
 	return rewind_to(tap, go_prev_unit, shift);
 }
 
 #if REISER4_DEBUG
 /** debugging function: print @tap content in human readable form */
-static void print_tap(const char *prefix, const tap_t * tap)
+static void print_tap(const char *prefix, const tap_t *tap)
 {
 	if (tap == NULL) {
 		printk("%s: null tap\n", prefix);
@@ -324,7 +323,7 @@ static void print_tap(const char *prefix
 }
 
 /** check [tap-sane] invariant */
-static int tap_invariant(const tap_t * tap)
+static int tap_invariant(const tap_t *tap)
 {
 	/* [tap-sane] invariant */
 
@@ -353,7 +352,7 @@ static int tap_invariant(const tap_t * t
 }
 
 /** debugging function: check internal @tap consistency */
-static void tap_check(const tap_t * tap)
+static void tap_check(const tap_t *tap)
 {
 	int result;
 
diff -puN fs/reiser4/tap.h~reiser4-code-cleanups fs/reiser4/tap.h
--- a/fs/reiser4/tap.h~reiser4-code-cleanups
+++ a/fs/reiser4/tap.h
@@ -2,7 +2,7 @@
 
 /* Tree Access Pointers. See tap.c for more details. */
 
-#if !defined( __REISER4_TAP_H__ )
+#if !defined(__REISER4_TAP_H__)
 #define __REISER4_TAP_H__
 
 #include "forward.h"
@@ -31,23 +31,23 @@ struct tree_access_pointer {
 	ra_info_t ra_info;
 };
 
-typedef int (*go_actor_t) (tap_t * tap);
+typedef int (*go_actor_t) (tap_t *tap);
 
-extern int reiser4_tap_load(tap_t * tap);
-extern void reiser4_tap_relse(tap_t * tap);
-extern void reiser4_tap_init(tap_t * tap, coord_t * coord, lock_handle * lh,
+extern int reiser4_tap_load(tap_t *tap);
+extern void reiser4_tap_relse(tap_t *tap);
+extern void reiser4_tap_init(tap_t *tap, coord_t *coord, lock_handle * lh,
 		     znode_lock_mode mode);
-extern void reiser4_tap_monitor(tap_t * tap);
-extern void reiser4_tap_copy(tap_t * dst, tap_t * src);
-extern void reiser4_tap_done(tap_t * tap);
-extern int reiser4_tap_move(tap_t * tap, lock_handle * target);
-extern int tap_to_coord(tap_t * tap, coord_t * target);
-
-extern int go_dir_el(tap_t * tap, sideof dir, int units_p);
-extern int go_next_unit(tap_t * tap);
-extern int go_prev_unit(tap_t * tap);
-extern int rewind_right(tap_t * tap, int shift);
-extern int rewind_left(tap_t * tap, int shift);
+extern void reiser4_tap_monitor(tap_t *tap);
+extern void reiser4_tap_copy(tap_t *dst, tap_t *src);
+extern void reiser4_tap_done(tap_t *tap);
+extern int reiser4_tap_move(tap_t *tap, lock_handle * target);
+extern int tap_to_coord(tap_t *tap, coord_t *target);
+
+extern int go_dir_el(tap_t *tap, sideof dir, int units_p);
+extern int go_next_unit(tap_t *tap);
+extern int go_prev_unit(tap_t *tap);
+extern int rewind_right(tap_t *tap, int shift);
+extern int rewind_left(tap_t *tap, int shift);
 
 extern struct list_head *reiser4_taps_list(void);
 
diff -puN fs/reiser4/tree.c~reiser4-code-cleanups fs/reiser4/tree.c
--- a/fs/reiser4/tree.c~reiser4-code-cleanups
+++ a/fs/reiser4/tree.c
@@ -205,10 +205,10 @@ const reiser4_block_nr UBER_TREE_ADDR = 
 
 #define CUT_TREE_MIN_ITERATIONS 64
 
-static int find_child_by_addr(znode * parent, znode * child, coord_t * result);
+static int find_child_by_addr(znode * parent, znode * child, coord_t *result);
 
 /* return node plugin of coord->node */
-node_plugin *node_plugin_by_coord(const coord_t * coord)
+node_plugin *node_plugin_by_coord(const coord_t *coord)
 {
 	assert("vs-1", coord != NULL);
 	assert("vs-2", coord->node != NULL);
@@ -223,11 +223,11 @@ insert_result insert_by_key(reiser4_tree
 			    const reiser4_key * key /* key of new item */ ,
 			    reiser4_item_data * data	/* parameters for item
 							 * creation */ ,
-			    coord_t * coord /* resulting insertion coord */ ,
+			    coord_t *coord /* resulting insertion coord */ ,
 			    lock_handle * lh	/* resulting lock
 						 * handle */ ,
-			    tree_level stop_level /** level where to insert */ ,
-			    __u32 flags /* insertion flags */ )
+			    tree_level stop_level /* level where to insert */ ,
+			    __u32 flags/* insertion flags */)
 {
 	int result;
 
@@ -236,7 +236,7 @@ insert_result insert_by_key(reiser4_tree
 
 	result = coord_by_key(tree, key, coord, lh, ZNODE_WRITE_LOCK,
 			      FIND_EXACT, stop_level, stop_level,
-			      flags | CBK_FOR_INSERT, NULL /*ra_info */ );
+			      flags | CBK_FOR_INSERT, NULL/*ra_info */);
 	switch (result) {
 	default:
 		break;
@@ -245,7 +245,7 @@ insert_result insert_by_key(reiser4_tree
 		break;
 	case CBK_COORD_NOTFOUND:
 		assert("nikita-2017", coord->node != NULL);
-		result = insert_by_coord(coord, data, key, lh, 0 /*flags */ );
+		result = insert_by_coord(coord, data, key, lh, 0/*flags */);
 		break;
 	}
 	return result;
@@ -253,15 +253,18 @@ insert_result insert_by_key(reiser4_tree
 
 /* insert item by calling carry. Helper function called if short-cut
    insertion failed  */
-static insert_result insert_with_carry_by_coord(coord_t * coord,	/* coord where to insert */
-						lock_handle * lh,	/* lock handle of insertion
-									 * node */
-						reiser4_item_data * data,	/* parameters of new
-										 * item */
-						const reiser4_key * key,	/* key of new item */
-						carry_opcode cop,	/* carry operation to perform */
+static insert_result insert_with_carry_by_coord(coord_t *coord,
+					/* coord where to insert */
+						lock_handle * lh,
+					/* lock handle of insertion node */
+						reiser4_item_data * data,
+					/* parameters of new item */
+						const reiser4_key * key,
+					/* key of new item */
+						carry_opcode cop,
+					/* carry operation to perform */
 						cop_insert_flag flags
-						/* carry flags */ )
+					/* carry flags */ )
 {
 	int result;
 	carry_pool *pool;
@@ -314,14 +317,14 @@ static insert_result insert_with_carry_b
    different block.
 
 */
-static int paste_with_carry(coord_t * coord,	/* coord of paste */
+static int paste_with_carry(coord_t *coord,	/* coord of paste */
 			    lock_handle * lh,	/* lock handle of node
 						 * where item is
 						 * pasted */
 			    reiser4_item_data * data,	/* parameters of new
 							 * item */
 			    const reiser4_key * key,	/* key of new item */
-			    unsigned flags /* paste flags */ )
+			    unsigned flags/* paste flags */)
 {
 	int result;
 	carry_pool *pool;
@@ -373,7 +376,7 @@ static int paste_with_carry(coord_t * co
    that will do full carry().
 
 */
-insert_result insert_by_coord(coord_t * coord	/* coord where to
+insert_result insert_by_coord(coord_t *coord	/* coord where to
 						 * insert. coord->node has
 						 * to be write locked by
 						 * caller */ ,
@@ -382,7 +385,7 @@ insert_result insert_by_coord(coord_t * 
 			      const reiser4_key * key /* key of new item */ ,
 			      lock_handle * lh	/* lock handle of write
 						 * lock on node */ ,
-			      __u32 flags /* insertion flags */ )
+			      __u32 flags/* insertion flags */)
 {
 	unsigned item_size;
 	int result;
@@ -447,14 +450,13 @@ insert_result insert_by_coord(coord_t * 
 
 /* @coord is set to leaf level and @data is to be inserted to twig level */
 insert_result
-insert_extent_by_coord(coord_t *
-		       coord
-		       /* coord where to insert. coord->node * has to be write * locked by caller */
-		       ,
-		       reiser4_item_data * data /* data to be inserted */ ,
-		       const reiser4_key * key /* key of new item */ ,
-		       lock_handle *
-		       lh /* lock handle of write lock on * node */ )
+insert_extent_by_coord(coord_t *coord,         /* coord where to insert.
+				                * coord->node has to be write
+					        * locked by caller */
+		       reiser4_item_data *data,/* data to be inserted */
+		       const reiser4_key *key, /* key of new item */
+		       lock_handle *lh         /* lock handle of write lock
+						  on node */)
 {
 	assert("vs-405", coord != NULL);
 	assert("vs-406", data != NULL);
@@ -1638,7 +1640,7 @@ cut_tree_worker_common(tap_t * tap, cons
 			}
 
 			/* cut data from one node */
-			// *smallest_removed = *reiser4_min_key();
+			/* *smallest_removed = *reiser4_min_key(); */
 			result =
 			    kill_node_content(&left_coord, tap->coord, from_key,
 					      to_key, smallest_removed,
@@ -1674,7 +1676,7 @@ cut_tree_worker_common(tap_t * tap, cons
 		}
 	}
 	done_lh(&next_node_lock);
-	// assert("vs-301", !keyeq(&smallest_removed, reiser4_min_key()));
+	/* assert("vs-301", !keyeq(&smallest_removed, reiser4_min_key())); */
 	return result;
 }
 
diff -puN fs/reiser4/wander.c~reiser4-code-cleanups fs/reiser4/wander.c
--- a/fs/reiser4/wander.c~reiser4-code-cleanups
+++ a/fs/reiser4/wander.c
@@ -440,8 +440,8 @@ static int update_journal_header(struct 
 	if (ret)
 		return ret;
 
-	// blk_run_address_space(sbinfo->fake->i_mapping);
-	/*blk_run_queues(); */
+	/* blk_run_address_space(sbinfo->fake->i_mapping);
+	 * blk_run_queues(); */
 
 	ret = jwait_io(jh, WRITE);
 
@@ -471,8 +471,8 @@ static int update_journal_footer(struct 
 	if (ret)
 		return ret;
 
-	// blk_run_address_space(sbinfo->fake->i_mapping);
-	/*blk_run_queue(); */
+	/* blk_run_address_space(sbinfo->fake->i_mapping);
+	 * blk_run_queue(); */
 
 	ret = jwait_io(jf, WRITE);
 	if (ret)
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

origin.patch
reiser4.patch
reiser4-code-cleanups.patch

