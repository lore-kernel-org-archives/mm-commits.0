From: akpm@osdl.org
Subject: + config_input_debug-improvements.patch added to -mm tree
Date: Mon, 29 Jan 2007 17:26:28 -0800
Message-ID: <200701300126.l0U1QS1i005567@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36768 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932812AbXA3B3u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 20:29:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, dtor@mail.ru


The patch titled
     CONFIG_INPUT_DEBUG improvements
has been added to the -mm tree.  Its filename is
     config_input_debug-improvements.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: CONFIG_INPUT_DEBUG improvements
From: Adrian Bunk <bunk@stusta.de>

- remove Makefile code for the nonexisting CONFIG_INPUT_DEBUG
- simpler Makefile for hid-debug.o
- replace all HID debug #define's with CONFIG_INPUT_DEBUG

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/hid/Makefile    |   15 ++-------------
 drivers/hid/hid-core.c  |    6 ++----
 drivers/hid/hid-input.c |    6 ++----
 3 files changed, 6 insertions(+), 21 deletions(-)

diff -puN drivers/hid/Makefile~config_input_debug-improvements drivers/hid/Makefile
--- a/drivers/hid/Makefile~config_input_debug-improvements
+++ a/drivers/hid/Makefile
@@ -2,18 +2,7 @@
 # Makefile for the HID driver
 #
 
-# Multipart objects.
-hid-objs	:= hid-core.o hid-input.o
-
-# Optional parts of multipart objects.
-ifeq ($(CONFIG_HID_DEBUG),y)
-hid-objs	+= hid-debug.o
-endif
-
-ifeq ($(CONFIG_INPUT_DEBUG),y)
-EXTRA_CFLAGS += -DDEBUG
-endif
-
-
 obj-$(CONFIG_HID)		+= hid.o
+hid-objs			:= hid-core.o hid-input.o
+hid-$(CONFIG_HID_DEBUG)		+= hid-debug.o
 
diff -puN drivers/hid/hid-core.c~config_input_debug-improvements drivers/hid/hid-core.c
--- a/drivers/hid/hid-core.c~config_input_debug-improvements
+++ a/drivers/hid/hid-core.c
@@ -28,8 +28,6 @@
 #include <linux/input.h>
 #include <linux/wait.h>
 
-#undef DEBUG_DATA
-
 #include <linux/hid.h>
 #include <linux/hiddev.h>
 #include <linux/hid-debug.h>
@@ -951,7 +949,7 @@ int hid_input_report(struct hid_device *
 		return -1;
 	}
 
-#ifdef DEBUG_DATA
+#ifdef CONFIG_INPUT_DEBUG
 	printk(KERN_DEBUG __FILE__ ": report (size %u) (%snumbered)\n", size, report_enum->numbered ? "" : "un");
 #endif
 
@@ -961,7 +959,7 @@ int hid_input_report(struct hid_device *
 		size--;
 	}
 
-#ifdef DEBUG_DATA
+#ifdef CONFIG_INPUT_DEBUG
 	{
 		int i;
 		printk(KERN_DEBUG __FILE__ ": report %d (size %u) = ", n, size);
diff -puN drivers/hid/hid-input.c~config_input_debug-improvements drivers/hid/hid-input.c
--- a/drivers/hid/hid-input.c~config_input_debug-improvements
+++ a/drivers/hid/hid-input.c
@@ -31,8 +31,6 @@
 #include <linux/slab.h>
 #include <linux/kernel.h>
 
-#undef DEBUG
-
 #include <linux/hid.h>
 #include <linux/hid-debug.h>
 
@@ -248,7 +246,7 @@ static void hidinput_configure_usage(str
 
 	field->hidinput = hidinput;
 
-#ifdef DEBUG
+#ifdef CONFIG_HID_DEBUG
 	printk(KERN_DEBUG "Mapping: ");
 	hid_resolv_usage(usage->hid);
 	printk(" ---> ");
@@ -685,7 +683,7 @@ static void hidinput_configure_usage(str
 	return;
 
 ignore:
-#ifdef DEBUG
+#ifdef CONFIG_HID_DEBUG
 	printk("IGNORED\n");
 #endif
 	return;
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
fs-lockd-clntlockc-add-missing-newlines-to-dprintks.patch
git-acpi.patch
git-alsa.patch
cpu_freq_table-shouldnt-be-a-def_tristate.patch
git-powerpc.patch
drivers-char-drm-drm_mmc-remove-unused-exports.patch
git-dvb.patch
drivers-media-dvb-frontends-make-4-functions-static.patch
cx88-videoc-remove-struct-radionorms.patch
git-gfs2-nmw.patch
ia64-add-pci_get_legacy_ide_irq.patch
git-ieee1394.patch
config_input_debug-improvements.patch
git-libata-all.patch
fix-config_sata_sis=y-compile-error.patch
mips-remove-smp_tune_scheduling.patch
git-mmc.patch
mtd_ck804xrom-must-depend-on-pci.patch
git-ubi.patch
git-netdev-all.patch
remove-one-remaining-define-bcm_tso-1.patch
net-irda-proper-prototypes.patch
net-wanrouter-wanmainc-cleanups.patch
nf_conntrack_h323-must-depend-on-ipv6-ipv6=n.patch
net-uninline-skb_put-fix.patch
git-ocfs2.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
git-unionfs.patch
usb_rtl8150-must-select-mii.patch
cleanup-x86_64-mm-vmi-timer.patch
x86_64-re-add-a-newline-to-restore_context.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
lumpy-reclaim-cleanup.patch
remove-include-linux-byteorder-pdp_endianh.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
drivers-char-vc_screenc-proper-prototypes.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix.patch
schedule-obsolete-oss-drivers-for-removal-3rd-round.patch
cleanup-linux-byteorder-swabbh.patch
cleanup-include-linux-xattrh.patch
cleanup-include-linux-reiserfs_xattrh.patch
remove-dead-kernel-config-option-aedsp16_mpu401.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i383-drivers.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
drivers-isdn-hisax-proper-prototypes.patch
drivers-isdn-sc-proper-prototypes.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
fbdev-driver-for-s3-trio-virge-cleanups.patch
remove-broken-video-drivers-v4.patch
remove-bogus-con_is_present-prototypes.patch
proper-prototype-for-tosh_smm.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
