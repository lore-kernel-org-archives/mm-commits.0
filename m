From: akpm@linux-foundation.org
Subject: + smc911x-superh-architecture-support.patch added to -mm tree
Date: Tue, 03 Jun 2008 15:46:59 -0700
Message-ID: <200806032246.m53MkxNJ023826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752801AbYFCWrL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 18:47:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: magnus.damm@gmail.com, damm@igel.co.jp, jeff@garzik.org, lethal@linux-sh.org


The patch titled
     smc911x: SuperH architecture support
has been added to the -mm tree.  Its filename is
     smc911x-superh-architecture-support.patch

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
smc911x-remove-unused-8-bit-i-o-operations.patch
smc911x-fix-16-bit-i-o-operations.patch
smc911x-pass-along-private-data-and-use-iomem.patch
smc911x-introduce-platform-data-flags.patch
smc911x-superh-architecture-support.patch
video-superh-mobile-lcdc-driver.patch
video-superh-mobile-lcdc-driver-update.patch

