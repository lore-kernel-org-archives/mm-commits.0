From: akpm@linux-foundation.org
Subject: [folded-merged] hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix-fix.patch removed from -mm tree
Date: Tue, 18 Dec 2012 14:43:12 -0800
Message-ID: <20121218224313.52440200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f73.google.com ([74.125.82.73]:55598 "EHLO
	mail-wg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab2LRWnP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 17:43:15 -0500
Received: by mail-wg0-f73.google.com with SMTP id dt12so68526wgb.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 14:43:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: slava@dubeyko.com, htl10@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: make error message in hfsplus_system_write_inode() more compact and detailed
has been removed from the -mm tree.  Its filename was
     hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix-fix.patch

This patch was dropped because it was folded into hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: make error message in hfsplus_system_write_inode() more compact and detailed

Join printk and dprint in one printk error message in the case of b-tree
write error in hfsplus_system_write_inode() method.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/super.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/hfsplus/super.c~hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix-fix fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix-fix
+++ a/fs/hfsplus/super.c
@@ -132,10 +132,8 @@ static int hfsplus_system_write_inode(st
 	if (tree) {
 		int err = hfs_btree_write(tree);
 		if (err) {
-			printk(KERN_ERR "hfs: unable to write b-tree: %d\n",
-				err);
-			dprint(DBG_INODE, "hfsplus_system_write_inode: %lu\n",
-				inode->i_ino);
+			printk(KERN_ERR "hfs: b-tree write err: %d, ino %lu\n",
+					err, inode->i_ino);
 			return err;
 		}
 	}
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
hfsplus-add-error-message-for-the-case-of-failure-of-sync-fs-in-delayed_sync_fs-method.patch

