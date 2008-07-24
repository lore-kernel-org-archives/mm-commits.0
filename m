From: akpm@linux-foundation.org
Subject: - remove-include-linux-pm_legacyh.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:25:15 -0700
Message-ID: <200807242325.m6ONPFIG010862@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755576AbYGXXZd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:25:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, pavel@suse.cz, rjw@sisk.pl, rpjday@crashcourse.ca, mm-commits@vger.kernel.org


The patch titled
     remove include/linux/pm_legacy.h
has been removed from the -mm tree.  Its filename was
     remove-include-linux-pm_legacyh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove include/linux/pm_legacy.h
From: Adrian Bunk <bunk@kernel.org>

Remove the obsolete and no longer used include/linux/pm_legacy.h

Reviewed-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Pavel Machek <pavel@suse.cz>
Acked-by: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/pm.c            |    1 
 arch/mips/au1000/common/power.c |    1 
 arch/x86/kernel/apm_32.c        |    1 
 include/linux/pm_legacy.h       |   35 ------------------------------
 4 files changed, 38 deletions(-)

diff -puN arch/frv/kernel/pm.c~remove-include-linux-pm_legacyh arch/frv/kernel/pm.c
--- a/arch/frv/kernel/pm.c~remove-include-linux-pm_legacyh
+++ a/arch/frv/kernel/pm.c
@@ -14,7 +14,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pm.h>
-#include <linux/pm_legacy.h>
 #include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/sysctl.h>
diff -puN arch/mips/au1000/common/power.c~remove-include-linux-pm_legacyh arch/mips/au1000/common/power.c
--- a/arch/mips/au1000/common/power.c~remove-include-linux-pm_legacyh
+++ a/arch/mips/au1000/common/power.c
@@ -31,7 +31,6 @@
 
 #include <linux/init.h>
 #include <linux/pm.h>
-#include <linux/pm_legacy.h>
 #include <linux/sysctl.h>
 #include <linux/jiffies.h>
 
diff -puN arch/x86/kernel/apm_32.c~remove-include-linux-pm_legacyh arch/x86/kernel/apm_32.c
--- a/arch/x86/kernel/apm_32.c~remove-include-linux-pm_legacyh
+++ a/arch/x86/kernel/apm_32.c
@@ -219,7 +219,6 @@
 #include <linux/time.h>
 #include <linux/sched.h>
 #include <linux/pm.h>
-#include <linux/pm_legacy.h>
 #include <linux/capability.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
diff -puN include/linux/pm_legacy.h~remove-include-linux-pm_legacyh /dev/null
--- a/include/linux/pm_legacy.h
+++ /dev/null
@@ -1,35 +0,0 @@
-#ifndef __LINUX_PM_LEGACY_H__
-#define __LINUX_PM_LEGACY_H__
-
-
-#ifdef CONFIG_PM_LEGACY
-
-/*
- * Register a device with power management
- */
-struct pm_dev __deprecated *
-pm_register(pm_dev_t type, unsigned long id, pm_callback callback);
-
-/*
- * Send a request to all devices
- */
-int __deprecated pm_send_all(pm_request_t rqst, void *data);
-
-#else /* CONFIG_PM_LEGACY */
-
-static inline struct pm_dev *pm_register(pm_dev_t type,
-					 unsigned long id,
-					 pm_callback callback)
-{
-	return NULL;
-}
-
-static inline int pm_send_all(pm_request_t rqst, void *data)
-{
-	return 0;
-}
-
-#endif /* CONFIG_PM_LEGACY */
-
-#endif /* __LINUX_PM_LEGACY_H__ */
-
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
init-do_mountsc-should-include-linux-initrdh.patch
build-kernel-profileo-only-when-requested.patch
build-kernel-profileo-only-when-requested-cleanups.patch
asm-generic-int-ll64h-always-provide-__su64.patch
remove-some-more-tipar-bits.patch
include-linux-kernelh-userspace-header-cleanup.patch
minix-remove-no_truncate-code.patch
jbd-unexport-journal_update_superblock.patch
coda-remove-coda_fs_old_api.patch
fat-dirc-switch-to-struct-__fat_dirent.patch
remove-the-in-kernel-struct-dirent64.patch
remove-unused-include-linux-direnths.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
pty-remove-unused-unix98_pty_count-options.patch
proper-extern-for-mwave_s_mdd.patch
if-0-hpet_unregister.patch
unexport-proc_clear_tty.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proper-pidhashmap_init-prototypes.patch
unexport-uts_sem.patch
parport-sharec-proper-externs.patch
tpm_biosc-make-2-structs-static.patch
drm-make-drm_minors_cleanup-static.patch
make-cgroup_seqfile_release-static.patch
make-pnp_add_card_id-static.patch
make-parport_cs_release-static.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
make-macfb_setup-static.patch
video-console-sticonrec-make-code-static.patch
video-console-sticonrec-make-code-static-checkpatch-fixes.patch
video-stifbc-make-2-functions-static.patch
reiser4.patch

