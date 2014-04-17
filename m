From: akpm@linux-foundation.org
Subject: + fanotify-create-fan_access-event-for-readdir.patch added to -mm tree
Date: Thu, 17 Apr 2014 13:39:58 -0700
Message-ID: <53503c1e.3Z3QStNxG8NIO1xO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaDQUj6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Apr 2014 16:39:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jack@suse.cz, eparis@redhat.com, xypron.glpk@gmx.de

Subject: + fanotify-create-fan_access-event-for-readdir.patch added to -mm tree
To: xypron.glpk@gmx.de,eparis@redhat.com,jack@suse.cz
From: akpm@linux-foundation.org
Date: Thu, 17 Apr 2014 13:39:58 -0700


The patch titled
     Subject: fanotify: create FAN_ACCESS event for readdir
has been added to the -mm tree.  Its filename is
     fanotify-create-fan_access-event-for-readdir.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fanotify-create-fan_access-event-for-readdir.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fanotify-create-fan_access-event-for-readdir.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fanotify-fan_mark_flush-avoid-having-to-provide-a-fake-invalid-fd-and-path.patch
fanotify-create-fan_access-event-for-readdir.patch

