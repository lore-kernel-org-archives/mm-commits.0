From: akpm@linux-foundation.org
Subject: + dax-clear-dirty-entry-tags-on-cache-flush.patch added to -mm
 tree
Date: Tue, 22 Nov 2016 16:15:40 -0800
Message-ID: <5834dfac.2PJML1339NxkwgBi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36654 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755763AbcKWAPk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2016 19:15:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: clear dirty entry tags on cache flush
has been added to the -mm tree.  Its filename is
     dax-clear-dirty-entry-tags-on-cache-flush.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-clear-dirty-entry-tags-on-cache-flush.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-clear-dirty-entry-tags-on-cache-flush.patch

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
Subject: dax: clear dirty entry tags on cache flush

Currently we never clear dirty tags in DAX mappings and thus address
ranges to flush accumulate.  Now that we have locking of radix tree
entries, we have all the locking necessary to reliably clear the radix
tree dirty tag when flushing caches for corresponding address range. 
Similarly to page_mkclean() we also have to write-protect pages to get a
page fault when the page is next written to so that we can mark the entry
dirty again.

Link: http://lkml.kernel.org/r/1479460644-25076-21-git-send-email-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   64 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff -puN fs/dax.c~dax-clear-dirty-entry-tags-on-cache-flush fs/dax.c
--- a/fs/dax.c~dax-clear-dirty-entry-tags-on-cache-flush
+++ a/fs/dax.c
@@ -31,6 +31,7 @@
 #include <linux/vmstat.h>
 #include <linux/pfn_t.h>
 #include <linux/sizes.h>
+#include <linux/mmu_notifier.h>
 #include <linux/iomap.h>
 #include "internal.h"
 
@@ -615,6 +616,59 @@ static void *dax_insert_mapping_entry(st
 	return new_entry;
 }
 
+static inline unsigned long
+pgoff_address(pgoff_t pgoff, struct vm_area_struct *vma)
+{
+	unsigned long address;
+
+	address = vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
+	VM_BUG_ON_VMA(address < vma->vm_start || address >= vma->vm_end, vma);
+	return address;
+}
+
+/* Walk all mappings of a given index of a file and writeprotect them */
+static void dax_mapping_entry_mkclean(struct address_space *mapping,
+				      pgoff_t index, unsigned long pfn)
+{
+	struct vm_area_struct *vma;
+	pte_t *ptep;
+	pte_t pte;
+	spinlock_t *ptl;
+	bool changed;
+
+	i_mmap_lock_read(mapping);
+	vma_interval_tree_foreach(vma, &mapping->i_mmap, index, index) {
+		unsigned long address;
+
+		cond_resched();
+
+		if (!(vma->vm_flags & VM_SHARED))
+			continue;
+
+		address = pgoff_address(index, vma);
+		changed = false;
+		if (follow_pte(vma->vm_mm, address, &ptep, &ptl))
+			continue;
+		if (pfn != pte_pfn(*ptep))
+			goto unlock;
+		if (!pte_dirty(*ptep) && !pte_write(*ptep))
+			goto unlock;
+
+		flush_cache_page(vma, address, pfn);
+		pte = ptep_clear_flush(vma, address, ptep);
+		pte = pte_wrprotect(pte);
+		pte = pte_mkclean(pte);
+		set_pte_at(vma->vm_mm, address, ptep, pte);
+		changed = true;
+unlock:
+		pte_unmap_unlock(ptep, ptl);
+
+		if (changed)
+			mmu_notifier_invalidate_page(vma->vm_mm, address);
+	}
+	i_mmap_unlock_read(mapping);
+}
+
 static int dax_writeback_one(struct block_device *bdev,
 		struct address_space *mapping, pgoff_t index, void *entry)
 {
@@ -688,7 +742,17 @@ static int dax_writeback_one(struct bloc
 		goto unmap;
 	}
 
+	dax_mapping_entry_mkclean(mapping, index, pfn_t_to_pfn(dax.pfn));
 	wb_cache_pmem(dax.addr, dax.size);
+	/*
+	 * After we have flushed the cache, we can clear the dirty tag. There
+	 * cannot be new dirty data in the pfn after the flush has completed as
+	 * the pfn mappings are writeprotected and fault waits for mapping
+	 * entry lock.
+	 */
+	spin_lock_irq(&mapping->tree_lock);
+	radix_tree_tag_clear(page_tree, index, PAGECACHE_TAG_DIRTY);
+	spin_unlock_irq(&mapping->tree_lock);
  unmap:
 	dax_unmap_atomic(bdev, &dax);
 	put_locked_mapping_entry(mapping, index, entry);
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

