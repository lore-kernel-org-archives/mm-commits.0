From: akpm@linux-foundation.org
Subject: + lguest-the-net-driver-tidyups-update.patch added to -mm tree
Date: Mon, 14 May 2007 22:55:46 -0700
Message-ID: <200705150555.l4F5tkKB002693@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758659AbXEOF4a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 01:56:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, jeff@garzik.org


The patch titled
     lguest: netdriver tidyups and a bugfix
has been added to the -mm tree.  Its filename is
     lguest-the-net-driver-tidyups-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest: netdriver tidyups and a bugfix
From: Rusty Russell <rusty@rustcorp.com.au>

Feedback from Jeff Garzik:
1) Use netdev_priv instead of dev->priv.
2) Check for ioremap failure
3) iounmap on failure.
4) Wrap SEND_DMA and BIND_DMA calls
5) Don't set NETIF_F_SG unless we set NETIF_F_NO_CSUM
6) Use SET_NETDEV_DEV()
7) Don't set dev->irq, mem_start & mem_end (deprecated)

Feedback from Chrisoph Hellwig:
8) Use lguest_map()/lguest_unmap() helpers instead of ioremap/iounmap.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/lguest_net.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/net/lguest_net.c~lguest-the-net-driver-tidyups-update drivers/net/lguest_net.c
--- a/drivers/net/lguest_net.c~lguest-the-net-driver-tidyups-update
+++ a/drivers/net/lguest_net.c
@@ -22,7 +22,6 @@
 #include <linux/module.h>
 #include <linux/mm_types.h>
 #include <linux/lguest_bus.h>
-#include <asm/io.h>
 
 #define SHARED_SIZE		PAGE_SIZE
 #define MAX_LANS		4
@@ -301,7 +300,7 @@ static int lguestnet_probe(struct lguest
 	info->mapsize = PAGE_SIZE * desc->num_pages;
 	info->peer_phys = ((unsigned long)desc->pfn << PAGE_SHIFT);
 	info->lgdev = lgdev;
-	info->peer = (__force void *)ioremap(info->peer_phys, info->mapsize);
+	info->peer = lguest_map(info->peer_phys, desc->num_pages);
 	if (!info->peer) {
 		err = -ENOMEM;
 		goto free;
@@ -331,7 +330,7 @@ static int lguestnet_probe(struct lguest
 unregister:
 	unregister_netdev(dev);
 unmap:
-	iounmap((__force void __iomem *)info->peer);
+	lguest_unmap(info->peer);
 free:
 	free_netdev(dev);
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
