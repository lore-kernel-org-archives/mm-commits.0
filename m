From: akpm@linux-foundation.org
Subject: + char-moxa-eliminate-busy-waiting.patch added to -mm tree
Date: Thu, 24 May 2007 16:59:57 -0700
Message-ID: <200705242359.l4ONxvgw006710@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751077AbXEYAAB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 20:00:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: moxa, eliminate busy waiting
has been added to the -mm tree.  Its filename is
     char-moxa-eliminate-busy-waiting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: moxa, eliminate busy waiting
From: Jiri Slaby <jirislaby@gmail.com>

blah, moxa delays 250+ ms in busy waiting, use msleep instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |   37 ++++++++++++-------------------------
 1 files changed, 12 insertions(+), 25 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-eliminate-busy-waiting drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-eliminate-busy-waiting
+++ a/drivers/char/moxa.c
@@ -1405,7 +1405,6 @@ static int moxaCard;
 static struct mon_str moxaLog;
 static int moxaFuncTout = HZ / 2;
 
-static void moxadelay(int);
 static void moxafunc(void __iomem *, int, ushort);
 static void wait_finish(void __iomem *);
 static void low_water_check(void __iomem *);
@@ -2404,10 +2403,10 @@ void MoxaPortSendBreak(int port, int ms1
 	ofsAddr = moxa_ports[port].tableAddr;
 	if (ms100) {
 		moxafunc(ofsAddr, FC_SendBreak, Magic_code);
-		moxadelay(ms100 * (HZ / 10));
+		msleep(ms100 * 10);
 	} else {
 		moxafunc(ofsAddr, FC_SendBreak, Magic_code);
-		moxadelay(HZ / 4);	/* 250 ms */
+		msleep(250);
 	}
 	moxafunc(ofsAddr, FC_StopBreak, Magic_code);
 }
@@ -2476,18 +2475,6 @@ static int moxa_set_serial_info(struct m
 /*****************************************************************************
  *	Static local functions: 					     *
  *****************************************************************************/
-/*
- * moxadelay - delays a specified number ticks
- */
-static void moxadelay(int tick)
-{
-	unsigned long st, et;
-
-	st = jiffies;
-	et = st + tick;
-	while (time_before(jiffies, et));
-}
-
 static void moxafunc(void __iomem *ofsAddr, int cmd, ushort arg)
 {
 
@@ -2535,7 +2522,7 @@ static int moxaloadbios(int cardno, unsi
 		return -EFAULT;
 	baseAddr = moxa_boards[cardno].basemem;
 	writeb(HW_reset, baseAddr + Control_reg);	/* reset */
-	moxadelay(1);		/* delay 10 ms */
+	msleep(10);
 	for (i = 0; i < 4096; i++)
 		writeb(0, baseAddr + i);	/* clear fix page */
 	for (i = 0; i < len; i++)
@@ -2713,7 +2700,7 @@ static int moxaloadc218(int cardno, void
 			for (i = 0; i < 100; i++) {
 				if (readw(baseAddr + C218_key) == keycode)
 					break;
-				moxadelay(1);	/* delay 10 ms */
+				msleep(10);
 			}
 			if (readw(baseAddr + C218_key) != keycode) {
 				return (-1);
@@ -2725,7 +2712,7 @@ static int moxaloadc218(int cardno, void
 		for (i = 0; i < 100; i++) {
 			if (readw(baseAddr + C218_key) == keycode)
 				break;
-			moxadelay(1);	/* delay 10 ms */
+			msleep(10);
 		}
 		retry++;
 	} while ((readb(baseAddr + C218chksum_ok) != 1) && (retry < 3));
@@ -2736,7 +2723,7 @@ static int moxaloadc218(int cardno, void
 	for (i = 0; i < 100; i++) {
 		if (readw(baseAddr + Magic_no) == Magic_code)
 			break;
-		moxadelay(1);	/* delay 10 ms */
+		msleep(10);
 	}
 	if (readw(baseAddr + Magic_no) != Magic_code) {
 		return (-1);
@@ -2746,7 +2733,7 @@ static int moxaloadc218(int cardno, void
 	for (i = 0; i < 100; i++) {
 		if (readw(baseAddr + Magic_no) == Magic_code)
 			break;
-		moxadelay(1);	/* delay 10 ms */
+		msleep(10);
 	}
 	if (readw(baseAddr + Magic_no) != Magic_code) {
 		return (-1);
@@ -2788,7 +2775,7 @@ static int moxaloadc320(int cardno, void
 			for (i = 0; i < 10; i++) {
 				if (readw(baseAddr + C320_key) == C320_KeyCode)
 					break;
-				moxadelay(1);
+				msleep(10);
 			}
 			if (readw(baseAddr + C320_key) != C320_KeyCode)
 				return (-1);
@@ -2799,7 +2786,7 @@ static int moxaloadc320(int cardno, void
 		for (i = 0; i < 10; i++) {
 			if (readw(baseAddr + C320_key) == C320_KeyCode)
 				break;
-			moxadelay(1);
+			msleep(10);
 		}
 		retry++;
 	} while ((readb(baseAddr + C320chksum_ok) != 1) && (retry < 3));
@@ -2809,7 +2796,7 @@ static int moxaloadc320(int cardno, void
 	for (i = 0; i < 600; i++) {
 		if (readw(baseAddr + Magic_no) == Magic_code)
 			break;
-		moxadelay(1);
+		msleep(10);
 	}
 	if (readw(baseAddr + Magic_no) != Magic_code)
 		return (-100);
@@ -2828,7 +2815,7 @@ static int moxaloadc320(int cardno, void
 	for (i = 0; i < 500; i++) {
 		if (readw(baseAddr + Magic_no) == Magic_code)
 			break;
-		moxadelay(1);
+		msleep(10);
 	}
 	if (readw(baseAddr + Magic_no) != Magic_code)
 		return (-102);
@@ -2842,7 +2829,7 @@ static int moxaloadc320(int cardno, void
 	for (i = 0; i < 600; i++) {
 		if (readw(baseAddr + Magic_no) == Magic_code)
 			break;
-		moxadelay(1);
+		msleep(10);
 	}
 	if (readw(baseAddr + Magic_no) != Magic_code)
 		return (-102);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
char-cyclades-fix-deadlock.patch
misc-phantom-move-to-unlocked_ioctl.patch
misc-phantom-take-care-of-pci-posting.patch
cinergyt2-fix-file-release-handler.patch
rocketc-fix-unchecked-mutex_lock_interruptible.patch
char-cyclades-add-firmware-loading.patch
char-cyclades-fix-sparse-warning.patch
char-isicom-cleanup-locking.patch
char-isicom-del_timer-at-exit.patch
char-isicom-proper-variables-types.patch
char-moxa-eliminate-busy-waiting.patch
char-specialix-remove-busy-waiting.patch
char-riscom8-eliminate-busy-loop.patch
shrink_slab-handle-bad-shrinkers.patch
