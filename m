From: akpm@linux-foundation.org
Subject: [merged] mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback.patch removed from -mm tree
Date: Tue, 28 Jun 2011 13:42:39 -0700
Message-ID: <201106282042.p5SKgLHt002999@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750713Ab1F1UmZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jun 2011 16:42:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, jinshan.xiong@whamcloud.com, mszeredi@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm: fix assertion mapping->nrpages == 0 in end_writeback()
has been removed from the -mm tree.  Its filename was
     mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix assertion mapping->nrpages == 0 in end_writeback()
From: Jan Kara <jack@suse.cz>

Under heavy memory and filesystem load, users observe the assertion
mapping->nrpages == 0 in end_writeback() trigger.  This can be caused by
page reclaim reclaiming the last page from a mapping in the following
race:

	CPU0				CPU1
  ...
  shrink_page_list()
    __remove_mapping()
      __delete_from_page_cache()
        radix_tree_delete()
					evict_inode()
					  truncate_inode_pages()
					    truncate_inode_pages_range()
					      pagevec_lookup() - finds nothing
					  end_writeback()
					    mapping->nrpages != 0 -> BUG
        page->mapping = NULL
        mapping->nrpages--

Fix the problem by doing a reliable check of mapping->nrpages under
mapping->tree_lock in end_writeback().

Analyzed by Jay <jinshan.xiong@whamcloud.com>, lost in LKML, and dug
out by Miklos Szeredi <mszeredi@suse.de>.

Cc: Jay <jinshan.xiong@whamcloud.com>
Cc: Miklos Szeredi <mszeredi@suse.de>
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c         |    7 +++++++
 include/linux/fs.h |    1 +
 mm/truncate.c      |    5 +++++
 3 files changed, 13 insertions(+)

diff -puN fs/inode.c~mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback fs/inode.c
--- a/fs/inode.c~mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback
+++ a/fs/inode.c
@@ -423,7 +423,14 @@ EXPORT_SYMBOL(remove_inode_hash);
 void end_writeback(struct inode *inode)
 {
 	might_sleep();
+	/*
+	 * We have to cycle tree_lock here because reclaim can be still in the
+	 * process of removing the last page (in __delete_from_page_cache())
+	 * and we must not free mapping under it.
+	 */
+	spin_lock_irq(&inode->i_data.tree_lock);
 	BUG_ON(inode->i_data.nrpages);
+	spin_unlock_irq(&inode->i_data.tree_lock);
 	BUG_ON(!list_empty(&inode->i_data.private_list));
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(inode->i_state & I_CLEAR);
diff -puN include/linux/fs.h~mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback include/linux/fs.h
--- a/include/linux/fs.h~mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback
+++ a/include/linux/fs.h
@@ -639,6 +639,7 @@ struct address_space {
 	struct prio_tree_root	i_mmap;		/* tree of private and shared mappings */
 	struct list_head	i_mmap_nonlinear;/*list VM_NONLINEAR mappings */
 	struct mutex		i_mmap_mutex;	/* protect tree, count, list */
+	/* Protected by tree_lock together with the radix tree */
 	unsigned long		nrpages;	/* number of total pages */
 	pgoff_t			writeback_index;/* writeback starts here */
 	const struct address_space_operations *a_ops;	/* methods */
diff -puN mm/truncate.c~mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback mm/truncate.c
--- a/mm/truncate.c~mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback
+++ a/mm/truncate.c
@@ -304,6 +304,11 @@ EXPORT_SYMBOL(truncate_inode_pages_range
  * @lstart: offset from which to truncate
  *
  * Called under (and serialised by) inode->i_mutex.
+ *
+ * Note: When this function returns, there can be a page in the process of
+ * deletion (inside __delete_from_page_cache()) in the specified range.  Thus
+ * mapping->nrpages can be non-zero when this function returns even after
+ * truncation of the whole mapping.
  */
 void truncate_inode_pages(struct address_space *mapping, loff_t lstart)
 {
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch

