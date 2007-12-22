From: akpm@linux-foundation.org
Subject: + udf-remove-wrong-prototype-of-udf_readdir.patch added to -mm tree
Date: Fri, 21 Dec 2007 16:22:58 -0800
Message-ID: <200712220022.lBM0MwLN006476@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33611 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757458AbXLVAXK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 19:23:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, jack@suse.cz


The patch titled
     udf: remove wrong prototype of udf_readdir
has been added to the -mm tree.  Its filename is
     udf-remove-wrong-prototype-of-udf_readdir.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: udf: remove wrong prototype of udf_readdir
From: Marcin Slusarz <marcin.slusarz@gmail.com>

sparse generated:
fs/udf/dir.c:78:5: warning: symbol 'udf_readdir' was not declared. Should it be static?
there are 2 different prototypes of udf_readdir - remove them and move
code around to make it still compile

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/dir.c |  118 +++++++++++++++++++++++--------------------------
 1 file changed, 56 insertions(+), 62 deletions(-)

diff -puN fs/udf/dir.c~udf-remove-wrong-prototype-of-udf_readdir fs/udf/dir.c
--- a/fs/udf/dir.c~udf-remove-wrong-prototype-of-udf_readdir
+++ a/fs/udf/dir.c
@@ -36,68 +36,8 @@
 #include "udf_i.h"
 #include "udf_sb.h"
 
-/* Prototypes for file operations */
-static int udf_readdir(struct file *, void *, filldir_t);
-static int do_udf_readdir(struct inode *, struct file *, filldir_t, void *);
-
-/* readdir and lookup functions */
-
-const struct file_operations udf_dir_operations = {
-	.read			= generic_read_dir,
-	.readdir		= udf_readdir,
-	.ioctl			= udf_ioctl,
-	.fsync			= udf_fsync_file,
-};
-
-/*
- * udf_readdir
- *
- * PURPOSE
- *	Read a directory entry.
- *
- * DESCRIPTION
- *	Optional - sys_getdents() will return -ENOTDIR if this routine is not
- *	available.
- *
- *	Refer to sys_getdents() in fs/readdir.c
- *	sys_getdents() -> .
- *
- * PRE-CONDITIONS
- *	filp			Pointer to directory file.
- *	buf			Pointer to directory entry buffer.
- *	filldir			Pointer to filldir function.
- *
- * POST-CONDITIONS
- *	<return>		>=0 on success.
- *
- * HISTORY
- *	July 1, 1997 - Andrew E. Mileski
- *	Written, tested, and released.
- */
-
-int udf_readdir(struct file *filp, void *dirent, filldir_t filldir)
-{
-	struct inode *dir = filp->f_path.dentry->d_inode;
-	int result;
-
-	lock_kernel();
-
-	if (filp->f_pos == 0) {
-		if (filldir(dirent, ".", 1, filp->f_pos, dir->i_ino, DT_DIR) < 0) {
-			unlock_kernel();
-			return 0;
-		}
-		filp->f_pos++;
-	}
-
-	result = do_udf_readdir(dir, filp, filldir, dirent);
-	unlock_kernel();
- 	return result;
-}
-
-static int
-do_udf_readdir(struct inode *dir, struct file *filp, filldir_t filldir,
-	       void *dirent)
+static int do_udf_readdir(struct inode *dir, struct file *filp,
+			  filldir_t filldir, void *dirent)
 {
 	struct udf_fileident_bh fibh;
 	struct fileIdentDesc *fi = NULL;
@@ -244,3 +184,57 @@ do_udf_readdir(struct inode *dir, struct
 
 	return 0;
 }
+
+/*
+ * udf_readdir
+ *
+ * PURPOSE
+ *	Read a directory entry.
+ *
+ * DESCRIPTION
+ *	Optional - sys_getdents() will return -ENOTDIR if this routine is not
+ *	available.
+ *
+ *	Refer to sys_getdents() in fs/readdir.c
+ *	sys_getdents() -> .
+ *
+ * PRE-CONDITIONS
+ *	filp			Pointer to directory file.
+ *	buf			Pointer to directory entry buffer.
+ *	filldir			Pointer to filldir function.
+ *
+ * POST-CONDITIONS
+ *	<return>		>=0 on success.
+ *
+ * HISTORY
+ *	July 1, 1997 - Andrew E. Mileski
+ *	Written, tested, and released.
+ */
+
+static int udf_readdir(struct file *filp, void *dirent, filldir_t filldir)
+{
+	struct inode *dir = filp->f_path.dentry->d_inode;
+	int result;
+
+	lock_kernel();
+
+	if (filp->f_pos == 0) {
+		if (filldir(dirent, ".", 1, filp->f_pos, dir->i_ino, DT_DIR) < 0) {
+			unlock_kernel();
+			return 0;
+		}
+		filp->f_pos++;
+	}
+
+	result = do_udf_readdir(dir, filp, filldir, dirent);
+	unlock_kernel();
+ 	return result;
+}
+
+/* readdir and lookup functions */
+const struct file_operations udf_dir_operations = {
+	.read			= generic_read_dir,
+	.readdir		= udf_readdir,
+	.ioctl			= udf_ioctl,
+	.fsync			= udf_fsync_file,
+};
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

git-alsa.patch
ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol-checkpatch-fixes.patch
vgacon-fix-sparse-warning-about-shadowing-i-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-p-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-rotate-symbol.patch
logo-move-declarations-of-logos-to-linux_logoh.patch
logo-move-declarations-of-logos-to-linux_logoh-fix.patch
udf-remove-wrong-prototype-of-udf_readdir.patch
udf-improve-readability-of-do_udf_readdir.patch
udf-fix-coding-style-of-dirc.patch
udf-fix-3-signedness-1-unitialized-variable-warnings.patch
udf-fix-signedness-issue.patch
