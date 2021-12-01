Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89190C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  1 Dec 2021 02:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346232AbhLACtC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 Nov 2021 21:49:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346231AbhLACtB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Nov 2021 21:49:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70787C061574
        for <mm-commits@vger.kernel.org>; Tue, 30 Nov 2021 18:45:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2864BB81DD4
        for <mm-commits@vger.kernel.org>; Wed,  1 Dec 2021 02:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF07C53FCB;
        Wed,  1 Dec 2021 02:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638326738;
        bh=CizShluJbjpwO48pRjtahbF50xK6WLfNU+qSSCx95v8=;
        h=Date:From:To:Subject:From;
        b=zKvXEaDzUiBxPddo/zO5kEVH6aQbnIpItvJugDfgtmlqSOgpxE7InK4WnGnGBSLle
         bnEF0srvraAiWk/sVulP6u0Tg0n7e3k99G7zs51mpDoO5A23Y4nVrS2MfLrAqEbRKL
         M8Ou5gUYdE7tJHn5Y2e3wTbKKeW+OT3GgjfGiifw=
Date:   Tue, 30 Nov 2021 18:45:37 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, dave.hansen@linux.intel.com, elver@google.com,
        luto@kernel.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, namit@vmware.com, will@kernel.org,
        ying.huang@intel.com, yuzhao@google.com
Subject:  + mm-rmap-fix-potential-batched-tlb-flush-race.patch
 added to -mm tree
Message-ID: <20211201024537.OnmI9nW05%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: fix potential batched TLB flush race
has been added to the -mm tree.  Its filename is
     mm-rmap-fix-potential-batched-tlb-flush-race.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-fix-potential-batched-tlb-flush-race.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-fix-potential-batched-tlb-flush-race.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm/rmap: fix potential batched TLB flush race

In theory, the following race is possible for batched TLB flushing.

CPU0                               CPU1
----                               ----
shrink_page_list()
                                   unmap
                                     zap_pte_range()
                                       flush_tlb_batched_pending()
                                         flush_tlb_mm()
  try_to_unmap()
    set_tlb_ubc_flush_pending()
      mm->tlb_flush_batched = true
                                         mm->tlb_flush_batched = false

After the TLB is flushed on CPU1 via flush_tlb_mm() and before
mm->tlb_flush_batched is set to false, some PTE is unmapped on CPU0
and the TLB flushing is pended.  Then the pended TLB flushing will be
lost.  Although both set_tlb_ubc_flush_pending() and
flush_tlb_batched_pending() are called with PTL locked, different PTL
instances may be used.

Because the race window is really small, and the lost TLB flushing
will cause problem only if a TLB entry is inserted before the
unmapping in the race window, the race is only theoretical.  But the
fix is simple and cheap too.

Syzbot has reported this too as follows,

==================================================================
BUG: KCSAN: data-race in flush_tlb_batched_pending / try_to_unmap_one

write to 0xffff8881072cfbbc of 1 bytes by task 17406 on cpu 1:
 flush_tlb_batched_pending+0x5f/0x80 mm/rmap.c:691
 madvise_free_pte_range+0xee/0x7d0 mm/madvise.c:594
 walk_pmd_range mm/pagewalk.c:128 [inline]
 walk_pud_range mm/pagewalk.c:205 [inline]
 walk_p4d_range mm/pagewalk.c:240 [inline]
 walk_pgd_range mm/pagewalk.c:277 [inline]
 __walk_page_range+0x981/0x1160 mm/pagewalk.c:379
 walk_page_range+0x131/0x300 mm/pagewalk.c:475
 madvise_free_single_vma mm/madvise.c:734 [inline]
 madvise_dontneed_free mm/madvise.c:822 [inline]
 madvise_vma mm/madvise.c:996 [inline]
 do_madvise+0xe4a/0x1140 mm/madvise.c:1202
 __do_sys_madvise mm/madvise.c:1228 [inline]
 __se_sys_madvise mm/madvise.c:1226 [inline]
 __x64_sys_madvise+0x5d/0x70 mm/madvise.c:1226
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

write to 0xffff8881072cfbbc of 1 bytes by task 71 on cpu 0:
 set_tlb_ubc_flush_pending mm/rmap.c:636 [inline]
 try_to_unmap_one+0x60e/0x1220 mm/rmap.c:1515
 rmap_walk_anon+0x2fb/0x470 mm/rmap.c:2301
 try_to_unmap+0xec/0x110
 shrink_page_list+0xe91/0x2620 mm/vmscan.c:1719
 shrink_inactive_list+0x3fb/0x730 mm/vmscan.c:2394
 shrink_list mm/vmscan.c:2621 [inline]
 shrink_lruvec+0x3c9/0x710 mm/vmscan.c:2940
 shrink_node_memcgs+0x23e/0x410 mm/vmscan.c:3129
 shrink_node+0x8f6/0x1190 mm/vmscan.c:3252
 kswapd_shrink_node mm/vmscan.c:4022 [inline]
 balance_pgdat+0x702/0xd30 mm/vmscan.c:4213
 kswapd+0x200/0x340 mm/vmscan.c:4473
 kthread+0x2c7/0x2e0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30

value changed: 0x01 -> 0x00

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 71 Comm: kswapd0 Not tainted 5.16.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
==================================================================

Link: https://lkml.kernel.org/r/20211201021104.126469-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reported-by: syzbot+aa5bebed695edaccf0df@syzkaller.appspotmail.com
Cc: Nadav Amit <namit@vmware.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    2 -
 mm/rmap.c                |   44 +++++++++++++++++++++++++++++++------
 2 files changed, 38 insertions(+), 8 deletions(-)

--- a/include/linux/mm_types.h~mm-rmap-fix-potential-batched-tlb-flush-race
+++ a/include/linux/mm_types.h
@@ -647,7 +647,7 @@ struct mm_struct {
 		atomic_t tlb_flush_pending;
 #ifdef CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
 		/* See flush_tlb_batched_pending() */
-		bool tlb_flush_batched;
+		atomic_t tlb_flush_batched;
 #endif
 		struct uprobes_state uprobes_state;
 #ifdef CONFIG_PREEMPT_RT
--- a/mm/rmap.c~mm-rmap-fix-potential-batched-tlb-flush-race
+++ a/mm/rmap.c
@@ -621,9 +621,20 @@ void try_to_unmap_flush_dirty(void)
 		try_to_unmap_flush();
 }
 
+/*
+ * The 0-14 bit of mm->tlb_flush_batched records pending generations,
+ * and the 16-30 bit records flushed generations.
+ */
+#define TLB_FLUSH_BATCH_FLUSHED_SHIFT	16
+#define TLB_FLUSH_BATCH_PENDING_MASK			\
+	((1 << (TLB_FLUSH_BATCH_FLUSHED_SHIFT - 1)) - 1)
+#define TLB_FLUSH_BATCH_PENDING_LARGE			\
+	(TLB_FLUSH_BATCH_PENDING_MASK / 2)
+
 static void set_tlb_ubc_flush_pending(struct mm_struct *mm, bool writable)
 {
 	struct tlbflush_unmap_batch *tlb_ubc = &current->tlb_ubc;
+	int batch, nbatch;
 
 	arch_tlbbatch_add_mm(&tlb_ubc->arch, mm);
 	tlb_ubc->flush_required = true;
@@ -633,7 +644,22 @@ static void set_tlb_ubc_flush_pending(st
 	 * before the PTE is cleared.
 	 */
 	barrier();
-	mm->tlb_flush_batched = true;
+	batch = atomic_read(&mm->tlb_flush_batched);
+retry:
+	if ((batch & TLB_FLUSH_BATCH_PENDING_MASK) > TLB_FLUSH_BATCH_PENDING_LARGE) {
+		/*
+		 * To avoid ""pending"" to catch up with ""flushed""
+		 * because of overflow.  Reset "pending" and "flushed"
+		 * to be "1" and "0" if "pending" becomes large.
+		 */
+		nbatch = atomic_cmpxchg(&mm->tlb_flush_batched, batch, 1);
+		if (nbatch != batch) {
+			batch = nbatch;
+			goto retry;
+		}
+	} else {
+		atomic_inc(&mm->tlb_flush_batched);
+	}
 
 	/*
 	 * If the PTE was dirty then it's best to assume it's writable. The
@@ -680,15 +706,19 @@ static bool should_defer_flush(struct mm
  */
 void flush_tlb_batched_pending(struct mm_struct *mm)
 {
-	if (data_race(mm->tlb_flush_batched)) {
-		flush_tlb_mm(mm);
+	int batch = atomic_read(&mm->tlb_flush_batched);
+	int pending = batch & TLB_FLUSH_BATCH_PENDING_MASK;
+	int flushed = batch >> TLB_FLUSH_BATCH_FLUSHED_SHIFT;
 
+	if (pending != flushed) {
+		flush_tlb_mm(mm);
 		/*
-		 * Do not allow the compiler to re-order the clearing of
-		 * tlb_flush_batched before the tlb is flushed.
+		 * If the new TLB flushing is pended during flushing,
+		 * leave mm->tlb_flush_batched as is, to avoid to lose
+		 * flushing.
 		 */
-		barrier();
-		mm->tlb_flush_batched = false;
+		atomic_cmpxchg(&mm->tlb_flush_batched, batch,
+			       pending | (pending << TLB_FLUSH_BATCH_FLUSHED_SHIFT));
 	}
 }
 #else
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-rmap-fix-potential-batched-tlb-flush-race.patch

