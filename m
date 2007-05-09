From: akpm@linux-foundation.org
Subject: - is_power_of_2-in-fat.patch removed from -mm tree
Date: Tue, 08 May 2007 19:44:46 -0700
Message-ID: <200705090244.l492iki9008624@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754320AbXEICov (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:44:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vignesh.babu@wipro.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     is_power_of_2 in fat
has been removed from the -mm tree.  Its filename was
     is_power_of_2-in-fat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-alsa.patch
git-ia64.patch
git-scsi-misc.patch
