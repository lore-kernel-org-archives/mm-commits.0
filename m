From: akpm@linux-foundation.org
Subject: [merged] staging-otus-remove-dependency-on-wireless_ext-version.patch removed from -mm tree
Date: Tue, 14 Jul 2009 13:33:12 -0700
Message-ID: <200907142033.n6EKXCVZ013179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756490AbZGNUdP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jul 2009 16:33:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.beregalov@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     otus: remove dependency on WIRELESS_EXT version
has been removed from the -mm tree.  Its filename was
     staging-otus-remove-dependency-on-wireless_ext-version.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: otus: remove dependency on WIRELESS_EXT version
From: Alexander Beregalov <a.beregalov@gmail.com>

As the driver is in mainline now we can remove such dependencies. 
WIRELESS_EXT is 22 now.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/otus/ioctl.c    |   20 ++------------------
 drivers/staging/otus/usbdrv.c   |   13 -------------
 drivers/staging/otus/wrap_buf.c |    4 ----
 drivers/staging/otus/wrap_dbg.c |    3 ---
 drivers/staging/otus/wrap_ev.c  |    7 -------
 drivers/staging/otus/wrap_mem.c |    3 ---
 drivers/staging/otus/wrap_mis.c |    3 ---
 drivers/staging/otus/wrap_pkt.c |    4 ----
 drivers/staging/otus/wrap_sec.c |    3 ---
 drivers/staging/otus/wrap_usb.c |    3 ---
 drivers/staging/otus/wwrap.c    |    3 ---
 drivers/staging/otus/zdcompat.h |   10 ----------
 12 files changed, 2 insertions(+), 74 deletions(-)

diff -puN drivers/staging/otus/ioctl.c~staging-otus-remove-dependency-on-wireless_ext-version drivers/staging/otus/ioctl.c
--- a/drivers/staging/otus/ioctl.c~staging-otus-remove-dependency-on-wireless_ext-version
+++ a/drivers/staging/otus/ioctl.c
@@ -58,9 +58,7 @@
 #define ZD_MAX_KEY_SIZE			    32
 #define ZD_MAX_GENERIC_SIZE		    64
 
-#if WIRELESS_EXT > 12
 #include <net/iw_handler.h>
-#endif
 
 extern u16_t zfLnxGetVapId(zdev_t *dev);
 
@@ -248,7 +246,6 @@ int usbdrv_ioctl_setrts(struct net_devic
 	return 0;
 }
 
-#if WIRELESS_EXT > 14
 /*
  * Encode a WPA or RSN information element as a custom
  * element using the hostap format.
@@ -269,7 +266,6 @@ u32 encode_ie(void *buf, u32 bufsize, co
 		p += sprintf(p, "%02x", ie[i]);
 	return (i == ielen ? p - (u8 *)buf:0);
 }
-#endif  /* WIRELESS_EXT > 14 */
 
 /*
  * Translate scan data returned from the card to a card independent
@@ -284,9 +280,7 @@ char *usbdrv_translate_scan(struct net_d
 	char *current_val;     /* For rates */
 	char *last_ev;
 	int i;
-	#if WIRELESS_EXT > 14
-		char    buf[64*2 + 30];
-	#endif
+	char    buf[64*2 + 30];
 
 	last_ev = current_ev;
 
@@ -365,10 +359,8 @@ char *usbdrv_translate_scan(struct net_d
 
 	/* Add quality statistics */
 	iwe.cmd = IWEVQUAL;
-	#if WIRELESS_EXT > 18
 	iwe.u.qual.updated = IW_QUAL_QUAL_UPDATED | IW_QUAL_LEVEL_UPDATED
 				| IW_QUAL_NOISE_UPDATED;
-	#endif
 	iwe.u.qual.level = list->signalStrength;
 	iwe.u.qual.noise = 0;
 	iwe.u.qual.qual = list->signalQuality;
@@ -441,8 +433,7 @@ char *usbdrv_translate_scan(struct net_d
 	/* Check if we added any event */
 	if ((current_val - current_ev) > IW_EV_LCP_LEN)
 		current_ev = current_val;
-	#if WIRELESS_EXT > 14
-		#define IEEE80211_ELEMID_RSN 0x30
+#define IEEE80211_ELEMID_RSN 0x30
 	memset(&iwe, 0, sizeof(iwe));
 	iwe.cmd = IWEVCUSTOM;
 	snprintf(buf, sizeof(buf), "bcn_int=%d", (list->beaconInterval[1] << 8)
@@ -503,7 +494,6 @@ char *usbdrv_translate_scan(struct net_d
 			last_ev = current_ev;
 		}
 	}
-	#endif
 	/* The other data in the scan result are not really
 	* interesting, so for now drop it
 	*/
@@ -697,12 +687,9 @@ int usbdrvwext_giwrange(struct net_devic
 	if (!netif_running(dev))
 		return -EINVAL;
 
-	#if WIRELESS_EXT > 9
 	range->txpower_capa = IW_TXPOW_DBM;
 	/* XXX what about min/max_pmp, min/max_pmt, etc. */
-	#endif
 
-	#if WIRELESS_EXT > 10
 	range->we_version_compiled = WIRELESS_EXT;
 	range->we_version_source = 13;
 
@@ -710,7 +697,6 @@ int usbdrvwext_giwrange(struct net_devic
 	range->retry_flags = IW_RETRY_LIMIT;
 	range->min_retry = 0;
 	range->max_retry = 255;
-	#endif  /* WIRELESS_EXT > 10 */
 
 	channel_num = zfiWlanQueryAllowChannels(dev, channels);
 
@@ -917,13 +903,11 @@ int usbdrvwext_giwscan(struct net_device
 		current_ev = usbdrv_translate_scan(dev, info, current_ev,
 					end_buf, &pBssList->bssInfo[i]);
 
-		#if WIRELESS_EXT > 16
 		if (current_ev == end_buf) {
 			kfree(pBssList);
 			data->length = current_ev - extra;
 			return -E2BIG;
 		}
-		#endif
 	}
 
 	/* Length of data */
diff -puN drivers/staging/otus/usbdrv.c~staging-otus-remove-dependency-on-wireless_ext-version drivers/staging/otus/usbdrv.c
--- a/drivers/staging/otus/usbdrv.c~staging-otus-remove-dependency-on-wireless_ext-version
+++ a/drivers/staging/otus/usbdrv.c
@@ -39,9 +39,7 @@
 #include "linux/netlink.h"
 #include "linux/rtnetlink.h"
 
-#if WIRELESS_EXT > 12
 #include <net/iw_handler.h>
-#endif
 
 #ifdef ZM_HOSTAPD_SUPPORT
 #include "athr_common.h"
@@ -113,9 +111,7 @@ extern u8_t zfLnxCreateThread(zdev_t *de
 
 /* Definition of Wireless Extension */
 
-#if WIRELESS_EXT > 12
 #include <net/iw_handler.h>
-#endif
 //wireless extension helper functions
 extern int usbdrv_ioctl_setessid(struct net_device *dev, struct iw_point *erq);
 extern int usbdrv_ioctl_setrts(struct net_device *dev, struct iw_param *rrq);
@@ -203,7 +199,6 @@ struct iw_priv_args usbdrv_private_args[
 //    { SIOCIWFIRSTPRIV + 0xC, 0, IW_PRIV_TYPE_CHAR | 12, "get_mac_mode" },
 };
 
-#if WIRELESS_EXT > 12
 static iw_handler usbdrvwext_handler[] = {
     (iw_handler) NULL,                              /* SIOCSIWCOMMIT */
     (iw_handler) usbdrvwext_giwname,                /* SIOCGIWNAME */
@@ -229,13 +224,8 @@ static iw_handler usbdrvwext_handler[] =
     (iw_handler) usbdrvwext_giwap,                  /* SIOCGIWAP */
     (iw_handler) NULL,              /* -- hole -- */
     (iw_handler) usbdrvwext_iwaplist,               /* SIOCGIWAPLIST */
-#if WIRELESS_EXT > 13
     (iw_handler) usbdrvwext_siwscan,                /* SIOCSIWSCAN */
     (iw_handler) usbdrvwext_giwscan,                /* SIOCGIWSCAN */
-#else /* WIRELESS_EXT > 13 */
-    (iw_handler) NULL, /* null */                   /* SIOCSIWSCAN */
-    (iw_handler) NULL, /* null */                   /* SIOCGIWSCAN */
-#endif /* WIRELESS_EXT > 13 */
     (iw_handler) usbdrvwext_siwessid,               /* SIOCSIWESSID */
     (iw_handler) usbdrvwext_giwessid,               /* SIOCGIWESSID */
 
@@ -291,7 +281,6 @@ static struct iw_handler_def p80211wext_
     .private = (iw_handler *) usbdrv_private_handler,
     .private_args = (struct iw_priv_args *) usbdrv_private_args
 };
-#endif
 
 /* WDS */
 //struct zsWdsStruct wds[ZM_WDS_PORT_NUMBER];
@@ -1106,9 +1095,7 @@ u8_t zfLnxInitSetup(struct net_device *d
     dev->dev_addr[4] = addr[4];
     dev->dev_addr[5] = addr[5];
 #endif
-#if WIRELESS_EXT > 12
     dev->wireless_handlers = (struct iw_handler_def *)&p80211wext_handler_def;
-#endif
 
     dev->netdev_ops = &otus_netdev_ops;
 
diff -puN drivers/staging/otus/wrap_buf.c~staging-otus-remove-dependency-on-wireless_ext-version drivers/staging/otus/wrap_buf.c
--- a/drivers/staging/otus/wrap_buf.c~staging-otus-remove-dependency-on-wireless_ext-version
+++ a/drivers/staging/otus/wrap_buf.c
@@ -29,11 +29,7 @@
 
 
 #include <linux/netlink.h>
-
-#if WIRELESS_EXT > 12
 #include <net/iw_handler.h>
-#endif
-
 
 
 /* Called to allocate buffer, must return a continue buffer space */
diff -puN drivers/staging/otus/wrap_dbg.c~staging-otus-remove-dependency-on-wireless_ext-version drivers/staging/otus/wrap_dbg.c
--- a/drivers/staging/otus/wrap_dbg.c~staging-otus-remove-dependency-on-wireless_ext-version
+++ a/drivers/staging/otus/wrap_dbg.c
@@ -27,10 +27,7 @@
 #include "usbdrv.h"
 
 #include <linux/netlink.h>
-
-#if WIRELESS_EXT > 12
 #include <net/iw_handler.h>
-#endif
 
 void zfwDumpBuf(zdev_t* dev, zbuf_t* buf)
 {
diff -puN drivers/staging/otus/wrap_ev.c~staging-otus-remove-dependency-on-wireless_ext-version drivers/staging/otus/wrap_ev.c
--- a/drivers/staging/otus/wrap_ev.c~staging-otus-remove-dependency-on-wireless_ext-version
+++ a/drivers/staging/otus/wrap_ev.c
@@ -28,10 +28,7 @@
 #include "usbdrv.h"
 
 #include <linux/netlink.h>
-
-#if WIRELESS_EXT > 12
 #include <net/iw_handler.h>
-#endif
 
 
 /***** Management *****/
@@ -75,7 +72,6 @@ u16_t zfLnxAsocNotify(zdev_t* dev, u16_t
     //            //wireless_send_event(macp->device, SIOCGIWSCAN, &wreq, NULL);
     //    wireless_send_event(macp->device, SIOCGIWAP, &wreq, NULL);
     //}
-#if WIRELESS_EXT >= 15
     //else if(macp->cardSetting.BssType == AP_BSS) {
 //        if (port == 0)
 //        {
@@ -94,7 +90,6 @@ u16_t zfLnxAsocNotify(zdev_t* dev, u16_t
 //            }
 //        }
     //}
-#endif
 //#endif
 
     return 0;
@@ -185,7 +180,6 @@ void zfLnxConnectNotify(zdev_t* dev, u16
         //            //wireless_send_event(dev, SIOCGIWSCAN, &wreq, NULL);
             wireless_send_event(dev, SIOCGIWAP, &wreq, NULL);
         }
-#if WIRELESS_EXT >= 15
         else if(zfiWlanQueryWlanMode(dev) == ZM_MODE_AP) {
             //if (port == 0)
             //{
@@ -204,7 +198,6 @@ void zfLnxConnectNotify(zdev_t* dev, u16
             //    }
             //}
         }
-#endif
     }
     //return 0;
 }
diff -puN drivers/staging/otus/wrap_mem.c~staging-otus-remove-dependency-on-wireless_ext-version drivers/staging/otus/wrap_mem.c
--- a/drivers/staging/otus/wrap_mem.c~staging-otus-remove-dependency-on-wireless_ext-version
+++ a/drivers/staging/otus/wrap_mem.c
@@ -27,10 +27,7 @@
 #include "usbdrv.h"
 
 #include <linux/netlink.h>
-
-#if WIRELESS_EXT > 12
 #include <net/iw_handler.h>
-#endif
 
 /* Memory management */
 /* Called to allocate uncached memory, allocated memory must    */
diff -puN drivers/staging/otus/wrap_mis.c~staging-otus-remove-dependency-on-wireless_ext-version drivers/staging/otus/wrap_mis.c
--- a/drivers/staging/otus/wrap_mis.c~staging-otus-remove-dependency-on-wireless_ext-version
+++ a/drivers/staging/otus/wrap_mis.c
@@ -28,10 +28,7 @@
 #include "usbdrv.h"
 
 #include <linux/netlink.h>
-
-#if WIRELESS_EXT > 12
 #include <net/iw_handler.h>
-#endif
 
 //extern struct zsWdsStruct wds[ZM_WDS_PORT_NUMBER];
 extern struct zsVapStruct vap[ZM_VAP_PORT_NUMBER];
diff -puN drivers/staging/otus/wrap_pkt.c~staging-otus-remove-dependency-on-wireless_ext-version drivers/staging/otus/wrap_pkt.c
--- a/drivers/staging/otus/wrap_pkt.c~staging-otus-remove-dependency-on-wireless_ext-version
+++ a/drivers/staging/otus/wrap_pkt.c
@@ -28,11 +28,7 @@
 #include "usbdrv.h"
 
 #include <linux/netlink.h>
-
-#if WIRELESS_EXT > 12
 #include <net/iw_handler.h>
-#endif
-
 
 
 //extern struct zsWdsStruct wds[ZM_WDS_PORT_NUMBER];
diff -puN drivers/staging/otus/wrap_sec.c~staging-otus-remove-dependency-on-wireless_ext-version drivers/staging/otus/wrap_sec.c
--- a/drivers/staging/otus/wrap_sec.c~staging-otus-remove-dependency-on-wireless_ext-version
+++ a/drivers/staging/otus/wrap_sec.c
@@ -28,10 +28,7 @@
 #include "usbdrv.h"
 
 #include <linux/netlink.h>
-
-#if WIRELESS_EXT > 12
 #include <net/iw_handler.h>
-#endif
 
 #ifdef ZM_ENABLE_CENC
 extern int zfLnxCencSendMsg(struct sock *netlink_sk, u_int8_t *msg, int len);
diff -puN drivers/staging/otus/wrap_usb.c~staging-otus-remove-dependency-on-wireless_ext-version drivers/staging/otus/wrap_usb.c
--- a/drivers/staging/otus/wrap_usb.c~staging-otus-remove-dependency-on-wireless_ext-version
+++ a/drivers/staging/otus/wrap_usb.c
@@ -28,10 +28,7 @@
 #include "usbdrv.h"
 
 #include <linux/netlink.h>
-
-#if WIRELESS_EXT > 12
 #include <net/iw_handler.h>
-#endif
 
 extern void zfLnxInitUsbTxQ(zdev_t* dev);
 extern void zfLnxInitUsbRxQ(zdev_t* dev);
diff -puN drivers/staging/otus/wwrap.c~staging-otus-remove-dependency-on-wireless_ext-version drivers/staging/otus/wwrap.c
--- a/drivers/staging/otus/wwrap.c~staging-otus-remove-dependency-on-wireless_ext-version
+++ a/drivers/staging/otus/wwrap.c
@@ -26,10 +26,7 @@
 #include "usbdrv.h"
 
 #include <linux/netlink.h>
-
-#if WIRELESS_EXT > 12
 #include <net/iw_handler.h>
-#endif
 
 extern void zfiRecv80211(zdev_t* dev, zbuf_t* buf, struct zsAdditionInfo* addInfo);
 extern void zfCoreRecv(zdev_t* dev, zbuf_t* buf, struct zsAdditionInfo* addInfo);
diff -puN drivers/staging/otus/zdcompat.h~staging-otus-remove-dependency-on-wireless_ext-version drivers/staging/otus/zdcompat.h
--- a/drivers/staging/otus/zdcompat.h~staging-otus-remove-dependency-on-wireless_ext-version
+++ a/drivers/staging/otus/zdcompat.h
@@ -35,16 +35,6 @@
 #undef netdevice_t
 typedef struct net_device netdevice_t;
 
-#ifdef WIRELESS_EXT
-#if (WIRELESS_EXT < 13)
-struct iw_request_info
-{
-        __u16           cmd;            /* Wireless Extension command */
-        __u16           flags;          /* More to come ;-) */
-};
-#endif
-#endif
