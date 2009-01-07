From: akpm@linux-foundation.org
Subject: - mm-gup-persist-for-write-permission.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:12:33 -0800
Message-ID: <200901072212.n07MCX7p012761@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45928 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754857AbZAGWM6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:12:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, holt@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: gup persist for write permission
has been removed from the -mm tree.  Its filename was
     mm-gup-persist-for-write-permission.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: gup persist for write permission
From: Hugh Dickins <hugh@veritas.com>

do_wp_page()'s VM_FAULT_WRITE return value tells __get_user_pages() that
COW has been done if necessary, though it may be leaving the pte without
write permission - for the odd case of forced writing to a readonly vma
for ptrace.  At present GUP then retries the follow_page() without asking
for write permission, to escape an endless loop when forced.

But an application may be relying on GUP to guarantee a writable page
which won't be COWed again when written from userspace, whereas a race
here might leave a readonly pte in place?  Change the VM_FAULT_WRITE
handling to ask follow_page() for write permission again, except in that
odd case of forced writing to a readonly vma.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-gup-persist-for-write-permission mm/memory.c
--- a/mm/memory.c~mm-gup-persist-for-write-permission
+++ a/mm/memory.c
@@ -1264,9 +1264,15 @@ int __get_user_pages(struct task_struct 
 				 * do_wp_page has broken COW when necessary,
 				 * even if maybe_mkwrite decided not to set
 				 * pte_write. We can thus safely do subsequent
-				 * page lookups as if they were reads.
+				 * page lookups as if they were reads. But only
+				 * do so when looping for pte_write is futile:
+				 * in some cases userspace may also be wanting
+				 * to write to the gotten user page, which a
+				 * read fault here might prevent (a readonly
+				 * page might get reCOWed by userspace write).
 				 */
-				if (ret & VM_FAULT_WRITE)
+				if ((ret & VM_FAULT_WRITE) &&
+				    !(vma->vm_flags & VM_WRITE))
 					foll_flags &= ~FOLL_WRITE;
 
 				cond_resched();
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
linux-next.patch
mark-complex-bitopsh-inlines-as-__always_inline.patch
clocksource-pass-clocksource-to-read-callback.patch
clocksource-pass-clocksource-to-read-callback-sparc-cleanup.patch
bio-zero-inlined-bio_vec.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-shmemc-fix-division-by-zero.patch
getrusage-fill-ru_maxrss-value.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-explain-details-and-test-document.patch
memcg-fix-swap-accounting-leak-v3.patch
memcg-fix-swap-accounting-leak-doc-fix.patch
memcg-fix-shmems-swap-accounting.patch
prio_tree-debugging-patch.patch

