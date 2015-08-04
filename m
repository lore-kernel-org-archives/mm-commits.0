From: akpm@linux-foundation.org
Subject: + dax-fix-race-between-simultaneous-faults.patch added to -mm
 tree
Date: Tue, 04 Aug 2015 14:34:35 -0700
Message-ID: <55c12feb.1q/pjzeadytCK/CW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56630 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbbHDVef (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2015 17:34:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: fix race between simultaneous faults
has been added to the -mm tree.  Its filename is
     dax-fix-race-between-simultaneous-faults.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-fix-race-between-simultaneous-faults.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-fix-race-between-simultaneous-faults.patch

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
Subject: dax: fix race between simultaneous faults

If two threads write-fault on the same hole at the same time, the winner
of the race will return to userspace and complete their store, only to
have the loser overwrite their store with zeroes.  Fix this for now by
taking the i_mmap_sem for write instead of read, and do so outside the
call to get_block().  Now the loser of the race will see the block has
already been zeroed, and will not zero it again.

This severely limits our scalability.  I have ideas for improving it, but
those can wait for a later patch.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c    |   33 +++++++++++++++++----------------
 mm/memory.c |   11 ++++++++---
 2 files changed, 25 insertions(+), 19 deletions(-)

diff -puN fs/dax.c~dax-fix-race-between-simultaneous-faults fs/dax.c
--- a/fs/dax.c~dax-fix-race-between-simultaneous-faults
+++ a/fs/dax.c
@@ -272,7 +272,6 @@ static int copy_user_bh(struct page *to,
 static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 			struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	struct address_space *mapping = inode->i_mapping;
 	sector_t sector = bh->b_blocknr << (inode->i_blkbits - 9);
 	unsigned long vaddr = (unsigned long)vmf->virtual_address;
 	void *addr;
@@ -280,8 +279,6 @@ static int dax_insert_mapping(struct ino
 	pgoff_t size;
 	int error;
 
-	i_mmap_lock_read(mapping);
-
 	/*
 	 * Check truncate didn't happen while we were allocating a block.
 	 * If it did, this block may or may not be still allocated to the
@@ -309,8 +306,6 @@ static int dax_insert_mapping(struct ino
 	error = vm_insert_mixed(vma, vaddr, pfn);
 
  out:
-	i_mmap_unlock_read(mapping);
-
 	return error;
 }
 
@@ -372,15 +367,17 @@ int __dax_fault(struct vm_area_struct *v
 			 * from a read fault and we've raced with a truncate
 			 */
 			error = -EIO;
-			goto unlock_page;
+			goto unlock;
 		}
+	} else {
+		i_mmap_lock_write(mapping);
 	}
 
 	error = get_block(inode, block, &bh, 0);
 	if (!error && (bh.b_size < PAGE_SIZE))
 		error = -EIO;		/* fs corruption? */
 	if (error)
-		goto unlock_page;
+		goto unlock;
 
 	if (!buffer_mapped(&bh) && !buffer_unwritten(&bh) && !vmf->cow_page) {
 		if (vmf->flags & FAULT_FLAG_WRITE) {
@@ -391,8 +388,9 @@ int __dax_fault(struct vm_area_struct *v
 			if (!error && (bh.b_size < PAGE_SIZE))
 				error = -EIO;
 			if (error)
-				goto unlock_page;
+				goto unlock;
 		} else {
+			i_mmap_unlock_write(mapping);
 			return dax_load_hole(mapping, page, vmf);
 		}
 	}
@@ -404,17 +402,15 @@ int __dax_fault(struct vm_area_struct *v
 		else
 			clear_user_highpage(new_page, vaddr);
 		if (error)
-			goto unlock_page;
+			goto unlock;
 		vmf->page = page;
 		if (!page) {
-			i_mmap_lock_read(mapping);
 			/* Check we didn't race with truncate */
 			size = (i_size_read(inode) + PAGE_SIZE - 1) >>
 								PAGE_SHIFT;
 			if (vmf->pgoff >= size) {
-				i_mmap_unlock_read(mapping);
 				error = -EIO;
-				goto out;
+				goto unlock;
 			}
 		}
 		return VM_FAULT_LOCKED;
@@ -450,6 +446,8 @@ int __dax_fault(struct vm_area_struct *v
 			WARN_ON_ONCE(!(vmf->flags & FAULT_FLAG_WRITE));
 	}
 
+	if (!page)
+		i_mmap_unlock_write(mapping);
  out:
 	if (error == -ENOMEM)
 		return VM_FAULT_OOM | major;
@@ -458,11 +456,14 @@ int __dax_fault(struct vm_area_struct *v
 		return VM_FAULT_SIGBUS | major;
 	return VM_FAULT_NOPAGE | major;
 
- unlock_page:
+ unlock:
 	if (page) {
 		unlock_page(page);
 		page_cache_release(page);
+	} else {
+		i_mmap_unlock_write(mapping);
 	}
+
 	goto out;
 }
 EXPORT_SYMBOL(__dax_fault);
@@ -540,10 +541,10 @@ int __dax_pmd_fault(struct vm_area_struc
 	block = (sector_t)pgoff << (PAGE_SHIFT - blkbits);
 
 	bh.b_size = PMD_SIZE;
+	i_mmap_lock_write(mapping);
 	length = get_block(inode, block, &bh, write);
 	if (length)
 		return VM_FAULT_SIGBUS;
-	i_mmap_lock_read(mapping);
 
 	/*
 	 * If the filesystem isn't willing to tell us the length of a hole,
@@ -607,11 +608,11 @@ int __dax_pmd_fault(struct vm_area_struc
 	}
 
  out:
-	i_mmap_unlock_read(mapping);
-
 	if (buffer_unwritten(&bh))
 		complete_unwritten(&bh, !(result & VM_FAULT_ERROR));
 
+	i_mmap_unlock_write(mapping);
+
 	return result;
 
  fallback:
diff -puN mm/memory.c~dax-fix-race-between-simultaneous-faults mm/memory.c
--- a/mm/memory.c~dax-fix-race-between-simultaneous-faults
+++ a/mm/memory.c
@@ -2427,11 +2427,16 @@ void unmap_mapping_range(struct address_
 		details.last_index = ULONG_MAX;
 
 
-	/* DAX uses i_mmap_lock to serialise file truncate vs page fault */
-	i_mmap_lock_write(mapping);
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

Patches currently in -mm which might be from willy@linux.intel.com are

mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
dax-move-dax-related-functions-to-a-new-header.patch
dax-revert-userfaultfd-change.patch
thp-prepare-for-dax-huge-pages.patch
thp-prepare-for-dax-huge-pages-fix.patch
mm-add-a-pmd_fault-handler.patch
mm-export-various-functions-for-the-benefit-of-dax.patch
mm-add-vmf_insert_pfn_pmd.patch
dax-add-huge-page-fault-support.patch
ext2-huge-page-fault-support.patch
ext4-huge-page-fault-support.patch
xfs-huge-page-fault-support.patch
ext4-use-ext4_get_block_write-for-dax.patch
thp-change-insert_pfns-return-type-to-void.patch
dax-improve-comment-about-truncate-race.patch
ext4-add-ext4_get_block_dax.patch
ext4-start-transaction-before-calling-into-dax.patch
dax-fix-race-between-simultaneous-faults.patch
thp-decrement-refcount-on-huge-zero-page-if-it-is-split.patch
thp-fix-zap_huge_pmd-for-dax.patch
dax-dont-use-set_huge_zero_page.patch
dax-ensure-that-zero-pages-are-removed-from-other-processes.patch
dax-use-linear_page_index.patch

