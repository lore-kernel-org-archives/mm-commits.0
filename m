From: akpm@osdl.org
Subject: - softmac-fix-unbalanced-mutex_lock-unlock-in-ieee80211softmac_wx_set_mlme.patch removed from -mm tree
Date: Wed, 06 Dec 2006 13:20:27 -0800
Message-ID: <200612062120.kB6LKRGW016307@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:42379 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937658AbWLFVV0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 16:21:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maxime@tralhalla.org, linville@tuxdriver.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     softmac: fix unbalanced mutex_lock/unlock in ieee80211softmac_wx_set_mlme
has been removed from the -mm tree.  Its filename was
     softmac-fix-unbalanced-mutex_lock-unlock-in-ieee80211softmac_wx_set_mlme.patch

This patch was dropped because underlying changes broke it. Resend, please?

------------------------------------------------------
Subject: softmac: fix unbalanced mutex_lock/unlock in ieee80211softmac_wx_set_mlme
From: Maxime Austruy <maxime@tralhalla.org>

Found a hang while playing with wpa_supplicant and a zd1211 usb adapter
using linux 2.6.19.  The problem is that ieee80211softmac_wx_set_mlme
forgets to release a mutex when mlme->cmd is IW_MLME_DEAUTH.  The fix below
allows me to kill wpa_supplicant and to restart it without having to reboot
the machine.  FWIW, it seems that the problem was introduced between
2.6.19-rc2 and 2.6.19-rc3 when this function was changed to use a mutex.

Signed-off-by: Maxime Austruy <maxime@tralhalla.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 net/ieee80211/softmac/ieee80211softmac_wx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN net/ieee80211/softmac/ieee80211softmac_wx.c~softmac-fix-unbalanced-mutex_lock-unlock-in-ieee80211softmac_wx_set_mlme net/ieee80211/softmac/ieee80211softmac_wx.c
--- a/net/ieee80211/softmac/ieee80211softmac_wx.c~softmac-fix-unbalanced-mutex_lock-unlock-in-ieee80211softmac_wx_set_mlme
+++ a/net/ieee80211/softmac/ieee80211softmac_wx.c
@@ -495,7 +495,8 @@ ieee80211softmac_wx_set_mlme(struct net_
 			printk(KERN_DEBUG PFX "wx_set_mlme: we should know the net here...\n");
 			goto out;
 		}
-		return ieee80211softmac_deauth_req(mac, net, reason);
+		err =  ieee80211softmac_deauth_req(mac, net, reason);
+		goto out;
 	case IW_MLME_DISASSOC:
 		ieee80211softmac_send_disassoc_req(mac, reason);
 		mac->associnfo.associated = 0;
_

Patches currently in -mm which might be from maxime@tralhalla.org are

softmac-fix-unbalanced-mutex_lock-unlock-in-ieee80211softmac_wx_set_mlme.patch

