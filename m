From: akpm@linux-foundation.org
Subject: [merged] dax-fix-conversion-of-holes-to-pmds.patch removed from
 -mm tree
Date: Mon, 25 Jan 2016 10:58:32 -0800
Message-ID: <56a67058./f52t4pFzvp2ly6t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48095 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978AbcAYS6d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jan 2016 13:58:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, adilger.kernel@dilger.ca, bfields@fieldses.org, dan.j.williams@intel.com, dave.hansen@linux.intel.com, david@fromorbit.com, hpa@zytor.com, jack@suse.cz, jlayton@poochiereds.net, matthew.r.wilcox@intel.com, mingo@redhat.com, tglx@linutronix.de, tytso@mit.edu, viro@zeniv.linux.org.uk, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: fix conversion of holes to PMDs
has been removed from the -mm tree.  Its filename was
     dax-fix-conversion-of-holes-to-pmds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: fix conversion of holes to PMDs

When we get a DAX PMD fault for a write it is possible that there could be
some number of 4k zero pages already present for the same range that were
inserted to service reads from a hole.  These 4k zero pages need to be
unmapped from the VMAs and removed from the struct address_space radix
tree before the real DAX PMD entry can be inserted.

For PTE faults this same use case also exists and is handled by a
combination of unmap_mapping_range() to unmap the VMAs and
delete_from_page_cache() to remove the page from the address_space radix
tree.

For PMD faults we do have a call to unmap_mapping_range() (protected by a
buffer_new() check), but nothing clears out the radix tree entry.  The
buffer_new() check is also incorrect as the current ext4 and XFS
filesystem code will never return a buffer_head with BH_New set, even when
allocating new blocks over a hole.  Instead the filesystem will zero the
blocks manually and return a buffer_head with only BH_Mapped set.

Fix this situation by removing the buffer_new() check and adding a call to
truncate_inode_pages_range() to clear out the radix tree entries before we
insert the DAX PMD.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN fs/dax.c~dax-fix-conversion-of-holes-to-pmds fs/dax.c
--- a/fs/dax.c~dax-fix-conversion-of-holes-to-pmds
+++ a/fs/dax.c
@@ -589,6 +589,7 @@ int __dax_pmd_fault(struct vm_area_struc
 	bool write = flags & FAULT_FLAG_WRITE;
 	struct block_device *bdev;
 	pgoff_t size, pgoff;
+	loff_t lstart, lend;
 	sector_t block;
 	int result = 0;
 
@@ -643,15 +644,13 @@ int __dax_pmd_fault(struct vm_area_struc
 		goto fallback;
 	}
 
-	/*
-	 * If we allocated new storage, make sure no process has any
-	 * zero pages covering this hole
-	 */
-	if (buffer_new(&bh)) {
-		i_mmap_unlock_read(mapping);
-		unmap_mapping_range(mapping, pgoff << PAGE_SHIFT, PMD_SIZE, 0);
-		i_mmap_lock_read(mapping);
-	}
+	/* make sure no process has any zero pages covering this hole */
+	lstart = pgoff << PAGE_SHIFT;
+	lend = lstart + PMD_SIZE - 1; /* inclusive */
+	i_mmap_unlock_read(mapping);
+	unmap_mapping_range(mapping, lstart, PMD_SIZE, 0);
+	truncate_inode_pages_range(mapping, lstart, lend);
+	i_mmap_lock_read(mapping);
 
 	/*
 	 * If a truncate happened while we were allocating blocks, we may
@@ -665,7 +664,8 @@ int __dax_pmd_fault(struct vm_area_struc
 		goto out;
 	}
 	if ((pgoff | PG_PMD_COLOUR) >= size) {
-		dax_pmd_dbg(&bh, address, "pgoff unaligned");
+		dax_pmd_dbg(&bh, address,
+				"offset + huge page size > file size");
 		goto fallback;
 	}
 
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are


