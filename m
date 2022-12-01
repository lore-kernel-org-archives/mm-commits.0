Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14DFFC4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbiLAAEh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:04:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbiLAADR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:03:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033398C6A2
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD1C0B81D80
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A2AC433B5;
        Thu,  1 Dec 2022 00:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852882;
        bh=lbryng/GZNOxfYE7p16dA291vqNjakMlyYqu7Y6vjao=;
        h=Date:To:From:Subject:From;
        b=2IAfpBoFmLThy8ulBja4Y/XS6fco9/YEoMjlR0/86sMLfarcxWYr1CXsenrOgKwU6
         Hyr/On/hzdzD7VWTzwy3Z5+wspm2QoT/5ecVQU+167+xvKbnXZPjmwHXdp0z5gGCxN
         vRcn3aG/UYqAUrzGMTXGjFgTtM6/8Vj7rvsUB768=
Date:   Wed, 30 Nov 2022 16:01:21 -0800
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        agordeev@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmu_gather-do-not-expose-delayed_rmap-flag.patch removed from -mm tree
Message-Id: <20221201000122.66A2AC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: mmu_gather: do not expose delayed_rmap flag
has been removed from the -mm tree.  Its filename was
     mm-mmu_gather-do-not-expose-delayed_rmap-flag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: mm: mmu_gather: do not expose delayed_rmap flag
Date: Wed, 16 Nov 2022 08:49:30 +0100

Flag delayed_rmap of 'struct mmu_gather' is rather a private member, but
it is still accessed directly.  Instead, let the TLB gather code access
the flag.

Link: https://lkml.kernel.org/r/Y3SWCu6NRaMQ5dbD@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c     |    3 +--
 mm/mmu_gather.c |    3 +++
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-mmu_gather-do-not-expose-delayed_rmap-flag
+++ a/mm/memory.c
@@ -1465,8 +1465,7 @@ again:
 	/* Do the actual TLB flush before dropping ptl */
 	if (force_flush) {
 		tlb_flush_mmu_tlbonly(tlb);
-		if (tlb->delayed_rmap)
-			tlb_flush_rmaps(tlb, vma);
+		tlb_flush_rmaps(tlb, vma);
 	}
 	pte_unmap_unlock(start_pte, ptl);
 
--- a/mm/mmu_gather.c~mm-mmu_gather-do-not-expose-delayed_rmap-flag
+++ a/mm/mmu_gather.c
@@ -61,6 +61,9 @@ void tlb_flush_rmaps(struct mmu_gather *
 {
 	struct mmu_gather_batch *batch;
 
+	if (!tlb->delayed_rmap)
+		return;
+
 	batch = tlb->active;
 	for (int i = 0; i < batch->nr; i++) {
 		struct encoded_page *enc = batch->encoded_pages[i];
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are


