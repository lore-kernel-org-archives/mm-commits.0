From: akpm@linux-foundation.org
Subject: - nfsd4-convert-nfsv4-to-new-lock-interface.patch removed from -mm tree
Date: Thu, 19 Apr 2007 23:38:33 -0700
Message-ID: <200704200638.l3K6cXD5008767@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423027AbXDTGiu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 02:38:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eshel@almaden.ibm.com, bfields@citi.umich.edu, jack@ucw.cz, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     nfsd4: Convert NFSv4 to new lock interface
has been removed from the -mm tree.  Its filename was
     nfsd4-convert-nfsv4-to-new-lock-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nfsd4: Convert NFSv4 to new lock interface
From: Marc Eshel <eshel@almaden.ibm.com> - unquoted

Convert NFSv4 to the new lock interface.  We don't define any callback for
now, so we're not taking advantage of the asynchronous feature--that's less
critical for the multi-threaded nfsd then it is for the single-threaded lockd.
 But this does allow a cluster filesystems to export cluster-coherent locking
to NFS.

Note that it's cluster filesystems that are the issue--of the filesystems that
define lock methods (nfs, cifs, etc.), most are not exportable by nfsd.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Jan Kara <jack@ucw.cz>
Cc: Marc Eshel <eshel@almaden.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4state.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff -puN fs/nfsd/nfs4state.c~nfsd4-convert-nfsv4-to-new-lock-interface fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~nfsd4-convert-nfsv4-to-new-lock-interface
+++ a/fs/nfsd/nfs4state.c
@@ -50,6 +50,7 @@
 #include <linux/nfsd/xdr4.h>
 #include <linux/namei.h>
 #include <linux/mutex.h>
+#include <linux/lockd/bind.h>
 
 #define NFSDDBG_FACILITY                NFSDDBG_PROC
 
@@ -2773,7 +2774,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
 	/* XXX?: Just to divert the locks_release_private at the start of
 	 * locks_copy_lock: */
 	locks_init_lock(&conflock);
-	err = posix_lock_file(filp, &file_lock, &conflock);
+	err = vfs_lock_file(filp, cmd, &file_lock, &conflock);
 	switch (-err) {
 	case 0: /* success! */
 		update_stateid(&lock_stp->st_stateid);
@@ -2790,7 +2791,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
 		status = nfserr_deadlock;
 		break;
 	default:        
-		dprintk("NFSD: nfsd4_lock: posix_lock_file_conf() failed! status %d\n",err);
+		dprintk("NFSD: nfsd4_lock: vfs_lock_file() failed! status %d\n",err);
 		status = nfserr_resource;
 		break;
 	}
@@ -2815,6 +2816,7 @@ nfsd4_lockt(struct svc_rqst *rqstp, stru
 	struct inode *inode;
 	struct file file;
 	struct file_lock file_lock;
+	int error;
 	__be32 status;
 
 	if (nfs4_in_grace())
@@ -2870,16 +2872,20 @@ nfsd4_lockt(struct svc_rqst *rqstp, stru
 
 	nfs4_transform_lock_offset(&file_lock);
 
-	/* posix_test_lock uses the struct file _only_ to resolve the inode.
+	/* vfs_test_lock uses the struct file _only_ to resolve the inode.
 	 * since LOCKT doesn't require an OPEN, and therefore a struct
-	 * file may not exist, pass posix_test_lock a struct file with
+	 * file may not exist, pass vfs_test_lock a struct file with
 	 * only the dentry:inode set.
 	 */
 	memset(&file, 0, sizeof (struct file));
 	file.f_path.dentry = cstate->current_fh.fh_dentry;
 
 	status = nfs_ok;
-	posix_test_lock(&file, &file_lock);
+	error = vfs_test_lock(&file, &file_lock);
+	if (error) {
+		status = nfserrno(error);
+		goto out;
+	}
 	if (file_lock.fl_type != F_UNLCK) {
 		status = nfserr_denied;
 		nfs4_set_lock_denied(&file_lock, &lockt->lt_denied);
@@ -2935,9 +2941,9 @@ nfsd4_locku(struct svc_rqst *rqstp, stru
 	/*
 	*  Try to unlock the file in the VFS.
 	*/
-	err = posix_lock_file(filp, &file_lock, NULL);
+	err = vfs_lock_file(filp, F_SETLK, &file_lock, NULL);
 	if (err) {
-		dprintk("NFSD: nfs4_locku: posix_lock_file failed!\n");
+		dprintk("NFSD: nfs4_locku: vfs_lock_file failed!\n");
 		goto out_nfserr;
 	}
 	/*
_

Patches currently in -mm which might be from eshel@almaden.ibm.com are

git-nfs-server-cluster-locking-api.patch
