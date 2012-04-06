From: akpm@linux-foundation.org
Subject: [merged] libfs-add-simple_open.patch removed from -mm tree
Date: Fri, 06 Apr 2012 11:48:57 -0700
Message-ID: <20120406184857.807C2A0443@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:39661 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab2DFStA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Apr 2012 14:49:00 -0400
Received: by lboi15 with SMTP id i15so55682lbo.1
        for <mm-commits@vger.kernel.org>; Fri, 06 Apr 2012 11:48:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sboyd@codeaurora.org, Julia.Lawall@lip6.fr, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: libfs: add simple_open()
has been removed from the -mm tree.  Its filename was
     libfs-add-simple_open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Stephen Boyd <sboyd@codeaurora.org>
Subject: libfs: add simple_open()

debugfs and a few other drivers use an open-coded version of simple_open()
to pass a pointer from the file to the read/write file ops.  Add support
for this simple case to libfs so that we can remove the many duplicate
copies of this simple function.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c         |    8 ++++++++
 include/linux/fs.h |    1 +
 2 files changed, 9 insertions(+)

diff -puN fs/libfs.c~libfs-add-simple_open fs/libfs.c
--- a/fs/libfs.c~libfs-add-simple_open
+++ a/fs/libfs.c
@@ -264,6 +264,13 @@ Enomem:
 	return ERR_PTR(-ENOMEM);
 }
 
+int simple_open(struct inode *inode, struct file *file)
+{
+	if (inode->i_private)
+		file->private_data = inode->i_private;
+	return 0;
+}
+
 int simple_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = old_dentry->d_inode;
@@ -984,6 +991,7 @@ EXPORT_SYMBOL(simple_dir_operations);
 EXPORT_SYMBOL(simple_empty);
 EXPORT_SYMBOL(simple_fill_super);
 EXPORT_SYMBOL(simple_getattr);
+EXPORT_SYMBOL(simple_open);
 EXPORT_SYMBOL(simple_link);
 EXPORT_SYMBOL(simple_lookup);
 EXPORT_SYMBOL(simple_pin_fs);
diff -puN include/linux/fs.h~libfs-add-simple_open include/linux/fs.h
--- a/include/linux/fs.h~libfs-add-simple_open
+++ a/include/linux/fs.h
@@ -2506,6 +2506,7 @@ extern int dcache_readdir(struct file *,
 extern int simple_setattr(struct dentry *, struct iattr *);
 extern int simple_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 extern int simple_statfs(struct dentry *, struct kstatfs *);
+extern int simple_open(struct inode *inode, struct file *file);
 extern int simple_link(struct dentry *, struct inode *, struct dentry *);
 extern int simple_unlink(struct inode *, struct dentry *);
 extern int simple_rmdir(struct inode *, struct dentry *);
_

Patches currently in -mm which might be from sboyd@codeaurora.org are

origin.patch

