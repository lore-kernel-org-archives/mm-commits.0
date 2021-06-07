Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6B19C47094
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 23:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8C4061182
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 23:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhFHABI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 20:01:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230209AbhFHABH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 20:01:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D79E6610D0;
        Mon,  7 Jun 2021 23:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623110344;
        bh=8Qqn08pe8NVBAJ/mUV1Zw4jF1s9dlCqlVVKWxuqFhIw=;
        h=Date:From:To:Subject:From;
        b=MHXm9UFyz9dFGSnqLhbzQzxL7WseDvEebzuFxVRPIlQFU/5Pp0l/pNl0BWVn++ivh
         M2EHWg4sLqxt5RKPvJevdY///f2iGd8LOiYWqsW+qSBkRuVqgpnDF9rjma0k6V07ya
         ZAXosb1aitNZMzMWT5DlKXpz1O8d6Q1as4LlHjpY=
Date:   Mon, 07 Jun 2021 16:59:03 -0700
From:   akpm@linux-foundation.org
To:     anton@ozlabs.org, benh@kernel.crashing.org, luto@kernel.org,
        mm-commits@vger.kernel.org, npiggin@gmail.com, paulus@ozlabs.org,
        rdunlap@infradead.org
Subject:  + powerpc-64s-enable-mmu_lazy_tlb_shootdown.patch added
 to -mm tree
Message-ID: <20210607235903.R90y9albj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/64s: enable MMU_LAZY_TLB_SHOOTDOWN
has been added to the -mm tree.  Its filename is
     powerpc-64s-enable-mmu_lazy_tlb_shootdown.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/powerpc-64s-enable-mmu_lazy_tlb_shootdown.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/powerpc-64s-enable-mmu_lazy_tlb_shootdown.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: powerpc/64s: enable MMU_LAZY_TLB_SHOOTDOWN

On a 16-socket 192-core POWER8 system, a context switching benchmark
with as many software threads as CPUs (so each switch will go in and
out of idle), upstream can achieve a rate of about 1 million context
switches per second. After this patch it goes up to 118 million.

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
@@ -252,6 +252,7 @@ config PPC
 	select IRQ_FORCED_THREADING
 	select MMU_GATHER_PAGE_SIZE
 	select MMU_GATHER_RCU_TABLE_FREE
+	select MMU_LAZY_TLB_SHOOTDOWN		if PPC_BOOK3S_64
 	select MODULES_USE_ELF_RELA
 	select NEED_DMA_MAP_STATE		if PPC64 || NOT_COHERENT_CACHE
 	select NEED_SG_DMA_LENGTH
_

Patches currently in -mm which might be from npiggin@gmail.com are

lazy-tlb-introduce-lazy-mm-refcount-helper-functions.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable.patch
lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option.patch
powerpc-64s-enable-mmu_lazy_tlb_shootdown.patch

