From: akpm@osdl.org
Subject: - error-handling-in-sysfs-fill_read_buffer.patch removed from -mm tree
Date: Sun, 07 Jan 2007 00:00:52 -0800
Message-ID: <200701070800.l0780q7L013228@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41086 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932495AbXAGIAz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 03:00:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oliver@neukum.name, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     error handling in sysfs, fill_read_buffer()
has been removed from the -mm tree.  Its filename was
     error-handling-in-sysfs-fill_read_buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: error handling in sysfs, fill_read_buffer()
From: Oliver Neukum <oliver@neukum.name>

If a driver returns an error in fill_read_buffer(), the buffer will be
marked as filled.  Subsequent reads will return eof.  But there is no data
because of an error, not because it has been read.  Not marking the buffer
filled is the obvious fix.

Signed-off-by: Oliver Neukum <oliver@neukum.name>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/sysfs/file.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff -puN fs/sysfs/file.c~error-handling-in-sysfs-fill_read_buffer fs/sysfs/file.c
--- a/fs/sysfs/file.c~error-handling-in-sysfs-fill_read_buffer
+++ a/fs/sysfs/file.c
@@ -91,7 +91,8 @@ remove_from_collection(struct sysfs_buff
  *	Allocate @buffer->page, if it hasn't been already, then call the
  *	kobject's show() method to fill the buffer with this attribute's 
  *	data. 
- *	This is called only once, on the file's first read. 
+ *	This is called only once, on the file's first read unless an error
+ *	is returned.
  */
 static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer)
 {
@@ -109,12 +110,13 @@ static int fill_read_buffer(struct dentr
 
 	buffer->event = atomic_read(&sd->s_event);
 	count = ops->show(kobj,attr,buffer->page);
-	buffer->needs_read_fill = 0;
 	BUG_ON(count > (ssize_t)PAGE_SIZE);
-	if (count >= 0)
+	if (count >= 0) {
+		buffer->needs_read_fill = 0;
 		buffer->count = count;
-	else
+	} else {
 		ret = count;
+	}
 	return ret;
 }
 
_

Patches currently in -mm which might be from oliver@neukum.name are
