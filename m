From: akpm@linux-foundation.org
Subject: - fix-compile-of-swim3-as-module.patch removed from -mm tree
Date: Thu, 14 Feb 2008 19:15:57 -0500
Message-ID: <200802150719.m1F7JKfV025633@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50228 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762853AbYBOHUS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:20:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tony@bakeyournoodle.com, benh@kernel.crashing.org, bzolnier@gmail.com, jwboyer@linux.vnet.ibm.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Fix compile of swim3 as module
has been removed from the -mm tree.  Its filename was
     fix-compile-of-swim3-as-module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix compile of swim3 as module
From: Tony Breeds <tony@bakeyournoodle.com>

The current pmac32_defconfig fails to build with the following error:

  Building modules, stage 2.
ERROR: "check_media_bay" [drivers/block/swim3.ko] undefined!
WARNING: modpost: Found 23 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
make[2]: *** [__modpost] Error 1

This patch fixes that.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/swim3.c        |    4 ----
 drivers/macintosh/mediabay.c |    2 --
 2 files changed, 6 deletions(-)

diff -puN drivers/block/swim3.c~fix-compile-of-swim3-as-module drivers/block/swim3.c
--- a/drivers/block/swim3.c~fix-compile-of-swim3-as-module
+++ a/drivers/block/swim3.c
@@ -251,10 +251,6 @@ static int floppy_release(struct inode *
 static int floppy_check_change(struct gendisk *disk);
 static int floppy_revalidate(struct gendisk *disk);
 
-#ifndef CONFIG_PMAC_MEDIABAY
-#define check_media_bay(which, what)	1
-#endif
-
 static void swim3_select(struct floppy_state *fs, int sel)
 {
 	struct swim3 __iomem *sw = fs->swim3;
diff -puN drivers/macintosh/mediabay.c~fix-compile-of-swim3-as-module drivers/macintosh/mediabay.c
--- a/drivers/macintosh/mediabay.c~fix-compile-of-swim3-as-module
+++ a/drivers/macintosh/mediabay.c
@@ -416,7 +416,6 @@ static void poll_media_bay(struct media_
 	}
 }
 
-#ifdef CONFIG_MAC_FLOPPY
 int check_media_bay(struct device_node *which_bay, int what)
 {
 	int	i;
@@ -431,7 +430,6 @@ int check_media_bay(struct device_node *
 	return -ENODEV;
 }
 EXPORT_SYMBOL(check_media_bay);
-#endif /* CONFIG_MAC_FLOPPY */
 
 #ifdef CONFIG_BLK_DEV_IDE_PMAC
 int check_media_bay_by_base(unsigned long base, int what)
_

Patches currently in -mm which might be from tony@bakeyournoodle.com are

origin.patch
git-dvb.patch
