From: akpm@linux-foundation.org
Subject: [merged] fs-exportfs-add-exportfs_encode_inode_fh-helper.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:12:43 -0800
Message-ID: <20121218201243.BC55A100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:33675 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab2LRUMp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:12:45 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so126264vcd.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:12:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, avagin@openvz.org, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, oleg@redhat.com, tvrtko.ursulin@onelan.co.uk, viro@ZenIV.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, exportfs: add exportfs_encode_inode_fh() helper
has been removed from the -mm tree.  Its filename was
     fs-exportfs-add-exportfs_encode_inode_fh-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: fs, exportfs: add exportfs_encode_inode_fh() helper

We will need this helper in the next patch to provide a file handle for
inotify marks in /proc/pid/fdinfo output.

The patch is rather providing the way to use inodes directly when dentry
is not available (like in case of inotify system).

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: James Bottomley <jbottomley@parallels.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Matthew Helsley <matt.helsley@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exportfs/expfs.c      |   19 ++++++++++++++-----
 include/linux/exportfs.h |    2 ++
 2 files changed, 16 insertions(+), 5 deletions(-)

diff -puN fs/exportfs/expfs.c~fs-exportfs-add-exportfs_encode_inode_fh-helper fs/exportfs/expfs.c
--- a/fs/exportfs/expfs.c~fs-exportfs-add-exportfs_encode_inode_fh-helper
+++ a/fs/exportfs/expfs.c
@@ -341,10 +341,21 @@ static int export_encode_fh(struct inode
 	return type;
 }
 
+int exportfs_encode_inode_fh(struct inode *inode, struct fid *fid,
+			     int *max_len, struct inode *parent)
+{
+	const struct export_operations *nop = inode->i_sb->s_export_op;
+
+	if (nop && nop->encode_fh)
+		return nop->encode_fh(inode, fid->raw, max_len, parent);
+
+	return export_encode_fh(inode, fid, max_len, parent);
+}
+EXPORT_SYMBOL_GPL(exportfs_encode_inode_fh);
+
 int exportfs_encode_fh(struct dentry *dentry, struct fid *fid, int *max_len,
 		int connectable)
 {
-	const struct export_operations *nop = dentry->d_sb->s_export_op;
 	int error;
 	struct dentry *p = NULL;
 	struct inode *inode = dentry->d_inode, *parent = NULL;
@@ -357,10 +368,8 @@ int exportfs_encode_fh(struct dentry *de
 		 */
 		parent = p->d_inode;
 	}
-	if (nop && nop->encode_fh)
-		error = nop->encode_fh(inode, fid->raw, max_len, parent);
-	else
-		error = export_encode_fh(inode, fid, max_len, parent);
+
+	error = exportfs_encode_inode_fh(inode, fid, max_len, parent);
 	dput(p);
 
 	return error;
diff -puN include/linux/exportfs.h~fs-exportfs-add-exportfs_encode_inode_fh-helper include/linux/exportfs.h
--- a/include/linux/exportfs.h~fs-exportfs-add-exportfs_encode_inode_fh-helper
+++ a/include/linux/exportfs.h
@@ -177,6 +177,8 @@ struct export_operations {
 	int (*commit_metadata)(struct inode *inode);
 };
 
+extern int exportfs_encode_inode_fh(struct inode *inode, struct fid *fid,
+				    int *max_len, struct inode *parent);
 extern int exportfs_encode_fh(struct dentry *dentry, struct fid *fid,
 	int *max_len, int connectable);
 extern struct dentry *exportfs_decode_fh(struct vfsmount *mnt, struct fid *fid,
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
linux-next.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch

