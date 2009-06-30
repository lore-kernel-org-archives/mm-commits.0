From: akpm@linux-foundation.org
Subject: + staging-rtl8187se-remove-dependency-on-wireless_ext-version.patch added to -mm tree
Date: Tue, 30 Jun 2009 12:45:55 -0700
Message-ID: <200906301945.n5UJjuCR007217@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756183AbZF3TqL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jun 2009 15:46:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.beregalov@gmail.com, greg@kroah.com


The patch titled
     rtl8187se: remove dependency on WIRELESS_EXT version
has been added to the -mm tree.  Its filename is
     staging-rtl8187se-remove-dependency-on-wireless_ext-version.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtl8187se: remove dependency on WIRELESS_EXT version
From: Alexander Beregalov <a.beregalov@gmail.com>

As the driver is in mainline now we can remove such dependencies. 
WIRELESS_EXT is 22 now.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/rtl8187se/ieee80211.h                      |    9 ---
 drivers/staging/rtl8187se/ieee80211/ieee80211.h            |    9 ---
 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c |   24 ----------
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c         |    4 -
 drivers/staging/rtl8187se/r8180_core.c                     |   13 -----
 drivers/staging/rtl8187se/r8180_wx.c                       |    4 -
 6 files changed, 63 deletions(-)

diff -puN drivers/staging/rtl8187se/ieee80211.h~staging-rtl8187se-remove-dependency-on-wireless_ext-version drivers/staging/rtl8187se/ieee80211.h
--- a/drivers/staging/rtl8187se/ieee80211.h~staging-rtl8187se-remove-dependency-on-wireless_ext-version
+++ a/drivers/staging/rtl8187se/ieee80211.h
@@ -196,15 +196,6 @@ typedef struct ieee_param {
 }ieee_param;
 
 
-#if WIRELESS_EXT < 17
-#define IW_QUAL_QUAL_INVALID   0x10
-#define IW_QUAL_LEVEL_INVALID  0x20
-#define IW_QUAL_NOISE_INVALID  0x40
-#define IW_QUAL_QUAL_UPDATED   0x1
-#define IW_QUAL_LEVEL_UPDATED  0x2
-#define IW_QUAL_NOISE_UPDATED  0x4
-#endif
-
 // linux under 2.6.9 release may not support it, so modify it for common use
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,9))
 #define MSECS(t)	(1000 * ((t) / HZ) + 1000 * ((t) % HZ) / HZ)
diff -puN drivers/staging/rtl8187se/ieee80211/ieee80211.h~staging-rtl8187se-remove-dependency-on-wireless_ext-version drivers/staging/rtl8187se/ieee80211/ieee80211.h
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211.h~staging-rtl8187se-remove-dependency-on-wireless_ext-version
+++ a/drivers/staging/rtl8187se/ieee80211/ieee80211.h
@@ -196,15 +196,6 @@ typedef struct ieee_param {
 }ieee_param;
 
 
-#if WIRELESS_EXT < 17
-#define IW_QUAL_QUAL_INVALID   0x10
-#define IW_QUAL_LEVEL_INVALID  0x20
-#define IW_QUAL_NOISE_INVALID  0x40
-#define IW_QUAL_QUAL_UPDATED   0x1
-#define IW_QUAL_LEVEL_UPDATED  0x2
-#define IW_QUAL_NOISE_UPDATED  0x4
-#endif
-
 // linux under 2.6.9 release may not support it, so modify it for common use
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,9))
 #define MSECS(t)	(1000 * ((t) / HZ) + 1000 * ((t) % HZ) / HZ)
diff -puN drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c~staging-rtl8187se-remove-dependency-on-wireless_ext-version drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c~staging-rtl8187se-remove-dependency-on-wireless_ext-version
+++ a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
@@ -753,7 +753,6 @@ static int ieee80211_michael_mic_add(str
 }
 
 
-#if WIRELESS_EXT >= 18
 static void ieee80211_michael_mic_failure(struct net_device *dev,
 				       struct ieee80211_hdr *hdr,
 				       int keyidx)
@@ -774,29 +773,6 @@ static void ieee80211_michael_mic_failur
 	wrqu.data.length = sizeof(ev);
 	wireless_send_event(dev, IWEVMICHAELMICFAILURE, &wrqu, (char *) &ev);
 }
-#elif WIRELESS_EXT >= 15
-static void ieee80211_michael_mic_failure(struct net_device *dev,
-				       struct ieee80211_hdr *hdr,
-				       int keyidx)
-{
-	union iwreq_data wrqu;
-	char buf[128];
-
-	/* TODO: needed parameters: count, keyid, key type, TSC */
-	sprintf(buf, "MLME-MICHAELMICFAILURE.indication(keyid=%d %scast addr="
-		MAC_FMT ")", keyidx, hdr->addr1[0] & 0x01 ? "broad" : "uni",
-		MAC_ARG(hdr->addr2));
-	memset(&wrqu, 0, sizeof(wrqu));
-	wrqu.data.length = strlen(buf);
-	wireless_send_event(dev, IWEVCUSTOM, &wrqu, buf);
-}
-#else /* WIRELESS_EXT >= 15 */
-static inline void ieee80211_michael_mic_failure(struct net_device *dev,
-					      struct ieee80211_hdr *hdr,
-					      int keyidx)
-{
-}
-#endif /* WIRELESS_EXT >= 15 */
 
 
 static int ieee80211_michael_mic_verify(struct sk_buff *skb, int keyidx,
diff -puN drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c~staging-rtl8187se-remove-dependency-on-wireless_ext-version drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c~staging-rtl8187se-remove-dependency-on-wireless_ext-version
+++ a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
@@ -644,7 +644,6 @@ int ieee80211_rx(struct ieee80211_device
 	hdrlen = ieee80211_get_hdrlen(fc);
 
 #ifdef NOT_YET
-#if WIRELESS_EXT > 15
 	/* Put this code here so that we avoid duplicating it in all
 	 * Rx paths. - Jean II */
 #ifdef IW_WIRELESS_SPY		/* defined in iw_handler.h */
@@ -658,18 +657,15 @@ int ieee80211_rx(struct ieee80211_device
 		wireless_spy_update(dev, hdr->addr2, &wstats);
 	}
 #endif /* IW_WIRELESS_SPY */
-#endif /* WIRELESS_EXT > 15 */
 	hostap_update_rx_stats(local->ap, hdr, rx_stats);
 #endif
 
-#if WIRELESS_EXT > 15
 	if (ieee->iw_mode == IW_MODE_MONITOR) {
 		ieee80211_monitor_rx(ieee, skb, rx_stats);
 		stats->rx_packets++;
 		stats->rx_bytes += skb->len;
 		return 1;
 	}
-#endif
 	if (ieee->host_decrypt) {
 		int idx = 0;
 		if (skb->len >= hdrlen + 3)
diff -puN drivers/staging/rtl8187se/r8180_core.c~staging-rtl8187se-remove-dependency-on-wireless_ext-version drivers/staging/rtl8187se/r8180_core.c
--- a/drivers/staging/rtl8187se/r8180_core.c~staging-rtl8187se-remove-dependency-on-wireless_ext-version
+++ a/drivers/staging/rtl8187se/r8180_core.c
@@ -592,14 +592,6 @@ static int proc_get_stats_tx(char *page,
 }
 
 
-#if WIRELESS_EXT < 17
-static struct iw_statistics *r8180_get_wireless_stats(struct net_device *dev)
-{
-       struct r8180_priv *priv = ieee80211_priv(dev);
-
-       return &priv->wstats;
-}
-#endif
 void rtl8180_proc_module_init(void)
 {
 	DMESG("Initializing proc filesystem");
@@ -5950,12 +5942,7 @@ static int __devinit rtl8180_pci_probe(s
 	dev->netdev_ops = &rtl8180_netdev_ops;
 	dev->wireless_handlers = &r8180_wx_handlers_def;
 
-#if WIRELESS_EXT >= 12
-#if WIRELESS_EXT < 17
-	dev->get_wireless_stats = r8180_get_wireless_stats;
-#endif
 	dev->wireless_handlers = (struct iw_handler_def *) &r8180_wx_handlers_def;
-#endif
 
 	dev->type=ARPHRD_ETHER;
 	dev->watchdog_timeo = HZ*3; //added by david woo, 2007.12.13
diff -puN drivers/staging/rtl8187se/r8180_wx.c~staging-rtl8187se-remove-dependency-on-wireless_ext-version drivers/staging/rtl8187se/r8180_wx.c
--- a/drivers/staging/rtl8187se/r8180_wx.c~staging-rtl8187se-remove-dependency-on-wireless_ext-version
+++ a/drivers/staging/rtl8187se/r8180_wx.c
@@ -1543,7 +1543,6 @@ static iw_handler r8180_private_handler[
 	r8180_wx_set_forcerate,
 };
 
-#if WIRELESS_EXT >= 17
 static inline int is_same_network(struct ieee80211_network *src,
                                   struct ieee80211_network *dst,
 				  struct ieee80211_device *ieee)
@@ -1626,7 +1625,6 @@ static struct iw_statistics *r8180_get_w
 	wstats->qual.updated = IW_QUAL_ALL_UPDATED| IW_QUAL_DBM;
 	return wstats;
 }
-#endif
 
 
 struct iw_handler_def  r8180_wx_handlers_def={
@@ -1635,9 +1633,7 @@ struct iw_handler_def  r8180_wx_handlers
 	.private = r8180_private_handler,
 	.num_private = sizeof(r8180_private_handler) / sizeof(iw_handler),
  	.num_private_args = sizeof(r8180_private_args) / sizeof(struct iw_priv_args),
-#if WIRELESS_EXT >= 17
 	.get_wireless_stats = r8180_get_wireless_stats,
-#endif
 	.private_args = (struct iw_priv_args *)r8180_private_args,
 };
 
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

linux-next.patch
comedi-jr3_pcic-add-required-includes.patch
vt6655-fix-build-when-config_wireless_ext.patch
vt6655-remove-dependency-on-wireless_ext-version.patch
stlc45xx-convert-config_interface-to-bss_info_changed.patch
vt6655-s-void-void.patch
staging-otus-remove-dependency-on-wireless_ext-version.patch
staging-rt2860-remove-dependency-on-wireless_ext-version.patch
staging-rtl8187se-remove-dependency-on-wireless_ext-version.patch

