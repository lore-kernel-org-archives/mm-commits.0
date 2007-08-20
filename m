From: akpm@linux-foundation.org
Subject: - libata-acpi-checks-for-80wire-cable-headers.patch removed from -mm tree
Date: Mon, 20 Aug 2007 11:54:44 -0700
Message-ID: <200708201854.l7KIsivq017542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58084 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752428AbXHTSzG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 14:55:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     libata: ACPI checks for 80wire cable: headers
has been removed from the -mm tree.  Its filename was
     libata-acpi-checks-for-80wire-cable-headers.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: libata: ACPI checks for 80wire cable: headers
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

We can use the ACPI mode information with several drivers as a hint to cable
type.  If the ACPI mode set by the BIOS is faster than UDMA33 then we know the
BIOS thinks there are 80wire cables.  If it doesn't set such a mode or it has
no ACPI method then we get no further information and can rely on existing
approaches

Introduce the function headers needed. Null it out for non ACPI boxes

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/libata.h |    6 ++++++
 1 files changed, 6 insertions(+)

diff -puN include/linux/libata.h~libata-acpi-checks-for-80wire-cable-headers include/linux/libata.h
--- a/include/linux/libata.h~libata-acpi-checks-for-80wire-cable-headers
+++ a/include/linux/libata.h
@@ -1053,6 +1053,12 @@ static inline int ata_port_max_devices(c
 	return 1;
 }
 
+/* libata-acpi.c */
+#ifdef CONFIG_ATA_ACPI
+extern int ata_acpi_cbl_80wire(struct ata_port *ap);
+#else
+static inline int ata_acpi_cbl_80wire(struct ata_port *ap) { return 0; }
+#endif
 
 static inline u8 ata_chk_status(struct ata_port *ap)
 {
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
serial-add-support-for-ite-887x-chips.patch
serial_txx9-fix-modem-control-line-handling.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
fix-null-pointer-dereference-in-__vm_enough_memory.patch
m68k-enable-arbitary-speed-tty-support.patch
introduce-config_check_signature-was-re-uninline.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
alpm-enable-aggressive-link-power-management-for-ahci-controllers.patch
libata-acpi-checks-for-80wire-cable-headers.patch
libata-acpi-checks-for-80wire-cable-implementation.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_amd.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_via.patch
libata-correct-iordy-handling.patch
st340823a-hpa-and-libata.patch
pata_cmd64x-set-up-mwdma-modes-properly.patch
ata_piix-disallow-udma-133-on-ich5-ich7.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
serial_txx9-cleanup-includes.patch
git-scsi-misc.patch
dtc-clean-up-indent-damage-and-add-printk-levels.patch
kl5kusb105-switch-to-new-speed-api.patch
mct_u232-convert-to-proper-speed-handling-api-fix.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
char-cyclades-remove-bottom-half-processing.patch
