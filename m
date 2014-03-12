From: akpm@linux-foundation.org
Subject: +
 mm-numa-recheck-for-transhuge-pages-under-lock-during-protection-changes.patch added to -mm tree
Date: Wed, 12 Mar 2014 13:02:20 -0700
Message-ID: <5320bd4c.kOtZSGpBfGylSCuS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaCLUCW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Mar 2014 16:02:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, riel@redhat.com, mgorman@suse.de

Subject: + mm-numa-recheck-for-transhuge-pages-under-lock-during-protection-changes.patch added to -mm tree
To: mgorman@suse.de,riel@redhat.com,sasha.levin@oracle.com
From: akpm@linux-foundation.org
Date: Wed, 12 Mar 2014 13:02:20 -0700


The patch titled
     Subject: mm: numa: recheck for transhuge pages under lock during protection changes
has been added to the -mm tree.  Its filename is
     mm-numa-recheck-for-transhuge-pages-under-lock-during-protection-changes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-numa-recheck-for-transhuge-pages-under-lock-during-protection-changes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-numa-recheck-for-transhuge-pages-under-lock-during-protection-changes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: numa: recheck for transhuge pages under lock during protection changes

Sasha reported the following bug using trinity

[  886.745765] kernel BUG at mm/mprotect.c:149!
[  886.746831] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  886.748511] Dumping ftrace buffer:
[  886.749998]    (ftrace buffer empty)
[  886.750110] Modules linked in:
[  886.751396] CPU: 20 PID: 26219 Comm: trinity-c216 Tainted: G        W    3.14.0-rc5-next-20140305-sasha-00011-ge06f5f3-dirty #105
[  886.751396] task: ffff8800b6c80000 ti: ffff880228436000 task.ti: ffff880228436000
[  886.751396] RIP: 0010:[<ffffffff812aab33>]  [<ffffffff812aab33>] change_protection_range+0x3b3/0x500
[  886.751396] RSP: 0000:ffff880228437da8  EFLAGS: 00010282
[  886.751396] RAX: 8000000527c008e5 RBX: 00007f647916e000 RCX: 0000000000000000
[  886.751396] RDX: ffff8802ef488e40 RSI: 00007f6479000000 RDI: 8000000527c008e5
[  886.751396] RBP: ffff880228437e78 R08: 0000000000000000 R09: 0000000000000000
[  886.751396] R10: 0000000000000001 R11: 0000000000000000 R12: ffff8802ef488e40
[  886.751396] R13: 00007f6479000000 R14: 00007f647916e000 R15: 00007f646e34e000
[  886.751396] FS:  00007f64b28d4700(0000) GS:ffff88052ba00000(0000) knlGS:0000000000000000
[  886.751396] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  886.751396] CR2: 00007f64aed83af8 CR3: 0000000206e52000 CR4: 00000000000006a0
[  886.751396] Stack:
[  886.751396]  ffff880200000001 ffffffff8447f152 ffff880228437dd8 ffff880228af3000
[  886.769142]  00007f646e34e000 00007f647916dfff 0000000000000000 00007f647916e000
[  886.769142]  ffff880206e527f0 00007f647916dfff 0000000000000000 0000000000000000
[  886.769142] Call Trace:
[  886.769142]  [<ffffffff8447f152>] ? preempt_count_sub+0xe2/0x120
[  886.769142]  [<ffffffff812aaca5>] change_protection+0x25/0x30
[  886.769142]  [<ffffffff812c3eeb>] change_prot_numa+0x1b/0x30
[  886.769142]  [<ffffffff8118df49>] task_numa_work+0x279/0x360
[  886.769142]  [<ffffffff8116c57e>] task_work_run+0xae/0xf0
[  886.769142]  [<ffffffff8106ffbe>] do_notify_resume+0x8e/0xe0
[  886.769142]  [<ffffffff8447a93b>] retint_signal+0x4d/0x92
[  886.769142] Code: 49 8b 3c 24 48 83 3d fc 2e ba 04 00 75 12 0f 0b 0f 1f 84 00 00 00 00 00 eb fe 66 0f 1f 44 00 00 48 89 f8 66 66 66 90 84 c0 79 0d <0f> 0b 0f 1f 00 eb fe 66 0f 1f 44 00 00 8b 4d 9c 44 8b 4d 98
+89
[  886.769142] RIP  [<ffffffff812aab33>] change_protection_range+0x3b3/0x500
[  886.769142]  RSP <ffff880228437da8>

The VM_BUG_ON was added by the patch "mm,numa: reorganize
change_pmd_range". The race existed without the patch but was just harder
to hit.

The problem is that a transhuge check is made without holding the PTL. 
It's possible at the time of the check that a parallel fault clears the
pmd and inserts a new one which then triggers the VM_BUG_ON check.  This
patch removes the VM_BUG_ON but fixes the race by rechecking transhuge
under the PTL when marking page tables for NUMA hinting and bailing if a
race occurred.  It is not a problem for calls to mprotect() as they hold
mmap_sem for write.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN mm/mprotect.c~mm-numa-recheck-for-transhuge-pages-under-lock-during-protection-changes mm/mprotect.c
--- a/mm/mprotect.c~mm-numa-recheck-for-transhuge-pages-under-lock-during-protection-changes
+++ a/mm/mprotect.c
@@ -46,6 +46,17 @@ static unsigned long change_pte_range(st
 	unsigned long pages = 0;
 
 	pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+
+	/*
+	 * For a prot_numa update we only hold mmap_sem for read so there is a
+	 * potential race with faulting where a pmd was temporarily none so
+	 * recheck it under the lock and bail if we race
+	 */
+	if (prot_numa && unlikely(pmd_trans_huge(*pmd))) {
+		pte_unmap_unlock(pte, ptl);
+		return 0;
+	}
+
 	arch_enter_lazy_mmu_mode();
 	do {
 		oldpte = *pte;
@@ -132,12 +143,13 @@ static inline unsigned long change_pmd_r
 						pages += HPAGE_PMD_NR;
 						nr_huge_updates++;
 					}
+
+					/* huge pmd was handled */
 					continue;
 				}
 			}
 			/* fall through, the trans huge pmd just split */
 		}
-		VM_BUG_ON(pmd_trans_huge(*pmd));
 		this_pages = change_pte_range(vma, pmd, addr, next, newprot,
 				 dirty_accountable, prot_numa);
 		pages += this_pages;
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
mm-optimize-put_mems_allowed-usage.patch
mm-vmstat-fix-up-zone-state-accounting.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
lib-radix_tree-tree-node-interface.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-compaction-avoid-isolating-pinned-pages.patch
mm-rename-__do_fault-do_fault.patch
mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function.patch
mm-introduce-do_read_fault.patch
mm-introduce-do_cow_fault.patch
mm-introduce-do_shared_fault-and-drop-do_fault.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite-fix.patch
mm-consolidate-code-to-setup-pte.patch
mm-numa-recheck-for-transhuge-pages-under-lock-during-protection-changes.patch
mm-vmscan-restore-sc-gfp_mask-after-promoting-it-to-__gfp_highmem.patch
mm-vmscan-do-not-check-compaction_ready-on-promoted-zones.patch
mm-exclude-memory-less-nodes-from-zone_reclaim.patch
mm-compaction-disallow-high-order-page-for-migration-target.patch
mm-compaction-do-not-call-suitable_migration_target-on-every-page.patch
mm-compaction-change-the-timing-to-check-to-drop-the-spinlock.patch
mm-compaction-check-pageblock-suitability-once-per-pageblock.patch
mm-compaction-clean-up-code-on-success-of-ballon-isolation.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags-ignore-madv_hugepage-on-s390-to-prevent-sigsegv-in-qemu.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
mm-introduce-vm_ops-map_pages.patch
mm-implement-map_pages-for-page-cache.patch
mm-cleanup-size-checks-in-filemap_fault-and-filemap_map_pages.patch
mm-add-debugfs-tunable-for-fault_around_order.patch
fork-collapse-copy_flags-into-copy_process.patch
mm-mempolicy-rename-slab_node-for-clarity.patch
mm-mempolicy-remove-per-process-flag.patch
res_counter-remove-interface-for-locked-charging-and-uncharging.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-compaction-determine-isolation-mode-only-once.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

