From: akpm@linux-foundation.org
Subject: + libata-allow-for-original-ide-drives-that-dont-support-geometry-setting.patch added to -mm tree
Date: Thu, 23 Aug 2007 15:24:45 -0700
Message-ID: <200708232224.l7NMOjLm029853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48869 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762345AbXHWWY4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 18:24:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     libata: allow for original IDE drives that don't support geometry setting
has been added to the -mm tree.  Its filename is
     libata-allow-for-original-ide-drives-that-dont-support-geometry-setting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: allow for original IDE drives that don't support geometry setting
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This is mandatory for all early ATA devices but may fail on IDE.  As we try to
set the geometry to the geometry we already have a failure of this request is
harmless.  We can't skip the request as its mandatory during setup and some
older ATA drives pee themselves if you don't do it.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    7 +++++++
 1 files changed, 7 insertions(+)

diff -puN drivers/ata/libata-core.c~libata-allow-for-original-ide-drives-that-dont-support-geometry-setting drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-allow-for-original-ide-drives-that-dont-support-geometry-setting
+++ a/drivers/ata/libata-core.c
@@ -4090,6 +4090,8 @@ static unsigned int ata_dev_set_AN(struc
  *	@heads: Number of heads (taskfile parameter)
  *	@sectors: Number of sectors (taskfile parameter)
  *
+ *	FIXME: Although mandatory on ATA1-4 it is not on original IDE
+ *
  *	LOCKING:
  *	Kernel thread context (may sleep)
  *
@@ -4117,6 +4119,11 @@ static unsigned int ata_dev_init_params(
 	tf.device |= (heads - 1) & 0x0f; /* max head = num. of heads - 1 */
 
 	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0);
+	/* A clean abort indicates an original or just out of spec drive
+	   and we should continue as we issue the setup based on the
+	   drive reported working geometry */
+	if (err_mask == AC_ERR_DEV && (tf.feature & ATA_ABORTED))
+		err_mask &= ~AC_ERR_DEV;
 
 	DPRINTK("EXIT, err_mask=%x\n", err_mask);
 	return err_mask;
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
pata_marvell-add-more-identifiers.patch
libata-portmap-remove-unused-definitions.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-spot-bridge-chips.patch
libata-allow-for-original-ide-drives-that-dont-support-geometry-setting.patch
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
pata_it821x-fix-regression-corruptor.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
