From: akpm@linux-foundation.org
Subject: + remove-pointless-casts-from-void-pointers.patch added to -mm tree
Date: Sat, 27 Oct 2007 10:01:28 -0700
Message-ID: <200710271701.l9RH1S8S021895@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58096 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755426AbXJ0REC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Oct 2007 13:04:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff@garzik.org, James.Bottomley@steeleye.com, adaplas@pol.net, benh@kernel.crashing.org, david-b@pacbell.net, dtor@mail.ru, geert@linux-m68k.org, jgarzik@redhat.com, kkeil@suse.de, linville@tuxdriver.com, paulus@samba.org, rmk@arm.linux.org.uk, tony.luck@intel.com, zippel@linux-m68k.org


The patch titled
     Remove pointless casts from void pointers
has been added to the -mm tree.  Its filename is
     remove-pointless-casts-from-void-pointers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Karsten Keil <kkeil@suse.de>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-pxa/ssp.c                    |    2 +-
 arch/arm/mach-s3c2410/usb-simtec.c         |    2 +-
 arch/arm/plat-omap/mailbox.c               |    2 +-
 arch/ia64/sn/pci/pcibr/pcibr_provider.c    |    6 +++---
 arch/m68k/amiga/cia.c                      |    2 +-
 arch/ppc/8260_io/enet.c                    |    4 ++--
 arch/ppc/8260_io/fcc_enet.c                |    4 ++--
 arch/ppc/syslib/ppc85xx_rio.c              |    6 +++---
 drivers/input/touchscreen/h3600_ts_input.c |    4 ++--
 drivers/isdn/hardware/eicon/diva.c         |    5 ++---
 drivers/net/ibmlana.c                      |    4 ++--
 drivers/net/wireless/airo.c                |    5 +++--
 drivers/net/wireless/hostap/hostap_hw.c    |    2 +-
 drivers/net/wireless/libertas/if_cs.c      |    2 +-
 drivers/scsi/aic7xxx_old.c                 |    2 +-
 drivers/scsi/ibmvscsi/ibmvstgt.c           |    4 ++--
 drivers/serial/cpm_uart/cpm_uart_core.c    |    2 +-
 drivers/serial/dz.c                        |    2 +-
 drivers/serial/imx.c                       |    4 ++--
 drivers/serial/uartlite.c                  |    2 +-
 drivers/spi/spi_bfin5xx.c                  |    2 +-
 drivers/video/bf54x-lq043fb.c              |    3 +--
 drivers/video/intelfb/intelfbhw.c          |    2 +-
 sound/oss/waveartist.c                     |    2 +-
 24 files changed, 37 insertions(+), 38 deletions(-)

diff -puN arch/arm/mach-pxa/ssp.c~remove-pointless-casts-from-void-pointers arch/arm/mach-pxa/ssp.c
--- a/arch/arm/mach-pxa/ssp.c~remove-pointless-casts-from-void-pointers
+++ a/arch/arm/mach-pxa/ssp.c
@@ -67,7 +67,7 @@ static int use_count[PXA_SSP_PORTS] = {0
 
 static irqreturn_t ssp_interrupt(int irq, void *dev_id)
 {
-	struct ssp_dev *dev = (struct ssp_dev*) dev_id;
+	struct ssp_dev *dev = dev_id;
 	unsigned int status = SSSR_P(dev->port);
 
 	SSSR_P(dev->port) = status; /* clear status bits */
diff -puN arch/arm/mach-s3c2410/usb-simtec.c~remove-pointless-casts-from-void-pointers arch/arm/mach-s3c2410/usb-simtec.c
--- a/arch/arm/mach-s3c2410/usb-simtec.c~remove-pointless-casts-from-void-pointers
+++ a/arch/arm/mach-s3c2410/usb-simtec.c
@@ -60,7 +60,7 @@ usb_simtec_powercontrol(int port, int to
 static irqreturn_t
 usb_simtec_ocirq(int irq, void *pw)
 {
-	struct s3c2410_hcd_info *info = (struct s3c2410_hcd_info *)pw;
+	struct s3c2410_hcd_info *info = pw;
 
 	if (s3c2410_gpio_getpin(S3C2410_GPG10) == 0) {
 		pr_debug("usb_simtec: over-current irq (oc detected)\n");
diff -puN arch/arm/plat-omap/mailbox.c~remove-pointless-casts-from-void-pointers arch/arm/plat-omap/mailbox.c
--- a/arch/arm/plat-omap/mailbox.c~remove-pointless-casts-from-void-pointers
+++ a/arch/arm/plat-omap/mailbox.c
@@ -212,7 +212,7 @@ static void __mbox_rx_interrupt(struct o
 
 static irqreturn_t mbox_interrupt(int irq, void *p)
 {
-	struct omap_mbox *mbox = (struct omap_mbox *)p;
+	struct omap_mbox *mbox = p;
 
 	if (is_mbox_irq(mbox, IRQ_TX))
 		__mbox_tx_interrupt(mbox);
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
@@ -272,7 +272,7 @@ scc_enet_timeout(struct net_device *dev)
  * This is called from the CPM handler, not the MPC core interrupt.
  */
 static irqreturn_t
-scc_enet_interrupt(int irq, void * dev_id)
+scc_enet_interrupt(int irq, void *dev_id)
 {
 	struct	net_device *dev = dev_id;
 	volatile struct	scc_enet_private *cep;
@@ -280,7 +280,7 @@ scc_enet_interrupt(int irq, void * dev_i
 	ushort	int_events;
 	int	must_restart;
 
-	cep = (struct scc_enet_private *)dev->priv;
+	cep = dev->priv;
 
 	/* Get the interrupt events that caused us to be here.
 	*/
diff -puN arch/ppc/8260_io/fcc_enet.c~remove-pointless-casts-from-void-pointers arch/ppc/8260_io/fcc_enet.c
--- a/arch/ppc/8260_io/fcc_enet.c~remove-pointless-casts-from-void-pointers
+++ a/arch/ppc/8260_io/fcc_enet.c
@@ -524,7 +524,7 @@ fcc_enet_timeout(struct net_device *dev)
 
 /* The interrupt handler. */
 static irqreturn_t
-fcc_enet_interrupt(int irq, void * dev_id)
+fcc_enet_interrupt(int irq, void *dev_id)
 {
 	struct	net_device *dev = dev_id;
 	volatile struct	fcc_enet_private *cep;
@@ -532,7 +532,7 @@ fcc_enet_interrupt(int irq, void * dev_i
 	ushort	int_events;
 	int	must_restart;
 
-	cep = (struct fcc_enet_private *)dev->priv;
+	cep = dev->priv;
 
 	/* Get the interrupt events that caused us to be here.
 	*/
diff -puN arch/ppc/syslib/ppc85xx_rio.c~remove-pointless-casts-from-void-pointers arch/ppc/syslib/ppc85xx_rio.c
--- a/arch/ppc/syslib/ppc85xx_rio.c~remove-pointless-casts-from-void-pointers
+++ a/arch/ppc/syslib/ppc85xx_rio.c
@@ -355,7 +355,7 @@ static irqreturn_t
 mpc85xx_rio_tx_handler(int irq, void *dev_instance)
 {
 	int osr;
-	struct rio_mport *port = (struct rio_mport *)dev_instance;
+	struct rio_mport *port = dev_instance;
 
 	osr = in_be32((void *)&msg_regs->osr);
 
@@ -522,7 +522,7 @@ static irqreturn_t
 mpc85xx_rio_rx_handler(int irq, void *dev_instance)
 {
 	int isr;
-	struct rio_mport *port = (struct rio_mport *)dev_instance;
+	struct rio_mport *port = dev_instance;
 
 	isr = in_be32((void *)&msg_regs->isr);
 
@@ -740,7 +740,7 @@ static irqreturn_t
 mpc85xx_rio_dbell_handler(int irq, void *dev_instance)
 {
 	int dsr;
-	struct rio_mport *port = (struct rio_mport *)dev_instance;
+	struct rio_mport *port = dev_instance;
 
 	dsr = in_be32((void *)&msg_regs->dsr);
 
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
diff -puN drivers/net/ibmlana.c~remove-pointless-casts-from-void-pointers drivers/net/ibmlana.c
--- a/drivers/net/ibmlana.c~remove-pointless-casts-from-void-pointers
+++ a/drivers/net/ibmlana.c
@@ -704,9 +704,9 @@ static void irqtxerr_handler(struct net_
 
 /* general interrupt entry */
 
-static irqreturn_t irq_handler(int irq, void *device)
+static irqreturn_t irq_handler(int dummy, void *device)
 {
-	struct net_device *dev = (struct net_device *) device;
+	struct net_device *dev = device;
 	u16 ival;
 
 	/* in case we're not meant... */
diff -puN drivers/net/wireless/airo.c~remove-pointless-casts-from-void-pointers drivers/net/wireless/airo.c
--- a/drivers/net/wireless/airo.c~remove-pointless-casts-from-void-pointers
+++ a/drivers/net/wireless/airo.c
@@ -3177,8 +3177,9 @@ static int airo_thread(void *data) {
 	return 0;
 }
 
-static irqreturn_t airo_interrupt ( int irq, void* dev_id) {
-	struct net_device *dev = (struct net_device *)dev_id;
+static irqreturn_t airo_interrupt(int irq, void *dev_id)
+{
+	struct net_device *dev = dev_id;
 	u16 status;
 	u16 fid;
 	struct airo_info *apriv = dev->priv;
diff -puN drivers/net/wireless/hostap/hostap_hw.c~remove-pointless-casts-from-void-pointers drivers/net/wireless/hostap/hostap_hw.c
--- a/drivers/net/wireless/hostap/hostap_hw.c~remove-pointless-casts-from-void-pointers
+++ a/drivers/net/wireless/hostap/hostap_hw.c
@@ -2624,7 +2624,7 @@ static void prism2_check_magic(local_inf
 /* Called only from hardware IRQ */
 static irqreturn_t prism2_interrupt(int irq, void *dev_id)
 {
-	struct net_device *dev = (struct net_device *) dev_id;
+	struct net_device *dev = dev_id;
 	struct hostap_interface *iface;
 	local_info_t *local;
 	int events = 0;
diff -puN drivers/net/wireless/libertas/if_cs.c~remove-pointless-casts-from-void-pointers drivers/net/wireless/libertas/if_cs.c
--- a/drivers/net/wireless/libertas/if_cs.c~remove-pointless-casts-from-void-pointers
+++ a/drivers/net/wireless/libertas/if_cs.c
@@ -242,7 +242,7 @@ static inline void if_cs_disable_ints(st
 
 static irqreturn_t if_cs_interrupt(int irq, void *data)
 {
-	struct if_cs_card *card = (struct if_cs_card *)data;
+	struct if_cs_card *card = data;
 	u16 int_cause;
 
 	lbs_deb_enter(LBS_DEB_CS);
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
@@ -575,7 +575,7 @@ static void giveback(struct driver_data 
 
 static irqreturn_t dma_irq_handler(int irq, void *dev_id)
 {
-	struct driver_data *drv_data = (struct driver_data *)dev_id;
+	struct driver_data *drv_data = dev_id;
 	struct spi_message *msg = drv_data->cur_msg;
 
 	dev_dbg(&drv_data->pdev->dev, "in dma_irq_handler\n");
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
 
diff -puN sound/oss/waveartist.c~remove-pointless-casts-from-void-pointers sound/oss/waveartist.c
--- a/sound/oss/waveartist.c~remove-pointless-casts-from-void-pointers
+++ a/sound/oss/waveartist.c
@@ -835,7 +835,7 @@ static struct audio_driver waveartist_au
 static irqreturn_t
 waveartist_intr(int irq, void *dev_id)
 {
-	wavnc_info *devc = (wavnc_info *)dev_id;
+	wavnc_info *devc = dev_id;
 	int	   irqstatus, status;
 
 	spin_lock(&waveartist_lock);
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
remove-bogus-default-y-for-dmar-and-net_dma.patch
acpi-sbs-fix-retval-warning.patch
git-jg-misc.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-add-helper-__ide_setup_pci_device.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop-checkpatch-fixes.patch
git-netdev-all.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
hptiop-fix-type-mismatch-warning.patch
ips-remove-ips_ha-members-that-duplicate-struct-pci_dev-members.patch
ips-trim-trailing-whitespace.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
ips-pci-api-cleanups.patch
ips-handle-scsi_add_host-failure-and-other-err-cleanups.patch
git-wireless.patch
x86-fix-config_smp-warning-in-processorc.patch
x86-fix-config_smp-warning-in-processorc-fix.patch
fix-versus-precedence-in-various-places.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
riscom8-fix-smp-brokenness.patch
riscom8-fix-smp-brokenness-fix.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
sound-oss-sb_commonc-fix-casting-warning.patch
remove-warnings-for-longstanding-conditions.patch
remove-warnings-for-longstanding-conditions-fix.patch
remove-warnings-for-longstanding-conditions-checkpatch-fixes.patch
remove-pointless-casts-from-void-pointers.patch
