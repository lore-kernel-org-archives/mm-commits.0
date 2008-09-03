From: akpm@linux-foundation.org
Subject: + initramfs-add-option-to-preserve-mtime-from-initramfs-cpio-images.patch added to -mm tree
Date: Wed, 03 Sep 2008 15:22:41 -0700
Message-ID: <200809032222.m83MMfe4007117@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753543AbYICWXQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2008 18:23:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nyet@nyet.org, viro@zeniv.linux.org.uk


The patch titled
     initramfs: add option to preserve mtime from initramfs cpio images
has been added to the -mm tree.  Its filename is
     initramfs-add-option-to-preserve-mtime-from-initramfs-cpio-images.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: initramfs: add option to preserve mtime from initramfs cpio images
From: Nye Liu <nyet@nyet.org>

When unpacking the cpio into the initramfs, mtimes are not preserved by
default.  This patch adds an INITRAMFS_PRESERVE_MTIME option that allows
mtimes stored in the cpio image to be used when constructing the
initramfs.  For embedded applications that run exclusively out of the
initramfs, this is invaluable.

Signed-off-by: Nye Liu <nyet@nyet.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |   55 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff -puN init/initramfs.c~initramfs-add-option-to-preserve-mtime-from-initramfs-cpio-images init/initramfs.c
--- a/init/initramfs.c~initramfs-add-option-to-preserve-mtime-from-initramfs-cpio-images
+++ a/init/initramfs.c
@@ -7,6 +7,7 @@
 #include <linux/string.h>
 #include <linux/dirent.h>
 #include <linux/syscalls.h>
+#include <linux/utime.h>
 
 static __initdata char *message;
 static void __init error(char *x)
@@ -73,6 +74,38 @@ static void __init free_hash(void)
 	}
 }
 
+static __initdata LIST_HEAD(dir_list);
+struct dir_entry {
+	struct list_head list;
+	char *name;
+	struct utimbuf mtime;
+};
+
+static void __init dir_add(const char *name, struct utimbuf mtime)
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
+	struct list_head *e, *tmp;
+	list_for_each_safe(e, tmp, &dir_list) {
+		struct dir_entry *de = list_entry(e, struct dir_entry, list);
+		list_del(e);
+		sys_utime(de->name, &de->mtime);
+		kfree(de->name);
+		kfree(de);
+	}
+}
+
+static __initdata struct utimbuf mtime;
+
 /* cpio header parsing */
 
 static __initdata unsigned long ino, major, minor, nlink;
@@ -98,6 +131,7 @@ static void __init parse_header(char *s)
 	uid = parsed[2];
 	gid = parsed[3];
 	nlink = parsed[4];
+	mtime.actime = mtime.modtime = parsed[5];
 	body_len = parsed[6];
 	major = parsed[7];
 	minor = parsed[8];
@@ -129,6 +163,7 @@ static inline void __init eat(unsigned n
 	count -= n;
 }
 
+static __initdata char *vcollected;
 static __initdata char *collected;
 static __initdata int remains;
 static __initdata char *collect;
@@ -264,6 +299,7 @@ static int __init do_name(void)
 			if (wfd >= 0) {
 				sys_fchown(wfd, uid, gid);
 				sys_fchmod(wfd, mode);
+				vcollected = kstrdup(collected, GFP_KERNEL);
 				state = CopyFile;
 			}
 		}
@@ -271,12 +307,14 @@ static int __init do_name(void)
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
+			sys_utime(collected, &mtime);
 		}
 	}
 	return 0;
@@ -287,6 +325,8 @@ static int __init do_copy(void)
 	if (count >= body_len) {
 		sys_write(wfd, victim, body_len);
 		sys_close(wfd);
+		sys_utime(vcollected, &mtime);
+		kfree(vcollected);
 		eat(body_len);
 		state = SkipIt;
 		return 0;
@@ -298,12 +338,26 @@ static int __init do_copy(void)
 	}
 }
 
+static long __init do_lutime(char __user *filename,
+	struct utimbuf __user *times)
+{
+	struct timespec t[2];
+
+	t[0].tv_sec = times->actime;
+	t[0].tv_nsec = 0;
+	t[1].tv_sec = times->modtime;
+	t[1].tv_nsec = 0;
+
+	return do_utimes(AT_FDCWD, filename, t, AT_SYMLINK_NOFOLLOW);
+}
+
 static int __init do_symlink(void)
 {
 	collected[N_ALIGN(name_len) + body_len] = '\0';
 	clean_path(collected, 0);
 	sys_symlink(collected + N_ALIGN(name_len), collected);
 	sys_lchown(collected, uid, gid);
+	do_lutime(collected, &mtime);
 	state = SkipIt;
 	next_state = Reset;
 	return 0;
@@ -458,6 +512,7 @@ static char * __init unpack_to_rootfs(ch
 		buf += inptr;
 		len -= inptr;
 	}
+	dir_utime();
 	kfree(window);
 	kfree(name_buf);
 	kfree(symlink_buf);
_

Patches currently in -mm which might be from nyet@nyet.org are

initramfs-add-option-to-preserve-mtime-from-initramfs-cpio-images.patch

