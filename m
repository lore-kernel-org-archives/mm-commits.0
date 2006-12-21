From: akpm@osdl.org
Subject: + drivers-char-vc_screenc-proper-prototypes.patch added to -mm tree
Date: Wed, 20 Dec 2006 16:53:43 -0800
Message-ID: <200612210053.kBL0rhrC011671@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54612 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161099AbWLUA45 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 19:56:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de


The patch titled
     drivers/char/vc_screen.c: proper prototypes
has been added to the -mm tree.  Its filename is
     drivers-char-vc_screenc-proper-prototypes.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/char/vc_screen.c: proper prototypes
From: Adrian Bunk <bunk@stusta.de>

Add proper prototypes for two functions in drivers/char/vc_screen.c

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/vt.c       |    3 ---
 include/linux/console.h |    4 ++++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/char/vt.c~drivers-char-vc_screenc-proper-prototypes drivers/char/vt.c
--- a/drivers/char/vt.c~drivers-char-vc_screenc-proper-prototypes
+++ a/drivers/char/vt.c
@@ -136,9 +136,6 @@ const struct consw *conswitchp;
 #define DEFAULT_BELL_PITCH	750
 #define DEFAULT_BELL_DURATION	(HZ/8)
 
-extern void vcs_make_sysfs(struct tty_struct *tty);
-extern void vcs_remove_sysfs(struct tty_struct *tty);
-
 struct vc vc_cons [MAX_NR_CONSOLES];
 
 #ifndef VT_SINGLE_DRIVER
diff -puN include/linux/console.h~drivers-char-vc_screenc-proper-prototypes include/linux/console.h
--- a/include/linux/console.h~drivers-char-vc_screenc-proper-prototypes
+++ a/include/linux/console.h
@@ -21,6 +21,7 @@ struct vc_data;
 struct console_font_op;
 struct console_font;
 struct module;
+struct tty_struct;
 
 /*
  * this is what the terminal answers to a ESC-Z or csi0c query.
@@ -132,6 +133,9 @@ static inline void resume_console(void) 
 int mda_console_init(void);
 void prom_con_init(void);
 
+void vcs_make_sysfs(struct tty_struct *tty);
+void vcs_remove_sysfs(struct tty_struct *tty);
+
 /* Some debug stub to catch some of the obvious races in the VT code */
 #if 1
 #define WARN_CONSOLE_UNLOCKED()	WARN_ON(!is_console_locked() && !oops_in_progress)
_

Patches currently in -mm which might be from bunk@stusta.de are

make-kernel-printkcignore_loglevel_setup-static.patch
fs-sysv-proper-prototypes-for-2-functions.patch
git-acpi.patch
git-alsa.patch
usbvision-possible-cleanups.patch
drivers-media-video-cafe_ccicc-fix-null-dereference.patch
git-gfs2-nmw.patch
git-mtd.patch
remove-the-broken-skmc-driver.patch
git-net.patch
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

