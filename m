From: akpm@linux-foundation.org
Subject: + wireless-ipw2x00-print-ssid-via-%pe.patch added to -mm tree
Date: Thu, 28 Aug 2014 14:09:12 -0700
Message-ID: <53ff9a78.vA0BWlAa9lvXkHM0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:47163 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaH1VZf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Aug 2014 17:25:35 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so1042167pab.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2014 14:25:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org, joe@perches.com, johannes@sipsolutions.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: wireless: ipw2x00: print SSID via %*pE
has been added to the -mm tree.  Its filename is
     wireless-ipw2x00-print-ssid-via-%pe.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/wireless-ipw2x00-print-ssid-via-%pe.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/wireless-ipw2x00-print-ssid-via-%pe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: wireless: ipw2x00: print SSID via %*pE

Instead of custom approach this allows to print escaped strings via
recently added kernel extension: %*pE.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "John W . Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ipw2x00/ipw2100.c   |   22 -
 drivers/net/wireless/ipw2x00/ipw2200.c   |  270 ++++++---------------
 drivers/net/wireless/ipw2x00/libipw_rx.c |   65 ++---
 drivers/net/wireless/ipw2x00/libipw_wx.c |   16 -
 4 files changed, 126 insertions(+), 247 deletions(-)

diff -puN drivers/net/wireless/ipw2x00/ipw2100.c~wireless-ipw2x00-print-ssid-via-%pe drivers/net/wireless/ipw2x00/ipw2100.c
--- a/drivers/net/wireless/ipw2x00/ipw2100.c~wireless-ipw2x00-print-ssid-via-%pe
+++ a/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -2005,7 +2005,6 @@ static void isr_indicate_associated(stru
 	u32 chan;
 	char *txratename;
 	u8 bssid[ETH_ALEN];
-	DECLARE_SSID_BUF(ssid);
 
 	/*
 	 * TBD: BSSID is usually 00:00:00:00:00:00 here and not
@@ -2067,8 +2066,8 @@ static void isr_indicate_associated(stru
 		break;
 	}
 
-	IPW_DEBUG_INFO("%s: Associated with '%s' at %s, channel %d (BSSID=%pM)\n",
-		       priv->net_dev->name, print_ssid(ssid, essid, essid_len),
+	IPW_DEBUG_INFO("%s: Associated with '%*pE' at %s, channel %d (BSSID=%pM)\n",
+		       priv->net_dev->name, essid_len, essid,
 		       txratename, chan, bssid);
 
 	/* now we copy read ssid into dev */
@@ -2095,9 +2094,8 @@ static int ipw2100_set_essid(struct ipw2
 		.host_command_length = ssid_len
 	};
 	int err;
-	DECLARE_SSID_BUF(ssid);
 
-	IPW_DEBUG_HC("SSID: '%s'\n", print_ssid(ssid, essid, ssid_len));
+	IPW_DEBUG_HC("SSID: '%*pE'\n", ssid_len, essid);
 
 	if (ssid_len)
 		memcpy(cmd.host_command_parameters, essid, ssid_len);
@@ -2138,11 +2136,8 @@ static int ipw2100_set_essid(struct ipw2
 
 static void isr_indicate_association_lost(struct ipw2100_priv *priv, u32 status)
 {
-	DECLARE_SSID_BUF(ssid);
-
 	IPW_DEBUG(IPW_DL_NOTIF | IPW_DL_STATE | IPW_DL_ASSOC,
-		  "disassociated: '%s' %pM\n",
-		  print_ssid(ssid, priv->essid, priv->essid_len),
+		  "disassociated: '%*pE' %pM\n", priv->essid_len, priv->essid,
 		  priv->bssid);
 
 	priv->status &= ~(STATUS_ASSOCIATED | STATUS_ASSOCIATING);
@@ -6975,7 +6970,6 @@ static int ipw2100_wx_set_essid(struct n
 	char *essid = "";	/* ANY */
 	int length = 0;
 	int err = 0;
-	DECLARE_SSID_BUF(ssid);
 
 	mutex_lock(&priv->action_mutex);
 	if (!(priv->status & STATUS_INITIALIZED)) {
@@ -7005,8 +6999,7 @@ static int ipw2100_wx_set_essid(struct n
 		goto done;
 	}
 
-	IPW_DEBUG_WX("Setting ESSID: '%s' (%d)\n",
-		     print_ssid(ssid, essid, length), length);
+	IPW_DEBUG_WX("Setting ESSID: '%*pE' (%d)\n", length, essid, length);
 
 	priv->essid_len = length;
 	memcpy(priv->essid, essid, priv->essid_len);
@@ -7027,13 +7020,12 @@ static int ipw2100_wx_get_essid(struct n
 	 */
 
 	struct ipw2100_priv *priv = libipw_priv(dev);
-	DECLARE_SSID_BUF(ssid);
 
 	/* If we are associated, trying to associate, or have a statically
 	 * configured ESSID then return that; otherwise return ANY */
 	if (priv->config & CFG_STATIC_ESSID || priv->status & STATUS_ASSOCIATED) {
-		IPW_DEBUG_WX("Getting essid: '%s'\n",
-			     print_ssid(ssid, priv->essid, priv->essid_len));
+		IPW_DEBUG_WX("Getting essid: '%*pE'\n",
+			     priv->essid_len, priv->essid);
 		memcpy(extra, priv->essid, priv->essid_len);
 		wrqu->essid.length = priv->essid_len;
 		wrqu->essid.flags = 1;	/* active */
diff -puN drivers/net/wireless/ipw2x00/ipw2200.c~wireless-ipw2x00-print-ssid-via-%pe drivers/net/wireless/ipw2x00/ipw2200.c
--- a/drivers/net/wireless/ipw2x00/ipw2200.c~wireless-ipw2x00-print-ssid-via-%pe
+++ a/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -4496,7 +4496,6 @@ static void handle_scan_event(struct ipw
 static void ipw_rx_notification(struct ipw_priv *priv,
 				       struct ipw_rx_notification *notif)
 {
-	DECLARE_SSID_BUF(ssid);
 	u16 size = le16_to_cpu(notif->size);
 
 	IPW_DEBUG_NOTIF("type = %i (%d bytes)\n", notif->subtype, size);
@@ -4509,9 +4508,8 @@ static void ipw_rx_notification(struct i
 			case CMAS_ASSOCIATED:{
 					IPW_DEBUG(IPW_DL_NOTIF | IPW_DL_STATE |
 						  IPW_DL_ASSOC,
-						  "associated: '%s' %pM\n",
-						  print_ssid(ssid, priv->essid,
-							     priv->essid_len),
+						  "associated: '%*pE' %pM\n",
+						  priv->essid_len, priv->essid,
 						  priv->bssid);
 
 					switch (priv->ieee->iw_mode) {
@@ -4585,14 +4583,9 @@ static void ipw_rx_notification(struct i
 						IPW_DEBUG(IPW_DL_NOTIF |
 							  IPW_DL_STATE |
 							  IPW_DL_ASSOC,
-							  "deauthenticated: '%s' "
-							  "%pM"
-							  ": (0x%04X) - %s\n",
-							  print_ssid(ssid,
-								     priv->
-								     essid,
-								     priv->
-								     essid_len),
+							  "deauthenticated: '%*pE' %pM: (0x%04X) - %s\n",
+							  priv->essid_len,
+							  priv->essid,
 							  priv->bssid,
 							  le16_to_cpu(auth->status),
 							  ipw_get_status_code
@@ -4610,9 +4603,8 @@ static void ipw_rx_notification(struct i
 
 					IPW_DEBUG(IPW_DL_NOTIF | IPW_DL_STATE |
 						  IPW_DL_ASSOC,
-						  "authenticated: '%s' %pM\n",
-						  print_ssid(ssid, priv->essid,
-							     priv->essid_len),
+						  "authenticated: '%*pE' %pM\n",
+						  priv->essid_len, priv->essid,
 						  priv->bssid);
 					break;
 				}
@@ -4638,9 +4630,8 @@ static void ipw_rx_notification(struct i
 
 					IPW_DEBUG(IPW_DL_NOTIF | IPW_DL_STATE |
 						  IPW_DL_ASSOC,
-						  "disassociated: '%s' %pM\n",
-						  print_ssid(ssid, priv->essid,
-							     priv->essid_len),
+						  "disassociated: '%*pE' %pM\n",
+						  priv->essid_len, priv->essid,
 						  priv->bssid);
 
 					priv->status &=
@@ -4676,9 +4667,8 @@ static void ipw_rx_notification(struct i
 			switch (auth->state) {
 			case CMAS_AUTHENTICATED:
 				IPW_DEBUG(IPW_DL_NOTIF | IPW_DL_STATE,
-					  "authenticated: '%s' %pM\n",
-					  print_ssid(ssid, priv->essid,
-						     priv->essid_len),
+					  "authenticated: '%*pE' %pM\n",
+					  priv->essid_len, priv->essid,
 					  priv->bssid);
 				priv->status |= STATUS_AUTH;
 				break;
@@ -4695,9 +4685,8 @@ static void ipw_rx_notification(struct i
 				}
 				IPW_DEBUG(IPW_DL_NOTIF | IPW_DL_STATE |
 					  IPW_DL_ASSOC,
-					  "deauthenticated: '%s' %pM\n",
-					  print_ssid(ssid, priv->essid,
-						     priv->essid_len),
+					  "deauthenticated: '%*pE' %pM\n",
+					  priv->essid_len, priv->essid,
 					  priv->bssid);
 
 				priv->status &= ~(STATUS_ASSOCIATING |
@@ -5516,16 +5505,13 @@ static int ipw_find_adhoc_network(struct
 				  int roaming)
 {
 	struct ipw_supported_rates rates;
-	DECLARE_SSID_BUF(ssid);
 
 	/* Verify that this network's capability is compatible with the
 	 * current mode (AdHoc or Infrastructure) */
 	if ((priv->ieee->iw_mode == IW_MODE_ADHOC &&
 	     !(network->capability & WLAN_CAPABILITY_IBSS))) {
-		IPW_DEBUG_MERGE("Network '%s (%pM)' excluded due to "
-				"capability mismatch.\n",
-				print_ssid(ssid, network->ssid,
-					   network->ssid_len),
+		IPW_DEBUG_MERGE("Network '%*pE (%pM)' excluded due to capability mismatch.\n",
+				network->ssid_len, network->ssid,
 				network->bssid);
 		return 0;
 	}
@@ -5536,10 +5522,8 @@ static int ipw_find_adhoc_network(struct
 		if ((network->ssid_len != match->network->ssid_len) ||
 		    memcmp(network->ssid, match->network->ssid,
 			   network->ssid_len)) {
-			IPW_DEBUG_MERGE("Network '%s (%pM)' excluded "
-					"because of non-network ESSID.\n",
-					print_ssid(ssid, network->ssid,
-						   network->ssid_len),
+			IPW_DEBUG_MERGE("Network '%*pE (%pM)' excluded because of non-network ESSID.\n",
+					network->ssid_len, network->ssid,
 					network->bssid);
 			return 0;
 		}
@@ -5550,17 +5534,10 @@ static int ipw_find_adhoc_network(struct
 		    ((network->ssid_len != priv->essid_len) ||
 		     memcmp(network->ssid, priv->essid,
 			    min(network->ssid_len, priv->essid_len)))) {
-			char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
-
-			strncpy(escaped,
-				print_ssid(ssid, network->ssid,
-					   network->ssid_len),
-				sizeof(escaped));
-			IPW_DEBUG_MERGE("Network '%s (%pM)' excluded "
-					"because of ESSID mismatch: '%s'.\n",
-					escaped, network->bssid,
-					print_ssid(ssid, priv->essid,
-						   priv->essid_len));
+			IPW_DEBUG_MERGE("Network '%*pE (%pM)' excluded because of ESSID mismatch: '%*pE'.\n",
+					network->ssid_len, network->ssid,
+					network->bssid, priv->essid_len,
+					priv->essid);
 			return 0;
 		}
 	}
@@ -5569,26 +5546,20 @@ static int ipw_find_adhoc_network(struct
 	 * testing everything else. */
 
 	if (network->time_stamp[0] < match->network->time_stamp[0]) {
-		IPW_DEBUG_MERGE("Network '%s excluded because newer than "
-				"current network.\n",
-				print_ssid(ssid, match->network->ssid,
-					   match->network->ssid_len));
+		IPW_DEBUG_MERGE("Network '%*pE excluded because newer than current network.\n",
+				match->network->ssid_len, match->network->ssid);
 		return 0;
 	} else if (network->time_stamp[1] < match->network->time_stamp[1]) {
-		IPW_DEBUG_MERGE("Network '%s excluded because newer than "
-				"current network.\n",
-				print_ssid(ssid, match->network->ssid,
-					   match->network->ssid_len));
+		IPW_DEBUG_MERGE("Network '%*pE excluded because newer than current network.\n",
+				match->network->ssid_len, match->network->ssid);
 		return 0;
 	}
 
 	/* Now go through and see if the requested network is valid... */
 	if (priv->ieee->scan_age != 0 &&
 	    time_after(jiffies, network->last_scanned + priv->ieee->scan_age)) {
-		IPW_DEBUG_MERGE("Network '%s (%pM)' excluded "
-				"because of age: %ums.\n",
-				print_ssid(ssid, network->ssid,
-					   network->ssid_len),
+		IPW_DEBUG_MERGE("Network '%*pE (%pM)' excluded because of age: %ums.\n",
+				network->ssid_len, network->ssid,
 				network->bssid,
 				jiffies_to_msecs(jiffies -
 						 network->last_scanned));
@@ -5597,10 +5568,8 @@ static int ipw_find_adhoc_network(struct
 
 	if ((priv->config & CFG_STATIC_CHANNEL) &&
 	    (network->channel != priv->channel)) {
-		IPW_DEBUG_MERGE("Network '%s (%pM)' excluded "
-				"because of channel mismatch: %d != %d.\n",
-				print_ssid(ssid, network->ssid,
-					   network->ssid_len),
+		IPW_DEBUG_MERGE("Network '%*pE (%pM)' excluded because of channel mismatch: %d != %d.\n",
+				network->ssid_len, network->ssid,
 				network->bssid,
 				network->channel, priv->channel);
 		return 0;
@@ -5609,10 +5578,8 @@ static int ipw_find_adhoc_network(struct
 	/* Verify privacy compatibility */
 	if (((priv->capability & CAP_PRIVACY_ON) ? 1 : 0) !=
 	    ((network->capability & WLAN_CAPABILITY_PRIVACY) ? 1 : 0)) {
-		IPW_DEBUG_MERGE("Network '%s (%pM)' excluded "
-				"because of privacy mismatch: %s != %s.\n",
-				print_ssid(ssid, network->ssid,
-					   network->ssid_len),
+		IPW_DEBUG_MERGE("Network '%*pE (%pM)' excluded because of privacy mismatch: %s != %s.\n",
+				network->ssid_len, network->ssid,
 				network->bssid,
 				priv->
 				capability & CAP_PRIVACY_ON ? "on" : "off",
@@ -5623,22 +5590,16 @@ static int ipw_find_adhoc_network(struct
 	}
 
 	if (ether_addr_equal(network->bssid, priv->bssid)) {
-		IPW_DEBUG_MERGE("Network '%s (%pM)' excluded "
-				"because of the same BSSID match: %pM"
-				".\n", print_ssid(ssid, network->ssid,
-						  network->ssid_len),
-				network->bssid,
-				priv->bssid);
+		IPW_DEBUG_MERGE("Network '%*pE (%pM)' excluded because of the same BSSID match: %pM.\n",
+				network->ssid_len, network->ssid,
+				network->bssid, priv->bssid);
 		return 0;
 	}
 
 	/* Filter out any incompatible freq / mode combinations */
 	if (!libipw_is_valid_mode(priv->ieee, network->mode)) {
-		IPW_DEBUG_MERGE("Network '%s (%pM)' excluded "
-				"because of invalid frequency/mode "
-				"combination.\n",
-				print_ssid(ssid, network->ssid,
-					   network->ssid_len),
+		IPW_DEBUG_MERGE("Network '%*pE (%pM)' excluded because of invalid frequency/mode combination.\n",
+				network->ssid_len, network->ssid,
 				network->bssid);
 		return 0;
 	}
@@ -5646,20 +5607,15 @@ static int ipw_find_adhoc_network(struct
 	/* Ensure that the rates supported by the driver are compatible with
 	 * this AP, including verification of basic rates (mandatory) */
 	if (!ipw_compatible_rates(priv, network, &rates)) {
-		IPW_DEBUG_MERGE("Network '%s (%pM)' excluded "
-				"because configured rate mask excludes "
-				"AP mandatory rate.\n",
-				print_ssid(ssid, network->ssid,
-					   network->ssid_len),
+		IPW_DEBUG_MERGE("Network '%*pE (%pM)' excluded because configured rate mask excludes AP mandatory rate.\n",
+				network->ssid_len, network->ssid,
 				network->bssid);
 		return 0;
 	}
 
 	if (rates.num_rates == 0) {
-		IPW_DEBUG_MERGE("Network '%s (%pM)' excluded "
-				"because of no compatible rates.\n",
-				print_ssid(ssid, network->ssid,
-					   network->ssid_len),
+		IPW_DEBUG_MERGE("Network '%*pE (%pM)' excluded because of no compatible rates.\n",
+				network->ssid_len, network->ssid,
 				network->bssid);
 		return 0;
 	}
@@ -5671,16 +5627,14 @@ static int ipw_find_adhoc_network(struct
 	/* Set up 'new' AP to this network */
 	ipw_copy_rates(&match->rates, &rates);
 	match->network = network;
-	IPW_DEBUG_MERGE("Network '%s (%pM)' is a viable match.\n",
-			print_ssid(ssid, network->ssid, network->ssid_len),
-			network->bssid);
+	IPW_DEBUG_MERGE("Network '%*pE (%pM)' is a viable match.\n",
+			network->ssid_len, network->ssid, network->bssid);
 
 	return 1;
 }
 
 static void ipw_merge_adhoc_network(struct work_struct *work)
 {
-	DECLARE_SSID_BUF(ssid);
 	struct ipw_priv *priv =
 		container_of(work, struct ipw_priv, merge_networks);
 	struct libipw_network *network = NULL;
@@ -5710,9 +5664,8 @@ static void ipw_merge_adhoc_network(stru
 
 		mutex_lock(&priv->mutex);
 		if ((priv->ieee->iw_mode == IW_MODE_ADHOC)) {
-			IPW_DEBUG_MERGE("remove network %s\n",
-					print_ssid(ssid, priv->essid,
-						   priv->essid_len));
+			IPW_DEBUG_MERGE("remove network %*pE\n",
+					priv->essid_len, priv->essid);
 			ipw_remove_current_network(priv);
 		}
 
@@ -5728,7 +5681,6 @@ static int ipw_best_network(struct ipw_p
 			    struct libipw_network *network, int roaming)
 {
 	struct ipw_supported_rates rates;
-	DECLARE_SSID_BUF(ssid);
 
 	/* Verify that this network's capability is compatible with the
 	 * current mode (AdHoc or Infrastructure) */
@@ -5736,10 +5688,8 @@ static int ipw_best_network(struct ipw_p
 	     !(network->capability & WLAN_CAPABILITY_ESS)) ||
 	    (priv->ieee->iw_mode == IW_MODE_ADHOC &&
 	     !(network->capability & WLAN_CAPABILITY_IBSS))) {
-		IPW_DEBUG_ASSOC("Network '%s (%pM)' excluded due to "
-				"capability mismatch.\n",
-				print_ssid(ssid, network->ssid,
-					   network->ssid_len),
+		IPW_DEBUG_ASSOC("Network '%*pE (%pM)' excluded due to capability mismatch.\n",
+				network->ssid_len, network->ssid,
 				network->bssid);
 		return 0;
 	}
@@ -5750,10 +5700,8 @@ static int ipw_best_network(struct ipw_p
 		if ((network->ssid_len != match->network->ssid_len) ||
 		    memcmp(network->ssid, match->network->ssid,
 			   network->ssid_len)) {
-			IPW_DEBUG_ASSOC("Network '%s (%pM)' excluded "
-					"because of non-network ESSID.\n",
-					print_ssid(ssid, network->ssid,
-						   network->ssid_len),
+			IPW_DEBUG_ASSOC("Network '%*pE (%pM)' excluded because of non-network ESSID.\n",
+					network->ssid_len, network->ssid,
 					network->bssid);
 			return 0;
 		}
@@ -5764,16 +5712,10 @@ static int ipw_best_network(struct ipw_p
 		    ((network->ssid_len != priv->essid_len) ||
 		     memcmp(network->ssid, priv->essid,
 			    min(network->ssid_len, priv->essid_len)))) {
-			char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
-			strncpy(escaped,
-				print_ssid(ssid, network->ssid,
-					   network->ssid_len),
-				sizeof(escaped));
-			IPW_DEBUG_ASSOC("Network '%s (%pM)' excluded "
-					"because of ESSID mismatch: '%s'.\n",
-					escaped, network->bssid,
-					print_ssid(ssid, priv->essid,
-						   priv->essid_len));
+			IPW_DEBUG_ASSOC("Network '%*pE (%pM)' excluded because of ESSID mismatch: '%*pE'.\n",
+					network->ssid_len, network->ssid,
+					network->bssid, priv->essid_len,
+					priv->essid);
 			return 0;
 		}
 	}
@@ -5781,16 +5723,10 @@ static int ipw_best_network(struct ipw_p
 	/* If the old network rate is better than this one, don't bother
 	 * testing everything else. */
 	if (match->network && match->network->stats.rssi > network->stats.rssi) {
-		char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
-		strncpy(escaped,
-			print_ssid(ssid, network->ssid, network->ssid_len),
-			sizeof(escaped));
-		IPW_DEBUG_ASSOC("Network '%s (%pM)' excluded because "
-				"'%s (%pM)' has a stronger signal.\n",
-				escaped, network->bssid,
-				print_ssid(ssid, match->network->ssid,
-					   match->network->ssid_len),
-				match->network->bssid);
+		IPW_DEBUG_ASSOC("Network '%*pE (%pM)' excluded because '%*pE (%pM)' has a stronger signal.\n",
+				network->ssid_len, network->ssid,
+				network->bssid, match->network->ssid_len,
+				match->network->ssid, match->network->bssid);
 		return 0;
 	}
 
@@ -5798,11 +5734,8 @@ static int ipw_best_network(struct ipw_p
 	 * last 3 seconds, do not try and associate again... */
 	if (network->last_associate &&
 	    time_after(network->last_associate + (HZ * 3UL), jiffies)) {
-		IPW_DEBUG_ASSOC("Network '%s (%pM)' excluded "
-				"because of storming (%ums since last "
-				"assoc attempt).\n",
-				print_ssid(ssid, network->ssid,
-					   network->ssid_len),
+		IPW_DEBUG_ASSOC("Network '%*pE (%pM)' excluded because of storming (%ums since last assoc attempt).\n",
+				network->ssid_len, network->ssid,
 				network->bssid,
 				jiffies_to_msecs(jiffies -
 						 network->last_associate));
@@ -5812,10 +5745,8 @@ static int ipw_best_network(struct ipw_p
 	/* Now go through and see if the requested network is valid... */
 	if (priv->ieee->scan_age != 0 &&
 	    time_after(jiffies, network->last_scanned + priv->ieee->scan_age)) {
-		IPW_DEBUG_ASSOC("Network '%s (%pM)' excluded "
-				"because of age: %ums.\n",
-				print_ssid(ssid, network->ssid,
-					   network->ssid_len),
+		IPW_DEBUG_ASSOC("Network '%*pE (%pM)' excluded because of age: %ums.\n",
+				network->ssid_len, network->ssid,
 				network->bssid,
 				jiffies_to_msecs(jiffies -
 						 network->last_scanned));
@@ -5824,10 +5755,8 @@ static int ipw_best_network(struct ipw_p
 
 	if ((priv->config & CFG_STATIC_CHANNEL) &&
 	    (network->channel != priv->channel)) {
-		IPW_DEBUG_ASSOC("Network '%s (%pM)' excluded "
-				"because of channel mismatch: %d != %d.\n",
-				print_ssid(ssid, network->ssid,
-					   network->ssid_len),
+		IPW_DEBUG_ASSOC("Network '%*pE (%pM)' excluded because of channel mismatch: %d != %d.\n",
+				network->ssid_len, network->ssid,
 				network->bssid,
 				network->channel, priv->channel);
 		return 0;
@@ -5836,10 +5765,8 @@ static int ipw_best_network(struct ipw_p
 	/* Verify privacy compatibility */
 	if (((priv->capability & CAP_PRIVACY_ON) ? 1 : 0) !=
 	    ((network->capability & WLAN_CAPABILITY_PRIVACY) ? 1 : 0)) {
-		IPW_DEBUG_ASSOC("Network '%s (%pM)' excluded "
-				"because of privacy mismatch: %s != %s.\n",
-				print_ssid(ssid, network->ssid,
-					   network->ssid_len),
+		IPW_DEBUG_ASSOC("Network '%*pE (%pM)' excluded because of privacy mismatch: %s != %s.\n",
+				network->ssid_len, network->ssid,
 				network->bssid,
 				priv->capability & CAP_PRIVACY_ON ? "on" :
 				"off",
@@ -5850,31 +5777,24 @@ static int ipw_best_network(struct ipw_p
 
 	if ((priv->config & CFG_STATIC_BSSID) &&
 	    !ether_addr_equal(network->bssid, priv->bssid)) {
-		IPW_DEBUG_ASSOC("Network '%s (%pM)' excluded "
-				"because of BSSID mismatch: %pM.\n",
-				print_ssid(ssid, network->ssid,
-					   network->ssid_len),
+		IPW_DEBUG_ASSOC("Network '%*pE (%pM)' excluded because of BSSID mismatch: %pM.\n",
+				network->ssid_len, network->ssid,
 				network->bssid, priv->bssid);
 		return 0;
 	}
 
 	/* Filter out any incompatible freq / mode combinations */
 	if (!libipw_is_valid_mode(priv->ieee, network->mode)) {
-		IPW_DEBUG_ASSOC("Network '%s (%pM)' excluded "
-				"because of invalid frequency/mode "
-				"combination.\n",
-				print_ssid(ssid, network->ssid,
-					   network->ssid_len),
+		IPW_DEBUG_ASSOC("Network '%*pE (%pM)' excluded because of invalid frequency/mode combination.\n",
+				network->ssid_len, network->ssid,
 				network->bssid);
 		return 0;
 	}
 
 	/* Filter out invalid channel in current GEO */
 	if (!libipw_is_valid_channel(priv->ieee, network->channel)) {
-		IPW_DEBUG_ASSOC("Network '%s (%pM)' excluded "
-				"because of invalid channel in current GEO\n",
-				print_ssid(ssid, network->ssid,
-					   network->ssid_len),
+		IPW_DEBUG_ASSOC("Network '%*pE (%pM)' excluded because of invalid channel in current GEO\n",
+				network->ssid_len, network->ssid,
 				network->bssid);
 		return 0;
 	}
@@ -5882,20 +5802,15 @@ static int ipw_best_network(struct ipw_p
 	/* Ensure that the rates supported by the driver are compatible with
 	 * this AP, including verification of basic rates (mandatory) */
 	if (!ipw_compatible_rates(priv, network, &rates)) {
-		IPW_DEBUG_ASSOC("Network '%s (%pM)' excluded "
-				"because configured rate mask excludes "
-				"AP mandatory rate.\n",
-				print_ssid(ssid, network->ssid,
-					   network->ssid_len),
+		IPW_DEBUG_ASSOC("Network '%*pE (%pM)' excluded because configured rate mask excludes AP mandatory rate.\n",
+				network->ssid_len, network->ssid,
 				network->bssid);
 		return 0;
 	}
 
 	if (rates.num_rates == 0) {
-		IPW_DEBUG_ASSOC("Network '%s (%pM)' excluded "
-				"because of no compatible rates.\n",
-				print_ssid(ssid, network->ssid,
-					   network->ssid_len),
+		IPW_DEBUG_ASSOC("Network '%*pE (%pM)' excluded because of no compatible rates.\n",
+				network->ssid_len, network->ssid,
 				network->bssid);
 		return 0;
 	}
@@ -5908,9 +5823,8 @@ static int ipw_best_network(struct ipw_p
 	ipw_copy_rates(&match->rates, &rates);
 	match->network = network;
 
-	IPW_DEBUG_ASSOC("Network '%s (%pM)' is a viable match.\n",
-			print_ssid(ssid, network->ssid, network->ssid_len),
-			network->bssid);
+	IPW_DEBUG_ASSOC("Network '%*pE (%pM)' is a viable match.\n",
+			network->ssid_len, network->ssid, network->bssid);
 
 	return 1;
 }
@@ -6152,7 +6066,6 @@ static void ipw_bg_adhoc_check(struct wo
 
 static void ipw_debug_config(struct ipw_priv *priv)
 {
-	DECLARE_SSID_BUF(ssid);
 	IPW_DEBUG_INFO("Scan completed, no valid APs matched "
 		       "[CFG 0x%08X]\n", priv->config);
 	if (priv->config & CFG_STATIC_CHANNEL)
@@ -6160,8 +6073,8 @@ static void ipw_debug_config(struct ipw_
 	else
 		IPW_DEBUG_INFO("Channel unlocked.\n");
 	if (priv->config & CFG_STATIC_ESSID)
-		IPW_DEBUG_INFO("ESSID locked to '%s'\n",
-			       print_ssid(ssid, priv->essid, priv->essid_len));
+		IPW_DEBUG_INFO("ESSID locked to '%*pE'\n",
+			       priv->essid_len, priv->essid);
 	else
 		IPW_DEBUG_INFO("ESSID unlocked.\n");
 	if (priv->config & CFG_STATIC_BSSID)
@@ -7385,7 +7298,6 @@ static int ipw_associate_network(struct
 				 struct ipw_supported_rates *rates, int roaming)
 {
 	int err;
-	DECLARE_SSID_BUF(ssid);
 
 	if (priv->config & CFG_FIXED_RATE)
 		ipw_set_fixed_rate(priv, network->mode);
@@ -7451,10 +7363,9 @@ static int ipw_associate_network(struct
 		priv->assoc_request.capability &=
 		    ~cpu_to_le16(WLAN_CAPABILITY_SHORT_SLOT_TIME);
 
-	IPW_DEBUG_ASSOC("%ssociation attempt: '%s', channel %d, "
-			"802.11%c [%d], %s[:%s], enc=%s%s%s%c%c\n",
+	IPW_DEBUG_ASSOC("%ssociation attempt: '%*pE', channel %d, 802.11%c [%d], %s[:%s], enc=%s%s%s%c%c\n",
 			roaming ? "Rea" : "A",
-			print_ssid(ssid, priv->essid, priv->essid_len),
+			priv->essid_len, priv->essid,
 			network->channel,
 			ipw_modes[priv->assoc_request.ieee_mode],
 			rates->num_rates,
@@ -7553,9 +7464,8 @@ static int ipw_associate_network(struct
 		return err;
 	}
 
-	IPW_DEBUG(IPW_DL_STATE, "associating: '%s' %pM\n",
-		  print_ssid(ssid, priv->essid, priv->essid_len),
-		  priv->bssid);
+	IPW_DEBUG(IPW_DL_STATE, "associating: '%*pE' %pM\n",
+		  priv->essid_len, priv->essid, priv->bssid);
 
 	return 0;
 }
@@ -7645,7 +7555,6 @@ static int ipw_associate(void *data)
 	struct ipw_supported_rates *rates;
 	struct list_head *element;
 	unsigned long flags;
-	DECLARE_SSID_BUF(ssid);
 
 	if (priv->ieee->iw_mode == IW_MODE_MONITOR) {
 		IPW_DEBUG_ASSOC("Not attempting association (monitor mode)\n");
@@ -7704,10 +7613,8 @@ static int ipw_associate(void *data)
 			/* If there are no more slots, expire the oldest */
 			list_del(&oldest->list);
 			target = oldest;
-			IPW_DEBUG_ASSOC("Expired '%s' (%pM) from "
-					"network list.\n",
-					print_ssid(ssid, target->ssid,
-						   target->ssid_len),
+			IPW_DEBUG_ASSOC("Expired '%*pE' (%pM) from network list.\n",
+					target->ssid_len, target->ssid,
 					target->bssid);
 			list_add_tail(&target->list,
 				      &priv->ieee->network_free_list);
@@ -9093,7 +9000,6 @@ static int ipw_wx_set_essid(struct net_d
 {
 	struct ipw_priv *priv = libipw_priv(dev);
         int length;
-	DECLARE_SSID_BUF(ssid);
 
         mutex_lock(&priv->mutex);
 
@@ -9118,8 +9024,7 @@ static int ipw_wx_set_essid(struct net_d
 		return 0;
 	}
 
-	IPW_DEBUG_WX("Setting ESSID: '%s' (%d)\n",
-		     print_ssid(ssid, extra, length), length);
+	IPW_DEBUG_WX("Setting ESSID: '%*pE' (%d)\n", length, extra, length);
 
 	priv->essid_len = length;
 	memcpy(priv->essid, extra, priv->essid_len);
@@ -9138,15 +9043,14 @@ static int ipw_wx_get_essid(struct net_d
 			    union iwreq_data *wrqu, char *extra)
 {
 	struct ipw_priv *priv = libipw_priv(dev);
-	DECLARE_SSID_BUF(ssid);
 
 	/* If we are associated, trying to associate, or have a statically
 	 * configured ESSID then return that; otherwise return ANY */
 	mutex_lock(&priv->mutex);
 	if (priv->config & CFG_STATIC_ESSID ||
 	    priv->status & (STATUS_ASSOCIATED | STATUS_ASSOCIATING)) {
-		IPW_DEBUG_WX("Getting essid: '%s'\n",
-			     print_ssid(ssid, priv->essid, priv->essid_len));
+		IPW_DEBUG_WX("Getting essid: '%*pE'\n",
+			     priv->essid_len, priv->essid);
 		memcpy(extra, priv->essid, priv->essid_len);
 		wrqu->essid.length = priv->essid_len;
 		wrqu->essid.flags = 1;	/* active */
diff -puN drivers/net/wireless/ipw2x00/libipw_rx.c~wireless-ipw2x00-print-ssid-via-%pe drivers/net/wireless/ipw2x00/libipw_rx.c
--- a/drivers/net/wireless/ipw2x00/libipw_rx.c~wireless-ipw2x00-print-ssid-via-%pe
+++ a/drivers/net/wireless/ipw2x00/libipw_rx.c
@@ -1120,7 +1120,6 @@ static int libipw_parse_info_param(struc
 				      *info_element, u16 length,
 				      struct libipw_network *network)
 {
-	DECLARE_SSID_BUF(ssid);
 	u8 i;
 #ifdef CONFIG_LIBIPW_DEBUG
 	char rates_str[64];
@@ -1151,10 +1150,9 @@ static int libipw_parse_info_param(struc
 				memset(network->ssid + network->ssid_len, 0,
 				       IW_ESSID_MAX_SIZE - network->ssid_len);
 
-			LIBIPW_DEBUG_MGMT("WLAN_EID_SSID: '%s' len=%d.\n",
-					     print_ssid(ssid, network->ssid,
-							network->ssid_len),
-					     network->ssid_len);
+			LIBIPW_DEBUG_MGMT("WLAN_EID_SSID: '%*pE' len=%d.\n",
+					  network->ssid_len, network->ssid,
+					  network->ssid_len);
 			break;
 
 		case WLAN_EID_SUPP_RATES:
@@ -1399,8 +1397,6 @@ static int libipw_network_init(struct li
 					 struct libipw_network *network,
 					 struct libipw_rx_stats *stats)
 {
-	DECLARE_SSID_BUF(ssid);
-
 	network->qos_data.active = 0;
 	network->qos_data.supported = 0;
 	network->qos_data.param_count = 0;
@@ -1447,11 +1443,9 @@ static int libipw_network_init(struct li
 	}
 
 	if (network->mode == 0) {
-		LIBIPW_DEBUG_SCAN("Filtered out '%s (%pM)' "
-				     "network.\n",
-				     print_ssid(ssid, network->ssid,
-						 network->ssid_len),
-				     network->bssid);
+		LIBIPW_DEBUG_SCAN("Filtered out '%*pE (%pM)' network.\n",
+				  network->ssid_len, network->ssid,
+				  network->bssid);
 		return 1;
 	}
 
@@ -1563,11 +1557,9 @@ static void libipw_process_probe_respons
 	struct libipw_info_element *info_element = beacon->info_element;
 #endif
 	unsigned long flags;
-	DECLARE_SSID_BUF(ssid);
 
-	LIBIPW_DEBUG_SCAN("'%s' (%pM"
-		     "): %c%c%c%c %c%c%c%c-%c%c%c%c %c%c%c%c\n",
-		     print_ssid(ssid, info_element->data, info_element->len),
+	LIBIPW_DEBUG_SCAN("'%*pE' (%pM): %c%c%c%c %c%c%c%c-%c%c%c%c %c%c%c%c\n",
+		     info_element->len, info_element->data,
 		     beacon->header.addr3,
 		     (beacon->capability & cpu_to_le16(1 << 0xf)) ? '1' : '0',
 		     (beacon->capability & cpu_to_le16(1 << 0xe)) ? '1' : '0',
@@ -1587,12 +1579,11 @@ static void libipw_process_probe_respons
 		     (beacon->capability & cpu_to_le16(1 << 0x0)) ? '1' : '0');
 
 	if (libipw_network_init(ieee, beacon, &network, stats)) {
-		LIBIPW_DEBUG_SCAN("Dropped '%s' (%pM) via %s.\n",
-				     print_ssid(ssid, info_element->data,
-						 info_element->len),
-				     beacon->header.addr3,
-				     is_beacon(beacon->header.frame_ctl) ?
-				     "BEACON" : "PROBE RESPONSE");
+		LIBIPW_DEBUG_SCAN("Dropped '%*pE' (%pM) via %s.\n",
+				  info_element->len, info_element->data,
+				  beacon->header.addr3,
+				  is_beacon(beacon->header.frame_ctl) ?
+				  "BEACON" : "PROBE RESPONSE");
 		return;
 	}
 
@@ -1624,11 +1615,9 @@ static void libipw_process_probe_respons
 			/* If there are no more slots, expire the oldest */
 			list_del(&oldest->list);
 			target = oldest;
-			LIBIPW_DEBUG_SCAN("Expired '%s' (%pM) from "
-					     "network list.\n",
-					     print_ssid(ssid, target->ssid,
-							 target->ssid_len),
-					     target->bssid);
+			LIBIPW_DEBUG_SCAN("Expired '%*pE' (%pM) from network list.\n",
+					  target->ssid_len, target->ssid,
+					  target->bssid);
 			libipw_network_reset(target);
 		} else {
 			/* Otherwise just pull from the free list */
@@ -1638,23 +1627,21 @@ static void libipw_process_probe_respons
 		}
 
 #ifdef CONFIG_LIBIPW_DEBUG
-		LIBIPW_DEBUG_SCAN("Adding '%s' (%pM) via %s.\n",
-				     print_ssid(ssid, network.ssid,
-						 network.ssid_len),
-				     network.bssid,
-				     is_beacon(beacon->header.frame_ctl) ?
-				     "BEACON" : "PROBE RESPONSE");
+		LIBIPW_DEBUG_SCAN("Adding '%*pE' (%pM) via %s.\n",
+				  network.ssid_len, network.ssid,
+				  network.bssid,
+				  is_beacon(beacon->header.frame_ctl) ?
+				  "BEACON" : "PROBE RESPONSE");
 #endif
 		memcpy(target, &network, sizeof(*target));
 		network.ibss_dfs = NULL;
 		list_add_tail(&target->list, &ieee->network_list);
 	} else {
-		LIBIPW_DEBUG_SCAN("Updating '%s' (%pM) via %s.\n",
-				     print_ssid(ssid, target->ssid,
-						 target->ssid_len),
-				     target->bssid,
-				     is_beacon(beacon->header.frame_ctl) ?
-				     "BEACON" : "PROBE RESPONSE");
+		LIBIPW_DEBUG_SCAN("Updating '%*pE' (%pM) via %s.\n",
+				  target->ssid_len, target->ssid,
+				  target->bssid,
+				  is_beacon(beacon->header.frame_ctl) ?
+				  "BEACON" : "PROBE RESPONSE");
 		update_network(target, &network);
 		network.ibss_dfs = NULL;
 	}
diff -puN drivers/net/wireless/ipw2x00/libipw_wx.c~wireless-ipw2x00-print-ssid-via-%pe drivers/net/wireless/ipw2x00/libipw_wx.c
--- a/drivers/net/wireless/ipw2x00/libipw_wx.c~wireless-ipw2x00-print-ssid-via-%pe
+++ a/drivers/net/wireless/ipw2x00/libipw_wx.c
@@ -272,7 +272,6 @@ int libipw_wx_get_scan(struct libipw_dev
 	char *ev = extra;
 	char *stop = ev + wrqu->data.length;
 	int i = 0;
-	DECLARE_SSID_BUF(ssid);
 
 	LIBIPW_DEBUG_WX("Getting scan\n");
 
@@ -290,12 +289,10 @@ int libipw_wx_get_scan(struct libipw_dev
 			ev = libipw_translate_scan(ieee, ev, stop, network,
 						      info);
 		else {
-			LIBIPW_DEBUG_SCAN("Not showing network '%s ("
-					     "%pM)' due to age (%ums).\n",
-					     print_ssid(ssid, network->ssid,
-							 network->ssid_len),
-					     network->bssid,
-					     elapsed_jiffies_msecs(
+			LIBIPW_DEBUG_SCAN("Not showing network '%*pE (%pM)' due to age (%ums).\n",
+					  network->ssid_len, network->ssid,
+					  network->bssid,
+					  elapsed_jiffies_msecs(
 					               network->last_scanned));
 		}
 	}
@@ -322,7 +319,6 @@ int libipw_wx_set_encode(struct libipw_d
 	int i, key, key_provided, len;
 	struct lib80211_crypt_data **crypt;
 	int host_crypto = ieee->host_encrypt || ieee->host_decrypt;
-	DECLARE_SSID_BUF(ssid);
 
 	LIBIPW_DEBUG_WX("SET_ENCODE\n");
 
@@ -417,8 +413,8 @@ int libipw_wx_set_encode(struct libipw_d
 		if (len > erq->length)
 			memset(sec.keys[key] + erq->length, 0,
 			       len - erq->length);
-		LIBIPW_DEBUG_WX("Setting key %d to '%s' (%d:%d bytes)\n",
-				   key, print_ssid(ssid, sec.keys[key], len),
+		LIBIPW_DEBUG_WX("Setting key %d to '%*pE' (%d:%d bytes)\n",
+				   key, len, sec.keys[key],
 				   erq->length, len);
 		sec.key_sizes[key] = len;
 		if (*crypt)
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-string_helpers-move-documentation-to-c-file.patch
lib-string_helpers-refactoring-the-test-suite.patch
lib-string_helpers-introduce-string_escape_mem.patch
lib-vsprintf-add-%pe-format-specifier.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
wireless-libertas-print-esaped-string-via-%pe.patch
wireless-ipw2x00-print-ssid-via-%pe.patch
wireless-hostap-proc-print-properly-escaped-ssid.patch
lib80211-remove-unused-print_ssid.patch
staging-wlan-ng-use-%pehp-to-print-sn.patch
staging-rtl8192e-use-%pen-to-escape-buffer.patch
staging-rtl8192u-use-%pen-to-escape-buffer.patch
linux-next.patch

