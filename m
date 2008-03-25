From: akpm@linux-foundation.org
Subject: - wdev-ath5k-typecheck-on-nondebug.patch removed from -mm tree
Date: Mon, 24 Mar 2008 17:19:53 -0700
Message-ID: <200803250019.m2P0Jr82032720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753876AbYCYAUZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 20:20:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mcgrof@gmail.com, mickflemm@gmail.com, mm-commits@vger.kernel.org


The patch titled
     WDEV: ath5k, typecheck on nonDEBUG
has been removed from the -mm tree.  Its filename was
     wdev-ath5k-typecheck-on-nondebug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: WDEV: ath5k, typecheck on nonDEBUG
From: Jiri Slaby <jirislaby@gmail.com>

At least type check the ATH5K_TRACE paramter on !ATH5K_DEBUG configs.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Nick Kossifidis <mickflemm@gmail.com>
Acked-by: Luis R. Rodriguez <mcgrof@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath5k/debug.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/net/wireless/ath5k/debug.h~wdev-ath5k-typecheck-on-nondebug drivers/net/wireless/ath5k/debug.h
--- a/drivers/net/wireless/ath5k/debug.h~wdev-ath5k-typecheck-on-nondebug
+++ a/drivers/net/wireless/ath5k/debug.h
@@ -171,7 +171,9 @@ ath5k_debug_printtxbuf(struct ath5k_soft
 
 #else /* no debugging */
 
-#define ATH5K_TRACE(_sc) /* empty */
+#include <linux/compiler.h>
+
+#define ATH5K_TRACE(_sc) typecheck(struct ath5k_softc *, (_sc))
 
 static inline void __attribute__ ((format (printf, 3, 4)))
 ATH5K_DBG(struct ath5k_softc *sc, unsigned int m, const char *fmt, ...) {}
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-drm.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc-update.patch
git-net.patch
capabilities-implement-per-process-securebits-fix.patch
misc-phantom-add-compat-ioctl.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
misc-phantom-fix-poll.patch
misc-phantom-consistent-whitespace.patch
mxser-prepare-for-bkl-pushdown.patch
tty-bkl-pushdown-fix.patch
tty-bkl-pushdown-fix1.patch
char-moxa-remove-static-isa-support.patch
char-moxa-cleanup-module-param-passed-isa-init.patch
char-moxa-pci-io-space-fixup.patch
char-moxa-fix-tiocg-ssoftcar-param.patch
char-moxa-add-firmware-loading.patch
char-moxa-merge-c2xx-and-c320-firmware-loading.patch
char-moxa-remove-port-port.patch
char-moxa-remove-unused-port-entries.patch
char-moxa-centralize-board-readiness.patch
char-moxa-timer-cleanup.patch
char-moxa-ioctl-cleanup.patch
char-moxa-merge-2-poll-functions.patch
char-moxa-cleanup-rx-tx.patch
char-moxa-serialise-timer.patch
char-moxa-rework-open-close.patch
char-moxa-little-cleanup.patch
char-moxa-remove-useless-tty-functions.patch
char-moxa-introduce-moxa_is_320-macro.patch
char-moxa-notify-about-board-readiness.patch
char-moxa-update-credits.patch
char-moxa-add-firmware-loading-fix.patch
char-espc-fix-possible-double-unlock.patch
mxser-convert-large-macros-to-functions.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

