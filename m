From: akpm@linux-foundation.org
Subject: + fuse-fix-bdi-naming-conflict.patch added to -mm tree
Date: Mon, 19 May 2008 13:03:36 -0700
Message-ID: <200805192003.m4JK3acZ018050@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761599AbYESUDm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 16:03:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, opslynx@gmail.com


The patch titled
     fuse: fix bdi naming conflict
has been added to the -mm tree.  Its filename is
     fuse-fix-bdi-naming-conflict.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fuse: fix bdi naming conflict
From: Miklos Szeredi <mszeredi@suse.cz>

Fuse allocates a separate bdi for each filesystem, and registers them
in sysfs with "MAJOR:MINOR" of sb->s_dev (st_dev).  This works fine for
anon devices normally used by fuse, but can conflict with an already
registered BDI for "fuseblk" filesystems, where sb->s_dev represents a
real block device.  In particularl this happens if a non-partitioned
device is being mounted.

Fix by registering with a different name for "fuseblk" filesystems.

Thanks to Ioan Ionita for the bug report.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Reported-by: Ioan Ionita <opslynx@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-bdi |    4 ++++
 fs/fuse/inode.c                           |    7 ++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff -puN Documentation/ABI/testing/sysfs-class-bdi~fuse-fix-bdi-naming-conflict Documentation/ABI/testing/sysfs-class-bdi
--- a/Documentation/ABI/testing/sysfs-class-bdi~fuse-fix-bdi-naming-conflict
+++ a/Documentation/ABI/testing/sysfs-class-bdi
@@ -14,6 +14,10 @@ MAJOR:MINOR
 	non-block filesystems which provide their own BDI, such as NFS
 	and FUSE.
 
+MAJOR:MINOR-fuseblk
+
+	Value of st_dev on fuseblk filesystems.
+
 default
 
 	The default backing dev, used for non-block device backed
diff -puN fs/fuse/inode.c~fuse-fix-bdi-naming-conflict fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-fix-bdi-naming-conflict
+++ a/fs/fuse/inode.c
@@ -488,7 +488,12 @@ static struct fuse_conn *new_conn(struct
 		err = bdi_init(&fc->bdi);
 		if (err)
 			goto error_kfree;
-		err = bdi_register_dev(&fc->bdi, fc->dev);
+		if (sb->s_bdev) {
+			err = bdi_register(&fc->bdi, NULL, "%u:%u-fuseblk",
+					   MAJOR(fc->dev), MINOR(fc->dev));
+		} else {
+			err = bdi_register_dev(&fc->bdi, fc->dev);
+		}
 		if (err)
 			goto error_bdi_destroy;
 		/*
_

Patches currently in -mm which might be from mszeredi@suse.cz are

fuse-fix-bdi-naming-conflict.patch
git-vfs-cleanups.patch
git-unprivileged-mounts.patch
lockd-dont-return-eagain-for-a-permanent-error.patch
locks-add-special-return-value-for-asynchronous-locks.patch
locks-cleanup-code-duplication.patch
locks-allow-lock-to-return-file_lock_deferred.patch
fuse-prepare-lookup-for-nfs-export.patch
fuse-add-export-operations.patch
fuse-add-fuse_lookup_name-helper.patch
fuse-nfs-export-special-lookups.patch
fuse-lockd-support.patch

