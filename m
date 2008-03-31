From: akpm@linux-foundation.org
Subject: + char-rio-fix-sparse-warnings.patch added to -mm tree
Date: Mon, 31 Mar 2008 16:58:13 -0700
Message-ID: <200803312358.m2VNwDmr032499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751272AbYCaX6q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 19:58:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: rio, fix sparse warnings
has been added to the -mm tree.  Its filename is
     char-rio-fix-sparse-warnings.patch

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
@@ -320,6 +320,7 @@ int riotopen(struct tty_struct *tty, str
 			PortP->State |= RIO_WOPEN;
 			rio_spin_unlock_irqrestore(&PortP->portSem, flags);
 			if (RIODelay(PortP, HUNDRED_MS) == RIO_FAIL) {
+				rio_spin_lock_irqsave(&PortP->portSem, flags);
 				/*
 				 ** ACTION: verify that this is a good thing
 				 ** to do here. -- ???
@@ -335,6 +336,7 @@ int riotopen(struct tty_struct *tty, str
 				func_exit();
 				return -EINTR;
 			}
+			rio_spin_lock_irqsave(&PortP->portSem, flags);
 		}
 		PortP->State &= ~RIO_WOPEN;
 	}
@@ -494,6 +496,7 @@ int riotclose(void *ptr)
 
 	if (RIOShortCommand(p, PortP, RIOC_CLOSE, 1, 0) == RIO_FAIL) {
 		RIOPreemptiveCmd(p, PortP, RIOC_FCLOSE);
+		rio_spin_lock_irqsave(&PortP->portSem, flags);
 		goto close_end;
 	}
 
@@ -509,6 +512,7 @@ int riotclose(void *ptr)
 
 			if (p->RIOHalted) {
 				RIOClearUp(PortP);
+				rio_spin_lock_irqsave(&PortP->portSem, flags);
 				goto close_end;
 			}
 			if (RIODelay(PortP, HUNDRED_MS) == RIO_FAIL) {
_

Patches currently in -mm which might be from jirislaby@gmail.com are

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
char-rio-fix-cirrus-defines.patch
char-ip2-fix-sparse-warnings.patch
char-rio-fix-sparse-warnings.patch
mxser-convert-large-macros-to-functions.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

