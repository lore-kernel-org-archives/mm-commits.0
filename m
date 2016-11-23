From: akpm@linux-foundation.org
Subject: + dax-make-cache-flushing-protected-by-entry-lock.patch added to
 -mm tree
Date: Tue, 22 Nov 2016 16:15:36 -0800
Message-ID: <5834dfa8.iJVlWPF1P2VCT0bH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36636 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751245AbcKWAPg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2016 19:15:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: make cache flushing protected by entry lock
has been added to the -mm tree.  Its filename is
     dax-make-cache-flushing-protected-by-entry-lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-make-cache-flushing-protected-by-entry-lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-make-cache-flushing-protected-by-entry-lock.patch

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
Subject: dax: make cache flushing protected by entry lock

Currently, flushing of caches for DAX mappings was ignoring entry lock. 
So far this was ok (modulo a bug that a difference in entry lock could
cause cache flushing to be mistakenly skipped) but in the following
patches we will write-protect PTEs on cache flushing and clear dirty tags.
For that we will need more exclusion.  So do cache flushing under an
entry lock.  This allows us to remove one lock-unlock pair of
mapping->tree_lock as a bonus.

Link: http://lkml.kernel.org/r/1479460644-25076-19-git-send-email-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   61 +++++++++++++++++++++++++++++++++--------------------
 1 file changed, 39 insertions(+), 22 deletions(-)

diff -puN fs/dax.c~dax-make-cache-flushing-protected-by-entry-lock fs/dax.c
--- a/fs/dax.c~dax-make-cache-flushing-protected-by-entry-lock
+++ a/fs/dax.c
@@ -619,32 +619,50 @@ static int dax_writeback_one(struct bloc
 		struct address_space *mapping, pgoff_t index, void *entry)
 {
 	struct radix_tree_root *page_tree = &mapping->page_tree;
-	struct radix_tree_node *node;
 	struct blk_dax_ctl dax;
-	void **slot;
+	void *entry2, **slot;
 	int ret = 0;
 
-	spin_lock_irq(&mapping->tree_lock);
 	/*
-	 * Regular page slots are stabilized by the page lock even
-	 * without the tree itself locked.  These unlocked entries
-	 * need verification under the tree lock.
+	 * A page got tagged dirty in DAX mapping? Something is seriously
+	 * wrong.
 	 */
-	if (!__radix_tree_lookup(page_tree, index, &node, &slot))
-		goto unlock;
-	if (*slot != entry)
-		goto unlock;
-
-	/* another fsync thread may have already written back this entry */
-	if (!radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_TOWRITE))
-		goto unlock;
+	if (WARN_ON(!radix_tree_exceptional_entry(entry)))
+		return -EIO;
 
+	spin_lock_irq(&mapping->tree_lock);
+	entry2 = get_unlocked_mapping_entry(mapping, index, &slot);
+	/* Entry got punched out / reallocated? */
+	if (!entry2 || !radix_tree_exceptional_entry(entry2))
+		goto put_unlocked;
+	/*
+	 * Entry got reallocated elsewhere? No need to writeback. We have to
+	 * compare sectors as we must not bail out due to difference in lockbit
+	 * or entry type.
+	 */
+	if (dax_radix_sector(entry2) != dax_radix_sector(entry))
+		goto put_unlocked;
 	if (WARN_ON_ONCE(dax_is_empty_entry(entry) ||
 				dax_is_zero_entry(entry))) {
 		ret = -EIO;
-		goto unlock;
+		goto put_unlocked;
 	}
 
+	/* Another fsync thread may have already written back this entry */
+	if (!radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_TOWRITE))
+		goto put_unlocked;
+	/* Lock the entry to serialize with page faults */
+	entry = lock_slot(mapping, slot);
+	/*
+	 * We can clear the tag now but we have to be careful so that concurrent
+	 * dax_writeback_one() calls for the same index cannot finish before we
+	 * actually flush the caches. This is achieved as the calls will look
+	 * at the entry only under tree_lock and once they do that they will
+	 * see the entry locked and wait for it to unlock.
+	 */
+	radix_tree_tag_clear(page_tree, index, PAGECACHE_TAG_TOWRITE);
+	spin_unlock_irq(&mapping->tree_lock);
+
 	/*
 	 * Even if dax_writeback_mapping_range() was given a wbc->range_start
 	 * in the middle of a PMD, the 'index' we are given will be aligned to
@@ -654,15 +672,16 @@ static int dax_writeback_one(struct bloc
 	 */
 	dax.sector = dax_radix_sector(entry);
 	dax.size = PAGE_SIZE << dax_radix_order(entry);
-	spin_unlock_irq(&mapping->tree_lock);
 
 	/*
 	 * We cannot hold tree_lock while calling dax_map_atomic() because it
 	 * eventually calls cond_resched().
 	 */
 	ret = dax_map_atomic(bdev, &dax);
-	if (ret < 0)
+	if (ret < 0) {
+		put_locked_mapping_entry(mapping, index, entry);
 		return ret;
+	}
 
 	if (WARN_ON_ONCE(ret < dax.size)) {
 		ret = -EIO;
@@ -670,15 +689,13 @@ static int dax_writeback_one(struct bloc
 	}
 
 	wb_cache_pmem(dax.addr, dax.size);
-
-	spin_lock_irq(&mapping->tree_lock);
-	radix_tree_tag_clear(page_tree, index, PAGECACHE_TAG_TOWRITE);
-	spin_unlock_irq(&mapping->tree_lock);
  unmap:
 	dax_unmap_atomic(bdev, &dax);
+	put_locked_mapping_entry(mapping, index, entry);
 	return ret;
 
- unlock:
+ put_unlocked:
+	put_unlocked_mapping_entry(mapping, index, entry2);
 	spin_unlock_irq(&mapping->tree_lock);
 	return ret;
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

