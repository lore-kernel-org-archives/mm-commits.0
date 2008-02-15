From: akpm@linux-foundation.org
Subject: - move-struct-path-into-its-own-header.patch removed from -mm tree
Date: Thu, 14 Feb 2008 19:16:39 -0500
Message-ID: <200802150720.m1F7K1nD025780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37180 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763230AbYBOHUt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:20:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jblunck@suse.de, agruen@suse.de, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Move struct path into its own header
has been removed from the -mm tree.  Its filename was
     move-struct-path-into-its-own-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -3,6 +3,7 @@
 
 #include <linux/dcache.h>
 #include <linux/linkage.h>
+#include <linux/path.h>
 
 struct vfsmount;
 
@@ -29,11 +30,6 @@ struct nameidata {
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

origin.patch
introduce-path_put-unionfs.patch
