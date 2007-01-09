From: akpm@osdl.org
Subject: + z85230-spinlock-logic.patch added to -mm tree
Date: Mon, 08 Jan 2007 16:03:11 -0800
Message-ID: <200701090003.l0903BJD023431@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56170 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbXAIADU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 19:03:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, davem@davemloft.net, jeff@garzik.org


The patch titled
     z85230: spinlock logic
has been added to the -mm tree.  Its filename is
     z85230-spinlock-logic.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: z85230: spinlock logic
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

At some point someone added a spin_lock(&dev->lock) to the IRQ handler for
the Z85230 driver.  This actually correctly fixes a bug but the necessary
changes to remove the chan->lock calls in the event handlers were not made
(c->lock is the same lock).

Simona Dascenzo reported the problem with the driver and this patch should
fix the problem he found.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/wan/z85230.c |   14 +-------------
 1 files changed, 1 insertion(+), 13 deletions(-)

diff -puN drivers/net/wan/z85230.c~z85230-spinlock-logic drivers/net/wan/z85230.c
--- a/drivers/net/wan/z85230.c~z85230-spinlock-logic
+++ a/drivers/net/wan/z85230.c
@@ -331,8 +331,7 @@ static void z8530_rtsdtr(struct z8530_ch
 static void z8530_rx(struct z8530_channel *c)
 {
 	u8 ch,stat;
-	spin_lock(c->lock);
- 
+
 	while(1)
 	{
 		/* FIFO empty ? */
@@ -390,7 +389,6 @@ static void z8530_rx(struct z8530_channe
 	 */
 	write_zsctrl(c, ERR_RES);
 	write_zsctrl(c, RES_H_IUS);
-	spin_unlock(c->lock);
 }
 
 
@@ -406,7 +404,6 @@ static void z8530_rx(struct z8530_channe
  
 static void z8530_tx(struct z8530_channel *c)
 {
-	spin_lock(c->lock);
 	while(c->txcount) {
 		/* FIFO full ? */
 		if(!(read_zsreg(c, R0)&4))
@@ -434,7 +431,6 @@ static void z8530_tx(struct z8530_channe
 
 	z8530_tx_done(c);	 
 	write_zsctrl(c, RES_H_IUS);
-	spin_unlock(c->lock);
 }
 
 /**
@@ -452,7 +448,6 @@ static void z8530_status(struct z8530_ch
 {
 	u8 status, altered;
 
-	spin_lock(chan->lock);
 	status=read_zsreg(chan, R0);
 	altered=chan->status^status;
 	
@@ -487,7 +482,6 @@ static void z8530_status(struct z8530_ch
 	}	
 	write_zsctrl(chan, RES_EXT_INT);
 	write_zsctrl(chan, RES_H_IUS);
-	spin_unlock(chan->lock);
 }
 
 struct z8530_irqhandler z8530_sync=
@@ -511,7 +505,6 @@ EXPORT_SYMBOL(z8530_sync);
  
 static void z8530_dma_rx(struct z8530_channel *chan)
 {
-	spin_lock(chan->lock);
 	if(chan->rxdma_on)
 	{
 		/* Special condition check only */
@@ -534,7 +527,6 @@ static void z8530_dma_rx(struct z8530_ch
 		/* DMA is off right now, drain the slow way */
 		z8530_rx(chan);
 	}	
-	spin_unlock(chan->lock);
 }
 
 /**
@@ -547,7 +539,6 @@ static void z8530_dma_rx(struct z8530_ch
  
 static void z8530_dma_tx(struct z8530_channel *chan)
 {
-	spin_lock(chan->lock);
 	if(!chan->dma_tx)
 	{
 		printk(KERN_WARNING "Hey who turned the DMA off?\n");
@@ -557,7 +548,6 @@ static void z8530_dma_tx(struct z8530_ch
 	/* This shouldnt occur in DMA mode */
 	printk(KERN_ERR "DMA tx - bogus event!\n");
 	z8530_tx(chan);
-	spin_unlock(chan->lock);
 }
 
 /**
@@ -596,7 +586,6 @@ static void z8530_dma_status(struct z853
 		}
 	}
 
-	spin_lock(chan->lock);
 	if(altered&chan->dcdcheck)
 	{
 		if(status&chan->dcdcheck)
@@ -618,7 +607,6 @@ static void z8530_dma_status(struct z853
 
 	write_zsctrl(chan, RES_EXT_INT);
 	write_zsctrl(chan, RES_H_IUS);
-	spin_unlock(chan->lock);
 }
 
 struct z8530_irqhandler z8530_dma_sync=
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
add-suport-for-marvell-88se6121-in-pata_marvell.patch
ahci-remove-jmicron-fixup.patch
sata_via-pata-support-resubmit.patch
git-mtd.patch
z85230-spinlock-logic.patch
resend-iphase-64bit-cleanup.patch
make-sure-uart-is-powered-up-when-dumping-mctrl-status.patch
perle-multimodem-card-pci-ras-detection.patch
pnx8550-uart-driver.patch
pnx8550-uart-driver-fixes.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-tty_wakeup-cleanup.patch
proc-remove-useless-and-buggy-nlink-settings.patch
tty-improve-encode_baud_rate-logic.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
edac-e752x-bit-mask-fix.patch
edac-e752x-byte-access-fix.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
hpt3xx-rework-rate-filtering.patch
hpt3xx-rework-rate-filtering-tidy.patch
hpt3xx-print-the-real-chip-name-at-startup.patch
hpt3xx-switch-to-using-pci_get_slot.patch
hpt3xx-cache-channels-mcr-address.patch
hpt3x7-merge-speedproc-handlers.patch
hpt370-clean-up-dma-timeout-handling.patch
hpt3xx-init-code-rewrite.patch
piix-fix-82371mx-enablebits.patch
pdc202xx_new-remove-useless-code.patch
pdc202xx_-remove-check_in_drive_lists-abomination.patch
piix-tuneproc-fixes-cleanups.patch
slc90e66-carry-over-fixes-from-piix-driver.patch
hpt36x-pci-clock-detection-fix.patch
atiixpc-remove-unused-code.patch
atiixpc-sb600-ide-only-has-one-channel.patch
atiixpc-add-cable-detection-support-for-ati-ide.patch
jmicron-warning-fix.patch
