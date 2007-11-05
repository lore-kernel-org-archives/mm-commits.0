From: akpm@linux-foundation.org
Subject: + move-struct-path-into-its-own-header.patch added to -mm tree
Date: Mon, 05 Nov 2007 13:01:23 -0800
Message-ID: <200711052101.lA5L1NxZ019528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38441 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753574AbXKEVBg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 16:01:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, agruen@suse.de, hch@lst.de


The patch titled
     Move struct path into its own header
has been added to the -mm tree.  Its filename is
     move-struct-path-into-its-own-header.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Move struct path into its own header
From: Jan Blunck <jblunck@suse.de>

Move the definition of struct path into its own header file for further
patches.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/namei.h |    6 +-----
 include/linux/path.h  |   12 ++++++++++++
 2 files changed, 13 insertions(+), 5 deletions(-)

diff -puN include/linux/namei.h~move-struct-path-into-its-own-header include/linux/namei.h
--- a/include/linux/namei.h~move-struct-path-into-its-own-header
+++ a/include/linux/namei.h
@@ -4,6 +4,7 @@
 #include <linux/dcache.h>
 #include <linux/linkage.h>
 #include <linux/mount.h>
+#include <linux/path.h>
 
 struct vfsmount;
 
@@ -30,11 +31,6 @@ struct nameidata {
 	} intent;
 };
 
-struct path {
-	struct vfsmount *mnt;
-	struct dentry *dentry;
-};
-
 /*
  * Type of the last component on LOOKUP_PARENT
  */
diff -puN /dev/null include/linux/path.h
--- /dev/null
+++ a/include/linux/path.h
@@ -0,0 +1,12 @@
+#ifndef _LINUX_PATH_H
+#define _LINUX_PATH_H
+
+struct dentry;
+struct vfsmount;
+
+struct path {
+	struct vfsmount *mnt;
+	struct dentry *dentry;
+};
+
+#endif  /* _LINUX_PATH_H */
_

Patches currently in -mm which might be from jblunck@suse.de are

r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime-fix.patch
r-o-bind-mounts-track-number-of-mount-writers-fix.patch
dont-touch-fs_struct-in-drivers.patch
dont-touch-fs_struct-in-usermodehelper.patch
remove-path_release_on_umount.patch
move-struct-path-into-its-own-header.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
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
