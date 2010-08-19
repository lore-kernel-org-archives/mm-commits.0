From: akpm@linux-foundation.org
Subject: + init-mark-__user-address-space-on-string-literals.patch added to -mm tree
Date: Thu, 19 Aug 2010 15:11:08 -0700
Message-ID: <201008192211.o7JMB8l9011291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751191Ab0HSWLL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Aug 2010 18:11:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com


The patch titled
     From: Namhyung Kim <namhyung@gmail.com>
has been added to the -mm tree.  Its filename is
     init-mark-__user-address-space-on-string-literals.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: From: Namhyung Kim <namhyung@gmail.com>


When calling syscall service routines in kernel, some of arguments should be
user pointers but were missing __user markup on string literals. Add it.

Impact: remove sparse warnings

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---

index 8eabff6..91fc443 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c    |    4 ++--
 init/do_mounts_md.c |    2 +-
 init/do_mounts_rd.c |    4 ++--
 init/initramfs.c    |    5 +++--
 init/noinitramfs.c  |    6 +++---
 5 files changed, 11 insertions(+), 10 deletions(-)

diff -puN init/do_mounts.c~init-mark-__user-address-space-on-string-literals init/do_mounts.c
--- a/init/do_mounts.c~init-mark-__user-address-space-on-string-literals
+++ a/init/do_mounts.c
@@ -221,7 +221,7 @@ static int __init do_mount_root(char *na
 	if (err)
 		return err;
 
-	sys_chdir("/root");
+	sys_chdir((const char __user __force *)"/root");
 	ROOT_DEV = current->fs->pwd.mnt->mnt_sb->s_dev;
 	printk("VFS: Mounted root (%s filesystem)%s on device %u:%u.\n",
 	       current->fs->pwd.mnt->mnt_sb->s_type->name,
@@ -418,5 +418,5 @@ void __init prepare_namespace(void)
 out:
 	devtmpfs_mount("dev");
 	sys_mount(".", "/", NULL, MS_MOVE, NULL);
-	sys_chroot(".");
+	sys_chroot((const char __user __force *)".");
 }
diff -puN init/do_mounts_md.c~init-mark-__user-address-space-on-string-literals init/do_mounts_md.c
--- a/init/do_mounts_md.c~init-mark-__user-address-space-on-string-literals
+++ a/init/do_mounts_md.c
@@ -283,7 +283,7 @@ static void __init autodetect_raid(void)
 
 	wait_for_device_probe();
 
-	fd = sys_open("/dev/md0", 0, 0);
+	fd = sys_open((const char __user __force *) "/dev/md0", 0, 0);
 	if (fd >= 0) {
 		sys_ioctl(fd, RAID_AUTORUN, raid_autopart);
 		sys_close(fd);
diff -puN init/do_mounts_rd.c~init-mark-__user-address-space-on-string-literals init/do_mounts_rd.c
--- a/init/do_mounts_rd.c~init-mark-__user-address-space-on-string-literals
+++ a/init/do_mounts_rd.c
@@ -168,7 +168,7 @@ int __init rd_load_image(char *from)
 	char rotator[4] = { '|' , '/' , '-' , '\\' };
 #endif
 
-	out_fd = sys_open("/dev/ram", O_RDWR, 0);
+	out_fd = sys_open((const char __user __force *) "/dev/ram", O_RDWR, 0);
 	if (out_fd < 0)
 		goto out;
 
@@ -267,7 +267,7 @@ noclose_input:
 	sys_close(out_fd);
 out:
 	kfree(buf);
-	sys_unlink("/dev/ram");
+	sys_unlink((const char __user __force *) "/dev/ram");
 	return res;
 }
 
diff -puN init/initramfs.c~init-mark-__user-address-space-on-string-literals init/initramfs.c
--- a/init/initramfs.c~init-mark-__user-address-space-on-string-literals
+++ a/init/initramfs.c
@@ -528,7 +528,7 @@ static void __init clean_rootfs(void)
 	struct linux_dirent64 *dirp;
 	int num;
 
-	fd = sys_open("/", O_RDONLY, 0);
+	fd = sys_open((const char __user __force *) "/", O_RDONLY, 0);
 	WARN_ON(fd < 0);
 	if (fd < 0)
 		return;
@@ -590,7 +590,8 @@ static int __init populate_rootfs(void)
 		}
 		printk(KERN_INFO "rootfs image is not initramfs (%s)"
 				"; looks like an initrd\n", err);
-		fd = sys_open("/initrd.image", O_WRONLY|O_CREAT, 0700);
+		fd = sys_open((const char __user __force *) "/initrd.image",
+			      O_WRONLY|O_CREAT, 0700);
 		if (fd >= 0) {
 			sys_write(fd, (char *)initrd_start,
 					initrd_end - initrd_start);
diff -puN init/noinitramfs.c~init-mark-__user-address-space-on-string-literals init/noinitramfs.c
--- a/init/noinitramfs.c~init-mark-__user-address-space-on-string-literals
+++ a/init/noinitramfs.c
@@ -29,17 +29,17 @@ static int __init default_rootfs(void)
 {
 	int err;
 
-	err = sys_mkdir("/dev", 0755);
+	err = sys_mkdir((const char __user __force *) "/dev", 0755);
 	if (err < 0)
 		goto out;
 
-	err = sys_mknod((const char __user *) "/dev/console",
+	err = sys_mknod((const char __user __force *) "/dev/console",
 			S_IFCHR | S_IRUSR | S_IWUSR,
 			new_encode_dev(MKDEV(5, 1)));
 	if (err < 0)
 		goto out;
 
-	err = sys_mkdir("/root", 0700);
+	err = sys_mkdir((const char __user __force *) "/root", 0700);
 	if (err < 0)
 		goto out;
 
_

Patches currently in -mm which might be from namhyung@gmail.com are

origin.patch
linux-next.patch
init-mark-__user-address-space-on-string-literals.patch

