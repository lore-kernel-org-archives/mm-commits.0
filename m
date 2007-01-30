From: akpm@osdl.org
Subject: - uml-fix-mknod.patch removed from -mm tree
Date: Tue, 30 Jan 2007 13:46:25 -0800
Message-ID: <200701302146.l0ULkPqV030098@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52058 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbXA3Vsp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 16:48:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js@linuxtv.org, blaisorblade@yahoo.it, jdike@addtoit.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     uml: fix mknod
has been removed from the -mm tree.  Its filename was
     uml-fix-mknod.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fix mknod
From: Johannes Stezenbach <js@linuxtv.org>

Fix UML hostfs mknod(): userspace has differernt dev_t size and encoding
than kernel, so extract major/minor and reencode using glibc makedev()
macro.

Signed-off-by: Johannes Stezenbach <js@linuxtv.org>
Acked-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/hostfs/hostfs.h      |    2 +-
 fs/hostfs/hostfs_kern.c |    2 +-
 fs/hostfs/hostfs_user.c |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/hostfs/hostfs.h~uml-fix-mknod fs/hostfs/hostfs.h
--- a/fs/hostfs/hostfs.h~uml-fix-mknod
+++ a/fs/hostfs/hostfs.h
@@ -76,7 +76,7 @@ extern int make_symlink(const char *from
 extern int unlink_file(const char *file);
 extern int do_mkdir(const char *file, int mode);
 extern int do_rmdir(const char *file);
-extern int do_mknod(const char *file, int mode, int dev);
+extern int do_mknod(const char *file, int mode, unsigned int major, unsigned int minor);
 extern int link_file(const char *from, const char *to);
 extern int do_readlink(char *file, char *buf, int size);
 extern int rename_file(char *from, char *to);
diff -puN fs/hostfs/hostfs_kern.c~uml-fix-mknod fs/hostfs/hostfs_kern.c
--- a/fs/hostfs/hostfs_kern.c~uml-fix-mknod
+++ a/fs/hostfs/hostfs_kern.c
@@ -755,7 +755,7 @@ int hostfs_mknod(struct inode *dir, stru
 		goto out_put;
 
 	init_special_inode(inode, mode, dev);
-	err = do_mknod(name, mode, dev);
+	err = do_mknod(name, mode, MAJOR(dev), MINOR(dev));
 	if(err)
 		goto out_free;
 
diff -puN fs/hostfs/hostfs_user.c~uml-fix-mknod fs/hostfs/hostfs_user.c
--- a/fs/hostfs/hostfs_user.c~uml-fix-mknod
+++ a/fs/hostfs/hostfs_user.c
@@ -295,11 +295,11 @@ int do_rmdir(const char *file)
 	return(0);
 }
 
-int do_mknod(const char *file, int mode, int dev)
+int do_mknod(const char *file, int mode, unsigned int major, unsigned int minor)
 {
 	int err;
 
-	err = mknod(file, mode, dev);
+	err = mknod(file, mode, makedev(major, minor));
 	if(err) return(-errno);
 	return(0);
 }
_

Patches currently in -mm which might be from js@linuxtv.org are

origin.patch
