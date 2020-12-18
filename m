Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3917FC4361B
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 18:58:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0DB023B84
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 18:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725804AbgLRS6U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 13:58:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:60410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgLRS6U (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 13:58:20 -0500
Date:   Fri, 18 Dec 2020 10:57:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608317859;
        bh=Ma9b8v1qjDFPO9h+LNKzOZu/k9HXw3h0xcSL60+onPk=;
        h=From:To:Subject:From;
        b=vKSCLaLj6YWSWvA+dBadWvFGiQfmM0iV+4N06mU3KL4FHqZGMhRlyXKjJXaRn3KK+
         619Cl6RdtxndzH9MRqEQlhGeAKhkU8JtFs6R3qlsE14Dvw70yHl8wUotcYhuT1ozaL
         6bVHRm78ZQNFB2NTvsKHiyv7F8HnoeusCmDZKpgw=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, suresh.b.siddha@intel.com,
        sbsiddha@gmail.com, peterz@infradead.org, hughd@google.com,
        davem@davemloft.net, npiggin@gmail.com
Subject:  + mm-generalise-cow-smc-tlb-flushing-race-comment.patch
 added to -mm tree
Message-ID: <20201218185738.Si9qJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: generalise COW SMC TLB flushing race comment
has been added to the -mm tree.  Its filename is
     mm-generalise-cow-smc-tlb-flushing-race-comment.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-generalise-cow-smc-tlb-flushing-race-comment.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-generalise-cow-smc-tlb-flushing-race-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-generalise-cow-smc-tlb-flushing-race-comment.patch

