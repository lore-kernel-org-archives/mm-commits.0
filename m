From: akpm@linux-foundation.org
Subject: - group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch removed from -mm tree
Date: Tue, 29 May 2007 13:29:10 -0700
Message-ID: <200705292029.l4TKTB98010736@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757693AbXE2UaR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 16:30:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Use SLAB_ACCOUNT_RECLAIM to determine when __GFP_RECLAIMABLE should be used
has been removed from the -mm tree.  Its filename was
     group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch

This patch was dropped because it was folded into group-short-lived-and-reclaimable-kernel-allocations.patch

------------------------------------------------------
Subject: Use SLAB_ACCOUNT_RECLAIM to determine when __GFP_RECLAIMABLE should be used
From: Mel Gorman <mel@csn.ul.ie>

A number of slab caches are reclaimable and some of their allocation callsites
were updated to use the __GFP_RECLAIMABLE flag.  However, slabs that are
reclaimable specify the SLAB_ACCOUNT_RECLAIM flag at creation time and this
information is available at the time of page allocation.

This patch uses the SLAB_ACCOUNT_RECLAIM flag in the SLAB and SLUB allocators
to determine if __GFP_RECLAIMABLE should be used when allocating pages.  The
SLOB allocator is not updated as it is unlikely to be used on a system where
grouping pages by mobility is worthwhile and now SLUB is recommended over SLOB
for smaller systems.  The callsites for reclaimable cache allocations no
longer specify __GFP_RECLAIMABLE as the information is redundant.  This can be
considered as fix to
group-short-lived-and-reclaimable-kernel-allocations.patch.

Credit goes to Christoph Lameter for identifying this problem during review
and suggesting this fix.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c         |    2 +-
 fs/ext2/super.c     |    3 +--
 fs/ext3/super.c     |    2 +-
 fs/ntfs/inode.c     |    4 ++--
 fs/reiserfs/super.c |    3 +--
 mm/slab.c           |    2 ++
 mm/slub.c           |    3 +++
 7 files changed, 11 insertions(+), 8 deletions(-)

diff -puN fs/dcache.c~group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used fs/dcache.c
--- a/fs/dcache.c~group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used
+++ a/fs/dcache.c
@@ -898,7 +898,7 @@ struct dentry *d_alloc(struct dentry * p
 	struct dentry *dentry;
 	char *dname;
 
-	dentry = kmem_cache_alloc(dentry_cache, GFP_KERNEL|__GFP_RECLAIMABLE);
+	dentry = kmem_cache_alloc(dentry_cache, GFP_KERNEL);
 	if (!dentry)
 		return NULL;
 
diff -puN fs/ext2/super.c~group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used fs/ext2/super.c
--- a/fs/ext2/super.c~group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used
+++ a/fs/ext2/super.c
@@ -140,8 +140,7 @@ static struct kmem_cache * ext2_inode_ca
 static struct inode *ext2_alloc_inode(struct super_block *sb)
 {
 	struct ext2_inode_info *ei;
-	ei = (struct ext2_inode_info *)kmem_cache_alloc(ext2_inode_cachep,
-						GFP_KERNEL|__GFP_RECLAIMABLE);
+	ei = (struct ext2_inode_info *)kmem_cache_alloc(ext2_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 #ifdef CONFIG_EXT2_FS_POSIX_ACL
diff -puN fs/ext3/super.c~group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used fs/ext3/super.c
--- a/fs/ext3/super.c~group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used
+++ a/fs/ext3/super.c
@@ -445,7 +445,7 @@ static struct inode *ext3_alloc_inode(st
 {
 	struct ext3_inode_info *ei;
 
-	ei = kmem_cache_alloc(ext3_inode_cachep, GFP_NOFS|__GFP_RECLAIMABLE);
+	ei = kmem_cache_alloc(ext3_inode_cachep, GFP_NOFS);
 	if (!ei)
 		return NULL;
 #ifdef CONFIG_EXT3_FS_POSIX_ACL
diff -puN fs/ntfs/inode.c~group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used fs/ntfs/inode.c
--- a/fs/ntfs/inode.c~group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used
+++ a/fs/ntfs/inode.c
@@ -323,7 +323,7 @@ struct inode *ntfs_alloc_big_inode(struc
 	ntfs_inode *ni;
 
 	ntfs_debug("Entering.");
-	ni = kmem_cache_alloc(ntfs_big_inode_cache, GFP_NOFS|__GFP_RECLAIMABLE);
+	ni = kmem_cache_alloc(ntfs_big_inode_cache, GFP_NOFS);
 	if (likely(ni != NULL)) {
 		ni->state = 0;
 		return VFS_I(ni);
@@ -348,7 +348,7 @@ static inline ntfs_inode *ntfs_alloc_ext
 	ntfs_inode *ni;
 
 	ntfs_debug("Entering.");
-	ni = kmem_cache_alloc(ntfs_inode_cache, GFP_NOFS|__GFP_RECLAIMABLE);
+	ni = kmem_cache_alloc(ntfs_inode_cache, GFP_NOFS);
 	if (likely(ni != NULL)) {
 		ni->state = 0;
 		return ni;
diff -puN fs/reiserfs/super.c~group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used
+++ a/fs/reiserfs/super.c
@@ -496,8 +496,7 @@ static struct inode *reiserfs_alloc_inod
 {
 	struct reiserfs_inode_info *ei;
 	ei = (struct reiserfs_inode_info *)
-	    kmem_cache_alloc(reiserfs_inode_cachep,
-						GFP_KERNEL|__GFP_RECLAIMABLE);
+	    kmem_cache_alloc(reiserfs_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
diff -puN mm/slab.c~group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used mm/slab.c
--- a/mm/slab.c~group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used
+++ a/mm/slab.c
@@ -1637,6 +1637,8 @@ static void *kmem_getpages(struct kmem_c
 #endif
 
 	flags |= cachep->gfpflags;
+	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
+		flags |= __GFP_RECLAIMABLE;
 
 	page = alloc_pages_node(nodeid, flags, cachep->gfporder);
 	if (!page)
diff -puN mm/slub.c~group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used mm/slub.c
--- a/mm/slub.c~group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used
+++ a/mm/slub.c
@@ -985,6 +985,9 @@ static struct page *allocate_slab(struct
 	if (s->flags & SLAB_CACHE_DMA)
 		flags |= SLUB_DMA;
 
+	if (s->flags & SLAB_ACCOUNT_RECLAIM)
+		gfpflags |= __GFP_RECLAIMABLE;
+
 	if (node == -1)
 		page = alloc_pages(flags, s->order);
 	else
_

Patches currently in -mm which might be from mel@csn.ul.ie are

x86_64-extract-helper-function-from-e820_register_active_regions.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
group-short-lived-and-reclaimable-kernel-allocations-do-not-annotate-shmem-allocations-explicitly.patch
group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived.patch
group-high-order-atomic-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
dont-group-high-order-atomic-allocations-remove-unused-parameter-to-allocflags_to_migratetype.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
remove-alloc_zeroed_user_highpage.patch
create-the-zone_movable-zone.patch
create-the-zone_movable-zone-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-2.patch
handle-kernelcore=-generic.patch
lumpy-reclaim-v4.patch
lumpy-move-to-using-pfn_valid_within.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch
add-debugging-aid-for-memory-initialisation-problems.patch
