From: akpm@osdl.org
Subject: - nfs-kill-obsolete-nfs_paranoia.patch removed from -mm tree
Date: Tue, 19 Dec 2006 13:29:18 -0800
Message-ID: <200612192129.kBJLTLLq011363@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37333 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932952AbWLSV3f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Dec 2006 16:29:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     NFS: Kill obsolete NFS_PARANOIA
has been removed from the -mm tree.  Its filename was
     nfs-kill-obsolete-nfs_paranoia.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: NFS: Kill obsolete NFS_PARANOIA
From: Jesper Juhl <jesper.juhl@gmail.com>

Remove obsolete NFS_PARANOIA.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfs/dir.c      |   17 ++---------------
 fs/nfs/inode.c    |   11 +----------
 fs/nfs/nfs2xdr.c  |    1 -
 fs/nfs/pagelist.c |    6 ------
 4 files changed, 3 insertions(+), 32 deletions(-)

diff -puN fs/nfs/dir.c~nfs-kill-obsolete-nfs_paranoia fs/nfs/dir.c
--- a/fs/nfs/dir.c~nfs-kill-obsolete-nfs_paranoia
+++ a/fs/nfs/dir.c
@@ -38,7 +38,6 @@
 #include "delegation.h"
 #include "iostat.h"
 
-#define NFS_PARANOIA 1
 /* #define NFS_DEBUG_VERBOSE 1 */
 
 static int nfs_opendir(struct inode *, struct file *);
@@ -1322,11 +1321,6 @@ static int nfs_sillyrename(struct inode 
 		atomic_read(&dentry->d_count));
 	nfs_inc_stats(dir, NFSIOS_SILLYRENAME);
 
-#ifdef NFS_PARANOIA
-if (!dentry->d_inode)
-printk("NFS: silly-renaming %s/%s, negative dentry??\n",
-dentry->d_parent->d_name.name, dentry->d_name.name);
-#endif
 	/*
 	 * We don't allow a dentry to be silly-renamed twice.
 	 */
@@ -1641,16 +1635,9 @@ static int nfs_rename(struct inode *old_
 			new_inode = NULL;
 			/* instantiate the replacement target */
 			d_instantiate(new_dentry, NULL);
-		} else if (atomic_read(&new_dentry->d_count) > 1) {
-		/* dentry still busy? */
-#ifdef NFS_PARANOIA
-			printk("nfs_rename: target %s/%s busy, d_count=%d\n",
-			       new_dentry->d_parent->d_name.name,
-			       new_dentry->d_name.name,
-			       atomic_read(&new_dentry->d_count));
-#endif
+		} else if (atomic_read(&new_dentry->d_count) > 1)
+			/* dentry still busy? */
 			goto out;
-		}
 	} else
 		drop_nlink(new_inode);
 
diff -puN fs/nfs/inode.c~nfs-kill-obsolete-nfs_paranoia fs/nfs/inode.c
--- a/fs/nfs/inode.c~nfs-kill-obsolete-nfs_paranoia
+++ a/fs/nfs/inode.c
@@ -48,7 +48,6 @@
 #include "internal.h"
 
 #define NFSDBG_FACILITY		NFSDBG_VFS
-#define NFS_PARANOIA 1
 
 static void nfs_invalidate_inode(struct inode *);
 static int nfs_update_inode(struct inode *, struct nfs_fattr *);
@@ -910,7 +909,7 @@ static int nfs_update_inode(struct inode
 	 * Make sure the inode's type hasn't changed.
 	 */
 	if ((inode->i_mode & S_IFMT) != (fattr->mode & S_IFMT))
-		goto out_changed;
+		goto out_err;
 
 	server = NFS_SERVER(inode);
 	/* Update the fsid if and only if this is the root directory */
@@ -1018,14 +1017,6 @@ static int nfs_update_inode(struct inode
 		nfsi->cache_validity |= invalid;
 
 	return 0;
- out_changed:
-	/*
-	 * Big trouble! The inode has become a different object.
-	 */
-#ifdef NFS_PARANOIA
-	printk(KERN_DEBUG "%s: inode %ld mode changed, %07o to %07o\n",
-			__FUNCTION__, inode->i_ino, inode->i_mode, fattr->mode);
-#endif
  out_err:
 	/*
 	 * No need to worry about unhashing the dentry, as the
diff -puN fs/nfs/nfs2xdr.c~nfs-kill-obsolete-nfs_paranoia fs/nfs/nfs2xdr.c
--- a/fs/nfs/nfs2xdr.c~nfs-kill-obsolete-nfs_paranoia
+++ a/fs/nfs/nfs2xdr.c
@@ -26,7 +26,6 @@
 #include "internal.h"
 
 #define NFSDBG_FACILITY		NFSDBG_XDR
-/* #define NFS_PARANOIA 1 */
 
 /* Mapping from NFS error code to "errno" error code. */
 #define errno_NFSERR_IO		EIO
diff -puN fs/nfs/pagelist.c~nfs-kill-obsolete-nfs_paranoia fs/nfs/pagelist.c
--- a/fs/nfs/pagelist.c~nfs-kill-obsolete-nfs_paranoia
+++ a/fs/nfs/pagelist.c
@@ -18,7 +18,6 @@
 #include <linux/nfs_fs.h>
 #include <linux/nfs_mount.h>
 
-#define NFS_PARANOIA 1
 
 static kmem_cache_t *nfs_page_cachep;
 
@@ -171,11 +170,6 @@ nfs_release_request(struct nfs_page *req
 	if (!atomic_dec_and_test(&req->wb_count))
 		return;
 
-#ifdef NFS_PARANOIA
-	BUG_ON (!list_empty(&req->wb_list));
-	BUG_ON (NFS_WBACK_BUSY(req));
-#endif
-
 	/* Release struct file or cached credential */
 	nfs_clear_request(req);
 	put_nfs_open_context(req->wb_context);
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

git-acpi.patch
nfs-kill-obsolete-nfs_paranoia.patch
debug-shared-irqs.patch

