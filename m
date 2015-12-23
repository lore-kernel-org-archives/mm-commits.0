From: akpm@linux-foundation.org
Subject: + dax-add-support-for-fsync-sync-v6.patch added to -mm tree
Date: Wed, 23 Dec 2015 13:01:50 -0800
Message-ID: <567b0bbe.s298/RwwKSiiIT0Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44245 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934194AbbLWVBv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Dec 2015 16:01:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, adilger.kernel@dilger.ca, bfields@fieldses.org, dan.j.williams@intel.com, dave.hansen@linux.intel.com, david@fromorbit.com, hpa@zytor.com, jack@suse.com, jlayton@poochiereds.net, matthew.r.wilcox@intel.com, mingo@redhat.com, tglx@linutronix.de, tytso@mit.edu, viro@zeniv.linux.org.uk, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax-add-support-for-fsync-sync-v6
has been added to the -mm tree.  Its filename is
     dax-add-support-for-fsync-sync-v6.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-add-support-for-fsync-sync-v6.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-add-support-for-fsync-sync-v6.patch

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
Subject: dax-add-support-for-fsync-sync-v6

2) Store sectors in the address_space radix tree for DAX entries instead
of addresses.  This allows us to get the addresses from the block driver
via dax_map_atomic() during fsync/msync so that we can protect against
races with block device removal.  (Dan)

3) Reordered things a bit in dax_writeback_one() so we clear the
PAGECACHE_TAG_TOWRITE tag even if the radix tree entry is corrupt.  This
prevents us from getting into an infinite loop where we don't proceed far
enough in dax_writeback_one() to clear that flag, but
dax_writeback_mapping_range() will keep finding that entry via
find_get_entries_tag().

4) Changed the ordering of the radix tree insertion so that it happens
before the page insertion into the page tables.  This ensures that we
don't end up in a case where the page table insertion succeeds and the
radix tree insertion fails which could give us a writeable PTE that has no
corresponding radix tree entry.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c            |  112 ++++++++++++++++++++++++++++--------------
 include/linux/dax.h |    2 
 mm/filemap.c        |    7 +-
 3 files changed, 81 insertions(+), 40 deletions(-)

diff -puN fs/dax.c~dax-add-support-for-fsync-sync-v6 fs/dax.c
--- a/fs/dax.c~dax-add-support-for-fsync-sync-v6
+++ a/fs/dax.c
@@ -325,8 +325,10 @@ static int copy_user_bh(struct page *to,
 	return 0;
 }
 
+#define NO_SECTOR -1
+
 static int dax_radix_entry(struct address_space *mapping, pgoff_t index,
-		void __pmem *addr, bool pmd_entry, bool dirty)
+		sector_t sector, bool pmd_entry, bool dirty)
 {
 	struct radix_tree_root *page_tree = &mapping->page_tree;
 	int error = 0;
@@ -341,10 +343,10 @@ static int dax_radix_entry(struct addres
 		if (!pmd_entry || RADIX_DAX_TYPE(entry) == RADIX_DAX_PMD)
 			goto dirty;
 		radix_tree_delete(&mapping->page_tree, index);
-		mapping->nrdax--;
+		mapping->nrexceptional--;
 	}
 
-	if (!addr) {
+	if (sector == NO_SECTOR) {
 		/*
 		 * This can happen during correct operation if our pfn_mkwrite
 		 * fault raced against a hole punch operation.  If this
@@ -356,17 +358,14 @@ static int dax_radix_entry(struct addres
 		 * to be retried by the CPU.
 		 */
 		goto unlock;
-	} else if (RADIX_DAX_TYPE(addr)) {
-		WARN_ONCE(1, "%s: invalid address %p\n", __func__, addr);
-		goto unlock;
 	}
 
 	error = radix_tree_insert(page_tree, index,
-			RADIX_DAX_ENTRY(addr, pmd_entry));
+			RADIX_DAX_ENTRY(sector, pmd_entry));
 	if (error)
 		goto unlock;
 
-	mapping->nrdax++;
+	mapping->nrexceptional++;
  dirty:
 	if (dirty)
 		radix_tree_tag_set(page_tree, index, PAGECACHE_TAG_DIRTY);
@@ -375,18 +374,15 @@ static int dax_radix_entry(struct addres
 	return error;
 }
 
-static void dax_writeback_one(struct address_space *mapping, pgoff_t index,
-		void *entry)
+static int dax_writeback_one(struct block_device *bdev,
+		struct address_space *mapping, pgoff_t index, void *entry)
 {
 	struct radix_tree_root *page_tree = &mapping->page_tree;
 	int type = RADIX_DAX_TYPE(entry);
 	struct radix_tree_node *node;
+	struct blk_dax_ctl dax;
 	void **slot;
-
-	if (type != RADIX_DAX_PTE && type != RADIX_DAX_PMD) {
-		WARN_ON_ONCE(1);
-		return;
-	}
+	int ret = 0;
 
 	spin_lock_irq(&mapping->tree_lock);
 	/*
@@ -405,12 +401,45 @@ static void dax_writeback_one(struct add
 
 	radix_tree_tag_clear(page_tree, index, PAGECACHE_TAG_TOWRITE);
 
-	if (type == RADIX_DAX_PMD)
-		wb_cache_pmem(RADIX_DAX_ADDR(entry), PMD_SIZE);
-	else
-		wb_cache_pmem(RADIX_DAX_ADDR(entry), PAGE_SIZE);
+	if (WARN_ON_ONCE(type != RADIX_DAX_PTE && type != RADIX_DAX_PMD)) {
+		ret = -EIO;
+		goto unlock;
+	}
+
+	dax.sector = RADIX_DAX_SECTOR(entry);
+	dax.size = (type == RADIX_DAX_PMD ? PMD_SIZE : PAGE_SIZE);
+	spin_unlock_irq(&mapping->tree_lock);
+
+	/*
+	 * We cannot hold tree_lock while calling dax_map_atomic() because it
+	 * eventually calls cond_resched().
+	 */
+	ret = dax_map_atomic(bdev, &dax);
+	if (ret < 0)
+		return ret;
+
+	if (WARN_ON_ONCE(ret < dax.size)) {
+		ret = -EIO;
+		dax_unmap_atomic(bdev, &dax);
+		return ret;
+	}
+
+	spin_lock_irq(&mapping->tree_lock);
+	/*
+	 * We need to revalidate our radix entry while holding tree_lock
+	 * before we do the writeback.
+	 */
+	if (!__radix_tree_lookup(page_tree, index, &node, &slot))
+		goto unmap;
+	if (*slot != entry)
+		goto unmap;
+
+	wb_cache_pmem(dax.addr, dax.size);
+ unmap:
+	dax_unmap_atomic(bdev, &dax);
  unlock:
 	spin_unlock_irq(&mapping->tree_lock);
+	return ret;
 }
 
 /*
@@ -418,20 +447,19 @@ static void dax_writeback_one(struct add
  * end]. This is required by data integrity operations to ensure file data is
  * on persistent storage prior to completion of the operation.
  */
-void dax_writeback_mapping_range(struct address_space *mapping, loff_t start,
+int dax_writeback_mapping_range(struct address_space *mapping, loff_t start,
 		loff_t end)
 {
 	struct inode *inode = mapping->host;
+	struct block_device *bdev = inode->i_sb->s_bdev;
 	pgoff_t indices[PAGEVEC_SIZE];
 	pgoff_t start_page, end_page;
 	struct pagevec pvec;
 	void *entry;
-	int i;
+	int i, ret = 0;
 
-	if (inode->i_blkbits != PAGE_SHIFT) {
-		WARN_ON_ONCE(1);
-		return;
-	}
+	if (WARN_ON_ONCE(inode->i_blkbits != PAGE_SHIFT))
+		return -EIO;
 
 	rcu_read_lock();
 	entry = radix_tree_lookup(&mapping->page_tree, start & PMD_MASK);
@@ -455,10 +483,15 @@ void dax_writeback_mapping_range(struct
 		if (pvec.nr == 0)
 			break;
 
-		for (i = 0; i < pvec.nr; i++)
-			dax_writeback_one(mapping, indices[i], pvec.pages[i]);
+		for (i = 0; i < pvec.nr; i++) {
+			ret = dax_writeback_one(bdev, mapping, indices[i],
+					pvec.pages[i]);
+			if (ret < 0)
+				return ret;
+		}
 	}
 	wmb_pmem();
+	return 0;
 }
 EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
 
@@ -501,12 +534,13 @@ static int dax_insert_mapping(struct ino
 	}
 	dax_unmap_atomic(bdev, &dax);
 
-	error = vm_insert_mixed(vma, vaddr, dax.pfn);
+	error = dax_radix_entry(mapping, vmf->pgoff, dax.sector, false,
+			vmf->flags & FAULT_FLAG_WRITE);
 	if (error)
 		goto out;
 
-	error = dax_radix_entry(mapping, vmf->pgoff, addr, false,
-			vmf->flags & FAULT_FLAG_WRITE);
+	error = vm_insert_mixed(vma, vaddr, dax.pfn);
+
  out:
 	i_mmap_unlock_read(mapping);
 
@@ -875,6 +909,16 @@ int __dax_pmd_fault(struct vm_area_struc
 		}
 		dax_unmap_atomic(bdev, &dax);
 
+		if (write) {
+			error = dax_radix_entry(mapping, pgoff, dax.sector,
+					true, true);
+			if (error) {
+				dax_pmd_dbg(bdev, address,
+						"PMD radix insertion failed");
+				goto fallback;
+			}
+		}
+
 		dev_dbg(part_to_dev(bdev->bd_part),
 				"%s: %s addr: %lx pfn: %lx sect: %llx\n",
 				__func__, current->comm, address,
@@ -882,12 +926,6 @@ int __dax_pmd_fault(struct vm_area_struc
 				(unsigned long long) dax.sector);
 		result |= vmf_insert_pfn_pmd(vma, address, pmd,
 				dax.pfn, write);
-		if (write) {
-			error = dax_radix_entry(mapping, pgoff, kaddr, true,
-					true);
-			if (error)
-				goto fallback;
-		}
 	}
 
  out:
@@ -944,7 +982,7 @@ int dax_pfn_mkwrite(struct vm_area_struc
 {
 	struct file *file = vma->vm_file;
 
-	dax_radix_entry(file->f_mapping, vmf->pgoff, NULL, false, true);
+	dax_radix_entry(file->f_mapping, vmf->pgoff, NO_SECTOR, false, true);
 	return VM_FAULT_NOPAGE;
 }
 EXPORT_SYMBOL_GPL(dax_pfn_mkwrite);
diff -puN include/linux/dax.h~dax-add-support-for-fsync-sync-v6 include/linux/dax.h
--- a/include/linux/dax.h~dax-add-support-for-fsync-sync-v6
+++ a/include/linux/dax.h
@@ -41,6 +41,6 @@ static inline bool dax_mapping(struct ad
 {
 	return mapping->host && IS_DAX(mapping->host);
 }
-void dax_writeback_mapping_range(struct address_space *mapping, loff_t start,
+int dax_writeback_mapping_range(struct address_space *mapping, loff_t start,
 		loff_t end);
 #endif
diff -puN mm/filemap.c~dax-add-support-for-fsync-sync-v6 mm/filemap.c
--- a/mm/filemap.c~dax-add-support-for-fsync-sync-v6
+++ a/mm/filemap.c
@@ -482,8 +482,11 @@ int filemap_write_and_wait_range(struct
 {
 	int err = 0;
 
-	if (dax_mapping(mapping) && mapping->nrdax)
-		dax_writeback_mapping_range(mapping, lstart, lend);
+	if (dax_mapping(mapping) && mapping->nrexceptional) {
+		err = dax_writeback_mapping_range(mapping, lstart, lend);
+		if (err)
+			return err;
+	}
 
 	if (mapping->nrpages) {
 		err = __filemap_fdatawrite_range(mapping, lstart, lend,
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

mm-dax-fix-livelock-allow-dax-pmd-mappings-to-become-writeable.patch
pmem-add-wb_cache_pmem-to-the-pmem-api.patch
pmem-add-wb_cache_pmem-to-the-pmem-api-v6.patch
dax-support-dirty-dax-entries-in-radix-tree.patch
dax-support-dirty-dax-entries-in-radix-tree-v6.patch
mm-add-find_get_entries_tag.patch
dax-add-support-for-fsync-sync.patch
dax-add-support-for-fsync-sync-v6.patch
ext2-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
ext4-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
xfs-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch

