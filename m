From: akpm@osdl.org
Subject: - struct-path-move-struct-path-from-fs-nameic-into.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:01:31 -0800
Message-ID: <200612082001.kB8K1VRh001872@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56820 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426213AbWLHUBe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:01:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     struct path: move struct path from fs/namei.c into include/linux
has been removed from the -mm tree.  Its filename was
     struct-path-move-struct-path-from-fs-nameic-into.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: move struct path from fs/namei.c into include/linux
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Moved struct path from fs/namei.c to include/linux/namei.h.  This allows many
places in the VFS, as well as any stackable filesystem to easily keep track of
dentry-vfsmount pairs.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/namei.c            |    5 -----
 include/linux/namei.h |    5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/namei.c~struct-path-move-struct-path-from-fs-nameic-into fs/namei.c
--- a/fs/namei.c~struct-path-move-struct-path-from-fs-nameic-into
+++ a/fs/namei.c
@@ -572,11 +572,6 @@ fail:
 	return PTR_ERR(link);
 }
 
-struct path {
-	struct vfsmount *mnt;
-	struct dentry *dentry;
-};
-
 static inline void dput_path(struct path *path, struct nameidata *nd)
 {
 	dput(path->dentry);
diff -puN include/linux/namei.h~struct-path-move-struct-path-from-fs-nameic-into include/linux/namei.h
--- a/include/linux/namei.h~struct-path-move-struct-path-from-fs-nameic-into
+++ a/include/linux/namei.h
@@ -29,6 +29,11 @@ struct nameidata {
 	} intent;
 };
 
+struct path {
+	struct vfsmount *mnt;
+	struct dentry *dentry;
+};
+
 /*
  * Type of the last component on LOOKUP_PARENT
  */
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

struct-path-move-struct-path-from-fs-nameic-into.patch
struct-path-make-ecryptfs-a-user-of-struct-path.patch
vfs-change-struct-file-to-use-struct-path.patch
sysfs-change-uses-of-f_dentry.patch
proc-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ext2-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ext3-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ext4-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
fat-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
isofs-change-uses-of-f_dentry.patch
nfs-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
nfsd-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ntfs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
i386-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
x86_64-change-uses-of-f_dentry.patch
kernel-change-uses-of-f_dentry.patch
mm-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
9p-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
affs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
autofs-change-uses-of-f_dentry.patch
autofs4-change-uses-of-f_dentry.patch
configfs-change-uses-of-f_dentry.patch
cifs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ecryptfs-change-uses-of-f_dentry.patch
xfs-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch

