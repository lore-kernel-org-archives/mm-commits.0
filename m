From: akpm@linux-foundation.org
Subject: - vmscan-ramfs-and-ram-disk-pages-are-non-reclaimable.patch removed from -mm tree
Date: Wed, 11 Jun 2008 12:46:26 -0700
Message-ID: <200806111946.m5BJkQhr014584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751440AbYFKTqy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 15:46:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, lee.schermerhorn@hp.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: ramfs and ram disk pages are non-reclaimable
has been removed from the -mm tree.  Its filename was
     vmscan-ramfs-and-ram-disk-pages-are-non-reclaimable.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: ramfs and ram disk pages are non-reclaimable
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Christoph Lameter pointed out that ram disk pages also clutter the LRU
lists.  When vmscan finds them dirty and tries to clean them, the ram disk
writeback function just redirties the page so that it goes back onto the
active list.  Round and round she goes...

Define new address_space flag [shares address_space flags member with
mapping's gfp mask] to indicate that the address space contains all
non-reclaimable pages.  This will provide for efficient testing of ramdisk
pages in page_reclaimable().

Also provide wrapper functions to set/test the noreclaim state to minimize
#ifdefs in ramdisk driver and any other users of this facility.

Set the noreclaim state on address_space structures for new ramdisk
inodes.  Test the noreclaim state in page_reclaimable() to cull
non-reclaimable pages.

Similarly, ramfs pages are non-reclaimable.  Set the 'noreclaim'
address_space flag for new ramfs inodes.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/brd.c     |   13 +++++++++++++
 fs/ramfs/inode.c        |    1 +
 include/linux/pagemap.h |   22 ++++++++++++++++++++++
 mm/vmscan.c             |    5 +++++
 4 files changed, 41 insertions(+)

diff -puN drivers/block/brd.c~vmscan-ramfs-and-ram-disk-pages-are-non-reclaimable drivers/block/brd.c
--- a/drivers/block/brd.c~vmscan-ramfs-and-ram-disk-pages-are-non-reclaimable
+++ a/drivers/block/brd.c
@@ -374,8 +374,21 @@ static int brd_ioctl(struct inode *inode
 	return error;
 }
 
+/*
+ * brd_open():
+ * Just mark the mapping as containing non-reclaimable pages
+ */
+static int brd_open(struct inode *inode, struct file *filp)
+{
+	struct address_space *mapping = inode->i_mapping;
+
+	mapping_set_noreclaim(mapping);
+	return 0;
+}
+
 static struct block_device_operations brd_fops = {
 	.owner =		THIS_MODULE,
+	.open  =		brd_open,
 	.ioctl =		brd_ioctl,
 #ifdef CONFIG_BLK_DEV_XIP
 	.direct_access =	brd_direct_access,
diff -puN fs/ramfs/inode.c~vmscan-ramfs-and-ram-disk-pages-are-non-reclaimable fs/ramfs/inode.c
--- a/fs/ramfs/inode.c~vmscan-ramfs-and-ram-disk-pages-are-non-reclaimable
+++ a/fs/ramfs/inode.c
@@ -61,6 +61,7 @@ struct inode *ramfs_get_inode(struct sup
 		inode->i_mapping->a_ops = &ramfs_aops;
 		inode->i_mapping->backing_dev_info = &ramfs_backing_dev_info;
 		mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
+		mapping_set_noreclaim(inode->i_mapping);
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		switch (mode & S_IFMT) {
 		default:
diff -puN include/linux/pagemap.h~vmscan-ramfs-and-ram-disk-pages-are-non-reclaimable include/linux/pagemap.h
--- a/include/linux/pagemap.h~vmscan-ramfs-and-ram-disk-pages-are-non-reclaimable
+++ a/include/linux/pagemap.h
@@ -31,6 +31,28 @@ static inline void mapping_set_error(str
 	}
 }
 
+#ifdef CONFIG_NORECLAIM_LRU
+#define AS_NORECLAIM	(__GFP_BITS_SHIFT + 2)	/* e.g., ramdisk, SHM_LOCK */
+
+static inline void mapping_set_noreclaim(struct address_space *mapping)
+{
+	set_bit(AS_NORECLAIM, &mapping->flags);
+}
+
+static inline int mapping_non_reclaimable(struct address_space *mapping)
+{
+	if (mapping && (mapping->flags & AS_NORECLAIM))
+		return 1;
+	return 0;
+}
+#else
+static inline void mapping_set_noreclaim(struct address_space *mapping) { }
+static inline int mapping_non_reclaimable(struct address_space *mapping)
+{
+	return 0;
+}
+#endif
+
 static inline gfp_t mapping_gfp_mask(struct address_space * mapping)
 {
 	return (__force gfp_t)mapping->flags & __GFP_BITS_MASK;
diff -puN mm/vmscan.c~vmscan-ramfs-and-ram-disk-pages-are-non-reclaimable mm/vmscan.c
--- a/mm/vmscan.c~vmscan-ramfs-and-ram-disk-pages-are-non-reclaimable
+++ a/mm/vmscan.c
@@ -2341,6 +2341,8 @@ int zone_reclaim(struct zone *zone, gfp_
  * lists vs noreclaim list.
  *
  * Reasons page might not be reclaimable:
+ * (1) page's mapping marked non-reclaimable
+ *
  * TODO - later patches
  */
 int page_reclaimable(struct page *page, struct vm_area_struct *vma)
@@ -2348,6 +2350,9 @@ int page_reclaimable(struct page *page, 
 
 	VM_BUG_ON(PageNoreclaim(page));
 
+	if (mapping_non_reclaimable(page_mapping(page)))
+		return 0;
+
 	/* TODO:  test page [!]reclaimable conditions */
 
 	return 1;
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

vmscan-ramfs-and-ram-disk-pages-are-non-reclaimable.patch
vmscan-shm_locked-pages-are-non-reclaimable.patch

