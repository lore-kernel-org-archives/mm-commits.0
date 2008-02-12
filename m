From: akpm@linux-foundation.org
Subject: + remove-set_migrateflags.patch added to -mm tree
Date: Tue, 12 Feb 2008 13:46:23 -0800
Message-ID: <200802122146.m1CLkNSr023883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40775 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981AbYBLVqh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 16:46:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, mel@csn.ul.ie


The patch titled
     Remove set_migrateflags()
has been added to the -mm tree.  Its filename is
     remove-set_migrateflags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -3169,8 +3169,7 @@ static void recalc_bh_state(void)
 	
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
gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab-slabinfo-fallback-from-sys-kernel-slab-to-sys-slab.patch
git-unionfs.patch
mempolicy-silently-restrict-nodemask-to-allowed-nodes-v3.patch
remove-set_migrateflags.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
