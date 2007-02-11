From: akpm@linux-foundation.org
Subject: - drivers-char-vc_screenc-proper-prototypes.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:51:07 -0800
Message-ID: <200702112251.l1BMp7oA015921@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60467 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932852AbXBKWyU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:54:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     drivers/char/vc_screen.c: proper prototypes
has been removed from the -mm tree.  Its filename was
     drivers-char-vc_screenc-proper-prototypes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/char/vc_screen.c: proper prototypes
From: Adrian Bunk <bunk@stusta.de>

Add proper prototypes for two functions in drivers/char/vc_screen.c

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

origin.patch
ifdef-acpi_future_usage-acpi_os_readable.patch
git-cpufreq.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
mips-remove-smp_tune_scheduling.patch
git-mtd.patch
git-ubi.patch
net-uninline-skb_put-fix.patch
drivers-scsi-small-cleanups.patch
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
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
lumpy-reclaim-cleanup.patch
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
