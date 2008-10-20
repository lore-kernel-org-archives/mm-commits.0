From: akpm@linux-foundation.org
Subject: - ramfs-and-ram-disk-pages-are-unevictable.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:32:56 -0700
Message-ID: <200810202032.m9KKWuGW010517@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33569 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753453AbYJTUdo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:33:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Ramfs and Ram Disk pages are unevictable
has been removed from the -mm tree.  Its filename was
     ramfs-and-ram-disk-pages-are-unevictable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Ramfs and Ram Disk pages are unevictable
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Christoph Lameter pointed out that ram disk pages also clutter the LRU
lists.  When vmscan finds them dirty and tries to clean them, the ram disk
writeback function just redirties the page so that it goes back onto the
active list.  Round and round she goes...

With the ram disk driver [rd.c] replaced by the newer 'brd.c', this is no
longer the case, as ram disk pages are no longer maintained on the lru. 
[This makes them unmigratable for defrag or memory hot remove, but that
can be addressed by a separate patch series.] However, the ramfs pages
behave like ram disk pages used to, so:

Define new address_space flag [shares address_space flags member with
mapping's gfp mask] to indicate that the address space contains all
unevictable pages.  This will provide for efficient testing of ramfs pages
in page_evictable().

Also provide wrapper functions to set/test the unevictable state to
minimize #ifdefs in ramfs driver and any other users of this facility.

Set the unevictable state on address_space structures for new ramfs
inodes.  Test the unevictable state in page_evictable() to cull
unevictable pages.

These changes depend on [CONFIG_]UNEVICTABLE_LRU.

[riel@redhat.com: undo the brd.c part]
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Debugged-by: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/inode.c        |    1 +
 include/linux/pagemap.h |   22 ++++++++++++++++++++++
 mm/vmscan.c             |    5 +++++
 3 files changed, 28 insertions(+)

diff -puN fs/ramfs/inode.c~ramfs-and-ram-disk-pages-are-unevictable fs/ramfs/inode.c
--- a/fs/ramfs/inode.c~ramfs-and-ram-disk-pages-are-unevictable
+++ a/fs/ramfs/inode.c
@@ -61,6 +61,7 @@ struct inode *ramfs_get_inode(struct sup
 		inode->i_mapping->a_ops = &ramfs_aops;
 		inode->i_mapping->backing_dev_info = &ramfs_backing_dev_info;
 		mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
+		mapping_set_unevictable(inode->i_mapping);
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		switch (mode & S_IFMT) {
 		default:
diff -puN include/linux/pagemap.h~ramfs-and-ram-disk-pages-are-unevictable include/linux/pagemap.h
--- a/include/linux/pagemap.h~ramfs-and-ram-disk-pages-are-unevictable
+++ a/include/linux/pagemap.h
@@ -32,6 +32,28 @@ static inline void mapping_set_error(str
 	}
 }
 
+#ifdef CONFIG_UNEVICTABLE_LRU
+#define AS_UNEVICTABLE	(__GFP_BITS_SHIFT + 2)	/* e.g., ramdisk, SHM_LOCK */
+
+static inline void mapping_set_unevictable(struct address_space *mapping)
+{
+	set_bit(AS_UNEVICTABLE, &mapping->flags);
+}
+
+static inline int mapping_unevictable(struct address_space *mapping)
+{
+	if (mapping && (mapping->flags & AS_UNEVICTABLE))
+		return 1;
+	return 0;
+}
+#else
+static inline void mapping_set_unevictable(struct address_space *mapping) { }
+static inline int mapping_unevictable(struct address_space *mapping)
+{
+	return 0;
+}
+#endif
+
 static inline gfp_t mapping_gfp_mask(struct address_space * mapping)
 {
 	return (__force gfp_t)mapping->flags & __GFP_BITS_MASK;
diff -puN mm/vmscan.c~ramfs-and-ram-disk-pages-are-unevictable mm/vmscan.c
--- a/mm/vmscan.c~ramfs-and-ram-disk-pages-are-unevictable
+++ a/mm/vmscan.c
@@ -2332,11 +2332,16 @@ int zone_reclaim(struct zone *zone, gfp_
  * lists vs unevictable list.
  *
  * Reasons page might not be evictable:
+ * (1) page's mapping marked unevictable
+ *
  * TODO - later patches
  */
 int page_evictable(struct page *page, struct vm_area_struct *vma)
 {
 
+	if (mapping_unevictable(page_mapping(page)))
+		return 0;
+
 	/* TODO:  test page [!]evictable conditions */
 
 	return 1;
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

origin.patch

