From: akpm@linux-foundation.org
Subject: - char-cyclades-add-firmware-loading.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:06:11 -0700
Message-ID: <200707172306.l6HN6BSs011991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43762 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933045AbXGQXPP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, add firmware loading
has been removed from the -mm tree.  Its filename was
     char-cyclades-add-firmware-loading.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, add firmware loading
From: Jiri Slaby <jirislaby@gmail.com>

cyclades, add firmware loading

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |  351 +++++++++++++++++++++++++++++++++++---
 1 file changed, 328 insertions(+), 23 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-add-firmware-loading drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-add-firmware-loading
+++ a/drivers/char/cyclades.c
@@ -646,6 +646,7 @@
 #include <linux/delay.h>
 #include <linux/spinlock.h>
 #include <linux/bitops.h>
+#include <linux/firmware.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -680,6 +681,44 @@ static void cy_send_xchar(struct tty_str
 
 #define STD_COM_FLAGS (0)
 
+/* firmware stuff */
+#define ZL_MAX_BLOCKS	16
+#define DRIVER_VERSION	0x02010203
+#define RAM_SIZE 0x80000
+
+#define Z_FPGA_LOADED(X)	((readl(&(X)->init_ctrl) & (1<<17)) != 0)
+
+enum zblock_type {
+	ZBLOCK_PRG = 0,
+	ZBLOCK_FPGA = 1
+};
+
+struct zfile_header {
+	char name[64];
+	char date[32];
+	char aux[32];
+	u32 n_config;
+	u32 config_offset;
+	u32 n_blocks;
+	u32 block_offset;
+	u32 reserved[9];
+} __attribute__ ((packed));
+
+struct zfile_config {
+	char name[64];
+	u32 mailbox;
+	u32 function;
+	u32 n_blocks;
+	u32 block_list[ZL_MAX_BLOCKS];
+} __attribute__ ((packed));
+
+struct zfile_block {
+	u32 type;
+	u32 file_offset;
+	u32 ram_offset;
+	u32 size;
+} __attribute__ ((packed));
+
 static struct tty_driver *cy_serial_driver;
 
 #ifdef CONFIG_ISA
@@ -4735,17 +4774,295 @@ static int __init cy_detect_isa(void)
 }				/* cy_detect_isa */
 
 #ifdef CONFIG_PCI
-static void __devinit plx_init(void __iomem * addr, __u32 initctl)
+static inline int __devinit cyc_isfwstr(const char *str, unsigned int size)
+{
+	unsigned int a;
+
+	for (a = 0; a < size && *str; a++, str++)
+		if (*str & 0x80)
+			return -EINVAL;
+
+	for (; a < size; a++, str++)
+		if (*str)
+			return -EINVAL;
+
+	return 0;
+}
+
+static inline void __devinit cyz_fpga_copy(void __iomem *fpga, u8 *data,
+		unsigned int size)
+{
+	for (; size > 0; size--) {
+		cy_writel(fpga, *data++);
+		udelay(10);
+	}
+}
+
+static void __devinit plx_init(struct pci_dev *pdev, int irq,
+		struct RUNTIME_9060 __iomem *addr)
 {
 	/* Reset PLX */
-	cy_writel(addr + initctl, readl(addr + initctl) | 0x40000000);
+	cy_writel(&addr->init_ctrl, readl(&addr->init_ctrl) | 0x40000000);
 	udelay(100L);
-	cy_writel(addr + initctl, readl(addr + initctl) & ~0x40000000);
+	cy_writel(&addr->init_ctrl, readl(&addr->init_ctrl) & ~0x40000000);
 
 	/* Reload Config. Registers from EEPROM */
-	cy_writel(addr + initctl, readl(addr + initctl) | 0x20000000);
+	cy_writel(&addr->init_ctrl, readl(&addr->init_ctrl) | 0x20000000);
 	udelay(100L);
-	cy_writel(addr + initctl, readl(addr + initctl) & ~0x20000000);
+	cy_writel(&addr->init_ctrl, readl(&addr->init_ctrl) & ~0x20000000);
+
+	/* For some yet unknown reason, once the PLX9060 reloads the EEPROM,
+	 * the IRQ is lost and, thus, we have to re-write it to the PCI config.
+	 * registers. This will remain here until we find a permanent fix.
+	 */
+	pci_write_config_byte(pdev, PCI_INTERRUPT_LINE, irq);
+}
+
+static int __devinit __cyz_load_fw(const struct firmware *fw,
+		const char *name, const u32 mailbox, void __iomem *base,
+		void __iomem *fpga)
+{
+	void *ptr = fw->data;
+	struct zfile_header *h = ptr;
+	struct zfile_config *c, *cs;
+	struct zfile_block *b, *bs;
+	unsigned int a, tmp, len = fw->size;
+#define BAD_FW KERN_ERR "Bad firmware: "
+	if (len < sizeof(*h)) {
+		printk(BAD_FW "too short: %u<%zu\n", len, sizeof(*h));
+		return -EINVAL;
+	}
+
+	cs = ptr + h->config_offset;
+	bs = ptr + h->block_offset;
+
+	if ((void *)(cs + h->n_config) > ptr + len ||
+			(void *)(bs + h->n_blocks) > ptr + len) {
+		printk(BAD_FW "too short");
+		return  -EINVAL;
+	}
+
+	if (cyc_isfwstr(h->name, sizeof(h->name)) ||
+			cyc_isfwstr(h->date, sizeof(h->date))) {
+		printk(BAD_FW "bad formatted header string\n");
+		return -EINVAL;
+	}
+
+	if (strncmp(name, h->name, sizeof(h->name))) {
+		printk(BAD_FW "bad name '%s' (expected '%s')\n", h->name, name);
+		return -EINVAL;
+	}
+
+	tmp = 0;
+	for (c = cs; c < cs + h->n_config; c++) {
+		for (a = 0; a < c->n_blocks; a++)
+			if (c->block_list[a] > h->n_blocks) {
+				printk(BAD_FW "bad block ref number in cfgs\n");
+				return -EINVAL;
+			}
+		if (c->mailbox == mailbox && c->function == 0) /* 0 is normal */
+			tmp++;
+	}
+	if (!tmp) {
+		printk(BAD_FW "nothing appropriate\n");
+		return -EINVAL;
+	}
+
+	for (b = bs; b < bs + h->n_blocks; b++)
+		if (b->file_offset + b->size > len) {
+			printk(BAD_FW "bad block data offset\n");
+			return -EINVAL;
+		}
+
+	/* everything is OK, let's seek'n'load it */
+	for (c = cs; c < cs + h->n_config; c++)
+		if (c->mailbox == mailbox && c->function == 0)
+			break;
+
+	for (a = 0; a < c->n_blocks; a++) {
+		b = &bs[c->block_list[a]];
+		if (b->type == ZBLOCK_FPGA) {
+			if (fpga != NULL)
+				cyz_fpga_copy(fpga, ptr + b->file_offset,
+						b->size);
+		} else {
+			if (base != NULL)
+				memcpy_toio(base + b->ram_offset,
+					       ptr + b->file_offset, b->size);
+		}
+	}
+#undef BAD_FW
+	return 0;
+}
+
+static int __devinit cyz_load_fw(struct pci_dev *pdev, void __iomem *base_addr,
+		struct RUNTIME_9060 __iomem *ctl_addr, int irq)
+{
+	const struct firmware *fw;
+	struct FIRM_ID __iomem *fid = base_addr + ID_ADDRESS;
+	struct CUSTOM_REG __iomem *cust = base_addr;
+	struct ZFW_CTRL __iomem *pt_zfwctrl;
+	u8 *tmp;
+	u32 mailbox, status;
+	unsigned int i;
+	int retval;
+
+	retval = request_firmware(&fw, "cyzfirm.bin", &pdev->dev);
+	if (retval) {
+		dev_err(&pdev->dev, "can't get firmware\n");
+		goto err;
+	}
+
+	/* Check whether the firmware is already loaded and running. If
+	   positive, skip this board */
+	if (Z_FPGA_LOADED(ctl_addr) && readl(&fid->signature) == ZFIRM_ID) {
+		u32 cntval = readl(base_addr + 0x190);
+
+		udelay(100);
+		if (cntval != readl(base_addr + 0x190)) {
+			/* FW counter is working, FW is running */
+			dev_dbg(&pdev->dev, "Cyclades-Z FW already loaded. "
+					"Skipping board.\n");
+			retval = 0;
+			goto err_rel;
+		}
+	}
+
+	/* start boot */
+	cy_writel(&ctl_addr->intr_ctrl_stat, readl(&ctl_addr->intr_ctrl_stat) &
+			~0x00030800UL);
+
+	mailbox = readl(&ctl_addr->mail_box_0);
+
+	if (mailbox == 0 || Z_FPGA_LOADED(ctl_addr)) {
+		/* stops CPU and set window to beginning of RAM */
+		cy_writel(&ctl_addr->loc_addr_base, WIN_CREG);
+		cy_writel(&cust->cpu_stop, 0);
+		cy_writel(&ctl_addr->loc_addr_base, WIN_RAM);
+		udelay(100);
+	}
+
+	plx_init(pdev, irq, ctl_addr);
+
+	if (mailbox != 0) {
+		/* load FPGA */
+		retval = __cyz_load_fw(fw, "Cyclom-Z", mailbox, NULL,
+				base_addr);
+		if (retval)
+			goto err_rel;
+		if (!Z_FPGA_LOADED(ctl_addr)) {
+			dev_err(&pdev->dev, "fw upload successful, but fw is "
+					"not loaded\n");
+			goto err_rel;
+		}
+	}
+
+	/* stops CPU and set window to beginning of RAM */
+	cy_writel(&ctl_addr->loc_addr_base, WIN_CREG);
+	cy_writel(&cust->cpu_stop, 0);
+	cy_writel(&ctl_addr->loc_addr_base, WIN_RAM);
+	udelay(100);
+
+	/* clear memory */
+	for (tmp = base_addr; (void *)tmp < base_addr + RAM_SIZE; tmp++)
+		cy_writeb(tmp, 255);
+	if (mailbox != 0) {
+		/* set window to last 512K of RAM */
+		cy_writel(&ctl_addr->loc_addr_base, WIN_RAM + RAM_SIZE);
+		//sleep(1);
+		for (tmp = base_addr; (void *)tmp < base_addr + RAM_SIZE; tmp++)
+			cy_writeb(tmp, 255);
+		/* set window to beginning of RAM */
+		cy_writel(&ctl_addr->loc_addr_base, WIN_RAM);
+		//sleep(1);
+	}
+
+	retval = __cyz_load_fw(fw, "Cyclom-Z", mailbox, base_addr, NULL);
+	release_firmware(fw);
+	if (retval)
+		goto err;
+
+	/* finish boot and start boards */
+	cy_writel(&ctl_addr->loc_addr_base, WIN_CREG);
+	cy_writel(&cust->cpu_start, 0);
+	cy_writel(&ctl_addr->loc_addr_base, WIN_RAM);
+	i = 0;
+	while ((status = readl(&fid->signature)) != ZFIRM_ID && i++ < 40)
+		msleep(100);
+	if (status != ZFIRM_ID) {
+		if (status == ZFIRM_HLT) {
+			dev_err(&pdev->dev, "you need an external power supply "
+				"for this number of ports. Firmware halted and "
+				"board reset.\n");
+			retval = -EIO;
+			goto err;
+		}
+		dev_warn(&pdev->dev, "fid->signature = 0x%x... Waiting "
+				"some more time\n", status);
+		while ((status = readl(&fid->signature)) != ZFIRM_ID &&
+				i++ < 200)
+			msleep(100);
+		if (status != ZFIRM_ID) {
+			dev_err(&pdev->dev, "Board not started in 20 seconds! "
+					"Giving up. (fid->signature = 0x%x)\n",
+					status);
+			dev_info(&pdev->dev, "*** Warning ***: if you are "
+				"upgrading the FW, please power cycle the "
+				"system before loading the new FW to the "
+				"Cyclades-Z.\n");
+
+			if (Z_FPGA_LOADED(ctl_addr))
+				plx_init(pdev, irq, ctl_addr);
+
+			retval = -EIO;
+			goto err;
+		}
+		dev_dbg(&pdev->dev, "Firmware started after %d seconds.\n",
+				i / 10);
+	}
+	pt_zfwctrl = base_addr + readl(&fid->zfwctrl_addr);
+
+	dev_dbg(&pdev->dev, "fid=> %p, zfwctrl_addr=> %x, npt_zfwctrl=> %p\n",
+			base_addr + ID_ADDRESS, readl(&fid->zfwctrl_addr),
+			base_addr + readl(&fid->zfwctrl_addr));
+
+	dev_info(&pdev->dev, "Cyclades-Z FW loaded: version = %x, ports = %u\n",
+		readl(&pt_zfwctrl->board_ctrl.fw_version),
+		readl(&pt_zfwctrl->board_ctrl.n_channel));
+
+	if (readl(&pt_zfwctrl->board_ctrl.n_channel) == 0) {
+		dev_warn(&pdev->dev, "no Cyclades-Z ports were found. Please "
+			"check the connection between the Z host card and the "
+			"serial expanders.\n");
+
+		if (Z_FPGA_LOADED(ctl_addr))
+			plx_init(pdev, irq, ctl_addr);
+
+		dev_info(&pdev->dev, "Null number of ports detected. Board "
+				"reset.\n");
+		retval = 0;
+		goto err;
+	}
+
+	cy_writel(&pt_zfwctrl->board_ctrl.op_system, C_OS_LINUX);
+	cy_writel(&pt_zfwctrl->board_ctrl.dr_version, DRIVER_VERSION);
+
+	/*
+	   Early firmware failed to start looking for commands.
+	   This enables firmware interrupts for those commands.
+	 */
+	cy_writel(&ctl_addr->intr_ctrl_stat, readl(&ctl_addr->intr_ctrl_stat) |
+			(1 << 17));
+	cy_writel(&ctl_addr->intr_ctrl_stat, readl(&ctl_addr->intr_ctrl_stat) |
+			0x00030800UL);
+
+	plx_init(pdev, irq, ctl_addr);
+
+	return 0;
+err_rel:
+	release_firmware(fw);
+err:
+	return retval;
 }
 
 static int __devinit cy_pci_probe(struct pci_dev *pdev,
@@ -4827,16 +5144,9 @@ static int __devinit cy_pci_probe(struct
 		}
 
 		/* Disable interrupts on the PLX before resetting it */
-		cy_writew(addr0 + 0x68,
-			readw(addr0 + 0x68) & ~0x0900);
+		cy_writew(addr0 + 0x68, readw(addr0 + 0x68) & ~0x0900);
 
-		plx_init(addr0, 0x6c);
-		/* For some yet unknown reason, once the PLX9060 reloads
-		   the EEPROM, the IRQ is lost and, thus, we have to
-		   re-write it to the PCI config. registers.
-		   This will remain here until we find a permanent
-		   fix. */
-		pci_write_config_byte(pdev, PCI_INTERRUPT_LINE, irq);
+		plx_init(pdev, irq, addr0);
 
 		mailbox = (u32)readl(&ctl_addr->mail_box_0);
 
@@ -4877,6 +5187,9 @@ static int __devinit cy_pci_probe(struct
 			if ((mailbox == ZO_V1) || (mailbox == ZO_V2))
 				cy_writel(addr2 + ID_ADDRESS, 0L);
 
+			retval = cyz_load_fw(pdev, addr2, addr0, irq);
+			if (retval)
+				goto err_unmap;
 			/* This must be a Cyclades-8Zo/PCI.  The extendable
 			   version will have a different device_id and will
 			   be allocated its maximum number of ports. */
@@ -4953,15 +5266,7 @@ static int __devinit cy_pci_probe(struct
 		case PLX_9060:
 		case PLX_9080:
 		default:	/* Old boards, use PLX_9060 */
-
-			plx_init(addr0, 0x6c);
-		/* For some yet unknown reason, once the PLX9060 reloads
-		   the EEPROM, the IRQ is lost and, thus, we have to
-		   re-write it to the PCI config. registers.
-		   This will remain here until we find a permanent
-		   fix. */
-			pci_write_config_byte(pdev, PCI_INTERRUPT_LINE, irq);
-
+			plx_init(pdev, irq, addr0);
 			cy_writew(addr0 + 0x68, readw(addr0 + 0x68) | 0x0900);
 			break;
 		}
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
shrink_slab-handle-bad-shrinkers.patch
