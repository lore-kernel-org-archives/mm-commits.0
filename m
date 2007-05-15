From: akpm@linux-foundation.org
Subject: + lguest-the-block-driver-tidyups-update.patch added to -mm tree
Date: Mon, 14 May 2007 22:55:50 -0700
Message-ID: <200705150555.l4F5tool002696@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756224AbXEOF4u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 01:56:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de, jens.axboe@oracle.com


The patch titled
     lguest: block driver tidyups
has been added to the -mm tree.  Its filename is
     lguest-the-block-driver-tidyups-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest: block driver tidyups
From: Rusty Russell <rusty@rustcorp.com.au>

1) Use new dma wrapper functions, and handle bind failure (may happen
   in future)
2) Use new lgdev_irq() "get me a good interrupt number" function.
3) Use new lguest_map()/lguest_unmap() instead of ioremap/iounmap.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/lguest_blk.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/block/lguest_blk.c~lguest-the-block-driver-tidyups-update drivers/block/lguest_blk.c
--- a/drivers/block/lguest_blk.c~lguest-the-block-driver-tidyups-update
+++ a/drivers/block/lguest_blk.c
@@ -37,7 +37,7 @@ struct blockdev
 	int irq;
 
 	unsigned long phys_addr;
-	/* The ioremap'ed block page. */
+	/* The mapped block page. */
 	struct lguest_block_page *lb_page;
 
 	/* We only have a single request outstanding at a time. */
@@ -189,7 +189,7 @@ static int lguestblk_probe(struct lguest
 	bd->dma.len[0] = 0;
 	bd->phys_addr = (lguest_devices[lgdev->index].pfn << PAGE_SHIFT);
 
-	bd->lb_page = (__force void *)ioremap(bd->phys_addr, PAGE_SIZE);
+	bd->lb_page = lguest_map(bd->phys_addr, 1);
 	if (!bd->lb_page) {
 		err = -ENOMEM;
 		goto out_free_bd;
@@ -252,7 +252,7 @@ out_put_disk:
 out_unregister_blkdev:
 	unregister_blkdev(bd->major, "lguestblk");
 out_unmap:
-	iounmap((__force void *__iomem)bd->lb_page);
+	lguest_unmap(bd->lb_page);
 out_free_bd:
 	kfree(bd);
 	return err;
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

xfs-clean-up-shrinker-games.patch
refine-screen_info-sanity-check-for-vgacon-initialization.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
use-menuconfig-objects-ii-module-menu.patch
split-usermodehelper-setup-from-execution.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-guest-code-tidyups.patch
lguest-the-guest-code-tidyups-update.patch
lguest-the-host-code.patch
lguest-the-host-code-tidyups.patch
lguest-the-host-code-tidyups-update.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-makefile-and-kconfig-tidyups.patch
lguest-the-console-driver.patch
lguest-the-console-driver-tidyups.patch
lguest-the-net-driver.patch
lguest-the-net-driver-tidyups.patch
lguest-the-net-driver-tidyups-update.patch
lguest-the-block-driver.patch
lguest-the-block-driver-tidyups.patch
lguest-the-block-driver-tidyups-update.patch
lguest-the-documentation-example-launcher.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
