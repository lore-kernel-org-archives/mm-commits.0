From: akpm@linux-foundation.org
Subject: - move-struct-path-into-its-own-header.patch removed from -mm tree
Date: Fri, 26 Oct 2007 11:58:22 -0700
Message-ID: <200710261858.l9QIwMra009527@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43316 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752684AbXJZS7E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Oct 2007 14:59:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jblunck@suse.de, agruen@suse.de, bharata@linux.vnet.ibm.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Move struct path into its own header
has been removed from the -mm tree.  Its filename was
     move-struct-path-into-its-own-header.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Move struct path into its own header
From: Jan Blunck <jblunck@suse.de>

Move the definition of struct path into its own header file for further
patches.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
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
move-struct-path-into-its-own-header.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
introduce-path_put.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
introduce-path_get.patch
use-struct-path-in-fs_struct.patch
make-set_fs_rootpwd-take-a-struct-path.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
introduce-path_put-unionfs.patch
introduce-path_get-unionfs.patch
