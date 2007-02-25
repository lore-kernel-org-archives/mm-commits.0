From: akpm@linux-foundation.org
Subject: + is_power_of_2-in-fat.patch added to -mm tree
Date: Sun, 25 Feb 2007 04:27:42 -0800
Message-ID: <200702251227.l1PCRiqE029262@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34520 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964851AbXBYM2B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Feb 2007 07:28:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vignesh.babu@wipro.com, hirofumi@mail.parknet.co.jp


The patch titled
     is_power_of_2 in fat
has been added to the -mm tree.  Its filename is
     is_power_of_2-in-fat.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: is_power_of_2 in fat
From: Vignesh Babu BM <vignesh.babu@wipro.com>

Replacing (n & (n-1)) in the context of power of 2 checks with
is_power_of_2

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/fat/inode.c~is_power_of_2-in-fat fs/fat/inode.c
--- a/fs/fat/inode.c~is_power_of_2-in-fat
+++ a/fs/fat/inode.c
@@ -25,6 +25,7 @@
 #include <linux/parser.h>
 #include <linux/uio.h>
 #include <linux/writeback.h>
+#include <linux/log2.h>
 #include <asm/unaligned.h>
 
 #ifndef CONFIG_FAT_DEFAULT_IOCHARSET
@@ -1217,8 +1218,7 @@ int fat_fill_super(struct super_block *s
 	}
 	logical_sector_size =
 		le16_to_cpu(get_unaligned((__le16 *)&b->sector_size));
-	if (!logical_sector_size
-	    || (logical_sector_size & (logical_sector_size - 1))
+	if (!is_power_of_2(logical_sector_size)
 	    || (logical_sector_size < 512)
 	    || (PAGE_CACHE_SIZE < logical_sector_size)) {
 		if (!silent)
@@ -1228,8 +1228,7 @@ int fat_fill_super(struct super_block *s
 		goto out_invalid;
 	}
 	sbi->sec_per_clus = b->sec_per_clus;
-	if (!sbi->sec_per_clus
-	    || (sbi->sec_per_clus & (sbi->sec_per_clus - 1))) {
+	if (!is_power_of_2(sbi->sec_per_clus)) {
 		if (!silent)
 			printk(KERN_ERR "FAT: bogus sectors per cluster %u\n",
 			       sbi->sec_per_clus);
_

Patches currently in -mm which might be from vignesh.babu@wipro.com are

is_power_of_2-in-fat.patch
