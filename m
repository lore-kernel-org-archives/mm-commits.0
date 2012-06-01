From: akpm@linux-foundation.org
Subject: [merged] fs-move-file_remove_suid-to-fs-inodec.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:41:51 -0700
Message-ID: <20120601194151.55396A026A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:34946 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759228Ab2FATlw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:41:52 -0400
Received: by vbnl22 with SMTP id l22so244913vbn.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:41:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: move file_remove_suid() to fs/inode.c
has been removed from the -mm tree.  Its filename was
     fs-move-file_remove_suid-to-fs-inodec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: fs: move file_remove_suid() to fs/inode.c

file_remove_suid() is a generic function operates on struct file, it
almost has no relations with file mapping, so move it to fs/inode.c.

Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c   |   65 +++++++++++++++++++++++++++++++++++++++++++++++++
 mm/filemap.c |   65 -------------------------------------------------
 2 files changed, 65 insertions(+), 65 deletions(-)

diff -puN fs/inode.c~fs-move-file_remove_suid-to-fs-inodec fs/inode.c
--- a/fs/inode.c~fs-move-file_remove_suid-to-fs-inodec
+++ a/fs/inode.c
@@ -1530,6 +1530,71 @@ void touch_atime(struct path *path)
 }
 EXPORT_SYMBOL(touch_atime);
 
+/*
+ * The logic we want is
+ *
+ *	if suid or (sgid and xgrp)
+ *		remove privs
+ */
+int should_remove_suid(struct dentry *dentry)
+{
+	umode_t mode = dentry->d_inode->i_mode;
+	int kill = 0;
+
+	/* suid always must be killed */
+	if (unlikely(mode & S_ISUID))
+		kill = ATTR_KILL_SUID;
+
+	/*
+	 * sgid without any exec bits is just a mandatory locking mark; leave
+	 * it alone.  If some exec bits are set, it's a real sgid; kill it.
+	 */
+	if (unlikely((mode & S_ISGID) && (mode & S_IXGRP)))
+		kill |= ATTR_KILL_SGID;
+
+	if (unlikely(kill && !capable(CAP_FSETID) && S_ISREG(mode)))
+		return kill;
+
+	return 0;
+}
+EXPORT_SYMBOL(should_remove_suid);
+
+static int __remove_suid(struct dentry *dentry, int kill)
+{
+	struct iattr newattrs;
+
+	newattrs.ia_valid = ATTR_FORCE | kill;
+	return notify_change(dentry, &newattrs);
+}
+
+int file_remove_suid(struct file *file)
+{
+	struct dentry *dentry = file->f_path.dentry;
+	struct inode *inode = dentry->d_inode;
+	int killsuid;
+	int killpriv;
+	int error = 0;
+
+	/* Fast path for nothing security related */
+	if (IS_NOSEC(inode))
+		return 0;
+
+	killsuid = should_remove_suid(dentry);
+	killpriv = security_inode_need_killpriv(dentry);
+
+	if (killpriv < 0)
+		return killpriv;
+	if (killpriv)
+		error = security_inode_killpriv(dentry);
+	if (!error && killsuid)
+		error = __remove_suid(dentry, killsuid);
+	if (!error && (inode->i_sb->s_flags & MS_NOSEC))
+		inode->i_flags |= S_NOSEC;
+
+	return error;
+}
+EXPORT_SYMBOL(file_remove_suid);
+
 /**
  *	file_update_time	-	update mtime and ctime time
  *	@file: file accessed
diff -puN mm/filemap.c~fs-move-file_remove_suid-to-fs-inodec mm/filemap.c
--- a/mm/filemap.c~fs-move-file_remove_suid-to-fs-inodec
+++ a/mm/filemap.c
@@ -1938,71 +1938,6 @@ struct page *read_cache_page(struct addr
 }
 EXPORT_SYMBOL(read_cache_page);
 
-/*
- * The logic we want is
- *
- *	if suid or (sgid and xgrp)
- *		remove privs
- */
-int should_remove_suid(struct dentry *dentry)
-{
-	umode_t mode = dentry->d_inode->i_mode;
-	int kill = 0;
-
-	/* suid always must be killed */
-	if (unlikely(mode & S_ISUID))
-		kill = ATTR_KILL_SUID;
-
-	/*
-	 * sgid without any exec bits is just a mandatory locking mark; leave
-	 * it alone.  If some exec bits are set, it's a real sgid; kill it.
-	 */
-	if (unlikely((mode & S_ISGID) && (mode & S_IXGRP)))
-		kill |= ATTR_KILL_SGID;
-
-	if (unlikely(kill && !capable(CAP_FSETID) && S_ISREG(mode)))
-		return kill;
-
-	return 0;
-}
-EXPORT_SYMBOL(should_remove_suid);
-
-static int __remove_suid(struct dentry *dentry, int kill)
-{
-	struct iattr newattrs;
-
-	newattrs.ia_valid = ATTR_FORCE | kill;
-	return notify_change(dentry, &newattrs);
-}
-
-int file_remove_suid(struct file *file)
-{
-	struct dentry *dentry = file->f_path.dentry;
-	struct inode *inode = dentry->d_inode;
-	int killsuid;
-	int killpriv;
-	int error = 0;
-
-	/* Fast path for nothing security related */
-	if (IS_NOSEC(inode))
-		return 0;
-
-	killsuid = should_remove_suid(dentry);
-	killpriv = security_inode_need_killpriv(dentry);
-
-	if (killpriv < 0)
-		return killpriv;
-	if (killpriv)
-		error = security_inode_killpriv(dentry);
-	if (!error && killsuid)
-		error = __remove_suid(dentry, killsuid);
-	if (!error && (inode->i_sb->s_flags & MS_NOSEC))
-		inode->i_flags |= S_NOSEC;
-
-	return error;
-}
-EXPORT_SYMBOL(file_remove_suid);
