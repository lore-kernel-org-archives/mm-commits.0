From: akpm@linux-foundation.org
Subject: - sysfs-filec-use-mutex-instead-of-semaphore.patch removed from -mm tree
Date: Tue, 31 Jul 2007 13:30:05 -0700
Message-ID: <200707312030.l6VKU5du020939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59089 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932644AbXGaUaw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 16:30:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sysfs/file.c: use mutex instead of semaphore
has been removed from the -mm tree.  Its filename was
     sysfs-filec-use-mutex-instead-of-semaphore.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysfs/file.c: use mutex instead of semaphore
From: Dave Young <hidave.darkstar@gmail.com>

Use mutex instead of semaphore in sysfs/file.c: sys_buffer.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/file.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/sysfs/file.c~sysfs-filec-use-mutex-instead-of-semaphore fs/sysfs/file.c
--- a/fs/sysfs/file.c~sysfs-filec-use-mutex-instead-of-semaphore
+++ a/fs/sysfs/file.c
@@ -8,8 +8,8 @@
 #include <linux/namei.h>
 #include <linux/poll.h>
 #include <linux/list.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 
 #include "sysfs.h"
 
@@ -55,7 +55,7 @@ struct sysfs_buffer {
 	loff_t			pos;
 	char			* page;
 	struct sysfs_ops	* ops;
-	struct semaphore	sem;
+	struct mutex		mutex;
 	int			needs_read_fill;
 	int			event;
 };
@@ -128,7 +128,7 @@ sysfs_read_file(struct file *file, char 
 	struct sysfs_buffer * buffer = file->private_data;
 	ssize_t retval = 0;
 
-	down(&buffer->sem);
+	mutex_lock(&buffer->mutex);
 	if (buffer->needs_read_fill) {
 		retval = fill_read_buffer(file->f_path.dentry,buffer);
 		if (retval)
@@ -139,7 +139,7 @@ sysfs_read_file(struct file *file, char 
 	retval = simple_read_from_buffer(buf, count, ppos, buffer->page,
 					 buffer->count);
 out:
-	up(&buffer->sem);
+	mutex_unlock(&buffer->mutex);
 	return retval;
 }
 
@@ -228,13 +228,13 @@ sysfs_write_file(struct file *file, cons
 	struct sysfs_buffer * buffer = file->private_data;
 	ssize_t len;
 
-	down(&buffer->sem);
+	mutex_lock(&buffer->mutex);
 	len = fill_write_buffer(buffer, buf, count);
 	if (len > 0)
 		len = flush_write_buffer(file->f_path.dentry, buffer, len);
 	if (len > 0)
 		*ppos += len;
-	up(&buffer->sem);
+	mutex_unlock(&buffer->mutex);
 	return len;
 }
 
@@ -294,7 +294,7 @@ static int sysfs_open_file(struct inode 
 	if (!buffer)
 		goto err_out;
 
-	init_MUTEX(&buffer->sem);
+	mutex_init(&buffer->mutex);
 	buffer->needs_read_fill = 1;
 	buffer->ops = ops;
 	file->private_data = buffer;
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

hpettxt-broken-link-fix.patch
zisofs-use-mutex-instead-of-semaphore.patch
