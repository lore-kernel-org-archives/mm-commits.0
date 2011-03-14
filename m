From: akpm@linux-foundation.org
Subject: [merged] gpio-add-module_device_table.patch removed from -mm tree
Date: Mon, 14 Mar 2011 12:44:58 -0700
Message-ID: <201103141946.p2EJkuYn006899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751798Ab1CNTrE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Mar 2011 15:47:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, tomoya-linux@dsn.okisemi.com, mm-commits@vger.kernel.org


The patch titled
     gpio: add MODULE_DEVICE_TABLE
has been removed from the -mm tree.  Its filename was
     gpio-add-module_device_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: add MODULE_DEVICE_TABLE
From: Axel Lin <axel.lin@gmail.com>

The device table is required to load modules based on modaliases.
After adding MODULE_DEVICE_TABLE, below entries will be added to modules.pcimap:

pch_gpio             0x00008086 0x00008803 0xffffffff 0xffffffff 0x00000000 0x00000000 0x0
ml_ioh_gpio          0x000010db 0x0000802e 0xffffffff 0xffffffff 0x00000000 0x00000000 0x0

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/ml_ioh_gpio.c |    1 +
 drivers/gpio/pch_gpio.c    |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/gpio/ml_ioh_gpio.c~gpio-add-module_device_table drivers/gpio/ml_ioh_gpio.c
--- a/drivers/gpio/ml_ioh_gpio.c~gpio-add-module_device_table
+++ a/drivers/gpio/ml_ioh_gpio.c
@@ -326,6 +326,7 @@ static DEFINE_PCI_DEVICE_TABLE(ioh_gpio_
 	{ PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x802E) },
 	{ 0, }
 };
+MODULE_DEVICE_TABLE(pci, ioh_gpio_pcidev_id);
 
 static struct pci_driver ioh_gpio_driver = {
 	.name = "ml_ioh_gpio",
diff -puN drivers/gpio/pch_gpio.c~gpio-add-module_device_table drivers/gpio/pch_gpio.c
--- a/drivers/gpio/pch_gpio.c~gpio-add-module_device_table
+++ a/drivers/gpio/pch_gpio.c
@@ -286,6 +286,7 @@ static DEFINE_PCI_DEVICE_TABLE(pch_gpio_
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8803) },
 	{ 0, }
 };
+MODULE_DEVICE_TABLE(pci, pch_gpio_pcidev_id);
 
 static struct pci_driver pch_gpio_driver = {
 	.name = "pch_gpio",
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
drivers-video-backlight-jornada720_c-make-needlessly-global-symbols-static.patch
drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv.patch
drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv-fix.patch
drivers-misc-atmel_tclibc-fix-a-memory-leak.patch
gpio-use-__devexit-at-necessary-places.patch

