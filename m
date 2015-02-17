From: akpm@linux-foundation.org
Subject: [merged] mm-allow-page-fault-handlers-to-perform-the-cow.patch
 removed from -mm tree
Date: Tue, 17 Feb 2015 12:05:21 -0800
Message-ID: <54e39f01.loVkbvNT6PKn8RRy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbbBQUFW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 15:05:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew.r.wilcox@intel.com, andreas.dilger@intel.com, axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mathieu.desnoyers@efficios.com, rdunlap@infradead.org, ross.zwisler@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: allow page fault handlers to perform the COW
has been removed from the -mm tree.  Its filename was
     mm-allow-page-fault-handlers-to-perform-the-cow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: mm: allow page fault handlers to perform the COW

Currently COW of an XIP file is done by first bringing in a read-only
mapping, then retrying the fault and copying the page.  It is much more
efficient to tell the fault handler that a COW is being attempted (by
passing in the pre-allocated page in the vm_fault structure), and allow
the handler to perform the COW operation itself.

The handler cannot insert the page itself if there is already a read-only
mapping at that address, so allow the handler to return VM_FAULT_LOCKED
and set the fault_page to be NULL.  This indicates to the MM code that the
i_mmap_lock is held instead of the page lock.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 mm/memory.c        |   41 ++++++++++++++++++++++++++++++++---------
 2 files changed, 33 insertions(+), 9 deletions(-)

diff -puN include/linux/mm.h~mm-allow-page-fault-handlers-to-perform-the-cow include/linux/mm.h
--- a/include/linux/mm.h~mm-allow-page-fault-handlers-to-perform-the-cow
+++ a/include/linux/mm.h
@@ -224,6 +224,7 @@ struct vm_fault {
 	pgoff_t pgoff;			/* Logical page offset based on vma */
 	void __user *virtual_address;	/* Faulting virtual address */
 
+	struct page *cow_page;		/* Handler may choose to COW */
 	struct page *page;		/* ->fault handlers should return a
 					 * page here, unless VM_FAULT_NOPAGE
 					 * is set (which is also implied by
diff -puN mm/memory.c~mm-allow-page-fault-handlers-to-perform-the-cow mm/memory.c
--- a/mm/memory.c~mm-allow-page-fault-handlers-to-perform-the-cow
+++ a/mm/memory.c
@@ -1965,6 +1965,7 @@ static int do_page_mkwrite(struct vm_are
 	vmf.pgoff = page->index;
 	vmf.flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
 	vmf.page = page;
+	vmf.cow_page = NULL;
 
 	ret = vma->vm_ops->page_mkwrite(vma, &vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
@@ -2639,7 +2640,8 @@ oom:
  * See filemap_fault() and __lock_page_retry().
  */
 static int __do_fault(struct vm_area_struct *vma, unsigned long address,
-		pgoff_t pgoff, unsigned int flags, struct page **page)
+			pgoff_t pgoff, unsigned int flags,
+			struct page *cow_page, struct page **page)
 {
 	struct vm_fault vmf;
 	int ret;
@@ -2648,10 +2650,13 @@ static int __do_fault(struct vm_area_str
 	vmf.pgoff = pgoff;
 	vmf.flags = flags;
 	vmf.page = NULL;
+	vmf.cow_page = cow_page;
 
 	ret = vma->vm_ops->fault(vma, &vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
+	if (!vmf.page)
+		goto out;
 
 	if (unlikely(PageHWPoison(vmf.page))) {
 		if (ret & VM_FAULT_LOCKED)
@@ -2665,6 +2670,7 @@ static int __do_fault(struct vm_area_str
 	else
 		VM_BUG_ON_PAGE(!PageLocked(vmf.page), vmf.page);
 
+ out:
 	*page = vmf.page;
 	return ret;
 }
@@ -2835,7 +2841,7 @@ static int do_read_fault(struct mm_struc
 		pte_unmap_unlock(pte, ptl);
 	}
 
-	ret = __do_fault(vma, address, pgoff, flags, &fault_page);
+	ret = __do_fault(vma, address, pgoff, flags, NULL, &fault_page);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
 
@@ -2875,26 +2881,43 @@ static int do_cow_fault(struct mm_struct
 		return VM_FAULT_OOM;
 	}
 
-	ret = __do_fault(vma, address, pgoff, flags, &fault_page);
+	ret = __do_fault(vma, address, pgoff, flags, new_page, &fault_page);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		goto uncharge_out;
 
-	copy_user_highpage(new_page, fault_page, address, vma);
+	if (fault_page)
+		copy_user_highpage(new_page, fault_page, address, vma);
 	__SetPageUptodate(new_page);
 
 	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
 	if (unlikely(!pte_same(*pte, orig_pte))) {
 		pte_unmap_unlock(pte, ptl);
-		unlock_page(fault_page);
-		page_cache_release(fault_page);
+		if (fault_page) {
+			unlock_page(fault_page);
+			page_cache_release(fault_page);
+		} else {
+			/*
+			 * The fault handler has no page to lock, so it holds
+			 * i_mmap_lock for read to protect against truncate.
+			 */
+			i_mmap_unlock_read(vma->vm_file->f_mapping);
+		}
 		goto uncharge_out;
 	}
 	do_set_pte(vma, address, new_page, pte, true, true);
 	mem_cgroup_commit_charge(new_page, memcg, false);
 	lru_cache_add_active_or_unevictable(new_page, vma);
 	pte_unmap_unlock(pte, ptl);
-	unlock_page(fault_page);
-	page_cache_release(fault_page);
+	if (fault_page) {
+		unlock_page(fault_page);
+		page_cache_release(fault_page);
+	} else {
+		/*
+		 * The fault handler has no page to lock, so it holds
+		 * i_mmap_lock for read to protect against truncate.
+		 */
+		i_mmap_unlock_read(vma->vm_file->f_mapping);
+	}
 	return ret;
 uncharge_out:
 	mem_cgroup_cancel_charge(new_page, memcg);
@@ -2913,7 +2936,7 @@ static int do_shared_fault(struct mm_str
 	int dirtied = 0;
 	int ret, tmp;
 
-	ret = __do_fault(vma, address, pgoff, flags, &fault_page);
+	ret = __do_fault(vma, address, pgoff, flags, NULL, &fault_page);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
 
_

Patches currently in -mm which might be from matthew.r.wilcox@intel.com are

origin.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

