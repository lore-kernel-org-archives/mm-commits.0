From: akpm@linux-foundation.org
Subject: - smc911x-superh-architecture-support.patch removed from -mm tree
Date: Sun, 15 Jun 2008 23:04:28 -0700
Message-ID: <200806160604.m5G64Sng010687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751790AbYFPGEl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jun 2008 02:04:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: magnus.damm@gmail.com, damm@igel.co.jp, jeff@garzik.org, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     smc911x: SuperH architecture support
has been removed from the -mm tree.  Its filename was
     smc911x-superh-architecture-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smc911x: SuperH architecture support
From: Magnus Damm <magnus.damm@gmail.com>

Enable the smc911x driver for the SuperH architecture.  While at it remove
the unused SMC_USE_SH_DMA definition.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Kconfig   |    2 +-
 drivers/net/smc911x.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/net/Kconfig~smc911x-superh-architecture-support drivers/net/Kconfig
--- a/drivers/net/Kconfig~smc911x-superh-architecture-support
+++ a/drivers/net/Kconfig
@@ -955,7 +955,7 @@ config SMC911X
 	tristate "SMSC LAN911[5678] support"
 	select CRC32
 	select MII
-	depends on ARCH_PXA || SH_MAGIC_PANEL_R2
+	depends on ARCH_PXA || SUPERH
 	help
 	  This is a driver for SMSC's LAN911x series of Ethernet chipsets
 	  including the new LAN9115, LAN9116, LAN9117, and LAN9118.
diff -puN drivers/net/smc911x.h~smc911x-superh-architecture-support drivers/net/smc911x.h
--- a/drivers/net/smc911x.h~smc911x-superh-architecture-support
+++ a/drivers/net/smc911x.h
@@ -39,7 +39,6 @@
   #define SMC_USE_32BIT		1
   #define SMC_IRQ_SENSE		IRQF_TRIGGER_FALLING
 #elif defined(CONFIG_SH_MAGIC_PANEL_R2)
-  #define SMC_USE_SH_DMA	0
   #define SMC_USE_16BIT		0
   #define SMC_USE_32BIT		1
   #define SMC_IRQ_SENSE		IRQF_TRIGGER_LOW
_

Patches currently in -mm which might be from magnus.damm@gmail.com are

linux-next.patch
video-superh-mobile-lcdc-driver.patch
video-superh-mobile-lcdc-driver-update.patch

