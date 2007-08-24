From: akpm@linux-foundation.org
Subject: - pata_via-add-armia-w730-k8-and-other-rebadgings.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:57:37 -0700
Message-ID: <200708242057.l7OKvben014235@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59156 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760021AbXHXVIq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mikpe@it.uu.se, mm-commits@vger.kernel.org


The patch titled
     pata_via: add Arima W730-K8 and other rebadgings
has been removed from the -mm tree.  Its filename was
     pata_via-add-armia-w730-k8-and-other-rebadgings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_via: add Arima W730-K8 and other rebadgings
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

More cable funnies

Signed-off-by: Alan Cox <alan@redhat.com>
Tested-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_via.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/ata/pata_via.c~pata_via-add-armia-w730-k8-and-other-rebadgings drivers/ata/pata_via.c
--- a/drivers/ata/pata_via.c~pata_via-add-armia-w730-k8-and-other-rebadgings
+++ a/drivers/ata/pata_via.c
@@ -63,7 +63,7 @@
 #include <linux/dmi.h>
 
 #define DRV_NAME "pata_via"
-#define DRV_VERSION "0.3.1"
+#define DRV_VERSION "0.3.2"
 
 /*
  *	The following comes directly from Vojtech Pavlik's ide/pci/via82cxxx
@@ -144,6 +144,9 @@ static int via_cable_override(struct pci
 	/* Systems by DMI */
 	if (dmi_check_system(cable_dmi_table))
 		return 1;
+	/* Armia W730-K8/Targa Visionary 811/... */
+	if (pdev->subsystem_vendor == 0x161F && pdev->subsystem_device == 0x2032)
+		return 1;
 	return 0;
 }
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-switch-most-of-the-remaining-sff-drivers-to.patch
pata_marvell-add-more-identifiers.patch
libata-portmap-remove-unused-definitions.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-spot-bridge-chips.patch
libata-allow-for-original-ide-drives-that-dont-support-geometry-setting.patch
libata-strict-checking-for-identify-reporting.patch
libata-add-a-drivers-ide-style-dma-disable.patch
st340823a-hpa-and-libata.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
git-scsi-misc.patch
fix-gregkh-usb-usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
kobil_sct-rework-driver.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
