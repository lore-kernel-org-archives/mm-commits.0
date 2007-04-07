From: akpm@linux-foundation.org
Subject: + round_up-macro-cleanup-in-fs-selectcompatreaddirc.patch added to -mm tree
Date: Fri, 06 Apr 2007 18:08:32 -0700
Message-ID: <200704070108.l3718WMx024412@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41200 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933450AbXDGBIe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 21:08:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: milindchoudhary@gmail.com


The patch titled
     ROUND_UP macro cleanup in fs/(select|compat|readdir).c
has been added to the -mm tree.  Its filename is
     round_up-macro-cleanup-in-fs-selectcompatreaddirc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ROUND_UP macro cleanup in fs/(select|compat|readdir).c
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

ROUND_UP macro cleanup use,ALIGN or DIV_ROUND_UP where ever appropriate.

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c  |   20 ++++++++------------
 fs/readdir.c |    8 +++-----
 fs/select.c  |    8 ++++----
 3 files changed, 15 insertions(+), 21 deletions(-)

diff -puN fs/compat.c~round_up-macro-cleanup-in-fs-selectcompatreaddirc fs/compat.c
--- a/fs/compat.c~round_up-macro-cleanup-in-fs-selectcompatreaddirc
+++ a/fs/compat.c
@@ -15,6 +15,7 @@
  *  published by the Free Software Foundation.
  */
 
+#include <linux/kernel.h>
 #include <linux/linkage.h>
 #include <linux/compat.h>
 #include <linux/errno.h>
@@ -901,8 +902,6 @@ asmlinkage long compat_sys_mount(char __
 }
 
 #define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
-#define COMPAT_ROUND_UP(x) (((x)+sizeof(compat_long_t)-1) & \
-				~(sizeof(compat_long_t)-1))
 
 struct compat_old_linux_dirent {
 	compat_ulong_t	d_ino;
@@ -990,7 +989,7 @@ static int compat_filldir(void *__buf, c
 	struct compat_linux_dirent __user * dirent;
 	struct compat_getdents_callback *buf = __buf;
 	compat_ulong_t d_ino;
-	int reclen = COMPAT_ROUND_UP(NAME_OFFSET(dirent) + namlen + 2);
+	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 2, sizeof(compat_long_t));
 
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
@@ -1065,7 +1064,6 @@ out:
 }
 
 #ifndef __ARCH_OMIT_COMPAT_SYS_GETDENTS64
-#define COMPAT_ROUND_UP64(x) (((x)+sizeof(u64)-1) & ~(sizeof(u64)-1))
 
 struct compat_getdents_callback64 {
 	struct linux_dirent64 __user *current_dir;
@@ -1080,7 +1078,7 @@ static int compat_filldir64(void * __buf
 	struct linux_dirent64 __user *dirent;
 	struct compat_getdents_callback64 *buf = __buf;
 	int jj = NAME_OFFSET(dirent);
-	int reclen = COMPAT_ROUND_UP64(jj + namlen + 1);
+	int reclen = ALIGN(jj + namlen + 1, sizeof(u64));
 	u64 off;
 
 	buf->error = -EINVAL;	/* only used if we fail.. */
@@ -1593,8 +1591,6 @@ out_ret:
 
 #define __COMPAT_NFDBITS       (8 * sizeof(compat_ulong_t))
 
-#define ROUND_UP(x,y) (((x)+(y)-1)/(y))
-
 /*
  * Ooo, nasty.  We need here to frob 32-bit unsigned longs to
  * 64-bit unsigned longs.
@@ -1603,7 +1599,7 @@ static
 int compat_get_fd_set(unsigned long nr, compat_ulong_t __user *ufdset,
 			unsigned long *fdset)
 {
-	nr = ROUND_UP(nr, __COMPAT_NFDBITS);
+	nr = DIV_ROUND_UP(nr, __COMPAT_NFDBITS);
 	if (ufdset) {
 		unsigned long odd;
 
@@ -1637,7 +1633,7 @@ int compat_set_fd_set(unsigned long nr, 
 		      unsigned long *fdset)
 {
 	unsigned long odd;
-	nr = ROUND_UP(nr, __COMPAT_NFDBITS);
+	nr = DIV_ROUND_UP(nr, __COMPAT_NFDBITS);
 
 	if (!ufdset)
 		return 0;
@@ -1759,7 +1755,7 @@ asmlinkage long compat_sys_select(int n,
 		if ((u64)tv.tv_sec >= (u64)MAX_INT64_SECONDS)
 			timeout = -1;	/* infinite */
 		else {
-			timeout = ROUND_UP(tv.tv_usec, 1000000/HZ);
+			timeout = DIV_ROUND_UP(tv.tv_usec, 1000000/HZ);
 			timeout += tv.tv_sec * HZ;
 		}
 	}
@@ -1827,7 +1823,7 @@ asmlinkage long compat_sys_pselect7(int 
 	do {
 		if (tsp) {
 			if ((unsigned long)ts.tv_sec < MAX_SELECT_SECONDS) {
-				timeout = ROUND_UP(ts.tv_nsec, 1000000000/HZ);
+				timeout = DIV_ROUND_UP(ts.tv_nsec, 1000000000/HZ);
 				timeout += ts.tv_sec * (unsigned long)HZ;
 				ts.tv_sec = 0;
 				ts.tv_nsec = 0;
@@ -1923,7 +1919,7 @@ asmlinkage long compat_sys_ppoll(struct 
 		/* We assume that ts.tv_sec is always lower than
 		   the number of seconds that can be expressed in
 		   an s64. Otherwise the compiler bitches at us */
-		timeout = ROUND_UP(ts.tv_nsec, 1000000000/HZ);
+		timeout = DIV_ROUND_UP(ts.tv_nsec, 1000000000/HZ);
 		timeout += ts.tv_sec * HZ;
 	}
 
diff -puN fs/readdir.c~round_up-macro-cleanup-in-fs-selectcompatreaddirc fs/readdir.c
--- a/fs/readdir.c~round_up-macro-cleanup-in-fs-selectcompatreaddirc
+++ a/fs/readdir.c
@@ -4,6 +4,7 @@
  *  Copyright (C) 1995  Linus Torvalds
  */
 
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/time.h>
 #include <linux/mm.h>
@@ -51,7 +52,6 @@ EXPORT_SYMBOL(vfs_readdir);
  * case (the low-level handlers don't need to care about this).
  */
 #define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
-#define ROUND_UP(x) (((x)+sizeof(long)-1) & ~(sizeof(long)-1))
 
 #ifdef __ARCH_WANT_OLD_READDIR
 
@@ -146,7 +146,7 @@ static int filldir(void * __buf, const c
 	struct linux_dirent __user * dirent;
 	struct getdents_callback * buf = (struct getdents_callback *) __buf;
 	unsigned long d_ino;
-	int reclen = ROUND_UP(NAME_OFFSET(dirent) + namlen + 2);
+	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 2, sizeof(long));
 
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
@@ -219,8 +219,6 @@ out:
 	return error;
 }
 
-#define ROUND_UP64(x) (((x)+sizeof(u64)-1) & ~(sizeof(u64)-1))
-
 struct getdents_callback64 {
 	struct linux_dirent64 __user * current_dir;
 	struct linux_dirent64 __user * previous;
@@ -233,7 +231,7 @@ static int filldir64(void * __buf, const
 {
 	struct linux_dirent64 __user *dirent;
 	struct getdents_callback64 * buf = (struct getdents_callback64 *) __buf;
-	int reclen = ROUND_UP64(NAME_OFFSET(dirent) + namlen + 1);
+	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 1, sizeof(u64));
 
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
diff -puN fs/select.c~round_up-macro-cleanup-in-fs-selectcompatreaddirc fs/select.c
--- a/fs/select.c~round_up-macro-cleanup-in-fs-selectcompatreaddirc
+++ a/fs/select.c
@@ -14,6 +14,7 @@
  *     of fds to overcome nfds < 16390 descriptors limit (Tigran Aivazian).
  */
 
+#include <linux/kernel.h>
 #include <linux/syscalls.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -25,7 +26,6 @@
 
 #include <asm/uaccess.h>
 
-#define ROUND_UP(x,y) (((x)+(y)-1)/(y))
 #define DEFAULT_POLLMASK (POLLIN | POLLOUT | POLLRDNORM | POLLWRNORM)
 
 struct poll_table_page {
@@ -398,7 +398,7 @@ asmlinkage long sys_select(int n, fd_set
 		if ((u64)tv.tv_sec >= (u64)MAX_INT64_SECONDS)
 			timeout = -1;	/* infinite */
 		else {
-			timeout = ROUND_UP(tv.tv_usec, USEC_PER_SEC/HZ);
+			timeout = DIV_ROUND_UP(tv.tv_usec, USEC_PER_SEC/HZ);
 			timeout += tv.tv_sec * HZ;
 		}
 	}
@@ -453,7 +453,7 @@ asmlinkage long sys_pselect7(int n, fd_s
 		if ((u64)ts.tv_sec >= (u64)MAX_INT64_SECONDS)
 			timeout = -1;	/* infinite */
 		else {
-			timeout = ROUND_UP(ts.tv_nsec, NSEC_PER_SEC/HZ);
+			timeout = DIV_ROUND_UP(ts.tv_nsec, NSEC_PER_SEC/HZ);
 			timeout += ts.tv_sec * HZ;
 		}
 	}
@@ -775,7 +775,7 @@ asmlinkage long sys_ppoll(struct pollfd 
 		if ((u64)ts.tv_sec >= (u64)MAX_INT64_SECONDS)
 			timeout = -1;	/* infinite */
 		else {
-			timeout = ROUND_UP(ts.tv_nsec, NSEC_PER_SEC/HZ);
+			timeout = DIV_ROUND_UP(ts.tv_nsec, NSEC_PER_SEC/HZ);
 			timeout += ts.tv_sec * HZ;
 		}
 	}
_

Patches currently in -mm which might be from milindchoudhary@gmail.com are

unused-round_up-name_offset-macro-in-arch-powerpc.patch
round_up-macro-cleanup-in-drivers-net-ppp_genericc.patch
round_up-macro-cleanup-in-drivers-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch
round_up-macro-cleanup-in-drivers-char-lpc.patch
round_up-macro-cleanup-in-fs-selectcompatreaddirc.patch
