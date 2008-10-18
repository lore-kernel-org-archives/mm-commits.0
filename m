From: akpm@linux-foundation.org
Subject: - initramfs-add-option-to-preserve-mtime-from-initramfs-cpio-images.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:11:41 -0700
Message-ID: <200810182311.m9INBfnh027769@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209AbYJRXLq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:11:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nyet@nyet.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     initramfs: add option to preserve mtime from initramfs cpio images
has been removed from the -mm tree.  Its filename was
     initramfs-add-option-to-preserve-mtime-from-initramfs-cpio-images.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: initramfs: add option to preserve mtime from initramfs cpio images
From: Nye Liu <nyet@nyet.org>

When unpacking the cpio into the initramfs, mtimes are not preserved by
default.  This patch adds an INITRAMFS_PRESERVE_MTIME option that allows
mtimes stored in the cpio image to be used when constructing the
initramfs.

For embedded applications that run exclusively out of the initramfs, this
is invaluable:

When building embedded application initramfs images, its nice to know when
the files were actually created during the build process - that makes it
easier to see what files were modified when so we can compare the files
that are being used on the image with the files used during the build
process.  This might help (for example) to determine if the target system
has all the updated files you expect to see w/o having to check MD5s etc.

In our environment, the whole system runs off the initramfs partition, and
seeing the modified times of the shared libraries (for example) helps us
find bugs that may have been introduced by the build system incorrectly
propogating outdated shared libraries into the image.

Similarly, many of the initializion/configuration files in /etc might be
dynamically built by the build system, and knowing when they were modified
helps us sanity check whether the target system has the "latest" files
etc.

Finally, we might use last modified times to determine whether a hot fix
should be applied or not to the running ramfs.

Signed-off-by: Nye Liu <nyet@nyet.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |   53 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff -puN init/initramfs.c~initramfs-add-option-to-preserve-mtime-from-initramfs-cpio-images init/initramfs.c
--- a/init/initramfs.c~initramfs-add-option-to-preserve-mtime-from-initramfs-cpio-images
+++ a/init/initramfs.c
@@ -6,6 +6,7 @@
 #include <linux/delay.h>
 #include <linux/string.h>
 #include <linux/syscalls.h>
+#include <linux/utime.h>
 
 static __initdata char *message;
 static void __init error(char *x)
@@ -72,6 +73,49 @@ static void __init free_hash(void)
 	}
 }
 
+static long __init do_utime(char __user *filename, time_t mtime)
+{
+	struct timespec t[2];
+
+	t[0].tv_sec = mtime;
+	t[0].tv_nsec = 0;
+	t[1].tv_sec = mtime;
+	t[1].tv_nsec = 0;
+
+	return do_utimes(AT_FDCWD, filename, t, AT_SYMLINK_NOFOLLOW);
+}
+
+static __initdata LIST_HEAD(dir_list);
+struct dir_entry {
+	struct list_head list;
+	char *name;
+	time_t mtime;
+};
+
+static void __init dir_add(const char *name, time_t mtime)
+{
+	struct dir_entry *de = kmalloc(sizeof(struct dir_entry), GFP_KERNEL);
+	if (!de)
+		panic("can't allocate dir_entry buffer");
+	INIT_LIST_HEAD(&de->list);
+	de->name = kstrdup(name, GFP_KERNEL);
+	de->mtime = mtime;
+	list_add(&de->list, &dir_list);
+}
+
+static void __init dir_utime(void)
+{
+	struct dir_entry *de, *tmp;
+	list_for_each_entry_safe(de, tmp, &dir_list, list) {
+		list_del(&de->list);
+		do_utime(de->name, de->mtime);
+		kfree(de->name);
+		kfree(de);
+	}
+}
+
+static __initdata time_t mtime;
+
 /* cpio header parsing */
 
 static __initdata unsigned long ino, major, minor, nlink;
@@ -97,6 +141,7 @@ static void __init parse_header(char *s)
 	uid = parsed[2];
 	gid = parsed[3];
 	nlink = parsed[4];
+	mtime = parsed[5];
 	body_len = parsed[6];
 	major = parsed[7];
 	minor = parsed[8];
@@ -130,6 +175,7 @@ static inline void __init eat(unsigned n
 	count -= n;
 }
 
+static __initdata char *vcollected;
 static __initdata char *collected;
 static __initdata int remains;
 static __initdata char *collect;
@@ -271,6 +317,7 @@ static int __init do_name(void)
 			if (wfd >= 0) {
 				sys_fchown(wfd, uid, gid);
 				sys_fchmod(wfd, mode);
+				vcollected = kstrdup(collected, GFP_KERNEL);
 				state = CopyFile;
 			}
 		}
@@ -278,12 +325,14 @@ static int __init do_name(void)
 		sys_mkdir(collected, mode);
 		sys_chown(collected, uid, gid);
 		sys_chmod(collected, mode);
+		dir_add(collected, mtime);
 	} else if (S_ISBLK(mode) || S_ISCHR(mode) ||
 		   S_ISFIFO(mode) || S_ISSOCK(mode)) {
 		if (maybe_link() == 0) {
 			sys_mknod(collected, mode, rdev);
 			sys_chown(collected, uid, gid);
 			sys_chmod(collected, mode);
+			do_utime(collected, mtime);
 		}
 	}
 	return 0;
@@ -294,6 +343,8 @@ static int __init do_copy(void)
 	if (count >= body_len) {
 		sys_write(wfd, victim, body_len);
 		sys_close(wfd);
+		do_utime(vcollected, mtime);
+		kfree(vcollected);
 		eat(body_len);
 		state = SkipIt;
 		return 0;
@@ -311,6 +362,7 @@ static int __init do_symlink(void)
 	clean_path(collected, 0);
 	sys_symlink(collected + N_ALIGN(name_len), collected);
 	sys_lchown(collected, uid, gid);
+	do_utime(collected, mtime);
 	state = SkipIt;
 	next_state = Reset;
 	return 0;
@@ -466,6 +518,7 @@ static char * __init unpack_to_rootfs(ch
 		buf += inptr;
 		len -= inptr;
 	}
+	dir_utime();
 	kfree(window);
 	kfree(name_buf);
 	kfree(symlink_buf);
_

Patches currently in -mm which might be from nyet@nyet.org are

origin.patch

