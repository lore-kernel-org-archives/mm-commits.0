From: akpm@linux-foundation.org
Subject: [folded-dropped] hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes-fix.patch removed from -mm tree
Date: Tue, 18 Dec 2012 14:42:45 -0800
Message-ID: <20121218224246.06A1520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:44165 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab2LRWms (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 17:42:48 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so68693eaa.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 14:42:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: slava@dubeyko.com, fengguang.wu@intel.com, hch@lst.de, htl10@users.sourceforge.net, jack@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes-fix
has been removed from the -mm tree.  Its filename was
     hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes-fix.patch

This patch was dropped because it was folded into hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes-fix

Fix warning in [next:akpm 357/436] fs/hfsplus/xattr.c:363:23: sparse: cast to restricted __be32.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/xattr.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/hfsplus/xattr.c~hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes-fix fs/hfsplus/xattr.c
--- a/fs/hfsplus/xattr.c~hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes-fix
+++ a/fs/hfsplus/xattr.c
@@ -310,6 +310,7 @@ ssize_t hfsplus_getxattr(struct dentry *
 	struct inode *inode = dentry->d_inode;
 	struct hfs_find_data fd;
 	hfsplus_attr_entry *entry;
+	__be32 xattr_record_type;
 	u32 record_type;
 	u16 record_length = 0;
 	ssize_t res = 0;
@@ -358,9 +359,9 @@ ssize_t hfsplus_getxattr(struct dentry *
 		goto out;
 	}
 
-	hfs_bnode_read(fd.bnode, &record_type,
-			fd.entryoffset, sizeof(record_type));
-	record_type = be32_to_cpu(record_type);
+	hfs_bnode_read(fd.bnode, &xattr_record_type,
+			fd.entryoffset, sizeof(xattr_record_type));
+	record_type = be32_to_cpu(xattr_record_type);
 	if (record_type == HFSPLUS_ATTR_INLINE_DATA) {
 		record_length = hfs_bnode_read_u16(fd.bnode,
 				fd.entryoffset +
_

Patches currently in -mm which might be from slava@dubeyko.com are

hfsplus-avoid-crash-on-failed-block-map-free.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch
hfsplus-rework-processing-errors-in-hfsplus_free_extents.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix-fix.patch
hfsplus-add-error-message-for-the-case-of-failure-of-sync-fs-in-delayed_sync_fs-method.patch

