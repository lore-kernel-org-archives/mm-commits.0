From: akpm@linux-foundation.org
Subject: + dax-add-support-for-fsync-msync-v8-fix-2.patch added to -mm
 tree
Date: Thu, 21 Jan 2016 12:46:02 -0800
Message-ID: <56a1438a.sebdL/VuRvp00Ti+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57423 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbcAUUqD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 15:46:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: improve documentation for fsync/msync
has been added to the -mm tree.  Its filename is
     dax-add-support-for-fsync-msync-v8-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-add-support-for-fsync-msync-v8-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-add-support-for-fsync-msync-v8-fix-2.patch

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
Subject: dax: improve documentation for fsync/msync

Several of the subtleties and assumptions of the DAX fsync/msync
implementation are not immediately obvious, so document them with comments.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff -puN fs/dax.c~dax-add-support-for-fsync-msync-v8-fix-2 fs/dax.c
--- a/fs/dax.c~dax-add-support-for-fsync-msync-v8-fix-2
+++ a/fs/dax.c
@@ -349,6 +349,13 @@ static int dax_radix_entry(struct addres
 
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
@@ -910,6 +917,21 @@ int __dax_pmd_fault(struct vm_area_struc
 		}
 		dax_unmap_atomic(bdev, &dax);
 
+		/*
+		 * For PTE faults we insert a radix tree entry for reads, and
+		 * leave it clean.  Then on the first write we dirty the radix
+		 * tree entry via the dax_pnf_mkwrite() path.  This sequence
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
@@ -983,6 +1005,14 @@ int dax_pfn_mkwrite(struct vm_area_struc
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

