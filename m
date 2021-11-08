Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBB9CC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  8 Nov 2021 18:47:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5974617E4
	for <mm-commits@archiver.kernel.org>; Mon,  8 Nov 2021 18:47:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236098AbhKHSuY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 13:50:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:47704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236104AbhKHSuY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 13:50:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3D2F617E4;
        Mon,  8 Nov 2021 18:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636397257;
        bh=BTVNy0pT5NyvR6cFHXpmqv9jWVJorFY8PkXVy8McLbU=;
        h=Date:From:To:Subject:From;
        b=Djufu2Tza3pSGu0p8MIX9Z6uwWyn/QH6DN+etLxSpUZ1+O+SeSZqxj5NwXiHw8E+Z
         65X+KohurKYHmd3H9uSVZqkBY6fgV9qdl5hOvXn/9IgKDYIfkF1GzG6CNEXg0NRCjL
         sMbXTO4RnKImOTiP5W64UjP/uxYgwd9FmlpbL6vY=
Date:   Mon, 08 Nov 2021 10:47:37 -0800
From:   akpm@linux-foundation.org
To:     anton@ozlabs.org, benh@kernel.crashing.org, luto@kernel.org,
        mm-commits@vger.kernel.org, npiggin@gmail.com, paulus@ozlabs.org,
        rdunlap@infradead.org
Subject:  [to-be-updated]
 powerpc-64s-enable-mmu_lazy_tlb_shootdown.patch removed from -mm tree
Message-ID: <20211108184737.N9f1enbmP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/64s: enable MMU_LAZY_TLB_SHOOTDOWN
has been removed from the -mm tree.  Its filename was
     powerpc-64s-enable-mmu_lazy_tlb_shootdown.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: powerpc/64s: enable MMU_LAZY_TLB_SHOOTDOWN

On a 16-socket 192-core POWER8 system, a context switching benchmark
with as many software threads as CPUs (so each switch will go in and
out of idle), upstream can achieve a rate of about 1 million context
switches per second. After this patch it goes up to 118 million.

No real datya for real world workloads unfortunately.  I think it's
always been a "known" cacheline, it just showed up badly on
will-it-scale tests recently when Anton was doing a sweep of low
hanging scalability issues on big systems.

We have some very big systems running certain in-memory databases that
get into very high contention conditions on mutexes that push context
switch rates right up and with idle times pretty high, which would get
a lot of parallel context switching between user and idle thread, we
might be getting a bit of this contention there.

It's not something at the top of profiles though.  And on
multi-threaded workloads like this, the normal refcounting of the user
mm still has fundmaental contention.  It's tricky to get the change
tested on these workloads (machine time is very limited and I can't
drive the software).

I suspect it could also show in things that do high net or disk IO
rates (enough to need a lot of cores), and do some user processing
steps along the way.  You'd potentially get a lot of idle switching.


This infrastructure could be beneficial to other architectures.  The
cacheline is going to bounce in the same situations on other archs, so
I would say yes.  Rik at one stage had some patches to try avoid it for
x86 some years ago, I don't know what happened to those.

The way powerpc has to maintain mm_cpumask for its TLB flushing makes
it relatively easy to do this shootdown, and we decided the additional
IPIs were less of a concern than the bouncing.  Others have different
concerns, but I tried to make it generic and add comments explaining
what other archs can do, or possibly different ways it might be
achieved.

Link: https://lkml.kernel.org/r/20210605014216.446867-5-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anton Blanchard <anton@ozlabs.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/Kconfig~powerpc-64s-enable-mmu_lazy_tlb_shootdown
+++ a/arch/powerpc/Kconfig
@@ -249,6 +249,7 @@ config PPC
 	select IRQ_FORCED_THREADING
 	select MMU_GATHER_PAGE_SIZE
 	select MMU_GATHER_RCU_TABLE_FREE
+	select MMU_LAZY_TLB_SHOOTDOWN		if PPC_BOOK3S_64
 	select MODULES_USE_ELF_RELA
 	select NEED_DMA_MAP_STATE		if PPC64 || NOT_COHERENT_CACHE
 	select NEED_SG_DMA_LENGTH
_

Patches currently in -mm which might be from npiggin@gmail.com are


