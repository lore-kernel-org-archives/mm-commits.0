From: akpm@linux-foundation.org
Subject: - frv-remove-bogus-no_irq-=-1-define.patch removed from -mm tree
Date: Mon, 12 Nov 2007 20:06:57 -0800
Message-ID: <200711130406.lAD46vwK025126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45084 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752954AbXKMEHV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 23:07:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     frv: remove bogus NO_IRQ = -1 define
has been removed from the -mm tree.  Its filename was
     frv-remove-bogus-no_irq-=-1-define.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: frv: remove bogus NO_IRQ = -1 define
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

The old NO_IRQ define some platforms had was long ago declared obsolete
and wrong. FRV should therefore not be re-introducing this, especially as
IRQs are usually unsigned in the kernel. The "no IRQ" case is defined to be
zero and Linus made this rather clear at the time.

arch/frv shows no dependancy on this but it might show up driver fixes
needing doing I guess

Signed-off-by: Alan Cox <alan@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-frv/irq.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN include/asm-frv/irq.h~frv-remove-bogus-no_irq-=-1-define include/asm-frv/irq.h
--- a/include/asm-frv/irq.h~frv-remove-bogus-no_irq-=-1-define
+++ a/include/asm-frv/irq.h
@@ -12,9 +12,6 @@
 #ifndef _ASM_IRQ_H_
 #define _ASM_IRQ_H_
 
-/* this number is used when no interrupt has been assigned */
-#define NO_IRQ				(-1)
-
 #define NR_IRQS				48
 #define IRQ_BASE_CPU			(0 * 16)
 #define IRQ_BASE_FPGA			(1 * 16)
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-libata-all.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
libata-separate-out-ata_acpi_gtm_xfermask-from-pacpi_discover_modes.patch
libata-fix-ata_acpi_gtm_xfermask.patch
libata-implement-ata_timing_cycle2mode-and-use-it-in-libata-acpi-and-pata_acpi.patch
libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm_xfermask.patch
libata-add-ata_cbl_pata_ign.patch
pata_amd-update-mode-selection-for-nv-patas.patch
pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
serial-keep-the-dtr-setting-for-serial-console.patch
quirk_vialatency-omit-reading-pci-revision-id.patch
quirk_vialatency-omit-reading-pci-revision-id-checkpatch-fixes.patch
initio-fix-conflict-when-loading-driver.patch
serial-only-use-pnp-irq-if-its-valid.patch
keyspan-init-termios-properly.patch
tty-fix-network-driver-interactions-with-tcget-set-checkpatch-fixes.patch
geode-lists-are-subscriber-only.patch
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
