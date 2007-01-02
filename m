From: akpm@osdl.org
Subject: + char-moxa-do-not-initialize-global-static.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:52:46 -0800
Message-ID: <200701022152.l02Lqk1i030995@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35896 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959AbXABVwy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:52:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: moxa, do not initialize global static
has been added to the -mm tree.  Its filename is
     char-moxa-do-not-initialize-global-static.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: moxa, do not initialize global static
From: Jiri Slaby <jirislaby@gmail.com>

Remove useless initialization of variables a) statically b) dynamically at
module_init c) dynamically after kzalloc (those with '= 0/NULL')

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/moxa.c |   24 ++++--------------------
 1 files changed, 4 insertions(+), 20 deletions(-)

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

git-input.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-isicom-remove-tty_hangwakeup-bottomhalves.patch
mxser-remove-ambiguous-redefinition-of-init_work.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
char-isicom-fix-locking-in-isr.patch
char-isicom-augment-card_reset.patch
char-isicom-check-card-state-in-isr.patch
char-isicom-support-higher-rates.patch
char-isicom-correct-probing-removing.patch
char-tty_wakeup-cleanup.patch
char-mxser_new-mark-init-functions.patch
char-mxser_new-remove-useless-spinlock.patch
char-serial167-cleanup.patch
char-n_r3964-cleanup.patch
char-mxser_new-remove-unused-stuff.patch
char-mxser-obsolete-old-nonexperimental-new.patch
char-mxser_new-remove-tty_wakeup-bottomhalf.patch
char-mxser_new-clean-request_irq-call.patch
doc-isicom-remove-reserved-ioctl-number.patch
char-mxser_new-alter-locking-in-isr.patch
char-mxser_new-header-file-cleanup.patch
char-mxser_new-less-loops-in-isr.patch
char-mxser_new-fix-twice-resource-releasing.patch
char-mxser_new-do-not-put-pdev.patch
char-moxa-remove-unused-allocated-page.patch
char-moxa-do-not-initialize-global-static.patch
char-moxa-timers-cleanup.patch
char-moxa-remove-hangup-bottomhalf.patch
char-moxa-remove-unused-functions.patch
char-moxa-devids-cleanup.patch
char-moxa-use-pci_device.patch
char-moxa-eliminate-typedefs.patch
shrink_slab-handle-bad-shrinkers.patch
