From: akpm@osdl.org
Subject: - unionfs-privileged-operations-workqueue.patch removed from -mm tree
Date: Mon, 08 Jan 2007 13:10:02 -0800
Message-ID: <200701082110.l08LA3qt019037@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43615 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbXAHVKT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 16:10:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, dquigley@fsl.cs.sunysb.edu, ezk@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     unionfs: privileged operations workqueue
has been removed from the -mm tree.  Its filename was
     unionfs-privileged-operations-workqueue.patch

This patch was dropped because I'll use the git tree

------------------------------------------------------
Subject: unionfs: privileged operations workqueue
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Workqueue & helper functions used to perform privileged operations on behalf
of the user process.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: David Quigley <dquigley@fsl.cs.sunysb.edu>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/unionfs/sioq.c |  122 ++++++++++++++++++++++++++++++++++++++++++++
 fs/unionfs/sioq.h |   79 ++++++++++++++++++++++++++++
 2 files changed, 201 insertions(+)

diff -puN /dev/null fs/unionfs/sioq.c
--- /dev/null
+++ a/fs/unionfs/sioq.c
@@ -0,0 +1,122 @@
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
+/* Super-user IO work Queue - sometimes we need to perform actions which
+ * would fail due to the unix permissions on the parent directory (e.g.,
+ * rmdir a directory which appears empty, but in reality contains
+ * whiteouts).
+ */
+
+struct workqueue_struct *sioq;
+
+int __init init_sioq(void)
+{
+	int err;
+
+	sioq = create_workqueue("unionfs_siod");
+	if (!IS_ERR(sioq))
+		return 0;
+
+	err = PTR_ERR(sioq);
+	printk(KERN_ERR "create_workqueue failed %d\n", err);
+	sioq = NULL;
+	return err;
+}
+
+void __exit stop_sioq(void)
+{
+	if (sioq)
+		destroy_workqueue(sioq);
+}
+
+void run_sioq(work_func_t func, struct sioq_args *args)
+{
+	INIT_WORK(&args->work, func);
+
+	init_completion(&args->comp);
+	while (!queue_work(sioq, &args->work)) {
+		/* TODO: do accounting if needed */
+		schedule();
+	}
+	wait_for_completion(&args->comp);
+}
+
+void __unionfs_create(struct work_struct *work)
+{
+	struct sioq_args *args = container_of(work, struct sioq_args, work);
+	struct create_args *c = &args->create;
+
+	args->err = vfs_create(c->parent, c->dentry, c->mode, c->nd);
+	complete(&args->comp);
+}
+
+void __unionfs_mkdir(struct work_struct *work)
+{
+	struct sioq_args *args = container_of(work, struct sioq_args, work);
+	struct mkdir_args *m = &args->mkdir;
+
+	args->err = vfs_mkdir(m->parent, m->dentry, m->mode);
+	complete(&args->comp);
+}
+
+void __unionfs_mknod(struct work_struct *work)
+{
+	struct sioq_args *args = container_of(work, struct sioq_args, work);
+	struct mknod_args *m = &args->mknod;
+
+	args->err = vfs_mknod(m->parent, m->dentry, m->mode, m->dev);
+	complete(&args->comp);
+}
+
+void __unionfs_symlink(struct work_struct *work)
+{
+	struct sioq_args *args = container_of(work, struct sioq_args, work);
+	struct symlink_args *s = &args->symlink;
+
+	args->err = vfs_symlink(s->parent, s->dentry, s->symbuf, s->mode);
+	complete(&args->comp);
+}
+
+void __unionfs_unlink(struct work_struct *work)
+{
+	struct sioq_args *args = container_of(work, struct sioq_args, work);
+	struct unlink_args *u = &args->unlink;
+
+	args->err = vfs_unlink(u->parent, u->dentry);
+	complete(&args->comp);
+}
+
+void __delete_whiteouts(struct work_struct *work) {
+	struct sioq_args *args = container_of(work, struct sioq_args, work);
+	struct deletewh_args *d = &args->deletewh;
+
+	args->err = do_delete_whiteouts(d->dentry, d->bindex, d->namelist);
+	complete(&args->comp);
+}
+
+void __is_opaque_dir(struct work_struct *work)
+{
+	struct sioq_args *args = container_of(work, struct sioq_args, work);
+
+	args->ret = lookup_one_len(UNIONFS_DIR_OPAQUE, args->is_opaque.dentry,
+				sizeof(UNIONFS_DIR_OPAQUE) - 1);
+	complete(&args->comp);
+}
+
diff -puN /dev/null fs/unionfs/sioq.h
--- /dev/null
+++ a/fs/unionfs/sioq.h
@@ -0,0 +1,79 @@
+#ifndef _SIOQ_H
+#define _SIOQ_H
+
+struct deletewh_args {
+	struct unionfs_dir_state *namelist;
+	struct dentry *dentry;
+	int bindex;
+};
+
+struct is_opaque_args {
+	struct dentry *dentry;
+};
+
+struct create_args {
+	struct inode *parent;
+	struct dentry *dentry;
+	umode_t mode;
+	struct nameidata *nd;
+};
+
+struct mkdir_args {
+	struct inode *parent;
+	struct dentry *dentry;
+	umode_t mode;
+};
+
+struct mknod_args {
+	struct inode *parent;
+	struct dentry *dentry;
+	umode_t mode;
+	dev_t dev;
+};
+
+struct symlink_args {
+	struct inode *parent;
+	struct dentry *dentry;
+	char *symbuf;
+	umode_t mode;
+};
+
+struct unlink_args {
+	struct inode *parent;
+	struct dentry *dentry;
+};
+
+
+struct sioq_args {
+	struct completion comp;
+	struct work_struct work;
+	int err;
+	void *ret;
+
+	union {
+		struct deletewh_args deletewh;
+		struct is_opaque_args is_opaque;
+		struct create_args create;
+		struct mkdir_args mkdir;
+		struct mknod_args mknod;
+		struct symlink_args symlink;
+		struct unlink_args unlink;
+	};
+};
+
+extern struct workqueue_struct *sioq;
+extern int __init init_sioq(void);
+extern __exit void stop_sioq(void);
+extern void run_sioq(work_func_t func, struct sioq_args *args);
+
+/* Extern definitions for our privlege escalation helpers */
+extern void __unionfs_create(struct work_struct *work);
+extern void __unionfs_mkdir(struct work_struct *work);
+extern void __unionfs_mknod(struct work_struct *work);
+extern void __unionfs_symlink(struct work_struct *work);
+extern void __unionfs_unlink(struct work_struct *work);
+extern void __delete_whiteouts(struct work_struct *work);
+extern void __is_opaque_dir(struct work_struct *work);
+
+#endif /* _SIOQ_H */
+
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

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
