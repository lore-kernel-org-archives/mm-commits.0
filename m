From: akpm@linux-foundation.org
Subject: - locks-make-lock-release-private-data-before-returning-in-getlk-case.patch removed from -mm tree
Date: Thu, 19 Apr 2007 23:38:18 -0700
Message-ID: <200704200638.l3K6cIvT008746@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422997AbXDTGif (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 02:38:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, eshel@almaden.ibm.com, jack@ucw.cz, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     locks: make ->lock release private data before returning in GETLK case
has been removed from the -mm tree.  Its filename was
     locks-make-lock-release-private-data-before-returning-in-getlk-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: locks: make ->lock release private data before returning in GETLK case
From: J. Bruce Fields <bfields@citi.umich.edu> - unquoted

The file_lock argument to ->lock is used to return the conflicting lock when
found.  There's no reason for the filesystem to return any private information
with this conflicting lock, but nfsv4 is.

Fix nfsv4 client, and modify locks.c to stop calling fl_release_private for it
in this case.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Jan Kara <jack@ucw.cz>
Cc: Marc Eshel <eshel@almaden.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/locks.c        |    4 ----
 fs/nfs/nfs4proc.c |    2 ++
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/locks.c~locks-make-lock-release-private-data-before-returning-in-getlk-case fs/locks.c
--- a/fs/locks.c~locks-make-lock-release-private-data-before-returning-in-getlk-case
+++ a/fs/locks.c
@@ -1665,8 +1665,6 @@ int fcntl_getlk(struct file *filp, struc
 
 	if (filp->f_op && filp->f_op->lock) {
 		error = filp->f_op->lock(filp, F_GETLK, &file_lock);
-		if (file_lock.fl_ops && file_lock.fl_ops->fl_release_private)
-			file_lock.fl_ops->fl_release_private(&file_lock);
 		if (error < 0)
 			goto out;
 		else
@@ -1804,8 +1802,6 @@ int fcntl_getlk64(struct file *filp, str
 
 	if (filp->f_op && filp->f_op->lock) {
 		error = filp->f_op->lock(filp, F_GETLK, &file_lock);
-		if (file_lock.fl_ops && file_lock.fl_ops->fl_release_private)
-			file_lock.fl_ops->fl_release_private(&file_lock);
 		if (error < 0)
 			goto out;
 		else
diff -puN fs/nfs/nfs4proc.c~locks-make-lock-release-private-data-before-returning-in-getlk-case fs/nfs/nfs4proc.c
--- a/fs/nfs/nfs4proc.c~locks-make-lock-release-private-data-before-returning-in-getlk-case
+++ a/fs/nfs/nfs4proc.c
@@ -3019,6 +3019,8 @@ static int _nfs4_proc_getlk(struct nfs4_
 			status = 0;
 	}
 out:
+	if (request->fl_ops)
+		request->fl_ops->fl_release_private(request);
 	up_read(&clp->cl_sem);
 	return status;
 }
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

auth_gss-unregister-gss_domain-when-unloading-module.patch
git-nfs-server-cluster-locking-api.patch
remove-nfs4_acl_add_ace.patch
