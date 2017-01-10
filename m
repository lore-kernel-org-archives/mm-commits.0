From: akpm@linux-foundation.org
Subject: + mm-respect-foll_force-foll_cow-for-thp-checkpatch-fixes.patch
 added to -mm tree
Date: Mon, 09 Jan 2017 16:16:40 -0800
Message-ID: <587427e8.nLH24cgljcUX6H+x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48022 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755842AbdAJAPN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2017 19:15:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, keno@juliacomputing.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-respect-foll_force-foll_cow-for-thp-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-respect-foll_force-foll_cow-for-thp-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-respect-foll_force-foll_cow-for-thp-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-respect-foll_force-foll_cow-for-thp-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-respect-foll_force-foll_cow-for-thp-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
kernel-watchdog-prevent-false-hardlockup-on-overloaded-system-fix.patch
mm.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
linux-next-rejects.patch
reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

