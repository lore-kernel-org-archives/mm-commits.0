Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D93C433DB
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 05:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBD8122C9F
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 05:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbhAXFC6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 24 Jan 2021 00:02:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:47498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726192AbhAXFCt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 24 Jan 2021 00:02:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE88422D3E;
        Sun, 24 Jan 2021 05:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611464529;
        bh=5m6eKIrU3O/9S7JR8opysQYB7ve/fwDQzJXKsoXT4q4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IL5yFNEBgszUsIogAzsPzynt7ECC1kgFa5KcHXYVSHG5hhphlQoYblsx32WoNzTRd
         e5W2ry7E9W96q0LyZ2ctT1koCa3FA5mKinVNmFNK9WgCMUJ4H4JpwUvzNdJ+HdTGr4
         Pvdez8QPkYLOZdf9dxonNtRePqnftiWyowbfMUvA=
Date:   Sat, 23 Jan 2021 21:02:07 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreas@gaisler.com,
        davem@davemloft.net, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        paul@crapouillou.net, peterz@infradead.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, tsbogend@alpha.franken.de
Subject:  [patch 16/19] mips/mm/highmem: use set_pte() for
 kmap_local()
Message-ID: <20210124050207.kzNYUeyrW%akpm@linux-foundation.org>
In-Reply-To: <20210123210029.a7c704d0cab204683e41ad10@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
