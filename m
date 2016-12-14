From: akpm@linux-foundation.org
Subject: [patch 069/114] mm: move handling of COW faults into DAX code
Date: Wed, 14 Dec 2016 15:07:24 -0800
Message-ID: <5851d0ac.CHQNv+y5tzfe8gcZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35090 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933477AbcLNXH2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:07:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jack@suse.cz, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com

From: Jan Kara <jack@suse.cz>
Subject: mm: move handling of COW faults into DAX code

Move final handling of COW faults from generic code into DAX fault
handler.  That way generic code doesn't have to be aware of peculiarities
of DAX locking so remove that knowledge and make locking functions private
to fs/dax.c.

Link: http://lkml.kernel.org/r/1479460644-25076-11-git-send-email-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c            |   61 +++++++++++++++++++-----------------------
 include/linux/dax.h |    7 ----
 include/linux/mm.h  |    9 ------
 mm/memory.c         |   13 ++------
 4 files changed, 34 insertions(+), 56 deletions(-)

diff -puN fs/dax.c~mm-move-handling-of-cow-faults-into-dax-code fs/dax.c
--- a/fs/dax.c~mm-move-handling-of-cow-faults-into-dax-code
+++ a/fs/dax.c
@@ -240,6 +240,23 @@ static void *get_unlocked_mapping_entry(
 	}
 }
 
+static void dax_unlock_mapping_entry(struct address_space *mapping,
+				     pgoff_t index)
+{
+	void *entry, **slot;
+
+	spin_lock_irq(&mapping->tree_lock);
+	entry = __radix_tree_lookup(&mapping->page_tree, index, NULL, &slot);
+	if (WARN_ON_ONCE(!entry || !radix_tree_exceptional_entry(entry) ||
+			 !slot_locked(mapping, slot))) {
+		spin_unlock_irq(&mapping->tree_lock);
+		return;
+	}
+	unlock_slot(mapping, slot);
+	spin_unlock_irq(&mapping->tree_lock);
+	dax_wake_mapping_entry_waiter(mapping, index, entry, false);
+}
+
 static void put_locked_mapping_entry(struct address_space *mapping,
 				     pgoff_t index, void *entry)
 {
@@ -433,22 +450,6 @@ void dax_wake_mapping_entry_waiter(struc
 		__wake_up(wq, TASK_NORMAL, wake_all ? 0 : 1, &key);
 }
 
-void dax_unlock_mapping_entry(struct address_space *mapping, pgoff_t index)
-{
-	void *entry, **slot;
-
-	spin_lock_irq(&mapping->tree_lock);
-	entry = __radix_tree_lookup(&mapping->page_tree, index, NULL, &slot);
-	if (WARN_ON_ONCE(!entry || !radix_tree_exceptional_entry(entry) ||
-			 !slot_locked(mapping, slot))) {
-		spin_unlock_irq(&mapping->tree_lock);
-		return;
-	}
-	unlock_slot(mapping, slot);
-	spin_unlock_irq(&mapping->tree_lock);
-	dax_wake_mapping_entry_waiter(mapping, index, entry, false);
-}
-
 /*
  * Delete exceptional DAX entry at @index from @mapping. Wait for radix tree
  * entry to get unlocked before deleting it.
@@ -500,10 +501,8 @@ static int dax_load_hole(struct address_
 	/* This will replace locked radix tree entry with a hole page */
 	page = find_or_create_page(mapping, vmf->pgoff,
 				   vmf->gfp_mask | __GFP_ZERO);
-	if (!page) {
-		put_locked_mapping_entry(mapping, vmf->pgoff, entry);
+	if (!page)
 		return VM_FAULT_OOM;
-	}
 	vmf->page = page;
 	return VM_FAULT_LOCKED;
 }
@@ -954,7 +953,7 @@ int dax_iomap_fault(struct vm_area_struc
 	struct iomap iomap = { 0 };
 	unsigned flags = IOMAP_FAULT;
 	int error, major = 0;
-	int locked_status = 0;
+	int vmf_ret = 0;
 	void *entry;
 
 	/*
@@ -1007,13 +1006,11 @@ int dax_iomap_fault(struct vm_area_struc
 
 		if (error)
 			goto finish_iomap;
-		if (!radix_tree_exceptional_entry(entry)) {
-			vmf->page = entry;
-			locked_status = VM_FAULT_LOCKED;
-		} else {
-			vmf->entry = entry;
-			locked_status = VM_FAULT_DAX_LOCKED;
-		}
+
+		__SetPageUptodate(vmf->cow_page);
+		vmf_ret = finish_fault(vmf);
+		if (!vmf_ret)
+			vmf_ret = VM_FAULT_DONE_COW;
 		goto finish_iomap;
 	}
 
@@ -1030,7 +1027,7 @@ int dax_iomap_fault(struct vm_area_struc
 	case IOMAP_UNWRITTEN:
 	case IOMAP_HOLE:
 		if (!(vmf->flags & FAULT_FLAG_WRITE)) {
-			locked_status = dax_load_hole(mapping, entry, vmf);
+			vmf_ret = dax_load_hole(mapping, entry, vmf);
 			break;
 		}
 		/*FALLTHRU*/
@@ -1042,7 +1039,7 @@ int dax_iomap_fault(struct vm_area_struc
 
  finish_iomap:
 	if (ops->iomap_end) {
-		if (error) {
+		if (error || (vmf_ret & VM_FAULT_ERROR)) {
 			/* keep previous error */
 			ops->iomap_end(inode, pos, PAGE_SIZE, 0, flags,
 					&iomap);
@@ -1052,7 +1049,7 @@ int dax_iomap_fault(struct vm_area_struc
 		}
 	}
  unlock_entry:
-	if (!locked_status || error)
+	if (vmf_ret != VM_FAULT_LOCKED || error)
 		put_locked_mapping_entry(mapping, vmf->pgoff, entry);
  out:
 	if (error == -ENOMEM)
@@ -1060,9 +1057,9 @@ int dax_iomap_fault(struct vm_area_struc
 	/* -EBUSY is fine, somebody else faulted on the same PTE */
 	if (error < 0 && error != -EBUSY)
 		return VM_FAULT_SIGBUS | major;
-	if (locked_status) {
+	if (vmf_ret) {
 		WARN_ON_ONCE(error); /* -EBUSY from ops->iomap_end? */
-		return locked_status;
+		return vmf_ret;
 	}
 	return VM_FAULT_NOPAGE | major;
 }
diff -puN include/linux/dax.h~mm-move-handling-of-cow-faults-into-dax-code include/linux/dax.h
--- a/include/linux/dax.h~mm-move-handling-of-cow-faults-into-dax-code
+++ a/include/linux/dax.h
@@ -46,7 +46,6 @@ void dax_wake_mapping_entry_waiter(struc
 
 #ifdef CONFIG_FS_DAX
 struct page *read_dax_sector(struct block_device *bdev, sector_t n);
-void dax_unlock_mapping_entry(struct address_space *mapping, pgoff_t index);
 int __dax_zero_page_range(struct block_device *bdev, sector_t sector,
 		unsigned int offset, unsigned int length);
 #else
@@ -55,12 +54,6 @@ static inline struct page *read_dax_sect
 {
 	return ERR_PTR(-ENXIO);
 }
-/* Shouldn't ever be called when dax is disabled. */
-static inline void dax_unlock_mapping_entry(struct address_space *mapping,
-					    pgoff_t index)
-{
-	BUG();
-}
 static inline int __dax_zero_page_range(struct block_device *bdev,
 		sector_t sector, unsigned int offset, unsigned int length)
 {
diff -puN include/linux/mm.h~mm-move-handling-of-cow-faults-into-dax-code include/linux/mm.h
--- a/include/linux/mm.h~mm-move-handling-of-cow-faults-into-dax-code
+++ a/include/linux/mm.h
@@ -308,12 +308,6 @@ struct vm_fault {
 					 * is set (which is also implied by
 					 * VM_FAULT_ERROR).
 					 */
-	void *entry;			/* ->fault handler can alternatively
-					 * return locked DAX entry. In that
-					 * case handler should return
-					 * VM_FAULT_DAX_LOCKED and fill in
-					 * entry here.
-					 */
 	/* These three entries are valid only while holding ptl lock */
 	pte_t *pte;			/* Pointer to pte entry matching
 					 * the 'address'. NULL if the page
@@ -1104,8 +1098,7 @@ static inline void clear_page_pfmemalloc
 #define VM_FAULT_LOCKED	0x0200	/* ->fault locked the returned page */
 #define VM_FAULT_RETRY	0x0400	/* ->fault blocked, must retry */
 #define VM_FAULT_FALLBACK 0x0800	/* huge page fault failed, fall back to small */
-#define VM_FAULT_DAX_LOCKED 0x1000	/* ->fault has locked DAX entry */
-#define VM_FAULT_DONE_COW   0x2000	/* ->fault has fully handled COW */
+#define VM_FAULT_DONE_COW   0x1000	/* ->fault has fully handled COW */
 
 #define VM_FAULT_HWPOISON_LARGE_MASK 0xf000 /* encodes hpage index for large hwpoison */
 
diff -puN mm/memory.c~mm-move-handling-of-cow-faults-into-dax-code mm/memory.c
--- a/mm/memory.c~mm-move-handling-of-cow-faults-into-dax-code
+++ a/mm/memory.c
@@ -2845,7 +2845,7 @@ static int __do_fault(struct vm_fault *v
 
 	ret = vma->vm_ops->fault(vma, vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY |
-			    VM_FAULT_DAX_LOCKED | VM_FAULT_DONE_COW)))
+			    VM_FAULT_DONE_COW)))
 		return ret;
 
 	if (unlikely(PageHWPoison(vmf->page))) {
@@ -3276,17 +3276,12 @@ static int do_cow_fault(struct vm_fault
 	if (ret & VM_FAULT_DONE_COW)
 		return ret;
 
-	if (!(ret & VM_FAULT_DAX_LOCKED))
-		copy_user_highpage(vmf->cow_page, vmf->page, vmf->address, vma);
+	copy_user_highpage(vmf->cow_page, vmf->page, vmf->address, vma);
 	__SetPageUptodate(vmf->cow_page);
 
 	ret |= finish_fault(vmf);
-	if (!(ret & VM_FAULT_DAX_LOCKED)) {
-		unlock_page(vmf->page);
-		put_page(vmf->page);
-	} else {
-		dax_unlock_mapping_entry(vma->vm_file->f_mapping, vmf->pgoff);
-	}
+	unlock_page(vmf->page);
+	put_page(vmf->page);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		goto uncharge_out;
 	return ret;
_
