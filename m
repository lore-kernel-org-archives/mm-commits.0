From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-debug-mm-introduce-vm_bug_on_mm-fix-fixpatch.patch removed from -mm tree
Date: Thu, 09 Oct 2014 13:42:48 -0700
Message-ID: <5436f348.uWf1DUfKK+Ues5ZB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35654 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaJIUmt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:42:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, Valdis.Kletnieks@vt.edu, davej@redhat.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, debug: introduce-vm_bug_on_mm-fix-fix.patch
has been removed from the -mm tree.  Its filename was
     mm-debug-mm-introduce-vm_bug_on_mm-fix-fixpatch.patch

This patch was dropped because it was folded into mm-introduce-vm_bug_on_mm.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm, debug: introduce-vm_bug_on_mm-fix-fix.patch

dump_mm will fail to compile if the last config options are not defined.
I have hit the following (trimmed down) while doing randconfig:
mm/debug.c: In function `dump_mm':
mm/debug.c:197:3: error: expected `)' before `mm'
   mm, mm->mmap, mm->vmacache_seqnum, mm->task_size,
   ^
include/linux/printk.h:221:21: note: in definition of macro `pr_fmt'
 #define pr_fmt(fmt) fmt
                     ^
mm/debug.c:169:2: note: in expansion of macro `pr_emerg'
  pr_emerg("mm %p mmap %p seqnum %d task_size %lu\n"

with neither CONFIG_COMPACTION nor CONFIG_NUMA_BALANCING set because
the last format string portion will not have a comma separating other
parameters. There is also a trailing comma at the end of parameters
list.

Fix this by being careful to place commas before mm as the first known
unconditional paramter after formatting patch and also before the last
conditional parameters rather at their end.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/debug.c~mm-debug-mm-introduce-vm_bug_on_mm-fix-fixpatch mm/debug.c
--- a/mm/debug.c~mm-debug-mm-introduce-vm_bug_on_mm-fix-fixpatch
+++ a/mm/debug.c
@@ -195,9 +195,9 @@ void dump_mm(const struct mm_struct *mm)
 		"numa_next_scan %lu numa_scan_offset %lu numa_scan_seq %d\n"
 #endif
 #if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
-		"tlb_flush_pending %d\n",
+		"tlb_flush_pending %d\n"
 #endif
-		mm, mm->mmap, mm->vmacache_seqnum, mm->task_size,
+		, mm, mm->mmap, mm->vmacache_seqnum, mm->task_size,
 #ifdef CONFIG_MMU
 		mm->get_unmapped_area,
 #endif
@@ -218,15 +218,15 @@ void dump_mm(const struct mm_struct *mm)
 #ifdef CONFIG_MEMCG
 		mm->owner,
 #endif
-		mm->exe_file,
+		mm->exe_file
 #ifdef CONFIG_MMU_NOTIFIER
-		mm->mmu_notifier_mm,
+		, mm->mmu_notifier_mm
 #endif
 #ifdef CONFIG_NUMA_BALANCING
-		mm->numa_next_scan, mm->numa_scan_offset, mm->numa_scan_seq,
+		, mm->numa_next_scan, mm->numa_scan_offset, mm->numa_scan_seq
 #endif
 #if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
-		mm->tlb_flush_pending
+		, mm->tlb_flush_pending
 #endif
 		);
 
_

Patches currently in -mm which might be from mhocko@suse.cz are

introduce-dump_vma.patch
introduce-vm_bug_on_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch
mm-introduce-vm_bug_on_mm.patch
mm-debug-mm-introduce-vm_bug_on_mm-fix-fixpatch-fix.patch
memcg-move-memcg_allocfree_cache_params-to-slab_commonc.patch
memcg-dont-call-memcg_update_all_caches-if-new-cache-id-fits.patch
memcg-move-memcg_update_cache_size-to-slab_commonc.patch
mm-memcontrol-do-not-kill-uncharge-batching-in-free_pages_and_swap_cache.patch
mm-memcontrol-do-not-kill-uncharge-batching-in-free_pages_and_swap_cache-fix.patch
mm-memcontrol-simplify-detecting-when-the-memoryswap-limit-is-hit.patch
mm-memcontrol-fix-transparent-huge-page-allocations-under-pressure.patch
memcg-zap-memcg_can_account_kmem.patch

