From: akpm@linux-foundation.org
Subject: + vfs-fix-sys_getcwd-for-detached-mounts.patch added to -mm tree
Date: Fri, 30 May 2008 17:13:35 -0700
Message-ID: <200805310013.m4V0DZOn018646@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756578AbYEaANu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 20:13:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, hch@lst.de, jjohansen@suse.de, viro@zeniv.linux.org.uk


The patch titled
     vfs: fix sys_getcwd for detached mounts
has been added to the -mm tree.  Its filename is
     vfs-fix-sys_getcwd-for-detached-mounts.patch

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
Subject: vfs: fix sys_getcwd for detached mounts
From: Miklos Szeredi <mszeredi@suse.cz>

Currently getcwd(2) on a detached mount will give a garbled result:

   > mkdir /mnt/foo
   > mount --bind /etc /mnt/foo
   > cd /mnt/foo/skel
   > /bin/pwd
   /mnt/foo/skel
   > umount -l /mnt/foo
   > /bin/pwd
   etcskel

After the patch it will give a much saner "/skel" result.

Thanks to John Johansen for pointing out this bug.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Reported-by: John Johansen <jjohansen@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff -puN fs/dcache.c~vfs-fix-sys_getcwd-for-detached-mounts fs/dcache.c
--- a/fs/dcache.c~vfs-fix-sys_getcwd-for-detached-mounts
+++ a/fs/dcache.c
@@ -1952,10 +1952,20 @@ char *__d_path(const struct path *path, 
 	return retval;
 
 global_root:
-	retval += 1;	/* hit the slash */
-	name = &dentry->d_name;
-	if (prepend(&retval, &buflen, name->name, name->len) != 0)
-		goto Elong;
+	/*
+	 * If this is a root dentry, then overwrite the slash.  This
+	 * will also DTRT with pseudo filesystems which have root
+	 * dentries named "foo:".
+	 *
+	 * Otherwise this is the root of a detached mount, so don't do
+	 * anything.
+	 */
+	if (IS_ROOT(dentry)) {
+		retval += 1;
+		name = &dentry->d_name;
+		if (prepend(&retval, &buflen, name->name, name->len) != 0)
+			goto Elong;
+	}
 	root->mnt = vfsmnt;
 	root->dentry = dentry;
 	return retval;
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

