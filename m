From: akpm@linux-foundation.org
Subject: [withdrawn] nfs-inotify-inotify-user-when-deleting-files-on-nfs.patch removed from -mm tree
Date: Wed, 04 Apr 2012 16:49:18 -0700
Message-ID: <20120404234918.BCF4BA038B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:40905 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab2DDXtU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Apr 2012 19:49:20 -0400
Received: by wejx9 with SMTP id x9so40857wej.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Apr 2012 16:49:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maxim.uvarov@oracle.com, bharrosh@panasas.com, chuck.lever@oracle.com, eparis@redhat.com, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: nfs/inotify: inotify user when deleting files on nfs
has been removed from the -mm tree.  Its filename was
     nfs-inotify-inotify-user-when-deleting-files-on-nfs.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Maxim Uvarov <maxim.uvarov@oracle.com>
Subject: nfs/inotify: inotify user when deleting files on nfs

This issue was introduced with LTP inotify02 test.  If file system is not
NFS user inotify application gets IN_DELETE event.  But on NFS code avoids
d_delete() which sends this event.  This patch makes notification on NFS
the same as non-NFS.  I.e.  vfs_unlink still avoids deletion but it sends
event for NFS sillyrenamed files.

More details here: https://lkml.org/lkml/2011/11/29/421

Signed-off-by: Maxim Uvarov <maxim.uvarov@oracle.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff -puN fs/namei.c~nfs-inotify-inotify-user-when-deleting-files-on-nfs fs/namei.c
--- a/fs/namei.c~nfs-inotify-inotify-user-when-deleting-files-on-nfs
+++ a/fs/namei.c
@@ -2850,10 +2850,23 @@ int vfs_unlink(struct inode *dir, struct
 	}
 	mutex_unlock(&dentry->d_inode->i_mutex);
 
-	/* We don't d_delete() NFS sillyrenamed files--they still exist. */
-	if (!error && !(dentry->d_flags & DCACHE_NFSFS_RENAMED)) {
+
+	if (!error) {
 		fsnotify_link_count(dentry->d_inode);
-		d_delete(dentry);
+		if (!(dentry->d_flags & DCACHE_NFSFS_RENAMED))
+			d_delete(dentry);
+		else {
+			/* We don't d_delete() NFS sillyrenamed files - they
+			 * still exist. But from user side this file was
+			 * deleted. So that we need to generate notify event
+			 * about it.
+			 */
+			struct inode *inode;
+			int isdir;
+			inode = dentry->d_inode;
+			isdir = S_ISDIR(inode->i_mode);
+			fsnotify_nameremove(dentry, isdir);
+		}
 	}
 
 	return error;
_

Patches currently in -mm which might be from maxim.uvarov@oracle.com are


