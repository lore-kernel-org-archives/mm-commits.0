From: akpm@linux-foundation.org
Subject: - vfs-fix-sys_getcwd-for-detached-mounts.patch removed from -mm tree
Date: Sat, 31 May 2008 00:42:57 -0700
Message-ID: <200805310742.m4V7gvhP000952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751294AbYEaHnk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 31 May 2008 03:43:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, hch@lst.de, jjohansen@suse.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: fix sys_getcwd for detached mounts
has been removed from the -mm tree.  Its filename was
     vfs-fix-sys_getcwd-for-detached-mounts.patch

This patch was dropped because it's more controversial than was first thought, and it was sent off-list

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

vfs-fix-sys_getcwd-for-detached-mounts.patch
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

