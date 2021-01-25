Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28146C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jan 2021 22:29:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE898207D0
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jan 2021 22:29:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732485AbhAYW2p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jan 2021 17:28:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:36010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732975AbhAYVhZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 25 Jan 2021 16:37:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C1A2229C5;
        Mon, 25 Jan 2021 21:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611610530;
        bh=RHnMu3LumuKKFduikoKel7Sa/ls1l9UH8ZWoxkg0NKM=;
        h=Date:From:To:Subject:From;
        b=oOZeN8/RJ70UCJdFRkBXwsRf4AWfHZr3sm8jGVgHRZc7DKm7vK8W5rRSfy8yCjK5m
         A7tKuc6MJk+454fYvDlbvtavo7fTBj+J36rL2zcII5zEbrR80NhQMt2N2BQ+RunTet
         vv917x1ahDUZ3KkHx0bkIjp077NYu/qlADd3m0FY=
Date:   Mon, 25 Jan 2021 13:35:30 -0800
From:   akpm@linux-foundation.org
To:     andreas@gaisler.com, davem@davemloft.net,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        paul@crapouillou.net, peterz@infradead.org, tglx@linutronix.de,
        tsbogend@alpha.franken.de
Subject:  [merged]
 powerpc-mm-highmem-use-__set_pte_at-for-kmap_local.patch removed from -mm
 tree
Message-ID: <20210125213530.GlUN7r9lI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm/highmem: use __set_pte_at() for kmap_local()
has been removed from the -mm tree.  Its filename was
     powerpc-mm-highmem-use-__set_pte_at-for-kmap_local.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thomas Gleixner <tglx@linutronix.de>
Subject: powerpc/mm/highmem: use __set_pte_at() for kmap_local()

The original PowerPC highmem mapping function used __set_pte_at() to
denote that the mapping is per CPU.  This got lost with the conversion to
the generic implementation.

Override the default map function.

Link: https://lkml.kernel.org/r/20210112170411.281464308@linutronix.de
Fixes: 47da42b27a56 ("powerpc/mm/highmem: Switch to generic kmap atomic")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Paul Cercueil <paul@crapouillou.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/highmem.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/include/asm/highmem.h~powerpc-mm-highmem-use-__set_pte_at-for-kmap_local
+++ a/arch/powerpc/include/asm/highmem.h
@@ -58,6 +58,8 @@ extern pte_t *pkmap_page_table;
 
 #define flush_cache_kmaps()	flush_cache_all()
 
+#define arch_kmap_local_set_pte(mm, vaddr, ptep, ptev)	\
+	__set_pte_at(mm, vaddr, ptep, ptev, 1)
 #define arch_kmap_local_post_map(vaddr, pteval)	\
 	local_flush_tlb_page(NULL, vaddr)
 #define arch_kmap_local_post_unmap(vaddr)	\
_

Patches currently in -mm which might be from tglx@linutronix.de are


