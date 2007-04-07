From: akpm@linux-foundation.org
Subject: + locks-make-lock-release-private-data-before-returning-in-getlk-case.patch added to -mm tree
Date: Fri, 06 Apr 2007 22:40:48 -0700
Message-ID: <200704070540.l375emAs028389@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45293 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbXDGFk7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 01:40:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@citi.umich.edu, eshel@almaden.ibm.com, jack@ucw.cz, trond.myklebust@fys.uio.no


The patch titled
     locks: make ->lock release private data before returning in GETLK case
has been added to the -mm tree.  Its filename is
     locks-make-lock-release-private-data-before-returning-in-getlk-case.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
remove-nfs4_acl_add_ace.patch
locks-trivial-removal-of-unnecessary-parentheses.patch
locks-create-posix-to-flock-helper-functions.patch
locks-make-lock-release-private-data-before-returning-in-getlk-case.patch
locks-give-posix_test_lock-same-interface-as-lock.patch
locks-factor-out-generic-filesystem-switch-from-test_lock.patch
locks-factor-out-generic-filesystem-switch-from-setlock-code.patch
locks-allow-vfsposix_lock_file-to-return-conflicting-lock.patch
locks-add-fl_notify-arguments-for-asynchronous-lock-return.patch
locks-add-lock-cancel-command.patch
nfsd4-convert-nfsv4-to-new-lock-interface.patch
lockd-save-lock-state-on-deferral.patch
lockd-handle-fl_notify-callbacks.patch
lockd-pass-cookie-in-nlmsvc_testlock.patch
lockd-handle-test_lock-deferrals.patch
lockd-always-preallocate-block-in-nlmsvc_lock.patch
lockd-add-code-to-handle-deferred-lock-requests.patch
gfs2-nfs-lock-support-for-gfs2.patch
