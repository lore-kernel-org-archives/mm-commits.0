From: akpm@osdl.org
Subject: + nfs-kill-the-obsolete-nfs_paranoia.patch added to -mm tree
Date: Wed, 20 Dec 2006 20:23:52 -0800
Message-ID: <200612210423.kBL4NqfL015455@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36537 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422695AbWLUEX7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 23:23:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com, Trond.Myklebust@netapp.com


The patch titled
     NFS: Kill the obsolete NFS_PARANOIA
has been added to the -mm tree.  Its filename is
     nfs-kill-the-obsolete-nfs_paranoia.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NFS: Kill the obsolete NFS_PARANOIA
From: Jesper Juhl <jesper.juhl@gmail.com>

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfs/dir.c      |   17 ++---------------
 fs/nfs/getroot.c  |    1 -
 fs/nfs/inode.c    |    3 ---
 fs/nfs/nfs2xdr.c  |    1 -
 fs/nfs/pagelist.c |    7 -------
 5 files changed, 2 insertions(+), 27 deletions(-)

diff -puN fs/nfs/dir.c~nfs-kill-the-obsolete-nfs_paranoia fs/nfs/dir.c
--- a/fs/nfs/dir.c~nfs-kill-the-obsolete-nfs_paranoia
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
 
diff -puN fs/nfs/getroot.c~nfs-kill-the-obsolete-nfs_paranoia fs/nfs/getroot.c
--- a/fs/nfs/getroot.c~nfs-kill-the-obsolete-nfs_paranoia
+++ a/fs/nfs/getroot.c
@@ -42,7 +42,6 @@
 #include "internal.h"
 
 #define NFSDBG_FACILITY		NFSDBG_CLIENT
-#define NFS_PARANOIA 1
 
 /*
  * get an NFS2/NFS3 root dentry from the root filehandle
diff -puN fs/nfs/inode.c~nfs-kill-the-obsolete-nfs_paranoia fs/nfs/inode.c
--- a/fs/nfs/inode.c~nfs-kill-the-obsolete-nfs_paranoia
+++ a/fs/nfs/inode.c
@@ -48,7 +48,6 @@
 #include "internal.h"
 
 #define NFSDBG_FACILITY		NFSDBG_VFS
-#define NFS_PARANOIA 1
 
 static void nfs_invalidate_inode(struct inode *);
 static int nfs_update_inode(struct inode *, struct nfs_fattr *);
@@ -1021,10 +1020,8 @@ static int nfs_update_inode(struct inode
 	/*
 	 * Big trouble! The inode has become a different object.
 	 */
-#ifdef NFS_PARANOIA
 	printk(KERN_DEBUG "%s: inode %ld mode changed, %07o to %07o\n",
 			__FUNCTION__, inode->i_ino, inode->i_mode, fattr->mode);
-#endif
  out_err:
 	/*
 	 * No need to worry about unhashing the dentry, as the
diff -puN fs/nfs/nfs2xdr.c~nfs-kill-the-obsolete-nfs_paranoia fs/nfs/nfs2xdr.c
--- a/fs/nfs/nfs2xdr.c~nfs-kill-the-obsolete-nfs_paranoia
+++ a/fs/nfs/nfs2xdr.c
@@ -26,7 +26,6 @@
 #include "internal.h"
 
 #define NFSDBG_FACILITY		NFSDBG_XDR
-/* #define NFS_PARANOIA 1 */
 
 /* Mapping from NFS error code to "errno" error code. */
 #define errno_NFSERR_IO		EIO
diff -puN fs/nfs/pagelist.c~nfs-kill-the-obsolete-nfs_paranoia fs/nfs/pagelist.c
--- a/fs/nfs/pagelist.c~nfs-kill-the-obsolete-nfs_paranoia
+++ a/fs/nfs/pagelist.c
@@ -19,8 +19,6 @@
 #include <linux/nfs_mount.h>
 #include <linux/writeback.h>
 
-#define NFS_PARANOIA 1
-
 static struct kmem_cache *nfs_page_cachep;
 
 static inline struct nfs_page *
@@ -172,11 +170,6 @@ nfs_release_request(struct nfs_page *req
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
nfs-kill-the-obsolete-nfs_paranoia.patch
debug-shared-irqs.patch

