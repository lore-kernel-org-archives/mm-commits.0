From: akpm@linux-foundation.org
Subject: + configfs-use-capped-length-for-store_attribute.patch added to -mm tree
Date: Tue, 07 May 2013 14:15:34 -0700
Message-ID: <20130507211534.7528731C034@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:64938 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab3EGVPf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 17:15:35 -0400
Received: by mail-qe0-f73.google.com with SMTP id a11so112372qen.0
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 14:15:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, jlbec@evilplan.org


The patch titled
     Subject: configfs: use capped length for ->store_attribute()
has been added to the -mm tree.  Its filename is
     configfs-use-capped-length-for-store_attribute.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: configfs: use capped length for ->store_attribute()

The difference between "count" and "len" is that "len" is capped at 4095. 
Changing it like this makes it match how sysfs_write_file() is
implemented.

This is a static analysis patch.  I haven't found any store_attribute()
functions where this change makes a difference.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
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
configfs-use-capped-length-for-store_attribute.patch
mwave-fix-info-leak-in-mwave_ioctl.patch

