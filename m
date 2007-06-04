From: akpm@linux-foundation.org
Subject: + remove-sonypi_camera_command.patch added to -mm tree
Date: Mon, 04 Jun 2007 14:38:05 -0700
Message-ID: <200706042138.l54Lc5OM019781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54299 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753494AbXFDViX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 17:38:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, malattia@linux.it


The patch titled
     remove sonypi_camera_command()
has been added to the -mm tree.  Its filename is
     remove-sonypi_camera_command.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove sonypi_camera_command()
From: Adrian Bunk <bunk@stusta.de>

Remove the no longer used sonypi_camera_command().

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Mattia Dongili <malattia@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sonypi.c  |   47 ---------------------------------------
 include/linux/sonypi.h |    2 -
 2 files changed, 49 deletions(-)

diff -puN drivers/char/sonypi.c~remove-sonypi_camera_command drivers/char/sonypi.c
--- a/drivers/char/sonypi.c~remove-sonypi_camera_command
+++ a/drivers/char/sonypi.c
@@ -885,53 +885,6 @@ found:
 	return IRQ_HANDLED;
 }
 
-/* External camera command (exported to the motion eye v4l driver) */
-int sonypi_camera_command(int command, u8 value)
-{
-	if (!camera)
-		return -EIO;
-
-	mutex_lock(&sonypi_device.lock);
-
-	switch (command) {
-	case SONYPI_COMMAND_SETCAMERA:
-		if (value)
-			sonypi_camera_on();
-		else
-			sonypi_camera_off();
-		break;
-	case SONYPI_COMMAND_SETCAMERABRIGHTNESS:
-		sonypi_set(SONYPI_CAMERA_BRIGHTNESS, value);
-		break;
-	case SONYPI_COMMAND_SETCAMERACONTRAST:
-		sonypi_set(SONYPI_CAMERA_CONTRAST, value);
-		break;
-	case SONYPI_COMMAND_SETCAMERAHUE:
-		sonypi_set(SONYPI_CAMERA_HUE, value);
-		break;
-	case SONYPI_COMMAND_SETCAMERACOLOR:
-		sonypi_set(SONYPI_CAMERA_COLOR, value);
-		break;
-	case SONYPI_COMMAND_SETCAMERASHARPNESS:
-		sonypi_set(SONYPI_CAMERA_SHARPNESS, value);
-		break;
-	case SONYPI_COMMAND_SETCAMERAPICTURE:
-		sonypi_set(SONYPI_CAMERA_PICTURE, value);
-		break;
-	case SONYPI_COMMAND_SETCAMERAAGC:
-		sonypi_set(SONYPI_CAMERA_AGC, value);
-		break;
-	default:
-		printk(KERN_ERR "sonypi: sonypi_camera_command invalid: %d\n",
-		       command);
-		break;
-	}
-	mutex_unlock(&sonypi_device.lock);
-	return 0;
-}
-
-EXPORT_SYMBOL(sonypi_camera_command);
-
 static int sonypi_misc_fasync(int fd, struct file *filp, int on)
 {
 	int retval;
diff -puN include/linux/sonypi.h~remove-sonypi_camera_command include/linux/sonypi.h
--- a/include/linux/sonypi.h~remove-sonypi_camera_command
+++ a/include/linux/sonypi.h
@@ -153,8 +153,6 @@
 #define SONYPI_COMMAND_GETCAMERAROMVERSION	18	/* obsolete */
 #define SONYPI_COMMAND_GETCAMERAREVISION	19	/* obsolete */
 
-int sonypi_camera_command(int command, u8 value);
-
 #endif				/* __KERNEL__ */
 
 #endif				/* _SONYPI_H_ */
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
make-drivers-char-hvc_consoleckhvcd-static.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
the-async_-options-shouldnt-be-user-visible.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
drivers-mtd-maps-nettelc-possible-cleanups.patch
git-battery.patch
unexport-pci_proc_attach_device.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
more-scheduled-oss-driver-removal.patch
remove-sonypi_camera_command.patch
ext2-reservations.patch
revoke-core-code.patch
oss-trident-fix-locking-around-write_voice_regs.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
