From: akpm@linux-foundation.org
Subject: + init-do_mounts_rdc-fix-ramdisk-identification-for-padded-cramfs.patch added to -mm tree
Date: Fri, 26 Aug 2011 16:49:50 -0700
Message-ID: <201108262349.p7QNnoRd019633@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752920Ab1HZXua (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 19:50:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: narmstrong@neotion.com, dave@gnu.org, namhyung@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     init/do_mounts_rd.c: fix ramdisk identification for padded cramfs
has been added to the -mm tree.  Its filename is
     init-do_mounts_rdc-fix-ramdisk-identification-for-padded-cramfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init/do_mounts_rd.c: fix ramdisk identification for padded cramfs
From: Neil Armstrong <narmstrong@neotion.com>

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

init-do_mounts_rdc-fix-ramdisk-identification-for-padded-cramfs.patch

