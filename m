Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE0EAC433E0
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 19:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 960472310B
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 19:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729553AbhAST66 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jan 2021 14:58:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:52416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391446AbhAST6g (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Jan 2021 14:58:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A1A42310B;
        Tue, 19 Jan 2021 19:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611086275;
        bh=fbHVrpHyQB6RiQL2hxPX+nLiSdZBDc06rtC+8EaJUrE=;
        h=Date:From:To:Subject:From;
        b=Il0esIPj707o0hrO4BFDpQ+4xpNDvVfI9JuLljRlpVJ2ejw/xz6gU9PKQy9Q3sqLL
         ukqjmnWufzBi9bL2WpvcfUqbtkndtktw66B+fPQUxhYufny8kW9LmGHmoiV2Kvzywi
         6ZHbVNdJ9SHCq/YTjWh8kKiwTwX+aJS+pSRL1pFA=
Date:   Tue, 19 Jan 2021 11:57:54 -0800
From:   akpm@linux-foundation.org
To:     andreas@gaisler.com, davem@davemloft.net,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        paul@crapouillou.net, peterz@infradead.org, tglx@linutronix.de,
        tsbogend@alpha.franken.de
Subject:  + mm-highmem-prepare-for-overriding-set_pte_at.patch
 added to -mm tree
Message-ID: <20210119195754.bCAsLa8Kv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/highmem: prepare for overriding set_pte_at()
has been added to the -mm tree.  Its filename is
     mm-highmem-prepare-for-overriding-set_pte_at.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-highmem-prepare-for-overriding-set_pte_at.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-highmem-prepare-for-overriding-set_pte_at.patch

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
Subject: mm/highmem: prepare for overriding set_pte_at()

The generic kmap_local() map function uses set_pte_at(), but MIPS requires
set_pte() and PowerPC wants __set_pte_at().

Provide arch_kmap_local_set_pte() and default it to set_pte_at().

Link: https://lkml.kernel.org/r/20210112170411.056306194@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Cercueil <paul@crapouillou.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/highmem.c~mm-highmem-prepare-for-overriding-set_pte_at
+++ a/mm/highmem.c
@@ -473,6 +473,11 @@ static inline void *arch_kmap_local_high
 }
 #endif
 
+#ifndef arch_kmap_local_set_pte
+#define arch_kmap_local_set_pte(mm, vaddr, ptep, ptev)	\
+	set_pte_at(mm, vaddr, ptep, ptev)
+#endif
+
 /* Unmap a local mapping which was obtained by kmap_high_get() */
 static inline bool kmap_high_unmap_local(unsigned long vaddr)
 {
@@ -515,7 +520,7 @@ void *__kmap_local_pfn_prot(unsigned lon
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	BUG_ON(!pte_none(*(kmap_pte - idx)));
 	pteval = pfn_pte(pfn, prot);
-	set_pte_at(&init_mm, vaddr, kmap_pte - idx, pteval);
+	arch_kmap_local_set_pte(&init_mm, vaddr, kmap_pte - idx, pteval);
 	arch_kmap_local_post_map(vaddr, pteval);
 	current->kmap_ctrl.pteval[kmap_local_idx()] = pteval;
 	preempt_enable();
_

Patches currently in -mm which might be from tglx@linutronix.de are

sparc-mm-highmem-flush-cache-and-tlb.patch
mm-highmem-prepare-for-overriding-set_pte_at.patch
mips-mm-highmem-use-set_pte-for-kmap_local.patch
powerpc-mm-highmem-use-__set_pte_at-for-kmap_local.patch

