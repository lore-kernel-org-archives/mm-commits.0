From: akpm@linux-foundation.org
Subject: + dax-support-dirty-dax-entries-in-radix-tree.patch added to -mm
 tree
Date: Tue, 22 Dec 2015 14:46:47 -0800
Message-ID: <5679d2d7.kljbM1eziyBNyPfm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59693 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932299AbbLVWqs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Dec 2015 17:46:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, adilger.kernel@dilger.ca, bfields@fieldses.org, dan.j.williams@intel.com, dave.hansen@linux.intel.com, david@fromorbit.com, hpa@zytor.com, hughd@google.com, jack@suse.com, jlayton@poochiereds.net, matthew.r.wilcox@intel.com, mingo@redhat.com, tglx@linutronix.de, tytso@mit.edu, viro@zeniv.linux.org.uk, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: support dirty DAX entries in radix tree
has been added to the -mm tree.  Its filename is
     dax-support-dirty-dax-entries-in-radix-tree.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-support-dirty-dax-entries-in-radix-tree.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-support-dirty-dax-entries-in-radix-tree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: support dirty DAX entries in radix tree

Add support for tracking dirty DAX entries in the struct address_space
radix tree.  This tree is already used for dirty page writeback, and it
already supports the use of exceptional (non struct page*) entries.

In order to properly track dirty DAX pages we will insert new exceptional
entries into the radix tree that represent dirty DAX PTE or PMD pages. 
These exceptional entries will also contain the writeback addresses for
the PTE or PMD faults that we can use at fsync/msync time.

There are currently two types of exceptional entries (shmem and shadow)
that can be placed into the radix tree, and this adds a third.  We rely on
the fact that only one type of exceptional entry can be found in a given
radix tree based on its usage.  This happens for free with DAX vs shmem
but we explicitly prevent shadow entries from being added to radix trees
for DAX mappings.

The only shadow entries that would be generated for DAX radix trees would
be to track zero page mappings that were created for holes.  These pages
would receive minimal benefit from having shadow entries, and the choice
to have only one type of exceptional entry in a given radix tree makes the
logic simpler both in clear_exceptional_entry() and in the rest of DAX.

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

 fs/block_dev.c             |    3 +
 fs/inode.c                 |    1 
 include/linux/dax.h        |    5 ++
 include/linux/fs.h         |    1 
 include/linux/radix-tree.h |    9 ++++
 mm/filemap.c               |   13 +++++--
 mm/truncate.c              |   64 ++++++++++++++++++++---------------
 mm/vmscan.c                |    9 ++++
 8 files changed, 73 insertions(+), 32 deletions(-)

diff -puN fs/block_dev.c~dax-support-dirty-dax-entries-in-radix-tree fs/block_dev.c
--- a/fs/block_dev.c~dax-support-dirty-dax-entries-in-radix-tree
+++ a/fs/block_dev.c
@@ -75,7 +75,8 @@ void kill_bdev(struct block_device *bdev
 {
 	struct address_space *mapping = bdev->bd_inode->i_mapping;
 
-	if (mapping->nrpages == 0 && mapping->nrshadows == 0)
+	if (mapping->nrpages == 0 && mapping->nrshadows == 0 &&
+			mapping->nrdax == 0)
 		return;
 
 	invalidate_bh_lrus();
diff -puN fs/inode.c~dax-support-dirty-dax-entries-in-radix-tree fs/inode.c
--- a/fs/inode.c~dax-support-dirty-dax-entries-in-radix-tree
+++ a/fs/inode.c
@@ -496,6 +496,7 @@ void clear_inode(struct inode *inode)
 	spin_lock_irq(&inode->i_data.tree_lock);
 	BUG_ON(inode->i_data.nrpages);
 	BUG_ON(inode->i_data.nrshadows);
+	BUG_ON(inode->i_data.nrdax);
 	spin_unlock_irq(&inode->i_data.tree_lock);
 	BUG_ON(!list_empty(&inode->i_data.private_list));
 	BUG_ON(!(inode->i_state & I_FREEING));
diff -puN include/linux/dax.h~dax-support-dirty-dax-entries-in-radix-tree include/linux/dax.h
--- a/include/linux/dax.h~dax-support-dirty-dax-entries-in-radix-tree
+++ a/include/linux/dax.h
@@ -36,4 +36,9 @@ static inline bool vma_is_dax(struct vm_
 {
 	return vma->vm_file && IS_DAX(vma->vm_file->f_mapping->host);
 }
+
+static inline bool dax_mapping(struct address_space *mapping)
+{
+	return mapping->host && IS_DAX(mapping->host);
+}
 #endif
diff -puN include/linux/fs.h~dax-support-dirty-dax-entries-in-radix-tree include/linux/fs.h
--- a/include/linux/fs.h~dax-support-dirty-dax-entries-in-radix-tree
+++ a/include/linux/fs.h
@@ -433,6 +433,7 @@ struct address_space {
 	/* Protected by tree_lock together with the radix tree */
 	unsigned long		nrpages;	/* number of total pages */
 	unsigned long		nrshadows;	/* number of shadow entries */
+	unsigned long		nrdax;	        /* number of DAX entries */
 	pgoff_t			writeback_index;/* writeback starts here */
 	const struct address_space_operations *a_ops;	/* methods */
 	unsigned long		flags;		/* error bits/gfp mask */
diff -puN include/linux/radix-tree.h~dax-support-dirty-dax-entries-in-radix-tree include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~dax-support-dirty-dax-entries-in-radix-tree
+++ a/include/linux/radix-tree.h
@@ -51,6 +51,15 @@
 #define RADIX_TREE_EXCEPTIONAL_ENTRY	2
 #define RADIX_TREE_EXCEPTIONAL_SHIFT	2
 
+#define RADIX_DAX_MASK	0xf
+#define RADIX_DAX_PTE  (0x4 | RADIX_TREE_EXCEPTIONAL_ENTRY)
+#define RADIX_DAX_PMD  (0x8 | RADIX_TREE_EXCEPTIONAL_ENTRY)
+#define RADIX_DAX_TYPE(entry) ((__force unsigned long)entry & RADIX_DAX_MASK)
+#define RADIX_DAX_ADDR(entry) ((void __pmem *)((unsigned long)entry & \
+			~RADIX_DAX_MASK))
+#define RADIX_DAX_ENTRY(addr, pmd) ((void *)((__force unsigned long)addr | \
+			(pmd ? RADIX_DAX_PMD : RADIX_DAX_PTE)))
+
 static inline int radix_tree_is_indirect_ptr(void *ptr)
 {
 	return (int)((unsigned long)ptr & RADIX_TREE_INDIRECT_PTR);
diff -puN mm/filemap.c~dax-support-dirty-dax-entries-in-radix-tree mm/filemap.c
--- a/mm/filemap.c~dax-support-dirty-dax-entries-in-radix-tree
+++ a/mm/filemap.c
@@ -11,6 +11,7 @@
  */
 #include <linux/export.h>
 #include <linux/compiler.h>
+#include <linux/dax.h>
 #include <linux/fs.h>
 #include <linux/uaccess.h>
 #include <linux/capability.h>
@@ -579,6 +580,12 @@ static int page_cache_tree_insert(struct
 		p = radix_tree_deref_slot_protected(slot, &mapping->tree_lock);
 		if (!radix_tree_exceptional_entry(p))
 			return -EEXIST;
+
+		if (dax_mapping(mapping)) {
+			WARN_ON(1);
+			return -EINVAL;
+		}
+
 		if (shadowp)
 			*shadowp = p;
 		mapping->nrshadows--;
@@ -1245,9 +1252,9 @@ repeat:
 			if (radix_tree_deref_retry(page))
 				goto restart;
 			/*
-			 * A shadow entry of a recently evicted page,
-			 * or a swap entry from shmem/tmpfs.  Return
-			 * it without attempting to raise page count.
+			 * A shadow entry of a recently evicted page, a swap
+			 * entry from shmem/tmpfs or a DAX entry.  Return it
+			 * without attempting to raise page count.
 			 */
 			goto export;
 		}
diff -puN mm/truncate.c~dax-support-dirty-dax-entries-in-radix-tree mm/truncate.c
--- a/mm/truncate.c~dax-support-dirty-dax-entries-in-radix-tree
+++ a/mm/truncate.c
@@ -9,6 +9,7 @@
 
 #include <linux/kernel.h>
 #include <linux/backing-dev.h>
+#include <linux/dax.h>
 #include <linux/gfp.h>
 #include <linux/mm.h>
 #include <linux/swap.h>
@@ -34,31 +35,39 @@ static void clear_exceptional_entry(stru
 		return;
 
 	spin_lock_irq(&mapping->tree_lock);
-	/*
-	 * Regular page slots are stabilized by the page lock even
-	 * without the tree itself locked.  These unlocked entries
-	 * need verification under the tree lock.
-	 */
-	if (!__radix_tree_lookup(&mapping->page_tree, index, &node, &slot))
-		goto unlock;
-	if (*slot != entry)
-		goto unlock;
-	radix_tree_replace_slot(slot, NULL);
-	mapping->nrshadows--;
-	if (!node)
-		goto unlock;
-	workingset_node_shadows_dec(node);
-	/*
-	 * Don't track node without shadow entries.
-	 *
-	 * Avoid acquiring the list_lru lock if already untracked.
-	 * The list_empty() test is safe as node->private_list is
-	 * protected by mapping->tree_lock.
-	 */
-	if (!workingset_node_shadows(node) &&
-	    !list_empty(&node->private_list))
-		list_lru_del(&workingset_shadow_nodes, &node->private_list);
-	__radix_tree_delete_node(&mapping->page_tree, node);
+
+	if (dax_mapping(mapping)) {
+		if (radix_tree_delete_item(&mapping->page_tree, index, entry))
+			mapping->nrdax--;
+	} else {
+		/*
+		 * Regular page slots are stabilized by the page lock even
+		 * without the tree itself locked.  These unlocked entries
+		 * need verification under the tree lock.
+		 */
+		if (!__radix_tree_lookup(&mapping->page_tree, index, &node,
+					&slot))
+			goto unlock;
+		if (*slot != entry)
+			goto unlock;
+		radix_tree_replace_slot(slot, NULL);
+		mapping->nrshadows--;
+		if (!node)
+			goto unlock;
+		workingset_node_shadows_dec(node);
+		/*
+		 * Don't track node without shadow entries.
+		 *
+		 * Avoid acquiring the list_lru lock if already untracked.
+		 * The list_empty() test is safe as node->private_list is
+		 * protected by mapping->tree_lock.
+		 */
+		if (!workingset_node_shadows(node) &&
+		    !list_empty(&node->private_list))
+			list_lru_del(&workingset_shadow_nodes,
+					&node->private_list);
+		__radix_tree_delete_node(&mapping->page_tree, node);
+	}
 unlock:
 	spin_unlock_irq(&mapping->tree_lock);
 }
@@ -228,7 +237,8 @@ void truncate_inode_pages_range(struct a
 	int		i;
 
 	cleancache_invalidate_inode(mapping);
-	if (mapping->nrpages == 0 && mapping->nrshadows == 0)
+	if (mapping->nrpages == 0 && mapping->nrshadows == 0 &&
+			mapping->nrdax == 0)
 		return;
 
 	/* Offsets within partial pages */
@@ -423,7 +433,7 @@ void truncate_inode_pages_final(struct a
 	smp_rmb();
 	nrshadows = mapping->nrshadows;
 
-	if (nrpages || nrshadows) {
+	if (nrpages || nrshadows || mapping->nrdax) {
 		/*
 		 * As truncation uses a lockless tree lookup, cycle
 		 * the tree lock to make sure any ongoing tree
diff -puN mm/vmscan.c~dax-support-dirty-dax-entries-in-radix-tree mm/vmscan.c
--- a/mm/vmscan.c~dax-support-dirty-dax-entries-in-radix-tree
+++ a/mm/vmscan.c
@@ -46,6 +46,7 @@
 #include <linux/oom.h>
 #include <linux/prefetch.h>
 #include <linux/printk.h>
+#include <linux/dax.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -671,9 +672,15 @@ static int __remove_mapping(struct addre
 		 * inode reclaim needs to empty out the radix tree or
 		 * the nodes are lost.  Don't plant shadows behind its
 		 * back.
+		 *
+		 * We also don't store shadows for DAX mappings because the
+		 * only page cache pages found in these are zero pages
+		 * covering holes, and because we don't want to mix DAX
+		 * exceptional entries and shadow exceptional entries in the
+		 * same page_tree.
 		 */
 		if (reclaimed && page_is_file_cache(page) &&
-		    !mapping_exiting(mapping))
+		    !mapping_exiting(mapping) && !dax_mapping(mapping))
 			shadow = workingset_eviction(mapping, page);
 		__delete_from_page_cache(page, shadow, memcg);
 		spin_unlock_irqrestore(&mapping->tree_lock, flags);
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

mm-dax-fix-livelock-allow-dax-pmd-mappings-to-become-writeable.patch
pmem-add-wb_cache_pmem-to-the-pmem-api.patch
dax-support-dirty-dax-entries-in-radix-tree.patch
mm-add-find_get_entries_tag.patch
dax-add-support-for-fsync-sync.patch
ext2-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
ext4-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
xfs-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch

