From: akpm@linux-foundation.org
Subject: + dax-remove-unnecessary-rechecking-of-i_size.patch added to -mm
 tree
Date: Tue, 29 Mar 2016 14:08:30 -0700
Message-ID: <56faeece.ntB2oCWcNLI5eKez%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbcC2VIc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Mar 2016 17:08:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, dan.j.williams@intel.com, david@fromorbit.com, hpa@zytor.com, jack@suse.cz, kirill@shutemov.name, matthew.r.wilcox@intel.com, mingo@elte.hu, rientjes@google.com, ross.zwisler@linux.intel.com, tglx@linutronix.de, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: remove unnecessary rechecking of i_size
has been added to the -mm tree.  Its filename is
     dax-remove-unnecessary-rechecking-of-i_size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-remove-unnecessary-rechecking-of-i_size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-remove-unnecessary-rechecking-of-i_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: dax: remove unnecessary rechecking of i_size

When i_mmap_lock (or the page lock) was the only protection against
truncate, we checked i_size at the beginning of the fault handler, then
rechecked it after acquiring the lock.  Since the fliesystems now exclude
truncate from racing with the fault handler, we no longer need to recheck
i_size.  We do, of course, still need to check i_size at the entry to the
fault handler.

Also remove the now-unnecessary acquisitions of i_mmap_lock.  One of the
acquisitions is still needed, so put a big fat comment beside it to
prevent the well-intentioned from removing it.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   98 +++++------------------------------------------------
 1 file changed, 10 insertions(+), 88 deletions(-)

diff -puN fs/dax.c~dax-remove-unnecessary-rechecking-of-i_size fs/dax.c
--- a/fs/dax.c~dax-remove-unnecessary-rechecking-of-i_size
+++ a/fs/dax.c
@@ -312,21 +312,11 @@ EXPORT_SYMBOL_GPL(dax_do_io);
 static int dax_load_hole(struct address_space *mapping, struct page *page,
 							struct vm_fault *vmf)
 {
-	unsigned long size;
-	struct inode *inode = mapping->host;
 	if (!page)
 		page = find_or_create_page(mapping, vmf->pgoff,
 						vmf->gfp_mask | __GFP_ZERO);
 	if (!page)
 		return VM_FAULT_OOM;
-	/* Recheck i_size under page lock to avoid truncate race */
-	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	if (vmf->pgoff >= size) {
-		unlock_page(page);
-		page_cache_release(page);
-		return VM_FAULT_SIGBUS;
-	}
-
 	vmf->page = page;
 	return VM_FAULT_LOCKED;
 }
@@ -556,24 +546,8 @@ static int dax_insert_mapping(struct ino
 		.sector = to_sector(bh, inode),
 		.size = bh->b_size,
 	};
-	pgoff_t size;
 	int error;
 
-	i_mmap_lock_read(mapping);
-
-	/*
-	 * Check truncate didn't happen while we were allocating a block.
-	 * If it did, this block may or may not be still allocated to the
-	 * file.  We can't tell the filesystem to free it because we can't
-	 * take i_mutex here.  In the worst case, the file still has blocks
-	 * allocated past the end of the file.
-	 */
-	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	if (unlikely(vmf->pgoff >= size)) {
-		error = -EIO;
-		goto out;
-	}
-
 	if (dax_map_atomic(bdev, &dax) < 0) {
 		error = PTR_ERR(dax.addr);
 		goto out;
@@ -593,8 +567,6 @@ static int dax_insert_mapping(struct ino
 	error = vm_insert_mixed(vma, vaddr, dax.pfn);
 
  out:
-	i_mmap_unlock_read(mapping);
-
 	return error;
 }
 
@@ -634,15 +606,6 @@ static int dax_pte_fault(struct vm_area_
 			page_cache_release(page);
 			goto repeat;
 		}
-		size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
-		if (unlikely(vmf->pgoff >= size)) {
-			/*
-			 * We have a struct page covering a hole in the file
-			 * from a read fault and we've raced with a truncate
-			 */
-			error = -EIO;
-			goto unlock_page;
-		}
 	}
 
 	error = get_block(inode, block, &bh, 0);
@@ -675,17 +638,17 @@ static int dax_pte_fault(struct vm_area_
 		if (error)
 			goto unlock_page;
 		vmf->page = page;
-		if (!page) {
+
+		/*
+		 * A truncate must remove COWs of pages that are removed
+		 * from the file.  If we have a struct page, the normal
+		 * page lock mechanism prevents truncate from missing the
+		 * COWed page.  If not, the i_mmap_lock can provide the
+		 * same guarantee.  It is dropped by the caller after the
+		 * page is safely in the page tables.
+		 */
+		if (!page)
 			i_mmap_lock_read(mapping);
-			/* Check we didn't race with truncate */
-			size = (i_size_read(inode) + PAGE_SIZE - 1) >>
-								PAGE_SHIFT;
-			if (vmf->pgoff >= size) {
-				i_mmap_unlock_read(mapping);
-				error = -EIO;
-				goto out;
-			}
-		}
 		return VM_FAULT_LOCKED;
 	}
 
@@ -847,25 +810,6 @@ static int dax_pmd_fault(struct vm_area_
 		truncate_pagecache_range(inode, lstart, lend);
 	}
 
-	i_mmap_lock_read(mapping);
-
-	/*
-	 * If a truncate happened while we were allocating blocks, we may
-	 * leave blocks allocated to the file that are beyond EOF.  We can't
-	 * take i_mutex here, so just leave them hanging; they'll be freed
-	 * when the file is deleted.
-	 */
-	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	if (pgoff >= size) {
-		result = VM_FAULT_SIGBUS;
-		goto out;
-	}
-	if ((pgoff | PG_PMD_COLOUR) >= size) {
-		dax_pmd_dbg(&bh, address,
-				"offset + huge page size > file size");
-		goto fallback;
-	}
-
 	if (!write && !buffer_mapped(&bh) && buffer_uptodate(&bh)) {
 		spinlock_t *ptl;
 		pmd_t entry, *pmd = vmf->pmd;
@@ -965,8 +909,6 @@ static int dax_pmd_fault(struct vm_area_
 	}
 
  out:
-	i_mmap_unlock_read(mapping);
-
 	if (buffer_unwritten(&bh))
 		complete_unwritten(&bh, !(result & VM_FAULT_ERROR));
 
@@ -1074,24 +1016,6 @@ static int dax_pud_fault(struct vm_area_
 		truncate_pagecache_range(inode, lstart, lend);
 	}
 
-	i_mmap_lock_read(mapping);
-
-	/*
-	 * If a truncate happened while we were allocating blocks, we may
-	 * leave blocks allocated to the file that are beyond EOF.  We can't
-	 * take i_mutex here, so just leave them hanging; they'll be freed
-	 * when the file is deleted.
-	 */
-	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	if (pgoff >= size) {
-		result = VM_FAULT_SIGBUS;
-		goto out;
-	}
-	if ((pgoff | PG_PUD_COLOUR) >= size) {
-		dax_pud_dbg(&bh, address, "page extends outside VMA");
-		goto fallback;
-	}
-
 	if (!write && !buffer_mapped(&bh) && buffer_uptodate(&bh)) {
 		dax_pud_dbg(&bh, address, "no zero page");
 		goto fallback;
@@ -1142,8 +1066,6 @@ static int dax_pud_fault(struct vm_area_
 	}
 
  out:
-	i_mmap_unlock_read(mapping);
