From: akpm@linux-foundation.org
Subject: + pata_legacy-merge-winbond-support.patch added to -mm tree
Date: Mon, 21 Jan 2008 19:00:24 -0800
Message-ID: <200801220300.m0M3040G001081@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50223 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751769AbYAVDBG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 22:01:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     Merge winbond support
has been added to the -mm tree.  Its filename is
     pata_legacy-merge-winbond-support.patch

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
Subject: Merge winbond support
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This puts winbond VLB in with the other ISA/VLB support and means we can
lose pata_winbond.c. With all the VLB/ISA probe in one space (and out of
the core libata) this makes legacy probing work sanely.

Also switch to devm_ for resource handling on the ports post probe

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_legacy.c |  178 +++++++++++++++++++++++++++++-------
 1 file changed, 144 insertions(+), 34 deletions(-)

diff -puN drivers/ata/pata_legacy.c~pata_legacy-merge-winbond-support drivers/ata/pata_legacy.c
--- a/drivers/ata/pata_legacy.c~pata_legacy-merge-winbond-support
+++ a/drivers/ata/pata_legacy.c
@@ -28,7 +28,6 @@
  *
  *  Unsupported but docs exist:
  *	Appian/Adaptec AIC25VL01/Cirrus Logic PD7220
- *	Winbond W83759A
  *
  *  This driver handles legacy (that is "ISA/VLB side") IDE ports found
  *  on PC class systems. There are three hybrid devices that are exceptions
@@ -36,7 +35,7 @@
  *  the MPIIX where the tuning is PCI side but the IDE is "ISA side".
  *
  *  Specific support is included for the ht6560a/ht6560b/opti82c611a/
- *  opti82c465mv/promise 20230c/20630
+ *  opti82c465mv/promise 20230c/20630/winbond83759A
  *
  *  Use the autospeed and pio_mask options with:
  *	Appian ADI/2 aka CLPD7220 or AIC25VL01.
@@ -47,9 +46,6 @@
  *  For now use autospeed and pio_mask as above with the W83759A. This may
  *  change.
  *
- *  TODO
- *	Merge existing pata_qdi driver
- *
  */
 
 #include <linux/kernel.h>
@@ -64,7 +60,7 @@
 #include <linux/platform_device.h>
 
 #define DRV_NAME "pata_legacy"
-#define DRV_VERSION "0.5.5"
+#define DRV_VERSION "0.6.5"
 
 #define NR_HOST 6
 
@@ -92,6 +88,7 @@ enum controller {
 	QDI6500 = 7,
 	QDI6580 = 8,
 	QDI6580DP = 9,		/* Dual channel mode is different */
+	W83759A = 10,
 
 	UNKNOWN = -1
 };
@@ -111,7 +108,8 @@ struct legacy_controller {
 	struct ata_port_operations *ops;
 	unsigned int pio_mask;
 	unsigned int flags;
-	int (*setup)(struct legacy_probe *probe, struct legacy_data *data);
+	int (*setup)(struct platform_device *, struct legacy_probe *probe,
+		struct legacy_data *data);
 };
 
 static int legacy_port[NR_HOST] = { 0x1f0, 0x170, 0x1e8, 0x168, 0x1e0, 0x160 };
@@ -128,6 +126,8 @@ static int ht6560b;		/* HT 6560A on prim
 static int opti82c611a;		/* Opti82c611A on primary 1, sec 2, both 3 */
 static int opti82c46x;		/* Opti 82c465MV present(pri/sec autodetect) */
 static int qdi;			/* Set to probe QDI controllers */
+static int winbond;		/* Set to probe Winbond controllers,
+					give I/O port if non stdanard */
 static int autospeed;		/* Chip present which snoops speed changes */
 static int pio_mask = 0x1F;	/* PIO range for autospeed devices */
 static int iordy_mask = 0xFFFFFFFF;	/* Use iordy if available */
@@ -891,9 +891,7 @@ static unsigned int qdi_qc_issue_prot(st
 	return ata_qc_issue_prot(qc);
 }
 
-/* For the 6580 can we flip the FIFO on/off at this point ? */
-
-static unsigned int qdi_data_xfer(struct ata_device *adev, unsigned char *buf,
+static unsigned int vlb32_data_xfer(struct ata_device *adev, unsigned char *buf,
 					unsigned int buflen, int rw)
 {
 	struct ata_port *ap = adev->link->ap;
@@ -922,6 +920,15 @@ static unsigned int qdi_data_xfer(struct
 		return ata_data_xfer(adev, buf, buflen, rw);
 }
 
+static int qdi_port(struct platform_device *dev,
+			struct legacy_probe *lp, struct legacy_data *ld)
+{
+	if (devm_request_region(&dev->dev, lp->private, 4, "qdi") == NULL)
+		return -EBUSY;
+	ld->timing = lp->private;
+	return 0;
+}
+
 static struct ata_port_operations qdi6500_port_ops = {
 	.set_piomode	= qdi6500_set_piomode,
 
@@ -940,7 +947,7 @@ static struct ata_port_operations qdi650
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= qdi_qc_issue_prot,
 
-	.data_xfer	= qdi_data_xfer,
+	.data_xfer	= vlb32_data_xfer,
 
 	.irq_handler	= ata_interrupt,
 	.irq_clear	= ata_bmdma_irq_clear,
@@ -967,7 +974,7 @@ static struct ata_port_operations qdi658
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
 
-	.data_xfer	= qdi_data_xfer,
+	.data_xfer	= vlb32_data_xfer,
 
 	.irq_handler	= ata_interrupt,
 	.irq_clear	= ata_bmdma_irq_clear,
@@ -994,7 +1001,7 @@ static struct ata_port_operations qdi658
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= qdi_qc_issue_prot,
 
-	.data_xfer	= qdi_data_xfer,
+	.data_xfer	= vlb32_data_xfer,
 
 	.irq_handler	= ata_interrupt,
 	.irq_clear	= ata_bmdma_irq_clear,
@@ -1003,6 +1010,97 @@ static struct ata_port_operations qdi658
 	.port_start	= ata_sff_port_start,
 };
 
+static DEFINE_SPINLOCK(winbond_lock);
+
+static void winbond_writecfg(unsigned long port, u8 reg, u8 val)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&winbond_lock, flags);
+	outb(reg, port + 0x01);
+	outb(val, port + 0x02);
+	spin_unlock_irqrestore(&winbond_lock, flags);
+}
+
+static u8 winbond_readcfg(unsigned long port, u8 reg)
+{
+	u8 val;
+
+	unsigned long flags;
+	spin_lock_irqsave(&winbond_lock, flags);
+	outb(reg, port + 0x01);
+	val = inb(port + 0x02);
+	spin_unlock_irqrestore(&winbond_lock, flags);
+
+	return val;
+}
+
+static void winbond_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	struct ata_timing t;
+	struct legacy_data *winbond = ap->host->private_data;
+	int active, recovery;
+	u8 reg;
+	int timing = 0x88 + (ap->port_no * 4) + (adev->devno * 2);
+
+	reg = winbond_readcfg(winbond->timing, 0x81);
+
+	/* Get the timing data in cycles */
+	if (reg & 0x40)		/* Fast VLB bus, assume 50MHz */
+		ata_timing_compute(adev, adev->pio_mode, &t, 20000, 1000);
+	else
+		ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
+
+	active = (FIT(t.active, 3, 17) - 1) & 0x0F;
+	recovery = (FIT(t.recover, 1, 15) + 1) & 0x0F;
+	timing = (active << 4) | recovery;
+	winbond_writecfg(winbond->timing, timing, reg);
+
+	/* Load the setup timing */
+
+	reg = 0x35;
+	if (adev->class != ATA_DEV_ATA)
+		reg |= 0x08;	/* FIFO off */
+	if (!ata_pio_need_iordy(adev))
+		reg |= 0x02;	/* IORDY off */
+	reg |= (FIT(t.setup, 0, 3) << 6);
+	winbond_writecfg(winbond->timing, timing + 1, reg);
+}
+
+static int winbond_port(struct platform_device *dev,
+			struct legacy_probe *lp, struct legacy_data *ld)
+{
+	if (devm_request_region(&dev->dev, lp->private, 4, "winbond") == NULL)
+		return -EBUSY;
+	ld->timing = lp->private;
+	return 0;
+}
+
+static struct ata_port_operations winbond_port_ops = {
+	.set_piomode	= winbond_set_piomode,
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
+	.data_xfer	= vlb32_data_xfer,
+
+	.irq_clear	= ata_bmdma_irq_clear,
+	.irq_on		= ata_irq_on,
+
+	.port_start	= ata_sff_port_start,
+};
+
 static struct legacy_controller controllers[] = {
 	{"BIOS",	&legacy_port_ops, 	0x1F,
 						ATA_FLAG_NO_IORDY,	NULL },
@@ -1019,11 +1117,13 @@ static struct legacy_controller controll
 	{"OPTI82C46X",	&opti82c46x_port_ops,	0x0F,
 						0	       ,	NULL },
 	{"QDI6500",	&qdi6500_port_ops,	0x07,
-						ATA_FLAG_NO_IORDY,	NULL },
+					ATA_FLAG_NO_IORDY,	qdi_port },
 	{"QDI6580",	&qdi6580_port_ops,	0x1F,
-						0	       ,	NULL },
+					0	       ,	qdi_port },
 	{"QDI6580DP",	&qdi6580dp_port_ops,	0x1F,
-						0	       ,	NULL }
+					0	       ,	qdi_port },
+	{"W83759A",	&winbond_port_ops,	0x1F,
+					0	       ,	winbond_port }
 };
 
 /**
@@ -1034,10 +1134,26 @@ static struct legacy_controller controll
  *	check if the controller appears to be driveless at this point.
  */
 
-static int probe_chip_type(struct legacy_probe *probe)
+static __init int probe_chip_type(struct legacy_probe *probe)
 {
 	int mask = 1 << probe->slot;
 
+	if (winbond && (probe->port == 0x1F0 || probe->port == 0x170)) {
+		u8 reg = winbond_readcfg(winbond, 0x81);
+		reg |= 0x80;	/* jumpered mode off */
+		winbond_writecfg(winbond, 0x81, reg);
+		reg = winbond_readcfg(winbond, 0x83);
+		reg |= 0xF0;	/* local control */
+		winbond_writecfg(winbond, 0x83, reg);
+		reg = winbond_readcfg(winbond, 0x85);
+		reg |= 0xF0;	/* programmable timing */
+		winbond_writecfg(winbond, 0x85, reg);
+
+		reg = winbond_readcfg(winbond, 0x81);
+
+		if (reg & mask)
+			return W83759A;
+	}
 	if (probe->port == 0x1F0) {
 		unsigned long flags;
 		local_irq_save(flags);
@@ -1127,7 +1243,7 @@ static __init int legacy_init_one(struct
 	if (!io_addr || !ctrl_addr)
 		goto fail;
 	if (controller->setup)
-		if (controller->setup(probe, ld) < 0)
+		if (controller->setup(pdev, probe, ld) < 0)
 			goto fail;
 	host = ata_host_alloc(&pdev->dev, 1);
 	if (!host)
@@ -1141,7 +1257,7 @@ static __init int legacy_init_one(struct
 	ap->ioaddr.altstatus_addr = ctrl_addr;
 	ap->ioaddr.ctl_addr = ctrl_addr;
 	ata_std_ports(&ap->ioaddr);
-	ap->private_data = ld;
+	ap->host->private_data = ld;
 
 	ata_port_desc(ap, "cmd 0x%lx ctl 0x%lx", io, io + 0x0206);
 
@@ -1164,9 +1280,6 @@ static __init int legacy_init_one(struct
 fail:
 	if (host)
 		ata_host_detach(host);
-	/* FIXME: use devm for this */
-	if (ld->timing)
-		release_region(ld->timing, 2);
 	platform_device_unregister(pdev);
 	return ret;
 }
@@ -1184,7 +1297,7 @@ fail:
  *	is the right driver anyway.
  */
 
-static void legacy_check_special_cases(struct pci_dev *p, int *primary,
+static void __init legacy_check_special_cases(struct pci_dev *p, int *primary,
 								int *secondary)
 {
 	/* Cyrix CS5510 pre SFF MWDMA ATA on the bridge */
@@ -1249,11 +1362,9 @@ static __init void qdi65_identify_port(u
 	/* Check card type */
 	if ((r & 0xF0) == 0xC0) {
 		/* QD6500: single channel */
-		if (r & 8) {
+		if (r & 8)
 			/* Disabled ? */
-			release_region(port, 2);
 			return;
-		}
 		legacy_probe_add(ide_port[r & 0x01], 14 + (r & 0x01),
 								QDI6500, port);
 	}
@@ -1273,6 +1384,7 @@ static __init void qdi65_identify_port(u
 			/* port + 0x02, r & 0x04 */
 			legacy_probe_add(0x170, 15, QDI6580DP, port + 2);
 		}
+		release_region(port + 2, 2);
 	}
 }
 
@@ -1315,11 +1427,9 @@ static __init void probe_qdi_vlb(void)
 			r = inb(port + 1);
 			udelay(1);
 			/* Check port agrees with port set */
-			if ((r & 2) >> 1 != i) {
-				release_region(port, 2);
-				continue;
-			}
-			qdi65_identify_port(r, res, port);
+			if ((r & 2) >> 1 == i)
+				qdi65_identify_port(r, res, port);
+			release_region(port, 2);
 		}
 	}
 }
@@ -1365,6 +1475,9 @@ static __init int legacy_init(void)
 		pci_present = 1;
 	}
 
+	if (winbond == 1)
+		winbond = 0x130;	/* Default port, alt is 1B0 */
+
 	if (primary == 0 || all)
 		legacy_probe_add(0x1F0, 14, UNKNOWN, 0);
 	if (secondary == 0 || all)
@@ -1383,7 +1496,6 @@ static __init int legacy_init(void)
 	if (qdi)
 		probe_qdi_vlb();
 
-
 	for (i = 0; i < NR_HOST; i++, pl++) {
 		if (pl->port == 0)
 			continue;
@@ -1406,8 +1518,6 @@ static __exit void legacy_exit(void)
 		struct legacy_data *ld = &legacy_data[i];
 		ata_host_detach(legacy_host[i]);
 		platform_device_unregister(ld->platform_dev);
-		if (ld->timing)
-			release_region(ld->timing, 2);
 	}
 }
 
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
x86-reboot-remove-inb_p-usage.patch
pata_legacy-merge-winbond-support.patch
pata_mpc52xx-remove-un-needed-assignment.patch
pata_pdc202xx_old-fix-crashes-with-atapi.patch
pata_serverworks-fix-cable-types-and-cosmetics.patch
pata_winbond-error-return.patch
resend-8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
sh-termios-ioctl-definitions.patch
ata_generic-cenatek-support.patch
