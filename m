From: akpm@linux-foundation.org
Subject: - add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix.patch removed from -mm tree
Date: Sat, 10 Feb 2007 00:15:39 -0800
Message-ID: <200702100815.l1A8Fenc007049@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39486 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbXBJISz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 03:18:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     make proc_dointvec_taint() static
has been removed from the -mm tree.  Its filename was
     add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix.patch

This patch was dropped because it was folded into add-taint_user-and-ability-to-set-taint-flags-from-userspace.patch

------------------------------------------------------
Subject: make proc_dointvec_taint() static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |    2 --
 kernel/sysctl.c        |    7 +++++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN include/linux/sysctl.h~add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix include/linux/sysctl.h
--- a/include/linux/sysctl.h~add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix
+++ a/include/linux/sysctl.h
@@ -930,8 +930,6 @@ extern int proc_dointvec(ctl_table *, in
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

origin.patch
remove-include-linux-byteorder-pdp_endianh.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
drivers-char-vc_screenc-proper-prototypes.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace.patch
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
