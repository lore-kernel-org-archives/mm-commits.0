From: akpm@osdl.org
Subject: - uml-problems-with-linux-ioh.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:11:20 -0800
Message-ID: <200612140611.kBE6BLRn002040@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52229 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbWLNGLs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:11:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viro@ftp.linux.org.uk, jdike@addtoit.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     uml problems with linux/io.h
has been removed from the -mm tree.  Its filename was
     uml-problems-with-linux-ioh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml problems with linux/io.h
From: Al Viro <viro@ftp.linux.org.uk>

Remove useless includes of linux/io.h, don't even try to build iomap_copy
on uml (it doesn't have readb() et.al., so...)

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 crypto/blkcipher.c |    1 -
 lib/Kconfig        |    5 +++++
 lib/Makefile       |    3 ++-
 lib/ioremap.c      |    1 -
 4 files changed, 7 insertions(+), 3 deletions(-)

diff -puN crypto/blkcipher.c~uml-problems-with-linux-ioh crypto/blkcipher.c
--- a/crypto/blkcipher.c~uml-problems-with-linux-ioh
+++ a/crypto/blkcipher.c
@@ -17,7 +17,6 @@
 #include <linux/crypto.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
-#include <linux/io.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 #include <linux/seq_file.h>
diff -puN lib/Kconfig~uml-problems-with-linux-ioh lib/Kconfig
--- a/lib/Kconfig~uml-problems-with-linux-ioh
+++ a/lib/Kconfig
@@ -101,4 +101,9 @@ config TEXTSEARCH_FSM
 config PLIST
 	boolean
 
+config IOMAP_COPY
+	boolean
+	depends on !UML
+	default y
+
 endmenu
diff -puN lib/Makefile~uml-problems-with-linux-ioh lib/Makefile
--- a/lib/Makefile~uml-problems-with-linux-ioh
+++ a/lib/Makefile
@@ -12,13 +12,14 @@ lib-$(CONFIG_SMP) += cpumask.o
 
 lib-y	+= kobject.o kref.o kobject_uevent.o klist.o
 
-obj-y += sort.o parser.o halfmd4.o iomap_copy.o debug_locks.o random32.o
+obj-y += sort.o parser.o halfmd4.o debug_locks.o random32.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
 CFLAGS_kobject_uevent.o += -DDEBUG
 endif
 
+obj-$(CONFIG_IOMAP_COPY) += iomap_copy.o
 obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
 lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
diff -puN lib/ioremap.c~uml-problems-with-linux-ioh lib/ioremap.c
--- a/lib/ioremap.c~uml-problems-with-linux-ioh
+++ a/lib/ioremap.c
@@ -5,7 +5,6 @@
  *
  * (C) Copyright 1995 1996 Linus Torvalds
  */
-#include <linux/io.h>
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
 
_

Patches currently in -mm which might be from viro@ftp.linux.org.uk are

m68k-work-around-binutils-tokenizer-change.patch
slab-leaks3-default-y.patch

