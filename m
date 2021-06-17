Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E06B9C48BE8
	for <mm-commits@archiver.kernel.org>; Thu, 17 Jun 2021 00:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6C58613E2
	for <mm-commits@archiver.kernel.org>; Thu, 17 Jun 2021 00:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbhFQBBc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Jun 2021 21:01:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231628AbhFQBBb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Jun 2021 21:01:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98926613E1;
        Thu, 17 Jun 2021 00:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623891564;
        bh=uzuxXmLtfqgQaQ/w7rwV8bOEXd9UNIwK7m4JYlOjTLM=;
        h=Date:From:To:Subject:From;
        b=vAfsDyndBqHufWEELinlQKQUE6Sz39yIsbsvwP/MFUF623fRE6iX8ZQm8mJ/WJHQl
         +t4WngMUKKBqBe20vmG4BUp1DMSKcwtoglBGBpdc8BjVZ95s3Wa1drxmFiOkNZjqMW
         7DSBXsMwltroEqhlMXp2AcwwRvJ6Iyr8Reg/Ppj0=
Date:   Wed, 16 Jun 2021 17:59:24 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        joel@joelfernandes.org, kaleshsingh@google.com,
        kirill@shutemov.name, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, npiggin@gmail.com
Subject:  [to-be-updated]
 powerpc-mm-enable-have_move_pmd-support.patch removed from -mm tree
Message-ID: <20210617005924.Qu3R0oY5G%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm: enable HAVE_MOVE_PMD support
has been removed from the -mm tree.  Its filename was
     powerpc-mm-enable-have_move_pmd-support.patch

This patch was dropped because an updated version will be merged

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


