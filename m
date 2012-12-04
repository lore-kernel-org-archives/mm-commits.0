From: akpm@linux-foundation.org
Subject: + hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix-fix.patch added to -mm tree
Date: Tue, 04 Dec 2012 13:41:56 -0800
Message-ID: <20121204214156.AB07982004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:45135 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab2LDVl6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2012 16:41:58 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so428439vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Dec 2012 13:41:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: slava@dubeyko.com, htl10@users.sourceforge.net


The patch titled
     Subject: hfsplus: make error message in hfsplus_system_write_inode() more compact and detailed
has been added to the -mm tree.  Its filename is
     hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes-checkpatch-fixes.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes-fix.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch
hfsplus-rework-processing-errors-in-hfsplus_free_extents.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix-fix.patch
hfsplus-add-error-message-for-the-case-of-failure-of-sync-fs-in-delayed_sync_fs-method.patch

