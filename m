From: akpm@linux-foundation.org
Subject: [merged] mm-remove-__invalidate_mapping_pages-variant.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:36:03 -0700
Message-ID: <200906171836.n5HIa3EQ002081@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760266AbZFQShD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:37:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mikew@google.com, david@fromorbit.com, fengguang.wu@intel.com, jack@suse.cz, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm: remove __invalidate_mapping_pages variant
has been removed from the -mm tree.  Its filename was
     mm-remove-__invalidate_mapping_pages-variant.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove __invalidate_mapping_pages variant
From: Mike Waychison <mikew@google.com>

Remove __invalidate_mapping_pages atomic variant now that its sole caller
can sleep (fixed in eccb95cee4f0d56faa46ef22fb94dd4a3578d3eb ("vfs: fix
lock inversion in drop_pagecache_sb()")).

This fixes softlockups that can occur while in the drop_caches path.

Signed-off-by: Mike Waychison <mikew@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/drop_caches.c   |    2 +-
 include/linux/fs.h |    3 ---
 mm/truncate.c      |   39 ++++++++++++++++-----------------------
 3 files changed, 17 insertions(+), 27 deletions(-)

diff -puN fs/drop_caches.c~mm-remove-__invalidate_mapping_pages-variant fs/drop_caches.c
--- a/fs/drop_caches.c~mm-remove-__invalidate_mapping_pages-variant
+++ a/fs/drop_caches.c
@@ -24,7 +24,7 @@ static void drop_pagecache_sb(struct sup
 			continue;
 		__iget(inode);
 		spin_unlock(&inode_lock);
-		__invalidate_mapping_pages(inode->i_mapping, 0, -1, true);
+		invalidate_mapping_pages(inode->i_mapping, 0, -1);
 		iput(toput_inode);
 		toput_inode = inode;
 		spin_lock(&inode_lock);
diff -puN include/linux/fs.h~mm-remove-__invalidate_mapping_pages-variant include/linux/fs.h
--- a/include/linux/fs.h~mm-remove-__invalidate_mapping_pages-variant
+++ a/include/linux/fs.h
@@ -2036,9 +2036,6 @@ extern int __invalidate_device(struct bl
 extern int invalidate_partition(struct gendisk *, int);
 #endif
 extern int invalidate_inodes(struct super_block *);
-unsigned long __invalidate_mapping_pages(struct address_space *mapping,
-					pgoff_t start, pgoff_t end,
-					bool be_atomic);
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
 					pgoff_t start, pgoff_t end);
 
diff -puN mm/truncate.c~mm-remove-__invalidate_mapping_pages-variant mm/truncate.c
--- a/mm/truncate.c~mm-remove-__invalidate_mapping_pages-variant
+++ a/mm/truncate.c
@@ -267,8 +267,21 @@ void truncate_inode_pages(struct address
 }
 EXPORT_SYMBOL(truncate_inode_pages);
 
-unsigned long __invalidate_mapping_pages(struct address_space *mapping,
-				pgoff_t start, pgoff_t end, bool be_atomic)
+/**
+ * invalidate_mapping_pages - Invalidate all the unlocked pages of one inode
+ * @mapping: the address_space which holds the pages to invalidate
+ * @start: the offset 'from' which to invalidate
+ * @end: the offset 'to' which to invalidate (inclusive)
+ *
+ * This function only removes the unlocked pages, if you want to
+ * remove all the pages of one inode, you must call truncate_inode_pages.
+ *
+ * invalidate_mapping_pages() will not block on IO activity. It will not
+ * invalidate pages which are dirty, locked, under writeback or mapped into
+ * pagetables.
+ */
+unsigned long invalidate_mapping_pages(struct address_space *mapping,
+				       pgoff_t start, pgoff_t end)
 {
 	struct pagevec pvec;
 	pgoff_t next = start;
@@ -309,30 +322,10 @@ unlock:
 				break;
 		}
 		pagevec_release(&pvec);
-		if (likely(!be_atomic))
-			cond_resched();
+		cond_resched();
 	}
 	return ret;
 }
-
-/**
- * invalidate_mapping_pages - Invalidate all the unlocked pages of one inode
- * @mapping: the address_space which holds the pages to invalidate
- * @start: the offset 'from' which to invalidate
- * @end: the offset 'to' which to invalidate (inclusive)
- *
- * This function only removes the unlocked pages, if you want to
- * remove all the pages of one inode, you must call truncate_inode_pages.
- *
- * invalidate_mapping_pages() will not block on IO activity. It will not
- * invalidate pages which are dirty, locked, under writeback or mapped into
- * pagetables.
- */
-unsigned long invalidate_mapping_pages(struct address_space *mapping,
-				pgoff_t start, pgoff_t end)
-{
-	return __invalidate_mapping_pages(mapping, start, end, false);
-}
 EXPORT_SYMBOL(invalidate_mapping_pages);
 
 /*
_

Patches currently in -mm which might be from mikew@google.com are

origin.patch

