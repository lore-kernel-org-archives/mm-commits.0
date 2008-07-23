From: akpm@linux-foundation.org
Subject: + ath5k-fix-beacon-update-deadlock.patch added to -mm tree
Date: Wed, 23 Jul 2008 12:25:59 -0700
Message-ID: <200807231926.m6NJPxJA007925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752649AbYGWT1b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 15:27:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, johannes@sipsolutions.net, linville@tuxdriver.com, mcgrof@gmail.com, me@bobcopeland.com, mickflemm@gmail.com


The patch titled
     ath5k: fix beacon-update deadlock
has been added to the -mm tree.  Its filename is
     ath5k-fix-beacon-update-deadlock.patch

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
Subject: ath5k: fix beacon-update deadlock
From: Jiri Slaby <jirislaby@gmail.com>

Commit 9d139c810a2aa17365cc548d0cd2a189d8433c65 introduced AA deadlock --
ath5k_config_interface(); holds sc->lock and it calls
ath5k_beacon_update(); which tries to grab the lock again.

Don't grab the lock in beacon update, since only caller is config iface
for now.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
Cc: "Bob Copeland" <me@bobcopeland.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath5k/base.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/net/wireless/ath5k/base.c~ath5k-fix-beacon-update-deadlock drivers/net/wireless/ath5k/base.c
--- a/drivers/net/wireless/ath5k/base.c~ath5k-fix-beacon-update-deadlock
+++ a/drivers/net/wireless/ath5k/base.c
@@ -3065,8 +3065,6 @@ ath5k_beacon_update(struct ieee80211_hw 
 
 	ath5k_debug_dump_skb(sc, skb, "BC  ", 1);
 
-	mutex_lock(&sc->lock);
-
 	if (sc->opmode != IEEE80211_IF_TYPE_IBSS) {
 		ret = -EIO;
 		goto end;
@@ -3081,9 +3079,7 @@ ath5k_beacon_update(struct ieee80211_hw 
 		ath5k_beacon_config(sc);
 		mmiowb();
 	}
-
 end:
-	mutex_unlock(&sc->lock);
 	return ret;
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
ath5k-fix-beacon-update-deadlock.patch
ath5k-mask-out-unneeded-interrupts.patch
ath5k-unify-resets.patch
mac80211-tx-use-dev_kfree_skb_any-for-beacon_get.patch
mac80211-return-correct-error-return-from-ieee80211_wep_init.patch
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
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch
drivers-misc-phantom-note-pci.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

