From: akpm@linux-foundation.org
Subject: [alternative-merged] pata-rb532-cf-platform_get_irq-failure-ignored.patch removed from -mm tree
Date: Tue, 12 May 2009 14:29:44 -0700
Message-ID: <200905122129.n4CLTjdc025182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752228AbZELVfF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 May 2009 17:35:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, alan@lxorguk.ukuu.org.uk, florian@openwrt.org, jeff@garzik.org, n0-1@freewrt.org, mm-commits@vger.kernel.org


The patch titled
     pata-rb532-cf: platform_get_irq() failure ignored
has been removed from the -mm tree.  Its filename was
     pata-rb532-cf-platform_get_irq-failure-ignored.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pata-rb532-cf: platform_get_irq() failure ignored
From: Roel Kluin <roel.kluin@gmail.com>

platform_get_irq() can return -ENXIO, but since 'irq' is an unsigned int,
it does not show when the IRQ resource wasn't found.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Acked-by: Phil Sutter <n0-1@freewrt.org>
Cc: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_rb532_cf.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/ata/pata_rb532_cf.c~pata-rb532-cf-platform_get_irq-failure-ignored drivers/ata/pata_rb532_cf.c
--- a/drivers/ata/pata_rb532_cf.c~pata-rb532-cf-platform_get_irq-failure-ignored
+++ a/drivers/ata/pata_rb532_cf.c
@@ -117,11 +117,12 @@ static __devinit int rb532_pata_driver_p
 		return -EINVAL;
 	}
 
-	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0) {
+	ret = platform_get_irq(pdev, 0);
+	if (ret <= 0) {
 		dev_err(&pdev->dev, "no IRQ resource found\n");
 		return -ENOENT;
 	}
+	irq = ret;
 
 	gpio = irq_to_gpio(irq);
 	if (gpio < 0) {
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
i2c-pxac-timeouts-off-by-1.patch
drm-fix-lock_test_with_return-macro.patch
v4l-dvb-cimax2c-fix-typo.patch
zoran-fix-error.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
uwb-event_size-should-be-signed.patch
isdn-get_free_devid-failure-ignored.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
wis-sony-tunerc-typo.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
ufs-sector_t-cannot-be-negative.patch

