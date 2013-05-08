From: akpm@linux-foundation.org
Subject: [merged] drivers-net-rename-random32-to-prandom_u32.patch removed from -mm tree
Date: Wed, 08 May 2013 11:34:37 -0700
Message-ID: <20130508183437.9EB355A415E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:52707 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758097Ab3EHSej (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 14:34:39 -0400
Received: by mail-gg0-f201.google.com with SMTP id k25so207864ggl.2
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 11:34:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, arend@broadcom.com, brudley@broadcom.com, bzhao@marvell.com, davem@davemloft.net, frankyl@broadcom.com, jpr@f6fbb.org, mchan@broadcom.com, meuleman@broadcom.com, t.sailer@alumni.ethz.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/net: rename random32() to prandom_u32()
has been removed from the -mm tree.  Its filename was
     drivers-net-rename-random32-to-prandom_u32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: drivers/net: rename random32() to prandom_u32()

Use preferable function name which implies using a pseudo-random
number generator.

[akpm@linux-foundation.org: convert team_mode_random.c]
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
 drivers/net/team/team_mode_random.c           |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c |    2 +-
 drivers/net/wireless/mwifiex/cfg80211.c       |    4 ++--
 7 files changed, 9 insertions(+), 9 deletions(-)

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
diff -puN drivers/net/team/team_mode_random.c~drivers-net-rename-random32-to-prandom_u32 drivers/net/team/team_mode_random.c
--- a/drivers/net/team/team_mode_random.c~drivers-net-rename-random32-to-prandom_u32
+++ a/drivers/net/team/team_mode_random.c
@@ -18,7 +18,7 @@
 
 static u32 random_N(unsigned int N)
 {
-	return reciprocal_divide(random32(), N);
+	return reciprocal_divide(prandom_u32(), N);
 }
 
 static bool rnd_transmit(struct team *team, struct sk_buff *skb)
diff -puN drivers/net/wireless/brcm80211/brcmfmac/p2p.c~drivers-net-rename-random32-to-prandom_u32 drivers/net/wireless/brcm80211/brcmfmac/p2p.c
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c~drivers-net-rename-random32-to-prandom_u32
+++ a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -1117,7 +1117,7 @@ static void brcmf_p2p_afx_handler(struct
 	if (afx_hdl->is_listen && afx_hdl->my_listen_chan)
 		/* 100ms ~ 300ms */
 		err = brcmf_p2p_discover_listen(p2p, afx_hdl->my_listen_chan,
-						100 * (1 + (random32() % 3)));
+						100 * (1 + prandom_u32() % 3));
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

origin.patch
linux-next.patch

