From: akpm@linux-foundation.org
Subject: + tifm-fix-the-memorystick-host-fifo-handling-code.patch added to -mm tree
Date: Wed, 05 Mar 2008 15:17:46 -0800
Message-ID: <200803052317.m25NHkgo026681@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933275AbYCEXSM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 18:18:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oakad@yahoo.com


The patch titled
     tifm: fix the MemoryStick host fifo handling code
has been added to the -mm tree.  Its filename is
     tifm-fix-the-memorystick-host-fifo-handling-code.patch

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
Subject: tifm: fix the MemoryStick host fifo handling code
From: Alex Dubov <oakad@yahoo.com>

Additional input received from JMicron on MemoryStick host interfaces showed
that some assumtions in fifo handling code were incorrect.  This patch also
fixes data corruption used to occure during PIO transfers.

Signed-off-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/host/tifm_ms.c |  522 +++++++++++++++---------------
 include/linux/tifm.h            |    2 
 2 files changed, 263 insertions(+), 261 deletions(-)

diff -puN drivers/memstick/host/tifm_ms.c~tifm-fix-the-memorystick-host-fifo-handling-code drivers/memstick/host/tifm_ms.c
--- a/drivers/memstick/host/tifm_ms.c~tifm-fix-the-memorystick-host-fifo-handling-code
+++ a/drivers/memstick/host/tifm_ms.c
@@ -24,275 +24,289 @@
 static int no_dma;
 module_param(no_dma, bool, 0644);
 
-#define TIFM_MS_TIMEOUT      0x00100
-#define TIFM_MS_BADCRC       0x00200
-#define TIFM_MS_EOTPC        0x01000
-#define TIFM_MS_INT          0x02000
-
-/* The meaning of the bit majority in this constant is unknown. */
-#define TIFM_MS_SERIAL       0x04010
-
-#define TIFM_MS_SYS_LATCH    0x00100
-#define TIFM_MS_SYS_NOT_RDY  0x00800
-#define TIFM_MS_SYS_DATA     0x10000
+/*
+ * Some control bits of TIFM appear to conform to Sony's reference design,
+ * so I'm just assuming they all are.
+ */
+
+#define TIFM_MS_STAT_DRQ     0x04000
+#define TIFM_MS_STAT_MSINT   0x02000
+#define TIFM_MS_STAT_RDY     0x01000
+#define TIFM_MS_STAT_CRC     0x00200
+#define TIFM_MS_STAT_TOE     0x00100
+#define TIFM_MS_STAT_EMP     0x00020
+#define TIFM_MS_STAT_FUL     0x00010
+#define TIFM_MS_STAT_CED     0x00008
+#define TIFM_MS_STAT_ERR     0x00004
+#define TIFM_MS_STAT_BRQ     0x00002
+#define TIFM_MS_STAT_CNK     0x00001
+
+#define TIFM_MS_SYS_DMA      0x10000
+#define TIFM_MS_SYS_RESET    0x08000
+#define TIFM_MS_SYS_SRAC     0x04000
+#define TIFM_MS_SYS_INTEN    0x02000
+#define TIFM_MS_SYS_NOCRC    0x01000
+#define TIFM_MS_SYS_INTCLR   0x00800
+#define TIFM_MS_SYS_MSIEN    0x00400
+#define TIFM_MS_SYS_FCLR     0x00200
+#define TIFM_MS_SYS_FDIR     0x00100
+#define TIFM_MS_SYS_DAM      0x00080
+#define TIFM_MS_SYS_DRM      0x00040
+#define TIFM_MS_SYS_DRQSL    0x00020
+#define TIFM_MS_SYS_REI      0x00010
+#define TIFM_MS_SYS_REO      0x00008
+#define TIFM_MS_SYS_BSY_MASK 0x00007
+
+#define TIFM_MS_SYS_FIFO     (TIFM_MS_SYS_INTEN | TIFM_MS_SYS_MSIEN \
+			      | TIFM_MS_SYS_FCLR | TIFM_MS_SYS_BSY_MASK)
 
 /* Hardware flags */
 enum {
-	CMD_READY  = 0x0001,
-	FIFO_READY = 0x0002,
-	CARD_READY = 0x0004,
-	DATA_CARRY = 0x0008
+	CMD_READY  = 0x01,
+	FIFO_READY = 0x02,
+	CARD_INT   = 0x04
 };
 
 struct tifm_ms {
 	struct tifm_dev         *dev;
-	unsigned short          eject:1,
-				no_dma:1;
-	unsigned short          cmd_flags;
+	struct timer_list       timer;
+	struct memstick_request *req;
 	unsigned int            mode_mask;
 	unsigned int            block_pos;
 	unsigned long           timeout_jiffies;
-
-	struct timer_list       timer;
-	struct memstick_request *req;
+	unsigned char           eject:1,
+				use_dma:1;
+	unsigned char           cmd_flags;
+	unsigned char           io_pos;
 	unsigned int            io_word;
 };
 
-static void tifm_ms_read_fifo(struct tifm_ms *host, unsigned int fifo_offset,
-			      struct page *pg, unsigned int page_off,
-			      unsigned int length)
+static unsigned int tifm_ms_read_data(struct tifm_ms *host,
+				      unsigned char *buf, unsigned int length)
 {
 	struct tifm_dev *sock = host->dev;
-	unsigned int cnt = 0, off = 0;
-	unsigned char *buf = kmap_atomic(pg, KM_BIO_DST_IRQ) + page_off;
+	unsigned int off = 0;
 
-	if (host->cmd_flags & DATA_CARRY) {
-		while ((fifo_offset & 3) && length) {
+	while (host->io_pos && length) {
+		buf[off++] = host->io_word & 0xff;
+		host->io_word >>= 8;
+		length--;
+		host->io_pos--;
+	}
+
+	if (!length)
+		return off;
+
+	while (!(TIFM_MS_STAT_EMP & readl(sock->addr + SOCK_MS_STATUS))) {
+		if (length < 4)
+			break;
+		*(unsigned int *)(buf + off) = __raw_readl(sock->addr
+							   + SOCK_MS_DATA);
+		length -= 4;
+		off += 4;
+	}
+
+	if (length
+	    && !(TIFM_MS_STAT_EMP & readl(sock->addr + SOCK_MS_STATUS))) {
+		host->io_word = readl(sock->addr + SOCK_MS_DATA);
+		for (host->io_pos = 4; host->io_pos; --host->io_pos) {
 			buf[off++] = host->io_word & 0xff;
 			host->io_word >>= 8;
 			length--;
-			fifo_offset++;
+			if (!length)
+				break;
 		}
-		if (!(fifo_offset & 3))
-			host->cmd_flags &= ~DATA_CARRY;
-		if (!length)
-			return;
 	}
 
-	do {
-		host->io_word = readl(sock->addr + SOCK_FIFO_ACCESS
-				      + fifo_offset);
-		cnt = 4;
-		while (length && cnt) {
-			buf[off++] = (host->io_word >> 8) & 0xff;
-			cnt--;
-			length--;
-		}
-		fifo_offset += 4 - cnt;
-	} while (length);
-
-	if (cnt)
-		host->cmd_flags |= DATA_CARRY;
-
-	kunmap_atomic(buf - page_off, KM_BIO_DST_IRQ);
+	return off;
 }
 
-static void tifm_ms_write_fifo(struct tifm_ms *host, unsigned int fifo_offset,
-			       struct page *pg, unsigned int page_off,
-			       unsigned int length)
+static unsigned int tifm_ms_write_data(struct tifm_ms *host,
+				       unsigned char *buf, unsigned int length)
 {
 	struct tifm_dev *sock = host->dev;
-	unsigned int cnt = 0, off = 0;
-	unsigned char *buf = kmap_atomic(pg, KM_BIO_SRC_IRQ) + page_off;
+	unsigned int off = 0;
 
-	if (host->cmd_flags & DATA_CARRY) {
-		while (fifo_offset & 3) {
-			host->io_word |= buf[off++] << (8 * (fifo_offset & 3));
+	if (host->io_pos) {
+		while (host->io_pos < 4 && length) {
+			host->io_word |=  buf[off++] << (host->io_pos * 8);
+			host->io_pos++;
 			length--;
-			fifo_offset++;
-		}
-		if (!(fifo_offset & 3)) {
-			writel(host->io_word, sock->addr + SOCK_FIFO_ACCESS
-			       + fifo_offset - 4);
-
-			host->cmd_flags &= ~DATA_CARRY;
 		}
-		if (!length)
-			return;
 	}
 
-	do {
-		cnt = 4;
+	if (host->io_pos == 4
+	    && !(TIFM_MS_STAT_FUL & readl(sock->addr + SOCK_MS_STATUS))) {
+		writel(TIFM_MS_SYS_FDIR | readl(sock->addr + SOCK_MS_SYSTEM),
+		       sock->addr + SOCK_MS_SYSTEM);
+		writel(host->io_word, sock->addr + SOCK_MS_DATA);
+		host->io_pos = 0;
 		host->io_word = 0;
-		while (length && cnt) {
-			host->io_word |= buf[off++] << (4 - cnt);
-			cnt--;
-			length--;
-		}
-		fifo_offset += 4 - cnt;
-		if (!cnt)
-			writel(host->io_word, sock->addr + SOCK_FIFO_ACCESS
-					      + fifo_offset - 4);
+	} else if (host->io_pos) {
+		return off;
+	}
+
+	if (!length)
+		return off;
 
-	} while (length);
+	while (!(TIFM_MS_STAT_FUL & readl(sock->addr + SOCK_MS_STATUS))) {
+		if (length < 4)
+			break;
+		writel(TIFM_MS_SYS_FDIR | readl(sock->addr + SOCK_MS_SYSTEM),
+		       sock->addr + SOCK_MS_SYSTEM);
+		__raw_writel(*(unsigned int *)(buf + off),
+			     sock->addr + SOCK_MS_DATA);
+		length -= 4;
+		off += 4;
+	}
 
-	if (cnt)
-		host->cmd_flags |= DATA_CARRY;
+	switch (length) {
+	case 3:
+		host->io_word |= buf[off + 2] << 16;
+		host->io_pos++;
+	case 2:
+		host->io_word |= buf[off + 1] << 8;
+		host->io_pos++;
+	case 1:
+		host->io_word |= buf[off];
+		host->io_pos++;
+	}
 
-	kunmap_atomic(buf - page_off, KM_BIO_SRC_IRQ);
+	off += host->io_pos;
+
+	return off;
 }
 
-static void tifm_ms_move_block(struct tifm_ms *host, unsigned int length)
+static unsigned int tifm_ms_transfer_data(struct tifm_ms *host)
 {
-	unsigned int t_size;
-	unsigned int off = host->req->sg.offset + host->block_pos;
-	unsigned int p_off, p_cnt;
+	struct tifm_dev *sock = host->dev;
+	unsigned int length;
+	unsigned int off;
+	unsigned int t_size, p_off, p_cnt;
+	unsigned char *buf;
 	struct page *pg;
-	unsigned long flags;
+	unsigned long flags = 0;
 
-	dev_dbg(&host->dev->dev, "moving block\n");
-	local_irq_save(flags);
-	t_size = length;
-	while (t_size) {
-		pg = nth_page(sg_page(&host->req->sg), off >> PAGE_SHIFT);
-		p_off = offset_in_page(off);
-		p_cnt = PAGE_SIZE - p_off;
-		p_cnt = min(p_cnt, t_size);
-
-		if (host->req->data_dir == WRITE)
-			tifm_ms_write_fifo(host, length - t_size,
-					   pg, p_off, p_cnt);
-		else
-			tifm_ms_read_fifo(host, length - t_size,
-					  pg, p_off, p_cnt);
-
-		t_size -= p_cnt;
+	if (host->req->long_data) {
+		length = host->req->sg.length - host->block_pos;
+		off = host->req->sg.offset + host->block_pos;
+	} else {
+		length = host->req->data_len - host->block_pos;
+		off = 0;
 	}
-	local_irq_restore(flags);
-}
+	dev_dbg(&sock->dev, "fifo data transfer, %d, %d\n", length,
+		host->block_pos);
 
-static int tifm_ms_transfer_data(struct tifm_ms *host, int skip)
-{
-	struct tifm_dev *sock = host->dev;
-	unsigned int length = host->req->sg.length - host->block_pos;
+	while (length) {
+		if (host->req->long_data) {
+			pg = nth_page(sg_page(&host->req->sg),
+				      off >> PAGE_SHIFT);
+			p_off = offset_in_page(off);
+			p_cnt = PAGE_SIZE - p_off;
+			p_cnt = min(p_cnt, length);
 
-	if (!length)
-		return 1;
+			local_irq_save(flags);
+			buf = kmap_atomic(pg, KM_BIO_SRC_IRQ) + p_off;
+		} else {
+			buf = host->req->data + host->block_pos;
+			p_cnt = host->req->data_len - host->block_pos;
+		}
 
-	if (length > TIFM_FIFO_SIZE)
-		length = TIFM_FIFO_SIZE;
+		t_size = host->req->data_dir == WRITE
+			 ? tifm_ms_write_data(host, buf, p_cnt)
+			 : tifm_ms_read_data(host, buf, p_cnt);
+
+		if (host->req->long_data) {
+			kunmap_atomic(buf - p_off, KM_BIO_SRC_IRQ);
+			local_irq_restore(flags);
+		}
 
-	if (!skip) {
-		tifm_ms_move_block(host, length);
-		host->block_pos += length;
+		if (!t_size)
+			break;
+		host->block_pos += t_size;
+		length -= t_size;
+		off += t_size;
 	}
 
-	if ((host->req->data_dir == READ)
-	    && (host->block_pos == host->req->sg.length))
-		return 1;
-
-	writel(ilog2(length) - 2, sock->addr + SOCK_FIFO_PAGE_SIZE);
-	if (host->req->data_dir == WRITE)
-		writel((1 << 8) | TIFM_DMA_TX, sock->addr + SOCK_DMA_CONTROL);
-	else
-		writel((1 << 8), sock->addr + SOCK_DMA_CONTROL);
+	dev_dbg(&sock->dev, "fifo data transfer, %d remaining\n", length);
+	if (!length && (host->req->data_dir == WRITE)) {
+		if (host->io_pos) {
+			writel(TIFM_MS_SYS_FDIR
+			       | readl(sock->addr + SOCK_MS_SYSTEM),
+			       sock->addr + SOCK_MS_SYSTEM);
+			writel(host->io_word, sock->addr + SOCK_MS_DATA);
+		}
+		writel(TIFM_MS_SYS_FDIR
+		       | readl(sock->addr + SOCK_MS_SYSTEM),
+		       sock->addr + SOCK_MS_SYSTEM);
+		writel(0, sock->addr + SOCK_MS_DATA);
+	} else {
+		readl(sock->addr + SOCK_MS_DATA);
+	}
 
-	return 0;
+	return length;
 }
 
 static int tifm_ms_issue_cmd(struct tifm_ms *host)
 {
 	struct tifm_dev *sock = host->dev;
 	unsigned char *data;
-	unsigned int data_len = 0, cmd = 0, cmd_mask = 0, cnt, tval = 0;
+	unsigned int data_len, cmd, sys_param;
 
 	host->cmd_flags = 0;
+	host->block_pos = 0;
+	host->io_pos = 0;
+	host->io_word = 0;
+	host->cmd_flags = 0;
 
-	if (host->req->long_data) {
-		if (!host->no_dma) {
-			if (1 != tifm_map_sg(sock, &host->req->sg, 1,
-					     host->req->data_dir == READ
-					     ? PCI_DMA_FROMDEVICE
-					     : PCI_DMA_TODEVICE)) {
-				host->req->error = -ENOMEM;
-				return host->req->error;
-			}
-			data_len = sg_dma_len(&host->req->sg);
-		} else
-			data_len = host->req->sg.length;
+	data = host->req->data;
 
-		writel(TIFM_FIFO_INT_SETALL,
-		       sock->addr + SOCK_DMA_FIFO_INT_ENABLE_CLEAR);
-		writel(TIFM_FIFO_ENABLE,
-		       sock->addr + SOCK_FIFO_CONTROL);
-		writel(TIFM_FIFO_INTMASK,
-		       sock->addr + SOCK_DMA_FIFO_INT_ENABLE_SET);
-
-		if (!host->no_dma) {
-			writel(ilog2(data_len) - 2,
-			       sock->addr + SOCK_FIFO_PAGE_SIZE);
-			writel(sg_dma_address(&host->req->sg),
-			       sock->addr + SOCK_DMA_ADDRESS);
-			if (host->req->data_dir == WRITE)
-				writel((1 << 8) | TIFM_DMA_TX | TIFM_DMA_EN,
-				       sock->addr + SOCK_DMA_CONTROL);
-			else
-				writel((1 << 8) | TIFM_DMA_EN,
-				       sock->addr + SOCK_DMA_CONTROL);
-		} else {
-			tifm_ms_transfer_data(host,
-					      host->req->data_dir == READ);
-		}
+	host->use_dma = !no_dma;
 
-		cmd_mask = readl(sock->addr + SOCK_MS_SYSTEM);
-		cmd_mask |= TIFM_MS_SYS_DATA | TIFM_MS_SYS_NOT_RDY;
-		writel(cmd_mask, sock->addr + SOCK_MS_SYSTEM);
+	if (host->req->long_data) {
+		data_len = host->req->sg.length;
+		if (!is_power_of_2(data_len))
+			host->use_dma = 0;
 	} else {
-		data = host->req->data;
 		data_len = host->req->data_len;
+		host->use_dma = 0;
+	}
 
-		cmd_mask = host->mode_mask | 0x2607; /* unknown constant */
+	writel(TIFM_FIFO_INT_SETALL,
+	       sock->addr + SOCK_DMA_FIFO_INT_ENABLE_CLEAR);
+	writel(TIFM_FIFO_ENABLE,
+	       sock->addr + SOCK_FIFO_CONTROL);
+
+	if (host->use_dma) {
+		if (1 != tifm_map_sg(sock, &host->req->sg, 1,
+				     host->req->data_dir == READ
+				     ? PCI_DMA_FROMDEVICE
+				     : PCI_DMA_TODEVICE)) {
+			host->req->error = -ENOMEM;
+			return host->req->error;
+		}
+		data_len = sg_dma_len(&host->req->sg);
 
-		if (host->req->data_dir == WRITE) {
-			cmd_mask |= TIFM_MS_SYS_LATCH;
-			writel(cmd_mask, sock->addr + SOCK_MS_SYSTEM);
-			for (cnt = 0; (data_len - cnt) >= 4; cnt += 4) {
-				writel(TIFM_MS_SYS_LATCH
-				       | readl(sock->addr + SOCK_MS_SYSTEM),
-				       sock->addr + SOCK_MS_SYSTEM);
-				__raw_writel(*(unsigned int *)(data + cnt),
-					     sock->addr + SOCK_MS_DATA);
-				dev_dbg(&sock->dev, "writing %x\n",
-					*(int *)(data + cnt));
-			}
-			switch (data_len - cnt) {
-			case 3:
-				tval |= data[cnt + 2] << 16;
-			case 2:
-				tval |= data[cnt + 1] << 8;
-			case 1:
-				tval |= data[cnt];
-				writel(TIFM_MS_SYS_LATCH
-				       | readl(sock->addr + SOCK_MS_SYSTEM),
-				       sock->addr + SOCK_MS_SYSTEM);
-				writel(tval, sock->addr + SOCK_MS_DATA);
-				dev_dbg(&sock->dev, "writing %x\n", tval);
-			}
+		writel(ilog2(data_len) - 2,
+		       sock->addr + SOCK_FIFO_PAGE_SIZE);
+		writel(TIFM_FIFO_INTMASK,
+		       sock->addr + SOCK_DMA_FIFO_INT_ENABLE_SET);
+		sys_param = TIFM_DMA_EN | (1 << 8);
+		if (host->req->data_dir == WRITE)
+			sys_param |= TIFM_DMA_TX;
 
-			writel(TIFM_MS_SYS_LATCH
-			       | readl(sock->addr + SOCK_MS_SYSTEM),
-			       sock->addr + SOCK_MS_SYSTEM);
-			writel(0, sock->addr + SOCK_MS_DATA);
-			dev_dbg(&sock->dev, "writing %x\n", 0);
+		writel(TIFM_FIFO_INTMASK,
+		       sock->addr + SOCK_DMA_FIFO_INT_ENABLE_SET);
 
-		} else
-			writel(cmd_mask, sock->addr + SOCK_MS_SYSTEM);
+		writel(sg_dma_address(&host->req->sg),
+		       sock->addr + SOCK_DMA_ADDRESS);
+		writel(sys_param, sock->addr + SOCK_DMA_CONTROL);
+	} else {
+		writel(host->mode_mask | TIFM_MS_SYS_FIFO,
+		       sock->addr + SOCK_MS_SYSTEM);
 
-		cmd_mask = readl(sock->addr + SOCK_MS_SYSTEM);
-		cmd_mask &= ~TIFM_MS_SYS_DATA;
-		cmd_mask |= TIFM_MS_SYS_NOT_RDY;
-		dev_dbg(&sock->dev, "mask %x\n", cmd_mask);
-		writel(cmd_mask, sock->addr + SOCK_MS_SYSTEM);
+		writel(TIFM_FIFO_MORE,
+		       sock->addr + SOCK_DMA_FIFO_INT_ENABLE_SET);
 	}
 
 	mod_timer(&host->timer, jiffies + host->timeout_jiffies);
@@ -300,11 +314,21 @@ static int tifm_ms_issue_cmd(struct tifm
 	       sock->addr + SOCK_CONTROL);
 	host->req->error = 0;
 
+	sys_param = readl(sock->addr + SOCK_MS_SYSTEM);
+	sys_param |= TIFM_MS_SYS_INTCLR;
+
+	if (host->use_dma)
+		sys_param |= TIFM_MS_SYS_DMA;
+	else
+		sys_param &= ~TIFM_MS_SYS_DMA;
+
+	writel(sys_param, sock->addr + SOCK_MS_SYSTEM);
+
 	cmd = (host->req->tpc & 0xf) << 12;
 	cmd |= data_len;
 	writel(cmd, sock->addr + SOCK_MS_COMMAND);
 
-	dev_dbg(&sock->dev, "executing TPC %x, %x\n", cmd, cmd_mask);
+	dev_dbg(&sock->dev, "executing TPC %x, %x\n", cmd, sys_param);
 	return 0;
 }
 
@@ -312,47 +336,20 @@ static void tifm_ms_complete_cmd(struct 
 {
 	struct tifm_dev *sock = host->dev;
 	struct memstick_host *msh = tifm_get_drvdata(sock);
-	unsigned int tval = 0, data_len;
-	unsigned char *data;
 	int rc;
 
 	del_timer(&host->timer);
-	if (host->req->long_data) {
-		if (!host->no_dma)
-			tifm_unmap_sg(sock, &host->req->sg, 1,
-				      host->req->data_dir == READ
-				      ? PCI_DMA_FROMDEVICE
-				      : PCI_DMA_TODEVICE);
-	} else {
-		writel(~TIFM_MS_SYS_DATA & readl(sock->addr + SOCK_MS_SYSTEM),
-		       sock->addr + SOCK_MS_SYSTEM);
-
-		data = host->req->data;
-		data_len = host->req->data_len;
 
-		if (host->req->data_dir == READ) {
-			for (rc = 0; (data_len - rc) >= 4; rc += 4)
-				*(int *)(data + rc)
-					= __raw_readl(sock->addr
-						      + SOCK_MS_DATA);
-
-			if (data_len - rc)
-				tval = readl(sock->addr + SOCK_MS_DATA);
-			switch (data_len - rc) {
-			case 3:
-				data[rc + 2] = (tval >> 16) & 0xff;
-			case 2:
-				data[rc + 1] = (tval >> 8) & 0xff;
-			case 1:
-				data[rc] = tval & 0xff;
-			}
-			readl(sock->addr + SOCK_MS_DATA);
-		}
-	}
+	if (host->use_dma)
+		tifm_unmap_sg(sock, &host->req->sg, 1,
+			      host->req->data_dir == READ
+			      ? PCI_DMA_FROMDEVICE
+			      : PCI_DMA_TODEVICE);
 
 	writel((~TIFM_CTRL_LED) & readl(sock->addr + SOCK_CONTROL),
 	       sock->addr + SOCK_CONTROL);
 
+	dev_dbg(&sock->dev, "TPC complete\n");
 	do {
 		rc = memstick_next_req(msh, &host->req);
 	} while (!rc && tifm_ms_issue_cmd(host));
@@ -363,11 +360,10 @@ static int tifm_ms_check_status(struct t
 	if (!host->req->error) {
 		if (!(host->cmd_flags & CMD_READY))
 			return 1;
-		if (host->req->long_data
-		    && !(host->cmd_flags & FIFO_READY))
+		if (!(host->cmd_flags & FIFO_READY))
 			return 1;
 		if (host->req->need_card_int
-		    && !(host->cmd_flags & CARD_READY))
+		    && !(host->cmd_flags & CARD_INT))
 			return 1;
 	}
 	return 0;
@@ -377,18 +373,24 @@ static int tifm_ms_check_status(struct t
 static void tifm_ms_data_event(struct tifm_dev *sock)
 {
 	struct tifm_ms *host;
-	unsigned int fifo_status = 0;
+	unsigned int fifo_status = 0, host_status = 0;
 	int rc = 1;
 
 	spin_lock(&sock->lock);
 	host = memstick_priv((struct memstick_host *)tifm_get_drvdata(sock));
 	fifo_status = readl(sock->addr + SOCK_DMA_FIFO_STATUS);
-	dev_dbg(&sock->dev, "data event: fifo_status %x, flags %x\n",
-		fifo_status, host->cmd_flags);
+	host_status = readl(sock->addr + SOCK_MS_STATUS);
+	dev_dbg(&sock->dev,
+		"data event: fifo_status %x, host_status %x, flags %x\n",
+		fifo_status, host_status, host->cmd_flags);
 
 	if (host->req) {
-		if (fifo_status & TIFM_FIFO_READY) {
-			if (!host->no_dma || tifm_ms_transfer_data(host, 0)) {
+		if (host->use_dma && (fifo_status & 1)) {
+			host->cmd_flags |= FIFO_READY;
+			rc = tifm_ms_check_status(host);
+		}
+		if (!host->use_dma && (fifo_status & TIFM_FIFO_MORE)) {
+			if (!tifm_ms_transfer_data(host)) {
 				host->cmd_flags |= FIFO_READY;
 				rc = tifm_ms_check_status(host);
 			}
@@ -417,9 +419,9 @@ static void tifm_ms_card_event(struct ti
 		host_status, host->cmd_flags);
 
 	if (host->req) {
-		if (host_status & TIFM_MS_TIMEOUT)
+		if (host_status & TIFM_MS_STAT_TOE)
 			host->req->error = -ETIME;
-		else if (host_status & TIFM_MS_BADCRC)
+		else if (host_status & TIFM_MS_STAT_CRC)
 			host->req->error = -EILSEQ;
 
 		if (host->req->error) {
@@ -428,18 +430,17 @@ static void tifm_ms_card_event(struct ti
 			writel(TIFM_DMA_RESET, sock->addr + SOCK_DMA_CONTROL);
 		}
 
-		if (host_status & TIFM_MS_EOTPC)
+		if (host_status & TIFM_MS_STAT_RDY)
 			host->cmd_flags |= CMD_READY;
-		if (host_status & TIFM_MS_INT)
-			host->cmd_flags |= CARD_READY;
+
+		if (host_status & TIFM_MS_STAT_MSINT)
+			host->cmd_flags |= CARD_INT;
 
 		rc = tifm_ms_check_status(host);
 
 	}
 
-	writel(TIFM_MS_SYS_NOT_RDY | readl(sock->addr + SOCK_MS_SYSTEM),
-	       sock->addr + SOCK_MS_SYSTEM);
-	writel((~TIFM_MS_SYS_DATA) & readl(sock->addr + SOCK_MS_SYSTEM),
+	writel(TIFM_MS_SYS_INTCLR | readl(sock->addr + SOCK_MS_SYSTEM),
 	       sock->addr + SOCK_MS_SYSTEM);
 
 	if (!rc)
@@ -499,7 +500,7 @@ static void tifm_ms_set_param(struct mem
 		break;
 	case MEMSTICK_INTERFACE:
 		if (value == MEMSTICK_SERIAL) {
-			host->mode_mask = TIFM_MS_SERIAL;
+			host->mode_mask = TIFM_MS_SYS_SRAC | TIFM_MS_SYS_REI;
 			writel((~TIFM_CTRL_FAST_CLK)
 			       & readl(sock->addr + SOCK_CONTROL),
 			       sock->addr + SOCK_CONTROL);
@@ -535,9 +536,10 @@ static int tifm_ms_initialize_host(struc
 	struct tifm_dev *sock = host->dev;
 	struct memstick_host *msh = tifm_get_drvdata(sock);
 
-	host->mode_mask = TIFM_MS_SERIAL;
-	writel(0x8000, sock->addr + SOCK_MS_SYSTEM);
-	writel(0x0200 | TIFM_MS_SYS_NOT_RDY, sock->addr + SOCK_MS_SYSTEM);
+	host->mode_mask = TIFM_MS_SYS_SRAC | TIFM_MS_SYS_REI;
+	writel(TIFM_MS_SYS_RESET, sock->addr + SOCK_MS_SYSTEM);
+	writel(TIFM_MS_SYS_FCLR | TIFM_MS_SYS_INTCLR,
+	       sock->addr + SOCK_MS_SYSTEM);
 	writel(0xffffffff, sock->addr + SOCK_MS_STATUS);
 	if (tifm_has_ms_pif(sock))
 		msh->caps |= MEMSTICK_CAP_PAR4;
@@ -566,7 +568,6 @@ static int tifm_ms_probe(struct tifm_dev
 	tifm_set_drvdata(sock, msh);
 	host->dev = sock;
 	host->timeout_jiffies = msecs_to_jiffies(1000);
-	host->no_dma = no_dma;
 
 	setup_timer(&host->timer, tifm_ms_abort, (unsigned long)host);
 
@@ -599,7 +600,7 @@ static void tifm_ms_remove(struct tifm_d
 		writel(TIFM_FIFO_INT_SETALL,
 		       sock->addr + SOCK_DMA_FIFO_INT_ENABLE_CLEAR);
 		writel(TIFM_DMA_RESET, sock->addr + SOCK_DMA_CONTROL);
-		if (host->req->long_data && !host->no_dma)
+		if (host->use_dma)
 			tifm_unmap_sg(sock, &host->req->sg, 1,
 				      host->req->data_dir == READ
 				      ? PCI_DMA_TODEVICE
@@ -616,7 +617,8 @@ static void tifm_ms_remove(struct tifm_d
 
 	memstick_remove_host(msh);
 
-	writel(0x0200 | TIFM_MS_SYS_NOT_RDY, sock->addr + SOCK_MS_SYSTEM);
+	writel(TIFM_MS_SYS_FCLR | TIFM_MS_SYS_INTCLR,
+	       sock->addr + SOCK_MS_SYSTEM);
 	writel(0xffffffff, sock->addr + SOCK_MS_STATUS);
 
 	memstick_free_host(msh);
diff -puN include/linux/tifm.h~tifm-fix-the-memorystick-host-fifo-handling-code include/linux/tifm.h
--- a/include/linux/tifm.h~tifm-fix-the-memorystick-host-fifo-handling-code
+++ a/include/linux/tifm.h
@@ -70,9 +70,9 @@ enum {
 
 #define TIFM_FIFO_ENABLE          0x00000001
 #define TIFM_FIFO_READY           0x00000001
+#define TIFM_FIFO_MORE            0x00000008
 #define TIFM_FIFO_INT_SETALL      0x0000ffff
 #define TIFM_FIFO_INTMASK         0x00000005
-#define TIFM_FIFO_SIZE            0x00000200
 
 #define TIFM_DMA_RESET            0x00000002
 #define TIFM_DMA_TX               0x00008000
_

Patches currently in -mm which might be from oakad@yahoo.com are

memstick-introduce-correct-definitions-in-the-header.patch
memstick-add-memstick_suspend-resume_host-methods.patch
memstick-make-sure-number-of-command-retries-is-exactly-as-specified.patch
memstick-drop-driver_version-numbers-as-meaningless.patch
tifm-fix-the-memorystick-host-fifo-handling-code.patch
tifm-fix-memorystick-host-initialization-code.patch
tifm-clear-interrupt-mask-bits-before-setting-them-on-adapter-init.patch
memstick-add-support-for-decoding-specfile-media-attributes.patch
memstick-fix-parsing-of-assembly_date-attribute-field.patch
memstick-try-harder-to-recover-from-unsuccessful-interface-mode-switch.patch
memstick-add-support-for-jmicron-jmb38x-memorystick-host-controller.patch

