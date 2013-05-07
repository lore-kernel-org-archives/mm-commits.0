From: akpm@linux-foundation.org
Subject: [merged] hfsplus-add-error-propagation-to-__hfsplus_ext_write_extent.patch removed from -mm tree
Date: Tue, 07 May 2013 10:48:54 -0700
Message-ID: <20130507174854.843DF5A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:33385 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103Ab3EGRsz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:48:55 -0400
Received: by mail-qc0-f201.google.com with SMTP id c10so85382qcz.0
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:48:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khoroshilov@ispras.ru, artem.bityutskiy@linux.intel.com, hch@lst.de, htl10@users.sourceforge.net, slava@dubeyko.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: add error propagation to __hfsplus_ext_write_extent()
has been removed from the -mm tree.  Its filename was
     hfsplus-add-error-propagation-to-__hfsplus_ext_write_extent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: hfsplus: add error propagation to __hfsplus_ext_write_extent()

__hfsplus_ext_write_extent() suppresses errors coming from
hfs_brec_find().  The patch implements error code propagation.

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Reviewed-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/extents.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff -puN fs/hfsplus/extents.c~hfsplus-add-error-propagation-to-__hfsplus_ext_write_extent fs/hfsplus/extents.c
--- a/fs/hfsplus/extents.c~hfsplus-add-error-propagation-to-__hfsplus_ext_write_extent
+++ a/fs/hfsplus/extents.c
@@ -83,7 +83,7 @@ static u32 hfsplus_ext_lastblock(struct
 	return be32_to_cpu(ext->start_block) + be32_to_cpu(ext->block_count);
 }
 
-static void __hfsplus_ext_write_extent(struct inode *inode,
+static int __hfsplus_ext_write_extent(struct inode *inode,
 		struct hfs_find_data *fd)
 {
 	struct hfsplus_inode_info *hip = HFSPLUS_I(inode);
@@ -98,13 +98,13 @@ static void __hfsplus_ext_write_extent(s
 	res = hfs_brec_find(fd, hfs_find_rec_by_key);
 	if (hip->extent_state & HFSPLUS_EXT_NEW) {
 		if (res != -ENOENT)
-			return;
+			return res;
 		hfs_brec_insert(fd, hip->cached_extents,
 				sizeof(hfsplus_extent_rec));
 		hip->extent_state &= ~(HFSPLUS_EXT_DIRTY | HFSPLUS_EXT_NEW);
 	} else {
 		if (res)
-			return;
+			return res;
 		hfs_bnode_write(fd->bnode, hip->cached_extents,
 				fd->entryoffset, fd->entrylength);
 		hip->extent_state &= ~HFSPLUS_EXT_DIRTY;
@@ -117,11 +117,13 @@ static void __hfsplus_ext_write_extent(s
 	 * to explicily mark the inode dirty, too.
 	 */
 	set_bit(HFSPLUS_I_EXT_DIRTY, &hip->flags);
+
+	return 0;
 }
 
 static int hfsplus_ext_write_extent_locked(struct inode *inode)
 {
-	int res;
+	int res = 0;
 
 	if (HFSPLUS_I(inode)->extent_state & HFSPLUS_EXT_DIRTY) {
 		struct hfs_find_data fd;
@@ -129,10 +131,10 @@ static int hfsplus_ext_write_extent_lock
 		res = hfs_find_init(HFSPLUS_SB(inode->i_sb)->ext_tree, &fd);
 		if (res)
 			return res;
-		__hfsplus_ext_write_extent(inode, &fd);
+		res = __hfsplus_ext_write_extent(inode, &fd);
 		hfs_find_exit(&fd);
 	}
-	return 0;
+	return res;
 }
 
 int hfsplus_ext_write_extent(struct inode *inode)
@@ -175,8 +177,11 @@ static inline int __hfsplus_ext_cache_ex
 
 	WARN_ON(!mutex_is_locked(&hip->extents_lock));
 
-	if (hip->extent_state & HFSPLUS_EXT_DIRTY)
-		__hfsplus_ext_write_extent(inode, fd);
+	if (hip->extent_state & HFSPLUS_EXT_DIRTY) {
+		res = __hfsplus_ext_write_extent(inode, fd);
+		if (res)
+			return res;
+	}
 
 	res = __hfsplus_ext_read_extent(fd, hip->cached_extents, inode->i_ino,
 					block, HFSPLUS_IS_RSRC(inode) ?
_

Patches currently in -mm which might be from khoroshilov@ispras.ru are

origin.patch
linux-next.patch

