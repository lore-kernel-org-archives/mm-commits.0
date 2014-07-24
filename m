From: akpm@linux-foundation.org
Subject: [merged] shmem-fix-splicing-from-a-hole-while-its-punched.patch
 removed from -mm tree
Date: Thu, 24 Jul 2014 13:47:23 -0700
Message-ID: <53d170db.9NwCTZRueosCdS6L%akpm__17310.2488079623$1406234865$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:51648 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934651AbaGXUrZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jul 2014 16:47:25 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so914694pab.2
        for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2014 13:47:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, davej@redhat.com, hannes@cmpxchg.org, koct9i@gmail.com, lczerner@redhat.com, sasha.levin@oracle.com, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: fix splicing from a hole while it's punched
has been removed from the -mm tree.  Its filename was
     shmem-fix-splicing-from-a-hole-while-its-punched.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: shmem: fix splicing from a hole while it's punched

shmem_fault() is the actual culprit in trinity's hole-punch starvation,
and the most significant cause of such problems: since a page faulted is
one that then appears page_mapped(), needing unmap_mapping_range() and
i_mmap_mutex to be unmapped again.

But it is not the only way in which a page can be brought into a hole in
the radix_tree while that hole is being punched; and Vlastimil's testing
implies that if enough other processors are busy filling in the hole, then
shmem_undo_range() can be kept from completing indefinitely.

shmem_file_splice_read() is the main other user of SGP_CACHE, which can
instantiate shmem pagecache pages in the read-only case (without holding
i_mutex, so perhaps concurrently with a hole-punch).  Probably it's silly
not to use SGP_READ already (using the ZERO_PAGE for holes): which ought
to be safe, but might bring surprises - not a change to be rushed.

shmem_read_mapping_page_gfp() is an internal interface used by
drivers/gpu/drm GEM (and next by uprobes): it should be okay.  And
shmem_file_read_iter() uses the SGP_DIRTY variant of SGP_CACHE, when
called internally by the kernel (perhaps for a stacking filesystem, which
might rely on holes to be reserved): it's unclear whether it could be
provoked to keep hole-punch busy or not.

We could apply the same umbrella as now used in shmem_fault() to
shmem_file_splice_read() and the others; but it looks ugly, and use over a
range raises questions - should it actually be per page?  can these get
starved themselves?

The origin of this part of the problem is my v3.1 commit d0823576bf4b
("mm: pincer in truncate_inode_pages_range"), once it was duplicated into
shmem.c.  It seemed like a nice idea at the time, to ensure (barring RCU
lookup fuzziness) that there's an instant when the entire hole is empty;
but the indefinitely repeated scans to ensure that make it vulnerable.

Revert that "enhancement" to hole-punch from shmem_undo_range(), but
retain the unproblematic rescanning when it's truncating; add a couple of
comments there.

Remove the "indices[0] >= end" test: that is now handled satisfactorily by
the inner loop, and mem_cgroup_uncharge_start()/end() are too light to be
worth avoiding here.

But if we do not always loop indefinitely, we do need to handle the case
of swap swizzled back to page before shmem_free_swap() gets it: add a
retry for that case, as suggested by Konstantin Khlebnikov; and for the
case of page swizzled back to swap, as suggested by Johannes Weiner.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lukas Czerner <lczerner@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: <stable@vger.kernel.org>	[3.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff -puN mm/shmem.c~shmem-fix-splicing-from-a-hole-while-its-punched mm/shmem.c
--- a/mm/shmem.c~shmem-fix-splicing-from-a-hole-while-its-punched
+++ a/mm/shmem.c
@@ -468,23 +468,20 @@ static void shmem_undo_range(struct inod
 		return;
 
 	index = start;
-	for ( ; ; ) {
+	while (index < end) {
 		cond_resched();
 
 		pvec.nr = find_get_entries(mapping, index,
 				min(end - index, (pgoff_t)PAGEVEC_SIZE),
 				pvec.pages, indices);
 		if (!pvec.nr) {
-			if (index == start || unfalloc)
+			/* If all gone or hole-punch or unfalloc, we're done */
+			if (index == start || end != -1)
 				break;
+			/* But if truncating, restart to make sure all gone */
 			index = start;
 			continue;
 		}
-		if ((index == start || unfalloc) && indices[0] >= end) {
-			pagevec_remove_exceptionals(&pvec);
-			pagevec_release(&pvec);
-			break;
-		}
 		mem_cgroup_uncharge_start();
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
@@ -496,8 +493,12 @@ static void shmem_undo_range(struct inod
 			if (radix_tree_exceptional_entry(page)) {
 				if (unfalloc)
 					continue;
-				nr_swaps_freed += !shmem_free_swap(mapping,
-								index, page);
+				if (shmem_free_swap(mapping, index, page)) {
+					/* Swap was replaced by page: retry */
+					index--;
+					break;
+				}
+				nr_swaps_freed++;
 				continue;
 			}
 
@@ -506,6 +507,11 @@ static void shmem_undo_range(struct inod
 				if (page->mapping == mapping) {
 					VM_BUG_ON_PAGE(PageWriteback(page), page);
 					truncate_inode_page(mapping, page);
+				} else {
+					/* Page was replaced by swap: retry */
+					unlock_page(page);
+					index--;
+					break;
 				}
 			}
 			unlock_page(page);
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

