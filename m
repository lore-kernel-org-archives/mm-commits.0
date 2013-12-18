From: akpm@linux-foundation.org
Subject: + mm-fix-use-after-free-in-sys_remap_file_pages.patch added to
 -mm tree
Date: Wed, 18 Dec 2013 13:25:55 -0800
Message-ID: <52b212e3.FtUnH4dh6nnrE1/F%akpm__20724.0785276101$1387401986$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36731 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab3LRVZ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Dec 2013 16:25:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, stable@vger.kernel.org, pageexec@freemail.hu, keescook@chromium.org, hughd@google.com, gorcunov@openvz.org, dvyukov@google.com, riel@redhat.com

Subject: + mm-fix-use-after-free-in-sys_remap_file_pages.patch added to -mm tree
To: riel@redhat.com,dvyukov@google.com,gorcunov@openvz.org,hughd@google.com,keescook@chromium.org,pageexec@freemail.hu,stable@vger.kernel.org,walken@google.com
From: akpm@linux-foundation.org
Date: Wed, 18 Dec 2013 13:25:55 -0800


The patch titled
     Subject: mm: fix use-after-free in sys_remap_file_pages
has been added to the -mm tree.  Its filename is
     mm-fix-use-after-free-in-sys_remap_file_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-use-after-free-in-sys_remap_file_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-use-after-free-in-sys_remap_file_pages.patch

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
Subject: mm: fix use-after-free in sys_remap_file_pages

remap_file_pages calls mmap_region, which may merge the VMA with other
existing VMAs, and free "vma".  This can lead to a use-after-free bug. 
Avoid the bug by remembering vm_flags before calling mmap_region, and not
trying to dereference vma later.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Cc: "PaX Team" <pageexec@freemail.hu>
Cc: Kees Cook <keescook@chromium.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fremap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/fremap.c~mm-fix-use-after-free-in-sys_remap_file_pages mm/fremap.c
--- a/mm/fremap.c~mm-fix-use-after-free-in-sys_remap_file_pages
+++ a/mm/fremap.c
@@ -208,9 +208,10 @@ get_write_lock:
 		if (mapping_cap_account_dirty(mapping)) {
 			unsigned long addr;
 			struct file *file = get_file(vma->vm_file);
+			/* mmap_region may free vma; grab the info now */
+			vm_flags = ACCESS_ONCE(vma->vm_flags);
 
-			addr = mmap_region(file, start, size,
-					vma->vm_flags, pgoff);
+			addr = mmap_region(file, start, size, vm_flags, pgoff);
 			fput(file);
 			if (IS_ERR_VALUE(addr)) {
 				err = addr;
@@ -218,7 +219,7 @@ get_write_lock:
 				BUG_ON(addr != start);
 				err = 0;
 			}
-			goto out;
+			goto out_freed;
 		}
 		mutex_lock(&mapping->i_mmap_mutex);
 		flush_dcache_mmap_lock(mapping);
@@ -253,6 +254,7 @@ get_write_lock:
 out:
 	if (vma)
 		vm_flags = vma->vm_flags;
+out_freed:
 	if (likely(!has_write_lock))
 		up_read(&mm->mmap_sem);
 	else
_

Patches currently in -mm which might be from riel@redhat.com are

mm-numa-serialise-parallel-get_user_page-against-thp-migration.patch
mm-numa-call-mmu-notifiers-on-thp-migration.patch
mm-clear-pmd_numa-before-invalidating.patch
mm-numa-do-not-clear-pmd-during-pte-update-scan.patch
mm-numa-do-not-clear-pte-for-pte_numa-update.patch
mm-numa-do-not-clear-pte-for-pte_numa-update-fix.patch
mm-numa-ensure-anon_vma-is-locked-to-prevent-parallel-thp-splits.patch
mm-numa-avoid-unnecessary-work-on-the-failure-path.patch
sched-numa-skip-inaccessible-vmas.patch
mm-numa-clear-numa-hinting-information-on-mprotect.patch
mm-numa-avoid-unnecessary-disruption-of-numa-hinting-during-migration.patch
mm-fix-tlb-flush-race-between-migration-and-change_protection_range.patch
mm-numa-guarantee-that-tlb_flush_pending-updates-are-visible-before-page-table-updates.patch
mm-numa-defer-tlb-flush-for-thp-migration-as-long-as-possible.patch
mm-page_alloc-exclude-unreclaimable-allocations-from-zone-fairness-policy.patch
mm-mempolicy-correct-putback-method-for-isolate-pages-if-failed.patch
mm-compaction-respect-ignore_skip_hint-in-update_pageblock_skip.patch
mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered.patch
mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered-v2.patch
mm-munlock-fix-deadlock-in-__munlock_pagevec.patch
mm-munlock-fix-deadlock-in-__munlock_pagevec-fix.patch
mm-fix-use-after-free-in-sys_remap_file_pages.patch
mm-hugetlb-use-get_page_foll-in-follow_hugetlb_page.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch
mm-thp-optimize-compound_trans_huge.patch
mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs.patch
mm-hugetlbfs-use-__compound_tail_refcounted-in-__get_page_tail-too.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-hugetlbc-defer-pageheadhuge-symbol-export.patch
proc-meminfo-provide-estimated-available-memory.patch
mm-call-mmu-notifiers-when-copying-a-hugetlb-page-range.patch
mm-mmapc-add-mlock_future_check-helper.patch
mm-mlock-prepare-params-outside-critical-region.patch
x86-get-pg_data_ts-memory-from-other-node.patch
memblock-numa-introduce-flags-field-into-memblock.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
memblock-make-memblock_set_node-support-different-memblock_type.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
acpi-numa-mem_hotplug-mark-all-nodes-the-kernel-resides-un-hotpluggable.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch
mm-rmap-recompute-pgoff-for-huge-page.patch
mm-rmap-factor-nonlinear-handling-out-of-try_to_unmap_file.patch
mm-rmap-factor-lock-function-out-of-rmap_walk_anon.patch
mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument.patch
mm-rmap-extend-rmap_walk_xxx-to-cope-with-different-cases.patch
mm-rmap-use-rmap_walk-in-try_to_unmap.patch
mm-rmap-use-rmap_walk-in-try_to_munlock.patch
mm-rmap-use-rmap_walk-in-page_referenced.patch
mm-rmap-use-rmap_walk-in-page_mkclean.patch
mm-numa-make-numa-migrate-related-functions-static.patch
mm-numa-limit-scope-of-lock-for-numa-migrate-rate-limiting.patch
mm-numa-trace-tasks-that-fail-migration-due-to-rate-limiting.patch
mm-numa-do-not-automatically-migrate-ksm-pages.patch
sched-add-tracepoints-related-to-numa-task-migration.patch
sched-add-tracepoints-related-to-numa-task-migration-fix.patch
mm-compaction-trace-compaction-begin-and-end.patch
mm-compaction-encapsulate-defer-reset-logic.patch
mm-compaction-reset-cached-scanner-pfns-before-reading-them.patch
mm-compaction-detect-when-scanners-meet-in-isolate_freepages.patch
mm-compaction-do-not-mark-unmovable-pageblocks-as-skipped-in-async-compaction.patch
mm-compaction-reset-scanner-positions-immediately-when-they-meet.patch
mm-migrate-add-comment-about-permanent-failure-path.patch
mm-migrate-correct-failure-handling-if-hugepage_migration_support.patch
mm-migrate-remove-putback_lru_pages-fix-comment-on-putback_movable_pages.patch
mm-migrate-remove-unused-function-fail_migrate_page.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
linux-next.patch
mm-migratec-fix-set-cpupid-on-page-migration-twice-against-thp.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch

