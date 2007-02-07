From: akpm@linux-foundation.org
Subject: + drivers-scsi-aacraid-cleanups.patch added to -mm tree
Date: Tue, 06 Feb 2007 16:52:14 -0800
Message-ID: <200702070052.l170qEVl002441@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57115 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933316AbXBGAw1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 19:52:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, James.Bottomley@steeleye.com


The patch titled
     drivers/scsi/aacraid/: cleanups
has been added to the -mm tree.  Its filename is
     drivers-scsi-aacraid-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/scsi/aacraid/: cleanups
From: Adrian Bunk <bunk@stusta.de>

- proper prototypes for global code in aacraid.h
- aac_rx_start_adapter() can now become static

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/aacraid.h |    3 +++
 drivers/scsi/aacraid/linit.c   |    2 --
 drivers/scsi/aacraid/nark.c    |    3 ---
 drivers/scsi/aacraid/rkt.c     |    3 ---
 drivers/scsi/aacraid/rx.c      |    2 +-
 5 files changed, 4 insertions(+), 9 deletions(-)

diff -puN drivers/scsi/aacraid/aacraid.h~drivers-scsi-aacraid-cleanups drivers/scsi/aacraid/aacraid.h
--- a/drivers/scsi/aacraid/aacraid.h~drivers-scsi-aacraid-cleanups
+++ a/drivers/scsi/aacraid/aacraid.h
@@ -1840,8 +1840,11 @@ struct aac_driver_ident* aac_get_driver_
 int aac_get_adapter_info(struct aac_dev* dev);
 int aac_send_shutdown(struct aac_dev *dev);
 int aac_probe_container(struct aac_dev *dev, int cid);
+int _aac_rx_init(struct aac_dev *dev);
+int aac_rx_select_comm(struct aac_dev *dev, int comm);
 extern int numacb;
 extern int acbsize;
 extern char aac_driver_version[];
 extern int startup_timeout;
 extern int aif_timeout;
+extern int expose_physicals;
diff -puN drivers/scsi/aacraid/linit.c~drivers-scsi-aacraid-cleanups drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c~drivers-scsi-aacraid-cleanups
+++ a/drivers/scsi/aacraid/linit.c
@@ -82,8 +82,6 @@ static LIST_HEAD(aac_devices);
 static int aac_cfg_major = -1;
 char aac_driver_version[] = AAC_DRIVER_FULL_VERSION;
 
-extern int expose_physicals;
-
 /*
  * Because of the way Linux names scsi devices, the order in this table has
  * become important.  Check for on-board Raid first, add-in cards second.
diff -puN drivers/scsi/aacraid/nark.c~drivers-scsi-aacraid-cleanups drivers/scsi/aacraid/nark.c
--- a/drivers/scsi/aacraid/nark.c~drivers-scsi-aacraid-cleanups
+++ a/drivers/scsi/aacraid/nark.c
@@ -74,9 +74,6 @@ static int aac_nark_ioremap(struct aac_d
 
 int aac_nark_init(struct aac_dev * dev)
 {
-	extern int _aac_rx_init(struct aac_dev *dev);
-	extern int aac_rx_select_comm(struct aac_dev *dev, int comm);
-
 	/*
 	 *	Fill in the function dispatch table.
 	 */
diff -puN drivers/scsi/aacraid/rkt.c~drivers-scsi-aacraid-cleanups drivers/scsi/aacraid/rkt.c
--- a/drivers/scsi/aacraid/rkt.c~drivers-scsi-aacraid-cleanups
+++ a/drivers/scsi/aacraid/rkt.c
@@ -45,7 +45,6 @@
 static int aac_rkt_select_comm(struct aac_dev *dev, int comm)
 {
 	int retval;
-	extern int aac_rx_select_comm(struct aac_dev *dev, int comm);
 	retval = aac_rx_select_comm(dev, comm);
 	if (comm == AAC_COMM_MESSAGE) {
 		/*
@@ -97,8 +96,6 @@ static int aac_rkt_ioremap(struct aac_de
 
 int aac_rkt_init(struct aac_dev *dev)
 {
-	extern int _aac_rx_init(struct aac_dev *dev);
-
 	/*
 	 *	Fill in the function dispatch table.
 	 */
diff -puN drivers/scsi/aacraid/rx.c~drivers-scsi-aacraid-cleanups drivers/scsi/aacraid/rx.c
--- a/drivers/scsi/aacraid/rx.c~drivers-scsi-aacraid-cleanups
+++ a/drivers/scsi/aacraid/rx.c
@@ -294,7 +294,7 @@ static void aac_rx_notify_adapter(struct
  *	Start up processing on an i960 based AAC adapter
  */
 
-void aac_rx_start_adapter(struct aac_dev *dev)
+static void aac_rx_start_adapter(struct aac_dev *dev)
 {
 	struct aac_init *init;
 
_

Patches currently in -mm which might be from bunk@stusta.de are

v9fs_vfs_mkdir-fix-a-double-free.patch
git-acpi.patch
ifdef-acpi_future_usage-acpi_os_readable.patch
git-alsa.patch
cpu_freq_table-shouldnt-be-a-def_tristate.patch
git-powerpc.patch
drivers-char-drm-drm_mmc-remove-unused-exports.patch
git-dvb.patch
drivers-media-dvb-frontends-make-4-functions-static.patch
cx88-videoc-remove-struct-radionorms.patch
if-0-v4l_printk_ioctl_arg.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-libata-all.patch
mips-remove-smp_tune_scheduling.patch
mtd_ck804xrom-must-depend-on-pci.patch
git-ubi.patch
git-netdev-all.patch
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
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
git-unionfs.patch
usb_rtl8150-must-select-mii.patch
git-ipwireless_cs.patch
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
debug-shared-irqs-kconfig-fix.patch
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
remove-broken-video-drivers-v4.patch
remove-bogus-con_is_present-prototypes.patch
proper-prototype-for-tosh_smm.patch
remove-the-broken-fb_s3trio-driver.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
make-gfs2_writepages-static.patch
fs-proc-make-code-static.patch
make-kernel-time-timer_statscnr_entries-static.patch
