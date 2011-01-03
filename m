From: akpm@linux-foundation.org
Subject: + fs-char_devc-remove-unused-cdev_index.patch added to -mm tree
Date: Mon, 03 Jan 2011 13:33:04 -0800
Message-ID: <201101032133.p03LX4ip029701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754560Ab1ACVdS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jan 2011 16:33:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, stefanr@s5r6.in-berlin.de, tytso@mit.edu


The patch titled
     fs/char_dev.c: remove unused cdev_index()
has been added to the -mm tree.  Its filename is
     fs-char_devc-remove-unused-cdev_index.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
