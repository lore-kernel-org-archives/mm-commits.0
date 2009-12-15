From: akpm@linux-foundation.org
Subject: [folded] errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch removed from -mm tree
Date: Mon, 14 Dec 2009 17:09:05 -0800
Message-ID: <200912150109.nBF195Oo016546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758143AbZLOBJJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 20:09:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ext-phil.2.carmody@nokia.com, mm-commits@vger.kernel.org


The patch titled
     errh-add-helper-function-to-simplify-pointer-error-checking-fix
has been removed from the -mm tree.  Its filename was
     errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch

This patch was dropped because it was folded into errh-add-helper-function-to-simplify-pointer-error-checking.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: errh-add-helper-function-to-simplify-pointer-error-checking-fix
From: Andrew Morton <akpm@linux-foundation.org>

/usr/src/devel/arch/x86/Makefile:82: stack protector enabled but no compiler support
/usr/src/devel/arch/x86/Makefile:82: stack protector enabled but no compiler support
In file included from crypto/api.c:18:
include/linux/err.h: In function 'IS_ERR_OR_NULL':
include/linux/err.h:39: error: 'NULL' undeclared (first use in this function)
include/linux/err.h:39: error: (Each undeclared identifier is reported only once
include/linux/err.h:39: error: for each function it appears in.)

Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/err.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/err.h~errh-add-helper-function-to-simplify-pointer-error-checking-fix include/linux/err.h
--- a/include/linux/err.h~errh-add-helper-function-to-simplify-pointer-error-checking-fix
+++ a/include/linux/err.h
@@ -36,7 +36,7 @@ static inline long IS_ERR(const void *pt
 
 static inline long IS_ERR_OR_NULL(const void *ptr)
 {
-	return (ptr == NULL) || IS_ERR_VALUE((unsigned long)ptr);
+	return !ptr || IS_ERR_VALUE((unsigned long)ptr);
 }
 
 /**
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
errh-add-helper-function-to-simplify-pointer-error-checking.patch
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

