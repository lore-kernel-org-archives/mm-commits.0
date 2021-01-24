Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7788C433E6
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 05:02:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9582C227BF
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 05:02:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbhAXFCy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 24 Jan 2021 00:02:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:47460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726237AbhAXFCr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 24 Jan 2021 00:02:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A363C227BF;
        Sun, 24 Jan 2021 05:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611464519;
        bh=2gawlxer+f9zbV45an/YuonChBVf1rIrb3jGZMkt1nI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=u3anqksuwCBtMV5ukpiVNvDof8lwcdhr67nV/cDLkmMmMNfCVVngolg7iCSAvm9zq
         a1S+CJe/bWAGqeIdvSSd3iRn70HycoGZN6fypstUSmIFQV1HVm1cGIKe6/tBo3GW5m
         f3Z7gIKKm1T+WRBURKTxQJlixd4W8/9XPtX0IQfU=
Date:   Sat, 23 Jan 2021 21:01:57 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreas@gaisler.com,
        davem@davemloft.net, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        paul@crapouillou.net, peterz@infradead.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, tsbogend@alpha.franken.de
Subject:  [patch 14/19] sparc/mm/highmem: flush cache and TLB
Message-ID: <20210124050157.TD2CcAZCR%akpm@linux-foundation.org>
In-Reply-To: <20210123210029.a7c704d0cab204683e41ad10@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Subject: sparc/mm/highmem: flush cache and TLB

Patch series "mm/highmem: Fix fallout from generic kmap_local conversions".

The kmap_local conversion wreckaged sparc, mips and powerpc as it missed
some of the details in the original implementation.


This patch (of 4):

The recent conversion to the generic kmap_local infrastructure failed to
assign the proper pre/post map/unmap flush operations for sparc.

Sparc requires cache flush before map/unmap and tlb flush afterwards.

Link: https://lkml.kernel.org/r/20210112170136.078559026@linutronix.de
Link: https://lkml.kernel.org/r/20210112170410.905976187@linutronix.de
Fixes: 3293efa97807 ("sparc/mm/highmem: Switch to generic kmap atomic")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Andreas Larsson <andreas@gaisler.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Cercueil <paul@crapouillou.net>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/highmem.h |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/arch/sparc/include/asm/highmem.h~sparc-mm-highmem-flush-cache-and-tlb
+++ a/arch/sparc/include/asm/highmem.h
@@ -50,10 +50,11 @@ extern pte_t *pkmap_page_table;
 
 #define flush_cache_kmaps()	flush_cache_all()
 
-/* FIXME: Use __flush_tlb_one(vaddr) instead of flush_cache_all() -- Anton */
-#define arch_kmap_local_post_map(vaddr, pteval)	flush_cache_all()
-#define arch_kmap_local_post_unmap(vaddr)	flush_cache_all()
-
+/* FIXME: Use __flush_*_one(vaddr) instead of flush_*_all() -- Anton */
+#define arch_kmap_local_pre_map(vaddr, pteval)	flush_cache_all()
+#define arch_kmap_local_pre_unmap(vaddr)	flush_cache_all()
+#define arch_kmap_local_post_map(vaddr, pteval)	flush_tlb_all()
+#define arch_kmap_local_post_unmap(vaddr)	flush_tlb_all()
 
 #endif /* __KERNEL__ */
 
_
