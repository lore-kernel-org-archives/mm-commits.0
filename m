From: akpm@osdl.org
Subject: - make-hdlc_setup-static-again.patch removed from -mm tree
Date: Mon, 22 Jan 2007 12:47:33 -0800
Message-ID: <200701222047.l0MKlXLS001636@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50827 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932614AbXAVUuu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jan 2007 15:50:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, khc@pm.waw.pl, mm-commits@vger.kernel.org


The patch titled
     make hdlc_setup() static again
has been removed from the -mm tree.  Its filename was
     make-hdlc_setup-static-again.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make hdlc_setup() static again
From: Adrian Bunk <bunk@stusta.de>

hdlc_setup was exported, but this export was never used.

If a driver using it actually shows up it can still be exported again.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/wan/hdlc.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/net/wan/hdlc.c~make-hdlc_setup-static-again drivers/net/wan/hdlc.c
--- a/drivers/net/wan/hdlc.c~make-hdlc_setup-static-again
+++ a/drivers/net/wan/hdlc.c
@@ -222,7 +222,7 @@ int hdlc_ioctl(struct net_device *dev, s
 	return -EINVAL;
 }
 
-void hdlc_setup(struct net_device *dev)
+static void hdlc_setup(struct net_device *dev)
 {
 	hdlc_device *hdlc = dev_to_hdlc(dev);
 
@@ -325,7 +325,6 @@ MODULE_LICENSE("GPL v2");
 EXPORT_SYMBOL(hdlc_open);
 EXPORT_SYMBOL(hdlc_close);
 EXPORT_SYMBOL(hdlc_ioctl);
-EXPORT_SYMBOL(hdlc_setup);
 EXPORT_SYMBOL(alloc_hdlcdev);
 EXPORT_SYMBOL(unregister_hdlc_device);
 EXPORT_SYMBOL(register_hdlc_protocol);
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-alsa.patch
cpu_freq_table-shouldnt-be-a-def_tristate.patch
drivers-char-drm-drm_mmc-remove-unused-exports.patch
git-dvb.patch
git-gfs2-nmw.patch
ia64-add-pci_get_legacy_ide_irq.patch
git-ieee1394.patch
git-libata-all.patch
mips-remove-smp_tune_scheduling.patch
git-mmc.patch
git-mtd.patch
git-ubi.patch
git-netdev-all.patch
net-irda-proper-prototypes.patch
net-wanrouter-wanmainc-cleanups.patch
net-uninline-skb_put-fix.patch
git-ocfs2.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
x86_64-re-add-a-newline-to-restore_context.patch
lumpy-reclaim-cleanup.patch
remove-include-linux-byteorder-pdp_endianh.patch
toshiba-tc86c001-ide-driver-take-2-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
drivers-char-vc_screenc-proper-prototypes.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix.patch
schedule-obsolete-oss-drivers-for-removal-3rd-round.patch
more-ftape-removal.patch
cleanup-linux-byteorder-swabbh.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i386-drivers.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
drivers-isdn-hisax-proper-prototypes.patch
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
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
