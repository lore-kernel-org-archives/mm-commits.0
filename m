From: akpm@linux-foundation.org
Subject: + drivers-net-rename-random32-to-prandom_u32.patch added to -mm tree
Date: Tue, 05 Mar 2013 17:02:19 -0800
Message-ID: <20130306010220.03CA65A41EB@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:49896 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab3CFBCV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 20:02:21 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so811211yhz.5
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 17:02:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, arend@broadcom.com, brudley@broadcom.com, bzhao@marvell.com, davem@davemloft.net, frankyl@broadcom.com, jpr@f6fbb.org, mchan@broadcom.com, meuleman@broadcom.com, t.sailer@alumni.ethz.ch


The patch titled
     Subject: drivers/net: rename random32() to prandom_u32()
has been added to the -mm tree.  Its filename is
     drivers-net-rename-random32-to-prandom_u32.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: drivers/net: rename random32() to prandom_u32()

Use preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Thomas Sailer <t.sailer@alumni.ethz.ch>
Acked-by: Bing Zhao <bzhao@marvell.com> [mwifiex]
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michael Chan <mchan@broadcom.com>
Cc: Thomas Sailer <t.sailer@alumni.ethz.ch>
Cc: Jean-Paul Roubelat <jpr@f6fbb.org>
Cc: Bing Zhao <bzhao@marvell.com>
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Arend van Spriel <arend@broadcom.com>
Cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Cc: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/broadcom/cnic.c          |    4 ++--
 drivers/net/hamradio/baycom_epp.c             |    2 +-
 drivers/net/hamradio/hdlcdrv.c                |    2 +-
 drivers/net/hamradio/yam.c                    |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c |    2 +-
 drivers/net/wireless/mwifiex/cfg80211.c       |    4 ++--
 6 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/net/ethernet/broadcom/cnic.c~drivers-net-rename-random32-to-prandom_u32 drivers/net/ethernet/broadcom/cnic.c
--- a/drivers/net/ethernet/broadcom/cnic.c~drivers-net-rename-random32-to-prandom_u32
+++ a/drivers/net/ethernet/broadcom/cnic.c
@@ -4085,7 +4085,7 @@ static int cnic_cm_alloc_mem(struct cnic
 	if (!cp->csk_tbl)
 		return -ENOMEM;
 
-	port_id = random32();
+	port_id = prandom_u32();
 	port_id %= CNIC_LOCAL_PORT_RANGE;
 	if (cnic_init_id_tbl(&cp->csk_port_tbl, CNIC_LOCAL_PORT_RANGE,
 			     CNIC_LOCAL_PORT_MIN, port_id)) {
@@ -4145,7 +4145,7 @@ static int cnic_cm_init_bnx2_hw(struct c
 {
 	u32 seed;
 
-	seed = random32();
+	seed = prandom_u32();
 	cnic_ctx_wr(dev, 45, 0, seed);
 	return 0;
 }
diff -puN drivers/net/hamradio/baycom_epp.c~drivers-net-rename-random32-to-prandom_u32 drivers/net/hamradio/baycom_epp.c
--- a/drivers/net/hamradio/baycom_epp.c~drivers-net-rename-random32-to-prandom_u32
+++ a/drivers/net/hamradio/baycom_epp.c
@@ -449,7 +449,7 @@ static int transmit(struct baycom_state
 			if ((--bc->hdlctx.slotcnt) > 0)
 				return 0;
 			bc->hdlctx.slotcnt = bc->ch_params.slottime;
-			if ((random32() % 256) > bc->ch_params.ppersist)
+			if ((prandom_u32() % 256) > bc->ch_params.ppersist)
 				return 0;
 		}
 	}
diff -puN drivers/net/hamradio/hdlcdrv.c~drivers-net-rename-random32-to-prandom_u32 drivers/net/hamradio/hdlcdrv.c
--- a/drivers/net/hamradio/hdlcdrv.c~drivers-net-rename-random32-to-prandom_u32
+++ a/drivers/net/hamradio/hdlcdrv.c
@@ -389,7 +389,7 @@ void hdlcdrv_arbitrate(struct net_device
 	if ((--s->hdlctx.slotcnt) > 0)
 		return;
 	s->hdlctx.slotcnt = s->ch_params.slottime;
-	if ((random32() % 256) > s->ch_params.ppersist)
+	if ((prandom_u32() % 256) > s->ch_params.ppersist)
 		return;
 	start_tx(dev, s);
 }
diff -puN drivers/net/hamradio/yam.c~drivers-net-rename-random32-to-prandom_u32 drivers/net/hamradio/yam.c
--- a/drivers/net/hamradio/yam.c~drivers-net-rename-random32-to-prandom_u32
+++ a/drivers/net/hamradio/yam.c
@@ -638,7 +638,7 @@ static void yam_arbitrate(struct net_dev
 	yp->slotcnt = yp->slot / 10;
 
 	/* is random > persist ? */
-	if ((random32() % 256) > yp->pers)
+	if ((prandom_u32() % 256) > yp->pers)
 		return;
 
 	yam_start_tx(dev, yp);
diff -puN drivers/net/wireless/brcm80211/brcmfmac/p2p.c~drivers-net-rename-random32-to-prandom_u32 drivers/net/wireless/brcm80211/brcmfmac/p2p.c
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c~drivers-net-rename-random32-to-prandom_u32
+++ a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -1118,7 +1118,7 @@ static void brcmf_p2p_afx_handler(struct
 	if (afx_hdl->is_listen && afx_hdl->my_listen_chan)
 		/* 100ms ~ 300ms */
 		err = brcmf_p2p_discover_listen(p2p, afx_hdl->my_listen_chan,
-						100 * (1 + (random32() % 3)));
+					100 * (1 + (prandom_u32() % 3)));
 	else
 		err = brcmf_p2p_act_frm_search(p2p, afx_hdl->peer_listen_chan);
 
diff -puN drivers/net/wireless/mwifiex/cfg80211.c~drivers-net-rename-random32-to-prandom_u32 drivers/net/wireless/mwifiex/cfg80211.c
--- a/drivers/net/wireless/mwifiex/cfg80211.c~drivers-net-rename-random32-to-prandom_u32
+++ a/drivers/net/wireless/mwifiex/cfg80211.c
@@ -216,7 +216,7 @@ mwifiex_cfg80211_mgmt_tx(struct wiphy *w
 	mwifiex_form_mgmt_frame(skb, buf, len);
 	mwifiex_queue_tx_pkt(priv, skb);
 
-	*cookie = random32() | 1;
+	*cookie = prandom_u32() | 1;
 	cfg80211_mgmt_tx_status(wdev, *cookie, buf, len, true, GFP_ATOMIC);
 
 	wiphy_dbg(wiphy, "info: management frame transmitted\n");
@@ -271,7 +271,7 @@ mwifiex_cfg80211_remain_on_channel(struc
 					 duration);
 
 	if (!ret) {
-		*cookie = random32() | 1;
+		*cookie = prandom_u32() | 1;
 		priv->roc_cfg.cookie = *cookie;
 		priv->roc_cfg.chan = *chan;
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
raid6test-use-prandom_bytes.patch
uuid-use-prandom_bytes.patch
x86-pageattr-test-remove-srandom32-call.patch
x86-rename-random32-to-prandom_u32.patch
lib-rename-random32-to-prandom_u32.patch
mm-rename-random32-to-prandom_u32.patch
kernel-rename-random32-to-prandom_u32.patch
drbd-rename-random32-to-prandom_u32.patch
infiniband-rename-random32-to-prandom_u32.patch
mmc-rename-random32-to-prandom_u32.patch
video-uvesafb-rename-random32-to-prandom_u32.patch
xfs-rename-random32-to-prandom_u32.patch
uwb-rename-random32-to-prandom_u32.patch
lguest-rename-random32-to-prandom_u32.patch
scsi-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32.patch
net-sunrpc-rename-random32-to-prandom_u32.patch
net-sched-rename-random32-to-prandom_u32.patch
net-netfilter-rename-random32-to-prandom_u32.patch
net-core-rename-random32-to-prandom_u32.patch
net-core-remove-duplicate-statements-by-do-while-loop.patch
net-rename-random32-to-prandom.patch
remove-unused-random32-and-srandom32.patch

