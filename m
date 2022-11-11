Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E9CC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 11 Nov 2022 23:15:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbiKKXPH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Nov 2022 18:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiKKXPG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Nov 2022 18:15:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C9FCE04
        for <mm-commits@vger.kernel.org>; Fri, 11 Nov 2022 15:15:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99C9DB8280A
        for <mm-commits@vger.kernel.org>; Fri, 11 Nov 2022 23:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1238DC433C1;
        Fri, 11 Nov 2022 23:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668208502;
        bh=5+d9DobbxxjMtwkU2eJnYiLjHGrIFYmBTKiD5TSro1c=;
        h=Date:To:From:Subject:From;
        b=QaWw4leknSZJZhFB+oCB949tgpS7soWmuqvlelVb5IApcDHVI/6iWLyCLNmN4jjUH
         0ZUboH0i95RFmsbRq3Dw+CalzFNWWNNU+fEgV/PYkN8DHfDHA58z0fSbrHekokH74C
         uSHtJPLqtqw1K+KtTdPT7WSGR2afAzaLgrIpAZi4=
Date:   Fri, 11 Nov 2022 15:15:01 -0800
To:     mm-commits@vger.kernel.org, will@kernel.org, peterz@infradead.org,
        elver@google.com, ebiggers@google.com, dvyukov@google.com,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-kmsan-unpoison-tlb-in-arch_tlb_gather_mmu.patch added to mm-hotfixes-unstable branch
Message-Id: <20221111231502.1238DC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "kmsan: unpoison @tlb in arch_tlb_gather_mmu()"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     revert-kmsan-unpoison-tlb-in-arch_tlb_gather_mmu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-kmsan-unpoison-tlb-in-arch_tlb_gather_mmu.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Alexander Potapenko <glider@google.com>
Subject: Revert "kmsan: unpoison @tlb in arch_tlb_gather_mmu()"
Date: Thu, 10 Nov 2022 12:35:41 +0100

This reverts commit ac801e7e252c5588325e3c983c7d4167fc68c024.

The patch in question was picked to -mm from the KMSAN v6 patch series
(https://lore.kernel.org/linux-mm/20220905122452.2258262-1-glider@google.com/)
and sneaked into mainline despite its removal from the v7 series
(https://lore.kernel.org/linux-mm/20220915150417.722975-1-glider@google.com/)

Currently KMSAN does not warn about origin chains hitting the maximum
depth, so keeping @tlb poisoned won't result in any inconveniences.

Link: https://lkml.kernel.org/r/20221110113541.1844156-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_gather.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/mm/mmu_gather.c~revert-kmsan-unpoison-tlb-in-arch_tlb_gather_mmu
+++ a/mm/mmu_gather.c
@@ -1,7 +1,6 @@
 #include <linux/gfp.h>
 #include <linux/highmem.h>
 #include <linux/kernel.h>
-#include <linux/kmsan-checks.h>
 #include <linux/mmdebug.h>
 #include <linux/mm_types.h>
 #include <linux/mm_inline.h>
@@ -266,15 +265,6 @@ void tlb_flush_mmu(struct mmu_gather *tl
 static void __tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm,
 			     bool fullmm)
 {
-	/*
-	 * struct mmu_gather contains 7 1-bit fields packed into a 32-bit
-	 * unsigned int value. The remaining 25 bits remain uninitialized
-	 * and are never used, but KMSAN updates the origin for them in
-	 * zap_pXX_range() in mm/memory.c, thus creating very long origin
-	 * chains. This is technically correct, but consumes too much memory.
-	 * Unpoisoning the whole structure will prevent creating such chains.
-	 */
-	kmsan_unpoison_memory(tlb, sizeof(*tlb));
 	tlb->mm = mm;
 	tlb->fullmm = fullmm;
 
_

Patches currently in -mm which might be from glider@google.com are

revert-kmsan-unpoison-tlb-in-arch_tlb_gather_mmu.patch

