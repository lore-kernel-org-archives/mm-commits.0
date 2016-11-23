From: akpm@linux-foundation.org
Subject: +
 dax-protect-pte-modification-on-wp-fault-by-radix-tree-entry-lock.patch
 added to -mm tree
Date: Tue, 22 Nov 2016 16:15:38 -0800
Message-ID: <5834dfaa.3UxxpBEEB50fihoP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36646 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751245AbcKWAPi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2016 19:15:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: protect PTE modification on WP fault by radix tree entry lock
has been added to the -mm tree.  Its filename is
     dax-protect-pte-modification-on-wp-fault-by-radix-tree-entry-lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-protect-pte-modification-on-wp-fault-by-radix-tree-entry-lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-protect-pte-modification-on-wp-fault-by-radix-tree-entry-lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -784,17 +784,27 @@ int dax_pfn_mkwrite(struct vm_area_struc
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

Patches currently in -mm which might be from jack@suse.cz are

mm-join-struct-fault_env-and-vm_fault.patch
mm-use-vmf-address-instead-of-of-vmf-virtual_address.patch
mm-use-pgoff-in-struct-vm_fault-instead-of-passing-it-separately.patch
mm-use-passed-vm_fault-structure-in-__do_fault.patch
mm-trim-__do_fault-arguments.patch
mm-use-passed-vm_fault-structure-for-in-wp_pfn_shared.patch
mm-add-orig_pte-field-into-vm_fault.patch
mm-allow-full-handling-of-cow-faults-in-fault-handlers.patch
mm-factor-out-functionality-to-finish-page-faults.patch
mm-move-handling-of-cow-faults-into-dax-code.patch
mm-factor-out-common-parts-of-write-fault-handling.patch
mm-pass-vm_fault-structure-into-do_page_mkwrite.patch
mm-use-vmf-page-during-wp-faults.patch
mm-move-part-of-wp_page_reuse-into-the-single-call-site.patch
mm-provide-helper-for-finishing-mkwrite-faults.patch
mm-change-return-values-of-finish_mkwrite_fault.patch
mm-export-follow_pte.patch
dax-make-cache-flushing-protected-by-entry-lock.patch
dax-protect-pte-modification-on-wp-fault-by-radix-tree-entry-lock.patch
dax-clear-dirty-entry-tags-on-cache-flush.patch

