From: akpm@linux-foundation.org
Subject: + nfs-inotify-inotify-user-when-deleting-files-on-nfs.patch added to -mm tree
Date: Wed, 04 Apr 2012 15:52:36 -0700
Message-ID: <20120404225236.777B7A0341@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:56507 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757350Ab2DDWwj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Apr 2012 18:52:39 -0400
Received: by wejx9 with SMTP id x9so39592wej.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Apr 2012 15:52:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maxim.uvarov@oracle.com, bharrosh@panasas.com, chuck.lever@oracle.com, eparis@redhat.com, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk


The patch titled
     Subject: nfs/inotify: inotify user when deleting files on nfs
has been added to the -mm tree.  Its filename is
     nfs-inotify-inotify-user-when-deleting-files-on-nfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: nfs/inotify: inotify user when deleting files on nfs

Patches currently in -mm which might be from maxim.uvarov@oracle.com are

nfs-inotify-inotify-user-when-deleting-files-on-nfs.patch
nfs-inotify-inotify-user-when-deleting-files-on-nfs-fix.patch

