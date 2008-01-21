From: akpm@linux-foundation.org
Subject: - pata_legacy-resychronize-with-upstream-changes-and-resubmit.patch removed from -mm tree
Date: Mon, 21 Jan 2008 15:13:28 -0800
Message-ID: <200801212313.m0LNDSWA024904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48354 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756020AbYAUXOd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 18:14:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     pata_legacy: resychronize with upstream changes and resubmit
has been removed from the -mm tree.  Its filename was
     pata_legacy-resychronize-with-upstream-changes-and-resubmit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pata_legacy: resychronize with upstream changes and resubmit
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Update the legacy driver so it can handle VLB ports nicely, and has an
internal structure for nailing new ISA/VLB forms in.  Anyone got an ALI14xx
and a spare day ;)

Also adds an "all" parameter so you can load this driver after all the PCI
ones in a boot time kernel and tell it to grab anything ST412 compatible
even if it is an unknown PCI device.  That allows libata to offer the same
"just get me a disk somehow" fallback that old IDE did.

Obsoletes pata_qdi.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_legacy.c |  750 +++++++++++++++++++++++++++++-------
 1 file changed, 605 insertions(+), 145 deletions(-)

diff -puN drivers/ata/pata_legacy.c~pata_legacy-resychronize-with-upstream-changes-and-resubmit drivers/ata/pata_legacy.c
--- a/drivers/ata/pata_legacy.c~pata_legacy-resychronize-with-upstream-changes-and-resubmit
+++ a/drivers/ata/pata_legacy.c
@@ -68,8 +68,9 @@
 
 #define NR_HOST 6
 
-static int legacy_port[NR_HOST] = { 0x1f0, 0x170, 0x1e8, 0x168, 0x1e0, 0x160 };
-static int legacy_irq[NR_HOST] = { 14, 15, 11, 10, 8, 12 };
+static int all;
+module_param(all, int, 0444);
+MODULE_PARM_DESC(all, "Grab all legacy port devices, even if PCI(0=off, 1=on)");
 
 struct legacy_data {
 	unsigned long timing;
@@ -80,21 +81,103 @@ struct legacy_data {
 
 };
 
+enum controller {
+	BIOS = 0,
+	SNOOP = 1,
+	PDC20230 = 2,
+	HT6560A = 3,
+	HT6560B = 4,
+	OPTI611A = 5,
+	OPTI46X = 6,
+	QDI6500 = 7,
+	QDI6580 = 8,
+	QDI6580DP = 9,		/* Dual channel mode is different */
+
+	UNKNOWN = -1
+};
+
+
+struct legacy_probe {
+	unsigned char *name;
+	unsigned long port;
+	unsigned int irq;
+	unsigned int slot;
+	enum controller type;
+	unsigned long private;
+};
+
+struct legacy_controller {
+	const char *name;
+	struct ata_port_operations *ops;
+	unsigned int pio_mask;
+	unsigned int flags;
+	int (*setup)(struct legacy_probe *probe, struct legacy_data *data);
+};
+
+static int legacy_port[NR_HOST] = { 0x1f0, 0x170, 0x1e8, 0x168, 0x1e0, 0x160 };
+
+static struct legacy_probe probe_list[NR_HOST];
 static struct legacy_data legacy_data[NR_HOST];
 static struct ata_host *legacy_host[NR_HOST];
 static int nr_legacy_host;
 
 
-static int probe_all;			/* Set to check all ISA port ranges */
-static int ht6560a;			/* HT 6560A on primary 1, secondary 2, both 3 */
-static int ht6560b;			/* HT 6560A on primary 1, secondary 2, both 3 */
-static int opti82c611a;			/* Opti82c611A on primary 1, secondary 2, both 3 */
-static int opti82c46x;			/* Opti 82c465MV present (pri/sec autodetect) */
-static int autospeed;			/* Chip present which snoops speed changes */
-static int pio_mask = 0x1F;		/* PIO range for autospeed devices */
+static int probe_all;		/* Set to check all ISA port ranges */
+static int ht6560a;		/* HT 6560A on primary 1, second 2, both 3 */
+static int ht6560b;		/* HT 6560A on primary 1, second 2, both 3 */
+static int opti82c611a;		/* Opti82c611A on primary 1, sec 2, both 3 */
+static int opti82c46x;		/* Opti 82c465MV present(pri/sec autodetect) */
+static int qdi;			/* Set to probe QDI controllers */
+static int autospeed;		/* Chip present which snoops speed changes */
+static int pio_mask = 0x1F;	/* PIO range for autospeed devices */
 static int iordy_mask = 0xFFFFFFFF;	/* Use iordy if available */
 
 /**
+ *	legacy_probe_add	-	Add interface to probe list
+ *	@port: Controller port
+ *	@irq: IRQ number
+ *	@type: Controller type
+ *	@private: Controller specific info
+ *
+ *	Add an entry into the probe list for ATA controllers. This is used
+ *	to add the default ISA slots and then to build up the table
+ *	further according to other ISA/VLB/Weird device scans
+ *
+ *	An I/O port list is used to keep ordering stable and sane, as we
+ *	don't have any good way to talk about ordering otherwise
+ */
+
+static int legacy_probe_add(unsigned long port, unsigned int irq,
+				enum controller type, unsigned long private)
+{
+	struct legacy_probe *lp = &probe_list[0];
+	int i;
+	struct legacy_probe *free = NULL;
+
+	for (i = 0; i < NR_HOST; i++) {
+		if (lp->port == 0 && free == NULL)
+			free = lp;
+		/* Matching port, or the correct slot for ordering */
+		if (lp->port == port || legacy_port[i] == port) {
+			free = lp;
+			break;
+		}
+		lp++;
+	}
+	if (free == NULL) {
+		printk(KERN_ERR "pata_legacy: Too many interfaces.\n");
+		return -1;
+	}
+	/* Fill in the entry for later probing */
+	free->port = port;
+	free->irq = irq;
+	free->type = type;
+	free->private = private;
+	return 0;
+}
+
+
+/**
  *	legacy_set_mode		-	mode setting
  *	@link: IDE link
  *	@unused: Device that failed when error is returned
@@ -113,7 +196,8 @@ static int legacy_set_mode(struct ata_li
 
 	ata_link_for_each_dev(dev, link) {
 		if (ata_dev_enabled(dev)) {
-			ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
+			ata_dev_printk(dev, KERN_INFO,
+						"configured for PIO\n");
 			dev->pio_mode = XFER_PIO_0;
 			dev->xfer_mode = XFER_PIO_0;
 			dev->xfer_shift = ATA_SHIFT_PIO;
@@ -171,7 +255,7 @@ static struct ata_port_operations simple
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 static struct ata_port_operations legacy_port_ops = {
@@ -198,15 +282,16 @@ static struct ata_port_operations legacy
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /*
  *	Promise 20230C and 20620 support
  *
- *	This controller supports PIO0 to PIO2. We set PIO timings conservatively to
- *	allow for 50MHz Vesa Local Bus. The 20620 DMA support is weird being DMA to
- *	controller and PIO'd to the host and not supported.
+ *	This controller supports PIO0 to PIO2. We set PIO timings
+ *	conservatively to allow for 50MHz Vesa Local Bus. The 20620 DMA
+ *	support is weird being DMA to controller and PIO'd to the host
+ *	and not supported.
  */
 
 static void pdc20230_set_piomode(struct ata_port *ap, struct ata_device *adev)
@@ -221,8 +306,7 @@ static void pdc20230_set_piomode(struct 
 	local_irq_save(flags);
 
 	/* Unlock the control interface */
-	do
-	{
+	do {
 		inb(0x1F5);
 		outb(inb(0x1F2) | 0x80, 0x1F2);
 		inb(0x1F2);
@@ -231,7 +315,7 @@ static void pdc20230_set_piomode(struct 
 		inb(0x1F2);
 		inb(0x1F2);
 	}
-	while((inb(0x1F2) & 0x80) && --tries);
+	while ((inb(0x1F2) & 0x80) && --tries);
 
 	local_irq_restore(flags);
 
@@ -250,7 +334,7 @@ static void pdc20230_set_piomode(struct 
 }
 
 static unsigned int pdc_data_xfer_vlb(struct ata_device *dev,
-				unsigned char *buf, unsigned int buflen, int rw)
+			unsigned char *buf, unsigned int buflen, int rw)
 {
 	if (ata_id_has_dword_io(dev->id)) {
 		struct ata_port *ap = dev->link->ap;
@@ -314,14 +398,14 @@ static struct ata_port_operations pdc202
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /*
  *	Holtek 6560A support
  *
- *	This controller supports PIO0 to PIO2 (no IORDY even though higher timings
- *	can be loaded).
+ *	This controller supports PIO0 to PIO2 (no IORDY even though higher
+ *	timings can be loaded).
  */
 
 static void ht6560a_set_piomode(struct ata_port *ap, struct ata_device *adev)
@@ -368,14 +452,14 @@ static struct ata_port_operations ht6560
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /*
  *	Holtek 6560B support
  *
- *	This controller supports PIO0 to PIO4. We honour the BIOS/jumper FIFO setting
- *	unless we see an ATAPI device in which case we force it off.
+ *	This controller supports PIO0 to PIO4. We honour the BIOS/jumper FIFO
+ *	setting unless we see an ATAPI device in which case we force it off.
  *
  *	FIXME: need to implement 2nd channel support.
  */
@@ -402,7 +486,7 @@ static void ht6560b_set_piomode(struct a
 	if (adev->class != ATA_DEV_ATA) {
 		u8 rconf = inb(0x3E6);
 		if (rconf & 0x24) {
-			rconf &= ~ 0x24;
+			rconf &= ~0x24;
 			outb(rconf, 0x3E6);
 		}
 	}
@@ -427,13 +511,13 @@ static struct ata_port_operations ht6560
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
 
-	.data_xfer	= ata_data_xfer,	/* FIXME: Check 32bit and noirq */
+	.data_xfer	= ata_data_xfer,    /* FIXME: Check 32bit and noirq */
 
 	.irq_handler	= ata_interrupt,
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /*
@@ -466,7 +550,8 @@ static u8 opti_syscfg(u8 reg)
  *	This controller supports PIO0 to PIO3.
  */
 
-static void opti82c611a_set_piomode(struct ata_port *ap, struct ata_device *adev)
+static void opti82c611a_set_piomode(struct ata_port *ap,
+						struct ata_device *adev)
 {
 	u8 active, recover, setup;
 	struct ata_timing t;
@@ -553,7 +638,7 @@ static struct ata_port_operations opti82
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /*
@@ -685,77 +770,282 @@ static struct ata_port_operations opti82
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
+static void qdi6500_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	struct ata_timing t;
+	struct legacy_data *qdi = ap->host->private_data;
+	int active, recovery;
+	u8 timing;
+
+	/* Get the timing data in cycles */
+	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
+
+	if (qdi->fast) {
+		active = 8 - FIT(t.active, 1, 8);
+		recovery = 18 - FIT(t.recover, 3, 18);
+	} else {
+		active = 9 - FIT(t.active, 2, 9);
+		recovery = 15 - FIT(t.recover, 0, 15);
+	}
+	timing = (recovery << 4) | active | 0x08;
+
+	qdi->clock[adev->devno] = timing;
+
+	outb(timing, qdi->timing);
+}
 
 /**
- *	legacy_init_one		-	attach a legacy interface
- *	@port: port number
- *	@io: I/O port start
- *	@ctrl: control port
+ *	qdi6580dp_set_piomode		-	PIO setup for dual channel
+ *	@ap: Port
+ *	@adev: Device
  *	@irq: interrupt line
  *
- *	Register an ISA bus IDE interface. Such interfaces are PIO and we
- *	assume do not support IRQ sharing.
+ *	In dual channel mode the 6580 has one clock per channel and we have
+ *	to software clockswitch in qc_issue_prot.
  */
 
-static __init int legacy_init_one(int port, unsigned long io, unsigned long ctrl, int irq)
+static void qdi6580dp_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
-	struct legacy_data *ld = &legacy_data[nr_legacy_host];
-	struct ata_host *host;
-	struct ata_port *ap;
-	struct platform_device *pdev;
-	struct ata_port_operations *ops = &legacy_port_ops;
-	void __iomem *io_addr, *ctrl_addr;
-	int pio_modes = pio_mask;
-	u32 mask = (1 << port);
-	u32 iordy = (iordy_mask & mask) ? 0: ATA_FLAG_NO_IORDY;
-	int ret;
+	struct ata_timing t;
+	struct legacy_data *qdi = ap->host->private_data;
+	int active, recovery;
+	u8 timing;
 
-	pdev = platform_device_register_simple(DRV_NAME, nr_legacy_host, NULL, 0);
-	if (IS_ERR(pdev))
-		return PTR_ERR(pdev);
+	/* Get the timing data in cycles */
+	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
-	ret = -EBUSY;
-	if (devm_request_region(&pdev->dev, io, 8, "pata_legacy") == NULL ||
-	    devm_request_region(&pdev->dev, ctrl, 1, "pata_legacy") == NULL)
-		goto fail;
+	if (qdi->fast) {
+		active = 8 - FIT(t.active, 1, 8);
+		recovery = 18 - FIT(t.recover, 3, 18);
+	} else {
+		active = 9 - FIT(t.active, 2, 9);
+		recovery = 15 - FIT(t.recover, 0, 15);
+	}
+	timing = (recovery << 4) | active | 0x08;
 
-	ret = -ENOMEM;
-	io_addr = devm_ioport_map(&pdev->dev, io, 8);
-	ctrl_addr = devm_ioport_map(&pdev->dev, ctrl, 1);
-	if (!io_addr || !ctrl_addr)
-		goto fail;
+	qdi->clock[adev->devno] = timing;
 
-	if (ht6560a & mask) {
-		ops = &ht6560a_port_ops;
-		pio_modes = 0x07;
-		iordy = ATA_FLAG_NO_IORDY;
-	}
-	if (ht6560b & mask) {
-		ops = &ht6560b_port_ops;
-		pio_modes = 0x1F;
-	}
-	if (opti82c611a & mask) {
-		ops = &opti82c611a_port_ops;
-		pio_modes = 0x0F;
+	outb(timing, qdi->timing + 2 * ap->port_no);
+	/* Clear the FIFO */
+	if (adev->class != ATA_DEV_ATA)
+		outb(0x5F, qdi->timing + 3);
+}
+
+/**
+ *	qdi6580_set_piomode		-	PIO setup for single channel
+ *	@ap: Port
+ *	@adev: Device
+ *
+ *	In single channel mode the 6580 has one clock per device and we can
+ *	avoid the requirement to clock switch. We also have to load the timing
+ *	into the right clock according to whether we are master or slave.
+ */
+
+static void qdi6580_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	struct ata_timing t;
+	struct legacy_data *qdi = ap->host->private_data;
+	int active, recovery;
+	u8 timing;
+
+	/* Get the timing data in cycles */
+	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
+
+	if (qdi->fast) {
+		active = 8 - FIT(t.active, 1, 8);
+		recovery = 18 - FIT(t.recover, 3, 18);
+	} else {
+		active = 9 - FIT(t.active, 2, 9);
+		recovery = 15 - FIT(t.recover, 0, 15);
 	}
-	if (opti82c46x & mask) {
-		ops = &opti82c46x_port_ops;
-		pio_modes = 0x0F;
+	timing = (recovery << 4) | active | 0x08;
+	qdi->clock[adev->devno] = timing;
+	outb(timing, qdi->timing + 2 * adev->devno);
+	/* Clear the FIFO */
+	if (adev->class != ATA_DEV_ATA)
+		outb(0x5F, qdi->timing + 3);
+}
+
+/**
+ *	qdi_qc_issue_prot	-	command issue
+ *	@qc: command pending
+ *
+ *	Called when the libata layer is about to issue a command. We wrap
+ *	this interface so that we can load the correct ATA timings.
+ */
+
+static unsigned int qdi_qc_issue_prot(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct ata_device *adev = qc->dev;
+	struct legacy_data *qdi = ap->host->private_data;
+
+	if (qdi->clock[adev->devno] != qdi->last) {
+		if (adev->pio_mode) {
+			qdi->last = qdi->clock[adev->devno];
+			outb(qdi->clock[adev->devno], qdi->timing +
+							2 * ap->port_no);
+		}
 	}
+	return ata_qc_issue_prot(qc);
+}
 
-	/* Probe for automatically detectable controllers */
+/* For the 6580 can we flip the FIFO on/off at this point ? */
 
-	if (io == 0x1F0 && ops == &legacy_port_ops) {
-		unsigned long flags;
+static unsigned int qdi_data_xfer(struct ata_device *adev, unsigned char *buf,
+					unsigned int buflen, int rw)
+{
+	struct ata_port *ap = adev->link->ap;
+	int slop = buflen & 3;
 
-		local_irq_save(flags);
+	if (ata_id_has_dword_io(adev->id)) {
+		if (rw == WRITE)
+			iowrite32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
+		else
+			ioread32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
 
+		if (unlikely(slop)) {
+			u32 pad;
+			if (rw == WRITE) {
+				memcpy(&pad, buf + buflen - slop, slop);
+				pad = le32_to_cpu(pad);
+				iowrite32(pad, ap->ioaddr.data_addr);
+			} else {
+				pad = ioread32(ap->ioaddr.data_addr);
+				pad = cpu_to_le32(pad);
+				memcpy(buf + buflen - slop, &pad, slop);
+			}
+		}
+		return (buflen + 3) & ~3;
+	} else
+		return ata_data_xfer(adev, buf, buflen, rw);
+}
+
+static struct ata_port_operations qdi6500_port_ops = {
+	.set_piomode	= qdi6500_set_piomode,
+
+	.tf_load	= ata_tf_load,
+	.tf_read	= ata_tf_read,
+	.check_status 	= ata_check_status,
+	.exec_command	= ata_exec_command,
+	.dev_select 	= ata_std_dev_select,
+
+	.freeze		= ata_bmdma_freeze,
+	.thaw		= ata_bmdma_thaw,
+	.error_handler	= ata_bmdma_error_handler,
+	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
+
+	.qc_prep 	= ata_qc_prep,
+	.qc_issue	= qdi_qc_issue_prot,
+
+	.data_xfer	= qdi_data_xfer,
+
+	.irq_handler	= ata_interrupt,
+	.irq_clear	= ata_bmdma_irq_clear,
+	.irq_on		= ata_irq_on,
+
+	.port_start	= ata_sff_port_start,
+};
+
+static struct ata_port_operations qdi6580_port_ops = {
+	.set_piomode	= qdi6580_set_piomode,
+
+	.tf_load	= ata_tf_load,
+	.tf_read	= ata_tf_read,
+	.check_status 	= ata_check_status,
+	.exec_command	= ata_exec_command,
+	.dev_select 	= ata_std_dev_select,
+
+	.freeze		= ata_bmdma_freeze,
+	.thaw		= ata_bmdma_thaw,
+	.error_handler	= ata_bmdma_error_handler,
+	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
+
+	.qc_prep 	= ata_qc_prep,
+	.qc_issue	= ata_qc_issue_prot,
+
+	.data_xfer	= qdi_data_xfer,
+
+	.irq_handler	= ata_interrupt,
+	.irq_clear	= ata_bmdma_irq_clear,
+	.irq_on		= ata_irq_on,
+
+	.port_start	= ata_sff_port_start,
+};
+
+static struct ata_port_operations qdi6580dp_port_ops = {
+	.set_piomode	= qdi6580dp_set_piomode,
+
+	.tf_load	= ata_tf_load,
+	.tf_read	= ata_tf_read,
+	.check_status 	= ata_check_status,
+	.exec_command	= ata_exec_command,
+	.dev_select 	= ata_std_dev_select,
+
+	.freeze		= ata_bmdma_freeze,
+	.thaw		= ata_bmdma_thaw,
+	.error_handler	= ata_bmdma_error_handler,
+	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
+
+	.qc_prep 	= ata_qc_prep,
+	.qc_issue	= qdi_qc_issue_prot,
+
+	.data_xfer	= qdi_data_xfer,
+
+	.irq_handler	= ata_interrupt,
+	.irq_clear	= ata_bmdma_irq_clear,
+	.irq_on		= ata_irq_on,
+
+	.port_start	= ata_sff_port_start,
+};
+
+static struct legacy_controller controllers[] = {
+	{"BIOS",	&legacy_port_ops, 	0x1F,
+						ATA_FLAG_NO_IORDY,	NULL },
+	{"Snooping", 	&simple_port_ops, 	0x1F,
+						0	       ,	NULL },
+	{"PDC20230",	&pdc20230_port_ops,	0x7,
+						ATA_FLAG_NO_IORDY,	NULL },
+	{"HT6560A",	&ht6560a_port_ops,	0x07,
+						ATA_FLAG_NO_IORDY,	NULL },
+	{"HT6560B",	&ht6560b_port_ops,	0x1F,
+						ATA_FLAG_NO_IORDY,	NULL },
+	{"OPTI82C611A",	&opti82c611a_port_ops,	0x0F,
+						0	       ,	NULL },
+	{"OPTI82C46X",	&opti82c46x_port_ops,	0x0F,
+						0	       ,	NULL },
+	{"QDI6500",	&qdi6500_port_ops,	0x07,
+						ATA_FLAG_NO_IORDY,	NULL },
+	{"QDI6580",	&qdi6580_port_ops,	0x1F,
+						0	       ,	NULL },
+	{"QDI6580DP",	&qdi6580dp_port_ops,	0x1F,
+						0	       ,	NULL }
+};
+
+/**
+ *	probe_chip_type		-	Discover controller
+ *	@probe: Probe entry to check
+ *
+ *	Probe an ATA port and identify the type of controller. We don't
+ *	check if the controller appears to be driveless at this point.
+ */
+
+static int probe_chip_type(struct legacy_probe *probe)
+{
+	int mask = 1 << probe->slot;
+
+	if (probe->port == 0x1F0) {
+		unsigned long flags;
+		local_irq_save(flags);
 		/* Probes */
-		inb(0x1F5);
 		outb(inb(0x1F2) | 0x80, 0x1F2);
+		inb(0x1F5);
 		inb(0x1F2);
 		inb(0x3F6);
 		inb(0x3F6);
@@ -764,29 +1054,83 @@ static __init int legacy_init_one(int po
 
 		if ((inb(0x1F2) & 0x80) == 0) {
 			/* PDC20230c or 20630 ? */
-			printk(KERN_INFO "PDC20230-C/20630 VLB ATA controller detected.\n");
-				pio_modes = 0x07;
-			ops = &pdc20230_port_ops;
-			iordy = ATA_FLAG_NO_IORDY;
+			printk(KERN_INFO  "PDC20230-C/20630 VLB ATA controller"
+							" detected.\n");
 			udelay(100);
 			inb(0x1F5);
+			local_irq_restore(flags);
+			return PDC20230;
 		} else {
 			outb(0x55, 0x1F2);
 			inb(0x1F2);
 			inb(0x1F2);
-			if (inb(0x1F2) == 0x00) {
-				printk(KERN_INFO "PDC20230-B VLB ATA controller detected.\n");
-			}
+			if (inb(0x1F2) == 0x00)
+				printk(KERN_INFO "PDC20230-B VLB ATA "
+						     "controller detected.\n");
+			local_irq_restore(flags);
+			return BIOS;
 		}
 		local_irq_restore(flags);
 	}
 
+	if (ht6560a & mask)
+		return HT6560A;
+	if (ht6560b & mask)
+		return HT6560B;
+	if (opti82c611a & mask)
+		return OPTI611A;
+	if (opti82c46x & mask)
+		return OPTI46X;
+	if (autospeed & mask)
+		return SNOOP;
+	return BIOS;
+}
+
 
-	/* Chip does mode setting by command snooping */
-	if (ops == &legacy_port_ops && (autospeed & mask))
-		ops = &simple_port_ops;
+/**
+ *	legacy_init_one		-	attach a legacy interface
+ *	@pl: probe record
+ *
+ *	Register an ISA bus IDE interface. Such interfaces are PIO and we
+ *	assume do not support IRQ sharing.
+ */
+
+static __init int legacy_init_one(struct legacy_probe *probe)
+{
+	struct legacy_controller *controller = &controllers[probe->type];
+	int pio_modes = controller->pio_mask;
+	unsigned long io = probe->port;
+	u32 mask = (1 << probe->slot);
+	struct ata_port_operations *ops = controller->ops;
+	struct legacy_data *ld = &legacy_data[probe->slot];
+	struct ata_host *host = NULL;
+	struct ata_port *ap;
+	struct platform_device *pdev;
+	struct ata_device *dev;
+	void __iomem *io_addr, *ctrl_addr;
+	u32 iordy = (iordy_mask & mask) ? 0: ATA_FLAG_NO_IORDY;
+	int ret;
+
+	iordy |= controller->flags;
+
+	pdev = platform_device_register_simple(DRV_NAME, probe->slot, NULL, 0);
+	if (IS_ERR(pdev))
+		return PTR_ERR(pdev);
+
+	ret = -EBUSY;
+	if (devm_request_region(&pdev->dev, io, 8, "pata_legacy") == NULL ||
+	    devm_request_region(&pdev->dev, io + 0x0206, 1,
+							"pata_legacy") == NULL)
+		goto fail;
 
 	ret = -ENOMEM;
+	io_addr = devm_ioport_map(&pdev->dev, io, 8);
+	ctrl_addr = devm_ioport_map(&pdev->dev, io + 0x0206, 1);
+	if (!io_addr || !ctrl_addr)
+		goto fail;
+	if (controller->setup)
+		if (controller->setup(probe, ld) < 0)
+			goto fail;
 	host = ata_host_alloc(&pdev->dev, 1);
 	if (!host)
 		goto fail;
@@ -801,17 +1145,30 @@ static __init int legacy_init_one(int po
 	ata_std_ports(&ap->ioaddr);
 	ap->private_data = ld;
 
-	ata_port_desc(ap, "cmd 0x%lx ctl 0x%lx", io, ctrl);
+	ata_port_desc(ap, "cmd 0x%lx ctl 0x%lx", io, io + 0x0206);
 
-	ret = ata_host_activate(host, irq, ata_interrupt, 0, &legacy_sht);
+	ret = ata_host_activate(host, probe->irq, ata_interrupt, 0,
+								&legacy_sht);
 	if (ret)
 		goto fail;
-
-	legacy_host[nr_legacy_host++] = dev_get_drvdata(&pdev->dev);
 	ld->platform_dev = pdev;
-	return 0;
 
+	/* Nothing found means we drop the port as its probably not there */
+
+	ret = -ENODEV;
+	ata_link_for_each_dev(dev, &ap->link) {
+		if (!ata_dev_absent(dev)) {
+			legacy_host[probe->slot] = host;
+			ld->platform_dev = pdev;
+			return 0;
+		}
+	}
 fail:
+	if (host)
+		ata_host_detach(host);
+	/* FIXME: use devm for this */
+	if (ld->timing)
+		release_region(ld->timing, 2);
 	platform_device_unregister(pdev);
 	return ret;
 }
@@ -822,13 +1179,15 @@ fail:
  *	@master: set this if we find an ATA master
  *	@master: set this if we find an ATA secondary
  *
- *	A small number of vendors implemented early PCI ATA interfaces on bridge logic
- *	without the ATA interface being PCI visible. Where we have a matching PCI driver
- *	we must skip the relevant device here. If we don't know about it then the legacy
- *	driver is the right driver anyway.
+ *	A small number of vendors implemented early PCI ATA interfaces
+ *	on bridge logic without the ATA interface being PCI visible.
+ *	Where we have a matching PCI driver we must skip the relevant
+ *	device here. If we don't know about it then the legacy driver
+ *	is the right driver anyway.
  */
 
-static void legacy_check_special_cases(struct pci_dev *p, int *primary, int *secondary)
+static void legacy_check_special_cases(struct pci_dev *p, int *primary,
+								int *secondary)
 {
 	/* Cyrix CS5510 pre SFF MWDMA ATA on the bridge */
 	if (p->vendor == 0x1078 && p->device == 0x0000) {
@@ -844,7 +1203,8 @@ static void legacy_check_special_cases(s
 	if (p->vendor == 0x8086 && p->device == 0x1234) {
 		u16 r;
 		pci_read_config_word(p, 0x6C, &r);
-		if (r & 0x8000) {	/* ATA port enabled */
+		if (r & 0x8000) {
+			/* ATA port enabled */
 			if (r & 0x4000)
 				*secondary = 1;
 			else
@@ -854,6 +1214,117 @@ static void legacy_check_special_cases(s
 	}
 }
 
+static __init void probe_opti_vlb(void)
+{
+	/* If an OPTI 82C46X is present find out where the channels are */
+	static const char *optis[4] = {
+		"3/463MV", "5MV",
+		"5MVA", "5MVB"
+	};
+	u8 chans = 1;
+	u8 ctrl = (opti_syscfg(0x30) & 0xC0) >> 6;
+
+	opti82c46x = 3;	/* Assume master and slave first */
+	printk(KERN_INFO DRV_NAME ": Opti 82C46%s chipset support.\n",
+								optis[ctrl]);
+	if (ctrl == 3)
+		chans = (opti_syscfg(0x3F) & 0x20) ? 2 : 1;
+	ctrl = opti_syscfg(0xAC);
+	/* Check enabled and this port is the 465MV port. On the
+	   MVB we may have two channels */
+	if (ctrl & 8) {
+		if (chans == 2) {
+			legacy_probe_add(0x1F0, 14, OPTI46X, 0);
+			legacy_probe_add(0x170, 15, OPTI46X, 0);
+		}
+		if (ctrl & 4)
+			legacy_probe_add(0x170, 15, OPTI46X, 0);
+		else
+			legacy_probe_add(0x1F0, 14, OPTI46X, 0);
+	} else
+		legacy_probe_add(0x1F0, 14, OPTI46X, 0);
+}
+
+static __init void qdi65_identify_port(u8 r, u8 res, unsigned long port)
+{
+	static const unsigned long ide_port[2] = { 0x170, 0x1F0 };
+	/* Check card type */
+	if ((r & 0xF0) == 0xC0) {
+		/* QD6500: single channel */
+		if (r & 8) {
+			/* Disabled ? */
+			release_region(port, 2);
+			return;
+		}
+		legacy_probe_add(ide_port[r & 0x01], 14 + (r & 0x01),
+								QDI6500, port);
+	}
+	if (((r & 0xF0) == 0xA0) || (r & 0xF0) == 0x50) {
+		/* QD6580: dual channel */
+		if (!request_region(port + 2 , 2, "pata_qdi")) {
+			release_region(port, 2);
+			return;
+		}
+		res = inb(port + 3);
+		/* Single channel mode ? */
+		if (res & 1)
+			legacy_probe_add(ide_port[r & 0x01], 14 + (r & 0x01),
+								QDI6580, port);
+		else { /* Dual channel mode */
+			legacy_probe_add(0x1F0, 14, QDI6580DP, port);
+			/* port + 0x02, r & 0x04 */
+			legacy_probe_add(0x170, 15, QDI6580DP, port + 2);
+		}
+	}
+}
+
+static __init void probe_qdi_vlb(void)
+{
+	unsigned long flags;
+	static const unsigned long qd_port[2] = { 0x30, 0xB0 };
+	int i;
+
+	/*
+	 *	Check each possible QD65xx base address
+	 */
+
+	for (i = 0; i < 2; i++) {
+		unsigned long port = qd_port[i];
+		u8 r, res;
+
+
+		if (request_region(port, 2, "pata_qdi")) {
+			/* Check for a card */
+			local_irq_save(flags);
+			/* I have no h/w that needs this delay but it
+			   is present in the historic code */
+			r = inb(port);
+			udelay(1);
+			outb(0x19, port);
+			udelay(1);
+			res = inb(port);
+			udelay(1);
+			outb(r, port);
+			udelay(1);
+			local_irq_restore(flags);
+
+			/* Fail */
+			if (res == 0x19) {
+				release_region(port, 2);
+				continue;
+			}
+			/* Passes the presence test */
+			r = inb(port + 1);
+			udelay(1);
+			/* Check port agrees with port set */
+			if ((r & 2) >> 1 != i) {
+				release_region(port, 2);
+				continue;
+			}
+			qdi65_identify_port(r, res, port);
+		}
+	}
+}
 
 /**
  *	legacy_init		-	attach legacy interfaces
@@ -871,15 +1342,17 @@ static __init int legacy_init(void)
 	int ct = 0;
 	int primary = 0;
 	int secondary = 0;
-	int last_port = NR_HOST;
+	int pci_present = 0;
+	struct legacy_probe *pl = &probe_list[0];
+	int slot = 0;
 
 	struct pci_dev *p = NULL;
 
 	for_each_pci_dev(p) {
 		int r;
-		/* Check for any overlap of the system ATA mappings. Native mode controllers
-		   stuck on these addresses or some devices in 'raid' mode won't be found by
-		   the storage class test */
+		/* Check for any overlap of the system ATA mappings. Native
+		   mode controllers stuck on these addresses or some devices
+		   in 'raid' mode won't be found by the storage class test */
 		for (r = 0; r < 6; r++) {
 			if (pci_resource_start(p, r) == 0x1f0)
 				primary = 1;
@@ -889,49 +1362,37 @@ static __init int legacy_init(void)
 		/* Check for special cases */
 		legacy_check_special_cases(p, &primary, &secondary);
 
-		/* If PCI bus is present then don't probe for tertiary legacy ports */
-		if (probe_all == 0)
-			last_port = 2;
+		/* If PCI bus is present then don't probe for tertiary
+		   legacy ports */
+		pci_present = 1;
 	}
 
-	/* If an OPTI 82C46X is present find out where the channels are */
-	if (opti82c46x) {
-		static const char *optis[4] = {
-			"3/463MV", "5MV",
-			"5MVA", "5MVB"
-		};
-		u8 chans = 1;
-		u8 ctrl = (opti_syscfg(0x30) & 0xC0) >> 6;
-
-		opti82c46x = 3;	/* Assume master and slave first */
-		printk(KERN_INFO DRV_NAME ": Opti 82C46%s chipset support.\n", optis[ctrl]);
-		if (ctrl == 3)
-			chans = (opti_syscfg(0x3F) & 0x20) ? 2 : 1;
-		ctrl = opti_syscfg(0xAC);
-		/* Check enabled and this port is the 465MV port. On the
-		   MVB we may have two channels */
-		if (ctrl & 8) {
-			if (ctrl & 4)
-				opti82c46x = 2;	/* Slave */
-			else
-				opti82c46x = 1;	/* Master */
-			if (chans == 2)
-				opti82c46x = 3; /* Master and Slave */
-		}	/* Slave only */
-		else if (chans == 1)
-			opti82c46x = 1;
+	if (primary == 0 || all)
+		legacy_probe_add(0x1F0, 14, UNKNOWN, 0);
+	if (secondary == 0 || all)
+		legacy_probe_add(0x170, 15, UNKNOWN, 0);
+
+	if (probe_all || !pci_present) {
+		/* ISA/VLB extra ports */
+		legacy_probe_add(0x1E8, 11, UNKNOWN, 0);
+		legacy_probe_add(0x168, 10, UNKNOWN, 0);
+		legacy_probe_add(0x1E0, 8, UNKNOWN, 0);
+		legacy_probe_add(0x160, 12, UNKNOWN, 0);
 	}
 
-	for (i = 0; i < last_port; i++) {
-		/* Skip primary if we have seen a PCI one */
-		if (i == 0 && primary == 1)
-			continue;
-		/* Skip secondary if we have seen a PCI one */
-		if (i == 1 && secondary == 1)
+	if (opti82c46x)
+		probe_opti_vlb();
+	if (qdi)
+		probe_qdi_vlb();
+
+
+	for (i = 0; i < NR_HOST; i++, pl++) {
+		if (pl->port == 0)
 			continue;
-		if (legacy_init_one(i, legacy_port[i],
-				   legacy_port[i] + 0x0206,
-				   legacy_irq[i]) == 0)
+		if (pl->type == UNKNOWN)
+			pl->type = probe_chip_type(pl);
+		pl->slot = slot++;
+		if (legacy_init_one(pl) == 0)
 			ct++;
 	}
 	if (ct != 0)
@@ -945,7 +1406,6 @@ static __exit void legacy_exit(void)
 
 	for (i = 0; i < nr_legacy_host; i++) {
 		struct legacy_data *ld = &legacy_data[i];
-
 		ata_host_detach(legacy_host[i]);
 		platform_device_unregister(ld->platform_dev);
 		if (ld->timing)
@@ -964,9 +1424,9 @@ module_param(ht6560a, int, 0);
 module_param(ht6560b, int, 0);
 module_param(opti82c611a, int, 0);
 module_param(opti82c46x, int, 0);
+module_param(qdi, int, 0);
 module_param(pio_mask, int, 0);
 module_param(iordy_mask, int, 0);
 
 module_init(legacy_init);
 module_exit(legacy_exit);
-
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
keyspan-fix-oops.patch
git-acpi.patch
git-arm.patch
git-libata-all.patch
git-net.patch
bluetooth-rfcomm-tty_close-before-destruct.patch
hci_ldisc-fix-null-pointer-deref.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250c-support-specifying-dw-apb-uarts-in-device-platform_data.patch
avoid-waking-up-closed-serial-ports-on-resume.patch
serial-avoid-stalling-suspend-if-serial-port-wont-drain.patch
serial-speed-setup-failure-reporting.patch
serial-coding-style.patch
git-scsi-misc.patch
fix-gregkh-usb-usb-ti_usb-termios-cleanups.patch
git-watchdog.patch
git-x86.patch
geode-lists-are-subscriber-only.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
sc26xx-new-serial-driver-for-sc2681-uarts.patch
sc26xx-new-serial-driver-for-sc2681-uarts-update.patch
documentation-about-unaligned-memory-access.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.patch
fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline.patch
fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline-update.patch
tty-kill-tty_flipbuf_size.patch
drivers-edac-turnon-edac-device-error-logging.patch
drivers-edac-use-round_jiffies_relative.patch
drivers-edac-add-cell-xdr-memory-types.patch
drivers-edac-add-cell-mc-driver.patch
drivers-edac-i3000-code-tidying.patch
drivers-edac-i3000-replace-macros-with-functions.patch
drivers-edac-add-freescale-mpc85xx-driver.patch
drivers-edac-add-marvell-mv64x60-driver.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
dz-clean-up-and-improve-the-setup-of-termios-settings.patch
char-rocket-switch-long-delay-to-sleep.patch
char-rocket-printk-cleanup.patch
char-char-serial-remove-serial_type_normal-redefines.patch
char-mxser_new-ioaddresses-are-ulong.patch
char-stallion-fix-compiler-warnings.patch
char-riscom8-change-rc_init_drivers-prototype.patch
mxser-mxser_new-first-pass-over-termios-reporting-for-the.patch
tty-let-architectures-override-the-user-kernel-macros.patch
tty-s390-support-for-termios2.patch
moxa-first-pass-at-termios-reporting.patch
n_tty-clean-up-old-code-to-follow-coding-style-and-mostly-checkpatch.patch
rocket-first-pass-at-termios-reporting.patch
rocket-dont-let-random-users-reset-the-controller.patch
tty_audit-fix-checkpatch-complaint.patch
tty_io-drag-screaming-into-coding-style-compliance.patch
tty_ioctl-drag-screaming-into-compliance-with-the-coding.patch
8250_early-coding-style.patch
8250_gsc-coding-style.patch
8250_hp300-coding-style.patch
8250_hub6-codding-style.patch
8250_pci-coding-style.patch
serial8250-coding-style.patch
8250-enable-rate-reporting-via-termios.patch
serial_core-bring-mostly-into-line-with-coding-style.patch
