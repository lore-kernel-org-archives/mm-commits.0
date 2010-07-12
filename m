From: akpm@linux-foundation.org
Subject: + vfs-fix-warning-dirent-is-used-uninitialized-in-this-function.patch added to -mm tree
Date: Mon, 12 Jul 2010 14:43:37 -0700
Message-ID: <201007122143.o6CLhbxX030929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753779Ab0GLVns (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jul 2010 17:43:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kjwinchester@gmail.com, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     vfs: fix warning: 'dirent' is used uninitialized in this function
has been added to the -mm tree.  Its filename is
     vfs-fix-warning-dirent-is-used-uninitialized-in-this-function.patch

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
Subject: vfs: fix warning: 'dirent' is used uninitialized in this function
From: Kevin Winchester <kjwinchester@gmail.com>

Using:

	gcc (GCC) 4.5.0 20100610 (prerelease)

The following warnings appear:

	fs/readdir.c: In function `filldir64':
	fs/readdir.c:240:15: warning: `dirent' is used uninitialized in this function
	fs/readdir.c: In function `filldir':
	fs/readdir.c:155:15: warning: `dirent' is used uninitialized in this function
	fs/compat.c: In function `compat_filldir64':
	fs/compat.c:1071:11: warning: `dirent' is used uninitialized in this function
	fs/compat.c: In function `compat_filldir':
	fs/compat.c:984:15: warning: `dirent' is used uninitialized in this function

The warnings are related to the use of the NAME_OFFSET() macro.  Luckily,
it appears as though the standard offsetof() macro is what is being
implemented by NAME_OFFSET(), thus we can fix the warning and use a more
standard code construct at the same time.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c  |   10 +++++-----
 fs/readdir.c |    8 +++++---
 2 files changed, 10 insertions(+), 8 deletions(-)

diff -puN fs/compat.c~vfs-fix-warning-dirent-is-used-uninitialized-in-this-function fs/compat.c
--- a/fs/compat.c~vfs-fix-warning-dirent-is-used-uninitialized-in-this-function
+++ a/fs/compat.c
@@ -15,6 +15,7 @@
  *  published by the Free Software Foundation.
  */
 
+#include <linux/stddef.h>
 #include <linux/kernel.h>
 #include <linux/linkage.h>
 #include <linux/compat.h>
@@ -891,8 +892,6 @@ asmlinkage long compat_sys_mount(char __
 	return retval;
 }
 
-#define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
-
 struct compat_old_linux_dirent {
 	compat_ulong_t	d_ino;
 	compat_ulong_t	d_offset;
@@ -981,7 +980,8 @@ static int compat_filldir(void *__buf, c
 	struct compat_linux_dirent __user * dirent;
 	struct compat_getdents_callback *buf = __buf;
 	compat_ulong_t d_ino;
-	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 2, sizeof(compat_long_t));
+	int reclen = ALIGN(offsetof(struct compat_linux_dirent, d_name) +
+		namlen + 2, sizeof(compat_long_t));
 
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
@@ -1068,8 +1068,8 @@ static int compat_filldir64(void * __buf
 {
 	struct linux_dirent64 __user *dirent;
 	struct compat_getdents_callback64 *buf = __buf;
-	int jj = NAME_OFFSET(dirent);
-	int reclen = ALIGN(jj + namlen + 1, sizeof(u64));
+	int reclen = ALIGN(offsetof(struct linux_dirent64, d_name) + namlen + 1,
+		sizeof(u64));
 	u64 off;
 
 	buf->error = -EINVAL;	/* only used if we fail.. */
diff -puN fs/readdir.c~vfs-fix-warning-dirent-is-used-uninitialized-in-this-function fs/readdir.c
--- a/fs/readdir.c~vfs-fix-warning-dirent-is-used-uninitialized-in-this-function
+++ a/fs/readdir.c
@@ -4,6 +4,7 @@
  *  Copyright (C) 1995  Linus Torvalds
  */
 
+#include <linux/stddef.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/time.h>
@@ -54,7 +55,6 @@ EXPORT_SYMBOL(vfs_readdir);
  * anyway. Thus the special "fillonedir()" function for that
  * case (the low-level handlers don't need to care about this).
  */
-#define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
 
 #ifdef __ARCH_WANT_OLD_READDIR
 
@@ -152,7 +152,8 @@ static int filldir(void * __buf, const c
 	struct linux_dirent __user * dirent;
 	struct getdents_callback * buf = (struct getdents_callback *) __buf;
 	unsigned long d_ino;
-	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 2, sizeof(long));
+	int reclen = ALIGN(offsetof(struct linux_dirent, d_name) + namlen + 2,
+		sizeof(long));
 
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
@@ -237,7 +238,8 @@ static int filldir64(void * __buf, const
 {
 	struct linux_dirent64 __user *dirent;
 	struct getdents_callback64 * buf = (struct getdents_callback64 *) __buf;
-	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 1, sizeof(u64));
+	int reclen = ALIGN(offsetof(struct linux_dirent64, d_name) + namlen + 1,
+		sizeof(u64));
 
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
_

Patches currently in -mm which might be from kjwinchester@gmail.com are

linux-next.patch
vfs-fix-warning-dirent-is-used-uninitialized-in-this-function.patch
init-mainc-fix-warning-calltimetv64-may-be-used-uninitialized.patch
init-mainc-mark-do_one_initcall-as-__init_or_module.patch

