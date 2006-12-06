From: akpm@osdl.org
Subject: - softmac-fixed-handling-of-deassociation-from-ap.patch removed from -mm tree
Date: Wed, 06 Dec 2006 13:22:24 -0800
Message-ID: <200612062122.kB6LMOhl016459@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:42511 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937648AbWLFVWs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 16:22:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kune@deine-taler.de, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     softmac: Fixed handling of deassociation from AP
has been removed from the -mm tree.  Its filename was
     softmac-fixed-handling-of-deassociation-from-ap.patch

This patch was dropped because underlying changes broke it. Resend, please?

------------------------------------------------------
Subject: softmac: Fixed handling of deassociation from AP
From: Ulrich Kunitz <kune@deine-taler.de>

In 2.6.19 a deauthentication from the AP doesn't start a reassociation by
the softmac code.  It appears that mac->associnfo.associating must be set
and the ieee80211softmac_assoc_work function must be scheduled.  This patch
fixes that.

Signed-off-by: Ulrich Kunitz <kune@deine-taler.de>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 net/ieee80211/softmac/ieee80211softmac_assoc.c |   14 ++++++++++++--
 net/ieee80211/softmac/ieee80211softmac_auth.c  |    2 ++
 net/ieee80211/softmac/ieee80211softmac_priv.h  |    2 ++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff -puN net/ieee80211/softmac/ieee80211softmac_assoc.c~softmac-fixed-handling-of-deassociation-from-ap net/ieee80211/softmac/ieee80211softmac_assoc.c
--- a/net/ieee80211/softmac/ieee80211softmac_assoc.c~softmac-fixed-handling-of-deassociation-from-ap
+++ a/net/ieee80211/softmac/ieee80211softmac_assoc.c
@@ -427,6 +427,17 @@ ieee80211softmac_handle_assoc_response(s
 	return 0;
 }
 
+void
+ieee80211softmac_try_reassoc(struct ieee80211softmac_device *mac)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mac->lock, flags);
+	mac->associnfo.associating = 1;
+	schedule_work(&mac->associnfo.work);
+	spin_unlock_irqrestore(&mac->lock, flags);
+}
+
 int
 ieee80211softmac_handle_disassoc(struct net_device * dev,
 				 struct ieee80211_disassoc *disassoc)
@@ -445,8 +456,7 @@ ieee80211softmac_handle_disassoc(struct 
 	dprintk(KERN_INFO PFX "got disassoc frame\n");
 	ieee80211softmac_disassoc(mac);
 
-	/* try to reassociate */
-	schedule_work(&mac->associnfo.work);
+	ieee80211softmac_try_reassoc(mac);
 
 	return 0;
 }
diff -puN net/ieee80211/softmac/ieee80211softmac_auth.c~softmac-fixed-handling-of-deassociation-from-ap net/ieee80211/softmac/ieee80211softmac_auth.c
--- a/net/ieee80211/softmac/ieee80211softmac_auth.c~softmac-fixed-handling-of-deassociation-from-ap
+++ a/net/ieee80211/softmac/ieee80211softmac_auth.c
@@ -334,6 +334,8 @@ ieee80211softmac_deauth_from_net(struct 
 	/* can't transmit data right now... */
 	netif_carrier_off(mac->dev);
 	spin_unlock_irqrestore(&mac->lock, flags);
+
+	ieee80211softmac_try_reassoc(mac);
 }
 
 /* 
diff -puN net/ieee80211/softmac/ieee80211softmac_priv.h~softmac-fixed-handling-of-deassociation-from-ap net/ieee80211/softmac/ieee80211softmac_priv.h
--- a/net/ieee80211/softmac/ieee80211softmac_priv.h~softmac-fixed-handling-of-deassociation-from-ap
+++ a/net/ieee80211/softmac/ieee80211softmac_priv.h
@@ -238,4 +238,6 @@ void ieee80211softmac_call_events_locked
 int ieee80211softmac_notify_internal(struct ieee80211softmac_device *mac,
 	int event, void *event_context, notify_function_ptr fun, void *context, gfp_t gfp_mask);
 
+void ieee80211softmac_try_reassoc(struct ieee80211softmac_device *mac);
+
 #endif /* IEEE80211SOFTMAC_PRIV_H_ */
_

Patches currently in -mm which might be from kune@deine-taler.de are

origin.patch
softmac-fixed-handling-of-deassociation-from-ap.patch

