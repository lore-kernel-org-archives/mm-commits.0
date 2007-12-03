From: akpm@linux-foundation.org
Subject: + remove-superfluous-checks-for-config_blk_dev_initrd-from-initramfsc.patch added to -mm tree
Date: Mon, 03 Dec 2007 14:37:21 -0800
Message-ID: <200712032237.lB3MbLlX021066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55493 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750970AbXLCWh1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2007 17:37:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca


The patch titled
     Remove superfluous checks for CONFIG_BLK_DEV_INITRD from initramfs.c
has been added to the -mm tree.  Its filename is
     remove-superfluous-checks-for-config_blk_dev_initrd-from-initramfsc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-arm.patch
git-hwmon.patch
git-mips.patch
pcmcia-net-use-roundup_pow_of_two-macro-instead-of-grotesque-loop.patch
git-nfsd.patch
git-xfs.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
m68knommu-remove-vestiges-of-non-existent-disktel.patch
uml-delete-some-unused-headers.patch
rd-use-is_power_of_2-in-drivers-block-rdc.patch
log2h-define-order_base_2-macro-for-convenience.patch
a-few-corrections-to-include-linux-kbuild.patch
ncpfs-update-diagnostic-strings-to-match-routine-names.patch
hfs-update-comment-to-reflect-actual-init-and-exit-routines.patch
synclink-standardize-format-of-linux-header-file-includes-with.patch
remove-superfluous-checks-for-config_blk_dev_initrd-from-initramfsc.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
