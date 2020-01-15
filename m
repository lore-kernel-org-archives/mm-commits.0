From: akpm@linux-foundation.org
Subject: +
 =?US-ASCII?Q?mm-mempolicy-skip-walking-hugetlb-vma-if-mpol=5Fmf=5Fstri?=
 =?US-ASCII?Q?ct-is-specified-alone-checkpatch-fixes.patch?= added to -mm
 tree
Date: Tue, 14 Jan 2020 16:34:23 -0800
Message-ID: <20200115003423.WZE9cF_QG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728808AbgAOAeZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Jan 2020 19:34:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, lixinhai.lxh@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mempolicy-skip-walking-hugetlb-vma-if-mpol_mf_strict-is-specified-alone-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-mempolicy-skip-walking-hugetlb-vma-if-mpol_mf_strict-is-specified-alone-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-skip-walking-hugetlb-vma-if-mpol_mf_strict-is-specified-alone-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-skip-walking-hugetlb-vma-if-mpol_mf_strict-is-specified-alone-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mempolicy-skip-walking-hugetlb-vma-if-mpol_mf_strict-is-specified-alone-checkpatch-fixes

WARNING: Block comments should align the * on each line
#33: FILE: mm/mempolicy.c:660:
+	/* MPOL_MF_STRICT is ignored for huge page, skip checking
+	*  misplaced pages

total: 0 errors, 1 warnings, 13 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-mempolicy-skip-walking-hugetlb-vma-if-mpol_mf_strict-is-specified-alone.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Li Xinhai <lixinhai.lxh@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-skip-walking-hugetlb-vma-if-mpol_mf_strict-is-specified-alone-checkpatch-fixes
+++ a/mm/mempolicy.c
@@ -656,9 +656,10 @@ static int queue_pages_test_walk(unsigne
 		return 1;
 	}
 
-	/* MPOL_MF_STRICT is ignored for huge page, skip checking
-	*  misplaced pages
-	*/
+	/*
+	 * MPOL_MF_STRICT is ignored for huge page, skip checking
+	 * misplaced pages
+	 */
 	if ((flags & MPOL_MF_VALID) == MPOL_MF_STRICT &&
 		is_vm_hugetlb_page(vma))
 		return 1;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-vmscan-remove-unused-reclaim_off-reclaim_zone-fix.patch
mm-mempolicy-skip-walking-hugetlb-vma-if-mpol_mf_strict-is-specified-alone-checkpatch-fixes.patch
mm-oom-avoid-printk-iteration-under-rcu-fix.patch
linux-next-rejects.patch
linux-next-fix.patch
linux-next-git-rejects.patch
drivers-block-null_blk_mainc-fix-layout.patch
drivers-block-null_blk_mainc-fix-uninitialized-var-warnings.patch
proc-convert-everything-to-struct-proc_ops-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
