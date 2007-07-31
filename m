From: akpm@linux-foundation.org
Subject: - pata_ali-more-work.patch removed from -mm tree
Date: Tue, 31 Jul 2007 03:10:32 -0700
Message-ID: <200707311010.l6VAAWY9028034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59643 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754333AbXGaKKs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 06:10:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pata_ali: more work
has been removed from the -mm tree.  Its filename was
     pata_ali-more-work.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: pata_ali: more work
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Still don't know why some people see problems with ATAPI devices
specifically but here are some more small fixes done while searching for
the root problem (some of these fixes are overconservative but that can be
fixed *after* the thing works fully)

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_ali.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN drivers/ata/pata_ali.c~pata_ali-more-work drivers/ata/pata_ali.c
--- a/drivers/ata/pata_ali.c~pata_ali-more-work
+++ a/drivers/ata/pata_ali.c
@@ -346,6 +346,16 @@ static int ali_check_atapi_dma(struct at
 	return 0;
 }
 
+static int ali_check_atapi_dma_20(struct ata_queued_cmd *qc)
+{
+	if (qc->dma_dir == DMA_TO_DEVICE)
+		return -1;
+	/* Don't do DMA except for whole blocks */
+	if (qc->nbytes & 511)
+		return -1;
+	return 0;
+}
+
 static struct scsi_host_template ali_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -385,7 +395,6 @@ static struct ata_port_operations ali_ea
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
-	.check_atapi_dma= ali_check_atapi_dma,
 
 	.data_xfer	= ata_data_xfer,
 
@@ -428,7 +437,7 @@ static struct ata_port_operations ali_20
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
-	.check_atapi_dma= ali_check_atapi_dma,
+	.check_atapi_dma= ali_check_atapi_dma_20,
 
 	.data_xfer	= ata_data_xfer,
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
nozomi-shoot-defunct-label.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
sata_mv-test-patch-for-hightpoint-rocketraid-1740-1742.patch
libata-acpi-checks-for-80wire-cable-headers.patch
libata-acpi-checks-for-80wire-cable-implementation.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_amd.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_via.patch
libata-sff-unbreak-non-dma-capable-controllers-again.patch
pata_cmd64x-correct-the-speed-ranges.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
pata_ali-more-work.patch
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
blackfin-enable-arbitary-speed-serial-setting.patch
char-cyclades-remove-bottom-half-processing.patch
