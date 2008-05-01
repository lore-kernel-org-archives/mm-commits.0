From: akpm@linux-foundation.org
Subject: - char-moxa-remove-unused-port-entries.patch removed from -mm tree
Date: Thu, 01 May 2008 02:29:08 -0700
Message-ID: <200805010929.m419T82a030647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757419AbYEAJ3M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:29:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, Oyvind.Aabling@uni-c.dk, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, remove unused port entries
has been removed from the -mm tree.  Its filename was
     char-moxa-remove-unused-port-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

