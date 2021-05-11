Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32437C433B4
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 22:34:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D621D6191E
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 22:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhEKWfO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 May 2021 18:35:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229996AbhEKWfN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 May 2021 18:35:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F185461928;
        Tue, 11 May 2021 22:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620772446;
        bh=5lmWIbCandueY07ESQSC/V5GUYf7deJe2S3IlURH8oc=;
        h=Date:From:To:Subject:From;
        b=OSKGL5dq+IxfKsmzaiHgb2wU/MN1/305bq8jQO+bzZwb6jSesMVbUvVV7SUE68Iwm
         bWz+7u20jQ8/dMqDjigbXdGacp/vFCh+W4KZ1AILBOUY1WEDMdKRgOk3Iys3WfuXmf
         kyLQZcpIgnv2+nETr/eE2EM30wk1Ar54EE4F0Fq8=
Date:   Tue, 11 May 2021 15:34:05 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        joel@joelfernandes.org, kaleshsingh@google.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com
Subject:  + powerpc-mm-enable-move-pmd-pud.patch added to -mm tree
Message-ID: <20210511223405.nEpEPlHi0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm: enable move pmd/pud
has been added to the -mm tree.  Its filename is
     powerpc-mm-enable-move-pmd-pud.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/powerpc-mm-enable-move-pmd-pud.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/powerpc-mm-enable-move-pmd-pud.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: powerpc/mm: enable move pmd/pud

mremap HAVE_MOVE_PMD/PUD optimization time comparison for 1GB region:
1GB mremap - Source PTE-aligned, Destination PTE-aligned
  mremap time:      1127034ns
1GB mremap - Source PMD-aligned, Destination PMD-aligned
  mremap time:       508817ns
1GB mremap - Source PUD-aligned, Destination PUD-aligned
  mremap time:        23046ns

Link: https://lkml.kernel.org/r/20210422054323.150993-10-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/Kconfig.cputype |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/platforms/Kconfig.cputype~powerpc-mm-enable-move-pmd-pud
+++ a/arch/powerpc/platforms/Kconfig.cputype
@@ -96,6 +96,8 @@ config PPC_BOOK3S_64
 	select PPC_FPU
 	select PPC_HAVE_PMU_SUPPORT
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
+	select HAVE_MOVE_PMD
+	select HAVE_MOVE_PUD
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_PMD_SPLIT_PTLOCK
 	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

selftest-mremap_test-update-the-test-to-handle-pagesize-other-than-4k.patch
selftest-mremap_test-avoid-crash-with-static-build.patch
mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries.patch
powerpc-mm-book3s64-fix-possible-build-error.patch
powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument.patch
mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush.patch
mm-mremap-move-tlb-flush-outside-page-table-lock.patch
mm-mremap-allow-arch-runtime-override.patch
powerpc-mm-enable-move-pmd-pud.patch

