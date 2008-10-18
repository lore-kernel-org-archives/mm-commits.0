From: akpm@linux-foundation.org
Subject: - identify_ramdisk_image-correct-typo-about-return-value-in-comment.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:11:26 -0700
Message-ID: <200810182311.m9INBQ7t027736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751171AbYJRXLb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:11:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, mm-commits@vger.kernel.org


The patch titled
     identify_ramdisk_image(): correct typo about return value in comment
has been removed from the -mm tree.  Its filename was
     identify_ramdisk_image-correct-typo-about-return-value-in-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: identify_ramdisk_image(): correct typo about return value in comment
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

identify_ramdisk_image() returns 0 (not -1) if a gzipped ramdisk is found:

	if (buf[0] == 037 && ((buf[1] == 0213) || (buf[1] == 0236))) {
		printk(KERN_NOTICE
		       "RAMDISK: Compressed image found at block %d\n",
		       start_block);
		nblocks = 0;
		^^^^^^^^^^^
		goto done;
	}

	...

done:
	sys_lseek(fd, start_block * BLOCK_SIZE, 0);
	kfree(buf);
	return nblocks;
	^^^^^^^^^^^^^^

Hence correct the typo in the comment, which has existed since the
addition of compressed ramdisk support in 1.3.48.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts_rd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/do_mounts_rd.c~identify_ramdisk_image-correct-typo-about-return-value-in-comment init/do_mounts_rd.c
--- a/init/do_mounts_rd.c~identify_ramdisk_image-correct-typo-about-return-value-in-comment
+++ a/init/do_mounts_rd.c
@@ -71,7 +71,7 @@ identify_ramdisk_image(int fd, int start
 	sys_read(fd, buf, size);
 
 	/*
-	 * If it matches the gzip magic numbers, return -1
+	 * If it matches the gzip magic numbers, return 0
 	 */
 	if (buf[0] == 037 && ((buf[1] == 0213) || (buf[1] == 0236))) {
 		printk(KERN_NOTICE
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch

