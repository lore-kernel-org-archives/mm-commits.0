From: akpm@linux-foundation.org
Subject: + mm-dax-fix-dax-deadlocks.patch added to -mm tree
Date: Thu, 08 Oct 2015 14:07:14 -0700
Message-ID: <5616db02.lr8l5NC0TnocBfJP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47141 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627AbbJHVHP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Oct 2015 17:07:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dan.j.williams@intel.com, david@fromorbit.com, jack@suse.com, kirill.shutemov@linux.intel.com, matthew.r.wilcox@intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, dax: fix DAX deadlocks
has been added to the -mm tree.  Its filename is
     mm-dax-fix-dax-deadlocks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dax-fix-dax-deadlocks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dax-fix-dax-deadlocks.patch

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
Subject: mm, dax: fix DAX deadlocks

The following two locking commits in the DAX code:

commit 843172978bb9 ("dax: fix race between simultaneous faults")
commit 46c043ede471 ("mm: take i_mmap_lock in unmap_mapping_range() for DAX")

introduced a number of deadlocks and other issues which need to be fixed
for the v4.3 kernel.  The list of issues in DAX after these commits (some
newly introduced by the commits, some preexisting) can be found here:

https://lkml.org/lkml/2015/9/25/602 (Subject: "Re: [PATCH] dax: fix
deadlock in __dax_fault").

This undoes most of the changes introduced by those two commits,
essentially returning us to the DAX locking scheme that was used in v4.2.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c    |   70 ++++++++++++++++++++------------------------------
 mm/memory.c |    2 +
 2 files changed, 31 insertions(+), 41 deletions(-)

diff -puN fs/dax.c~mm-dax-fix-dax-deadlocks fs/dax.c
--- a/fs/dax.c~mm-dax-fix-dax-deadlocks
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
@@ -569,36 +568,14 @@ int __dax_pmd_fault(struct vm_area_struc
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
@@ -635,6 +612,7 @@ int __dax_pmd_fault(struct vm_area_struc
 		result = VM_FAULT_NOPAGE;
 		spin_unlock(ptl);
 	} else {
+		sector = bh.b_blocknr << (blkbits - 9);
 		length = bdev_direct_access(bh.b_bdev, sector, &kaddr, &pfn,
 						bh.b_size);
 		if (length < 0) {
@@ -644,15 +622,25 @@ int __dax_pmd_fault(struct vm_area_struc
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
 
  out:
+	i_mmap_unlock_read(mapping);
+
 	if (buffer_unwritten(&bh))
 		complete_unwritten(&bh, !(result & VM_FAULT_ERROR));
 
-	i_mmap_unlock_write(mapping);
