From: akpm@linux-foundation.org
Subject: - fatfs-fix-build-warning-with-64k-page_size.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:01:52 -0700
Message-ID: <200804282201.m3SM1q4u018901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965819AbYD1WB5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:01:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olof@lixom.net, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fatfs: fix build warning with 64k PAGE_SIZE
has been removed from the -mm tree.  Its filename was
     fatfs-fix-build-warning-with-64k-page_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fatfs: fix build warning with 64k PAGE_SIZE
From: Olof Johansson <olof@lixom.net>

Annoying gcc warning:

fs/fat/inode.c: In function 'fat_fill_super':
fs/fat/inode.c:1222: warning: comparison is always false due to limited range of data type

Change it to compare with 4K instead of PAGE_CACHE_SIZE, as suggested
by OGAWA-san.

[FAT spec says: logical_sector_size should be 512, 1024, 2048 4096]
So, at least for now, we limit it to 4096.

Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fat/inode.c~fatfs-fix-build-warning-with-64k-page_size fs/fat/inode.c
--- a/fs/fat/inode.c~fatfs-fix-build-warning-with-64k-page_size
+++ a/fs/fat/inode.c
@@ -1226,7 +1226,7 @@ int fat_fill_super(struct super_block *s
 		le16_to_cpu(get_unaligned((__le16 *)&b->sector_size));
 	if (!is_power_of_2(logical_sector_size)
 	    || (logical_sector_size < 512)
-	    || (PAGE_CACHE_SIZE < logical_sector_size)) {
+	    || (logical_sector_size > 4096)) {
 		if (!silent)
 			printk(KERN_ERR "FAT: bogus logical sector size %u\n",
 			       logical_sector_size);
_

Patches currently in -mm which might be from olof@lixom.net are

origin.patch

