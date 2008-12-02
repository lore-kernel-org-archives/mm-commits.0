From: akpm@linux-foundation.org
Subject: - spi-avoid-spidev-crash-when-device-is-removed.patch removed from -mm tree
Date: Tue, 02 Dec 2008 10:38:27 -0800
Message-ID: <200812021838.mB2IcRVx006920@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754038AbYLBSii (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 13:38:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weo@reccoware.de, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: avoid spidev crash when device is removed
has been removed from the -mm tree.  Its filename was
     spi-avoid-spidev-crash-when-device-is-removed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: avoid spidev crash when device is removed
From: Wolfgang Ocker <weo@reccoware.de>

I saw a kernel oops in spidev_remove() when a spidev device was registered
and I unloaded the SPI master driver:

Unable to handle kernel paging request for data at address 0x00000004
Faulting instruction address: 0xc01c0c50
Oops: Kernel access of bad area, sig: 11 [#1]
CDSPR
Modules linked in: spi_ppc4xx(-)
NIP: c01c0c50 LR: c01bf9e4 CTR: c01c0c34
REGS: cec89c30 TRAP: 0300   Not tainted  (2.6.27.3izt)
MSR: 00021000 <ME>  CR: 24000228  XER: 20000007
DEAR: 00000004, ESR: 00800000
TASK = cf889040[2070] 'rmmod' THREAD: cec88000
GPR00: 00000000 cec89ce0 cf889040 cec8e000 00000004 cec8e000 ffffffff 00000000
GPR08: 0000001c c0336380 00000000 c01c0c34 00000001 1001a338 100e0000 100df49c
GPR16: 100b54c0 100df49c 100ddd20 100f05a8 100b5340 100efd68 00000000 00000000
GPR24: 100ec008 100f0428 c0327788 c0327794 cec8e0ac cec8e000 c0336380 00000000
NIP [c01c0c50] spidev_remove+0x1c/0xe4
LR [c01bf9e4] spi_drv_remove+0x2c/0x3c
Call Trace:
[cec89d00] [c01bf9e4] spi_drv_remove+0x2c/0x3c
[cec89d10] [c01859a0] __device_release_driver+0x78/0xb4
[cec89d20] [c0185ab0] device_release_driver+0x28/0x44
[cec89d40] [c0184be8] bus_remove_device+0xac/0xd8
[cec89d60] [c0183094] device_del+0x100/0x194
[cec89d80] [c0183140] device_unregister+0x18/0x30
[cec89da0] [c01bf30c] __unregister+0x20/0x34
[cec89db0] [c0182778] device_for_each_child+0x38/0x74
[cec89de0] [c01bf2d0] spi_unregister_master+0x28/0x44
[cec89e00] [c01bfeac] spi_bitbang_stop+0x1c/0x58
[cec89e20] [d908a5e0] spi_ppc4xx_of_remove+0x24/0x7c [spi_ppc4xx]
[...]

IMHO a call to spi_set_drvdata() is missing in spidev_probe(). The patch
below helped.

Signed-off-by: Wolfgang Ocker <weo@reccoware.de>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spidev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/spi/spidev.c~spi-avoid-spidev-crash-when-device-is-removed drivers/spi/spidev.c
--- a/drivers/spi/spidev.c~spi-avoid-spidev-crash-when-device-is-removed
+++ a/drivers/spi/spidev.c
@@ -597,7 +597,9 @@ static int spidev_probe(struct spi_devic
 	}
 	mutex_unlock(&device_list_lock);
 
-	if (status != 0)
+	if (status == 0)
+		spi_set_drvdata(spi, spidev);
+	else
 		kfree(spidev);
 
 	return status;
_

Patches currently in -mm which might be from weo@reccoware.de are


