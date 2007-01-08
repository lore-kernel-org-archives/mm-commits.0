From: akpm@osdl.org
Subject: - unionfs-unlink.patch removed from -mm tree
Date: Mon, 08 Jan 2007 13:10:18 -0800
Message-ID: <200701082110.l08LAI4L019063@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43640 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbXAHVKg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 16:10:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, dquigley@fsl.cs.sunysb.edu, ezk@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     unionfs: unlink
has been removed from the -mm tree.  Its filename was
     unionfs-unlink.patch

This patch was dropped because I'll use the git tree

------------------------------------------------------
Subject: unionfs: unlink
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Unlink functionality for Unionfs.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: David Quigley <dquigley@fsl.cs.sunysb.edu>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/unionfs/unlink.c |  162 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 162 insertions(+)

diff -puN /dev/null fs/unionfs/unlink.c
--- /dev/null
+++ a/fs/unionfs/unlink.c
@@ -0,0 +1,162 @@
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
+/* unlink a file by creating a whiteout */
+static int unionfs_unlink_whiteout(struct inode *dir, struct dentry *dentry)
+{
+	struct dentry *hidden_dentry;
+	struct dentry *hidden_dir_dentry;
+	int bindex;
+	int err = 0;
+
+	if ((err = unionfs_partial_lookup(dentry)))
+		goto out;
+
+	bindex = dbstart(dentry);
+
+	hidden_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+	if (!hidden_dentry)
+		goto out;
+
+	hidden_dir_dentry = lock_parent(hidden_dentry);
+
+	/* avoid destroying the hidden inode if the file is in use */
+	dget(hidden_dentry);
+	if (!(err = is_robranch_super(dentry->d_sb, bindex)))
+		err = vfs_unlink(hidden_dir_dentry->d_inode, hidden_dentry);
+	dput(hidden_dentry);
+	fsstack_copy_attr_times(dir, hidden_dir_dentry->d_inode);
+	unlock_dir(hidden_dir_dentry);
+
+	if (err && !IS_COPYUP_ERR(err))
+		goto out;
+
+	if (err) {
+		if (dbstart(dentry) == 0)
+			goto out;
+
+		err = create_whiteout(dentry, dbstart(dentry) - 1);
+	} else if (dbopaque(dentry) != -1)
+		/* There is a hidden lower-priority file with the same name. */
+		err = create_whiteout(dentry, dbopaque(dentry));
+	else
+		err = create_whiteout(dentry, dbstart(dentry));
+
+out:
+	if (!err)
+		dentry->d_inode->i_nlink--;
+
+	/* We don't want to leave negative leftover dentries for revalidate. */
+	if (!err && (dbopaque(dentry) != -1))
+		update_bstart(dentry);
+
+	return err;
+}
+
+int unionfs_unlink(struct inode *dir, struct dentry *dentry)
+{
+	int err = 0;
+
+	lock_dentry(dentry);
+
+	err = unionfs_unlink_whiteout(dir, dentry);
+	/* call d_drop so the system "forgets" about us */
+	if (!err)
+		d_drop(dentry);
+
+	unlock_dentry(dentry);
+	return err;
+}
+
+static int unionfs_rmdir_first(struct inode *dir, struct dentry *dentry,
+			       struct unionfs_dir_state *namelist)
+{
+	int err;
+	struct dentry *hidden_dentry;
+	struct dentry *hidden_dir_dentry = NULL;
+
+	/* Here we need to remove whiteout entries. */
+	err = delete_whiteouts(dentry, dbstart(dentry), namelist);
+	if (err)
+		goto out;
+
+	hidden_dentry = unionfs_lower_dentry(dentry);
+
+	hidden_dir_dentry = lock_parent(hidden_dentry);
+
+	/* avoid destroying the hidden inode if the file is in use */
+	dget(hidden_dentry);
+	if (!(err = is_robranch(dentry)))
+		err = vfs_rmdir(hidden_dir_dentry->d_inode, hidden_dentry);
+	dput(hidden_dentry);
+
+	fsstack_copy_attr_times(dir, hidden_dir_dentry->d_inode);
+	/* propagate number of hard-links */
+	dentry->d_inode->i_nlink = unionfs_get_nlinks(dentry->d_inode);
+
+out:
+	if (hidden_dir_dentry)
+		unlock_dir(hidden_dir_dentry);
+	return err;
+}
+
+int unionfs_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	int err = 0;
+	struct unionfs_dir_state *namelist = NULL;
+
+	lock_dentry(dentry);
+
+	/* check if this unionfs directory is empty or not */
+	err = check_empty(dentry, &namelist);
+	if (err)
+		goto out;
+
+	err = unionfs_rmdir_first(dir, dentry, namelist);
+	/* create whiteout */
+	if (!err)
+		err = create_whiteout(dentry, dbstart(dentry));
+	else {
+		int new_err;
+
+		if (dbstart(dentry) == 0)
+			goto out;
+
+		/* exit if the error returned was NOT -EROFS */
+		if (!IS_COPYUP_ERR(err))
+			goto out;
+
+		new_err = create_whiteout(dentry, dbstart(dentry) - 1);
+		if (new_err != -EEXIST)
+			err = new_err;
+	}
+
+out:
+	/* call d_drop so the system "forgets" about us */
+	if (!err)
+		d_drop(dentry);
+
+	if (namelist)
+		free_rdstate(namelist);
+
+	unlock_dentry(dentry);
+	return err;
+}
+
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

unionfs-unlink.patch
unionfs-kconfig-and-makefile.patch
unionfs-extended-attributes-support.patch
