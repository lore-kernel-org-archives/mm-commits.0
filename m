Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 527ACC433DB
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 19:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05B932310B
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 19:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbhAST64 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jan 2021 14:58:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:52476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392074AbhAST6n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Jan 2021 14:58:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 522332310D;
        Tue, 19 Jan 2021 19:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611086283;
        bh=EEIigaKbVfbKiW7yaktnaSB90eroh+QKmed2ibibNy8=;
        h=Date:From:To:Subject:From;
        b=M5P8AhHlcSQONo0HZZzBMMWyjlTTUQ6SgMDnj+BIcVQ48boNTOFq/LtfGw+CvrgWb
         T2aKpjqES+nwdhRhmG6Tgals3oT6Fl5aek0NRwsjB88KIq/NWrP6O32CEpADLqb39o
         T0z7hFSN7o/Wq0Lx+9qeiiq6r82gMWkeybxJdw+c=
Date:   Tue, 19 Jan 2021 11:58:01 -0800
From:   akpm@linux-foundation.org
To:     andreas@gaisler.com, davem@davemloft.net,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        paul@crapouillou.net, peterz@infradead.org, tglx@linutronix.de,
        tsbogend@alpha.franken.de
Subject:  +
 powerpc-mm-highmem-use-__set_pte_at-for-kmap_local.patch added to -mm tree
Message-ID: <20210119195801.fLdoqLND8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm/highmem: use __set_pte_at() for kmap_local()
has been added to the -mm tree.  Its filename is
     powerpc-mm-highmem-use-__set_pte_at-for-kmap_local.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/powerpc-mm-highmem-use-__set_pte_at-for-kmap_local.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/powerpc-mm-highmem-use-__set_pte_at-for-kmap_local.patch

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

sparc-mm-highmem-flush-cache-and-tlb.patch
mm-highmem-prepare-for-overriding-set_pte_at.patch
mips-mm-highmem-use-set_pte-for-kmap_local.patch
powerpc-mm-highmem-use-__set_pte_at-for-kmap_local.patch

