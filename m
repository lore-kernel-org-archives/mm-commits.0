From: akpm@linux-foundation.org
Subject: + vt8623fbc-make-code-static.patch added to -mm tree
Date: Tue, 05 Jun 2007 10:56:32 -0700
Message-ID: <200706051756.l55HuWmb032042@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41296 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754996AbXFER4r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 13:56:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, adaplas@gmail.com


The patch titled
     vt8623fb.c: make code static
has been added to the -mm tree.  Its filename is
     vt8623fbc-make-code-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vt8623fb.c: make code static
From: Adrian Bunk <bunk@stusta.de>

This patch makes needlessly global code static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/vt8623fb.c |   40 ++++++++++++++++++-------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff -puN drivers/video/vt8623fb.c~vt8623fbc-make-code-static drivers/video/vt8623fb.c
--- a/drivers/video/vt8623fb.c~vt8623fbc-make-code-static
+++ a/drivers/video/vt8623fb.c
@@ -68,26 +68,26 @@ static const struct svga_pll vt8623_pll 
 
 /* CRT timing register sets */
 
-struct vga_regset vt8623_h_total_regs[]       = {{0x00, 0, 7}, {0x36, 3, 3}, VGA_REGSET_END};
-struct vga_regset vt8623_h_display_regs[]     = {{0x01, 0, 7}, VGA_REGSET_END};
-struct vga_regset vt8623_h_blank_start_regs[] = {{0x02, 0, 7}, VGA_REGSET_END};
-struct vga_regset vt8623_h_blank_end_regs[]   = {{0x03, 0, 4}, {0x05, 7, 7}, {0x33, 5, 5}, VGA_REGSET_END};
-struct vga_regset vt8623_h_sync_start_regs[]  = {{0x04, 0, 7}, {0x33, 4, 4}, VGA_REGSET_END};
-struct vga_regset vt8623_h_sync_end_regs[]    = {{0x05, 0, 4}, VGA_REGSET_END};
-
-struct vga_regset vt8623_v_total_regs[]       = {{0x06, 0, 7}, {0x07, 0, 0}, {0x07, 5, 5}, {0x35, 0, 0}, VGA_REGSET_END};
-struct vga_regset vt8623_v_display_regs[]     = {{0x12, 0, 7}, {0x07, 1, 1}, {0x07, 6, 6}, {0x35, 2, 2}, VGA_REGSET_END};
-struct vga_regset vt8623_v_blank_start_regs[] = {{0x15, 0, 7}, {0x07, 3, 3}, {0x09, 5, 5}, {0x35, 3, 3}, VGA_REGSET_END};
-struct vga_regset vt8623_v_blank_end_regs[]   = {{0x16, 0, 7}, VGA_REGSET_END};
-struct vga_regset vt8623_v_sync_start_regs[]  = {{0x10, 0, 7}, {0x07, 2, 2}, {0x07, 7, 7}, {0x35, 1, 1}, VGA_REGSET_END};
-struct vga_regset vt8623_v_sync_end_regs[]    = {{0x11, 0, 3}, VGA_REGSET_END};
-
-struct vga_regset vt8623_offset_regs[]        = {{0x13, 0, 7}, {0x35, 5, 7}, VGA_REGSET_END};
-struct vga_regset vt8623_line_compare_regs[]  = {{0x18, 0, 7}, {0x07, 4, 4}, {0x09, 6, 6}, {0x33, 0, 2}, {0x35, 4, 4}, VGA_REGSET_END};
-struct vga_regset vt8623_fetch_count_regs[]   = {{0x1C, 0, 7}, {0x1D, 0, 1}, VGA_REGSET_END};
-struct vga_regset vt8623_start_address_regs[] = {{0x0d, 0, 7}, {0x0c, 0, 7}, {0x34, 0, 7}, {0x48, 0, 1}, VGA_REGSET_END};
+static struct vga_regset vt8623_h_total_regs[]       = {{0x00, 0, 7}, {0x36, 3, 3}, VGA_REGSET_END};
+static struct vga_regset vt8623_h_display_regs[]     = {{0x01, 0, 7}, VGA_REGSET_END};
+static struct vga_regset vt8623_h_blank_start_regs[] = {{0x02, 0, 7}, VGA_REGSET_END};
+static struct vga_regset vt8623_h_blank_end_regs[]   = {{0x03, 0, 4}, {0x05, 7, 7}, {0x33, 5, 5}, VGA_REGSET_END};
+static struct vga_regset vt8623_h_sync_start_regs[]  = {{0x04, 0, 7}, {0x33, 4, 4}, VGA_REGSET_END};
+static struct vga_regset vt8623_h_sync_end_regs[]    = {{0x05, 0, 4}, VGA_REGSET_END};
+
+static struct vga_regset vt8623_v_total_regs[]       = {{0x06, 0, 7}, {0x07, 0, 0}, {0x07, 5, 5}, {0x35, 0, 0}, VGA_REGSET_END};
+static struct vga_regset vt8623_v_display_regs[]     = {{0x12, 0, 7}, {0x07, 1, 1}, {0x07, 6, 6}, {0x35, 2, 2}, VGA_REGSET_END};
+static struct vga_regset vt8623_v_blank_start_regs[] = {{0x15, 0, 7}, {0x07, 3, 3}, {0x09, 5, 5}, {0x35, 3, 3}, VGA_REGSET_END};
+static struct vga_regset vt8623_v_blank_end_regs[]   = {{0x16, 0, 7}, VGA_REGSET_END};
+static struct vga_regset vt8623_v_sync_start_regs[]  = {{0x10, 0, 7}, {0x07, 2, 2}, {0x07, 7, 7}, {0x35, 1, 1}, VGA_REGSET_END};
+static struct vga_regset vt8623_v_sync_end_regs[]    = {{0x11, 0, 3}, VGA_REGSET_END};
+
+static struct vga_regset vt8623_offset_regs[]        = {{0x13, 0, 7}, {0x35, 5, 7}, VGA_REGSET_END};
+static struct vga_regset vt8623_line_compare_regs[]  = {{0x18, 0, 7}, {0x07, 4, 4}, {0x09, 6, 6}, {0x33, 0, 2}, {0x35, 4, 4}, VGA_REGSET_END};
+static struct vga_regset vt8623_fetch_count_regs[]   = {{0x1C, 0, 7}, {0x1D, 0, 1}, VGA_REGSET_END};
+static struct vga_regset vt8623_start_address_regs[] = {{0x0d, 0, 7}, {0x0c, 0, 7}, {0x34, 0, 7}, {0x48, 0, 1}, VGA_REGSET_END};
 
-struct svga_timing_regs vt8623_timing_regs     = {
+static struct svga_timing_regs vt8623_timing_regs     = {
 	vt8623_h_total_regs, vt8623_h_display_regs, vt8623_h_blank_start_regs,
 	vt8623_h_blank_end_regs, vt8623_h_sync_start_regs, vt8623_h_sync_end_regs,
 	vt8623_v_total_regs, vt8623_v_display_regs, vt8623_v_blank_start_regs,
@@ -903,7 +903,7 @@ static void __exit vt8623fb_cleanup(void
 
 /* Driver Initialisation */
 
-int __init vt8623fb_init(void)
+static int __init vt8623fb_init(void)
 {
 
 #ifndef MODULE
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
more-scheduled-oss-driver-removal.patch
remove-sonypi_camera_command.patch
ext2-reservations.patch
revoke-core-code.patch
oss-trident-fix-locking-around-write_voice_regs.patch
pm3fb-possible-cleanups.patch
vt8623fbc-make-code-static.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
