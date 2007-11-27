From: akpm@linux-foundation.org
Subject: - remove-fs-jffs2-ioctlc.patch removed from -mm tree
Date: Tue, 27 Nov 2007 10:09:25 -0800
Message-ID: <200711271809.lARI9PoO023844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34523 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755673AbXK0SJp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 13:09:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     remove fs/jffs2/ioctl.c
has been removed from the -mm tree.  Its filename was
     remove-fs-jffs2-ioctlc.patch

This patch was dropped because it was nacked

------------------------------------------------------
Subject: remove fs/jffs2/ioctl.c
=46rom: Adrian Bunk <bunk@stusta.de>

fs/jffs2/ioctl.c is already for so long in the "might be used later" st=
ate
that I doubt it will ever be actually used...

And if it will ever be used, reverting this patch will be trivial.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/Makefile   |    2 +-
 fs/jffs2/dir.c      |    1 -
 fs/jffs2/file.c     |    1 -
 fs/jffs2/ioctl.c    |   21 ---------------------
 fs/jffs2/os-linux.h |    3 ---
 5 files changed, 1 insertion(+), 27 deletions(-)

diff -puN fs/jffs2/Makefile~remove-fs-jffs2-ioctlc fs/jffs2/Makefile
--- a/fs/jffs2/Makefile~remove-fs-jffs2-ioctlc
+++ a/fs/jffs2/Makefile
@@ -5,7 +5,7 @@
=20
 obj-$(CONFIG_JFFS2_FS) +=3D jffs2.o
=20
-jffs2-y	:=3D compr.o dir.o file.o ioctl.o nodelist.o malloc.o
+jffs2-y	:=3D compr.o dir.o file.o nodelist.o malloc.o
 jffs2-y	+=3D read.o nodemgmt.o readinode.o write.o scan.o gc.o
 jffs2-y	+=3D symlink.o build.o erase.o background.o fs.o writev.o
 jffs2-y	+=3D super.o debug.o
diff -puN fs/jffs2/dir.c~remove-fs-jffs2-ioctlc fs/jffs2/dir.c
--- a/fs/jffs2/dir.c~remove-fs-jffs2-ioctlc
+++ a/fs/jffs2/dir.c
@@ -38,7 +38,6 @@ const struct file_operations jffs2_dir_o
 {
 	.read =3D		generic_read_dir,
 	.readdir =3D	jffs2_readdir,
-	.ioctl =3D	jffs2_ioctl,
 	.fsync =3D	jffs2_fsync
 };
=20
diff -puN fs/jffs2/file.c~remove-fs-jffs2-ioctlc fs/jffs2/file.c
--- a/fs/jffs2/file.c~remove-fs-jffs2-ioctlc
+++ a/fs/jffs2/file.c
@@ -46,7 +46,6 @@ const struct file_operations jffs2_file_
  	.aio_read =3D	generic_file_aio_read,
  	.write =3D	do_sync_write,
  	.aio_write =3D	generic_file_aio_write,
-	.ioctl =3D	jffs2_ioctl,
 	.mmap =3D		generic_file_readonly_mmap,
 	.fsync =3D	jffs2_fsync,
 	.splice_read =3D	generic_file_splice_read,
diff -puN fs/jffs2/ioctl.c~remove-fs-jffs2-ioctlc /dev/null
--- a/fs/jffs2/ioctl.c
+++ /dev/null
@@ -1,21 +0,0 @@
-/*
- * JFFS2 -- Journalling Flash File System, Version 2.
- *
- * Copyright =C2=A9 2001-2007 Red Hat, Inc.
- *
- * Created by David Woodhouse <dwmw2@infradead.org>
- *
- * For licensing information, see the file 'LICENCE' in this directory=
=2E
- *
- */
-
-#include <linux/fs.h>
-
-int jffs2_ioctl(struct inode *inode, struct file *filp, unsigned int c=
md,
-		unsigned long arg)
-{
-	/* Later, this will provide for lsattr.jffs2 and chattr.jffs2, which
-	   will include compression support etc. */
-	return -ENOTTY;
-}
-
diff -puN fs/jffs2/os-linux.h~remove-fs-jffs2-ioctlc fs/jffs2/os-linux.=
h
--- a/fs/jffs2/os-linux.h~remove-fs-jffs2-ioctlc
+++ a/fs/jffs2/os-linux.h
@@ -166,9 +166,6 @@ extern const struct address_space_operat
 int jffs2_fsync(struct file *, struct dentry *, int);
 int jffs2_do_readpage_unlock (struct inode *inode, struct page *pg);
=20
-/* ioctl.c */
-int jffs2_ioctl(struct inode *, struct file *, unsigned int, unsigned =
long);
-
 /* symlink.c */
 extern const struct inode_operations jffs2_symlink_inode_operations;
=20
_

Patches currently in -mm which might be from bunk@stusta.de are

git-dvb.patch
git-kvm.patch
remove-fs-jffs2-ioctlc.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-x86.patch
maps4-add-proc-kpagecount-interface.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
