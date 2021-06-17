Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E03DC48BE8
	for <mm-commits@archiver.kernel.org>; Thu, 17 Jun 2021 00:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EDCD613BF
	for <mm-commits@archiver.kernel.org>; Thu, 17 Jun 2021 00:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbhFQA6X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Jun 2021 20:58:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231361AbhFQA6V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Jun 2021 20:58:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3226613CD;
        Thu, 17 Jun 2021 00:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623891374;
        bh=OTlQNSaL1zjEw+kDKLfNEax7YoR6S0zI+in5vbsi8eg=;
        h=Date:From:To:Subject:From;
        b=fLk1pFRYyscK8HpqWuA3GUnvVgI50rQRf2Eip3szvPRUftos/Nb8Ss2aXhJyAn+gu
         ITL/qtomptBwH/y8s6WzEIkY/WHWlbBRFAvW6owlKTmEsXIGlImwiVsVCaWrm5Wami
         +XMIR4LUf9ouK0TDKuK+sQMUcC61jR4gs+3JVHJs=
Date:   Wed, 16 Jun 2021 17:56:13 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        joel@joelfernandes.org, kaleshsingh@google.com,
        kirill@shutemov.name, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, npiggin@gmail.com
Subject:  + powerpc-mm-enable-have_move_pmd-support.patch added to
 -mm tree
Message-ID: <20210617005613.rLHPYNeAb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm: enable HAVE_MOVE_PMD support
has been added to the -mm tree.  Its filename is
     powerpc-mm-enable-have_move_pmd-support.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/powerpc-mm-enable-have_move_pmd-support.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/powerpc-mm-enable-have_move_pmd-support.patch

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
Subject: powerpc/mm: enable HAVE_MOVE_PMD support

mremap HAVE_MOVE_PMD/PUD optimization time comparison for 1GB region:
1GB mremap - Source PTE-aligned, Destination PTE-aligned
  mremap time:      2292772ns
1GB mremap - Source PMD-aligned, Destination PMD-aligned
  mremap time:      1158928ns
1GB mremap - Source PUD-aligned, Destination PUD-aligned
  mremap time:        63886ns

Link: https://lkml.kernel.org/r/20210616045735.374532-4-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/Kconfig.cputype |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/platforms/Kconfig.cputype~powerpc-mm-enable-have_move_pmd-support
+++ a/arch/powerpc/platforms/Kconfig.cputype
@@ -101,6 +101,8 @@ config PPC_BOOK3S_64
 	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
 	select ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_SUPPORTS_NUMA_BALANCING
+	select HAVE_MOVE_PMD
+	select HAVE_MOVE_PUD
 	select IRQ_WORK
 	select PPC_MM_SLICES
 	select PPC_HAVE_KUEP
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-mremap-allow-arch-runtime-override.patch
powerpc-book3s64-mm-update-flush_tlb_range-to-flush-page-walk-cache.patch
powerpc-mm-enable-have_move_pmd-support.patch

