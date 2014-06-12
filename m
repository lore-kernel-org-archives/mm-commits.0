From: akpm@linux-foundation.org
Subject: +
 mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control-fix.patch added to -mm tree
Date: Thu, 12 Jun 2014 15:24:19 -0700
Message-ID: <539a2893.n+mw/3XYxWzI2gRr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaFLWYU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jun 2014 18:24:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, akpm@linux-foundation.org

Subject: + mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control-fix.patch added to -mm tree
To: akpm@linux-foundation.org,n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Thu, 12 Jun 2014 15:24:19 -0700


The patch titled
     Subject: mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control-fix
has been added to the -mm tree.  Its filename is
     mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control-fix.patch

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
Subject: mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control-fix

fix build

fs/proc/task_mmu.c: In function 'clear_refs_pmd':
fs/proc/task_mmu.c:806: error: 'struct mm_walk' has no member named 'skip'

Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control-fix fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control-fix
+++ a/fs/proc/task_mmu.c
@@ -803,7 +803,7 @@ static int clear_refs_pmd(pmd_t *pmd, un
 out:
 	spin_unlock(ptl);
 	/* handled as pmd, no need to call clear_refs_pte() */
-	walk->skip = 1;
+	walk->control = PTWALK_DOWN;
 	return 0;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
x86-vdso-remove-one-final-use-of-htole16.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-update-page-table-walker-core-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control-fix.patch
madvise-cleanup-swapin_walk_pmd_entry-fix.patch
memcg-separate-mem_cgroup_move_charge_pte_range-checkpatch-fixes.patch
mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code-checkpatch-fixes.patch
mincore-apply-page-table-walker-on-do_mincore-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-page_ioc-work-around-gcc-bug.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

