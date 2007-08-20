From: akpm@linux-foundation.org
Subject: - libata-correct-iordy-handling.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:12:41 -0700
Message-ID: <200708201912.l7KJCfov018376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33593 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761233AbXHTTVv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:21:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org, sshtylyov@ru.mvista.com, mm-commits@vger.kernel.org


The patch titled
     libata: correct IORDY handling
has been removed from the -mm tree.  Its filename was
     libata-correct-iordy-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: correct IORDY handling
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Debugging a report of a problem with an ancient solid state disk showed up
some problems in the IORDY handling

1.	We check the wrong bit to see if the device has IORDY
2.	Even then some ancient creaking piles of crap don't support
	SETXFER at all.

I think this should go via -mm for a bit.  The cases it fixes are obscure
and the risk of side effects is slight but possible.  This also moves us
slightly closer to supporting original MFM/RLL disks with libata but before
Jeff panics I have no plans to do that....

Signed-off-by: Alan Cox <alan@redhat.com>
Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    6 +++++-
 include/linux/ata.h       |    2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-correct-iordy-handling drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-correct-iordy-handling
+++ a/drivers/ata/libata-core.c
@@ -2770,7 +2770,11 @@ static int ata_dev_set_mode(struct ata_d
 	/* Old CFA may refuse this command, which is just fine */
 	if (dev->xfer_shift == ATA_SHIFT_PIO && ata_id_is_cfa(dev->id))
         	err_mask &= ~AC_ERR_DEV;
-
+	/* Some very old devices and some bad newer ones fail any kind of
+	   SET_XFERMODE request but support PIO0-2 timings and no IORDY */
+	if (dev->xfer_shift == ATA_SHIFT_PIO && !ata_id_has_iordy(dev->id) &&
+			dev->pio_mode <= XFER_PIO_2)
+		err_mask &= ~AC_ERR_DEV;
 	if (err_mask) {
 		ata_dev_printk(dev, KERN_ERR, "failed to set xfermode "
 			       "(err_mask=0x%x)\n", err_mask);
diff -puN include/linux/ata.h~libata-correct-iordy-handling include/linux/ata.h
--- a/include/linux/ata.h~libata-correct-iordy-handling
+++ a/include/linux/ata.h
@@ -345,7 +345,7 @@ struct ata_taskfile {
 #define ata_id_removeable(id)	((id)[0] & (1 << 7))
 #define ata_id_has_dword_io(id)	((id)[50] & (1 << 0))
 #define ata_id_iordy_disable(id) ((id)[49] & (1 << 10))
-#define ata_id_has_iordy(id) ((id)[49] & (1 << 9))
+#define ata_id_has_iordy(id) ((id)[49] & (1 << 11))
 #define ata_id_u32(id,n)	\
 	(((u32) (id)[(n) + 1] << 16) | ((u32) (id)[(n)]))
 #define ata_id_u64(id,n)	\
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
libata-acpi-checks-for-80wire-cable-implementation.patch
st340823a-hpa-and-libata.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
serial_txx9-cleanup-includes.patch
git-scsi-misc.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
char-cyclades-remove-bottom-half-processing.patch
