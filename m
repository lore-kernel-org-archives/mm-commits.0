From: akpm@linux-foundation.org
Subject: + mmc-omap-add-support-for-16-bit-and-32-bit-registers.patch added to -mm tree
Date: Thu, 18 Mar 2010 11:52:54 -0700
Message-ID: <201003181852.o2IIqsFW009584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751070Ab0CRSyd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 14:54:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marek.belisko@open-nandra.com, ben@fluff.org, darkstar6262@gmail.com, ladis@linux-mips.org, linux-mmc@vger.kernel.org, tony@atomide.com


The patch titled
     mmc-omap: add support for 16-bit and 32-bit registers
has been added to the -mm tree.  Its filename is
     mmc-omap-add-support-for-16-bit-and-32-bit-registers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc-omap: add support for 16-bit and 32-bit registers
From: Marek Belisko <marek.belisko@open-nandra.com>

The omap850 and omap730 use 16-bit registers instead of 32-bit, requiring
a modification of the register addresses in the mmc-omap driver.  To
resolve this, a bit shift is performed on base register addresses, either
by 1 or 2 bits depending on the CPU in use.  This yields the correct
registers for each CPU.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
Signed-off-by: Cory Maccarrone <darkstar6262@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: Ladislav Michl <ladis@linux-mips.org>
Cc: Ben Dooks <ben@fluff.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap.c |   62 ++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 29 deletions(-)

diff -puN drivers/mmc/host/omap.c~mmc-omap-add-support-for-16-bit-and-32-bit-registers drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmc-omap-add-support-for-16-bit-and-32-bit-registers
+++ a/drivers/mmc/host/omap.c
@@ -38,30 +38,30 @@
 #include <plat/fpga.h>
 
 #define	OMAP_MMC_REG_CMD	0x00
-#define	OMAP_MMC_REG_ARGL	0x04
-#define	OMAP_MMC_REG_ARGH	0x08
-#define	OMAP_MMC_REG_CON	0x0c
-#define	OMAP_MMC_REG_STAT	0x10
-#define	OMAP_MMC_REG_IE		0x14
-#define	OMAP_MMC_REG_CTO	0x18
-#define	OMAP_MMC_REG_DTO	0x1c
-#define	OMAP_MMC_REG_DATA	0x20
-#define	OMAP_MMC_REG_BLEN	0x24
-#define	OMAP_MMC_REG_NBLK	0x28
-#define	OMAP_MMC_REG_BUF	0x2c
-#define OMAP_MMC_REG_SDIO	0x34
-#define	OMAP_MMC_REG_REV	0x3c
-#define	OMAP_MMC_REG_RSP0	0x40
-#define	OMAP_MMC_REG_RSP1	0x44
-#define	OMAP_MMC_REG_RSP2	0x48
-#define	OMAP_MMC_REG_RSP3	0x4c
-#define	OMAP_MMC_REG_RSP4	0x50
-#define	OMAP_MMC_REG_RSP5	0x54
-#define	OMAP_MMC_REG_RSP6	0x58
-#define	OMAP_MMC_REG_RSP7	0x5c
-#define	OMAP_MMC_REG_IOSR	0x60
-#define	OMAP_MMC_REG_SYSC	0x64
-#define	OMAP_MMC_REG_SYSS	0x68
+#define	OMAP_MMC_REG_ARGL	0x01
+#define	OMAP_MMC_REG_ARGH	0x02
+#define	OMAP_MMC_REG_CON	0x03
+#define	OMAP_MMC_REG_STAT	0x04
+#define	OMAP_MMC_REG_IE		0x05
+#define	OMAP_MMC_REG_CTO	0x06
+#define	OMAP_MMC_REG_DTO	0x07
+#define	OMAP_MMC_REG_DATA	0x08
+#define	OMAP_MMC_REG_BLEN	0x09
+#define	OMAP_MMC_REG_NBLK	0x0a
+#define	OMAP_MMC_REG_BUF	0x0b
+#define	OMAP_MMC_REG_SDIO	0x0d
+#define	OMAP_MMC_REG_REV	0x0f
+#define	OMAP_MMC_REG_RSP0	0x10
+#define	OMAP_MMC_REG_RSP1	0x11
+#define	OMAP_MMC_REG_RSP2	0x12
+#define	OMAP_MMC_REG_RSP3	0x13
+#define	OMAP_MMC_REG_RSP4	0x14
+#define	OMAP_MMC_REG_RSP5	0x15
+#define	OMAP_MMC_REG_RSP6	0x16
+#define	OMAP_MMC_REG_RSP7	0x17
+#define	OMAP_MMC_REG_IOSR	0x18
+#define	OMAP_MMC_REG_SYSC	0x19
+#define	OMAP_MMC_REG_SYSS	0x1a
 
 #define	OMAP_MMC_STAT_CARD_ERR		(1 << 14)
 #define	OMAP_MMC_STAT_CARD_IRQ		(1 << 13)
@@ -77,8 +77,9 @@
 #define	OMAP_MMC_STAT_CARD_BUSY		(1 <<  2)
 #define	OMAP_MMC_STAT_END_OF_CMD	(1 <<  0)
 
-#define OMAP_MMC_READ(host, reg)	__raw_readw((host)->virt_base + OMAP_MMC_REG_##reg)
-#define OMAP_MMC_WRITE(host, reg, val)	__raw_writew((val), (host)->virt_base + OMAP_MMC_REG_##reg)
+#define OMAP_MMC_REG(host, reg)		(OMAP_MMC_REG_##reg << (host)->reg_shift)
+#define OMAP_MMC_READ(host, reg)	__raw_readw((host)->virt_base + OMAP_MMC_REG(host, reg))
+#define OMAP_MMC_WRITE(host, reg, val)	__raw_writew((val), (host)->virt_base + OMAP_MMC_REG(host, reg))
 
 /*
  * Command types
@@ -132,6 +133,7 @@ struct mmc_omap_host {
 	int			irq;
 	unsigned char		bus_mode;
 	unsigned char		hw_bus_mode;
+	unsigned int		reg_shift;
 
 	struct work_struct	cmd_abort_work;
 	unsigned		abort:1;
@@ -679,9 +681,9 @@ mmc_omap_xfer_data(struct mmc_omap_host 
 	host->data->bytes_xfered += n;
 
 	if (write) {
-		__raw_writesw(host->virt_base + OMAP_MMC_REG_DATA, host->buffer, n);
+		__raw_writesw(host->virt_base + OMAP_MMC_REG(host, DATA), host->buffer, n);
 	} else {
-		__raw_readsw(host->virt_base + OMAP_MMC_REG_DATA, host->buffer, n);
+		__raw_readsw(host->virt_base + OMAP_MMC_REG(host, DATA), host->buffer, n);
 	}
 }
 
@@ -899,7 +901,7 @@ mmc_omap_prepare_dma(struct mmc_omap_hos
 	int dst_port = 0;
 	int sync_dev = 0;
 
-	data_addr = host->phys_base + OMAP_MMC_REG_DATA;
+	data_addr = host->phys_base + OMAP_MMC_REG(host, DATA);
 	frame = data->blksz;
 	count = sg_dma_len(sg);
 
@@ -1492,6 +1494,8 @@ static int __init mmc_omap_probe(struct 
 		}
 	}
 
+	host->reg_shift = (cpu_is_omap7xx() ? 1 : 2);
+
 	return 0;
 
 err_plat_cleanup:
_

Patches currently in -mm which might be from marek.belisko@open-nandra.com are

mmc-omap-add-support-for-16-bit-and-32-bit-registers.patch

