From: akpm@linux-foundation.org
Subject: [merged] fs-fat-remove-unnecessary-includes.patch removed from
 -mm tree
Date: Mon, 20 Apr 2015 12:19:24 -0700
Message-ID: <5535513c.uax7vWXEwi7blkk4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40346 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbbDTTND (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:13:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, hirofumi@mail.parknet.co.jp, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/fat: remove unnecessary includes
has been removed from the -mm tree.  Its filename was
     fs-fat-remove-unnecessary-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: fs/fat: remove unnecessary includes

'fat.h' includes <linux/buffer_head.h> which includes <linux/fs.h> which
includes all the header files required for all *.c files fat filesystem.

[akpm@linux-foundation.org: fs/fat/iode.c needs seq_file.h]
[sfr@canb.auug.org.au: put one actually necessary include file back]
Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/cache.c       |    2 --
 fs/fat/dir.c         |    4 ----
 fs/fat/fat.h         |    3 ---
 fs/fat/fatent.c      |    3 ---
 fs/fat/file.c        |    4 ----
 fs/fat/inode.c       |   10 +---------
 fs/fat/misc.c        |    4 ----
 fs/fat/namei_msdos.c |    2 --
 fs/fat/namei_vfat.c  |    2 --
 9 files changed, 1 insertion(+), 33 deletions(-)

diff -puN fs/fat/cache.c~fs-fat-remove-unnecessary-includes fs/fat/cache.c
--- a/fs/fat/cache.c~fs-fat-remove-unnecessary-includes
+++ a/fs/fat/cache.c
@@ -8,9 +8,7 @@
  *  May 1999. AV. Fixed the bogosity with FAT32 (read "FAT28"). Fscking lusers.
  */
 
-#include <linux/fs.h>
 #include <linux/slab.h>
-#include <linux/buffer_head.h>
 #include "fat.h"
 
 /* this must be > 0. */
diff -puN fs/fat/dir.c~fs-fat-remove-unnecessary-includes fs/fat/dir.c
--- a/fs/fat/dir.c~fs-fat-remove-unnecessary-includes
+++ a/fs/fat/dir.c
@@ -13,13 +13,9 @@
  *  Short name translation 1999, 2001 by Wolfram Pienkoss <wp@bszh.de>
  */
 
-#include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/time.h>
-#include <linux/buffer_head.h>
 #include <linux/compat.h>
 #include <linux/uaccess.h>
-#include <linux/kernel.h>
 #include "fat.h"
 
 /*
diff -puN fs/fat/fat.h~fs-fat-remove-unnecessary-includes fs/fat/fat.h
--- a/fs/fat/fat.h~fs-fat-remove-unnecessary-includes
+++ a/fs/fat/fat.h
@@ -2,11 +2,8 @@
 #define _FAT_H
 
 #include <linux/buffer_head.h>
-#include <linux/string.h>
 #include <linux/nls.h>
-#include <linux/fs.h>
 #include <linux/hash.h>
-#include <linux/mutex.h>
 #include <linux/ratelimit.h>
 #include <linux/msdos_fs.h>
 
diff -puN fs/fat/fatent.c~fs-fat-remove-unnecessary-includes fs/fat/fatent.c
--- a/fs/fat/fatent.c~fs-fat-remove-unnecessary-includes
+++ a/fs/fat/fatent.c
@@ -3,9 +3,6 @@
  * Released under GPL v2.
  */
 
-#include <linux/module.h>
-#include <linux/fs.h>
-#include <linux/msdos_fs.h>
 #include <linux/blkdev.h>
 #include "fat.h"
 
diff -puN fs/fat/file.c~fs-fat-remove-unnecessary-includes fs/fat/file.c
--- a/fs/fat/file.c~fs-fat-remove-unnecessary-includes
+++ a/fs/fat/file.c
@@ -10,10 +10,6 @@
 #include <linux/module.h>
 #include <linux/compat.h>
 #include <linux/mount.h>
-#include <linux/time.h>
-#include <linux/buffer_head.h>
-#include <linux/writeback.h>
-#include <linux/backing-dev.h>
 #include <linux/blkdev.h>
 #include <linux/fsnotify.h>
 #include <linux/security.h>
diff -puN fs/fat/inode.c~fs-fat-remove-unnecessary-includes fs/fat/inode.c
--- a/fs/fat/inode.c~fs-fat-remove-unnecessary-includes
+++ a/fs/fat/inode.c
@@ -11,20 +11,12 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
-#include <linux/time.h>
-#include <linux/slab.h>
-#include <linux/seq_file.h>
 #include <linux/pagemap.h>
 #include <linux/mpage.h>
-#include <linux/buffer_head.h>
-#include <linux/mount.h>
 #include <linux/vfs.h>
+#include <linux/seq_file.h>
 #include <linux/parser.h>
 #include <linux/uio.h>
-#include <linux/writeback.h>
-#include <linux/log2.h>
-#include <linux/hash.h>
 #include <linux/blkdev.h>
 #include <asm/unaligned.h>
 #include "fat.h"
diff -puN fs/fat/misc.c~fs-fat-remove-unnecessary-includes fs/fat/misc.c
--- a/fs/fat/misc.c~fs-fat-remove-unnecessary-includes
+++ a/fs/fat/misc.c
@@ -6,10 +6,6 @@
  *		 and date_dos2unix for date==0 by Igor Zhbanov(bsg@uniyar.ac.ru)
  */
 
-#include <linux/module.h>
-#include <linux/fs.h>
-#include <linux/buffer_head.h>
-#include <linux/time.h>
 #include "fat.h"
 
 /*
diff -puN fs/fat/namei_msdos.c~fs-fat-remove-unnecessary-includes fs/fat/namei_msdos.c
--- a/fs/fat/namei_msdos.c~fs-fat-remove-unnecessary-includes
+++ a/fs/fat/namei_msdos.c
@@ -7,8 +7,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/time.h>
-#include <linux/buffer_head.h>
 #include "fat.h"
 
 /* Characters that are undesirable in an MS-DOS file name */
diff -puN fs/fat/namei_vfat.c~fs-fat-remove-unnecessary-includes fs/fat/namei_vfat.c
--- a/fs/fat/namei_vfat.c~fs-fat-remove-unnecessary-includes
+++ a/fs/fat/namei_vfat.c
@@ -16,10 +16,8 @@
  */
 
 #include <linux/module.h>
-#include <linux/jiffies.h>
 #include <linux/ctype.h>
 #include <linux/slab.h>
-#include <linux/buffer_head.h>
 #include <linux/namei.h>
 #include "fat.h"
 
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

origin.patch
linux-next.patch

