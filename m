From: akpm@linux-foundation.org
Subject: - round_up-macro-cleanup-in-fs-selectcompatreaddirc.patch removed from -mm tree
Date: Tue, 08 May 2007 19:49:08 -0700
Message-ID: <200705090249.l492n8Z0009191@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032101AbXEICtM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:49:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: milindchoudhary@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ROUND_UP macro cleanup in fs/(select|compat|readdir).c
has been removed from the -mm tree.  Its filename was
     round_up-macro-cleanup-in-fs-selectcompatreaddirc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -902,8 +903,6 @@ asmlinkage long compat_sys_mount(char __
 }
 
 #define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
-#define COMPAT_ROUND_UP(x) (((x)+sizeof(compat_long_t)-1) & \
-				~(sizeof(compat_long_t)-1))
 
 struct compat_old_linux_dirent {
 	compat_ulong_t	d_ino;
@@ -991,7 +990,7 @@ static int compat_filldir(void *__buf, c
 	struct compat_linux_dirent __user * dirent;
 	struct compat_getdents_callback *buf = __buf;
 	compat_ulong_t d_ino;
-	int reclen = COMPAT_ROUND_UP(NAME_OFFSET(dirent) + namlen + 2);
+	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 2, sizeof(compat_long_t));
 
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
@@ -1066,7 +1065,6 @@ out:
 }
 
 #ifndef __ARCH_OMIT_COMPAT_SYS_GETDENTS64
-#define COMPAT_ROUND_UP64(x) (((x)+sizeof(u64)-1) & ~(sizeof(u64)-1))
 
 struct compat_getdents_callback64 {
 	struct linux_dirent64 __user *current_dir;
@@ -1081,7 +1079,7 @@ static int compat_filldir64(void * __buf
 	struct linux_dirent64 __user *dirent;
 	struct compat_getdents_callback64 *buf = __buf;
 	int jj = NAME_OFFSET(dirent);
-	int reclen = COMPAT_ROUND_UP64(jj + namlen + 1);
+	int reclen = ALIGN(jj + namlen + 1, sizeof(u64));
 	u64 off;
 
 	buf->error = -EINVAL;	/* only used if we fail.. */
@@ -1594,8 +1592,6 @@ out_ret:
 
 #define __COMPAT_NFDBITS       (8 * sizeof(compat_ulong_t))
 
-#define ROUND_UP(x,y) (((x)+(y)-1)/(y))
-
 /*
  * Ooo, nasty.  We need here to frob 32-bit unsigned longs to
  * 64-bit unsigned longs.
@@ -1604,7 +1600,7 @@ static
 int compat_get_fd_set(unsigned long nr, compat_ulong_t __user *ufdset,
 			unsigned long *fdset)
 {
-	nr = ROUND_UP(nr, __COMPAT_NFDBITS);
+	nr = DIV_ROUND_UP(nr, __COMPAT_NFDBITS);
 	if (ufdset) {
 		unsigned long odd;
 
@@ -1638,7 +1634,7 @@ int compat_set_fd_set(unsigned long nr, 
 		      unsigned long *fdset)
 {
 	unsigned long odd;
-	nr = ROUND_UP(nr, __COMPAT_NFDBITS);
+	nr = DIV_ROUND_UP(nr, __COMPAT_NFDBITS);
 
 	if (!ufdset)
 		return 0;
@@ -1760,7 +1756,7 @@ asmlinkage long compat_sys_select(int n,
 		if ((u64)tv.tv_sec >= (u64)MAX_INT64_SECONDS)
 			timeout = -1;	/* infinite */
 		else {
-			timeout = ROUND_UP(tv.tv_usec, 1000000/HZ);
+			timeout = DIV_ROUND_UP(tv.tv_usec, 1000000/HZ);
 			timeout += tv.tv_sec * HZ;
 		}
 	}
@@ -1828,7 +1824,7 @@ asmlinkage long compat_sys_pselect7(int 
 	do {
 		if (tsp) {
 			if ((unsigned long)ts.tv_sec < MAX_SELECT_SECONDS) {
-				timeout = ROUND_UP(ts.tv_nsec, 1000000000/HZ);
+				timeout = DIV_ROUND_UP(ts.tv_nsec, 1000000000/HZ);
 				timeout += ts.tv_sec * (unsigned long)HZ;
 				ts.tv_sec = 0;
 				ts.tv_nsec = 0;
@@ -1924,7 +1920,7 @@ asmlinkage long compat_sys_ppoll(struct 
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

origin.patch
git-alsa.patch
git-ia64.patch
spin_lock_unlocked-macro-cleanup-in-arch-ia64.patch
nfs-use-__set_current_state.patch
round_up-macro-cleanup-in-drivers-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
pcie-remove-spin_lock_unlocked.patch
round_up-macro-cleanup-in-arch-sh64-kernel-pci_sh5c.patch
