From: akpm@linux-foundation.org
Subject: - ath5k-mask-out-unneeded-interrupts.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:07:40 -0700
Message-ID: <200808042007.m74K7e6r027828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758747AbYHDUIK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:08:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mcgrof@gmail.com, me@bobcopeland.com, mickflemm@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ath5k: mask out unneeded interrupts
has been removed from the -mm tree.  Its filename was
     ath5k-mask-out-unneeded-interrupts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ath5k: mask out unneeded interrupts
From: Jiri Slaby <jirislaby@gmail.com>

Mask out previously demanded interrupt flags because we set new ones. 
Don't allow mixing them after switch from sta to ibss and vice versa.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
Cc: "Bob Copeland" <me@bobcopeland.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath5k/base.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/wireless/ath5k/base.c~ath5k-mask-out-unneeded-interrupts drivers/net/wireless/ath5k/base.c
--- a/drivers/net/wireless/ath5k/base.c~ath5k-mask-out-unneeded-interrupts
+++ a/drivers/net/wireless/ath5k/base.c
@@ -2170,6 +2170,7 @@ ath5k_beacon_config(struct ath5k_softc *
 
 	ath5k_hw_set_intr(ah, 0);
 	sc->bmisscount = 0;
+	sc->imask &= ~(AR5K_INT_BMISS | AR5K_INT_SWBA);
 
 	if (sc->opmode == IEEE80211_IF_TYPE_STA) {
 		sc->imask |= AR5K_INT_BMISS;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
ath5k-unify-resets.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch
char-ds1286-eliminate-busy-waiting.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

