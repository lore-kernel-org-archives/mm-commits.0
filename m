From: akpm@linux-foundation.org
Subject: - group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived.patch removed from -mm tree
Date: Tue, 29 May 2007 13:29:20 -0700
Message-ID: <200705292029.l4TKTKtf010749@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758478AbXE2Ua1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 16:30:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Add __GFP_TEMPORARY to identify allocations that are short-lived
has been removed from the -mm tree.  Its filename was
     group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived.patch

This patch was dropped because it was folded into group-short-lived-and-reclaimable-kernel-allocations.patch

------------------------------------------------------
Subject: Add __GFP_TEMPORARY to identify allocations that are short-lived
From: Mel Gorman <mel@csn.ul.ie>

Currently allocations that are short-lived or reclaimable by the kernel are
grouped together by specifying __GFP_RECLAIMABLE in the GFP flags.  However,
it is confusing when reading code to see a temporary allocation using
__GFP_RECLAIMABLE when it is clearly not reclaimable.

This patch adds __GFP_TEMPORARY, GFP_TEMPORARY and SLAB_TEMPORARY for
temporary allocations.  The journal_handle, journal_head, revoke_table,
revoke_record, skbuff_head_cache and skbuff_fclone_cache slabs are converted
to use SLAB_TEMPORARY instead of flagging the allocation call-sites.  In the
implementation, reclaimable and temporary allocations are grouped into the
same blocks but this might change in the future.  This change makes call sites
for temporary allocations clearer.  Not all temporary allocations were
previously flagged.  This patch flags a few additional allocations
appropriately.

Note that some GFP_USER and GFP_KERNEL allocations are both changed to
GFP_TEMPORARY.  The difference between GFP_USER and GFP_KERNEL is only in how
cpuset boundaries are handled which is unimportant to temporary allocations.

This patch can be considered as fix to
group-short-lived-and-reclaimable-kernel-allocations.patch.

Credit goes to Christoph Lameter for identifying the problems in relation to
temporary allocations during review and providing an illustration-of-concept
patch to act as a starting point.

[clameter@sgi.com: patch framework]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/acsi_slm.c |    2 +-
 fs/jbd/journal.c         |   10 ++++------
 fs/jbd/revoke.c          |   14 ++++++++------
 fs/proc/base.c           |   12 ++++++------
 fs/proc/generic.c        |    2 +-
 include/linux/gfp.h      |    2 ++
 include/linux/slab.h     |    4 +++-
 kernel/cpuset.c          |    2 +-
 mm/slub.c                |    2 +-
 net/core/skbuff.c        |   19 +++++++++----------
 10 files changed, 36 insertions(+), 33 deletions(-)

diff -puN drivers/block/acsi_slm.c~group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived drivers/block/acsi_slm.c
--- a/drivers/block/acsi_slm.c~group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived
+++ a/drivers/block/acsi_slm.c
@@ -367,7 +367,7 @@ static ssize_t slm_read( struct file *fi
 	int length;
 	int end;
 
-	if (!(page = __get_free_page( GFP_KERNEL )))
+	if (!(page = __get_free_page(GFP_TEMPORARY)))
 		return( -ENOMEM );
 	
 	length = slm_getstats( (char *)page, iminor(node) );
diff -puN fs/jbd/journal.c~group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived fs/jbd/journal.c
--- a/fs/jbd/journal.c~group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived
+++ a/fs/jbd/journal.c
@@ -1710,7 +1710,7 @@ static int journal_init_journal_head_cac
 	journal_head_cache = kmem_cache_create("journal_head",
 				sizeof(struct journal_head),
 				0,		/* offset */
-				0,		/* flags */
+				SLAB_TEMPORARY,	/* flags */
 				NULL,		/* ctor */
 				NULL);		/* dtor */
 	retval = 0;
@@ -1739,8 +1739,7 @@ static struct journal_head *journal_allo
 #ifdef CONFIG_JBD_DEBUG
 	atomic_inc(&nr_journal_heads);
 #endif
-	ret = kmem_cache_alloc(journal_head_cache,
-			set_migrateflags(GFP_NOFS, __GFP_RECLAIMABLE));
+	ret = kmem_cache_alloc(journal_head_cache, GFP_NOFS);
 	if (ret == 0) {
 		jbd_debug(1, "out of memory for journal_head\n");
 		if (time_after(jiffies, last_warning + 5*HZ)) {
@@ -1750,8 +1749,7 @@ static struct journal_head *journal_allo
 		}
 		while (ret == 0) {
 			yield();
-			ret = kmem_cache_alloc(journal_head_cache,
-					GFP_NOFS|__GFP_RECLAIMABLE);
+			ret = kmem_cache_alloc(journal_head_cache, GFP_NOFS);
 		}
 	}
 	return ret;
@@ -2009,7 +2007,7 @@ static int __init journal_init_handle_ca
 	jbd_handle_cache = kmem_cache_create("journal_handle",
 				sizeof(handle_t),
 				0,		/* offset */
-				0,		/* flags */
+				SLAB_TEMPORARY,	/* flags */
 				NULL,		/* ctor */
 				NULL);		/* dtor */
 	if (jbd_handle_cache == NULL) {
diff -puN fs/jbd/revoke.c~group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived fs/jbd/revoke.c
--- a/fs/jbd/revoke.c~group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived
+++ a/fs/jbd/revoke.c
@@ -169,13 +169,17 @@ int __init journal_init_revoke_caches(vo
 {
 	revoke_record_cache = kmem_cache_create("revoke_record",
 					   sizeof(struct jbd_revoke_record_s),
-					   0, SLAB_HWCACHE_ALIGN, NULL, NULL);
+					   0,
+					   SLAB_HWCACHE_ALIGN|SLAB_TEMPORARY,
+					   NULL, NULL);
 	if (revoke_record_cache == 0)
 		return -ENOMEM;
 
 	revoke_table_cache = kmem_cache_create("revoke_table",
 					   sizeof(struct jbd_revoke_table_s),
-					   0, 0, NULL, NULL);
+					   0,
+					   SLAB_TEMPORARY,
+					   NULL, NULL);
 	if (revoke_table_cache == 0) {
 		kmem_cache_destroy(revoke_record_cache);
 		revoke_record_cache = NULL;
@@ -205,8 +209,7 @@ int journal_init_revoke(journal_t *journ
 	while((tmp >>= 1UL) != 0UL)
 		shift++;
 
-	journal->j_revoke_table[0] = kmem_cache_alloc(revoke_table_cache,
-					GFP_KERNEL|__GFP_RECLAIMABLE);
+	journal->j_revoke_table[0] = kmem_cache_alloc(revoke_table_cache, GFP_KERNEL);
 	if (!journal->j_revoke_table[0])
 		return -ENOMEM;
 	journal->j_revoke = journal->j_revoke_table[0];
@@ -229,8 +232,7 @@ int journal_init_revoke(journal_t *journ
 	for (tmp = 0; tmp < hash_size; tmp++)
 		INIT_LIST_HEAD(&journal->j_revoke->hash_table[tmp]);
 
-	journal->j_revoke_table[1] = kmem_cache_alloc(revoke_table_cache,
-					GFP_KERNEL|__GFP_RECLAIMABLE);
+	journal->j_revoke_table[1] = kmem_cache_alloc(revoke_table_cache, GFP_KERNEL);
 	if (!journal->j_revoke_table[1]) {
 		kfree(journal->j_revoke_table[0]->hash_table);
 		kmem_cache_free(revoke_table_cache, journal->j_revoke_table[0]);
diff -puN fs/proc/base.c~group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived fs/proc/base.c
--- a/fs/proc/base.c~group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived
+++ a/fs/proc/base.c
@@ -487,7 +487,7 @@ static ssize_t proc_info_read(struct fil
 		count = PROC_BLOCK_SIZE;
 
 	length = -ENOMEM;
-	if (!(page = __get_free_page(GFP_KERNEL|__GFP_RECLAIMABLE)))
+	if (!(page = __get_free_page(GFP_TEMPORARY)))
 		goto out;
 
 	length = PROC_I(inode)->op.proc_read(task, (char*)page);
@@ -527,7 +527,7 @@ static ssize_t mem_read(struct file * fi
 		goto out;
 
 	ret = -ENOMEM;
-	page = (char *)__get_free_page(GFP_USER);
+	page = (char *)__get_free_page(GFP_TEMPORARY);
 	if (!page)
 		goto out;
 
@@ -597,7 +597,7 @@ static ssize_t mem_write(struct file * f
 		goto out;
 
 	copied = -ENOMEM;
-	page = (char *)__get_free_page(GFP_USER|__GFP_RECLAIMABLE);
+	page = (char *)__get_free_page(GFP_TEMPORARY);
 	if (!page)
 		goto out;
 
@@ -783,7 +783,7 @@ static ssize_t proc_loginuid_write(struc
 		/* No partial writes. */
 		return -EINVAL;
 	}
-	page = (char*)__get_free_page(GFP_USER|__GFP_RECLAIMABLE);
+	page = (char*)__get_free_page(GFP_TEMPORARY);
 	if (!page)
 		return -ENOMEM;
 	length = -EFAULT;
@@ -951,7 +951,7 @@ static int do_proc_readlink(struct dentr
 			    char __user *buffer, int buflen)
 {
 	struct inode * inode;
-	char *tmp = (char*)__get_free_page(GFP_KERNEL|__GFP_RECLAIMABLE);
+	char *tmp = (char*)__get_free_page(GFP_TEMPORARY);
 	char *path;
 	int len;
 
@@ -1724,7 +1724,7 @@ static ssize_t proc_pid_attr_write(struc
 		goto out;
 
 	length = -ENOMEM;
-	page = (char*)__get_free_page(GFP_USER|__GFP_RECLAIMABLE);
+	page = (char*)__get_free_page(GFP_TEMPORARY);
 	if (!page)
 		goto out;
 
diff -puN fs/proc/generic.c~group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived fs/proc/generic.c
--- a/fs/proc/generic.c~group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived
+++ a/fs/proc/generic.c
@@ -73,7 +73,7 @@ proc_file_read(struct file *file, char _
 		nbytes = MAX_NON_LFS - pos;
 
 	dp = PDE(inode);
-	if (!(page = (char*) __get_free_page(GFP_KERNEL|__GFP_RECLAIMABLE)))
+	if (!(page = (char*) __get_free_page(GFP_TEMPORARY)))
 		return -ENOMEM;
 
 	while ((nbytes > 0) && !eof) {
diff -puN include/linux/gfp.h~group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived include/linux/gfp.h
--- a/include/linux/gfp.h~group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived
+++ a/include/linux/gfp.h
@@ -71,6 +71,8 @@ struct vm_area_struct;
 #define GFP_NOIO	(__GFP_WAIT)
 #define GFP_NOFS	(__GFP_WAIT | __GFP_IO)
 #define GFP_KERNEL	(__GFP_WAIT | __GFP_IO | __GFP_FS)
+#define GFP_TEMPORARY	(__GFP_WAIT | __GFP_IO | __GFP_FS | \
+			 __GFP_RECLAIMABLE)
 #define GFP_USER	(__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL)
 #define GFP_HIGHUSER	(__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL | \
 			 __GFP_HIGHMEM)
diff -puN include/linux/slab.h~group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived include/linux/slab.h
--- a/include/linux/slab.h~group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived
+++ a/include/linux/slab.h
@@ -24,12 +24,14 @@
 #define SLAB_HWCACHE_ALIGN	0x00002000UL	/* Align objs on cache lines */
 #define SLAB_CACHE_DMA		0x00004000UL	/* Use GFP_DMA memory */
 #define SLAB_STORE_USER		0x00010000UL	/* DEBUG: Store the last owner for bug hunting */
-#define SLAB_RECLAIM_ACCOUNT	0x00020000UL	/* Objects are reclaimable */
 #define SLAB_PANIC		0x00040000UL	/* Panic if kmem_cache_create() fails */
 #define SLAB_DESTROY_BY_RCU	0x00080000UL	/* Defer freeing slabs to RCU */
 #define SLAB_MEM_SPREAD		0x00100000UL	/* Spread some memory over cpuset */
 #define SLAB_TRACE		0x00200000UL	/* Trace allocations and frees */
 
+/* The following flags affect the page allocator grouping pages by mobility */
+#define SLAB_RECLAIM_ACCOUNT	0x00020000UL		/* Objects are reclaimable */
+#define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
 /*
  * struct kmem_cache related prototypes
  */
diff -puN kernel/cpuset.c~group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived kernel/cpuset.c
--- a/kernel/cpuset.c~group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived
+++ a/kernel/cpuset.c
@@ -1445,7 +1445,7 @@ static ssize_t cpuset_common_file_read(s
 	ssize_t retval = 0;
 	char *s;
 
-	if (!(page = (char *)__get_free_page(GFP_KERNEL)))
+	if (!(page = (char *)__get_free_page(GFP_TEMPORARY)))
 		return -ENOMEM;
 
 	s = page;
diff -puN mm/slub.c~group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived mm/slub.c
--- a/mm/slub.c~group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived
+++ a/mm/slub.c
@@ -2840,7 +2840,7 @@ static int alloc_loc_track(struct loc_tr
 
 	order = get_order(sizeof(struct location) * max);
 
-	l = (void *)__get_free_pages(GFP_KERNEL, order);
+	l = (void *)__get_free_pages(GFP_TEMPORARY, order);
 
 	if (!l)
 		return 0;
diff -puN net/core/skbuff.c~group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived net/core/skbuff.c
--- a/net/core/skbuff.c~group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived
+++ a/net/core/skbuff.c
@@ -152,7 +152,6 @@ struct sk_buff *__alloc_skb(unsigned int
 	u8 *data;
 
 	cache = fclone ? skbuff_fclone_cache : skbuff_head_cache;
-	gfp_mask = set_migrateflags(gfp_mask, __GFP_RECLAIMABLE);
 
 	/* Get the HEAD */
 	skb = kmem_cache_alloc_node(cache, gfp_mask & ~__GFP_DMA, node);
@@ -2001,16 +2000,16 @@ EXPORT_SYMBOL_GPL(skb_segment);
 void __init skb_init(void)
 {
 	skbuff_head_cache = kmem_cache_create("skbuff_head_cache",
-					      sizeof(struct sk_buff),
-					      0,
-					      SLAB_HWCACHE_ALIGN|SLAB_PANIC,
-					      NULL, NULL);
+				sizeof(struct sk_buff),
+				0,
+				SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_TEMPORARY,
+				NULL, NULL);
 	skbuff_fclone_cache = kmem_cache_create("skbuff_fclone_cache",
-						(2*sizeof(struct sk_buff)) +
-						sizeof(atomic_t),
-						0,
-						SLAB_HWCACHE_ALIGN|SLAB_PANIC,
-						NULL, NULL);
+				(2*sizeof(struct sk_buff)) +
+				sizeof(atomic_t),
+				0,
+				SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_TEMPORARY,
+				NULL, NULL);
 }
 
 /**
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
