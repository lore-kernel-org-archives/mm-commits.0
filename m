From: akpm@linux-foundation.org
Subject: - introduce-path_get.patch removed from -mm tree
Date: Thu, 14 Feb 2008 19:16:48 -0500
Message-ID: <200802150720.m1F7KAh1025792@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41271 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763364AbYBOH3a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:29:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jblunck@suse.de, agruen@suse.de, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Introduce path_get()
has been removed from the -mm tree.  Its filename was
     introduce-path_get.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Introduce path_get()
From: Jan Blunck <jblunck@suse.de>

This introduces the symmetric function to path_put() for getting a reference
to the dentry and vfsmount of a struct path in the right order.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c           |   17 +++++++++++++++--
 include/linux/path.h |    1 +
 2 files changed, 16 insertions(+), 2 deletions(-)

diff -puN fs/namei.c~introduce-path_get fs/namei.c
--- a/fs/namei.c~introduce-path_get
+++ a/fs/namei.c
@@ -363,6 +363,19 @@ int deny_write_access(struct file * file
 }
 
 /**
+ * path_get - get a reference to a path
+ * @path: path to get the reference to
+ *
+ * Given a path increment the reference count to the dentry and the vfsmount.
+ */
+void path_get(struct path *path)
+{
+	mntget(path->mnt);
+	dget(path->dentry);
+}
+EXPORT_SYMBOL(path_get);
+
+/**
  * path_put - put a reference to a path
  * @path: path to put the reference to
  *
@@ -1160,8 +1173,8 @@ static int do_path_lookup(int dfd, const
 		if (retval)
 			goto fput_fail;
 
-		nd->path.mnt = mntget(file->f_path.mnt);
-		nd->path.dentry = dget(dentry);
+		nd->path = file->f_path;
+		path_get(&file->f_path);
 
 		fput_light(file, fput_needed);
 	}
diff -puN include/linux/path.h~introduce-path_get include/linux/path.h
--- a/include/linux/path.h~introduce-path_get
+++ a/include/linux/path.h
@@ -9,6 +9,7 @@ struct path {
 	struct dentry *dentry;
 };
 
+extern void path_get(struct path *);
 extern void path_put(struct path *);
 
 #endif  /* _LINUX_PATH_H */
_

Patches currently in -mm which might be from jblunck@suse.de are

origin.patch
introduce-path_put-unionfs.patch
