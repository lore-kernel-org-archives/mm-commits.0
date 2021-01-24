Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E11BFC433E0
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 05:03:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE4B3227BF
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 05:03:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbhAXFDJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 24 Jan 2021 00:03:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:47570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726056AbhAXFCy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 24 Jan 2021 00:02:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A825322581;
        Sun, 24 Jan 2021 05:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611464533;
        bh=T4q9YEL/6jZaAbHkuu1euTC6Q7+X18nkKwi303F/SeE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Z681rynWkaf3DG+vP8Q2SJOjnDHKbPlFaioJao7gHTZTk4+XHYgBYsU0bRoesvRCf
         7ROu1upSz2C911AWmTGa/VngQ22gco0YbfoGd19AqpEwB1+WWU4+V2dpLp7sGNX49g
         5xTwKOkQpiNEejDR8z08i+oA26Qng9sDF3K2wxu0=
Date:   Sat, 23 Jan 2021 21:02:11 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreas@gaisler.com,
        davem@davemloft.net, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        paul@crapouillou.net, peterz@infradead.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, tsbogend@alpha.franken.de
Subject:  [patch 17/19] powerpc/mm/highmem: use __set_pte_at() for
 kmap_local()
Message-ID: <20210124050211.iTnzvLhNR%akpm@linux-foundation.org>
In-Reply-To: <20210123210029.a7c704d0cab204683e41ad10@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
