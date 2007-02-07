From: akpm@linux-foundation.org
Subject: - drivers-media-dvb-frontends-make-4-functions-static.patch removed from -mm tree
Date: Wed, 07 Feb 2007 11:51:22 -0800
Message-ID: <200702071951.l17JpMq3025149@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33813 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161121AbXBGTym (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 14:54:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media/dvb/frontends/: make 4 functions static
has been removed from the -mm tree.  Its filename was
     drivers-media-dvb-frontends-make-4-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/media/dvb/frontends/: make 4 functions static
From: Adrian Bunk <bunk@stusta.de>

This patch makes four needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/frontends/stv0299.c  |    2 +-
 drivers/media/dvb/frontends/tda10021.c |    2 +-
 drivers/media/dvb/frontends/tda1004x.c |    2 +-
 drivers/media/dvb/frontends/zl10353.c  |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/media/dvb/frontends/stv0299.c~drivers-media-dvb-frontends-make-4-functions-static drivers/media/dvb/frontends/stv0299.c
--- a/drivers/media/dvb/frontends/stv0299.c~drivers-media-dvb-frontends-make-4-functions-static
+++ a/drivers/media/dvb/frontends/stv0299.c
@@ -92,7 +92,7 @@ static int stv0299_writeregI (struct stv
 	return (ret != 1) ? -EREMOTEIO : 0;
 }
 
-int stv0299_write(struct dvb_frontend* fe, u8 *buf, int len)
+static int stv0299_write(struct dvb_frontend* fe, u8 *buf, int len)
 {
 	struct stv0299_state* state = fe->demodulator_priv;
 
diff -puN drivers/media/dvb/frontends/tda10021.c~drivers-media-dvb-frontends-make-4-functions-static drivers/media/dvb/frontends/tda10021.c
--- a/drivers/media/dvb/frontends/tda10021.c~drivers-media-dvb-frontends-make-4-functions-static
+++ a/drivers/media/dvb/frontends/tda10021.c
@@ -201,7 +201,7 @@ static int tda10021_set_symbolrate (stru
 	return 0;
 }
 
-int tda10021_write(struct dvb_frontend* fe, u8 *buf, int len)
+static int tda10021_write(struct dvb_frontend* fe, u8 *buf, int len)
 {
 	struct tda10021_state* state = fe->demodulator_priv;
 
diff -puN drivers/media/dvb/frontends/tda1004x.c~drivers-media-dvb-frontends-make-4-functions-static drivers/media/dvb/frontends/tda1004x.c
--- a/drivers/media/dvb/frontends/tda1004x.c~drivers-media-dvb-frontends-make-4-functions-static
+++ a/drivers/media/dvb/frontends/tda1004x.c
@@ -579,7 +579,7 @@ static int tda1004x_decode_fec(int tdafe
 	return -1;
 }
 
-int tda1004x_write(struct dvb_frontend* fe, u8 *buf, int len)
+static int tda1004x_write(struct dvb_frontend* fe, u8 *buf, int len)
 {
 	struct tda1004x_state* state = fe->demodulator_priv;
 
diff -puN drivers/media/dvb/frontends/zl10353.c~drivers-media-dvb-frontends-make-4-functions-static drivers/media/dvb/frontends/zl10353.c
--- a/drivers/media/dvb/frontends/zl10353.c~drivers-media-dvb-frontends-make-4-functions-static
+++ a/drivers/media/dvb/frontends/zl10353.c
@@ -54,7 +54,7 @@ static int zl10353_single_write(struct d
 	return 0;
 }
 
-int zl10353_write(struct dvb_frontend *fe, u8 *ibuf, int ilen)
+static int zl10353_write(struct dvb_frontend *fe, u8 *ibuf, int ilen)
 {
 	int err, i;
 	for (i = 0; i < ilen - 1; i++)
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
v9fs_vfs_mkdir-fix-a-double-free.patch
git-acpi.patch
ifdef-acpi_future_usage-acpi_os_readable.patch
git-alsa.patch
cpu_freq_table-shouldnt-be-a-def_tristate.patch
git-powerpc.patch
drivers-char-drm-drm_mmc-remove-unused-exports.patch
git-dvb.patch
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
add-debugging-feature-proc-timer_stat-cleanup.patch
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
sysctl-reimplement-the-sysctl-proc-support-fix-3.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
