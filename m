From: akpm@osdl.org
Subject: + add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix.patch added to -mm tree
Date: Mon, 08 Jan 2007 13:37:13 -0800
Message-ID: <200701082137.l08LbDeG019683@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45595 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964785AbXAHVk3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 16:40:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, tytso@mit.edu


The patch titled
     make proc_dointvec_taint() static
has been added to the -mm tree.  Its filename is
     add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make proc_dointvec_taint() static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/sysctl.h |    2 --
 kernel/sysctl.c        |    7 +++++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN include/linux/sysctl.h~add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix include/linux/sysctl.h
--- a/include/linux/sysctl.h~add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix
+++ a/include/linux/sysctl.h
@@ -929,8 +929,6 @@ extern int proc_dointvec(ctl_table *, in
 			 void __user *, size_t *, loff_t *);
 extern int proc_dointvec_bset(ctl_table *, int, struct file *,
 			      void __user *, size_t *, loff_t *);
-extern int proc_dointvec_taint(ctl_table *, int, struct file *,
-			       void __user *, size_t *, loff_t *);
 extern int proc_dointvec_minmax(ctl_table *, int, struct file *,
 				void __user *, size_t *, loff_t *);
 extern int proc_dointvec_jiffies(ctl_table *, int, struct file *,
diff -puN kernel/sysctl.c~add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix kernel/sysctl.c
--- a/kernel/sysctl.c~add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix
+++ a/kernel/sysctl.c
@@ -174,6 +174,9 @@ extern ctl_table inotify_table[];
 int sysctl_legacy_va_layout;
 #endif
 
+static int proc_dointvec_taint(ctl_table *table, int write, struct file *filp,
+			       void __user *buffer, size_t *lenp, loff_t *ppos);
+
 static void *get_uts(ctl_table *table, int write)
 {
 	char *which = table->data;
@@ -1975,8 +1978,8 @@ int proc_dointvec_bset(ctl_table *table,
 /*
  *	Taint values can only be increased
  */
-int proc_dointvec_taint(ctl_table *table, int write, struct file *filp,
-			void __user *buffer, size_t *lenp, loff_t *ppos)
+static int proc_dointvec_taint(ctl_table *table, int write, struct file *filp,
+			       void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int op;
 
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
git-alsa.patch
git-dvb.patch
make-usbvision_rvfree-static.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-mtd.patch
drivers-mtd-ubi-vtblc-make-2-functions-static.patch
git-netdev-all.patch
net-irda-proper-prototypes.patch
net-uninline-skb_put-fix.patch
git-ocfs2.patch
git-scsi-rc-fixes.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
arch-i386-kernel-e820c-should-include-asm-setuph.patch
arch-i386-kernel-cpu-mcheck-mcec-should-include-asm-mceh.patch
lumpy-reclaim-cleanup.patch
remove-include-linux-byteorder-pdp_endianh.patch
toshiba-tc86c001-ide-driver-take-2-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
drivers-char-vc_screenc-proper-prototypes.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix.patch
schedule-obsolete-oss-drivers-for-removal-3rd-round.patch
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
