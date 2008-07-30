From: akpm@linux-foundation.org
Subject: - ath5k-kill-tasklets-on-shutdown.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:17:43 -0700
Message-ID: <200807301917.m6UJHhpS011238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754742AbYG3TZL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:25:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mcgrof@gmail.com, mickflemm@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ath5k: kill tasklets on shutdown
has been removed from the -mm tree.  Its filename was
     ath5k-kill-tasklets-on-shutdown.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ath5k: kill tasklets on shutdown
From: Jiri Slaby <jirislaby@gmail.com>

Don't forget to kill tasklets on stop to not panic if they fire after
freeing some structures.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath5k/base.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/net/wireless/ath5k/base.c~ath5k-kill-tasklets-on-shutdown drivers/net/wireless/ath5k/base.c
--- a/drivers/net/wireless/ath5k/base.c~ath5k-kill-tasklets-on-shutdown
+++ a/drivers/net/wireless/ath5k/base.c
@@ -2342,6 +2342,9 @@ ath5k_stop_hw(struct ath5k_softc *sc)
 	mutex_unlock(&sc->lock);
 
 	del_timer_sync(&sc->calib_tim);
+	tasklet_kill(&sc->rxtq);
+	tasklet_kill(&sc->txtq);
+	tasklet_kill(&sc->restq);
 
 	return ret;
 }
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
ath5k-mask-out-unneeded-interrupts.patch
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

