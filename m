From: akpm@linux-foundation.org
Subject: + pata_pdc202xx_old-fix-crashes-with-atapi.patch added to -mm tree
Date: Mon, 21 Jan 2008 19:00:31 -0800
Message-ID: <200801220300.m0M30BgN001087@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44193 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752293AbYAVDBL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 22:01:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     pata_pdc202xx_old: Fix crashes with ATAPI
has been added to the -mm tree.  Its filename is
     pata_pdc202xx_old-fix-crashes-with-atapi.patch

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
Subject: pata_pdc202xx_old: Fix crashes with ATAPI
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

The PDC202xx older devices do not support ATAPI DMA via the usual
interfaces. What documentation I have isn't sufficient to support DMA and
it isn't clear if the Windows drivers do this or it is possible at all.
(Neither do the drivers/ide old drivers)

So turn it ATAPI DMA off, these are disk optimised controllers.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_pdc202xx_old.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff -puN drivers/ata/pata_pdc202xx_old.c~pata_pdc202xx_old-fix-crashes-with-atapi drivers/ata/pata_pdc202xx_old.c
--- a/drivers/ata/pata_pdc202xx_old.c~pata_pdc202xx_old-fix-crashes-with-atapi
+++ a/drivers/ata/pata_pdc202xx_old.c
@@ -261,6 +261,24 @@ static int pdc2026x_check_atapi_dma(stru
 	return 1;
 }
 
+/**
+ *	pdc2026x_check_atapi_dma - Check whether ATAPI DMA can be supported for this command
+ *	@qc: Metadata associated with taskfile to check
+ *
+ *	Just say no - not supported on older Promise.
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ *
+ *	RETURNS: 0 when ATAPI DMA can be used
+ *		 1 otherwise
+ */
+
+static int pdc2026x_check_atapi_dma(struct ata_queued_cmd *qc)
+{
+	return 1;
+}
+
 static struct scsi_host_template pdc202xx_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -295,6 +313,7 @@ static struct ata_port_operations pdc202
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
 	.cable_detect	= ata_cable_40wire,
 
+	.check_atapi_dma= pdc2026x_check_atapi_dma,
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
 	.bmdma_stop	= ata_bmdma_stop,
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
