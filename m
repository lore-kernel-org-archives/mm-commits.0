From: akpm@linux-foundation.org
Subject: + shmem-fix-faulting-into-a-hole-while-its-punched-take-2.patch
 added to -mm tree
Date: Wed, 02 Jul 2014 12:25:15 -0700
Message-ID: <53b45c9b.2rlA0uGYBLzlXEeS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:53629 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307AbaGBTZQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2014 15:25:16 -0400
Received: by mail-yh0-f73.google.com with SMTP id f10so1330105yha.0
        for <mm-commits@vger.kernel.org>; Wed, 02 Jul 2014 12:25:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, davej@redhat.com, koct9i@gmail.com, lczerner@redhat.com, sasha.levin@oracle.com, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: fix faulting into a hole while it's punched, take 2
has been added to the -mm tree.  Its filename is
     shmem-fix-faulting-into-a-hole-while-its-punched-take-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/shmem-fix-faulting-into-a-hole-while-its-punched-take-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/shmem-fix-faulting-into-a-hole-while-its-punched-take-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: shmem: fix faulting into a hole while it's punched, take 2

Trinity finds that mmap access to a hole while it's punched from shmem can
prevent the madvise(MADV_REMOVE) or fallocate(FALLOC_FL_PUNCH_HOLE) from
completing, until the (killable) reader stops; with the puncher's hold on
i_mutex locking out all other writers until it can complete.  This issue
was tagged with CVE-2014-4171.

It appears that the tmpfs fault path is too light in comparison with its
hole-punching path, lacking an i_data_sem to obstruct it; but we don't
want to slow down the common case.  It is not a problem in truncation,
because there the SIGBUS beyond i_size stops pages from being appended.

The origin of this problem is my v3.1 commit d0823576bf4b ("mm: pincer in
truncate_inode_pages_range"), once it was duplicated into shmem.c.  It
seemed like a nice idea at the time, to ensure (barring RCU lookup
fuzziness) that there's an instant when the entire hole is empty; but the
indefinitely repeated scans to ensure that make it vulnerable.

Revert that "enhancement" to hole-punch from shmem_undo_range(), but
retain the unproblematic rescanning when it's truncating; add a couple of
comments there.

Remove the "indices[0] >= end" test: that is now handled satisfactorily by
the inner loop, and mem_cgroup_uncharge_start()/end() are too light to be
worth avoiding here.

But if we do not always loop indefinitely, we do need to handle the case
of swap swizzled back to page before shmem_free_swap() gets it: add a
retry for that case, as suggested by Konstantin Khlebnikov.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Suggested-and-Tested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Lukas Czerner <lczerner@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: <stable@vger.kernel.org>	[3.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN mm/shmem.c~shmem-fix-faulting-into-a-hole-while-its-punched-take-2 mm/shmem.c
--- a/mm/shmem.c~shmem-fix-faulting-into-a-hole-while-its-punched-take-2
+++ a/mm/shmem.c
@@ -467,23 +467,20 @@ static void shmem_undo_range(struct inod
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
@@ -495,8 +492,12 @@ static void shmem_undo_range(struct inod
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
 
_

Patches currently in -mm which might be from hughd@google.com are

shmem-fix-init_page_accessed-use-to-stop-pagelru-bug.patch
revert-shmem-fix-faulting-into-a-hole-while-its-punched.patch
shmem-fix-faulting-into-a-hole-while-its-punched-take-2.patch
mm-fs-fix-pessimization-in-hole-punching-pagecache.patch
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
mm-vmallocc-add-a-schedule-point-to-vmalloc.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
shmem-fix-double-uncharge-in-__shmem_file_setup.patch
shmem-update-memory-reservation-on-truncate.patch
mm-catch-memory-commitment-underflow.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch
mm-replace-init_page_accessed-by-__setpagereferenced.patch
mm-zbud-zbud_alloc-minor-param-change.patch
mm-zbud-change-zbud_alloc-size-type-to-size_t.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
mm-zpool-update-zswap-to-use-zpool.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used.patch
list-use-argument-hlist_add_after-names-from-rcu-variant.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu.patch
klist-use-same-naming-scheme-as-hlist-for-klist_add_after.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

