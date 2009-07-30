From: akpm@linux-foundation.org
Subject: [merged] mm-copy-over-oom_adj-value-at-fork-time.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:34:57 -0700
Message-ID: <200907302034.n6UKYvmx007291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751685AbZG3UfS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:35:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, kosaki.motohiro@jp.fujitsu.com, manage@google.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: copy over oom_adj value at fork time
has been removed from the -mm tree.  Its filename was
     mm-copy-over-oom_adj-value-at-fork-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: copy over oom_adj value at fork time
From: Rik van Riel <riel@redhat.com>

Fix a post-2.6.31 regression which was introduced by
2ff05b2b4eac2e63d345fc731ea151a060247f53 ("oom: move oom_adj value from
task_struct to mm_struct").

After moving the oom_adj value from the task struct to the mm_struct, the
oom_adj value was no longer properly inherited by child processes.

Copying over the oom_adj value at fork time fixes that bug.

[kosaki.motohiro@jp.fujitsu.com: test for current->mm before dereferencing it]
Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Paul Menage <manage@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/fork.c~mm-copy-over-oom_adj-value-at-fork-time kernel/fork.c
--- a/kernel/fork.c~mm-copy-over-oom_adj-value-at-fork-time
+++ a/kernel/fork.c
@@ -426,6 +426,7 @@ static struct mm_struct * mm_init(struct
 	init_rwsem(&mm->mmap_sem);
 	INIT_LIST_HEAD(&mm->mmlist);
 	mm->flags = (current->mm) ? current->mm->flags : default_dump_filter;
+	mm->oom_adj = (current->mm) ? current->mm->oom_adj : 0;
 	mm->core_state = NULL;
 	mm->nr_ptes = 0;
 	set_mm_counter(mm, file_rss, 0);
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
mm-make-swap-token-dummies-static-inlines.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
mm-clean-up-page_remove_rmap.patch
mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch
mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output.patch
mm-oom-analysis-add-shmem-vmstat.patch
mm-rename-pgmoved-variable-in-shrink_active_list.patch
mm-shrink_inactive_list-nr_scan-accounting-fix-fix.patch
mm-vmstat-add-isolate-pages.patch
mm-vmstat-add-isolate-pages-fix.patch
vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch
mm-remove-__addsub_zone_page_state.patch
mm-count-only-reclaimable-lru-pages-v2.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
vmscan-use-add_page_to_lru_list-helper-function.patch
vmscan-move-pgdeactivate-modification-to-shrink_active_list.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
mm-introduce-proc-pid-oom_adj_child.patch

