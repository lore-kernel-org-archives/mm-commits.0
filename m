From: akpm@linux-foundation.org
Subject: - ath5k-fix-bintval-setup.patch removed from -mm tree
Date: Thu, 28 Aug 2008 14:48:54 -0700
Message-ID: <200808282148.m7SLms8F016145@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753911AbYH1VtD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Aug 2008 17:49:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, linville@tuxdriver.com, mcgrof@gmail.com, mickflemm@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Ath5k: fix bintval setup
has been removed from the -mm tree.  Its filename was
     ath5k-fix-bintval-setup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Ath5k: fix bintval setup
From: Jiri Slaby <jirislaby@gmail.com>

bintval is set to the initial value at .config_interface which is too
late, since it overwrites previously set value from .config.  Move the
initialization to the .add_interface.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath5k/base.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/net/wireless/ath5k/base.c~ath5k-fix-bintval-setup drivers/net/wireless/ath5k/base.c
--- a/drivers/net/wireless/ath5k/base.c~ath5k-fix-bintval-setup
+++ a/drivers/net/wireless/ath5k/base.c
@@ -2711,6 +2711,11 @@ static int ath5k_add_interface(struct ie
 		ret = -EOPNOTSUPP;
 		goto end;
 	}
+
+	/* Set to a reasonable value. Note that this will
+	 * be set to mac80211's value at ath5k_config(). */
+	sc->bintval = 1000;
+
 	ret = 0;
 end:
 	mutex_unlock(&sc->lock);
@@ -2755,9 +2760,6 @@ ath5k_config_interface(struct ieee80211_
 	struct ath5k_hw *ah = sc->ah;
 	int ret;
 
-	/* Set to a reasonable value. Note that this will
-	 * be set to mac80211's value at ath5k_config(). */
-	sc->bintval = 1000;
 	mutex_lock(&sc->lock);
 	if (sc->vif != vif) {
 		ret = -EIO;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
mm-owner-fix-race-between-swap-and-exit-fix.patch
char-sx-remove-bogus-iomap.patch
serial-mpc52xx_uart-remove-code-associated-with-config_ppc_merge.patch
viafb-viafbdevc-viafbdevh.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch
char-ds1286-eliminate-busy-waiting.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
char-moxac-sparse-annotation.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

