From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch
 added to -mm tree
Date: Tue, 11 Feb 2020 15:23:07 -0800
Message-ID: <20200211232307.QO5-eT8SN%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727786AbgBKXXI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Feb 2020 18:23:08 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, elver@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: annotate a data race at tlb_flush_batched
has been added to the -mm tree.  Its filename is
     mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch

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
Subject: mm/rmap: annotate a data race at tlb_flush_batched

mm->tlb_flush_batched could be accessed concurrently as noticed by
KCSAN,

 BUG: KCSAN: data-race in flush_tlb_batched_pending / try_to_unmap_one

 write to 0xffff93f754880bd0 of 1 bytes by task 822 on cpu 6:
  try_to_unmap_one+0x59a/0x1ab0
  set_tlb_ubc_flush_pending at mm/rmap.c:635
  (inlined by) try_to_unmap_one at mm/rmap.c:1538
  rmap_walk_anon+0x296/0x650
  rmap_walk+0xdf/0x100
  try_to_unmap+0x18a/0x2f0
  shrink_page_list+0xef6/0x2870
  shrink_inactive_list+0x316/0x880
  shrink_lruvec+0x8dc/0x1380
  shrink_node+0x317/0xd80
  balance_pgdat+0x652/0xd90
  kswapd+0x396/0x8d0
  kthread+0x1e0/0x200
  ret_from_fork+0x27/0x50

 read to 0xffff93f754880bd0 of 1 bytes by task 6364 on cpu 4:
  flush_tlb_batched_pending+0x29/0x90
  flush_tlb_batched_pending at mm/rmap.c:682
  change_p4d_range+0x5dd/0x1030
  change_pte_range at mm/mprotect.c:44
  (inlined by) change_pmd_range at mm/mprotect.c:212
  (inlined by) change_pud_range at mm/mprotect.c:240
  (inlined by) change_p4d_range at mm/mprotect.c:260
  change_protection+0x222/0x310
  change_prot_numa+0x3e/0x60
  task_numa_work+0x219/0x350
  task_work_run+0xed/0x140
  prepare_exit_to_usermode+0x2cc/0x2e0
  ret_from_intr+0x32/0x42

 Reported by Kernel Concurrency Sanitizer on:
 CPU: 4 PID: 6364 Comm: mtest01 Tainted: G        W    L 5.5.0-next-20200210+ #5
 Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 07/10/2019

flush_tlb_batched_pending() is under PTL but the write is not, but
mm->tlb_flush_batched is only a bool type, so the value is unlikely to be
shattered.  Thus, mark it as an intentional data race by using the data
race macro.

Link: http://lkml.kernel.org/r/1581450783-8262-1-git-send-email-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-annotate-a-data-race-at-tlb_flush_batched
+++ a/mm/rmap.c
@@ -666,7 +666,7 @@ static bool should_defer_flush(struct mm
  */
 void flush_tlb_batched_pending(struct mm_struct *mm)
 {
-	if (mm->tlb_flush_batched) {
+	if (data_race(mm->tlb_flush_batched)) {
 		flush_tlb_mm(mm);
 
 		/*
_

Patches currently in -mm which might be from cai@lca.pw are

mm-swapfile-fix-and-annotate-various-data-races.patch
mm-memcontrol-fix-a-data-race-in-scan-count.patch
mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch
mm-frontswap-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races.patch
mm-swap_state-mark-various-intentional-data-races.patch
