From: akpm@linux-foundation.org
Subject: + init-disable-sparse-checking-of-the-mounto-source-files.patch added to -mm tree
Date: Fri, 27 Apr 2012 16:28:06 -0700
Message-ID: <20120427232806.9B736A035C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:49003 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757359Ab2D0X2J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Apr 2012 19:28:09 -0400
Received: by bkwj5 with SMTP id j5so60914bkw.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Apr 2012 16:28:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, hsweeten@visionengravers.com


The patch titled
     Subject: init: disable sparse checking of the mount.o source files
has been added to the -mm tree.  Its filename is
     init-disable-sparse-checking-of-the-mounto-source-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: init: disable sparse checking of the mount.o source files

The init/mount.o source files produce a number of sparse warnings of the
type:

warning: incorrect type in argument 1 (different address spaces)
   expected char [noderef] <asn:1>*dev_name
   got char *name 

This is due to the syscalls expecting some of the arguments to be user
pointers but they are being passed as kernel pointers.  This is harmless
but adds a lot of noise to a sparse build.

To limit the noise just disable the sparse checking in the relevant source
files, but still display a warning so that the user knows this has been
done.

Since the sparse checking has been disabled we can also remove the __user
__force casts that are scattered thru the source.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c        |   14 ++++++++++++--
 init/do_mounts_initrd.c |   10 ++++++++++
 init/do_mounts_md.c     |   12 +++++++++++-
 init/do_mounts_rd.c     |   13 +++++++++++--
 init/initramfs.c        |   16 +++++++++++++---
 5 files changed, 57 insertions(+), 8 deletions(-)

diff -puN init/do_mounts.c~init-disable-sparse-checking-of-the-mounto-source-files init/do_mounts.c
--- a/init/do_mounts.c~init-disable-sparse-checking-of-the-mounto-source-files
+++ a/init/do_mounts.c
@@ -1,3 +1,13 @@
+/*
+ * Many of the syscalls used in this file expect some of the arguments
+ * to be __user pointers not __kernel pointers.  To limit the sparse
+ * noise, turn off sparse checking for this file.
+ */
+#ifdef __CHECKER__
+#undef __CHECKER__
+#warning "Sparse checking disabled for this file"
+#endif
+
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/ctype.h>
@@ -330,7 +340,7 @@ static int __init do_mount_root(char *na
 	if (err)
 		return err;
 
-	sys_chdir((const char __user __force *)"/root");
+	sys_chdir("/root");
 	s = current->fs->pwd.dentry->d_sb;
 	ROOT_DEV = s->s_dev;
 	printk(KERN_INFO
@@ -556,5 +566,5 @@ void __init prepare_namespace(void)
 out:
 	devtmpfs_mount("dev");
 	sys_mount(".", "/", NULL, MS_MOVE, NULL);
-	sys_chroot((const char __user __force *)".");
+	sys_chroot(".");
 }
diff -puN init/do_mounts_initrd.c~init-disable-sparse-checking-of-the-mounto-source-files init/do_mounts_initrd.c
--- a/init/do_mounts_initrd.c~init-disable-sparse-checking-of-the-mounto-source-files
+++ a/init/do_mounts_initrd.c
@@ -1,3 +1,13 @@
+/*
+ * Many of the syscalls used in this file expect some of the arguments
+ * to be __user pointers not __kernel pointers.  To limit the sparse
+ * noise, turn off sparse checking for this file.
+ */
+#ifdef __CHECKER__
+#undef __CHECKER__
+#warning "Sparse checking disabled for this file"
+#endif
+
 #include <linux/unistd.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
diff -puN init/do_mounts_md.c~init-disable-sparse-checking-of-the-mounto-source-files init/do_mounts_md.c
--- a/init/do_mounts_md.c~init-disable-sparse-checking-of-the-mounto-source-files
+++ a/init/do_mounts_md.c
@@ -1,3 +1,13 @@
+/*
+ * Many of the syscalls used in this file expect some of the arguments
+ * to be __user pointers not __kernel pointers.  To limit the sparse
+ * noise, turn off sparse checking for this file.
+ */
+#ifdef __CHECKER__
+#undef __CHECKER__
+#warning "Sparse checking disabled for this file"
+#endif
+
 #include <linux/delay.h>
 #include <linux/raid/md_u.h>
 #include <linux/raid/md_p.h>
@@ -283,7 +293,7 @@ static void __init autodetect_raid(void)
 
 	wait_for_device_probe();
 
-	fd = sys_open((const char __user __force *) "/dev/md0", 0, 0);
+	fd = sys_open("/dev/md0", 0, 0);
 	if (fd >= 0) {
 		sys_ioctl(fd, RAID_AUTORUN, raid_autopart);
 		sys_close(fd);
diff -puN init/do_mounts_rd.c~init-disable-sparse-checking-of-the-mounto-source-files init/do_mounts_rd.c
--- a/init/do_mounts_rd.c~init-disable-sparse-checking-of-the-mounto-source-files
+++ a/init/do_mounts_rd.c
@@ -1,3 +1,12 @@
+/*
+ * Many of the syscalls used in this file expect some of the arguments
+ * to be __user pointers not __kernel pointers.  To limit the sparse
+ * noise, turn off sparse checking for this file.
+ */
+#ifdef __CHECKER__
+#undef __CHECKER__
+#warning "Sparse checking disabled for this file"
+#endif
 
 #include <linux/kernel.h>
 #include <linux/fs.h>
@@ -181,7 +190,7 @@ int __init rd_load_image(char *from)
 	char rotator[4] = { '|' , '/' , '-' , '\\' };
 #endif
 
-	out_fd = sys_open((const char __user __force *) "/dev/ram", O_RDWR, 0);
+	out_fd = sys_open("/dev/ram", O_RDWR, 0);
 	if (out_fd < 0)
 		goto out;
 
@@ -280,7 +289,7 @@ noclose_input:
 	sys_close(out_fd);
 out:
 	kfree(buf);
-	sys_unlink((const char __user __force *) "/dev/ram");
+	sys_unlink("/dev/ram");
 	return res;
 }
 
diff -puN init/initramfs.c~init-disable-sparse-checking-of-the-mounto-source-files init/initramfs.c
--- a/init/initramfs.c~init-disable-sparse-checking-of-the-mounto-source-files
+++ a/init/initramfs.c
@@ -1,3 +1,13 @@
+/*
+ * Many of the syscalls used in this file expect some of the arguments
+ * to be __user pointers not __kernel pointers.  To limit the sparse
+ * noise, turn off sparse checking for this file.
+ */
+#ifdef __CHECKER__
+#undef __CHECKER__
+#warning "Sparse checking disabled for this file"
+#endif
+
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
@@ -74,7 +84,7 @@ static void __init free_hash(void)
 	}
 }
 
-static long __init do_utime(char __user *filename, time_t mtime)
+static long __init do_utime(char *filename, time_t mtime)
 {
 	struct timespec t[2];
 
@@ -529,7 +539,7 @@ static void __init clean_rootfs(void)
 	struct linux_dirent64 *dirp;
 	int num;
 
-	fd = sys_open((const char __user __force *) "/", O_RDONLY, 0);
+	fd = sys_open("/", O_RDONLY, 0);
 	WARN_ON(fd < 0);
 	if (fd < 0)
 		return;
@@ -589,7 +599,7 @@ static int __init populate_rootfs(void)
 		}
 		printk(KERN_INFO "rootfs image is not initramfs (%s)"
 				"; looks like an initrd\n", err);
-		fd = sys_open((const char __user __force *) "/initrd.image",
+		fd = sys_open("/initrd.image",
 			      O_WRONLY|O_CREAT, 0700);
 		if (fd >= 0) {
 			sys_write(fd, (char *)initrd_start,
_
Subject: Subject: init: disable sparse checking of the mount.o source files

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch
init-disable-sparse-checking-of-the-mounto-source-files.patch
drivers-rtc-rtc-ep93xxc-convert-to-use-module_platform_driver.patch

