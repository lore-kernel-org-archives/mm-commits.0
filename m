From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-respect-foll_force-foll_cow-for-thp-checkpatch-fixes.patch removed from
 -mm tree
Date: Tue, 24 Jan 2017 15:12:50 -0800
Message-ID: <5887df72.1xl2pCN67xtCP9ec%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41166 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750943AbdAXXMv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2017 18:12:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, keno@juliacomputing.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-respect-foll_force-foll_cow-for-thp-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-respect-foll_force-foll_cow-for-thp-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-respect-foll_force-foll_cow-for-thp.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-respect-foll_force-foll_cow-for-thp-checkpatch-fixes

WARNING: please, no spaces at the start of a line
#101: FILE: mm/huge_memory.c:1143:
+       return pmd_write(pmd) ||$

ERROR: code indent should use tabs where possible
#102: FILE: mm/huge_memory.c:1144:
+               ((flags & FOLL_FORCE) && (flags & FOLL_COW) && pmd_dirty(pmd));$

WARNING: please, no spaces at the start of a line
#102: FILE: mm/huge_memory.c:1144:
+               ((flags & FOLL_FORCE) && (flags & FOLL_COW) && pmd_dirty(pmd));$

total: 1 errors, 2 warnings, 36 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/mm-respect-foll_force-foll_cow-for-thp.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Keno Fischer <keno@juliacomputing.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-respect-foll_force-foll_cow-for-thp-checkpatch-fixes mm/huge_memory.c
--- a/mm/huge_memory.c~mm-respect-foll_force-foll_cow-for-thp-checkpatch-fixes
+++ a/mm/huge_memory.c
@@ -1140,8 +1140,8 @@ out_unlock:
  */
 static inline bool can_follow_write_pmd(pmd_t pmd, unsigned int flags)
 {
-       return pmd_write(pmd) ||
-               ((flags & FOLL_FORCE) && (flags & FOLL_COW) && pmd_dirty(pmd));
+	return pmd_write(pmd) ||
+	       ((flags & FOLL_FORCE) && (flags & FOLL_COW) && pmd_dirty(pmd));
 }
 
 struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-respect-foll_force-foll_cow-for-thp.patch
kernel-watchdog-prevent-false-hardlockup-on-overloaded-system-fix.patch
proc-add-a-schedule-point-in-proc_pid_readdir-fix.patch
mm-page_alloc-fix-premature-oom-when-racing-with-cpuset-mems-update-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
dax-enable-iostat-for-read-write-fix.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix-fix.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes.patch
mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix.patch
mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix.patch
mm-track-active-portions-of-a-section-at-boot-fix.patch
mm-memory_hotplugc-unexport-__remove_pages.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
linux-next-rejects.patch
reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

