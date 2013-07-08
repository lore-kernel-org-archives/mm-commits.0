From: akpm@linux-foundation.org
Subject: [merged] configfs-use-capped-length-for-store_attribute.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:22:58 -0700
Message-ID: <51db1192.4d81plCbKPVhLBJ+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3GHTW6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:22:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jlbec@evilplan.org, dan.carpenter@oracle.com

Subject: [merged] configfs-use-capped-length-for-store_attribute.patch removed from -mm tree
To: dan.carpenter@oracle.com,jlbec@evilplan.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:22:58 -0700


The patch titled
     Subject: configfs: use capped length for ->store_attribute()
has been removed from the -mm tree.  Its filename was
     configfs-use-capped-length-for-store_attribute.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: configfs: use capped length for ->store_attribute()

The difference between "count" and "len" is that "len" is capped at 4095. 
Changing it like this makes it match how sysfs_write_file() is
implemented.

This is a static analysis patch.  I haven't found any store_attribute()
functions where this change makes a difference.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/configfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/configfs/file.c~configfs-use-capped-length-for-store_attribute fs/configfs/file.c
--- a/fs/configfs/file.c~configfs-use-capped-length-for-store_attribute
+++ a/fs/configfs/file.c
@@ -203,7 +203,7 @@ configfs_write_file(struct file *file, c
 	mutex_lock(&buffer->mutex);
 	len = fill_write_buffer(buffer, buf, count);
 	if (len > 0)
-		len = flush_write_buffer(file->f_path.dentry, buffer, count);
+		len = flush_write_buffer(file->f_path.dentry, buffer, len);
 	if (len > 0)
 		*ppos += len;
 	mutex_unlock(&buffer->mutex);
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
fanotify-info-leak-in-copy_event_to_user.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix.patch
mm-vmallocc-unbreak-__vunmap.patch
mwave-fix-info-leak-in-mwave_ioctl.patch
lib-scatterlist-error-handling-in-__sg_alloc_table.patch

