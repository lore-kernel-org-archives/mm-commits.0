From: akpm@linux-foundation.org
Subject: [patch 08/15] dax: prevent invalidation of mapped DAX
 entries
Date: Fri, 12 May 2017 15:46:47 -0700
Message-ID: <20170512224647.mgEZvQCeV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38712 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758228AbdELWqt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2017 18:46:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.j.williams@intel.com, jack@suse.cz, mm-commits@vger.kernel.org, ross.zwisler@linux.intel.com, stable@vger.kernel.org, torvalds@linux-foundation.org

From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: prevent invalidation of mapped DAX entries

Patch series "mm,dax: Fix data corruption due to mmap inconsistency", v4.

This series fixes data corruption that can happen for DAX mounts when page
faults race with write(2) and as a result page tables get out of sync with
block mappings in the filesystem and thus data seen through mmap is
different from data seen through read(2).

The series passes testing with t_mmap_stale test program from Ross and
also other mmap related tests on DAX filesystem.


This patch (of 4):

dax_invalidate_mapping_entry() currently removes DAX exceptional entries
only if they are clean and unlocked.  This is done via:

invalidate_mapping_pages()
  invalidate_exceptional_entry()
    dax_invalidate_mapping_entry()

However, for page cache pages removed in invalidate_mapping_pages() there
is an additional criteria which is that the page must not be mapped.  This
is noted in the comments above invalidate_mapping_pages() and is checked
in invalidate_inode_page().

For DAX entries this means that we can can end up in a situation where a
DAX exceptional entry, either a huge zero page or a regular DAX entry,
could end up mapped but without an associated radix tree entry.  This is
inconsistent with the rest of the DAX code and with what happens in the
page cache case.

We aren't able to unmap the DAX exceptional entry because according to its
comments invalidate_mapping_pages() isn't allowed to block, and
unmap_mapping_range() takes a write lock on the mapping->i_mmap_rwsem.

Since we essentially never have unmapped DAX entries to evict from the
radix tree, just remove dax_invalidate_mapping_entry().

Fixes: c6dcf52c23d2 ("mm: Invalidate DAX radix tree entries only if appropriate")
Link: http://lkml.kernel.org/r/20170510085419.27601-2-jack@suse.cz
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Jan Kara <jack@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@vger.kernel.org>    [4.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c            |   29 -----------------------------
 include/linux/dax.h |    1 -
 mm/truncate.c       |    9 +++------
 3 files changed, 3 insertions(+), 36 deletions(-)

diff -puN fs/dax.c~dax-prevent-invalidation-of-mapped-dax-entries fs/dax.c
--- a/fs/dax.c~dax-prevent-invalidation-of-mapped-dax-entries
+++ a/fs/dax.c
@@ -461,35 +461,6 @@ int dax_delete_mapping_entry(struct addr
 }
 
 /*
- * Invalidate exceptional DAX entry if easily possible. This handles DAX
- * entries for invalidate_inode_pages() so we evict the entry only if we can
- * do so without blocking.
- */
-int dax_invalidate_mapping_entry(struct address_space *mapping, pgoff_t index)
-{
-	int ret = 0;
-	void *entry, **slot;
-	struct radix_tree_root *page_tree = &mapping->page_tree;
-
-	spin_lock_irq(&mapping->tree_lock);
-	entry = __radix_tree_lookup(page_tree, index, NULL, &slot);
-	if (!entry || !radix_tree_exceptional_entry(entry) ||
-	    slot_locked(mapping, slot))
-		goto out;
-	if (radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_DIRTY) ||
-	    radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_TOWRITE))
-		goto out;
-	radix_tree_delete(page_tree, index);
-	mapping->nrexceptional--;
-	ret = 1;
-out:
-	spin_unlock_irq(&mapping->tree_lock);
-	if (ret)
-		dax_wake_mapping_entry_waiter(mapping, index, entry, true);
-	return ret;
-}
-
-/*
  * Invalidate exceptional DAX entry if it is clean.
  */
 int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
diff -puN include/linux/dax.h~dax-prevent-invalidation-of-mapped-dax-entries include/linux/dax.h
--- a/include/linux/dax.h~dax-prevent-invalidation-of-mapped-dax-entries
+++ a/include/linux/dax.h
@@ -63,7 +63,6 @@ ssize_t dax_iomap_rw(struct kiocb *iocb,
 int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
 		    const struct iomap_ops *ops);
 int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
-int dax_invalidate_mapping_entry(struct address_space *mapping, pgoff_t index);
 int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 				      pgoff_t index);
 void dax_wake_mapping_entry_waiter(struct address_space *mapping,
diff -puN mm/truncate.c~dax-prevent-invalidation-of-mapped-dax-entries mm/truncate.c
--- a/mm/truncate.c~dax-prevent-invalidation-of-mapped-dax-entries
+++ a/mm/truncate.c
@@ -67,17 +67,14 @@ static void truncate_exceptional_entry(s
 
 /*
  * Invalidate exceptional entry if easily possible. This handles exceptional
- * entries for invalidate_inode_pages() so for DAX it evicts only unlocked and
- * clean entries.
+ * entries for invalidate_inode_pages().
  */
 static int invalidate_exceptional_entry(struct address_space *mapping,
 					pgoff_t index, void *entry)
 {
-	/* Handled by shmem itself */
-	if (shmem_mapping(mapping))
+	/* Handled by shmem itself, or for DAX we do nothing. */
+	if (shmem_mapping(mapping) || dax_mapping(mapping))
 		return 1;
-	if (dax_mapping(mapping))
-		return dax_invalidate_mapping_entry(mapping, index);
 	clear_shadow_entry(mapping, index, entry);
 	return 1;
 }
_
