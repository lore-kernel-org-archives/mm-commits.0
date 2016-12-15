From: akpm@linux-foundation.org
Subject: [merged] dax-clear-dirty-entry-tags-on-cache-flush.patch removed
 from -mm tree
Date: Thu, 15 Dec 2016 10:48:00 -0800
Message-ID: <5852e560.KLeYZDAAHtGloMHQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49086 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754898AbcLOSsB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:48:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: clear dirty entry tags on cache flush
has been removed from the -mm tree.  Its filename was
     dax-clear-dirty-entry-tags-on-cache-flush.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 
@@ -614,6 +615,59 @@ static void *dax_insert_mapping_entry(st
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
@@ -687,7 +741,17 @@ static int dax_writeback_one(struct bloc
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


