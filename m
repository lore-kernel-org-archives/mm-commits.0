From: akpm@linux-foundation.org
Subject: - radix-tree-avoid-atomic-allocations-for-preloaded-insertions.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:31:33 -0800
Message-ID: <200802052231.m15MVEj9012154@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53379 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760839AbYBEWlv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     radix-tree: avoid atomic allocations for preloaded insertions
has been removed from the -mm tree.  Its filename was
     radix-tree-avoid-atomic-allocations-for-preloaded-insertions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radix-tree: avoid atomic allocations for preloaded insertions
From: Nick Piggin <npiggin@suse.de>

Most pagecache (and some other) radix tree insertions have the great
opportunity to preallocate a few nodes with relaxed gfp flags.  But the
preallocation is squandered when it comes time to allocate a node, we
default to first attempting a GFP_ATOMIC allocation -- that doesn't
normally fail, but it can eat into atomic memory reserves that we don't
need to be using.

Another upshot of this is that it removes the sometimes highly contended
zone->lock from underneath tree_lock.  Pagecache insertions are always
performed with a radix tree preload, and after this change, such a
situation will never fall back to kmem_cache_alloc within
radix_tree_node_alloc.

David Miller reports seeing this allocation fail on a highly threaded
sparc64 system:

[527319.459981] dd: page allocation failure. order:0, mode:0x20
[527319.460403] Call Trace:
[527319.460568]  [00000000004b71e0] __slab_alloc+0x1b0/0x6a8
[527319.460636]  [00000000004b7bbc] kmem_cache_alloc+0x4c/0xa8
[527319.460698]  [000000000055309c] radix_tree_node_alloc+0x20/0x90
[527319.460763]  [0000000000553238] radix_tree_insert+0x12c/0x260
[527319.460830]  [0000000000495cd0] add_to_page_cache+0x38/0xb0
[527319.460893]  [00000000004e4794] mpage_readpages+0x6c/0x134
[527319.460955]  [000000000049c7fc] __do_page_cache_readahead+0x170/0x280
[527319.461028]  [000000000049cc88] ondemand_readahead+0x208/0x214
[527319.461094]  [0000000000496018] do_generic_mapping_read+0xe8/0x428
[527319.461152]  [0000000000497948] generic_file_aio_read+0x108/0x170
[527319.461217]  [00000000004badac] do_sync_read+0x88/0xd0
[527319.461292]  [00000000004bb5cc] vfs_read+0x78/0x10c
[527319.461361]  [00000000004bb920] sys_read+0x34/0x60
[527319.461424]  [0000000000406294] linux_sparc_syscall32+0x3c/0x40

The calltrace is significant: __do_page_cache_readahead allocates a number
of pages with GFP_KERNEL, and hence it should have reclaimed sufficient
memory to satisfy GFP_ATOMIC allocations.  However after the list of pages
goes to mpage_readpages, there can be significant intervals (including disk
IO) before all the pages are inserted into the radix-tree.  So the reserves
can easily be depleted at that point.  The patch is confirmed to fix the
problem.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   15 +++++++++++----
 mm/filemap.c     |    1 -
 mm/rmap.c        |    1 -
 3 files changed, 11 insertions(+), 6 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-avoid-atomic-allocations-for-preloaded-insertions lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-avoid-atomic-allocations-for-preloaded-insertions
+++ a/lib/radix-tree.c
@@ -95,14 +95,17 @@ static inline gfp_t root_gfp_mask(struct
 static struct radix_tree_node *
 radix_tree_node_alloc(struct radix_tree_root *root)
 {
-	struct radix_tree_node *ret;
+	struct radix_tree_node *ret = NULL;
 	gfp_t gfp_mask = root_gfp_mask(root);
 
-	ret = kmem_cache_alloc(radix_tree_node_cachep,
-				set_migrateflags(gfp_mask, __GFP_RECLAIMABLE));
-	if (ret == NULL && !(gfp_mask & __GFP_WAIT)) {
+	if (!(gfp_mask & __GFP_WAIT)) {
 		struct radix_tree_preload *rtp;
 
+		/*
+		 * Provided the caller has preloaded here, we will always
+		 * succeed in getting a node here (and never reach
+		 * kmem_cache_alloc)
+		 */
 		rtp = &__get_cpu_var(radix_tree_preloads);
 		if (rtp->nr) {
 			ret = rtp->nodes[rtp->nr - 1];
@@ -110,6 +113,10 @@ radix_tree_node_alloc(struct radix_tree_
 			rtp->nr--;
 		}
 	}
+	if (ret == NULL)
+		ret = kmem_cache_alloc(radix_tree_node_cachep,
+				set_migrateflags(gfp_mask, __GFP_RECLAIMABLE));
+
 	BUG_ON(radix_tree_is_indirect_ptr(ret));
 	return ret;
 }
diff -puN mm/filemap.c~radix-tree-avoid-atomic-allocations-for-preloaded-insertions mm/filemap.c
--- a/mm/filemap.c~radix-tree-avoid-atomic-allocations-for-preloaded-insertions
+++ a/mm/filemap.c
@@ -65,7 +65,6 @@ generic_file_direct_IO(int rw, struct ki
  *    ->private_lock		(__free_pte->__set_page_dirty_buffers)
  *      ->swap_lock		(exclusive_swap_page, others)
  *        ->mapping->tree_lock
- *          ->zone.lock
  *
  *  ->i_mutex
  *    ->i_mmap_lock		(truncate->unmap_mapping_range)
diff -puN mm/rmap.c~radix-tree-avoid-atomic-allocations-for-preloaded-insertions mm/rmap.c
--- a/mm/rmap.c~radix-tree-avoid-atomic-allocations-for-preloaded-insertions
+++ a/mm/rmap.c
@@ -36,7 +36,6 @@
  *                 mapping->tree_lock (widely used, in set_page_dirty,
  *                           in arch-dependent flush_dcache_mmap_lock,
  *                           within inode_lock in __sync_single_inode)
- *                   zone->lock (within radix tree node alloc)
  */
 
 #include <linux/mm.h>
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-special-mapping-nopage.patch
drm-convert-from-nopage-to-fault.patch
git-kvm.patch
nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
sg-nopage.patch
vt-bitlock-fix.patch
inotify-fix-race.patch
inotify-remove-debug-code.patch
relay-nopage.patch
uio-nopage.patch
ext2-xip-check-fix.patch
fb-defio-nopage.patch
rewrite-rd.patch
rewrite-rd-fix.patch
rewrite-rd-fix-2.patch
rd-support-xip.patch
mm-remove-nopage.patch
buffer_head-fix-private_list-handling.patch
reiser4.patch
reiser4-correct-references-to-filemap_nopage.patch
