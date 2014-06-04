From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possiblefix-2.patch removed from -mm tree
Date: Wed, 04 Jun 2014 15:47:00 -0700
Message-ID: <538fa1e4.W+eJOWUo4SCFnVBq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39305 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaFDWrB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:47:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, prabhakar.csengg@gmail.com, peterz@infradead.org, mhocko@suse.cz, mgorman@suse.de, jack@suse.cz, hughd@google.com, hannes@cmpxchg.org, dave.hansen@intel.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possiblefix-2.patch removed from -mm tree
To: akpm@linux-foundation.org,dave.hansen@intel.com,hannes@cmpxchg.org,hughd@google.com,jack@suse.cz,mgorman@suse.de,mhocko@suse.cz,peterz@infradead.org,prabhakar.csengg@gmail.com,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:47:00 -0700


The patch titled
     Subject: mm/shmem.c: don't run init_page_accessed() against an uninitialised pointer
has been removed from the -mm tree.  Its filename was
     mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possiblefix-2.patch

This patch was dropped because it was folded into mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/shmem.c: don't run init_page_accessed() against an uninitialised pointer

If shmem_getpage() returned an error then it didn't necessarily initialise
*pagep.  So shmem_write_begin() shouldn't be playing with *pagep in this
situation.

Fixes an oops when "mm: non-atomically mark page accessed during page
cache allocation where possible" (quite reasonably) left *pagep
uninitialized.

Reported-by: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/shmem.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possiblefix-2 mm/shmem.c
--- a/mm/shmem.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possiblefix-2
+++ a/mm/shmem.c
@@ -1376,7 +1376,7 @@ shmem_write_begin(struct file *file, str
 	struct inode *inode = mapping->host;
 	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
 	ret = shmem_getpage(inode, index, pagep, SGP_WRITE, NULL);
-	if (*pagep)
+	if (ret == 0 && *pagep)
 		init_page_accessed(*pagep);
 	return ret;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1.patch
arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn.patch
ocfs2-limit-printk-when-journal-is-aborted.patch
fs-add-generic-data-flush-to-fsync.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage.patch
mm-pass-vm_bug_on-reason-to-dump_page.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-compaction-cleanup-isolate_freepages.patch
arc-call-find_vma-with-the-mmap_sem-held.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal.patch
swap-use-bdev_read_page-bdev_write_page.patch
mm-update-comment-for-default_max_map_count.patch
memcg-fold-mem_cgroup_stolen.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-add-comment-for-__mod_zone_page_stat.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix.patch
mm-document-do_fault_around-feature-fix.patch
mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao-checkpatch-fixes.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
lib-btreec-fix-leak-of-whole-btree-nodes-fix.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
init-mainc-remove-an-ifdef.patch

