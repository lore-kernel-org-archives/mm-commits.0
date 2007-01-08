From: akpm@osdl.org
Subject: + unionfs-include-file.patch added to -mm tree
Date: Mon, 08 Jan 2007 13:08:55 -0800
Message-ID: <200701082108.l08L8tMV018934@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43443 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbXAHVJL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 16:09:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jsipek@cs.sunysb.edu, dquigley@fsl.cs.sunysb.edu, ezk@cs.sunysb.edu


The patch titled
     unionfs: include file
has been added to the -mm tree.  Its filename is
     unionfs-include-file.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: unionfs: include file
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Global include file - can be included from userspace by utilities.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: David Quigley <dquigley@fsl.cs.sunysb.edu>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/magic.h    |    2 ++
 include/linux/union_fs.h |   18 ++++++++++++++++++
 2 files changed, 20 insertions(+)

diff -puN include/linux/magic.h~unionfs-include-file include/linux/magic.h
--- a/include/linux/magic.h~unionfs-include-file
+++ a/include/linux/magic.h
@@ -33,6 +33,8 @@
 #define REISER2FS_SUPER_MAGIC_STRING	"ReIsEr2Fs"
 #define REISER2FS_JR_SUPER_MAGIC_STRING	"ReIsEr3Fs"
 
+#define UNIONFS_SUPER_MAGIC 0xf15f083d
+
 #define SMB_SUPER_MAGIC		0x517B
 #define USBDEVICE_SUPER_MAGIC	0x9fa2
 
diff -puN /dev/null include/linux/union_fs.h
--- /dev/null
+++ a/include/linux/union_fs.h
@@ -0,0 +1,18 @@
+#ifndef _LINUX_UNION_FS_H
+#define _LINUX_UNION_FS_H
+
+#define UNIONFS_VERSION  "2.0"
+/*
+ * DEFINITIONS FOR USER AND KERNEL CODE:
+ */
+# define UNIONFS_IOCTL_INCGEN		_IOR(0x15, 11, int)
+# define UNIONFS_IOCTL_QUERYFILE	_IOR(0x15, 15, int)
+
+/* We don't support normal remount, but unionctl uses it. */
+# define UNIONFS_REMOUNT_MAGIC		0x4a5a4380
+
+/* should be at least LAST_USED_UNIONFS_PERMISSION<<1 */
+#define MAY_NFSRO			16
+
+#endif /* _LINUX_UNIONFS_H */
+
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

unionfs-documentation.patch
lookup_one_len_nd-lookup_one_len-with-nameidata-argument.patch
unionfs-branch-management-functionality.patch
unionfs-common-file-operations.patch
unionfs-copyup-functionality.patch
unionfs-dentry-operations.patch
unionfs-file-operations.patch
unionfs-directory-file-operations.patch
unionfs-directory-manipulation-helper-functions.patch
unionfs-inode-operations.patch
unionfs-lookup-helper-functions.patch
unionfs-main-module-functions.patch
unionfs-readdir-state.patch
unionfs-rename.patch
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
