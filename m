From: akpm@linux-foundation.org
Subject: + libata-sff-pci-irq-handling-fix.patch added to -mm tree
Date: Wed, 09 Jan 2008 21:32:43 -0800
Message-ID: <200801100532.m0A5WNWO006950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45743 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969AbYAJFdt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 00:33:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     libata-sff: PCI IRQ handling fix
has been added to the -mm tree.  Its filename is
     libata-sff-pci-irq-handling-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libata-sff: PCI IRQ handling fix
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

It is legitimate (although annoying and silly) for a PCI IDE controller not
to be assigned an interrupt and to be polled.  The libata-sff code should
therefore not try and request IRQ 0 in this case.

Signed-off-by: Alan Cox <alan@redhat.com>
Acked-by: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-sff.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/ata/libata-sff.c~libata-sff-pci-irq-handling-fix drivers/ata/libata-sff.c
--- a/drivers/ata/libata-sff.c~libata-sff-pci-irq-handling-fix
+++ a/drivers/ata/libata-sff.c
@@ -808,7 +808,10 @@ int ata_pci_init_one(struct pci_dev *pde
 	if (rc)
 		goto err_out;
 
-	if (!legacy_mode) {
+	if (!legacy_mode && pdev->irq) {
+		/* We may have no IRQ assigned in which case we can poll. This
+		   shouldn't happen on a sane system but robustness is cheap
+		   in this case */
 		rc = devm_request_irq(dev, pdev->irq, pi->port_ops->irq_handler,
 				      IRQF_SHARED, DRV_NAME, host);
 		if (rc)
@@ -816,7 +819,7 @@ int ata_pci_init_one(struct pci_dev *pde
 
 		ata_port_desc(host->ports[0], "irq %d", pdev->irq);
 		ata_port_desc(host->ports[1], "irq %d", pdev->irq);
-	} else {
+	} else if (legacy_mode) {
 		if (!ata_port_is_dummy(host->ports[0])) {
 			rc = devm_request_irq(dev, ATA_PRIMARY_IRQ(pdev),
 					      pi->port_ops->irq_handler,
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

pl2303-fix-mode-switching-regression.patch
pl2303-fix-mode-switching-regression-fix.patch
git-arm.patch
git-libata-all.patch
git-libata-all-fix-pata_winbond-borkage.patch
git-libata-all-wtf.patch
libata-fix-early-use-of-port-printk-checkpatch-fixes.patch
pata_pdc202xx_old-further-fixups.patch
git-netdev-all.patch
bluetooth-rfcomm-tty_close-before-destruct.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250c-support-specifying-dw-apb-uarts-in-device-platform_data.patch
avoid-waking-up-closed-serial-ports-on-resume.patch
serial-avoid-stalling-suspend-if-serial-port-wont-drain.patch
libata-sff-pci-irq-handling-fix.patch
geode-lists-are-subscriber-only.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
sc26xx-new-serial-driver-for-sc2681-uarts.patch
sc26xx-new-serial-driver-for-sc2681-uarts-update.patch
documentation-about-unaligned-memory-access.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.patch
fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline.patch
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
