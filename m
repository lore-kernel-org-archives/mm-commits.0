From: akpm@linux-foundation.org
Subject: + libata-correct-iordy-handling.patch added to -mm tree
Date: Tue, 31 Jul 2007 11:43:24 -0700
Message-ID: <200707311843.l6VIhOHS016648@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41598 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755457AbXGaSn7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 14:43:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org, sshtylyov@ru.mvista.com


The patch titled
     libata: correct IORDY handling
has been added to the -mm tree.  Its filename is
     libata-correct-iordy-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2787,7 +2787,11 @@ static int ata_dev_set_mode(struct ata_d
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
@@ -354,7 +354,7 @@ struct ata_taskfile {
 	( (((id)[76] != 0x0000) && ((id)[76] != 0xffff)) && \
 	  ((id)[78] & (1 << 5)) )
 #define ata_id_iordy_disable(id) ((id)[49] & (1 << 10))
-#define ata_id_has_iordy(id) ((id)[49] & (1 << 9))
+#define ata_id_has_iordy(id) ((id)[49] & (1 << 11))
 #define ata_id_u32(id,n)	\
 	(((u32) (id)[(n) + 1] << 16) | ((u32) (id)[(n)]))
 #define ata_id_u64(id,n)	\
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
libata-correct-iordy-handling.patch
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
blackfin-enable-arbitary-speed-serial-setting.patch
char-cyclades-remove-bottom-half-processing.patch
