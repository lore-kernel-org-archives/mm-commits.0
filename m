Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D4FDC433E9
	for <mm-commits@archiver.kernel.org>; Thu, 31 Dec 2020 18:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D97D02242A
	for <mm-commits@archiver.kernel.org>; Thu, 31 Dec 2020 18:24:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgLaSYH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Dec 2020 13:24:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:34116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbgLaSYG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 31 Dec 2020 13:24:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EB8222473;
        Thu, 31 Dec 2020 18:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609438980;
        bh=mvP/89jxy6/xt8bsTp7wuTv2DxK3OCH06tc8MFeG6jk=;
        h=Date:From:To:Subject:From;
        b=VsCtftb+G8ZiIjSrQ8p5f/m64Ij5Mtgfnh4yYoEvW/+nrhlcQE36g7rTm0qJymqC3
         VK2HPIbQUZe3SyX7jrSr4UGpsO7RMXHpxT30FJV+Ni9cXsVd7aW15UJvgITdxeqCh4
         8TCl6ra/812m0HlHVUcxOntjpm+c9PMCRXasLsO4=
Date:   Thu, 31 Dec 2020 10:23:00 -0800
From:   akpm@linux-foundation.org
To:     davem@davemloft.net, hughd@google.com, mm-commits@vger.kernel.org,
        npiggin@gmail.com, peterz@infradead.org, sbsiddha@gmail.com,
        suresh.b.siddha@intel.com, willy@infradead.org
Subject:  [merged]
 mm-generalise-cow-smc-tlb-flushing-race-comment.patch removed from -mm tree
Message-ID: <20201231182300.fWM7jgKOg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: generalise COW SMC TLB flushing race comment
has been removed from the -mm tree.  Its filename was
     mm-generalise-cow-smc-tlb-flushing-race-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: mm: generalise COW SMC TLB flushing race comment

I'm not sure if I'm completely missing something here, but AFAIKS the
reference to the mysterious "COW SMC race" confuses the issue.  The
original changelog and mailing list thread didn't help me either.

This SMC race is where the problem was detected, but isn't the general
problem bigger and more obvious: that the new PTE could be picked up at
any time by any TLB while entries for the old PTE exist in other TLBs
before the TLB flush takes effect?

The case where the iTLB and dTLB of a CPU are pointing at different pages
is an interesting one but follows from the general problem.

The other (minor) thing with the comment I think it makes it a bit clearer
to say what the old code was doing (i.e., it avoids the race as opposed to
what?).

References: 4ce072f1faf29 ("mm: fix a race condition under SMC + COW")
Link: https://lkml.kernel.org/r/20201215121119.351650-1-npiggin@gmail.com
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Siddha <sbsiddha@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/memory.c~mm-generalise-cow-smc-tlb-flushing-race-comment
+++ a/mm/memory.c
@@ -2892,11 +2892,13 @@ static vm_fault_t wp_page_copy(struct vm
 		entry = mk_pte(new_page, vma->vm_page_prot);
 		entry = pte_sw_mkyoung(entry);
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
+
 		/*
 		 * Clear the pte entry and flush it first, before updating the
-		 * pte with the new entry. This will avoid a race condition
-		 * seen in the presence of one thread doing SMC and another
-		 * thread doing COW.
+		 * pte with the new entry, to keep TLBs on different CPUs in
+		 * sync. This code used to set the new PTE then flush TLBs, but
+		 * that left a window where the new PTE could be loaded into
+		 * some TLBs while the old PTE remains in others.
 		 */
 		ptep_clear_flush_notify(vma, vmf->address, vmf->pte);
 		page_add_new_anon_rmap(new_page, vma, vmf->address, false);
_

Patches currently in -mm which might be from npiggin@gmail.com are


