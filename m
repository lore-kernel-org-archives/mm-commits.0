From: akpm@linux-foundation.org
Subject: [to-be-updated]
 revert-dax-fix-race-between-simultaneous-faults.patch removed from -mm tree
Date: Wed, 07 Oct 2015 14:35:56 -0700
Message-ID: <5615903c.tjQWCgH6Vk4Q/SPo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbbJGVf5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Oct 2015 17:35:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dan.j.williams@intel.com, david@fromorbit.com, jack@suse.com, kirill.shutemov@linux.intel.com, viro@zeniv.linux.org.uk, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "dax: fix race between simultaneous faults"
has been removed from the -mm tree.  Its filename was
     revert-dax-fix-race-between-simultaneous-faults.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Revert "dax: fix race between simultaneous faults"

This reverts 843172978bb92 ("dax: fix race between simultaneous faults").

The following two locking commits in the DAX code:

commit 843172978bb9 ("dax: fix race between simultaneous faults")
commit 46c043ede471 ("mm: take i_mmap_lock in unmap_mapping_range() for DAX")

introduced a number of deadlocks and other issues, and need to be reverted
for the v4.3 kernel.  The list of issues in DAX after these commits (some
newly introduced by the commits, some preexisting) can be found here:

https://lkml.org/lkml/2015/9/25/602 (Subject: "Re: [PATCH] dax: fix
deadlock in __dax_fault").

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c    |   33 ++++++++++++++++-----------------
 mm/memory.c |   11 +++--------
 2 files changed, 19 insertions(+), 25 deletions(-)

diff -puN fs/dax.c~revert-dax-fix-race-between-simultaneous-faults fs/dax.c
--- a/fs/dax.c~revert-dax-fix-race-between-simultaneous-faults
+++ a/fs/dax.c
@@ -285,6 +285,7 @@ static int copy_user_bh(struct page *to,
 static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 			struct vm_area_struct *vma, struct vm_fault *vmf)
 {
+	struct address_space *mapping = inode->i_mapping;
 	sector_t sector = bh->b_blocknr << (inode->i_blkbits - 9);
 	unsigned long vaddr = (unsigned long)vmf->virtual_address;
 	void __pmem *addr;
@@ -292,6 +293,8 @@ static int dax_insert_mapping(struct ino
 	pgoff_t size;
 	int error;
 
+	i_mmap_lock_read(mapping);
+
 	/*
 	 * Check truncate didn't happen while we were allocating a block.
 	 * If it did, this block may or may not be still allocated to the
@@ -321,6 +324,8 @@ static int dax_insert_mapping(struct ino
 	error = vm_insert_mixed(vma, vaddr, pfn);
 
  out:
+	i_mmap_unlock_read(mapping);
+
 	return error;
 }
 
@@ -382,17 +387,15 @@ int __dax_fault(struct vm_area_struct *v
 			 * from a read fault and we've raced with a truncate
 			 */
 			error = -EIO;
-			goto unlock;
+			goto unlock_page;
 		}
-	} else {
-		i_mmap_lock_write(mapping);
 	}
 
 	error = get_block(inode, block, &bh, 0);
 	if (!error && (bh.b_size < PAGE_SIZE))
 		error = -EIO;		/* fs corruption? */
 	if (error)
-		goto unlock;
+		goto unlock_page;
 
 	if (!buffer_mapped(&bh) && !buffer_unwritten(&bh) && !vmf->cow_page) {
 		if (vmf->flags & FAULT_FLAG_WRITE) {
@@ -403,9 +406,8 @@ int __dax_fault(struct vm_area_struct *v
 			if (!error && (bh.b_size < PAGE_SIZE))
 				error = -EIO;
 			if (error)
-				goto unlock;
+				goto unlock_page;
 		} else {
-			i_mmap_unlock_write(mapping);
 			return dax_load_hole(mapping, page, vmf);
 		}
 	}
@@ -417,15 +419,17 @@ int __dax_fault(struct vm_area_struct *v
 		else
 			clear_user_highpage(new_page, vaddr);
 		if (error)
-			goto unlock;
+			goto unlock_page;
 		vmf->page = page;
 		if (!page) {
+			i_mmap_lock_read(mapping);
 			/* Check we didn't race with truncate */
 			size = (i_size_read(inode) + PAGE_SIZE - 1) >>
 								PAGE_SHIFT;
 			if (vmf->pgoff >= size) {
+				i_mmap_unlock_read(mapping);
 				error = -EIO;
-				goto unlock;
+				goto out;
 			}
 		}
 		return VM_FAULT_LOCKED;
@@ -461,8 +465,6 @@ int __dax_fault(struct vm_area_struct *v
 			WARN_ON_ONCE(!(vmf->flags & FAULT_FLAG_WRITE));
 	}
 
-	if (!page)
-		i_mmap_unlock_write(mapping);
  out:
 	if (error == -ENOMEM)
 		return VM_FAULT_OOM | major;
@@ -471,14 +473,11 @@ int __dax_fault(struct vm_area_struct *v
 		return VM_FAULT_SIGBUS | major;
 	return VM_FAULT_NOPAGE | major;
 
- unlock:
+ unlock_page:
 	if (page) {
 		unlock_page(page);
 		page_cache_release(page);
-	} else {
-		i_mmap_unlock_write(mapping);
 	}
-
 	goto out;
 }
 EXPORT_SYMBOL(__dax_fault);
@@ -556,10 +555,10 @@ int __dax_pmd_fault(struct vm_area_struc
 	block = (sector_t)pgoff << (PAGE_SHIFT - blkbits);
 
 	bh.b_size = PMD_SIZE;
-	i_mmap_lock_write(mapping);
 	length = get_block(inode, block, &bh, write);
 	if (length)
 		return VM_FAULT_SIGBUS;
+	i_mmap_lock_read(mapping);
 
 	/*
 	 * If the filesystem isn't willing to tell us the length of a hole,
@@ -634,11 +633,11 @@ int __dax_pmd_fault(struct vm_area_struc
 	}
 
  out:
+	i_mmap_unlock_read(mapping);
+
 	if (buffer_unwritten(&bh))
 		complete_unwritten(&bh, !(result & VM_FAULT_ERROR));
 
-	i_mmap_unlock_write(mapping);
-
 	return result;
 
  fallback:
diff -puN mm/memory.c~revert-dax-fix-race-between-simultaneous-faults mm/memory.c
--- a/mm/memory.c~revert-dax-fix-race-between-simultaneous-faults
+++ a/mm/memory.c
@@ -2427,16 +2427,11 @@ void unmap_mapping_range(struct address_
 		details.last_index = ULONG_MAX;
 
 
-	/*
-	 * DAX already holds i_mmap_lock to serialise file truncate vs
-	 * page fault and page fault vs page fault.
-	 */
-	if (!IS_DAX(mapping->host))
-		i_mmap_lock_write(mapping);
+	/* DAX uses i_mmap_lock to serialise file truncate vs page fault */
+	i_mmap_lock_write(mapping);
 	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap)))
 		unmap_mapping_range_tree(&mapping->i_mmap, &details);
-	if (!IS_DAX(mapping->host))
-		i_mmap_unlock_write(mapping);
+	i_mmap_unlock_write(mapping);
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

dax-temporarily-disable-dax-pmd-fault-path.patch

