From: akpm@linux-foundation.org
Subject: + swsusp-remove-code-duplication-between-diskc-and-userc-fix.patch added to -mm tree
Date: Tue, 05 Jun 2007 23:49:32 -0700
Message-ID: <200706060649.l566nW14011225@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47488 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756907AbXFFGts (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 02:49:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, rjw@sisk.pl


The patch titled
     kernel/power/disk.c: make code static
has been added to the -mm tree.  Its filename is
     swsusp-remove-code-duplication-between-diskc-and-userc-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel/power/disk.c: make code static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/disk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/power/disk.c~swsusp-remove-code-duplication-between-diskc-and-userc-fix kernel/power/disk.c
--- a/kernel/power/disk.c~swsusp-remove-code-duplication-between-diskc-and-userc-fix
+++ a/kernel/power/disk.c
@@ -45,7 +45,7 @@ enum {
 
 static int hibernation_mode = HIBERNATION_SHUTDOWN;
 
-struct hibernation_ops *hibernation_ops;
+static struct hibernation_ops *hibernation_ops;
 
 /**
  * hibernation_set_ops - set the global hibernate operations
@@ -189,7 +189,7 @@ int hibernation_platform_enter(void)
  *	to power off or reboot.
  */
 
-void power_down(void)
+static void power_down(void)
 {
 	switch (hibernation_mode) {
 	case HIBERNATION_TEST:
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
make-drivers-char-hvc_consoleckhvcd-static.patch
fix-2-gregkh-driver-dmi-based-module-autoloading.patch
git-dvb-fix-the-tea5761-tuner-support.patch
git-input-make-xpad_play_effect-static.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
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
swsusp-remove-code-duplication-between-diskc-and-userc-fix.patch
more-scheduled-oss-driver-removal.patch
remove-sonypi_camera_command.patch
ext2-reservations.patch
revoke-core-code.patch
oss-trident-fix-locking-around-write_voice_regs.patch
pm3fb-possible-cleanups.patch
vt8623fbc-make-code-static.patch
drivers-edac-core-make-functions-static.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
