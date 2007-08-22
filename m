From: akpm@linux-foundation.org
Subject: + pata_via-add-armia-w730-k8-and-other-rebadgings.patch added to -mm tree
Date: Wed, 22 Aug 2007 16:14:23 -0700
Message-ID: <200708222314.l7MNENm2009864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35344 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763324AbXHVXOl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Aug 2007 19:14:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     pata_via: add Armia W730-K8 and other rebadgings
has been added to the -mm tree.  Its filename is
     pata_via-add-armia-w730-k8-and-other-rebadgings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_via: add Armia W730-K8 and other rebadgings
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

More cable funnies

Signed-off-by: Alan Cox <alan@redhat.com>
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
serial-add-support-for-ite-887x-chips.patch
serial_txx9-fix-modem-control-line-handling.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
fix-null-pointer-dereference-in-__vm_enough_memory.patch
m68k-enable-arbitary-speed-tty-support.patch
introduce-config_check_signature-was-re-uninline.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-switch-most-of-the-remaining-sff-drivers-to.patch
pata_sis-add-the-fsc-amilo-and-friends.patch
pata_via-add-armia-w730-k8-and-other-rebadgings.patch
st340823a-hpa-and-libata.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-scsi-misc.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
char-cyclades-remove-bottom-half-processing.patch
