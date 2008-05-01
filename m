From: akpm@linux-foundation.org
Subject: - char-moxa-introduce-moxa_is_320-macro.patch removed from -mm tree
Date: Thu, 01 May 2008 02:29:28 -0700
Message-ID: <200805010929.m419TS53030682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756795AbYEAJ3c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:29:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, Oyvind.Aabling@uni-c.dk, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, introduce MOXA_IS_320 macro
has been removed from the -mm tree.  Its filename was
     char-moxa-introduce-moxa_is_320-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: moxa, introduce MOXA_IS_320 macro
From: Jiri Slaby <jirislaby@gmail.com>

It allows to simplify the code, especially MoxaPortSetBaud.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |   65 ++++++++++++------------------------------
 1 file changed, 19 insertions(+), 46 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-introduce-moxa_is_320-macro drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-introduce-moxa_is_320-macro
+++ a/drivers/char/moxa.c
@@ -59,6 +59,9 @@
 #define MAX_PORTS_PER_BOARD	32	/* Don't change this value */
 #define MAX_PORTS		(MAX_BOARDS * MAX_PORTS_PER_BOARD)
 
+#define MOXA_IS_320(brd) ((brd)->boardType == MOXA_BOARD_C320_ISA || \
+		(brd)->boardType == MOXA_BOARD_C320_PCI)
+
 /*
  *    Define the Moxa PCI vendor and device IDs.
  */
@@ -512,11 +515,9 @@ static int moxa_real_load_code(struct mo
 	const u16 *uptr = ptr;
 	size_t wlen, len2, j;
 	unsigned long key, loadbuf, loadlen, checksum, checksum_ok;
-	unsigned int i, retry, c320;
+	unsigned int i, retry;
 	u16 usum, keycode;
 
-	c320 = brd->boardType == MOXA_BOARD_C320_PCI ||
-			brd->boardType == MOXA_BOARD_C320_ISA;
 	keycode = (brd->boardType == MOXA_BOARD_CP204J) ? CP204J_KeyCode :
 				C218_KeyCode;
 
@@ -586,7 +587,7 @@ static int moxa_real_load_code(struct mo
 	if (readw(baseAddr + Magic_no) != Magic_code)
 		return -EIO;
 
-	if (c320) {
+	if (MOXA_IS_320(brd)) {
 		if (brd->busType == MOXA_BUS_TYPE_PCI) {	/* ASIC board */
 			writew(0x3800, baseAddr + TMS320_PORT1);
 			writew(0x3900, baseAddr + TMS320_PORT2);
@@ -607,7 +608,7 @@ static int moxa_real_load_code(struct mo
 	if (readw(baseAddr + Magic_no) != Magic_code)
 		return -EIO;
 
-	if (c320) {
+	if (MOXA_IS_320(brd)) {
 		j = readw(baseAddr + Module_cnt);
 		if (j <= 0)
 			return -EIO;
@@ -1635,18 +1636,9 @@ static void MoxaPortFlushData(struct mox
  *           int port           : port number (0 - 127)
  *
  *
- *      Function 8:     Get the maximun available baud rate of this port.
- *      Syntax:
- *      long MoxaPortGetMaxBaud(int port);
- *           int port           : port number (0 - 127)
- *
- *           return:    0       : this port is invalid
- *                      38400/57600/115200 bps
- *
- *
  *      Function 10:    Setting baud rate of this port.
  *      Syntax:
- *      long MoxaPortSetBaud(int port, long baud);
+ *      speed_t MoxaPortSetBaud(int port, speed_t baud);
  *           int port           : port number (0 - 127)
  *           long baud          : baud rate (50 - 115200)
  *
@@ -1795,8 +1787,7 @@ static void MoxaPortEnable(struct moxa_p
 
 	ofsAddr = port->tableAddr;
 	writew(lowwater, ofsAddr + Low_water);
-	if (port->board->boardType == MOXA_BOARD_C320_ISA ||
-			port->board->boardType == MOXA_BOARD_C320_PCI)
+	if (MOXA_IS_320(port->board))
 		moxafunc(ofsAddr, FC_SetBreakIrq, 0);
 	else
 		writew(readw(ofsAddr + HostStat) | WakeupBreak,
@@ -1819,33 +1810,18 @@ static void MoxaPortDisable(struct moxa_
 	moxafunc(ofsAddr, FC_DisableCH, Magic_code);
 }
 
-static long MoxaPortGetMaxBaud(struct moxa_port *port)
-{
-	if (port->board->boardType == MOXA_BOARD_C320_ISA ||
-			port->board->boardType == MOXA_BOARD_C320_PCI)
-		return 460800L;
-	else
-		return 921600L;
-}
-
-
-static long MoxaPortSetBaud(struct moxa_port *port, long baud)
+static speed_t MoxaPortSetBaud(struct moxa_port *port, speed_t baud)
 {
-	void __iomem *ofsAddr;
-	long max, clock;
-	unsigned int val;
+	void __iomem *ofsAddr = port->tableAddr;
+	unsigned int clock, val;
+	speed_t max;
 
-	if (baud < 50L || (max = MoxaPortGetMaxBaud(port)) == 0)
+	max = MOXA_IS_320(port->board) ? 460800 : 921600;
+	if (baud < 50)
 		return 0;
-	ofsAddr = port->tableAddr;
 	if (baud > max)
 		baud = max;
-	if (max == 38400L)
-		clock = 614400L;	/* for 9.8304 Mhz : max. 38400 bps */
-	else if (max == 57600L)
-		clock = 691200L;	/* for 11.0592 Mhz : max. 57600 bps */
-	else
-		clock = 921600L;	/* for 14.7456 Mhz : max. 115200 bps */
+	clock = 921600;
 	val = clock / baud;
 	moxafunc(ofsAddr, FC_SetBaud, val);
 	baud = clock / val;
@@ -1890,11 +1866,9 @@ static int MoxaPortSetTermio(struct moxa
 
 	moxafunc(ofsAddr, FC_SetDataMode, (u16)mode);
 
-	if (port->board->boardType == MOXA_BOARD_C320_ISA ||
-			port->board->boardType == MOXA_BOARD_C320_PCI) {
-		if (baud >= 921600L)
-			return -1;
-	}
+	if (MOXA_IS_320(port->board) && baud >= 921600)
+		return -1;
+
 	baud = MoxaPortSetBaud(port, baud);
 
 	if (termio->c_iflag & (IXON | IXOFF | IXANY)) {
@@ -1954,8 +1928,7 @@ static int MoxaPortLineStatus(struct mox
 	int val;
 
 	ofsAddr = port->tableAddr;
-	if (port->board->boardType == MOXA_BOARD_C320_ISA ||
-			port->board->boardType == MOXA_BOARD_C320_PCI) {
+	if (MOXA_IS_320(port->board)) {
 		moxafunc(ofsAddr, FC_LineStatus, 0);
 		val = readw(ofsAddr + FuncArg);
 	} else {
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

