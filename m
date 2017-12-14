From: akpm@linux-foundation.org
Subject: +
 mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
 added to -mm tree
Date: Thu, 14 Dec 2017 12:14:00 -0800
Message-ID: <5a32db88.f0kG4SSTj1DFlh6M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43828 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752045AbdLNUOB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Dec 2017 15:14:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, yang.s@alibaba-inc.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix
has been added to the -mm tree.  Its filename is
     mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch

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
Subject: mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix

tweak comment

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Yang Shi <yang.s@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/khugepaged.c~mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix mm/khugepaged.c
--- a/mm/khugepaged.c~mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix
+++ a/mm/khugepaged.c
@@ -1674,8 +1674,8 @@ static unsigned int khugepaged_scan_mm_s
 
 	mm = mm_slot->mm;
 	/*
- 	 * Not wait for semaphore to avoid long time waiting, just move
- 	 * to the next mm on the list.
+ 	 * Don't wait for semaphore (to avoid long wait times).  Just move to
+	 * the next mm on the list.
  	 */
 	if (unlikely(!down_read_trylock(&mm->mmap_sem)))
 		goto breakouterloop_mmap_sem;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-kmemleakc-make-cond_resched-rate-limiting-more-efficient.patch
stringh-work-around-for-increased-stack-usage-fix.patch
mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch
x86-mm-provide-pmdp_establish-helper-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

