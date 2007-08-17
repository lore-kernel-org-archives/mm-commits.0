From: akpm@linux-foundation.org
Subject: + dont-use-gfp_dma-for-zone-allocation.patch added to -mm tree
Date: Fri, 17 Aug 2007 11:33:57 -0700
Message-ID: <200708171833.l7HIXvgo023685@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38870 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763513AbXHQSet (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 14:34:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org


The patch titled
     METH: don't use GFP_DMA for zone allocation.
has been added to the -mm tree.  Its filename is
     dont-use-gfp_dma-for-zone-allocation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: METH: don't use GFP_DMA for zone allocation.
From: Ralf Baechle <ralf@linux-mips.org>

IP32 doesn't even have a ZONE_DMA so no point in using GFP_DMA in any
IP32-specific device driver.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/meth.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/meth.c~dont-use-gfp_dma-for-zone-allocation drivers/net/meth.c
--- a/drivers/net/meth.c~dont-use-gfp_dma-for-zone-allocation
+++ a/drivers/net/meth.c
@@ -405,7 +405,7 @@ static void meth_rx(struct net_device* d
 				priv->stats.rx_length_errors++;
 				skb = priv->rx_skbs[priv->rx_write];
 			} else {
-				skb = alloc_skb(METH_RX_BUFF_SIZE, GFP_ATOMIC | GFP_DMA);
+				skb = alloc_skb(METH_RX_BUFF_SIZE, GFP_ATOMIC);
 				if (!skb) {
 					/* Ouch! No memory! Drop packet on the floor */
 					DPRINTK("No mem: dropping packet\n");
_

Patches currently in -mm which might be from ralf@linux-mips.org are

serial_txx9-fix-modem-control-line-handling.patch
git-mips.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
mips-qemu-network-work-again.patch
mips-detect-bcm947xx-cpus.patch
mips-bcm947xx-support.patch
rfc-add-bcm947xx-to-kconfig.patch
mips-add-bcm947xx-to-makefile.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
git-mtd.patch
git-netdev-all.patch
dont-use-gfp_dma-for-zone-allocation.patch
serial_txx9-cleanup-includes.patch
serio-fix-modpost-warning.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
clean-up-duplicate-includes-in-drivers-char.patch
