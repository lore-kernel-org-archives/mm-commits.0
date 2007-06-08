From: akpm@linux-foundation.org
Subject: - lguest-the-console-driver-tidyups.patch removed from -mm tree
Date: Thu, 07 Jun 2007 23:16:33 -0700
Message-ID: <200706080616.l586GXXk021030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39675 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755691AbXFHGQm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 02:16:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest console driver feedback tidyups
has been removed from the -mm tree.  Its filename was
     lguest-the-console-driver-tidyups.patch

This patch was dropped because it was folded into lguest-the-console-driver.patch

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
lguest-the-console-driver-tidyups.patch
lguest-the-net-driver.patch
lguest-the-net-driver-tidyups.patch
lguest-the-net-driver-tidyups-update.patch
lguest-the-net-driver-include-fix.patch
lguest-the-block-driver.patch
lguest-the-block-driver-tidyups.patch
lguest-the-block-driver-tidyups-update.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-example-launcher-fix.patch
lguest-dont-signal-like-crazy-use-lhreq_break-command-doc.patch
lguest-documentation-infrastructure-and-chapter-i.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
