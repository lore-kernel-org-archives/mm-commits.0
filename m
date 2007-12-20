From: akpm@linux-foundation.org
Subject: - pata_pcmcia-minor-cleanups-and-support-for-dual-channel-cards.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:37:44 -0800
Message-ID: <200712202337.lBKNbiCH018923@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40929 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755838AbXLTXs3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:48:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pata_pcmcia: minor cleanups and support for dual channel cards
has been removed from the -mm tree.  Its filename was
     pata_pcmcia-minor-cleanups-and-support-for-dual-channel-cards.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_pcmcia: minor cleanups and support for dual channel cards
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_pcmcia.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff -puN drivers/ata/pata_pcmcia.c~pata_pcmcia-minor-cleanups-and-support-for-dual-channel-cards drivers/ata/pata_pcmcia.c
--- a/drivers/ata/pata_pcmcia.c~pata_pcmcia-minor-cleanups-and-support-for-dual-channel-cards
+++ a/drivers/ata/pata_pcmcia.c
@@ -42,7 +42,7 @@
 
 
 #define DRV_NAME "pata_pcmcia"
-#define DRV_VERSION "0.3.2"
+#define DRV_VERSION "0.3.3"
 
 /*
  *	Private data structure to glue stuff together
@@ -198,7 +198,6 @@ do { last_fn = (fn); if ((last_ret = (re
 /**
  *	pcmcia_init_one		-	attach a PCMCIA interface
  *	@pdev: pcmcia device
- *	@ops: operations for this device
  *
  *	Register a PCMCIA IDE interface. Such interfaces are PIO 0 and
  *	shared IRQ.
@@ -217,9 +216,10 @@ static int pcmcia_init_one(struct pcmcia
 		cistpl_cftable_entry_t dflt;
 	} *stk = NULL;
 	cistpl_cftable_entry_t *cfg;
-	int pass, last_ret = 0, last_fn = 0, is_kme = 0, ret = -ENOMEM;
+	int pass, last_ret = 0, last_fn = 0, is_kme = 0, ret = -ENOMEM, p;
 	unsigned long io_base, ctl_base;
 	void __iomem *io_addr, *ctl_addr;
+	int n_ports = 1;
 
 	struct ata_port_operations *ops = &pcmcia_port_ops;
 
@@ -348,7 +348,7 @@ next_entry:
 	/* FIXME: Could be more ports at base + 0x10 but we only deal with
 	   one right now */
 	if (pdev->io.NumPorts1 >= 0x20)
-		printk(KERN_WARNING DRV_NAME ": second channel not yet supported.\n");
+		n_ports = 2;
 
 	if (pdev->manf_id == 0x0097 && pdev->card_id == 0x1620)
 		ops = &pcmcia_8bit_port_ops;
@@ -357,20 +357,23 @@ next_entry:
 	 *	sane.
 	 */
 	ret = -ENOMEM;
-	host = ata_host_alloc(&pdev->dev, 1);
+	host = ata_host_alloc(&pdev->dev, n_ports);
 	if (!host)
 		goto failed;
-	ap = host->ports[0];
 
-	ap->ops = ops;
-	ap->pio_mask = 1;		/* ISA so PIO 0 cycles */
-	ap->flags |= ATA_FLAG_SLAVE_POSS;
-	ap->ioaddr.cmd_addr = io_addr;
-	ap->ioaddr.altstatus_addr = ctl_addr;
-	ap->ioaddr.ctl_addr = ctl_addr;
-	ata_std_ports(&ap->ioaddr);
+	for (p = 0; p < n_ports; p++) {
+		ap = host->ports[p];
 
-	ata_port_desc(ap, "cmd 0x%lx ctl 0x%lx", io_base, ctl_base);
+		ap->ops = ops;
+		ap->pio_mask = 1;		/* ISA so PIO 0 cycles */
+		ap->flags |= ATA_FLAG_SLAVE_POSS;
+		ap->ioaddr.cmd_addr = io_addr + 0x10 * p;
+		ap->ioaddr.altstatus_addr = ctl_addr + 0x10 * p;
+		ap->ioaddr.ctl_addr = ctl_addr + 0x10 * p;
+		ata_std_ports(&ap->ioaddr);
+
+		ata_port_desc(ap, "cmd 0x%lx ctl 0x%lx", io_base, ctl_base);
+	}
 
 	/* activate */
 	ret = ata_host_activate(host, pdev->irq.AssignedIRQ, ata_interrupt,
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-arm.patch
git-libata-all.patch
libata-fix-early-use-of-port-printk-checkpatch-fixes.patch
git-netdev-all.patch
bluetooth-rfcomm-tty_close-before-destruct.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
serial-keep-the-dtr-setting-for-serial-console.patch
belkin_sa-clean-up-for-new-style-termios-and-speed.patch
keyspan_pda-clean-up-speed-handling.patch
mct232-speed-new-termios-and-compliance-cleanups.patch
geode-lists-are-subscriber-only.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
sc26xx-new-serial-driver-for-sc2681-uarts.patch
sc26xx-new-serial-driver-for-sc2681-uarts-update.patch
documentation-about-unaligned-memory-access.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.patch
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
