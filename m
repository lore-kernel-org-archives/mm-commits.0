From: akpm@linux-foundation.org
Subject: + mmmigration-avoid-race-between-shift_arg_pages-and-rmap_walk-during-migration-by-not-migrating-temporary-stacks.patch added to -mm tree
Date: Tue, 11 May 2010 12:29:22 -0700
Message-ID: <201005111929.o4BJTMEZ018662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435Ab0EKTaL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 May 2010 15:30:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, cl@linux.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, peterz@infradead.org, riel@redhat.com, torvalds@linux-foundation.org


The patch titled
     mm: migration: avoid race between shift_arg_pages() and rmap_walk() during migration by not migrating temporary stacks
has been added to the -mm tree.  Its filename is
     mmmigration-avoid-race-between-shift_arg_pages-and-rmap_walk-during-migration-by-not-migrating-temporary-stacks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: migration: avoid race between shift_arg_pages() and rmap_walk() during migration by not migrating temporary stacks
From: Mel Gorman <mel@csn.ul.ie>

Page migration requires rmap to be able to find all ptes mapping a page
at all times, otherwise the migration entry can be instantiated, but it
is possible to leave one behind if the second rmap_walk fails to find
the page.  If this page is later faulted, migration_entry_to_page() will
call BUG because the page is locked indicating the page was migrated by
the migration PTE not cleaned up. For example

[  511.201534] kernel BUG at include/linux/swapops.h:105!
[  511.201534] invalid opcode: 0000 [#1] PREEMPT SMP
[  511.201534] last sysfs file: /sys/block/sde/size
[  511.201534] CPU 0
[  511.201534] Modules linked in: kvm_amd kvm dm_crypt loop i2c_piix4 serio_raw tpm_tis shpchp evdev tpm i2c_core pci_hotplug tpm_bios wmi processor button ext3 jbd mbcache dm_mirror dm_region_hash dm_log dm_snapshot dm_mod raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear md_mod sg sr_mod cdrom sd_mod ata_generic ahci libahci libata ide_pci_generic ehci_hcd ide_core r8169 mii ohci_hcd scsi_mod floppy thermal fan thermal_sys
[  511.888526]
[  511.888526] Pid: 20431, comm: date Not tainted 2.6.34-rc4-mm1-fix-swapops #6 GA-MA790GP-UD4H/GA-MA790GP-UD4H
[  511.888526] RIP: 0010:[<ffffffff811094ff>]  [<ffffffff811094ff>] migration_entry_wait+0xc1/0x129
[  512.173545] RSP: 0018:ffff880037b979d8  EFLAGS: 00010246
[  512.198503] RAX: ffffea0000000000 RBX: ffffea0001a2ba10 RCX: 0000000000029830
[  512.329617] RDX: 0000000001a2ba10 RSI: ffffffff818264b8 RDI: 000000000ef45c3e
[  512.380001] RBP: ffff880037b97a08 R08: ffff880078003f00 R09: ffff880037b979e8
[  512.380001] R10: ffffffff8114ddaa R11: 0000000000000246 R12: 0000000037304000
[  512.380001] R13: ffff88007a9ed5c8 R14: f800000000077a2e R15: 000000000ef45c3e
[  512.380001] FS:  00007f3d346866e0(0000) GS:ffff880002200000(0000) knlGS:0000000000000000
[  512.380001] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  512.380001] CR2: 00007fff6abec9c1 CR3: 0000000037a15000 CR4: 00000000000006f0
[  512.380001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  513.004775] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  513.068415] Process date (pid: 20431, threadinfo ffff880037b96000, task ffff880078003f00)
[  513.068415] Stack:
[  513.068415]  ffff880037b97b98 ffff880037b97a18 ffff880037b97be8 0000000000000c00
[  513.228068] <0> ffff880037304f60 00007fff6abec9c1 ffff880037b97aa8 ffffffff810e951a
[  513.228068] <0> ffff880037b97a88 0000000000000246 0000000000000000 ffffffff8130c5c2
[  513.228068] Call Trace:
[  513.228068]  [<ffffffff810e951a>] handle_mm_fault+0x3f8/0x76a
[  513.228068]  [<ffffffff8130c5c2>] ? do_page_fault+0x26a/0x46e
[  513.228068]  [<ffffffff8130c7a2>] do_page_fault+0x44a/0x46e
[  513.720755]  [<ffffffff8130875d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  513.789278]  [<ffffffff8114ddaa>] ? load_elf_binary+0x14a1/0x192b
[  513.851506]  [<ffffffff813099b5>] page_fault+0x25/0x30
[  513.851506]  [<ffffffff8114ddaa>] ? load_elf_binary+0x14a1/0x192b
[  513.851506]  [<ffffffff811c1e27>] ? strnlen_user+0x3f/0x57
[  513.851506]  [<ffffffff8114de33>] load_elf_binary+0x152a/0x192b
[  513.851506]  [<ffffffff8111329b>] search_binary_handler+0x173/0x313
[  513.851506]  [<ffffffff8114c909>] ? load_elf_binary+0x0/0x192b
[  513.851506]  [<ffffffff81114896>] do_execve+0x219/0x30a
[  513.851506]  [<ffffffff8111887f>] ? getname+0x14d/0x1b3
[  513.851506]  [<ffffffff8100a5c6>] sys_execve+0x43/0x5e
[  514.483501]  [<ffffffff8100320a>] stub_execve+0x6a/0xc0
[  514.548357] Code: 74 05 83 f8 1f 75 68 48 b8 ff ff ff ff ff ff ff 07 48 21 c2 48 b8 00 00 00 00 00 ea ff ff 48 6b d2 38 48 8d 1c 02 f6 03 01 75 04 <0f> 0b eb fe 8b 4b 08 48 8d 73 08 85 c9 74 35 8d 41 01 89 4d e0
[  514.704292] RIP  [<ffffffff811094ff>] migration_entry_wait+0xc1/0x129
[  514.808221]  RSP <ffff880037b979d8>
[  514.906179] ---[ end trace 4f88495edc224d6b ]---

There is a race between shift_arg_pages and migration that triggers this
bug.  A temporary stack is setup during exec and later moved.  If
migration moves a page in the temporary stack and the VMA is then removed
before migration completes, the migration PTE may not be found leading to
a BUG when the stack is faulted.

This patch causes pages within the temporary stack during exec to be
skipped by migration.  It does this by marking the VMA covering the
temporary stack with an otherwise impossible combination of VMA flags. 
These flags are cleared when the temporary stack is moved to its final
location.

[kamezawa.hiroyu@jp.fujitsu.com: idea for having migration skip temporary stacks]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c          |    7 ++++++-
 include/linux/mm.h |    3 +++
 mm/rmap.c          |   30 +++++++++++++++++++++++++++++-
 3 files changed, 38 insertions(+), 2 deletions(-)

diff -puN fs/exec.c~mmmigration-avoid-race-between-shift_arg_pages-and-rmap_walk-during-migration-by-not-migrating-temporary-stacks fs/exec.c
--- a/fs/exec.c~mmmigration-avoid-race-between-shift_arg_pages-and-rmap_walk-during-migration-by-not-migrating-temporary-stacks
+++ a/fs/exec.c
@@ -242,9 +242,10 @@ static int __bprm_mm_init(struct linux_b
 	 * use STACK_TOP because that can depend on attributes which aren't
 	 * configured yet.
 	 */
+	BUG_ON(VM_STACK_FLAGS & VM_STACK_INCOMPLETE_SETUP);
 	vma->vm_end = STACK_TOP_MAX;
 	vma->vm_start = vma->vm_end - PAGE_SIZE;
-	vma->vm_flags = VM_STACK_FLAGS;
+	vma->vm_flags = VM_STACK_FLAGS | VM_STACK_INCOMPLETE_SETUP;
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 	INIT_LIST_HEAD(&vma->anon_vma_chain);
 	err = insert_vm_struct(mm, vma);
@@ -616,6 +617,7 @@ int setup_arg_pages(struct linux_binprm 
 	else if (executable_stack == EXSTACK_DISABLE_X)
 		vm_flags &= ~VM_EXEC;
 	vm_flags |= mm->def_flags;
+	vm_flags |= VM_STACK_INCOMPLETE_SETUP;
 
 	ret = mprotect_fixup(vma, &prev, vma->vm_start, vma->vm_end,
 			vm_flags);
@@ -630,6 +632,9 @@ int setup_arg_pages(struct linux_binprm 
 			goto out_unlock;
 	}
 
+	/* mprotect_fixup is overkill to remove the temporary stack flags */
+	vma->vm_flags &= ~VM_STACK_INCOMPLETE_SETUP;
+
 	stack_expand = 131072UL; /* randomly 32*4k (or 2*64k) pages */
 	stack_size = vma->vm_end - vma->vm_start;
 	/*
diff -puN include/linux/mm.h~mmmigration-avoid-race-between-shift_arg_pages-and-rmap_walk-during-migration-by-not-migrating-temporary-stacks include/linux/mm.h
--- a/include/linux/mm.h~mmmigration-avoid-race-between-shift_arg_pages-and-rmap_walk-during-migration-by-not-migrating-temporary-stacks
+++ a/include/linux/mm.h
@@ -106,6 +106,9 @@ extern unsigned int kobjsize(const void 
 #define VM_PFN_AT_MMAP	0x40000000	/* PFNMAP vma that is fully mapped at mmap time */
 #define VM_MERGEABLE	0x80000000	/* KSM may merge identical pages */
 
+/* Bits set in the VMA until the stack is in its final location */
+#define VM_STACK_INCOMPLETE_SETUP	(VM_RAND_READ | VM_SEQ_READ)
+
 #ifndef VM_STACK_DEFAULT_FLAGS		/* arch can override this */
 #define VM_STACK_DEFAULT_FLAGS VM_DATA_DEFAULT_FLAGS
 #endif
diff -puN mm/rmap.c~mmmigration-avoid-race-between-shift_arg_pages-and-rmap_walk-during-migration-by-not-migrating-temporary-stacks mm/rmap.c
--- a/mm/rmap.c~mmmigration-avoid-race-between-shift_arg_pages-and-rmap_walk-during-migration-by-not-migrating-temporary-stacks
+++ a/mm/rmap.c
@@ -1131,6 +1131,20 @@ static int try_to_unmap_cluster(unsigned
 	return ret;
 }
 
+static bool is_vma_temporary_stack(struct vm_area_struct *vma)
+{
+	int maybe_stack = vma->vm_flags & (VM_GROWSDOWN | VM_GROWSUP);
+
+	if (!maybe_stack)
+		return false;
+
+	if ((vma->vm_flags & VM_STACK_INCOMPLETE_SETUP) ==
+						VM_STACK_INCOMPLETE_SETUP)
+		return true;
+
+	return false;
+}
+
 /**
  * try_to_unmap_anon - unmap or unlock anonymous page using the object-based
  * rmap method
@@ -1159,7 +1173,21 @@ static int try_to_unmap_anon(struct page
 
 	list_for_each_entry(avc, &anon_vma->head, same_anon_vma) {
 		struct vm_area_struct *vma = avc->vma;
-		unsigned long address = vma_address(page, vma);
+		unsigned long address;
+
+		/*
+		 * During exec, a temporary VMA is setup and later moved.
+		 * The VMA is moved under the anon_vma lock but not the
+		 * page tables leading to a race where migration cannot
+		 * find the migration ptes. Rather than increasing the
+		 * locking requirements of exec(), migration skips
+		 * temporary VMAs until after exec() completes.
+		 */
+		if (PAGE_MIGRATION && (flags & TTU_MIGRATION) &&
+				is_vma_temporary_stack(vma))
+			continue;
+
+		address = vma_address(page, vma);
 		if (address == -EFAULT)
 			continue;
 		ret = try_to_unmap_one(page, vma, address, flags);
_

Patches currently in -mm which might be from mel@csn.ul.ie are

hugetlbfs-kill-applications-that-use-map_noreserve-with-sigbus-instead-of-oom-killer.patch
rmap-remove-anon_vma-check-in-page_address_in_vma.patch
linux-next.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mempolicy-remove-redundant-code.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
mmmigration-take-a-reference-to-the-anon_vma-before-migrating.patch
mmmigration-share-the-anon_vma-ref-counts-between-ksm-and-page-migration.patch
mmmigration-do-not-try-to-migrate-unmapped-anonymous-pages.patch
mmmigration-allow-the-migration-of-pageswapcache-pages.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mmmigration-avoid-race-between-shift_arg_pages-and-rmap_walk-during-migration-by-not-migrating-temporary-stacks.patch
mm-export-unusable-free-space-index-via-debugfs.patch
mm-export-fragmentation-index-via-debugfs.patch
mm-move-definition-for-lru-isolation-modes-to-a-header.patch
mmcompaction-memory-compaction-core.patch
mmcompaction-memory-compaction-core-do-not-schedule-work-on-other-cpus-for-compaction.patch
mmcompaction-add-proc-trigger-for-memory-compaction.patch
mmcompaction-add-sys-trigger-for-per-node-memory-compaction.patch
mmcompaction-direct-compact-when-a-high-order-allocation-fails.patch
mmcompaction-direct-compact-when-a-high-order-allocation-fails-fix.patch
mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
mmcompaction-defer-compaction-using-an-exponential-backoff-when-compaction-fails.patch
mm-introduce-free_pages_prepare.patch
mm-introduce-free_pages_prepare-fix.patch
vmscan-fix-unmapping-behaviour-for-reclaim_swap.patch
vmscan-remove-may_unmap-scan-control.patch
vmscan-remove-all_unreclaimable-scan-control.patch
vmscan-remove-isolate_pages-callback-scan-control.patch
vmscan-remove-may_swap-scan-control.patch
ummunotify-userspace-support-for-mmu-notifications-v2.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
numa-add-generic-percpu-var-numa_node_id-implementation.patch
numa-x86_64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-ia64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id.patch
numa-ia64-support-numa_mem_id-for-memoryless-nodes.patch
numa-slab-use-numa_mem_id-for-slab-local-memory-node.patch
numa-in-kernel-profiling-use-cpu_to_mem-for-per-cpu-allocations.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
add-debugging-aid-for-memory-initialisation-problems.patch

