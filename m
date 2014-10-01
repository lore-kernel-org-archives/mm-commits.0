From: akpm@linux-foundation.org
Subject: +
 mm-softdirty-unmapped-addresses-between-vmas-are-clean-v2-fix.patch added
 to -mm tree
Date: Wed, 01 Oct 2014 15:49:25 -0700
Message-ID: <542c84f5.GNFwynQEIs6U3uB4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaJAWtZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 18:49:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, gorcunov@openvz.org, hughd@google.com, jamieliu@google.com, kirill@shutemov.name, pfeiner@google.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pagemap: prevent pagemap_pte_range() from overrunning
has been added to the -mm tree.  Its filename is
     mm-softdirty-unmapped-addresses-between-vmas-are-clean-v2-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-softdirty-unmapped-addresses-between-vmas-are-clean-v2-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-softdirty-unmapped-addresses-between-vmas-are-clean-v2-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: pagemap: prevent pagemap_pte_range() from overrunning

When the vm_end address of the last vma just before vma(VM_HUGETLB) is not
aligned to PMD boundary, the while loop in pagemap_pte_range() gets
vma(VM_HUGETLB) and triggers BUG_ON(is_vm_hugetlb_page(vma)).  This patch
fixes it by checking the overrun.

Fixes: 62c98294410d ("mm: softdirty: unmapped addresses between VMAs are clean")
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Peter Feiner <pfeiner@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Jamie Liu <jamieliu@google.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~mm-softdirty-unmapped-addresses-between-vmas-are-clean-v2-fix fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-softdirty-unmapped-addresses-between-vmas-are-clean-v2-fix
+++ a/fs/proc/task_mmu.c
@@ -1074,7 +1074,7 @@ static int pagemap_pte_range(pmd_t *pmd,
 				return err;
 		}
 
-		if (!vma)
+		if (!vma || vma->vm_start >= end)
 			break;
 		/*
 		 * We can't possibly be in a hugetlb VMA. In general,
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

memory-hotplug-add-sysfs-zones_online_to-attribute.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-4.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range-fix.patch
mm-compaction-reduce-zone-checking-frequency-in-the-migration-scanner.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
mm-compaction-periodically-drop-lock-and-restore-irqs-in-scanners.patch
mm-compaction-skip-rechecks-when-lock-was-already-held.patch
mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch
mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
mm-rename-allocflags_to_migratetype-for-clarity.patch
mm-compaction-pass-gfp-mask-to-compact_control.patch
mempolicy-change-alloc_pages_vma-to-use-mpol_cond_put.patch
mempolicy-change-get_task_policy-to-return-default_policy-rather-than-null.patch
mempolicy-sanitize-the-usage-of-get_task_policy.patch
mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it.patch
mempolicy-introduce-__get_vma_policy-export-get_task_policy.patch
mempolicy-fix-show_numa_map-vs-exec-do_set_mempolicy-race.patch
mempolicy-kill-do_set_mempolicy-down_writemm-mmap_sem.patch
mempolicy-unexport-get_vma_policy-and-remove-its-task-arg.patch
introduce-dump_vma.patch
introduce-dump_vma-fix.patch
introduce-vm_bug_on_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch
mm-softdirty-unmapped-addresses-between-vmas-are-clean.patch
mm-softdirty-unmapped-addresses-between-vmas-are-clean-v2.patch
mm-softdirty-unmapped-addresses-between-vmas-are-clean-v2-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared.patch
mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared-fix.patch

