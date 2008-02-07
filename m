From: akpm@linux-foundation.org
Subject: - remove-superfluous-checks-for-config_blk_dev_initrd-from-initramfsc.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:23:40 -0800
Message-ID: <200802070023.m170NLQL006513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53897 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933894AbYBGAoN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, mm-commits@vger.kernel.org


The patch titled
     Remove superfluous checks for CONFIG_BLK_DEV_INITRD from initramfs.c
has been removed from the -mm tree.  Its filename was
     remove-superfluous-checks-for-config_blk_dev_initrd-from-initramfsc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Remove superfluous checks for CONFIG_BLK_DEV_INITRD from initramfs.c
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Given that init/Makefile includes initramfs.c in the build only if
CONFIG_BLK_DEV_INITRD is defined, there seems to be no point checking for
it yet again.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN init/initramfs.c~remove-superfluous-checks-for-config_blk_dev_initrd-from-initramfsc init/initramfs.c
--- a/init/initramfs.c~remove-superfluous-checks-for-config_blk_dev_initrd-from-initramfsc
+++ a/init/initramfs.c
@@ -503,7 +503,6 @@ static int __init retain_initrd_param(ch
 __setup("retain_initrd", retain_initrd_param);
 
 extern char __initramfs_start[], __initramfs_end[];
-#ifdef CONFIG_BLK_DEV_INITRD
 #include <linux/initrd.h>
 #include <linux/kexec.h>
 
@@ -539,15 +538,12 @@ skip:
 	initrd_end = 0;
 }
 
-#endif
-
 static int __init populate_rootfs(void)
 {
 	char *err = unpack_to_rootfs(__initramfs_start,
 			 __initramfs_end - __initramfs_start, 0);
 	if (err)
 		panic(err);
-#ifdef CONFIG_BLK_DEV_INITRD
 	if (initrd_start) {
 #ifdef CONFIG_BLK_DEV_RAM
 		int fd;
@@ -579,7 +575,6 @@ static int __init populate_rootfs(void)
 		free_initrd();
 #endif
 	}
-#endif
 	return 0;
 }
 rootfs_initcall(populate_rootfs);
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
git-hwmon.patch
git-xfs.patch
