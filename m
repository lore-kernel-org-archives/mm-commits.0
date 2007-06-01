From: akpm@linux-foundation.org
Subject: + xtensa-use-asm-generic-fcntlh.patch added to -mm tree
Date: Thu, 31 May 2007 18:21:29 -0700
Message-ID: <200706010121.l511LS05032370@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757713AbXFABWF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2007 21:22:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, zankel@tensilica.com


The patch titled
     Xtensa: use asm-generic/fcntl.h
has been added to the -mm tree.  Its filename is
     xtensa-use-asm-generic-fcntlh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Xtensa: use asm-generic/fcntl.h
From: Stephen Rothwell <sfr@canb.auug.org.au>

Commit fc4fb2adf944d45a7f3d4d38df991c79ffdb6a43 "fixed" the Xtensa
asm/fcntl.h and in doing so ignored asm-generic/fcntl.h completely.
It turns out that it is now exactly the same as asm-generic/fcntl.h.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Chris Zankel <zankel@tensilica.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-xtensa/fcntl.h |  100 -----------------------------------
 1 file changed, 1 insertion(+), 99 deletions(-)

diff -puN include/asm-xtensa/fcntl.h~xtensa-use-asm-generic-fcntlh include/asm-xtensa/fcntl.h
--- a/include/asm-xtensa/fcntl.h~xtensa-use-asm-generic-fcntlh
+++ a/include/asm-xtensa/fcntl.h
@@ -1,99 +1 @@
-/*
- * include/asm-xtensa/fcntl.h
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 1995, 1996, 1997, 1998 by Ralf Baechle
- * Copyright (C) 2001 - 2005 Tensilica Inc.
- */
-
-#ifndef _XTENSA_FCNTL_H
-#define _XTENSA_FCNTL_H
-
-/* open/fcntl - O_SYNC is only implemented on blocks devices and on files
-   located on an ext2 file system */
-#define O_ACCMODE	   0003
-#define O_RDONLY	     00
-#define O_WRONLY	     01
-#define O_RDWR		     02
-#define O_CREAT		   0100	/* not fcntl */
-#define O_EXCL		   0200	/* not fcntl */
-#define O_NOCTTY	   0400	/* not fcntl */
-#define O_TRUNC		  01000	/* not fcntl */
-#define O_APPEND	  02000
-#define O_NONBLOCK	  04000
-#define O_NDELAY	O_NONBLOCK
-#define O_SYNC		 010000
-#define FASYNC		 020000	/* fcntl, for BSD compatibility */
-#define O_DIRECT	 040000	/* direct disk access hint */
-#define O_LARGEFILE	0100000
-#define O_DIRECTORY	0200000	/* must be a directory */
-#define O_NOFOLLOW	0400000 /* don't follow links */
-#define O_NOATIME	01000000
-
-#define F_DUPFD		0	/* dup */
-#define F_GETFD		1	/* get close_on_exec */
-#define F_SETFD		2	/* set/clear close_on_exec */
-#define F_GETFL		3	/* get file->f_flags */
-#define F_SETFL		4	/* set file->f_flags */
-#define F_GETLK		5
-#define F_SETLK		6
-#define F_SETLKW	7
-
-#define F_SETOWN	8	/*  for sockets. */
-#define F_GETOWN	9	/*  for sockets. */
-#define F_SETSIG	10	/*  for sockets. */
-#define F_GETSIG	11	/*  for sockets. */
-
-#define F_GETLK64	12	/*  using 'struct flock64' */
-#define F_SETLK64	13
-#define F_SETLKW64	14
-
-/* for F_[GET|SET]FL */
-#define FD_CLOEXEC	1	/* actually anything with low bit set goes */
-
-/* for posix fcntl() and lockf() */
-#define F_RDLCK		0
-#define F_WRLCK		1
-#define F_UNLCK		2
-
-/* for old implementation of bsd flock () */
-#define F_EXLCK		4	/* or 3 */
-#define F_SHLCK		8	/* or 4 */
-
-/* for leases */
-#define F_INPROGRESS	16
-
-/* operations for bsd flock(), also used by the kernel implementation */
-#define LOCK_SH		1	/* shared lock */
-#define LOCK_EX		2	/* exclusive lock */
-#define LOCK_NB		4	/* or'd with one of the above to prevent
-				   blocking */
-#define LOCK_UN		8	/* remove lock */
-
-#define LOCK_MAND	32	/* This is a mandatory flock */
-#define LOCK_READ	64	/* ... Which allows concurrent read operations */
-#define LOCK_WRITE	128	/* ... Which allows concurrent write operations */
-#define LOCK_RW		192	/* ... Which allows concurrent read & write ops */
-
-struct flock {
-	short l_type;
-	short l_whence;
-	off_t l_start;
-	off_t l_len;
-	pid_t l_pid;
-};
-
-struct flock64 {
-	short  l_type;
-	short  l_whence;
-	loff_t l_start;
-	loff_t l_len;
-	pid_t  l_pid;
-};
-
-#define F_LINUX_SPECIFIC_BASE	1024
-
-#endif /* _XTENSA_FCNTL_H */
+#include <asm-generic/fcntl.h>
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

viotape-use-designated-initializers-for-fops-member.patch
git-kbuild.patch
move-three-functions-that-are-only-needed-for.patch
introduce-config_virt_to_bus.patch
xtensa-use-asm-generic-fcntlh.patch
