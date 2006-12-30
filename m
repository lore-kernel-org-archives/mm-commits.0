From: akpm@osdl.org
Subject: - dvb-fix-compile-error.patch removed from -mm tree
Date: Fri, 29 Dec 2006 16:22:53 -0800
Message-ID: <200612300022.kBU0Msa0007690@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36007 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755106AbWL3A0T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Dec 2006 19:26:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     DVB: fix compile error
has been removed from the -mm tree.  Its filename was
     dvb-fix-compile-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: DVB: fix compile error
From: Adrian Bunk <bunk@stusta.de>

  LD      drivers/media/video/built-in.o
drivers/media/video/saa7134/built-in.o:(.data+0x85ec): multiple definition of `ir_rc5_remote_gap'
drivers/media/video/bt8xx/built-in.o:(.data+0x734c): first defined here
drivers/media/video/saa7134/built-in.o:(.data+0x85f0): multiple definition of `ir_rc5_key_timeout'
drivers/media/video/bt8xx/built-in.o:(.data+0x7350): first defined here
make[4]: *** [drivers/media/video/built-in.o] Error 1

Since these variables were needlessly global, this patch implements the
trivial fix of making them static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/media/video/bt8xx/bttv-input.c      |    4 ++--
 drivers/media/video/saa7134/saa7134-input.c |    4 ++--
 include/media/ir-common.h                   |    3 ---
 3 files changed, 4 insertions(+), 7 deletions(-)

diff -puN drivers/media/video/bt8xx/bttv-input.c~dvb-fix-compile-error drivers/media/video/bt8xx/bttv-input.c
--- a/drivers/media/video/bt8xx/bttv-input.c~dvb-fix-compile-error
+++ a/drivers/media/video/bt8xx/bttv-input.c
@@ -36,9 +36,9 @@ module_param(repeat_delay, int, 0644);
 static int repeat_period = 33;
 module_param(repeat_period, int, 0644);
 
-int ir_rc5_remote_gap = 885;
+static int ir_rc5_remote_gap = 885;
 module_param(ir_rc5_remote_gap, int, 0644);
-int ir_rc5_key_timeout = 200;
+static int ir_rc5_key_timeout = 200;
 module_param(ir_rc5_key_timeout, int, 0644);
 
 #define DEVNAME "bttv-input"
diff -puN drivers/media/video/saa7134/saa7134-input.c~dvb-fix-compile-error drivers/media/video/saa7134/saa7134-input.c
--- a/drivers/media/video/saa7134/saa7134-input.c~dvb-fix-compile-error
+++ a/drivers/media/video/saa7134/saa7134-input.c
@@ -41,9 +41,9 @@ static int pinnacle_remote = 0;
 module_param(pinnacle_remote, int, 0644);    /* Choose Pinnacle PCTV remote */
 MODULE_PARM_DESC(pinnacle_remote, "Specify Pinnacle PCTV remote: 0=coloured, 1=grey (defaults to 0)");
 
-int ir_rc5_remote_gap = 885;
+static int ir_rc5_remote_gap = 885;
 module_param(ir_rc5_remote_gap, int, 0644);
-int ir_rc5_key_timeout = 115;
+static int ir_rc5_key_timeout = 115;
 module_param(ir_rc5_key_timeout, int, 0644);
 
 #define dprintk(fmt, arg...)	if (ir_debug) \
diff -puN include/media/ir-common.h~dvb-fix-compile-error include/media/ir-common.h
--- a/include/media/ir-common.h~dvb-fix-compile-error
+++ a/include/media/ir-common.h
@@ -36,9 +36,6 @@
 #define IR_KEYCODE(tab,code)	(((unsigned)code < IR_KEYTAB_SIZE) \
 				 ? tab[code] : KEY_RESERVED)
 
-extern int ir_rc5_remote_gap;
-extern int ir_rc5_key_timeout;
-
 #define RC5_START(x)	(((x)>>12)&3)
 #define RC5_TOGGLE(x)	(((x)>>11)&1)
 #define RC5_ADDR(x)	(((x)>>6)&31)
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-alsa.patch
git-dvb.patch
git-gfs2-nmw.patch
git-mtd.patch
git-netdev-all.patch
net-irda-proper-prototypes.patch
net-uninline-skb_put-fix.patch
git-ocfs2.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
make-qla2x00_reg_remote_port-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
arch-i386-kernel-e820c-should-include-asm-setuph.patch
arch-i386-kernel-cpu-mcheck-mcec-should-include-asm-mceh.patch
lumpy-reclaim-cleanup.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
remove-include-linux-byteorder-pdp_endianh.patch
toshiba-tc86c001-ide-driver-take-2-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
drivers-char-vc_screenc-proper-prototypes.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i386-drivers.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
drivers-isdn-hisax-proper-prototypes.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
fbdev-driver-for-s3-trio-virge-cleanups.patch
remove-broken-video-drivers-v4.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

