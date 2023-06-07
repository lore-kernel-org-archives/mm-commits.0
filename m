Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD37C7EE2F
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 01:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240450AbjFGBDb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jun 2023 21:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240492AbjFGBDT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jun 2023 21:03:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4CA1FE8
        for <mm-commits@vger.kernel.org>; Tue,  6 Jun 2023 18:02:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1D276396D
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 01:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F235C433D2;
        Wed,  7 Jun 2023 01:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686099760;
        bh=SRdbs52V6iuCh9szowCrUb9mITCG9pLTOToOA0cZ4Gw=;
        h=Date:To:From:Subject:From;
        b=v5axwcGtFw47SNDegvqhJ/FpK9N0OVHzmv3wtzFD8WmdmbeQieaMpTeTI/SuBvhGy
         KucWONW6YEBqnfuA59fErcJ9MXSQ0DLMu6Vv7KrX5Eu5uc99YFv5TLU1hnGN6A1HnL
         1jvvBjaz85+HkLVE/9voof20LwyJGuhXKqRMESZ0=
Date:   Tue, 06 Jun 2023 18:02:39 -0700
To:     mm-commits@vger.kernel.org, sachinp@linux.ibm.com,
        npiggin@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lazy-tlb-consolidate-lazy-tlb-mm-switching-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20230607010240.2F235C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lazy tlb: consolidate lazy tlb mm switching fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lazy-tlb-consolidate-lazy-tlb-mm-switching-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lazy-tlb-consolidate-lazy-tlb-mm-switching-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
    Fixes: a665eec0a22e1 ("powerpc/64s/radix: Fix mm_cpumask trimming race vs k>

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
lazy-tlb-consolidate-lazy-tlb-mm-switching-fix.patch

