From: akpm@linux-foundation.org
Subject: [folded] workqueue-add-to_delayed_work-helper-function-update.patch removed from -mm tree
Date: Thu, 02 Apr 2009 13:12:59 -0700
Message-ID: <200904022013.n32KCxOm022019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754760AbZDBUOz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2009 16:14:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     workqueue-add-to_delayed_work-helper-function update
has been removed from the -mm tree.  Its filename was
     workqueue-add-to_delayed_work-helper-function-update.patch

This patch was dropped because it was folded into workqueue-add-to_delayed_work-helper-function.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: workqueue-add-to_delayed_work-helper-function update
From: Jean Delvare <khali@linux-fr.org>

It is a fairly common operation to have a pointer to a work and to
need a pointer to the delayed work it is contained in. In particular,
all delayed works which want to rearm themselves will have to do that.
So it would seem fair to offer a helper function for this operation.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/mlx4/sense.c                                |    2 +-
 drivers/net/phy/phy.c                                   |    3 +--
 drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c |    2 +-
 drivers/staging/rtl8187se/r8180_core.c                  |    4 ++--
 4 files changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/net/mlx4/sense.c~workqueue-add-to_delayed_work-helper-function-update drivers/net/mlx4/sense.c
--- a/drivers/net/mlx4/sense.c~workqueue-add-to_delayed_work-helper-function-update
+++ a/drivers/net/mlx4/sense.c
@@ -103,7 +103,7 @@ void mlx4_do_sense_ports(struct mlx4_dev
 
 static void mlx4_sense_port(struct work_struct *work)
 {
-	struct delayed_work *delay = container_of(work, struct delayed_work, work);
+	struct delayed_work *delay = to_delayed_work(work);
 	struct mlx4_sense *sense = container_of(delay, struct mlx4_sense,
 						sense_poll);
 	struct mlx4_dev *dev = sense->dev;
diff -puN drivers/net/phy/phy.c~workqueue-add-to_delayed_work-helper-function-update drivers/net/phy/phy.c
--- a/drivers/net/phy/phy.c~workqueue-add-to_delayed_work-helper-function-update
+++ a/drivers/net/phy/phy.c
@@ -757,8 +757,7 @@ EXPORT_SYMBOL(phy_start);
  */
 static void phy_state_machine(struct work_struct *work)
 {
-	struct delayed_work *dwork =
-			container_of(work, struct delayed_work, work);
+	struct delayed_work *dwork = to_delayed_work(work);
 	struct phy_device *phydev =
 			container_of(dwork, struct phy_device, state_queue);
 	int needs_aneg = 0;
diff -puN drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c~workqueue-add-to_delayed_work-helper-function-update drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c~workqueue-add-to_delayed_work-helper-function-update
+++ a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
@@ -777,7 +777,7 @@ out:
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 void ieee80211_softmac_scan_wq(struct work_struct *work)
 {
-	struct delayed_work *dwork = to_delayed_work(work);
+        struct delayed_work *dwork = to_delayed_work(work);
         struct ieee80211_device *ieee = container_of(work, struct ieee80211_device, softmac_scan_wq);
 #else
 void ieee80211_softmac_scan_wq(struct ieee80211_device *ieee)
diff -puN drivers/staging/rtl8187se/r8180_core.c~workqueue-add-to_delayed_work-helper-function-update drivers/staging/rtl8187se/r8180_core.c
--- a/drivers/staging/rtl8187se/r8180_core.c~workqueue-add-to_delayed_work-helper-function-update
+++ a/drivers/staging/rtl8187se/r8180_core.c
@@ -5459,7 +5459,7 @@ void rtl8180_hw_sleep_wq (struct work_st
 //      struct r8180_priv *priv = container_of(work, struct r8180_priv, watch_dog_wq);
 //      struct ieee80211_device * ieee = (struct ieee80211_device*)
 //                                             container_of(work, struct ieee80211_device, watch_dog_wq);
-	struct delayed_work *dwork = to_delayed_work(work);
+        struct delayed_work *dwork = to_delayed_work(work);
         struct ieee80211_device *ieee = container_of(dwork,struct ieee80211_device,hw_sleep_wq);
         struct net_device *dev = ieee->dev;
 #else
@@ -6407,7 +6407,7 @@ priv->txnpring)/8);
 void rtl8180_tx_irq_wq(struct work_struct *work)
 {
 	//struct r8180_priv *priv = container_of(work, struct r8180_priv, reset_wq);
-	struct delayed_work *dwork = to_delayed_work(work);
+        struct delayed_work *dwork = to_delayed_work(work);
 	struct ieee80211_device * ieee = (struct ieee80211_device*)
 	                                       container_of(dwork, struct ieee80211_device, watch_dog_wq);
 	struct net_device *dev = ieee->dev;
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
workqueue-add-to_delayed_work-helper-function.patch
workqueue-add-to_delayed_work-helper-function-update.patch
memory_accessor-new-interface-for-reading-writing-persistent-memory.patch
memory_accessor-implement-the-new-memory_accessor-interface-for-i2c-eeprom.patch
memory_accessor-implement-the-new-memory_accessor-interfaces-for-spi-eeproms.patch
linux-next.patch
dell-laptop-fix-uninitialized-wrong-return-value.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
i2c-incremental-i2c-mpc-driver-fix-for-multi-master-i2c-busses.patch
tdfxfb-move-i2c-functionality-into-the-tdfxfb.patch
tdfxfb-make-use-of-ddc-information-about-connected-monitor.patch

