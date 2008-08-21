From: akpm@linux-foundation.org
Subject: + at91_mci-dont-use-coherent-dma-buffers.patch added to -mm tree
Date: Thu, 21 Aug 2008 13:48:11 -0700
Message-ID: <200808212048.m7LKmB3x025200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752762AbYHUUst (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Aug 2008 16:48:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, drzeus-mmc@drzeus.cx, linux@maxim.org.za, nicolas.ferre@atmel.com, rmk@arm.linux.org.uk


The patch titled
     mmc: at91_mci: don't use coherent dma buffers
has been added to the -mm tree.  Its filename is
     at91_mci-dont-use-coherent-dma-buffers.patch

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
Subject: mmc: at91_mci: don't use coherent dma buffers
From: David Brownell <dbrownell@users.sourceforge.net>

At91_mci is abusing dma_free_coherent(), which may not be called with IRQs
disabled.  I saw "mkfs.ext3" on an MMC card objecting voluminously as each
write completed:

 WARNING: at arch/arm/mm/consistent.c:368 dma_free_coherent+0x2c/0x224()
 [<c002726c>] (dump_stack+0x0/0x14) from [<c00387d4>] (warn_on_slowpath+0x4c/0x68)
 [<c0038788>] (warn_on_slowpath+0x0/0x68) from [<c0028768>] (dma_free_coherent+0x2c/0x224)
  r6:00008008 r5:ffc06000 r4:00000000
 [<c002873c>] (dma_free_coherent+0x0/0x224) from [<c01918ac>] (at91_mci_irq+0x374/0x420)
 [<c0191538>] (at91_mci_irq+0x0/0x420) from [<c0065d9c>] (handle_IRQ_event+0x2c/0x6c)
 ...

This bug has been around for a LONG time.  The MM warning is from late
2005, but the driver merged a year later ...  so I'm puzzled why nobody
noticed this before now.

The fix involves noting that this buffer shouldn't be DMA-coherent; it's
just used for normal DMA writes.  So replace it with standard kmalloc()
buffering and DMA mapping calls.

This is the quickie fix.  A better one would not rely on allocating large
bounce buffers.  (Note that dma_alloc_coherent could have failed too, but
that case was ignored...  kmalloc is a bit more likely to fail though.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/at91_mci.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff -puN drivers/mmc/host/at91_mci.c~at91_mci-dont-use-coherent-dma-buffers drivers/mmc/host/at91_mci.c
--- a/drivers/mmc/host/at91_mci.c~at91_mci-dont-use-coherent-dma-buffers
+++ a/drivers/mmc/host/at91_mci.c
@@ -621,12 +621,21 @@ static void at91_mci_send_command(struct
 				if (cpu_is_at91sam9260 () || cpu_is_at91sam9263())
 					if (host->total_length < 12)
 						host->total_length = 12;
-				host->buffer = dma_alloc_coherent(NULL,
-						host->total_length,
-						&host->physical_address, GFP_KERNEL);
+
+				host->buffer = kmalloc(host->total_length, GFP_KERNEL);
+				if (!host->buffer) {
+					pr_debug("Can't alloc tx buffer\n");
+					cmd->error = -ENOMEM;
+					mmc_request_done(host->mmc, host->request);
+					return;
+				}
 
 				at91_mci_sg_to_dma(host, data);
 
+				host->physical_address = dma_map_single(NULL,
+						host->buffer, host->total_length,
+						DMA_TO_DEVICE);
+
 				pr_debug("Transmitting %d bytes\n", host->total_length);
 
 				at91_mci_write(host, ATMEL_PDC_TPR, host->physical_address);
@@ -694,7 +703,10 @@ static void at91_mci_completed_command(s
 	cmd->resp[3] = at91_mci_read(host, AT91_MCI_RSPR(3));
 
 	if (host->buffer) {
-		dma_free_coherent(NULL, host->total_length, host->buffer, host->physical_address);
+		dma_unmap_single(NULL,
+				host->physical_address, host->total_length,
+				DMA_TO_DEVICE);
+		kfree(host->buffer);
 		host->buffer = NULL;
 	}
 
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

linux-next.patch
at91_mci-dont-use-coherent-dma-buffers.patch
rtc-ds1307-alarm-support-for-ds1337-ds1339.patch
rtc-remove-some-nop-open-release-methods.patch
legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option.patch
rtc-file-close-consistently-disables-repeating-irqs.patch
rtc-cmos-strongly-avoid-hpet-emulation.patch
make-gpiochip-label-const.patch
irq-warn-about-irqf_disabledirqf_shared.patch

