Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3419C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 16 Nov 2022 22:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239112AbiKPWqj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Nov 2022 17:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239119AbiKPWqR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Nov 2022 17:46:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25625C74C
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 14:46:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D81AAB81EAF
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 22:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79127C433C1;
        Wed, 16 Nov 2022 22:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668638760;
        bh=s/6YogSVK4jrXTSEY6YDleV//xoODveTVkQjuH1yOpo=;
        h=Date:To:From:Subject:From;
        b=GUG3+rR20u9DJemB8B3OMosR0nZp8AzXf26rDvYZ0nf4NlHOvmyl0zix4DiAlFIqo
         iPLm7ewtrrr8T0D7QtUpoG/jsk3b5ICoNMNQVd2TJkgdeBlIKbyZ/l/34GO9LpdDWe
         NiECFNAs0aN58NaoILlO7bE2JSthqyaoSMbYrHew=
Date:   Wed, 16 Nov 2022 14:45:59 -0800
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        agordeev@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmu_gather-do-not-expose-delayed_rmap-flag.patch added to mm-unstable branch
Message-Id: <20221116224600.79127C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mmu_gather: do not expose delayed_rmap flag
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmu_gather-do-not-expose-delayed_rmap-flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmu_gather-do-not-expose-delayed_rmap-flag.patch

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
@@ -60,6 +60,9 @@ void tlb_flush_rmaps(struct mmu_gather *
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

mm-mmu_gather-do-not-expose-delayed_rmap-flag.patch

