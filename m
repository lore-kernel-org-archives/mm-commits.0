From: akpm@linux-foundation.org
Subject: + char-moxa-introduce-moxa_is_320-macro.patch added to -mm tree
Date: Wed, 27 Feb 2008 15:13:28 -0800
Message-ID: <200802272313.m1RNDSNH003310@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:32961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762268AbYB0XOE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 18:14:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, Oyvind.Aabling@uni-c.dk


The patch titled
     Char: moxa, introduce MOXA_IS_320 macro
has been added to the -mm tree.  Its filename is
     char-moxa-introduce-moxa_is_320-macro.patch

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
@@ -1634,18 +1635,9 @@ static void MoxaPortFlushData(struct mox
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
@@ -1794,8 +1786,7 @@ static void MoxaPortEnable(struct moxa_p
 
 	ofsAddr = port->tableAddr;
 	writew(lowwater, ofsAddr + Low_water);
-	if (port->board->boardType == MOXA_BOARD_C320_ISA ||
-			port->board->boardType == MOXA_BOARD_C320_PCI)
+	if (MOXA_IS_320(port->board))
 		moxafunc(ofsAddr, FC_SetBreakIrq, 0);
 	else
 		writew(readw(ofsAddr + HostStat) | WakeupBreak,
@@ -1818,33 +1809,18 @@ static void MoxaPortDisable(struct moxa_
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
@@ -1889,11 +1865,9 @@ static int MoxaPortSetTermio(struct moxa
 
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
@@ -1953,8 +1927,7 @@ static int MoxaPortLineStatus(struct mox
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
