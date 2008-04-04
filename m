From: akpm@linux-foundation.org
Subject: - char-rio-fix-sparse-warnings.patch removed from -mm tree
Date: Fri, 04 Apr 2008 12:00:04 -0700
Message-ID: <200804041900.m34J04Oi004245@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57414 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754910AbYDDTAG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2008 15:00:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: rio, fix sparse warnings
has been removed from the -mm tree.  Its filename was
     char-rio-fix-sparse-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: rio, fix sparse warnings
From: Jiri Slaby <jirislaby@gmail.com>

Add some locks and unlocks to some code paths.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rio/riotable.c |    4 +++-
 drivers/char/rio/riotty.c   |    4 ++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/char/rio/riotable.c~char-rio-fix-sparse-warnings drivers/char/rio/riotable.c
--- a/drivers/char/rio/riotable.c~char-rio-fix-sparse-warnings
+++ a/drivers/char/rio/riotable.c
@@ -425,8 +425,10 @@ int RIOApel(struct rio_info *p)
 
 		MapP = &p->RIOConnectTable[Next++];
 		MapP->HostUniqueNum = HostP->UniqueNum;
-		if ((HostP->Flags & RUN_STATE) != RC_RUNNING)
+		if ((HostP->Flags & RUN_STATE) != RC_RUNNING) {
+			rio_spin_unlock_irqrestore(&HostP->HostLock, flags);
 			continue;
+		}
 		MapP->RtaUniqueNum = 0;
 		MapP->ID = 0;
 		MapP->Flags = SLOT_IN_USE;
diff -puN drivers/char/rio/riotty.c~char-rio-fix-sparse-warnings drivers/char/rio/riotty.c
--- a/drivers/char/rio/riotty.c~char-rio-fix-sparse-warnings
+++ a/drivers/char/rio/riotty.c
@@ -319,6 +319,7 @@ int riotopen(struct tty_struct *tty, str
 			PortP->State |= RIO_WOPEN;
 			rio_spin_unlock_irqrestore(&PortP->portSem, flags);
 			if (RIODelay(PortP, HUNDRED_MS) == RIO_FAIL) {
+				rio_spin_lock_irqsave(&PortP->portSem, flags);
 				/*
 				 ** ACTION: verify that this is a good thing
 				 ** to do here. -- ???
@@ -334,6 +335,7 @@ int riotopen(struct tty_struct *tty, str
 				func_exit();
 				return -EINTR;
 			}
+			rio_spin_lock_irqsave(&PortP->portSem, flags);
 		}
 		PortP->State &= ~RIO_WOPEN;
 	}
@@ -493,6 +495,7 @@ int riotclose(void *ptr)
 
 	if (RIOShortCommand(p, PortP, CLOSE, 1, 0) == RIO_FAIL) {
 		RIOPreemptiveCmd(p, PortP, FCLOSE);
+		rio_spin_lock_irqsave(&PortP->portSem, flags);
 		goto close_end;
 	}
 
@@ -508,6 +511,7 @@ int riotclose(void *ptr)
 
 			if (p->RIOHalted) {
 				RIOClearUp(PortP);
+				rio_spin_lock_irqsave(&PortP->portSem, flags);
 				goto close_end;
 			}
 			if (RIODelay(PortP, HUNDRED_MS) == RIO_FAIL) {
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

