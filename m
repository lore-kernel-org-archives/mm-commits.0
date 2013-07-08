From: akpm@linux-foundation.org
Subject: [merged]
 fs-fat-use-fat_msg-to-replace-printk-in-__fat_fs_error.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:35:31 -0700
Message-ID: <51db1483.ZXt/X0RmFufG/Pyb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab3GHTfe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:35:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hirofumi@mail.parknet.co.jp, guz.fnst@cn.fujitsu.com

Subject: [merged] fs-fat-use-fat_msg-to-replace-printk-in-__fat_fs_error.patch removed from -mm tree
To: guz.fnst@cn.fujitsu.com,hirofumi@mail.parknet.co.jp,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:35:31 -0700


The patch titled
     Subject: fs/fat: use fat_msg() to replace printk() in __fat_fs_error()
has been removed from the -mm tree.  Its filename was
     fs-fat-use-fat_msg-to-replace-printk-in-__fat_fs_error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: fs/fat: use fat_msg() to replace printk() in __fat_fs_error()

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/misc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/fat/misc.c~fs-fat-use-fat_msg-to-replace-printk-in-__fat_fs_error fs/fat/misc.c
--- a/fs/fat/misc.c~fs-fat-use-fat_msg-to-replace-printk-in-__fat_fs_error
+++ a/fs/fat/misc.c
@@ -30,7 +30,7 @@ void __fat_fs_error(struct super_block *
 		va_start(args, fmt);
 		vaf.fmt = fmt;
 		vaf.va = &args;
-		printk(KERN_ERR "FAT-fs (%s): error, %pV\n", sb->s_id, &vaf);
+		fat_msg(sb, KERN_ERR, "error, %pV", &vaf);
 		va_end(args);
 	}
 
@@ -38,8 +38,7 @@ void __fat_fs_error(struct super_block *
 		panic("FAT-fs (%s): fs panic from previous error\n", sb->s_id);
 	else if (opts->errors == FAT_ERRORS_RO && !(sb->s_flags & MS_RDONLY)) {
 		sb->s_flags |= MS_RDONLY;
-		printk(KERN_ERR "FAT-fs (%s): Filesystem has been "
-				"set read-only\n", sb->s_id);
+		fat_msg(sb, KERN_ERR, "Filesystem has been set read-only");
 	}
 }
 EXPORT_SYMBOL_GPL(__fat_fs_error);
_

Patches currently in -mm which might be from guz.fnst@cn.fujitsu.com are

origin.patch
linux-next.patch

