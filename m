From: akpm@linux-foundation.org
Subject: - dont-force-uclinux-mtd-map-to-be-root-dev.patch removed from -mm tree
Date: Mon, 21 May 2007 13:09:26 -0700
Message-ID: <200705212009.l4LK9PFD018768@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51955 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763006AbXEUUMF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 16:12:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, dwmw2@infradead.org, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     don't force uclinux mtd map to be root dev
has been removed from the -mm tree.  Its filename was
     dont-force-uclinux-mtd-map-to-be-root-dev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: don't force uclinux mtd map to be root dev
From: Mike Frysinger <vapier@gentoo.org>

The cheesy uclinux mtd maps can be used for more than just the root device, so
I think we should drop the forcing.

Also, I feel like this is a policy decision that shouldnt be in the kernel in
the first place.  People who have been lazy and boot with uclinux mtd maps and
dont put root= into their commandline can simply add the appropriate root=
line either into their bootloader or into the compiled in bootargs.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Christoph Hellwig <hch@lst.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/uclinux.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/mtd/maps/uclinux.c~dont-force-uclinux-mtd-map-to-be-root-dev drivers/mtd/maps/uclinux.c
--- a/drivers/mtd/maps/uclinux.c~dont-force-uclinux-mtd-map-to-be-root-dev
+++ a/drivers/mtd/maps/uclinux.c
@@ -16,7 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/major.h>
-#include <linux/root_dev.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/map.h>
 #include <linux/mtd/partitions.h>
@@ -89,10 +88,6 @@ int __init uclinux_mtd_init(void)
 	uclinux_ram_mtdinfo = mtd;
 	add_mtd_partitions(mtd, uclinux_romfs, NUM_PARTITIONS);
 
-	printk("uclinux[mtd]: set %s to be root filesystem\n",
-	     	uclinux_romfs[0].name);
-	ROOT_DEV = MKDEV(MTD_BLOCK_MAJOR, 0);
-
 	return(0);
 }
 
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
git-kbuild.patch
git-mtd.patch
