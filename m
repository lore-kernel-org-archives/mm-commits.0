Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15C68C433E6
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 19:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEDFC2310B
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 19:58:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729323AbhAST65 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jan 2021 14:58:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:52446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391931AbhAST6k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Jan 2021 14:58:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FC472310C;
        Tue, 19 Jan 2021 19:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611086279;
        bh=Fw7qp5vsfaSD2WFUwXIZrSl56VmCFFBnZahhs1j8YXg=;
        h=Date:From:To:Subject:From;
        b=jxMpww+YSdzhu+3mRXeO4OvxeC6xKIwegGiqR8k9Abk1y+SvIOa3hggOeyWqHcmkb
         OgKGBBA88WbDrBrYN8wsqZTgz9rY9RmxHgpx3UFS4u34GIt8jir/JDivJ7HVoUJdHq
         YVnb4Gh3FFCYuZAaTLPyUYxHl3A3T6efEWnI+Mpg=
Date:   Tue, 19 Jan 2021 11:57:57 -0800
From:   akpm@linux-foundation.org
To:     andreas@gaisler.com, davem@davemloft.net,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        paul@crapouillou.net, peterz@infradead.org, tglx@linutronix.de,
        tsbogend@alpha.franken.de
Subject:  + mips-mm-highmem-use-set_pte-for-kmap_local.patch added
 to -mm tree
Message-ID: <20210119195757.zBOOXlaa9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mips/mm/highmem: use set_pte() for kmap_local()
has been added to the -mm tree.  Its filename is
     mips-mm-highmem-use-set_pte-for-kmap_local.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mips-mm-highmem-use-set_pte-for-kmap_local.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mips-mm-highmem-use-set_pte-for-kmap_local.patch

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
Subject: mips/mm/highmem: use set_pte() for kmap_local()

set_pte_at() on MIPS invokes update_cache() which might recurse into
kmap_local().  Use set_pte() like the original MIPS highmem implementation
did.

Link: https://lkml.kernel.org/r/20210112170411.187513575@linutronix.de
Fixes: a4c33e83bca1 ("mips/mm/highmem: Switch to generic kmap atomic")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Paul Cercueil <paul@crapouillou.net>
Reported-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/highmem.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/mips/include/asm/highmem.h~mips-mm-highmem-use-set_pte-for-kmap_local
+++ a/arch/mips/include/asm/highmem.h
@@ -51,6 +51,7 @@ extern void kmap_flush_tlb(unsigned long
 
 #define flush_cache_kmaps()	BUG_ON(cpu_has_dc_aliases)
 
+#define arch_kmap_local_set_pte(mm, vaddr, ptep, ptev)	set_pte(ptep, ptev)
 #define arch_kmap_local_post_map(vaddr, pteval)	local_flush_tlb_one(vaddr)
 #define arch_kmap_local_post_unmap(vaddr)	local_flush_tlb_one(vaddr)
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

sparc-mm-highmem-flush-cache-and-tlb.patch
mm-highmem-prepare-for-overriding-set_pte_at.patch
mips-mm-highmem-use-set_pte-for-kmap_local.patch
powerpc-mm-highmem-use-__set_pte_at-for-kmap_local.patch

