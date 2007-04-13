From: akpm@linux-foundation.org
Subject: - sysfs-fix-error-handling-in-binattr-write.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:28:54 -0700
Message-ID: <200704132328.l3DNSs2c012557@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60437 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161094AbXDMX3Q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:29:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, cornelia.huck@de.ibm.com, dipankar@in.ibm.com, greg@kroah.com, maneesh@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     sysfs: fix error handling in binattr write()
has been removed from the -mm tree.  Its filename was
     sysfs-fix-error-handling-in-binattr-write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
optional-led-trigger-for-libata.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
git-scsi-misc.patch
introduce-config_has_dma.patch
