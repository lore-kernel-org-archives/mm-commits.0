From: akpm@linux-foundation.org
Subject: - ksym_symbol_len-fixes.patch removed from -mm tree
Date: Wed, 10 Dec 2008 11:29:14 -0800
Message-ID: <200812101929.mBAJTEA1021711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755486AbYLJTao (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Dec 2008 14:30:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, cl@linux-foundation.org, fweisbec@gmail.com, miles.lane@gmail.com, penberg@cs.helsinki.fi, rusty@rustcorp.com.au, srostedt@redhat.com, mm-commits@vger.kernel.org


The patch titled
     KSYM_SYMBOL_LEN fixes
has been removed from the -mm tree.  Its filename was
     ksym_symbol_len-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: KSYM_SYMBOL_LEN fixes
From: Hugh Dickins <hugh@veritas.com>

Miles Lane tailing /sys files hit a BUG which Pekka Enberg has tracked
to my 966c8c12dc9e77f931e2281ba25d2f0244b06949 sprint_symbol(): use
less stack exposing a bug in slub's list_locations() -
kallsyms_lookup() writes a 0 to namebuf[KSYM_NAME_LEN-1], but that was
beyond the end of page provided.

The 100 slop which list_locations() allows at end of page looks roughly
enough for all the other stuff it might print after the symbol before
it checks again: break out KSYM_SYMBOL_LEN earlier than before.

Latencytop and ftrace and are using KSYM_NAME_LEN buffers where they
need KSYM_SYMBOL_LEN buffers, and vmallocinfo a 2*KSYM_NAME_LEN buffer
where it wants a KSYM_SYMBOL_LEN buffer: fix those before anyone copies
them.

[akpm@linux-foundation.org: ftrace.h needs module.h]
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc Miles Lane <miles.lane@gmail.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Steven Rostedt <srostedt@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c         |    2 +-
 include/linux/ftrace.h |    3 ++-
 kernel/latencytop.c    |    2 +-
 mm/slub.c              |    2 +-
 mm/vmalloc.c           |    2 +-
 5 files changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/proc/base.c~ksym_symbol_len-fixes fs/proc/base.c
--- a/fs/proc/base.c~ksym_symbol_len-fixes
+++ a/fs/proc/base.c
@@ -371,7 +371,7 @@ static int lstats_show_proc(struct seq_f
 				task->latency_record[i].time,
 				task->latency_record[i].max);
 			for (q = 0; q < LT_BACKTRACEDEPTH; q++) {
-				char sym[KSYM_NAME_LEN];
+				char sym[KSYM_SYMBOL_LEN];
 				char *c;
 				if (!task->latency_record[i].backtrace[q])
 					break;
diff -puN include/linux/ftrace.h~ksym_symbol_len-fixes include/linux/ftrace.h
--- a/include/linux/ftrace.h~ksym_symbol_len-fixes
+++ a/include/linux/ftrace.h
@@ -6,6 +6,7 @@
 #include <linux/ktime.h>
 #include <linux/init.h>
 #include <linux/types.h>
+#include <linux/module.h>
 #include <linux/kallsyms.h>
 
 #ifdef CONFIG_FUNCTION_TRACER
@@ -231,7 +232,7 @@ ftrace_init_module(unsigned long *start,
 
 struct boot_trace {
 	pid_t			caller;
-	char			func[KSYM_NAME_LEN];
+	char			func[KSYM_SYMBOL_LEN];
 	int			result;
 	unsigned long long	duration;		/* usecs */
 	ktime_t			calltime;
diff -puN kernel/latencytop.c~ksym_symbol_len-fixes kernel/latencytop.c
--- a/kernel/latencytop.c~ksym_symbol_len-fixes
+++ a/kernel/latencytop.c
@@ -191,7 +191,7 @@ static int lstats_show(struct seq_file *
 				latency_record[i].time,
 				latency_record[i].max);
 			for (q = 0; q < LT_BACKTRACEDEPTH; q++) {
-				char sym[KSYM_NAME_LEN];
+				char sym[KSYM_SYMBOL_LEN];
 				char *c;
 				if (!latency_record[i].backtrace[q])
 					break;
diff -puN mm/slub.c~ksym_symbol_len-fixes mm/slub.c
--- a/mm/slub.c~ksym_symbol_len-fixes
+++ a/mm/slub.c
@@ -3597,7 +3597,7 @@ static int list_locations(struct kmem_ca
 	for (i = 0; i < t.count; i++) {
 		struct location *l = &t.loc[i];
 
-		if (len > PAGE_SIZE - 100)
+		if (len > PAGE_SIZE - KSYM_SYMBOL_LEN - 100)
 			break;
 		len += sprintf(buf + len, "%7ld ", l->count);
 
diff -puN mm/vmalloc.c~ksym_symbol_len-fixes mm/vmalloc.c
--- a/mm/vmalloc.c~ksym_symbol_len-fixes
+++ a/mm/vmalloc.c
@@ -1717,7 +1717,7 @@ static int s_show(struct seq_file *m, vo
 		v->addr, v->addr + v->size, v->size);
 
 	if (v->caller) {
-		char buff[2 * KSYM_NAME_LEN];
+		char buff[KSYM_SYMBOL_LEN];
 
 		seq_putc(m, ' ');
 		sprint_symbol(buff, (unsigned long)v->caller);
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
linux-next.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
mm-remove-cgroup_mm_owner_callbacks.patch
mm-remove-aop_writepage_activate.patch
mm-remove-gfp_highuser_pagecache.patch
mm-add-setclearpageswapcache-stubs.patch
mm-replace-some-bug_ons-by-vm_bug_ons.patch
mm-add_active_or_unevictable-into-rmap.patch
mm-make-page_lock_anon_vma-static.patch
mm-further-cleanup-page_add_new_anon_rmap.patch
mm-gup-persist-for-write-permission.patch
mm-wp-lock-page-before-deciding-cow.patch
mm-reuse_swap_page-replaces-can_share_swap_page.patch
mm-try_to_free_swap-replaces-remove_exclusive_swap_page.patch
mm-try_to_unuse-check-removing-right-swap.patch
mm-remove-try_to_munlock-from-vmscan.patch
mm-remove-gfp_mask-from-add_to_swap.patch
mm-add-add_to_swap-stub.patch
mm-optimize-get_scan_ratio-for-no-swap.patch
swapfile-swapon-needs-larger-size-type.patch
swapfile-remove-swp_active-mask.patch
swapfile-remove-surplus-whitespace.patch
swapfile-remove-v0-swap-space-message.patch
swapfile-rearrange-scan-and-swap_info.patch
swapfile-swapon-use-discard-trim.patch
swapfile-swap-allocation-use-discard.patch
swapfile-swapon-randomize-if-nonrot.patch
swapfile-swap-allocation-cycle-if-nonrot.patch
swapfile-change-discard-pgoff_t-to-sector_t.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
swapfile-let-others-seed-random.patch
badpage-simplify-page_alloc-flag-checkclear.patch
badpage-keep-any-bad-page-out-of-circulation.patch
badpage-replace-page_remove_rmap-eeek-and-bug.patch
badpage-vm_normal_page-use-print_bad_pte.patch
badpage-zap-print_bad_pte-on-swap-and-file.patch
badpage-remove-vma-from-page_remove_rmap.patch
badpage-ratelimit-print_bad_pte-and-bad_page.patch
badpage-kern_alert-bug-instead-of-kern_emerg.patch
hugetlb-unsigned-ret-cannot-be-negative.patch
mm-make-get_user_pages-interruptible.patch
mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_pages-during-munlock.patch
shmem-remove-unused-shmem_get_unmapped_area.patch
shmem-unify-regular-and-tiny-shmem.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-mmapc-fix-coding-style.patch
mm-mmapc-fix-coding-style-fix.patch
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
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-explain-details-and-test-document.patch
prio_tree-debugging-patch.patch

