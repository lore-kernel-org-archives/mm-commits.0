From: akpm@linux-foundation.org
Subject: [folded] kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 14 Dec 2009 17:08:25 -0800
Message-ID: <200912150108.nBF18PMY014875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758417AbZLOBI4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 20:08:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, h-shimamoto@ct.jp.nec.com, joe@perches.com, mingo@elte.hu, nooiwa@miraclelinux.com, mm-commits@vger.kernel.org


The patch titled
     kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch

This patch was dropped because it was folded into kernelh-add-printk_ratelimited-and-pr_level_rl.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#42: FILE: include/linux/kernel.h:427:
+        printk_ratelimited(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)$

ERROR: code indent should use tabs where possible
#44: FILE: include/linux/kernel.h:429:
+        printk_ratelimited(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)$

ERROR: code indent should use tabs where possible
#46: FILE: include/linux/kernel.h:431:
+        printk_ratelimited(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)$

ERROR: code indent should use tabs where possible
#48: FILE: include/linux/kernel.h:433:
+        printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)$

ERROR: code indent should use tabs where possible
#50: FILE: include/linux/kernel.h:435:
+        printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)$

ERROR: code indent should use tabs where possible
#52: FILE: include/linux/kernel.h:437:
+        printk_ratelimited(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)$

ERROR: code indent should use tabs where possible
#54: FILE: include/linux/kernel.h:439:
+        printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)$

total: 7 errors, 0 warnings, 50 lines checked

./patches/kernelh-add-printk_ratelimited-and-pr_level_rl.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Joe Perches <joe@perches.com>
Cc: Naohiro Ooiwa <nooiwa@miraclelinux.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN include/linux/kernel.h~kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes
+++ a/include/linux/kernel.h
@@ -424,19 +424,19 @@ static inline char *pack_hex_byte(char *
 #endif
 
 #define pr_emerg_rl(fmt, ...) \
-        printk_ratelimited(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+	printk_ratelimited(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_alert_rl(fmt, ...) \
-        printk_ratelimited(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+	printk_ratelimited(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_crit_rl(fmt, ...) \
-        printk_ratelimited(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+	printk_ratelimited(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_err_rl(fmt, ...) \
-        printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+	printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_warning_rl(fmt, ...) \
-        printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+	printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_notice_rl(fmt, ...) \
-        printk_ratelimited(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+	printk_ratelimited(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_info_rl(fmt, ...) \
-        printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+	printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 /* no pr_cont_rl, don't do that... */
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(DEBUG)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-memory_hotplug-make-offline_pages-static.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore.patch
mm-hugetlb-add-hugepage-support-to-pagemap.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments.patch
rwsem-fix-rwsem_is_locked-bugs.patch
kernelh-add-printk_ratelimited-and-pr_level_rl.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
cs5535-add-a-generic-mfgpt-driver-fix.patch
cs5535-add-a-generic-clock-event-mfgpt-driver-fix.patch
drivers-scsi-sym53c8xx_2-sym_gluec-rename-skip_spaces-to-sym_skip_spaces.patch
lib-introduce-strim-checkpatch-fixes.patch
blackfin-sd-host-controller-driver-fix.patch
blackfin-sd-host-controller-driver-fix-fix.patch
blackfin-sd-host-controller-driver-fix-fix-fix.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
lis3-update-documentation-to-match-latest-changes-fix.patch

