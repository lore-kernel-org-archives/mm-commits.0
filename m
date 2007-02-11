From: akpm@linux-foundation.org
Subject: - char-moxa-do-not-initialize-global-static.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:52:21 -0800
Message-ID: <200702112252.l1BMqL8j016008@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60246 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932794AbXBKWwX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:52:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, do not initialize global static
has been removed from the -mm tree.  Its filename was
     char-moxa-do-not-initialize-global-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: moxa, do not initialize global static
From: Jiri Slaby <jirislaby@gmail.com>

Remove useless initialization of variables a) statically b) dynamically at
module_init c) dynamically after kzalloc (those with '= 0/NULL')

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |   24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-do-not-initialize-global-static drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-do-not-initialize-global-static
+++ a/drivers/char/moxa.c
@@ -194,9 +194,9 @@ static int verbose = 0;
 static int ttymajor = MOXAMAJOR;
 /* Variables for insmod */
 #ifdef MODULE
-static int baseaddr[] 	= 	{0, 0, 0, 0};
-static int type[]	=	{0, 0, 0, 0};
-static int numports[] 	=	{0, 0, 0, 0};
+static int baseaddr[4];
+static int type[4];
+static int numports[4];
 #endif
 
 MODULE_AUTHOR("William Chen");
@@ -348,10 +348,7 @@ static int __init moxa_init(void)
 	moxaDriver->type = TTY_DRIVER_TYPE_SERIAL;
 	moxaDriver->subtype = SERIAL_TYPE_NORMAL;
 	moxaDriver->init_termios = tty_std_termios;
-	moxaDriver->init_termios.c_iflag = 0;
-	moxaDriver->init_termios.c_oflag = 0;
 	moxaDriver->init_termios.c_cflag = B9600 | CS8 | CREAD | CLOCAL | HUPCL;
-	moxaDriver->init_termios.c_lflag = 0;
 	moxaDriver->init_termios.c_ispeed = 9600;
 	moxaDriver->init_termios.c_ospeed = 9600;
 	moxaDriver->flags = TTY_DRIVER_REAL_RAW;
@@ -361,25 +358,13 @@ static int __init moxa_init(void)
 		ch->type = PORT_16550A;
 		ch->port = i;
 		INIT_WORK(&ch->tqueue, do_moxa_softint);
-		ch->tty = NULL;
 		ch->close_delay = 5 * HZ / 10;
 		ch->closing_wait = 30 * HZ;
-		ch->count = 0;
-		ch->blocked_open = 0;
 		ch->cflag = B9600 | CS8 | CREAD | CLOCAL | HUPCL;
 		init_waitqueue_head(&ch->open_wait);
 		init_waitqueue_head(&ch->close_wait);
 	}
 
-	for (i = 0; i < MAX_BOARDS; i++) {
-		moxa_boards[i].boardType = 0;
-		moxa_boards[i].numPorts = 0;
-		moxa_boards[i].baseAddr = 0;
-		moxa_boards[i].busType = 0;
-		moxa_boards[i].pciInfo.busNum = 0;
-		moxa_boards[i].pciInfo.devNum = 0;
-	}
-	MoxaDriverInit();
 	printk("Tty devices major number = %d\n", ttymajor);
 
 	if (tty_register_driver(moxaDriver)) {
@@ -391,7 +376,6 @@ static int __init moxa_init(void)
 		init_timer(&moxaEmptyTimer[i]);
 		moxaEmptyTimer[i].function = check_xmit_empty;
 		moxaEmptyTimer[i].data = (unsigned long) & moxaChannels[i];
-		moxaEmptyTimer_on[i] = 0;
 	}
 
 	init_timer(&moxaTimer);
@@ -1470,7 +1454,7 @@ static char moxaLowChkFlag[MAX_PORTS];
 static int moxaLowWaterChk;
 static int moxaCard;
 static mon_st moxaLog;
-static int moxaFuncTout;
+static int moxaFuncTout = HZ / 2;
 static ushort moxaBreakCnt[MAX_PORTS];
 
 static void moxadelay(int);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
char-use-more-pci_device-macro.patch
char-cyclades-use-pci_device_id.patch
maintainers-remove-two-dead-e-mail.patch
char-specialix-isr-have-2-params.patch
char-timers-cleanup.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
video-fb-add-true-ref_count-atomicity.patch
video-fb-kzalloc-changes.patch
shrink_slab-handle-bad-shrinkers.patch
