From: akpm@linux-foundation.org
Subject: + char-moxa-cleanup-rx-tx.patch added to -mm tree
Date: Wed, 27 Feb 2008 15:13:17 -0800
Message-ID: <200802272313.m1RNDHVW003285@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762994AbYB0XNy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 18:13:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, Oyvind.Aabling@uni-c.dk


The patch titled
     Char: moxa, cleanup rx/tx
has been added to the -mm tree.  Its filename is
     char-moxa-cleanup-rx-tx.patch

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
Subject: Char: moxa, cleanup rx/tx
From: Jiri Slaby <jirislaby@gmail.com>

- cleanup types
- use tty_prepare_flip_string and io memcpys

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |  124 ++++++++++++++++--------------------------
 drivers/char/moxa.h |    2 
 2 files changed, 51 insertions(+), 75 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-cleanup-rx-tx drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-cleanup-rx-tx
+++ a/drivers/char/moxa.c
@@ -224,7 +224,7 @@ static void MoxaPortLineCtrl(struct moxa
 static void MoxaPortFlowCtrl(struct moxa_port *, int, int, int, int, int);
 static int MoxaPortLineStatus(struct moxa_port *);
 static void MoxaPortFlushData(struct moxa_port *, int);
-static int MoxaPortWriteData(struct moxa_port *, unsigned char *, int);
+static int MoxaPortWriteData(struct moxa_port *, const unsigned char *, int);
 static int MoxaPortReadData(struct moxa_port *);
 static int MoxaPortTxQueue(struct moxa_port *);
 static int MoxaPortRxQueue(struct moxa_port *);
@@ -1164,7 +1164,7 @@ static int moxa_write(struct tty_struct 
 		return 0;
 
 	spin_lock_bh(&moxa_lock);
-	len = MoxaPortWriteData(ch, (unsigned char *) buf, count);
+	len = MoxaPortWriteData(ch, buf, count);
 	spin_unlock_bh(&moxa_lock);
 
 	/*********************************************
@@ -2029,15 +2029,13 @@ static int MoxaPortLineStatus(struct mox
 	return val;
 }
 
-static int MoxaPortWriteData(struct moxa_port *port, unsigned char *buffer,
-		int len)
+static int MoxaPortWriteData(struct moxa_port *port,
+		const unsigned char *buffer, int len)
 {
-	int c, total, i;
-	ushort tail;
-	int cnt;
-	ushort head, tx_mask, spage, epage;
-	ushort pageno, pageofs, bufhead;
 	void __iomem *baseAddr, *ofsAddr, *ofs;
+	unsigned int c, total;
+	u16 head, tail, tx_mask, spage, epage;
+	u16 pageno, pageofs, bufhead;
 
 	ofsAddr = port->tableAddr;
 	baseAddr = port->board->basemem;
@@ -2046,8 +2044,7 @@ static int MoxaPortWriteData(struct moxa
 	epage = readw(ofsAddr + EndPage_txb);
 	tail = readw(ofsAddr + TXwptr);
 	head = readw(ofsAddr + TXrptr);
-	c = (head > tail) ? (head - tail - 1)
-	    : (head - tail + tx_mask);
+	c = (head > tail) ? (head - tail - 1) : (head - tail + tx_mask);
 	if (c > len)
 		c = len;
 	moxaLog.txcnt[port->tty->index] += c;
@@ -2062,46 +2059,42 @@ static int MoxaPortWriteData(struct moxa
 				len = tx_mask + 1 - tail;
 			len = (c > len) ? len : c;
 			ofs = baseAddr + DynPage_addr + bufhead + tail;
-			for (i = 0; i < len; i++)
-				writeb(*buffer++, ofs + i);
+			memcpy_toio(ofs, buffer, len);
+			buffer += len;
 			tail = (tail + len) & tx_mask;
 			c -= len;
 		}
-		writew(tail, ofsAddr + TXwptr);
 	} else {
-		len = c;
 		pageno = spage + (tail >> 13);
 		pageofs = tail & Page_mask;
-		do {
-			cnt = Page_size - pageofs;
-			if (cnt > c)
-				cnt = c;
-			c -= cnt;
+		while (c > 0) {
+			len = Page_size - pageofs;
+			if (len > c)
+				len = c;
 			writeb(pageno, baseAddr + Control_reg);
 			ofs = baseAddr + DynPage_addr + pageofs;
-			for (i = 0; i < cnt; i++)
-				writeb(*buffer++, ofs + i);
-			if (c == 0) {
-				writew((tail + len) & tx_mask, ofsAddr + TXwptr);
-				break;
-			}
+			memcpy_toio(ofs, buffer, len);
+			buffer += len;
 			if (++pageno == epage)
 				pageno = spage;
 			pageofs = 0;
-		} while (1);
+			c -= len;
+		}
+		tail = (tail + total) & tx_mask;
 	}
+	writew(tail, ofsAddr + TXwptr);
 	writeb(1, ofsAddr + CD180TXirq);	/* start to send */
-	return (total);
+	return total;
 }
 
 static int MoxaPortReadData(struct moxa_port *port)
 {
 	struct tty_struct *tty = port->tty;
-	register ushort head, pageofs;
-	int i, count, cnt, len, total, remain;
-	ushort tail, rx_mask, spage, epage;
-	ushort pageno, bufhead;
+	unsigned char *dst;
 	void __iomem *baseAddr, *ofsAddr, *ofs;
+	unsigned int count, len, total;
+	u16 tail, rx_mask, spage, epage;
+	u16 pageno, pageofs, bufhead, head;
 
 	ofsAddr = port->tableAddr;
 	baseAddr = port->board->basemem;
@@ -2110,101 +2103,84 @@ static int MoxaPortReadData(struct moxa_
 	rx_mask = readw(ofsAddr + RX_mask);
 	spage = readw(ofsAddr + Page_rxb);
 	epage = readw(ofsAddr + EndPage_rxb);
-	count = (tail >= head) ? (tail - head)
-	    : (tail - head + rx_mask + 1);
+	count = (tail >= head) ? (tail - head) : (tail - head + rx_mask + 1);
 	if (count == 0)
 		return 0;
 
 	total = count;
-	remain = count - total;
 	moxaLog.rxcnt[tty->index] += total;
-	count = total;
 	if (spage == epage) {
 		bufhead = readw(ofsAddr + Ofs_rxb);
 		writew(spage, baseAddr + Control_reg);
 		while (count > 0) {
-			if (tail >= head)
-				len = tail - head;
-			else
-				len = rx_mask + 1 - head;
-			len = (count > len) ? len : count;
 			ofs = baseAddr + DynPage_addr + bufhead + head;
-			for (i = 0; i < len; i++)
-				tty_insert_flip_char(tty, readb(ofs + i), TTY_NORMAL);
+			len = (tail >= head) ? (tail - head) :
+					(rx_mask + 1 - head);
+			len = tty_prepare_flip_string(tty, &dst,
+					min(len, count));
+			memcpy_fromio(dst, ofs, len);
 			head = (head + len) & rx_mask;
 			count -= len;
 		}
-		writew(head, ofsAddr + RXrptr);
 	} else {
-		len = count;
 		pageno = spage + (head >> 13);
 		pageofs = head & Page_mask;
-		do {
-			cnt = Page_size - pageofs;
-			if (cnt > count)
-				cnt = count;
-			count -= cnt;
+		while (count > 0) {
 			writew(pageno, baseAddr + Control_reg);
 			ofs = baseAddr + DynPage_addr + pageofs;
-			for (i = 0; i < cnt; i++)
-				tty_insert_flip_char(tty, readb(ofs + i), TTY_NORMAL);
-			if (count == 0) {
-				writew((head + len) & rx_mask, ofsAddr + RXrptr);
-				break;
-			}
-			if (++pageno == epage)
+			len = tty_prepare_flip_string(tty, &dst,
+					min(Page_size - pageofs, count));
+			memcpy_fromio(dst, ofs, len);
+
+			count -= len;
+			pageofs = (pageofs + len) & Page_mask;
+			if (pageofs == 0 && ++pageno == epage)
 				pageno = spage;
-			pageofs = 0;
-		} while (1);
+		}
+		head = (head + total) & rx_mask;
 	}
-	if ((readb(ofsAddr + FlagStat) & Xoff_state) && (remain < LowWater)) {
+	writew(head, ofsAddr + RXrptr);
+	if (readb(ofsAddr + FlagStat) & Xoff_state) {
 		moxaLowWaterChk = 1;
 		port->lowChkFlag = 1;
 	}
-	return (total);
+	return total;
 }
 
 
 static int MoxaPortTxQueue(struct moxa_port *port)
 {
 	void __iomem *ofsAddr = port->tableAddr;
-	ushort rptr, wptr, mask;
-	int len;
+	u16 rptr, wptr, mask;
 
 	rptr = readw(ofsAddr + TXrptr);
 	wptr = readw(ofsAddr + TXwptr);
 	mask = readw(ofsAddr + TX_mask);
-	len = (wptr - rptr) & mask;
-	return (len);
+	return (wptr - rptr) & mask;
 }
 
 static int MoxaPortTxFree(struct moxa_port *port)
 {
 	void __iomem *ofsAddr = port->tableAddr;
-	ushort rptr, wptr, mask;
-	int len;
+	u16 rptr, wptr, mask;
 
 	rptr = readw(ofsAddr + TXrptr);
 	wptr = readw(ofsAddr + TXwptr);
 	mask = readw(ofsAddr + TX_mask);
-	len = mask - ((wptr - rptr) & mask);
-	return (len);
+	return mask - ((wptr - rptr) & mask);
 }
 
 static int MoxaPortRxQueue(struct moxa_port *port)
 {
 	void __iomem *ofsAddr = port->tableAddr;
-	ushort rptr, wptr, mask;
-	int len;
+	u16 rptr, wptr, mask;
 
 	rptr = readw(ofsAddr + RXrptr);
 	wptr = readw(ofsAddr + RXwptr);
 	mask = readw(ofsAddr + RX_mask);
-	len = (wptr - rptr) & mask;
-	return (len);
+	return (wptr - rptr) & mask;
 }
 
-
 static void MoxaPortTxDisable(struct moxa_port *port)
 {
 	moxafunc(port->tableAddr, FC_SetXoffState, Magic_code);
diff -puN drivers/char/moxa.h~char-moxa-cleanup-rx-tx drivers/char/moxa.h
--- a/drivers/char/moxa.h~char-moxa-cleanup-rx-tx
+++ a/drivers/char/moxa.h
@@ -217,7 +217,7 @@
 #define C320p32rx_mask	(C320p32rx_size - 1)
 #define C320p32tx_mask	(C320p32tx_size - 1)
 
-#define Page_size	0x2000
+#define Page_size	0x2000U
 #define Page_mask	(Page_size - 1)
 #define C218rx_spage	3
 #define C218tx_spage	4
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
