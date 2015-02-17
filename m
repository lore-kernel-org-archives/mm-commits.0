From: akpm@linux-foundation.org
Subject: + fs-fat-remove-unnecessary-includes.patch added to -mm tree
Date: Tue, 17 Feb 2015 14:36:18 -0800
Message-ID: <54e3c262.rPbfj0OyBmwvq8hY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37008 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772AbbBQWgT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 17:36:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/fat: remove unnecessary includes
has been added to the -mm tree.  Its filename is
     fs-fat-remove-unnecessary-includes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-fat-remove-unnecessary-includes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-fat-remove-unnecessary-includes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: fs/fat: remove unnecessary includes

'fat.h' includes <linux/buffer_head.h> which includes <linux/fs.h> which
includes all the header files required for all *.c files fat filesystem.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/cache.c       |    2 --
 fs/fat/dir.c         |    4 ----
 fs/fat/fat.h         |    3 ---
 fs/fat/fatent.c      |    3 ---
 fs/fat/file.c        |    4 ----
 fs/fat/inode.c       |   10 ----------
 fs/fat/misc.c        |    4 ----
 fs/fat/namei_msdos.c |    2 --
 fs/fat/namei_vfat.c  |    2 --
 9 files changed, 34 deletions(-)

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
@@ -11,21 +11,11 @@
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
 #include <linux/aio.h>
 #include <linux/vfs.h>
 #include <linux/parser.h>
-#include <linux/uio.h>
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
kexec-fix-a-typo-in-comment.patch
fs-fat-remove-unnecessary-defintion.patch
fs-fat-remove-unnecessary-includes.patch

