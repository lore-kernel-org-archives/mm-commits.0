From: akpm@linux-foundation.org
Subject: [merged] rapidio-tsi721-convert-to-modular-mport-driver.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:36:41 -0700
Message-ID: <51db14c9.fseRzq1nXvjbnvNg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3GHTgm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:36:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stef.van.os@Prodrive.nl, mporter@kernel.crashing.org, micha.nelissen@Prodrive.nl, leoli@freescale.com, jdelvare@suse.de, galak@kernel.crashing.org, andre.van.herk@Prodrive.nl, alexandre.bounine@idt.com

Subject: [merged] rapidio-tsi721-convert-to-modular-mport-driver.patch removed from -mm tree
To: alexandre.bounine@idt.com,andre.van.herk@Prodrive.nl,galak@kernel.crashing.org,jdelvare@suse.de,leoli@freescale.com,micha.nelissen@Prodrive.nl,mporter@kernel.crashing.org,stef.van.os@Prodrive.nl,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:36:41 -0700


The patch titled
     Subject: rapidio/tsi721: convert to modular mport driver
has been removed from the -mm tree.  Its filename was
     rapidio-tsi721-convert-to-modular-mport-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/tsi721: convert to modular mport driver

This patch adds an option to build device driver for Tsi721 PCIe-to-SRIO
bridge device as a kernel module.

Currently this module cannot be unloaded because the existing RapidIO
subsystem code does not support dynamic removal of local RapidIO
controllers (TODO).

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@Prodrive.nl>
Cc: Micha Nelissen <micha.nelissen@Prodrive.nl>
Cc: Stef van Os <stef.van.os@Prodrive.nl>
Cc: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/Kconfig  |    2 +-
 drivers/rapidio/devices/Makefile |    7 +++----
 drivers/rapidio/devices/tsi721.c |    9 ++++-----
 drivers/rapidio/rio.c            |    1 +
 4 files changed, 9 insertions(+), 10 deletions(-)

diff -puN drivers/rapidio/devices/Kconfig~rapidio-tsi721-convert-to-modular-mport-driver drivers/rapidio/devices/Kconfig
--- a/drivers/rapidio/devices/Kconfig~rapidio-tsi721-convert-to-modular-mport-driver
+++ a/drivers/rapidio/devices/Kconfig
@@ -3,7 +3,7 @@
 #
 
 config RAPIDIO_TSI721
-	bool "IDT Tsi721 PCI Express SRIO Controller support"
+	tristate "IDT Tsi721 PCI Express SRIO Controller support"
 	depends on RAPIDIO && PCIEPORTBUS
 	default "n"
 	---help---
diff -puN drivers/rapidio/devices/Makefile~rapidio-tsi721-convert-to-modular-mport-driver drivers/rapidio/devices/Makefile
--- a/drivers/rapidio/devices/Makefile~rapidio-tsi721-convert-to-modular-mport-driver
+++ a/drivers/rapidio/devices/Makefile
@@ -2,7 +2,6 @@
 # Makefile for RapidIO devices
 #
 
-obj-$(CONFIG_RAPIDIO_TSI721)	+= tsi721.o
-ifeq ($(CONFIG_RAPIDIO_DMA_ENGINE),y)
-obj-$(CONFIG_RAPIDIO_TSI721)	+= tsi721_dma.o
-endif
+obj-$(CONFIG_RAPIDIO_TSI721)	+= tsi721_mport.o
+tsi721_mport-y			:= tsi721.o
+tsi721_mport-$(CONFIG_RAPIDIO_DMA_ENGINE) += tsi721_dma.o
diff -puN drivers/rapidio/devices/tsi721.c~rapidio-tsi721-convert-to-modular-mport-driver drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-convert-to-modular-mport-driver
+++ a/drivers/rapidio/devices/tsi721.c
@@ -2515,9 +2515,8 @@ static int __init tsi721_init(void)
 	return pci_register_driver(&tsi721_driver);
 }
 
-static void __exit tsi721_exit(void)
-{
-	pci_unregister_driver(&tsi721_driver);
-}
