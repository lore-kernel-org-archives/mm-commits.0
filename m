From: akpm@linux-foundation.org
Subject: [folded] mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch removed from -mm tree
Date: Thu, 13 Jan 2011 15:29:02 -0800
Message-ID: <201101132329.p0DNT3rm007102@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757142Ab1AMX3h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 18:29:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, hpa@zytor.com, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, npiggin@kernel.dk, peterz@infradead.org, riel@redhat.com


The patch titled
     mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix
has been removed from the -mm tree.  Its filename was
     mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch

This patch was dropped because it was folded into mlock-do-not-hold-mmap_sem-for-extended-periods-of-time.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix
From: Andrew Morton <akpm@linux-foundation.org>

remove ref to rwsem_is_contended()

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN mm/memory.c~mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix mm/memory.c
--- a/mm/memory.c~mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix
+++ a/mm/memory.c
@@ -1528,11 +1528,6 @@ int __get_user_pages(struct task_struct 
 			i++;
 			start += PAGE_SIZE;
 			nr_pages--;
-			if (nonblocking && rwsem_is_contended(&mm->mmap_sem)) {
-				up_read(&mm->mmap_sem);
-				*nonblocking = 0;
-				return i;
-			}
 		} while (nr_pages && start < vma->vm_end);
 	} while (nr_pages);
 	return i;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time.patch
writeback-avoid-unnecessary-determine_dirtyable_memory-call-fix.patch
thp-pte-alloc-trans-splitting-fix-checkpatch-fixes.patch
thp-kvm-mmu-transparent-hugepage-support-bisection.patch
thp-khugepaged-make-khugepaged-aware-of-madvise-fix.patch
mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration-fix.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common-fix.patch
brk-fix-min_brk-lower-bound-computation-for-compat_brk-fix.patch
mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists-checkpatch-fixes.patch
mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists-fix.patch
mm-dmapoolc-use-task_uninterruptible-in-dma_pool_alloc.patch
hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler-fix.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix.patch
mm-fix-migration-hangs-on-anon_vma-lock-checkpatch-fixes.patch
mm-page_allocc-dont-cache-current-in-a-local.patch
mm-batch-activate_page-to-reduce-lock-contention-checkpatch-fixes.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch

