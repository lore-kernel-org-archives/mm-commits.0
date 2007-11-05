From: akpm@linux-foundation.org
Subject: + introduce-path_get.patch added to -mm tree
Date: Mon, 05 Nov 2007 13:02:16 -0800
Message-ID: <200711052102.lA5L2Gxl019557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55381 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753695AbXKEVC2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 16:02:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, agruen@suse.de, hch@lst.de


The patch titled
     Introduce path_get()
has been added to the -mm tree.  Its filename is
     introduce-path_get.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 fs/namei.c            |   17 +++++++++++++++--
 include/linux/namei.h |    6 ------
 include/linux/path.h  |    1 +
 3 files changed, 16 insertions(+), 8 deletions(-)

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
@@ -1161,8 +1174,8 @@ static int fastcall do_path_lookup(int d
 		if (retval)
 			goto fput_fail;
 
-		nd->path.mnt = mntget(file->f_path.mnt);
-		nd->path.dentry = dget(dentry);
+		nd->path = file->f_path;
+		path_get(&file->f_path);
 
 		fput_light(file, fput_needed);
 	}
diff -puN include/linux/namei.h~introduce-path_get include/linux/namei.h
--- a/include/linux/namei.h~introduce-path_get
+++ a/include/linux/namei.h
@@ -94,10 +94,4 @@ static inline char *nd_get_link(struct n
 	return nd->saved_names[nd->depth];
 }
 
-static inline void pathget(struct path *path)
-{
-	mntget(path->mnt);
-	dget(path->dentry);
-}
-
 #endif /* _LINUX_NAMEI_H */
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

r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime-fix.patch
r-o-bind-mounts-track-number-of-mount-writers-fix.patch
dont-touch-fs_struct-in-drivers.patch
dont-touch-fs_struct-in-usermodehelper.patch
remove-path_release_on_umount.patch
move-struct-path-into-its-own-header.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
introduce-path_put.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
introduce-path_get.patch
use-struct-path-in-fs_struct.patch
make-set_fs_rootpwd-take-a-struct-path.patch
introduce-path_get-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
one-less-parameter-to-__d_path.patch
d_path-kerneldoc-cleanup.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
