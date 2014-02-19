From: akpm@linux-foundation.org
Subject: + mmnuma-reorganize-change_pmd_range.patch added to -mm tree
Date: Wed, 19 Feb 2014 11:27:46 -0800
Message-ID: <530505b2.YuKBnGMmrFbzrgno%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60822 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbaBST1r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Feb 2014 14:27:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, peterz@infradead.org, gang.xing@hp.com, chegu_vinod@hp.com, aarcange@redhat.com, riel@redhat.com

Subject: + mmnuma-reorganize-change_pmd_range.patch added to -mm tree
To: riel@redhat.com,aarcange@redhat.com,chegu_vinod@hp.com,gang.xing@hp.com,peterz@infradead.org,rientjes@google.com
From: akpm@linux-foundation.org
Date: Wed, 19 Feb 2014 11:27:46 -0800


The patch titled
     Subject: mm,numa: reorganize change_pmd_range()
has been added to the -mm tree.  Its filename is
     mmnuma-reorganize-change_pmd_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmnuma-reorganize-change_pmd_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmnuma-reorganize-change_pmd_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: mm,numa: reorganize change_pmd_range()

Reorganize the order of ifs in change_pmd_range a little, in preparation
for the next patch.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Xing Gang <gang.xing@hp.com>
Tested-by: Chegu Vinod <chegu_vinod@hp.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/mprotect.c~mmnuma-reorganize-change_pmd_range mm/mprotect.c
--- a/mm/mprotect.c~mmnuma-reorganize-change_pmd_range
+++ a/mm/mprotect.c
@@ -118,6 +118,8 @@ static inline unsigned long change_pmd_r
 		unsigned long this_pages;
 
 		next = pmd_addr_end(addr, end);
+		if (!pmd_trans_huge(*pmd) && pmd_none_or_clear_bad(pmd))
+				continue;
 		if (pmd_trans_huge(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE)
 				split_huge_page_pmd(vma, addr, pmd);
@@ -133,10 +135,9 @@ static inline unsigned long change_pmd_r
 					continue;
 				}
 			}
-			/* fall through */
+			/* fall through, the trans huge pmd just split */
 		}
-		if (pmd_none_or_clear_bad(pmd))
-			continue;
+		VM_BUG_ON(pmd_trans_huge(*pmd));
 		this_pages = change_pte_range(vma, pmd, addr, next, newprot,
 				 dirty_accountable, prot_numa);
 		pages += this_pages;
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
mm-hwpoison-release-page-on-pagehwpoison-in-__do_fault.patch
mm-close-pagetail-race.patch
mm-page_alloc-make-first_page-visible-before-pagetail.patch
mm-include-vm_mixedmap-flag-in-the-vm_special-list-to-avoid-munlocking.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
mm-vmstat-fix-up-zone-state-accounting.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
lib-radix_tree-tree-node-interface.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-compaction-avoid-isolating-pinned-pages.patch
mm-compactionc-mark-function-as-static.patch
mm-memoryc-mark-functions-as-static.patch
mm-mmapc-mark-function-as-static.patch
include-linux-mmh-remove-ifdef-condition.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-rename-__do_fault-do_fault.patch
mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function.patch
mm-introduce-do_read_fault.patch
mm-introduce-do_cow_fault.patch
mm-introduce-do_shared_fault-and-drop-do_fault.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite-fix.patch
mm-consolidate-code-to-setup-pte.patch
schednuma-add-cond_resched-to-task_numa_work.patch
mmnuma-reorganize-change_pmd_range.patch
mmnuma-reorganize-change_pmd_range-fix.patch
move-mmu-notifier-call-from-change_protection-to-change_pmd_range.patch
fs-proc-meminfo-meminfo_proc_show-fix-typo-in-comment.patch
linux-next.patch

