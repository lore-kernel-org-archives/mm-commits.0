From: akpm@linux-foundation.org
Subject: + fix-compile-of-swim3-as-module.patch added to -mm tree
Date: Wed, 13 Feb 2008 16:04:23 -0800
Message-ID: <200802140004.m1E04N5v021097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53659 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754441AbYBNAFa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 19:05:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tony@bakeyournoodle.com, benh@kernel.crashing.org, bzolnier@gmail.com, jwboyer@linux.vnet.ibm.com, paulus@samba.org


The patch titled
     Fix compile of swim3 as module
has been added to the -mm tree.  Its filename is
     fix-compile-of-swim3-as-module.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
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
@@ -417,7 +417,6 @@ static void poll_media_bay(struct media_
 	}
 }
 
-#ifdef CONFIG_MAC_FLOPPY
 int check_media_bay(struct device_node *which_bay, int what)
 {
 	int	i;
@@ -432,7 +431,6 @@ int check_media_bay(struct device_node *
 	return -ENODEV;
 }
 EXPORT_SYMBOL(check_media_bay);
-#endif /* CONFIG_MAC_FLOPPY */
 
 #ifdef CONFIG_BLK_DEV_IDE_PMAC
 int check_media_bay_by_base(unsigned long base, int what)
_

Patches currently in -mm which might be from tony@bakeyournoodle.com are

xc5000-fix-build-error-when-built-as-module.patch
fix-compile-of-swim3-as-module.patch
