From: akpm@linux-foundation.org
Subject: [merged]
 scripts-spellingtxt-add-deintialized-pattern-and-fix-typo-instances.patch
 removed from -mm tree
Date: Tue, 28 Feb 2017 12:51:51 -0800
Message-ID: <58b5e2e7.sNH7Um1s/b6p9ZII%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52802 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751911AbdB1Uvw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:51:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "deintialize(d)" pattern and fix typo instances
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-deintialized-pattern-and-fix-typo-instances.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "deintialize(d)" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  deintializing||deinitializing
  deintialize||deinitialize
  deintialized||deinitialized

Link: http://lkml.kernel.org/r/1481573103-11329-28-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/crypto/caam/ctrl.c                        |    2 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c            |    2 +-
 drivers/staging/wilc1000/linux_wlan.c             |    2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |    2 +-
 scripts/spelling.txt                              |    3 +++
 sound/soc/amd/acp-pcm-dma.c                       |    2 +-
 6 files changed, 8 insertions(+), 5 deletions(-)

diff -puN drivers/crypto/caam/ctrl.c~scripts-spellingtxt-add-deintialized-pattern-and-fix-typo-instances drivers/crypto/caam/ctrl.c
--- a/drivers/crypto/caam/ctrl.c~scripts-spellingtxt-add-deintialized-pattern-and-fix-typo-instances
+++ a/drivers/crypto/caam/ctrl.c
@@ -269,7 +269,7 @@ static int deinstantiate_rng(struct devi
 		/*
 		 * If the corresponding bit is set, then it means the state
 		 * handle was initialized by us, and thus it needs to be
-		 * deintialized as well
+		 * deinitialized as well
 		 */
 		if ((1 << sh_idx) & state_handle_mask) {
 			/*
diff -puN drivers/net/wireless/rsi/rsi_91x_usb.c~scripts-spellingtxt-add-deintialized-pattern-and-fix-typo-instances drivers/net/wireless/rsi/rsi_91x_usb.c
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c~scripts-spellingtxt-add-deintialized-pattern-and-fix-typo-instances
+++ a/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -516,7 +516,7 @@ err:
 
 /**
  * rsi_disconnect() - This function performs the reverse of the probe function,
- *		      it deintialize the driver structure.
+ *		      it deinitialize the driver structure.
  * @pfunction: Pointer to the USB interface structure.
  *
  * Return: None.
diff -puN drivers/staging/wilc1000/linux_wlan.c~scripts-spellingtxt-add-deintialized-pattern-and-fix-typo-instances drivers/staging/wilc1000/linux_wlan.c
--- a/drivers/staging/wilc1000/linux_wlan.c~scripts-spellingtxt-add-deintialized-pattern-and-fix-typo-instances
+++ a/drivers/staging/wilc1000/linux_wlan.c
@@ -213,7 +213,7 @@ static void deinit_irq(struct net_device
 	vif = netdev_priv(dev);
 	wilc = vif->wilc;
 
-	/* Deintialize IRQ */
+	/* Deinitialize IRQ */
 	if (wilc->dev_irq_num) {
 		free_irq(wilc->dev_irq_num, wilc);
 		gpio_free(wilc->gpio);
diff -puN drivers/staging/wilc1000/wilc_wfi_cfgoperations.c~scripts-spellingtxt-add-deintialized-pattern-and-fix-typo-instances drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c~scripts-spellingtxt-add-deintialized-pattern-and-fix-typo-instances
+++ a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2357,7 +2357,7 @@ int wilc_deinit_host_int(struct net_devi
 		del_timer_sync(&wilc_during_ip_timer);
 
 	if (s32Error)
-		netdev_err(net, "Error while deintializing host interface\n");
+		netdev_err(net, "Error while deinitializing host interface\n");
 
 	return s32Error;
 }
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-deintialized-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-deintialized-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -322,6 +322,9 @@ defintion||definition
 defintions||definitions
 defualt||default
 defult||default
+deintializing||deinitializing
+deintialize||deinitialize
+deintialized||deinitialized
 deivce||device
 delared||declared
 delare||declare
diff -puN sound/soc/amd/acp-pcm-dma.c~scripts-spellingtxt-add-deintialized-pattern-and-fix-typo-instances sound/soc/amd/acp-pcm-dma.c
--- a/sound/soc/amd/acp-pcm-dma.c~scripts-spellingtxt-add-deintialized-pattern-and-fix-typo-instances
+++ a/sound/soc/amd/acp-pcm-dma.c
@@ -506,7 +506,7 @@ static int acp_init(void __iomem *acp_mm
 	return 0;
 }
 
-/* Deintialize ACP */
+/* Deinitialize ACP */
 static int acp_deinit(void __iomem *acp_mmio)
 {
 	u32 val;
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances.patch

