From: akpm@linux-foundation.org
Subject: - char-ip2-fix-sparse-warnings.patch removed from -mm tree
Date: Fri, 04 Apr 2008 12:00:02 -0700
Message-ID: <200804041900.m34J02v1004242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752185AbYDDTAF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2008 15:00:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: ip2, fix sparse warnings
has been removed from the -mm tree.  Its filename was
     char-ip2-fix-sparse-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: ip2, fix sparse warnings
From: Jiri Slaby <jirislaby@gmail.com>

Unlock two grabbed locks on some paths.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ip2/i2lib.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/char/ip2/i2lib.c~char-ip2-fix-sparse-warnings drivers/char/ip2/i2lib.c
--- a/drivers/char/ip2/i2lib.c~char-ip2-fix-sparse-warnings
+++ a/drivers/char/ip2/i2lib.c
@@ -644,12 +644,12 @@ i2QueueCommands(int type, i2ChanStrPtr p
 				// Normal Expected path - We still hold LOCK
 				break; /* from for()- Enough room: goto proceed */
 			}
-		}
-
-		ip2trace (CHANN, ITRC_QUEUE, 3, 1, totalsize );
+			ip2trace(CHANN, ITRC_QUEUE, 3, 1, totalsize);
+			WRITE_UNLOCK_IRQRESTORE(lock_var_p, flags);
+		} else
+			ip2trace(CHANN, ITRC_QUEUE, 3, 1, totalsize);
 
-		// Prepare to wait for buffers to empty
-		WRITE_UNLOCK_IRQRESTORE(lock_var_p,flags); 
+		/* Prepare to wait for buffers to empty */
 		serviceOutgoingFifo(pB);	// Dump what we got
 
 		if (timeout == 0) {
@@ -1830,6 +1830,8 @@ i2StripFifo(i2eBordStrPtr pB)
 		default: // Neither packet? should be impossible
 			ip2trace (ITRC_NO_PORT, ITRC_SFIFO, 5, 1,
 				PTYPE_OF(pB->i2eLeadoffWord) );
+			WRITE_UNLOCK_IRQRESTORE(&pB->read_fifo_spinlock,
+					bflags);
 
 			break;
 		}  // End of switch on type of packets
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
git-hid.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
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
char-moxa-centralize-board-readiness-warning-fix.patch
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
char-ip2-macros-cleanup.patch
char-rio-fix-cirrus-defines.patch
mxser-convert-large-macros-to-functions.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

