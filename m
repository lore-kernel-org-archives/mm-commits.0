From: akpm@linux-foundation.org
Subject: [folded-merged]
 dax-support-dirty-dax-entries-in-radix-tree-v6.patch removed from -mm tree
Date: Fri, 22 Jan 2016 14:57:23 -0800
Message-ID: <56a2b3d3.9nK7BpOile+IImks%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56707 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbcAVW5Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Jan 2016 17:57:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, adilger.kernel@dilger.ca, bfields@fieldses.org, dan.j.williams@intel.com, dave.hansen@linux.intel.com, david@fromorbit.com, hpa@zytor.com, hughd@google.com, jack@suse.com, jlayton@poochiereds.net, matthew.r.wilcox@intel.com, mingo@redhat.com, tglx@linutronix.de, tytso@mit.edu, viro@zeniv.linux.org.uk, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax-support-dirty-dax-entries-in-radix-tree-v6
has been removed from the -mm tree.  Its filename was
     dax-support-dirty-dax-entries-in-radix-tree-v6.patch

This patch was dropped because it was folded into dax-support-dirty-dax-entries-in-radix-tree.patch

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax-support-dirty-dax-entries-in-radix-tree-v6

5) Got rid of the 'nrdax' variable in struct address_space and renamed
'nrshadows' to 'nrexceptional' so that it can be used for both DAX and
shadow exceptional entries.  We explicitly prevent shadow entries from
being added to radix trees for DAX mappings, so the single counter can
safely be reused for both purposes. (Jan)

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Kara <jack@suse.com>
Cc: Jeff Layton <jlayton@poochiereds.net>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c             |    3 +--
 fs/inode.c                 |    3 +--
 include/linux/fs.h         |    4 ++--
 include/linux/radix-tree.h |   10 +++++-----
 mm/filemap.c               |   10 ++++------
 mm/truncate.c              |   15 +++++++--------
 mm/workingset.c            |    4 ++--
 7 files changed, 22 insertions(+), 27 deletions(-)

diff -puN fs/block_dev.c~dax-support-dirty-dax-entries-in-radix-tree-v6 fs/block_dev.c
--- a/fs/block_dev.c~dax-support-dirty-dax-entries-in-radix-tree-v6
+++ a/fs/block_dev.c
@@ -75,8 +75,7 @@ void kill_bdev(struct block_device *bdev
 {
 	struct address_space *mapping = bdev->bd_inode->i_mapping;
 
-	if (mapping->nrpages == 0 && mapping->nrshadows == 0 &&
-			mapping->nrdax == 0)
+	if (mapping->nrpages == 0 && mapping->nrexceptional == 0)
 		return;
 
 	invalidate_bh_lrus();
diff -puN fs/inode.c~dax-support-dirty-dax-entries-in-radix-tree-v6 fs/inode.c
--- a/fs/inode.c~dax-support-dirty-dax-entries-in-radix-tree-v6
+++ a/fs/inode.c
@@ -495,8 +495,7 @@ void clear_inode(struct inode *inode)
 	 */
 	spin_lock_irq(&inode->i_data.tree_lock);
 	BUG_ON(inode->i_data.nrpages);
-	BUG_ON(inode->i_data.nrshadows);
-	BUG_ON(inode->i_data.nrdax);
+	BUG_ON(inode->i_data.nrexceptional);
 	spin_unlock_irq(&inode->i_data.tree_lock);
 	BUG_ON(!list_empty(&inode->i_data.private_list));
 	BUG_ON(!(inode->i_state & I_FREEING));
diff -puN include/linux/fs.h~dax-support-dirty-dax-entries-in-radix-tree-v6 include/linux/fs.h
--- a/include/linux/fs.h~dax-support-dirty-dax-entries-in-radix-tree-v6
+++ a/include/linux/fs.h
@@ -433,8 +433,8 @@ struct address_space {
 	struct rw_semaphore	i_mmap_rwsem;	/* protect tree, count, list */
 	/* Protected by tree_lock together with the radix tree */
 	unsigned long		nrpages;	/* number of total pages */
-	unsigned long		nrshadows;	/* number of shadow entries */
-	unsigned long		nrdax;	        /* number of DAX entries */
+	/* number of shadow or DAX exceptional entries */
+	unsigned long		nrexceptional;
 	pgoff_t			writeback_index;/* writeback starts here */
 	const struct address_space_operations *a_ops;	/* methods */
 	unsigned long		flags;		/* error bits/gfp mask */
diff -puN include/linux/radix-tree.h~dax-support-dirty-dax-entries-in-radix-tree-v6 include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~dax-support-dirty-dax-entries-in-radix-tree-v6
+++ a/include/linux/radix-tree.h
@@ -52,13 +52,13 @@
 #define RADIX_TREE_EXCEPTIONAL_SHIFT	2
 
 #define RADIX_DAX_MASK	0xf
+#define RADIX_DAX_SHIFT	4
 #define RADIX_DAX_PTE  (0x4 | RADIX_TREE_EXCEPTIONAL_ENTRY)
 #define RADIX_DAX_PMD  (0x8 | RADIX_TREE_EXCEPTIONAL_ENTRY)
-#define RADIX_DAX_TYPE(entry) ((__force unsigned long)entry & RADIX_DAX_MASK)
-#define RADIX_DAX_ADDR(entry) ((void __pmem *)((unsigned long)entry & \
-			~RADIX_DAX_MASK))
-#define RADIX_DAX_ENTRY(addr, pmd) ((void *)((__force unsigned long)addr | \
-			(pmd ? RADIX_DAX_PMD : RADIX_DAX_PTE)))
+#define RADIX_DAX_TYPE(entry) ((unsigned long)entry & RADIX_DAX_MASK)
+#define RADIX_DAX_SECTOR(entry) (((unsigned long)entry >> RADIX_DAX_SHIFT))
+#define RADIX_DAX_ENTRY(sector, pmd) ((void *)((unsigned long)sector << \
+		RADIX_DAX_SHIFT | (pmd ? RADIX_DAX_PMD : RADIX_DAX_PTE)))
 
 static inline int radix_tree_is_indirect_ptr(void *ptr)
 {
diff -puN mm/filemap.c~dax-support-dirty-dax-entries-in-radix-tree-v6 mm/filemap.c
--- a/mm/filemap.c~dax-support-dirty-dax-entries-in-radix-tree-v6
+++ a/mm/filemap.c
@@ -124,9 +124,9 @@ static void page_cache_tree_delete(struc
 	__radix_tree_lookup(&mapping->page_tree, page->index, &node, &slot);
 
 	if (shadow) {
-		mapping->nrshadows++;
+		mapping->nrexceptional++;
 		/*
-		 * Make sure the nrshadows update is committed before
+		 * Make sure the nrexceptional update is committed before
 		 * the nrpages update so that final truncate racing
 		 * with reclaim does not see both counters 0 at the
 		 * same time and miss a shadow entry.
@@ -581,14 +581,12 @@ static int page_cache_tree_insert(struct
 		if (!radix_tree_exceptional_entry(p))
 			return -EEXIST;
 
-		if (dax_mapping(mapping)) {
-			WARN_ON(1);
+		if (WARN_ON(dax_mapping(mapping)))
 			return -EINVAL;
-		}
 
 		if (shadowp)
 			*shadowp = p;
-		mapping->nrshadows--;
+		mapping->nrexceptional--;
 		if (node)
 			workingset_node_shadows_dec(node);
 	}
diff -puN mm/truncate.c~dax-support-dirty-dax-entries-in-radix-tree-v6 mm/truncate.c
--- a/mm/truncate.c~dax-support-dirty-dax-entries-in-radix-tree-v6
+++ a/mm/truncate.c
@@ -38,7 +38,7 @@ static void clear_exceptional_entry(stru
 
 	if (dax_mapping(mapping)) {
 		if (radix_tree_delete_item(&mapping->page_tree, index, entry))
-			mapping->nrdax--;
+			mapping->nrexceptional--;
 	} else {
 		/*
 		 * Regular page slots are stabilized by the page lock even
@@ -51,7 +51,7 @@ static void clear_exceptional_entry(stru
 		if (*slot != entry)
 			goto unlock;
 		radix_tree_replace_slot(slot, NULL);
-		mapping->nrshadows--;
+		mapping->nrexceptional--;
 		if (!node)
 			goto unlock;
 		workingset_node_shadows_dec(node);
@@ -237,8 +237,7 @@ void truncate_inode_pages_range(struct a
 	int		i;
 
 	cleancache_invalidate_inode(mapping);
-	if (mapping->nrpages == 0 && mapping->nrshadows == 0 &&
-			mapping->nrdax == 0)
+	if (mapping->nrpages == 0 && mapping->nrexceptional == 0)
 		return;
 
 	/* Offsets within partial pages */
@@ -412,7 +411,7 @@ EXPORT_SYMBOL(truncate_inode_pages);
  */
 void truncate_inode_pages_final(struct address_space *mapping)
 {
-	unsigned long nrshadows;
+	unsigned long nrexceptional;
 	unsigned long nrpages;
 
 	/*
@@ -426,14 +425,14 @@ void truncate_inode_pages_final(struct a
 
 	/*
 	 * When reclaim installs eviction entries, it increases
-	 * nrshadows first, then decreases nrpages.  Make sure we see
+	 * nrexceptional first, then decreases nrpages.  Make sure we see
 	 * this in the right order or we might miss an entry.
 	 */
 	nrpages = mapping->nrpages;
 	smp_rmb();
-	nrshadows = mapping->nrshadows;
+	nrexceptional = mapping->nrexceptional;
 
-	if (nrpages || nrshadows || mapping->nrdax) {
+	if (nrpages || nrexceptional) {
 		/*
 		 * As truncation uses a lockless tree lookup, cycle
 		 * the tree lock to make sure any ongoing tree
diff -puN mm/workingset.c~dax-support-dirty-dax-entries-in-radix-tree-v6 mm/workingset.c
--- a/mm/workingset.c~dax-support-dirty-dax-entries-in-radix-tree-v6
+++ a/mm/workingset.c
@@ -351,8 +351,8 @@ static enum lru_status shadow_lru_isolat
 			node->slots[i] = NULL;
 			BUG_ON(node->count < (1U << RADIX_TREE_COUNT_SHIFT));
 			node->count -= 1U << RADIX_TREE_COUNT_SHIFT;
-			BUG_ON(!mapping->nrshadows);
-			mapping->nrshadows--;
+			BUG_ON(!mapping->nrexceptional);
+			mapping->nrexceptional--;
 		}
 	}
 	BUG_ON(node->count);
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

dax-fix-null-pointer-dereference-in-__dax_dbg.patch
dax-fix-conversion-of-holes-to-pmds.patch
pmem-add-wb_cache_pmem-to-the-pmem-api.patch
dax-support-dirty-dax-entries-in-radix-tree.patch
mm-add-find_get_entries_tag.patch
dax-add-support-for-fsync-sync.patch
dax-add-support-for-fsync-sync-v6.patch
dax-add-support-for-fsync-msync-v7.patch
dax-add-support-for-fsync-msync-v8.patch
dax-add-support-for-fsync-msync-v8-fix.patch
dax-add-support-for-fsync-msync-v8-fix-2-v2.patch
dax-add-support-for-fsync-msync-v8-fix-3-v2.patch
dax-add-support-for-fsync-sync-v8-fix-4.patch
ext2-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
ext4-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
xfs-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
dax-never-rely-on-bhb_dev-being-set-by-get_block.patch

