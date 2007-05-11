From: akpm@linux-foundation.org
Subject: + lguest-the-block-driver-tidyups.patch added to -mm tree
Date: Thu, 10 May 2007 20:51:00 -0700
Message-ID: <200705110351.l4B3p0Xf005543@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757576AbXEKDvF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 23:51:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au


The patch titled
     lguest block driver feedback tidyups
has been added to the -mm tree.  Its filename is
     lguest-the-block-driver-tidyups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest block driver feedback tidyups
From: Rusty Russell <rusty@rustcorp.com.au>

1) Use new dma wrapper functions, and handle bind failure (may happen
   in future)
2) Use new lgdev_irq() "get me a good interrupt number" function.
3)  __force the ioremap: guests can use it as normal memory.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/lguest_blk.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN drivers/block/lguest_blk.c~lguest-the-block-driver-tidyups drivers/block/lguest_blk.c
--- a/drivers/block/lguest_blk.c~lguest-the-block-driver-tidyups
+++ a/drivers/block/lguest_blk.c
@@ -123,7 +123,7 @@ static void do_write(struct blockdev *bd
 	pr_debug("lgb: WRITE sector %li\n", (long)req->sector);
 	setup_req(bd, 1, req, &send);
 
-	hcall(LHCALL_SEND_DMA, bd->phys_addr, __pa(&send), 0);
+	lguest_send_dma(bd->phys_addr, &send);
 }
 
 static void do_read(struct blockdev *bd, struct request *req)
@@ -134,7 +134,7 @@ static void do_read(struct blockdev *bd,
 	setup_req(bd, 0, req, &bd->dma);
 
 	empty_dma(&ping);
-	hcall(LHCALL_SEND_DMA, bd->phys_addr, __pa(&ping), 0);
+	lguest_send_dma(bd->phys_addr, &ping);
 }
 
 static void do_lgb_request(request_queue_t *q)
@@ -183,13 +183,13 @@ static int lguestblk_probe(struct lguest
 		return -ENOMEM;
 
 	spin_lock_init(&bd->lock);
-	bd->irq = lgdev->index+1;
+	bd->irq = lgdev_irq(lgdev);
 	bd->req = NULL;
 	bd->dma.used_len = 0;
 	bd->dma.len[0] = 0;
 	bd->phys_addr = (lguest_devices[lgdev->index].pfn << PAGE_SHIFT);
 
-	bd->lb_page = (void *)ioremap(bd->phys_addr, PAGE_SIZE);
+	bd->lb_page = (__force void *)ioremap(bd->phys_addr, PAGE_SIZE);
 	if (!bd->lb_page) {
 		err = -ENOMEM;
 		goto out_free_bd;
@@ -225,7 +225,9 @@ static int lguestblk_probe(struct lguest
 	if (err)
 		goto out_cleanup_queue;
 
-	hcall(LHCALL_BIND_DMA, bd->phys_addr, __pa(&bd->dma), (1<<8)+bd->irq);
+	err = lguest_bind_dma(bd->phys_addr, &bd->dma, 1, bd->irq);
+	if (err)
+		goto out_free_irq;
 
 	bd->disk->major = bd->major;
 	bd->disk->first_minor = 0;
@@ -241,6 +243,8 @@ static int lguestblk_probe(struct lguest
 	lgdev->private = bd;
 	return 0;
 
+out_free_irq:
+	free_irq(bd->irq, bd);
 out_cleanup_queue:
 	blk_cleanup_queue(bd->disk->queue);
 out_put_disk:
@@ -248,7 +252,7 @@ out_put_disk:
 out_unregister_blkdev:
 	unregister_blkdev(bd->major, "lguestblk");
 out_unmap:
-	iounmap(bd->lb_page);
+	iounmap((__force void *__iomem)bd->lb_page);
 out_free_bd:
 	kfree(bd);
 	return err;
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
xfs-clean-up-shrinker-games.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
powerpc-fixup-hard_irq_disable-semantics.patch
add-hard_irq_disable.patch
stop_machine-now-uses-hard_irq_disable.patch
stop_machine-now-uses-hard_irq_disable-fix.patch
use-menuconfig-objects-ii-module-menu.patch
module_author-dont-advice-putting-in-an-email-address.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-guest-code-tidyups.patch
lguest-the-host-code.patch
lguest-the-host-code-tidyups.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-makefile-and-kconfig-tidyups.patch
lguest-the-console-driver.patch
lguest-the-console-driver-tidyups.patch
lguest-the-net-driver.patch
lguest-the-net-driver-tidyups.patch
lguest-the-block-driver.patch
lguest-the-block-driver-tidyups.patch
lguest-the-documentation-example-launcher.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
