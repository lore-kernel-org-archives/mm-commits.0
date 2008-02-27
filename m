From: akpm@linux-foundation.org
Subject: + char-moxa-remove-unused-port-entries.patch added to -mm tree
Date: Wed, 27 Feb 2008 15:13:06 -0800
Message-ID: <200802272313.m1RND6WM003262@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760104AbYB0XU4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 18:20:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, Oyvind.Aabling@uni-c.dk


The patch titled
     Char: moxa, remove unused port entries
has been added to the -mm tree.  Its filename is
     char-moxa-remove-unused-port-entries.patch

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
Subject: Char: moxa, remove unused port entries
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-remove-unused-port-entries drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-remove-unused-port-entries
+++ a/drivers/char/moxa.c
@@ -131,10 +131,8 @@ struct moxa_port {
 	struct moxa_board_conf *board;
 	int type;
 	int close_delay;
-	unsigned short closing_wait;
 	int count;
 	int blocked_open;
-	long event; /* long req'd for set_bit --RR */
 	int asyncflags;
 	unsigned long statusflags;
 	struct tty_struct *tty;
@@ -147,7 +145,6 @@ struct moxa_port {
 	char chkPort;
 	char lineCtrl;
 	void __iomem *tableAddr;
-	long curBaud;
 	char DCDState;
 	char lowChkFlag;
 
@@ -515,7 +512,6 @@ static int moxa_load_code(struct moxa_bo
 		for (i = 0; i < brd->numPorts; i++, port++) {
 			port->board = brd;
 			port->chkPort = 1;
-			port->curBaud = 9600L;
 			port->DCDState = 0;
 			port->tableAddr = baseAddr + Extern_table +
 					Extern_size * i;
@@ -535,7 +531,6 @@ static int moxa_load_code(struct moxa_bo
 		for (i = 0; i < brd->numPorts; i++, port++) {
 			port->board = brd;
 			port->chkPort = 1;
-			port->curBaud = 9600L;
 			port->DCDState = 0;
 			port->tableAddr = baseAddr + Extern_table +
 					Extern_size * i;
@@ -823,7 +818,6 @@ static int __init moxa_init(void)
 	for (i = 0, ch = moxa_ports; i < MAX_PORTS; i++, ch++) {
 		ch->type = PORT_16550A;
 		ch->close_delay = 5 * HZ / 10;
-		ch->closing_wait = 30 * HZ;
 		ch->cflag = B9600 | CS8 | CREAD | CLOCAL | HUPCL;
 		init_waitqueue_head(&ch->open_wait);
 		init_completion(&ch->close_wait);
@@ -1006,7 +1000,6 @@ static void moxa_close(struct tty_struct
 	tty_ldisc_flush(tty);
 			
 	tty->closing = 0;
-	ch->event = 0;
 	ch->tty = NULL;
 	if (ch->blocked_open) {
 		if (ch->close_delay) {
@@ -1270,7 +1263,6 @@ static void moxa_hangup(struct tty_struc
 
 	moxa_flush_buffer(tty);
 	moxa_shut_down(ch);
-	ch->event = 0;
 	ch->count = 0;
 	ch->asyncflags &= ~ASYNC_NORMAL_ACTIVE;
 	ch->tty = NULL;
@@ -2079,7 +2071,6 @@ static long MoxaPortSetBaud(struct moxa_
 	val = clock / baud;
 	moxafunc(ofsAddr, FC_SetBaud, val);
 	baud = clock / val;
-	port->curBaud = baud;
 	return (baud);
 }
 
@@ -2457,7 +2448,6 @@ static int moxa_get_serial_info(struct m
 	tmp.flags = info->asyncflags;
 	tmp.baud_base = 921600;
 	tmp.close_delay = info->close_delay;
-	tmp.closing_wait = info->closing_wait;
 	tmp.custom_divisor = 0;
 	tmp.hub6 = 0;
 	if(copy_to_user(retinfo, &tmp, sizeof(*retinfo)))
@@ -2487,7 +2477,6 @@ static int moxa_set_serial_info(struct m
 			return (-EPERM);
 	} else {
 		info->close_delay = new_serial.close_delay * HZ / 100;
-		info->closing_wait = new_serial.closing_wait * HZ / 100;
 	}
 
 	new_serial.flags = (new_serial.flags & ~ASYNC_FLAGS);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
wdev-ath5k-typecheck-on-nondebug.patch
misc-phantom-add-compat-ioctl.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
misc-phantom-fix-poll.patch
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
mxser-convert-large-macros-to-functions.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
