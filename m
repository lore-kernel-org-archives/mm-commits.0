From: akpm@linux-foundation.org
Subject: + unregister_blkdev-return-void.patch added to -mm tree
Date: Tue, 03 Jul 2007 12:56:08 -0700
Message-ID: <200707031956.l63Ju8eR012165@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48252 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757895AbXGCT4U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 15:56:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, jens.axboe@oracle.com


The patch titled
     unregister_blkdev(): return void
has been added to the -mm tree.  Its filename is
     unregister_blkdev-return-void.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: unregister_blkdev(): return void
From: Akinobu Mita <akinobu.mita@gmail.com>

Put WARN_ON and fixed all callers of unregister_blkdev().  Now we can make
unregister_blkdev return void.

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c      |    7 +------
 include/linux/fs.h |    2 +-
 2 files changed, 2 insertions(+), 7 deletions(-)

diff -puN block/genhd.c~unregister_blkdev-return-void block/genhd.c
--- a/block/genhd.c~unregister_blkdev-return-void
+++ a/block/genhd.c
@@ -108,13 +108,11 @@ out:
 
 EXPORT_SYMBOL(register_blkdev);
 
-/* todo: make void - error printk here */
-int unregister_blkdev(unsigned int major, const char *name)
+void unregister_blkdev(unsigned int major, const char *name)
 {
 	struct blk_major_name **n;
 	struct blk_major_name *p = NULL;
 	int index = major_to_index(major);
-	int ret = 0;
 
 	mutex_lock(&block_subsys_lock);
 	for (n = &major_names[index]; *n; n = &(*n)->next)
@@ -122,15 +120,12 @@ int unregister_blkdev(unsigned int major
 			break;
 	if (!*n || strcmp((*n)->name, name)) {
 		WARN_ON(1);
-		ret = -EINVAL;
 	} else {
 		p = *n;
 		*n = p->next;
 	}
 	mutex_unlock(&block_subsys_lock);
 	kfree(p);
-
-	return ret;
 }
 
 EXPORT_SYMBOL(unregister_blkdev);
diff -puN include/linux/fs.h~unregister_blkdev-return-void include/linux/fs.h
--- a/include/linux/fs.h~unregister_blkdev-return-void
+++ a/include/linux/fs.h
@@ -1585,7 +1585,7 @@ extern void putname(const char *name);
 
 #ifdef CONFIG_BLOCK
 extern int register_blkdev(unsigned int, const char *);
-extern int unregister_blkdev(unsigned int, const char *);
+extern void unregister_blkdev(unsigned int, const char *);
 extern struct block_device *bdget(dev_t);
 extern void bd_set_size(struct block_device *, loff_t size);
 extern void bd_forget(struct inode *inode);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

git-dvb.patch
git-netdev-all.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
fault-injection-add-min-order-parameter-to-fail_page_alloc.patch
fault-injection-fix-example-scripts-in-documentation.patch
unregister_chrdev-ignore-the-return-value.patch
unregister_chrdev-return-void.patch
unregister_blkdev-do-warn_on-on-failure.patch
unregister_blkdev-delete-redundant-messages-in-callers.patch
unregister_blkdev-delete-redundant-message.patch
unregister_blkdev-return-void.patch
