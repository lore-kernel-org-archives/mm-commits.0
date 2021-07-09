Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B08F0C07E99
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:34:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93391613D3
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:34:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbhGIVg7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:36:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230317AbhGIVg6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 17:36:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A47A1613D0;
        Fri,  9 Jul 2021 21:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866454;
        bh=kxk4a+2EEdn1mEgG8uDlYe48QF6jo4cnXs3SaXegacE=;
        h=Date:From:To:Subject:From;
        b=i5bd79FUmOMuJwbSDf3gpsDm+NBFNhASzO/+WyTUxKoN8+evhMsLzqe1hLnP+QrSd
         Z22yn8Y5oyfC3Opa6S0qY0crhZJgtrZaKQzsCVReGibzQfHfBxc/EY9yRC1VrggFYj
         Xkogwu8vJTv73/kzrOZPTixwsDDqUq0I9no3LKzo=
Date:   Fri, 09 Jul 2021 14:34:13 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        hughd@google.com, joel@joelfernandes.org, kaleshsingh@google.com,
        kirill.shutemov@linux.intel.com, kirill@shutemov.name,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
        sfr@canb.auug.org.au
Subject:  [merged] powerpc-mm-enable-have_move_pmd-support.patch
 removed from -mm tree
Message-ID: <20210709213413.DMi4VkBoQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm: enable HAVE_MOVE_PMD support
has been removed from the -mm tree.  Its filename was
     powerpc-mm-enable-have_move_pmd-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Hugh Dickins <hughd@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/Kconfig.cputype |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/platforms/Kconfig.cputype~powerpc-mm-enable-have_move_pmd-support
+++ a/arch/powerpc/platforms/Kconfig.cputype
@@ -102,6 +102,8 @@ config PPC_BOOK3S_64
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


