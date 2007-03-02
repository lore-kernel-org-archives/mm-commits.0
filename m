From: akpm@linux-foundation.org
Subject: + group-short-lived-and-reclaimable-kernel-allocations.patch added to -mm tree
Date: Fri, 02 Mar 2007 13:41:41 -0800
Message-ID: <200703022141.l22Lfgg0019776@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42061 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030195AbXCBVlr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 16:41:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie


The patch titled
     Group short-lived and reclaimable kernel allocations
has been added to the -mm tree.  Its filename is
     group-short-lived-and-reclaimable-kernel-allocations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                     |    6 ++++--
 fs/dcache.c                     |    2 +-
 fs/ext2/super.c                 |    3 ++-
 fs/ext3/super.c                 |    2 +-
 fs/jbd/journal.c                |    6 ++++--
 fs/jbd/revoke.c                 |    6 ++++--
 fs/ntfs/inode.c                 |    4 ++--
 fs/proc/base.c                  |   13 +++++++------
 fs/proc/generic.c               |    2 +-
 fs/reiserfs/super.c             |    3 ++-
 include/linux/gfp.h             |   16 +++++++++++++---
 include/linux/mmzone.h          |    6 ++++--
 include/linux/pageblock-flags.h |    2 +-
 lib/radix-tree.c                |    6 ++++--
 mm/page_alloc.c                 |   10 +++++++---
 mm/shmem.c                      |    7 +++++--
 net/core/skbuff.c               |    1 +
 17 files changed, 63 insertions(+), 32 deletions(-)

diff -puN fs/buffer.c~group-short-lived-and-reclaimable-kernel-allocations fs/buffer.c
--- a/fs/buffer.c~group-short-lived-and-reclaimable-kernel-allocations
+++ a/fs/buffer.c
@@ -980,7 +980,8 @@ grow_dev_page(struct block_device *bdev,
 	struct page *page;
 	struct buffer_head *bh;
 
-	page = find_or_create_page(inode->i_mapping, index, GFP_NOFS);
+	page = find_or_create_page(inode->i_mapping, index,
+					GFP_NOFS|__GFP_RECLAIMABLE);
 	if (!page)
 		return NULL;
 
@@ -2909,7 +2910,8 @@ static void recalc_bh_state(void)
 	
 struct buffer_head *alloc_buffer_head(gfp_t gfp_flags)
 {
-	struct buffer_head *ret = kmem_cache_alloc(bh_cachep, gfp_flags);
+	struct buffer_head *ret = kmem_cache_alloc(bh_cachep,
+				set_migrateflags(gfp_flags, __GFP_RECLAIMABLE));
 	if (ret) {
 		get_cpu_var(bh_accounting).nr++;
 		recalc_bh_state();
diff -puN fs/dcache.c~group-short-lived-and-reclaimable-kernel-allocations fs/dcache.c
--- a/fs/dcache.c~group-short-lived-and-reclaimable-kernel-allocations
+++ a/fs/dcache.c
@@ -869,7 +869,7 @@ struct dentry *d_alloc(struct dentry * p
 	struct dentry *dentry;
 	char *dname;
 
-	dentry = kmem_cache_alloc(dentry_cache, GFP_KERNEL); 
+	dentry = kmem_cache_alloc(dentry_cache, GFP_KERNEL|__GFP_RECLAIMABLE);
 	if (!dentry)
 		return NULL;
 
diff -puN fs/ext2/super.c~group-short-lived-and-reclaimable-kernel-allocations fs/ext2/super.c
--- a/fs/ext2/super.c~group-short-lived-and-reclaimable-kernel-allocations
+++ a/fs/ext2/super.c
@@ -140,7 +140,8 @@ static struct kmem_cache * ext2_inode_ca
 static struct inode *ext2_alloc_inode(struct super_block *sb)
 {
 	struct ext2_inode_info *ei;
-	ei = (struct ext2_inode_info *)kmem_cache_alloc(ext2_inode_cachep, GFP_KERNEL);
+	ei = (struct ext2_inode_info *)kmem_cache_alloc(ext2_inode_cachep,
+						GFP_KERNEL|__GFP_RECLAIMABLE);
 	if (!ei)
 		return NULL;
 #ifdef CONFIG_EXT2_FS_POSIX_ACL
diff -puN fs/ext3/super.c~group-short-lived-and-reclaimable-kernel-allocations fs/ext3/super.c
--- a/fs/ext3/super.c~group-short-lived-and-reclaimable-kernel-allocations
+++ a/fs/ext3/super.c
@@ -445,7 +445,7 @@ static struct inode *ext3_alloc_inode(st
 {
 	struct ext3_inode_info *ei;
 
-	ei = kmem_cache_alloc(ext3_inode_cachep, GFP_NOFS);
+	ei = kmem_cache_alloc(ext3_inode_cachep, GFP_NOFS|__GFP_RECLAIMABLE);
 	if (!ei)
 		return NULL;
 #ifdef CONFIG_EXT3_FS_POSIX_ACL
diff -puN fs/jbd/journal.c~group-short-lived-and-reclaimable-kernel-allocations fs/jbd/journal.c
--- a/fs/jbd/journal.c~group-short-lived-and-reclaimable-kernel-allocations
+++ a/fs/jbd/journal.c
@@ -1735,7 +1735,8 @@ static struct journal_head *journal_allo
 #ifdef CONFIG_JBD_DEBUG
 	atomic_inc(&nr_journal_heads);
 #endif
-	ret = kmem_cache_alloc(journal_head_cache, GFP_NOFS);
+	ret = kmem_cache_alloc(journal_head_cache,
+			set_migrateflags(GFP_NOFS, __GFP_RECLAIMABLE));
 	if (ret == 0) {
 		jbd_debug(1, "out of memory for journal_head\n");
 		if (time_after(jiffies, last_warning + 5*HZ)) {
@@ -1745,7 +1746,8 @@ static struct journal_head *journal_allo
 		}
 		while (ret == 0) {
 			yield();
-			ret = kmem_cache_alloc(journal_head_cache, GFP_NOFS);
+			ret = kmem_cache_alloc(journal_head_cache,
+					GFP_NOFS|__GFP_RECLAIMABLE);
 		}
 	}
 	return ret;
diff -puN fs/jbd/revoke.c~group-short-lived-and-reclaimable-kernel-allocations fs/jbd/revoke.c
--- a/fs/jbd/revoke.c~group-short-lived-and-reclaimable-kernel-allocations
+++ a/fs/jbd/revoke.c
@@ -206,7 +206,8 @@ int journal_init_revoke(journal_t *journ
 	while((tmp >>= 1UL) != 0UL)
 		shift++;
 
-	journal->j_revoke_table[0] = kmem_cache_alloc(revoke_table_cache, GFP_KERNEL);
+	journal->j_revoke_table[0] = kmem_cache_alloc(revoke_table_cache,
+					GFP_KERNEL|__GFP_RECLAIMABLE);
 	if (!journal->j_revoke_table[0])
 		return -ENOMEM;
 	journal->j_revoke = journal->j_revoke_table[0];
@@ -229,7 +230,8 @@ int journal_init_revoke(journal_t *journ
 	for (tmp = 0; tmp < hash_size; tmp++)
 		INIT_LIST_HEAD(&journal->j_revoke->hash_table[tmp]);
 
-	journal->j_revoke_table[1] = kmem_cache_alloc(revoke_table_cache, GFP_KERNEL);
+	journal->j_revoke_table[1] = kmem_cache_alloc(revoke_table_cache,
+					GFP_KERNEL|__GFP_RECLAIMABLE);
 	if (!journal->j_revoke_table[1]) {
 		kfree(journal->j_revoke_table[0]->hash_table);
 		kmem_cache_free(revoke_table_cache, journal->j_revoke_table[0]);
diff -puN fs/ntfs/inode.c~group-short-lived-and-reclaimable-kernel-allocations fs/ntfs/inode.c
--- a/fs/ntfs/inode.c~group-short-lived-and-reclaimable-kernel-allocations
+++ a/fs/ntfs/inode.c
@@ -324,7 +324,7 @@ struct inode *ntfs_alloc_big_inode(struc
 	ntfs_inode *ni;
 
 	ntfs_debug("Entering.");
-	ni = kmem_cache_alloc(ntfs_big_inode_cache, GFP_NOFS);
+	ni = kmem_cache_alloc(ntfs_big_inode_cache, GFP_NOFS|__GFP_RECLAIMABLE);
 	if (likely(ni != NULL)) {
 		ni->state = 0;
 		return VFS_I(ni);
@@ -349,7 +349,7 @@ static inline ntfs_inode *ntfs_alloc_ext
 	ntfs_inode *ni;
 
 	ntfs_debug("Entering.");
-	ni = kmem_cache_alloc(ntfs_inode_cache, GFP_NOFS);
+	ni = kmem_cache_alloc(ntfs_inode_cache, GFP_NOFS|__GFP_RECLAIMABLE);
 	if (likely(ni != NULL)) {
 		ni->state = 0;
 		return ni;
diff -puN fs/proc/base.c~group-short-lived-and-reclaimable-kernel-allocations fs/proc/base.c
--- a/fs/proc/base.c~group-short-lived-and-reclaimable-kernel-allocations
+++ a/fs/proc/base.c
@@ -487,7 +487,7 @@ static ssize_t proc_info_read(struct fil
 		count = PROC_BLOCK_SIZE;
 
 	length = -ENOMEM;
-	if (!(page = __get_free_page(GFP_KERNEL)))
+	if (!(page = __get_free_page(GFP_KERNEL|__GFP_RECLAIMABLE)))
 		goto out;
 
 	length = PROC_I(inode)->op.proc_read(task, (char*)page);
@@ -597,7 +597,7 @@ static ssize_t mem_write(struct file * f
 		goto out;
 
 	copied = -ENOMEM;
-	page = (char *)__get_free_page(GFP_USER);
+	page = (char *)__get_free_page(GFP_USER|__GFP_RECLAIMABLE);
 	if (!page)
 		goto out;
 
@@ -754,7 +754,7 @@ static ssize_t proc_loginuid_write(struc
 		/* No partial writes. */
 		return -EINVAL;
 	}
-	page = (char*)__get_free_page(GFP_USER);
+	page = (char*)__get_free_page(GFP_USER|__GFP_RECLAIMABLE);
 	if (!page)
 		return -ENOMEM;
 	length = -EFAULT;
@@ -936,7 +936,8 @@ static int do_proc_readlink(struct dentr
 			    char __user *buffer, int buflen)
 {
 	struct inode * inode;
-	char *tmp = (char*)__get_free_page(GFP_KERNEL), *path;
+	char *tmp = (char*)__get_free_page(GFP_KERNEL|__GFP_RECLAIMABLE);
+	char *path;
 	int len;
 
 	if (!tmp)
@@ -1569,7 +1570,7 @@ static ssize_t proc_pid_attr_read(struct
 	if (count > PAGE_SIZE)
 		count = PAGE_SIZE;
 	length = -ENOMEM;
-	if (!(page = __get_free_page(GFP_KERNEL)))
+	if (!(page = __get_free_page(GFP_KERNEL|__GFP_RECLAIMABLE)))
 		goto out;
 
 	length = security_getprocattr(task,
@@ -1604,7 +1605,7 @@ static ssize_t proc_pid_attr_write(struc
 		goto out;
 
 	length = -ENOMEM;
-	page = (char*)__get_free_page(GFP_USER);
+	page = (char*)__get_free_page(GFP_USER|__GFP_RECLAIMABLE);
 	if (!page)
 		goto out;
 
diff -puN fs/proc/generic.c~group-short-lived-and-reclaimable-kernel-allocations fs/proc/generic.c
--- a/fs/proc/generic.c~group-short-lived-and-reclaimable-kernel-allocations
+++ a/fs/proc/generic.c
@@ -73,7 +73,7 @@ proc_file_read(struct file *file, char _
 		nbytes = MAX_NON_LFS - pos;
 
 	dp = PDE(inode);
-	if (!(page = (char*) __get_free_page(GFP_KERNEL)))
+	if (!(page = (char*) __get_free_page(GFP_KERNEL|__GFP_RECLAIMABLE)))
 		return -ENOMEM;
 
 	while ((nbytes > 0) && !eof) {
diff -puN fs/reiserfs/super.c~group-short-lived-and-reclaimable-kernel-allocations fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~group-short-lived-and-reclaimable-kernel-allocations
+++ a/fs/reiserfs/super.c
@@ -496,7 +496,8 @@ static struct inode *reiserfs_alloc_inod
 {
 	struct reiserfs_inode_info *ei;
 	ei = (struct reiserfs_inode_info *)
-	    kmem_cache_alloc(reiserfs_inode_cachep, GFP_KERNEL);
+	    kmem_cache_alloc(reiserfs_inode_cachep,
+						GFP_KERNEL|__GFP_RECLAIMABLE);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
diff -puN include/linux/gfp.h~group-short-lived-and-reclaimable-kernel-allocations include/linux/gfp.h
--- a/include/linux/gfp.h~group-short-lived-and-reclaimable-kernel-allocations
+++ a/include/linux/gfp.h
@@ -49,9 +49,10 @@ struct vm_area_struct;
 #define __GFP_NOMEMALLOC ((__force gfp_t)0x10000u) /* Don't use emergency reserves */
 #define __GFP_HARDWALL   ((__force gfp_t)0x20000u) /* Enforce hardwall cpuset memory allocs */
 #define __GFP_THISNODE	((__force gfp_t)0x40000u)/* No fallback, no policies */
-#define __GFP_MOVABLE	((__force gfp_t)0x80000u) /* Page is movable */
+#define __GFP_RECLAIMABLE ((__force gfp_t)0x80000u) /* Page is reclaimable */
+#define __GFP_MOVABLE	((__force gfp_t)0x100000u)  /* Page is movable */
 
-#define __GFP_BITS_SHIFT 20	/* Room for 20 __GFP_FOO bits */
+#define __GFP_BITS_SHIFT 21	/* Room for 21 __GFP_FOO bits */
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
 /* if you forget to add the bitmask here kernel will crash, period */
@@ -59,7 +60,10 @@ struct vm_area_struct;
 			__GFP_COLD|__GFP_NOWARN|__GFP_REPEAT| \
 			__GFP_NOFAIL|__GFP_NORETRY|__GFP_NO_GROW|__GFP_COMP| \
 			__GFP_NOMEMALLOC|__GFP_HARDWALL|__GFP_THISNODE| \
-			__GFP_MOVABLE)
+			__GFP_RECLAIMABLE|__GFP_MOVABLE)
+
+/* This mask makes up all the page movable related flags */
+#define GFP_MOVABLE_MASK (__GFP_RECLAIMABLE|__GFP_MOVABLE)
 
 /* This equals 0, but use constants in case they ever change */
 #define GFP_NOWAIT	(GFP_ATOMIC & ~__GFP_HIGH)
@@ -108,6 +112,12 @@ static inline enum zone_type gfp_zone(gf
 	return ZONE_NORMAL;
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
@@ -27,10 +27,12 @@
 
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
 
diff -puN lib/radix-tree.c~group-short-lived-and-reclaimable-kernel-allocations lib/radix-tree.c
--- a/lib/radix-tree.c~group-short-lived-and-reclaimable-kernel-allocations
+++ a/lib/radix-tree.c
@@ -93,7 +93,8 @@ radix_tree_node_alloc(struct radix_tree_
 	struct radix_tree_node *ret;
 	gfp_t gfp_mask = root_gfp_mask(root);
 
-	ret = kmem_cache_alloc(radix_tree_node_cachep, gfp_mask);
+	ret = kmem_cache_alloc(radix_tree_node_cachep,
+				set_migrateflags(gfp_mask, __GFP_RECLAIMABLE));
 	if (ret == NULL && !(gfp_mask & __GFP_WAIT)) {
 		struct radix_tree_preload *rtp;
 
@@ -137,7 +138,8 @@ int radix_tree_preload(gfp_t gfp_mask)
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
@@ -150,7 +150,10 @@ static void set_pageblock_migratetype(st
 
 static inline int gfpflags_to_migratetype(gfp_t gfp_flags)
 {
-	return ((gfp_flags & __GFP_MOVABLE) != 0);
+	WARN_ON((gfp_flags & GFP_MOVABLE_MASK) == GFP_MOVABLE_MASK);
+
+	return (((gfp_flags & __GFP_MOVABLE) != 0) << 1) |
+		((gfp_flags & __GFP_RECLAIMABLE) != 0);
 }
 
 #else
@@ -663,8 +666,9 @@ static int prep_new_page(struct page *pa
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
@@ -983,7 +983,9 @@ shmem_alloc_page(gfp_t gfp, struct shmem
 	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, idx);
 	pvma.vm_pgoff = idx;
 	pvma.vm_end = PAGE_SIZE;
-	page = alloc_page_vma(gfp | __GFP_ZERO, &pvma, 0);
+	page = alloc_page_vma(
+			set_migrateflags(gfp | __GFP_ZERO, __GFP_RECLAIMABLE),
+								&pvma, 0);
 	mpol_free(pvma.vm_policy);
 	return page;
 }
@@ -1003,7 +1005,8 @@ shmem_swapin(struct shmem_inode_info *in
 static inline struct page *
 shmem_alloc_page(gfp_t gfp,struct shmem_inode_info *info, unsigned long idx)
 {
-	return alloc_page(gfp | __GFP_ZERO);
+	return alloc_page(
+			set_migrateflags(gfp | __GFP_ZERO, __GFP_RECLAIMABLE));
 }
 #endif
 
diff -puN net/core/skbuff.c~group-short-lived-and-reclaimable-kernel-allocations net/core/skbuff.c
--- a/net/core/skbuff.c~group-short-lived-and-reclaimable-kernel-allocations
+++ a/net/core/skbuff.c
@@ -170,6 +170,7 @@ struct sk_buff *__alloc_skb(unsigned int
 	u8 *data;
 
 	cache = fclone ? skbuff_fclone_cache : skbuff_head_cache;
+	gfp_mask = set_migrateflags(gfp_mask, __GFP_RECLAIMABLE);
 
 	/* Get the HEAD */
 	skb = kmem_cache_alloc_node(cache, gfp_mask & ~__GFP_DMA, node);
_

Patches currently in -mm which might be from mel@csn.ul.ie are

add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-low-memory-that-may-be-migrated.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
create-the-zone_movable-zone.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
x86-specify-amount-of-kernel-memory-at-boot-time.patch
ppc-and-powerpc-specify-amount-of-kernel-memory-at-boot-time.patch
x86_64-specify-amount-of-kernel-memory-at-boot-time.patch
ia64-specify-amount-of-kernel-memory-at-boot-time.patch
add-documentation-for-additional-boot-parameter-and-sysctl.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
add-debugging-aid-for-memory-initialisation-problems.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
