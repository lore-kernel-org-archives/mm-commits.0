From: akpm@linux-foundation.org
Subject: [folded] mm-hugetlb-fix-hugepage-memory-leak-in-mincore-build-fix.patch removed from -mm tree
Date: Mon, 14 Dec 2009 17:04:33 -0800
Message-ID: <200912150104.nBF14Yel004886@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758442AbZLOBFa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 20:05:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, apw@canonical.com, fengguang.wu@intel.com, hugh.dickins@tiscali.co.uk, lee.schermerhorn@hp.com, mel@csn.ul.ie, n-horiguchi@ah.jp.nec.com


The patch titled
     mm-hugetlb-fix-hugepage-memory-leak-in-mincore-build-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-hugepage-memory-leak-in-mincore-build-fix.patch

This patch was dropped because it was folded into mm-hugetlb-fix-hugepage-memory-leak-in-mincore.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-hugetlb-fix-hugepage-memory-leak-in-mincore-build-fix
From: Andrew Morton <akpm@linux-foundation.org>

x86_64 allnoconfig:

mm/mincore.c: In function 'do_mincore':
mm/mincore.c:91: error: implicit declaration of function 'huge_pte_offset'
mm/mincore.c:92: warning: assignment makes pointer from integer without a cast
mm/mincore.c:94: error: implicit declaration of function 'huge_pte_none'
mm/mincore.c:94: error: implicit declaration of function 'huge_ptep_get'

Cc: <stable@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/mincore.c~mm-hugetlb-fix-hugepage-memory-leak-in-mincore-build-fix mm/mincore.c
--- a/mm/mincore.c~mm-hugetlb-fix-hugepage-memory-leak-in-mincore-build-fix
+++ a/mm/mincore.c
@@ -73,6 +73,7 @@ static long do_mincore(unsigned long add
 	if (!vma || addr < vma->vm_start)
 		return -ENOMEM;
 
+#ifdef CONFIG_HUGETLB_PAGE
 	if (is_vm_hugetlb_page(vma)) {
 		struct hstate *h;
 		unsigned long nr_huge;
@@ -106,6 +107,7 @@ static long do_mincore(unsigned long add
 		}
 		return nr;
 	}
+#endif
 
 	/*
 	 * Calculate how many pages there are left in the last level of the
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-memory_hotplug-make-offline_pages-static.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore.patch
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

