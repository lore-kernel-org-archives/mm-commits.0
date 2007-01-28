From: akpm@osdl.org
Subject: + fix-config_sata_sis=y-compile-error.patch added to -mm tree
Date: Sun, 28 Jan 2007 15:43:09 -0800
Message-ID: <200701282343.l0SNh9Ew006187@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42254 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933007AbXA1Xq3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 28 Jan 2007 18:46:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, htejun@gmail.com, jeff@garzik.org


The patch titled
     fix CONFIG_SATA_SIS=y compile error
has been added to the -mm tree.  Its filename is
     fix-config_sata_sis=y-compile-error.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix CONFIG_SATA_SIS=y compile error
From: Adrian Bunk <bunk@stusta.de>

Static code shouldn't be used from other modules.

drivers/built-in.o: In function `sis_init_one':
sata_sis.c:(.text+0x7634cd): undefined reference to `sis_info133'
sata_sis.c:(.text+0x7634d6): undefined reference to `sis_info133'

While I was at it, I also moved the prototype of this struct to a header
file.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ata/libata.h   |    3 +++
 drivers/ata/pata_sis.c |    3 ++-
 drivers/ata/sata_sis.c |    4 +---
 3 files changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/ata/libata.h~fix-config_sata_sis=y-compile-error drivers/ata/libata.h
--- a/drivers/ata/libata.h~fix-config_sata_sis=y-compile-error
+++ a/drivers/ata/libata.h
@@ -151,4 +151,7 @@ extern void ata_qc_schedule_eh(struct at
 /* libata-sff.c */
 extern u8 ata_irq_on(struct ata_port *ap);
 
+/* pata_sis.c */
+extern struct ata_port_info sis_info133;
+
 #endif /* __LIBATA_H__ */
diff -puN drivers/ata/pata_sis.c~fix-config_sata_sis=y-compile-error drivers/ata/pata_sis.c
--- a/drivers/ata/pata_sis.c~fix-config_sata_sis=y-compile-error
+++ a/drivers/ata/pata_sis.c
@@ -32,6 +32,7 @@
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
 #include <linux/ata.h>
+#include "libata.h"
 
 #define DRV_NAME	"pata_sis"
 #define DRV_VERSION	"0.4.5"
@@ -781,7 +782,7 @@ static struct ata_port_info sis_info100_
 	.pio_mask	= 0x1f,	/* pio0-4 */
 	.port_ops	= &sis_66_ops,
 };
-static struct ata_port_info sis_info133 = {
+struct ata_port_info sis_info133 = {
 	.sht		= &sis_sht,
 	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 	.pio_mask	= 0x1f,	/* pio0-4 */
diff -puN drivers/ata/sata_sis.c~fix-config_sata_sis=y-compile-error drivers/ata/sata_sis.c
--- a/drivers/ata/sata_sis.c~fix-config_sata_sis=y-compile-error
+++ a/drivers/ata/sata_sis.c
@@ -40,6 +40,7 @@
 #include <linux/device.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
+#include "libata.h"
 
 #define DRV_NAME	"sata_sis"
 #define DRV_VERSION	"0.7"
@@ -254,9 +255,6 @@ static void sis_scr_write (struct ata_po
 
 static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	/* Provided by the PATA driver */
-	extern struct ata_port_info sis_info133;
-
 	static int printed_version;
 	struct ata_probe_ent *probe_ent = NULL;
 	int rc;
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-alsa.patch
cpu_freq_table-shouldnt-be-a-def_tristate.patch
git-powerpc.patch
drivers-char-drm-drm_mmc-remove-unused-exports.patch
git-dvb.patch
drivers-media-dvb-frontends-make-4-functions-static.patch
git-gfs2-nmw.patch
ia64-add-pci_get_legacy_ide_irq.patch
git-ieee1394.patch
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
usb_rtl8150-must-select-mii.patch
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
