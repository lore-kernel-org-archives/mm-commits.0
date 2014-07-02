From: akpm@linux-foundation.org
Subject: + mm-fs-fix-pessimization-in-hole-punching-pagecache.patch added
 to -mm tree
Date: Wed, 02 Jul 2014 12:25:16 -0700
Message-ID: <53b45c9c.WudrGfi63yjqc05o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:43270 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaGBTZR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2014 15:25:17 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so2681594obb.2
        for <mm-commits@vger.kernel.org>; Wed, 02 Jul 2014 12:25:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, davej@redhat.com, koct9i@gmail.com, lczerner@redhat.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/fs: fix pessimization in hole-punching pagecache
has been added to the -mm tree.  Its filename is
     mm-fs-fix-pessimization-in-hole-punching-pagecache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fs-fix-pessimization-in-hole-punching-pagecache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fs-fix-pessimization-in-hole-punching-pagecache.patch

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
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Lukas Czerner <lczerner@redhat.com>
Cc: Dave Jones <davej@redhat.com>
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

