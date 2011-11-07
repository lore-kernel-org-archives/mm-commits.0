From: akpm@linux-foundation.org
Subject: [merged] init-do_mounts_rdc-fix-ramdisk-identification-for-padded-cramfs.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:25:53 -0800
Message-ID: <201111072025.pA7KPrjH011441@hpaq12.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5106 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab1KGU0H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:26:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: narmstrong@neotion.com, dave@gnu.org, namhyung@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: init/do_mounts_rd.c: fix ramdisk identification for padded cramfs
has been removed from the -mm tree.  Its filename was
     init-do_mounts_rdc-fix-ramdisk-identification-for-padded-cramfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Neil Armstrong <narmstrong@neotion.com>
Subject: init/do_mounts_rd.c: fix ramdisk identification for padded cramfs

When a cramfs ramdisk padded with 512 bytes is given to the kernel, the
current identify_ramdisk_image function fails to identify it.

Tested with a padded cramfs image on an ARM based board.

Signed-off-by: Neil Armstrong <narmstrong@neotion.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Davidlohr Bueso <dave@gnu.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts_rd.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN init/do_mounts_rd.c~init-do_mounts_rdc-fix-ramdisk-identification-for-padded-cramfs init/do_mounts_rd.c
--- a/init/do_mounts_rd.c~init-do_mounts_rdc-fix-ramdisk-identification-for-padded-cramfs
+++ a/init/do_mounts_rd.c
@@ -120,6 +120,20 @@ identify_ramdisk_image(int fd, int start
 	}
 
 	/*
+	 * Read 512 bytes further to check if cramfs is padded
+	 */
+	sys_lseek(fd, start_block * BLOCK_SIZE + 0x200, 0);
+	sys_read(fd, buf, size);
+
+	if (cramfsb->magic == CRAMFS_MAGIC) {
+		printk(KERN_NOTICE
+		       "RAMDISK: cramfs filesystem found at block %d\n",
+		       start_block);
+		nblocks = (cramfsb->size + BLOCK_SIZE - 1) >> BLOCK_SIZE_BITS;
+		goto done;
+	}
+
+	/*
 	 * Read block 1 to test for minix and ext2 superblock
 	 */
 	sys_lseek(fd, (start_block+1) * BLOCK_SIZE, 0);
_

Patches currently in -mm which might be from narmstrong@neotion.com are

origin.patch

