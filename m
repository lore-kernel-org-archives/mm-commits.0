From: akpm@linux-foundation.org
Subject: [folded] dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch removed from -mm tree
Date: Mon, 14 Dec 2009 16:55:56 -0800
Message-ID: <200912150055.nBF0tvtE014986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757449AbZLOA47 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 19:56:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, avi@qumranet.com, broonie@opensource.wolfsonmicro.com, fengguang.wu@intel.com, gregkh@suse.de, johannes@sipsolutions.net, mtosatti@redhat


The patch titled
     dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix
has been removed from the -mm tree.  Its filename was
     dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch

This patch was dropped because it was folded into dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix
From: Andrew Morton <akpm@linux-foundation.org>

cleanuplets.

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Avi Kivity <avi@qumranet.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/char/mem.c~dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix drivers/char/mem.c
--- a/drivers/char/mem.c~dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix
+++ a/drivers/char/mem.c
@@ -130,7 +130,6 @@ static ssize_t read_mem(struct file * fi
 			size_t count, loff_t *ppos)
 {
 	unsigned long p = *ppos;
-	unsigned long ret;
 	ssize_t read, sz;
 	char *ptr;
 
@@ -155,6 +154,9 @@ static ssize_t read_mem(struct file * fi
 #endif
 
 	while (count > 0) {
+		unsigned long remaining;
+		int ret;
+
 		sz = size_inside_page(p, count);
 
 		if (!range_is_allowed(p >> PAGE_SHIFT, count))
@@ -169,9 +171,9 @@ static ssize_t read_mem(struct file * fi
 		if (!ptr)
 			return -EFAULT;
 
-		ret = copy_to_user(buf, ptr, sz);
+		remaining = copy_to_user(buf, ptr, sz);
 		unxlate_dev_mem_ptr(p, ptr);
-		if (ret)
+		if (remaining)
 			return -EFAULT;
 
 		buf += sz;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
mm-memory_hotplug-make-offline_pages-static.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore-cleanup.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore-build-fix.patch
mm-hugetlb-add-hugepage-support-to-pagemap-build-fix.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-cleanup.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
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

