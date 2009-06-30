From: akpm@linux-foundation.org
Subject: + staging-rt2860-remove-dependency-on-wireless_ext-version.patch added to -mm tree
Date: Tue, 30 Jun 2009 12:45:52 -0700
Message-ID: <200906301945.n5UJjrCj007174@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756024AbZF3TqJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jun 2009 15:46:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.beregalov@gmail.com, greg@kroah.com


The patch titled
     rt2860: remove dependency on WIRELESS_EXT version
has been added to the -mm tree.  Its filename is
     staging-rt2860-remove-dependency-on-wireless_ext-version.patch

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
Subject: rt2860: remove dependency on WIRELESS_EXT version
From: Alexander Beregalov <a.beregalov@gmail.com>

As the driver is in mainline now we can remove such dependencies. 
WIRELESS_EXT is 22 now.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/rt2860/oid.h         |    7 -
 drivers/staging/rt2860/rt_linux.c    |    4 
 drivers/staging/rt2860/rt_main_dev.c |    9 --
 drivers/staging/rt2860/rt_profile.c  |    4 
 drivers/staging/rt2860/rtmp.h        |    4 
 drivers/staging/rt2860/sta/assoc.c   |   14 ---
 drivers/staging/rt2860/sta_ioctl.c   |  104 +++----------------------
 7 files changed, 13 insertions(+), 133 deletions(-)

diff -puN drivers/staging/rt2860/oid.h~staging-rt2860-remove-dependency-on-wireless_ext-version drivers/staging/rt2860/oid.h
--- a/drivers/staging/rt2860/oid.h~staging-rt2860-remove-dependency-on-wireless_ext-version
+++ a/drivers/staging/rt2860/oid.h
@@ -626,13 +626,6 @@ typedef struct _NDIS_802_11_CAPABILITY
      NDIS_802_11_AUTHENTICATION_ENCRYPTION AuthenticationEncryptionSupported[1];
 } NDIS_802_11_CAPABILITY, *PNDIS_802_11_CAPABILITY;
 
-#if WIRELESS_EXT <= 11
-#ifndef SIOCDEVPRIVATE
-#define SIOCDEVPRIVATE                              0x8BE0
-#endif
-#define SIOCIWFIRSTPRIV								SIOCDEVPRIVATE
-#endif
-
 #ifdef RT30xx
 #define RT_PRIV_IOCTL_EXT							(SIOCIWFIRSTPRIV + 0x01) // Sync. with AP for wsc upnp daemon
 #endif
diff -puN drivers/staging/rt2860/rt_linux.c~staging-rt2860-remove-dependency-on-wireless_ext-version drivers/staging/rt2860/rt_linux.c
--- a/drivers/staging/rt2860/rt_linux.c~staging-rt2860-remove-dependency-on-wireless_ext-version
+++ a/drivers/staging/rt2860/rt_linux.c
@@ -728,7 +728,6 @@ VOID RTMPSendWirelessEvent(
 	IN	UCHAR			BssIdx,
 	IN	CHAR			Rssi)
 {
-#if WIRELESS_EXT >= 15
 
 	union 	iwreq_data      wrqu;
 	PUCHAR 	pBuf = NULL, pBufPtr = NULL;
@@ -805,9 +804,6 @@ VOID RTMPSendWirelessEvent(
 	}
 	else
 		DBGPRINT(RT_DEBUG_ERROR, ("%s : Can't allocate memory for wireless event.\n", __func__));
-#else
-	DBGPRINT(RT_DEBUG_ERROR, ("%s : The Wireless Extension MUST be v15 or newer.\n", __func__));
-#endif  /* WIRELESS_EXT >= 15 */
 }
 
 void send_monitor_packets(
diff -puN drivers/staging/rt2860/rt_main_dev.c~staging-rt2860-remove-dependency-on-wireless_ext-version drivers/staging/rt2860/rt_main_dev.c
--- a/drivers/staging/rt2860/rt_main_dev.c~staging-rt2860-remove-dependency-on-wireless_ext-version
+++ a/drivers/staging/rt2860/rt_main_dev.c
@@ -74,11 +74,9 @@ static void CfgInitHook(PRTMP_ADAPTER pA
 
 extern	const struct iw_handler_def rt28xx_iw_handler_def;
 
-#if WIRELESS_EXT >= 12
 // This function will be called when query /proc
 struct iw_statistics *rt28xx_get_wireless_stats(
     IN struct net_device *net_dev);
-#endif
 
 struct net_device_stats *RT28xx_get_ether_stats(
     IN  struct net_device *net_dev);
@@ -695,16 +693,11 @@ static NDIS_STATUS rt_ieee80211_if_setup
 	CHAR    slot_name[IFNAMSIZ];
 	struct net_device   *device;
 
-#if WIRELESS_EXT >= 12
 	if (pAd->OpMode == OPMODE_STA)
 	{
 		dev->wireless_handlers = &rt28xx_iw_handler_def;
 	}
-#endif //WIRELESS_EXT >= 12
 
-#if WIRELESS_EXT < 21
-		dev->get_wireless_stats = rt28xx_get_wireless_stats;
-#endif
 	dev->priv_flags = INT_MAIN;
 	dev->netdev_ops = &rt2860_netdev_ops;
 	// find available device name
@@ -942,7 +935,6 @@ void CfgInitHook(PRTMP_ADAPTER pAd)
 } /* End of CfgInitHook */
 
 
-#if WIRELESS_EXT >= 12
 // This function will be called when query /proc
 struct iw_statistics *rt28xx_get_wireless_stats(
     IN struct net_device *net_dev)
@@ -976,7 +968,6 @@ struct iw_statistics *rt28xx_get_wireles
 	DBGPRINT(RT_DEBUG_TRACE, ("<--- rt28xx_get_wireless_stats\n"));
 	return &pAd->iw_stats;
 } /* End of rt28xx_get_wireless_stats */
-#endif // WIRELESS_EXT //
 
 
 
diff -puN drivers/staging/rt2860/rt_profile.c~staging-rt2860-remove-dependency-on-wireless_ext-version drivers/staging/rt2860/rt_profile.c
--- a/drivers/staging/rt2860/rt_profile.c~staging-rt2860-remove-dependency-on-wireless_ext-version
+++ a/drivers/staging/rt2860/rt_profile.c
@@ -1230,14 +1230,10 @@ NDIS_STATUS	RTMPReadParametersHook(
 					//WirelessEvent
 					if(RTMPGetKeyParameter("WirelessEvent", tmpbuf, 10, buffer))
 					{
-#if WIRELESS_EXT >= 15
 					    if(simple_strtol(tmpbuf, 0, 10) != 0)
 							pAd->CommonCfg.bWirelessEvent = simple_strtol(tmpbuf, 0, 10);
 						else
 							pAd->CommonCfg.bWirelessEvent = 0;	// disable
-#else
-						pAd->CommonCfg.bWirelessEvent = 0;	// disable
-#endif
    						DBGPRINT(RT_DEBUG_TRACE, ("WirelessEvent=%d\n", pAd->CommonCfg.bWirelessEvent));
 					}
 					if(RTMPGetKeyParameter("WiFiTest", tmpbuf, 10, buffer))
diff -puN drivers/staging/rt2860/rtmp.h~staging-rt2860-remove-dependency-on-wireless_ext-version drivers/staging/rt2860/rtmp.h
--- a/drivers/staging/rt2860/rtmp.h~staging-rt2860-remove-dependency-on-wireless_ext-version
+++ a/drivers/staging/rt2860/rtmp.h
@@ -2972,9 +2972,7 @@ typedef struct _RTMP_ADAPTER
 
 	ULONG					OneSecondnonBEpackets;		// record non BE packets per second
 
-#if WIRELESS_EXT >= 12
     struct iw_statistics    iw_stats;
-#endif
 
 	struct net_device_stats	stats;
 
@@ -6323,11 +6321,9 @@ void send_monitor_packets(
 	IN	PRTMP_ADAPTER	pAd,
 	IN	RX_BLK			*pRxBlk);
 
-#if WIRELESS_EXT >= 12
 // This function will be called when query /proc
 struct iw_statistics *rt28xx_get_wireless_stats(
     IN struct net_device *net_dev);
-#endif
 
 VOID    RTMPSetDesiredRates(
     IN  PRTMP_ADAPTER   pAdapter,
diff -puN drivers/staging/rt2860/sta/assoc.c~staging-rt2860-remove-dependency-on-wireless_ext-version drivers/staging/rt2860/sta/assoc.c
--- a/drivers/staging/rt2860/sta/assoc.c~staging-rt2860-remove-dependency-on-wireless_ext-version
+++ a/drivers/staging/rt2860/sta/assoc.c
@@ -1503,7 +1503,6 @@ int wext_notify_event_assoc(
     union iwreq_data    wrqu;
     char custom[IW_CUSTOM_MAX] = {0};
 
-#if WIRELESS_EXT > 17
     if (pAd->StaCfg.ReqVarIELen <= IW_CUSTOM_MAX)
     {
         wrqu.data.length = pAd->StaCfg.ReqVarIELen;
@@ -1512,19 +1511,6 @@ int wext_notify_event_assoc(
     }
     else
         DBGPRINT(RT_DEBUG_TRACE, ("pAd->StaCfg.ReqVarIELen > MAX_CUSTOM_LEN\n"));
-#else
-    if (((pAd->StaCfg.ReqVarIELen*2) + 17) <= IW_CUSTOM_MAX)
-    {
-        UCHAR   idx;
-        wrqu.data.length = (pAd->StaCfg.ReqVarIELen*2) + 17;
-        sprintf(custom, "ASSOCINFO(ReqIEs=");
-        for (idx=0; idx<pAd->StaCfg.ReqVarIELen; idx++)
-                sprintf(custom + strlen(custom), "%02x", pAd->StaCfg.ReqVarIEs[idx]);
-        wireless_send_event(pAd->net_dev, IWEVCUSTOM, &wrqu, custom);
-    }
-    else
-        DBGPRINT(RT_DEBUG_TRACE, ("(pAd->StaCfg.ReqVarIELen*2) + 17 > MAX_CUSTOM_LEN\n"));
-#endif
 
 	return 0;
 
diff -puN drivers/staging/rt2860/sta_ioctl.c~staging-rt2860-remove-dependency-on-wireless_ext-version drivers/staging/rt2860/sta_ioctl.c
--- a/drivers/staging/rt2860/sta_ioctl.c~staging-rt2860-remove-dependency-on-wireless_ext-version
+++ a/drivers/staging/rt2860/sta_ioctl.c
@@ -820,11 +820,9 @@ int rt_ioctl_giwrange(struct net_device 
 	range->min_frag = 256;
 	range->max_frag = 2346;
 
-#if WIRELESS_EXT > 17
 	/* IW_ENC_CAPA_* bit field */
 	range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
 					IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
-#endif
 
 	return 0;
 }
@@ -1115,25 +1113,15 @@ int rt_ioctl_giwscan(struct net_device *
 		return 0;
 	}
 
-#if WIRELESS_EXT >= 17
     if (data->length > 0)
         end_buf = extra + data->length;
     else
         end_buf = extra + IW_SCAN_MAX_DATA;
-#else
-    end_buf = extra + IW_SCAN_MAX_DATA;
-#endif
 
 	for (i = 0; i < pAdapter->ScanTab.BssNr; i++)
 	{
 		if (current_ev >= end_buf)
-        {
-#if WIRELESS_EXT >= 17
-            return -E2BIG;
-#else
-			break;
-#endif
-        }
+			return -E2BIG;
 
 		//MAC address
 		//================================
@@ -1146,11 +1134,7 @@ int rt_ioctl_giwscan(struct net_device *
 		current_ev = iwe_stream_add_event(info, current_ev,end_buf, &iwe, IW_EV_ADDR_LEN);
 #ifdef RT30xx
         if (current_ev == previous_ev)
-#if WIRELESS_EXT >= 17
-            return -E2BIG;
-#else
-			break;
-#endif
+		return -E2BIG;
 
 		/*
 		Protocol:
@@ -1226,11 +1210,7 @@ int rt_ioctl_giwscan(struct net_device *
 		current_ev	 = iwe_stream_add_event(info, current_ev, end_buf, &iwe, IW_EV_ADDR_LEN);
 #endif /* RT30xx */
         if (current_ev == previous_ev)
-#if WIRELESS_EXT >= 17
-            return -E2BIG;
-#else
-			break;
-#endif
+		return -E2BIG;
 
 		//ESSID
 		//================================
@@ -1242,11 +1222,7 @@ int rt_ioctl_giwscan(struct net_device *
         previous_ev = current_ev;
 		current_ev = iwe_stream_add_point(info, current_ev,end_buf, &iwe, pAdapter->ScanTab.BssEntry[i].Ssid);
         if (current_ev == previous_ev)
-#if WIRELESS_EXT >= 17
-            return -E2BIG;
-#else
-			break;
-#endif
+		return -E2BIG;
 
 		//Network Type
 		//================================
@@ -1269,11 +1245,7 @@ int rt_ioctl_giwscan(struct net_device *
         previous_ev = current_ev;
 		current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe,  IW_EV_UINT_LEN);
         if (current_ev == previous_ev)
-#if WIRELESS_EXT >= 17
-            return -E2BIG;
-#else
-			break;
-#endif
+		return -E2BIG;
 
 		//Channel and Frequency
 		//================================
@@ -1289,11 +1261,7 @@ int rt_ioctl_giwscan(struct net_device *
 		previous_ev = current_ev;
 		current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe, IW_EV_FREQ_LEN);
         if (current_ev == previous_ev)
-#if WIRELESS_EXT >= 17
-            return -E2BIG;
-#else
-			break;
-#endif
+		return -E2BIG;
 
         //Add quality statistics
         //================================
@@ -1304,11 +1272,7 @@ int rt_ioctl_giwscan(struct net_device *
         set_quality(pAdapter, &iwe.u.qual, pAdapter->ScanTab.BssEntry[i].Rssi);
     	current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe, IW_EV_QUAL_LEN);
         if (current_ev == previous_ev)
-#if WIRELESS_EXT >= 17
-            return -E2BIG;
-#else
-			break;
-#endif
+		return -E2BIG;
 
 		//Encyption key
 		//================================
@@ -1322,11 +1286,7 @@ int rt_ioctl_giwscan(struct net_device *
         previous_ev = current_ev;
         current_ev = iwe_stream_add_point(info, current_ev, end_buf,&iwe, (char *)pAdapter->SharedKey[BSS0][(iwe.u.data.flags & IW_ENCODE_INDEX)-1].Key);
         if (current_ev == previous_ev)
-#if WIRELESS_EXT >= 17
-            return -E2BIG;
-#else
-			break;
-#endif
+		return -E2BIG;
 
 		//Bit Rate
 		//================================
@@ -1355,11 +1315,7 @@ int rt_ioctl_giwscan(struct net_device *
         	if((current_val-current_ev)>IW_EV_LCP_LEN)
             	current_ev = current_val;
         	else
-#if WIRELESS_EXT >= 17
-                return -E2BIG;
-#else
-			    break;
-#endif
+			return -E2BIG;
         }
 
 #ifdef IWEVGENIE
@@ -1374,11 +1330,7 @@ int rt_ioctl_giwscan(struct net_device *
 			iwe.u.data.length = pAdapter->ScanTab.BssEntry[i].WpaIE.IELen;
 			current_ev = iwe_stream_add_point(info, current_ev, end_buf, &iwe, custom);
 			if (current_ev == previous_ev)
-#if WIRELESS_EXT >= 17
-                return -E2BIG;
-#else
-			    break;
-#endif
+				return -E2BIG;
 		}
 
 		//WPA2 IE
@@ -1392,11 +1344,7 @@ int rt_ioctl_giwscan(struct net_device *
 			iwe.u.data.length = pAdapter->ScanTab.BssEntry[i].RsnIE.IELen;
 			current_ev = iwe_stream_add_point(info, current_ev, end_buf, &iwe, custom);
 			if (current_ev == previous_ev)
-#if WIRELESS_EXT >= 17
-                return -E2BIG;
-#else
-			    break;
-#endif
+				return -E2BIG;
         }
 #else
         //WPA IE
@@ -1413,11 +1361,7 @@ int rt_ioctl_giwscan(struct net_device *
             previous_ev = current_ev;
     		current_ev = iwe_stream_add_point(current_ev, end_buf, &iwe,  custom);
             if (current_ev == previous_ev)
-#if WIRELESS_EXT >= 17
-                return -E2BIG;
-#else
-			    break;
-#endif
+		return -E2BIG;
         }
 
         //WPA2 IE
@@ -1433,11 +1377,7 @@ int rt_ioctl_giwscan(struct net_device *
             previous_ev = current_ev;
     		current_ev = iwe_stream_add_point(current_ev, end_buf, &iwe,  custom);
             if (current_ev == previous_ev)
-#if WIRELESS_EXT >= 17
-                return -E2BIG;
-#else
-			    break;
-#endif
+		return -E2BIG;
         }
 #endif // IWEVGENIE //
 	}
@@ -2337,7 +2277,6 @@ int rt_ioctl_siwmlme(struct net_device *
 }
 #endif // SIOCSIWMLME //
 
-#if WIRELESS_EXT > 17
 int rt_ioctl_siwauth(struct net_device *dev,
 			  struct iw_request_info *info,
 			  union iwreq_data *wrqu, char *extra)
@@ -2916,7 +2855,6 @@ int rt_ioctl_siwpmksa(struct net_device 
 
 	return 0;
 }
-#endif // #if WIRELESS_EXT > 17
 
 #ifdef DBG
 static int
@@ -3219,7 +3157,6 @@ static const iw_handler rt_handler[] =
 	(iw_handler) NULL,		                /* SIOCGIWPOWER  */
 	(iw_handler) NULL,						/* -- hole -- */
 	(iw_handler) NULL,						/* -- hole -- */
-#if WIRELESS_EXT > 17
     (iw_handler) rt_ioctl_siwgenie,         /* SIOCSIWGENIE  */
 	(iw_handler) rt_ioctl_giwgenie,         /* SIOCGIWGENIE  */
 	(iw_handler) rt_ioctl_siwauth,		    /* SIOCSIWAUTH   */
@@ -3227,7 +3164,6 @@ static const iw_handler rt_handler[] =
 	(iw_handler) rt_ioctl_siwencodeext,	    /* SIOCSIWENCODEEXT */
 	(iw_handler) rt_ioctl_giwencodeext,		/* SIOCGIWENCODEEXT */
 	(iw_handler) rt_ioctl_siwpmksa,         /* SIOCSIWPMKSA  */
-#endif
 };
 
 static const iw_handler rt_priv_handlers[] = {
@@ -4589,22 +4525,9 @@ INT RTMPQueryInformation(
                 }
                 pBss->Length = (ULONG)(sizeof(NDIS_WLAN_BSSID_EX) - 1 + sizeof(NDIS_802_11_FIXED_IEs) + pAdapter->ScanTab.BssEntry[i].VarIELen + Padding);
 
-#if WIRELESS_EXT < 17
-                if ((BssLen + pBss->Length) < wrq->u.data.length)
-                BssLen += pBss->Length;
-                else
-                {
-                    pBssidList->NumberOfItems = i;
-                    break;
-                }
-#else
                 BssLen += pBss->Length;
-#endif
             }
 
-#if WIRELESS_EXT < 17
-            wrq->u.data.length = BssLen;
-#else
             if (BssLen > wrq->u.data.length)
             {
                 kfree(pBssidList);
@@ -4612,7 +4535,6 @@ INT RTMPQueryInformation(
             }
             else
                 wrq->u.data.length = BssLen;
-#endif
             Status = copy_to_user(wrq->u.data.pointer, pBssidList, BssLen);
             kfree(pBssidList);
             break;
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

