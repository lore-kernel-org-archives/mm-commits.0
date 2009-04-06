From: akpm@linux-foundation.org
Subject: [merged] workqueue-add-to_delayed_work-helper-function.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:33:11 -0700
Message-ID: <200904061933.n36JXBxl011005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758627AbZDFVBh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 17:01:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, benh@kernel.crashing.org, davem@davemloft.net, greg@kroah.com, herbert@gondor.apana.org.au, mingo@elte.hu, penberg@cs.helsinki.fi, schwidefsky@de.ibm.com, mm-commi


The patch titled
     workqueue: add to_delayed_work() helper function
has been removed from the -mm tree.  Its filename was
     workqueue-add-to_delayed_work-helper-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: workqueue: add to_delayed_work() helper function
From: Jean Delvare <khali@linux-fr.org>

It is a fairly common operation to have a pointer to a work and to need a
pointer to the delayed work it is contained in.  In particular, all
delayed works which want to rearm themselves will have to do that.  So it
would seem fair to offer a helper function for this operation.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/vio.c                               |    2 +-
 drivers/crypto/hifn_795x.c                              |    2 +-
 drivers/input/mouse/hgpk.c                              |    2 +-
 drivers/net/dm9000.c                                    |    2 +-
 drivers/net/mlx4/en_netdev.c                            |    2 +-
 drivers/net/mlx4/en_rx.c                                |    2 +-
 drivers/net/mlx4/sense.c                                |    2 +-
 drivers/net/phy/phy.c                                   |    3 +--
 drivers/s390/scsi/zfcp_fc.c                             |    2 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c |    8 ++++----
 drivers/staging/rtl8187se/r8180_core.c                  |    8 ++++----
 drivers/staging/rtl8187se/r8180_dm.c                    |    6 +++---
 drivers/usb/wusbcore/devconnect.c                       |    2 +-
 include/linux/workqueue.h                               |    5 +++++
 mm/slab.c                                               |    3 +--
 15 files changed, 27 insertions(+), 24 deletions(-)

diff -puN arch/powerpc/kernel/vio.c~workqueue-add-to_delayed_work-helper-function arch/powerpc/kernel/vio.c
--- a/arch/powerpc/kernel/vio.c~workqueue-add-to_delayed_work-helper-function
+++ a/arch/powerpc/kernel/vio.c
@@ -482,7 +482,7 @@ static void vio_cmo_balance(struct work_
 	cmo->excess.size = cmo->entitled - cmo->reserve.size;
 	cmo->excess.free = cmo->excess.size - need;
 
-	cancel_delayed_work(container_of(work, struct delayed_work, work));
+	cancel_delayed_work(to_delayed_work(work));
 	spin_unlock_irqrestore(&vio_cmo.lock, flags);
 }
 
diff -puN drivers/crypto/hifn_795x.c~workqueue-add-to_delayed_work-helper-function drivers/crypto/hifn_795x.c
--- a/drivers/crypto/hifn_795x.c~workqueue-add-to_delayed_work-helper-function
+++ a/drivers/crypto/hifn_795x.c
@@ -1882,7 +1882,7 @@ static void hifn_clear_rings(struct hifn
 
 static void hifn_work(struct work_struct *work)
 {
-	struct delayed_work *dw = container_of(work, struct delayed_work, work);
+	struct delayed_work *dw = to_delayed_work(work);
 	struct hifn_device *dev = container_of(dw, struct hifn_device, work);
 	unsigned long flags;
 	int reset = 0;
diff -puN drivers/input/mouse/hgpk.c~workqueue-add-to_delayed_work-helper-function drivers/input/mouse/hgpk.c
--- a/drivers/input/mouse/hgpk.c~workqueue-add-to_delayed_work-helper-function
+++ a/drivers/input/mouse/hgpk.c
@@ -381,7 +381,7 @@ static void hgpk_disconnect(struct psmou
 
 static void hgpk_recalib_work(struct work_struct *work)
 {
-	struct delayed_work *w = container_of(work, struct delayed_work, work);
+	struct delayed_work *w = to_delayed_work(work);
 	struct hgpk_data *priv = container_of(w, struct hgpk_data, recalib_wq);
 	struct psmouse *psmouse = priv->psmouse;
 
diff -puN drivers/net/dm9000.c~workqueue-add-to_delayed_work-helper-function drivers/net/dm9000.c
--- a/drivers/net/dm9000.c~workqueue-add-to_delayed_work-helper-function
+++ a/drivers/net/dm9000.c
@@ -559,7 +559,7 @@ static void dm9000_show_carrier(board_in
 static void
 dm9000_poll_work(struct work_struct *w)
 {
-	struct delayed_work *dw = container_of(w, struct delayed_work, work);
+	struct delayed_work *dw = to_delayed_work(w);
 	board_info_t *db = container_of(dw, board_info_t, phy_poll);
 	struct net_device *ndev = db->ndev;
 
diff -puN drivers/net/mlx4/en_netdev.c~workqueue-add-to_delayed_work-helper-function drivers/net/mlx4/en_netdev.c
--- a/drivers/net/mlx4/en_netdev.c~workqueue-add-to_delayed_work-helper-function
+++ a/drivers/net/mlx4/en_netdev.c
@@ -505,7 +505,7 @@ out:
 
 static void mlx4_en_do_get_stats(struct work_struct *work)
 {
-	struct delayed_work *delay = container_of(work, struct delayed_work, work);
+	struct delayed_work *delay = to_delayed_work(work);
 	struct mlx4_en_priv *priv = container_of(delay, struct mlx4_en_priv,
 						 stats_task);
 	struct mlx4_en_dev *mdev = priv->mdev;
diff -puN drivers/net/mlx4/en_rx.c~workqueue-add-to_delayed_work-helper-function drivers/net/mlx4/en_rx.c
--- a/drivers/net/mlx4/en_rx.c~workqueue-add-to_delayed_work-helper-function
+++ a/drivers/net/mlx4/en_rx.c
@@ -298,7 +298,7 @@ static void mlx4_en_free_rx_buf(struct m
 
 void mlx4_en_rx_refill(struct work_struct *work)
 {
-	struct delayed_work *delay = container_of(work, struct delayed_work, work);
+	struct delayed_work *delay = to_delayed_work(work);
 	struct mlx4_en_priv *priv = container_of(delay, struct mlx4_en_priv,
 						 refill_task);
 	struct mlx4_en_dev *mdev = priv->mdev;
diff -puN drivers/net/mlx4/sense.c~workqueue-add-to_delayed_work-helper-function drivers/net/mlx4/sense.c
--- a/drivers/net/mlx4/sense.c~workqueue-add-to_delayed_work-helper-function
+++ a/drivers/net/mlx4/sense.c
@@ -103,7 +103,7 @@ void mlx4_do_sense_ports(struct mlx4_dev
 
 static void mlx4_sense_port(struct work_struct *work)
 {
-	struct delayed_work *delay = container_of(work, struct delayed_work, work);
+	struct delayed_work *delay = to_delayed_work(work);
 	struct mlx4_sense *sense = container_of(delay, struct mlx4_sense,
 						sense_poll);
 	struct mlx4_dev *dev = sense->dev;
diff -puN drivers/net/phy/phy.c~workqueue-add-to_delayed_work-helper-function drivers/net/phy/phy.c
--- a/drivers/net/phy/phy.c~workqueue-add-to_delayed_work-helper-function
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
diff -puN drivers/s390/scsi/zfcp_fc.c~workqueue-add-to_delayed_work-helper-function drivers/s390/scsi/zfcp_fc.c
--- a/drivers/s390/scsi/zfcp_fc.c~workqueue-add-to_delayed_work-helper-function
+++ a/drivers/s390/scsi/zfcp_fc.c
@@ -94,7 +94,7 @@ static int zfcp_wka_port_get(struct zfcp
 
 static void zfcp_wka_port_offline(struct work_struct *work)
 {
-	struct delayed_work *dw = container_of(work, struct delayed_work, work);
+	struct delayed_work *dw = to_delayed_work(work);
 	struct zfcp_wka_port *wka_port =
 			container_of(dw, struct zfcp_wka_port, work);
 
diff -puN drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c~workqueue-add-to_delayed_work-helper-function drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c~workqueue-add-to_delayed_work-helper-function
+++ a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
@@ -719,7 +719,7 @@ void ieee80211_softmac_scan(struct ieee8
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 void ieee80211_softmac_scan_wq(struct work_struct *work)
 {
-	struct delayed_work *dwork = container_of(work, struct delayed_work, work);
+	struct delayed_work *dwork = to_delayed_work(work);
 	struct ieee80211_device *ieee = container_of(dwork, struct ieee80211_device, softmac_scan_wq);
 #else
 void ieee80211_softmac_scan_wq(struct ieee80211_device *ieee)
@@ -777,7 +777,7 @@ out:
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 void ieee80211_softmac_scan_wq(struct work_struct *work)
 {
-        struct delayed_work *dwork = container_of(work, struct delayed_work, work);
+	struct delayed_work *dwork = to_delayed_work(work);
         struct ieee80211_device *ieee = container_of(work, struct ieee80211_device, softmac_scan_wq);
 #else
 void ieee80211_softmac_scan_wq(struct ieee80211_device *ieee)
@@ -2980,7 +2980,7 @@ void ieee80211_start_monitor_mode(struct
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 void ieee80211_start_ibss_wq(struct work_struct *work)
 {
-	struct delayed_work *dwork = container_of(work, struct delayed_work, work);
+	struct delayed_work *dwork = to_delayed_work(work);
 	struct ieee80211_device *ieee = container_of(dwork, struct ieee80211_device, start_ibss_wq);
 #else
 void ieee80211_start_ibss_wq(struct ieee80211_device *ieee)
@@ -3162,7 +3162,7 @@ void ieee80211_disassociate(struct ieee8
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 void ieee80211_associate_retry_wq(struct work_struct *work)
 {
-	struct delayed_work *dwork = container_of(work, struct delayed_work, work);
+	struct delayed_work *dwork = to_delayed_work(work);
 	struct ieee80211_device *ieee = container_of(dwork, struct ieee80211_device, associate_retry_wq);
 #else
 void ieee80211_associate_retry_wq(struct ieee80211_device *ieee)
diff -puN drivers/staging/rtl8187se/r8180_core.c~workqueue-add-to_delayed_work-helper-function drivers/staging/rtl8187se/r8180_core.c
--- a/drivers/staging/rtl8187se/r8180_core.c~workqueue-add-to_delayed_work-helper-function
+++ a/drivers/staging/rtl8187se/r8180_core.c
@@ -5438,7 +5438,7 @@ void rtl8180_hw_wakeup_wq (struct work_s
 //	struct r8180_priv *priv = container_of(work, struct r8180_priv, watch_dog_wq);
 //	struct ieee80211_device * ieee = (struct ieee80211_device*)
 //	                                       container_of(work, struct ieee80211_device, watch_dog_wq);
-	struct delayed_work *dwork = container_of(work,struct delayed_work,work);
+	struct delayed_work *dwork = to_delayed_work(work);
 	struct ieee80211_device *ieee = container_of(dwork,struct ieee80211_device,hw_wakeup_wq);
 	struct net_device *dev = ieee->dev;
 #else
@@ -5459,7 +5459,7 @@ void rtl8180_hw_sleep_wq (struct work_st
 //      struct r8180_priv *priv = container_of(work, struct r8180_priv, watch_dog_wq);
 //      struct ieee80211_device * ieee = (struct ieee80211_device*)
 //                                             container_of(work, struct ieee80211_device, watch_dog_wq);
-        struct delayed_work *dwork = container_of(work,struct delayed_work,work);
+	struct delayed_work *dwork = to_delayed_work(work);
         struct ieee80211_device *ieee = container_of(dwork,struct ieee80211_device,hw_sleep_wq);
         struct net_device *dev = ieee->dev;
 #else
@@ -6407,7 +6407,7 @@ priv->txnpring)/8);
 void rtl8180_tx_irq_wq(struct work_struct *work)
 {
 	//struct r8180_priv *priv = container_of(work, struct r8180_priv, reset_wq);
-        struct delayed_work *dwork = container_of(work,struct delayed_work,work);
+	struct delayed_work *dwork = to_delayed_work(work);
 	struct ieee80211_device * ieee = (struct ieee80211_device*)
 	                                       container_of(dwork, struct ieee80211_device, watch_dog_wq);
 	struct net_device *dev = ieee->dev;
@@ -6691,7 +6691,7 @@ lizhaoming--------------------------- RF
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 void GPIOChangeRFWorkItemCallBack(struct work_struct *work)
 {
-	//struct delayed_work *dwork = container_of(work, struct delayed_work, work);
+	//struct delayed_work *dwork = to_delayed_work(work);
 	struct ieee80211_device *ieee = container_of(work, struct ieee80211_device, GPIOChangeRFWorkItem.work);
 	struct net_device *dev = ieee->dev;
 	struct r8180_priv *priv = ieee80211_priv(dev);
diff -puN drivers/staging/rtl8187se/r8180_dm.c~workqueue-add-to_delayed_work-helper-function drivers/staging/rtl8187se/r8180_dm.c
--- a/drivers/staging/rtl8187se/r8180_dm.c~workqueue-add-to_delayed_work-helper-function
+++ a/drivers/staging/rtl8187se/r8180_dm.c
@@ -132,7 +132,7 @@ void rtl8180_tx_pw_wq (struct work_struc
 //      struct r8180_priv *priv = container_of(work, struct r8180_priv, watch_dog_wq);
 //      struct ieee80211_device * ieee = (struct ieee80211_device*)
 //                                             container_of(work, struct ieee80211_device, watch_dog_wq);
-        struct delayed_work *dwork = container_of(work,struct delayed_work,work);
+        struct delayed_work *dwork = to_delayed_work(work);
         struct ieee80211_device *ieee = container_of(dwork,struct ieee80211_device,tx_pw_wq);
         struct net_device *dev = ieee->dev;
 #else
@@ -314,7 +314,7 @@ void rtl8180_hw_dig_wq (struct work_stru
 //      struct r8180_priv *priv = container_of(work, struct r8180_priv, watch_dog_wq);
 //      struct ieee80211_device * ieee = (struct ieee80211_device*)
 //                                             container_of(work, struct ieee80211_device, watch_dog_wq);
-        struct delayed_work *dwork = container_of(work,struct delayed_work,work);
+        struct delayed_work *dwork = to_delayed_work(work);
         struct ieee80211_device *ieee = container_of(dwork,struct ieee80211_device,hw_dig_wq);
         struct net_device *dev = ieee->dev;
 #else
@@ -1250,7 +1250,7 @@ SetInitialGain:
 #if LINUX_VERSION_CODE >=KERNEL_VERSION(2,6,20)
 void rtl8180_rate_adapter(struct work_struct * work)
 {
-	struct delayed_work *dwork = container_of(work,struct delayed_work,work);
+	struct delayed_work *dwork = to_delayed_work(work);
         struct ieee80211_device *ieee = container_of(dwork,struct ieee80211_device,rate_adapter_wq);
         struct net_device *dev = ieee->dev;
 #else
diff -puN drivers/usb/wusbcore/devconnect.c~workqueue-add-to_delayed_work-helper-function drivers/usb/wusbcore/devconnect.c
--- a/drivers/usb/wusbcore/devconnect.c~workqueue-add-to_delayed_work-helper-function
+++ a/drivers/usb/wusbcore/devconnect.c
@@ -471,7 +471,7 @@ static void __wusbhc_keep_alive(struct w
  */
 static void wusbhc_keep_alive_run(struct work_struct *ws)
 {
-	struct delayed_work *dw = container_of(ws, struct delayed_work, work);
+	struct delayed_work *dw = to_delayed_work(ws);
 	struct wusbhc *wusbhc =	container_of(dw, struct wusbhc, keep_alive_timer);
 
 	mutex_lock(&wusbhc->mutex);
diff -puN include/linux/workqueue.h~workqueue-add-to_delayed_work-helper-function include/linux/workqueue.h
--- a/include/linux/workqueue.h~workqueue-add-to_delayed_work-helper-function
+++ a/include/linux/workqueue.h
@@ -41,6 +41,11 @@ struct delayed_work {
 	struct timer_list timer;
 };
 
+static inline struct delayed_work *to_delayed_work(struct work_struct *work)
+{
+	return container_of(work, struct delayed_work, work);
+}
+
 struct execute_work {
 	struct work_struct work;
 };
diff -puN mm/slab.c~workqueue-add-to_delayed_work-helper-function mm/slab.c
--- a/mm/slab.c~workqueue-add-to_delayed_work-helper-function
+++ a/mm/slab.c
@@ -3992,8 +3992,7 @@ static void cache_reap(struct work_struc
 	struct kmem_cache *searchp;
 	struct kmem_list3 *l3;
 	int node = numa_node_id();
-	struct delayed_work *work =
-		container_of(w, struct delayed_work, work);
+	struct delayed_work *work = to_delayed_work(w);
 
 	if (!mutex_trylock(&cache_chain_mutex))
 		/* Give up. Setup the next iteration. */
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
linux-next.patch
dell-laptop-fix-uninitialized-wrong-return-value.patch
i2c-incremental-i2c-mpc-driver-fix-for-multi-master-i2c-busses.patch
tdfxfb-move-i2c-functionality-into-the-tdfxfb.patch
tdfxfb-make-use-of-ddc-information-about-connected-monitor.patch

