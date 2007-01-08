From: akpm@osdl.org
Subject: + unionfs-handling-of-stale-inodes.patch added to -mm tree
Date: Mon, 08 Jan 2007 13:08:45 -0800
Message-ID: <200701082108.l08L8jE6018917@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43389 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbXAHVI6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 16:08:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jsipek@cs.sunysb.edu, dquigley@fsl.cs.sunysb.edu, ezk@cs.sunysb.edu


The patch titled
     unionfs: handling of stale inodes
has been added to the -mm tree.  Its filename is
     unionfs-handling-of-stale-inodes.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: unionfs: handling of stale inodes
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Provides nicer handling of stale inodes.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: David Quigley <dquigley@fsl.cs.sunysb.edu>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/unionfs/stale_inode.c |  112 +++++++++++++++++++++++++++++++++++++
 1 files changed, 112 insertions(+)

diff -puN /dev/null fs/unionfs/stale_inode.c
--- /dev/null
+++ a/fs/unionfs/stale_inode.c
@@ -0,0 +1,112 @@
+/*
+ *  Adpated from linux/fs/bad_inode.c
+ *
+ *  Copyright (C) 1997, Stephen Tweedie
+ *
+ *  Provide stub functions for "stale" inodes, a bit friendlier than the
+ *  -EIO that bad_inode.c does.
+ */
+
+#include <linux/version.h>
+
+#include <linux/fs.h>
+#include <linux/stat.h>
+#include <linux/sched.h>
+
+static struct address_space_operations unionfs_stale_aops;
+
+/* declarations for "sparse */
+extern struct inode_operations stale_inode_ops;
+
+/*
+ * The follow_link operation is special: it must behave as a no-op
+ * so that a stale root inode can at least be unmounted. To do this
+ * we must dput() the base and return the dentry with a dget().
+ */
+static void *stale_follow_link(struct dentry *dent, struct nameidata *nd)
+{
+	return ERR_PTR(vfs_follow_link(nd, ERR_PTR(-ESTALE)));
+}
+
+static int return_ESTALE(void)
+{
+	return -ESTALE;
+}
+
+#define ESTALE_ERROR ((void *) (return_ESTALE))
+
+static struct file_operations stale_file_ops = {
+	.llseek		= ESTALE_ERROR,
+	.read		= ESTALE_ERROR,
+	.write		= ESTALE_ERROR,
+	.readdir	= ESTALE_ERROR,
+	.poll		= ESTALE_ERROR,
+	.ioctl		= ESTALE_ERROR,
+	.mmap		= ESTALE_ERROR,
+	.open		= ESTALE_ERROR,
+	.flush		= ESTALE_ERROR,
+	.release	= ESTALE_ERROR,
+	.fsync		= ESTALE_ERROR,
+	.fasync		= ESTALE_ERROR,
+	.lock		= ESTALE_ERROR,
+};
+
+struct inode_operations stale_inode_ops = {
+	.create		= ESTALE_ERROR,
+	.lookup		= ESTALE_ERROR,
+	.link		= ESTALE_ERROR,
+	.unlink		= ESTALE_ERROR,
+	.symlink	= ESTALE_ERROR,
+	.mkdir		= ESTALE_ERROR,
+	.rmdir		= ESTALE_ERROR,
+	.mknod		= ESTALE_ERROR,
+	.rename		= ESTALE_ERROR,
+	.readlink	= ESTALE_ERROR,
+	.follow_link	= stale_follow_link,
+	.truncate	= ESTALE_ERROR,
+	.permission	= ESTALE_ERROR,
+};
+
+/*
+ * When a filesystem is unable to read an inode due to an I/O error in
+ * its read_inode() function, it can call make_stale_inode() to return a
+ * set of stubs which will return ESTALE errors as required.
+ *
+ * We only need to do limited initialisation: all other fields are
+ * preinitialised to zero automatically.
+ */
+
+/**
+ * make_stale_inode - mark an inode stale due to an I/O error
+ * @inode: Inode to mark stale
+ *
+ * When an inode cannot be read due to a media or remote network
+ * failure this function makes the inode "stale" and causes I/O operations
+ * on it to fail from this point on.
+ */
+void make_stale_inode(struct inode *inode)
+{
+	inode->i_mode = S_IFREG;
+	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	inode->i_op = &stale_inode_ops;
+	inode->i_fop = &stale_file_ops;
+	inode->i_mapping->a_ops = &unionfs_stale_aops;
+}
+
+/*
+ * This tests whether an inode has been flagged as stale. The test uses
+ * &stale_inode_ops to cover the case of invalidated inodes as well as
+ * those created by make_stale_inode() above.
+ */
+
+/**
+ * is_stale_inode - is an inode errored
+ * @inode: inode to test
+ *
+ * Returns true if the inode in question has been marked as stale.
+ */
+int is_stale_inode(struct inode *inode)
+{
+	return (inode->i_op == &stale_inode_ops);
+}
+
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

unionfs-documentation.patch
lookup_one_len_nd-lookup_one_len-with-nameidata-argument.patch
unionfs-branch-management-functionality.patch
unionfs-common-file-operations.patch
unionfs-copyup-functionality.patch
unionfs-dentry-operations.patch
unionfs-file-operations.patch
unionfs-directory-file-operations.patch
unionfs-directory-manipulation-helper-functions.patch
unionfs-inode-operations.patch
unionfs-lookup-helper-functions.patch
unionfs-main-module-functions.patch
unionfs-readdir-state.patch
unionfs-rename.patch
unionfs-privileged-operations-workqueue.patch
unionfs-handling-of-stale-inodes.patch
unionfs-miscellaneous-helper-functions.patch
unionfs-superblock-operations.patch
unionfs-helper-macros-inlines.patch
unionfs-internal-include-file.patch
unionfs-include-file.patch
unionfs-unlink.patch
unionfs-kconfig-and-makefile.patch
unionfs-extended-attributes-support.patch
