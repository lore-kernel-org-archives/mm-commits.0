Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5385FC4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:08:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbiLAAIn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:08:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbiLAAGk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:06:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5834764CB
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31A726176C
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7D3C433D6;
        Thu,  1 Dec 2022 00:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852961;
        bh=sEbhT0ksh9hoLPc2eGVer2Z/HnJjwLiv67pfLwxXQdg=;
        h=Date:To:From:Subject:From;
        b=MHHAKn1VVE9E5gT3KBJoPMLslthrV8KDXnXe9hLb01sVonVmoBVq9LcNuOjgzNeb8
         7AepPGogyzqsPO22L6bV9OqQJM+6K+vTlPo8AX3dFQukD8l3urrgGelvGq2AWxH2Sg
         Qa/2UdOYni2teUF9rChdfkwhQGxytVWr4XOeNQIQ=
Date:   Wed, 30 Nov 2022 16:02:40 -0800
To:     mm-commits@vger.kernel.org, will@kernel.org, peterz@infradead.org,
        elver@google.com, ebiggers@google.com, dvyukov@google.com,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] revert-kmsan-unpoison-tlb-in-arch_tlb_gather_mmu.patch removed from -mm tree
Message-Id: <20221201000241.5E7D3C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Revert "kmsan: unpoison @tlb in arch_tlb_gather_mmu()"
has been removed from the -mm tree.  Its filename was
     revert-kmsan-unpoison-tlb-in-arch_tlb_gather_mmu.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -299,15 +298,6 @@ void tlb_flush_mmu(struct mmu_gather *tl
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

lockdep-allow-instrumenting-lockdepc-with-kmsan.patch
kmsan-allow-using-__msan_instrument_asm_store-inside-runtime.patch

