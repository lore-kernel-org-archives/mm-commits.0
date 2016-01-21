From: akpm@linux-foundation.org
Subject: + dax-add-support-for-fsync-sync-v8-fix-4.patch added to -mm tree
Date: Thu, 21 Jan 2016 12:46:06 -0800
Message-ID: <56a1438e.Sh+hT/AckQX1k2o7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57429 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbcAUUqH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 15:46:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: fix clearing of holes in __dax_pmd_fault()
has been added to the -mm tree.  Its filename is
     dax-add-support-for-fsync-sync-v8-fix-4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-add-support-for-fsync-sync-v8-fix-4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-add-support-for-fsync-sync-v8-fix-4.patch

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
Subject: dax: fix clearing of holes in __dax_pmd_fault()

When the user reads from a DAX hole via a mmap we service page faults using
zero-filled page cache pages.  These zero pages are also placed into the
address_space radix tree.  When we get our first write for that space, we
can allocate a PMD page worth of DAX storage to replace that hole.

When this happens we need to unmap the zero pages and remove them from the
radix tree.  Prior to this patch we were unmapping *all* storage in our
PMD's range, which is incorrect because it removed DAX entries as well on
non-allocating page faults.

Instead, keep track of when get_block() actually gives us storage so that
we can be sure to only remove zero pages that were covering holes.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff -puN fs/dax.c~dax-add-support-for-fsync-sync-v8-fix-4 fs/dax.c
--- a/fs/dax.c~dax-add-support-for-fsync-sync-v8-fix-4
+++ a/fs/dax.c
@@ -788,9 +788,9 @@ int __dax_pmd_fault(struct vm_area_struc
 	bool write = flags & FAULT_FLAG_WRITE;
 	struct block_device *bdev;
 	pgoff_t size, pgoff;
-	loff_t lstart, lend;
 	sector_t block;
 	int error, result = 0;
+	bool alloc = false;
 
 	/* dax pmd mappings require pfn_t_devmap() */
 	if (!IS_ENABLED(CONFIG_FS_DAX_PMD))
@@ -828,10 +828,17 @@ int __dax_pmd_fault(struct vm_area_struc
 	block = (sector_t)pgoff << (PAGE_SHIFT - blkbits);
 
 	bh.b_size = PMD_SIZE;
-	if (get_block(inode, block, &bh, write) != 0)
+
+	if (get_block(inode, block, &bh, 0) != 0)
 		return VM_FAULT_SIGBUS;
+
+	if (!buffer_mapped(&bh) && write) {
+		if (get_block(inode, block, &bh, 1) != 0)
+			return VM_FAULT_SIGBUS;
+		alloc = true;
+	}
+
 	bdev = bh.b_bdev;
-	i_mmap_lock_read(mapping);
 
 	/*
 	 * If the filesystem isn't willing to tell us the length of a hole,
@@ -840,15 +847,20 @@ int __dax_pmd_fault(struct vm_area_struc
 	 */
 	if (!buffer_size_valid(&bh) || bh.b_size < PMD_SIZE) {
 		dax_pmd_dbg(&bh, address, "allocated block too small");
-		goto fallback;
+		return VM_FAULT_FALLBACK;
+	}
+
+	/*
+	 * If we allocated new storage, make sure no process has any
+	 * zero pages covering this hole
+	 */
+	if (alloc) {
+		loff_t lstart = pgoff << PAGE_SHIFT;
+		loff_t lend = lstart + PMD_SIZE - 1; /* inclusive */
+
+		truncate_pagecache_range(inode, lstart, lend);
 	}
 
-	/* make sure no process has any zero pages covering this hole */
-	lstart = pgoff << PAGE_SHIFT;
-	lend = lstart + PMD_SIZE - 1; /* inclusive */
-	i_mmap_unlock_read(mapping);
-	unmap_mapping_range(mapping, lstart, PMD_SIZE, 0);
-	truncate_inode_pages_range(mapping, lstart, lend);
 	i_mmap_lock_read(mapping);
 
 	/*
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

dax-fix-null-pointer-dereference-in-__dax_dbg.patch
dax-fix-conversion-of-holes-to-pmds.patch
pmem-add-wb_cache_pmem-to-the-pmem-api.patch
pmem-add-wb_cache_pmem-to-the-pmem-api-v6.patch
dax-support-dirty-dax-entries-in-radix-tree.patch
dax-support-dirty-dax-entries-in-radix-tree-v6.patch
mm-add-find_get_entries_tag.patch
dax-add-support-for-fsync-sync.patch
dax-add-support-for-fsync-sync-v6.patch
dax-add-support-for-fsync-msync-v7.patch
dax-add-support-for-fsync-msync-v8.patch
dax-add-support-for-fsync-msync-v8-fix.patch
dax-add-support-for-fsync-msync-v8-fix-2.patch
dax-add-support-for-fsync-msync-v8-fix-3.patch
dax-add-support-for-fsync-sync-v8-fix-4.patch
ext2-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
ext4-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
xfs-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
dax-never-rely-on-bhb_dev-being-set-by-get_block.patch

