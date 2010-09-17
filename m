From: akpm@linux-foundation.org
Subject: + init-use-kernel_sys_-wrappers-instead-of-syscall.patch added to -mm tree
Date: Fri, 17 Sep 2010 14:40:46 -0700
Message-ID: <201009172140.o8HLek2W011499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753034Ab0IQVlR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Sep 2010 17:41:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, arnd@arndb.de, phillip@lougher.demon.co.uk, sam@ravnborg.org, viro@zeniv.linux.org.uk


The patch titled
     init: use kernel_sys_* wrappers instead of syscall
has been added to the -mm tree.  Its filename is
     init-use-kernel_sys_-wrappers-instead-of-syscall.patch

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
Subject: init: use kernel_sys_* wrappers instead of syscall
From: Namhyung Kim <namhyung@gmail.com>

Replace direct syscall invocations with the wrapper functions defined in
init/sys-wrapper.h.  This removes the following sparse warnings:

 init/main.c:896:23: warning: cast adds address space to expression (<asn:1>)
 ...
 init/do_mounts.c:220:29: warning: incorrect type in argument 1 (different address spaces)
 init/do_mounts.c:220:29:    expected char [noderef] <asn:1>*dev_name
 init/do_mounts.c:220:29:    got char *name
 ...

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c        |   29 ++++++++---------
 init/do_mounts_initrd.c |   48 ++++++++++++++--------------
 init/do_mounts_md.c     |   29 ++++++++---------
 init/do_mounts_rd.c     |   39 +++++++++++------------
 init/initramfs.c        |   64 +++++++++++++++++++-------------------
 init/main.c             |   12 ++++---
 init/noinitramfs.c      |   12 ++++---
 7 files changed, 122 insertions(+), 111 deletions(-)

diff -puN init/do_mounts.c~init-use-kernel_sys_-wrappers-instead-of-syscall init/do_mounts.c
--- a/init/do_mounts.c~init-use-kernel_sys_-wrappers-instead-of-syscall
+++ a/init/do_mounts.c
@@ -21,6 +21,7 @@
 #include <linux/nfs_fs_sb.h>
 #include <linux/nfs_mount.h>
 
+#include "sys-wrapper.h"
 #include "do_mounts.h"
 
 int __initdata rd_doload;	/* 1 = load RAM disk, 0 = don't load */
@@ -283,11 +284,11 @@ static void __init get_fs_names(char *pa
 
 static int __init do_mount_root(char *name, char *fs, int flags, void *data)
 {
-	int err = sys_mount(name, "/root", fs, flags, data);
+	int err = kernel_sys_mount(name, "/root", fs, flags, data);
 	if (err)
 		return err;
 
-	sys_chdir((const char __user __force *)"/root");
+	kernel_sys_chdir("/root");
 	ROOT_DEV = current->fs->pwd.mnt->mnt_sb->s_dev;
 	printk("VFS: Mounted root (%s filesystem)%s on device %u:%u.\n",
 	       current->fs->pwd.mnt->mnt_sb->s_type->name,
@@ -353,7 +354,7 @@ retry:
 out:
 	putname(fs_names);
 }
- 
+
 #ifdef CONFIG_ROOT_NFS
 static int __init mount_nfs_root(void)
 {
@@ -378,21 +379,21 @@ void __init change_floppy(char *fmt, ...
 	va_start(args, fmt);
 	vsprintf(buf, fmt, args);
 	va_end(args);
-	fd = sys_open("/dev/root", O_RDWR | O_NDELAY, 0);
+	fd = kernel_sys_open("/dev/root", O_RDWR | O_NDELAY, 0);
 	if (fd >= 0) {
-		sys_ioctl(fd, FDEJECT, 0);
-		sys_close(fd);
+		kernel_sys_ioctl(fd, FDEJECT, 0);
+		kernel_sys_close(fd);
 	}
 	printk(KERN_NOTICE "VFS: Insert %s and press ENTER\n", buf);
-	fd = sys_open("/dev/console", O_RDWR, 0);
+	fd = kernel_sys_open("/dev/console", O_RDWR, 0);
 	if (fd >= 0) {
-		sys_ioctl(fd, TCGETS, (long)&termios);
+		kernel_sys_ioctl(fd, TCGETS, (long)&termios);
 		termios.c_lflag &= ~ICANON;
-		sys_ioctl(fd, TCSETSF, (long)&termios);
-		sys_read(fd, &c, 1);
+		kernel_sys_ioctl(fd, TCSETSF, (long)&termios);
+		kernel_sys_read(fd, &c, 1);
 		termios.c_lflag |= ICANON;
-		sys_ioctl(fd, TCSETSF, (long)&termios);
-		sys_close(fd);
+		kernel_sys_ioctl(fd, TCSETSF, (long)&termios);
+		kernel_sys_close(fd);
 	}
 }
 #endif
@@ -483,6 +484,6 @@ void __init prepare_namespace(void)
 	mount_root();
 out:
 	devtmpfs_mount("dev");
-	sys_mount(".", "/", NULL, MS_MOVE, NULL);
-	sys_chroot((const char __user __force *)".");
+	kernel_sys_mount(".", "/", NULL, MS_MOVE, NULL);
+	kernel_sys_chroot(".");
 }
diff -puN init/do_mounts_initrd.c~init-use-kernel_sys_-wrappers-instead-of-syscall init/do_mounts_initrd.c
--- a/init/do_mounts_initrd.c~init-use-kernel_sys_-wrappers-instead-of-syscall
+++ a/init/do_mounts_initrd.c
@@ -8,6 +8,7 @@
 #include <linux/sched.h>
 #include <linux/freezer.h>
 
+#include "sys-wrapper.h"
 #include "do_mounts.h"
 
 unsigned long initrd_start, initrd_end;
@@ -30,8 +31,9 @@ static int __init do_linuxrc(void *_shel
 	extern const char *envp_init[];
 	const char *shell = _shell;
 
-	sys_close(old_fd);sys_close(root_fd);
-	sys_setsid();
+	kernel_sys_close(old_fd);
+	kernel_sys_close(root_fd);
+	kernel_sys_setsid();
 	return kernel_execve(shell, argv, envp_init);
 }
 
@@ -44,13 +46,13 @@ static void __init handle_initrd(void)
 	create_dev("/dev/root.old", Root_RAM0);
 	/* mount initrd on rootfs' /root */
 	mount_block_root("/dev/root.old", root_mountflags & ~MS_RDONLY);
-	sys_mkdir("/old", 0700);
-	root_fd = sys_open("/", 0, 0);
-	old_fd = sys_open("/old", 0, 0);
+	kernel_sys_mkdir("/old", 0700);
+	root_fd = kernel_sys_open("/", 0, 0);
+	old_fd = kernel_sys_open("/old", 0, 0);
 	/* move initrd over / and chdir/chroot in initrd root */
-	sys_chdir("/root");
-	sys_mount(".", "/", NULL, MS_MOVE, NULL);
-	sys_chroot(".");
+	kernel_sys_chdir("/root");
+	kernel_sys_mount(".", "/", NULL, MS_MOVE, NULL);
+	kernel_sys_chroot(".");
 
 	/*
 	 * In case that a resume from disk is carried out by linuxrc or one of
@@ -60,22 +62,22 @@ static void __init handle_initrd(void)
 
 	pid = kernel_thread(do_linuxrc, "/linuxrc", SIGCHLD);
 	if (pid > 0)
-		while (pid != sys_wait4(-1, NULL, 0, NULL))
+		while (pid != kernel_sys_wait4(-1, NULL, 0, NULL))
 			yield();
 
 	current->flags &= ~PF_FREEZER_SKIP;
 
 	/* move initrd to rootfs' /old */
-	sys_fchdir(old_fd);
-	sys_mount("/", ".", NULL, MS_MOVE, NULL);
+	kernel_sys_fchdir(old_fd);
+	kernel_sys_mount("/", ".", NULL, MS_MOVE, NULL);
 	/* switch root and cwd back to / of rootfs */
-	sys_fchdir(root_fd);
-	sys_chroot(".");
-	sys_close(old_fd);
-	sys_close(root_fd);
+	kernel_sys_fchdir(root_fd);
+	kernel_sys_chroot(".");
+	kernel_sys_close(old_fd);
+	kernel_sys_close(root_fd);
 
 	if (new_decode_dev(real_root_dev) == Root_RAM0) {
-		sys_chdir("/old");
+		kernel_sys_chdir("/old");
 		return;
 	}
 
@@ -83,23 +85,23 @@ static void __init handle_initrd(void)
 	mount_root();
 
 	printk(KERN_NOTICE "Trying to move old root to /initrd ... ");
-	error = sys_mount("/old", "/root/initrd", NULL, MS_MOVE, NULL);
+	error = kernel_sys_mount("/old", "/root/initrd", NULL, MS_MOVE, NULL);
 	if (!error)
 		printk("okay\n");
 	else {
-		int fd = sys_open("/dev/root.old", O_RDWR, 0);
+		int fd = kernel_sys_open("/dev/root.old", O_RDWR, 0);
 		if (error == -ENOENT)
 			printk("/initrd does not exist. Ignored.\n");
 		else
 			printk("failed\n");
 		printk(KERN_NOTICE "Unmounting old root\n");
-		sys_umount("/old", MNT_DETACH);
+		kernel_sys_umount("/old", MNT_DETACH);
 		printk(KERN_NOTICE "Trying to free ramdisk memory ... ");
 		if (fd < 0) {
 			error = fd;
 		} else {
-			error = sys_ioctl(fd, BLKFLSBUF, 0);
-			sys_close(fd);
+			error = kernel_sys_ioctl(fd, BLKFLSBUF, 0);
+			kernel_sys_close(fd);
 		}
 		printk(!error ? "okay\n" : "failed\n");
 	}
@@ -116,11 +118,11 @@ int __init initrd_load(void)
 		 * mounted in the normal path.
 		 */
 		if (rd_load_image("/initrd.image") && ROOT_DEV != Root_RAM0) {
-			sys_unlink("/initrd.image");
+			kernel_sys_unlink("/initrd.image");
 			handle_initrd();
 			return 1;
 		}
 	}
-	sys_unlink("/initrd.image");
+	kernel_sys_unlink("/initrd.image");
 	return 0;
 }
diff -puN init/do_mounts_md.c~init-use-kernel_sys_-wrappers-instead-of-syscall init/do_mounts_md.c
--- a/init/do_mounts_md.c~init-use-kernel_sys_-wrappers-instead-of-syscall
+++ a/init/do_mounts_md.c
@@ -2,6 +2,7 @@
 #include <linux/raid/md_u.h>
 #include <linux/raid/md_p.h>
 
+#include "sys-wrapper.h"
 #include "do_mounts.h"
 
 /*
@@ -170,17 +171,17 @@ static void __init md_setup_drive(void)
 			partitioned ? "_d" : "", minor,
 			md_setup_args[ent].device_names);
 
-		fd = sys_open(name, 0, 0);
+		fd = kernel_sys_open(name, 0, 0);
 		if (fd < 0) {
 			printk(KERN_ERR "md: open failed - cannot start "
 					"array %s\n", name);
 			continue;
 		}
-		if (sys_ioctl(fd, SET_ARRAY_INFO, 0) == -EBUSY) {
+		if (kernel_sys_ioctl(fd, SET_ARRAY_INFO, 0) == -EBUSY) {
 			printk(KERN_WARNING
 			       "md: Ignoring md=%d, already autodetected. (Use raid=noautodetect)\n",
 			       minor);
-			sys_close(fd);
+			kernel_sys_close(fd);
 			continue;
 		}
 
@@ -199,7 +200,7 @@ static void __init md_setup_drive(void)
 			ainfo.state = (1 << MD_SB_CLEAN);
 			ainfo.layout = 0;
 			ainfo.chunk_size = md_setup_args[ent].chunk;
-			err = sys_ioctl(fd, SET_ARRAY_INFO, (long)&ainfo);
+			err = kernel_sys_ioctl(fd, SET_ARRAY_INFO, (long)&ainfo);
 			for (i = 0; !err && i <= MD_SB_DISKS; i++) {
 				dev = devices[i];
 				if (!dev)
@@ -209,7 +210,7 @@ static void __init md_setup_drive(void)
 				dinfo.state = (1<<MD_DISK_ACTIVE)|(1<<MD_DISK_SYNC);
 				dinfo.major = MAJOR(dev);
 				dinfo.minor = MINOR(dev);
-				err = sys_ioctl(fd, ADD_NEW_DISK, (long)&dinfo);
+				err = kernel_sys_ioctl(fd, ADD_NEW_DISK, (long)&dinfo);
 			}
 		} else {
 			/* persistent */
@@ -219,11 +220,11 @@ static void __init md_setup_drive(void)
 					break;
 				dinfo.major = MAJOR(dev);
 				dinfo.minor = MINOR(dev);
-				sys_ioctl(fd, ADD_NEW_DISK, (long)&dinfo);
+				kernel_sys_ioctl(fd, ADD_NEW_DISK, (long)&dinfo);
 			}
 		}
 		if (!err)
-			err = sys_ioctl(fd, RUN_ARRAY, 0);
+			err = kernel_sys_ioctl(fd, RUN_ARRAY, 0);
 		if (err)
 			printk(KERN_WARNING "md: starting md%d failed\n", minor);
 		else {
@@ -232,11 +233,11 @@ static void __init md_setup_drive(void)
 			 * boot a kernel with devfs compiled in from partitioned md
 			 * array without it
 			 */
-			sys_close(fd);
-			fd = sys_open(name, 0, 0);
-			sys_ioctl(fd, BLKRRPART, 0);
+			kernel_sys_close(fd);
+			fd = kernel_sys_open(name, 0, 0);
+			kernel_sys_ioctl(fd, BLKRRPART, 0);
 		}
-		sys_close(fd);
+		kernel_sys_close(fd);
 	}
 }
 
@@ -283,10 +284,10 @@ static void __init autodetect_raid(void)
 
 	wait_for_device_probe();
 
-	fd = sys_open((const char __user __force *) "/dev/md0", 0, 0);
+	fd = kernel_sys_open("/dev/md0", 0, 0);
 	if (fd >= 0) {
-		sys_ioctl(fd, RAID_AUTORUN, raid_autopart);
-		sys_close(fd);
+		kernel_sys_ioctl(fd, RAID_AUTORUN, raid_autopart);
+		kernel_sys_close(fd);
 	}
 }
 
diff -puN init/do_mounts_rd.c~init-use-kernel_sys_-wrappers-instead-of-syscall init/do_mounts_rd.c
--- a/init/do_mounts_rd.c~init-use-kernel_sys_-wrappers-instead-of-syscall
+++ a/init/do_mounts_rd.c
@@ -9,8 +9,9 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 
-#include "do_mounts.h"
 #include "../fs/squashfs/squashfs_fs.h"
+#include "sys-wrapper.h"
+#include "do_mounts.h"
 
 #include <linux/decompress/generic.h>
 
@@ -76,8 +77,8 @@ identify_ramdisk_image(int fd, int start
 	/*
 	 * Read block 0 to test for compressed kernel
 	 */
-	sys_lseek(fd, start_block * BLOCK_SIZE, 0);
-	sys_read(fd, buf, size);
+	kernel_sys_lseek(fd, start_block * BLOCK_SIZE, 0);
+	kernel_sys_read(fd, buf, size);
 
 	*decompressor = decompress_method(buf, size, &compress_name);
 	if (compress_name) {
@@ -122,8 +123,8 @@ identify_ramdisk_image(int fd, int start
 	/*
 	 * Read block 1 to test for minix and ext2 superblock
 	 */
-	sys_lseek(fd, (start_block+1) * BLOCK_SIZE, 0);
-	sys_read(fd, buf, size);
+	kernel_sys_lseek(fd, (start_block+1) * BLOCK_SIZE, 0);
+	kernel_sys_read(fd, buf, size);
 
 	/* Try minix */
 	if (minixsb->s_magic == MINIX_SUPER_MAGIC ||
@@ -150,7 +151,7 @@ identify_ramdisk_image(int fd, int start
 	       start_block);
 
 done:
-	sys_lseek(fd, start_block * BLOCK_SIZE, 0);
+	kernel_sys_lseek(fd, start_block * BLOCK_SIZE, 0);
 	kfree(buf);
 	return nblocks;
 }
@@ -168,11 +169,11 @@ int __init rd_load_image(char *from)
 	char rotator[4] = { '|' , '/' , '-' , '\\' };
 #endif
 
-	out_fd = sys_open((const char __user __force *) "/dev/ram", O_RDWR, 0);
+	out_fd = kernel_sys_open("/dev/ram", O_RDWR, 0);
 	if (out_fd < 0)
 		goto out;
 
-	in_fd = sys_open(from, O_RDONLY, 0);
+	in_fd = kernel_sys_open(from, O_RDONLY, 0);
 	if (in_fd < 0)
 		goto noclose_input;
 
@@ -197,7 +198,7 @@ int __init rd_load_image(char *from)
 	 * silly to use anything else, so make sure to use 1KiB
 	 * blocksize while generating ext2fs ramdisk-images.
 	 */
-	if (sys_ioctl(out_fd, BLKGETSIZE, (unsigned long)&rd_blocks) < 0)
+	if (kernel_sys_ioctl(out_fd, BLKGETSIZE, (unsigned long)&rd_blocks) < 0)
 		rd_blocks = 0;
 	else
 		rd_blocks >>= 1;
@@ -211,7 +212,7 @@ int __init rd_load_image(char *from)
 	/*
 	 * OK, time to copy in the data
 	 */
-	if (sys_ioctl(in_fd, BLKGETSIZE, (unsigned long)&devblocks) < 0)
+	if (kernel_sys_ioctl(in_fd, BLKGETSIZE, (unsigned long)&devblocks) < 0)
 		devblocks = 0;
 	else
 		devblocks >>= 1;
@@ -236,20 +237,20 @@ int __init rd_load_image(char *from)
 		if (i && (i % devblocks == 0)) {
 			printk("done disk #%d.\n", disk++);
 			rotate = 0;
-			if (sys_close(in_fd)) {
+			if (kernel_sys_close(in_fd)) {
 				printk("Error closing the disk.\n");
 				goto noclose_input;
 			}
 			change_floppy("disk #%d", disk);
-			in_fd = sys_open(from, O_RDONLY, 0);
+			in_fd = kernel_sys_open(from, O_RDONLY, 0);
 			if (in_fd < 0)  {
 				printk("Error opening disk.\n");
 				goto noclose_input;
 			}
 			printk("Loading disk #%d... ", disk);
 		}
-		sys_read(in_fd, buf, BLOCK_SIZE);
-		sys_write(out_fd, buf, BLOCK_SIZE);
+		kernel_sys_read(in_fd, buf, BLOCK_SIZE);
+		kernel_sys_write(out_fd, buf, BLOCK_SIZE);
 #if !defined(CONFIG_S390) && !defined(CONFIG_PPC_ISERIES)
 		if (!(i % 16)) {
 			printk("%c\b", rotator[rotate & 0x3]);
@@ -262,12 +263,12 @@ int __init rd_load_image(char *from)
 successful_load:
 	res = 1;
 done:
-	sys_close(in_fd);
+	kernel_sys_close(in_fd);
 noclose_input:
-	sys_close(out_fd);
+	kernel_sys_close(out_fd);
 out:
 	kfree(buf);
-	sys_unlink((const char __user __force *) "/dev/ram");
+	kernel_sys_unlink("/dev/ram");
 	return res;
 }
 
@@ -286,7 +287,7 @@ static int crd_infd, crd_outfd;
 
 static int __init compr_fill(void *buf, unsigned int len)
 {
-	int r = sys_read(crd_infd, buf, len);
+	int r = kernel_sys_read(crd_infd, buf, len);
 	if (r < 0)
 		printk(KERN_ERR "RAMDISK: error while reading compressed data");
 	else if (r == 0)
@@ -296,7 +297,7 @@ static int __init compr_fill(void *buf, 
 
 static int __init compr_flush(void *window, unsigned int outcnt)
 {
-	int written = sys_write(crd_outfd, window, outcnt);
+	int written = kernel_sys_write(crd_outfd, window, outcnt);
 	if (written != outcnt) {
 		if (decompress_error == 0)
 			printk(KERN_ERR
diff -puN init/initramfs.c~init-use-kernel_sys_-wrappers-instead-of-syscall init/initramfs.c
--- a/init/initramfs.c~init-use-kernel_sys_-wrappers-instead-of-syscall
+++ a/init/initramfs.c
@@ -9,6 +9,8 @@
 #include <linux/syscalls.h>
 #include <linux/utime.h>
 
+#include "sys-wrapper.h"
+
 static __initdata char *message;
 static void __init error(char *x)
 {
@@ -271,7 +273,7 @@ static int __init maybe_link(void)
 	if (nlink >= 2) {
 		char *old = find_link(major, minor, ino, mode, collected);
 		if (old)
-			return (sys_link(old, collected) < 0) ? -1 : 1;
+			return (kernel_sys_link(old, collected) < 0) ? -1 : 1;
 	}
 	return 0;
 }
@@ -280,11 +282,11 @@ static void __init clean_path(char *path
 {
 	struct stat st;
 
-	if (!sys_newlstat(path, &st) && (st.st_mode^mode) & S_IFMT) {
+	if (!kernel_sys_newlstat(path, &st) && (st.st_mode^mode) & S_IFMT) {
 		if (S_ISDIR(st.st_mode))
-			sys_rmdir(path);
+			kernel_sys_rmdir(path);
 		else
-			sys_unlink(path);
+			kernel_sys_unlink(path);
 	}
 }
 
@@ -305,28 +307,28 @@ static int __init do_name(void)
 			int openflags = O_WRONLY|O_CREAT;
 			if (ml != 1)
 				openflags |= O_TRUNC;
-			wfd = sys_open(collected, openflags, mode);
+			wfd = kernel_sys_open(collected, openflags, mode);
 
 			if (wfd >= 0) {
-				sys_fchown(wfd, uid, gid);
-				sys_fchmod(wfd, mode);
+				kernel_sys_fchown(wfd, uid, gid);
+				kernel_sys_fchmod(wfd, mode);
 				if (body_len)
-					sys_ftruncate(wfd, body_len);
+					kernel_sys_ftruncate(wfd, body_len);
 				vcollected = kstrdup(collected, GFP_KERNEL);
 				state = CopyFile;
 			}
 		}
 	} else if (S_ISDIR(mode)) {
-		sys_mkdir(collected, mode);
-		sys_chown(collected, uid, gid);
-		sys_chmod(collected, mode);
+		kernel_sys_mkdir(collected, mode);
+		kernel_sys_chown(collected, uid, gid);
+		kernel_sys_chmod(collected, mode);
 		dir_add(collected, mtime);
 	} else if (S_ISBLK(mode) || S_ISCHR(mode) ||
 		   S_ISFIFO(mode) || S_ISSOCK(mode)) {
 		if (maybe_link() == 0) {
-			sys_mknod(collected, mode, rdev);
-			sys_chown(collected, uid, gid);
-			sys_chmod(collected, mode);
+			kernel_sys_mknod(collected, mode, rdev);
+			kernel_sys_chown(collected, uid, gid);
+			kernel_sys_chmod(collected, mode);
 			do_utime(collected, mtime);
 		}
 	}
@@ -336,15 +338,15 @@ static int __init do_name(void)
 static int __init do_copy(void)
 {
 	if (count >= body_len) {
-		sys_write(wfd, victim, body_len);
-		sys_close(wfd);
+		kernel_sys_write(wfd, victim, body_len);
+		kernel_sys_close(wfd);
 		do_utime(vcollected, mtime);
 		kfree(vcollected);
 		eat(body_len);
 		state = SkipIt;
 		return 0;
 	} else {
-		sys_write(wfd, victim, count);
+		kernel_sys_write(wfd, victim, count);
 		body_len -= count;
 		eat(count);
 		return 1;
@@ -355,8 +357,8 @@ static int __init do_symlink(void)
 {
 	collected[N_ALIGN(name_len) + body_len] = '\0';
 	clean_path(collected, 0);
-	sys_symlink(collected + N_ALIGN(name_len), collected);
-	sys_lchown(collected, uid, gid);
+	kernel_sys_symlink(collected + N_ALIGN(name_len), collected);
+	kernel_sys_lchown(collected, uid, gid);
 	do_utime(collected, mtime);
 	state = SkipIt;
 	next_state = Reset;
@@ -528,31 +530,31 @@ static void __init clean_rootfs(void)
 	struct linux_dirent64 *dirp;
 	int num;
 
-	fd = sys_open((const char __user __force *) "/", O_RDONLY, 0);
+	fd = kernel_sys_open("/", O_RDONLY, 0);
 	WARN_ON(fd < 0);
 	if (fd < 0)
 		return;
 	buf = kzalloc(BUF_SIZE, GFP_KERNEL);
 	WARN_ON(!buf);
 	if (!buf) {
-		sys_close(fd);
+		kernel_sys_close(fd);
 		return;
 	}
 
 	dirp = buf;
-	num = sys_getdents64(fd, dirp, BUF_SIZE);
+	num = kernel_sys_getdents64(fd, dirp, BUF_SIZE);
 	while (num > 0) {
 		while (num > 0) {
 			struct stat st;
 			int ret;
 
-			ret = sys_newlstat(dirp->d_name, &st);
+			ret = kernel_sys_newlstat(dirp->d_name, &st);
 			WARN_ON_ONCE(ret);
 			if (!ret) {
 				if (S_ISDIR(st.st_mode))
-					sys_rmdir(dirp->d_name);
+					kernel_sys_rmdir(dirp->d_name);
 				else
-					sys_unlink(dirp->d_name);
+					kernel_sys_unlink(dirp->d_name);
 			}
 
 			num -= dirp->d_reclen;
@@ -560,10 +562,10 @@ static void __init clean_rootfs(void)
 		}
 		dirp = buf;
 		memset(buf, 0, BUF_SIZE);
-		num = sys_getdents64(fd, dirp, BUF_SIZE);
+		num = kernel_sys_getdents64(fd, dirp, BUF_SIZE);
 	}
 
-	sys_close(fd);
+	kernel_sys_close(fd);
 	kfree(buf);
 }
 #endif
@@ -590,12 +592,12 @@ static int __init populate_rootfs(void)
 		}
 		printk(KERN_INFO "rootfs image is not initramfs (%s)"
 				"; looks like an initrd\n", err);
-		fd = sys_open((const char __user __force *) "/initrd.image",
-			      O_WRONLY|O_CREAT, 0700);
+		fd = kernel_sys_open("/initrd.image",
+				     O_WRONLY|O_CREAT, 0700);
 		if (fd >= 0) {
-			sys_write(fd, (char *)initrd_start,
+			kernel_sys_write(fd, (char *)initrd_start,
 					initrd_end - initrd_start);
-			sys_close(fd);
+			kernel_sys_close(fd);
 			free_initrd();
 		}
 #else
diff -puN init/main.c~init-use-kernel_sys_-wrappers-instead-of-syscall init/main.c
--- a/init/main.c~init-use-kernel_sys_-wrappers-instead-of-syscall
+++ a/init/main.c
@@ -6,7 +6,7 @@
  *  GK 2/5/95  -  Changed to support mounting root fs via NFS
  *  Added initrd & change_root: Werner Almesberger & Hans Lermen, Feb '96
  *  Moan early if gcc is old, avoiding bogus kernels - Paul Gortmaker, May '96
- *  Simplified starting of init:  Michael A. Griffith <grif@acm.org> 
+ *  Simplified starting of init:  Michael A. Griffith <grif@acm.org>
  */
 
 #include <linux/types.h>
@@ -79,6 +79,8 @@
 #include <asm/smp.h>
 #endif
 
+#include "sys-wrapper.h"
+
 static int kernel_init(void *);
 
 extern void init_IRQ(void);
@@ -893,11 +895,11 @@ static int __init kernel_init(void * unu
 	do_basic_setup();
 
 	/* Open the /dev/console on the rootfs, this should never fail */
-	if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
+	if (kernel_sys_open("/dev/console", O_RDWR, 0) < 0)
 		printk(KERN_WARNING "Warning: unable to open an initial console.\n");
 
-	(void) sys_dup(0);
-	(void) sys_dup(0);
+	(void) kernel_sys_dup(0);
+	(void) kernel_sys_dup(0);
 	/*
 	 * check if there is an early userspace init.  If yes, let it do all
 	 * the work
@@ -906,7 +908,7 @@ static int __init kernel_init(void * unu
 	if (!ramdisk_execute_command)
 		ramdisk_execute_command = "/init";
 
-	if (sys_access((const char __user *) ramdisk_execute_command, 0) != 0) {
+	if (kernel_sys_access(ramdisk_execute_command, 0) != 0) {
 		ramdisk_execute_command = NULL;
 		prepare_namespace();
 	}
diff -puN init/noinitramfs.c~init-use-kernel_sys_-wrappers-instead-of-syscall init/noinitramfs.c
--- a/init/noinitramfs.c~init-use-kernel_sys_-wrappers-instead-of-syscall
+++ a/init/noinitramfs.c
@@ -22,6 +22,8 @@
 #include <linux/kdev_t.h>
 #include <linux/syscalls.h>
 
+#include "sys-wrapper.h"
+
 /*
  * Create a simple rootfs that is similar to the default initramfs
  */
@@ -29,17 +31,17 @@ static int __init default_rootfs(void)
 {
 	int err;
 
-	err = sys_mkdir((const char __user __force *) "/dev", 0755);
+	err = kernel_sys_mkdir("/dev", 0755);
 	if (err < 0)
 		goto out;
 
-	err = sys_mknod((const char __user __force *) "/dev/console",
-			S_IFCHR | S_IRUSR | S_IWUSR,
-			new_encode_dev(MKDEV(5, 1)));
+	err = kernel_sys_mknod("/dev/console",
+			     S_IFCHR | S_IRUSR | S_IWUSR,
+			     new_encode_dev(MKDEV(5, 1)));
 	if (err < 0)
 		goto out;
 
-	err = sys_mkdir((const char __user __force *) "/root", 0700);
+	err = kernel_sys_mkdir("/root", 0700);
 	if (err < 0)
 		goto out;
 
_

Patches currently in -mm which might be from namhyung@gmail.com are

linux-next.patch
init-mark-__user-address-space-on-string-literals.patch
init-add-sys-wrapperh.patch
init-use-kernel_sys_-wrappers-instead-of-syscall.patch
exit-add-lock-context-annotation-on-find_new_reaper.patch

