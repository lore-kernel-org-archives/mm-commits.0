From: akpm@linux-foundation.org
Subject: - knfsd-exportfs-add-procedural-interface-for-nfsd.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:04:09 -0700
Message-ID: <200707172304.l6HN49x3011778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38982 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936000AbXGQXQi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@infradead.org, hch@lst.de, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: exportfs: add procedural interface for NFSD
has been removed from the -mm tree.  Its filename was
     knfsd-exportfs-add-procedural-interface-for-nfsd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: exportfs: add procedural interface for NFSD
From: Christoph Hellwig <hch@infradead.org>

Currently NFSD calls directly into filesystems through the export_operations
structure.  I plan to change this interface in various ways in later patches,
and want to avoid the export of the default operations to NFSD, so this patch
adds two simple exportfs_encode_fh/exportfs_decode_fh helpers for NFSD to call
instead of poking into exportfs guts.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exportfs/expfs.c      |   22 +++++++++++++++++++++-
 fs/nfsd/nfsfh.c          |   18 +++++-------------
 include/linux/exportfs.h |    7 +++++++
 3 files changed, 33 insertions(+), 14 deletions(-)

diff -puN fs/exportfs/expfs.c~knfsd-exportfs-add-procedural-interface-for-nfsd fs/exportfs/expfs.c
--- a/fs/exportfs/expfs.c~knfsd-exportfs-add-procedural-interface-for-nfsd
+++ a/fs/exportfs/expfs.c
@@ -3,6 +3,7 @@
 #include <linux/fs.h>
 #include <linux/file.h>
 #include <linux/module.h>
+#include <linux/mount.h>
 #include <linux/namei.h>
 
 struct export_operations export_op_default;
@@ -468,6 +469,26 @@ static struct dentry *export_decode_fh(s
 				   acceptable, context);
 }
 
+int exportfs_encode_fh(struct dentry *dentry, __u32 *fh, int *max_len,
+		int connectable)
+{
+	struct export_operations *nop = dentry->d_sb->s_export_op;
+
+	return CALL(nop, encode_fh)(dentry, fh, max_len, connectable);
+}
+EXPORT_SYMBOL_GPL(exportfs_encode_fh);
+
+struct dentry *exportfs_decode_fh(struct vfsmount *mnt, __u32 *fh, int fh_len,
+		int fileid_type, int (*acceptable)(void *, struct dentry *),
+		void *context)
+{
+	struct export_operations *nop = mnt->mnt_sb->s_export_op;
+
+	return CALL(nop, decode_fh)(mnt->mnt_sb, fh, fh_len, fileid_type,
+			acceptable, context);
+}
+EXPORT_SYMBOL_GPL(exportfs_decode_fh);
+
 struct export_operations export_op_default = {
 	.decode_fh	= export_decode_fh,
 	.encode_fh	= export_encode_fh,
@@ -477,7 +498,6 @@ struct export_operations export_op_defau
 	.get_dentry	= get_dentry,
 };
 
-EXPORT_SYMBOL(export_op_default);
 EXPORT_SYMBOL(find_exported_dentry);
 
 MODULE_LICENSE("GPL");
diff -puN fs/nfsd/nfsfh.c~knfsd-exportfs-add-procedural-interface-for-nfsd fs/nfsd/nfsfh.c
--- a/fs/nfsd/nfsfh.c~knfsd-exportfs-add-procedural-interface-for-nfsd
+++ a/fs/nfsd/nfsfh.c
@@ -28,10 +28,6 @@
 static int nfsd_nr_verified;
 static int nfsd_nr_put;
 
-extern struct export_operations export_op_default;
-
-#define	CALL(ops,fun) ((ops->fun)?(ops->fun):export_op_default.fun)
-
 /*
  * our acceptability function.
  * if NOSUBTREECHECK, accept anything
@@ -212,11 +208,9 @@ fh_verify(struct svc_rqst *rqstp, struct
 		if (fileid_type == 0)
 			dentry = dget(exp->ex_dentry);
 		else {
-			struct export_operations *nop = exp->ex_mnt->mnt_sb->s_export_op;
-			dentry = CALL(nop,decode_fh)(exp->ex_mnt->mnt_sb,
-						     datap, data_left,
-						     fileid_type,
-						     nfsd_acceptable, exp);
+			dentry = exportfs_decode_fh(exp->ex_mnt, datap,
+					data_left, fileid_type,
+					nfsd_acceptable, exp);
 		}
 		if (dentry == NULL)
 			goto out;
@@ -287,15 +281,13 @@ out:
 static inline int _fh_update(struct dentry *dentry, struct svc_export *exp,
 			     __u32 *datap, int *maxsize)
 {
-	struct export_operations *nop = exp->ex_mnt->mnt_sb->s_export_op;
-
 	if (dentry == exp->ex_dentry) {
 		*maxsize = 0;
 		return 0;
 	}
 
-	return CALL(nop,encode_fh)(dentry, datap, maxsize,
-			  !(exp->ex_flags&NFSEXP_NOSUBTREECHECK));
+	return exportfs_encode_fh(dentry, datap, maxsize,
+			  !(exp->ex_flags & NFSEXP_NOSUBTREECHECK));
 }
 
 /*
diff -puN include/linux/exportfs.h~knfsd-exportfs-add-procedural-interface-for-nfsd include/linux/exportfs.h
--- a/include/linux/exportfs.h~knfsd-exportfs-add-procedural-interface-for-nfsd
+++ a/include/linux/exportfs.h
@@ -5,6 +5,7 @@
 
 struct dentry;
 struct super_block;
+struct vfsmount;
 
 
 /**
@@ -116,4 +117,10 @@ extern struct dentry *find_exported_dent
 	void *parent, int (*acceptable)(void *context, struct dentry *de),
 	void *context);
 
+extern int exportfs_encode_fh(struct dentry *dentry, __u32 *fh, int *max_len,
+	int connectable);
+extern struct dentry *exportfs_decode_fh(struct vfsmount *mnt, __u32 *fh,
+	int fh_len, int fileid_type, int (*acceptable)(void *, struct dentry *),
+	void *context);
+
 #endif /* LINUX_EXPORTFS_H */
_

Patches currently in -mm which might be from hch@infradead.org are

origin.patch
dvb_en_50221-convert-to-kthread-api.patch
git-vfs-lease-api.patch
git-xfs.patch
introduce-i_sync.patch
