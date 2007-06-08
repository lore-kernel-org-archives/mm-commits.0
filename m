From: akpm@linux-foundation.org
Subject: - lguest-the-block-driver-tidyups-update.patch removed from -mm tree
Date: Thu, 07 Jun 2007 23:17:26 -0700
Message-ID: <200706080617.l586HQQl021067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54887 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753769AbXFHGRw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 02:17:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     lguest: block driver tidyups
has been removed from the -mm tree.  Its filename was
     lguest-the-block-driver-tidyups-update.patch

This patch was dropped because it was folded into lguest-the-block-driver.patch

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

git-kbuild.patch
paravirt-helper-to-disable-all-io-space.patch
paravirt-helper-to-disable-all-io-space-fix.patch
xen-disable-all-non-virtual-devices.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
use-menuconfig-objects-ii-module-menu.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-host-code.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-block-driver-tidyups-update.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-example-launcher-fix.patch
lguest-dont-signal-like-crazy-use-lhreq_break-command-doc.patch
lguest-documentation-infrastructure-and-chapter-i.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
