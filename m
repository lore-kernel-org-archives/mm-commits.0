From: akpm@linux-foundation.org
Subject: [folded-merged] dax-add-support-for-fsync-msync-v8-fix-2-v2.patch removed from -mm tree
Date: Fri, 22 Jan 2016 14:58:04 -0800
Message-ID: <56a2b3fc.20rhBfC5yo2Znthg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56979 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbcAVW6F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Jan 2016 17:58:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: improve documentation for fsync/msync
has been removed from the -mm tree.  Its filename was
     dax-add-support-for-fsync-msync-v8-fix-2-v2.patch

This patch was dropped because it was folded into dax-add-support-for-fsync-sync.patch

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: improve documentation for fsync/msync

Several of the subtleties and assumptions of the DAX fsync/msync
implementation are not immediately obvious, so document them with comments.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff -puN fs/dax.c~dax-add-support-for-fsync-msync-v8-fix-2-v2 fs/dax.c
--- a/fs/dax.c~dax-add-support-for-fsync-msync-v8-fix-2-v2
+++ a/fs/dax.c
@@ -334,6 +334,7 @@ static int dax_radix_entry(struct addres
 	int type, error = 0;
 	void *entry;
 
+	WARN_ON_ONCE(pmd_entry && !dirty);
 	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 
 	spin_lock_irq(&mapping->tree_lock);
@@ -349,6 +350,13 @@ static int dax_radix_entry(struct addres
 
 		if (!pmd_entry || type == RADIX_DAX_PMD)
 			goto dirty;
+
+		/*
+		 * We only insert dirty PMD entries into the radix tree.  This
+		 * means we don't need to worry about removing a dirty PTE
+		 * entry and inserting a clean PMD entry, thus reducing the
+		 * range we would flush with a follow-up fsync/msync call.
+		 */
 		radix_tree_delete(&mapping->page_tree, index);
 		mapping->nrexceptional--;
 	}
@@ -910,6 +918,21 @@ int __dax_pmd_fault(struct vm_area_struc
 		}
 		dax_unmap_atomic(bdev, &dax);
 
+		/*
+		 * For PTE faults we insert a radix tree entry for reads, and
+		 * leave it clean.  Then on the first write we dirty the radix
+		 * tree entry via the dax_pfn_mkwrite() path.  This sequence
+		 * allows the dax_pfn_mkwrite() call to be simpler and avoid a
+		 * call into get_block() to translate the pgoff to a sector in
+		 * order to be able to create a new radix tree entry.
+		 *
+		 * The PMD path doesn't have an equivalent to
+		 * dax_pfn_mkwrite(), though, so for a read followed by a
+		 * write we traverse all the way through __dax_pmd_fault()
+		 * twice.  This means we can just skip inserting a radix tree
+		 * entry completely on the initial read and just wait until
+		 * the write to insert a dirty entry.
+		 */
 		if (write) {
 			error = dax_radix_entry(mapping, pgoff, dax.sector,
 					true, true);
@@ -983,6 +1006,14 @@ int dax_pfn_mkwrite(struct vm_area_struc
 {
 	struct file *file = vma->vm_file;
 
+	/*
+	 * We pass NO_SECTOR to dax_radix_entry() because we expect that a
+	 * RADIX_DAX_PTE entry already exists in the radix tree from a
+	 * previous call to __dax_fault().  We just want to look up that PTE
+	 * entry using vmf->pgoff and make sure the dirty tag is set.  This
+	 * saves us from having to make a call to get_block() here to look
+	 * up the sector.
+	 */
 	dax_radix_entry(file->f_mapping, vmf->pgoff, NO_SECTOR, false, true);
 	return VM_FAULT_NOPAGE;
 }
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

dax-fix-null-pointer-dereference-in-__dax_dbg.patch
dax-fix-conversion-of-holes-to-pmds.patch
pmem-add-wb_cache_pmem-to-the-pmem-api.patch
dax-support-dirty-dax-entries-in-radix-tree.patch
mm-add-find_get_entries_tag.patch
dax-add-support-for-fsync-sync.patch
dax-add-support-for-fsync-msync-v8-fix-3-v2.patch
dax-add-support-for-fsync-sync-v8-fix-4.patch
ext2-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
ext4-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
xfs-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
dax-never-rely-on-bhb_dev-being-set-by-get_block.patch

