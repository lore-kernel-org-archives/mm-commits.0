From: akpm@linux-foundation.org
Subject: + hpfs-dont-call-notify_change.patch added to -mm tree
Date: Fri, 30 May 2008 17:13:11 -0700
Message-ID: <200805310013.m4V0DCBN018604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753535AbYEaAN0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 20:13:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, hch@lst.de, mikulas@artax.karlin.mff.cuni.cz, viro@zeniv.linux.org.uk


The patch titled
     hpfs: dont call notify_change
has been added to the -mm tree.  Its filename is
     hpfs-dont-call-notify_change.patch

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
Subject: hpfs: dont call notify_change
From: Miklos Szeredi <mszeredi@suse.cz>

hpfs_unlink() calls notify_change() to truncate the file before
deleting.  Replace with explicit call to hpfs_notify_change().

This is equivalent, except that:
 - security_inode_setattr() is not called before hpfs_notify_change()
 - fsnotify_change() is not called after hpfs_notify_change()

The truncation is just an implementation detail, so both the security
check and the notification are unnecessary.

Possibly even the ctime modification is wrong?

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hpfs/namei.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/hpfs/namei.c~hpfs-dont-call-notify_change fs/hpfs/namei.c
--- a/fs/hpfs/namei.c~hpfs-dont-call-notify_change
+++ a/fs/hpfs/namei.c
@@ -426,7 +426,8 @@ again:
 			/*printk("HPFS: truncating file before delete.\n");*/
 			newattrs.ia_size = 0;
 			newattrs.ia_valid = ATTR_SIZE | ATTR_CTIME;
-			err = notify_change(dentry, &newattrs);
+			newattrs.ia_ctime = current_fs_time(inode->i_sb);
+			err = hpfs_notify_change(dentry, &newattrs);
 			put_write_access(inode);
 			if (!err)
 				goto again;
_

Patches currently in -mm which might be from mszeredi@suse.cz are

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
nfsd-clean-up-mnt_want_write-calls.patch
cgroup-dont-call-vfs_mkdir.patch
reiserfs-dont-call-vfs_rmdir.patch
reiserfs-dont-call-notify_change.patch
sysfs-dont-call-notify_change.patch
hpfs-dont-call-notify_change.patch
fat-dont-call-notify_change.patch
hpfs-dont-call-permission.patch
hppfs-remove-hppfs_permission.patch
gfs2-dont-call-permission.patch
vfs-immutable-inode-checking-cleanup.patch
vfs-truncate-dont-check-immutable-twice.patch
vfs-create-file_truncate-helper.patch
vfs-utimes-immutable-fix.patch
vfs-utimes-cleanup.patch
vfs-dcache-cleanups.patch
vfs-fix-sys_getcwd-for-detached-mounts.patch

