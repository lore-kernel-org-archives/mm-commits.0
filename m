From: akpm@linux-foundation.org
Subject: [merged] dax-make-cache-flushing-protected-by-entry-lock.patch
 removed from -mm tree
Date: Thu, 15 Dec 2016 10:47:55 -0800
Message-ID: <5852e55b.v4uo8OLu5o224KS7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49074 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932673AbcLOSr4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:47:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: make cache flushing protected by entry lock
has been removed from the -mm tree.  Its filename was
     dax-make-cache-flushing-protected-by-entry-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -618,32 +618,50 @@ static int dax_writeback_one(struct bloc
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
@@ -653,15 +671,16 @@ static int dax_writeback_one(struct bloc
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
@@ -669,15 +688,13 @@ static int dax_writeback_one(struct bloc
 	}
 
 	wb_cache_pmem(dax.addr, dax.size);
