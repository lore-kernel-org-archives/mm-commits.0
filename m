From: akpm@linux-foundation.org
Subject: + ath5k-lock-beacons.patch added to -mm tree
Date: Thu, 21 Aug 2008 13:36:59 -0700
Message-ID: <200808212036.m7LKaxAq024678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751639AbYHUUhR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Aug 2008 16:37:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, linville@tuxdriver.com, mcgrof@gmail.com, mickflemm@gmail.com


The patch titled
     Ath5k: lock beacons
has been added to the -mm tree.  Its filename is
     ath5k-lock-beacons.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Ath5k: lock beacons
From: Jiri Slaby <jirislaby@gmail.com>

Beacons setup and config was racy with beacon send.  Ensure that ISR and
reset functions see consistent state of bbuf.

Use also dev_kfree_skb_any in ath5k_txbuf_free since we call it from
atomic now.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath5k/base.c |   15 ++++++++++++---
 drivers/net/wireless/ath5k/base.h |    1 +
 2 files changed, 13 insertions(+), 3 deletions(-)

diff -puN drivers/net/wireless/ath5k/base.c~ath5k-lock-beacons drivers/net/wireless/ath5k/base.c
--- a/drivers/net/wireless/ath5k/base.c~ath5k-lock-beacons
+++ a/drivers/net/wireless/ath5k/base.c
@@ -252,7 +252,7 @@ static inline void ath5k_txbuf_free(stru
 		return;
 	pci_unmap_single(sc->pdev, bf->skbaddr, bf->skb->len,
 			PCI_DMA_TODEVICE);
-	dev_kfree_skb(bf->skb);
+	dev_kfree_skb_any(bf->skb);
 	bf->skb = NULL;
 }
 
@@ -467,6 +467,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	mutex_init(&sc->lock);
 	spin_lock_init(&sc->rxbuflock);
 	spin_lock_init(&sc->txbuflock);
+	spin_lock_init(&sc->block);
 
 	/* Set private data */
 	pci_set_drvdata(pdev, hw);
@@ -2143,8 +2144,11 @@ ath5k_beacon_config(struct ath5k_softc *
 
 		sc->imask |= AR5K_INT_SWBA;
 
-		if (ath5k_hw_hasveol(ah))
+		if (ath5k_hw_hasveol(ah)) {
+			spin_lock(&sc->block);
 			ath5k_beacon_send(sc);
+			spin_unlock(&sc->block);
+		}
 	}
 	/* TODO else AP */
 
@@ -2344,7 +2348,9 @@ ath5k_intr(int irq, void *dev_id)
 						  TSF_TO_TU(tsf),
 						  (unsigned long long) tsf);
 				} else {
+					spin_lock(&sc->block);
 					ath5k_beacon_send(sc);
+					spin_unlock(&sc->block);
 				}
 			}
 			if (status & AR5K_INT_RXEOL) {
@@ -3010,6 +3016,7 @@ static int
 ath5k_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct ath5k_softc *sc = hw->priv;
+	unsigned long flags;
 	int ret;
 
 	ath5k_debug_dump_skb(sc, skb, "BC  ", 1);
@@ -3019,12 +3026,14 @@ ath5k_beacon_update(struct ieee80211_hw 
 		goto end;
 	}
 
+	spin_lock_irqsave(&sc->block, flags);
 	ath5k_txbuf_free(sc, sc->bbuf);
 	sc->bbuf->skb = skb;
 	ret = ath5k_beacon_setup(sc, sc->bbuf);
 	if (ret)
 		sc->bbuf->skb = NULL;
-	else {
+	spin_unlock_irqrestore(&sc->block, flags);
+	if (!ret) {
 		ath5k_beacon_config(sc);
 		mmiowb();
 	}
diff -puN drivers/net/wireless/ath5k/base.h~ath5k-lock-beacons drivers/net/wireless/ath5k/base.h
--- a/drivers/net/wireless/ath5k/base.h~ath5k-lock-beacons
+++ a/drivers/net/wireless/ath5k/base.h
@@ -172,6 +172,7 @@ struct ath5k_softc {
 	struct tasklet_struct	txtq;		/* tx intr tasklet */
 	struct ath5k_led	tx_led;		/* tx led */
 
+	spinlock_t		block;		/* protects beacon */
 	struct ath5k_buf	*bbuf;		/* beacon buffer */
 	unsigned int		bhalq,		/* SW q for outgoing beacons */
 				bmisscount,	/* missed beacon transmits */
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
e100-fix-iomap-read.patch
ath5k-unify-resets.patch
ath5k-lock-beacons.patch
ath5k-fix-bintval-setup.patch
mm-owner-fix-race-between-swap-and-exit-fix.patch
char-sx-remove-bogus-iomap.patch
viafb-viafbdevc-viafbdevh.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch
char-ds1286-eliminate-busy-waiting.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

