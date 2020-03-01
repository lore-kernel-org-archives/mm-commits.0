From: akpm@linux-foundation.org
Subject: + mm-swap-annotate-data-races-for-lru_rotate_pvecs.patch
 added to -mm tree
Date: Sat, 29 Feb 2020 20:10:29 -0800
Message-ID: <20200301041029.VF0-V7kUe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726063AbgCAEKa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 29 Feb 2020 23:10:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, elver@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap.c: annotate data races for lru_rotate_pvecs
has been added to the -mm tree.  Its filename is
     mm-swap-annotate-data-races-for-lru_rotate_pvecs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-annotate-data-races-for-lru_rotate_pvecs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-annotate-data-races-for-lru_rotate_pvecs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: mm/swap.c: annotate data races for lru_rotate_pvecs

Read to lru_add_pvec->nr could be interrupted and then write to the same
variable.  The write has local interrupt disabled, but the plain reads
result in data races.  However, it is unlikely the compilers could do much
damage here given that lru_add_pvec->nr is a "unsigned char" and there is
an existing compiler barrier.  Thus, annotate the reads using the
data_race() macro.  The data races were reported by KCSAN,

 BUG: KCSAN: data-race in lru_add_drain_cpu / rotate_reclaimable_page

 write to 0xffff9291ebcb8a40 of 1 bytes by interrupt on cpu 23:
  rotate_reclaimable_page+0x2df/0x490
  pagevec_add at include/linux/pagevec.h:81
  (inlined by) rotate_reclaimable_page at mm/swap.c:259
  end_page_writeback+0x1b5/0x2b0
  end_swap_bio_write+0x1d0/0x280
  bio_endio+0x297/0x560
  dec_pending+0x218/0x430 [dm_mod]
  clone_endio+0xe4/0x2c0 [dm_mod]
  bio_endio+0x297/0x560
  blk_update_request+0x201/0x920
  scsi_end_request+0x6b/0x4a0
  scsi_io_completion+0xb7/0x7e0
  scsi_finish_command+0x1ed/0x2a0
  scsi_softirq_done+0x1c9/0x1d0
  blk_done_softirq+0x181/0x1d0
  __do_softirq+0xd9/0x57c
  irq_exit+0xa2/0xc0
  do_IRQ+0x8b/0x190
  ret_from_intr+0x0/0x42
  delay_tsc+0x46/0x80
  __const_udelay+0x3c/0x40
  __udelay+0x10/0x20
  kcsan_setup_watchpoint+0x202/0x3a0
  __tsan_read1+0xc2/0x100
  lru_add_drain_cpu+0xb8/0x3f0
  lru_add_drain+0x25/0x40
  shrink_active_list+0xe1/0xc80
  shrink_lruvec+0x766/0xb70
  shrink_node+0x2d6/0xca0
  do_try_to_free_pages+0x1f7/0x9a0
  try_to_free_pages+0x252/0x5b0
  __alloc_pages_slowpath+0x458/0x1290
  __alloc_pages_nodemask+0x3bb/0x450
  alloc_pages_vma+0x8a/0x2c0
  do_anonymous_page+0x16e/0x6f0
  __handle_mm_fault+0xcd5/0xd40
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 read to 0xffff9291ebcb8a40 of 1 bytes by task 37761 on cpu 23:
  lru_add_drain_cpu+0xb8/0x3f0
  lru_add_drain_cpu at mm/swap.c:602
  lru_add_drain+0x25/0x40
  shrink_active_list+0xe1/0xc80
  shrink_lruvec+0x766/0xb70
  shrink_node+0x2d6/0xca0
  do_try_to_free_pages+0x1f7/0x9a0
  try_to_free_pages+0x252/0x5b0
  __alloc_pages_slowpath+0x458/0x1290
  __alloc_pages_nodemask+0x3bb/0x450
  alloc_pages_vma+0x8a/0x2c0
  do_anonymous_page+0x16e/0x6f0
  __handle_mm_fault+0xcd5/0xd40
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 2 locks held by oom02/37761:
  #0: ffff9281e5928808 (&mm->mmap_sem#2){++++}, at: do_page_fault
  #1: ffffffffb3ade380 (fs_reclaim){+.+.}, at: fs_reclaim_acquire.part
 irq event stamp: 1949217
 trace_hardirqs_on_thunk+0x1a/0x1c
 __do_softirq+0x2e7/0x57c
 __do_softirq+0x34c/0x57c
 irq_exit+0xa2/0xc0

 Reported by Kernel Concurrency Sanitizer on:
 CPU: 23 PID: 37761 Comm: oom02 Not tainted 5.6.0-rc3-next-20200226+ #6
 Hardware name: HP ProLiant BL660c Gen9, BIOS I38 10/17/2018

Link: http://lkml.kernel.org/r/20200228044018.1263-1-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Acked-by: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/swap.c~mm-swap-annotate-data-races-for-lru_rotate_pvecs
+++ a/mm/swap.c
@@ -599,7 +599,8 @@ void lru_add_drain_cpu(int cpu)
 		__pagevec_lru_add(pvec);
 
 	pvec = &per_cpu(lru_rotate_pvecs, cpu);
-	if (pagevec_count(pvec)) {
+	/* Disabling interrupts below acts as a compiler barrier. */
+	if (data_race(pagevec_count(pvec))) {
 		unsigned long flags;
 
 		/* No harm done if a racing interrupt already did this */
@@ -744,7 +745,7 @@ void lru_add_drain_all(void)
 		struct work_struct *work = &per_cpu(lru_add_drain_work, cpu);
 
 		if (pagevec_count(&per_cpu(lru_add_pvec, cpu)) ||
-		    pagevec_count(&per_cpu(lru_rotate_pvecs, cpu)) ||
+		    data_race(pagevec_count(&per_cpu(lru_rotate_pvecs, cpu))) ||
 		    pagevec_count(&per_cpu(lru_deactivate_file_pvecs, cpu)) ||
 		    pagevec_count(&per_cpu(lru_deactivate_pvecs, cpu)) ||
 		    pagevec_count(&per_cpu(lru_lazyfree_pvecs, cpu)) ||
_

Patches currently in -mm which might be from cai@lca.pw are

mm-swapfile-fix-data-races-in-try_to_unuse.patch
mm-swap-annotate-data-races-for-lru_rotate_pvecs.patch
mm-vmscan-fix-data-races-at-kswapd_classzone_idx.patch
percpu_counter-fix-a-data-race-at-vm_committed_as.patch
mm-frontswap-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races-v2.patch
mm-swap_state-mark-various-intentional-data-races.patch
mm-kmemleak-annotate-various-data-races-obj-ptr.patch
mm-swapfile-fix-and-annotate-various-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races-v2.patch
mm-page_counter-fix-various-data-races-at-memsw.patch
mm-memcontrol-fix-a-data-race-in-scan-count.patch
mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-mempool-fix-a-data-race-in-mempool_free.patch
mm-util-annotate-an-data-race-at-vm_committed_as.patch
mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch
mm-annotate-a-data-race-in-page_zonenum.patch
