Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AA14C77B60
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjC1XV1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbjC1XVM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966FA26BB
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25182619EF
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F02C433A0;
        Tue, 28 Mar 2023 23:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045670;
        bh=50vO727sssh3tDc5PW4gwyaxueGK8fPQqUXjgWZpxSM=;
        h=Date:To:From:Subject:From;
        b=q5DWqGb7FSO9N217gRwW8ZMxrhUyx5LCl+K19clA41Lax7GmEx0ZPZY+bFA2BmP96
         JDLZpQFHsl/yR4f3adK9OjTkZaiyyVG24iX34+HYnzgCkNZcMXE/e9Ax/1dzfA5AhU
         N2eviFLFifUwa+wyFtvrKTk0uCOmbcZeT1dzNqX4=
Date:   Tue, 28 Mar 2023 16:21:10 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        torvalds@linux-foundation.org, riel@redhat.com,
        peterz@infradead.org, nadav.amit@gmail.com, mpe@ellerman.id.au,
        luto@kernel.org, dave.hansen@linux.intel.com,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        npiggin@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-64s-enable-mmu_lazy_tlb_shootdown.patch removed from -mm tree
Message-Id: <20230328232110.78F02C433A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: powerpc/64s: enable MMU_LAZY_TLB_SHOOTDOWN
has been removed from the -mm tree.  Its filename was
     powerpc-64s-enable-mmu_lazy_tlb_shootdown.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 arch/powerpc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/Kconfig~powerpc-64s-enable-mmu_lazy_tlb_shootdown
+++ a/arch/powerpc/Kconfig
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


