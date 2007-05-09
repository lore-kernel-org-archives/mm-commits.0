From: akpm@linux-foundation.org
Subject: - fbdev-hecuba-framebuffer-driver-fix.patch removed from -mm tree
Date: Tue, 08 May 2007 19:59:38 -0700
Message-ID: <200705090259.l492xcHv010430@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032742AbXEIC7t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:59:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, adaplas@gmail.com, jayakumar.lkml@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/video/hecubafb.c: make 4 functions static
has been removed from the -mm tree.  Its filename was
     fbdev-hecuba-framebuffer-driver-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/video/hecubafb.c: make 4 functions static
From: Adrian Bunk <bunk@stusta.de>

This patch makes the following needlessly global functions static:
- hcb_wait_for_ack()
- hcb_wait_for_ack_clear()
- apollo_send_data()
- apollo_send_command()

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/hecubafb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/hecubafb.c~fbdev-hecuba-framebuffer-driver-fix drivers/video/hecubafb.c
--- a/drivers/video/hecubafb.c~fbdev-hecuba-framebuffer-driver-fix
+++ a/drivers/video/hecubafb.c
@@ -145,7 +145,7 @@ static int __devinit apollo_init_control
 	return 0;
 }
 
-void hcb_wait_for_ack(struct hecubafb_par *par)
+static void hcb_wait_for_ack(struct hecubafb_par *par)
 {
 
 	int timeout;
@@ -161,7 +161,7 @@ void hcb_wait_for_ack(struct hecubafb_pa
 	printk(KERN_ERR "timed out waiting for ack\n");
 }
 
-void hcb_wait_for_ack_clear(struct hecubafb_par *par)
+static void hcb_wait_for_ack_clear(struct hecubafb_par *par)
 {
 
 	int timeout;
@@ -177,7 +177,7 @@ void hcb_wait_for_ack_clear(struct hecub
 	printk(KERN_ERR "timed out waiting for clear\n");
 }
 
-void apollo_send_data(struct hecubafb_par *par, unsigned char data)
+static void apollo_send_data(struct hecubafb_par *par, unsigned char data)
 {
 	/* set data */
 	hcb_set_data(par, data);
@@ -195,7 +195,7 @@ void apollo_send_data(struct hecubafb_pa
 	hcb_wait_for_ack_clear(par);
 }
 
-void apollo_send_command(struct hecubafb_par *par, unsigned char data)
+static void apollo_send_command(struct hecubafb_par *par, unsigned char data)
 {
 	/* command so set CD to high */
 	par->ctl &= ~(HCB_NCD_BIT);
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-alsa.patch
git-dvb.patch
git-ieee1394.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
drivers-mtd-maps-nettelc-possible-cleanups.patch
ibmtr_cs-fix-hang-on-eject.patch
git-battery.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
drivers-scsi-ipsc-remove-kernel-24-code.patch
drivers-scsi-nsp32c-remove-kernel-24-code.patch
git-unionfs.patch
git-watchdog.patch
git-wireless.patch
git-ipwireless_cs.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
more-scheduled-oss-driver-removal.patch
unexport-pci_proc_attach_device.patch
ext2-reservations.patch
remove-nfs4_acl_add_ace.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
compiler-introduce-__used-and-__maybe_unused.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
slim-main-patch.patch
slim-debug-output.patch
mutex-subsystem-synchro-test-module.patch
