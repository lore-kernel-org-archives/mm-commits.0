From: akpm@linux-foundation.org
Subject: - 64-bit-ino-support-for-nfs-client.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:13:23 -0700
Message-ID: <200708141913.l7EJDNvM016500@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53172 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933315AbXHNTVy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:21:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: staubach@redhat.com, bfields@fieldses.org, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     64 bit ino support for NFS client
has been removed from the -mm tree.  Its filename was
     64-bit-ino-support-for-nfs-client.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: 64 bit ino support for NFS client
From: Peter Staubach <staubach@redhat.com>

Modify the NFS client code to support 64 bit ino's, as appropriate for the
system and the NFS protocol version.

The code basically just expand the NFS interfaces for routines which handle
ino's from using ino_t to u64 and then uses the fileid in the nfs_inode
instead of i_ino in the inode.  The code paths that were updated are in the
getattr method and the readdir methods.

This should be no real change on 64 bit platforms.  Since the ino_t is an
unsigned long, it would already be 64 bits wide.

Signed-off-by: Peter Staubach <staubach@redhat.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/dir.c      |   15 ++++++++-------
 fs/nfs/inode.c    |    4 +++-
 fs/nfs/nfs4proc.c |    4 ++--
 3 files changed, 13 insertions(+), 10 deletions(-)

diff -puN fs/nfs/dir.c~64-bit-ino-support-for-nfs-client fs/nfs/dir.c
--- a/fs/nfs/dir.c~64-bit-ino-support-for-nfs-client
+++ a/fs/nfs/dir.c
@@ -407,7 +407,7 @@ int nfs_do_filldir(nfs_readdir_descripto
 	struct file	*file = desc->file;
 	struct nfs_entry *entry = desc->entry;
 	struct dentry	*dentry = NULL;
-	unsigned long	fileid;
+	u64		fileid;
 	int		loop_count = 0,
 			res;
 
@@ -418,7 +418,7 @@ int nfs_do_filldir(nfs_readdir_descripto
 		unsigned d_type = DT_UNKNOWN;
 		/* Note: entry->prev_cookie contains the cookie for
 		 *	 retrieving the current dirent on the server */
-		fileid = nfs_fileid_to_ino_t(entry->ino);
+		fileid = entry->ino;
 
 		/* Get a dentry if we have one */
 		if (dentry != NULL)
@@ -428,7 +428,7 @@ int nfs_do_filldir(nfs_readdir_descripto
 		/* Use readdirplus info */
 		if (dentry != NULL && dentry->d_inode != NULL) {
 			d_type = dt_type(dentry->d_inode);
-			fileid = dentry->d_inode->i_ino;
+			fileid = NFS_FILEID(dentry->d_inode);
 		}
 
 		res = filldir(dirent, entry->name, entry->len, 
@@ -1348,9 +1348,9 @@ static int nfs_rmdir(struct inode *dir, 
 static int nfs_sillyrename(struct inode *dir, struct dentry *dentry)
 {
 	static unsigned int sillycounter;
-	const int      i_inosize  = sizeof(dir->i_ino)*2;
+	const int      fileidsize  = sizeof(NFS_FILEID(dentry->d_inode))*2;
 	const int      countersize = sizeof(sillycounter)*2;
-	const int      slen       = sizeof(".nfs") + i_inosize + countersize - 1;
+	const int      slen        = sizeof(".nfs")+fileidsize+countersize-1;
 	char           silly[slen+1];
 	struct qstr    qsilly;
 	struct dentry *sdentry;
@@ -1368,8 +1368,9 @@ static int nfs_sillyrename(struct inode 
 	if (dentry->d_flags & DCACHE_NFSFS_RENAMED)
 		goto out;
 
-	sprintf(silly, ".nfs%*.*lx",
-		i_inosize, i_inosize, dentry->d_inode->i_ino);
+	sprintf(silly, ".nfs%*.*Lx",
+		fileidsize, fileidsize,
+		(unsigned long long)NFS_FILEID(dentry->d_inode));
 
 	/* Return delegation in anticipation of the rename */
 	nfs_inode_return_delegation(dentry->d_inode);
diff -puN fs/nfs/inode.c~64-bit-ino-support-for-nfs-client fs/nfs/inode.c
--- a/fs/nfs/inode.c~64-bit-ino-support-for-nfs-client
+++ a/fs/nfs/inode.c
@@ -450,8 +450,10 @@ int nfs_getattr(struct vfsmount *mnt, st
 		err = __nfs_revalidate_inode(NFS_SERVER(inode), inode);
 	else
 		err = nfs_revalidate_inode(NFS_SERVER(inode), inode);
-	if (!err)
+	if (!err) {
 		generic_fillattr(inode, stat);
+		stat->ino = NFS_FILEID(inode);
+	}
 	return err;
 }
 
diff -puN fs/nfs/nfs4proc.c~64-bit-ino-support-for-nfs-client fs/nfs/nfs4proc.c
--- a/fs/nfs/nfs4proc.c~64-bit-ino-support-for-nfs-client
+++ a/fs/nfs/nfs4proc.c
@@ -177,7 +177,7 @@ static void nfs4_setup_readdir(u64 cooki
 		*p++ = xdr_one;                         /* bitmap length */
 		*p++ = htonl(FATTR4_WORD0_FILEID);             /* bitmap */
 		*p++ = htonl(8);              /* attribute buffer length */
-		p = xdr_encode_hyper(p, dentry->d_inode->i_ino);
+		p = xdr_encode_hyper(p, NFS_FILEID(dentry->d_inode));
 	}
 	
 	*p++ = xdr_one;                                  /* next */
@@ -189,7 +189,7 @@ static void nfs4_setup_readdir(u64 cooki
 	*p++ = xdr_one;                         /* bitmap length */
 	*p++ = htonl(FATTR4_WORD0_FILEID);             /* bitmap */
 	*p++ = htonl(8);              /* attribute buffer length */
-	p = xdr_encode_hyper(p, dentry->d_parent->d_inode->i_ino);
+	p = xdr_encode_hyper(p, NFS_FILEID(dentry->d_parent->d_inode));
 
 	readdir->pgbase = (char *)p - (char *)start;
 	readdir->count -= readdir->pgbase;
_

Patches currently in -mm which might be from staubach@redhat.com are

git-nfs.patch
