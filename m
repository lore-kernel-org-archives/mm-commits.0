Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE7E2C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 23:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiC1XJW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 19:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiC1XJT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 19:09:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D745A60C2
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 16:07:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F9FDB812A3
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 23:07:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD56C340EC;
        Mon, 28 Mar 2022 23:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648508853;
        bh=ZKAO+7UMphgfUoE3b587u65I4WGnKKmQl/RBz70Hp/o=;
        h=Date:To:From:Subject:From;
        b=yZeEWWJq0C/45+tL6gpScT3SZhX4L9em9KSgVeQ/Q4C43Isd1wk3liCwnzAwN9olR
         Xwh5gjBtsnEOFCKDserxa1dKQIVzgpU0g2cpyctF7HnN3Ys4dhzAbK1J8/r2mRepRk
         CZ9xbVRSf7G/wh/SqKHEbIO4N+UECnwu6fvNQZ9M=
Date:   Mon, 28 Mar 2022 16:07:33 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, peterz@infradead.org,
        npiggin@gmail.com, wangjianxing@loongson.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmu_gather-limit-free-batch-count-and-add-schedule-point-in-tlb_batch_pages_flush.patch added to -mm tree
Message-Id: <20220328230733.CAD56C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmu_gather: limit free batch count and add schedule point in tlb_batch_pages_flush
has been added to the -mm tree.  Its filename is
     mm-mmu_gather-limit-free-batch-count-and-add-schedule-point-in-tlb_batch_pages_flush.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmu_gather-limit-free-batch-count-and-add-schedule-point-in-tlb_batch_pages_flush.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmu_gather-limit-free-batch-count-and-add-schedule-point-in-tlb_batch_pages_flush.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jianxing Wang <wangjianxing@loongson.cn>
Subject: mm/mmu_gather: limit free batch count and add schedule point in tlb_batch_pages_flush

free a large list of pages maybe cause rcu_sched starved on
non-preemptible kernels.  howerver free_unref_page_list maybe can't
cond_resched as it maybe called in interrupt or atomic context, especially
can't detect atomic context in CONFIG_PREEMPTION=n.

The issue is detected in guest with kvm cpu 200% overcommit, however I
didn't see the warning in the host with the same application.  I'm sure
that the patch is needed for guest kernel, but no sure for host.

To reproduce, set up two virtual machines in one host machine, per vm has
the same number cpu and half memory of host.  the run ltpstress.sh in per
vm, then will see rcu stall warning.kernel is preempt disabled, append
kernel command 'preempt=none' if enable dynamic preempt .  It could
detected in loongson machine(32 core, 128G mem) and ProLiant DL380
Gen9(x86 E5-2680, 28 core, 64G mem)

tlb flush batch count depends on PAGE_SIZE, it's too large if PAGE_SIZE >
4K, here limit free batch count with 512.  And add schedule point in
tlb_batch_pages_flush.

rcu: rcu_sched kthread starved for 5359 jiffies! g454793 f0x0
RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=19
[...]
Call Trace:
   free_unref_page_list+0x19c/0x270
   release_pages+0x3cc/0x498
   tlb_flush_mmu_free+0x44/0x70
   zap_pte_range+0x450/0x738
   unmap_page_range+0x108/0x240
   unmap_vmas+0x74/0xf0
   unmap_region+0xb0/0x120
   do_munmap+0x264/0x438
   vm_munmap+0x58/0xa0
   sys_munmap+0x10/0x20
   syscall_common+0x24/0x38

Link: https://lkml.kernel.org/r/20220317072857.2635262-1-wangjianxing@loongson.cn
Signed-off-by: Jianxing Wang <wangjianxing@loongson.cn>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_gather.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/mm/mmu_gather.c~mm-mmu_gather-limit-free-batch-count-and-add-schedule-point-in-tlb_batch_pages_flush
+++ a/mm/mmu_gather.c
@@ -47,8 +47,20 @@ static void tlb_batch_pages_flush(struct
 	struct mmu_gather_batch *batch;
 
 	for (batch = &tlb->local; batch && batch->nr; batch = batch->next) {
-		free_pages_and_swap_cache(batch->pages, batch->nr);
-		batch->nr = 0;
+		struct page **pages = batch->pages;
+
+		do {
+			/*
+			 * limit free batch count when PAGE_SIZE > 4K
+			 */
+			unsigned int nr = min(512U, batch->nr);
+
+			free_pages_and_swap_cache(pages, nr);
+			pages += nr;
+			batch->nr -= nr;
+
+			cond_resched();
+		} while (batch->nr);
 	}
 	tlb->active = &tlb->local;
 }
_

Patches currently in -mm which might be from wangjianxing@loongson.cn are

mm-mmu_gather-limit-free-batch-count-and-add-schedule-point-in-tlb_batch_pages_flush.patch

