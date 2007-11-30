From: akpm@linux-foundation.org
Subject: + libata-fix-early-use-of-port-printk.patch added to -mm tree
Date: Fri, 30 Nov 2007 13:44:30 -0800
Message-ID: <200711302144.lAULiURN025944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37931 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752301AbXK3VpX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 16:45:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     libata: fix early use of port printk
has been added to the -mm tree.  Its filename is
     libata-fix-early-use-of-port-printk.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: fix early use of port printk
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Allow for port start to fail politely with -ENODEV.

(akpm: fixes something else too, but I wasn't told what)

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-fix-early-use-of-port-printk drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-fix-early-use-of-port-printk
+++ a/drivers/ata/libata-core.c
@@ -7017,12 +7017,11 @@ int ata_host_start(struct ata_host *host
 		if (ap->ops->port_start) {
 			rc = ap->ops->port_start(ap);
 			if (rc) {
-				ata_port_printk(ap, KERN_ERR, "failed to "
-						"start port (errno=%d)\n", rc);
+				if (rc != -ENODEV)
+					dev_printk(KERN_ERR, host->dev, "failed to start port %d (errno=%d)\n", i, rc);
 				goto err_out;
 			}
 		}
-
 		ata_eh_freeze_port(ap);
 	}
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
termios-document-callback-more-clearly.patch
ip22zilog-fix-lockup-and-sysrq.patch
revert-keyspan-init-termios-properly.patch
git-arm.patch
git-libata-all.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
libata-separate-out-ata_acpi_gtm_xfermask-from-pacpi_discover_modes.patch
libata-fix-ata_acpi_gtm_xfermask.patch
libata-implement-ata_timing_cycle2mode-and-use-it-in-libata-acpi-and-pata_acpi.patch
libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm_xfermask.patch
libata-add-ata_cbl_pata_ign.patch
pata_amd-update-mode-selection-for-nv-patas.patch
pata_pcmcia-minor-cleanups-and-support-for-dual-channel-cards.patch
libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock.patch
ata-ahci-enclosure-management-via-led.patch
libata-fix-early-use-of-port-printk.patch
git-netdev-all.patch
bluetooth-rfcomm-tty_close-before-destruct.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-scsi-rc-fixes.patch
initio-fix-conflict-when-loading-driver.patch
belkin_sa-clean-up-for-new-style-termios-and-speed.patch
keyspan_pda-clean-up-speed-handling.patch
mct232-speed-new-termios-and-compliance-cleanups.patch
mct232-speed-new-termios-and-compliance-cleanups-fix.patch
pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings.patch
tty-add-the-new-termios2-ioctls-to-the-compatible.patch
geode-lists-are-subscriber-only.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
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
libata-fix-early-use-of-port-printk-checkpatch-fixes.patch
