From: akpm@linux-foundation.org
Subject: + st340823a-hpa-and-libata.patch added to -mm tree
Date: Thu, 09 Aug 2007 12:59:30 -0700
Message-ID: <200708091959.l79JxUld016780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56607 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755567AbXHIUAB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 16:00:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     ST340823A, HPA and libata
has been added to the -mm tree.  Its filename is
     st340823a-hpa-and-libata.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ST340823A, HPA and libata
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Ok this is a different approach to handling it - knowing it is an off by one
so we can handle the drive if clipped

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    7 +++++++
 include/linux/libata.h    |    1 +
 2 files changed, 8 insertions(+)

diff -puN drivers/ata/libata-core.c~st340823a-hpa-and-libata drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~st340823a-hpa-and-libata
+++ a/drivers/ata/libata-core.c
@@ -988,6 +988,10 @@ static u64 ata_hpa_resize(struct ata_dev
 	else
 		hpa_sectors = ata_read_native_max_address(dev);
 
+	/* Reports one sector too many */
+	if (hpa_sectors && (dev->horkage & ATA_HORKAGE_HPA_SIZE))
+		hpa_sectors--;
+
 	if (hpa_sectors > sectors) {
 		ata_dev_printk(dev, KERN_INFO,
 			"Host Protected Area detected:\n"
@@ -3863,6 +3867,9 @@ static const struct ata_blacklist_entry 
 
 	/* Devices with NCQ limits */
 
+	/* Devices which report 1 sector over size HPA */
+	{ "ST340823A",		NULL,		ATA_HORKAGE_HPA_SIZE, },
+
 	/* End Marker */
 	{ }
 };
diff -puN include/linux/libata.h~st340823a-hpa-and-libata include/linux/libata.h
--- a/include/linux/libata.h~st340823a-hpa-and-libata
+++ a/include/linux/libata.h
@@ -314,6 +314,7 @@ enum {
 	ATA_HORKAGE_NONCQ	= (1 << 2),	/* Don't use NCQ */
 	ATA_HORKAGE_MAX_SEC_128	= (1 << 3),	/* Limit max sects to 128 */
 	ATA_HORKAGE_IPM		= (1 << 4), 	/* LPM problems */
+	ATA_HORKAGE_HPA_SIZE	= (1 << 6), 	/* Reports native size off by one */
 };
 
 enum hsm_task_states {
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

fix-serial-buffer-memory-leak.patch
fix-serial-buffer-memory-leak-fix.patch
nozomi-shoot-defunct-label.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
libata-acpi-checks-for-80wire-cable-headers.patch
libata-acpi-checks-for-80wire-cable-implementation.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_amd.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_via.patch
libata-correct-iordy-handling.patch
st340823a-hpa-and-libata.patch
pata_cmd64x-set-up-mwdma-modes-properly.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ata_piix-disallow-udma-133-on-ich5-ich7.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
dtc-clean-up-indent-damage-and-add-printk-levels.patch
kl5kusb105-switch-to-new-speed-api.patch
mct_u232-convert-to-proper-speed-handling-api-fix.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
pci-align-bar-settings-for-legacy-mode-ide-fix.patch
belkin_sa-avoid-divide-by-zero-error.patch
blackfin-enable-arbitary-speed-serial-setting.patch
char-cyclades-remove-bottom-half-processing.patch
