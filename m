From: akpm@linux-foundation.org
Subject: - char-moxa-add-firmware-loading.patch removed from -mm tree
Date: Thu, 01 May 2008 02:28:59 -0700
Message-ID: <200805010929.m419Sx94030631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53803 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757495AbYEAJ3H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:29:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, Oyvind.Aabling@uni-c.dk, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, add firmware loading
has been removed from the -mm tree.  Its filename was
     char-moxa-add-firmware-loading.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: moxa, add firmware loading
From: Jiri Slaby <jirislaby@gmail.com>

Substitute ioctl load firmware interface by kernel firmware api.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c | 1241 +++++++++++++++++-------------------------
 drivers/char/moxa.h |  296 ++++++++++
 2 files changed, 818 insertions(+), 719 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-add-firmware-loading drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-add-firmware-loading
+++ a/drivers/char/moxa.c
@@ -25,6 +25,7 @@
 #include <linux/mm.h>
 #include <linux/ioport.h>
 #include <linux/errno.h>
+#include <linux/firmware.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
 #include <linux/timer.h>
@@ -47,8 +48,12 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
+#include "moxa.h"
+
 #define MOXA_VERSION		"5.1k"
 
+#define MOXA_FW_HDRLEN		32
+
 #define MOXAMAJOR		172
 #define MOXACUMAJOR		173
 
@@ -92,6 +97,8 @@ static struct pci_device_id moxa_pcibrds
 MODULE_DEVICE_TABLE(pci, moxa_pcibrds);
 #endif /* CONFIG_PCI */
 
+struct moxa_port;
+
 static struct moxa_board_conf {
 	int boardType;
 	int numPorts;
@@ -99,6 +106,8 @@ static struct moxa_board_conf {
 
 	int loadstat;
 
+	struct moxa_port *ports;
+
 	void __iomem *basemem;
 	void __iomem *intNdx;
 	void __iomem *intPend;
@@ -156,6 +165,7 @@ struct moxa_port {
 #define WAKEUP_CHARS		256
 
 static int ttymajor = MOXAMAJOR;
+static int moxaCard;
 /* Variables for insmod */
 #ifdef MODULE
 static unsigned long baseaddr[MAX_BOARDS];
@@ -208,7 +218,6 @@ static void moxa_receive_data(struct mox
 /*
  * moxa board interface functions:
  */
-static void MoxaDriverInit(void);
 static int MoxaDriverIoctl(unsigned int, unsigned long, int);
 static int MoxaDriverPoll(void);
 static int MoxaPortsOfCard(int);
@@ -263,6 +272,489 @@ static struct moxa_port moxa_ports[MAX_P
 static DEFINE_TIMER(moxaTimer, moxa_poll, 0, 0);
 static DEFINE_SPINLOCK(moxa_lock);
 
+static int moxa_check_fw_model(struct moxa_board_conf *brd, u8 model)
+{
+	switch (brd->boardType) {
+	case MOXA_BOARD_C218_ISA:
+	case MOXA_BOARD_C218_PCI:
+		if (model != 1)
+			goto err;
+		break;
+	case MOXA_BOARD_CP204J:
+		if (model != 3)
+			goto err;
+		break;
+	default:
+		if (model != 2)
+			goto err;
+		break;
+	}
+	return 0;
+err:
+	return -EINVAL;
+}
+
+static int moxa_check_fw(const void *ptr)
+{
+	const __le16 *lptr = ptr;
+
+	if (*lptr != cpu_to_le16(0x7980))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int moxa_load_bios(struct moxa_board_conf *brd, const u8 *buf,
+		size_t len)
+{
+	void __iomem *baseAddr = brd->basemem;
+	u16 tmp;
+
+	writeb(HW_reset, baseAddr + Control_reg);	/* reset */
+	msleep(10);
+	memset_io(baseAddr, 0, 4096);
+	memcpy_toio(baseAddr, buf, len);	/* download BIOS */
+	writeb(0, baseAddr + Control_reg);	/* restart */
+
+	msleep(2000);
+
+	switch (brd->boardType) {
+	case MOXA_BOARD_C218_ISA:
+	case MOXA_BOARD_C218_PCI:
+		tmp = readw(baseAddr + C218_key);
+		if (tmp != C218_KeyCode)
+			goto err;
+		break;
+	case MOXA_BOARD_CP204J:
+		tmp = readw(baseAddr + C218_key);
+		if (tmp != CP204J_KeyCode)
+			goto err;
+		break;
+	default:
+		tmp = readw(baseAddr + C320_key);
+		if (tmp != C320_KeyCode)
+			goto err;
+		tmp = readw(baseAddr + C320_status);
+		if (tmp != STS_init) {
+			printk(KERN_ERR "moxa: bios upload failed -- CPU/Basic "
+					"module not found\n");
+			return -EIO;
+		}
+		break;
+	}
+
+	return 0;
+err:
+	printk(KERN_ERR "moxa: bios upload failed -- board not found\n");
+	return -EIO;
+}
+
+static int moxa_load_320b(struct moxa_board_conf *brd, const u8 *ptr,
+		size_t len)
+{
+	void __iomem *baseAddr = brd->basemem;
+
+	if (len < 7168) {
+		printk(KERN_ERR "moxa: invalid 320 bios -- too short\n");
+		return -EINVAL;
+	}
+
+	writew(len - 7168 - 2, baseAddr + C320bapi_len);
+	writeb(1, baseAddr + Control_reg);	/* Select Page 1 */
+	memcpy_toio(baseAddr + DynPage_addr, ptr, 7168);
+	writeb(2, baseAddr + Control_reg);	/* Select Page 2 */
+	memcpy_toio(baseAddr + DynPage_addr, ptr + 7168, len - 7168);
+
+	return 0;
+}
+
+static int moxa_load_c218(struct moxa_board_conf *brd, const void *ptr,
+		size_t len)
+{
+	void __iomem *baseAddr = brd->basemem;
+	const u16 *uptr = ptr;
+	size_t wlen, len2, j;
+	unsigned int i, retry;
+	u16 usum, keycode;
+
+	if (brd->boardType == MOXA_BOARD_CP204J)
+		keycode = CP204J_KeyCode;
+	else
+		keycode = C218_KeyCode;
+	usum = 0;
+	wlen = len >> 1;
+	for (i = 0; i < wlen; i++)
+		usum += le16_to_cpu(uptr[i]);
+	retry = 0;
+	do {
+		wlen = len >> 1;
+		j = 0;
+		while (wlen) {
+			len2 = (wlen > 2048) ? 2048 : wlen;
+			wlen -= len2;
+			memcpy_toio(baseAddr + C218_LoadBuf, ptr + j,
+					len2 << 1);
+			j += len2 << 1;
+
+			writew(len2, baseAddr + C218DLoad_len);
+			writew(0, baseAddr + C218_key);
+			for (i = 0; i < 100; i++) {
+				if (readw(baseAddr + C218_key) == keycode)
+					break;
+				msleep(10);
+			}
+			if (readw(baseAddr + C218_key) != keycode)
+				return -EIO;
+		}
+		writew(0, baseAddr + C218DLoad_len);
+		writew(usum, baseAddr + C218check_sum);
+		writew(0, baseAddr + C218_key);
+		for (i = 0; i < 100; i++) {
+			if (readw(baseAddr + C218_key) == keycode)
+				break;
+			msleep(10);
+		}
+		retry++;
+	} while ((readb(baseAddr + C218chksum_ok) != 1) && (retry < 3));
+	if (readb(baseAddr + C218chksum_ok) != 1)
+		return -EIO;
+
+	writew(0, baseAddr + C218_key);
+	for (i = 0; i < 100; i++) {
+		if (readw(baseAddr + Magic_no) == Magic_code)
+			break;
+		msleep(10);
+	}
+	if (readw(baseAddr + Magic_no) != Magic_code)
+		return -EIO;
+
+	writew(1, baseAddr + Disable_IRQ);
+	writew(0, baseAddr + Magic_no);
+	for (i = 0; i < 100; i++) {
+		if (readw(baseAddr + Magic_no) == Magic_code)
+			break;
+		msleep(10);
+	}
+	if (readw(baseAddr + Magic_no) != Magic_code)
+		return -EIO;
+
+	moxaCard = 1;
+	brd->intNdx = baseAddr + IRQindex;
+	brd->intPend = baseAddr + IRQpending;
+	brd->intTable = baseAddr + IRQtable;
+
+	return 0;
+}
+
+static int moxa_load_c320(struct moxa_board_conf *brd, const void *ptr,
+		size_t len)
+{
+	void __iomem *baseAddr = brd->basemem;
+	const u16 *uptr = ptr;
+	size_t wlen, len2, j;
+	unsigned int i, retry;
+	u16 usum;
+
+	usum = 0;
+	wlen = len >> 1;
+	for (i = 0; i < wlen; i++)
+		usum += le16_to_cpu(uptr[i]);
+	retry = 0;
+	do {
+		wlen = len >> 1;
+		j = 0;
+		while (wlen) {
+			len2 = (wlen > 2048) ? 2048 : wlen;
+			wlen -= len2;
+			memcpy_toio(baseAddr + C320_LoadBuf, ptr + j,
+					len2 << 1);
+			j += len2 << 1;
+			writew(len2, baseAddr + C320DLoad_len);
+			writew(0, baseAddr + C320_key);
+			for (i = 0; i < 10; i++) {
+				if (readw(baseAddr + C320_key) == C320_KeyCode)
+					break;
+				msleep(10);
+			}
+			if (readw(baseAddr + C320_key) != C320_KeyCode)
+				return -EIO;
+		}
+		writew(0, baseAddr + C320DLoad_len);
+		writew(usum, baseAddr + C320check_sum);
+		writew(0, baseAddr + C320_key);
+		for (i = 0; i < 10; i++) {
+			if (readw(baseAddr + C320_key) == C320_KeyCode)
+				break;
+			msleep(10);
+		}
+		retry++;
+	} while ((readb(baseAddr + C320chksum_ok) != 1) && (retry < 3));
+	if (readb(baseAddr + C320chksum_ok) != 1)
+		return -EIO;
+
+	writew(0, baseAddr + C320_key);
+	for (i = 0; i < 600; i++) {
+		if (readw(baseAddr + Magic_no) == Magic_code)
+			break;
+		msleep(10);
+	}
+	if (readw(baseAddr + Magic_no) != Magic_code)
+		return -EIO;
+
+	if (brd->busType == MOXA_BUS_TYPE_PCI) {	/* ASIC board */
+		writew(0x3800, baseAddr + TMS320_PORT1);
+		writew(0x3900, baseAddr + TMS320_PORT2);
+		writew(28499, baseAddr + TMS320_CLOCK);
+	} else {
+		writew(0x3200, baseAddr + TMS320_PORT1);
+		writew(0x3400, baseAddr + TMS320_PORT2);
+		writew(19999, baseAddr + TMS320_CLOCK);
+	}
+	writew(1, baseAddr + Disable_IRQ);
+	writew(0, baseAddr + Magic_no);
+	for (i = 0; i < 500; i++) {
+		if (readw(baseAddr + Magic_no) == Magic_code)
+			break;
+		msleep(10);
+	}
+	if (readw(baseAddr + Magic_no) != Magic_code)
+		return -EIO;
+
+	j = readw(baseAddr + Module_cnt);
+	if (j <= 0)
+		return -EIO;
+	brd->numPorts = j * 8;
+	writew(j, baseAddr + Module_no);
+	writew(0, baseAddr + Magic_no);
+	for (i = 0; i < 600; i++) {
+		if (readw(baseAddr + Magic_no) == Magic_code)
+			break;
+		msleep(10);
+	}
+	if (readw(baseAddr + Magic_no) != Magic_code)
+		return -EIO;
+	moxaCard = 1;
+	brd->intNdx = baseAddr + IRQindex;
+	brd->intPend = baseAddr + IRQpending;
+	brd->intTable = baseAddr + IRQtable;
+
+	return 0;
+}
+
+static int moxa_load_code(struct moxa_board_conf *brd, const void *ptr,
+		size_t len)
+{
+	void __iomem *ofsAddr, *baseAddr = brd->basemem;
+	struct moxa_port *port;
+	int retval, i;
+
+	if (len % 2) {
+		printk(KERN_ERR "moxa: C2XX bios length is not even\n");
+		return -EINVAL;
+	}
+
+	switch (brd->boardType) {
+	case MOXA_BOARD_C218_ISA:
+	case MOXA_BOARD_C218_PCI:
+	case MOXA_BOARD_CP204J:
+		retval = moxa_load_c218(brd, ptr, len);
+		if (retval)
+			return retval;
+		port = brd->ports;
+		for (i = 0; i < brd->numPorts; i++, port++) {
+			port->chkPort = 1;
+			port->curBaud = 9600L;
+			port->DCDState = 0;
+			port->tableAddr = baseAddr + Extern_table +
+					Extern_size * i;
+			ofsAddr = port->tableAddr;
+			writew(C218rx_mask, ofsAddr + RX_mask);
+			writew(C218tx_mask, ofsAddr + TX_mask);
+			writew(C218rx_spage + i * C218buf_pageno, ofsAddr + Page_rxb);
+			writew(readw(ofsAddr + Page_rxb) + C218rx_pageno, ofsAddr + EndPage_rxb);
+
+			writew(C218tx_spage + i * C218buf_pageno, ofsAddr + Page_txb);
+			writew(readw(ofsAddr + Page_txb) + C218tx_pageno, ofsAddr + EndPage_txb);
+
+		}
+		break;
+	default:
+		retval = moxa_load_c320(brd, ptr, len); /* fills in numPorts */
+		if (retval)
+			return retval;
+		port = brd->ports;
+		for (i = 0; i < brd->numPorts; i++, port++) {
+			port->chkPort = 1;
+			port->curBaud = 9600L;
+			port->DCDState = 0;
+			port->tableAddr = baseAddr + Extern_table +
+					Extern_size * i;
+			ofsAddr = port->tableAddr;
+			switch (brd->numPorts) {
+			case 8:
+				writew(C320p8rx_mask, ofsAddr + RX_mask);
+				writew(C320p8tx_mask, ofsAddr + TX_mask);
+				writew(C320p8rx_spage + i * C320p8buf_pgno, ofsAddr + Page_rxb);
+				writew(readw(ofsAddr + Page_rxb) + C320p8rx_pgno, ofsAddr + EndPage_rxb);
+				writew(C320p8tx_spage + i * C320p8buf_pgno, ofsAddr + Page_txb);
+				writew(readw(ofsAddr + Page_txb) + C320p8tx_pgno, ofsAddr + EndPage_txb);
+
+				break;
+			case 16:
+				writew(C320p16rx_mask, ofsAddr + RX_mask);
+				writew(C320p16tx_mask, ofsAddr + TX_mask);
+				writew(C320p16rx_spage + i * C320p16buf_pgno, ofsAddr + Page_rxb);
+				writew(readw(ofsAddr + Page_rxb) + C320p16rx_pgno, ofsAddr + EndPage_rxb);
+				writew(C320p16tx_spage + i * C320p16buf_pgno, ofsAddr + Page_txb);
+				writew(readw(ofsAddr + Page_txb) + C320p16tx_pgno, ofsAddr + EndPage_txb);
+				break;
+
+			case 24:
+				writew(C320p24rx_mask, ofsAddr + RX_mask);
+				writew(C320p24tx_mask, ofsAddr + TX_mask);
+				writew(C320p24rx_spage + i * C320p24buf_pgno, ofsAddr + Page_rxb);
+				writew(readw(ofsAddr + Page_rxb) + C320p24rx_pgno, ofsAddr + EndPage_rxb);
+				writew(C320p24tx_spage + i * C320p24buf_pgno, ofsAddr + Page_txb);
+				writew(readw(ofsAddr + Page_txb), ofsAddr + EndPage_txb);
+				break;
+			case 32:
+				writew(C320p32rx_mask, ofsAddr + RX_mask);
+				writew(C320p32tx_mask, ofsAddr + TX_mask);
+				writew(C320p32tx_ofs, ofsAddr + Ofs_txb);
+				writew(C320p32rx_spage + i * C320p32buf_pgno, ofsAddr + Page_rxb);
+				writew(readb(ofsAddr + Page_rxb), ofsAddr + EndPage_rxb);
+				writew(C320p32tx_spage + i * C320p32buf_pgno, ofsAddr + Page_txb);
+				writew(readw(ofsAddr + Page_txb), ofsAddr + EndPage_txb);
+				break;
+			}
+		}
+		break;
+	}
+	brd->loadstat = 1;
+	return 0;
+}
+
+static int moxa_load_fw(struct moxa_board_conf *brd, const struct firmware *fw)
+{
+	void *ptr = fw->data;
+	char rsn[64];
+	u16 lens[5];
+	size_t len;
+	unsigned int a, lenp, lencnt;
+	int ret = -EINVAL;
+	struct {
+		__le32 magic;	/* 0x34303430 */
+		u8 reserved1[2];
+		u8 type;	/* UNIX = 3 */
+		u8 model;	/* C218T=1, C320T=2, CP204=3 */
+		u8 reserved2[8];
+		__le16 len[5];
+	} *hdr = ptr;
+
+	BUILD_BUG_ON(ARRAY_SIZE(hdr->len) != ARRAY_SIZE(lens));
+
+	if (fw->size < MOXA_FW_HDRLEN) {
+		strcpy(rsn, "too short (even header won't fit)");
+		goto err;
+	}
+	if (hdr->magic != cpu_to_le32(0x30343034)) {
+		sprintf(rsn, "bad magic: %.8x", le32_to_cpu(hdr->magic));
+		goto err;
+	}
+	if (hdr->type != 3) {
+		sprintf(rsn, "not for linux, type is %u", hdr->type);
+		goto err;
+	}
+	if (moxa_check_fw_model(brd, hdr->model)) {
+		sprintf(rsn, "not for this card, model is %u", hdr->model);
+		goto err;
+	}
+
+	len = MOXA_FW_HDRLEN;
+	lencnt = hdr->model == 2 ? 5 : 3;
+	for (a = 0; a < ARRAY_SIZE(lens); a++) {
+		lens[a] = le16_to_cpu(hdr->len[a]);
+		if (lens[a] && len + lens[a] <= fw->size &&
+				moxa_check_fw(&fw->data[len]))
+			printk(KERN_WARNING "moxa firmware: unexpected input "
+				"at offset %u, but going on\n", (u32)len);
+		if (!lens[a] && a < lencnt) {
+			sprintf(rsn, "too few entries in fw file");
+			goto err;
+		}
+		len += lens[a];
+	}
+
+	if (len != fw->size) {
+		sprintf(rsn, "bad length: %u (should be %u)", (u32)fw->size,
+				(u32)len);
+		goto err;
+	}
+
+	ptr += MOXA_FW_HDRLEN;
+	lenp = 0; /* bios */
+
+	strcpy(rsn, "read above");
+
+	ret = moxa_load_bios(brd, ptr, lens[lenp]);
+	if (ret)
+		goto err;
+
+	/* we skip the tty section (lens[1]), since we don't need it */
+	ptr += lens[lenp] + lens[lenp + 1];
+	lenp += 2; /* comm */
+
+	if (hdr->model == 2) {
+		ret = moxa_load_320b(brd, ptr, lens[lenp]);
+		if (ret)
+			goto err;
+		/* skip another tty */
+		ptr += lens[lenp] + lens[lenp + 1];
+		lenp += 2;
+	}
+
+	ret = moxa_load_code(brd, ptr, lens[lenp]);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	printk(KERN_ERR "firmware failed to load, reason: %s\n", rsn);
+	return ret;
+}
+
+static int moxa_init_board(struct moxa_board_conf *brd, struct device *dev)
+{
+	const struct firmware *fw;
+	const char *file;
+	int ret;
+
+	switch (brd->boardType) {
+	case MOXA_BOARD_C218_ISA:
+	case MOXA_BOARD_C218_PCI:
+		file = "c218tunx.cod";
+		break;
+	case MOXA_BOARD_CP204J:
+		file = "cp204unx.cod";
+		break;
+	default:
+		file = "c320tunx.cod";
+		break;
+	}
+
+	ret = request_firmware(&fw, file, dev);
+	if (ret) {
+		printk(KERN_ERR "request_firmware failed\n");
+		goto end;
+	}
+
+	ret = moxa_load_fw(brd, fw);
+
+	release_firmware(fw);
+end:
+	return ret;
+}
+
 #ifdef CONFIG_PCI
 static int __devinit moxa_pci_probe(struct pci_dev *pdev,
 		const struct pci_device_id *ent)
@@ -290,6 +782,7 @@ static int __devinit moxa_pci_probe(stru
 	}
 
 	board = &moxa_boards[i];
+	board->ports = &moxa_ports[i * MAX_PORTS_PER_BOARD];
 
 	retval = pci_request_region(pdev, 2, "moxa-base");
 	if (retval) {
@@ -319,9 +812,16 @@ static int __devinit moxa_pci_probe(stru
 	}
 	board->busType = MOXA_BUS_TYPE_PCI;
 
+	retval = moxa_init_board(board, &pdev->dev);
+	if (retval)
+		goto err_base;
+
 	pci_set_drvdata(pdev, board);
 
 	return (0);
+err_base:
+	iounmap(board->basemem);
+	board->basemem = NULL;
 err_reg:
 	pci_release_region(pdev, 2);
 err:
@@ -406,6 +906,7 @@ static int __init moxa_init(void)
 					isabrds + 1, moxa_brdname[type[i] - 1],
 					baseaddr[i]);
 			brd->boardType = type[i];
+			brd->ports = &moxa_ports[isabrds * MAX_PORTS_PER_BOARD];
 			brd->numPorts = type[i] == MOXA_BOARD_C218_ISA ? 8 :
 					numports[i];
 			brd->busType = MOXA_BUS_TYPE_ISA;
@@ -415,6 +916,11 @@ static int __init moxa_init(void)
 						baseaddr[i]);
 				continue;
 			}
+			if (moxa_init_board(brd, NULL)) {
+				iounmap(brd->basemem);
+				brd->basemem = NULL;
+				continue;
+			}
 
 			brd++;
 			isabrds++;
@@ -1062,308 +1568,17 @@ static void moxa_receive_data(struct mox
 	if (tp)
 		ts = tp->termios;
 	/**************************************************
-	if ( !tp || !ts || !(ts->c_cflag & CREAD) ) {
-	*****************************************************/
-	if (!tp || !ts) {
-		MoxaPortFlushData(ch->port, 0);
-		return;
-	}
-	spin_lock_irqsave(&moxa_lock, flags);
-	MoxaPortReadData(ch->port, tp);
-	spin_unlock_irqrestore(&moxa_lock, flags);
-	tty_schedule_flip(tp);
-}
-
-#define Magic_code	0x404
-
-/*
- *    System Configuration
- */
-/*
- *    for C218 BIOS initialization
- */
-#define C218_ConfBase	0x800
-#define C218_status	(C218_ConfBase + 0)	/* BIOS running status    */
-#define C218_diag	(C218_ConfBase + 2)	/* diagnostic status      */
-#define C218_key	(C218_ConfBase + 4)	/* WORD (0x218 for C218) */
-#define C218DLoad_len	(C218_ConfBase + 6)	/* WORD           */
-#define C218check_sum	(C218_ConfBase + 8)	/* BYTE           */
-#define C218chksum_ok	(C218_ConfBase + 0x0a)	/* BYTE (1:ok)            */
-#define C218_TestRx	(C218_ConfBase + 0x10)	/* 8 bytes for 8 ports    */
-#define C218_TestTx	(C218_ConfBase + 0x18)	/* 8 bytes for 8 ports    */
-#define C218_RXerr	(C218_ConfBase + 0x20)	/* 8 bytes for 8 ports    */
-#define C218_ErrFlag	(C218_ConfBase + 0x28)	/* 8 bytes for 8 ports    */
-
-#define C218_LoadBuf	0x0F00
-#define C218_KeyCode	0x218
-#define CP204J_KeyCode	0x204
-
-/*
- *    for C320 BIOS initialization
- */
-#define C320_ConfBase	0x800
-#define C320_LoadBuf	0x0f00
-#define STS_init	0x05	/* for C320_status        */
-
-#define C320_status	C320_ConfBase + 0	/* BIOS running status    */
-#define C320_diag	C320_ConfBase + 2	/* diagnostic status      */
-#define C320_key	C320_ConfBase + 4	/* WORD (0320H for C320) */
-#define C320DLoad_len	C320_ConfBase + 6	/* WORD           */
-#define C320check_sum	C320_ConfBase + 8	/* WORD           */
-#define C320chksum_ok	C320_ConfBase + 0x0a	/* WORD (1:ok)            */
-#define C320bapi_len	C320_ConfBase + 0x0c	/* WORD           */
-#define C320UART_no	C320_ConfBase + 0x0e	/* WORD           */
-
-#define C320_KeyCode	0x320
-
-#define FixPage_addr	0x0000	/* starting addr of static page  */
-#define DynPage_addr	0x2000	/* starting addr of dynamic page */
-#define C218_start	0x3000	/* starting addr of C218 BIOS prg */
-#define Control_reg	0x1ff0	/* select page and reset control */
-#define HW_reset	0x80
-
-/*
- *    Function Codes
- */
-#define FC_CardReset	0x80
-#define FC_ChannelReset 1	/* C320 firmware not supported */
-#define FC_EnableCH	2
-#define FC_DisableCH	3
-#define FC_SetParam	4
-#define FC_SetMode	5
-#define FC_SetRate	6
-#define FC_LineControl	7
-#define FC_LineStatus	8
-#define FC_XmitControl	9
-#define FC_FlushQueue	10
-#define FC_SendBreak	11
-#define FC_StopBreak	12
-#define FC_LoopbackON	13
-#define FC_LoopbackOFF	14
-#define FC_ClrIrqTable	15
-#define FC_SendXon	16
-#define FC_SetTermIrq	17	/* C320 firmware not supported */
-#define FC_SetCntIrq	18	/* C320 firmware not supported */
-#define FC_SetBreakIrq	19
-#define FC_SetLineIrq	20
-#define FC_SetFlowCtl	21
-#define FC_GenIrq	22
-#define FC_InCD180	23
-#define FC_OutCD180	24
-#define FC_InUARTreg	23
-#define FC_OutUARTreg	24
-#define FC_SetXonXoff	25
-#define FC_OutCD180CCR	26
-#define FC_ExtIQueue	27
-#define FC_ExtOQueue	28
-#define FC_ClrLineIrq	29
-#define FC_HWFlowCtl	30
-#define FC_GetClockRate 35
-#define FC_SetBaud	36
-#define FC_SetDataMode  41
-#define FC_GetCCSR      43
-#define FC_GetDataError 45
-#define FC_RxControl	50
-#define FC_ImmSend	51
-#define FC_SetXonState	52
-#define FC_SetXoffState	53
-#define FC_SetRxFIFOTrig 54
-#define FC_SetTxFIFOCnt 55
-#define FC_UnixRate	56
-#define FC_UnixResetTimer 57
-
-#define	RxFIFOTrig1	0
-#define	RxFIFOTrig4	1
-#define	RxFIFOTrig8	2
-#define	RxFIFOTrig14	3
-
-/*
- *    Dual-Ported RAM
- */
-#define DRAM_global	0
-#define INT_data	(DRAM_global + 0)
-#define Config_base	(DRAM_global + 0x108)
-
-#define IRQindex	(INT_data + 0)
-#define IRQpending	(INT_data + 4)
-#define IRQtable	(INT_data + 8)
-
-/*
- *    Interrupt Status
- */
-#define IntrRx		0x01	/* receiver data O.K.             */
-#define IntrTx		0x02	/* transmit buffer empty  */
-#define IntrFunc	0x04	/* function complete              */
-#define IntrBreak	0x08	/* received break         */
-#define IntrLine	0x10	/* line status change
-				   for transmitter                */
-#define IntrIntr	0x20	/* received INTR code             */
-#define IntrQuit	0x40	/* received QUIT code             */
-#define IntrEOF 	0x80	/* received EOF code              */
-
-#define IntrRxTrigger 	0x100	/* rx data count reach tigger value */
-#define IntrTxTrigger 	0x200	/* tx data count below trigger value */
-
-#define Magic_no	(Config_base + 0)
-#define Card_model_no	(Config_base + 2)
-#define Total_ports	(Config_base + 4)
-#define Module_cnt	(Config_base + 8)
-#define Module_no	(Config_base + 10)
-#define Timer_10ms	(Config_base + 14)
-#define Disable_IRQ	(Config_base + 20)
-#define TMS320_PORT1	(Config_base + 22)
-#define TMS320_PORT2	(Config_base + 24)
-#define TMS320_CLOCK	(Config_base + 26)
-
-/*
- *    DATA BUFFER in DRAM
- */
-#define Extern_table	0x400	/* Base address of the external table
-				   (24 words *    64) total 3K bytes
-				   (24 words * 128) total 6K bytes */
-#define Extern_size	0x60	/* 96 bytes                       */
-#define RXrptr		0x00	/* read pointer for RX buffer     */
-#define RXwptr		0x02	/* write pointer for RX buffer    */
-#define TXrptr		0x04	/* read pointer for TX buffer     */
-#define TXwptr		0x06	/* write pointer for TX buffer    */
-#define HostStat	0x08	/* IRQ flag and general flag      */
-#define FlagStat	0x0A
-#define FlowControl	0x0C	/* B7 B6 B5 B4 B3 B2 B1 B0              */
-					/*  x  x  x  x  |  |  |  |            */
-					/*              |  |  |  + CTS flow   */
-					/*              |  |  +--- RTS flow   */
-					/*              |  +------ TX Xon/Xoff */
-					/*              +--------- RX Xon/Xoff */
-#define Break_cnt	0x0E	/* received break count   */
-#define CD180TXirq	0x10	/* if non-0: enable TX irq        */
-#define RX_mask 	0x12
-#define TX_mask 	0x14
-#define Ofs_rxb 	0x16
-#define Ofs_txb 	0x18
-#define Page_rxb	0x1A
-#define Page_txb	0x1C
-#define EndPage_rxb	0x1E
-#define EndPage_txb	0x20
-#define Data_error	0x22
-#define RxTrigger	0x28
-#define TxTrigger	0x2a
-
-#define rRXwptr 	0x34
-#define Low_water	0x36
-
-#define FuncCode	0x40
-#define FuncArg 	0x42
-#define FuncArg1	0x44
-
-#define C218rx_size	0x2000	/* 8K bytes */
-#define C218tx_size	0x8000	/* 32K bytes */
-
-#define C218rx_mask	(C218rx_size - 1)
-#define C218tx_mask	(C218tx_size - 1)
-
-#define C320p8rx_size	0x2000
-#define C320p8tx_size	0x8000
-#define C320p8rx_mask	(C320p8rx_size - 1)
-#define C320p8tx_mask	(C320p8tx_size - 1)
-
-#define C320p16rx_size	0x2000
-#define C320p16tx_size	0x4000
-#define C320p16rx_mask	(C320p16rx_size - 1)
-#define C320p16tx_mask	(C320p16tx_size - 1)
-
-#define C320p24rx_size	0x2000
-#define C320p24tx_size	0x2000
-#define C320p24rx_mask	(C320p24rx_size - 1)
-#define C320p24tx_mask	(C320p24tx_size - 1)
-
-#define C320p32rx_size	0x1000
-#define C320p32tx_size	0x1000
-#define C320p32rx_mask	(C320p32rx_size - 1)
-#define C320p32tx_mask	(C320p32tx_size - 1)
-
-#define Page_size	0x2000
-#define Page_mask	(Page_size - 1)
-#define C218rx_spage	3
-#define C218tx_spage	4
-#define C218rx_pageno	1
-#define C218tx_pageno	4
-#define C218buf_pageno	5
-
-#define C320p8rx_spage	3
-#define C320p8tx_spage	4
-#define C320p8rx_pgno	1
-#define C320p8tx_pgno	4
-#define C320p8buf_pgno	5
-
-#define C320p16rx_spage 3
-#define C320p16tx_spage 4
-#define C320p16rx_pgno	1
-#define C320p16tx_pgno	2
-#define C320p16buf_pgno 3
-
-#define C320p24rx_spage 3
-#define C320p24tx_spage 4
-#define C320p24rx_pgno	1
-#define C320p24tx_pgno	1
-#define C320p24buf_pgno 2
-
-#define C320p32rx_spage 3
-#define C320p32tx_ofs	C320p32rx_size
-#define C320p32tx_spage 3
-#define C320p32buf_pgno 1
-
-/*
- *    Host Status
- */
-#define WakeupRx	0x01
-#define WakeupTx	0x02
-#define WakeupBreak	0x08
-#define WakeupLine	0x10
-#define WakeupIntr	0x20
-#define WakeupQuit	0x40
-#define WakeupEOF	0x80	/* used in VTIME control */
-#define WakeupRxTrigger	0x100
-#define WakeupTxTrigger	0x200
-/*
- *    Flag status
- */
-#define Rx_over		0x01
-#define Xoff_state	0x02
-#define Tx_flowOff	0x04
-#define Tx_enable	0x08
-#define CTS_state	0x10
-#define DSR_state	0x20
-#define DCD_state	0x80
-/*
- *    FlowControl
- */
-#define CTS_FlowCtl	1
-#define RTS_FlowCtl	2
-#define Tx_FlowCtl	4
-#define Rx_FlowCtl	8
-#define IXM_IXANY	0x10
-
-#define LowWater	128
-
-#define DTR_ON		1
-#define RTS_ON		2
-#define CTS_ON		1
-#define DSR_ON		2
-#define DCD_ON		8
-
-/* mode definition */
-#define	MX_CS8		0x03
-#define	MX_CS7		0x02
-#define	MX_CS6		0x01
-#define	MX_CS5		0x00
-
-#define	MX_STOP1	0x00
-#define	MX_STOP15	0x04
-#define	MX_STOP2	0x08
-
-#define	MX_PARNONE	0x00
-#define	MX_PAREVEN	0x40
-#define	MX_PARODD	0xC0
+	if ( !tp || !ts || !(ts->c_cflag & CREAD) ) {
+	*****************************************************/
+	if (!tp || !ts) {
+		MoxaPortFlushData(ch->port, 0);
+		return;
+	}
+	spin_lock_irqsave(&moxa_lock, flags);
+	MoxaPortReadData(ch->port, tp);
+	spin_unlock_irqrestore(&moxa_lock, flags);
+	tty_schedule_flip(tp);
+}
 
 /*
  *    Query
@@ -1378,55 +1593,22 @@ struct mon_str {
 #define 	DCD_changed	0x01
 #define 	DCD_oldstate	0x80
 
-static unsigned char moxaBuff[10240];
 static int moxaLowWaterChk;
-static int moxaCard;
 static struct mon_str moxaLog;
 static int moxaFuncTout = HZ / 2;
 
 static void moxafunc(void __iomem *, int, ushort);
 static void moxa_wait_finish(void __iomem *);
 static void moxa_low_water_check(void __iomem *);
-static int moxaloadbios(int, unsigned char __user *, int);
-static int moxafindcard(int);
-static int moxaload320b(int, unsigned char __user *, int);
-static int moxaloadcode(int, unsigned char __user *, int);
-static int moxaloadc218(int, void __iomem *, int);
-static int moxaloadc320(int, void __iomem *, int, int *);
 
 /*****************************************************************************
  *	Driver level functions: 					     *
- *	1. MoxaDriverInit(void);					     *
  *	2. MoxaDriverIoctl(unsigned int cmd, unsigned long arg, int port);   *
  *	3. MoxaDriverPoll(void);					     *
  *****************************************************************************/
-void MoxaDriverInit(void)
-{
-	struct moxa_port *p;
-	unsigned int i;
-
-	moxaFuncTout = HZ / 2;	/* 500 mini-seconds */
-	moxaCard = 0;
-	moxaLog.tick = 0;
-	moxaLowWaterChk = 0;
-	for (i = 0; i < MAX_PORTS; i++) {
-		p = &moxa_ports[i];
-		p->chkPort = 0;
-		p->lowChkFlag = 0;
-		p->lineCtrl = 0;
-		moxaLog.rxcnt[i] = 0;
-		moxaLog.txcnt[i] = 0;
-	}
-}
-
 #define	MOXA		0x400
 #define MOXA_GET_IQUEUE 	(MOXA + 1)	/* get input buffered count */
 #define MOXA_GET_OQUEUE 	(MOXA + 2)	/* get output buffered count */
-#define MOXA_INIT_DRIVER	(MOXA + 6)	/* moxaCard=0 */
-#define MOXA_LOAD_BIOS		(MOXA + 9)	/* download BIOS */
-#define MOXA_FIND_BOARD		(MOXA + 10)	/* Check if MOXA card exist? */
-#define MOXA_LOAD_C320B		(MOXA + 11)	/* download 320B firmware */
-#define MOXA_LOAD_CODE		(MOXA + 12)	/* download firmware */
 #define MOXA_GETDATACOUNT       (MOXA + 23)
 #define MOXA_GET_IOQUEUE	(MOXA + 27)
 #define MOXA_FLUSH_QUEUE	(MOXA + 28)
@@ -1435,14 +1617,6 @@ void MoxaDriverInit(void)
 #define MOXA_GET_CUMAJOR        (MOXA + 64)
 #define MOXA_GETMSTATUS         (MOXA + 65)
 
-struct dl_str {
-	char __user *buf;
-	int len;
-	int cardno;
-};
-
-static struct dl_str dltmp;
-
 void MoxaPortFlushData(int port, int mode)
 {
 	void __iomem *ofsAddr;
@@ -1464,23 +1638,12 @@ int MoxaDriverIoctl(unsigned int cmd, un
 	void __user *argp = (void __user *)arg;
 
 	if (port == MAX_PORTS) {
-		if ((cmd != MOXA_GET_CONF) && (cmd != MOXA_INIT_DRIVER) &&
-		    (cmd != MOXA_LOAD_BIOS) && (cmd != MOXA_FIND_BOARD) && (cmd != MOXA_LOAD_C320B) &&
-		 (cmd != MOXA_LOAD_CODE) && (cmd != MOXA_GETDATACOUNT) &&
-		  (cmd != MOXA_GET_IOQUEUE) && (cmd != MOXA_GET_MAJOR) &&
+		if ((cmd != MOXA_GET_CONF) && (cmd != MOXA_GETDATACOUNT) &&
+		    (cmd != MOXA_GET_IOQUEUE) && (cmd != MOXA_GET_MAJOR) &&
 		    (cmd != MOXA_GET_CUMAJOR) && (cmd != MOXA_GETMSTATUS))
 			return (-EINVAL);
 	}
 	switch (cmd) {
-	case MOXA_GET_CONF:
-		if(copy_to_user(argp, &moxa_boards, MAX_BOARDS *
-				sizeof(struct moxa_board_conf)))
-			return -EFAULT;
-		return (0);
-	case MOXA_INIT_DRIVER:
-		if ((int) arg == 0x404)
-			MoxaDriverInit();
-		return (0);
 	case MOXA_GETDATACOUNT:
 		moxaLog.tick = jiffies;
 		if(copy_to_user(argp, &moxaLog, sizeof(struct mon_str)))
@@ -1547,40 +1710,10 @@ copy:
 				return -EFAULT;
 		}
 		return 0;
-	} default:
-		return (-ENOIOCTLCMD);
-	case MOXA_LOAD_BIOS:
-	case MOXA_FIND_BOARD:
-	case MOXA_LOAD_C320B:
-	case MOXA_LOAD_CODE:
-		if (!capable(CAP_SYS_RAWIO))
-			return -EPERM;
-		break;
 	}
-
-	if(copy_from_user(&dltmp, argp, sizeof(struct dl_str)))
-		return -EFAULT;
-	if(dltmp.cardno < 0 || dltmp.cardno >= MAX_BOARDS || dltmp.len < 0)
-		return -EINVAL;
-
-	switch(cmd)
-	{
-	case MOXA_LOAD_BIOS:
-		i = moxaloadbios(dltmp.cardno, dltmp.buf, dltmp.len);
-		return (i);
-	case MOXA_FIND_BOARD:
-		return moxafindcard(dltmp.cardno);
-	case MOXA_LOAD_C320B:
-		moxaload320b(dltmp.cardno, dltmp.buf, dltmp.len);
-	default: /* to keep gcc happy */
-		return (0);
-	case MOXA_LOAD_CODE:
-		i = moxaloadcode(dltmp.cardno, dltmp.buf, dltmp.len);
-		if (i == -1)
-			return (-EFAULT);
-		return (i);
-
 	}
+
+	return -ENOIOCTLCMD;
 }
 
 int MoxaDriverPoll(void)
@@ -1935,7 +2068,6 @@ int MoxaPortsOfCard(int cardno)
  */
 int MoxaPortIsValid(int port)
 {
-
 	if (moxaCard == 0)
 		return (0);
 	if (moxa_ports[port].chkPort == 0)
@@ -2490,335 +2622,6 @@ static void moxa_low_water_check(void __
 	}
 }
 
-static int moxaloadbios(int cardno, unsigned char __user *tmp, int len)
-{
-	void __iomem *baseAddr;
-	int i;
-
-	if(len < 0 || len > sizeof(moxaBuff))
-		return -EINVAL;
-	if(copy_from_user(moxaBuff, tmp, len))
-		return -EFAULT;
-	baseAddr = moxa_boards[cardno].basemem;
-	writeb(HW_reset, baseAddr + Control_reg);	/* reset */
-	msleep(10);
-	for (i = 0; i < 4096; i++)
-		writeb(0, baseAddr + i);	/* clear fix page */
-	for (i = 0; i < len; i++)
-		writeb(moxaBuff[i], baseAddr + i);	/* download BIOS */
-	writeb(0, baseAddr + Control_reg);	/* restart */
-	return (0);
-}
-
-static int moxafindcard(int cardno)
-{
-	void __iomem *baseAddr;
-	ushort tmp;
-
-	baseAddr = moxa_boards[cardno].basemem;
-	switch (moxa_boards[cardno].boardType) {
-	case MOXA_BOARD_C218_ISA:
-	case MOXA_BOARD_C218_PCI:
-		if ((tmp = readw(baseAddr + C218_key)) != C218_KeyCode) {
-			return (-1);
-		}
-		break;
-	case MOXA_BOARD_CP204J:
-		if ((tmp = readw(baseAddr + C218_key)) != CP204J_KeyCode) {
-			return (-1);
-		}
-		break;
-	default:
-		if ((tmp = readw(baseAddr + C320_key)) != C320_KeyCode) {
-			return (-1);
-		}
-		if ((tmp = readw(baseAddr + C320_status)) != STS_init) {
-			return (-2);
-		}
-	}
-	return (0);
-}
-
-static int moxaload320b(int cardno, unsigned char __user *tmp, int len)
-{
-	void __iomem *baseAddr;
-	int i;
-
-	if(len < 0 || len > sizeof(moxaBuff))
-		return -EINVAL;
-	if(copy_from_user(moxaBuff, tmp, len))
-		return -EFAULT;
-	baseAddr = moxa_boards[cardno].basemem;
-	writew(len - 7168 - 2, baseAddr + C320bapi_len);
-	writeb(1, baseAddr + Control_reg);	/* Select Page 1 */
-	for (i = 0; i < 7168; i++)
-		writeb(moxaBuff[i], baseAddr + DynPage_addr + i);
-	writeb(2, baseAddr + Control_reg);	/* Select Page 2 */
-	for (i = 0; i < (len - 7168); i++)
-		writeb(moxaBuff[i + 7168], baseAddr + DynPage_addr + i);
-	return (0);
-}
-
-static int moxaloadcode(int cardno, unsigned char __user *tmp, int len)
-{
-	void __iomem *baseAddr, *ofsAddr;
-	int retval, port, i;
-
-	if(len < 0 || len > sizeof(moxaBuff))
-		return -EINVAL;
-	if(copy_from_user(moxaBuff, tmp, len))
-		return -EFAULT;
-	baseAddr = moxa_boards[cardno].basemem;
-	switch (moxa_boards[cardno].boardType) {
-	case MOXA_BOARD_C218_ISA:
-	case MOXA_BOARD_C218_PCI:
-	case MOXA_BOARD_CP204J:
-		retval = moxaloadc218(cardno, baseAddr, len);
-		if (retval)
-			return (retval);
-		port = cardno * MAX_PORTS_PER_BOARD;
-		for (i = 0; i < moxa_boards[cardno].numPorts; i++, port++) {
-			struct moxa_port *p = &moxa_ports[port];
-
-			p->chkPort = 1;
-			p->curBaud = 9600L;
-			p->DCDState = 0;
-			p->tableAddr = baseAddr + Extern_table + Extern_size * i;
-			ofsAddr = p->tableAddr;
-			writew(C218rx_mask, ofsAddr + RX_mask);
-			writew(C218tx_mask, ofsAddr + TX_mask);
-			writew(C218rx_spage + i * C218buf_pageno, ofsAddr + Page_rxb);
-			writew(readw(ofsAddr + Page_rxb) + C218rx_pageno, ofsAddr + EndPage_rxb);
-
-			writew(C218tx_spage + i * C218buf_pageno, ofsAddr + Page_txb);
-			writew(readw(ofsAddr + Page_txb) + C218tx_pageno, ofsAddr + EndPage_txb);
-
-		}
-		break;
-	default:
-		retval = moxaloadc320(cardno, baseAddr, len,
-				      &moxa_boards[cardno].numPorts);
-		if (retval)
-			return (retval);
-		port = cardno * MAX_PORTS_PER_BOARD;
-		for (i = 0; i < moxa_boards[cardno].numPorts; i++, port++) {
-			struct moxa_port *p = &moxa_ports[port];
-
-			p->chkPort = 1;
-			p->curBaud = 9600L;
-			p->DCDState = 0;
-			p->tableAddr = baseAddr + Extern_table + Extern_size * i;
-			ofsAddr = p->tableAddr;
-			if (moxa_boards[cardno].numPorts == 8) {
-				writew(C320p8rx_mask, ofsAddr + RX_mask);
-				writew(C320p8tx_mask, ofsAddr + TX_mask);
-				writew(C320p8rx_spage + i * C320p8buf_pgno, ofsAddr + Page_rxb);
-				writew(readw(ofsAddr + Page_rxb) + C320p8rx_pgno, ofsAddr + EndPage_rxb);
-				writew(C320p8tx_spage + i * C320p8buf_pgno, ofsAddr + Page_txb);
-				writew(readw(ofsAddr + Page_txb) + C320p8tx_pgno, ofsAddr + EndPage_txb);
-
-			} else if (moxa_boards[cardno].numPorts == 16) {
-				writew(C320p16rx_mask, ofsAddr + RX_mask);
-				writew(C320p16tx_mask, ofsAddr + TX_mask);
-				writew(C320p16rx_spage + i * C320p16buf_pgno, ofsAddr + Page_rxb);
-				writew(readw(ofsAddr + Page_rxb) + C320p16rx_pgno, ofsAddr + EndPage_rxb);
-				writew(C320p16tx_spage + i * C320p16buf_pgno, ofsAddr + Page_txb);
-				writew(readw(ofsAddr + Page_txb) + C320p16tx_pgno, ofsAddr + EndPage_txb);
-
-			} else if (moxa_boards[cardno].numPorts == 24) {
-				writew(C320p24rx_mask, ofsAddr + RX_mask);
-				writew(C320p24tx_mask, ofsAddr + TX_mask);
-				writew(C320p24rx_spage + i * C320p24buf_pgno, ofsAddr + Page_rxb);
-				writew(readw(ofsAddr + Page_rxb) + C320p24rx_pgno, ofsAddr + EndPage_rxb);
-				writew(C320p24tx_spage + i * C320p24buf_pgno, ofsAddr + Page_txb);
-				writew(readw(ofsAddr + Page_txb), ofsAddr + EndPage_txb);
-			} else if (moxa_boards[cardno].numPorts == 32) {
-				writew(C320p32rx_mask, ofsAddr + RX_mask);
-				writew(C320p32tx_mask, ofsAddr + TX_mask);
-				writew(C320p32tx_ofs, ofsAddr + Ofs_txb);
-				writew(C320p32rx_spage + i * C320p32buf_pgno, ofsAddr + Page_rxb);
-				writew(readb(ofsAddr + Page_rxb), ofsAddr + EndPage_rxb);
-				writew(C320p32tx_spage + i * C320p32buf_pgno, ofsAddr + Page_txb);
-				writew(readw(ofsAddr + Page_txb), ofsAddr + EndPage_txb);
-			}
-		}
-		break;
-	}
-	moxa_boards[cardno].loadstat = 1;
-	return (0);
-}
-
-static int moxaloadc218(int cardno, void __iomem *baseAddr, int len)
-{
-	char retry;
-	int i, j, len1, len2;
-	ushort usum, *ptr, keycode;
-
-	if (moxa_boards[cardno].boardType == MOXA_BOARD_CP204J)
-		keycode = CP204J_KeyCode;
-	else
-		keycode = C218_KeyCode;
-	usum = 0;
-	len1 = len >> 1;
-	ptr = (ushort *) moxaBuff;
-	for (i = 0; i < len1; i++)
-		usum += le16_to_cpu(*(ptr + i));
-	retry = 0;
-	do {
-		len1 = len >> 1;
-		j = 0;
-		while (len1) {
-			len2 = (len1 > 2048) ? 2048 : len1;
-			len1 -= len2;
-			for (i = 0; i < len2 << 1; i++)
-				writeb(moxaBuff[i + j], baseAddr + C218_LoadBuf + i);
-			j += i;
-
-			writew(len2, baseAddr + C218DLoad_len);
-			writew(0, baseAddr + C218_key);
-			for (i = 0; i < 100; i++) {
-				if (readw(baseAddr + C218_key) == keycode)
-					break;
-				msleep(10);
-			}
-			if (readw(baseAddr + C218_key) != keycode) {
-				return (-1);
-			}
-		}
-		writew(0, baseAddr + C218DLoad_len);
-		writew(usum, baseAddr + C218check_sum);
-		writew(0, baseAddr + C218_key);
-		for (i = 0; i < 100; i++) {
-			if (readw(baseAddr + C218_key) == keycode)
-				break;
-			msleep(10);
-		}
-		retry++;
-	} while ((readb(baseAddr + C218chksum_ok) != 1) && (retry < 3));
-	if (readb(baseAddr + C218chksum_ok) != 1) {
-		return (-1);
-	}
-	writew(0, baseAddr + C218_key);
-	for (i = 0; i < 100; i++) {
-		if (readw(baseAddr + Magic_no) == Magic_code)
-			break;
-		msleep(10);
-	}
-	if (readw(baseAddr + Magic_no) != Magic_code) {
-		return (-1);
-	}
-	writew(1, baseAddr + Disable_IRQ);
-	writew(0, baseAddr + Magic_no);
-	for (i = 0; i < 100; i++) {
-		if (readw(baseAddr + Magic_no) == Magic_code)
-			break;
-		msleep(10);
-	}
-	if (readw(baseAddr + Magic_no) != Magic_code) {
-		return (-1);
-	}
-	moxaCard = 1;
-	moxa_boards[cardno].intNdx = baseAddr + IRQindex;
-	moxa_boards[cardno].intPend = baseAddr + IRQpending;
-	moxa_boards[cardno].intTable = baseAddr + IRQtable;
-	return (0);
-}
-
-static int moxaloadc320(int cardno, void __iomem *baseAddr, int len, int *numPorts)
-{
-	ushort usum;
-	int i, j, wlen, len2, retry;
-	ushort *uptr;
-
-	usum = 0;
-	wlen = len >> 1;
-	uptr = (ushort *) moxaBuff;
-	for (i = 0; i < wlen; i++)
-		usum += le16_to_cpu(uptr[i]);
-	retry = 0;
-	j = 0;
-	do {
-		while (wlen) {
-			if (wlen > 2048)
-				len2 = 2048;
-			else
-				len2 = wlen;
-			wlen -= len2;
-			len2 <<= 1;
-			for (i = 0; i < len2; i++)
-				writeb(moxaBuff[j + i], baseAddr + C320_LoadBuf + i);
-			len2 >>= 1;
-			j += i;
-			writew(len2, baseAddr + C320DLoad_len);
-			writew(0, baseAddr + C320_key);
-			for (i = 0; i < 10; i++) {
-				if (readw(baseAddr + C320_key) == C320_KeyCode)
-					break;
-				msleep(10);
-			}
-			if (readw(baseAddr + C320_key) != C320_KeyCode)
-				return (-1);
-		}
-		writew(0, baseAddr + C320DLoad_len);
-		writew(usum, baseAddr + C320check_sum);
-		writew(0, baseAddr + C320_key);
-		for (i = 0; i < 10; i++) {
-			if (readw(baseAddr + C320_key) == C320_KeyCode)
-				break;
-			msleep(10);
-		}
-		retry++;
-	} while ((readb(baseAddr + C320chksum_ok) != 1) && (retry < 3));
-	if (readb(baseAddr + C320chksum_ok) != 1)
-		return (-1);
-	writew(0, baseAddr + C320_key);
-	for (i = 0; i < 600; i++) {
-		if (readw(baseAddr + Magic_no) == Magic_code)
-			break;
-		msleep(10);
-	}
-	if (readw(baseAddr + Magic_no) != Magic_code)
-		return (-100);
-
-	if (moxa_boards[cardno].busType == MOXA_BUS_TYPE_PCI) {		/* ASIC board */
-		writew(0x3800, baseAddr + TMS320_PORT1);
-		writew(0x3900, baseAddr + TMS320_PORT2);
-		writew(28499, baseAddr + TMS320_CLOCK);
-	} else {
-		writew(0x3200, baseAddr + TMS320_PORT1);
-		writew(0x3400, baseAddr + TMS320_PORT2);
-		writew(19999, baseAddr + TMS320_CLOCK);
-	}
-	writew(1, baseAddr + Disable_IRQ);
-	writew(0, baseAddr + Magic_no);
-	for (i = 0; i < 500; i++) {
-		if (readw(baseAddr + Magic_no) == Magic_code)
-			break;
-		msleep(10);
-	}
-	if (readw(baseAddr + Magic_no) != Magic_code)
-		return (-102);
-
-	j = readw(baseAddr + Module_cnt);
-	if (j <= 0)
-		return (-101);
-	*numPorts = j * 8;
-	writew(j, baseAddr + Module_no);
-	writew(0, baseAddr + Magic_no);
-	for (i = 0; i < 600; i++) {
-		if (readw(baseAddr + Magic_no) == Magic_code)
-			break;
-		msleep(10);
-	}
-	if (readw(baseAddr + Magic_no) != Magic_code)
-		return (-102);
-	moxaCard = 1;
-	moxa_boards[cardno].intNdx = baseAddr + IRQindex;
-	moxa_boards[cardno].intPend = baseAddr + IRQpending;
-	moxa_boards[cardno].intTable = baseAddr + IRQtable;
-	return (0);
-}
-
 static void MoxaSetFifo(int port, int enable)
 {
 	void __iomem *ofsAddr = moxa_ports[port].tableAddr;
diff -puN /dev/null drivers/char/moxa.h
--- /dev/null
+++ a/drivers/char/moxa.h
@@ -0,0 +1,296 @@
+#ifndef MOXA_H_FILE
+#define MOXA_H_FILE
+
+/*
+ *    System Configuration
+ */
+
+#define Magic_code	0x404
+
+/*
+ *    for C218 BIOS initialization
+ */
+#define C218_ConfBase	0x800
+#define C218_status	(C218_ConfBase + 0)	/* BIOS running status    */
+#define C218_diag	(C218_ConfBase + 2)	/* diagnostic status      */
+#define C218_key	(C218_ConfBase + 4)	/* WORD (0x218 for C218) */
+#define C218DLoad_len	(C218_ConfBase + 6)	/* WORD           */
+#define C218check_sum	(C218_ConfBase + 8)	/* BYTE           */
+#define C218chksum_ok	(C218_ConfBase + 0x0a)	/* BYTE (1:ok)            */
+#define C218_TestRx	(C218_ConfBase + 0x10)	/* 8 bytes for 8 ports    */
+#define C218_TestTx	(C218_ConfBase + 0x18)	/* 8 bytes for 8 ports    */
+#define C218_RXerr	(C218_ConfBase + 0x20)	/* 8 bytes for 8 ports    */
+#define C218_ErrFlag	(C218_ConfBase + 0x28)	/* 8 bytes for 8 ports    */
+
+#define C218_LoadBuf	0x0F00
+#define C218_KeyCode	0x218
+#define CP204J_KeyCode	0x204
+
+/*
+ *    for C320 BIOS initialization
+ */
+#define C320_ConfBase	0x800
+#define C320_LoadBuf	0x0f00
+#define STS_init	0x05	/* for C320_status        */
+
+#define C320_status	C320_ConfBase + 0	/* BIOS running status    */
+#define C320_diag	C320_ConfBase + 2	/* diagnostic status      */
+#define C320_key	C320_ConfBase + 4	/* WORD (0320H for C320) */
+#define C320DLoad_len	C320_ConfBase + 6	/* WORD           */
+#define C320check_sum	C320_ConfBase + 8	/* WORD           */
+#define C320chksum_ok	C320_ConfBase + 0x0a	/* WORD (1:ok)            */
+#define C320bapi_len	C320_ConfBase + 0x0c	/* WORD           */
+#define C320UART_no	C320_ConfBase + 0x0e	/* WORD           */
+
+#define C320_KeyCode	0x320
+
+#define FixPage_addr	0x0000	/* starting addr of static page  */
+#define DynPage_addr	0x2000	/* starting addr of dynamic page */
+#define C218_start	0x3000	/* starting addr of C218 BIOS prg */
+#define Control_reg	0x1ff0	/* select page and reset control */
+#define HW_reset	0x80
+
+/*
+ *    Function Codes
+ */
+#define FC_CardReset	0x80
+#define FC_ChannelReset 1	/* C320 firmware not supported */
+#define FC_EnableCH	2
+#define FC_DisableCH	3
+#define FC_SetParam	4
+#define FC_SetMode	5
+#define FC_SetRate	6
+#define FC_LineControl	7
+#define FC_LineStatus	8
+#define FC_XmitControl	9
+#define FC_FlushQueue	10
+#define FC_SendBreak	11
+#define FC_StopBreak	12
+#define FC_LoopbackON	13
+#define FC_LoopbackOFF	14
+#define FC_ClrIrqTable	15
+#define FC_SendXon	16
+#define FC_SetTermIrq	17	/* C320 firmware not supported */
+#define FC_SetCntIrq	18	/* C320 firmware not supported */
+#define FC_SetBreakIrq	19
+#define FC_SetLineIrq	20
+#define FC_SetFlowCtl	21
+#define FC_GenIrq	22
+#define FC_InCD180	23
+#define FC_OutCD180	24
+#define FC_InUARTreg	23
+#define FC_OutUARTreg	24
+#define FC_SetXonXoff	25
+#define FC_OutCD180CCR	26
+#define FC_ExtIQueue	27
+#define FC_ExtOQueue	28
+#define FC_ClrLineIrq	29
+#define FC_HWFlowCtl	30
+#define FC_GetClockRate 35
+#define FC_SetBaud	36
+#define FC_SetDataMode  41
+#define FC_GetCCSR      43
+#define FC_GetDataError 45
+#define FC_RxControl	50
+#define FC_ImmSend	51
+#define FC_SetXonState	52
+#define FC_SetXoffState	53
+#define FC_SetRxFIFOTrig 54
+#define FC_SetTxFIFOCnt 55
+#define FC_UnixRate	56
+#define FC_UnixResetTimer 57
+
+#define	RxFIFOTrig1	0
+#define	RxFIFOTrig4	1
+#define	RxFIFOTrig8	2
+#define	RxFIFOTrig14	3
+
+/*
+ *    Dual-Ported RAM
+ */
+#define DRAM_global	0
+#define INT_data	(DRAM_global + 0)
+#define Config_base	(DRAM_global + 0x108)
+
+#define IRQindex	(INT_data + 0)
+#define IRQpending	(INT_data + 4)
+#define IRQtable	(INT_data + 8)
+
+/*
+ *    Interrupt Status
+ */
+#define IntrRx		0x01	/* receiver data O.K.             */
+#define IntrTx		0x02	/* transmit buffer empty  */
+#define IntrFunc	0x04	/* function complete              */
+#define IntrBreak	0x08	/* received break         */
+#define IntrLine	0x10	/* line status change
+				   for transmitter                */
+#define IntrIntr	0x20	/* received INTR code             */
+#define IntrQuit	0x40	/* received QUIT code             */
+#define IntrEOF 	0x80	/* received EOF code              */
+
+#define IntrRxTrigger 	0x100	/* rx data count reach tigger value */
+#define IntrTxTrigger 	0x200	/* tx data count below trigger value */
+
+#define Magic_no	(Config_base + 0)
+#define Card_model_no	(Config_base + 2)
+#define Total_ports	(Config_base + 4)
+#define Module_cnt	(Config_base + 8)
+#define Module_no	(Config_base + 10)
+#define Timer_10ms	(Config_base + 14)
+#define Disable_IRQ	(Config_base + 20)
+#define TMS320_PORT1	(Config_base + 22)
+#define TMS320_PORT2	(Config_base + 24)
+#define TMS320_CLOCK	(Config_base + 26)
+
+/*
+ *    DATA BUFFER in DRAM
+ */
+#define Extern_table	0x400	/* Base address of the external table
+				   (24 words *    64) total 3K bytes
+				   (24 words * 128) total 6K bytes */
+#define Extern_size	0x60	/* 96 bytes                       */
+#define RXrptr		0x00	/* read pointer for RX buffer     */
+#define RXwptr		0x02	/* write pointer for RX buffer    */
+#define TXrptr		0x04	/* read pointer for TX buffer     */
+#define TXwptr		0x06	/* write pointer for TX buffer    */
+#define HostStat	0x08	/* IRQ flag and general flag      */
+#define FlagStat	0x0A
+#define FlowControl	0x0C	/* B7 B6 B5 B4 B3 B2 B1 B0              */
+					/*  x  x  x  x  |  |  |  |            */
+					/*              |  |  |  + CTS flow   */
+					/*              |  |  +--- RTS flow   */
+					/*              |  +------ TX Xon/Xoff */
+					/*              +--------- RX Xon/Xoff */
+#define Break_cnt	0x0E	/* received break count   */
+#define CD180TXirq	0x10	/* if non-0: enable TX irq        */
+#define RX_mask 	0x12
+#define TX_mask 	0x14
+#define Ofs_rxb 	0x16
+#define Ofs_txb 	0x18
+#define Page_rxb	0x1A
+#define Page_txb	0x1C
+#define EndPage_rxb	0x1E
+#define EndPage_txb	0x20
+#define Data_error	0x22
+#define RxTrigger	0x28
+#define TxTrigger	0x2a
+
+#define rRXwptr 	0x34
+#define Low_water	0x36
+
+#define FuncCode	0x40
+#define FuncArg 	0x42
+#define FuncArg1	0x44
+
+#define C218rx_size	0x2000	/* 8K bytes */
+#define C218tx_size	0x8000	/* 32K bytes */
+
+#define C218rx_mask	(C218rx_size - 1)
+#define C218tx_mask	(C218tx_size - 1)
+
+#define C320p8rx_size	0x2000
+#define C320p8tx_size	0x8000
+#define C320p8rx_mask	(C320p8rx_size - 1)
+#define C320p8tx_mask	(C320p8tx_size - 1)
+
+#define C320p16rx_size	0x2000
+#define C320p16tx_size	0x4000
+#define C320p16rx_mask	(C320p16rx_size - 1)
+#define C320p16tx_mask	(C320p16tx_size - 1)
+
+#define C320p24rx_size	0x2000
+#define C320p24tx_size	0x2000
+#define C320p24rx_mask	(C320p24rx_size - 1)
+#define C320p24tx_mask	(C320p24tx_size - 1)
+
+#define C320p32rx_size	0x1000
+#define C320p32tx_size	0x1000
+#define C320p32rx_mask	(C320p32rx_size - 1)
+#define C320p32tx_mask	(C320p32tx_size - 1)
+
+#define Page_size	0x2000
+#define Page_mask	(Page_size - 1)
+#define C218rx_spage	3
+#define C218tx_spage	4
+#define C218rx_pageno	1
+#define C218tx_pageno	4
+#define C218buf_pageno	5
+
+#define C320p8rx_spage	3
+#define C320p8tx_spage	4
+#define C320p8rx_pgno	1
+#define C320p8tx_pgno	4
+#define C320p8buf_pgno	5
+
+#define C320p16rx_spage 3
+#define C320p16tx_spage 4
+#define C320p16rx_pgno	1
+#define C320p16tx_pgno	2
+#define C320p16buf_pgno 3
+
+#define C320p24rx_spage 3
+#define C320p24tx_spage 4
+#define C320p24rx_pgno	1
+#define C320p24tx_pgno	1
+#define C320p24buf_pgno 2
+
+#define C320p32rx_spage 3
+#define C320p32tx_ofs	C320p32rx_size
+#define C320p32tx_spage 3
+#define C320p32buf_pgno 1
+
+/*
+ *    Host Status
+ */
+#define WakeupRx	0x01
+#define WakeupTx	0x02
+#define WakeupBreak	0x08
+#define WakeupLine	0x10
+#define WakeupIntr	0x20
+#define WakeupQuit	0x40
+#define WakeupEOF	0x80	/* used in VTIME control */
+#define WakeupRxTrigger	0x100
+#define WakeupTxTrigger	0x200
+/*
+ *    Flag status
+ */
+#define Rx_over		0x01
+#define Xoff_state	0x02
+#define Tx_flowOff	0x04
+#define Tx_enable	0x08
+#define CTS_state	0x10
+#define DSR_state	0x20
+#define DCD_state	0x80
+/*
+ *    FlowControl
+ */
+#define CTS_FlowCtl	1
+#define RTS_FlowCtl	2
+#define Tx_FlowCtl	4
+#define Rx_FlowCtl	8
+#define IXM_IXANY	0x10
+
+#define LowWater	128
+
+#define DTR_ON		1
+#define RTS_ON		2
+#define CTS_ON		1
+#define DSR_ON		2
+#define DCD_ON		8
+
+/* mode definition */
+#define	MX_CS8		0x03
+#define	MX_CS7		0x02
+#define	MX_CS6		0x01
+#define	MX_CS5		0x00
+
+#define	MX_STOP1	0x00
+#define	MX_STOP15	0x04
+#define	MX_STOP2	0x08
+
+#define	MX_PARNONE	0x00
+#define	MX_PAREVEN	0x40
+#define	MX_PARODD	0xC0
+
+#endif
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

