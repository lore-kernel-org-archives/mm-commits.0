Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C45C433DB
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jan 2021 22:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 308CE207B7
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jan 2021 22:28:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732434AbhAYW2b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jan 2021 17:28:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:36008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732974AbhAYVhZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 25 Jan 2021 16:37:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EFFB229C4;
        Mon, 25 Jan 2021 21:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611610527;
        bh=l1/0X3waQWkZYI+Z5IoAkfAtAwTTOFaUbyv/FXdwgtA=;
        h=Date:From:To:Subject:From;
        b=blzbrSnjBueKZ3IgC2HCCbOX6+pq3z5RRADaMq+CTlV8cv/EBfEqNIA8P1qY/jlrf
         2yifCWTBWWuGCDbWDcmQfXaLTeWYsDb+3+AQg/wlr9Jj2x7oQeYBF+ddPhXIzoSGIb
         HKXjNM48+rLzJqK1uUMW1VY4fV+xlSv3oCGkdxug=
Date:   Mon, 25 Jan 2021 13:35:27 -0800
From:   akpm@linux-foundation.org
To:     andreas@gaisler.com, davem@davemloft.net,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        paul@crapouillou.net, peterz@infradead.org, tglx@linutronix.de,
        tsbogend@alpha.franken.de
Subject:  [merged] mips-mm-highmem-use-set_pte-for-kmap_local.patch
 removed from -mm tree
Message-ID: <20210125213527.c8xPNKChB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mips/mm/highmem: use set_pte() for kmap_local()
has been removed from the -mm tree.  Its filename was
     mips-mm-highmem-use-set_pte-for-kmap_local.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


