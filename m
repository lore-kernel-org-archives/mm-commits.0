From: akpm@linux-foundation.org
Subject: [to-be-updated]
 revert-mm-take-i_mmap_lock-in-unmap_mapping_range-for-dax.patch removed
 from -mm tree
Date: Thu, 08 Oct 2015 14:05:26 -0700
Message-ID: <5616da96.53aEUZj51aoYWIOO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbbJHVF1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Oct 2015 17:05:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dan.j.williams@intel.com, david@fromorbit.com, jack@suse.com, kirill.shutemov@linux.intel.com, matthew.r.wilcox@intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "mm: take i_mmap_lock in unmap_mapping_range() for DAX"
has been removed from the -mm tree.  Its filename was
     revert-mm-take-i_mmap_lock-in-unmap_mapping_range-for-dax.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Revert "mm: take i_mmap_lock in unmap_mapping_range() for DAX"

This reverts commits 46c043ede4711e8d ("mm: take i_mmap_lock in
unmap_mapping_range() for DAX") and 8346c416d17bf5b4 ("dax: fix race
between simultaneous faults").

These introduced a number of deadlocks and other issues, and need to be
reverted for the v4.3 kernel.  The list of issues in DAX after these
commits (some newly introduced by the commits, some preexisting) can be
found here:

https://lkml.org/lkml/2015/9/25/602 (Subject: "Re: [PATCH] dax: fix
deadlock in __dax_fault").

This revert keeps the PMEM API changes to the zeroing code in
__dax_pmd_fault(), which were added by this commit:

commit d77e92e270ed ("dax: update PMD fault handler with PMEM API")

It also keeps the code dropping mapping->i_mmap_rwsem before calling
unmap_mapping_range(), but converts it to a read lock since that's what is
now used by the rest of __dax_pmd_fault().  This is needed to avoid
recursively acquiring mapping->i_mmap_rwsem, once with a read lock in
__dax_pmd_fault() and once with a write lock in unmap_mapping_range().

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c    |   37 +++++++++++++------------------------
 mm/memory.c |   11 +++++++++--
 2 files changed, 22 insertions(+), 26 deletions(-)

diff -puN fs/dax.c~revert-mm-take-i_mmap_lock-in-unmap_mapping_range-for-dax fs/dax.c
--- a/fs/dax.c~revert-mm-take-i_mmap_lock-in-unmap_mapping_range-for-dax
+++ a/fs/dax.c
@@ -569,36 +569,14 @@ int __dax_pmd_fault(struct vm_area_struc
 	if (!buffer_size_valid(&bh) || bh.b_size < PMD_SIZE)
 		goto fallback;
 
-	sector = bh.b_blocknr << (blkbits - 9);
-
-	if (buffer_unwritten(&bh) || buffer_new(&bh)) {
-		int i;
-
-		length = bdev_direct_access(bh.b_bdev, sector, &kaddr, &pfn,
-						bh.b_size);
-		if (length < 0) {
-			result = VM_FAULT_SIGBUS;
-			goto out;
-		}
-		if ((length < PMD_SIZE) || (pfn & PG_PMD_COLOUR))
-			goto fallback;
-
-		for (i = 0; i < PTRS_PER_PMD; i++)
-			clear_pmem(kaddr + i * PAGE_SIZE, PAGE_SIZE);
-		wmb_pmem();
-		count_vm_event(PGMAJFAULT);
-		mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
-		result |= VM_FAULT_MAJOR;
-	}
-
 	/*
 	 * If we allocated new storage, make sure no process has any
 	 * zero pages covering this hole
 	 */
 	if (buffer_new(&bh)) {
-		i_mmap_unlock_write(mapping);
+		i_mmap_unlock_read(mapping);
 		unmap_mapping_range(mapping, pgoff << PAGE_SHIFT, PMD_SIZE, 0);
-		i_mmap_lock_write(mapping);
+		i_mmap_lock_read(mapping);
 	}
 
 	/*
@@ -635,6 +613,7 @@ int __dax_pmd_fault(struct vm_area_struc
 		result = VM_FAULT_NOPAGE;
 		spin_unlock(ptl);
 	} else {
+		sector = bh.b_blocknr << (blkbits - 9);
 		length = bdev_direct_access(bh.b_bdev, sector, &kaddr, &pfn,
 						bh.b_size);
 		if (length < 0) {
@@ -644,6 +623,16 @@ int __dax_pmd_fault(struct vm_area_struc
 		if ((length < PMD_SIZE) || (pfn & PG_PMD_COLOUR))
 			goto fallback;
 
+		if (buffer_unwritten(&bh) || buffer_new(&bh)) {
+			int i;
+			for (i = 0; i < PTRS_PER_PMD; i++)
+				clear_pmem(kaddr + i * PAGE_SIZE, PAGE_SIZE);
+			wmb_pmem();
+			count_vm_event(PGMAJFAULT);
+			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
+			result |= VM_FAULT_MAJOR;
+		}
+
 		result |= vmf_insert_pfn_pmd(vma, address, pmd, pfn, write);
 	}
 
diff -puN mm/memory.c~revert-mm-take-i_mmap_lock-in-unmap_mapping_range-for-dax mm/memory.c
--- a/mm/memory.c~revert-mm-take-i_mmap_lock-in-unmap_mapping_range-for-dax
+++ a/mm/memory.c
@@ -2426,10 +2426,17 @@ void unmap_mapping_range(struct address_
 	if (details.last_index < details.first_index)
 		details.last_index = ULONG_MAX;
 
-	i_mmap_lock_write(mapping);
+
+	/*
+	 * DAX already holds i_mmap_lock to serialise file truncate vs
+	 * page fault and page fault vs page fault.
+	 */
+	if (!IS_DAX(mapping->host))
+		i_mmap_lock_write(mapping);
 	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap)))
 		unmap_mapping_range_tree(&mapping->i_mmap, &details);
-	i_mmap_unlock_write(mapping);
+	if (!IS_DAX(mapping->host))
+		i_mmap_unlock_write(mapping);
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

revert-dax-fix-race-between-simultaneous-faults.patch

