Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5813CC7EE2D
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 22:13:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjBZWNt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Feb 2023 17:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjBZWNo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Feb 2023 17:13:44 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E583CCDDD
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 14:13:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 60341CE0AEF
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 22:13:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85994C433EF;
        Sun, 26 Feb 2023 22:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677449618;
        bh=Weui57j9fSiDmJ/n73XHr1CfB/sak79fHz2JTc8NspQ=;
        h=Date:To:From:Subject:From;
        b=2HjL3mGM0vfKwOgONupeK7zx5+dejcPJRweC+aQZcizZIZq7zmOUpG8MxYSaUC90P
         pXjtmlR24WFfT9YPWIl32dCpCqvbeK/6CDL+t1FDBcWidpTilQ69pKrXVQo5CPN8WX
         lyWZl52cyjCmTxNi7ZKcn2AjuN0iGjXRs6t5XkxI=
Date:   Sun, 26 Feb 2023 14:13:37 -0800
To:     mm-commits@vger.kernel.org, will@kernel.org,
        torvalds@linux-foundation.org, riel@redhat.com,
        peterz@infradead.org, nadav.amit@gmail.com, mpe@ellerman.id.au,
        luto@kernel.org, dave.hansen@linux.intel.com,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        npiggin@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-64s-enable-mmu_lazy_tlb_shootdown.patch added to mm-unstable branch
Message-Id: <20230226221338.85994C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/64s: enable MMU_LAZY_TLB_SHOOTDOWN
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-64s-enable-mmu_lazy_tlb_shootdown.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-64s-enable-mmu_lazy_tlb_shootdown.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: powerpc/64s: enable MMU_LAZY_TLB_SHOOTDOWN
Date: Fri, 3 Feb 2023 17:18:37 +1000

On a 16-socket 192-core POWER8 system, the context_switch1_threads
benchmark from will-it-scale (see earlier changelog), upstream can achieve
a rate of about 1 million context switches per second, due to contention
on the mm refcount.

64s meets the prerequisites for CONFIG_MMU_LAZY_TLB_SHOOTDOWN, so enable
the option.  This increases the above benchmark to 118 million context
switches per second.

This generates 314 additional IPI interrupts on a 144 CPU system doing a
kernel compile, which is in the noise in terms of kernel cycles.

Link: https://lkml.kernel.org/r/20230203071837.1136453-6-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff --git a/arch/powerpc/Kconfig~powerpc-64s-enable-mmu_lazy_tlb_shootdown b/arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~powerpc-64s-enable-mmu_lazy_tlb_shootdown
+++ b/arch/powerpc/Kconfig
@@ -266,6 +266,7 @@ config PPC
 	select MMU_GATHER_PAGE_SIZE
 	select MMU_GATHER_RCU_TABLE_FREE
 	select MMU_GATHER_MERGE_VMAS
+	select MMU_LAZY_TLB_SHOOTDOWN		if PPC_BOOK3S_64
 	select MODULES_USE_ELF_RELA
 	select NEED_DMA_MAP_STATE		if PPC64 || NOT_COHERENT_CACHE
 	select NEED_PER_CPU_EMBED_FIRST_CHUNK	if PPC64
_

Patches currently in -mm which might be from npiggin@gmail.com are

kthread-simplify-kthread_use_mm-refcounting.patch
lazy-tlb-introduce-lazy-tlb-mm-refcount-helper-functions.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable.patch
lazy-tlb-shoot-lazies-non-refcounting-lazy-tlb-mm-reference-handling-scheme.patch
powerpc-64s-enable-mmu_lazy_tlb_shootdown.patch

