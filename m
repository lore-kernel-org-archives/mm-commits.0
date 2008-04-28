From: akpm@linux-foundation.org
Subject: - remove-set_migrateflags.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:50:37 -0700
Message-ID: <200804282150.m3SLobXW017491@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934590AbYD1Vur (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:50:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Remove set_migrateflags()
has been removed from the -mm tree.  Its filename was
     remove-set_migrateflags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Remove set_migrateflags()
From: Christoph Lameter <clameter@sgi.com>

Migrate flags must be set on slab creation as agreed upon when the antifrag
logic was reviewed.  Otherwise some slabs of a slabcache will end up in the
unmovable and others in the reclaimable section depending on which flag was
active when a new slab page was allocated.

This likely slid in somehow when antifrag was merged. Remove it.

The buffer_heads are always allocated with __GFP_RECLAIMABLE because the
SLAB_RECLAIM_ACCOUNT option is set.  The set_migrateflags() never had any
effect there.

Radix tree allocations are not directly reclaimable but they are allocated
with __GFP_RECLAIMABLE set on each allocation.  We now set
SLAB_RECLAIM_ACCOUNT on radix tree slab creation making sure that radix
tree slabs are consistently placed in the reclaimable section.  Radix tree
slabs will also be accounted as such.

There is then no user left of set_migratepages. So remove it.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c         |    3 +--
 include/linux/gfp.h |    6 ------
 lib/radix-tree.c    |    9 ++++-----
 3 files changed, 5 insertions(+), 13 deletions(-)

diff -puN fs/buffer.c~remove-set_migrateflags fs/buffer.c
--- a/fs/buffer.c~remove-set_migrateflags
+++ a/fs/buffer.c
@@ -3180,8 +3180,7 @@ static void recalc_bh_state(void)
 	
 struct buffer_head *alloc_buffer_head(gfp_t gfp_flags)
 {
-	struct buffer_head *ret = kmem_cache_alloc(bh_cachep,
-				set_migrateflags(gfp_flags, __GFP_RECLAIMABLE));
+	struct buffer_head *ret = kmem_cache_alloc(bh_cachep, gfp_flags);
 	if (ret) {
 		INIT_LIST_HEAD(&ret->b_assoc_buffers);
 		get_cpu_var(bh_accounting).nr++;
diff -puN include/linux/gfp.h~remove-set_migrateflags include/linux/gfp.h
--- a/include/linux/gfp.h~remove-set_migrateflags
+++ a/include/linux/gfp.h
@@ -144,12 +144,6 @@ static inline enum zone_type gfp_zone(gf
 	return base + ZONE_NORMAL;
 }
 
-static inline gfp_t set_migrateflags(gfp_t gfp, gfp_t migrate_flags)
-{
-	BUG_ON((gfp & GFP_MOVABLE_MASK) == GFP_MOVABLE_MASK);
-	return (gfp & ~(GFP_MOVABLE_MASK)) | migrate_flags;
-}
-
 /*
  * There is only one page-allocator function, and two main namespaces to
  * it. The alloc_page*() variants return 'struct page *' and as such
diff -puN lib/radix-tree.c~remove-set_migrateflags lib/radix-tree.c
--- a/lib/radix-tree.c~remove-set_migrateflags
+++ a/lib/radix-tree.c
@@ -114,8 +114,7 @@ radix_tree_node_alloc(struct radix_tree_
 		}
 	}
 	if (ret == NULL)
-		ret = kmem_cache_alloc(radix_tree_node_cachep,
-				set_migrateflags(gfp_mask, __GFP_RECLAIMABLE));
+		ret = kmem_cache_alloc(radix_tree_node_cachep, gfp_mask);
 
 	BUG_ON(radix_tree_is_indirect_ptr(ret));
 	return ret;
@@ -150,8 +149,7 @@ int radix_tree_preload(gfp_t gfp_mask)
 	rtp = &__get_cpu_var(radix_tree_preloads);
 	while (rtp->nr < ARRAY_SIZE(rtp->nodes)) {
 		preempt_enable();
-		node = kmem_cache_alloc(radix_tree_node_cachep,
-				set_migrateflags(gfp_mask, __GFP_RECLAIMABLE));
+		node = kmem_cache_alloc(radix_tree_node_cachep, gfp_mask);
 		if (node == NULL)
 			goto out;
 		preempt_disable();
@@ -1098,7 +1096,8 @@ void __init radix_tree_init(void)
 {
 	radix_tree_node_cachep = kmem_cache_create("radix_tree_node",
 			sizeof(struct radix_tree_node), 0,
-			SLAB_PANIC, radix_tree_node_ctor);
+			SLAB_PANIC | SLAB_RECLAIM_ACCOUNT,
+			radix_tree_node_ctor);
 	radix_tree_init_maxindex();
 	hotcpu_notifier(radix_tree_callback, 0);
 }
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
git-unionfs.patch
git-pekka.patch
page-allcoator-smarter-retry-of-costly-order-allocations.patch
page-allocator-explicitly-retry-hugepage-allocations.patch
ipc-add-definitions-of-ushort_max-and-others.patch
mm-add-nr_writeback_temp-counter.patch
remove-div_long_long_rem.patch
slab-add-a-flag-to-prevent-debug_free-checks-on-a-kmem_cache.patch
add-kbuildh-that-contains-common-definitions-for-kbuild-users.patch
x86-use-kbuildh.patch
mips-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
alpha-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
ia64-use-kbuildh-macros-instead-of-defining-macros-in-asm-offsetsc.patch
arm-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
xtensa-use-kbuildh-macros-instead-of-defining-them-in-asm-offsetsc.patch
sparc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
avr32-use-kbuildh-macros-instead-of-defining-macros-in-asm-offsetsc.patch
blackfin-use-kbuildh-instead-of-defining-macros-in-asm-macrosc.patch
frv-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
h8300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
m68k-m68kmmu-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
mn10300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
parisc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
ppc-powerpc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc-update.patch
sh-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
v850-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

