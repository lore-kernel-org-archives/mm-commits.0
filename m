From: akpm@linux-foundation.org
Subject: [folded] kcore-fix-vread-vwrite-to-be-aware-of-holes-update.patch removed from -mm tree
Date: Mon, 21 Sep 2009 14:23:05 -0700
Message-ID: <200909212123.n8LLN6XL007363@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753489AbZIUVXf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Sep 2009 17:23:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, nickpiggin@yahoo.com.au, scgtrp@gmail.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     kcore-fix-vread-vwrite-to-be-aware-of-holes-update
has been removed from the -mm tree.  Its filename was
     kcore-fix-vread-vwrite-to-be-aware-of-holes-update.patch

This patch was dropped because it was folded into kcore-fix-vread-vwrite-to-be-aware-of-holes.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kcore-fix-vread-vwrite-to-be-aware-of-holes-update
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Changelov v3->v3.1
 - fixed comments. (mainly vread/vwrite description is updated.)
 - use KM_USER0 instead of KM_USER1

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Mike Smith <scgtrp@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   49 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff -puN mm/vmalloc.c~kcore-fix-vread-vwrite-to-be-aware-of-holes-update mm/vmalloc.c
--- a/mm/vmalloc.c~kcore-fix-vread-vwrite-to-be-aware-of-holes-update
+++ a/mm/vmalloc.c
@@ -1669,10 +1669,13 @@ static int aligned_vread(char *buf, char
 		 * kmap() and get small overhead in this access function.
 		 */
 		if (p) {
-			/* we can expect USR1 is not used */
-			void *map = kmap_atomic(p, KM_USER1);
+			/*
+			 * we can expect USER0 is not used (see vread/vwrite's
+			 * function description)
+			 */
+			void *map = kmap_atomic(p, KM_USER0);
 			memcpy(buf, map + offset, length);
-			kunmap_atomic(map, KM_USER1);
+			kunmap_atomic(map, KM_USER0);
 		} else
 			memset(buf, 0, length);
 
@@ -1705,10 +1708,13 @@ static int aligned_vwrite(char *buf, cha
 		 * kmap() and get small overhead in this access function.
 		 */
 		if (p) {
-			/* we can expect USR1 is not used */
-			void *map = kmap_atomic(p, KM_USER1);
+			/*
+			 * we can expect USER0 is not used (see vread/vwrite's
+			 * function description)
+			 */
+			void *map = kmap_atomic(p, KM_USER0);
 			memcpy(map + offset, buf, length);
-			kunmap_atomic(map, KM_USER1);
+			kunmap_atomic(map, KM_USER0);
 		}
 		addr += length;
 		buf += length;
@@ -1725,20 +1731,25 @@ static int aligned_vwrite(char *buf, cha
  *	@count:		number of bytes to be read.
  *
  *	Returns # of bytes which addr and buf should be increased.
- *	(same to count).
- *	If [addr...addr+count) doesn't includes any valid area, returns 0.
+ *	(same number to @count). Returns 0 if [addr...addr+count) doesn't
+ *	includes any intersect with alive vmalloc area.
  *
  *	This function checks that addr is a valid vmalloc'ed area, and
- *	copy data from that area to a given buffer. If the given memory range of
- *	[addr...addr+count) includes some valid address, data is copied to
+ *	copy data from that area to a given buffer. If the given memory range
+ *	of [addr...addr+count) includes some valid address, data is copied to
  *	proper area of @buf. If there are memory holes, they'll be zero-filled.
  *	IOREMAP area is treated as memory hole and no copy is done.
  *
- *	Note: In usual ops, vread() is never necessary because the caller should
- *	know vmalloc() area is valid and can use memcpy(). This is for routines
- *	which have to access vmalloc area without any informaion, as /dev/kmem.
+ *	If [addr...addr+count) doesn't includes any intersects with alive
+ *	vm_struct area, returns 0.
+ *	@buf should be kernel's buffer. Because	this function uses KM_USER0,
+ *	the caller should guarantee KM_USER0 is not used.
+ *
+ *	Note: In usual ops, vread() is never necessary because the caller
+ *	should know vmalloc() area is valid and can use memcpy().
+ *	This is for routines which have to access vmalloc area without
+ *	any informaion, as /dev/kmem.
  *
- *	The caller should guarantee KM_USER1 is not used.
  */
 
 long vread(char *buf, char *addr, unsigned long count)
@@ -1795,8 +1806,9 @@ finished:
  *	@count:		number of bytes to be read.
  *
  *	Returns # of bytes which addr and buf should be incresed.
- *	(same to count).
- *	If [addr...addr+count) doesn't includes any valid area, returns 0.
+ *	(same number to @count).
+ *	If [addr...addr+count) doesn't includes any intersect with valid
+ *	vmalloc area, returns 0.
  *
  *	This function checks that addr is a valid vmalloc'ed area, and
  *	copy data from a buffer to the given addr. If specified range of
@@ -1804,6 +1816,11 @@ finished:
  *	proper area of @buf. If there are memory holes, no copy to hole.
  *	IOREMAP area is treated as memory hole and no copy is done.
  *
+ *	If [addr...addr+count) doesn't includes any intersects with alive
+ *	vm_struct area, returns 0.
+ *	@buf should be kernel's buffer. Because	this function uses KM_USER0,
+ *	the caller should guarantee KM_USER0 is not used.
+ *
  *	Note: In usual ops, vwrite() is never necessary because the caller
  *	should know vmalloc() area is valid and can use memcpy().
  *	This is for routines which have to access vmalloc area without
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

proc-kcore-work-around-a-bug.patch
mm-clean-up-page_remove_rmap.patch
vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch
mm-remove-__addsub_zone_page_state.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
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
page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback.patch
vmalloc-unmap-vmalloc-area-after-hiding-it.patch
revert-proc-kcore-work-around-a-bug.patch
kcore-fix-vread-vwrite-to-be-aware-of-holes.patch
kcore-fix-vread-vwrite-to-be-aware-of-holes-update.patch
kcore-proc-kcore-should-use-vread.patch
mm-add_to_swap_cache-must-not-sleep.patch
mm-add_to_swap_cache-does-not-return-eexist.patch
memory-hotplug-fix-updating-of-num_physpages-for-hot-plugged-memory.patch
mm-vmscan-rename-zone_nr_pages-to-zone_lru_nr_pages.patch
mm-do-batched-scans-for-mem_cgroup.patch
oom-move-oom_adj-value-from-task_struct-to-signal_struct.patch
oom-make-oom_score-to-per-process-value.patch
oom-oom_kill-doesnt-kill-vfork-parentor-child.patch
oom-fix-oom_adjust_write-input-sanity-check.patch
mm-fix-numa-accounting-in-numastattxt.patch
mm-munlock-use-follow_page.patch
mm-remove-unused-gup-flags.patch
mm-add-get_dump_page.patch
mm-foll_dump-replace-foll_anon.patch
mm-follow_hugetlb_page-flags.patch
mm-fix-anonymous-dirtying.patch
mm-reinstate-zero_page.patch
mm-foll-flags-for-gup-flags.patch
mm-munlock-avoid-zero_page.patch
mm-hugetlbfs_pagecache_present.patch
mm-zero_page-without-pte_special.patch
mm-zero_page-without-pte_special-mips-fix.patch
mm-move-highest_memmap_pfn.patch
kcore-fix-proc-kcores-statst_size.patch
kcore-use-usual-list-for-kclist.patch
kcore-add-kclist-types.patch
kcore-register-vmalloc-area-in-generic-way.patch
kcore-register-text-area-in-generic-way.patch
walk-system-ram-range.patch
walk-system-ram-range-fix.patch
walk-system-ram-range-fix-2.patch
kcore-use-registerd-physmem-information.patch
kcore-use-registerd-physmem-information-ia64-fix.patch
kcore-register-vmemmap-range.patch
kcore-register-vmemmap-range-fix.patch
kcore-register-module-area-in-generic-way.patch
kcore-more-fixes-for-init.patch
proc-kcore-fix-statst_size.patch
proc-kcore-update-statst_size-after-memory-hotplug.patch
cgroups-support-named-cgroups-hierarchies.patch
cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state.patch
cgroups-add-a-back-pointer-from-struct-cg_cgroup_link-to-struct-cgroup.patch
cgroups-allow-cgroup-hierarchies-to-be-created-with-no-bound-subsystems.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-add-comments-explaining-memory-barriers.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
memcg-show-swap-usage-in-stat-file.patch
memcg-show-swap-usage-in-stat-file-fix.patch
do_wait-wakeup-optimization-fix-child_wait_callback-eligible_child-usage.patch
do_wait-wakeup-optimization-simplify-task_pid_type.patch

