From: akpm@linux-foundation.org
Subject: + sysfs-fix-error-handling-in-binattr-write.patch added to -mm tree
Date: Tue, 10 Apr 2007 13:47:25 -0700
Message-ID: <200704102047.l3AKlPKU016925@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44706 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855AbXDJUrj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 16:47:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com, cornelia.huck@de.ibm.com, dipankar@in.ibm.com, greg@kroah.com, maneesh@in.ibm.com


The patch titled
     sysfs: fix error handling in binattr write()
has been added to the -mm tree.  Its filename is
     sysfs-fix-error-handling-in-binattr-write.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysfs: fix error handling in binattr write()
From: Tejun Heo <htejun@gmail.com>

Error handling in fs/sysfs/bin.c:write() was wrong because size_t count is
used to receive return value from flush_write() which is negative on failure.

This patch updates write() such that int variable is used instead.  read() is
updated the same way for consistency.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Maneesh Soni <maneesh@in.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/bin.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)

diff -puN fs/sysfs/bin.c~sysfs-fix-error-handling-in-binattr-write fs/sysfs/bin.c
--- a/fs/sysfs/bin.c~sysfs-fix-error-handling-in-binattr-write
+++ a/fs/sysfs/bin.c
@@ -33,16 +33,13 @@ fill_read(struct dentry *dentry, char *b
 }
 
 static ssize_t
-read(struct file * file, char __user * userbuf, size_t count, loff_t * off)
+read(struct file *file, char __user *userbuf, size_t bytes, loff_t *off)
 {
 	char *buffer = file->private_data;
 	struct dentry *dentry = file->f_path.dentry;
 	int size = dentry->d_inode->i_size;
 	loff_t offs = *off;
-	int ret;
-
-	if (count > PAGE_SIZE)
-		count = PAGE_SIZE;
+	int count = min_t(size_t, bytes, PAGE_SIZE);
 
 	if (size) {
 		if (offs > size)
@@ -51,10 +48,9 @@ read(struct file * file, char __user * u
 			count = size - offs;
 	}
 
-	ret = fill_read(dentry, buffer, offs, count);
-	if (ret < 0) 
-		return ret;
-	count = ret;
+	count = fill_read(dentry, buffer, offs, count);
+	if (count < 0)
+		return count;
 
 	if (copy_to_user(userbuf, buffer, count))
 		return -EFAULT;
@@ -78,16 +74,15 @@ flush_write(struct dentry *dentry, char 
 	return attr->write(kobj, buffer, offset, count);
 }
 
-static ssize_t write(struct file * file, const char __user * userbuf,
-		     size_t count, loff_t * off)
+static ssize_t write(struct file *file, const char __user *userbuf,
+		     size_t bytes, loff_t *off)
 {
 	char *buffer = file->private_data;
 	struct dentry *dentry = file->f_path.dentry;
 	int size = dentry->d_inode->i_size;
 	loff_t offs = *off;
+	int count = min_t(size_t, bytes, PAGE_SIZE);
 
-	if (count > PAGE_SIZE)
-		count = PAGE_SIZE;
 	if (size) {
 		if (offs > size)
 			return 0;
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
revert-gregkh-driver-sysfs-crash-debugging.patch
sysfs-fix-i_ino-handling-in-sysfs.patch
sysfs-fix-error-handling-in-binattr-write.patch
sysfs-move-release_sysfs_dirent-to-dirc.patch
sysfs-flatten-cleanup-paths-in-sysfs_add_link-and-create_dir.patch
sysfs-consolidate-sysfs_dirent-creation-functions.patch
sysfs-add-sysfs_dirent-s_parent.patch
sysfs-add-sysfs_dirent-s_name.patch
sysfs-make-sysfs_dirent-s_element-a-union.patch
sysfs-implement-kobj_sysfs_assoc_lock.patch
sysfs-reimplement-symlink-using-sysfs_dirent-tree.patch
sysfs-implement-bin_buffer.patch
sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect.patch
sysfs-kill-attribute-file-orphaning.patch
sysfs-kill-unnecessary-attribute-owner.patch
sysfs-kill-unnecessary-attribute-owner-fix.patch
git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
optional-led-trigger-for-libata.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
git-scsi-misc.patch
introduce-config_has_dma.patch
