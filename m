From: akpm@linux-foundation.org
Subject: - char-moxa-fix-and-optimise-empty-timer.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:44:13 -0700
Message-ID: <200710190344.l9J3iDgA013125@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36954 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934259AbXJSDze (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, fix and optimise empty timer
has been removed from the -mm tree.  Its filename was
     char-moxa-fix-and-optimise-empty-timer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: moxa, fix and optimise empty timer
From: Jiri Slaby <jirislaby@gmail.com>

moxa, fix and optimise empty timer

don't wait and delete empty timer in empty timer function. Also fire next
empty timer at rounded jiffies to save power.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-fix-and-optimise-empty-timer drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-fix-and-optimise-empty-timer
+++ a/drivers/char/moxa.c
@@ -1040,14 +1040,14 @@ static void check_xmit_empty(unsigned lo
 	struct moxa_port *ch;
 
 	ch = (struct moxa_port *) data;
-	del_timer_sync(&moxa_ports[ch->port].emptyTimer);
 	if (ch->tty && (ch->statusflags & EMPTYWAIT)) {
 		if (MoxaPortTxQueue(ch->port) == 0) {
 			ch->statusflags &= ~EMPTYWAIT;
 			tty_wakeup(ch->tty);
 			return;
 		}
-		mod_timer(&moxa_ports[ch->port].emptyTimer, jiffies + HZ);
+		mod_timer(&moxa_ports[ch->port].emptyTimer,
+				round_jiffies(jiffies + HZ));
 	} else
 		ch->statusflags &= ~EMPTYWAIT;
 }
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
v4l-stk11xx-add-a-new-webcam-driver.patch
v4l-stk11xx-use-array_size-in-another-2-cases.patch
v4l-stk11xx-use-retval-from-stk11xx_check_device.patch
v4l-stk11xx-add-static-to-tables.patch
git-wireless.patch
misc-phantom-synchronize_irq-on-suspend.patch
misc-phantom-add-comment-about-openhaptics.patch
misc-phantom-improved-data-passing.patch
fs-select-remove-unused-macros.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
cyber2000fb-rename-bit-macro.patch
i2c-pxa-rename-bit-macro-to-pxa_bit.patch
s2io-rename-bit-macro.patch
amba-pl011-rename-bit-macro.patch
define-first-set-of-bit-macros.patch
get-rid-of-input-bit-duplicate-defines.patch
define-global-bit-macro.patch
flashpoint-use-bit-instead-of-bitw.patch
remove-bits_to_type-macro.patch
remove-bits_to_type-macro-fix.patch
remove-asm-bitopsh-includes-reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
