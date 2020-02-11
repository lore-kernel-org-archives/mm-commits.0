From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempool-fix-a-data-race-in-mempool_free.patch added
 to -mm tree
Date: Tue, 11 Feb 2020 15:26:42 -0800
Message-ID: <20200211232642.EPnG1MCnj%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727597AbgBKX0p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Feb 2020 18:26:45 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, elver@google.com, mm-commits@vger.kernel.org, oleg@redhat.com, tj@kernel.org


The patch titled
     Subject: mm/mempool: fix a data race in mempool_free()
has been added to the -mm tree.  Its filename is
     mm-mempool-fix-a-data-race-in-mempool_free.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempool-fix-a-data-race-in-mempool_free.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempool-fix-a-data-race-in-mempool_free.patch

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
Subject: mm/mempool: fix a data race in mempool_free()

mempool_t pool.curr_nr could be accessed concurrently as noticed by
KCSAN,

 BUG: KCSAN: data-race in mempool_free / remove_element

 write to 0xffffffffa937638c of 4 bytes by task 6359 on cpu 113:
  remove_element+0x4a/0x1c0
  remove_element at mm/mempool.c:132
  mempool_alloc+0x102/0x210
  (inlined by) mempool_alloc at mm/mempool.c:399
  bio_alloc_bioset+0x106/0x2c0
  get_swap_bio+0x49/0x230
  __swap_writepage+0x680/0xc30
  swap_writepage+0x9c/0xf0
  pageout+0x33e/0xae0
  shrink_page_list+0x1f57/0x2870
  shrink_inactive_list+0x316/0x880
  shrink_lruvec+0x8dc/0x1380
  shrink_node+0x317/0xd80
  do_try_to_free_pages+0x1f7/0xa10
  try_to_free_pages+0x26c/0x5e0
  __alloc_pages_slowpath+0x458/0x1290
  <snip>

 read to 0xffffffffa937638c of 4 bytes by interrupt on cpu 64:
  mempool_free+0x3e/0x150
  mempool_free at mm/mempool.c:492
  bio_free+0x192/0x280
  bio_put+0x91/0xd0
  end_swap_bio_write+0x1d8/0x280
  bio_endio+0x2c2/0x5b0
  dec_pending+0x22b/0x440 [dm_mod]
  clone_endio+0xe4/0x2c0 [dm_mod]
  bio_endio+0x2c2/0x5b0
  blk_update_request+0x217/0x940
  scsi_end_request+0x6b/0x4d0
  scsi_io_completion+0xb7/0x7e0
  scsi_finish_command+0x223/0x310
  scsi_softirq_done+0x1d5/0x210
  blk_mq_complete_request+0x224/0x250
  scsi_mq_done+0xc2/0x250
  pqi_raid_io_complete+0x5a/0x70 [smartpqi]
  pqi_irq_handler+0x150/0x1410 [smartpqi]
  __handle_irq_event_percpu+0x90/0x540
  handle_irq_event_percpu+0x49/0xd0
  handle_irq_event+0x85/0xca
  handle_edge_irq+0x13f/0x3e0
  do_IRQ+0x86/0x190
  <snip>

Since the write is under pool->lock but the read is done as lockless.
Even though the commit 5b990546e334 ("mempool: fix and document
synchronization and memory barrier usage") introduced the smp_wmb() and
smp_rmb() pair to improve the situation, it is adequate to protect it
from data races which could lead to a logic bug, so fix it by adding
READ_ONCE() for the read.

Link: http://lkml.kernel.org/r/1581446384-2131-1-git-send-email-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Cc: Marco Elver <elver@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempool.c~mm-mempool-fix-a-data-race-in-mempool_free
+++ a/mm/mempool.c
@@ -489,7 +489,7 @@ void mempool_free(void *element, mempool
 	 * ensures that there will be frees which return elements to the
 	 * pool waking up the waiters.
 	 */
-	if (unlikely(pool->curr_nr < pool->min_nr)) {
+	if (unlikely(READ_ONCE(pool->curr_nr) < pool->min_nr)) {
 		spin_lock_irqsave(&pool->lock, flags);
 		if (likely(pool->curr_nr < pool->min_nr)) {
 			add_element(pool, element);
_

Patches currently in -mm which might be from cai@lca.pw are

mm-swapfile-fix-and-annotate-various-data-races.patch
mm-memcontrol-fix-a-data-race-in-scan-count.patch
mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-mempool-fix-a-data-race-in-mempool_free.patch
mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch
mm-frontswap-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races.patch
mm-swap_state-mark-various-intentional-data-races.patch
