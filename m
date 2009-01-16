From: akpm@linux-foundation.org
Subject: [merged] btrfs-squashfs-move-btrfs-and-squashfstos-magic-number-to-linux-magich.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:17:04 -0800
Message-ID: <200901161917.n0GJH4pc025602@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764176AbZAPTRt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:17:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qhfeng.kernel@gmail.com, chris.mason@oracle.com, phillip@lougher.demon.co.uk, mm-commits@vger.kernel.org


The patch titled
     btrfs & squashfs: Move btrfs and squashfsto's magic number to <linux/magic.h>
has been removed from the -mm tree.  Its filename was
     btrfs-squashfs-move-btrfs-and-squashfstos-magic-number-to-linux-magich.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: btrfs & squashfs: Move btrfs and squashfsto's magic number to <linux/magic.h>
From: Qinghuang Feng <qhfeng.kernel@gmail.com>

Use the standard magic.h for btrfs and squashfs.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/super.c          |    2 +-
 fs/squashfs/squashfs_fs.h |    1 -
 fs/squashfs/super.c       |    1 +
 include/linux/magic.h     |    2 ++
 4 files changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/btrfs/super.c~btrfs-squashfs-move-btrfs-and-squashfstos-magic-number-to-linux-magich fs/btrfs/super.c
--- a/fs/btrfs/super.c~btrfs-squashfs-move-btrfs-and-squashfstos-magic-number-to-linux-magich
+++ a/fs/btrfs/super.c
@@ -38,6 +38,7 @@
 #include <linux/namei.h>
 #include <linux/miscdevice.h>
 #include <linux/version.h>
+#include <linux/magic.h>
 #include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
@@ -51,7 +52,6 @@
 #include "export.h"
 #include "compression.h"
 
-#define BTRFS_SUPER_MAGIC 0x9123683E
 
 static struct super_operations btrfs_super_ops;
 
diff -puN fs/squashfs/squashfs_fs.h~btrfs-squashfs-move-btrfs-and-squashfstos-magic-number-to-linux-magich fs/squashfs/squashfs_fs.h
--- a/fs/squashfs/squashfs_fs.h~btrfs-squashfs-move-btrfs-and-squashfstos-magic-number-to-linux-magich
+++ a/fs/squashfs/squashfs_fs.h
@@ -26,7 +26,6 @@
 #define SQUASHFS_CACHED_FRAGMENTS	CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE
 #define SQUASHFS_MAJOR			4
 #define SQUASHFS_MINOR			0
-#define SQUASHFS_MAGIC			0x73717368
 #define SQUASHFS_START			0
 
 /* size of metadata (inode and directory) blocks */
diff -puN fs/squashfs/super.c~btrfs-squashfs-move-btrfs-and-squashfstos-magic-number-to-linux-magich fs/squashfs/super.c
--- a/fs/squashfs/super.c~btrfs-squashfs-move-btrfs-and-squashfstos-magic-number-to-linux-magich
+++ a/fs/squashfs/super.c
@@ -35,6 +35,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/zlib.h>
+#include <linux/magic.h>
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
diff -puN include/linux/magic.h~btrfs-squashfs-move-btrfs-and-squashfstos-magic-number-to-linux-magich include/linux/magic.h
--- a/include/linux/magic.h~btrfs-squashfs-move-btrfs-and-squashfstos-magic-number-to-linux-magich
+++ a/include/linux/magic.h
@@ -10,11 +10,13 @@
 #define SYSFS_MAGIC		0x62656572
 #define SECURITYFS_MAGIC	0x73636673
 #define TMPFS_MAGIC		0x01021994
+#define SQUASHFS_MAGIC		0x73717368
 #define EFS_SUPER_MAGIC		0x414A53
 #define EXT2_SUPER_MAGIC	0xEF53
 #define EXT3_SUPER_MAGIC	0xEF53
 #define XENFS_SUPER_MAGIC	0xabba1974
 #define EXT4_SUPER_MAGIC	0xEF53
+#define BTRFS_SUPER_MAGIC	0x9123683E
 #define HPFS_SUPER_MAGIC	0xf995e849
 #define ISOFS_SUPER_MAGIC	0x9660
 #define JFFS2_SUPER_MAGIC	0x72b6
_

Patches currently in -mm which might be from qhfeng.kernel@gmail.com are

origin.patch
linux-next.patch
sysfs-use-standard-magich-for-sysfs.patch

