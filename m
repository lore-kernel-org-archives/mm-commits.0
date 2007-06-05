From: akpm@linux-foundation.org
Subject: + git-dvb-fix-the-tea5761-tuner-support.patch added to -mm tree
Date: Mon, 04 Jun 2007 18:07:57 -0700
Message-ID: <200706050107.l5517t3W026651@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34661 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751924AbXFEBIR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 21:08:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, mchehab@infradead.org


The patch titled
     git-dvb: fix the tea5761 tuner support
has been added to the -mm tree.  Its filename is
     git-dvb-fix-the-tea5761-tuner-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-dvb: fix the tea5761 tuner support
From: Adrian Bunk <bunk@stusta.de>

Due to a typo the tea5761 tuner support was dead code.

This patch also fixes a bug in the no longer dead code:
A void function can't return anything.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/tuner-core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/media/video/tuner-core.c~git-dvb-fix-the-tea5761-tuner-support drivers/media/video/tuner-core.c
--- a/drivers/media/video/tuner-core.c~git-dvb-fix-the-tea5761-tuner-support
+++ a/drivers/media/video/tuner-core.c
@@ -25,7 +25,7 @@
 
 /* standard i2c insmod options */
 static unsigned short normal_i2c[] = {
-#ifdef CONFIG_TUNER_5761
+#ifdef CONFIG_TUNER_TEA5761
 	0x10,
 #endif
 	0x42, 0x43, 0x4a, 0x4b,			/* tda8290 */
@@ -192,12 +192,12 @@ static void set_type(struct i2c_client *
 		}
 		t->mode_mask = T_RADIO;
 		break;
-#ifdef CONFIG_TUNER_5761
+#ifdef CONFIG_TUNER_TEA5761
 	case TUNER_TEA5761:
 		if (tea5761_tuner_init(c) == EINVAL) {
 			t->type = TUNER_ABSENT;
 			t->mode_mask = T_UNINITIALIZED;
-			return -ENODEV;
+			return;
 		}
 		t->mode_mask = T_RADIO;
 		break;
@@ -473,7 +473,7 @@ static int tuner_attach(struct i2c_adapt
 	/* autodetection code based on the i2c addr */
 	if (!no_autodetect) {
 		switch (addr) {
-#ifdef CONFIG_TUNER_5761
+#ifdef CONFIG_TUNER_TEA5761
 		case 0x10:
 			if (tea5761_autodetection(&t->i2c) != EINVAL) {
 				t->type = TUNER_TEA5761;
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
make-drivers-char-hvc_consoleckhvcd-static.patch
fix-2-gregkh-driver-dmi-based-module-autoloading.patch
git-dvb-fix-the-tea5761-tuner-support.patch
git-input-make-xpad_play_effect-static.patch
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
