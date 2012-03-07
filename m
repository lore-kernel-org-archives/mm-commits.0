From: akpm@linux-foundation.org
Subject: + libfs-add-simple_open.patch added to -mm tree
Date: Tue, 06 Mar 2012 16:41:12 -0800
Message-ID: <20120307004113.3441FA0313@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:43025 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab2CGAlO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 19:41:14 -0500
Received: by yhgm50 with SMTP id m50so723045yhg.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 16:41:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sboyd@codeaurora.org, Julia.Lawall@lip6.fr, viro@zeniv.linux.org.uk


The patch titled
     Subject: libfs: add simple_open()
has been added to the -mm tree.  Its filename is
     libfs-add-simple_open.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2515,6 +2515,7 @@ extern int dcache_readdir(struct file *,
 extern int simple_setattr(struct dentry *, struct iattr *);
 extern int simple_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 extern int simple_statfs(struct dentry *, struct kstatfs *);
+extern int simple_open(struct inode *inode, struct file *file);
 extern int simple_link(struct dentry *, struct inode *, struct dentry *);
 extern int simple_unlink(struct inode *, struct dentry *);
 extern int simple_rmdir(struct inode *, struct dentry *);
_
Subject: Subject: libfs: add simple_open()

Patches currently in -mm which might be from sboyd@codeaurora.org are

origin.patch
linux-next.patch
libfs-add-simple_open.patch
coccinelle-semantic-patch-for-simple_open.patch

