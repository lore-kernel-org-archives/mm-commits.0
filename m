From: akpm@linux-foundation.org
Subject: [folded] mm-hugetlb-add-hugepage-support-to-pagemap-build-fix.patch removed from -mm tree
Date: Mon, 14 Dec 2009 17:05:34 -0800
Message-ID: <200912150105.nBF15YAw007497@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758262AbZLOBFw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 20:05:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, apw@canonical.com, fengguang.wu@intel.com, hugh.dickins@tiscali.co.uk, lee.schermerhorn@hp.com, mel@csn.ul.ie, n-horiguchi@ah.jp.nec.com


The patch titled
     mm-hugetlb-add-hugepage-support-to-pagemap-build-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-hugepage-support-to-pagemap-build-fix.patch

This patch was dropped because it was folded into mm-hugetlb-add-hugepage-support-to-pagemap.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-hugetlb-add-hugepage-support-to-pagemap-build-fix
From: Andrew Morton <akpm@linux-foundation.org>

mm/pagewalk.c: In function 'walk_page_range':
mm/pagewalk.c:134: error: implicit declaration of function 'huge_pte_offset'
mm/pagewalk.c:135: warning: assignment makes pointer from integer without a cast
mm/pagewalk.c:136: error: implicit declaration of function 'huge_pte_none'
mm/pagewalk.c:136: error: implicit declaration of function 'huge_ptep_get'

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

 mm/pagewalk.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/pagewalk.c~mm-hugetlb-add-hugepage-support-to-pagemap-build-fix mm/pagewalk.c
--- a/mm/pagewalk.c~mm-hugetlb-add-hugepage-support-to-pagemap-build-fix
+++ a/mm/pagewalk.c
@@ -106,11 +106,9 @@ int walk_page_range(unsigned long addr, 
 		    struct mm_walk *walk)
 {
 	pgd_t *pgd;
-	pte_t *pte;
 	unsigned long next;
 	int err = 0;
 	struct vm_area_struct *vma;
-	struct hstate *hs;
 
 	if (addr >= end)
 		return err;
@@ -128,7 +126,11 @@ int walk_page_range(unsigned long addr, 
 		 * we can't handled it in the same manner as non-huge pages.
 		 */
 		vma = find_vma(walk->mm, addr);
+#ifdef CONFIG_HUGETLB_PAGE
 		if (vma && is_vm_hugetlb_page(vma)) {
+			pte_t *pte;
+			struct hstate *hs;
+
 			if (vma->vm_end < next)
 				next = vma->vm_end;
 			hs = hstate_vma(vma);
@@ -142,7 +144,7 @@ int walk_page_range(unsigned long addr, 
 				break;
 			continue;
 		}
-
+#endif
 		if (pgd_none_or_clear_bad(pgd)) {
 			if (walk->pte_hole)
 				err = walk->pte_hole(addr, next, walk);
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

