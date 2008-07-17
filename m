From: akpm@linux-foundation.org
Subject: + ath5k-flush-work.patch added to -mm tree
Date: Wed, 16 Jul 2008 17:11:50 -0700
Message-ID: <200807170011.m6H0BpHf020940@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752615AbYGQALy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 20:11:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, mcgrof@gmail.com, mickflemm@gmail.com


The patch titled
     ath5k: flush work
has been added to the -mm tree.  Its filename is
     ath5k-flush-work.patch

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
Subject: ath5k: flush work
From: Jiri Slaby <jirislaby@gmail.com>

Make sure that the irq is not in progress after stop. This means
two things:
- ensure the intr setting register is set by flushing posted values
- call synchronize_irq() after that

Also flush stop tx write, inform callers of the tx stop about still
pending transfers (unsuccessful stop) and finally don't wait another
3ms in ath5k_rx_stop, since ath5k_hw_stop_rx_dma ensures transfer to
be finished.

Make sure all writes will be ordered in respect to locks by mmiowb().

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath5k/base.c |   13 +++++++++++--
 drivers/net/wireless/ath5k/hw.c   |    4 ++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff -puN drivers/net/wireless/ath5k/base.c~ath5k-flush-work drivers/net/wireless/ath5k/base.c
--- a/drivers/net/wireless/ath5k/base.c~ath5k-flush-work
+++ a/drivers/net/wireless/ath5k/base.c
@@ -43,7 +43,9 @@
 #include <linux/version.h>
 #include <linux/module.h>
 #include <linux/delay.h>
+#include <linux/hardirq.h>
 #include <linux/if.h>
+#include <linux/io.h>
 #include <linux/netdevice.h>
 #include <linux/cache.h>
 #include <linux/pci.h>
@@ -1249,6 +1251,7 @@ ath5k_txbuf_setup(struct ath5k_softc *sc
 
 	txq->link = &ds->ds_link;
 	ath5k_hw_tx_start(ah, txq->qnum);
+	mmiowb();
 	spin_unlock_bh(&txq->lock);
 
 	return 0;
@@ -1583,7 +1586,6 @@ ath5k_rx_stop(struct ath5k_softc *sc)
 	ath5k_hw_stop_pcu_recv(ah);	/* disable PCU */
 	ath5k_hw_set_rx_filter(ah, 0);	/* clear recv filter */
 	ath5k_hw_stop_rx_dma(ah);	/* disable DMA engine */
-	mdelay(3);			/* 3ms is long enough for 1 frame */
 
 	ath5k_debug_printrxbuffs(sc, ah);
 
@@ -2258,6 +2260,7 @@ ath5k_init(struct ath5k_softc *sc)
 
 	ret = 0;
 done:
+	mmiowb();
 	mutex_unlock(&sc->lock);
 	return ret;
 }
@@ -2290,6 +2293,7 @@ ath5k_stop_locked(struct ath5k_softc *sc
 	if (!test_bit(ATH_STAT_INVALID, sc->status)) {
 		ath5k_led_off(sc);
 		ath5k_hw_set_intr(ah, 0);
+		synchronize_irq(sc->pdev->irq);
 	}
 	ath5k_txq_cleanup(sc);
 	if (!test_bit(ATH_STAT_INVALID, sc->status)) {
@@ -2339,6 +2343,7 @@ ath5k_stop_hw(struct ath5k_softc *sc)
 		}
 	}
 	ath5k_txbuf_free(sc, sc->bbuf);
+	mmiowb();
 	mutex_unlock(&sc->lock);
 
 	del_timer_sync(&sc->calib_tim);
@@ -2804,6 +2809,7 @@ ath5k_config_interface(struct ieee80211_
 		/* XXX: assoc id is set to 0 for now, mac80211 doesn't have
 		 * a clean way of letting us retrieve this yet. */
 		ath5k_hw_set_associd(ah, ah->ah_bssid, 0);
+		mmiowb();
 	}
 
 	if (conf->changed & IEEE80211_IFCC_BEACON &&
@@ -2992,6 +2998,7 @@ ath5k_set_key(struct ieee80211_hw *hw, e
 	}
 
 unlock:
+	mmiowb();
 	mutex_unlock(&sc->lock);
 	return ret;
 }
@@ -3065,8 +3072,10 @@ ath5k_beacon_update(struct ieee80211_hw 
 	ret = ath5k_beacon_setup(sc, sc->bbuf);
 	if (ret)
 		sc->bbuf->skb = NULL;
-	else
+	else {
 		ath5k_beacon_config(sc);
+		mmiowb();
+	}
 
 end:
 	mutex_unlock(&sc->lock);
diff -puN drivers/net/wireless/ath5k/hw.c~ath5k-flush-work drivers/net/wireless/ath5k/hw.c
--- a/drivers/net/wireless/ath5k/hw.c~ath5k-flush-work
+++ a/drivers/net/wireless/ath5k/hw.c
@@ -1440,6 +1440,7 @@ int ath5k_hw_stop_tx_dma(struct ath5k_hw
 
 		/* Stop queue */
 		ath5k_hw_reg_write(ah, tx_queue, AR5K_CR);
+		ath5k_hw_reg_read(ah, AR5K_CR);
 	} else {
 		/*
 		 * Schedule TX disable and wait until queue is empty
@@ -1456,6 +1457,8 @@ int ath5k_hw_stop_tx_dma(struct ath5k_hw
 
 		/* Clear register */
 		ath5k_hw_reg_write(ah, 0, AR5K_QCU_TXD);
+		if (pending)
+			return -EBUSY;
 	}
 
 	/* TODO: Check for success else return error */
@@ -1716,6 +1719,7 @@ enum ath5k_int ath5k_hw_set_intr(struct 
 
 	/* ..re-enable interrupts */
 	ath5k_hw_reg_write(ah, AR5K_IER_ENABLE, AR5K_IER);
+	ath5k_hw_reg_read(ah, AR5K_IER);
 
 	return old_mask;
 }
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
ath5k-fix-memory-corruption.patch
ath5k-kill-tasklets-on-shutdown.patch
ath5k-flush-work.patch
ath5k-fix-dma-operation.patch
ath5k-suspend-resume-fixes.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
serial-z85c30-avoid-a-hang-at-console-switch-over.patch
serial-dz11-avoid-a-hang-at-console-switch-over.patch
vt-hold-console_sem-across-sysfs-operations.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
dsp56k-bkl-pushdown.patch
char-mxser-ioctl-cleanup.patch
char-mxser-globals-cleanup.patch
char-mxser-update-documentation.patch
char-mxser-prints-cleanup.patch
char-mxser-remove-predefined-isa-support.patch
char-mxser-various-cleanups.patch
char-isicom-enable-disable-pci-device.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
stallion-fix-the-istallion-drivers-putchar-and-break_ctl-ops.patch
drivers-misc-phantom-note-pci.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

