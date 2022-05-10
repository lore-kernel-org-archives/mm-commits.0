Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 645BCC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235272AbiEJEQ7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235997AbiEJEQY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:16:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50613F88B
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3261C615E8
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C92BC385A6;
        Tue, 10 May 2022 04:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155910;
        bh=xh3F/vM33KW2L4qi4Jxe71zycDaNjrqgyjoP0+egdb0=;
        h=Date:To:From:Subject:From;
        b=nm6omAVZmTSUVVgrzEpDEzaaYLyBMYPprRSpqf2lUVP1gvXorLWyD+3oirx7v3gI0
         rQG/HrKkUWeiaXvtdKrRgxSCnbfoQxVIg7YPTPQ0sq/xdSw7OlHTxo90CLxAWipLZ3
         Ho4LERqiS1q8NvodBC6LQe4FK81GUTRyCArwCMXk=
Date:   Mon, 09 May 2022 21:11:49 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, peterz@infradead.org,
        npiggin@gmail.com, wangjianxing@loongson.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmu_gather-limit-free-batch-count-and-add-schedule-point-in-tlb_batch_pages_flush.patch removed from -mm tree
Message-Id: <20220510041150.8C92BC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmu_gather: limit free batch count and add schedule point in tlb_batch_pages_flush
has been removed from the -mm tree.  Its filename was
     mm-mmu_gather-limit-free-batch-count-and-add-schedule-point-in-tlb_batch_pages_flush.patch

This patch was dropped because it was merged into mm-stable

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


