From: akpm@linux-foundation.org
Subject: - group-short-lived-and-reclaimable-kernel-allocations.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:34:41 -0700
Message-ID: <200710162034.l9GKYfMv014966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53453 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761718AbXJPVhw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:37:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Group short-lived and reclaimable kernel allocations
has been removed from the -mm tree.  Its filename was
     group-short-lived-and-reclaimable-kernel-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Group short-lived and reclaimable kernel allocations
From: Mel Gorman <mel@csn.ul.ie>

This patch marks a number of allocations that are either short-lived such as
network buffers or are reclaimable such as inode allocations.  When something
like updatedb is called, long-lived and unmovable kernel allocations tend to
be spread throughout the address space which increases fragmentation.

This patch groups these allocations together as much as possible by adding a
new MIGRATE_TYPE.  The MIGRATE_RECLAIMABLE type is for allocations that can be
reclaimed on demand, but not moved.  i.e.  they can be migrated by deleting
them and re-reading the information from elsewhere.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                     |    3 ++-
 fs/dcache.c                     |    2 +-
 fs/jbd/journal.c                |    4 ++--
 fs/jbd/revoke.c                 |    6 ++++--
 fs/proc/base.c                  |   13 +++++++------
 fs/proc/generic.c               |    2 +-
 include/linux/gfp.h             |   15 ++++++++++++---
 include/linux/mmzone.h          |    6 ++++--
 include/linux/pageblock-flags.h |    2 +-
 include/linux/slab.h            |    4 +++-
 kernel/cpuset.c                 |    2 +-
 lib/radix-tree.c                |    6 ++++--
 mm/page_alloc.c                 |   10 +++++++---
 mm/shmem.c                      |    4 ++--
 mm/slab.c                       |    2 ++
 mm/slub.c                       |    3 +++
 16 files changed, 56 insertions(+), 28 deletions(-)

diff -puN fs/buffer.c~group-short-lived-and-reclaimable-kernel-allocations fs/buffer.c
--- a/fs/buffer.c~group-short-lived-and-reclaimable-kernel-allocations
+++ a/fs/buffer.c
@@ -3169,7 +3169,8 @@ static void recalc_bh_state(void)
 	
 struct buffer_head *alloc_buffer_head(gfp_t gfp_flags)
 {
-	struct buffer_head *ret = kmem_cache_zalloc(bh_cachep, gfp_flags);
+	struct buffer_head *ret = kmem_cache_zalloc(bh_cachep,
+				set_migrateflags(gfp_flags, __GFP_RECLAIMABLE));
 	if (ret) {
 		INIT_LIST_HEAD(&ret->b_assoc_buffers);
 		get_cpu_var(bh_accounting).nr++;
diff -puN fs/dcache.c~group-short-lived-and-reclaimable-kernel-allocations fs/dcache.c
--- a/fs/dcache.c~group-short-lived-and-reclaimable-kernel-allocations
+++ a/fs/dcache.c
@@ -903,7 +903,7 @@ struct dentry *d_alloc(struct dentry * p
 	struct dentry *dentry;
 	char *dname;
 
-	dentry = kmem_cache_alloc(dentry_cache, GFP_KERNEL); 
+	dentry = kmem_cache_alloc(dentry_cache, GFP_KERNEL);
 	if (!dentry)
 		return NULL;
 
diff -puN fs/jbd/journal.c~group-short-lived-and-reclaimable-kernel-allocations fs/jbd/journal.c
--- a/fs/jbd/journal.c~group-short-lived-and-reclaimable-kernel-allocations
+++ a/fs/jbd/journal.c
@@ -1710,7 +1710,7 @@ static int journal_init_journal_head_cac
 	journal_head_cache = kmem_cache_create("journal_head",
 				sizeof(struct journal_head),
 				0,		/* offset */
-				0,		/* flags */
+				SLAB_TEMPORARY,	/* flags */
 				NULL);		/* ctor */
 	retval = 0;
 	if (journal_head_cache == 0) {
@@ -2006,7 +2006,7 @@ static int __init journal_init_handle_ca
 	jbd_handle_cache = kmem_cache_create("journal_handle",
 				sizeof(handle_t),
 				0,		/* offset */
-				0,		/* flags */
+				SLAB_TEMPORARY,	/* flags */
 				NULL);		/* ctor */
 	if (jbd_handle_cache == NULL) {
 		printk(KERN_EMERG "JBD: failed to create handle cache\n");
diff -puN fs/jbd/revoke.c~group-short-lived-and-reclaimable-kernel-allocations fs/jbd/revoke.c
--- a/fs/jbd/revoke.c~group-short-lived-and-reclaimable-kernel-allocations
+++ a/fs/jbd/revoke.c
@@ -170,13 +170,15 @@ int __init journal_init_revoke_caches(vo
 {
 	revoke_record_cache = kmem_cache_create("revoke_record",
 					   sizeof(struct jbd_revoke_record_s),
-					   0, SLAB_HWCACHE_ALIGN, NULL);
+					   0,
+					   SLAB_HWCACHE_ALIGN|SLAB_TEMPORARY,
+					   NULL);
 	if (revoke_record_cache == 0)
 		return -ENOMEM;
 
 	revoke_table_cache = kmem_cache_create("revoke_table",
 					   sizeof(struct jbd_revoke_table_s),
-					   0, 0, NULL);
+					   0, SLAB_TEMPORARY, NULL);
 	if (revoke_table_cache == 0) {
 		kmem_cache_destroy(revoke_record_cache);
 		revoke_record_cache = NULL;
diff -puN fs/proc/base.c~group-short-lived-and-reclaimable-kernel-allocations fs/proc/base.c
--- a/fs/proc/base.c~group-short-lived-and-reclaimable-kernel-allocations
+++ a/fs/proc/base.c
@@ -492,7 +492,7 @@ static ssize_t proc_info_read(struct fil
 		count = PROC_BLOCK_SIZE;
 
 	length = -ENOMEM;
-	if (!(page = __get_free_page(GFP_KERNEL)))
+	if (!(page = __get_free_page(GFP_TEMPORARY)))
 		goto out;
 
 	length = PROC_I(inode)->op.proc_read(task, (char*)page);
@@ -532,7 +532,7 @@ static ssize_t mem_read(struct file * fi
 		goto out;
 
 	ret = -ENOMEM;
-	page = (char *)__get_free_page(GFP_USER);
+	page = (char *)__get_free_page(GFP_TEMPORARY);
 	if (!page)
 		goto out;
 
@@ -602,7 +602,7 @@ static ssize_t mem_write(struct file * f
 		goto out;
 
 	copied = -ENOMEM;
-	page = (char *)__get_free_page(GFP_USER);
+	page = (char *)__get_free_page(GFP_TEMPORARY);
 	if (!page)
 		goto out;
 
@@ -788,7 +788,7 @@ static ssize_t proc_loginuid_write(struc
 		/* No partial writes. */
 		return -EINVAL;
 	}
-	page = (char*)__get_free_page(GFP_USER);
+	page = (char*)__get_free_page(GFP_TEMPORARY);
 	if (!page)
 		return -ENOMEM;
 	length = -EFAULT;
@@ -954,7 +954,8 @@ static int do_proc_readlink(struct dentr
 			    char __user *buffer, int buflen)
 {
 	struct inode * inode;
-	char *tmp = (char*)__get_free_page(GFP_KERNEL), *path;
+	char *tmp = (char*)__get_free_page(GFP_TEMPORARY);
+	char *path;
 	int len;
 
 	if (!tmp)
@@ -1726,7 +1727,7 @@ static ssize_t proc_pid_attr_write(struc
 		goto out;
 
 	length = -ENOMEM;
-	page = (char*)__get_free_page(GFP_USER);
+	page = (char*)__get_free_page(GFP_TEMPORARY);
 	if (!page)
 		goto out;
 
diff -puN fs/proc/generic.c~group-short-lived-and-reclaimable-kernel-allocations fs/proc/generic.c
--- a/fs/proc/generic.c~group-short-lived-and-reclaimable-kernel-allocations
+++ a/fs/proc/generic.c
@@ -74,7 +74,7 @@ proc_file_read(struct file *file, char _
 		nbytes = MAX_NON_LFS - pos;
 
 	dp = PDE(inode);
-	if (!(page = (char*) __get_free_page(GFP_KERNEL)))
+	if (!(page = (char*) __get_free_page(GFP_TEMPORARY)))
 		return -ENOMEM;
 
 	while ((nbytes > 0) && !eof) {
diff -puN include/linux/gfp.h~group-short-lived-and-reclaimable-kernel-allocations include/linux/gfp.h
--- a/include/linux/gfp.h~group-short-lived-and-reclaimable-kernel-allocations
+++ a/include/linux/gfp.h
@@ -48,9 +48,10 @@ struct vm_area_struct;
 #define __GFP_NOMEMALLOC ((__force gfp_t)0x10000u) /* Don't use emergency reserves */
 #define __GFP_HARDWALL   ((__force gfp_t)0x20000u) /* Enforce hardwall cpuset memory allocs */
 #define __GFP_THISNODE	((__force gfp_t)0x40000u)/* No fallback, no policies */
-#define __GFP_MOVABLE	((__force gfp_t)0x80000u) /* Page is movable */
+#define __GFP_RECLAIMABLE ((__force gfp_t)0x80000u) /* Page is reclaimable */
+#define __GFP_MOVABLE	((__force gfp_t)0x100000u)  /* Page is movable */
 
-#define __GFP_BITS_SHIFT 20	/* Room for 20 __GFP_FOO bits */
+#define __GFP_BITS_SHIFT 21	/* Room for 21 __GFP_FOO bits */
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
 /* This equals 0, but use constants in case they ever change */
@@ -60,6 +61,8 @@ struct vm_area_struct;
 #define GFP_NOIO	(__GFP_WAIT)
 #define GFP_NOFS	(__GFP_WAIT | __GFP_IO)
 #define GFP_KERNEL	(__GFP_WAIT | __GFP_IO | __GFP_FS)
+#define GFP_TEMPORARY	(__GFP_WAIT | __GFP_IO | __GFP_FS | \
+			 __GFP_RECLAIMABLE)
 #define GFP_USER	(__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL)
 #define GFP_HIGHUSER	(__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL | \
 			 __GFP_HIGHMEM)
@@ -80,7 +83,7 @@ struct vm_area_struct;
 #endif
 
 /* This mask makes up all the page movable related flags */
-#define GFP_MOVABLE_MASK (__GFP_MOVABLE)
+#define GFP_MOVABLE_MASK (__GFP_RECLAIMABLE|__GFP_MOVABLE)
 
 /* Control page allocator reclaim behavior */
 #define GFP_RECLAIM_MASK (__GFP_WAIT|__GFP_HIGH|__GFP_IO|__GFP_FS|\
@@ -129,6 +132,12 @@ static inline enum zone_type gfp_zone(gf
 	return base + ZONE_NORMAL;
 }
 
+static inline gfp_t set_migrateflags(gfp_t gfp, gfp_t migrate_flags)
+{
+	BUG_ON((gfp & GFP_MOVABLE_MASK) == GFP_MOVABLE_MASK);
+	return (gfp & ~(GFP_MOVABLE_MASK)) | migrate_flags;
+}
+
 /*
  * There is only one page-allocator function, and two main namespaces to
  * it. The alloc_page*() variants return 'struct page *' and as such
diff -puN include/linux/mmzone.h~group-short-lived-and-reclaimable-kernel-allocations include/linux/mmzone.h
--- a/include/linux/mmzone.h~group-short-lived-and-reclaimable-kernel-allocations
+++ a/include/linux/mmzone.h
@@ -35,10 +35,12 @@
 
 #ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
 #define MIGRATE_UNMOVABLE     0
-#define MIGRATE_MOVABLE       1
-#define MIGRATE_TYPES         2
+#define MIGRATE_RECLAIMABLE   1
+#define MIGRATE_MOVABLE       2
+#define MIGRATE_TYPES         3
 #else
 #define MIGRATE_UNMOVABLE     0
+#define MIGRATE_UNRECLAIMABLE 0
 #define MIGRATE_MOVABLE       0
 #define MIGRATE_TYPES         1
 #endif
diff -puN include/linux/pageblock-flags.h~group-short-lived-and-reclaimable-kernel-allocations include/linux/pageblock-flags.h
--- a/include/linux/pageblock-flags.h~group-short-lived-and-reclaimable-kernel-allocations
+++ a/include/linux/pageblock-flags.h
@@ -31,7 +31,7 @@
 
 /* Bit indices that affect a whole block of pages */
 enum pageblock_bits {
-	PB_range(PB_migrate, 1), /* 1 bit required for migrate types */
+	PB_range(PB_migrate, 2), /* 2 bits required for migrate types */
 	NR_PAGEBLOCK_BITS
 };
 
diff -puN include/linux/slab.h~group-short-lived-and-reclaimable-kernel-allocations include/linux/slab.h
--- a/include/linux/slab.h~group-short-lived-and-reclaimable-kernel-allocations
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
  * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
  *
diff -puN kernel/cpuset.c~group-short-lived-and-reclaimable-kernel-allocations kernel/cpuset.c
--- a/kernel/cpuset.c~group-short-lived-and-reclaimable-kernel-allocations
+++ a/kernel/cpuset.c
@@ -1463,7 +1463,7 @@ static ssize_t cpuset_common_file_read(s
 	ssize_t retval = 0;
 	char *s;
 
-	if (!(page = (char *)__get_free_page(GFP_KERNEL)))
+	if (!(page = (char *)__get_free_page(GFP_TEMPORARY)))
 		return -ENOMEM;
 
 	s = page;
diff -puN lib/radix-tree.c~group-short-lived-and-reclaimable-kernel-allocations lib/radix-tree.c
--- a/lib/radix-tree.c~group-short-lived-and-reclaimable-kernel-allocations
+++ a/lib/radix-tree.c
@@ -98,7 +98,8 @@ radix_tree_node_alloc(struct radix_tree_
 	struct radix_tree_node *ret;
 	gfp_t gfp_mask = root_gfp_mask(root);
 
-	ret = kmem_cache_alloc(radix_tree_node_cachep, gfp_mask);
+	ret = kmem_cache_alloc(radix_tree_node_cachep,
+				set_migrateflags(gfp_mask, __GFP_RECLAIMABLE));
 	if (ret == NULL && !(gfp_mask & __GFP_WAIT)) {
 		struct radix_tree_preload *rtp;
 
@@ -142,7 +143,8 @@ int radix_tree_preload(gfp_t gfp_mask)
 	rtp = &__get_cpu_var(radix_tree_preloads);
 	while (rtp->nr < ARRAY_SIZE(rtp->nodes)) {
 		preempt_enable();
-		node = kmem_cache_alloc(radix_tree_node_cachep, gfp_mask);
+		node = kmem_cache_alloc(radix_tree_node_cachep,
+				set_migrateflags(gfp_mask, __GFP_RECLAIMABLE));
 		if (node == NULL)
 			goto out;
 		preempt_disable();
diff -puN mm/page_alloc.c~group-short-lived-and-reclaimable-kernel-allocations mm/page_alloc.c
--- a/mm/page_alloc.c~group-short-lived-and-reclaimable-kernel-allocations
+++ a/mm/page_alloc.c
@@ -172,7 +172,10 @@ static void set_pageblock_migratetype(st
 
 static inline int gfpflags_to_migratetype(gfp_t gfp_flags)
 {
-	return ((gfp_flags & __GFP_MOVABLE) != 0);
+	WARN_ON((gfp_flags & GFP_MOVABLE_MASK) == GFP_MOVABLE_MASK);
+
+	return (((gfp_flags & __GFP_MOVABLE) != 0) << 1) |
+		((gfp_flags & __GFP_RECLAIMABLE) != 0);
 }
 
 #else
@@ -676,8 +679,9 @@ static int prep_new_page(struct page *pa
  * the free lists for the desirable migrate type are depleted
  */
 static int fallbacks[MIGRATE_TYPES][MIGRATE_TYPES-1] = {
-	[MIGRATE_UNMOVABLE] = { MIGRATE_MOVABLE   },
-	[MIGRATE_MOVABLE]   = { MIGRATE_UNMOVABLE },
+	[MIGRATE_UNMOVABLE]   = { MIGRATE_RECLAIMABLE, MIGRATE_MOVABLE   },
+	[MIGRATE_RECLAIMABLE] = { MIGRATE_UNMOVABLE,   MIGRATE_MOVABLE   },
+	[MIGRATE_MOVABLE]     = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE },
 };
 
 /*
diff -puN mm/shmem.c~group-short-lived-and-reclaimable-kernel-allocations mm/shmem.c
--- a/mm/shmem.c~group-short-lived-and-reclaimable-kernel-allocations
+++ a/mm/shmem.c
@@ -95,9 +95,9 @@ static inline struct page *shmem_dir_all
 	 * BLOCKS_PER_PAGE on indirect pages, assume PAGE_CACHE_SIZE:
 	 * might be reconsidered if it ever diverges from PAGE_SIZE.
 	 *
-	 * __GFP_MOVABLE is masked out as swap vectors cannot move
+	 * Mobility flags are masked out as swap vectors cannot move
 	 */
-	return alloc_pages((gfp_mask & ~__GFP_MOVABLE) | __GFP_ZERO,
+	return alloc_pages((gfp_mask & ~GFP_MOVABLE_MASK) | __GFP_ZERO,
 				PAGE_CACHE_SHIFT-PAGE_SHIFT);
 }
 
diff -puN mm/slab.c~group-short-lived-and-reclaimable-kernel-allocations mm/slab.c
--- a/mm/slab.c~group-short-lived-and-reclaimable-kernel-allocations
+++ a/mm/slab.c
@@ -1643,6 +1643,8 @@ static void *kmem_getpages(struct kmem_c
 #endif
 
 	flags |= cachep->gfpflags;
+	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
+		flags |= __GFP_RECLAIMABLE;
 
 	page = alloc_pages_node(nodeid, flags, cachep->gfporder);
 	if (!page)
diff -puN mm/slub.c~group-short-lived-and-reclaimable-kernel-allocations mm/slub.c
--- a/mm/slub.c~group-short-lived-and-reclaimable-kernel-allocations
+++ a/mm/slub.c
@@ -1055,6 +1055,9 @@ static struct page *allocate_slab(struct
 	if (s->flags & SLAB_CACHE_DMA)
 		flags |= SLUB_DMA;
 
+	if (s->flags & SLAB_RECLAIM_ACCOUNT)
+		flags |= __GFP_RECLAIMABLE;
+
 	if (node == -1)
 		page = alloc_pages(flags, s->order);
 	else
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
ext2-reservations.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
