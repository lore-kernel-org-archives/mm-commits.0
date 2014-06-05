From: akpm@linux-foundation.org
Subject: [merged] fanotify-create-fan_access-event-for-readdir.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:42:09 -0700
Message-ID: <5390c811.yjWphwmX7Uk2ASk9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55522 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaFETmK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:42:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jack@suse.cz, eparis@redhat.com, xypron.glpk@gmx.de

Subject: [merged] fanotify-create-fan_access-event-for-readdir.patch removed from -mm tree
To: xypron.glpk@gmx.de,eparis@redhat.com,jack@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:42:09 -0700


The patch titled
     Subject: fanotify: create FAN_ACCESS event for readdir
has been removed from the -mm tree.  Its filename was
     fanotify-create-fan_access-event-for-readdir.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: fanotify: create FAN_ACCESS event for readdir

Before the patch,
read creates FAN_ACCESS_PERM and FAN_ACCESS events,
readdir creates only FAN_ACCESS_PERM events.

This is inconsistent.

After the patch,
readdir creates FAN_ACCESS_PERM and FAN_ACCESS events.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/readdir.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/readdir.c~fanotify-create-fan_access-event-for-readdir fs/readdir.c
--- a/fs/readdir.c~fanotify-create-fan_access-event-for-readdir
+++ a/fs/readdir.c
@@ -13,6 +13,7 @@
 #include <linux/stat.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/fsnotify.h>
 #include <linux/dirent.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
@@ -40,6 +41,7 @@ int iterate_dir(struct file *file, struc
 		ctx->pos = file->f_pos;
 		res = file->f_op->iterate(file, ctx);
 		file->f_pos = ctx->pos;
+		fsnotify_access(file);
 		file_accessed(file);
 	}
 	mutex_unlock(&inode->i_mutex);
_

Patches currently in -mm which might be from xypron.glpk@gmx.de are

origin.patch
linux-next.patch

