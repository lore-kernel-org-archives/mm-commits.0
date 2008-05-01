From: akpm@linux-foundation.org
Subject: - char-moxa-cleanup-rx-tx.patch removed from -mm tree
Date: Thu, 01 May 2008 02:29:18 -0700
Message-ID: <200805010929.m419TILY030662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42242 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757128AbYEAJ3X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:29:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, Oyvind.Aabling@uni-c.dk, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, cleanup rx/tx
has been removed from the -mm tree.  Its filename was
     char-moxa-cleanup-rx-tx.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1165,7 +1165,7 @@ static int moxa_write(struct tty_struct 
 		return 0;
 
 	spin_lock_bh(&moxa_lock);
-	len = MoxaPortWriteData(ch, (unsigned char *) buf, count);
+	len = MoxaPortWriteData(ch, buf, count);
 	spin_unlock_bh(&moxa_lock);
 
 	/*********************************************
@@ -2030,15 +2030,13 @@ static int MoxaPortLineStatus(struct mox
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
@@ -2047,8 +2045,7 @@ static int MoxaPortWriteData(struct moxa
 	epage = readw(ofsAddr + EndPage_txb);
 	tail = readw(ofsAddr + TXwptr);
 	head = readw(ofsAddr + TXrptr);
-	c = (head > tail) ? (head - tail - 1)
-	    : (head - tail + tx_mask);
+	c = (head > tail) ? (head - tail - 1) : (head - tail + tx_mask);
 	if (c > len)
 		c = len;
 	moxaLog.txcnt[port->tty->index] += c;
@@ -2063,46 +2060,42 @@ static int MoxaPortWriteData(struct moxa
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
@@ -2111,101 +2104,84 @@ static int MoxaPortReadData(struct moxa_
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
 
