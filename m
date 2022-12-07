Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B58B7C4708D
	for <mm-commits@archiver.kernel.org>; Wed,  7 Dec 2022 22:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiLGWSU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Dec 2022 17:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiLGWST (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Dec 2022 17:18:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C7C62E94
        for <mm-commits@vger.kernel.org>; Wed,  7 Dec 2022 14:18:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E91AB820EA
        for <mm-commits@vger.kernel.org>; Wed,  7 Dec 2022 22:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311C9C433D6;
        Wed,  7 Dec 2022 22:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670451496;
        bh=5z1vQmFKTtpins0FVYYc4JNftnqdxU66+sstszzU7OY=;
        h=Date:To:From:Subject:From;
        b=B5a/1MaM8wAkPt6c/p+L0jpNLa4+iBkT2EnXg+pO9d4G7o8aDWZzqeI8PfjSu14+E
         0HYisitmjbeiJaVqoiEsBO15d7K5agli4EkQKptsni5KWiryyGUDEC1Xyn3Dm21+qS
         iEMLyWhSiEVAWal4JbwSaj7U1LrpbfTYBGKPUQ6g=
Date:   Wed, 07 Dec 2022 14:18:15 -0800
To:     mm-commits@vger.kernel.org, zhengjun.xing@linux.intel.com,
        yujie.liu@intel.com, ying.huang@intel.com, nadav.amit@gmail.com,
        hughd@google.com, hannes@cmpxchg.org, fengwei.yin@intel.com,
        feng.tang@intel.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmu_gather-allow-more-than-one-batch-of-delayed-rmaps.patch added to mm-unstable branch
Message-Id: <20221207221816.311C9C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mmu_gather: allow more than one batch of delayed rmaps
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmu_gather-allow-more-than-one-batch-of-delayed-rmaps.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmu_gather-allow-more-than-one-batch-of-delayed-rmaps.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: mm: mmu_gather: allow more than one batch of delayed rmaps
Date: Tue, 6 Dec 2022 11:15:09 -0800

Commit 5df397dec7c4 ("mm: delay page_remove_rmap() until after the TLB has
been flushed") limited the page batching for the mmu gather operation when
a dirty shared page needed to delay rmap removal until after the TLB had
been flushed.

It did so because it needs to walk that array of pages while still holding
the page table lock, and our mmu_gather infrastructure allows for batching
quite a lot of pages.  We may have thousands on pages queued up for
freeing, and we wanted to walk only the last batch if we then added a
dirty page to the queue.

However, when I limited it to one batch, I didn't think of the degenerate
case of the special first batch that is embedded on-stack in the
mmu_gather structure (called "local") and that only has eight entries.

So with the right pattern, that "limit delayed rmap to just one batch"
will trigger over and over in that first small batch, and we'll waste a
lot of time flushing TLB's every eight pages.

And those right patterns are trivially triggered by just having a shared
mappings with lots of adjacent dirty pages.  Like the 'page_fault3'
subtest of the 'will-it-scale' benchmark, that just maps a shared area,
dirties all pages, and unmaps it.  Rinse and repeat.

We still want to limit the batching, but to fix this (easily triggered)
degenerate case, just expand the "only one batch" logic to instead be
"only one batch that isn't the special first on-stack ('local') batch".

That way, when we need to flush the delayed rmaps, we can still limit our
walk to just the last batch - and that first small one.

Link: https://lkml.kernel.org/r/CAHk-=whkL5aM1fR7kYUmhHQHBcMUc-bDoFP7EwYjTxy64DGtvw@mail.gmail.com
Fixes: 5df397dec7c4 ("mm: delay page_remove_rmap() until after the TLB has been flushed")
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: kernel test robot <yujie.liu@intel.com>
  Link: https://lore.kernel.org/oe-lkp/202212051534.852804af-yujie.liu@intel.com
Tested-by: Huang, Ying <ying.huang@intel.com>
Tested-by: Hugh Dickins <hughd@google.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Cc: "Yin, Fengwei" <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mmu_gather.c~mm-mmu_gather-allow-more-than-one-batch-of-delayed-rmaps
+++ a/mm/mmu_gather.c
@@ -19,8 +19,8 @@ static bool tlb_next_batch(struct mmu_ga
 {
 	struct mmu_gather_batch *batch;
 
-	/* No more batching if we have delayed rmaps pending */
-	if (tlb->delayed_rmap)
+	/* Limit batching if we have delayed rmaps pending */
+	if (tlb->delayed_rmap && tlb->active != &tlb->local)
 		return false;
 
 	batch = tlb->active;
@@ -48,31 +48,35 @@ static bool tlb_next_batch(struct mmu_ga
 }
 
 #ifdef CONFIG_SMP
+static void tlb_flush_rmap_batch(struct mmu_gather_batch *batch, struct vm_area_struct *vma)
+{
+	for (int i = 0; i < batch->nr; i++) {
+		struct encoded_page *enc = batch->encoded_pages[i];
+
+		if (encoded_page_flags(enc)) {
+			struct page *page = encoded_page_ptr(enc);
+			page_remove_rmap(page, vma, false);
+		}
+	}
+}
+
 /**
  * tlb_flush_rmaps - do pending rmap removals after we have flushed the TLB
  * @tlb: the current mmu_gather
  *
  * Note that because of how tlb_next_batch() above works, we will
- * never start new batches with pending delayed rmaps, so we only
- * need to walk through the current active batch.
+ * never start multiple new batches with pending delayed rmaps, so
+ * we only need to walk through the current active batch and the
+ * original local one.
  */
 void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma)
 {
-	struct mmu_gather_batch *batch;
-
 	if (!tlb->delayed_rmap)
 		return;
 
-	batch = tlb->active;
-	for (int i = 0; i < batch->nr; i++) {
-		struct encoded_page *enc = batch->encoded_pages[i];
-
-		if (encoded_page_flags(enc)) {
-			struct page *page = encoded_page_ptr(enc);
-			page_remove_rmap(page, vma, false);
-		}
-	}
-
+	tlb_flush_rmap_batch(&tlb->local, vma);
+	if (tlb->active != &tlb->local)
+		tlb_flush_rmap_batch(tlb->active, vma);
 	tlb->delayed_rmap = 0;
 }
 #endif
_

Patches currently in -mm which might be from torvalds@linux-foundation.org are

mm-mmu_gather-allow-more-than-one-batch-of-delayed-rmaps.patch

