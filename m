From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-nfs-check-mnt-instead-of-sb.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:33:30 -0800
Message-ID: <200702150833.l1F8XUcA024636@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39630 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965307AbXBOIhH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:37:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hansendc@us.ibm.com, haveblue@us.ibm.com, hch@lst.de, miklos@szeredi.hu, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: nfs: check mnt instead of sb
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-nfs-check-mnt-instead-of-sb.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: r/o bind mounts: nfs: check mnt instead of sb
From: Dave Hansen <hansendc@us.ibm.com>

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/dir.c  |    3 ++-
 fs/nfsd/vfs.c |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/nfs/dir.c~r-o-bind-mounts-nfs-check-mnt-instead-of-sb fs/nfs/dir.c
--- a/fs/nfs/dir.c~r-o-bind-mounts-nfs-check-mnt-instead-of-sb
+++ a/fs/nfs/dir.c
@@ -980,7 +980,8 @@ static int is_atomic_open(struct inode *
 	if (nd->flags & LOOKUP_DIRECTORY)
 		return 0;
 	/* Are we trying to write to a read only partition? */
-	if (IS_RDONLY(dir) && (nd->intent.open.flags & (O_CREAT|O_TRUNC|FMODE_WRITE)))
+	if (__mnt_is_readonly(nd->mnt) &&
+	    (nd->intent.open.flags & (O_CREAT|O_TRUNC|FMODE_WRITE)))
 		return 0;
 	return 1;
 }
diff -puN fs/nfsd/vfs.c~r-o-bind-mounts-nfs-check-mnt-instead-of-sb fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~r-o-bind-mounts-nfs-check-mnt-instead-of-sb
+++ a/fs/nfsd/vfs.c
@@ -1811,7 +1811,7 @@ nfsd_permission(struct svc_export *exp, 
 		inode->i_mode,
 		IS_IMMUTABLE(inode)?	" immut" : "",
 		IS_APPEND(inode)?	" append" : "",
-		IS_RDONLY(inode)?	" ro" : "");
+		__mnt_is_readonly(exp->mnt)?	" ro" : "");
 	dprintk("      owner %d/%d user %d/%d\n",
 		inode->i_uid, inode->i_gid, current->fsuid, current->fsgid);
 #endif
@@ -1822,7 +1822,7 @@ nfsd_permission(struct svc_export *exp, 
 	 */
 	if (!(acc & MAY_LOCAL_ACCESS))
 		if (acc & (MAY_WRITE | MAY_SATTR | MAY_TRUNC)) {
-			if (EX_RDONLY(exp) || IS_RDONLY(inode))
+			if (EX_RDONLY(exp))
 				return nfserr_rofs;
 			if (/* (acc & MAY_WRITE) && */ IS_IMMUTABLE(inode))
 				return nfserr_perm;
_

Patches currently in -mm which might be from hansendc@us.ibm.com are

r-o-bind-mounts-nfs-check-mnt-instead-of-sb.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-elevate-writer-count-for-custom-struct_file.patch
r-o-bind-mounts-remove-is_rdonly-from-permission.patch
r-o-bind-mounts-reiser4-remove-is_rdonly-checks.patch
