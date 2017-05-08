From: akpm@linux-foundation.org
Subject: [patch 049/114] initramfs: use vfs_stat/lstat directly
Date: Mon, 08 May 2017 15:57:00 -0700
Message-ID: <20170508225700.1HcCLUlDs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46290 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751087AbdEHW5B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:57:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

From: Arnd Bergmann <arnd@arndb.de>
Subject: initramfs: use vfs_stat/lstat directly

sys_newlstat is a system call implementation that is meant for user space,
and that copies kernel-internal data structure to the user format, which
is not needed for in-kernel users.

Further, as we rearrange the system call implementation so we can extend
it with 64-bit time_t, the prototype for sys_newlstat changes.

This changes the initramfs code to use vfs_lstat directly, to get it out
of the way of the time_t changes, and make it slightly more efficient in
the process.  Along the same lines we also replace sys_stat and sys_stat64
with vfs_stat.

Link: http://lkml.kernel.org/r/20170314214932.4052842-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.h |   22 ++++------------------
 init/initramfs.c |   12 ++++++------
 2 files changed, 10 insertions(+), 24 deletions(-)

diff -puN init/do_mounts.h~initramfs-use-vfs_stat-lstat-directly init/do_mounts.h
--- a/init/do_mounts.h~initramfs-use-vfs_stat-lstat-directly
+++ a/init/do_mounts.h
@@ -19,29 +19,15 @@ static inline int create_dev(char *name,
 	return sys_mknod(name, S_IFBLK|0600, new_encode_dev(dev));
 }
 
-#if BITS_PER_LONG == 32
 static inline u32 bstat(char *name)
 {
-	struct stat64 stat;
-	if (sys_stat64(name, &stat) != 0)
+	struct kstat stat;
+	if (vfs_stat(name, &stat) != 0)
 		return 0;
-	if (!S_ISBLK(stat.st_mode))
+	if (!S_ISBLK(stat.mode))
 		return 0;
-	if (stat.st_rdev != (u32)stat.st_rdev)
-		return 0;
-	return stat.st_rdev;
-}
-#else
-static inline u32 bstat(char *name)
-{
-	struct stat stat;
-	if (sys_newstat(name, &stat) != 0)
-		return 0;
-	if (!S_ISBLK(stat.st_mode))
-		return 0;
-	return stat.st_rdev;
+	return stat.rdev;
 }
-#endif
 
 #ifdef CONFIG_BLK_DEV_RAM
 
diff -puN init/initramfs.c~initramfs-use-vfs_stat-lstat-directly init/initramfs.c
--- a/init/initramfs.c~initramfs-use-vfs_stat-lstat-directly
+++ a/init/initramfs.c
@@ -312,10 +312,10 @@ static int __init maybe_link(void)
 
 static void __init clean_path(char *path, umode_t fmode)
 {
-	struct stat st;
+	struct kstat st;
 
-	if (!sys_newlstat(path, &st) && (st.st_mode ^ fmode) & S_IFMT) {
-		if (S_ISDIR(st.st_mode))
+	if (!vfs_lstat(path, &st) && (st.mode ^ fmode) & S_IFMT) {
+		if (S_ISDIR(st.mode))
 			sys_rmdir(path);
 		else
 			sys_unlink(path);
@@ -581,13 +581,13 @@ static void __init clean_rootfs(void)
 	num = sys_getdents64(fd, dirp, BUF_SIZE);
 	while (num > 0) {
 		while (num > 0) {
-			struct stat st;
+			struct kstat st;
 			int ret;
 
-			ret = sys_newlstat(dirp->d_name, &st);
+			ret = vfs_lstat(dirp->d_name, &st);
 			WARN_ON_ONCE(ret);
 			if (!ret) {
-				if (S_ISDIR(st.st_mode))
+				if (S_ISDIR(st.mode))
 					sys_rmdir(dirp->d_name);
 				else
 					sys_unlink(dirp->d_name);
_
