Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F854C433E9
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 19:58:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 247BB2310B
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 19:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbhAST6y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jan 2021 14:58:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:52390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389698AbhAST6c (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Jan 2021 14:58:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7275123104;
        Tue, 19 Jan 2021 19:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611086272;
        bh=iB1lW5u72lh0c7YXTKzuAy8Yk5uKorHz0f0dnqittN8=;
        h=Date:From:To:Subject:From;
        b=me3TVgH6PPtwQOZAvXgM57zt4+6Iu5z3KBsOIIUtn4rRAEZu2xGrI+Q66oVZgh6Oh
         PKm6N3RQCNxrT+9mwsy6sN0l2+9VdK+0ZU5FBYp6ZX8RohBPomDSAHh43PjhCvcfK/
         GDIxZb0VxhQzLchsjT/F/kksbmEVuG6QuMRGfVS4=
Date:   Tue, 19 Jan 2021 11:57:50 -0800
From:   akpm@linux-foundation.org
To:     andreas@gaisler.com, davem@davemloft.net,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        paul@crapouillou.net, peterz@infradead.org, tglx@linutronix.de,
        tsbogend@alpha.franken.de
Subject:  + sparc-mm-highmem-flush-cache-and-tlb.patch added to -mm
 tree
Message-ID: <20210119195750.1lnyIZX0b%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sparc/mm/highmem: flush cache and TLB
has been added to the -mm tree.  Its filename is
     sparc-mm-highmem-flush-cache-and-tlb.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sparc-mm-highmem-flush-cache-and-tlb.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sparc-mm-highmem-flush-cache-and-tlb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from tglx@linutronix.de are

sparc-mm-highmem-flush-cache-and-tlb.patch
mm-highmem-prepare-for-overriding-set_pte_at.patch
mips-mm-highmem-use-set_pte-for-kmap_local.patch
powerpc-mm-highmem-use-__set_pte_at-for-kmap_local.patch

