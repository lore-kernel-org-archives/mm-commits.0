From: akpm@linux-foundation.org
Subject: - wdev-ath5k-fix-lock-imbalance.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:23:39 -0800
Message-ID: <200802232023.m1NKNdjq013560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761518AbYBWU2l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:28:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mcgrof@gmail.com, mickflemm@gmail.com, mm-commits@vger.kernel.org


The patch titled
     WDEV: ath5k, fix lock imbalance
has been removed from the -mm tree.  Its filename was
     wdev-ath5k-fix-lock-imbalance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: WDEV: ath5k, fix lock imbalance
From: Jiri Slaby <jirislaby@gmail.com>

Omitted lock causes sparse warning
drivers/net/wireless/ath5k/base.c:1682:1: warning: context imbalance in 'ath5k_tasklet_rx' - different lock contexts for basic block

Add the lock to the guilty fail path.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath5k/base.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/wireless/ath5k/base.c~wdev-ath5k-fix-lock-imbalance drivers/net/wireless/ath5k/base.c
--- a/drivers/net/wireless/ath5k/base.c~wdev-ath5k-fix-lock-imbalance
+++ a/drivers/net/wireless/ath5k/base.c
@@ -1715,6 +1715,7 @@ ath5k_tasklet_rx(unsigned long data)
 			break;
 		else if (unlikely(ret)) {
 			ATH5K_ERR(sc, "error in processing rx descriptor\n");
+			spin_unlock(&sc->rxbuflock);
 			return;
 		}
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
git-net.patch
wdev-ath5k-typecheck-on-nondebug.patch
mxser-prepare-for-bkl-pushdown.patch
tty-bkl-pushdown-fix.patch
tty-bkl-pushdown-fix1.patch
mxser-convert-large-macros-to-functions.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
