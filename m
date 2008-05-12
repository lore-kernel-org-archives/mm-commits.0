From: akpm@linux-foundation.org
Subject: + mmc-sd-host-driver-for-ricoh-bay1controllers.patch added to -mm tree
Date: Mon, 12 May 2008 16:17:26 -0700
Message-ID: <200805122317.m4CNHQEF014102@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752851AbYELXSG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 19:18:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: saschasommer@freenet.de, drzeus-list@drzeus.cx


The patch titled
     MMC/SD host driver for Ricoh Bay1Controllers
has been added to the -mm tree.  Its filename is
     mmc-sd-host-driver-for-ricoh-bay1controllers.patch

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
Subject: MMC/SD host driver for Ricoh Bay1Controllers
From: Sascha Sommer <saschasommer@freenet.de>

MMC/SD host driver for Ricoh Bay1Controllers

Signed-off-by: Sascha Sommer <saschasommer@freenet.de>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/Kconfig      |   10 
 drivers/mmc/host/Makefile     |    1 
 drivers/mmc/host/sdricoh_cs.c |  632 ++++++++++++++++++++++++++++++++
 3 files changed, 643 insertions(+)

diff -puN drivers/mmc/host/Kconfig~mmc-sd-host-driver-for-ricoh-bay1controllers drivers/mmc/host/Kconfig
--- a/drivers/mmc/host/Kconfig~mmc-sd-host-driver-for-ricoh-bay1controllers
+++ a/drivers/mmc/host/Kconfig
@@ -142,3 +142,13 @@ config MMC_SPI
 
 	  If unsure, or if your system has no SPI master driver, say N.
 
+config MMC_SDRICOH_CS
+	tristate "MMC/SD driver for Ricoh Bay1Controllers (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && MMC && PCI && PCMCIA && YENTA
+	help
+	  Say Y here if your Notebook reports a Ricoh Bay1Controller PCMCIA
+	  card whenever you insert a MMC or SD card into the card slot.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called sdricoh_cs.
+
diff -puN drivers/mmc/host/Makefile~mmc-sd-host-driver-for-ricoh-bay1controllers drivers/mmc/host/Makefile
--- a/drivers/mmc/host/Makefile~mmc-sd-host-driver-for-ricoh-bay1controllers
+++ a/drivers/mmc/host/Makefile
@@ -18,4 +18,5 @@ obj-$(CONFIG_MMC_OMAP)		+= omap.o
 obj-$(CONFIG_MMC_AT91)		+= at91_mci.o
 obj-$(CONFIG_MMC_TIFM_SD)	+= tifm_sd.o
 obj-$(CONFIG_MMC_SPI)		+= mmc_spi.o
+obj-$(CONFIG_MMC_SDRICOH_CS)	+= sdricoh_cs.o
 
diff -puN /dev/null drivers/mmc/host/sdricoh_cs.c
--- /dev/null
+++ a/drivers/mmc/host/sdricoh_cs.c
@@ -0,0 +1,632 @@
+/*
+ *  sdricoh_cs.c - driver for Ricoh Secure Digital Card Readers that can be
+ *     found on some Ricoh RL5c476 II cardbus bridge
+ *
+ *  Copyright (C) 2006 - 2008 Sascha Sommer <saschasommer@freenet.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+/*
+#define DEBUG
+#define VERBOSE_DEBUG
+*/
+#include <linux/delay.h>
+#include <linux/highmem.h>
+#include <linux/pci.h>
+#include <linux/ioport.h>
+#include <linux/version.h>
+
+#include <pcmcia/cs_types.h>
+#include <pcmcia/cs.h>
+#include <pcmcia/cistpl.h>
+#include <pcmcia/ds.h>
+#include <linux/io.h>
+
+#include <linux/mmc/host.h>
+#include <linux/mmc/mmc.h>
+#include <linux/mmc/sd.h>
+#include <linux/mmc/sdio.h>
+
+#define DRIVER_NAME "sdricoh_cs"
+
+static unsigned int switchlocked;
+
+/* i/o region */
+#define SDRICOH_PCI_REGION 0
+#define SDRICOH_PCI_REGION_SIZE 0x1000
+
+/* registers */
+#define R104_VERSION     0x104
+#define R200_CMD         0x200
+#define R204_CMD_ARG     0x204
+#define R208_DATAIO      0x208
+#define R20C_RESP        0x20c
+#define R21C_STATUS      0x21c
+#define R2E0_INIT        0x2e0
+#define R2E4_STATUS_RESP 0x2e4
+#define R2F0_RESET       0x2f0
+#define R224_MODE        0x224
+#define R228_POWER       0x228
+#define R230_DATA        0x230
+
+/* flags for the R21C_STATUS register */
+#define STATUS_CMD_FINISHED      0x00000001
+#define STATUS_TRANSFER_FINISHED 0x00000004
+#define STATUS_CARD_INSERTED     0x00000020
+#define STATUS_CARD_LOCKED       0x00000080
+#define STATUS_CMD_TIMEOUT       0x00400000
+#define STATUS_READY_TO_READ     0x01000000
+#define STATUS_READY_TO_WRITE    0x02000000
+#define STATUS_BUSY              0x40000000
+
+/* timeouts */
+#define INIT_TIMEOUT      100
+#define CMD_TIMEOUT       100000
+#define TRANSFER_TIMEOUT  100000
+#define BUSY_TIMEOUT      32767
+
+#define MODE_MMC 0
+#define MODE_SD 1
+#define MODE_SDHC 2
+
+/* list of supported pcmcia devices */
+static struct pcmcia_device_id pcmcia_ids[] = {
+	/* vendor and device strings followed by their crc32 hashes */
+	PCMCIA_DEVICE_PROD_ID12("RICOH", "Bay1Controller", 0xd9f522ed,
+				0xc3901202),
+	PCMCIA_DEVICE_NULL,
+};
+
+MODULE_DEVICE_TABLE(pcmcia, pcmcia_ids);
+
+/* mmc privdata */
+struct sdricoh_host {
+	struct device *dev;
+	struct mmc_host *mmc;	/* MMC structure */
+	unsigned char __iomem *iobase;
+	struct pci_dev *pci_dev;
+	int mode;
+};
+
+/***************** register i/o helper functions *****************************/
+
+static inline unsigned int sdricoh_readl(struct sdricoh_host *host,
+					 unsigned int reg)
+{
+	unsigned int value = readl(host->iobase + reg);
+	dev_vdbg(host->dev, "rl %x 0x%x\n", reg, value);
+	return value;
+}
+
+static inline void sdricoh_writel(struct sdricoh_host *host, unsigned int reg,
+				  unsigned int value)
+{
+	writel(value, host->iobase + reg);
+	dev_vdbg(host->dev, "wl %x 0x%x\n", reg, value);
+
+}
+
+static inline unsigned int sdricoh_readw(struct sdricoh_host *host,
+					 unsigned int reg)
+{
+	unsigned int value = readw(host->iobase + reg);
+	dev_vdbg(host->dev, "rb %x 0x%x\n", reg, value);
+	return value;
+}
+
+static inline unsigned int sdricoh_readb(struct sdricoh_host *host,
+					 unsigned int reg)
+{
+	unsigned int value = readb(host->iobase + reg);
+	dev_vdbg(host->dev, "rb %x 0x%x\n", reg, value);
+	return value;
+}
+
+static int sdricoh_query_status(struct sdricoh_host *host, unsigned int wanted,
+				unsigned int timeout){
+	unsigned int loop;
+	unsigned int status = 0;
+	struct device *dev = host->dev;
+	for (loop = 0; loop < timeout; loop++) {
+		status = sdricoh_readl(host, R21C_STATUS);
+		sdricoh_writel(host, R2E4_STATUS_RESP, status);
+		if (status & wanted)
+			break;
+	}
+
+	if (loop == timeout) {
+		dev_err(dev, "query_status: timeout waiting for data\n");
+		return -ETIMEDOUT;
+	}
+
+	/* do not do this check in the loop as some commands fail otherwise */
+	if (status & 0x7F0000) {
+		dev_err(dev, "waiting for status bit %x failed\n", wanted);
+		return -EINVAL;
+	}
+	return 0;
+
+}
+
+static int sdricoh_mmc_cmd(struct sdricoh_host *host, unsigned char opcode,
+			   unsigned int arg)
+{
+	unsigned int status;
+	int result = 0;
+	unsigned int loop = 0;
+	struct device *dev = host->dev;
+	/* reset status reg? */
+	sdricoh_writel(host, R21C_STATUS, 0x18);
+	/* fill parameters */
+	sdricoh_writel(host, R204_CMD_ARG, arg);
+	sdricoh_writel(host, R200_CMD, (0x10000 << 8) | opcode);
+	/* wait for command completion */
+	if (opcode) {
+		for (loop = 0; loop < CMD_TIMEOUT; loop++) {
+			status = sdricoh_readl(host, R21C_STATUS);
+			sdricoh_writel(host, R2E4_STATUS_RESP, status);
+			if (status  & STATUS_CMD_FINISHED)
+				break;
+		}
+		/* don't check for timeout in the loop it is not always
+		   reset correctly
+		*/
+		if (loop == CMD_TIMEOUT || status & STATUS_CMD_TIMEOUT)
+			result = -ETIMEDOUT;
+
+	}
+	dev_dbg(dev, "mmc_cmd opcode=%i arg=0x%x => %i (queries=%i)\n",
+	    opcode, arg, result, loop);
+
+	if (result == 0) {
+		/* EXT_CSD are filtered so this should be save */
+		if (opcode == SD_SEND_IF_COND) {
+			if (host->mode != MODE_SDHC) {
+				dev_info(dev, "switching to SDHC mode\n");
+				host->mode = MODE_SDHC;
+			}
+		}
+
+		/* switch to SD mode if APP_CMDs are supported */
+		if (opcode == MMC_APP_CMD) {
+			if (host->mode == MODE_MMC) {
+				dev_info(dev, "switching to SD mode\n");
+				host->mode = MODE_SD;
+			}
+		}
+	}
+
+	return result;
+
+}
+
+static int sdricoh_reset(struct sdricoh_host *host)
+{
+	dev_dbg(host->dev, "reset\n");
+	sdricoh_writel(host, R2F0_RESET, 0x10001);
+	sdricoh_writel(host, R2E0_INIT, 0x10000);
+	if (sdricoh_readl(host, R2E0_INIT) != 0x10000)
+		return -EIO;
+	sdricoh_writel(host, R2E0_INIT, 0x10007);
+
+	sdricoh_writel(host, R224_MODE, 0x2000000);
+	sdricoh_writel(host, R228_POWER, 0xe0);
+
+
+	/* status register ? */
+	sdricoh_writel(host, R21C_STATUS, 0x18);
+
+	return 0;
+}
+
+static int sdricoh_blockio(struct sdricoh_host *host, int read,
+				unsigned int *buf)
+{
+	int i;
+	/* wait until the data is available */
+	if (read) {
+		if (sdricoh_query_status(host, STATUS_READY_TO_READ,
+						TRANSFER_TIMEOUT))
+			return 0;
+		sdricoh_writel(host, R21C_STATUS, 0x18);
+		/* read data */
+		for (i = 0; i < 512 / 4; i++)
+			buf[i] = sdricoh_readl(host, R230_DATA);
+	} else {
+		if (sdricoh_query_status(host, STATUS_READY_TO_WRITE,
+						TRANSFER_TIMEOUT))
+			return 0;
+		sdricoh_writel(host, R21C_STATUS, 0x18);
+		/* write data */
+		for (i = 0; i < 512 / 4; i++)
+			sdricoh_writel(host, R230_DATA, buf[i]);
+	}
+
+	return 512;
+}
+
+static int sdricoh_busy(struct sdricoh_host *host)
+{
+	unsigned int status;
+	int i;
+	/* wait until the tranfer is finished */
+	for (i = 0; i < BUSY_TIMEOUT; i++) {
+		status = sdricoh_readl(host, R21C_STATUS);
+		sdricoh_writel(host, R2E4_STATUS_RESP, status);
+		if (!(status & STATUS_BUSY))
+			break;
+	}
+	if (status & 0x7F0000)
+		return -EINVAL;
+	if (i == BUSY_TIMEOUT)
+		return -ETIMEDOUT;
+	return 0;
+}
+
+
+static void sdricoh_request(struct mmc_host *mmc, struct mmc_request *mrq)
+{
+	struct sdricoh_host *host = mmc_priv(mmc);
+	struct mmc_command *cmd = mrq->cmd;
+	struct mmc_data *data = cmd->data;
+	struct device *dev = host->dev;
+	int i;
+
+	dev_dbg(dev, "=============================\n");
+	dev_dbg(dev, "sdricoh_request opcode=%i\n", cmd->opcode);
+
+	sdricoh_writel(host, R21C_STATUS, 0x18);
+
+	/* we cannot handle all commands that require a block transfer
+	   therefore do some ugly special handling here
+	*/
+	if (cmd->data) {
+		switch (cmd->opcode) {
+		/* working commands */
+		case MMC_READ_SINGLE_BLOCK:
+		case MMC_READ_MULTIPLE_BLOCK:
+		case MMC_WRITE_BLOCK:
+		case MMC_WRITE_MULTIPLE_BLOCK:
+			break;
+		case SD_APP_SEND_SCR: /* required for SDHC */
+			cmd->error = sdricoh_mmc_cmd(host, cmd->opcode,
+							cmd->arg);
+			mmc_request_done(mmc, mrq);
+			return;
+		default:
+			dev_dbg(dev, "unsupported command %i\n", cmd->opcode);
+			cmd->error = -EINVAL;
+			mmc_request_done(mmc, mrq);
+			return;
+		}
+	}
+
+
+	/* read/write commands seem to require this */
+	if (data) {
+		cmd->error = sdricoh_busy(host);
+		if (cmd->error)
+			dev_err(dev, "sdricoh_request: unable to prepare "
+				"transfer %x\n", cmd->error);
+		sdricoh_writel(host, R208_DATAIO, 0);
+	}
+
+
+	cmd->error = sdricoh_mmc_cmd(host, cmd->opcode, cmd->arg);
+
+	/* read response buffer */
+	if (cmd->flags & MMC_RSP_PRESENT) {
+		if (cmd->flags & MMC_RSP_136) {
+			/* CRC is stripped so we need to do some shifting. */
+			for (i = 0; i < 4; i++) {
+				cmd->resp[i] =
+				    sdricoh_readl(host,
+						  R20C_RESP + (3 - i) * 4) << 8;
+				if (i != 3)
+					cmd->resp[i] |=
+					    sdricoh_readb(host, R20C_RESP +
+							  (3 - i) * 4 - 1);
+			}
+			dev_dbg(dev, "resp[0]=0x%x\n", cmd->resp[0]);
+			dev_dbg(dev, "resp[1]=0x%x\n", cmd->resp[1]);
+			dev_dbg(dev, "resp[2]=0x%x\n", cmd->resp[2]);
+			dev_dbg(dev, "resp[2]=0x%x\n", cmd->resp[3]);
+		} else {
+			cmd->resp[0] = sdricoh_readl(host, R20C_RESP);
+			dev_dbg(dev, "resp[0]=0x%x\n", cmd->resp[0]);
+		}
+	}
+
+	/* yet another workaround */
+	/* without the extra command SD cards do not work at all */
+	if (cmd->opcode == MMC_SELECT_CARD) {
+		if (host->mode != MODE_MMC) {
+			sdricoh_mmc_cmd(host, MMC_APP_CMD, cmd->arg);
+			sdricoh_mmc_cmd(host, 0x46, 0x02);
+		} else {
+			sdricoh_writel(host, R228_POWER, 0xc0e0);
+			sdricoh_writel(host, R224_MODE, 0x2000301);
+		}
+	}
+
+	/* transfer data */
+	if (data && cmd->error == 0) {
+		dev_dbg(dev, "transfer: blksz %i blocks %i sg_len %i "
+			"sg length %i\n", data->blksz, data->blocks,
+			data->sg_len, data->sg->length);
+
+		/* enter data reading mode */
+		sdricoh_writel(host, R21C_STATUS, 0x837f031e);
+		for (i = 0; i < data->blocks; i++) {
+			unsigned int *buf;
+			struct page *page;
+			size_t xfered;
+			page = sg_page(data->sg);
+
+			buf = kmap(page) + data->sg->offset + (512 * i);
+			xfered =
+				sdricoh_blockio(host,
+					data->flags & MMC_DATA_READ, buf);
+			kunmap(page);
+			flush_dcache_page(page);
+			if (!xfered) {
+				dev_err(dev, "sdricoh_request: "
+					"block transfer failed\n");
+				cmd->error = -EINVAL;
+				break;
+			} else
+				data->bytes_xfered += xfered;
+		}
+
+		sdricoh_writel(host, R208_DATAIO, 1);
+
+		if (sdricoh_query_status(host, STATUS_TRANSFER_FINISHED,
+					TRANSFER_TIMEOUT)) {
+			dev_err(dev, "sdricoh_request: transfer end error\n");
+			cmd->error = -EINVAL;
+		}
+
+		if (!cmd->error) {
+			cmd->error = sdricoh_busy(host);
+			if (cmd->error)
+				dev_err(dev, "sdricoh_request: transfer not "
+					"finished %x\n", cmd->error);
+		}
+
+	}
+
+	mmc_request_done(mmc, mrq);
+	dev_dbg(dev, "=============================\n");
+}
+
+static void sdricoh_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
+{
+	struct sdricoh_host *host = mmc_priv(mmc);
+	dev_dbg(host->dev, "set_ios\n");
+
+	if (ios->power_mode == MMC_POWER_ON) {
+		sdricoh_writel(host, R228_POWER, 0xc0e0);
+
+		if (host->mode != MODE_MMC) {
+			sdricoh_writel(host, R224_MODE, 0x2000300);
+			sdricoh_writel(host, R228_POWER, 0x40e0);
+		} else {
+			sdricoh_writel(host, R224_MODE, 0x2000340);
+		}
+	} else if (ios->power_mode == MMC_POWER_UP) {
+		sdricoh_writel(host, R224_MODE, 0x2000320);
+		sdricoh_writel(host, R228_POWER, 0xe0);
+	}
+}
+
+static int sdricoh_get_ro(struct mmc_host *mmc)
+{
+	struct sdricoh_host *host = mmc_priv(mmc);
+	unsigned int status;
+
+	status = sdricoh_readl(host, R21C_STATUS);
+	sdricoh_writel(host, R2E4_STATUS_RESP, status);
+
+	/* some notebooks seem to have the locked flag switched */
+	if (switchlocked)
+		return !(status & STATUS_CARD_LOCKED);
+
+	return (status & STATUS_CARD_LOCKED);
+}
+
+static struct mmc_host_ops sdricoh_ops = {
+	.request = sdricoh_request,
+	.set_ios = sdricoh_set_ios,
+	.get_ro = sdricoh_get_ro,
+};
+
+/* initialize the control and register it to the mmc framework */
+static int sdricoh_init_mmc(struct pci_dev *pci_dev,
+			    struct pcmcia_device *pcmcia_dev)
+{
+	int result = 0;
+	void __iomem *iobase = NULL;
+	struct mmc_host *mmc = NULL;
+	struct sdricoh_host *host = NULL;
+	struct device *dev = &pcmcia_dev->dev;
+	/* map iomem */
+	if (pci_resource_len(pci_dev, SDRICOH_PCI_REGION) !=
+	    SDRICOH_PCI_REGION_SIZE) {
+		dev_dbg(dev, "unexpected pci resource len\n");
+		return -ENODEV;
+	}
+	iobase =
+	    pci_iomap(pci_dev, SDRICOH_PCI_REGION, SDRICOH_PCI_REGION_SIZE);
+	if (!iobase) {
+		dev_err(dev, "unable to map iobase\n");
+		return -ENODEV;
+	}
+	/* check version? */
+	if (readl(iobase + R104_VERSION) != 0x4000) {
+		dev_dbg(dev, "no supported mmc controller found\n");
+		result = -ENODEV;
+		goto err;
+	}
+	/* allocate privdata */
+	mmc = pcmcia_dev->priv =
+	    mmc_alloc_host(sizeof(struct sdricoh_host), &pcmcia_dev->dev);
+	if (!mmc) {
+		dev_err(dev, "mmc_alloc_host failed\n");
+		result = -ENOMEM;
+		goto err;
+	}
+	host = mmc_priv(mmc);
+
+	host->iobase = iobase;
+	host->dev = dev;
+	host->pci_dev = pci_dev;
+
+	mmc->ops = &sdricoh_ops;
+
+	/* FIXME: frequency and voltage handling is done by the controller
+	 */
+	mmc->f_min = 450000;
+	mmc->f_max = 24000000;
+	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
+
+	mmc->max_seg_size = 1024 * 512;
+
+	/* reset the controler */
+	if (sdricoh_reset(host)) {
+		dev_dbg(dev, "could not reset\n");
+		result = -EIO;
+		goto err;
+
+	}
+
+	result = mmc_add_host(mmc);
+
+	if (!result) {
+		dev_dbg(dev, "mmc host registered\n");
+		return 0;
+	}
+
+err:
+	if (iobase)
+		iounmap(iobase);
+	if (mmc)
+		mmc_free_host(mmc);
+
+	return result;
+}
+
+/* search for supported mmc controllers */
+static int sdricoh_pcmcia_probe(struct pcmcia_device *pcmcia_dev)
+{
+	struct pci_dev *pci_dev = NULL;
+
+	dev_info(&pcmcia_dev->dev, "Searching MMC controller for pcmcia device"
+		" %s %s ...\n", pcmcia_dev->prod_id[0], pcmcia_dev->prod_id[1]);
+
+	/* search pci cardbus bridge that contains the mmc controler */
+	/* the io region is already claimed by yenta_socket... */
+	while ((pci_dev =
+		pci_get_device(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_RL5C476,
+			       pci_dev))) {
+		/* try to init the device */
+		if (!sdricoh_init_mmc(pci_dev, pcmcia_dev)) {
+			dev_info(&pcmcia_dev->dev, "MMC controller found\n");
+			return 0;
+		}
+
+	}
+	dev_err(&pcmcia_dev->dev, "No MMC controller was found.\n");
+	return -ENODEV;
+}
+
+static void sdricoh_pcmcia_detach(struct pcmcia_device *link)
+{
+	struct mmc_host *mmc = link->priv;
+
+	dev_dbg(&link->dev, "detach\n");
+
+	/* remove mmc host */
+	if (mmc) {
+		struct sdricoh_host *host = mmc_priv(mmc);
+		mmc_remove_host(mmc);
+		pci_iounmap(host->pci_dev, host->iobase);
+		pci_dev_put(host->pci_dev);
+		mmc_free_host(mmc);
+	}
+	pcmcia_disable_device(link);
+
+}
+
+static int sdricoh_pcmcia_suspend(struct pcmcia_device *link)
+{
+	struct mmc_host *mmc = link->priv;
+	dev_dbg(&link->dev, "suspend\n");
+	mmc_suspend_host(mmc, PMSG_SUSPEND);
+	return 0;
+}
+
+static int sdricoh_pcmcia_resume(struct pcmcia_device *link)
+{
+	struct mmc_host *mmc = link->priv;
+	dev_dbg(&link->dev, "resume\n");
+	sdricoh_reset(mmc_priv(mmc));
+	mmc_resume_host(mmc);
+	return 0;
+}
+
+static struct pcmcia_driver sdricoh_driver = {
+	.drv = {
+		.name = DRIVER_NAME,
+		},
+	.probe = sdricoh_pcmcia_probe,
+	.remove = sdricoh_pcmcia_detach,
+	.id_table = pcmcia_ids,
+	.suspend = sdricoh_pcmcia_suspend,
+	.resume = sdricoh_pcmcia_resume,
+};
+
+/*****************************************************************************\
+ *                                                                           *
+ * Driver init/exit                                                          *
+ *                                                                           *
+\*****************************************************************************/
+
+static int __init sdricoh_drv_init(void)
+{
+	pr_debug("Ricoh PCMCIA Secure Digital Interface driver\n");
+	pr_debug("Copyright(c) 2006 - 2008 Sascha Sommer\n");
+	return pcmcia_register_driver(&sdricoh_driver);
+}
+
+static void __exit sdricoh_drv_exit(void)
+{
+	pr_debug("exiting\n");
+	pcmcia_unregister_driver(&sdricoh_driver);
+
+}
+
+module_init(sdricoh_drv_init);
+module_exit(sdricoh_drv_exit);
+
+module_param(switchlocked, uint, 0444);
+
+MODULE_AUTHOR("Sascha Sommer <saschasommer@freenet.de>");
+MODULE_DESCRIPTION("Ricoh PCMCIA Secure Digital Interface driver");
+MODULE_LICENSE("GPL");
+
+MODULE_PARM_DESC(switchlocked, "Switch the cards locked status."
+		"Use this when unlocked cards are shown readonly (default 0)");
_

Patches currently in -mm which might be from saschasommer@freenet.de are

mmc-sd-host-driver-for-ricoh-bay1controllers.patch

