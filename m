From: akpm@linux-foundation.org
Subject: + lguest-the-console-driver-tidyups.patch added to -mm tree
Date: Thu, 10 May 2007 20:50:56 -0700
Message-ID: <200705110350.l4B3ou0v005534@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757560AbXEKDvD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 23:51:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au


The patch titled
     lguest console driver feedback tidyups
has been added to the -mm tree.  Its filename is
     lguest-the-console-driver-tidyups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest console driver feedback tidyups
From: Rusty Russell <rusty@rustcorp.com.au>

1) Use new lguest_send_dma & lguest_bind_dma functions.
2) sparse: lguest_cons can be static.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hvc_lguest.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN drivers/char/hvc_lguest.c~lguest-the-console-driver-tidyups drivers/char/hvc_lguest.c
--- a/drivers/char/hvc_lguest.c~lguest-the-console-driver-tidyups
+++ a/drivers/char/hvc_lguest.c
@@ -36,7 +36,7 @@ static int put_chars(u32 vtermno, const 
 	dma.len[1] = 0;
 	dma.addr[0] = __pa(buf);
 
-	hcall(LHCALL_SEND_DMA, LGUEST_CONSOLE_DMA_KEY, __pa(&dma), 0);
+	lguest_send_dma(LGUEST_CONSOLE_DMA_KEY, &dma);
 	return count;
 }
 
@@ -59,7 +59,7 @@ static int get_chars(u32 vtermno, char *
 	return count;
 }
 
-struct hv_ops lguest_cons = {
+static struct hv_ops lguest_cons = {
 	.get_chars = get_chars,
 	.put_chars = put_chars,
 };
@@ -75,14 +75,17 @@ console_initcall(cons_init);
 
 static int lguestcons_probe(struct lguest_device *lgdev)
 {
-	lgdev->private = hvc_alloc(0, lgdev->index+1, &lguest_cons, 256);
+	int err;
+
+	lgdev->private = hvc_alloc(0, lgdev_irq(lgdev), &lguest_cons, 256);
 	if (IS_ERR(lgdev->private))
 		return PTR_ERR(lgdev->private);
 
-	if (!hcall(LHCALL_BIND_DMA, LGUEST_CONSOLE_DMA_KEY, __pa(&cons_input),
-		   (1<<8) + lgdev->index+1))
+	err = lguest_bind_dma(LGUEST_CONSOLE_DMA_KEY, &cons_input, 1,
+			      lgdev_irq(lgdev));
+	if (err)
 		printk("lguest console: failed to bind buffer.\n");
-	return 0;
+	return err;
 }
 
 static struct lguest_driver lguestcons_drv = {
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
