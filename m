From: akpm@linux-foundation.org
Subject: - char-moxa-eliminate-busy-waiting.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:06:21 -0700
Message-ID: <200707172306.l6HN6LJ6012006@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59057 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765595AbXGQXPN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, eliminate busy waiting
has been removed from the -mm tree.  Its filename was
     char-moxa-eliminate-busy-waiting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: moxa, eliminate busy waiting
From: Jiri Slaby <jirislaby@gmail.com>

blah, moxa delays 250+ ms in busy waiting, use msleep instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |   37 ++++++++++++-------------------------
 1 file changed, 12 insertions(+), 25 deletions(-)

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
some-kmalloc-memset-kzalloc-tree-wide.patch
shrink_slab-handle-bad-shrinkers.patch
