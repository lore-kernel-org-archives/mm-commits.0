From: akpm@linux-foundation.org
Subject: [merged] mm-fs-fix-pessimization-in-hole-punching-pagecache.patch removed from -mm tree
Date: Thu, 24 Jul 2014 13:47:25 -0700
Message-ID: <53d170dd.IlgIgs5d4pgcW2Ul%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:59910 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934680AbaGXUr0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jul 2014 16:47:26 -0400
Received: by mail-vc0-f202.google.com with SMTP id hq11so586975vcb.3
        for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2014 13:47:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, davej@redhat.com, koct9i@gmail.com, lczerner@redhat.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/fs: fix pessimization in hole-punching pagecache
has been removed from the -mm tree.  Its filename was
     mm-fs-fix-pessimization-in-hole-punching-pagecache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/fs: fix pessimization in hole-punching pagecache

I wanted to revert my v3.1 commit d0823576bf4b ("mm: pincer in
truncate_inode_pages_range"), to keep truncate_inode_pages_range() in
synch with shmem_undo_range(); but have stepped back - a change to
hole-punching in truncate_inode_pages_range() is a change to hole-punching
in every filesystem (except tmpfs) that supports it.

If there's a logical proof why no filesystem can depend for its own
correctness on the pincer guarantee in truncate_inode_pages_range() - an
instant when the entire hole is removed from pagecache - then let's
revisit later.  But the evidence is that only tmpfs suffered from the
livelock, and we have no intention of extending hole-punch to ramfs.  So
for now just add a few comments (to match or differ from those in
shmem_undo_range()), and fix one silliness noticed in d0823576bf4b...

Its "index == start" addition to the hole-punch termination test was
incomplete: it opened a way for the end condition to be missed, and the
loop go on looking through the radix_tree, all the way to end of file. 
Fix that pessimization by resetting index when detected in inner loop.

Note that it's actually hard to hit this case, without the obsessive
concurrent faulting that trinity does: normally all pages are removed in
the initial trylock_page() pass, and this loop finds nothing to do.  I had
to "#if 0" out the initial pass to reproduce bug and test fix.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Lukas Czerner <lczerner@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN mm/truncate.c~mm-fs-fix-pessimization-in-hole-punching-pagecache mm/truncate.c
--- a/mm/truncate.c~mm-fs-fix-pessimization-in-hole-punching-pagecache
+++ a/mm/truncate.c
@@ -355,14 +355,16 @@ void truncate_inode_pages_range(struct a
 	for ( ; ; ) {
 		cond_resched();
 		if (!pagevec_lookup_entries(&pvec, mapping, index,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE),
-			indices)) {
+			min(end - index, (pgoff_t)PAGEVEC_SIZE), indices)) {
+			/* If all gone from start onwards, we're done */
 			if (index == start)
 				break;
+			/* Otherwise restart to make sure all gone */
 			index = start;
 			continue;
 		}
 		if (index == start && indices[0] >= end) {
+			/* All gone out of hole to be punched, we're done */
 			pagevec_remove_exceptionals(&pvec);
 			pagevec_release(&pvec);
 			break;
@@ -373,8 +375,11 @@ void truncate_inode_pages_range(struct a
 
 			/* We rely upon deletion not changing page->index */
 			index = indices[i];
-			if (index >= end)
+			if (index >= end) {
+				/* Restart punch to make sure all gone */
+				index = start - 1;
 				break;
+			}
 
 			if (radix_tree_exceptional_entry(page)) {
 				clear_exceptional_entry(mapping, index, page);
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-use-root_mem_cgroup-res_counter.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-5.patch
mm-memcontrol-rewrite-charge-api-fix-shmem_unuse.patch
mm-memcontrol-rewrite-charge-api-fix-shmem_unuse-fix.patch
mm-memcontrol-rewrite-uncharge-api-fix-uncharge-from-irq-context.patch
mm-memcontrol-rewrite-uncharge-api-fix-double-migration-v2.patch
mm-memcontrol-rewrite-charge-api-fix-hugetlb-charging.patch
mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration-2.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
mm-vmscan-clean-up-struct-scan_control-v2.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
shmem-fix-double-uncharge-in-__shmem_file_setup.patch
shmem-update-memory-reservation-on-truncate.patch
mm-catch-memory-commitment-underflow.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch
mm-replace-init_page_accessed-by-__setpagereferenced.patch
mm-remove-the-unused-gfp-arg-to-shmem_add_to_page_cache.patch
vmstat-on-demand-vmstat-workers-v8.patch
vmstat-on-demand-vmstat-workers-v8-do-not-open-code-alloc_cpumask_var.patch
mm-refactor-page-index-offset-getters.patch
mm-refactor-page-index-offset-getters-fix.patch
list-use-argument-hlist_add_after-names-from-rcu-variant.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu.patch
klist-use-same-naming-scheme-as-hlist-for-klist_add_after.patch
linux-next.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

