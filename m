From: akpm@linux-foundation.org
Subject: [merged] fs-char_devc-remove-unused-cdev_index.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:08:47 -0800
Message-ID: <201101132011.p0DKBSMZ030177@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933769Ab1AMUVA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:21:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namhyung@gmail.com, stefanr@s5r6.in-berlin.de, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     fs/char_dev.c: remove unused cdev_index()
has been removed from the -mm tree.  Its filename was
     fs-char_devc-remove-unused-cdev_index.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/char_dev.c: remove unused cdev_index()
From: Namhyung Kim <namhyung@gmail.com>

Commit 66fa12c571d3 ("ieee1394: remove the old IEEE 1394 driver stack")
eliminated the only user of cdev_index().  So it can be removed too.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/char_dev.c        |   13 -------------
 include/linux/cdev.h |    2 --
 2 files changed, 15 deletions(-)

diff -puN fs/char_dev.c~fs-char_devc-remove-unused-cdev_index fs/char_dev.c
--- a/fs/char_dev.c~fs-char_devc-remove-unused-cdev_index
+++ a/fs/char_dev.c
@@ -417,18 +417,6 @@ static int chrdev_open(struct inode *ino
 	return ret;
 }
 
-int cdev_index(struct inode *inode)
-{
-	int idx;
-	struct kobject *kobj;
-
-	kobj = kobj_lookup(cdev_map, inode->i_rdev, &idx);
-	if (!kobj)
-		return -1;
-	kobject_put(kobj);
-	return idx;
-}
-
 void cd_forget(struct inode *inode)
 {
 	spin_lock(&cdev_lock);
@@ -582,7 +570,6 @@ EXPORT_SYMBOL(cdev_init);
 EXPORT_SYMBOL(cdev_alloc);
 EXPORT_SYMBOL(cdev_del);
 EXPORT_SYMBOL(cdev_add);
-EXPORT_SYMBOL(cdev_index);
 EXPORT_SYMBOL(__register_chrdev);
 EXPORT_SYMBOL(__unregister_chrdev);
 EXPORT_SYMBOL(directly_mappable_cdev_bdi);
diff -puN include/linux/cdev.h~fs-char_devc-remove-unused-cdev_index include/linux/cdev.h
--- a/include/linux/cdev.h~fs-char_devc-remove-unused-cdev_index
+++ a/include/linux/cdev.h
@@ -28,8 +28,6 @@ int cdev_add(struct cdev *, dev_t, unsig
 
 void cdev_del(struct cdev *);
 
-int cdev_index(struct inode *inode);
