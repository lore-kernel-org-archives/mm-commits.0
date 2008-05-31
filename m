From: akpm@linux-foundation.org
Subject: + nfsd-clean-up-mnt_want_write-calls.patch added to -mm tree
Date: Fri, 30 May 2008 17:13:01 -0700
Message-ID: <200805310013.m4V0D1Z1018523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753525AbYEaAN0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 20:13:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, bfields@fieldses.org, hch@lst.de, neilb@suse.de, viro@zeniv.linux.org.uk


The patch titled
     nfsd: clean up mnt_want_write calls
has been added to the -mm tree.  Its filename is
     nfsd-clean-up-mnt_want_write-calls.patch

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
Subject: nfsd: clean up mnt_want_write calls
From: Miklos Szeredi <mszeredi@suse.cz>

Multiple mnt_want_write() calls in the switch statement looks really
ugly.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/vfs.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff -puN fs/nfsd/vfs.c~nfsd-clean-up-mnt_want_write-calls fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~nfsd-clean-up-mnt_want_write-calls
+++ a/fs/nfsd/vfs.c
@@ -1248,36 +1248,34 @@ nfsd_create(struct svc_rqst *rqstp, stru
 		iap->ia_mode = 0;
 	iap->ia_mode = (iap->ia_mode & S_IALLUGO) | type;
 
+	err = nfserr_inval;
+	if (!S_ISREG(type) && !S_ISDIR(type) && !special_file(type)) {
+		printk(KERN_WARNING "nfsd: bad file type %o in nfsd_create\n",
+		       type);
+		goto out;
+	}
+
+	host_err = mnt_want_write(fhp->fh_export->ex_path.mnt);
+	if (host_err)
+		goto out_nfserr;
+
 	/*
 	 * Get the dir op function pointer.
 	 */
 	err = 0;
 	switch (type) {
 	case S_IFREG:
-		host_err = mnt_want_write(fhp->fh_export->ex_path.mnt);
-		if (host_err)
-			goto out_nfserr;
 		host_err = vfs_create(dirp, dchild, iap->ia_mode, NULL);
 		break;
 	case S_IFDIR:
-		host_err = mnt_want_write(fhp->fh_export->ex_path.mnt);
-		if (host_err)
-			goto out_nfserr;
 		host_err = vfs_mkdir(dirp, dchild, iap->ia_mode);
 		break;
 	case S_IFCHR:
 	case S_IFBLK:
 	case S_IFIFO:
 	case S_IFSOCK:
-		host_err = mnt_want_write(fhp->fh_export->ex_path.mnt);
-		if (host_err)
-			goto out_nfserr;
 		host_err = vfs_mknod(dirp, dchild, iap->ia_mode, rdev);
 		break;
-	default:
-	        printk("nfsd: bad file type %o in nfsd_create\n", type);
-		host_err = -EINVAL;
-		goto out_nfserr;
 	}
 	if (host_err < 0) {
 		mnt_drop_write(fhp->fh_export->ex_path.mnt);
@@ -1289,7 +1287,6 @@ nfsd_create(struct svc_rqst *rqstp, stru
 		write_inode_now(dchild->d_inode, 1);
 	}
 
-
 	err2 = nfsd_create_setattr(rqstp, resfhp, iap);
 	if (err2)
 		err = err2;
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

