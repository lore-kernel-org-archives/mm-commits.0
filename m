Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E618C77B7A
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 19:15:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbjFGTPf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jun 2023 15:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbjFGTPf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jun 2023 15:15:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B9D8E
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 12:15:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D876863B4A
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 19:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0B2C433D2;
        Wed,  7 Jun 2023 19:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686165333;
        bh=G5bq+zrSHDbFWPtnlOik203u6heqpyH6bF+3IeRDeN8=;
        h=Date:To:From:Subject:From;
        b=f4jKn3l7BRjpvjaDCp9mr5VAfElYmyYl+bSEDhnnmk9+2juMaXlusKYhUnUJwlEIb
         3WEFBsT2dmuCRTK3Mi0cUnSJn+frO8EP8e20j+P52U/eGFsEypClFBadr+O1KN30bf
         o0p33beIyy6SDCgSOYo4+VTU+YwpZFCzme3BJW4c=
Date:   Wed, 07 Jun 2023 12:15:32 -0700
To:     mm-commits@vger.kernel.org, sachinp@linux.ibm.com,
        npiggin@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lazy-tlb-consolidate-lazy-tlb-mm-switching-fix.patch removed from -mm tree
Message-Id: <20230607191533.3B0B2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lazy tlb: consolidate lazy tlb mm switching fix
has been removed from the -mm tree.  Its filename was
     lazy-tlb-consolidate-lazy-tlb-mm-switching-fix.patch

This patch was dropped because it was folded into lazy-tlb-consolidate-lazy-tlb-mm-switching.patch

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: lazy tlb: consolidate lazy tlb mm switching fix
Date: Wed, 7 Jun 2023 10:56:22 +1000

Fix an upstream powerpc bug that was discovered with a WARN_ON added in
"lazy tlb: consolidate lazy tlb mm switching":

   Switching mm and tinkering with current->active_mm should be done with
    irqs disabled. There is a path where exit_lazy_flush_tlb can be called
    with irqs enabled:

        exit_lazy_flush_tlb
        flush_type_needed
        __flush_all_mm
        tlb_finish_mmu
        exit_mmap

    Which results in the switching being incorrectly with irqs enabled.

    Link: https://lore.kernel.org/linuxppc-dev/87a5xcgopc.fsf@mail.lhotse/T/#m105488939d0cd9f980978ed2fdeeb89bf731e673

I will send that fix upstream, which will end up conflicting with these.
The resolution will be to take akpm's side of the merge (with this patch).
Or drop the patch when it conflicts and I'll resend it rebased on the fix.

Link: https://lkml.kernel.org/r/20230607005622.583318-1-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Cc: Sachin Sant <sachinp@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/book3s64/radix_tlb.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/arch/powerpc/mm/book3s64/radix_tlb.c~lazy-tlb-consolidate-lazy-tlb-mm-switching-fix
+++ a/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -795,8 +795,16 @@ void exit_lazy_flush_tlb(struct mm_struc
 		goto out;
 
 	if (current->active_mm == mm) {
-		/* Is a kernel thread and is using mm as the lazy tlb */
+		unsigned long flags;
+
+		/*
+		 * It is a kernel thread and is using mm as the lazy tlb, so
+		 * switch it to init_mm. This is not always called from IPI
+		 * (e.g., flush_type_needed), so must disable irqs.
+		 */
+		local_irq_save(flags);
 		kthread_end_lazy_tlb_mm();
+		local_irq_restore(flags);
 	}
 
 	/*
_

Patches currently in -mm which might be from npiggin@gmail.com are

lazy-tlb-fix-hotplug-exit-race-with-mmu_lazy_tlb_shootdown.patch
lazy-tlb-consolidate-lazy-tlb-mm-switching.patch

