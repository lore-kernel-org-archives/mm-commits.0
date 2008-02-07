From: akpm@linux-foundation.org
Subject: - remove-pointless-casts-from-void-pointers.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:20:56 -0800
Message-ID: <200802070020.m170KbrN006163@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43143 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934220AbYBGA2y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:28:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, James.Bottomley@steeleye.com, adaplas@pol.net, benh@kernel.crashing.org, david-b@pacbell.net, dtor@mail.ru, geert@linux-m68k.org, hs4233@mail.mn-solutions.de, jgarzik


The patch titled
     Remove pointless casts from void pointers
has been removed from the -mm tree.  Its filename was
     remove-pointless-casts-from-void-pointers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Remove pointless casts from void pointers
From: Jeff Garzik <jeff@garzik.org>

Mostly in and around irq handlers.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: "Luck Tony" <tony.luck@intel.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Dmitry Torokhov <dtor@mail.ru>
Cc: Karsten Keil <kkeil@suse.de>
Acked-by: "John W. Linville" <linville@tuxdriver.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Acked-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Acked-by: Holger Schurig <hs4233@mail.mn-solutions.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/sn/pci/pcibr/pcibr_provider.c    |    6 +++---
 arch/m68k/amiga/cia.c                      |    2 +-
 arch/ppc/8260_io/enet.c                    |    2 +-
 arch/ppc/8260_io/fcc_enet.c                |    2 +-
 drivers/input/touchscreen/h3600_ts_input.c |    4 ++--
 drivers/isdn/hardware/eicon/diva.c         |    5 ++---
 drivers/scsi/aic7xxx_old.c                 |    2 +-
 drivers/scsi/ibmvscsi/ibmvstgt.c           |    4 ++--
 drivers/serial/cpm_uart/cpm_uart_core.c    |    2 +-
 drivers/serial/dz.c                        |    2 +-
 drivers/serial/imx.c                       |    4 ++--
 drivers/serial/uartlite.c                  |    2 +-
 drivers/spi/spi_bfin5xx.c                  |    2 +-
 drivers/video/bf54x-lq043fb.c              |    3 +--
 drivers/video/intelfb/intelfbhw.c          |    2 +-
 15 files changed, 21 insertions(+), 23 deletions(-)

diff -puN arch/ia64/sn/pci/pcibr/pcibr_provider.c~remove-pointless-casts-from-void-pointers arch/ia64/sn/pci/pcibr/pcibr_provider.c
--- a/arch/ia64/sn/pci/pcibr/pcibr_provider.c~remove-pointless-casts-from-void-pointers
+++ a/arch/ia64/sn/pci/pcibr/pcibr_provider.c
@@ -100,11 +100,11 @@ u16 sn_ioboard_to_pci_bus(struct pci_bus
 static irqreturn_t
 pcibr_error_intr_handler(int irq, void *arg)
 {
-	struct pcibus_info *soft = (struct pcibus_info *)arg;
+	struct pcibus_info *soft = arg;
 
-	if (sal_pcibr_error_interrupt(soft) < 0) {
+	if (sal_pcibr_error_interrupt(soft) < 0)
 		panic("pcibr_error_intr_handler(): Fatal Bridge Error");
-	}
+
 	return IRQ_HANDLED;
 }
 
diff -puN arch/m68k/amiga/cia.c~remove-pointless-casts-from-void-pointers arch/m68k/amiga/cia.c
--- a/arch/m68k/amiga/cia.c~remove-pointless-casts-from-void-pointers
+++ a/arch/m68k/amiga/cia.c
@@ -84,7 +84,7 @@ unsigned char cia_able_irq(struct ciabas
 
 static irqreturn_t cia_handler(int irq, void *dev_id)
 {
-	struct ciabase *base = (struct ciabase *)dev_id;
+	struct ciabase *base = dev_id;
 	int mach_irq;
 	unsigned char ints;
 
diff -puN arch/ppc/8260_io/enet.c~remove-pointless-casts-from-void-pointers arch/ppc/8260_io/enet.c
--- a/arch/ppc/8260_io/enet.c~remove-pointless-casts-from-void-pointers
+++ a/arch/ppc/8260_io/enet.c
@@ -418,7 +418,7 @@ scc_enet_rx(struct net_device *dev)
 	struct	sk_buff *skb;
 	ushort	pkt_len;
 
-	cep = (struct scc_enet_private *)dev->priv;
+	cep = dev->priv;
 
 	/* First, grab all of the stats for the incoming packet.
 	 * These get messed up if we get called due to a busy condition.
diff -puN arch/ppc/8260_io/fcc_enet.c~remove-pointless-casts-from-void-pointers arch/ppc/8260_io/fcc_enet.c
--- a/arch/ppc/8260_io/fcc_enet.c~remove-pointless-casts-from-void-pointers
+++ a/arch/ppc/8260_io/fcc_enet.c
@@ -682,7 +682,7 @@ fcc_enet_rx(struct net_device *dev)
 	struct	sk_buff *skb;
 	ushort	pkt_len;
 
-	cep = (struct fcc_enet_private *)dev->priv;
+	cep = dev->priv;
 
 	/* First, grab all of the stats for the incoming packet.
 	 * These get messed up if we get called due to a busy condition.
diff -puN drivers/input/touchscreen/h3600_ts_input.c~remove-pointless-casts-from-void-pointers drivers/input/touchscreen/h3600_ts_input.c
--- a/drivers/input/touchscreen/h3600_ts_input.c~remove-pointless-casts-from-void-pointers
+++ a/drivers/input/touchscreen/h3600_ts_input.c
@@ -109,7 +109,7 @@ struct h3600_dev {
 static irqreturn_t action_button_handler(int irq, void *dev_id)
 {
 	int down = (GPLR & GPIO_BITSY_ACTION_BUTTON) ? 0 : 1;
-	struct input_dev *dev = (struct input_dev *) dev_id;
+	struct input_dev *dev = dev_id;
 
 	input_report_key(dev, KEY_ENTER, down);
 	input_sync(dev);
@@ -120,7 +120,7 @@ static irqreturn_t action_button_handler
 static irqreturn_t npower_button_handler(int irq, void *dev_id)
 {
 	int down = (GPLR & GPIO_BITSY_NPOWER_BUTTON) ? 0 : 1;
-	struct input_dev *dev = (struct input_dev *) dev_id;
+	struct input_dev *dev = dev_id;
 
 	/*
 	 * This interrupt is only called when we release the key. So we have
diff -puN drivers/isdn/hardware/eicon/diva.c~remove-pointless-casts-from-void-pointers drivers/isdn/hardware/eicon/diva.c
--- a/drivers/isdn/hardware/eicon/diva.c~remove-pointless-casts-from-void-pointers
+++ a/drivers/isdn/hardware/eicon/diva.c
@@ -515,12 +515,11 @@ diva_xdi_read(void *adapter, void *os_ha
 
 irqreturn_t diva_os_irq_wrapper(int irq, void *context)
 {
-	diva_os_xdi_adapter_t *a = (diva_os_xdi_adapter_t *) context;
+	diva_os_xdi_adapter_t *a = context;
 	diva_xdi_clear_interrupts_proc_t clear_int_proc;
 
-	if (!a || !a->xdi_adapter.diva_isr_handler) {
+	if (!a || !a->xdi_adapter.diva_isr_handler)
 		return IRQ_NONE;
-	}
 
 	if ((clear_int_proc = a->clear_interrupts_proc)) {
 		(*clear_int_proc) (a);
diff -puN drivers/scsi/aic7xxx_old.c~remove-pointless-casts-from-void-pointers drivers/scsi/aic7xxx_old.c
--- a/drivers/scsi/aic7xxx_old.c~remove-pointless-casts-from-void-pointers
+++ a/drivers/scsi/aic7xxx_old.c
@@ -6472,7 +6472,7 @@ do_aic7xxx_isr(int irq, void *dev_id)
   unsigned long cpu_flags;
   struct aic7xxx_host *p;
   
-  p = (struct aic7xxx_host *)dev_id;
+  p = dev_id;
   if(!p)
     return IRQ_NONE;
   spin_lock_irqsave(p->host->host_lock, cpu_flags);
diff -puN drivers/scsi/ibmvscsi/ibmvstgt.c~remove-pointless-casts-from-void-pointers drivers/scsi/ibmvscsi/ibmvstgt.c
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c~remove-pointless-casts-from-void-pointers
+++ a/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -539,9 +539,9 @@ out:
 		srp_iu_put(iue);
 }
 
-static irqreturn_t ibmvstgt_interrupt(int irq, void *data)
+static irqreturn_t ibmvstgt_interrupt(int dummy, void *data)
 {
-	struct srp_target *target = (struct srp_target *) data;
+	struct srp_target *target = data;
 	struct vio_port *vport = target_to_port(target);
 
 	vio_disable_interrupts(vport->dma_dev);
diff -puN drivers/serial/cpm_uart/cpm_uart_core.c~remove-pointless-casts-from-void-pointers drivers/serial/cpm_uart/cpm_uart_core.c
--- a/drivers/serial/cpm_uart/cpm_uart_core.c~remove-pointless-casts-from-void-pointers
+++ a/drivers/serial/cpm_uart/cpm_uart_core.c
@@ -380,7 +380,7 @@ static void cpm_uart_int_rx(struct uart_
 static irqreturn_t cpm_uart_int(int irq, void *data)
 {
 	u8 events;
-	struct uart_port *port = (struct uart_port *)data;
+	struct uart_port *port = data;
 	struct uart_cpm_port *pinfo = (struct uart_cpm_port *)port;
 	smc_t __iomem *smcp = pinfo->smcp;
 	scc_t __iomem *sccp = pinfo->sccp;
diff -puN drivers/serial/dz.c~remove-pointless-casts-from-void-pointers drivers/serial/dz.c
--- a/drivers/serial/dz.c~remove-pointless-casts-from-void-pointers
+++ a/drivers/serial/dz.c
@@ -324,7 +324,7 @@ static inline void check_modem_status(st
  */
 static irqreturn_t dz_interrupt(int irq, void *dev)
 {
-	struct dz_port *dport = (struct dz_port *)dev;
+	struct dz_port *dport = dev;
 	unsigned short status;
 
 	/* get the reason why we just got an irq */
diff -puN drivers/serial/imx.c~remove-pointless-casts-from-void-pointers drivers/serial/imx.c
--- a/drivers/serial/imx.c~remove-pointless-casts-from-void-pointers
+++ a/drivers/serial/imx.c
@@ -308,7 +308,7 @@ static void imx_start_tx(struct uart_por
 
 static irqreturn_t imx_rtsint(int irq, void *dev_id)
 {
-	struct imx_port *sport = (struct imx_port *)dev_id;
+	struct imx_port *sport = dev_id;
 	unsigned int val = readl(sport->port.membase + USR1) & USR1_RTSS;
 	unsigned long flags;
 
@@ -324,7 +324,7 @@ static irqreturn_t imx_rtsint(int irq, v
 
 static irqreturn_t imx_txint(int irq, void *dev_id)
 {
-	struct imx_port *sport = (struct imx_port *)dev_id;
+	struct imx_port *sport = dev_id;
 	struct circ_buf *xmit = &sport->port.info->xmit;
 	unsigned long flags;
 
diff -puN drivers/serial/uartlite.c~remove-pointless-casts-from-void-pointers drivers/serial/uartlite.c
--- a/drivers/serial/uartlite.c~remove-pointless-casts-from-void-pointers
+++ a/drivers/serial/uartlite.c
@@ -142,7 +142,7 @@ static int ulite_transmit(struct uart_po
 
 static irqreturn_t ulite_isr(int irq, void *dev_id)
 {
-	struct uart_port *port = (struct uart_port *)dev_id;
+	struct uart_port *port = dev_id;
 	int busy;
 
 	do {
diff -puN drivers/spi/spi_bfin5xx.c~remove-pointless-casts-from-void-pointers drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~remove-pointless-casts-from-void-pointers
+++ a/drivers/spi/spi_bfin5xx.c
@@ -616,7 +616,7 @@ static void giveback(struct driver_data 
 
 static irqreturn_t dma_irq_handler(int irq, void *dev_id)
 {
-	struct driver_data *drv_data = (struct driver_data *)dev_id;
+	struct driver_data *drv_data = dev_id;
 	struct chip_data *chip = drv_data->cur_chip;
 	struct spi_message *msg = drv_data->cur_msg;
 
diff -puN drivers/video/bf54x-lq043fb.c~remove-pointless-casts-from-void-pointers drivers/video/bf54x-lq043fb.c
--- a/drivers/video/bf54x-lq043fb.c~remove-pointless-casts-from-void-pointers
+++ a/drivers/video/bf54x-lq043fb.c
@@ -498,8 +498,7 @@ static struct lcd_device *lcd_dev;
 
 static irqreturn_t bfin_bf54x_irq_error(int irq, void *dev_id)
 {
-
-	/*struct bfin_bf54xfb_info *info = (struct bfin_bf54xfb_info *)dev_id;*/
+	/*struct bfin_bf54xfb_info *info = dev_id;*/
 
 	u16 status = bfin_read_EPPI0_STATUS();
 
diff -puN drivers/video/intelfb/intelfbhw.c~remove-pointless-casts-from-void-pointers drivers/video/intelfb/intelfbhw.c
--- a/drivers/video/intelfb/intelfbhw.c~remove-pointless-casts-from-void-pointers
+++ a/drivers/video/intelfb/intelfbhw.c
@@ -1971,7 +1971,7 @@ void intelfbhw_cursor_reset(struct intel
 static irqreturn_t intelfbhw_irq(int irq, void *dev_id)
 {
 	u16 tmp;
-	struct intelfb_info *dinfo = (struct intelfb_info *)dev_id;
+	struct intelfb_info *dinfo = dev_id;
 
 	spin_lock(&dinfo->int_lock);
 
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
git-libata-all.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls-x86-fix.patch
i8k-allow-i8k-driver-to-be-built-on-x86_64-systems.patch
i8k-adds-i8k-driver-to-the-x86_64-kconfig.patch
i8k-inspiron-e1705-fix.patch
smbios-dmi-add-type-41-=-onboard-devices-extended-information.patch
