From: akpm@linux-foundation.org
Subject: - ath5k-unify-resets.patch removed from -mm tree
Date: Tue, 26 Aug 2008 11:45:28 -0700
Message-ID: <200808261845.m7QIjSXn021406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757659AbYHZSq1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 14:46:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mcgrof@gmail.com, me@bobcopeland.com, mickflemm@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ath5k: unify resets
has been removed from the -mm tree.  Its filename was
     ath5k-unify-resets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ath5k: unify resets
From: Jiri Slaby <jirislaby@gmail.com>

There were 3 code copy and pastes of reset.  Unify the resets and place in
separate function.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
Cc: "Bob Copeland" <me@bobcopeland.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath5k/base.c |  124 +++++++++-------------------
 1 file changed, 42 insertions(+), 82 deletions(-)

diff -puN drivers/net/wireless/ath5k/base.c~ath5k-unify-resets drivers/net/wireless/ath5k/base.c
--- a/drivers/net/wireless/ath5k/base.c~ath5k-unify-resets
+++ a/drivers/net/wireless/ath5k/base.c
@@ -162,7 +162,8 @@ static struct pci_driver ath5k_pci_drive
  * Prototypes - MAC 802.11 stack related functions
  */
 static int ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
-static int ath5k_reset(struct ieee80211_hw *hw);
+static int ath5k_reset(struct ath5k_softc *sc, bool stop, bool change_channel);
+static int ath5k_reset_wake(struct ath5k_softc *sc);
 static int ath5k_start(struct ieee80211_hw *hw);
 static void ath5k_stop(struct ieee80211_hw *hw);
 static int ath5k_add_interface(struct ieee80211_hw *hw,
@@ -977,9 +978,6 @@ ath5k_getchannels(struct ieee80211_hw *h
 static int
 ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 {
-	struct ath5k_hw *ah = sc->ah;
-	int ret;
-
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "(%u MHz) -> (%u MHz)\n",
 		sc->curchan->center_freq, chan->center_freq);
 
@@ -995,41 +993,7 @@ ath5k_chan_set(struct ath5k_softc *sc, s
 		 * hardware at the new frequency, and then re-enable
 		 * the relevant bits of the h/w.
 		 */
-		ath5k_hw_set_intr(ah, 0);	/* disable interrupts */
-		ath5k_txq_cleanup(sc);		/* clear pending tx frames */
-		ath5k_rx_stop(sc);		/* turn off frame recv */
-		ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, true);
-		if (ret) {
-			ATH5K_ERR(sc, "%s: unable to reset channel "
-				"(%u Mhz)\n", __func__, chan->center_freq);
-			return ret;
-		}
-
-		ath5k_hw_set_txpower_limit(sc->ah, 0);
-
-		/*
-		 * Re-enable rx framework.
-		 */
-		ret = ath5k_rx_start(sc);
-		if (ret) {
-			ATH5K_ERR(sc, "%s: unable to restart recv logic\n",
-					__func__);
-			return ret;
-		}
-
-		/*
-		 * Change channels and update the h/w rate map
-		 * if we're switching; e.g. 11a to 11b/g.
-		 *
-		 * XXX needed?
-		 */
-/*		ath5k_chan_change(sc, chan); */
-
-		ath5k_beacon_config(sc);
-		/*
-		 * Re-enable interrupts.
-		 */
-		ath5k_hw_set_intr(ah, sc->imask);
+		return ath5k_reset(sc, true, true);
 	}
 
 	return 0;
@@ -2216,36 +2180,13 @@ ath5k_init(struct ath5k_softc *sc)
 	 */
 	sc->curchan = sc->hw->conf.channel;
 	sc->curband = &sc->sbands[sc->curchan->band];
-	ret = ath5k_hw_reset(sc->ah, sc->opmode, sc->curchan, false);
-	if (ret) {
-		ATH5K_ERR(sc, "unable to reset hardware: %d\n", ret);
-		goto done;
-	}
-	/*
-	 * This is needed only to setup initial state
-	 * but it's best done after a reset.
-	 */
-	ath5k_hw_set_txpower_limit(sc->ah, 0);
-
-	/*
-	 * Setup the hardware after reset: the key cache
-	 * is filled as needed and the receive engine is
-	 * set going.  Frame transmit is handled entirely
-	 * in the frame output path; there's nothing to do
-	 * here except setup the interrupt mask.
-	 */
-	ret = ath5k_rx_start(sc);
-	if (ret)
-		goto done;
-
-	/*
-	 * Enable interrupts.
-	 */
 	sc->imask = AR5K_INT_RX | AR5K_INT_TX | AR5K_INT_RXEOL |
 		AR5K_INT_RXORN | AR5K_INT_FATAL | AR5K_INT_GLOBAL |
 		AR5K_INT_MIB;
+	ret = ath5k_reset(sc, false, false);
+	if (ret)
+		goto done;
 
-	ath5k_hw_set_intr(sc->ah, sc->imask);
 	/* Set ack to be sent at low bit-rates */
 	ath5k_hw_set_ack_bitrate_high(sc->ah, false);
 
@@ -2445,7 +2386,7 @@ ath5k_tasklet_reset(unsigned long data)
 {
 	struct ath5k_softc *sc = (void *)data;
 
-	ath5k_reset(sc->hw);
+	ath5k_reset_wake(sc);
 }
 
 /*
@@ -2468,7 +2409,7 @@ ath5k_calibrate(unsigned long data)
 		 * to load new gain values.
 		 */
 		ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "calibration, resetting\n");
-		ath5k_reset(sc->hw);
+		ath5k_reset_wake(sc);
 	}
 	if (ath5k_hw_phy_calibrate(ah, sc->curchan))
 		ATH5K_ERR(sc, "calibration of channel %u failed\n",
@@ -2669,48 +2610,67 @@ ath5k_tx(struct ieee80211_hw *hw, struct
 }
 
 static int
-ath5k_reset(struct ieee80211_hw *hw)
+ath5k_reset(struct ath5k_softc *sc, bool stop, bool change_channel)
 {
-	struct ath5k_softc *sc = hw->priv;
 	struct ath5k_hw *ah = sc->ah;
 	int ret;
 
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "resetting\n");
 
-	ath5k_hw_set_intr(ah, 0);
-	ath5k_txq_cleanup(sc);
-	ath5k_rx_stop(sc);
-
+	if (stop) {
+		ath5k_hw_set_intr(ah, 0);
+		ath5k_txq_cleanup(sc);
+		ath5k_rx_stop(sc);
+	}
 	ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, true);
-	if (unlikely(ret)) {
+	if (ret) {
 		ATH5K_ERR(sc, "can't reset hardware (%d)\n", ret);
 		goto err;
 	}
+
+	/*
+	 * This is needed only to setup initial state
+	 * but it's best done after a reset.
+	 */
 	ath5k_hw_set_txpower_limit(sc->ah, 0);
 
 	ret = ath5k_rx_start(sc);
-	if (unlikely(ret)) {
+	if (ret) {
 		ATH5K_ERR(sc, "can't start recv logic\n");
 		goto err;
 	}
+
 	/*
-	 * We may be doing a reset in response to an ioctl
-	 * that changes the channel so update any state that
-	 * might change as a result.
+	 * Change channels and update the h/w rate map if we're switching;
+	 * e.g. 11a to 11b/g.
+	 *
+	 * We may be doing a reset in response to an ioctl that changes the
+	 * channel so update any state that might change as a result.
 	 *
 	 * XXX needed?
 	 */
 /*	ath5k_chan_change(sc, c); */
-	ath5k_beacon_config(sc);
-	/* intrs are started by ath5k_beacon_config */
 
-	ieee80211_wake_queues(hw);
+	ath5k_beacon_config(sc);
+	/* intrs are enabled by ath5k_beacon_config */
 
 	return 0;
 err:
 	return ret;
 }
 
+static int
+ath5k_reset_wake(struct ath5k_softc *sc)
+{
+	int ret;
+
+	ret = ath5k_reset(sc, true, true);
+	if (!ret)
+		ieee80211_wake_queues(sc->hw);
+
+	return ret;
+}
+
 static int ath5k_start(struct ieee80211_hw *hw)
 {
 	return ath5k_init(hw->priv);
@@ -2819,7 +2779,7 @@ ath5k_config_interface(struct ieee80211_
 
 	mutex_unlock(&sc->lock);
 
-	return ath5k_reset(hw);
+	return ath5k_reset_wake(sc);
 unlock:
 	mutex_unlock(&sc->lock);
 	return ret;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
e100-fix-iomap-read.patch
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

