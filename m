From: akpm@linux-foundation.org
Subject: + mm-thp-count-thp_fault_fallback-anytime-thp-fault-fails.patch
 added to -mm tree
Date: Thu, 22 Aug 2013 14:01:43 -0700
Message-ID: <52167c37.Qb3KaU+sNpt7gAb0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab3HVVBo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Aug 2013 17:01:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de, kirill.shutemov@linux.intel.com, aarcange@redhat.com, rientjes@google.com

Subject: + mm-thp-count-thp_fault_fallback-anytime-thp-fault-fails.patch added to -mm tree
To: rientjes@google.com,aarcange@redhat.com,kirill.shutemov@linux.intel.com,mgorman@suse.de
From: akpm@linux-foundation.org
Date: Thu, 22 Aug 2013 14:01:43 -0700


The patch titled
     Subject: mm, thp: count thp_fault_fallback anytime thp fault fails
has been added to the -mm tree.  Its filename is
     mm-thp-count-thp_fault_fallback-anytime-thp-fault-fails.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-count-thp_fault_fallback-anytime-thp-fault-fails.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-count-thp_fault_fallback-anytime-thp-fault-fails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, thp: count thp_fault_fallback anytime thp fault fails

Currently, thp_fault_fallback in vmstat only gets incremented if a
hugepage allocation fails.  If current's memcg hits its limit or the page
fault handler returns an error, it is incorrectly accounted as a
successful thp_fault_alloc.

Count thp_fault_fallback anytime the page fault handler falls back to
using regular pages and only count thp_fault_alloc when a hugepage has
actually been faulted.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-count-thp_fault_fallback-anytime-thp-fault-fails mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-count-thp_fault_fallback-anytime-thp-fault-fails
+++ a/mm/huge_memory.c
@@ -820,17 +820,19 @@ int do_huge_pmd_anonymous_page(struct mm
 		count_vm_event(THP_FAULT_FALLBACK);
 		return VM_FAULT_FALLBACK;
 	}
-	count_vm_event(THP_FAULT_ALLOC);
 	if (unlikely(mem_cgroup_newpage_charge(page, mm, GFP_KERNEL))) {
 		put_page(page);
+		count_vm_event(THP_FAULT_FALLBACK);
 		return VM_FAULT_FALLBACK;
 	}
 	if (unlikely(__do_huge_pmd_anonymous_page(mm, vma, haddr, pmd, page))) {
 		mem_cgroup_uncharge_page(page);
 		put_page(page);
+		count_vm_event(THP_FAULT_FALLBACK);
 		return VM_FAULT_FALLBACK;
 	}
 
+	count_vm_event(THP_FAULT_ALLOC);
 	return 0;
 }
 
@@ -1143,7 +1145,6 @@ alloc:
 		new_page = NULL;
 
 	if (unlikely(!new_page)) {
-		count_vm_event(THP_FAULT_FALLBACK);
 		if (is_huge_zero_pmd(orig_pmd)) {
 			ret = do_huge_pmd_wp_zero_page_fallback(mm, vma,
 					address, pmd, orig_pmd, haddr);
@@ -1154,9 +1155,9 @@ alloc:
 				split_huge_page(page);
 			put_page(page);
 		}
+		count_vm_event(THP_FAULT_FALLBACK);
 		goto out;
 	}
-	count_vm_event(THP_FAULT_ALLOC);
 
 	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
 		put_page(new_page);
@@ -1164,10 +1165,13 @@ alloc:
 			split_huge_page(page);
 			put_page(page);
 		}
+		count_vm_event(THP_FAULT_FALLBACK);
 		ret |= VM_FAULT_OOM;
 		goto out;
 	}
 
+	count_vm_event(THP_FAULT_ALLOC);
+
 	if (is_huge_zero_pmd(orig_pmd))
 		clear_huge_page(new_page, haddr, HPAGE_PMD_NR);
 	else
_

Patches currently in -mm which might be from rientjes@google.com are

mm-mempolicy-turn-vma_set_policy-into-vma_dup_policy.patch
mm-madvisec-fix-coding-style-errors.patch
mm-do_mmap_pgoff-cleanup-the-usage-of-file_inode.patch
mm-mmap_region-kill-correct_wcount-inode-use-allow_write_access.patch
mm-page_alloc-fix-comment-get_page_from_freelist.patch
mm-sparse-introduce-alloc_usemap_and_memmap.patch
mm-writeback-make-writeback_inodes_wb-static.patch
mm-vmalloc-use-wrapper-function-get_vm_area_size-to-caculate-size-of-vm-area.patch
linux-next.patch
arch-mm-remove-obsolete-init-oom-protection.patch
arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom.patch
arch-mm-pass-userspace-fault-flag-to-generic-fault-handler.patch
x86-finish-user-fault-error-path-with-fatal-signal.patch
mm-memcg-enable-memcg-oom-killer-only-for-user-faults.patch
mm-memcg-rework-and-document-oom-waiting-and-wakeup.patch
mm-memcg-do-not-trap-chargers-with-full-callstack-on-oom.patch
mm-thp-count-thp_fault_fallback-anytime-thp-fault-fails.patch
fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
list_lru-dynamically-adjust-node-arrays.patch

