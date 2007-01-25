From: akpm@osdl.org
Subject: + drivers-media-dvb-frontends-make-4-functions-static.patch added to -mm tree
Date: Thu, 25 Jan 2007 15:16:13 -0800
Message-ID: <200701252316.l0PNGD3P001386@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35032 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030244AbXAYXTd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 18:19:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, mchehab@infradead.org


The patch titled
     drivers/media/dvb/frontends/: make 4 functions static
has been added to the -mm tree.  Its filename is
     drivers-media-dvb-frontends-make-4-functions-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/media/dvb/frontends/: make 4 functions static
From: Adrian Bunk <bunk@stusta.de>

This patch makes four needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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
knfsd-replace-some-warning-ins-nfsfhh-with-bug_on-or-warn_on.patch
git-acpi.patch
git-alsa.patch
cpu_freq_table-shouldnt-be-a-def_tristate.patch
drivers-char-drm-drm_mmc-remove-unused-exports.patch
git-dvb.patch
drivers-media-dvb-frontends-make-4-functions-static.patch
git-gfs2-nmw.patch
ia64-add-pci_get_legacy_ide_irq.patch
git-ieee1394.patch
git-libata-all.patch
mips-remove-smp_tune_scheduling.patch
git-mmc.patch
mtd_ck804xrom-must-depend-on-pci.patch
git-ubi.patch
git-netdev-all.patch
remove-one-remaining-define-bcm_tso-1.patch
net-irda-proper-prototypes.patch
net-wanrouter-wanmainc-cleanups.patch
process-include-linux-if_addrlinkh-with-unifdef.patch
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
more-ftape-removal.patch
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
