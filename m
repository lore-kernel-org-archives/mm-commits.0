From: akpm@linux-foundation.org
Subject: + tmpfs-optimize-clearing-when-writing.patch added to -mm tree
Date: Mon, 14 May 2012 16:13:52 -0700
Message-ID: <20120514231352.2A6A4A00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:39786 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757353Ab2ENXNz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 May 2012 19:13:55 -0400
Received: by faaa25 with SMTP id a25so286809faa.1
        for <mm-commits@vger.kernel.org>; Mon, 14 May 2012 16:13:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, hch@infradead.org, npiggin@gmail.com


The patch titled
     Subject: tmpfs: optimize clearing when writing
has been added to the -mm tree.  Its filename is
     tmpfs-optimize-clearing-when-writing.patch

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
Subject: tmpfs: optimize clearing when writing

Nick proposed years ago that tmpfs should avoid clearing its pages where
write will overwrite them with new data, as ramfs has long done.  But I
messed it up and just got bad data.  Tried again recently, it works fine.

Here's time output for writing 4GiB 16 times on this Core i5 laptop:

before: real	0m21.169s user	0m0.028s sys	0m21.057s
        real	0m21.382s user	0m0.016s sys	0m21.289s
        real	0m21.311s user	0m0.020s sys	0m21.217s

after:  real	0m18.273s user	0m0.032s sys	0m18.165s
        real	0m18.354s user	0m0.020s sys	0m18.265s
        real	0m18.440s user	0m0.032s sys	0m18.337s

ramfs:  real	0m16.860s user	0m0.028s sys	0m16.765s
        real	0m17.382s user	0m0.040s sys	0m17.273s
        real	0m17.133s user	0m0.044s sys	0m17.021s

Yes, I have done perf reports, but they need more explanation than they
deserve: in summary, clear_page vanishes, its cache loading shifts into
copy_user_generic_unrolled; shmem_getpage_gfp goes down, and surprisingly
mark_page_accessed goes way up - I think because they are respectively
where the cache gets to be reloaded after being purged by clear or copy.

Suggested-by: Nick Piggin <npiggin@gmail.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff -puN mm/shmem.c~tmpfs-optimize-clearing-when-writing mm/shmem.c
--- a/mm/shmem.c~tmpfs-optimize-clearing-when-writing
+++ a/mm/shmem.c
@@ -1095,9 +1095,14 @@ repeat:
 		shmem_recalc_inode(inode);
 		spin_unlock(&info->lock);
 
-		clear_highpage(page);
-		flush_dcache_page(page);
-		SetPageUptodate(page);
+		/*
+		 * Let SGP_WRITE caller clear ends if write does not fill page
+		 */
+		if (sgp != SGP_WRITE) {
+			clear_highpage(page);
+			flush_dcache_page(page);
+			SetPageUptodate(page);
+		}
 		if (sgp == SGP_DIRTY)
 			set_page_dirty(page);
 	}
@@ -1307,6 +1312,14 @@ shmem_write_end(struct file *file, struc
 	if (pos + copied > inode->i_size)
 		i_size_write(inode, pos + copied);
 
+	if (!PageUptodate(page)) {
+		if (copied < PAGE_CACHE_SIZE) {
+			unsigned from = pos & (PAGE_CACHE_SIZE - 1);
+			zero_user_segments(page, 0, from,
+					from + copied, PAGE_CACHE_SIZE);
+		}
+		SetPageUptodate(page);
+	}
 	set_page_dirty(page);
 	unlock_page(page);
 	page_cache_release(page);
@@ -1768,6 +1781,7 @@ static int shmem_symlink(struct inode *d
 		kaddr = kmap_atomic(page);
 		memcpy(kaddr, symname, len);
 		kunmap_atomic(kaddr);
+		SetPageUptodate(page);
 		set_page_dirty(page);
 		unlock_page(page);
 		page_cache_release(page);
_
Subject: Subject: tmpfs: optimize clearing when writing

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
mm-remove-swap-token-code.patch
mm-vmscan-remove-lumpy-reclaim.patch
mm-vmscan-do-not-stall-on-writeback-during-memory-compaction.patch
mm-vmscan-remove-reclaim_mode_t.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check-fix.patch
mm-fork-fix-overflow-in-vma-length-when-copying-mmap-on-clone.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
bug-introduce-build_bug_on_invalid-macro.patch
bug-completely-remove-code-generated-by-disabled-vm_bug_on.patch
shmem-replace-page-if-mapping-excludes-its-zone.patch
tmpfs-enable-nosec-optimization.patch
tmpfs-optimize-clearing-when-writing.patch
tmpfs-support-fallocate-falloc_fl_punch_hole.patch
mm-fs-route-madv_remove-to-falloc_fl_punch_hole.patch
mm-fs-remove-truncate_range.patch
tmpfs-support-fallocate-preallocation.patch
tmpfs-undo-fallocation-on-failure.patch
tmpfs-quit-when-fallocate-fills-memory.patch
tmpfs-support-seek_data-and-seek_hole.patch
memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch
memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch
memcg-swap-use-mem_cgroup_uncharge_swap.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
memcg-add-mlock-statistic-in-memorystat.patch
memcg-add-mlock-statistic-in-memorystat-fix.patch
mm-vmscan-store-priority-in-struct-scan_control.patch
mm-add-link-from-struct-lruvec-to-struct-zone.patch
mm-vmscan-push-lruvec-pointer-into-isolate_lru_pages.patch
mm-vmscan-push-zone-pointer-into-shrink_page_list.patch
mm-vmscan-remove-update_isolated_counts.patch
mm-vmscan-push-lruvec-pointer-into-putback_inactive_pages.patch
mm-vmscan-replace-zone_nr_lru_pages-with-get_lruvec_size.patch
mm-vmscan-push-lruvec-pointer-into-inactive_list_is_low.patch
mm-vmscan-push-lruvec-pointer-into-shrink_list.patch
mm-vmscan-push-lruvec-pointer-into-get_scan_count.patch
mm-vmscan-push-lruvec-pointer-into-should_continue_reclaim.patch
mm-vmscan-kill-struct-mem_cgroup_zone.patch
mm-huge_memoryc-use-lockdep_assert_held.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-use-is_err_or_null.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
prio_tree-debugging-patch.patch

