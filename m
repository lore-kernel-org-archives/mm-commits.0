From: akpm@linux-foundation.org
Subject: [patch 078/114] dax: protect PTE modification on WP fault by
 radix tree entry lock
Date: Wed, 14 Dec 2016 15:07:50 -0800
Message-ID: <5851d0c6.0IMd1z4YdfZxHEvV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35190 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933666AbcLNXHw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:07:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jack@suse.cz, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com

From: Jan Kara <jack@suse.cz>
Subject: dax: protect PTE modification on WP fault by radix tree entry lock

Currently PTE gets updated in wp_pfn_shared() after dax_pfn_mkwrite() has
released corresponding radix tree entry lock.  When we want to
writeprotect PTE on cache flush, we need PTE modification to happen under
radix tree entry lock to ensure consistent updates of PTE and radix tree
(standard faults use page lock to ensure this consistency).  So move
update of PTE bit into dax_pfn_mkwrite().

Link: http://lkml.kernel.org/r/1479460644-25076-20-git-send-email-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c    |   22 ++++++++++++++++------
 mm/memory.c |    2 +-
 2 files changed, 17 insertions(+), 7 deletions(-)

diff -puN fs/dax.c~dax-protect-pte-modification-on-wp-fault-by-radix-tree-entry-lock fs/dax.c
--- a/fs/dax.c~dax-protect-pte-modification-on-wp-fault-by-radix-tree-entry-lock
+++ a/fs/dax.c
@@ -783,17 +783,27 @@ int dax_pfn_mkwrite(struct vm_area_struc
 {
 	struct file *file = vma->vm_file;
 	struct address_space *mapping = file->f_mapping;
-	void *entry;
+	void *entry, **slot;
 	pgoff_t index = vmf->pgoff;
 
 	spin_lock_irq(&mapping->tree_lock);
-	entry = get_unlocked_mapping_entry(mapping, index, NULL);
-	if (!entry || !radix_tree_exceptional_entry(entry))
-		goto out;
+	entry = get_unlocked_mapping_entry(mapping, index, &slot);
+	if (!entry || !radix_tree_exceptional_entry(entry)) {
+		if (entry)
+			put_unlocked_mapping_entry(mapping, index, entry);
+		spin_unlock_irq(&mapping->tree_lock);
+		return VM_FAULT_NOPAGE;
+	}
 	radix_tree_tag_set(&mapping->page_tree, index, PAGECACHE_TAG_DIRTY);
-	put_unlocked_mapping_entry(mapping, index, entry);
-out:
+	entry = lock_slot(mapping, slot);
 	spin_unlock_irq(&mapping->tree_lock);
+	/*
+	 * If we race with somebody updating the PTE and finish_mkwrite_fault()
+	 * fails, we don't care. We need to return VM_FAULT_NOPAGE and retry
+	 * the fault in either case.
+	 */
+	finish_mkwrite_fault(vmf);
+	put_locked_mapping_entry(mapping, index, entry);
 	return VM_FAULT_NOPAGE;
 }
 EXPORT_SYMBOL_GPL(dax_pfn_mkwrite);
diff -puN mm/memory.c~dax-protect-pte-modification-on-wp-fault-by-radix-tree-entry-lock mm/memory.c
--- a/mm/memory.c~dax-protect-pte-modification-on-wp-fault-by-radix-tree-entry-lock
+++ a/mm/memory.c
@@ -2315,7 +2315,7 @@ static int wp_pfn_shared(struct vm_fault
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 		vmf->flags |= FAULT_FLAG_MKWRITE;
 		ret = vma->vm_ops->pfn_mkwrite(vma, vmf);
-		if (ret & VM_FAULT_ERROR)
+		if (ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE))
 			return ret;
 		return finish_mkwrite_fault(vmf);
 	}
_
