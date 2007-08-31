From: akpm@linux-foundation.org
Subject: - libata-allow-for-original-ide-drives-that-dont-support-geometry-setting.patch removed from -mm tree
Date: Fri, 31 Aug 2007 09:56:43 -0700
Message-ID: <200708311656.l7VGuhP5017508@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43671 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758967AbXHaRIS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 13:08:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     libata: allow for original IDE drives that don't support geometry setting
has been removed from the -mm tree.  Its filename was
     libata-allow-for-original-ide-drives-that-dont-support-geometry-setting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-add-a-drivers-ide-style-dma-disable.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
st340823a-hpa-and-libata.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
git-scsi-misc.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
git-xtensa.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
codingstyle-relax-the-80-cole-rule.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
