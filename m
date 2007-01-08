From: akpm@osdl.org
Subject: - unionfs-branch-management-functionality.patch removed from -mm tree
Date: Mon, 08 Jan 2007 13:09:34 -0800
Message-ID: <200701082109.l08L9Y2P018969@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43534 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbXAHVJp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 16:09:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, dquigley@fsl.cs.sunysb.edu, ezk@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     unionfs: branch management functionality
has been removed from the -mm tree.  Its filename was
     unionfs-branch-management-functionality.patch

This patch was dropped because I'll use the git tree

------------------------------------------------------
Subject: unionfs: branch management functionality
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

The ioctls to increase the union generation and to query which branch a file
exists on.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: David Quigley <dquigley@fsl.cs.sunysb.edu>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/unionfs/branchman.c |   81 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 81 insertions(+)

diff -puN /dev/null fs/unionfs/branchman.c
--- /dev/null
+++ a/fs/unionfs/branchman.c
@@ -0,0 +1,81 @@
+/*
+ * Copyright (c) 2003-2006 Erez Zadok
+ * Copyright (c) 2003-2006 Charles P. Wright
+ * Copyright (c) 2005-2006 Josef 'Jeff' Sipek
+ * Copyright (c) 2005-2006 Junjiro Okajima
+ * Copyright (c) 2005      Arun M. Krishnakumar
+ * Copyright (c) 2004-2006 David P. Quigley
+ * Copyright (c) 2003-2004 Mohammad Nayyer Zubair
+ * Copyright (c) 2003      Puja Gupta
+ * Copyright (c) 2003      Harikesavan Krishnan
+ * Copyright (c) 2003-2006 Stony Brook University
+ * Copyright (c) 2003-2006 The Research Foundation of State University of New York
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "union.h"
+
+/* increase the superblock generation count; effectively invalidating every
+ * upper inode, dentry and file object */
+int unionfs_ioctl_incgen(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct super_block *sb;
+	int gen;
+
+	sb = file->f_dentry->d_sb;
+
+	unionfs_write_lock(sb);
+
+	gen = atomic_inc_return(&UNIONFS_SB(sb)->generation);
+
+	atomic_set(&UNIONFS_D(sb->s_root)->generation, gen);
+	atomic_set(&UNIONFS_I(sb->s_root->d_inode)->generation, gen);
+
+	unionfs_write_unlock(sb);
+
+	return gen;
+}
+
+/* return to userspace the branch indices containing the file in question
+ *
+ * We use fd_set and therefore we are limited to the number of the branches
+ * to FD_SETSIZE, which is currently 1024 - plenty for most people
+ */
+int unionfs_ioctl_queryfile(struct file *file, unsigned int cmd,
+			    unsigned long arg)
+{
+	int err = 0;
+	fd_set branchlist;
+
+	int bstart = 0, bend = 0, bindex = 0;
+	struct dentry *dentry, *hidden_dentry;
+
+	dentry = file->f_dentry;
+	lock_dentry(dentry);
+	if ((err = unionfs_partial_lookup(dentry)))
+		goto out;
+	bstart = dbstart(dentry);
+	bend = dbend(dentry);
+
+	FD_ZERO(&branchlist);
+
+	for (bindex = bstart; bindex <= bend; bindex++) {
+		hidden_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+		if (!hidden_dentry)
+			continue;
+		if (hidden_dentry->d_inode)
+			FD_SET(bindex, &branchlist);
+	}
+
+	err = copy_to_user((void __user *)arg, &branchlist, sizeof(fd_set));
+	if (err)
+		err = -EFAULT;
+
+out:
+	unlock_dentry(dentry);
+	return err < 0 ? err : bend;
+}
+
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

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
